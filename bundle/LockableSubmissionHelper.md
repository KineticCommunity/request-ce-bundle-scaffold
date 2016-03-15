## Overview

The LockableSubmissionHelper is a utility for retrieving and managing "lockable" submissions.  
Submission locking is used to ensure that Submissions to which multiple people have access to (such 
as Approvals, Fulfillments, or Tickets) can only be worked on by one user at a time.

### Required Fields

In order to implement this functionality, it is assumed that lockable submission forms have a 
set of "system fields" (fields that do not display in the page content, often implemented as fields 
on a page that is after the confirmation page) that are used to manage visibility and lock state.
These fields are:

* `Assigned Group`
* `Assigned Individual`
* `Locked By`
* `Locked Until`

Setting the `Assigned Group` and `Assigned Individual` field values is outside the scope of this 
document, but these will often be initialized when Kinetic Task first creates the 
Approval/Fulfillment/Ticket submission or changed by updating the submission itself.

Setting the `Locked By` and `Locked Until` fields is automatically managed once locking is 
configured (discussed in futher detail below).


### Retrieving

In order to retrieve submissions to display in the bundle, such as retrieving a list of Approval
submissions that are assigned to me or a group that I am in, the LockableSubmissionHelper can be 
used like:

```jsp
<c:forEach var="lockable" items="${locking.search('Approval')}">
    ...
</c:forEach>
```

This will search for all "Approval" type submissions that have me as the `Assigned Individual` or 
that have one of my groups as the `Assigned Group`.  If group management is being done via User 
attributes, than the LockableSubmissionHelper needs to be initialized with what the name of the
group attribute is.

```jsp
<%
    request.setAttribute("locking", 
        new LockableSubmissionHelper(request)
            .setGroupAttribute("Groups"));
%>
```

Additionally, if assignment delegation is being managed by attributes, the LockableSubmissionHelper
can be initialized with the name of the delegation attribute.  If this is set, the search query will
search for all submissions that have me as the `Assigned Individual`, that have anyone specified in 
my list of delegation attributes as the `Assigned Individual`, or that have one of my groups as the
`Assigned Group`.

```jsp
<%
    request.setAttribute("locking", 
        new LockableSubmissionHelper(request)
            .setDelegationAttribute("Delegations"));
%>
```


## Files

[bundle/LockableSubmissionHelper.md](LockableSubmissionHelper.md)  
README file containing information on configuring and using the lockable submission helper.

[bundle/LockableSubmissionHelper.jspf](LockableSubmissionHelper.jspf)  
Helper file containing definitions for the LockableSubmissionHelper and LockableSubmission 
classes.  More information can be found in the 
[BridgedResourceHelper Summary](#bridgedresourcehelper-summary) and
[LockableSubmission Summary](#lockablesubmission-summary) sections. 

[js/locking.js](../js/locking.js)  
JavaScript file containing the code for the client side locking logic.

[pages/lock.jsp](../pages/lock.jsp)  
The callback page that is called by the client side locking logic when a lockable submission is 
opened.  This page attempts to update the lock on a submission and renders a message describing the
results of the call.  The contents can be modified to change the displayed messages or formatting.


## Configuration

* Copy the files listed above into your bundle
* Apply `Submission Modification` security policies to the lockable submission forms
* Include `js/locking.js` in the rendered page head content
* Initialize the LockableSubmissionHelper in your `bundle/initialization.jspf` file
* Initialize the client side locking logic by extending the `bundle.config.ready` event callback

### Apply Submission Modification security policies
In order to guarantee that submissions can only be modified by the individual with the lock, a
Submission Security Policy Definition can be created and applied to the form.  Below is an example
Security Policy Definition that would be applied to the `Submission Modification` security policy
for any form that leverages locking.

**Name:** Lock Holder  
**Type:** Submission  
**Message:** `The submission is locked by ${values('Locked By')}.`  
**Rule:**
```
identity('authenticated') 
&& (
  values('Locked By') == identity('username')
  || Date.parse(values('Locked Until')) < Date.now()
)
```


### Include locking.js in the rendered page head content
**layouts/layout.jsp**  
```jsp
<bundle:scriptpack>
    ...
    <bundle:script src="${bundle.location}/js/locking.js" />
    ...
</bundle:scriptpack>
```

### Initialize the LockableSubmissionHelper
**bundle/initialization.jspf**  
```jsp
<%@include file="LockableSubmissionHelper.jspf"%>
<%
    request.setAttribute("locking", 
        new LockableSubmissionHelper(request)
            .setDelegationAttribute("Delegations")
            .setGroupAttribute("Groups"));
%>
```

### Initialize the client side locking logic
More information about what options are available to the `bundle.ext.locking.observe` call can be
found in the [bundle.ext.locking.observe Summary](#bundleextlockingobserve-summary) section.

**form.jsp**  
```jsp
<bundle:layout page="layouts/form.jsp">
    <bundle:variable name="head">
        ...
        <%-- If the form has a "Locked By" field and is not being displayed in review mode. --%>
        <c:if test="${form.getField('Locked By') != null && param.review == null}">
            <script>
                // Set the bundle ready callback function (this is called automatically by the 
                // application after the kinetic form has been initialized/activated)
                bundle.config.ready = function(kineticForm) {
                    // Prepare locking
                    bundle.ext.locking.observe(kineticForm, {
                        lockDuration: 60,
                        timeoutInterval: 45
                    });
                };
            </script>
        </c:if>
    </bundle:variable>
```


## Example Usage
```jsp
<c:forEach var="lockable" items="${locking.search('Approval')}">
    <c:set var="submission" value="${lockable.submission}"/>
    <tr>
        <td>
            <c:if test="${lockable.isLocked()}">
                <i class="fa fa-lock" 
                   data-toggle="tooltip" 
                   data-placement="top" 
                   title="${text.escape(lockable.getLockedBy())}"></i>
            </c:if>
        </td>
        <td>
            <a href="${bundle.spaceLocation}/submissions/${submission.id}" 
               target="_blank">${text.escape(submission.label)}</a>
        </td>
        <td>${submission.createdAt}</td>
        <td>
            <c:forEach var="group" items="${lockable.assignedGroups}" varStatus="status">
                ${text.escape(group)}${not status.last ? ", " : "" }
            </c:forEach>
        </td>
        <td>
            <c:forEach var="individual" items="${lockable.assignedIndividuals}" varStatus="status">
                ${text.escape(individual)}${not status.last ? ", " : "" }
            </c:forEach>
        </td>
    </tr>
</c:forEach>
```

---

### bundle.ext.locking.observe Summary

```javascript
// Configuration Options
var config = {
    element: null, // Defaults to an empty div prepended to the kinetic form contents
    lockDuration: 60,
    lockInterval: 45,
    onBefore: function() {
        // Called before each locking "heartbeat" AJAX call
    },
    onFailure: function(request) {
        // Called when the locking "heartbeat" AJAX call fails
    },
    onSuccess: function(content) {
        // Called when the locking "heartbeat" AJAX call return successfully.  If this is not set,
        // the default behavior is to set the HTML content of the config.element (or an empty div
        // prepended to the kinetic form if config.element is not set).  If the config.onSuccess
        // callback is configured, the display of the response content will be delegated to it.
    }
};
// Initialize the "heartbeat" AJAX calls
bundle.ext.locking.observe(kineticForm, config);
```

---

#### BridgedResourceHelper Summary

`LockableSubmissionHelper(HttpServletRequest request)`  

`LockableSubmissionHelper setDelegationAttribute(String attributeName)`  
`LockableSubmissionHelper setGroupAttribute(String attributeName)`  

`LockableSubmission lock(String id, String until) throws Exception`  
`LockableSubmission retrieve(String id)`  
`List<LockableSubmission> search(String type)`  

---

#### LockableSubmission Summary

`LockableSubmission(Submission submission)`

`List<String> getAssignedGroups()`  
`List<String> getAssignedIndividuals()`  
`String getLockedBy()`  
`Date getLockedUntil()`  
`Submission getSubmission()`  
`boolean isExpired()`  
`boolean isLocked()`  
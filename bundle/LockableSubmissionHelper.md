## Overview

TODO


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
TODO

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
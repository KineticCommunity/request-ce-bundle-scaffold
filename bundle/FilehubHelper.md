## Overview

The FilehubHelper utility class is used to integrate bundle requests with Kinetic Filehub, allowing
users to display or download files stored in external systems.

Kinetic Filehub is a web application used to provide a consistent interface for storing and 
retrieving files.  It is installed with a set of Filehub Adapters, which provide the functionality
necessary to read and write to external systems.  Example adapters include an Amazon S3 adapter, Ars
adapter, Database adapter, and Local Filesystem adapter.  In addition to pre-installed adapters, it 
is possible to write custom adapters for interacting with other systems.

Kinetic Filehub delegates file access authorization by pre-sharing access keys with integrating 
applications.  An access key "secret" can be used to create a cryptographic signature of an HTTP 
request (which could be to download, upload, or delete a file).  When a request is made, Kinetic
Filehub validates the signature and that the request has not expired before proceeding.

Once configured, a bundle expose files in external filestores by building up links similar to:

```jsp
<a href="${bundle.kappLocation}?filestore=employee-images&path=${path}">${text.escape(filename)}</a>
```


## Files

[bundle/FilehubHelper.md](FilehubHelper.md)  
README file containing information on configuring and using the filehub helper.

[bundle/FilehubHelper.jspf](FilehubHelper.jspf)  
Helper file containing definitions for the FilehubHelper.  More information can be found in the 
[FilehubHelper Summary](#filehubhelper-summary) section.


## Configuration

* Copy the files listed above into your bundle
* Prepare logic used to authorize requests
* Modify the router.jspf file to handle filestore requests

### Prepare helpers used to authorize requests

### Modify the router.jspf file to handle filestore requests
In order to configure the FilehubHelper to handle 

```jsp
<%-- FILEHUB ROUTING --%>
<%@include file="FilehubHelper.jspf"%>
<%
    // Initialize the filehub helper and configure filestores
    FilehubHelper filehubHelper = new FilehubHelper("https://filehub.acme.com/kinetic-filehub")
        .addFilestore("knowledge-management", "KEY", "SECRET");
    // If there is a request for the specified filestore
    if ("knowledge-management".equals(request.getParameter("filestore"))) {
        // If access is allowed
        if (knowledgeManagementHelper.canAccess(request.getParameter("path")) {
            // Build the redirection URL
            String url = filehubHelper.url("knowledge-management", request.getParameter("path"));
            // Configure the response to redirect
            response.setStatus(HttpServletResponse.SC_MOVED_TEMPORARILY);
            response.setHeader("Location", url);
        }
        // If access is not allowed
        else {
            // Simulate a 404 not found response
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            request.setAttribute("javax.servlet.error.message", path);
            request.getRequestDispatcher("/WEB-INF/pages/404.jsp").include(request, response);
        }
        // Return so that no further JSP processing occurs
        return;
    } 
%>
```

---

#### FilehubHelper Summary

`FilehubHelper(String baseUrl)`  

`FilehubHelper addFilestore(String filestoreSlug, String key, String secret)`

`String url(String filestoreSlug, String path)`
`String url(String filestoreSlug, String path, String filenameOverride)`
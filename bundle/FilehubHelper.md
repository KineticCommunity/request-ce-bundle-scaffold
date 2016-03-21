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
<a href="${bundle.kappLocation}?filestore=knowledge-management&path=${path}"
    >${text.escape(filename)}</a>
```

or 

```jsp
<a href="${bundle.kappLocation}?filestore=db&table=employee_images&record=653325&column=image"
    >${text.escape(filename)}</a>
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

Each integration will have different logic for how to control who has access to what files.  Some 
filestores may only contain files that are considered "public", in which case this step can be 
skipped.  It is more common that some sort of access control needs to be applied.  In this case, it
is often helpful to create a new helper (or leverage an existing helper) to determine this.

Here is a very simple example helper used in the proceeding examples:

```jsp
<%!
    public static class KnowledgeManagementHelper {
        private Identity identity;
        public KnowledgeManagementHelper(HttpServletRequest request) {
            this.identity = (Identity)request.getAttribute("identity");
        }
        public boolean canAccess(String path) {
            return Text.startsWith(path, identity.getAttributeValue("Department"));
        }
    }
%>
```

### Modify the router.jspf file to handle filestore requests

In order to leverage the FilehubHelper in a bundle, some additional routing needs to be added to the
`bundle/router.jsp` file.  Each bundle may have a different way to obtain the filehub url and 
filestore slugs/keys/secrets, and each filestore will have a different way of determining access 
authorization, but the added code should look something like:

```jsp
<%-- FILEHUB ROUTING --%>
<%@include file="FilehubHelper.jspf"%>
<%
    // If this request is scoped to a kapp
    if (kapp != null) {
        // Initialize the filehub helper and configure filestores
        String filehubUrl = kapp.getAttributeValue("Filehub Url");
        String slug = kapp.getAttributeValue("Knowledge Management Filestore Slug");
        String key = kapp.getAttributeValue("Knowledge Management Filestore Key");
        String secret = kapp.getAttributeValue("Knowledge Management Filestore Secret");
        FilehubHelper filehubHelper = new FilehubHelper(filehubUrl)
            .addFilestore(slug, key, secret);
        // If there is a request for the specified filestore
        if (slug.equals(request.getParameter("filestore"))) {
            // If access is allowed
            if (knowledgeManagementHelper.canAccess(request.getParameter("path"))) {
                // Build the redirection URL
                String url = filehubHelper.url(slug, request.getParameter("path"));
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
    }
%>
```

---

#### FilehubHelper Summary

`FilehubHelper(String baseUrl)`  

`FilehubHelper addFilestore(String filestoreSlug, String key, String secret)`  

`String url(String filestoreSlug, String path)`  
`String url(String filestoreSlug, String path, String filenameOverride)`  
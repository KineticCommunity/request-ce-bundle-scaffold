<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="../bundle/initialization.jspf" %>

<%-- font-awesome.css is incompatible with the bundle:stylepack due to font files. --%>
<link href="${bundle.location}/libraries/font-awesome/css/font-awesome.css" rel="stylesheet" type="text/css"/>

<bundle:stylepack>
    <%-- CSS files included in the stylepack will be combined and minified into one file --%>
    <bundle:style src="${bundle.location}/libraries/bootstrap/css/bootstrap.css" />
    <bundle:style src="${bundle.location}/libraries/datatables/datatables.css"/>
    <bundle:style src="${bundle.location}/libraries/notifie/jquery.notifie.css" />
</bundle:stylepack>

<%-- moment-with-locales.js is incompatible with the bundle:scriptpack minification process. --%>
<bundle:scriptpack minify="false">
    <bundle:script src="${bundle.location}/libraries/moment/moment-with-locales.min.js"/>
</bundle:scriptpack>

<bundle:scriptpack>
    <%-- JS files included in the scriptpack will be combined and minified into one file --%>
    <bundle:script src="${bundle.location}/libraries/jquery/jquery.js" />
    <bundle:script src="${bundle.location}/libraries/underscore/underscore.js" />
    <bundle:script src="${bundle.location}/libraries/bootstrap/js/bootstrap.js" />
    <bundle:script src="${bundle.location}/libraries/moment/moment-timezone.js" />
    <bundle:script src="${bundle.location}/libraries/datatables/datatables.js"/>
    <bundle:script src="${bundle.location}/libraries/typeahead/typeahead.js" />
    <bundle:script src="${bundle.location}/libraries/notifie/jquery.notifie.js" />
</bundle:scriptpack>
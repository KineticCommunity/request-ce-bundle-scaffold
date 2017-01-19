<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="bundle/initialization.jspf" %>
<%@include file="bundle/router.jspf" %>
<c:set var="bundleCategories" value="${CategoryHelper.getCategories(kapp)}"/>

<bundle:layout page="${bundle.path}/layouts/layout.jsp">
    <bundle:variable name="head">
        <bundle:variable name="pageTitle">${text.escape(i18n.translate(kapp.name))}</bundle:variable>
    </bundle:variable>
    
    <h3>${text.escape(i18n.translate(kapp.name))}</h3>
    <div class="row">
        <div class="col-md-12">
            
        </div>
    </div>
</bundle:layout>
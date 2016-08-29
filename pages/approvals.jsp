<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="../bundle/initialization.jspf" %>

<bundle:layout page="${bundle.path}/layouts/layout.jsp">
    <bundle:variable name="head">
        <title>${text.escape(i18n.translate(kapp.name))}&nbsp;${i18n.translate('Approvals')}</title>
    </bundle:variable>
    
    <h3>${i18n.translate('My Approvals')}</h3>
    <c:set scope="request" var="submissionsList" value="${SubmissionHelper.retrieveRecentSubmissions('Approval')}"/>
    <c:import url="${bundle.path}/partials/submissions.jsp" charEncoding="UTF-8"/>
</bundle:layout>
<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="../bundle/initialization.jspf" %>

<bundle:layout page="${bundle.path}/layouts/layout.jsp">
    <c:set var="params" value="${Resources.map()}"/>
    <c:set target="${params}" property="User" value="Demo"/>
    <c:set var="record" value="${Resources.retrieve('User', params)}"/>
    <div>
        ${text.escape(record.get('Email'))}
    </div>
</bundle:layout>
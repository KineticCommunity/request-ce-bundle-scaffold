<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="../bundle/initialization.jspf" %>
<bundle:layout page="${bundle.path}/layouts/layout.jsp">
    <c:set var="params" value="${Resources.map()}"/>
    <c:set target="${params}" property="User" value="${identity.username}"/>
    <c:set var="records" value="${Resources.search('Users', params)}"/>
    <ul>
        <c:forEach var="record" items="${records}">
            <li>${text.escape(record.get('Email'))}</li>
        </c:forEach>
    </ul>
</bundle:layout>
<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="../bundle/initialization.jspf" %>

<bundle:layout page="${bundle.path}/layouts/layout.jsp">
    <div>
        <ul>
            <c:set var="params" value="${Resources.map()}"/>
            <c:set var="params" property="username" value="${identity.username}"/>
            <c:forEach var="record" items="${Resources.search('People', params)}">
                <li>${text.escape(record.get('First Name'))}</li>
            </c:forEach>
        </ul>
    </div>
</bundle:layout>
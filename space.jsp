<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="bundle/initialization.jspf" %>
<%@include file="bundle/router.jspf" %>
<bundle:layout page="layouts/layout.jsp">
    <bundle:variable name="head">
        <title>${text.escape(i18n.translate(space.name))}&nbsp;${i18n.translate('Kapps')}</title>
    </bundle:variable>

    <h1>
        ${text.escape(i18n.translate(space.name))}&nbsp;${i18n.translate('Kapps')}
    </h1>
    <ul>
        <c:forEach var="kapp" items="${space.kapps}">
            <li><strong>${text.escape(i18n.translate(kapp.name))}:</strong> 
                <a href="${bundle.spaceLocation}/${kapp.slug}">${i18n.translate('user')}</a>
                <c:if test="${!(identity.anonymous)}">
                    <span>|</span>
                    <a href="${bundle.spaceLocation}/app/#/${kapp.slug}/activity/overview">${i18n.translate('manage')}</a>
                </c:if>
            </li>
        </c:forEach>
    </ul>
</bundle:layout>

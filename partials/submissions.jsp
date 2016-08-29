<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="../bundle/initialization.jspf" %>
<table class="table table-striped table-hover">
    <thead>
        <tr>
            <th class="date">${i18n.translate('Created At')}</th>
            <th>${i18n.translate('Form')}</th>
            <th class="nosort">${i18n.translate('Submission')}</th>
            <th>${i18n.translate('Created By')}</th>
            <th>${i18n.translate('State')}</th>

        </tr>
    </thead>
    <tbody>
        <c:forEach items="${submissionsList}" var="submission">
            <tr>
                <td>${submission.createdAt}</td>
                <td>${text.escape(i18n.translate(submission.form, submission.form.name))}</td>
                <td>
                  <c:choose>
                    <c:when test="${submission.coreState eq 'Draft'}">
                      <a href="${bundle.spaceLocation}/submissions/${submission.id}">${text.escape(i18n.translate(submission.form, submission.label))}</a>
                    </c:when>
                    <c:otherwise>
                      <a href="${bundle.kappLocation}?page=submission&type=${param.page}&id=${submission.id}">${text.escape(i18n.translate(submission.form, submission.label))}</a>
                    </c:otherwise>
                  </c:choose>
                </td>
                <td>${text.escape(submission.createdBy)}</td>
                <td>${i18n.translate(submission.form, submission.coreState)}</td>
            </tr>
        </c:forEach>
    </tbody>
</table>

<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="../bundle/initialization.jspf" %>
<c:catch var="submissionException">
    <c:set var="submission" value="${Submissions.retrieve(param.id)}" scope="page"/>
</c:catch>
<bundle:layout page="${bundle.path}/layouts/layout.jsp">
    <c:choose>
        <c:when test="${submissionException != null}">
            ${i18n.translate('Error')}
        </c:when>
        <c:otherwise>
            <bundle:variable name="head">
                <bundle:variable name="pageTitle">${text.escape(i18n.translate(submission.form, submission.form.name))}</bundle:variable>
            </bundle:variable>
            
            <h3>${i18n.translate('Submission Details')}</h3>
            <section class="timeline">
                <div class="row">
                    <div class="col-md-4 col-xs-12 ">
                        <div class="submission-meta">
                            <h2>${i18n.translate(submission.form, submission.form.name)}</h2>
                            <dl>
                                <dt>${i18n.translate('Label')}:</dt>
                                <dd>${i18n.translate(submission.label)}</dd>
                                <dt>${i18n.translate('Request Date')}:</dt>
                                <dd>${submission.submittedAt}</dd>
                                <dt>${i18n.translate('Status')}:</dt>
                                <dd>${i18n.translate(submission.coreState)}</dd>
                            </dl>
                            <p>${i18n.translate(submission.form.description)}</p>
                        </div>
                    </div>
                    <div class="col-md-8 col-xs-12 ">
                        <div class="timeline-block">
                            <c:catch var="taskRunException">
                                <c:forEach var="run" items="${TaskRuns.find(submission)}">
                                <ul>
                                    <c:forEach var="task" items="${run.tasks}">
                                        <li class="timeline-status">
                                            <div class="timeline-status-content">
                                                <h4>${text.escape(i18n.translate(task.name))}</h4>
                                                <h5>${text.escape(task.createdAt)}</h5>
                                                <ul>
                                                    <c:forEach var="entry" items="${task.messages}">
                                                        <li>${text.escape(i18n.translate(entry.message))}</li>
                                                    </c:forEach>
                                                </ul>
                                            </div>
                                        </li>
                                    </c:forEach>
                                </ul>
                                </c:forEach>
                            </c:catch>
                            <c:if test="${taskRunException != null}">
                                <ul>
                                    <li class="timeline-status">
                                        <div class="timeline-status-content">
                                        ${i18n.translate('There was a problem retrieving post processing task information for this submission.')}
                                        <hr>
                                        ${fn:escapeXml(i18n.translate(taskRunException.message))}
                                        </div>
                                    </li>
                                </ul>
                            </c:if>
                        </div>
                    </div>
                </div>
            </section>
        </c:otherwise>
    </c:choose>
</bundle:layout>

<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="../bundle/initialization.jspf" %>
<bundle:layout page="${bundle.path}/layouts/layout.jsp">
    <bundle:variable name="head">
        <title>${text.escape(kapp.title)} Approvals</title>
        <script>
            $(function () {
                $('[data-toggle="tooltip"]').tooltip();
            });
        </script>
    </bundle:variable>
    <div class="container">
        <c:choose>
            <c:when test="${identity.authenticated}">
                <h2>Approvals</h2>
                    <table class="table table-striped table-hover">
                        <thead>
                            <tr>
                                <th></th>
                                <th>Approval</th>
                                <th>Created At</th>
                                <th>Assigned Groups</th>
                                <th>Assigned Individuals</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="lockable" items="${locking.search('Approval')}">
                                <c:set var="submission" value="${lockable.submission}"/>
                                <tr>
                                    <td>
                                        <c:if test="${lockable.isLocked()}">
                                            <i class="fa fa-lock" 
                                               data-toggle="tooltip" 
                                               data-placement="top" 
                                               title="${text.escape(lockable.getLockedBy())}"></i>
                                        </c:if>
                                    </td>
                                    <td>
                                        <a href="${bundle.spaceLocation}/submissions/${submission.id}" 
                                           target="_blank">${text.escape(submission.label)}</a>
                                    </td>
                                    <td>${submission.createdAt}</td>
                                    <td>
                                        <c:forEach var="group" items="${lockable.assignedGroups}" varStatus="status">
                                            ${text.escape(group)}${not status.last ? ", " : "" }
                                        </c:forEach>
                                    </td>
                                    <td>
                                        <c:forEach var="individual" items="${lockable.assignedIndividuals}" varStatus="status">
                                            ${text.escape(individual)}${not status.last ? ", " : "" }
                                        </c:forEach>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
            </c:when>
            <c:otherwise>
                Unauthenticated!
            </c:otherwise>
        </c:choose>
    </div>
</bundle:layout>
<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="../bundle/initialization.jspf" %>
<bundle:layout page="${bundle.path}/layouts/layout.jsp">
    <bundle:variable name="head">
        <title>${text.escape(kapp.title)} Approvals</title>
    </bundle:variable>
    <div class="container">
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
                <tr>
                    <td><i class="fa fa-lock"></i></td>
                    <td>21fad731-e708-11e5-8e32-551734ea4459</td>
                    <td>Thu Mar 10 15:36:22 CST 2016</td>
                    <td>HR</td>
                    <td></td>
                </tr>
                <tr>
                    <td></td>
                    <td>21fad731-e708-11e5-8e32-551734ea4459</td>
                    <td>Thu Mar 10 15:36:22 CST 2016</td>
                    <td>IT</td>
                    <td>ben.christenson</td>
                </tr>
                <tr>
                    <td><i class="fa fa-lock"></i></td>
                    <td>21fad731-e708-11e5-8e32-551734ea4459</td>
                    <td>Thu Mar 10 15:36:22 CST 2016</td>
                    <td>IT</td>
                    <td></td>
                </tr>
                <c:forEach var="lockable" items="${approvals.retrieve()}">
                    <c:set var="submission" value="${lockable.submission}"/>
                    <tr>
                        <td></td>
                        <td><a href="${bundle.spaceLocation}/submissions/${submission.id}">${text.escape(submission.label)}</a></td>
                        <td>${submission.createdAt}</td>
                        <td>${submission.getValue('Assigned Group')}</td>
                        <td>${submission.getValue('Assigned Individual')}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</bundle:layout>
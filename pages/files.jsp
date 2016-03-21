<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="../bundle/initialization.jspf" %>
<bundle:layout page="${bundle.path}/layouts/layout.jsp">
    <c:set var="form" value="KTEST_FilehubArsAdapter_AttachmentForm"/>
    <c:set var="entry" value="000000000000121"/>
    <c:set var="field" value="Attachment 1"/>
    <div class="container">
        <a href="${bundle.kappLocation}?filestore=ars&form=${form}&entry=${entry}&field=${field}&file=newfile">newfile</a>
    </div>
</bundle:layout>
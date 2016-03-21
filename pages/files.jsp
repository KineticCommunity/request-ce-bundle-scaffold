<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="../bundle/initialization.jspf" %>
<bundle:layout page="${bundle.path}/layouts/layout.jsp">
    <c:set var="form" value="KTEST_FilehubArsAdapter_AttachmentForm"/>
    <c:set var="entry" value="000000000000134"/>
    <c:set var="field" value="Attachment 2"/>
    <div class="container">
        <a href="${bundle.kappLocation}?filestore=ars&form=${form}&entry=${entry}&field=${field}">newfile</a>
    </div>
        
    <div class="container">
        <a href="${bundle.kappLocation}?filestore=ars&form=${form}&entry=${entry}&field=${field}&filename=image.png">newfile</a>
    </div>
        
    <div class="container">
        <a href="${bundle.kappLocation}?filestore=ars&form=${form}&entry=${entry}&field=${field}&filename=image2.png">newfile</a>
    </div>
</bundle:layout>
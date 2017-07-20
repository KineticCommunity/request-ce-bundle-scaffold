<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="../bundle/initialization.jspf" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1.0, maximum-scale=1.0">
        <link rel="apple-touch-icon" sizes="76x76" href="${bundle.location}/images/apple-touch-icon.png">
        <link rel="icon" type="image/png" href="${bundle.location}/images/android-chrome-96x96.png" sizes="96x96">
        <link rel="icon" type="image/png" href="${bundle.location}/images/favicon-16x16.png" sizes="16x16">
        <link rel="icon" type="image/png" href="${bundle.location}/images/favicon-32x32.png" sizes="32x32">
        <link rel="icon" type="image/png" href="${bundle.location}/images/favicon-96x96.png" sizes="96x96">
        <link rel="shortcut icon" href="${bundle.location}/images/favicon.ico" type="image/x-icon"/>
        <app:headContent/>
        
        <%-- Include translation packs --%>
        <c:if test="${i18n.hasTranslationJs()}">
            <script src="${i18n.scriptPath('shared')}"></script>
            <script src="${i18n.scriptPath('bundle')}"></script>
            <c:if test="${form != null}">
                <script src="${i18n.scriptPath(form)}"></script>
            </c:if>
        </c:if>
        
        <%-- Include libraries, css, and js --%>
        <c:import url="${bundle.path}/partials/libraries.jsp" charEncoding="UTF-8"/>
        <bundle:stylepack>
            <bundle:style src="${bundle.location}/css/master.css" />
        </bundle:stylepack>
        <bundle:scriptpack>
            <bundle:script src="${bundle.location}/js/catalog.js" />
            <bundle:script src="${bundle.location}/js/locking.js" />
            <bundle:script src="${bundle.location}/js/review.js" />
        </bundle:scriptpack>
        
        <c:set var="pageTitle"><bundle:yield name="pageTitle"/></c:set>
        <title>
           ${text.join([not empty pageTitle ? pageTitle : text.defaultIfBlank(form.name, kapp.name), BundleHelper.companyName], ' - ')}
           ${space.hasAttribute('Page Title Brand') ? text.join([' | ', space.getAttributeValue('Page Title Brand')]) : ''}
        </title>

        <bundle:yield name="head"/>
    </head>
    <body>
        <div class="view-port">
            <c:import url="${bundle.path}/partials/header.jsp" charEncoding="UTF-8"/>
            <div class="container">
                <bundle:yield/>
            </div>
            <c:import url="${bundle.path}/partials/footer.jsp" charEncoding="UTF-8"/>
        </div>
    </body>
</html>
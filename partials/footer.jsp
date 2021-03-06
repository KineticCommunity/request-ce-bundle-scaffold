<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="../bundle/initialization.jspf" %>
<footer class="footer">
    <div class="container">
        <div class="col-xs-6">
            <img src='${bundle.location}/images/ProductName-Request.png' class='desaturate' height="40"/>
        </div>
        <div class="build col-xs-6">
            <dl class="dl-horizontal">
                <dt>Build Date:</dt>
                <dd>${time.format(time.parse(buildDate, 'yyyy-MM-dd HH:mm:ss Z', zoneId, locale), 'MMMM dd, yyyy K:mma z', zoneId, locale)}</dd>
                <dt>Version:</dt>
                <dd>${buildVersion}</dd>
                <dt>Bundle:</dt>
                <dd>Scaffold <a href='https://github.com/KineticCommunity/request-ce-bundle-scaffold' target="_blank">(Learn More)</a></dd>
            </dl>
        </div>
    </div>
</footer>

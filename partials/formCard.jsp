<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="../bundle/initialization.jspf" %>
<jsp:useBean id="random" class="java.util.Random" scope="application" />
<div class="col-sm-4">
    <div class="card small">
        <div class="card-content">
            <span class="fa ${text.defaultIfBlank(thisForm.getAttributeValue('Icon'), 'fa-star')} secondary-color"></span>
            <span class="card-title">
                <a href="${bundle.kappLocation}/${thisForm.slug}">
                    ${text.escape(i18n.translate(thisForm, thisForm.name))}
                </a>
            </span>
            <p>${text.escape(i18n.translate(thisForm, thisForm.description))}</p>

        </div>
        <div class="card-action clearfix">
            <a href="${bundle.kappLocation}/${thisForm.slug}">
                ${i18n.translate(thisForm, 'Submit Form')}
            </a>
        </div>
    </div>
</div>

<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="../bundle/initialization.jspf" %>

<bundle:layout page="${bundle.path}/layouts/layout.jsp">
    <bundle:variable name="head">
        <bundle:variable name="pageTitle">${text.escape(i18n.translate('Profile'))}</bundle:variable>
    </bundle:variable>
    <bundle:scriptpack>
        <bundle:script src="${bundle.location}/js/profile.js" />
    </bundle:scriptpack>
    
    <div class="container">
        <div class="profile panel panel-default">
            <div class="panel-heading">
                <h2>${i18n.translate('Edit Your Profile')}</h2>
            </div>
            <div class="panel-body">
                <div>
                    <h4>User Details</h4>
                </div>
                <div class="form-group">
                    <label for="username" class="control-label">${i18n.translate('Username')}</label>
                    <input id="username" name="username" class="form-control" value="${identity.username}" disabled>
                </div>
                <div class="form-group">
                    <label for="displayName" class="control-label">${i18n.translate('Display Name')}</label>
                    <input id="displayName" name="displayName" class="form-control" value="${identity.user.displayName}">
                </div>
                <div class="form-group">
                    <label for="email" class="control-label">${i18n.translate('Email')}</label>
                    <input id="email" name="email" class="form-control" value="${identity.user.email}">
                </div>
                <div class="form-group">
                    <label for="displayName" class="control-label">${i18n.translate('Preferred Language')}</label>
                    <select id="preferredLocale" class="form-control">
                        <option></option>
                        <c:forEach var="optionLocale" items="${i18n.getSystemLocales(pageContext.request.locales)}">
                            <option value="${i18n.getLocaleCode(optionLocale)}" 
                                    ${i18n.getLocaleCode(optionLocale) == identity.user.preferredLocale ? 'selected' : ''}
                                >${text.escape(i18n.getLocaleNameGlobalized(optionLocale))}</option>
                        </c:forEach>
                    </select>
                </div>
                <div id="password-section" class="collapse">
                    <hr />
                    <div>
                        <h4>Change Password</h4>
                    </div>
                    <div class="form-group">
                        <label for="password" class="control-label">${i18n.translate('Password')}</label>
                        <input id="password" type="password" name="password" class="form-control">
                    </div>
                    <div class="form-group">
                        <label for="passwordConfirmation" class="control-label">${i18n.translate('Password Confirmation')}</label>
                        <input id="passwordConfirmation" type="password" name="passwordConfirmation" class="form-control">
                    </div>
                </div>
                <button class="btn btn-link" id="password-toggle">
                    <span class="change-password">${i18n.translate('Change Password')}</span>
                    <span class="cancel collapse">${i18n.translate('Cancel')}</span>
                </button>
            </div>
            <div class="panel-footer text-right">
                <button class="btn btn-success save-profile" type="button">${i18n.translate('Save')}</button>
            </div>
        </div>
    </div>
</bundle:layout>

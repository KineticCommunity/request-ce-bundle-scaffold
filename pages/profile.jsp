<%@page pageEncoding="UTF-8" contentType="text/html" trimDirectiveWhitespaces="true"%>
<%@include file="../bundle/initialization.jspf" %>
<c:set var="teamsKapp" value="${space.getKapp(space.getAttributeValue('Teams Kapp Slug'))}" />

<bundle:layout page="${bundle.path}/layouts/layout.jsp">
    <bundle:variable name="head">
        <bundle:variable name="pageTitle">${text.escape(i18n.translate('Profile'))}</bundle:variable>
        <bundle:scriptpack>
            <bundle:script src="${bundle.location}/js/profile.js" />
        </bundle:scriptpack>
    </bundle:variable>
    
    <!-- BREADCRUMBS START HERE. Remove if not needed. ------------------------------------------->
    <bundle:variable name="breadcrumb">
        <li class="active">Profile</li>
    </bundle:variable>
    <!-- BREADCRUMBS END HERE. ------------------------------------------------------------------->
    
    <div class="container">
        <div class="profile m-b-4">
            <div class="profile-image">
                <div class="m-b-2">
                    <label class="control-label">${i18n.translate('Profile Image')}</label>
                    <a href="https://www.gravatar.com/emails" target="_blank">${GravatarHelper.get(200)}</a>
                </div>
            </div>
            <div class="profile-content">
                <div class="m-b-2">
                    <label class="control-label">${i18n.translate('Username')}</label>
                    <input class="form-control" value="${identity.username}" disabled>
                </div>
                <div class="m-b-2">
                    <label class="control-label">${i18n.translate('Display Name')}</label>
                    <input name="displayName" class="form-control" value="${identity.user.displayName}">
                </div>
                <div class="m-b-2">
                    <label class="control-label">${i18n.translate('Email')}</label>
                    <input name="email" class="form-control" value="${identity.user.email}">
                </div>
                <div id="password-section" class="collapse">
                    <hr />
                    <div class="m-b-2">
                        <label class="control-label">${i18n.translate('New Password')}</label>
                        <input type="password" name="password" class="form-control">
                    </div>
                    <div class="m-b-2">
                        <label class="control-label">${i18n.translate('Password Confirmation')}</label>
                        <input type="password" name="passwordConfirmation" class="form-control">
                    </div>
                </div>
                <button class="btn btn-link" id="password-toggle">
                    <span class="change-password">${i18n.translate('Change Password')}</span>
                    <span class="cancel-change-password collapse">${i18n.translate('Cancel Password Change')}</span>
                </button>
                <hr class="collapse" id="password-toggle-hr"/>
                <div class="m-b-2">
                    <label class="control-label">${i18n.translate('Preferred Language')}</label>
                    <select name="preferredLocale" class="form-control">
                        <option></option>
                        <c:forEach var="optionLocale" items="${i18n.getSystemLocales(pageContext.request.locales)}">
                            <option value="${i18n.getLocaleCode(optionLocale)}" 
                                    ${i18n.getLocaleCode(optionLocale) == identity.user.preferredLocale ? 'selected' : ''}
                                >${text.escape(i18n.getLocaleNameGlobalized(optionLocale))}</option>
                        </c:forEach>
                    </select>
                </div>

                <%-- Teams --%>
                <div class="m-b-2">
                    <label class="control-label">${i18n.translate('Teams')}</label>
                    <table class="table"> 
                        <tbody>
                            <c:forEach items="${identity.user.teams}" var="team">
                                <tr>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty teamsKapp}">
                                                <a href="${bundle.spaceLocation}/${teamsKapp.slug}?page=team&team=${team.slug}">${team.name}</a>
                                            </c:when>
                                            <c:otherwise>${team.name}</c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                            <tr class="empty-state"><td><i>${i18n.translate('None Found')}</i></td></tr>
                        </tbody>
                    </table>
                </div>
                
                <%-- Profile Attributes: All are visible/editable --%>
                <c:forEach items="${space.userProfileAttributeDefinitions}" var="definition">
                    <div class="m-b-2">
                        <label class="control-label">${i18n.translate(definition.name)}</label>
                        <div class="attribute-description">${i18n.translate(definition.description)}</div>
                        <c:choose>
                            <c:when test="${definition.allowsMultiple}">
                                <c:set var="values" value="${identity.user.getProfileAttributeValues(definition.name)}" />
                                <c:forEach items="${values}" var="value">
                                    <input name="profileAttributes" data-attribute="${definition.name}" 
                                           class="form-control" value="${value}">
                                </c:forEach>
                                <c:if test="${empty values}">
                                    <input name="profileAttributes" data-attribute="${definition.name}" class="form-control">
                                </c:if>
                                <div class="small text-right">
                                    <a href="javascript:void(0);" class="add-multiple-attribute" data-attribute="${definition.name}">
                                        ${i18n.translate('Add Another')}&nbsp;${i18n.translate(definition.name)}
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <input name="profileAttributes" data-attribute="${definition.name}" 
                                       class="form-control" value="${identity.user.getProfileAttributeValue(definition.name)}">
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:forEach>
                
                <%-- User Attributes: Only visible/editable if configured in space attribute "Visible User Attributes"
                        Attribute format: {"name": "<ATTRIBUTE_NAME>", "changeLinkText": "<LINK_LABEL>", "changeLinkUrl": "<URL>"} --%>
                <c:forEach items="${space.getAttributeValues('Visible User Attributes')}" var="visibleAttribute">
                    <c:set var="attributeSettings" value="${json.parse(visibleAttribute)}" />
                    <c:if test="${not empty attributeSettings.name}">
                        <div class="m-b-2">
                            <label class="control-label">${i18n.translate(attributeSettings.name)}</label>
                            <div class="attribute-description">${i18n.translate(space.getUserAttributeDefinition(attributeSettings.name).description)}</div>
                            <table class="table"> 
                                <tbody>
                                    <c:forEach items="${identity.user.getAttributeValues(attributeSettings.name)}" var="value">
                                        <tr><td>${value}</td></tr>
                                    </c:forEach>
                                    <tr class="empty-state"><td><i>${i18n.translate('None Found')}</i></td></tr>
                                </tbody>
                                <c:if test="${text.isNotBlank(attributeSettings.changeLinkUrl)}">
                                    <tfoot>
                                        <tr>
                                            <td class="small text-right">
                                                <a href="${attributeSettings.changeLinkUrl}" target="_blank">
                                                    ${i18n.translate(text.defaultIfBlank(attributeSettings.changeLinkText, 'Request Change'))}
                                                </a>
                                            </td>   
                                        </tr>
                                    </tfoot>
                                </c:if>
                            </table>
                        </div>
                    </c:if>
                </c:forEach>
                
                <div class="text-right">
                    <button class="btn btn-success save-profile-btn" type="button">${i18n.translate('Save')}</button>
                </div>
            </div>
        </div>
    </div>
</bundle:layout>

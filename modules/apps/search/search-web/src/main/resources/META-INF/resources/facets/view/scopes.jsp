<%--
/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
--%>

<%@ include file="/facets/init.jsp" %>

<%
if (termCollectors.isEmpty()) {
%>

	<aui:input name="<%= HtmlUtil.escapeAttribute(facet.getFieldName()) %>" type="hidden" value="<%= fieldParam %>" />

<%
	return;
}

int frequencyThreshold = dataJSONObject.getInt("frequencyThreshold");
int maxTerms = dataJSONObject.getInt("maxTerms");
boolean showAssetCount = dataJSONObject.getBoolean("showAssetCount", true);
%>

<div class="<%= cssClass %>" data-facetFieldName="<%= HtmlUtil.escapeAttribute(facet.getFieldId()) %>" id="<%= randomNamespace %>facet">
	<aui:input name="<%= HtmlUtil.escapeAttribute(facet.getFieldId()) %>" type="hidden" value="<%= fieldParam %>" />

	<ul class="nav nav-pills nav-stacked scopes">
		<li class="default facet-value <%= fieldParam.equals("0") ? "active" : StringPool.BLANK %>">
			<a data-value="0" href="javascript:;"><aui:icon image="sitemap" /> <liferay-ui:message key="<%= HtmlUtil.escape(facetConfiguration.getLabel()) %>" /></a>
		</li>

		<%
		long groupId = GetterUtil.getInteger(fieldParam);

		for (int i = 0; i < termCollectors.size(); i++) {
			TermCollector termCollector = termCollectors.get(i);

			long curGroupId = GetterUtil.getInteger(termCollector.getTerm());

			Group group = GroupLocalServiceUtil.fetchGroup(curGroupId);

			if (group == null) {
				continue;
			}

			if (((maxTerms > 0) && (i >= maxTerms)) || ((frequencyThreshold > 0) && (frequencyThreshold > termCollector.getFrequency()))) {
				break;
			}
		%>

			<li class="facet-value <%= groupId == curGroupId ? "active" : StringPool.BLANK %>">
				<a data-value="<%= curGroupId %>" href="javascript:;">
					<%= HtmlUtil.escape(group.getDescriptiveName(locale)) %>

					<c:if test="<%= showAssetCount %>">
						<span class="badge badge-info frequency"><%= termCollector.getFrequency() %></span>
					</c:if>
				</a>
			</li>

		<%
		}
		%>

	</ul>
</div>
<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String path = request.getContextPath();
    request.setAttribute("path", path);
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>
<%--<div class="user-part user-part-b">--%>
    <div class="activity-manage interactive-manage">
        <ul>
            <c:if test="${not empty activityList}">
                <c:forEach items="${activityList}" var="activity">
                    <li>
                        <div class="tit"><span class="lightred">编辑时间：  <fmt:formatDate value="${activity.activityCreateTime}" pattern="yyyy-MM-dd HH:mm:ss" /></span>
                            <i class="btn-status btn-chupiao">
                                <c:choose>
                                    <c:when test="${activity.activityState == 3}">
                                        待审核
                                    </c:when>
                                    <c:when test="${activity.activityState == 6}">
                                        已通过
                                    </c:when>
                                    <c:when test="${activity.activityState == 7}">
                                        未通过
                                    </c:when>
                                    <c:otherwise>
                                        未通过
                                    </c:otherwise>
                                </c:choose>
                            </i>
                        </div>
                        <div class="info">
                            <div>
                                <h3>活动：<c:out escapeXml="true" value="${activity.activityName}"/></h3>
                                <p>地址：<c:out escapeXml="true" value="${activity.activityAddress}"/></p>
                                <p>活动时间：${activity.activityStartTime}<c:if test="${not empty activity.activityEndTime}">&nbsp;至&nbsp;${activity.activityEndTime}</c:if></p>
                            </div>
                        </div>
                        <c:choose>
                            <c:when test="${activity.activityState == 3}">
                                <%--<div class="see"><a class="btn-edit" href="${path}/userActivity/preEditPublicActivity.do?activityId=${activity.activityId}">编辑 &gt;</a></div>--%>
                            </c:when>
                            <c:when test="${activity.activityState == 6}">
                                <div class="see"><a href="${path}/frontActivity/frontActivityDetail.do?activityId=${activity.activityId}" target="_blank">查看 &gt;</a></div>
                            </c:when>
                            <c:when test="${activity.activityState == 7}">
                                <div class="see"><a class="btn-edit" href="${path}/userActivity/preEditPublicActivity.do?activityId=${activity.activityId}">编辑</a></div>
                            </c:when>
                            <c:otherwise>
                                    <div class="see"><a class="btn-edit" href="${path}/userActivity/preEditPublicActivity.do?activityId=${activity.activityId}">编辑</a></div>
                            </c:otherwise>
                        </c:choose>
                    </li>
                </c:forEach>
            </c:if>
            <c:if test="${empty activityList}">
                <div  class="null_info">
                    <h3>您还没有发布活动记录哦。</h3>
                </div>
            </c:if>
        </ul>
        <%--动态取值分页--%>
        <c:if test="${fn:length(activityList) gt 0}">
            <div id="kkpager"></div>
            <input type="hidden" id="pages" value="${page.page}">
            <input type="hidden" id="countPage" value="${page.countPage}">
            <input type="hidden" id="total" value="${page.total}">
            <input type="hidden" id="reqPage"  value="1">
        </c:if>
    </div>

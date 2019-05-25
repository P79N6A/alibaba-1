<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java"  pageEncoding="UTF-8"%>

<%
    String path = request.getContextPath();
    request.setAttribute("path", path);
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>

    <ul class="activity_ul" id="data-ul">
        <c:forEach items="${activityList}" var="activity" >
            <li data-li-url="${activity.activityIconUrl}">
                <a href="${path}/ticketActivity/ticketActivityDetail.do?activityId=${activity.activityId}" class="img"><img src="${activity.activityIconUrl}" onload="fixImage(this, 280, 187)" /></a>
                <div class="info">
                    <h1><a href="${path}/ticketActivity/ticketActivityDetail.do?activityId=${activity.activityId}">${activity.activityName}</a></h1>
                    <div class="text">
                        <p>地址：
                            <%--${fn:split(activity.activityCity, ',')[1]}&nbsp;<c:if test="${fn:split(activity.activityArea, ',')[1] != fn:split(activity.activityCity, ',')[1]}">${fn:split(activity.activityArea, ',')[1]}&nbsp;</c:if><c:out value="${fn:substring(activityAddress,0,10)}" escapeXml="true"/>--%>
                            <c:out value="${fn:substring(activity.activityAddress,0,10)}" escapeXml="true"/>
                        </p>
                        <p>时间：
                            <fmt:parseDate value="${activity.activityStartTime}" pattern="yyyy-MM-dd" var="startTime"/>
                            <fmt:parseDate value="${activity.activityEndTime}" pattern="yyyy-MM-dd" var="endTime"/>
                            <fmt:formatDate value="${startTime}" pattern="yyyy-MM-dd"/>
                            <c:if test="${startTime eq endTime}"></c:if>
                            <c:if test="${not empty endTime && startTime != endTime}" >
                                至<fmt:formatDate value="${endTime}" pattern="yyyy-MM-dd"/>&nbsp;
                            </c:if>
                        </p>
                        <p>
                            <c:if test="${activity.activityIsReservation==2}" >
                                <c:if test="${activity.isOver == 'N'}" >
                                    <c:if test="${empty activity.sysNo || activity.sysNo=='0'}">
                                        余票：
						                <span class="red">
							                <c:if test="${empty activity.activityReservationCount}"> 0</c:if>
							                <c:if test="${not empty activity.activityReservationCount}"> ${activity.activityReservationCount}</c:if>
						                </span>
                                        张
                                    </c:if>
                                </c:if>
                            </c:if>
                        </p>
                    </div>
                    <div class="number">
                        <span class="like">${activity.collectNum}</span>
                        <span class="view"><c:if test="${empty activity.yearBrowseCount}">0</c:if><c:if test="${not empty activity.yearBrowseCount}">${activity.yearBrowseCount}</c:if></span>
                    </div>
                </div>
            </li>
        </c:forEach>
    </ul>

    <c:if test="${fn:length(activityList) gt 0}">
        <div id="kkpager" width:750px;margin:10 auto;></div>
        <input type="hidden" id="pages" value="${page.page}">
        <input type="hidden" id="countpage" value="${page.countPage}">
        <input type="hidden" id="total" value="${page.total}">
    </c:if>



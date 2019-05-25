<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<%
    String path = request.getContextPath();
    request.setAttribute("path", path);
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
    request.setAttribute("basePath", basePath);
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <title>安康文化云首页</title>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/bpNormalize.css"/>
    <%-- <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/hsCulture.css"/> --%>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/styleChild.css"/>
    <link rel="stylesheet" href="${path}/STATIC/css/owl.carousel.min.css"/>
    <link rel="stylesheet" href="${path}/STATIC/css/owl.theme.default.min.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>

    <%-- <script type="text/javascript" src="${path}/STATIC/js/frontBp/jquery.min.js"></script> --%>
    <script type="text/javascript" src="${path}/STATIC/js/frontBp/jquery-1.9.0.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/frontBp/jquery.SuperSlide.2.1.1.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/frontBp/owl.carousel.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/frontBp/culture.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/frontBp/qiehuan.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/common.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/base.js"></script>
    <%-- <script type="text/javascript" src="${path}/STATIC/js/index/index/index.js?version=20160507"></script> --%>
    <script src="http://webapi.amap.com/maps?v=1.3&key=a5b9a436f67422826aef2f4cb7e36910&plugin=AMap.AdvancedInfoWindow"></script>
    <style type="text/css">
        html, body {background-color: #f6f6f6}
    </style>
    <script>

    </script>
</head>
<body>
    <ul class="actListUl clearfix" id="dayNewUl">
        <c:choose>
            <c:when test="${ empty cmsActivities}">
                <img src="${path}/STATIC/image/noMessage.jpg" style="width:100%">
            </c:when>
            <c:otherwise>
                <div id="xinhuodong">
                <c:forEach items="${cmsActivities}" var="activity" varStatus="st">
                    <%--<c:forEach items="${activityList}" var="daynews" varStatus="dn">--%>
                    <li data-url="${activity.activityIconUrl}" style="">
                        <a class="mhActDivLink" href="${path}/frontActivity/frontActivityDetail.do?activityId=${activity.activityId}">
                            <div class="pic">
                                <img src="http://119.23.14.134:12001/${activity.activityIconUrl}" alt="" width="285" height="190">
                                <c:if test="${activity.activityIsReservation==2}">
                                    <div class="ding">订</div>
                                </c:if>
                            </div>
                            <div class="char">
                                <div class="titEr">${activity.activityName}</div>
                                <div class="wenYi">地点：${activity.activityAddress}</div>
                                <div class="wenYi">时间：${activity.activityStartTime}
                                    <c:if test="${activity.activityStartTime != activity.activityEndTime&&not empty activity.activityEndTime}">
                                        至 ${activity.activityEndTime}</c:if></div>
                                <!-- 预订-->
                                <div style="border-top:1px dashed #e5e5e5;height:80px;margin-top:10px">
                                    <c:if test="${activity.activityIsReservation==2}">
                                        <c:choose>
                                            <c:when test="${not empty activity.cancelEndTime}">
                                                <c:choose>
                                                    <c:when test="${nowDate-activity.cancelEndTime.time < 0}">
                                                        <c:choose>
                                                            <c:when test="${activity.availableCount>0}">
                                                                <div class="ydBtn">我要预订</div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="ydBtn done">已订完</div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="ydBtn done">已结束</div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:otherwise>
                                                <c:choose>
                                                    <c:when test="${nowDate-activity.endTime.time < 0}">
                                                        <c:choose>
                                                            <c:when test="${activity.availableCount>0}">
                                                                <div class="ydBtn">我要预订</div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="ydBtn done">已订完</div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="ydBtn done">已结束</div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if>
                                    <!-- 直接前往 -->
                                    <c:if test="${activity.activityIsReservation==1}">
                                        <c:choose>
                                            <c:when test="${nowDate-activity.endTime.time < 0}">
                                                <div class="ydBtn goto">直接前往</div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="ydBtn done">已结束</div>
                                            </c:otherwise>
                                        </c:choose>

                                    </c:if>
                                </div>

                            </div>
                        </a>
                    </li>
                </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </ul>
</body>
</html>
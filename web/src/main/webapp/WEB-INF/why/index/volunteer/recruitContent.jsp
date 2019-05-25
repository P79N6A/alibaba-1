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
    <title>志愿活动</title>
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
        .actListUl .pic #ding{
            width: 70px;
            font-size: 12px;
            color: #fff;
            text-align: center;
            height: 22px;
            line-height: 22px;
            position: absolute;
            right: 0;
            bottom: 0;
            background-color: rgb(84, 82, 79);
        }
    </style>
</head>
<body>
<!-- 最新文化活动 -->
<!-- <div class="syListWcAll" id="activityNewDiv"> -->
<ul class="actListUl clearfix" id="activityNewUl">
    <div id="xinhuodong">
        <c:set var="nowDate" value="<%=System.currentTimeMillis()%>"></c:set>
        <c:forEach items="${volunteerActivityList}" var="activity" varStatus="st">
            <li data-id="${activity.uuid}" style="">
                <a class="mhActDivLink" href="${path}/newVolunteerActivity/queryNewVolunteerActivityById.do?uuid=${activity.uuid}">
                    <div class="pic">
                        <img src="${activity.picUrl}" alt="" width="285" height="190">
                        <c:if test="${activity.recruitmentStatus==1}">
                            <div class="ding" style="width:70px;">正在招募</div>
                        </c:if>
                        <c:if test="${activity.recruitmentStatus==2}">
                            <div class="ding" style="width:70px;">停止招募</div>
                        </c:if>
                    </div>
                    <div class="char" style="height:auto">
                        <div class="titEr">${activity.name}</div>
                        <div class="wenYi">地点：${activity.address}</div>
                        <div class="wenYi">时间：
                            <fmt:formatDate value="${activity.startTime}" pattern="yyyy-MM-dd HH:mm:ss" />至
                        </div>
                        <c:if test="${activity.startTime != activity.endTime&&not empty activity.endTime}">
                            <div class="wenYi">
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <fmt:formatDate value="${activity.endTime}" pattern="yyyy-MM-dd HH:mm:ss" />
                            </div>
                        </c:if>
                    </div>
                </a>
            </li>
        </c:forEach>
    </div>
</ul>
</body>
</html>
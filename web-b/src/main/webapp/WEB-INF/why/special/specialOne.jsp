<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>假装在现场--文化云</title>
    <script type="text/javascript" src="${path}/STATIC/pandora/js/jquery.min.js"></script>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/special/css/reset-index.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/special/css/culture.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/special/css/culture-user.css"/>
    <!--[if lte IE 8]>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/special/css/culture-ie.css"/>
    <![endif]-->
    <script type="text/javascript" src="${path}/STATIC/special/js/jquery.min.js"></script>
    <script type="text/javascript" src="${path}/STATIC/special/js/jquery.SuperSlide.2.1.js"></script>
    <script type="text/javascript" src="${path}/STATIC/special/js/culture.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/common.js"></script>
    <!--移动端版本兼容 -->
    <script type="text/javascript">
        var phoneWidth = parseInt(window.screen.width);
        var phoneScale = phoneWidth / 1250;
        var ua = navigator.userAgent;            //浏览器类型
        if (/Android (\d+\.\d+)/.test(ua)) {      //判断是否是安卓系统
            var version = parseFloat(RegExp.$1); //安卓系统的版本号
            if (version > 2.3) {
                document.write('<meta name="viewport" content="width=1250, minimum-scale = ' + phoneScale + ', maximum-scale = ' + (phoneScale) + ', target-densitydpi=device-dpi">');
            } else {
                document.write('<meta name="viewport" content="width=1250, target-densitydpi=device-dpi">');
            }
        } else {
            document.write('<meta name="viewport" content="width=1250, user-scalable=yes, target-densitydpi=device-dpi">');
        }
        function urlMetnod(obj, iconUrl) {
            var imgUrl = obj.attr(iconUrl);
            //imgUrl= getImgUrl(imgUrl,"_300_300");
            if (imgUrl == undefined || imgUrl == "") {
                obj.find("img").attr("src", "../STATIC/image/default.jpg");
            } else {
                imgUrl = getIndexImgUrl(getImgUrl($(this).attr("data-url")), "_300_300");
                obj.find("img").attr("src", imgUrl);
            }
        }
        $(function () {
            $("#monkey_list img").each(function (index, item) {
                $(this).attr("src",getIndexImgUrl(getImgUrl($(this).attr("data-li-url")), "_300_300") );
            });
        });


    </script>
    <!--移动端版本兼容 end -->
</head>
<body>
<%@include file="/WEB-INF/why/index/index_top.jsp"%>
<!--2016.1.27-->
<div id="monkey_special_bg">
<div id="monkey_special">
    <div class="monkey_specialbg">
        <!--top start-->
        <div class="top_tit">
            <a href="#"><img src="${path}/STATIC/special/image/special_b1.png" width="1152" height="102"/></a><span
                class="icon_one"></span><span class="icon_two"></span><span class="icon_three"></span><span
                class="icon_four"></span><span class="icon_five"></span>
        </div>
        <!--top end-->
        <!--list start-->
        <div id="monkey_list">
            <ul class="monkey_ul">


                <%int i = 0;%>
                <c:forEach items="${activity}" var="activity">
                    <%i++;%>
                    <li>
                        <a href="${path}/frontActivity/frontActivityDetail.do?activityId=${activity.activityId}"
                           class="img"><img src="" data-li-url="${activity.activityIconUrl}" onload="fixImage(this, 280, 187);"/></a>
                        <div class="info">
                            <h1><a href="activity_detail.html"><c:out escapeXml="true"
                                                                      value="${activity.activityName}"/></a></h1>
                            <div class="text">
                                <p>地址：
                                    <c:set var="activityAddress" value="${activity.activityAddress}"/>
                                    <c:out value="${fn:substring(activityAddress,0,10)}" escapeXml="true"/>
                                    <c:if test="${fn:length(activityAddress) > 10}">...</c:if></p>
                                <p>时间：
                                    <fmt:parseDate value="${activity.activityStartTime}" pattern="yyyy-MM-dd" var="startTime"/>
                                    <fmt:parseDate value="${activity.activityEndTime}" pattern="yyyy-MM-dd" var="endTime"/>
                                    <fmt:formatDate value="${startTime}" pattern="yyyy-MM-dd"/>
                                    <c:if test="${startTime eq endTime}"></c:if>
                                    <c:if test="${not empty endTime && startTime != endTime}" >
                                        至 <fmt:formatDate value="${endTime}" pattern="yyyy-MM-dd"/>&nbsp;
                                    </c:if></p>
                                <p>					<c:if test="${activity.activityIsReservation==2}" >
                                    <c:if test="${empty activity.sysNo || '0' eq activity.sysNo}">
                                        余票：
						                <span class="red">
							                <c:if test="${empty activity.activityReservationCount}"> 0</c:if>
							                <c:if test="${not empty activity.activityReservationCount}"> ${activity.activityReservationCount}</c:if>
						                </span>
                                        张
                                    </c:if>
                                </c:if>
                                </p>
                            </div>
                            <div class="number">
                                <span class="like"><i></i>${activity.collectNum}</span>
                                <span class="view"><i></i><c:if test="${empty activity.yearBrowseCount}">0</c:if><c:if test="${not empty activity.yearBrowseCount}">${activity.yearBrowseCount}</c:if></span>
                            </div>
                        </div>
                    </li>
                </c:forEach>


            </ul>
        </div>
    </div>
</div>
</div>
<%@include file="/WEB-INF/why/index/index_foot.jsp"%>
</body>
</html>
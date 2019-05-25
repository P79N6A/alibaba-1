

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>文化日历</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/frontIndexPageFrameNew.jsp"%>
    <link type="text/css" rel="stylesheet" href="${path}/STATIC/css/normalize.css" />
    <link type="text/css" rel="stylesheet" href="${path}/STATIC/css/style.css" />
    <link type="text/css" rel="stylesheet" href="${path}/STATIC/css/styleChild.css" />
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/calendar.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/timebar.js"></script>
    <script src="http://webapi.amap.com/maps?v=1.3&key=a5b9a436f67422826aef2f4cb7e36910&plugin=AMap.AdvancedInfoWindow"></script>
    <style>
        .calendar{
            width:1200px;
            margin:0 auto;
            overflow:hidden;
        }
        .calendar .week li{
            height: 60px;
            padding: 5px 0;
            vertical-align: middle;
        }
    </style>
</head>
<body>
<div class="fsMain">

    <%@include file="../header.jsp" %>
    <div class="calendar">
        <div style="width:1200px;text-align:center">
            <div id="calendar" style="margin-top: 20px;margin-bottom: 20px;">

            </div>
        </div>
        <%--没有数据是显示内容--%>
        <div id="whCalendar" style="width:1200px">
        </div>
    </div>
    <%@include file="../footer.jsp" %>
</div>
<script>
$(function(){
    $("#calendarIndex").addClass('cur').siblings().removeClass('cur');
    timebar.init("calendar",null);
})
//通过日期获取文化活动
function loadDayNews(thisDay){
   $("#whCalendar").load("${path}/pcActivity/queryCalendarAdvert.do #dayNewUl",{TIME:thisDay}, function() {

    });
}
</script>
</body>
</html>

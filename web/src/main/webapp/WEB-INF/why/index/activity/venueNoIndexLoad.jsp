<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
    String path = request.getContextPath();
    request.setAttribute("path", path);
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>
<c:if test="${empty activityList}">
    <div class="sort-box search-result">
        <div class="no-result">
            <h2 id="tip1">抱歉，没有找到符合条件的结果</h2>
            <h2 id="tip2">抱歉，没有找到符合“<span class="red" id="searchTip"></span>”的结果</h2>
            <h4>您可以修改搜索条件重新尝试</h4>
        </div>
    </div>
</c:if>

<c:if test="${not empty activityList}">
    <div class="search_see">
        <div class="txt">共为您找到<span class="red" id="recordSize1"></span>条活动</div>
        <c:if test="${not empty venueId}" >
            <a href="${path}/frontVenue/venueDetail.do?venueId=${venueId}">查看该场馆详情</a>
        </c:if>
    </div>
    <input type="hidden" id="sort" value="1"/>
    <div id="loadListIdDiv">
        <ul class="activity_ul">
            <c:forEach items="${activityList}" var="activity" >
                <li data-li-url="${activity.activityIconUrl}">
                    <a href="${path}/frontActivity/frontActivityDetail.do?activityId=${activity.activityId}" class="img">
                        <img onload="fixImage(this, 280, 187)"/>
                    </a>
                    <div class="info">
                        <h1><a href="${path}/frontActivity/frontActivityDetail.do?activityId=${activity.activityId}">${activity.activityName}</a></h1>
                        <div class="text">
                            <p>地址：${activity.activityAddress}</p>
                            <p>时间：${activity.activityStartTime}</p>
                            <p><c:if test="${activity.activityIsReservation == 2}">余票：<span><c:choose><c:when test="${not empty activity.availableCount}">${activity.availableCount}</c:when><c:otherwise>0</c:otherwise></c:choose></span>张</c:if></p>
                        </div>
                        <div class="number">
                            <span class="like" id="${activity.activityId}" mid="${activity.activityId}"></span>
                            <span class="view"><c:if test="${empty activity.yearBrowseCount}" >0</c:if><c:if test="${not empty activity.yearBrowseCount}" >${activity.yearBrowseCount}</c:if></span>
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
    </div>
</c:if>

<script type="text/javascript">
    var venueName =  $("#keyword").val() == "请输入关键词" ? "" : $("#keyword").val();
    if($.trim(venueName)==""){
        $("#tip2").css("display","none");
    }else{
        $("#searchTip").html(venueName);
        $("#tip1").css("display","none");
    }

    var totalSize = $("#total").val();
    if(totalSize == undefined){
        $("#recordSize1").html(0);
        $("#recordSize2").html(0);
    }else{
        $("#recordSize1").html(totalSize);
        $("#recordSize2").html(totalSize);
    }

    if($.trim(venueName)==""){
        $("#recordResultDiv2").css("display","none");
        $("#recordResultDiv1").css("display","block");
    }else{
        $("#searchContent").html(venueName);
        $("#recordResultDiv1").css("display","none");
        $("#recordResultDiv2").css("display","block");
    }

</script>
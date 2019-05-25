<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
  String path = request.getContextPath();
  request.setAttribute("path", path);
  String basePath = request.getScheme() + "://"
          + request.getServerName() + ":" + request.getServerPort()
          + path + "/";
%>


<!-- 热点推荐 -->
<div id="recommendActivitysChild">
  <div class="in-content in-part1 clearfix">
    <div class="in-tit">
      <span class="in-hot fl"><i></i>热点推荐</span>
      <div class="in-hot-search fr">
        <input type="text" name="activityName"
               id="activityName" onblur="toSearchPage()"   onfocus="clearData()" onkeydown="if(window.event.keyCode==13){ toSearchPage(); return false; }"
              <c:if test="${empty activityName}" > value="请输入关键字" </c:if>  <c:if test="${not empty activityName}" > value="${activityName}" </c:if> data-val="请输入关键字" class="input-text"/>
      </div>
    </div>
    <div class="in-hotList">
      <ul>
        <c:forEach items="${recommendActivity}" var="activity">
          <li activity-icon-url="${activity.activityIconUrl}">
            <input type="hidden" name="activityIds" value="${activity.activityId}" />
            <img src="${activity.activityIconUrl}" onload="fixImage(this, 216, 216)"/>
            <div class="shade"></div>
            <a href="${path}/frontActivity/frontActivityDetail.do?activityId=${activity.activityId}" class="txt">
              <h3> ${activity.activityStartTime}<br/><c:out escapeXml="true" value="${activity.activityName}"/><br/></h3>
              <span class="heart"><i></i><label id="recommend_${activity.activityId}" tid="${activity.activityId}"></label></span>
            </a>
          </li>
        </c:forEach>
      </ul>
    </div>
  </div>
</div>
<!-- 热点推荐 end -->


<!-- 你可能喜欢的 -->
<div id="likeActivitysChild">
<div class="in-content in-part2 clearfix" >
  <div class="in-tit">
    <span class="in-love fl"><i></i>你可能喜欢的</span>
    <%--<div class="in-cate1 fr" id="tag">--%>

    <%--</div>--%>
  </div>
  <div class="in-loveList" >
    <ul>
      <c:forEach items="${likeActivity}" var="activity">
        <li activity-icon-url="${activity.activityIconUrl}">
          <a href="${path}/frontActivity/frontActivityDetail.do?activityId=${activity.activityId}" class="img fl"><img src=""  onload="fixImage(this, 120, 120)"/></a>
          <div class="info fr">
            <span></span>
            <h3 style="height: 56px;"><a href="${path}/frontActivity/frontActivityDetail.do?activityId=${activity.activityId}"><c:out escapeXml="true" value="${activity.activityName}"/></a></h3>
            <p>地址：
            		<c:set var="activityAddress" value="${activity.activityAddress}"/>
	                <c:out value="${fn:substring(activityAddress,0,8)}" escapeXml="true" />
	                <c:if test="${fn:length(activityAddress) > 8}">...</c:if>
            </p>
            <p>时间：${activity.activityStartTime}<c:if test="${activity.activityStartTime != activity.activityEndTime&&not empty activity.activityEndTime}}" > 至 ${activity.activityEndTime}</c:if></p>
          </div>
        </li>
      </c:forEach>
    </ul>
  </div>
</div>
</div>
<!-- 你可能喜欢的 end -->

<!-- 最新活动 -->
<div id="newActivitysChild">
  <div class="in-content in-part3 clearfix" >
    <div class="in-tit">
      <span class="in-tit1 fl"><i></i>最新活动</span>
      <a class="in-cate2 fr" href="${path}/frontActivity/frontActivityList.do">精选<em>${count}</em>个活动</a>
    </div>
    <div class="in-activity" >
      <ul>
        <c:forEach items="${newestActivity}" var="activity">

          <li activity-icon-url="${activity.activityIconUrl}">
            <input type="hidden" name="activityIds" value="${activity.activityId}" />
            <a href="${path}/frontActivity/frontActivityDetail.do?activityId=${activity.activityId}" class="img"><img  onload="fixImage(this, 235, 235)"/></a>
            <div class="info">
              <h3 style="height: 56px;"><a href="${path}/frontActivity/frontActivityDetail.do?activityId=${activity.activityId}"><c:out escapeXml="true" value="${activity.activityName}"/></a></h3>
              <p>地址：
					<c:set var="activityAddress" value="${activity.activityAddress}" />
	                <c:out value="${fn:substring(activityAddress,0,10)}" escapeXml="true"/>
	                <c:if test="${fn:length(activityAddress) > 10}">...</c:if>
			  </p>
              <p>时间：${activity.activityStartTime}<c:if test="${activity.activityStartTime != activity.activityEndTime&&not empty activity.activityEndTime}"> 至 ${activity.activityEndTime}</c:if></p>
            </div>
            <div class="icon">
              <span class="heart"><i></i><label id="new_${activity.activityId}" newmid="${activity.activityId}">0</label></span>
              <span class="look"><i></i><label id="new_view${activity.activityId}">${activity.yearBrowseCount==null?0:activity.yearBrowseCount}</label></span>
            </div>
          </li>
        </c:forEach>
        <li class="more">
          <a href="${path}/frontActivity/frontActivityList.do">
            <span>MORE</span>
            <p>点击查看更多有趣活动</p>
          </a>
        </li>
      </ul>
    </div>
  </div>
</div>
<!-- 最新活动 end-->

<!-- foot -->
<div class="in-part4 clearfix">
  <div class="in-phone"><img src="${path}/STATIC/image/in-phone.png" alt="" width="332" height="524"/></div>
  <div class="in-sweep">扫一扫，下载佛山文化云APP发现更多</div>
  <div class="in-site">精彩尽在<span>www.wenhuayun.cn</span></div>
  <div class="in-app">
    <div class="in-iphone">
      <img src="${path}/STATIC/image/app-img1.png" alt="" width="125" height="125"/>
      <span><i></i>App Store下载</span>
    </div>
    <div class="in-android">
      <img src="${path}/STATIC/image/app-img1.png" alt="" width="125" height="125"/>
      <span><i></i>Android下载</span>
    </div>
  </div>
</div>


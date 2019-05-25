<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
  String path = request.getContextPath();
  request.setAttribute("path", path);
  String basePath = request.getScheme() + "://"
          + request.getServerName() + ":" + request.getServerPort()
          + path + "/";
%>
<div class="collection_manage">
  <ul id="activityUl" class="activity_ul">
    <c:forEach items="${activityList}" var="activity">
      <li data-icon-url="${activity.activityIconUrl}">
        <a href="${path}/frontActivity/frontActivityDetail.do?activityId=${activity.activityId}" ><img width="250" height="168"/></a>
        <div class="info">
        <h1><a href="${path}/frontActivity/frontActivityDetail.do?activityId=${activity.activityId}">${activity.activityName}</a></h1>
        <div class="text">
          <p>地址：${activity.activityAddress}</p>
          <p>时间：${activity.activityStartTime}<c:if test="${not empty activity.activityEndTime && activity.activityStartTime != activity.activityEndTime}">&nbsp;至&nbsp;${activity.activityEndTime}</c:if></p>
          <p><c:if test="${activity.activityIsReservation == 2}">
            余票：<span class="red">
            <c:choose>
              <c:when test="${not empty activity.availableCount}">${activity.availableCount}</c:when>
              <c:otherwise>0</c:otherwise>
            </c:choose>
            </span>
            张
          </c:if></p>
        </div>
        <div class="number">
          <span class="like"><i></i><label id="recommend_${activity.activityId}" tid="${activity.activityId}"></label></span>
          <span class="view"><i></i><c:choose><c:when test="${not empty activity.yearBrowseCount}">${activity.yearBrowseCount}</c:when><c:otherwise>0</c:otherwise></c:choose></span>
        </div>
        <a class="del-btn" onclick="deleteCollectActivity('${activity.activityId}')"></a>
        </div>
      </li>
    </c:forEach>
  </ul>
  <c:if test="${empty activityList}">
      <div class="null_info">
        <h3>没有收藏的活动，<a href="${path}/frontActivity/activityList.do">去看看</a></h3>
      </div>
  </c:if>
  <%--动态取值分页--%>
  <c:if test="${fn:length(activityList) gt 0}">
    <div id="kkpager" width:750px;margin:10 auto;></div>
    <input type="hidden" id="pages" value="${page.page}">
    <input type="hidden" id="countPage" value="${page.countPage}">
    <input type="hidden" id="total" value="${page.total}">
    <input type="hidden" id="reqPage"  value="1">
  </c:if>
  <%--<div class="page">
    <a href="javascript:;" class="page-prev">&lt;</a>
    <a href="javascript:;">1</a>
    <a href="javascript:;" class="cur">2</a>
    <a href="javascript:;">3</a>
    <a href="javascript:;">4</a>
    <a href="javascript:;">...</a>
    <a href="javascript:;">32</a>
    <a href="javascript:;" class="page-next">&gt;</a>
    <span>跳转到</span>
    <input type="text" value="" class="pageNum"/>
    <input type="button" value="GO" class="page-go"/>
  </div>--%>
</div>
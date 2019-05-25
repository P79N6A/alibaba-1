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
<div class="group-list">
  <ul id="groupUl">
    <c:forEach items="${teamUserList}" var="teamUser">
      <li data-icon-url="${teamUser.tuserPicture}">
        <h3><a href="${path}/frontTeamUser/groupDetail.do?tuserId=${teamUser.tuserId}">${teamUser.tuserName}</a></h3>
        <p>所在：${fn:substringAfter(teamUser.tuserCounty,',')}</p>
        <a class="img" href="${path}/frontTeamUser/groupDetail.do?tuserId=${teamUser.tuserId}"><img width="235" height="235"/></a>
        <div class="icon">
          <span class="heart"><i></i><c:choose><c:when test="${not empty teamUser.yearCollectCount}">${teamUser.yearCollectCount}</c:when><c:otherwise>0</c:otherwise></c:choose></span>
          <span class="look"><i></i><c:choose><c:when test="${not empty teamUser.yearBrowseCount}">${teamUser.yearBrowseCount}</c:when><c:otherwise>0</c:otherwise></c:choose></span>
        </div>
        <a class="close-btn" id="close-btn" onclick="deleteCollectGroup('${teamUser.tuserId}')"></a>
      </li>
    </c:forEach>
  </ul>
  <c:if test="${empty teamUserList}">
      <div class="null_info">
        <h3>没有收藏的团体，<a href="${path}/frontActivity/activityList.do">去看看</a></h3>
      </div>
  </c:if>
  <%--动态取值分页--%>
  <c:if test="${fn:length(teamUserList) gt 0}">
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
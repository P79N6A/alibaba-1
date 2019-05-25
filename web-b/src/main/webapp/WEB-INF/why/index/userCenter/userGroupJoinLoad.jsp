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
<div class="group-manage join-list">
  <ul  id="userGroupJoinLoadUl">
    <c:forEach items="${teamUsers}" var="teamUser">
        <li data-name="${teamUser.tuserName}" data-applyId="${teamUser.applyId}" tag-id="${teamUser.tuserCrowdTag}${teamUser.tuserPropertyTag}${teamUser.tuserSiteTag}" dict-id="${teamUser.tuserLocationDict}">
        <div class="tit"><span>管理员：${teamUser.managerName}</span><em>加入时间： <fmt:formatDate value="${teamUser.applyUpdateTime}" pattern="yyyy-MM-dd HH:mm" /></em></div>
        <div class="info">
          <h3>团体名称：${teamUser.tuserName}</h3>
          <p>团体人数：<c:choose><c:when test="${not empty teamUser.tuserLimit}">${teamUser.tuserLimit}</c:when><c:otherwise>0</c:otherwise></c:choose>人</p>
          <p>团体标签：<span class="tag"></span></p>
        </div>
        <a class="btn btn-red btn-exit-group">退出团体</a>
      </li>
    </c:forEach>
    <c:if test="${empty teamUsers}">
        <div class="null_info">
          <h3>您还没有加入团体，<a href="${path}/frontTeamUser/teamUserList.do">去看看</a></h3>
        </div>
    </c:if>
  </ul>
  <c:if test="${fn:length(teamUsers) gt 0}">
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
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
  <ul id="userGroupHistoryLoadUl">
    <c:forEach items="${teamUsers}" var="teamUser">
      <li tag-id="${teamUser.tuserCrowdTag}${teamUser.tuserPropertyTag}${teamUser.tuserSiteTag}" dict-id="${teamUser.tuserLocationDict}">
        <div class="tit"><span>管理员：${teamUser.managerName}</span>
          <em>
            <c:if test="${teamUser.applyCheckState == 1}">申请时间：</c:if>
            <c:if test="${teamUser.applyCheckState == 2}">拒绝时间：</c:if>
            <c:if test="${teamUser.applyCheckState == 3}">加入时间：</c:if>
            <c:if test="${teamUser.applyCheckState == 4}">退出时间：</c:if>
            <fmt:formatDate value="${teamUser.tUpdateTime}" pattern="yyyy-MM-dd HH:mm" />
          </em>
        </div>
        <div class="info">
          <h3>团体名称：${teamUser.tuserName}</h3>
          <p>团体人数：${teamUser.tuserLimit}人</p>
          <p>团体标签：<span class="tag"></span></p>
        </div>
        <span class="btn btn-red btn-text">
          <c:if test="${teamUser.applyCheckState == 1}">待审核</c:if>
          <c:if test="${teamUser.applyCheckState == 2}">未通过</c:if>
          <c:if test="${teamUser.applyCheckState == 3}">已通过</c:if>
          <c:if test="${teamUser.applyCheckState == 4}">已退出</c:if>
        </span>
      </li>
    </c:forEach>
    <c:if test="${empty teamUsers}">
        <div class="null_info">
          <h3>您还没有产生历史记录，<a href="${path}/frontTeamUser/teamUserList.do">去看看</a></h3>
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
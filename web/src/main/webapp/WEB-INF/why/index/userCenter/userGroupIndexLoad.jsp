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
<div class="group-manage">
  <ul id="userGroupIndexLoadUl">
    <c:forEach items="${teamUsers}" var="teamUser">
      <li tag-id="${teamUser.tuserCrowdTag}${teamUser.tuserPropertyTag}${teamUser.tuserSiteTag}" dict-id="${teamUser.tuserLocationDict}">
        <div class="tit"><span>管理员：${teamUser.dictName}</span><em>创建时间： <fmt:formatDate value="${teamUser.tCreateTime}" pattern="yyyy-MM-dd HH:mm" /></em></div>
        <div class="info">
          <h3>团体名称：${teamUser.tuserName}</h3>
          <p>成员上限：<c:choose><c:when test="${not empty teamUser.tuserLimit}">${teamUser.tuserLimit}</c:when><c:otherwise>0</c:otherwise></c:choose></p>
          <p>团体标签：<span class="tag"></span></p>
          <div class="btn">
            <a href="${path}/frontTeamUser/userGroupManager.do?tuserId=${teamUser.tuserId}" class="btn-manage">成员管理</a>
            <a href="${path}/frontTeamUser/userGroupAuditing.do?tuserId=${teamUser.tuserId}" class="btn-auditing">待审核（${teamUser.checkCount}）</a>
            <a href="${path}/frontTeamUser/userGroupEdit.do?tuserId=${teamUser.tuserId}" class="btn-edit">编辑信息</a>
          </div>
        </div>
      </li>
    </c:forEach>
    <c:if test="${empty teamUsers}">
        <div class="null_info">
          <h3>没有您管理的团体，<a href="${path}/frontTeamUser/teamUserList.do">去看看</a></h3>
        </div>
    </c:if>
  </ul>
  <%--动态取值分页--%>
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
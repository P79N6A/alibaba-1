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
<div class="member-manage">
  <h2>成员管理</h2>
  <ul id="userHeadImgDiv">
    <c:forEach items="${teamUsers}" var="teamUser">
      <li data-name="${teamUser.dictName}" data-applyId="${teamUser.applyId}" user-head-img="${teamUser.tuserPicture}">
        <div class="img fl"><img width="80" height="80" <c:if test="${teamUser.userSex == 1}">src="${path}/STATIC/image/face_boy.png"</c:if><c:if test="${teamUser.userSex == 2}">src="${path}/STATIC/image/face_girl.png"</c:if>/></div>
        <div class="info fr">
          <h3><strong>${teamUser.dictName}</strong><c:if test="${teamUser.applyIsState == 1}"><span style="color:red">（管理员）</span></c:if><em>加入时间：<fmt:formatDate value="${teamUser.tUpdateTime}" pattern="yyyy-MM-dd" /></em></h3>
          <p>所属团体：${teamUser.tuserName}</p>
          <p>联系电话：<span class="lightblue">${teamUser.userMobileNo}</span></p>
        </div>
        <c:if test="${teamUser.applyIsState == 2}">
          <a href="javascript:;" class="btn btn-red btn-delete" style="disable:true">删除</a>
        </c:if>
      </li>
    </c:forEach>
    <c:if test="${empty teamUsers}">
        <div class="null_info">
          <h3>该团体没有成员，<a href="${path}/frontTeamUser/teamUserList.do">去看看</a></h3>
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
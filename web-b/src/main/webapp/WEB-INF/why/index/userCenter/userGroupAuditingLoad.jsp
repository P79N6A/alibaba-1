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
<div class="member-manage auditing-manage">
  <h2>待审核</h2>
  <ul id="userHeadImgDiv">
    <c:forEach items="${terminalUsers}" var="terminalUser">
      <li data-name="${terminalUser.userNickName}" data-applyId="${terminalUser.applyId}" user-head-img="${terminalUser.userHeadImgUrl}" tuser-id="${terminalUser.tuserId}" tuser-limit="${terminalUser.tuserLimit}">
        <div class="tit">
          <strong>姓名：${terminalUser.userNickName}</strong>
          <span>
            <c:if test="${terminalUser.userSex == 1}">男</c:if>
            <c:if test="${terminalUser.userSex == 2}">女</c:if>
            <c:if test="${terminalUser.userSex == 3}">保密</c:if>
          </span><span>${terminalUser.userAge}岁</span><span>申请加入：${terminalUser.tuserName}</span>
          <em>申请时间： <fmt:formatDate value="${terminalUser.applyTime}" pattern="yyyy-MM-dd HH:mm" /></em>
        </div>
        <div class="box">
          <div class="img fl"><img width="80" height="80" <c:if test="${terminalUser.userSex == 1}">src="${path}/STATIC/image/face_boy.png"</c:if>
                                   <c:if test="${terminalUser.userSex == 2}">src="${path}/STATIC/image/face_girl.png"</c:if>
                                   <c:if test="${terminalUser.userSex == 3}">src="${path}/STATIC/image/face_secrecy.png"</c:if>/></div>
          <div class="info fr">
            <p>申请理由：${terminalUser.applyReason}</p>
            <p>联系电话：<span class="lightblue">${terminalUser.userMobileNo}</span></p>
          </div>
        </div>
        <a class="btn btn-blue btn-approved">通过审核</a>
        <a class="btn btn-red btn-refuse">拒绝加入</a>
      </li>
    </c:forEach>
    <c:if test="${empty terminalUsers}">
        <div class="null_info">
          <h3>没有人申请加入该团体，<a href="${path}/frontTeamUser/teamUserList.do">去看看</a></h3>
        </div>
    </c:if>
  </ul>
  <c:if test="${fn:length(terminalUsers) gt 0}">
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
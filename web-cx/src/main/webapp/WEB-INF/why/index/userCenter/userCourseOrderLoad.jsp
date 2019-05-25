<%@ page import="com.sun3d.why.model.CmsTerminalUser" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>

<%
  String path = request.getContextPath();
  request.setAttribute("path", path);
  String basePath = request.getScheme() + "://"
          + request.getServerName() + ":" + request.getServerPort()
          + path + "/";
%>
  <style>
   .user-part li .tit .cancel_order{ padding:0 10px; background-color: #ffffff;   color: #4A4A4A; border: solid 1px #cbcbcb;cursor:pointer;}
   .user-part li .tit .cancel_order:hover{ background:#F58636;color: #ffffff;border: solid 1px #F58636; }
  </style>
  <div class="activity-manage">
    <ul>
      <c:if test="${not empty courseOrderList}" >
        <c:forEach items="${courseOrderList}" var="courseOrder">
        <input type="hidden" name="classTime" value="${courseOrder.classTimes}"/>
          <li data-orderNum="${courseOrder.orderId}">
            <div class="tit">
              <c:if test="${courseOrder.orderStatus == 1 or courseOrder.orderStatus==2}">
	              <a class="btn-status btn-chupiao cancel_order">取消报名</a>
              </c:if>
              <i class="btn-status btn-chupiao">
                <c:choose>
                  <c:when test="${courseOrder.orderStatus == 1}">
                    待确认
                  </c:when>
                  <c:when test="${courseOrder.orderStatus == 2}">
                     已确认
                  </c:when>
                  <%-- <c:when test="${courseOrder.orderStatus == 3}">
                     已取消
                  </c:when>
                  <c:otherwise>
                     已删除
                  </c:otherwise> --%>
                </c:choose>
                </i>
              <em>报名时间： ${fn:substring(courseOrder.createTime, 0, 19)}</em></div>
            <div class="info">
              <div>
                <h3>课程名称：${courseOrder.courseTitle}</h3>
                <p>培训地址：${courseOrder.trainAddress}</p>
                <p>培训时间：${courseOrder.startTime} 至  ${courseOrder.endTime} &nbsp;&nbsp;${courseOrder.trainTime}</p>
              </div>
            </div>
          </li>
        </c:forEach>
      </c:if>
      <c:if test="${empty courseOrderList}" >
          <div class="null_info">
            <h3>您还没有报名哦。</h3>
          </div>
      </c:if>
    </ul>

    <%--动态取值分页--%>
    <c:if test="${fn:length(courseOrderList) gt 0}">
      <div id="kkpager"></div>
      <input type="hidden" id="pages" value="${page.page}">
      <input type="hidden" id="countPage" value="${page.countPage}">
      <input type="hidden" id="total" value="${page.total}">
      <input type="hidden" id="reqPage"  value="1">
    </c:if>

  </div>
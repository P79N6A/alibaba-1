<%@ page import="com.sun3d.why.model.CmsTerminalUser" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>

<c:if test="${not empty culturalOrderOrderList}" >
	<c:forEach items="${culturalOrderOrderList}" var="order">
	<div class="item">
		<div class="topBox clearfix">
			<div class="sj"><fmt:formatDate value="${order.createTime}" pattern="yyyy-MM-dd HH:mm" /></div>
   			<c:choose>
       			<c:when test="${order.culturalOrderOrderStatus == 0 }">
       				<div class='zt wait'>待处理</div>
       			</c:when>
       			<c:when test="${order.culturalOrderOrderStatus == 1}">
       				<div class='zt'>已确认</div>
       			</c:when>
       			<c:when test="${order.culturalOrderOrderStatus == 2}">
       				<div class='zt refuse'>已拒绝</div>
       			</c:when>
       			<c:when test="${order.culturalOrderOrderStatus == 3}">
       				<div class='zt refuse'>已取消</div>
       			</c:when>
       		</c:choose>
        </div>
        <div class="xiaBox">
            <div class="char">
            	<div class="tit">${order.culturalOrderName}</div>
            	<c:if test="${order.culturalOrderLargeType == 1}">
            	   	<div class="wen">日期： <fmt:formatDate value="${order.culturalOrderEventDate}" pattern="yyyy-MM-dd" /></div>
            	    <div class="wen">时段： ${order.culturalOrderEventTime}</div>
           		</c:if>
           		<c:if test="${order.culturalOrderLargeType == 2}">
            	    <div class="wen">日期：<fmt:formatDate value="${order.culturalOrderOrderDate}" pattern="yyyy-MM-dd" /></div>
            	    <div class="wen">时段：${order.culturalOrderOrderPeriod}</div>
            	</c:if>
             </div>
             <c:choose>
          	    <c:when test="${order.culturalOrderOrderStatus == 0}">
          	    	<c:if test="${order.culturalOrderLargeType == 1}">
          	    			<a class="btn" href="javascript:void(0);" onclick="cancelOrderOrInvitation(this,'${order.culturalOrderOrderId}')">取消报名</a>
           			</c:if>
           			<c:if test="${order.culturalOrderLargeType == 2}">
          	    			<a class="btn" href="javascript:void(0);" onclick="cancelOrderOrInvitation(this,'${order.culturalOrderOrderId}')">取消邀请</a>
           			</c:if>
          	    </c:when>
          	    <c:when test="${order.culturalOrderOrderStatus == 2 || order.culturalOrderOrderStatus == 1}">
              		<a class="btn checkReply" href="javascript:void(0);" onclick="showReply('${order.culturalOrderOrderId}')">查看回复</a>
              	</c:when>
             </c:choose>
        </div>
     </div>
	</c:forEach>

	<c:if test="${fn:length(culturalOrderOrderList) gt 0}">
	      <div id="kkpager"></div>
	      <input type="hidden" id="pages" value="${page.page}">
	      <input type="hidden" id="countPage" value="${page.countPage}">
	      <input type="hidden" id="total" value="${page.total}">
	      <input type="hidden" id="reqPage"  value="1">
	</c:if>
</c:if>
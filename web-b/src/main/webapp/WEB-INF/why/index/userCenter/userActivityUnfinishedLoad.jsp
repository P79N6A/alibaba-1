<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
    String path = request.getContextPath();
    request.setAttribute("path", path);
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>

<div class="user-part user-part-b">
    <div class="activity-manage">
        <ul>
            <c:forEach items="${activityList}" var="activityList">
            <li data-orderNum="20150617068285">
                <div class="tit"><span class="lightred">订单号： ${activityList.orderNumber}</span><em>订单时间： 2015-06-17 15:20</em></div>
                <div class="info">
                    <div>
                        <h3>活动：孟京辉2015年最新话剧力作《琥珀》</h3>
                        <p>地址：上海市闸北区广中西路56号2楼</p>
                        <p>活动时间：<fmt:formatDate value="${activityList.orderCreateTime}" pattern="yyyy-MM-dd HH:mm" /></p>
                        <p>座位：${activityList.orderSummary}</p>
                        <p>票数：${activityList.orderVotes}</p>
                        <p>取票码：${activityList.orderValidateCode}<em></em>手机： ${activityList.orderPhoneNo}</p>
                    </div>
                </div>
                <div class="activity-comment">共有541条评论，<a href="Activity-detail.html#comment">去看看</a></div>
                <div class="total">费用：¥26.00</div>
                <div class="countdown" id="countdown1"></div>
                <a href="###" class="btn btn-red btn-order-pay">去付款</a>
                <a onclick="showAndHide('${activityList.activityId}')" class="btn btn-blue btn-order-detail">订单详情</a>
            </li>
            </c:forEach>
        </ul>

        <%--动态取值分页--%>
        <c:if test="${fn:length(activityList) gt 0}">
            <div id="kkpager" width:750px;margin:10 auto;></div>
            <input type="hidden" id="pages" value="${page.page}">
            <input type="hidden" id="countPage" value="${page.countPage}">
            <input type="hidden" id="total" value="${page.total}">
            <input type="hidden" id="reqPage"  value="1">
        </c:if>
    </div>
</div>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <title>取票机--活动预订--文化云</title>
  <%@include file="/WEB-INF/why/common/ticketFrame.jsp"%>
  <script type="text/javascript" src="${path}/STATIC/js/ticket/activity/ticketActivityBookOrder.js?id=123hgjk123"></script>
  <script type="text/javascript" src="${path}/STATIC/js/ticket/activity/ticketActivitySelectTopLabel.js"></script>
<%--  <script type="text/javascript">
    $(function() {
      $(".confirm_order").on("click", function(){
        var html = '<div class="btn-loading" id="btn-tip-loading"><h3>正在提交，请稍等...</h3><div class="img"></div></div>';
        $(this).parent().append(html);
        return false;
      });
    });
  </script>--%>
</head>
<body style="background: #eef4f7;">

<!-- ticket_top start -->
<%@include file="/WEB-INF/why/ticket/ticket-nav.jsp"%>
<!-- ticket_top end -->

<div class="register-content ticket-activity-book">
  <div class="steps steps-activity">
    <ul class="clearfix">
      <li class="step_1 visited_pre">1.填写基本信息<i class="tab_status"></i></li>
      <li class="step_2 visited_pre">2.选择座位<i class="tab_status"></i></li>
      <li class="step_3 visited_pre">3.填写取票信息<i class="tab_status"></i></li>
      <li class="step_4 active">4.确认订单信息<i class="tab_status"></i></li>
      <li class="step_5">5.完成预定</li>
    </ul>
  </div>
  <form action="" name="bookOrder" id="bookOrder" method="post" >
   <input type="hidden" name="activityId" id="activityId" value="${activity.activityId}"/>
   <input type="hidden" name="userId" id="userId" value="${sessionScope.terminalUser.userId}"/>
   <input type="hidden" id="activityEventIds" name="activityEventIds" value="${activityOrder.eventId}" />
   <input type="hidden" name="bookCount" id="bookCount" value="${bookCount }"/>
   <input type="hidden" name="orderMobileNum" id="orderPhoneNo" value="${activityOrder.orderPhoneNo}"/>
	<input type="hidden" name="orderPrice" id="orderPrice" value="0"/>
    <input type="hidden" name="seatIds" id="seatIds" value="${seatIds}"/>
    <input type="hidden" name="seatValues" id="seatValues" value="${saveSeatValues}" />
    <input type="hidden" name="orderName" id="orderName" value=""/>
    <input type="hidden" id="activityEventimes" name="activityEventimes" value="${activityOrder.eventDateTime}"/>
    
    
    <!--one start-->
    <div class="room-part3">
      <h1>确认订单信息</h1>
      <div class="room-order-info activity-order-info">
        <div class="img fl"><img id="iconUrl" iconUrl="${activity.activityIconUrl}" src="" width="450" height="300"/></div>
        <div class="details fr">
          <p><span>订单号：</span> ${activityOrder.orderNumber}</p>
          <p><span>活动：</span> <c:out escapeXml="true" value="${activity.activityName}"/></p>
          <p><span>时间：</span> ${activityOrder.eventDateTime}</p>
          <p><span>地址：</span> <c:out escapeXml="true" value="${activity.activityAddress}"/></p>
          <c:if test="${not empty activityOrder.orderSummary}" >
            <p><span>座位：</span>
                ${seatValues}
            </p>
          </c:if>
          <c:if test="${empty activityOrder.orderSummary}" >
            <p><span>订票数：</span>
                ${activityOrder.orderVotes}
            </p>
          </c:if>
          <%--<p><span>总价：</span><b class="lightred">¥${activityOrder.orderPrice}</b></p>--%>
          <p><span>手机：</span><b>${activityOrder.orderPhoneNo}</b></p>
          <!----<p><input type="checkbox" id="sendCodeToMobile"/><label for="sendCodeToMobile">发送验证码到手机</label></p>--->
        </div>
      </div>
      <div class="confirm_box">
        <input type="button" class="confirm_order" onclick="doSubmit();" value="确认订单"/>
      </div>
    </div>
    <!--one end-->
  </form>
</div>

</body>
</html>
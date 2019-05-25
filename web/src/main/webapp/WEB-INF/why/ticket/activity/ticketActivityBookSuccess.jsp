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
</head>
<body style="background: #eef4f7;">

<!-- ticket_top start -->
<%@include file="/WEB-INF/why/ticket/ticket-nav.jsp"%>
<script type="text/javascript" src="${path}/STATIC/js/ticket/activity/ticketActivitySelectTopLabel.js"></script>
<!-- ticket_top end -->

<script type="text/javascript">

 function ticketOutLogin() {
            $.post("${path}/frontTerminalUser/outLogin.do", function (result) {
                if (result == "success") {
                    //location.href='${path}/ticketActivity/ticketActivityList.do';
                	  parent.location.reload();
                } else {
                    alert("退出失败");
                }
            });
        }
</script>

<input type="hidden" value="${activityOrderId}" name="activityOrderId" id="activityOrderId" />
<input type="hidden" value="${activity.activityName}" name="activityName" />
<input type="hidden" value="${eventDateTime}" name="eventDateTime" />
<input type="hidden" value="${activity.activityAddress}" name="activityAddress" />
<input type="hidden" value="${activityOrder.orderSummary}" name="orderSummary" />
<input type="hidden" value="${seatValues}" name="seatValues" />
<input type="hidden" value="${fn:substringAfter(activity.activityCity, ',')}" name="activityCity"/>
<input type="hidden" value="${fn:substringAfter(activity.activityArea, ',')}" name="activityArea"/>
<div class="register-content ticket-activity-book">
    <div class="steps steps-activity">
        <ul class="clearfix">
            <li class="step_1 visited_pre">1.填写基本信息<i class="tab_status"></i></li>
            <li class="step_2 visited_pre">2.选择座位<i class="tab_status"></i></li>
            <li class="step_3 visited_pre">3.填写取票信息<i class="tab_status"></i></li>
            <li class="step_4 finish">4.确认订单信息<i class="tab_status"></i></li>
            <li class="step_5 end">5.完成预定</li>
        </ul>
    </div>
    <!--btn start-->
    <div class="register-part part3 clearfix">
        <div class="part3-box1">
            <div class="box1a">
                <a class="return" href="${path}/ticketActivity/ticketActivityBook.do?activityId=${activityId}">&lt;返回活动预订详情</a>
                <a class="orange" href="${path}/ticketUserActivity/ticketUserActivity.do">查看我的活动&gt;</a>
            </div>
            <div class="register-text">
                <img src="${path}/STATIC/image/transparent.gif">
                <span>恭喜您<br/>${activityName}<br />已预订成功！</span>
                 
                 <div style="width:350px;height:70;margin: 30px auto 0;cursor:pointer;" onclick="javascript:ticketOutLogin();">
                 	<img src="${path}/STATIC/image/logout.jpg" style="width:auto;height:auto;"></img>
                 </div>
            </div>
        </div>
    </div>
    <!--btn end-->
</div>

</body>
</html>
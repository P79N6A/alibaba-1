<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<title>取票机--活动室预订--文化云</title>
	<%@include file="/WEB-INF/why/common/ticketFrame.jsp"%>
	<script type="text/javascript" src="${path}/STATIC/js/ticket/room/ticketRoomBookSuccess.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/ticket/venue/ticketVenueSelectedLabel.js"></script>

	<script type="text/javascript">
		$(function() {
			$(".confirm_order").on("click", function(){
				var html = '<div class="btn-loading" id="btn-tip-loading"><h3>正在提交，请稍等...</h3><div class="img"></div></div>';
				$(this).parent().append(html);
				return false;
			});
		});
	</script>
</head>
<body style="background: #eef4f7;">

<%--导航--%>
<%@include file="../ticket-nav.jsp"%>

<div class="register-content ticket-activity-book ticket-room-book">
	<div class="steps steps-activity">
		<ul class="clearfix">
			<li class="step_1 visited_pre">1.填写基本信息<i class="tab_status"></i></li>
			<li class="step_2 visited_pre">2.填写预订人信息<i class="tab_status"></i></li>
			<li class="step_3 finish">3.确认订单<i class="tab_status"></i></li>
			<li class="step_4 end">4.完成预定</li>
		</ul>
	</div>
	<!--btn start-->
	<div class="register-part part3 clearfix">
		<div class="part3-box1">
			<div class="box1a">
				<form action="${path}/ticketRoom/roomDetail.do" id="roomDetailForm" method="get">
					<input type="hidden" id="roomId" name="roomId" value="${cmsActivityRoom.roomId}"/>
					<input type="hidden" id="tmpVenueId" name="venueId" value="${cmsVenue.venueId}"/>
				</form>
				<a class="return"  href="javascript:;" onclick="subRoomDetail()">&lt;返回场馆预订详情</a>
				<a class="orange" href="${path}/ticketRoomOrder/queryRoomOrder.do">查看我的场馆&gt;</a>
			</div>
			<div class="register-text">
				<img src="${path}/STATIC/image/transparent.gif">
				<span>恭喜您<br />${cmsVenue.venueName} ${cmsActivityRoom.roomName}<br />已预订成功！</span>
			</div>
		</div>
	</div>
	<!--btn end-->
</div>

</body>
</html>
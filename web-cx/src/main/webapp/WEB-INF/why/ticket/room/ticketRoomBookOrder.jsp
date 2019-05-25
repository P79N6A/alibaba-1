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
	<script type="text/javascript" src="${path}/STATIC/js/ticket/room/ticketRoomBookOrder.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/ticket/venue/ticketVenueSelectedLabel.js"></script>

	<script type="text/javascript">
		/**
		 *提交订单之前再次检查活动室是否被预订
		 */
		function checkOrder(){
			var html = '<div class="btn-loading" id="btn-tip-loading"><h3>正在提交，请稍等...</h3><div class="img"></div></div>';
			$("#subOrderConfirm").parent().append(html);

			//保存团体信息
			$.post("${path}/ticketRoom/roomOrderCheck.do", $("#roomOrderConfirmForm").serialize(),
				function(text) {
					var data=$.parseJSON(text);
					if (data!=null && data.status) {
						//应产品需求，预订成功不弹窗
						//alert("活动室预订成功!");
						//移除提交订单的点击事件
						$("#sysId").val(data.sysId);
						$("#sysNo").val(data.sysNo);
						$("#subOrderConfirm").removeAttr("onclick");
						$("#roomOrderConfirmForm").submit()
					} else {
						if(!data.status){
							dialogAlert("提示","预订失败:"+data.msg);
						}else{
							dialogAlert("提示",data.msg);
						}
						$(".btn-loading").remove();
					}
				});
		}
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
			<li class="step_3 active">3.确认订单<i class="tab_status"></i></li>
			<li class="step_4">4.完成预定</li>
		</ul>
	</div>
	<form action="${path}/ticketRoom/roomOrderConfirm.do" method="post" id="roomOrderConfirmForm">
		<!--one start-->
		<div class="room-part3">
			<h1>确认订单信息</h1>
			<div class="room-order-info activity-order-info">
				<div class="img fl">
					<img id="roomImg" width="450" height="300" data-id="${cmsActivityRoom.roomPicUrl}"/>
				</div>
				<div class="details fr">
					<p><span>订单号：</span> ${cmsRoomBook.orderNo}</p>
					<p><span>活动室：</span>  ${cmsActivityRoom.roomName}</p>
					<p><span>时间：</span> <fmt:formatDate value="${cmsRoomBook.curDate}" pattern="yyyy-MM-dd"></fmt:formatDate>${cmsRoomBook.openPeriod}</p>
					<p><span>地址：</span> ${fn:substringAfter(cmsVenue.venueCity, ',')}&nbsp;${fn:substringAfter(cmsVenue.venueArea, ',')}&nbsp;${cmsVenue.venueAddress}&nbsp;${cmsActivityRoom.roomNo}<%--<span id="areaSpan"></span>--%></p>
					<p><span>团体：</span> ${tuserName}</p>
					<p><span>手机：</span>${cmsRoomBook.userTel}</p>
					<input type="hidden" id="bookId" name="bookId" value="${cmsRoomBook.bookId}">
					<input type="hidden" id="orderNo" name="orderNo" value="${cmsRoomBook.orderNo}">
					<input type="hidden" id="userName" name="userName" value="${cmsRoomBook.userName}">
					<input type="hidden" id="userTel" name="userTel" value="${cmsRoomBook.userTel}">
					<input type="hidden" id="tuserId" name="tuserId" value="${cmsRoomBook.tuserId}">
					<input type="hidden" id="sysId" name="sysId" value="">
					<input type="hidden" id="sysNo" name="sysNo" value="">
				</div>
			</div>
			<div class="confirm_box">
				<%--<a class="go-back" href="javascript:;" onclick="singleRoomBook('${cmsRoomBook.roomId}','${cmsRoomBook.bookId}','${cmsRoomBook.tuserId}','${cmsRoomBook.userTel}')">< 返回修改信息</a>--%>
				<div class="confirm_box">
					<input class="confirm_order" type="button" value="确认订单" id="subOrderConfirm" onclick="checkOrder()"/>
				</div>
			</div>
		</div>
		<!--one end-->
	</form>

	<form action="${path}/ticketRoom/roomBook.do" id="roomBookForm" method="post">
		<input type="hidden" id="roomId2" name="roomId"/>
		<input type="hidden" id="bookId2" name="bookId"/>
		<input type="hidden" id="tuserId2" name="tuserId"/>
		<input type="hidden" id="userTel2" name="userTel"/>
	</form>
</div>

</body>
</html>
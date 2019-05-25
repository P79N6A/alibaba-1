<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<title>活动室预订-预订成功--文化云</title>

	<%@include file="../../common/frontPageFrame.jsp"%>

	<script type="text/javascript" src="${path}/STATIC/js/index/room/roomBookResultFront.js"></script>
</head>
<body>

<%@include file="../list_top.jsp"%>

<div id="register-content">
	<div class="register-content">
		<div class="steps steps-room">
			<ul class="clearfix">
				<li class="step_1 visited_pre">1.填写基本预订信息<i class="tab_status"></i></li>
				<li class="step_2 visited_pre">2.预订人信息<i class="tab_status"></i></li>
				<li class="step_3 visited_pre">3.提交订单<i class="tab_status"></i></li>
				<li class="step_4 active">4.完成预订</li>
			</ul>
		</div>
		<div class="register-part part3">
			<div class="part3-box1">
				<div class="register-text">
					<i></i>
					<input type="hidden" id="venueCity" value="${cmsVenue.venueCity}">
					<input type="hidden" id="venueArea" value="${cmsVenue.venueArea}">
					<input type="hidden" id="venueAddress" value="${cmsVenue.venueAddress}">
					<p>恭喜您，<span id="areaSpan"></span> ${cmsVenue.venueName} ${cmsActivityRoom.roomName} 已成功预订！</p>
					<p class="f12">
						<form action="${path}/frontRoom/roomDetail.do" id="roomDetailForm" method="post">
							<input type="hidden" id="roomId" name="roomId" value="${cmsActivityRoom.roomId}"/>
							<input type="hidden" id="tmpVenueId" name="venueId" value="${cmsVenue.venueId}"/>
						</form>
						<a href="javascript:;" onclick="subRoomDetail()">< 返回活动室详情页 </a>
						<a class="lightred" href="${path}/roomOrder/queryRoomOrder.do">查看我的预订</a>
					</p>
				</div>
			</div>
			<div class="part3-box2">
				<div class="bdsharebuttonbox">
					<span>分享：</span>
					<a href="#" class="bds_qzone" data-cmd="qzone" title="分享到QQ空间"></a>
					<a href="#" class="bds_tsina" data-cmd="tsina" title="分享到新浪微博"></a>
					<a href="#" class="bds_tqq" data-cmd="tqq" title="分享到腾讯微博"></a>
					<a href="#" class="bds_renren" data-cmd="renren" title="分享到人人网"></a>
					<a href="#" class="bds_weixin" data-cmd="weixin" title="分享到微信"></a>
					<a href="#" class="bds_more" data-cmd="more"></a>
				</div>
				<script>
					window._bd_share_config={
						"common":{
							"bdSnsKey":{},
							"bdText":"",
							"bdMini":"2",
							"bdMiniList":false,
							"bdPic":"",
							"bdStyle":"0",
							"bdSize":"16"
						},
						"share":{}
					};
					with(document)0[(getElementsByTagName('head')[0]||body).appendChild(createElement('script')).src='http://bdimg.share.baidu.com/static/api/js/share.js?v=89860593.js?cdnversion='+~(-new Date()/36e5)];
				</script>
			</div>
		</div>
	</div>
</div>

<%@include file="../index_foot.jsp"%>

</body>
</html>>
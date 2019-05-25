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

<%@include file="../index_top.jsp"%>

<div id="register-content">
	<div class="register-content">
		<div class="steps steps-room">
			<ul class="clearfix">
				<li class="step_1 visited_pre">1.填写基本信息<i class="tab_status"></i></li>
				<li class="step_2 visited_pre">2.填写预订人信息<i class="tab_status"></i></li>
				<li class="step_3 finish">3.确认订单<i class="tab_status"></i></li>
				<li class="step_4 end">4.完成预定</li>
			</ul>
		</div>
		<!--do start-->
		<div class="register-part part3">
			<div class="part3-box1">
				<div class="box1a">
					<form action="${path}/frontRoom/roomDetail.do" id="roomDetailForm" method="get">
						<input type="hidden" id="roomId" name="roomId" value="${cmsActivityRoom.roomId}"/>
						<input type="hidden" id="tmpVenueId" name="venueId" value="${cmsVenue.venueId}"/>
					</form>
					<a class="return" href="javascript:;" onclick="subRoomDetail()">&lt;返回活动室详情页</a>
					<a class="orange" href="${path}/roomOrder/queryRoomOrder.do">查看我的预订&gt;</a>
				</div>
				<div class="register-text">
					<img src="${path}/STATIC/image/transparent.gif">
					<span>恭喜您<br />${cmsVenue.venueName} ${cmsActivityRoom.roomName}<br />已预订成功！</span>
				</div>
			</div>
			<div class="part3-box2">
				<div class="bdsharebuttonbox bdshare-button-style0-16" data-bd-bind="1449817749456">
					<span>分享</span>
					<a href="#" class="bds_sqq" data-cmd="sqq" title="分享到QQ好友"></a>
					<a href="#" class="bds_tsina" data-cmd="tsina" title="分享到新浪微博"></a>
					<a href="#" class="bds_weixin" data-cmd="weixin" title="分享到微信"></a>
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
		<!--do end-->
	</div>
</div>

<%@include file="../index_foot.jsp"%>

</body>
</html>>
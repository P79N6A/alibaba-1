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
	<title>取票机--藏品详情--文化云</title>
	<%@include file="/WEB-INF/why/common/ticketFrame.jsp"%>
	<script type="text/javascript" src="${path}/STATIC/js/ticket/antique/ticketAntiqueDetail.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/ticket/venue/ticketVenueSelectedLabel.js"></script>
	<!-- 语音解说 start -->
	<script type="text/javascript" src="${path}/STATIC/js/audio.min.js"></script>
	<script type="text/javascript">
		audiojs.events.ready(function() {
			audiojs.createAll();
		});
		$(function(){
			$(".play-btn").click(function(){
				var $triangle = $(this).siblings("b");
				var $audio =  $("#audio-box");
				if($audio.is(":visible")){
					$triangle.hide();
					$audio.hide();
				}else{
					$triangle.show();
					$audio.show();
				}
			});
			/*$("#zan-btn").click(function(){
				var $this = $(this);
				var num = parseInt($this.text());
				if($this.hasClass("love")){
					$this.removeClass("love");
					$this.text(--num);
				}else{
					$this.addClass("love");
					$this.text(++num);
				}
			});*/
		});
	</script>
	<!-- 语音解说 end -->
</head>
<body style="background: #eef4f7;">

<%--导航--%>
<%@include file="../ticket-nav.jsp"%>

<!--con start-->
<div class="detail-content ticket-activity-detail">
	<!--left start-->
	<div class="detail-left fl">
		<!--the_one start-->
		<div class="the_one">
			<!--time start-->
			<div class="a_time">
				<span><fmt:formatDate value="${cmsAntique.antiqueCreateTime}" pattern="yyyy-MM-dd HH:mm" /></span>&nbsp;&nbsp;/&nbsp;
				收藏：<span id="likeCount"></span>&nbsp;&nbsp;/&nbsp;
				浏览：<span><c:if test="${statistics.yearBrowseCount != null}">${statistics.yearBrowseCount}</c:if><c:if test="${statistics.yearBrowseCount == null}">0</c:if></span>
			</div>
			<!--time end-->
			<div class="a_note">
				<!--time start-->
				<div class="title">
					<h1>${cmsAntique.antiqueName}</h1>
				</div>
				<!--time end-->
				<div class="address v_address">
					<div class="vl_img fl"><a href="#"><img id="antiqueImg" data-id="${cmsAntique.antiqueImgUrl}" width="400" height="270"/></a></div>
					<div class="al_r fl">
						<!--do start-->
						<c:if test="${not empty cmsAntique.antiqueVoiceUrl || not empty cmsAntique.antique3dUrl}">
							<div class="commentary">
								<ul>
									<c:if test="${not empty cmsAntique.antiqueVoiceUrl}">
										<li class="voice fl">
											<input type="hidden" id="venueVoiceUrl" value="${cmsAntique.antiqueVoiceUrl}">
											<a href="javascript:;" class="play-btn"><img src="${path}/STATIC/image/v_icon2.png" width="52" height="50"/></a>语言解说<b></b>
										</li>
									</c:if>
									<li class="fl m_r">
										<c:if test="${not empty cmsAntique.antique3dUrl}">
											<a href="${cmsAntique.antique3dUrl}"><img src="${path}/STATIC/image/v_icon3.png" width="52" height="50"/></a>三维讲解
										</c:if>
									</li>
								</ul>
								<c:if test="${not empty cmsAntique.antiqueVoiceUrl}">
									<div class="audio-box" id="audio-box"><audio preload="auto" id="audioPlay"></audio></div>
								</c:if>
							</div>
						</c:if>
						<!--do end-->
						<div class="list">
							<p class="site"><span>${cmsAntique.antiqueSpecification}</span></p>
							<p class="home"><span>${cmsVenue.venueName}</span></p>
							<p class="period"><span>${cmsAntique.dynastyName}</span></p>
						</div>
					</div>
				</div>
				<!--detail_intro start-->
				<div class="ad_intro">
					<p>${cmsAntique.antiqueRemark}</p>
				</div>
				<!--detail_intro end-->
				<!--share start-->
				<div class="shares" style="border-bottom:none;">
					<!--left start-->
					<div class="share_l fr">
						<a class="zan fl" id="zan-btn" onclick="changeClass()"></a>
					</div>
					<!--left end-->
				</div>
				<!--share end-->
			</div>
		</div>
		<!--the_one end-->
	</div>
	<!--left end-->
	<!--right start-->
	<div class="detail_right fr">
		<!--map start-->
		<div class="map mb20">
			<div id="map-site"></div>
			<script type="text/javascript" src="http://webapi.amap.com/maps?v=1.3&amp;key=de421f9a41545db0c1c39cbb84f32163"></script>
			<script type="text/javascript">
				var map, marker;
				//初始化地图对象，加载地图
				map = new AMap.Map("map-site",{
					resizeEnable: true,
					//二维地图显示视口
					view: new AMap.View2D({
						center:new AMap.LngLat(${cmsVenue.venueLon}, ${cmsVenue.venueLat}),//地图中心点
						zoom:19 //地图显示的缩放级别
					})
				});
				//实例化点标记
				marker = new AMap.Marker({
					//复杂图标
					/* icon: new AMap.Icon({
					 //图标大小
					 size:new AMap.Size(32,39),
					 //大图地址
					 image:"image/map-icon1.png"
					 }),
					 position:new AMap.LngLat(121.452481,31.23504)*/
					position:map.getCenter()
				});
				marker.setMap(map);  //在地图上添加点
			</script>
		</div>
		<!--map end-->
		<!--馆藏 start-->
		<div class="recommend mb20 p_bottom" id="antique-list-div">
			<div class="tit fd_bg">推荐馆藏</div>
			<!--list start-->
			<ul class="recommend-collection">

			</ul>
			<form action="${path}/ticketAntique/antiqueDetail.do" id="antiqueDetailForm" method="get">
				<input type="hidden" id="antiqueId" name="antiqueId" value="${cmsAntique.antiqueId}"/>
				<input type="hidden" id="venueId" value="${cmsVenue.venueId}"/>
			</form>
			<!--list end-->
		</div>
		<!--馆藏 end-->
	</div>
	<!--right end-->
</div>
<!--con end-->
<c:if test="${not empty sessionScope.terminalUser}">
	<input type="hidden" id="isLogin" value="1"/>
</c:if>
</body>
</html>
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
	<title>藏品详情--文化云</title>
	<%@include file="../../common/frontPageFrame.jsp"%>
	<script type="text/javascript" src="${path}/STATIC/js/audio.min.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/index/antique/antiqueDetailFront.js?version=20151215"></script>
	<script type="text/javascript">
		$(function() {
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

			//选中标签时，异步加载场馆数据
			$("#area-div a").click(function () {
				var areaData = $(this).attr("data-option");
				window.location.href="${path}/frontAntique/antiqueList.do?area="+areaData;
			});
			//选中标签时，异步加载场馆数据
			$("#dict-div a").click(function () {
				var dictData = $(this).attr("data-option");
				window.location.href="${path}/frontAntique/antiqueList.do?dynasty="+dictData;
			});
		});

		/*跳转到列表*/
		function toList(){
			var key =  $("#keyword").val() == "请输入关键词" ? "" : $("#keyword").val();
			if($.trim(key)!=""){
				window.location.href="${path}/frontAntique/antiqueList.do?key="+key;
			}
		}

		//失去焦点执行
		$(function(){
			$('#keyword').blur(function(){
				toList();
			});
		});
		//回车执行
		document.onkeydown=keyDownLogin;
		function keyDownLogin(e) {
			var theEvent = e || window.event;
			var code = theEvent.keyCode || theEvent.which || theEvent.charCode;
			if (code == 13) {
				toList();
				return false;
			}
			return true;
		}
	</script>

	<!-- 语音解说 end -->
</head>
<body>
<%@include file="../index_top.jsp"%>

<!--活动详情 start-->
<!--tit start-->
<div class="crumb">您所在的位置：<a href="${path}/frontVenue/venueIndex.do">场馆</a>&gt; <a href="${path}/frontVenue/venueDetail.do?venueId=${cmsVenue.venueId}">${cmsVenue.venueName}</a>&gt; ${cmsAntique.antiqueName}</div>
<!--con start-->
<div class="detail-content">
	<!--left start-->
	<div class="detail-left fl">
		<!--the_one start-->
		<div class="the_one">
			<!--time start-->
			<div class="a_time">
				<span><fmt:formatDate value="${cmsAntique.antiqueCreateTime}" pattern="yyyy-MM-dd HH:mm" /></span>&nbsp;&nbsp;/&nbsp;
				收藏：<span  id="likeCount"></span>&nbsp;&nbsp;/&nbsp;
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
					<div class="vl_img fl"><a href="javascript:;"><img id="antiqueImg" data-id="${cmsAntique.antiqueImgUrl}" width="400" height="264"/></a></div>
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
											<a href="${cmsAntique.antique3dUrl}" target="_blank"><img src="${path}/STATIC/image/v_icon3.png" width="52" height="50"/></a>三维讲解
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
						<%--<a class="zan fl" id="zanId" onclick="changeClass()"></a>--%>
						 <a class="zan fl" id="zanId" onclick="changeClass()"></a>
						 <span class="bdsharebuttonbox fl">
							<a class="share" data-cmd="count"></a>
						 </span>
						<!--分享代码 start-->
							<script type="text/javascript">
								with(document)0[(getElementsByTagName('head')[0]||body).appendChild(createElement('script')).src='http://bdimg.share.baidu.com/static/api/js/share.js?v=89860593.js?cdnversion='+~(-new Date()/36e5)];
							</script>
						<!--分享代码 end-->
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
			<div id="map-site" class="amap-container"><div class="amap-maps"><div class="amap-drags"><div class="amap-layers" style="-webkit-transform: translateZ(0px);"><div style="position: absolute; z-index: 0; top: 107.5px; left: 160px;"><canvas height="256" width="256" style="position: absolute; top: -16px; left: 1px; width: 256px; height: 256px; z-index: 18;"></canvas><canvas height="256" width="256" style="position: absolute; top: -272px; left: 1px; width: 256px; height: 256px; z-index: 18;"></canvas><canvas height="256" width="256" style="position: absolute; top: -16px; left: -255px; width: 256px; height: 256px; z-index: 18;"></canvas><canvas height="256" width="256" style="position: absolute; top: -272px; left: -255px; width: 256px; height: 256px; z-index: 18;"></canvas></div><canvas width="320" height="215" style="position: absolute; z-index: 1; height: 215px; width: 320px; top: 0px; left: 0px;"></canvas><div style="position: absolute; z-index: 120; top: 107.5px; left: 160px;"><div class="amap-marker" style="top: -31px; left: -9px; z-index: 100; -webkit-transform: translate(9px, 31px) rotate(0deg) translate(-9px, -31px); display: block;"><div class="amap-icon" style="position: absolute; width: 19px; height: 33px; opacity: 1;"><img src="http://webapi.amap.com/theme/v1.3/markers/n/mark_bs.png" style="width: 19px; height: 33px; top: 0px; left: 0px;"></div></div></div></div><div class="amap-overlays"></div></div></div><div style="display: none;"></div><div class="amap-controls"></div><a class="amap-logo" href="http://gaode.com" target="_blank"><img src="http://webapi.amap.com/theme/v1.3/autonavi.png"></a><div class="amap-copyright"></div></div>
			<script type="text/javascript" src="http://webapi.amap.com/maps?v=1.3&amp;key=de421f9a41545db0c1c39cbb84f32163"></script>
			<script type="text/javascript">
				// 百度地图API功能
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
			<!--list end-->
			<form action="${path}/frontAntique/antiqueDetail.do" id="antiqueDetailForm" method="get">
				<input type="hidden" id="antiqueId" name="antiqueId" value="${cmsAntique.antiqueId}"/>
				<input type="hidden" id="venueId" value="${cmsVenue.venueId}"/>
			</form>
		</div>
		<!--馆藏 end-->
	</div>
	<!--right end-->
</div>
<!--con end-->
<!--活动详情 end-->
<c:if test="${not empty sessionScope.terminalUser}">
	<input type="hidden" id="isLogin" value="1"/>
</c:if>
<%@include file="../index_foot.jsp"%>
</body>
</html>
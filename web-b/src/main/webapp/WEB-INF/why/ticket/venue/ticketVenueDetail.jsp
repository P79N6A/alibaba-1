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
	<title>取票机--活动详情--文化云</title>
	<%@include file="/WEB-INF/why/common/ticketFrame.jsp"%>
	<script type="text/javascript" src="${path}/STATIC/js/ticket/venue/ticketVenueDetail.js"></script>
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
		});
	</script>
	<!-- 语音解说 end -->
</head>
<body style="background: #eef4f7;">

<%--导航--%>
<%@include file="../ticket-nav.jsp"%>

<form action="${path}/ticketVenue/venueDetail.do"  id="venueDetailForm" method="get">
	<input type="hidden" id="detailVenueId" name="venueId" value="${cmsVenue.venueId}"/>
</form>
<input type="hidden" id="venueId" name="venueId" value="${cmsVenue.venueId}"/>
<!--con start-->
<div class="detail-content ticket-activity-detail">
	<!--left start-->
	<div class="detail-left fl">
		<!--the_one start-->
		<div class="the_one">
			<!--time start-->
			<div class="a_time">收藏：<span  id="likeCount">0</span>&nbsp;&nbsp;/&nbsp;浏览：
				<span>
					<c:if test="${statistics.yearBrowseCount != null}">
						${statistics.yearBrowseCount}
					</c:if>
					<c:if test="${statistics.yearBrowseCount == null}">
						0
					</c:if>
				</span>
			</div>
			<!--time end-->
			<div class="a_note">
				<!--time start-->
				<div class="title">
					<h2 class="fl"><c:out escapeXml="true" value="${cmsVenue.venueName}"/></h2>
					<div class="w_star fl" id="${c.venueId}">
						<div class="start fl" tip="${cmsVenue.venueStars}"><p></p></div>
						<span class="txt fl">${cmsVenue.venueStars}分</span>
					</div>
				</div>
				<!--time end-->
				<div class="tag">
					<c:forEach items="${typeList}" var="c">
						<a href="javascript:;">${c.tagName}</a>
					</c:forEach>
					<c:if test="${not empty location}">
						<a href="javascript:;">${location.dictName}</a>
					</c:if>
				</div>
				<div class="address v_address">
					<div class="vl_img fl"><img data-id="${cmsVenue.venueIconUrl}" src="${path}/STATIC/image/v1_img.png" width="400" height="264"/></div>
					<div class="al_r fl">
						<!--do start-->
						<c:if test="${not empty cmsVenue.venuePanorama || not empty cmsVenue.venueVoiceUrl || not empty cmsVenue.venueRoamUrl}">
							<div class="commentary">
								<ul>
									<c:if test="${not empty cmsVenue.venuePanorama}">
										<li class="fl">
											<a onclick="showPanorama('${cmsVenue.venuePanorama}');" id="map_display">
												<img src="${path}/STATIC/image/v_icon1.png" width="52" height="50"/>
											</a>
											<span>360全景</span>
										</li>
									</c:if>
									<c:if test="${not empty cmsVenue.venueVoiceUrl}">
										<li class="voice fl">
											<input type="hidden" id="venueVoiceUrl" value="${cmsVenue.venueVoiceUrl}">
											<a class="play-btn"><img src="${path}/STATIC/image/v_icon2.png" width="52" height="50"/></a><span>语音解说</span><b></b>
										</li>
									</c:if>
									<c:if test="${not empty cmsVenue.venueRoamUrl}">
										<li class="fl m_r">
											<a  href="${cmsVenue.venueRoamUrl}" target="_blank"><img src="${path}/STATIC/image/v_icon3.png" width="52" height="50"/></a><span>三维讲解</span>
										</li>
									</c:if>
								</ul>
								<c:if test="${not empty cmsVenue.venueVoiceUrl}">
									<div class="audio-box" id="audio-box"><audio preload="auto" id="audioPlay"></audio></div>
								</c:if>
							</div>
						</c:if>
						<!--do end-->
						<div class="list">
							<p class="site">
								<input type="hidden" id="venueCity" value="${cmsVenue.venueCity}">
								<input type="hidden" id="venueArea" value="${cmsVenue.venueArea}">
								<input type="hidden" id="venueAddress" value="${cmsVenue.venueAddress}">
								<span id="areaSpan"></span>
							</p>
							<c:if test="${cmsVenue.venueOpenTime != null && cmsVenue.venueEndTime != null}">
								<p class="time">
									<span>${venueTime} ${cmsVenue.venueOpenTime}-${cmsVenue.venueEndTime}</span>
								</p>
							</c:if>
							<c:if test="${not empty cmsVenue.openNotice}">
								<p style="height: auto;">注：<c:out escapeXml="true" value="${cmsVenue.openNotice}"/></p>
							</c:if>
							<p class="phone"><span>${cmsVenue.venueMobile}</span></p>
							<p class="free">
								<span>
									<c:if test="${cmsVenue.venueIsFree == 1}">
										免费
									</c:if>
									<c:if test="${cmsVenue.venueIsFree == 2}">
										${cmsVenue.venuePrice}
									</c:if>
								</span>
							</p>

							<c:choose>
								<c:when test="${cmsVenue.venueHasMetro == 2 && cmsVenue.venueHasBus == 2 }"><p class="traffic"><span>地铁</span>；<span>公交</span></p></c:when>
								<c:when test="${cmsVenue.venueHasMetro == 2 && cmsVenue.venueHasBus == 1}"><p class="traffic"><span>地铁</span></p></c:when>
								<c:when test="${cmsVenue.venueHasMetro == 1 && cmsVenue.venueHasBus == 2}"><p class="traffic"><span>公交</span></p></c:when>
								<c:otherwise></c:otherwise>
							</c:choose>
						</div>
					</div>
				</div>
				<!--detail_intro start-->
				<div class="ad_intro">
					<p>${cmsVenue.venueMemo}</p>
				</div>
				<!--detail_intro end-->
				<!--share start-->
				<div class="shares">
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
		<!--the_two start-->
		<div class="the_two">
			<!--评论start-->
			<div class="comment mt20 clearfix">
				<a name="comment"></a>
				<div class="comment-list" id="comment-list-div">
					<ul id="lrk_listpl">

					</ul>
					<c:if test="${commentCount >= 5}">
						<a href="javascript:void(0)" class="load-more" id="viewMore">查看更多></a>
						<input type="hidden" id="commentPageNum" value="1"/>
					</c:if>
				</div>
			</div>
			<!--评论end-->
		</div>
		<!--the_two end-->
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
					 image:"${path}/STATIC/image/map-icon1.png"
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
			<a href="${path}/ticketAntique/antiqueList.do?venueId=${cmsVenue.venueId}" class="load-more">查看更多></a>
			<form action="${path}/ticketAntique/antiqueDetail.do" id="antiqueDetailForm" method="get">
				<input type="hidden" id="antiqueId" name="antiqueId"/>
			</form>
			<!--list end-->
		</div>
		<!--馆藏 end-->
		<!--推荐活动室 start-->
		<div class="recommend mb20 p_bottom" id="room-list-div">
			<div class="tit fd_bg">推荐活动室</div>
			<!--list start-->
			<ul class="ra_room">

			</ul>
			<a id="roomViewMore" onclick="loadMoreRoom()" style="display: none;" class="load-more"  style="margin-top:15px;">查看更多></a>
			<input type="hidden" id="roomPageNum" value="1"/>
			<form action="${path}/ticketRoom/roomDetail.do" id="roomDetailForm" method="get">
				<input type="hidden" id="roomId" name="roomId"/>
			</form>
			<form action="${path}/ticketRoom/roomBook.do" id="roomBookForm" method="post">
				<input type="hidden" id="roomId2" name="roomId"/>
			</form>
			<!--list end-->
		</div>
		<!--推荐活动室 end--
          <!--推荐场馆 start-->
		<div class="recommend mb20 p_bottom" id="venue-list-div">
			<div class="tit fd_bg">推荐场馆</div>
			<!--list start-->
			<ul class="ra_room">

			</ul>
			<!--list end-->
		</div>
		<!--推荐场馆 end-->
		<c:if test="${not empty sessionScope.terminalUser}">
			<input type="hidden" id="isLogin" value="1"/>
			<input type="hidden" id="accountStatus" value="${sessionScope.terminalUser.commentStatus}"/>
			<input type="hidden" id="teamUserSize" value="${fn:length(teamUserList)}"/>
			<input type="hidden" id="teamUserType" value="${sessionScope.terminalUser.userType}"/>
		</c:if>
	</div>
	<!--right end-->
</div>
<!--con end-->

<!--360全景图 start-->
<div id="panorama"></div>
<!--360全景图 end-->
<script type="text/javascript">
	/*星星个数*/
	$(function(){
		function starts(obj,n){
			for(i=0;i<obj.length;i++){
				var num=parseFloat($(obj[i]).attr("tip"));
				var width=num*n;
				$(obj[i]).children("p").css("width",width);
			}
		}
		starts($(".start"),28);
	})
</script>

</body>
</html>
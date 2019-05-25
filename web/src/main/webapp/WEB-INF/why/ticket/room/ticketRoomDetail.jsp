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
	<title>取票机--活动室详情--文化云</title>
	<%@include file="/WEB-INF/why/common/ticketFrame.jsp"%>

	<script type="text/javascript" src="${path}/STATIC/js/ticket/room/ticketRoomDetail.js"></script>
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
			$("#zan-btn").click(function(){
				var $this = $(this);
				var num = parseInt($this.text());
				if($this.hasClass("love")){
					$this.removeClass("love");
					$this.text(--num);
				}else{
					$this.addClass("love");
					$this.text(++num);
				}
			});
		});
	</script>
	<!-- 语音解说 end -->
</head>
<body style="background: #eef4f7;">

<%--导航--%>
<%@include file="../ticket-nav.jsp"%>

<!--con start-->
<div class="detail-content ticket-activity-detail clearfix">
	<!--left start-->
	<div class="detail-left fl">
		<!--the_one start-->
		<div class="the_one">
			<!--time start-->
			<div class="a_time">
				<%--收藏：<span>287</span>&nbsp;&nbsp;/&nbsp;浏览：<span>3256</span>--%>
			</div>
			<!--time end-->
			<div class="a_note">
				<!--time start-->
				<div class="title room_top">
					<h1>${cmsActivityRoom.roomName}</h1>
				</div>
				<!--time end-->
				<div class="tag">
					<c:forEach items="${tagList}" var="t">
						<a href="javascript:;">${t.tagName}</a>
					</c:forEach>
				</div>
				<!--room_con start-->
				<div class="ar_room_con">
					<div class="room_img">
						<a href="javascript:;">
							<img id="roomPic" data-id="${cmsActivityRoom.roomPicUrl}" width="741" height="556"/>
						</a>
					</div>
					<!--txt start-->
					<div class="room_con">
						<input type="hidden" id="venueCity" value="${cmsVenue.venueCity}">
						<input type="hidden" id="venueArea" value="${cmsVenue.venueArea}">
						<input type="hidden" id="venueAddress" value="${cmsVenue.venueAddress}">
						<p id="areaSpan">地址：${cmsActivityRoom.roomNo}</p>
						<%--<p>时间：每天10:00-18:00</p>--%>
						<p>电话：${cmsActivityRoom.roomConsultTel}</p>
						<p>费用：
							<c:if test="${cmsActivityRoom.roomIsFree == 1}">
								免费
							</c:if>
							<c:if test="${cmsActivityRoom.roomIsFree == 2}">
								${cmsActivityRoom.roomFee}
							</c:if>
						</p>
						<c:if test="${not empty cmsActivityRoom.roomArea}">
							<p>面积：${cmsActivityRoom.roomArea}㎡</p>
						</c:if>
						<c:if test="${not empty cmsActivityRoom.roomCapacity}">
							<p>人数：${cmsActivityRoom.roomCapacity}人</p>
						</c:if>
						<p class="equip">设备：
							<c:choose>
								<c:when test="${not empty facList}">
									<c:forEach items="${facList}" var="f" varStatus="st">
										<label><img src="${path}/STATIC/image/facIco.gif">${f.dictName}</label>
									</c:forEach>
								</c:when>
								<c:otherwise>无</c:otherwise>
							</c:choose>
						</p>
						<c:if test="${not empty cmsActivityRoom.roomIntro}">
							<p>简介：${cmsActivityRoom.roomIntro}</p>
						</c:if>
						<c:if test="${not empty cmsActivityRoom.roomRemark}">
							<p>备注：${cmsActivityRoom.roomRemark}</p>
						</c:if>
					</div>
					<!--txt end-->
					<!--table start-->
					<div class="room-book">
						<div class="tit">
							<h2>预订实时动态</h2>
							<input type="hidden" id="invalidData" value="${invalidData}"/>
							<!-- 嘉定暂不开放 -->
							<%-- <c:if test="${cmsActivityRoom.sysNo!='0'&&not empty cmsActivityRoom.sysNo}">
                                <a href="javascript:;" class="room-btn" style="background-color:gray">我要预订</a>
                            </c:if> --%>
							<c:if test="${cmsActivityRoom.sysNo=='0'||empty cmsActivityRoom.sysNo}">
								<a href="javascript:;" class="room-btn" onclick="roomBook('${cmsActivityRoom.roomId}')">我要预订</a>
							</c:if>

						</div>
						<div class="room-tab">
							<c:set var="bookSize" value="${fn:length(roomBookList)}"></c:set>
							<%-- 控制要显示的天数 --%>
							<c:set var="days" value="${bookSize/5}"></c:set>
							<c:if test="${days > 0}">
								<table width="100%">
									<thead>
									<tr>
										<c:forEach var="s" begin="0" end="${days-1}">
											<th><fmt:formatDate value="${roomBookList[s].curDate}" pattern="M.d"></fmt:formatDate>
												（周
												<c:if test="${roomBookList[s].dayOfWeek == 1}">
													一
												</c:if>
												<c:if test="${roomBookList[s].dayOfWeek == 2}">
													二
												</c:if>
												<c:if test="${roomBookList[s].dayOfWeek == 3}">
													三
												</c:if>
												<c:if test="${roomBookList[s].dayOfWeek == 4}">
													四
												</c:if>
												<c:if test="${roomBookList[s].dayOfWeek == 5}">
													五
												</c:if>
												<c:if test="${roomBookList[s].dayOfWeek == 6}">
													六
												</c:if>
												<c:if test="${roomBookList[s].dayOfWeek == 7}">
													日
												</c:if>）
											</th>
										</c:forEach>
									</tr>
									</thead>
									<tbody id="openTime" style="display: none">
									<c:forEach items="${roomBookList}" var="c" varStatus="s">
										<c:if test="${s.index%days == 0}">
											<tr id="actRoom_${s.index}">
										</c:if>
										<c:if test="${c.bookStatus ==1}">
											<c:if test="${cmsActivityRoom.sysNo!='0'&&not empty cmsActivityRoom.sysNo}">
												<td><a href="javascript:;">可选(${c.openPeriod})</a></td>
											</c:if>
											<c:if test="${cmsActivityRoom.sysNo=='0'||empty cmsActivityRoom.sysNo}">
												<td><a href="javascript:;" onclick="singleRoomBook('${cmsActivityRoom.roomId}','${c.bookId}')">可选(${c.openPeriod})</a></td>
											</c:if>
										</c:if>
										<c:if test="${c.bookStatus ==2}">
											<%--<td class="disabled">已选(${c.openPeriod})</td>--%>
											<td class="disabled" title="${c.tuserName}">
												<c:set var="displaySize" value="8"></c:set>
												<c:if test="${fn:length(c.tuserName) > displaySize}">
													${fn:substring(c.tuserName,0 ,displaySize )}
												</c:if>
												<c:if test="${fn:length(c.tuserName) <= displaySize}">
													${c.tuserName}
												</c:if>
											</td>
										</c:if>
										<c:if test="${c.bookStatus ==3}">
											<td class="disabled noOpen">不开放</td>
										</c:if>

										<c:if test="${s.index == days-1}">
											</tr>
										</c:if>
									</c:forEach>
									</tbody>
								</table>
							</c:if>
						</div>
					</div>
					<!--table end-->
				</div>
				<!--room_con end-->
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
					<c:if test="${commentCount > 5}">
						<a href="javascript:;" class="load-more" onclick="loadMoreComment()" id="viewMore">查看更多...</a>
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
		<!--推荐活动室 start-->
		<div class="recommend mb20 p_bottom" id="room-list-div">
			<form action="${path}/ticketRoom/roomDetail.do" id="roomDetailForm" method="get">
				<input type="hidden" id="roomId" name="roomId" value="${cmsActivityRoom.roomId}"/>
				<input type="hidden" id="tmpVenueId" name="venueId" value="${cmsVenue.venueId}"/>
			</form>
			<form action="${path}/ticketRoom/roomBook.do" id="roomBookForm" method="post">
				<input type="hidden" id="roomId2" name="roomId"/>
				<input type="hidden" id="bookId" name="bookId"/>
			</form>
			<div class="tit fd_bg">推荐活动室</div>
			<!--list start-->
			<ul class="ra_room">
				<li>
				</li>
			</ul>
			<a href="javascript:;" onclick="loadMoreRoom()" id="roomViewMore"  class="load-more"  style="margin-top:15px;display: none;">查看更多></a>
			<input type="hidden" id="roomPageNum" value="1"/>
			<!--list end-->
		</div>
		<!--推荐活动室 end-->
		<!--推荐场馆 start-->
		<div class="recommend mb20 p_bottom" id="venue-list-div">
			<div class="tit fd_bg">推荐场馆</div>
			<!--list start-->
			<ul class="ra_room">

			</ul>
			<!--list end-->
		</div>
		<!--推荐场馆 end-->
		<%-- 只有登录之后的用户才可以预订 --%>
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

	/***********都不开放的不显示 2015.11.12 add by niu***************/
	$(function(){
		openTimeHandler();
		$("#openTime").show();
	});

	function openTimeHandler(){
		var tf = true;
		for(var index=0;index<21;index+=5){
			if($("#actRoom_"+index).length==0){
				continue;
			}
			tf = true;
			$.each($("#actRoom_"+index+" td"),function(i,el){
				if(!$(el).hasClass("noOpen")){
					tf = false;
					return false;
				}
			});
			if(tf){
				$("#actRoom_"+index).empty();
			}
		}
	}
</script>

</body>
</html>
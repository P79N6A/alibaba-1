<%@ page import="org.apache.commons.lang3.StringUtils" %>
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
	<title>活动室详情--文化云</title>

	<%@include file="../../common/frontPageFrame.jsp"%>

	<script type="text/javascript" src="${path}/STATIC/js/index/room/roomDetailFront.js?version=20151126"></script>
	<script type="text/javascript" src="${path}/STATIC/js/jquery.uploadify-3.1.min.js"></script>

	<style type="text/css">
		#file{ position: relative;}
	</style>

	<style type="text/css">
		.noOpen{}
	</style>

</head>

<body>
<c:if test="${cmsActivityRoom.sysNo=='1'}">
	<script>
		function roomBook(str){
			dialogAlert('提示','暂不提供文化嘉定的活动室预订服务，请到文化嘉定平台预订');
		}
		function singleRoomBook(str){
			dialogAlert('提示','暂不提供文化嘉定的活动室预订服务，请到文化嘉定平台预订');
		}
	</script>
</c:if>

    <div class="header">
		<%@include file="../header.jsp" %>
	</div>
<%
	String userMobileNo = "";
	if(session.getAttribute("terminalUser") != null){
		CmsTerminalUser terminalUser = (CmsTerminalUser)session.getAttribute("terminalUser");
		if(StringUtils.isNotBlank(terminalUser.getUserMobileNo())){
			userMobileNo = terminalUser.getUserMobileNo();
		}else{
			userMobileNo = "0000000";
		}
	}
%>
<input type="hidden" id="userMobileNo" value="<%=userMobileNo%>"/>

<div class="crumb">您所在的位置：<a href="${path}/frontVenue/venueList.do">场馆</a>&gt;<a href="${path}/frontVenue/venueDetail.do?venueId=${cmsVenue.venueId}"> ${cmsVenue.venueName}</a>&gt; ${cmsActivityRoom.roomName}</div>
<form action="${path}/frontVenue/venueDetail.do"  id="venueDetailForm" method="get" target="_blank">
	<input type="hidden" id="detailVenueId" name="venueId"/>
</form>
<!--tit end-->
<!--con start-->
<div class="detail-content clearfix">
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
						<p class="equip"><span>设备：</span>
							<c:choose>
								<c:when test="${not empty facList}">
									<span class="equip-list">
									<c:forEach items="${facList}" var="f" varStatus="st">
										<label><img src="${path}/STATIC/image/facIco.gif">${f.dictName}</label>
									</c:forEach>
									</span>
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
					<!--share start-->
					<div class="shares" style="border-bottom:none; margin-top:0px;">
						<!--left start-->
						<div class="share_l fr">
				 <span class="bdsharebuttonbox fl bdshare-button-style0-16" data-bd-bind="1449662884582">
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
				<!--room_con end-->
			</div>
		</div>
		<!--the_one end-->
		<!--the_two start-->
		<div class="the_two">
			<!--评论start-->
			<div class="comment mt20 clearfix">
				<a name="comment"></a>
				<div class="comment-tit">
					<h3>我要评论</h3>
				</div>
				<form id="commentForm">
					<input type="hidden" id="tmpRoomId" name="roomId" value="${cmsActivityRoom.roomId}"/>
					<textarea class="text" name="commentRemark" id="commentRemark" maxLength="200"></textarea>
					<div class="tips">
						<div class="wimg fl">
							<input type="hidden"  name="commentImgUrl" id="headImgUrl" value="">
							<input type="hidden" name="uploadType" value="Img" id="uploadType"/>
							<div id="imgHeadPrev" style="position: relative; overflow: hidden;  float: left;">
							</div>
							<div style="float: left;  margin-top: 0px;">
								<div>
									<input type="file" name="file" id="file">
								</div>
								<div class="comment_message" style="display: none">(最多三张图片)</div>
								<div id="fileContainer" style="display: none;"></div>
								<div id="btnContainer" style="display: none;"></div>
							</div>

						</div>
						<div class="fr r_p">
							<p>文明上网理性发言，请遵守新闻评论服务协议</p>
							<input type="button" class="btn_red" value="发表评论" onclick="addComment()">
						</div>
					</div>
				</form>

				<div class="comment-list" id="comment-list-div">
					<ul id="lrk_listpl">

					</ul>
					<c:if test="${commentCount >= 5}">
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
			<form action="${path}/frontRoom/roomDetail.do" id="roomDetailForm" method="get" target="_blank">
				<input type="hidden" id="roomId" name="roomId" value="${cmsActivityRoom.roomId}"/>
				<input type="hidden" id="tmpVenueId" name="venueId" value="${cmsVenue.venueId}"/>
			</form>
			<form action="${path}/frontRoom/roomBook.do" id="roomBookForm" method="post">
				<input type="hidden" id="roomId2" name="roomId"/>
				<input type="hidden" id="bookId" name="bookId"/>
			</form>
			<div class="tit fd_bg">推荐活动室</div>
			<!--list start-->
			<ul class="ra_room">

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
		<%-- 只有登录之后的用户才可以预订 --%>
		<c:if test="${not empty sessionScope.terminalUser}">
			<input type="hidden" id="isLogin" value="1"/>
			<input type="hidden" id="accountStatus" value="${sessionScope.terminalUser.commentStatus}"/>
			<input type="hidden" id="teamUserSize" value="${fn:length(teamUserList)}"/>
			<input type="hidden" id="teamUserType" value="${sessionScope.terminalUser.userType}"/>
		</c:if>
		<!--推荐场馆 end-->
	</div>
	<!--right end-->
</div>
<!--con end-->
<!--活动详情 end-->
<%@include file="/WEB-INF/why/index/footer.jsp" %>

<script>
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
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


<%@include file="../list_top.jsp"%>

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

<div class="crumbs"><i></i>您所在的位置： <a href="${path}/frontVenue/venueList.do">场馆</a> &gt; ${cmsVenue.venueName} &gt; ${cmsActivityRoom.roomName}</div>
<form action="${path}/frontVenue/venueDetail.do"  id="venueDetailForm" method="get">
	<input type="hidden" id="detailVenueId" name="venueId"/>
</form>

<div class="detail-content">
	<div class="detail-left fl">
		<div class="detail-note">
			<div class="tit">
				<h1>${cmsActivityRoom.roomName}</h1>
				<div class="tag" style="margin-top:10px;">
					<c:forEach items="${tagList}" var="t">
						<a href="javascript:;">${t.tagName}</a>
					</c:forEach>
<%--					<a href="#">讲座</a>
					<a href="#">百人容纳</a>
					<a href="#">多设备</a>--%>
				</div>
			</div>
			<div class="content">
				<img alt="" width="710" id="roomPic" data-id="${cmsActivityRoom.roomPicUrl}"/>
			</div>
			<div class="line"></div>
			<div class="content content-room">
				<input type="hidden" id="venueCity" value="${cmsVenue.venueCity}">
				<input type="hidden" id="venueArea" value="${cmsVenue.venueArea}">
				<input type="hidden" id="venueAddress" value="${cmsVenue.venueAddress}">
				<!-- <p id="areaSpan"></p> -->
				<p>位置：${cmsActivityRoom.roomNo}</p>
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
				<p>面积：${cmsActivityRoom.roomArea}㎡</p>
				<p>容纳人数：${cmsActivityRoom.roomCapacity}人</p>
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
			</div>
			<div class="line"></div>
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
											<td class="disabled">${c.tuserName}</td>
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
			<div class="line"></div>
			<div class="icon">
				<span class="bdsharebuttonbox">
					<a class="share" data-cmd="count"></a>
				</span>
				<!--分享代码 start-->
				<script type="text/javascript">
					with(document)0[(getElementsByTagName('head')[0]||body).appendChild(createElement('script')).src='http://bdimg.share.baidu.com/static/api/js/share.js?v=89860593.js?cdnversion='+~(-new Date()/36e5)];
				</script>
				<!--分享代码 end-->
			</div>
		</div>
		<input type="hidden" value="${pageContext.session.id}" id="sessionId"/>
		<div class="comment mt20 clearfix">
			<a name="comment"></a>
			<div class="comment-tit">
				<h3>我要评论</h3><span id="commentCount">${commentCount}条评论</span>
			</div>
			<form id="commentForm">
				<input type="hidden" id="tmpRoomId" name="roomId" value="${cmsActivityRoom.roomId}"/>
				<textarea class="text" name="commentRemark" id="commentRemark" maxLength="200"></textarea>
				<div class="tips">
					<div class="pl_img fl">

						<input type="hidden"  name="commentImgUrl" id="headImgUrl" value="">
						<input type="hidden" name="uploadType" value="Img" id="uploadType"/>
						<div id="imgHeadPrev" style="position: relative; overflow: hidden;  float: left;">
						</div>

						<div style="float: left;">
							<div>
								<div>
									<input type="file" name="file" id="file">
								</div>
							</div>
							<div class="comment_message" style="display: none">(最多三张图片)</div>
							<div id="fileContainer" style="display: none;"></div>
							<div id="btnContainer" style="display: none;"></div>
						</div>

					</div>
					<div class="fr pljl">
						<p style="color:#999999;">文明上网理性发言，请遵守新闻评论服务协议</p>
						<input type="button" class="btn" value="发表评论" onclick="addComment()"/>
					</div>
					<div class="clear"></div>
				</div>
			</form>
			<div class="comment-list" id="comment-list-div">
				<ul>

				</ul>
				<c:if test="${commentCount >= 5}">
					<a href="javascript:;" class="load-more" onclick="loadMoreComment()" id="viewMore">查看更多...</a>
					<input type="hidden" id="commentPageNum" value="1"/>
				</c:if>
			</div>
		</div>
	</div>
	<div class="detail-right fr">
		<div class="recommend mb20" id="room-list-div">
			<form action="${path}/frontRoom/roomDetail.do" id="roomDetailForm" method="get">
				<input type="hidden" id="roomId" name="roomId" value="${cmsActivityRoom.roomId}"/>
				<input type="hidden" id="tmpVenueId" name="venueId" value="${cmsVenue.venueId}"/>
			</form>
			<form action="${path}/frontRoom/roomBook.do" id="roomBookForm" method="post">
				<input type="hidden" id="roomId2" name="roomId"/>
				<input type="hidden" id="bookId" name="bookId"/>
			</form>
			<div class="tit"><i></i>推荐活动室</div>
			<ul class="recommend-collection recommend-room">

			</ul>
			<a href="javascript:;" class="load-more" onclick="loadMoreRoom()" id="roomViewMore" style="display: none;">查看更多</a>
			<input type="hidden" id="roomPageNum" value="1"/>
		</div>
		<div class="recommend mb20" id="venue-list-div">
			<div class="tit"><i></i>推荐场馆</div>
			<ul class="recommend-venues">

			</ul>
		</div>
		<%-- 只有登录之后的用户才可以预订 --%>
		<c:if test="${not empty sessionScope.terminalUser}">
			<input type="hidden" id="isLogin" value="1"/>
			<input type="hidden" id="accountStatus" value="${sessionScope.terminalUser.commentStatus}"/>
			<input type="hidden" id="teamUserSize" value="${fn:length(teamUserList)}"/>
			<input type="hidden" id="teamUserType" value="${sessionScope.terminalUser.userType}"/>
		</c:if>
	</div>
</div>
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
<%@include file="../index_foot.jsp"%>
</body>
</html>
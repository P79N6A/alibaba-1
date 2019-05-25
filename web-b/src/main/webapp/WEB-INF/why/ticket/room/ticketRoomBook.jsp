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

	<%--注册时临时时间控件--%>
	<script type="text/javascript" src="${path}/STATIC/js/DatePicker/WdatePicker-ticket.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/ticket/room/ticketRoomBook.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/keyboard.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/dialog/lib/sea.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/ticket/venue/ticketVenueSelectedLabel.js"></script>
	<script type="text/javascript">
		$(function(){
			keyboard.config({
				inputId:".input-text"
			});
		});
	</script>
	<!-- dialog end -->
</head>
<body style="background: #eef4f7;">

<%--导航--%>
<%@include file="../ticket-nav.jsp"%>

<div class="register-content ticket-activity-book ticket-room-book">
	<div class="steps steps-activity">
		<ul class="clearfix">
			<li class="step_1 visited_pre">1.填写基本信息<i class="tab_status"></i></li>
			<li class="step_2 active">2.填写预订人信息<i class="tab_status"></i></li>
			<li class="step_3">3.确认订单<i class="tab_status"></i></li>
			<li class="step_4">4.完成预定</li>
		</ul>
	</div>
	<form action="${path}/ticketRoom/roomBookOrder.do" method="post" id="roomBookOrderForm">
		<input type="hidden" id="roomId" name="roomId" value="${cmsActivityRoom.roomId}"/>
		<!--one start-->
		<div class="room-part1">
			<!--info start-->
			<div class="library_info clearfix">
				<input type="hidden" id="venueCity" value="${cmsVenue.venueCity}">
				<input type="hidden" id="venueArea" value="${cmsVenue.venueArea}">
				<input type="hidden" id="venueAddress" value="${cmsVenue.venueAddress}">
				<div class="library_img fl">
					<img id="roomImg" data-id="${cmsActivityRoom.roomPicUrl}" width="170" height="130">
				</div>
				<div class="room-info fl">
					<h3>${cmsActivityRoom.roomName}</h3>
					<p class="site">${fn:substringAfter(cmsActivityRoom.venueCity, ',')}&nbsp;${fn:substringAfter(cmsActivityRoom.venueArea, ',')}&nbsp;${cmsActivityRoom.venueAddress}&nbsp;${cmsActivityRoom.roomNo}</p>
					<p class="home">${cmsVenue.venueName}</p>
				</div>
			</div>
			<!--info end-->
			<table class="tab1" width="100%">
				<tbody><tr>
					<th colspan="2">选择日期场次</th>
				</tr>
				<tr>
					<td class="w500">
						<span class="date_name fl">选择日期</span>
						<div class="date fl">
							<input type="hidden" id="dateHidden" value="${dateStr} ${weekStr}">
							<input type="text" id="date-input" name="curDateStr" value="${dateStr}" readonly="">
							<span class="week" id="data-week">${weekStr}</span>
							<i class="data-btn"></i>
							<script type="text/javascript">
								$(function(){
									$(".data-btn").on("click", function(){
										WdatePicker({el:'dateHidden',dateFmt:'yyyy-MM-dd DD',doubleCalendar:true,minDate:'%y-%M-%d',maxDate:'%y-%M-{%d+7}',position:{left:-194,top:4},isShowClear:false,isShowOK:false,isShowToday:false,onpicked:pickedFunc})
									})
								});
								function pickedFunc(){
									$dp.$('date-input').value=$dp.cal.getDateStr('yyyy-MM-dd');
									$dp.$('data-week').innerHTML=$dp.cal.getDateStr('DD');
									$dp.$('dateHidden').value=$dp.cal.getDateStr('yyyy-MM-dd');
									getRoomBookListByDate();
								}
							</script>
						</div>
						<span class="error-msg fl">请选择日期</span>

					</td>
				</tr>
				<tr>
					<td class="clearfix">
						<span class="date_name fl">选择场次</span>
						<div class="cate fl" id="cate" <c:if test="${empty roomBookList}">style="display: none;"</c:if>>
							<span class="caption" id="caption"></span>
							<select name="openPeriod" id="openPeriod">
								<c:forEach items="${roomBookList}" var="c" varStatus="s">
									<option value="${c.openPeriod}" <c:if test="${openPeriod == c.openPeriod}">selected</c:if> >${c.openPeriod}</option>
								</c:forEach>
							</select>
							<span class="arrow">▼</span>
						</div>
						<span class="error-msg fl">请选择场次</span>
					</td>
				</tr>
				</tbody></table>
		</div>
		<!--one end-->
		<!--two start-->
		<h1>预订人信息</h1>
		<div class="room-part1 room-part2">
			<table class="tab1" width="100%" style="margin-top: 0;">
				<tbody>
				<tr>
					<td>
						<span class="rp_label">所属团体<font class="lightred">*</font></span>
						<input type="text" disabled="disabled" class="rp_noinput" value="${cmsTeamUser.tuserName}"/>
						<input type="hidden" id="tuserName" name="tuserName" value="${cmsTeamUser.tuserName}"/>
						<input type="hidden" id="tuserId" name="tuserId" value="${cmsTeamUser.tuserId}"/>
					</td>
				</tr>
				<tr>
					<td>
						<span class="rp_label">预定人<font class="lightred">*</font></span>
						<input type="text" disabled="disabled" class="rp_noinput" value="${cmsTerminalUser.userNickName}"/>
						<input type="hidden" id="userName" name="userName" value="${cmsTerminalUser.userNickName}"/>
					</td>
				</tr>
				<tr>
					<td>
						<span class="rp_label">手机号码<font class="lightred">*</font></span>
						<div><input type="text" class="input-text rp_input" name="userTel" value="${userTel != null ? userTel : cmsTerminalUser.userMobileNo}"/></div>
					</td>
				</tr>
				</tbody>
			</table>
			<div class="book-notes">
				<div class="book_inner">
					<div class="notes-content">
						<h3 class="caption">预订须知</h3>
						<p>本平台场馆活动室仅向团体用户开放；</p>
						<p>预订成功后，使用当天请准时入场；</p>
						<p>如需退订，请提前办理取消预订手续；</p>
						<p>活动室数量有限，取消预订后再次预订可能遇到已被他人预订的情况而导致预订失败，由用户自行负责</p>
						<p>如累计超过2次预订活动室却没有到场使用者，将取消该团体本年度购票资格。</p>
						<p>如遇重大原因导致活动室临时变更开放时间或取消开放，场馆负责人有义务以短信或站内信的方式告知场馆预订团体，最终解释权归场馆管理方。</p>
					</div>
				</div>
			</div>
		</div>
		<div class="book-agreement">
			<input type="checkbox" id="agreement" onclick="acceptItem()">
			<label for="agreement">我已阅读并接受<a href="javascript:;">预订须知条款</a></label>
		</div>
		<div class="book-control"><input type="button"  value="提交订单" class="btn-submit book-submit" id="subOrder" onclick="bookSubmit()" style="background: #808080"></div>
		<!--three end-->
	</form>
</div>

</body>
</html>
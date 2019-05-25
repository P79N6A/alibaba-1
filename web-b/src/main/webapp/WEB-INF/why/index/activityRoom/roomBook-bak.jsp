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
	<title>活动室预订--文化云</title>

	<%@include file="../../common/frontPageFrame.jsp"%>

	<script type="text/javascript" src="${path}/STATIC/js/index/room/roomBookFront.js"></script>
</head>
<body>

<%@include file="../list_top.jsp"%>

<div id="register-content">
	<div class="register-content">
		<div class="steps steps-room">
			<ul class="clearfix">
				<li class="step_1 visited_pre">1.填写基本预订信息<i class="tab_status"></i></li>
				<li class="step_2 active">2.预订人信息<i class="tab_status"></i></li>
				<li class="step_3">3.提交订单<i class="tab_status"></i></li>
				<li class="step_4">4.完成预订</li>
			</ul>
		</div>
		<form action="${path}/frontRoom/roomBookOrder.do" method="post" id="roomBookOrderForm">
			<input type="hidden" id="roomId" name="roomId" value="${cmsActivityRoom.roomId}"/>
			<input type="hidden" id="tuserName" name="tuserName"/>
			<div class="room-part1">
				<div class="room-info">
					<input type="hidden" id="venueCity" value="${cmsVenue.venueCity}">
					<input type="hidden" id="venueArea" value="${cmsVenue.venueArea}">
					<input type="hidden" id="venueAddress" value="${cmsVenue.venueAddress}">
					<h3>${cmsActivityRoom.roomName}</h3>
					<p>所属：${cmsVenue.venueName}</p>
					<p>地址：<span id="areaSpan"></span></p>
				</div>
				<table class="tab1" width="100%">
					<tr>
						<th colspan="2">选择日期场次<span class="lightred">*</span></th>
					</tr>
					<tr>
						<td width="204">
							<div class="date">
								<input type="hidden" id="dateHidden" value="${dateStr} ${weekStr}"/>
								<input type="text" id="date-input" name="curDateStr" value="${dateStr}" readonly/>
								<span class="week" id="data-week">${weekStr}</span>
								<i class="data-btn"></i>
								<script type="text/javascript">
									$(function(){
										$(".data-btn").on("click", function(){
											WdatePicker({el:'dateHidden',dateFmt:'yyyy-MM-dd DD',doubleCalendar:true,minDate:'%y-%M-%d',maxDate:'%y-%M-{%d+4}',position:{left:-163,top:4},isShowClear:false,isShowOK:false,isShowToday:false,onpicked:pickedFunc})
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
							<%--<span class="error-msg">请选择日期</span>--%>
						</td>
						<td>
							<div id="cate" class="cate" <c:if test="${empty roomBookList}">style="display: none;"</c:if>>
								<span class="caption" id="caption"></span>
								<select name="openPeriod" id="openPeriod">
									<c:forEach items="${roomBookList}" var="c" varStatus="s">
										<option value="${c.openPeriod}" <c:if test="${openPeriod == c.openPeriod}">selected</c:if> >${c.openPeriod}</option>
									</c:forEach>
								</select>
								<span class="arrow">▼</span>
							</div>
							<%--<span class="error-msg" id="errorMsg" <c:if test="${empty roomBookList}">style="display: none;"</c:if>>请选择场次</span>--%>
						</td>
					</tr>
				</table>
			</div>
			<h1>预订人信息</h1>
			<div class="room-part1 room-part2">
				<table class="tab1" width="100%">
					<tr>
						<th width="300">所属团体<span class="lightred">*</span></th>
						<th width="250">预订人<span class="lightred">*</span></th>
						<th>手机号码<span class="lightred">*</span></th>
					</tr>
					<tr>
						<td>
							<div class="cate groupList">
								<span class="caption default">请选择所属团体</span>
								<select name="tuserId" id="tuserId">
									<option value="0">请选择所属团体</option>
									<c:forEach items="${teamUserList}" var="c" varStatus="s">
										<option value="${c.tuserId}" <c:if test="${c.tuserId==tuserId}">selected="selected" </c:if> >${c.tuserName}</option>
									</c:forEach>
								</select>
								<span class="arrow">▼</span>
							</div>
							<%--<span class="error-msg">请选择所属团体</span>--%>
						</td>
						<td>
							<div class="input-box showPlaceholder">
								<input id="userName" name="userName" class="input-text name" type="text" value="${cmsTerminalUser.userNickName}" maxlength="80"/>
								<label class="placeholder">输入您的姓名</label>
							</div>
							<%--<span class="error-msg">请输入姓名</span>--%>
						</td>
						<td>
							<div class="input-box showPlaceholder">
								<input id="userTel" name="userTel" class="input-text phoneNum" type="text" value="${userTel != null ? userTel : cmsTerminalUser.userMobileNo}" maxlength="11"/>
								<label class="placeholder">输入11位手机号码</label>
							</div>
							<%--<span class="error-msg">请填写手机号码</span>--%>
						</td>
					</tr>
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
				<input type="checkbox" id="agreement" onclick="acceptItem()"/>
				<label for="agreement">我已阅读并接受<a href="javascript:;">预订须知条款</a></label>
			</div>
			<div class="book-control">
				<input type="button" value="提交订单" class="book-submit" id="subOrder" onclick="bookSubmit()" style="background: #808080"/>
			</div>
		</form>
	</div>
</div>
<%@include file="../index_foot.jsp"%>

</body>
</html>
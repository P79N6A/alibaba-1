<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta charset="utf-8"/>
<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
<!-- <title>活动室详情</title> -->
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<!--<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">-->
		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/normalize.css">
		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/common.css">
		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css">
		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/swiper-3.3.1.min.css">
		<title>活动室预订成功</title>
		
	<script type="text/javascript">
	
	
		function subUser()
		{
			var url="${path}/wechatUser/auth.do";
			
			$("#roomOrderForm").attr("action",url);
			
			$("#roomOrderForm").submit();  
		}
		
		function subTeamUser()
		{
			var url="${path}/wechatRoom/authTeamUser.do";
			
			$("#roomOrderForm").attr("action",url);
			
			$("#roomOrderForm").submit();  
		}
		
		function myOrder()
		{
			  window.location.href = '${path}/wechatActivity/wcOrderList.do';
		}
	
		</script>
	
		
	</head>
	

<body>
	<form id="roomOrderForm" method="post">
	
	<input type="hidden" id="roomOrderId" name="roomOrderId" value="${roomOrderId }"/>
	
	<input type="hidden" id="userId" name="userId" value="${userId }"/>
	
	<input type="hidden" id="tuserName" name="tuserName" value="${tuserName }"/>
	
	<input type="hidden" id="tuserIsDisplay" name="tuserIsDisplay" value="${tuserIsDisplay }"/>
		<div class="main">
			<div class="header">
				<div class="index-top">
					<span class="index-top-5">
						<img src="${path}/STATIC/wechat/image/arrow1.png"  onclick="history.go(-1);"/>
					</span>
					<span class="index-top-2">活动室预订</span>
				</div>
			</div>
			<div class="content padding-bottom0 margin-top100 h250">
				<div class="my-point bg7279a0 cfff h250">
					<p class="fs44 my-point-num">提交成功，请等待审核！</p>
					<p class="order-success-tip w590 fs26">您的活动室预约信息已提交成功，我们将在3个工作日以内日予以审核，请及时关注短信通知，谢谢！</p>
				</div>
				<div class="my-point-list fs30">
				
				<div class="order-success-info">
					<c:choose>
						<c:when test="${userType!=2 || tuserIsDisplay!=1 }">
							<div class="order-success-info border-bottom3">
						</c:when>
						<c:otherwise>
							<div class="order-success-info">
						</c:otherwise>
					</c:choose>
						<p class="order-success-title fs32 c262626">${roomName }</p>
						<table class="margin-top20">
							<tbody>
								<tr>
									<td class="p3-font">
										<p class="w2">场馆</p>
									</td>
									<td><span>：</span></td>
									<td>
										<p>${venueName }</p>
									</td>
								</tr>
								<tr>
									<td class="p3-font">
										<p class="w2">日期</p>
									</td>
									<td><span>：</span></td>
									<td>
										<p>${date }</p>
									</td>
								</tr>
								<tr>
									<td>
										<p>使用人</p>
									</td>
									<td><span>：</span></td>
									<td>
										<p>${tuserName }</p>
									</td>
								</tr>
								<tr>
									<td>
										<p>联系人</p>
									</td>
									<td><span>：</span></td>
									<td>
										<p>${orderName }&nbsp;&nbsp;${orderTel }</p>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<c:choose>
						<c:when test="${userType!=2 }">
							<div class="order-success-info">
								<p class="fs26 cd58185">本活动预约需要进行实名认证，请进行资料完善，以便通过预约审核，谢谢！</p>
							</div>
							<div class="order-success-info">
								<button  type="button" onclick="subUser();" class="w290 h80 bg7279a0 cfff">前往认证</button>
							</div>
						</c:when>
						<c:when test="${tuserIsDisplay!=1 }">
							<div class="order-success-info">
								<p class="fs26 cd58185">本活动预约需要进行使用者认证，请进行资料完善，以便通过预约审核，谢谢！</p>
							</div>
							<div class="order-success-info">
								<button type="button" onclick="subTeamUser();" class="w290 h80 bg7279a0 cfff">前往认证</button>
							</div>
						</c:when>
					</c:choose>
				</div>
			</div>
			<div class="footer w100-pc h80">
				<button type="button" class="w100-pc height100-pc fs30 bgf2f2f2 c7279a0" onclick="myOrder();" >进入我的订单</button>
			</div>
		</div>
	</form>
	
</body>
</html>

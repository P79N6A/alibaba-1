<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>扫二维码进活动送积分</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	
	<script>
		var activityId = '${activityId}';
		var integral = '${integral}';
		var isOver = '${isOver}';
		
		$(function () {
			if(isOver == 1){
				$("#integral").html("送积分活动已结束 ^-^");
			}else{
				if(Number(integral)>0){
					$("#integral").html("恭喜你，获取了"+integral+"积分");
				}
			}
			
			setTimeout(function () { 
				location.href = "${path}/wechatActivity/preActivityDetail.do?activityId=" + activityId;
			}, 2000);
		})
		
	</script>
	<style>
		html,
		body {
			height: 100%;
		}
		.integralMain {
			width: 750px;
			margin: auto;
			display: flex;
			justify-content: center;
			align-items: center;
			height: 100%;
		}
		
		.integralMain>div{
			text-align: center;
			font-size: 34px;
			color: #808080;
		}
	</style>
</head>

<body>
	<div class="integralMain">
		<div>
			<img src="${path}/STATIC/wxStatic/image/integral.png" />
			<p id="integral"></p>
		</div>
	</div>
</body>
</html>
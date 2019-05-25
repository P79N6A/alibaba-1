
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>支付失败</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wx/css/mc-mobile.css"/>
	<script src="${path}/STATIC/js/common.js"></script>
	<style>
		html,
		body {
			height: 100%;
		}
		
		.main {
			height: 100%;
			background-color: #fff;
		}
		
		.content {
			height: 100%;
			padding-bottom: 0;
			display: -webkit-box;
			display: -ms-flexbox;
			display: -webkit-flex;
			display: flex;
			-webkit-box-pack: center;
			-ms-flex-pack: center;
			-webkit-justify-content: center;
			justify-content: center;
			-webkit-box-align: center;
			-ms-flex-align: center;
			-webkit-align-items: center;
			align-items: center;
		}
		
		.payBtn {
		    float: right;
		    width: 320px;
		    height: 100%;
		    text-align: center;
		    line-height: 90px;
		    font-size: 40px;
		    background-color: #7279A0;
		    color: #fff;
		}
	</style>
	
	<script>
		var activityOrderId = '${activityOrderId}';
		
		$(function(){
			$(".payBtn").click(function(){
				 window.location.href = '${path}/wechatActivity/wcOrderList.do';
			})
			
			$(".rePay").click(function(){
				
				 window.location.href = "${path}/wechatActivity/preActivityOrderPay.do?activityOrderId=" + activityOrderId;
			})
		});
		
	</script>
</head>


<body>
		<div class="main">
			<div class="content">
				<div style="padding-bottom:250px;">
					<img style="display: block;margin: auto;" src="${path }/STATIC/wechat/image/payFailed.png" />
					<p style="text-align: center;font-size: 26px;color: #262626;">支付失败，请重新返回支付。</p>
					<div class="rePay" style="padding: 10px 20px;border: 1px solid #808080;font-size: 26px;color: #262626;text-align: center;margin: 20px 65px 0;border-radius: 10px;">重新支付</div>
				</div>
			</div>
			
		</div>
		<div class="M_activity_due" style="height: 100px;">
			<div class="payBtn" style="float: none;width: 100%;background-color: #f4f4f4;color: #646c9b;">进入我的订单</div>
		</div>
	</body>

</html>


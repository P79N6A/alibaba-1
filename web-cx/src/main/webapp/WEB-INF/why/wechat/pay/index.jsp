
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>微信支付</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
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
		
	</style>
<script type="text/javascript" >
	var activityOrderId = '${activityOrderId}';
	
	var openId='${openId}'
	 
	 if ('replaceState' in history) {
		 
		history.replaceState(null,null,'${path}/wechatPay/index.do');
	}
	
	//判断是否是微信浏览器打开
	if (is_weixin()) {
		//通过config接口注入权限验证配置
		wx.config({
			debug: false,
			appId: '${sign.appId}',
			timestamp: '${sign.timestamp}',
			nonceStr: '${sign.nonceStr}',
			signature: '${sign.signature}',
			jsApiList: ['chooseWXPay']
		});
		wx.ready(function () {
			if(activityOrderId)
			$.post("${path}/wechatPay/wxPayInfo.do", {
				   openId: openId,
				   orderId: activityOrderId
			 }, function (data) {
			 	if (data.status == 1) {
			 		
			 		var appId=data.data.appId;
			 		var timestamp=data.data.timestamp;
			 		var nonceStr=data.data.nonce_str;
			 		var pack_age=data.data.pack_age;
			 		var signType=data.data.signType;
			 		var paySign=data.data.paySign;
			 		  
			 		wx.chooseWXPay({
						   "appId" : appId,     //公众号名称，由商户传入     
				           "timestamp": timestamp,        //时间戳，自1970年以来的秒数     
				           "nonceStr" : nonceStr, //随机串     
				           "package" : pack_age,     
				           "signType" : signType,         //微信签名方式：     
				           "paySign" : paySign,//微信签名
				           success: function (res) {
				        	   
				        	   $("p").html("支付完成，请等待支付结果返回。")
				        	   
				        	   setInterval(
										function(){
											payCallBack();
										}
									,2000);	
			              },
			              cancel:function(res){
			            	  window.location.href = "${path}/wechatActivity/preActivityOrderPay.do?activityOrderId=" + activityOrderId;
			              },
			              fail:function(res){
			            	  window.location.href = "${path}/wechatActivity/activityOrderPayError.do?activityOrderId=" + activityOrderId;
			              }
					});
			 	}
			 }, "json");
		});
	}
	
	function payCallBack(){
		
		$.post("${path}/wechatUser/userActivityOrderDetail.do",{activityOrderId:activityOrderId,userId:userId}, function (data) {
			if(data.status==200){
				var dom = data.data;
            	  if(dom.orderPaymentStatus!=1)
					{
            	 	 window.location.href = "${path}/wechatActivity/activityOrderPaySuccess.do?activityOrderId=" + activityOrderId;
					}
              }  else if (data.status == 500) {
                  window.location.href = "${path}/timeOut.html";
              } else {
            	  alert (data.data)
              }
              
          }, "json");
	}

</script>
</head>

<body>
		<div class="main">
			<div class="content">
				<div style="padding-bottom:250px;">
					<img style="display: block;margin: auto;" src="${path }/STATIC/wechat/image/payLoading.png" />
					<p style="text-align: center;font-size: 26px;color: #262626;">支付中...</p>
				</div>
			</div>
		</div>

	</body>

</html>



<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>等待支付结果</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<script src="${path}/STATIC/js/common.js"></script>
<script type="text/javascript" >


	var activityOrderId = '${activityOrderId}';
	
	setInterval(
			function(){
				
			}
		,2000);		
	
	
	function payCallBack(){
		
	}

</script>

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

</head>

<body>
		<div class="main">
			<div class="content">
				<div>
					<img style="display: block;margin: auto;" src="${path }/STATIC/wechat/image/payLoading.png" />
					<p style="text-align: center;font-size: 26px;color: #262626;">支付中，请等待支付结果返回。</p>
				</div>
			</div>
		</div>

	</body>


</html>


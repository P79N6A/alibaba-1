<%@ page language="java" pageEncoding="UTF-8" %>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title></title>
		<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
		<script type="text/javascript">
			var phoneWidth = parseInt(window.screen.width);
			var phoneScale = phoneWidth / 750;
			var ua = navigator.userAgent; //浏览器类型
			if(/Android (\d+\.\d+)/.test(ua)) { //判断是否是安卓系统
				var version = parseFloat(RegExp.$1); //安卓系统的版本号
				if(version > 2.3) {
					document.write('<meta name="viewport" content="width=750,user-scalable=no, minimum-scale = ' + phoneScale + ', maximum-scale = ' + (phoneScale) + ', target-densitydpi=device-dpi">');
				} else {
					document.write('<meta name="viewport" content="width=750,user-scalable=no, target-densitydpi=device-dpi">');
				}
			} else {
				document.write('<meta name="viewport" content="width=750,user-scalable=no, target-densitydpi=device-dpi">');
			}
		</script>
	</head>
	<style>
		html,
		body {
			height: 100%;
			width: 100%;
			margin:0;
			padding:0;
		}
		
		body {
			background-color: #410e4b;
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

	<body>
		<div>
			<p style="font-size: 30px;color: #e6bcee;text-align: center;margin:0;">本次投票活动于1月7日上午9时正式开始</p>
			<img src="${path}/STATIC/wxStatic/image/qyg/guanzhu.png" style="display: block;margin: 40px auto 0;" />
		</div>
	</body>

</html>
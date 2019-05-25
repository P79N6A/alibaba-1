<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <!-- <title>我的消息详情</title> -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wx/css/reset-mc.css" />
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wx/css/mc-mobile.css" />
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>
    <script type="text/javascript" src="${path}/STATIC/wx/js/mc-mobile.js"></script>
	
	<style type="text/css">
		body,.M_message_detail{height: 100%}
	</style>
</head>
<body>
	<div class="index-top">
		<span class="index-top-5">
			<img src="${path}/STATIC/wechat/image/arrow1.png"  onclick="history.go(-1);"/>
		</span>
	    <span class="index-top-2">我的消息</span>
    </div>
	<div class="M_message_detail">
		<p>${message.userMessageContent}</p>
	</div>
</body>
</html>
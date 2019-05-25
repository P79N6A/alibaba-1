<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>佛山文化云·艺术天空</title>
<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
<link rel="stylesheet" type="text/css"
	href="${path}/STATIC/wxStatic/css/style-series.css" />
<style type="text/css">
	html,body{font-family:arial,\5FAE\8F6F\96C5\9ED1,\9ED1\4F53,\5b8b\4f53,sans-serif; -webkit-text-size-adjust:none;/*Google Chrome*/}
	img {vertical-align: middle;}
	html, body , .skydata {height: 100%;}
</style>
<script src="${path}/STATIC/js/common.js"></script>

</head>
<body>
<div class="skydata">
	<div class='skdatit clearfix'><img src="${basePath}/STATIC/wxStatic/image/sky/pic3.png"></div>
	<img class="skds" src="${basePath}/STATIC/wxStatic/image/sky/pic4.png">
	<p style="font-size:24px;line-height:40px; color:#333;width:580px;margin:0 auto;margin-top:40px;">
	请持此页面展示给活动现场文化云工作人员排队领票<br>
	余票有限，领完即止
	</p>
	<a class="skds_btn" href="javascript:window.location.href='../wechatStatic/artSky.do'">查看更多艺术天空精彩演出</a>
</div>
</body>
</html>

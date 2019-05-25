<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta charset="utf-8"/>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<!-- <title>购票须知</title> -->
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wx/css/reset-mc.css" />
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wx/css/mc-mobile.css" />
	<script type="text/javascript" src="${path}/STATIC/wx/js/mc-mobile.js"></script>
</head>
<body>
	<div id="common_head" class="clearfix">
		<a href="javascript:history.go(-1);" class="arrow_l"></a>
		<div class="notice-tit">购票须知</div>
	</div>
	<div class="ticket_notice">
		<p>${orderNotice}</p>
	</div>
</body>
</html>
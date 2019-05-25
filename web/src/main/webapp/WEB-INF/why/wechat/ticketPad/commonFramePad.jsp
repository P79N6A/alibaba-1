<%@ page language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page import="java.util.*" %>
<%
    String path = request.getContextPath();
    request.setAttribute("path", path);
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
    request.setAttribute("basePath", basePath);
    String error = request.getParameter("error");
    request.setAttribute("error", error);
%>
<%@include file="/WEB-INF/why/wechat/wechat_statistics.jsp"%>
<meta name="format-detection" content="telephone=no"/>
<meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no"/>
<meta name="apple-mobile-web-app-capable" content="yes"/>
<meta name="apple-mobile-web-app-status-bar-style" content="black"/>

<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/normalize.css">

<script type="text/javascript" src="${path}/STATIC/wechat/js/jquery-2.1.4.min.js"></script>
<script src="${path}/STATIC/js/avalon.js"></script>
<script type="text/javascript" src="${path}/stat/stat.js"></script>
<!--移动端版本兼容 -->
<script type="text/javascript">
	var phoneWidth = parseInt(window.screen.width);
	var phoneScale = phoneWidth / 2048;
	var ua = navigator.userAgent; //浏览器类型
	if (/Android (\d+\.\d+)/.test(ua)) { //判断是否是安卓系统
		var version = parseFloat(RegExp.$1); //安卓系统的版本号
		if (version > 2.3) {
			document.write('<meta name="viewport" content="width=2048,user-scalable=no, minimum-scale = ' + phoneScale + ', maximum-scale = ' + (phoneScale) + ', target-densitydpi=device-dpi">');
		} else {
			document.write('<meta name="viewport" content="width=2048,user-scalable=no, target-densitydpi=device-dpi">');
		}
	} else {
		document.write('<meta name="viewport" content="width=2048,user-scalable=no, target-densitydpi=device-dpi">');
	}
</script>

<script type="text/javascript">
	$(document).attr("title","文化引领品质生活");
</script>

<style>
	body {background-color: #F0F0F0;}
</style>
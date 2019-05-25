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
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/common.css">
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/ui-dialog.css"/>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/swiper-3.3.1.min.css">

<script type="text/javascript" src="${path}/STATIC/wechat/js/jquery-2.1.4.min.js"></script>
<script type="text/javascript" src="${path}/STATIC/wechat/js/dialog-min.js"></script>
<script type="text/javascript" src="${path}/STATIC/wechat/js/wechat-util.js"></script>
<script type="text/javascript" src="${path}/STATIC/wechat/js/map-transform.js"></script>
<script type="text/javascript" src="${path}/STATIC/wechat/js/jweixin-1.0.0.js"></script>
<script type="text/javascript" src="${path}/STATIC/wechat/js/swiper-3.3.1.jquery.min.js"></script>
<script src="${path}/STATIC/js/avalon.js"></script>
<script type="text/javascript" src="${path}/stat/stat.js"></script>
<!--移动端版本兼容 -->
<script type="text/javascript">
    (function () {
        var phoneWidth = parseInt(window.screen.width);
        var phoneScale = phoneWidth / 750;
        var ua = navigator.userAgent;            //浏览器类型
        if (/Android (\d+\.\d+)/.test(ua)) {      //判断是否是安卓系统
            var version = parseFloat(RegExp.$1); //安卓系统的版本号
            if (version > 2.3) {
                document.write('<meta name="viewport" content="width=750, minimum-scale = ' + phoneScale + ', maximum-scale = ' + phoneScale + ', target-densitydpi=device-dpi">');
            } else {
                document.write('<meta name="viewport" content="width=750, target-densitydpi=device-dpi">');
            }
        } else {
            document.write('<meta name="viewport" content="width=750, user-scalable=no, target-densitydpi=device-dpi">');
        }
    }());
</script>

<script type="text/javascript">
	var error = '${error}';
	$(function () {
		if(error=="loginFail"){
			dialogAlert('登录失败', '请重试或通过其他方式登录！');
		}
		
		downLoadApp();		//下载APP弹出框
	});

	if (!is_weixin()) {
		$(document).attr("title","文化云 - 文化引领品质生活");
	}else{
		$(document).attr("title","文化引领品质生活");
	}
</script>
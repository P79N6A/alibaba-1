<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
	String path = request.getContextPath();
	request.setAttribute("path", path);
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/wechat/reset.css">
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/wechat/mobile.css">
<script type="text/javascript" src="${path}/STATIC/js/wechat/blocksit.min.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/wechat/mo_common.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/jquery.min.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/common.js"></script>
<%--dialogAlert弹出框start--%>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
<script type="text/javascript" src="${path}/STATIC/js/base.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
<%--dialogAlert弹出框end--%>

<!--移动端版本兼容 -->
<script type="text/javascript">
	var phoneWidth =  parseInt(window.screen.width);
	var phoneScale = phoneWidth/750;
	var ua = navigator.userAgent;            //浏览器类型
	if (/Android (\d+\.\d+)/.test(ua)){      //判断是否是安卓系统
		var version = parseFloat(RegExp.$1); //安卓系统的版本号
		if(version>2.3){
			document.write('<meta name="viewport" content="width=750, minimum-scale = '+phoneScale+', maximum-scale = '+phoneScale+', target-densitydpi=device-dpi">');
		}else{
			document.write('<meta name="viewport" content="width=750, target-densitydpi=device-dpi">');
		}
	} else {
		document.write('<meta name="viewport" content="width=750, user-scalable=no, target-densitydpi=device-dpi">');
	}
</script>
<!--移动端版本兼容 end -->

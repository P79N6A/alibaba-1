<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
	String path = request.getContextPath();
	request.setAttribute("path", path);
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta http-equiv="content-type" content="text/html; charset=UTF-8" >
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<link rel="shortcut icon" href="${path}/STATIC/image/favicon.ico" type="image/x-icon" mce_href="${path}/STATIC/image/favicon.ico">
<link href="${path}/STATIC/image/favicon.ico" rel="icon" type="image/x-icon" mce_href="${path}/STATIC/image/favicon.ico">
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/reset-index.css"/>
<%--<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture-index.css"/>--%>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/ui-dialog.css"/>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture.css"/>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture-user.css"/>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/index_new.css"/>
<!--[if lte IE 8]>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture-ie.css"/>
<![endif]-->
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/frontpage.css">
<script type="text/javascript" src="${path}/STATIC/js/jquery.min.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/jquery.SuperSlide.2.1.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/common.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/page.min.js"></script>



<%--注册时临时时间控件--%>
<script type="text/javascript" src="${path}/STATIC/js/DatePicker/WdatePicker.js"></script>
<%--<script type="text/javascript" src="${path}/STATIC/js/common.js"></script>--%>
<script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/jquery.alerts.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/culture.js"></script>
<!--移动端版本兼容 -->
<script type="text/javascript">
	var phoneWidth =  parseInt(window.screen.width);
	var phoneScale = phoneWidth/1200;
	var ua = navigator.userAgent;            //浏览器类型
	if (/Android (\d+\.\d+)/.test(ua)){      //判断是否是安卓系统
		var version = parseFloat(RegExp.$1); //安卓系统的版本号
		if(version>2.3){
			document.write('<meta name="viewport" content="width=1200, minimum-scale = '+phoneScale+', maximum-scale = '+(phoneScale+1)+', target-densitydpi=device-dpi">');
		}else{
			document.write('<meta name="viewport" content="width=1200, target-densitydpi=device-dpi">');
		}
	} else {
		document.write('<meta name="viewport" content="width=1200, user-scalable=yes, target-densitydpi=device-dpi">');
	}
</script>
<!--移动端版本兼容 end -->

<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
	String path = request.getContextPath();
	request.setAttribute("path", path);
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	request.setAttribute("basePath", basePath);
%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<link rel="shortcut icon" href="${path}/STATIC/image/favicon.ico" type="image/x-icon" mce_href="${path}/STATIC/image/favicon.ico">
<link href="${path}/STATIC/image/favicon.ico" rel="icon" type="image/x-icon" mce_href="${path}/STATIC/image/favicon.ico">
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/reset.css"/>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/main.css"/>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/jquery.alerts.css">
<!--[if lte IE 8]>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/main-ie.css"/>
<![endif]-->
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/page.css"/>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/select2.css"/>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
<script type="text/javascript" src="${path}/STATIC/js/jquery.min.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/base.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/common.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/jquery.alerts.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/location.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/page.min.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/jquery.uploadify-3.1.min.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/birthday.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/clipboard.min.js"></script>

<!--搜索场馆三级联动 start-->
<%--<script type="text/javascript" src="${path}/STATIC/js/area-venues-admin.js"></script>--%>
<script type="text/javascript" src="${path}/STATIC/js/area.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/select2.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/select2_locale_zh-CN.js"></script>
<!-- <script src="${path}/STATIC/js/avalon.js"></script> -->
<script src="${path}/STATIC/js/angular.js"></script>

<%--<!--富文本编辑器 start-->--%>
<script type="text/javascript" src="${path}/STATIC/js/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/ckeditor/sample.js"></script>
<!--富文本编辑器 end-->

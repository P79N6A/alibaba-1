<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
    String path = request.getContextPath();request.setAttribute("path", path);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>405--文化安康云</title>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/reset.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture-index.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/reset-index.css"/>
    <!--[if lte IE 8]>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture-ie.css"/>
    <![endif]-->
    <script type="text/javascript" src="${path}/STATIC/js/jquery.min.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/culture.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/common.js"></script>

</head>
<body>

<!-- 导入头部文件 -->
<%@include file="../why/index/index_top.jsp"%>

<div class="wrong">
    <div class="w_pic"><img src="${path}/STATIC/image/404.png" width="602" height="241" /></div>
    <div class="w_txt">
        <h1>哎呦，出错啦!</h1>
        <p>您要找的页面不存在，</a><a href="${path}/frontActivity/frontActivityIndex.do">返回首页</a></p>
    </div>
</div>
<%@include file="../why/index/index_foot.jsp"%>
</body>
</html>



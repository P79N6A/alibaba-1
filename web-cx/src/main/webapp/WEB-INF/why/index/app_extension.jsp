<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>
    <meta charset="utf-8">
    <title>欢迎下载文化云App</title>
    <%@include file="/WEB-INF/why/common/frontPageFrame.jsp"%>
    <script type="text/javascript" src="${path}/STATIC/js/index/activity/activityDetail.js?version=20160112"></script>
    <script type="text/javascript" src="${path}/STATIC/js/jquery.uploadify-3.1.min.js"></script>
    <meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/tg.css">
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
</head>
<body>
<div class="content">
    <div class="logo"><img src="${path}/STATIC/image/logoApp.png" width="120" height="75"></div>
    <h1>文化云</h1>
    <h2>免费演出、亲子活动、艺术培训、文化场馆</h2>
    <h2>一网打尽 尽显城市逼格生活品质</h2>
    <div class="img"><img src="${path}/STATIC/image/phone_bg.png"></div>
    <div class="down_load">
        <a href="http://www.wenhuayun.cn/appdownload/" class="apple">IOS 版本下载</a>
        <a href="http://www.wenhuayun.cn/appdownload/" class="android">Android版本下载</a>
    </div>
    <div class="footer"><img src="${path}/STATIC/image/chuangtu_x.png" width="128" height="27"></div>
</div>
</body>
</html>



<%--
  Created by IntelliJ IDEA.
  User: niubiao
  Date: 2016/1/13
  Time: 15:51
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%request.setAttribute("path",request.getContextPath());%>
<%--<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>--%>
<!DOCTYPE html>
<html>
<head lang="en">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=0, minimum-scale=1.0, maximum-scale=1.0">
  <meta name="apple-mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-status-bar-style" content="black">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <!-- <title>密码重置成功</title> -->
  <link rel="stylesheet" type="text/css" href="${path}/STATIC/mobile/css/reset.css"/>
  <link rel="stylesheet" type="text/css" href="${path}/STATIC/mobile/css/M-login.css"/>
  <!--移动端版本兼容 -->
  <script type="text/javascript">
    var phoneWidth =  parseInt(window.screen.width);
    var phoneScale = phoneWidth/750;
    var ua = navigator.userAgent;            //浏览器类型
    if (/Android (\d+\.\d+)/.test(ua)){      //判断是否是安卓系统
      var version = parseFloat(RegExp.$1); //安卓系统的版本号
      if(version>2.3){
        document.write('<meta name="viewport" content="width=750, minimum-scale = '+phoneScale+', maximum-scale = '+(phoneScale)+', target-densitydpi=device-dpi">');
      }else{
        document.write('<meta name="viewport" content="width=750, target-densitydpi=device-dpi">');
      }
    } else {
      document.write('<meta name="viewport" content="width=750, user-scalable=yes, target-densitydpi=device-dpi">');
    }
  </script>
  <!--移动端版本兼容 end -->
</head>
<body>
<div class="content">
  <!--finish start-->
  <div class="reg_finish">
    <span>密码重置成功  正在跳转...</span>
    <span></span>
  </div>
  <!--finish end-->
</div>
<script>
     window.onload = function(){
         setTimeout(function(){
           window.location.href="${path}/muser/login.do?m="+'${m}';
         },2500)
     }
</script>
</body>
</html>

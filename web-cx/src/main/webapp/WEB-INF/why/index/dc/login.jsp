<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<%
    String path = request.getContextPath();
    request.setAttribute("path", path);
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/reset-index.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/ui-dialog.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/index_new.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/dc/css/whyupload.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture-user.css"/>

    <!--[if lte IE 8]>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture-ie.css"/>
    <![endif]-->
    <script type="text/javascript" src="${path}/STATIC/js/jquery.min.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/jquery.SuperSlide.2.1.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/culture.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/common.js"></script>
    <title>视频上传系统</title>
</head>
<body style="background-color: #ffffff;" ms-important="Login">

<!-- 导入头部文件  无搜索按钮 -->
<div class="hp_navbg">
    <div class="hp_nav clearfix">
        <div class="logo fl"><img alt="文化云" src="${path}/STATIC/image/baiduLogo.png" width="80" height="48"/>
        </div>
        <ul class="fl">
        
        </ul>
      
    </div>
</div>
<!--上传登录-->
<div class="whyuploadMain">
    <div class="whyUploadDiv">
        <!-- <p class="nowPlace">您所在的位置：视频上传系统</p> -->
        <div class="whyUserLogin">
            <div class="whyUserInfo">
                <p class="whyUserLoginTitle">此页面不存在！</p>
                <%-- <div class="whyUserAccount">
                    <input type="text" id="name" placeholder="账号" style="background: url(${path}/STATIC/dc/loginlogo.png) no-repeat 7px 7px;" />
                </div>
                <div class="whyUserPassword">
                    <input type="password" id="userPwd" placeholder="密码" style="background: url(${path}/STATIC/dc/loginlogo.png) no-repeat 7px -54px;" />
                </div>
                <div class="whyUserLoginBtn" onclick="userLogin()">登录</div> --%>
            </div>
        </div>
    </div>
</div>
<script>
    function userLogin() {

        var a = $("#name").val();
        var b = $("#userPwd").val();
        if($.trim(a) == "" || a == "账号") {
            dialogAlert("提示", "请输入您的账号");
            $("#name").focus();
            return
        }
        if($.trim(b) == "" || b == "请输入您的密码") {
            dialogAlert("提示", "请输入密码");
            $("#userPwd").focus();
            return
        }
        $.ajax({
            type: "POST",
            url: "${path}/dcFront/toLogin.do",
            data: {userName:a,userPwd:b},
            dataType: "json",
            success: function(data) {
                if(data == "success") {
                     window.location.href = "../dcFront/dcVideoList.do";
                } else if (data == "disPwd") {
                	 dialogAlert("登录失败", "帐户密码错误")
                }
                else {
                	 dialogAlert("登录失败", "系统错误")
                }
            },
            error: function() {
                model.canLogin = false;
                dialogAlert("提示", "系统繁忙")
            }
        })
    }
</script>
</body>
<!-- 导入头部文件 -->

</html>

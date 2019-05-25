<%@ page language="java"  pageEncoding="UTF-8"%>
<%
    String path = request.getContextPath();
    request.setAttribute("path", path);
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="s" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<link rel="shortcut icon" href="${path}/STATIC/image/favicon.ico" type="image/x-icon" mce_href="${path}/STATIC/image/favicon.ico">
<link href="${path}/STATIC/image/favicon.ico" rel="icon" type="image/x-icon" mce_href="${path}/STATIC/image/favicon.ico">
<html>
<head>
<title>文化云</title>
<%--<%@include file="/WEB-INF/why/common/pageFrame.jsp"%>--%>
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
    <script src="${path}/STATIC/js/placeholder.js"></script>
    <script src="${path}/STATIC/js/avalon.js"></script>
<style type="text/css">
.ms-controller,.ms-important,[ms-controller],[ms-important]{visibility:hidden}
</style>
</head>
<body>
<div class="login-top">
    <div class="logo" style="width: 600px;">
    	<img src="${path}/STATIC/image/backstage-logo.png" alt=""/>
    	<span style="font-size: 22px;color:#fff;">（${cityName}）</span>
    </div>
</div>

<div class="login-box" ms-important="dataForm">
            <div class="user name">
                <label class="txt"></label><input id="userAccount"  type="text"
                                                  ms-duplex="userAccount"  placeholder="用户名"/>
            </div>
            <div class="user pwd">
                <label class="txt"></label><input type="password" id="userPassword"
                                                  ms-duplex="userPassword"   placeholder="密码"/>
            </div>
            <div  class="msg-error" ms-if="errText!=0" >{{errText}}</div>
            <div class="user login-btn" onclick="userLogin()">
                <input type="button" class="login-submit"  value="登录" />
            </div>
</div>

<script type="text/javascript">
    avalon.ready(function(){
        fixPlaceholder();
    });
    var dataForm = avalon.define({
        $id:"dataForm",
        userAccount:"",
        userPassword:"",
        randomData:"",
        errText:0
    });
    $(document).keydown(function(e){
        if (e.which == 13) {
            userLogin();
            return false;
        }
        return true;
    });
    function userLogin(){
        if (!dataForm.userAccount||dataForm.userAccount=="用户名") {
            dataForm.errText="请输入用户名!";
            $("#userAccount").focus();
            return;
        }
        if (!dataForm.userPassword) {
            dataForm.errText="请输入密码!";
            $("#userPassword").focus();
            return;
        }
        var asm = new Date().getTime();
        dataForm.randomData=new Date().getTime();
        $.post("${path}/user/loginCheckSysUser.do?asm="+asm, dataForm.$model, function(data) {
            if (data == "success") {
                window.location.href="${path}/admin.do";
            } else if (data == "freeze") {
                dataForm.errText="该用户已被冻结!";
                $("#userPassword").focus();
            }
            else {
                dataForm.errText="用户名或密码错误!";
                $("#userPassword").focus();
            }
        });
    }
    //执行页面跳转时，如果当前页面包含在frameset中，则跳出至浏览器窗口
    if (window != top){
        top.location.href = "${path}/login.do";
    }
</script>
</body>
</html>

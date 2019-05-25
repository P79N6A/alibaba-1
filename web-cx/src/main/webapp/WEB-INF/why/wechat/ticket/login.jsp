<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp" %>
    <!-- <title>验票登陆</title> -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/ticket.css"/>
    
    <script type="text/javascript">
        function userLogin(){
            var userName=$('#userName').val();
            var pwd=$('#pwd').val();
            if (userName==undefined||userName=="") {
                $("#userName").focus();
                dialogAlert('系统提示',"请输入用户名!");
                return;
            }
            if (pwd==undefined||pwd=="") {
                $("#pwd").focus();
                dialogAlert('系统提示',"请输入密码!");
                return;
            }
            var asm = new Date().getTime();
            $.post("${path}/user/loginCheckSysUser.do?asm="+asm,{userAccount:userName,userPassword:pwd,userType:'ticketType'},function(data) {
                if (data == "success") {
                    window.location.href="${path}/wechatcheckTicket/ticketCheck.do";
                } else if (data == "freeze") {
                 //"该用户已被冻结!";
                    dialogAlert('系统提示',"该用户已被冻结");
                    $("#userName").focus();
                }
                else {
                    dialogAlert('系统提示',"用户名或密码错误");
                    //"用户名或密码错误!";
                    $("#pwd").focus();
                }
            });
        }
    </script>
    
    <style>
    	html,body,.main{height:100%}
        .content {padding-top: 100px;padding-bottom: 18px;}
    </style>
</head>
<body class="body">
	<div class="main">
	    <div class="content">
	        <div class="logo">
	            <img src="${path}/STATIC/wechat/image/logo.png" />
	            <p>佛山文化云活动验票系统</p>
	        </div>
	        <div class="user">
	            <div class="user-name">
	                <input type="text" placeholder="用户名"  id="userName"/>
	            </div>
	            <div class="user-password">
	                <input type="password" placeholder="密码" id="pwd"/>
	            </div>
	            <button type="button" onclick="userLogin()">登录</button>
	        </div>
	    </div>
	</div>
</body>
</html>
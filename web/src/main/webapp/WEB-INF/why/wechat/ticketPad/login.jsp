<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <%@include file="/WEB-INF/why/wechat/ticketPad/commonFramePad.jsp" %>
    <!-- <title>验票登陆</title> -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/ticket.css"/>
    
    <script type="text/javascript">
        function userLogin(){
            var userName=$('#userName').val();
            var pwd=$('#pwd').val();
            if (userName==undefined||userName=="") {
                $("#userName").focus();
                showDialog("请输入用户名!");
                return;
            }
            if (pwd==undefined||pwd=="") {
                $("#pwd").focus();
                showDialog("请输入密码!");
                return;
            }
            var asm = new Date().getTime();
            $.post("${path}/user/loginCheckSysUser.do?asm="+asm,{userAccount:userName,userPassword:pwd,userType:'ticketType'},function(data) {
                if (data == "success") {
                    window.location.href="${path}/wechatcheckTicket/ticketCheckPad.do";
                } else if (data == "freeze") {
                	showDialog("该用户已被冻结");
                    $("#userName").focus();
                }
                else {
                	showDialog("用户名或密码错误");
                    $("#pwd").focus();
                }
            });
        }
        
        //弹窗提示
        function showDialog(text){
        	$('.ipad-middle-pop p').html(text);
        	$('.ipad-middle-pop').show();
        }
    </script>
    
</head>
<body>
	<div class="main ipad" style="overflow: auto;">
		<div class="content ipad-middle">
			<div class="logo2" style="margin-top:0px;">
				<img src="${path}/STATIC/wechat/image/logo3.png" />
				<p style="color: #5e648f;font-size: 100px;margin: 50px 0px;">安康文化云自助验票</p>
			</div>
			<div class="ipad-user">
				<div class="ipad-user-name">
					<input id="userName" type="text" placeholder="用户名" style="background: url(${path}/STATIC/wechat/image/username.png) no-repeat 30px center;background-color: #fff;padding-left: 100px;" />
					<input id="pwd" type="password" placeholder="密码" style="background: url(${path}/STATIC/wechat/image/password2.png) no-repeat 30px center;background-color: #fff;padding-left: 100px;" />
				</div>
				<button type="button" onclick="userLogin()">确认</button>
			</div>
			<div class="ipad-middle-pop" style="display: none;">
				<img src="${path}/STATIC/wechat/image/warning.png" style="margin-top: 60px;" />
				<p style="margin:0 50px;"></p>
				<div class="ipad-pop-button" onclick="$('.ipad-middle-pop').hide();">确认</div>
			</div>
		</div>
	</div>
</body>
</html>
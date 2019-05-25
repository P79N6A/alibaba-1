<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head lang="en">
	<title>安康文化云内部订票系统</title>
	<%@include file="/WEB-INF/why/wechat/superOrder/commonFrame.jsp"%>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css">

    <script type="text/javascript">
    	var smsCode;
    	var type = '${type}';
	    
	    if (userId) {
	    	if(type) {
				window.location.href = type;
		    }else{
		    	window.location.href = '${path}/wechatSuperOrder/preActivityList.do';
		    }
	    }
	    
	  	//发送验证码
	    function sendSms() {
	        var userMobileNo = $("#userMobileNo").val();
	        var telReg = (/^1[34578]\d{9}$/);
	        if (!userMobileNo) {
	            dialogAlert('系统提示', '请输入手机号！');
	            return false;
	        } else if (!userMobileNo.match(telReg)) {
	            dialogAlert('系统提示', '请正确填写手机号！');
	            return false;
	        }
	        $.post("${path}/wechatSuperOrder/sendCode.do", {userMobileNo: userMobileNo,type:1}, function (data) {
	        	if (data.status == 200) {
	        		smsCode = data.data;
  	                var s = 60;
  	                $("#smsCodeBut").attr("onclick", "");
  	                $("#smsCodeBut").html(s + "s");
  	                var ss = setInterval(function () {
  	                    s -= 1;
  	                    $("#smsCodeBut").html(s + "s");
  	                    if (s == 0) {
  	                        clearInterval(ss);
  	                        $("#smsCodeBut").attr("onclick", "sendSms();");
  	                        smsCode = '';
  	                        $("#smsCodeBut").html("发送验证码");
  	                    }
  	                }, 1000)
  	            }else{
  	            	dialogAlert('系统提示', data.data);
  	            }
	        },"json");
	    }
    
	    //登录
        function userLogin() {
            var userMobileNo = $("#userMobileNo").val();
            if (!userMobileNo) {
                dialogAlert('系统提示', '请输入手机号');
                return false;
            }else{
            	var telReg = (/^1[34578]\d{9}$/);
                if (!userMobileNo.match(telReg)) {
                	dialogAlert('系统提示', '请输入正确的手机号');
                    return false;
                }
            }
            var loginCode = $("#loginCode").val();
            if (!loginCode) {
            	dialogAlert('系统提示', '请输入验证码');
                return
            }else if(loginCode!=smsCode){
                dialogAlert("系统提示", "请输入正确的短信验证码！");
                return;
            }
            $.post("${path}/wechatSuperOrder/superOrderUserLogin.do", {userMobileNo: userMobileNo,loginCode:loginCode}, function (data) {
            	if(data.status == 200) {
            		if(type) {
            			window.location.href = type;
                    }else {
                        window.location.href = '${path}/wechatSuperOrder/preActivityList.do';
                    }
            	}else{
  	            	dialogAlert('系统提示', data.data);
  	            }
            },"json");
        }
        
    </script>
    
    <style>
		html , body {background-color: #e1e4f1;}
		.inTickets {min-height: 100%;}
	</style>
</head>
<body>
	<div class="inTickets">
		<div class="logotp"></div>
		<p class="logowz">安康文化云内部订票系统</p>
		<div class="inTicInput clearfix">
			<div class="biao"><span>手机号</span></div>
			<input type="tel" class="txt" id="userMobileNo" maxlength="11">
		</div>
		<div class="inTicInput_yzm clearfix">
			<div class="inTicInput clearfix">
				<div class="biao"><span>验证码</span></div>
				<input type="tel" class="txt" id="loginCode" maxlength="6">
			</div>
			<div id="smsCodeBut" class="fsyzm" onclick="sendSms();">发送验证码</div>
		</div>
		<input class="inTicBtn" type="button" value="登  录" onclick="userLogin();">
	</div>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head lang="en">
	<title>登录</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css">
	<script type="text/javascript" src="${path}/STATIC/js/avalon.js"></script>
    <script type="text/javascript">
    	var mobileNo = "";	//动态登录手机号
	    
	    if (userId != null && userId != '') {
	    	if('${type}') {
	    		if('${type}'.indexOf("?")!=-1){
            		window.location.href = "${type}&userId="+userId;
            	}else{
            		window.location.href = "${type}?userId="+userId;
            	}
		    }else{
		    	window.location.href = '${path}/wechat/index.do';
		    }
	    }
    
        var dataForm = avalon.define({
            $id: "dataForm",
            userName: "${m}",
            userPwd: "",
            mobileErr: "",
            mobileNoErr:"",
            codeErr:"",
            pwdErr: ""
        });

        avalon.ready(function () {
        	if (is_weixin()) {
        		$("#wxLoginLi").show();
        	}
        	
            if (!dataForm.userName) {
                $("#userName").focus();
            }
            else {
                $(".userpwd").focus();
            }
        });

        function userLogin() {
            var a = dataForm.userName;
            if (!a) {
                dataForm.mobileErr = "请输入您的手机号";
                return
            }
            dataForm.mobileErr = "";
            var _thisReg = (/^1[34578]\d{9}$/);
            if (!a.match(_thisReg)) {
                dataForm.mobileErr = "请输入正确的手机号";
                return
            }
            var b = dataForm.userPwd;
            if (!b) {
                dataForm.pwdErr = "请输入密码";
                return
            }
            dataForm.pwdErr = "";
            $.ajax({
                type: "POST",
                url: '${path}/frontTerminalUser/terminalLogin.do?' + new Date().getTime(),
                data: dataForm.$model,
                dataType: "json",
                success: function (data) {
                    var c = eval(data);
                    if (c.status == "success") {
                        var type = '${type}';
                        if(type) {
                        	if(type.indexOf("?")!=-1){
                        		window.location.href = type+"&userId="+c.user.userId;
                        	}else{
                        		window.location.href = type+"?userId="+c.user.userId;
                        	}
                        }
                        else {
                            window.location.href = '${path}/wechat/index.do';
                        }
                    } else {
                        if (c.status == "noActive") {
                            $("#userName").focus();
                            dataForm.mobileErr = "账号未完成注册，请重新注册"
                        } else {
                            if (c.status == "isFreeze") {
                                dataForm.mobileErr = "账号已冻结";
                            }else if(c.status=="LoginLimit"){
                                dataForm.mobileErr = "密码输错次数过多,请明天再试";
                            } else {
                                dataForm.mobileErr = "账号和密码不匹配，请重新输入";
                            }
                        }
                    }
                },
                error: function () {
                }
            });
        }
        
        function toRegister(){
       		if('${type}') {
   				window.location.href = '${path}/muser/register.do?type=${type}';
   		    }else{
   		    	window.location.href = '${path}/muser/register.do';
   		    }
        }
        
        function toForget(){
       		if('${type}') {
   				window.location.href = '${path}/muser/forget.do?type=${type}';
   		    }else{
   		    	window.location.href = '${path}/muser/forget.do';
   		    }
        }
        
        $(function () {
			$('.logintitUl li').bind('click', function () {
				$('.logintitUl li').removeClass('current');
				$(this).addClass('current');
				$('.login-account-hide .login-account-wc').hide();
				$('.login-account-hide .login-account-wc').eq($(this).index()).show();
			});
		});
        
      	//发送验证码
        function sendSms() {
        	$("#smsCodeBut").attr("onclick", "");
            mobileNo = $("#mobileNo").val();
            var telReg = (/^1[34578]\d{9}$/);
            if (mobileNo == "") {
                dataForm.mobileNoErr="请输入手机号！";
                $("#smsCodeBut").attr("onclick", "sendSms();");
                return false;
            } else if (!mobileNo.match(telReg)) {
            	dataForm.mobileNoErr="请正确填写手机号！";
            	$("#smsCodeBut").attr("onclick", "sendSms();");
                return false;
            }else{
            	dataForm.mobileNoErr="";
            }
            $.post("${path}/muser/loginSendCode.do", {mobileNo: mobileNo}, function (data) {
            	if (data.status == 1) {
  	                var s = 60;
  	                $("#smsCodeBut").html(s + "秒后重新获取");
  	                var ss = setInterval(function () {
  	                    s -= 1;
  	                    $("#smsCodeBut").html(s + "秒后重新获取");
  	                    if (s == 0) {
  	                        clearInterval(ss);
  	                        $("#smsCodeBut").attr("onclick", "sendSms();");
  	                        $("#smsCodeBut").html("发送验证码");
  	                    }
  	                }, 1000);
  	            }else{
  	            	$("#smsCodeBut").attr("onclick", "sendSms();");
  	            }
            }, "json");
      	}
      	
      	//验证码登录
        function userCodeLogin() {
        	$("#codeLoginBtn").attr("onclick", "");
            if (mobileNo != $("#mobileNo").val()) {
                dataForm.mobileNoErr="手机号错误，请重新发送验证码！";
                $("#codeLoginBtn").attr("onclick", "userCodeLogin();");
                return false;
            }else{
            	dataForm.mobileNoErr="";
            }
            var code = $("#loginCode").val();
            if(!code){
            	dataForm.codeErr="请输入验证码";
            	$("#codeLoginBtn").attr("onclick", "userCodeLogin();");
            	return false;
            }else if(code.length!=6){
            	dataForm.codeErr="验证码长度有误";
            	$("#codeLoginBtn").attr("onclick", "userCodeLogin();");
            	return false;
            }else{
            	dataForm.codeErr="";
            }
            $.post("${path}/muser/codeLogin.do", {mobileNo: mobileNo,code:code,callback :'${type}'}, function (data) {
            	if (data.status == 1) {
            		if(data.data.status == "success"){
            			var type = '${type}';
                        if(type) {
                        	if(type.indexOf("?")!=-1){
                        		window.location.href = type+"&userId="+data.data.userId;
                        	}else{
                        		window.location.href = type+"?userId="+data.data.userId;
                        	}
                        }else {
                            window.location.href = '${path}/wechat/index.do';
                        }
            		}else{
            			$("#codeLoginBtn").attr("onclick", "userCodeLogin();");
            			dataForm.codeErr=data.data.errorMsg;
            		}
  	            }else{
  	            	$("#codeLoginBtn").attr("onclick", "userCodeLogin();");
  	            	dataForm.codeErr="响应失败！";
  	            }
            }, "json");
      	}
    </script>
    
    <style>
    	.ms-controller, .ms-important, [ms-controller], [ms-important] {visibility: hidden}
    	html,body,.main,.content {height: 100%;}
    	.error-tip{ display: block; line-height: 1.2em; color: #FF4D4D; font-size: 30px; margin-bottom: 10px;}
		.content {padding: 0;}
	</style>
</head>
<body>
	<div class="main">
		<div class="content" ms-controller="dataForm">
			<ul class="logintitUl clearfix">
				<li class="current"><a href="javascript:;">账号密码登录</a></li>
				<li><a href="javascript:;">手机动态密码登录</a></li>
				<li class="xian"></li>
			</ul>
			<div class="login-account-hide">
				<div class="login-account-wc">
					<form>
						<div class="login-account">
							<ul>
								<li class="border-bottom">
									<p>手机号</p>
		                			<input type="tel" class="username" id="userName" placeholder="手机号" maxlength="11" ms-duplex="userName"/>
									<div style="clear: both;"></div>
								</li>
								<li class="border-bottom">
									<p class="w2">密码</p>
									
		              	 			<input type="password" class="userpwd" placeholder="6-20位字母、数字和符号" ms-duplex="userPwd"/>
									<div style="clear: both;"></div>
								</li>
							</ul>
							<div class="forget">
								<a href="javascript:toForget();">忘记密码?</a>
							</div>
						</div>
						
						<div style="margin: 40px">
							<span class="error-tip">{{mobileErr}}</span>
							<span class="error-tip">{{pwdErr}}</span>
						</div>
						<div style="clear: both;"></div>
						<div class="login-button">
							<button type="button" onclick="userLogin()">登录</button>
						</div>
						<div class="login-zhuc"><img src="${path}/STATIC/wechat/image/jiant.png">我没有账号，<a href="javascript:toRegister();">立即注册</a></div>
						<div id="otherLoginDiv">
							<div class="login-other">
								<hr />
								<div>
									<p>其他登录方式</p>
								</div>
							</div>
							<div class="login-other-icon">
								<ul>

								<li class="login-other-icon-mr">
									<img src="${path}/STATIC/image/loginBtn.png" onclick="window.location.href='${path}/muser/readCardLogin.do?type=${type}'"/>
									<p style="text-align: center;font-size: 24px;"></p>
									</li>

									<li class="login-other-icon-mr" id="wxLoginLi" style="display: none;">
										<img src="${path}/STATIC/wechat/image/微信_big.png" onclick="window.location.href='${path}/wxUser/silentInvoke.do?type=${type}'"/>
										<p style="text-align: center;font-size: 24px;">微信</p>
									</li>
									<%--<li class="login-other-icon-mr">
										<img src="${path}/STATIC/wechat/image/qq_big.png" onclick="window.location.href='${path}/qq/login.do?callback=${type}'"/>
										<p style="text-align: center;font-size: 24px;">QQ</p>
									</li>
									<li>
										<img src="${path}/STATIC/wechat/image/微博_big.png" onclick="window.location.href='${path}/sina/login.do?callback=${type}'"/>
										<p style="text-align: center;font-size: 24px;">微博</p>
									</li>&ndash;%&gt;--%>
									<div style="clear: both;"></div>
								</ul>
							</div>
						</div>
					</form>
				</div>
				<div class="login-account-wc" style="display:none;">
					<div class="login-account">
						<ul>
							<li class="border-bottom">
								<p>手机号</p>
								<input type="text" placeholder="请输入11位手机号" id="mobileNo" maxlength="11"/>
								<div style="clear: both;"></div>
							</li>
							<li class="border-bottom">
								<p>验证码</p>
								<input type="tel" placeholder="请输入6位验证码" style="width:326px;" id="loginCode" maxlength="6"/>
								<div class="yanzm" id="smsCodeBut" onclick="sendSms();">发送验证码</div>
								<div style="clear: both;"></div>
							</li>
						</ul>
						<div style="margin: 40px">
							<span class="error-tip">{{mobileNoErr}}</span>
							<span class="error-tip">{{codeErr}}</span>
						</div>
					</div>
					<div class="login-button">
						<button type="button" onclick="userCodeLogin();" id="codeLoginBtn">登录</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
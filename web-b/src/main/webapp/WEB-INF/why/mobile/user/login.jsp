<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head lang="en">
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <!-- <title>文化云登录</title> -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css">
    <style type="text/css">
    	.ms-controller, .ms-important, [ms-controller], [ms-important] {visibility: hidden}
    	html,body,.main,.content {height: 100%;}
    	.error-tip{ display: block; line-height: 1.2em; color: #FF4D4D; font-size: 30px; margin-bottom: 10px;}
    </style>
    <script src="${path}/STATIC/js/avalon.js"></script>

    <script type="text/javascript">
	    var userId = '${sessionScope.terminalUser.userId}';
	    if (userId != null && userId != '') {
	    	if('${type}') {
				window.location.href = '${type}';
		    }else{
		    	window.location.href = '${path}/wechat/index.do';
		    }
	    }
    
        var dataForm = avalon.define({
            $id: "dataForm",
            userName: "${m}",
            userPwd: "",
            mobileErr: "",
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
                dataForm.mobileErr = "请输入您的手机号码";
                return
            }
            dataForm.mobileErr = "";
            var _thisReg = (/^1[34578]\d{9}$/);
            if (!a.match(_thisReg)) {
                dataForm.mobileErr = "请输入正确的手机号码";
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
    </script>
    
    <style>
		.content {padding: 0;margin-top: 100px;}
	</style>
</head>
<body>
	<div class="main">
		<div class="header">
			<div class="index-top">
				<span class="index-top-5">
					<img src="${path}/STATIC/wechat/image/arrow1.png" onclick="history.go(-1);"/>
				</span>
				<span class="index-top-2">登录</span>
				<span class="index-top-4" onclick="window.location.href='${path}/muser/register.do'">注册</span>
			</div>
		</div>
		<div class="content" ms-controller="dataForm">
			<form>
				<div class="login-account">
					<ul>
						<li class="border-bottom">
							<p>手机号码</p>
                			<input type="tel" class="username" id="userName" placeholder="手机号码" maxlength="11" ms-duplex="userName"/>
							<div style="clear: both;"></div>
						</li>
						<li>
							<p class="w2">密码</p>
							
              	 			<input type="password" class="userpwd" placeholder="6-20位字母、数字和符号" ms-duplex="userPwd"/>
							<div style="clear: both;"></div>
						</li>
					</ul>
				</div>
				<div class="forget">
					<a href="${path}/muser/forget.do">忘记密码?</a>
				</div>
				<div style="margin: 40px">
					<span class="error-tip">{{mobileErr}}</span>
					<span class="error-tip">{{pwdErr}}</span>
				</div>
				<div style="clear: both;"></div>
				<div class="login-button">
					<button type="button" onclick="userLogin()">登录</button>
				</div>
				<div id="otherLoginDiv">
					<div class="login-other">
						<hr />
						<div>
							<p>其他登录方式</p>
						</div>
					</div>
					<div class="login-other-icon">
						<ul>
							<li class="login-other-icon-mr" id="wxLoginLi" style="display: none;">
								<img src="${path}/STATIC/wechat/image/微信_big.png" onclick="window.location.href='${path}/wxUser/silentInvoke.do?type=${type}'"/>
							</li>
							<li class="login-other-icon-mr">
								<img src="${path}/STATIC/wechat/image/qq_big.png" onclick="window.location.href='${path}/qq/login.do?callback=${type}'"/>
							</li>
							<li>
								<img src="${path}/STATIC/wechat/image/微博_big.png" onclick="window.location.href='${path}/sina/login.do?callback=${type}'"/>
							</li>
							<div style="clear: both;"></div>
						</ul>
					</div>
				</div>
			</form>
		</div>
		<div class="footer">
			
		</div>
	</div>
</body>
</html>
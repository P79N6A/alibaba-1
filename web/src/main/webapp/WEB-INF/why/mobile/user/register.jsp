<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head lang="en">
  <title>注册</title>
  <%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
  <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css">
  <script src="${path}/STATIC/js/avalon.js"></script>  

  <script>
          var dataForm = avalon.define({
            $id:"dataForm",
            userName:"",
            userMobileNo:"",
            userPwd:"",
            confirmPwd:"",
            code:"",
            timeOut:0,
            userId:"",
            userSex:1,
            userNameErr:"",
            userPwdErr:"",
            confirmPwdErr:"",
            codeErr:"",
            mobileErr:""
          });
          function addSendEvent(){
            $("#sendCode").click(function(){
              sendCode();
            });
          }
          function addRegEvent(){
            $("#register").click(function(){
              saveRegister();
            });
          }
          $(function(){
            addSendEvent();
            addRegEvent();
          });

          function smsTimer () {
            var timeOut = dataForm.timeOut;
            if (timeOut === 0) {
              addSendEvent();
            }else{
              dataForm.timeOut--;
              setTimeout( function(){
                        smsTimer();},1000
              );
            }
          }


          function valInfo(){
            if(valMobile() && valUserName() &&  valPwd() && valConfirmPwd()){
              return true;
            }
            return false;
          }

          function sendCode(){
            if(!valInfo()){
              return;
            }
            $("#sendCode").unbind("click");
            sendSmsCode();
          }

          function sendSmsCode(){
            $.ajax({
              type: "POST",
              data:{
                userMobileNo:dataForm.userMobileNo,
                userName:dataForm.userName,
                userPwd:dataForm.userPwd,
                type:'${type}'
              },
              url: "${path}/frontTerminalUser/sendSmsCode.do?"+new Date().getTime(),
              dataType: "json",
              success: function (data) {
                if(data.result == "success") {
                  dataForm.timeOut=60;
                  smsTimer();
                  dataForm.userId=data.userId;
                }else if(data.result == "repeat"){
                  dataForm.mobileErr="该手机号已经注册过";
                  addSendEvent();
                }else if(data.result == "third"){
                  dataForm.codeErr="短信验证码发送超过三次,请明天再试";
                }else{

                }
              },
              error: function(){
              }
            });
          }


          function saveRegister(){
            if(!valInfo()){
              return;
            }
            if(!valCode()){
              return;
            }

            $("#register").unbind("click");
            $.post("${path}/frontTerminalUser/saveUser.do?asm="+new Date().getTime(),
                    dataForm.$model,
                    function(rsData) {
                      var data = eval(rsData);
                      if (data.status == "success") {
                        //window.location.href="${path}/muser/regResult.do"
                        //window.location.href = '${path}/wechat/index.do';
                    	//window.location.href="${path}/wechat/open.do"
                    	if('${type}') {
							window.location.href = '${type}';
					    }else{
					    	window.location.href = '${path}/wechat/index.do';
					    }
                      }else if(data.status == "SmsCodeErr"){
                        dataForm.codeErr="验证码验证失败,请确认验证码是否正确";
                        addRegEvent();
                      }else if(data.status == "repeat"){
                        dataForm.mobileErr="手机号已注册";
                        addRegEvent();
                      }else if(data.status=="NoValMobile"){
                        dataForm.codeErr="未获取验证码";
                        addRegEvent();
                      }
                    });
          }


          function valCode(){
            if(!dataForm.userId){
              dataForm.codeErr="未获取验证码";
              return;
            }
            var code=dataForm.code;
            if(!code){
              dataForm.codeErr="请输入验证码";
              return false;
            }else if(code.length!=6){
              dataForm.codeErr="验证码长度有误";
              return false;
            }
            return true;
          }

          avalon.ready(function(){
            $("#userName").focus();
          });

          function toLogin(){
       		if('${type}') {
   				window.location.href = '${path}/muser/login.do?type=${type}';
   		    }else{
   		    	window.location.href = '${path}/muser/login.do';
   		    }
          }
  </script>
  
  <style>
		.ms-controller,.ms-important,[ms-controller],[ms-important]{visibility:hidden}
		.error-tip{ display: block; line-height: 1.2em; color: #FF4D4D; font-size: 30px; margin-bottom: 10px;}
		html,body,.main,.content {
			height: 100%;
			padding-bottom: 0;
		}
  </style>
</head>

<body>
	<div class="main" ms-controller="dataForm">
		<div class="content">
			<div class="login-account-wc">
				<div class="login-account">
					<ul>
						<li class="border-bottom">
							<p>手机号</p>
      						<input type="tel" placeholder="请输入11位手机号" maxlength="11" onblur="this.value=this.value.replace(/\D/g,'')" id="userName" ms-duplex="userMobileNo" />
							<div style="clear: both;"></div>
						</li>
						<li class="border-bottom">
							<p class="w2">昵称</p>
      						<input type="text" placeholder="输入7字以内的昵称" ms-duplex="userName" maxlength="7"/>
							<div style="clear: both;"></div>
						</li>
						<li class="border-bottom">
							<p class="w2">密码</p>
      						<input type="password" placeholder="输入6～20位密码" ms-duplex="userPwd" maxlength="20"/>
							<div style="clear: both;"></div>
						</li>
						<li class="border-bottom">
							<p>确认密码</p>
      						<input type="password" placeholder="确认密码" ms-duplex="confirmPwd" />
							<div style="clear: both;"></div>
						</li>
						<li class="border-bottom">
							<p>验证码</p>
							<div class="yzm clearfix">
							  <input type="tel" class="fl" placeholder="请输入6位验证码" maxlength="6" ms-duplex="code" style="width:326px;" onblur="this.value=this.value.replace(/\D/g,'')" />
							  <a href="javascript:;" class="fr"  id="sendCode">
							    <span ms-if="timeOut==0" class="yanzm">发送验证码</span>
							    <span ms-if="timeOut>0" class="yanzm">{{timeOut}}秒后重新获取</span>
							  </a>
							</div>
							<div style="clear: both;"></div>
						</li>
					</ul>
					<div style="margin: 40px">
						<span class="error-tip">{{mobileErr}}</span>
						<span class="error-tip">{{userNameErr}}</span>
						<span class="error-tip">{{userPwdErr}}</span>
						<span class="error-tip">{{confirmPwdErr}}</span>
						<span class="error-tip">{{codeErr}}</span>
					</div>
				</div>
				<div class="login-button">
					<button type="button" class="next" id="register">注册</button>
				</div>
				<div class="login-zhuc"><img src="${path}/STATIC/wechat/image/jiant.png">我有账号，<a href="javascript:toLogin();">立即登录</a></div>
			</div>
		</div>
	</div>

<script>
  function checkPass(pass){
    var ls = 1;
    if(pass.match(/([0-9])+/)){ls+=1;}
    if(pass.match(/([a-z])+/) || pass.match(/([A-Z])+/)){ls+=1;}
    return ls;
  }

  function valUserName(){
    var userName=dataForm.userName;
    if(!$.trim(userName)){
      dataForm.userNameErr="请输入昵称";
      return false;
    }
    var nameReg = (/^[a-zA-Z0-9\u4e00-\u9fa5]+$/);
	if(!userName.match(nameReg)){
    	dataForm.userNameErr="昵称只能由中文，字母，数字组成";
        return false;
    }
    dataForm.userNameErr="";
    return true;
  }

  function valPwd(){
    var  userPwd= dataForm.userPwd;
    // 密码
    if(userPwd==""){
      dataForm.userPwdErr="请输入密码";
      return false;
    }else if(userPwd.length<6){
      dataForm.userPwdErr="密码至少6位";
      return false;
    }else if(userPwd.length>20){
      dataForm.userPwdErr="密码不能超过20位";
      return false;
    }
    //格式
    if(checkPass(userPwd)<3){
      dataForm.userPwdErr="密码格式不正确,必须是字母数字组合";
      return false;
    }else{
      dataForm.userPwdErr="";
    }
    return true;
  }

  function valConfirmPwd(){
    var  userPwd=dataForm.userPwd;
    var  confirmPassword=dataForm.confirmPwd;
    if(confirmPassword==""){
      dataForm.confirmPwdErr="请输入确认密码";
      return false;
    }else if(confirmPassword.length<6){
      dataForm.confirmPwdErr="确认密码至少6位";
      return false;
    }else if(confirmPassword.length>20){
      dataForm.confirmPwdErr="确认密码不能超过20位";
      return false;
    }else if(confirmPassword!=userPwd){
      dataForm.confirmPwdErr="两次输入密码不一致";
      return false;
    }
    if(checkPass(confirmPassword)<3){
      dataForm.confirmPwdErr="密码格式不正确,必须是字母数字组合";
      return false;
    }else{
      dataForm.confirmPwdErr="";
    }
    return true;
  }

  function valMobile(){
    var  userMobileNo=dataForm.userMobileNo;
    var telReg = (/^1[34578]\d{9}$/);
    // 联系电话
    if(userMobileNo ==""){
      dataForm.mobileErr="请输入手机号";
      return false;
    }else if(!userMobileNo.match(telReg)){
      dataForm.mobileErr="请正确填写手机号";
      return false;
    }else{
      dataForm.mobileErr="";
    }
    return true;
  }
</script>
</body>
</html>
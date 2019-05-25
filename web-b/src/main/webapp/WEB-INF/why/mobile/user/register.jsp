<%--
  Created by IntelliJ IDEA.
  User: niubiao
  Date: 2016/1/13
  Time: 13:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%request.setAttribute("path",request.getContextPath());%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<!DOCTYPE html>
<html>
<head lang="en">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta name="viewport" content="width=device-width,initial-scale=1.0,user-scalable=0,minimum-scale=1.0,maximum-scale=1.0">
  <meta name="apple-mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-status-bar-style" content="black">
  <!-- <title>注册</title> -->
  <link rel="stylesheet" type="text/css" href="${path}/STATIC/mobile/css/reset.css"/>
  <link rel="stylesheet" type="text/css" href="${path}/STATIC/mobile/css/M-login.css"/>
  <style type="text/css">.ms-controller,.ms-important,[ms-controller],[ms-important]{visibility:hidden}</style>
  <script src="${path}/STATIC/mobile/js/jquery.min.js"></script>
  <script src="${path}/STATIC/js/avalon.js"></script>
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
                userPwd:dataForm.userPwd
              },
              url: "${path}/frontTerminalUser/sendSmsCode.do?"+new Date().getTime(),
              dataType: "json",
              success: function (data) {
                if(data.result == "success") {
                  dataForm.timeOut=60;
                  smsTimer();
                  dataForm.userId=data.userId;
                }else if(data.result == "repeat"){
                  dataForm.mobileErr="该手机号码已经注册过";
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
                        window.location.href = '${path}/wechat/index.do';
                    	//window.location.href="${path}/wechat/open.do"
                      }else if(data.status == "SmsCodeErr"){
                        dataForm.codeErr="验证码验证失败,请确认验证码是否正确";
                        addRegEvent();
                      }else if(data.status == "repeat"){
                        dataForm.mobileErr="手机号码已注册";
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

  </script>
  <!--移动端版本兼容 end -->
</head>
<body>
<div class="content" ms-controller="dataForm">
  <!--do start-->
  <div class="top_arrow">
    <a href="javascript:window.history.go(-1);"><img src="${path}/STATIC/mobile/images/l_arrow.png" width="25" height="42"/></a>
  </div>
  <!--do end-->
  <!--register start-->
  <div class="find_pwd register">
    <h1>注册新用户</h1>
    <div class="txt">
      <span class="error-tip">{{mobileErr}}</span>
      <input type="tel" placeholder="输入手机号" maxlength="11" onblur="this.value=this.value.replace(/\D/g,'')"
             id="userName" ms-duplex="userMobileNo" />
    </div>

    <div class="txt" style="margin-top:20px;">
      <span class="error-tip">{{userNameErr}}</span>
      <input type="text" placeholder="输入昵称" ms-duplex="userName" maxlength="10"/>
    </div>

    <div class="txt" style="margin-top:20px;">
      <span class="error-tip">{{userPwdErr}}</span>
      <input type="password" placeholder="输入密码" ms-duplex="userPwd"/>
    </div>

    <div class="txt" style="margin-top:20px;">
      <span class="error-tip">{{confirmPwdErr}}</span>
      <input type="password" placeholder="确认密码" ms-duplex="confirmPwd" /></div>
    <div class="txt" style="margin-top:20px;" >
      <span class="error-tip">{{codeErr}}</span>
      <div class="yzm clearfix">
        <input type="tel" class="fl" placeholder="输入验证码" maxlength="6"
               ms-duplex="code"  onblur="this.value=this.value.replace(/\D/g,'')" />
        <a href="javascript:;" class="fr"  id="sendCode">
          <span ms-if="timeOut==0">获取验证码</span>
          <span ms-if="timeOut>0">{{timeOut}}秒后重新获取</span>
        </a>
      </div>
    </div>
    <a href="javascript:;" class="next" id="register">注 册</a>
  </div>
  <!--register end-->
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
    }else if(userPwd.length>12){
      dataForm.userPwdErr="密码不能超过12位";
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
    }else if(confirmPassword.length>12){
      dataForm.confirmPwdErr="确认密码不能超过12位";
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
      dataForm.mobileErr="请输入手机号码";
      return false;
    }else if(!userMobileNo.match(telReg)){
      dataForm.mobileErr="请正确填写手机号码";
      return false;
    }else{
      dataForm.mobileErr="";
    }
    return true;
  }

</script>

</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%request.setAttribute("path",request.getContextPath());%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>--%>
<!DOCTYPE html>
<html>
<head lang="en">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta name="viewport" content="width=device-width,initial-scale=1.0,user-scalable=0,minimum-scale=1.0,maximum-scale=1.0">
  <meta name="apple-mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-status-bar-style" content="black">
  <!-- <title>找回密码</title> -->
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
  <!--移动端版本兼容 end -->
</head>
<body>
<div class="content" ms-controller="forget">
  <!--do start-->
  <div class="top_arrow">
    <a href="javascript:history.go(-1);"><img src="${path}/STATIC/mobile/images/l_arrow.png" width="25" height="42"/></a>
  </div>
  <!--do end-->
  <!--find_pwd start-->
  <div class="find_pwd">
    <h1>找回密码</h1>
    <div class="txt">
      <span class="error-tip">{{mobileErr}}</span>
      <input type="tel" placeholder="请输入手机号码" ms-duplex="userMobile" maxlength="11"
             onblur="this.value=this.value.replace(/\D/g,'')"  id="userName" />
    </div>
    <div class="txt" style="margin-top: 20px;">
      <span class="error-tip">{{codeErr}}</span>
      <div class="yzm">
        <input type="tel" class="fl" placeholder="请输入验证码" ms-duplex="code" maxlength="6"
               onblur="this.value=this.value.replace(/\D/g,'')" />
        <a href="javascript:;" class="fr" id="sendCode">
          <span ms-if="timeOut==0">获取验证码</span>
          <span ms-if="timeOut>0">{{timeOut}}秒后重新获取</span>
        </a>
      </div>
    </div>
    <a href="javascript:;" class="next" id="passNext">下 一 步</a>
  </div>
  <!--find_pwd end-->
  <form id="userForm" action="${path}/muser/setPass.do" method="post">
        <input type="hidden" name="resCode" ms-duplex="resCode" />
        <input type="hidden" name="code" ms-duplex="code" />
  </form>

</div>

<script>
  var dataModel = avalon.define({
    $id:"forget",
    userMobile:"",
    resCode:"",
    code:"",
    timeOut:0,
    codeErr:"",
    mobileErr:""
  });

  function addSendEvent(){
      $("#sendCode").click(function(){
          sendSmsCode();
      });
  }
  function addNextEvent(){
    $("#passNext").click(function(){
        passNextStep();
    });
  }
  $(function(){
        addSendEvent();
        addNextEvent();
  });

  function smsTimer () {
    var timeOut=dataModel.timeOut;
    if (timeOut === 0) {
      addSendEvent();
    }else {
      dataModel.timeOut--;
      setTimeout(function () {
        smsTimer();
      }, 1000);
    }
  }

  function passNextStep(){
    if(!valMobile()){
      return;
    }
    var code =dataModel.code;
    if(!dataModel.resCode){
      dataModel.codeErr="未获取验证码";
      return;
    }
    if($.trim(code)==""){
     dataModel.codeErr="请填写手机验证码";
     return;
    }
    if(code.length!=6){
      dataModel.codeErr="验证码长度有误";
      return;
    }
    dataModel.codeErr="";
    $("#passNext").unbind("click");

    $.ajax({
      type: "POST",
      data:dataModel.$model,
      url: "${path}/frontTerminalUser/valForgetCode.do?"+new Date().getTime(),
      dataType: "json",
      success: function (data) {
        if(data=="success"){
          $("#userForm").submit();
        }else{
          addNextEvent();
          dataModel.codeErr="验证码验证失败";
        }
      }
    });
  }

  function sendSmsCode(){
    if(!valMobile()){
      return;
    }
    $("#sendCode").unbind("click");
    $.ajax({
      type: "POST",
      data:{
        userMobileNo:dataModel.userMobile
      },
      url: "${path}/frontTerminalUser/sendForgetCode.do?"+new Date().getTime(),
      dataType: "json",
      success: function (data) {
        if(data.result == "success") {
          dataModel.timeOut=60;
          smsTimer();
          dataModel.resCode=data.resCode;
        }else if(data.result == "NotFound"){
          addSendEvent();
          dataModel.mobileErr="用户不存在";
        }else if(data.result == "third"){
          dataModel.codeErr="短信验证码发送超过三次,请明天再试";
        }else if(data.result == "NotReg"){
          dataModel.mobileErr="用户不存在";
        }else if(data.result == "Freeze"){
          dataModel.mobileErr="账户已冻结";
        }
      },
      error:function(){
      }
    });
  }

  function valMobile(){
    var userMobileNo = dataModel.userMobile;
    var telReg = (/^1[34578]\d{9}$/);
    if(userMobileNo ==""){
      dataModel.mobileErr="请填写手机号码";
      return false;
    }else if(!userMobileNo.match(telReg)){
      dataModel.mobileErr="请正确填写手机号码";
      return false;
    }else{
      dataModel.mobileErr="";
    }
    return true;
  }

  avalon.ready(function(){
    $("#userName").focus();
  });

</script>

</body>
</html>
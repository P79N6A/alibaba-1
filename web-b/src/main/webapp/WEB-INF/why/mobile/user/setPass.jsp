<%--
  Created by IntelliJ IDEA.
  User: niubiao
  Date: 2016/1/13
  Time: 16:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>--%>
<!DOCTYPE html>
<html>
<head lang="en">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=0, minimum-scale=1.0, maximum-scale=1.0">
  <meta name="apple-mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-status-bar-style" content="black">
  <!-- <title>设置新密码</title> -->
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


    function addHandlerEvent(){
      $("#handler").click(function(){
          saveNewPass();
      });
    }

    $(function(){
        addHandlerEvent();
    });

    function checkPass(pass){
      var ls = 1;
      if(pass.match(/([0-9])+/)){ls+=1;}
      if(pass.match(/([a-z])+/) || pass.match(/([A-Z])+/)){ls+=1;}
      return ls;
    }

    function valPwd(){
      var  userPwd= dataForm.userPwd;
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

    function saveNewPass(){
          if(!(valPwd()&&valConfirmPwd())){
            return;
          }
          $("#handler").unbind("click");
          $.ajax({
            type: "POST",
            data:dataForm.$model,
            url: "${path}/frontTerminalUser/setNewPass.do?"+new Date().getTime(),
            dataType: "json",
            success: function (data) {
              if(data=="success"){
                location.href="${path}/muser/setPassResult.do?m="+dataForm.userMobileNo+"&"+new Date().getTime();
              }else{
                addHandlerEvent();
                dataForm.confirmPwdErr="系统繁忙,请稍后重试";
              }
            }
          });
    }

    var dataForm = avalon.define({
      $id:"setPass",
      reqCode:"${reqCode}",
      userPwd:"",
      confirmPwd:"",
      userPwdErr:"",
      confirmPwdErr:""
    });
  </script>
  <!--移动端版本兼容 end -->
</head>
<body>
<div class="content">
  <!--do start-->
  <div class="top_arrow">
    <a href="javascript:history.go(-1);"><img src="${path}/STATIC/mobile/images/l_arrow.png" width="25" height="42"/></a>
  </div>
  <!--do end-->
  <!--find_pwd start-->
  <div class="find_pwd" ms-controller="setPass">
    <h1>找回密码</h1>
    <div class="txt">
      <span class="error-tip">{{userPwdErr}}</span>
      <input type="password" placeholder="输入新密码" ms-duplex="userPwd" maxlength="12"/>
    </div>
    <div class="txt" style="margin-top:20px;">
      <span class="error-tip">{{confirmPwdErr}}</span>
      <input type="password"  placeholder="确定新密码" ms-duplex="confirmPwd" maxlength="12"/>
    </div>
    <a href="javascript:;" class="next" id="handler">确 定</a>
  </div>
  <!--find_pwd end-->
</div>
</body>
</html>
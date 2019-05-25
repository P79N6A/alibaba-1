<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head lang="en">
  <%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <!-- <title>修改密码</title> -->
  <link rel="stylesheet" type="text/css" href="${path}/STATIC/mobile/css/reset.css"/>
  <link rel="stylesheet" type="text/css" href="${path}/STATIC/mobile/css/M-login.css"/>
  <style type="text/css">.ms-controller,.ms-important,[ms-controller],[ms-important]{visibility:hidden}</style>
  <script src="${path}/STATIC/js/avalon.js"></script>

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


    function valOldPwd(){
      var  userPwd= dataForm.oldPass;
      if(userPwd==""){
        dataForm.oldPassErr="请输入密码";
        return false;
      }else if(userPwd.length<6){
        dataForm.oldPassErr="密码至少6位";
        return false;
      }else if(userPwd.length>20){
        dataForm.oldPassErr="密码不能超过20位";
        return false;
      }
      dataForm.oldPassErr="";
      return true;
    }

    function valPwd(){
      var  userPwd= dataForm.userPwd;
      var oldPass =  dataForm.oldPass;

      if(userPwd===oldPass){
        dataForm.userPwdErr="原密码不能和新密码一致";
        return false;
      }
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

    function saveNewPass(){
          if(!(valOldPwd()&&valPwd()&&valConfirmPwd())){
            return;
          }


      $.ajax({
        type: "POST",
        data:{
          userName:'${user.userMobileNo}',
          userPwd:dataForm.oldPass,
          asm:new Date().getTime()
        },
        url: "${path}/frontTerminalUser/terminalLogin.do?"+new Date().getTime(),
        dataType: "json",
        success: function (data) {
          if (data.status == "success") {
                $("#handler").unbind("click");
                $.ajax({
                  type: "POST",
                  data:dataForm.$model,
                  url: "${path}/frontTerminalUser/userModifyPwd.do?"+new Date().getTime(),
                  dataType: "json",
                  success: function (data) {
                    if(data=="success"){
                        window.location.href="${path}/muser/setPassResult.do?m="+dataForm.userMobileNo+"&type=${type}&"+new Date().getTime();
                    }else{
                        addHandlerEvent();
                        dataForm.confirmPwdErr="系统繁忙,请稍后重试";
                    }
                  }
                });
          }else{
            dataForm.oldPassErr="原密码错误";
          }

        }
      });
    }

    var dataForm = avalon.define({
      $id:"setPass",
      userId:"${user.userId}",
      userPwd:"",
      oldPass:"",
      oldPassErr:"",
      confirmPwd:"",
      userPwdErr:"",
      confirmPwdErr:"",
      userMobileNo:'${user.userMobileNo}'
    });
  </script>
  
</head>
<body>
<div class="content">
  <div class="top_arrow">
    <a href="javascript:history.go(-1);"><img src="${path}/STATIC/mobile/images/l_arrow.png" width="25" height="42"/></a>
  </div>
  <div class="find_pwd" ms-controller="setPass">
    <h1>修改密码</h1>
    <div class="txt">
      <span class="error-tip">{{oldPassErr}}</span>
      <input type="password" placeholder="输入原密码" ms-duplex="oldPass" maxlength="20"/>
    </div>

    <div class="txt">
      <span class="error-tip">{{userPwdErr}}</span>
      <input type="password" placeholder="输入新密码" ms-duplex="userPwd" maxlength="20"/>
    </div>
    <div class="txt" style="margin-top:20px;">
      <span class="error-tip">{{confirmPwdErr}}</span>
      <input type="password"  placeholder="确定新密码" ms-duplex="confirmPwd" maxlength="20"/>
    </div>
    <a href="javascript:;" class="next" id="handler">确 定</a>
  </div>
</div>
</body>
</html>
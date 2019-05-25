<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <title>取票机--登录--文化云</title>
  <%@include file="/WEB-INF/why/common/ticketFrame.jsp"%>
  <script type="text/javascript" src="${path}/STATIC/js/placeholder.js"></script>
  <script type="text/javascript" src="${path}/STATIC/js/keyboard.js"></script>
  <script type="text/javascript">

    $(document).click(function(e){
      checkData();
    });

    $(function() {
      $('#loginForm .input-txt').blur(function () {
        checkData();
      });
    });

    function checkData() {
      var a = $("#userName").val();
      if ($.trim(a) == "" || a == "请输入您的手机号") {
        removeMsg("userNameMsg");
        appendMsg("userNameMsg","请输入您的手机号");
        return false;
      } else {
        removeMsg("userNameMsg");
      }
      var _thisReg = (/^1[34578]\d{9}$/);
      if (!a.match(_thisReg)) {
        removeMsg("userNameMsg");
        appendMsg("userNameMsg","请输入正确的手机号");
        return false;
      } else {
        removeMsg("userNameMsg");
      }
      var b = $("#userPwd").val();
      if ($.trim(b) == "" || b == "请输入您的密码") {
        removeMsg("userPwdMsg");
        appendMsg("userPwdMsg","请输入您的密码");
        return false;
      } else {
        removeMsg("userPwdMsg");
      }
      return true;
    }

    function userLogin() {
      if (!checkData) {
          return;
      }
      $.ajax({
        type: "POST",
        url: '${path}/ticketUser/ticketUserLogin.do',
        data: $("#userForm").serialize(),
        dataType: "text",
        success: function(data) {
          var c = data;
          if (c == "success") {
            //修改父窗口的 登录状态
            $("#btnLogin", window.parent.document).attr("class","btn2 btn-logout");
            $("#btnLogin", window.parent.document).attr("title","退出");
            $("#btnLogin", window.parent.document).attr("href","javascript:ticketOutLogin();");
             location.href = '${path}/ticketActivity/ticketActivityList.do';
          } else {
            if (c == "noActive") {
              removeMsg("userNameMsg");
              appendMsg("userNameMsg","账号未完成注册，请重新注册");
            } else {
              if (c == "isFreeze") {
                removeMsg("userNameMsg");
                appendMsg("userNameMsg","账号已冻结");
              } else {
                removeMsg("userNameMsg");
                appendMsg("userNameMsg","账号和密码不匹配，请重新输入");
              }
            }
          }
        },
        error: function() {
          dialogAlert("提示", "系统繁忙")
        }
      })
    };


    $(function(){
      $('#ticketUserCenterId').addClass('cur').siblings().removeClass('cur');
      fixPlaceholder();
      keyboard.config({
        inputId:".input-txt"
      });
      $(document).keydown(function(a) {
        if (a.which == 13) {
          userLogin();
          return false
        }
        return true
      });


    });
  </script>
  <script type="text/javascript">
    var phoneWidth=parseInt(window.screen.width);var phoneScale=phoneWidth/1200;var ua=navigator.userAgent;if(/Android (\d+\.\d+)/.test(ua)){var version=parseFloat(RegExp.$1);if(version>2.3){document.write('<meta name="viewport" content="width=1200, minimum-scale = '+phoneScale+", maximum-scale = "+(phoneScale+1)+', target-densitydpi=device-dpi">')}else{document.write('<meta name="viewport" content="width=1200, target-densitydpi=device-dpi">')}}else{document.write('<meta name="viewport" content="width=1200, user-scalable=yes, target-densitydpi=device-dpi">')};
  </script>

</head>
<body style="background: #eef4f7;"  ms-important="Login">

<%--引入头文件--%>
<%@include file="/WEB-INF/why/ticket/ticket-nav.jsp"%>

<div class="ticket-login">
  <div class="login-box" id="loginForm">
    <h2>登录文化上海云</h2>
    <form action="" name="userForm" id="userForm" method="post">
      <dl>
        <dt>账号</dt>
        <dd id="userNameMsg"><input type="text" class="input-txt user-name" name="userName"  id="userName" maxlength="11" onkeyup="if(this.value!=this.value.replace(/\D/g,'')) this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" placeholder="请输入您的手机号"/></dd>
      </dl>
      <dl>
        <dt>密码</dt>
        <dd id="userPwdMsg"><input type="password" class="input-txt user-pwd" name="userPwd"  id="userPwd" placeholder="请输入您的密码"/></dd>
      </dl>
      <dl>
        <dt>&nbsp;</dt>
        <dd><input type="button" class="btn-submit" onclick="userLogin();" value="确定登录"/></dd>
      </dl>
    </form>
  </div>
</div>

</body>
</html>

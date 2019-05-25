<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
  String path = request.getContextPath();
  request.setAttribute("path", path);
  String basePath = request.getScheme() + "://"
          + request.getServerName() + ":" + request.getServerPort()
          + path + "/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <title>手机号-活动预订(手机号)弹窗--文化云</title>
  <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/reset.css"/>
  <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture-index.css"/>
  <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture.css"/>

  <!--[if lte IE 8]>
  <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture-ie.css"/>
  <![endif]-->
  <!-- dialog start -->
  <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/ui-dialog.css"/>
  <script type="text/javascript" src="${path}/STATIC/js/jquery.min.js"></script>
  <script type="text/javascript" src="${path}/STATIC/js/culture.js"></script>
  <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
  <script type="text/javascript" src="${path}/STATIC/js/dialog/lib/sea.js"></script>
  <script type="text/javascript">
    seajs.config({
        alias: {
          "jquery": "jquery-1.10.2.js"
        }
    });
    seajs.use(['${path}/STATIC/js/dialog/src/dialog-plus'], function (dialog) {
        window.dialog = dialog;
    });
    window.console = window.console || {log:function () {}}
    seajs.use(['jquery'], function ($) {
      $(function () {
          var dialog = top.dialog.get(window);
          var data = dialog.data;
          $('#groupTit').text(data);
          $("#closeDia").on("click", function(){
            dialog.close().remove();
          });
      });
    });

var wait = 60;
function smsTimer (obj) {
        if (wait == 0) {
            $("#sendCode").prop("disabled", false);
            $("#sendCode").val("获取验证码");
            wait = 60;
        } else {
            $("#sendCode").prop("disabled", true);
            $("#sendCode").val(wait + "秒后重发");
            wait--;
            setTimeout(function () {
                      smsTimer(obj);
                  },
                  1000)
            }
}

function sendRegCode(obj){
          $("#tips").html("");
          $("#sendCode").prop("disabled", true);
          $.ajax({
                type: "POST",
                data:{
                  userMobileNo:${mobile}
                },
                url: "${path}/frontTerminalUser/completeOrderSendCode.do?asm="+new Date().getTime(),
                dataType: "json",
                success: function (data) {
                  if (data.result == "success") {
                      smsTimer(obj);
                      //$("#tips").html("发送成功");
                  }/*else if(data.result=="repeat"){
                      var obj =  parent.window.document.getElementById("orderPhoneNo");
                      obj.value="";
                      obj.focus();
                      dialogAlert("提示","该手机号已注册!",function(){
                          $("#closeDia").click();
                      });
                  }*/
                  else if(data.result=="timeOut"){
                        //刷新页面
                        dialogAlert("提示","登录超时,请重新登录！",function(){
                          window.location.reload(true);
                        });
                        setTimeout(function(){
                          window.location.reload(true);
                        },2000)
                  }else if (data.result=="third"){
                        dialogAlert("提示","今日已发送三次,请明天再试！");
                  }
                }
          });
 }


 function completeOrderInfo(){
            var code=$("#mobileCode").val();
            if(!code){
              $("#mobileCode").focus();
              return;
            }
            $.ajax({
              type: "POST",
              data:{
                userMobileNo:${mobile},
                code:code
              },
              url: "${path}/frontTerminalUser/completeOrderInfo.do?asm="+new Date().getTime(),
              dataType: "json",
              success: function (data) {
                  if (data.data == "success") {
                    //var obj =  parent.window.document.getElementById("orderPhoneNo");
                    //obj.setAttribute("disabled", true);
                    //obj.setAttribute("readonly", true);
                    parent.window.document.getElementById("mark").value=$("#userMobileNo").val();
                    dialogAlert("提示","验证成功,可以提交订单啦",function(){
                      $("#closeDia").click();
                    });
                  }else if(data.data=="codeError"){
                      $("#tips").html("验证码错误！");
                  }
                  else if(data.data=="timeOut"){
                    dialogAlert("提示","登录超时,请重新登录");
                    window.location.reload(true);
                  }else if (data.result=="failure"){
                    dialogAlert("提示","系统繁忙");
                  }
              }
            });
}

  </script>
  <!-- dialog end -->

</head>
<body style="background: none;">
<input type="hidden" id="closeDia">
<div class="join-box">
  <form>
    <input type="hidden"   name="userMobileNo" value="${mobile}"   id="userMobileNo"   />
    <dl>
      <dt>手机号</dt>
      <dd><input type="text"  class="input-text"  value="${mobile}" readonly="readonly" disabled="disabled" /></dd>
    </dl>

    <dl>
      <dt>验证码</dt>
      <dd>
        <input type="text" class="w230"  name="mobileCode"  id="mobileCode"  maxlength="6"
               onkeyup="if(this.value!=this.value.replace(/\D/g,'')) this.value=this.value.replace(/\D/g,'')"
               onafterpaste="this.value=this.value.replace(/\D/g,'')"
               onblur="this.value=this.value.replace(/\D/g,'')"
               onfocus="this.value=this.value.replace(/\D/g,'')"  />
        <input type="button" class="yzmbg"  onclick="sendRegCode(this)" id="sendCode" value="获取验证码" style="border:0px" />
        <span id="tips"></span>
      </dd>
    </dl>

    <dl>
        <dt>&nbsp;</dt>
        <dd>
              <div class="join-btn" style="display:block;">
                 <input type="button" class="btn_submit"  value="提交" onclick="completeOrderInfo()" >
              </div>
        </dd>
    </dl>

  </form>
</div>

</body>
</html>

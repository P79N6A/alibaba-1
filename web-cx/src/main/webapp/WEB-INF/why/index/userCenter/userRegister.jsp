<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>注册页--文化云</title>
  <%@include file="/WEB-INF/why/common/frontPageFrame.jsp"%>
  <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/hsCulture.css">
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture-user.css" />
  <script type="text/javascript" src="${path}/STATIC/js/index/userCenter/userRegister.js?version=20160325"></script>
  <script src="${path}/STATIC/js/avalon.js"></script>
</head>
<body>
<!-- 导入头部文件  无搜索按钮 -->
<div class="header">
   <!-- 导入头部文件 -->
<%@include file="/WEB-INF/why/index/header.jsp" %>
</div>

<div id="register-content">
  <div class="register-content">
    <div class="steps">
      <ul class="clearfix">
        <li class="step_1 visited_pre">1.基本信息<i class="tab_status"></i></li>
        <li class="step_2 active">2.个性化设置<i class="tab_status"></i></li>
        <li class="step_3">3.注册成功</li>
      </ul>
    </div>
    <h1>基本信息</h1>
    <form id="userForm"   ms-controller="dataForm">
        <input type="hidden" value="${callback}" name="callback" id="callback"/>
      <div class="register-part part1">
          <dl>
              <dt>手机号</dt>
              <dd class="showPlaceholder">
                  <input id="userMobileNo" type="text" class="input-text" value="" name="userMobileNo" maxlength="11"
                         onkeyup="if(this.value!=this.value.replace(/\D/g,'')) this.value=this.value.replace(/\D/g,'')"
                         onafterpaste="this.value=this.value.replace(/\D/g,'')"
                         onblur="this.value=this.value.replace(/\D/g,'')"
                         onfocus="this.value=this.value.replace(/\D/g,'')"
                         ms-duplex="userMobileNo" data-duplex-changed="mobileChange"  />
                  <label class="placeholder" id="phonePlaceholder">输入11位手机号码</label>
                  <span id="userMobileNoErr"></span>
              </dd>
          </dl>
          <dl>
          <dt>昵称</dt>
          <dd class="showPlaceholder">
            <input type="text" class="input-text"  name="userName"  id="userName" value=""
                   ms-duplex="userName" data-duplex-changed="userNameChange" maxlength="20" />
            <label class="placeholder" id="namePlaceholder">数字、字母、下划线、汉字</label>
            <span id="userNameErr"></span>
          </dd>
        </dl>
        <dl>
          <dt>密码</dt>
          <dd class="showPlaceholder">
            <input id="newPass" type="password" class="input-text" value="" name="userPwd"  maxlength="20"
                   ms-duplex="newPass" data-duplex-changed="newPassChange" />
            <label class="placeholder" id="pwdPlaceholder">6-20位字母加数字组合</label>
            <span id="userPwdErr"></span>
          </dd>
        </dl>
        <dl>
          <dt>确认密码</dt>
          <dd class="showPlaceholder">
            <input id="newPass2" type="password" class="input-text" value="" name="confirmPassword" maxlength="20"
                   ms-duplex="conPass" data-duplex-changed="conPassChange"  />
            <label class="placeholder" id="pwdPlaceholder2">确认密码</label>
            <span id="confirmPasswordErr"></span>
          </dd>
        </dl>
        <dl>
          <dt>验证码</dt>
          <dd class="showPlaceholder">
            <input type="text" class="input-text input-code" value="" id="code" name="code" maxlength="6"
                   onkeyup="if(this.value!=this.value.replace(/\D/g,'')) this.value=this.value.replace(/\D/g,'')"
                   onafterpaste="this.value=this.value.replace(/\D/g,'')"
                   onblur="this.value=this.value.replace(/\D/g,'')"
                   ms-duplex="code" data-duplex-changed="codeChange"  />
            <input  id="sendCode" type="button" class="send-code" value="发送验证码"  onclick="sendSmsCode(this)" />
            <label class="placeholder" >输入手机验证码</label>
            <span id="codeErr" ></span>
            <span id="sendCodeTip"></span>
          </dd>
        </dl>
      </div>
      <h1>个性化设置</h1>
      <div class="register-part part2">
          <dl>
              <dt>性别</dt>
              <dd>
                  <label class="selected">
                      <input type="radio" name="userSex" value="2" checked="checked"/><span>女</span>

                  </label>
                  <label>
                      <input type="radio" name="userSex" value="1"  /><span>男</span>
                  </label>
              </dd>
          </dl>
        <dl>
          <dt>出生年代</dt>
          <dd>
            <label><input name="birth" type="radio" value="60"/><span>60</span></label>
            <label><input name="birth" type="radio" value="70"/><span>70</span></label>
            <label><input name="birth" type="radio" value="80"/><span>80</span></label>
            <label class="selected"><input name="birth" type="radio" value="90" checked/><span>90</span></label>
            <label><input name="birth" type="radio" value="00"/><span>00</span></label>
          </dd>
        </dl>

      </div>
        <div class="feedback-form">
      <input type="hidden" name="userId" id="userId"/>
      <input type="button" value="注  册" class="btn-submit btn-feedback"  id="registerBtn" onclick="saveRegister()"/>
            </div>
    </form>
  </div>
</div>
<script type="text/javascript">
$(function(){
        $(".part1 dl dd").on("input propertychange",'.input-text', function(){
            if($(this).val() == ''){
                $(this).parent().addClass("showPlaceholder");
            }else{
                $(this).parent().removeClass("showPlaceholder");
            }
        });
        $(".part1 dl dd").on("blur",'.input-text', function(){
            if ($(this).attr("id") == "userName") {
                valUserName();
            } else if ($(this).attr("id") == "newPass") {
                valNewPass();
            } else if ($(this).attr("id") == "newPass2") {
                valNewPass2();
            } else if ($(this).attr("id") == "userMobileNo") {
                valUserMobile();
            }
        });
        $(".placeholder").on({
            click:function(){ $(this).parent().find(".input-text").focus();},
            dblclick:function(){ $(this).parent().find(".input-text").focus();}
        });
        var userAgent=window.navigator.userAgent.toLowerCase();
        var msie = /msie/.test(userAgent);
        var msie8 = /msie 8\.0/i.test(userAgent);
        var msie7 = /msie 7\.0/i.test(userAgent);
        var msie6 = /msie 6\.0/i.test(userAgent);
        if(msie && (msie8 || msie7 || msie6)){
            $(".part1 dl dd").on("focus",".input-text",function(){$(this).parent().removeClass("showPlaceholder")})
        }
        $(".part2 input[type=radio]").on("click",function(){$(this).parent().find("input[type=radio]").prop("checked",false);$(this).parents("dd").find("label").removeClass("selected");$(this).prop("checked",true).parent().addClass("selected")});
});

var timeOut = 60;
function smsTimer () {
        if (timeOut <= 0) {
            setDisBtn("sendCode",false);
            $("#sendCode").val("获取验证码");
            timeOut = 60;
        } else {
            setDisBtn("sendCode",true);
            $("#sendCode").val(timeOut+"秒后重新获取");
            timeOut--;
            setTimeout(function () {smsTimer();}, 1000)
        }
}
function valCode(){
        var code=$("#code").val();
        if($.trim(code)==""){
            $("#codeErr").addClass("error-msg").html("请输入验证码！");
            $("#code").focus();
            return false;
        }else if(code.length!=6){
            $("#codeErr").addClass("error-msg").html("验证码长度有误！");
            $("#code").focus();
            return false;
        }else{
            $("#codeErr").removeClass("error-msg").html("");
        }
        return true;
}
function saveRegister(){
                if(!valRegForm()){
                  return;
                }
                if(!valCode()){
                    return;
                }
                if($("#userId").val()==""){
                      $("#codeErr").addClass("error-msg").html("未获取验证码！");
                      $("#code").focus();
                      return;
                }
                if(!dataForm.saveNext){
                    return;
                }
                setDisBtn("registerBtn",true);
    $.post("${path}/frontTerminalUser/saveUser.do?asm="+new Date().getTime(),
            $("#userForm").serialize(),
            function(rsData) {
                var data = eval(rsData);
                if (data.status == "success") {
                    //xh365使用跳转回自己的页面
                    if ($("#callback").val() != undefined && $("#callback").val() != '') {
                        dialogAlert("提示","恭喜您，已注册成功！",function() {
                            /*window.location.href = $("#callback").val();*/
                            var  userHeadImgUrl = data.user.userHeadImgUrl;
                            if (userHeadImgUrl == undefined || userHeadImgUrl == null  || userHeadImgUrl == '') {
                                if (data.user.userSex == 1) {
                                    userHeadImgUrl= 'http://www.wenhuayun.cn/STATIC/image/face_boy.png';
                                } else {
                                    userHeadImgUrl= 'http://www.wenhuayun.cn/STATIC/image/face_girl.png';
                                }
                            }
                            window.location.href = $("#callback").val() + "?userId=" + data.user.userId + "&userName=" + data.user.userName + "&userHeadImgUrl=" + userHeadImgUrl + "&userMobileNo=" + data.user.userMobileNo;
                        });
                    } else {
                        window.location.href="${path}/frontTerminalUser/userRegisterSuc.do"
                    }
                }else if(data.status == "SmsCodeErr"){
                    dataForm.saveNext=false;
                    $("#codeErr").addClass("error-msg").html("验证码验证失败,请确认验证码是否正确！");
                    $("#code").focus();
                    setDisBtn("registerBtn",false);
                }else if(data.status == "repeat"){
                    $("#userMobileNoErr").addClass("error-msg").html("手机号码已注册！");
                    $("#userMobileNo").focus();
                    setDisBtn("registerBtn",false);
                }else if(data.status=="NoValMobile"){
                    $("#codeErr").addClass("error-msg").html("未获取验证码！");
                    $("#code").focus();
                    setDisBtn("registerBtn",false);
                }else if(data.status=="timeOut"){
                    $("#codeErr").addClass("error-msg").html("验证码已过期,请重新获取！");
                    $("#code").focus();
                    //setDisBtn("registerBtn",false);
                }else{
                    dialogAlert("提示","抱歉,当前注册用户过多,请稍后重试！");
                    setDisBtn("registerBtn",false);
                }
            });
}
function sendSmsCode(obj){
        if(!dataForm.sendNext){
            return;
        }
        setDisBtn("sendCode",true);
        var userName=$("#userName").val();
        var userPwd = $("#newPass").val();
        var userMobileNo=$("#userMobileNo").val();
        if(!valRegForm()){
            setDisBtn("sendCode",false);
            return;
        }
        $.ajax({
                        type: "POST",
                        data:{
                            userMobileNo:userMobileNo,
                            userName:userName,
                            userPwd:userPwd,
                            userSex:1
                        },
                        url: "${path}/frontTerminalUser/sendSmsCode.do?asm="+new Date().getTime(),
                        dataType: "json",
                        success: function (data) {
                            if(data.result == "success") {
                                smsTimer();
                                $("#userId").val(data.userId);
                                //$("#codeErr").removeClass("error-msg").html("短信验证码发送成功");
                            }else if(data.result == "repeat"){
                                //timeOut=0;
                                dataForm.sendNext=false;
                                $("#userMobileNoErr").addClass("error-msg").html("该手机号码已经注册过！");
                                $("#userMobileNo").focus();
                                setDisBtn("sendCode",false);
                            }else if(data.result == "third"){
                                $("#codeErr").addClass("error-msg").html("短信验证码发送超过三次,请明天再试！");
                            }else{
                                //其他错误不做处理
                                setDisBtn("sendCode",false);
                            }
                        },
                        error: function(){
                            setDisBtn("sendCode",false);
                        }
                    });
}
var dataForm =  avalon.define({
        $id:"dataForm",
        userName:"",
        userMobileNo:"",
        newPass:"",
        conPass:"",
        code:"",
        sendNext:true,
        saveNext:true,
        mobileChange:function(){
          dataForm.sendNext=true;
        },
        userNameChange:function(){
            if(dataForm.userName.length>=6){
                valUserName();
            }
        },
        newPassChange:function(){
          if(dataForm.newPass.length>=6){
              valNewPass();
          }
        },
        conPassChange:function(){
           if(dataForm.conPass.length>=6){
               valNewPass2();
           }
        },
        codeChange:function(){
            if(dataForm.code.length==6){
                dataForm.saveNext=true;
                $("#codeErr").removeClass("error-msg").html("");
            }
        }
 });
</script>
<%@include file="/WEB-INF/why/index/footer.jsp" %>
</body>
</html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>注册页--文化安康云</title>
  <%@include file="/WEB-INF/why/common/frontPageFrame.jsp"%>
  <script type="text/javascript" src="${path}/STATIC/js/index/userCenter/userRegister.js?version=20151206"></script>
   <%-- <script  src="${path}/STATIC/js/placeholder.js"></script>--%>
    <script src="${path}/STATIC/js/avalon.js"></script>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/login_key.css" /><!--模拟键盘-->
    <script type="text/javascript" src="${path}/STATIC/js/reg_key.js?version=20151206"></script><!--模拟键盘-->
</head>
<body>
<%@include file="/WEB-INF/why/index/userCenter/user_center_top.jsp"%>

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
      <div class="register-part part1 user" style="position: relative;">
          <!--键盘 start-->

          <dl>
              <dt>手机号</dt>
              <dd class="showPlaceholder">
                  <input id="userMobileNo" type="text" class="input-text inputs" value="" name="userMobileNo" maxlength="11"
                         onkeyup="if(this.value!=this.value.replace(/\D/g,'')) this.value=this.value.replace(/\D/g,'')"
                         onafterpaste="this.value=this.value.replace(/\D/g,'')"
                         onblur="this.value=this.value.replace(/\D/g,'')"
                         onfocus="this.value=this.value.replace(/\D/g,'')"
                         ms-duplex="userMobileNo" data-duplex-changed="mobileChange" placeholder="输入11位手机号码"  />
                  <%--<label class="placeholder" id="phonePlaceholder">输入11位手机号码</label>--%>
                  <span id="userMobileNoErr"></span>
              </dd>
          </dl>

          <dl>
          <dt>昵称</dt>
          <dd class="showPlaceholder">
            <input type="text" class="input-text inputs"  name="userName"  id="userName" value="" maxlength="20"
                   ms-duplex="userName" data-duplex-changed="userNameChange" placeholder="数字、字母、汉字、下划线" />
            <%--<label class="placeholder" id="namePlaceholder">数字、字母、汉字、下划线</label>--%>
            <span id="userNameErr"></span>
          </dd>
        </dl>
        <dl>
          <dt>密码</dt>
          <dd class="showPlaceholder">
            <input id="newPass" type="password" class="input-text inputs" value="" name="userPwd"  maxlength="20"
                   ms-duplex="newPass" data-duplex-changed="newPassChange" placeholder="6-20位字母加数字组合" />
           <%-- <label class="placeholder" id="pwdPlaceholder">6-12位字母加数字组合</label>--%>
            <span id="userPwdErr"></span>
          </dd>
        </dl>
        <dl>
          <dt>确认密码</dt>
          <dd class="showPlaceholder">
            <input id="newPass2" type="password" class="input-text inputs" value="" name="confirmPassword" maxlength="20"
                   ms-duplex="conPass" data-duplex-changed="conPassChange" placeholder="确认密码"  />
           <%-- <label class="placeholder" id="pwdPlaceholder2">确认密码</label>--%>
            <span id="confirmPasswordErr"></span>
          </dd>
        </dl>
        <dl>
          <dt>验证码</dt>
          <dd class="showPlaceholder">
            <input type="text" class="input-text input-code inputs" value="" id="code" name="code" maxlength="6"
                   onkeyup="if(this.value!=this.value.replace(/\D/g,'')) this.value=this.value.replace(/\D/g,'')"
                   onafterpaste="this.value=this.value.replace(/\D/g,'')"
                   onblur="this.value=this.value.replace(/\D/g,'')"
                   ms-duplex="code" data-duplex-changed="codeChange" placeholder="输入手机验证码"  />
            <input  id="sendCode" type="button" class="send-code" value="获取验证码"  onclick="sendSmsCode(this)" />
         <%--   <label class="placeholder" >输入手机验证码</label>--%>
            <span id="codeErr" ></span>
            <span id="sendCodeTip"></span>
          </dd>
        </dl>
          <!--键盘 start-->
          <ul id="keyboard" style="display:none;z-index:3;">
              <li class="symbol"><span class="off">`</span><span class="on">~</span></li>
              <li class="symbol"><span class="off">1</span><span class="on">!</span></li>
              <li class="symbol"><span class="off">2</span><span class="on">@</span></li>
              <li class="symbol"><span class="off">3</span><span class="on">#</span></li>
              <li class="symbol"><span class="off">4</span><span class="on">$</span></li>
              <li class="symbol"><span class="off">5</span><span class="on">%</span></li>
              <li class="symbol"><span class="off">6</span><span class="on">^</span></li>
              <li class="symbol"><span class="off">7</span><span class="on">&amp;</span></li>
              <li class="symbol"><span class="off">8</span><span class="on">*</span></li>
              <li class="symbol"><span class="off">9</span><span class="on">(</span></li>
              <li class="symbol"><span class="off">0</span><span class="on">)</span></li>
              <li class="symbol"><span class="off">-</span><span class="on">_</span></li>
              <li class="symbol"><span class="off">=</span><span class="on">+</span></li>
              <li class="delete lastitem">delete</li>
              <li class="tab">tab</li>
              <li class="letter">q</li>
              <li class="letter">w</li>
              <li class="letter">e</li>
              <li class="letter">r</li>
              <li class="letter">t</li>
              <li class="letter">y</li>
              <li class="letter">u</li>
              <li class="letter">i</li>
              <li class="letter">o</li>
              <li class="letter">p</li>
              <li class="symbol"><span class="off">[</span><span class="on">{</span></li>
              <li class="symbol"><span class="off">]</span><span class="on">}</span></li>
              <li class="symbol lastitem"><span class="off">\</span><span class="on">|</span></li>
              <li class="capslock">caps lock</li>
              <li class="letter">a</li>
              <li class="letter">s</li>
              <li class="letter">d</li>
              <li class="letter">f</li>
              <li class="letter">g</li>
              <li class="letter">h</li>
              <li class="letter">j</li>
              <li class="letter">k</li>
              <li class="letter">l</li>
              <li class="symbol"><span class="off">;</span><span class="on">:</span></li>
              <li class="symbol"><span class="off">'</span><span class="on">&quot;</span></li>
              <li class="return lastitem">return</li>
              <li class="left-shift">shift</li>
              <li class="letter">z</li>
              <li class="letter">x</li>
              <li class="letter">c</li>
              <li class="letter">v</li>
              <li class="letter">b</li>
              <li class="letter">n</li>
              <li class="letter">m</li>
              <li class="symbol"><span class="off">,</span><span class="on">&lt;</span></li>
              <li class="symbol"><span class="off">.</span><span class="on">&gt;</span></li>
              <li class="symbol"><span class="off">/</span><span class="on">?</span></li>
              <li class="right-shift lastitem">shift</li>
              <li class="space lastitem">&nbsp;</li>
          </ul>
          <!--键盘 end-->
      </div>
      <h1>个性化设置</h1>
      <div class="register-part part2">
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
        <dl>
          <dt>性别</dt>
          <dd>
            <label class="selected">
                <input type="radio" name="userSex" value="1" checked="checked" /><span>男</span>
            </label>
            <label>
                <input type="radio" name="userSex" value="2" /><span>女</span>
            </label>
          </dd>
        </dl>
      </div>
      <input type="hidden" name="userId" id="userId"/>
      <input type="button" value="提交" class="register-submit"  id="registerBtn" onclick="saveRegister()"/>
    </form>
  </div>
</div>


<%--<!--键盘 end-->
<script type="text/javascript">
    var funPlaceholder = function(element) {
        var placeholder = '';
        if (element && !("placeholder" in document.createElement("input")) && (placeholder = element.getAttribute("placeholder"))) {
            element.onfocus = function() {
                if (this.value === placeholder) {
                    this.value = "";
                }
                this.style.color = '';
            };
            element.onblur = function() {
                if (this.value === "") {
                    this.value = placeholder;
                    this.style.color = 'graytext';
                }
            };

            //样式初始化
            if (element.value === "") {
                element.value = placeholder;
                element.style.color = 'graytext';
            }
        }
    };
    funPlaceholder(document.getElementById("userMobileNo"));
    funPlaceholder(document.getElementById("userName"));
    funPlaceholder(document.getElementById("newPass"));
    funPlaceholder(document.getElementById("newPass2"));
    funPlaceholder(document.getElementById("sendCode"));
</script>--%>

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
        /*IE8 IE7 IE6*/
        var userAgent=window.navigator.userAgent.toLowerCase();
        var msie = /msie/.test(userAgent);
        var msie8 = /msie 8\.0/i.test(userAgent);
        var msie7 = /msie 7\.0/i.test(userAgent);
        var msie6 = /msie 6\.0/i.test(userAgent);
        if(msie && (msie8 || msie7 || msie6)){
         $(".part1 dl dd").on("focus",".input-text",function(){
             $(this).parent().removeClass("showPlaceholder")})
        }
        $(".part2 input[type=radio]").on("click",function(){$(this).parent().find("input[type=radio]").prop("checked",false);$(this).parents("dd").find("label").removeClass("selected");$(this).prop("checked",true).parent().addClass("selected")});
});
var timeOut = 60;
function smsTimer () {
        if (timeOut <= 0) {
            //$("#codeErr").removeClass("error-msg").html("");
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
                $.post("${path}/frontTerminalUser/saveUser.do?asm="+new Date().getTime(), $("#userForm").serialize(),
                        function(data) {
                  if (data == "success") {
                    window.location.href="${path}/frontTerminalUser/userRegisterSuc.do"
                  }else if(data == "SmsCodeErr"){
                    dataForm.saveNext=false;
                    $("#codeErr").addClass("error-msg").html("验证码验证失败,请确认验证码是否正确！");
                    $("#code").focus();
                    setDisBtn("registerBtn",false);
                  }else if(data == "repeat"){
                    $("#userMobileNoErr").addClass("error-msg").html("手机号码已注册！");
                    $("#userMobileNo").focus();
                    setDisBtn("registerBtn",false);
                  }else if(data=="NoValMobile"){
                      $("#codeErr").addClass("error-msg").html("未获取验证码！");
                      $("#code").focus();
                      setDisBtn("registerBtn",false);
                  }else if(data=="timeOut"){
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
                                dataForm.sendNext=true;
                                $("#userMobileNoErr").addClass("error-msg").html("该手机号码已经注册过！");
                                $("#userMobileNo").focus();
                                $("#sendCode").prop("disabled",false);
                            }else if(data.result == "third"){
                                //timeOut=0;
                                $("#codeErr").addClass("error-msg").html("短信验证码发送超过三次,请明天再试！");
                            }else{
                                //其他错误不做处理
                                setDisBtn("sendCode",false);
                            }
                        },
                        error: function(){
                            setDisBtn("sendCode",false);
                            //$("#codeErr").removeClass("error-msg").html("如未收到验证码,点击重新获取!");
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
<%@include file="/WEB-INF/why/index/index_foot.jsp"%>
</body>
</html>
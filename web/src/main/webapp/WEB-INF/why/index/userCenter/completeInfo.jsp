<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>完善信息--安康文化云</title>
    <%@include file="/WEB-INF/why/common/frontPageFrame.jsp"%>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture-user.css" />
    <script src="${path}/STATIC/js/avalon.js"></script>
</head>
<body>
<%--<%@include file="/WEB-INF/why/index/index_top.jsp"%>--%>
<%@include file="/WEB-INF/why/index/index_top.jsp"%>

<div id="register-content">
    <div class="register-content">
        <h1>完善个人信息</h1>
        <form id="userForm" ms-controller="dataModel">
            <div class="register-part part1">
                <dl>
                    <dt>设置密码</dt>
                    <dd class="showPlaceholder">
                        <input id="newPass" type="password" class="input-text" value="" name="userPwd" maxlength="20"
                               ms-duplex="newPass" data-duplex-changed="newPassChange" />
                        <label class="placeholder" id="pwdPlaceholder">6-20位字母加数字组合</label>
                        <span id="userPwdErr"></span>
                    </dd>
                </dl>

                <dl>
                    <dt>确认密码</dt>
                    <dd class="showPlaceholder">
                        <input id="newPass2" type="password" class="input-text" value="" name="confirmPassword" maxlength="20"
                               ms-duplex="conPass" data-duplex-changed="conPassChange" />
                        <label class="placeholder" id="pwdPlaceholder2">确认密码</label>
                        <span id="confirmPasswordErr"></span>
                    </dd>
                </dl>
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
                    <dt>验证码</dt>
                    <dd class="showPlaceholder">
                        <input type="text" class="input-text input-code" value=""
                               id="code" name="registerCode" maxlength="6"
                               onkeyup="if(this.value!=this.value.replace(/\D/g,'')) this.value=this.value.replace(/\D/g,'')"
                               onafterpaste="this.value=this.value.replace(/\D/g,'')"
                               onblur="this.value=this.value.replace(/\D/g,'')"
                               onfocus="this.value=this.value.replace(/\D/g,'')"
                               ms-duplex="code" data-duplex-changed="codeChange"  />
                        <input  id="sendCode" type="button" class="send-code" value="发送验证码" onclick="sendSmsCode()"/>
                        <label class="placeholder" >输入手机验证码</label>
                        <span id="codeErr" ></span>
                        <%--<span id="sendCodeTip"></span>--%>
                    </dd>
                </dl>

            </div>
            <div class="feedback-form">
            <input type="hidden" name="userId" id="userId" value="${userId}"/>
            <input type="button" value="提交" class="btn-submit btn-feedback" onclick="saveComplete()"/>
            </div>
        </form>
    </div>
</div>
<script type="text/javascript">
    $(function(){
        $(".part1 dl dd").on("blur input propertychange",'.input-text', function(){
            if($(this).val() == ''){
                $(this).parent().addClass("showPlaceholder");
            }else{
                $(this).parent().removeClass("showPlaceholder");
            }
        });
        $(".part1 dl dd").on("blur",'.input-text', function(){
            if ($(this).attr("id") == "newPass") {
                valPwd();
            } else if ($(this).attr("id") == "newPass2") {
                valNewPwd();
            } else if ($(this).attr("id") == "userMobileNo") {
                valMobileNo();
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
            $(".part1 dl dd").on("focus",'.input-text', function(){
                $(this).parent().removeClass("showPlaceholder");
            })
        }
    });

    function checkPass(pass){
        var ls = 0;
        if(pass.match(/([a-z])+/)){  ls++; }
        if(pass.match(/([0-9])+/)){  ls++; }
        //if(pass.match(/([A-Z])+/)){   ls++; }
        if(pass.match(/^[A-Za-z0-9]+$/)){ ls++;}
        return ls;
    }

    function valPwd(){
        var  userPwd=$("#newPass").val();
        if($.trim(userPwd) ==""){
            $("#userPwdErr").addClass("error-msg").html("请输入密码");
            //$("#newPass").focus();
            return false;
        }else if(userPwd.length<6){
            $("#userPwdErr").addClass("error-msg").html("密码至少6位");
            //$("#newPass").focus();
            return false;
        }else if(userPwd.length>20){
            $("#userPwdErr").addClass("error-msg").html("密码不能超过20位");
            //$("#newPass").focus();
            return false;
        }else  if(checkPass(userPwd)<3){
            $("#userPwdErr").addClass("error-msg").html("密码格式不正确");
           // $("#newPass").focus();
            return false;
        }else{
            $("#userPwdErr").removeClass("error-msg").html("");
        }
        return true;
    }


    function valNewPwd(){
        var  userPwd=$("#newPass").val();
        var  confirmPassword=$("#newPass2").val();
        if($.trim(confirmPassword) ==""){
            $("#confirmPasswordErr").addClass("error-msg").html("请输入确认密码");
            //$("#newPass2").focus();
            return false;
        }else if(confirmPassword.length<6){
            $("#confirmPasswordErr").addClass("error-msg").html("确认密码至少6位");
            //$("#newPass2").focus();
            return false;
        }else if(confirmPassword.length>20){
            $("#confirmPasswordErr").addClass("error-msg").html("确认密码不能超过20位");
            //$("#newPass2").focus();
            return false;
        }else if(checkPass(userPwd)<3){
            $("#confirmPasswordErr").addClass("error-msg").html("密码格式不正确");
            //$("#newPass2").focus();
            return false;
        }else if(confirmPassword!=userPwd){
            $("#confirmPasswordErr").addClass("error-msg").html("两次输入密码不一致");
            //$("#newPass2").focus();
            return false;
        }else{
            $("#confirmPasswordErr").removeClass("error-msg").html("");
        }
        return true;
    }

    function valMobileNo(){
        var  userMobileNo=$("#userMobileNo").val();
        var telReg = (/^1[34578]\d{9}$/);
        if(userMobileNo ==""){
            $("#userMobileNoErr").addClass("error-msg").html("请输入手机号码");
            //$("#userMobileNo").focus();
            return false;
        }else if(!userMobileNo.match(telReg)){
            $("#userMobileNoErr").addClass("error-msg").html("请正确填写手机号码");
            //$("#userMobileNo").focus();
            return false;
        }else{
            $("#userMobileNoErr").removeClass("error-msg").html("");
        }
        return true;
    }

    var timeOut = 60;
    function smsTimer () {
        if (timeOut <= 0) {
            $("#sendCode").prop("disabled",false);
            $("#sendCode").val("获取验证码");
            timeOut = 60;
        }else {
            $("#sendCode").val(timeOut+"秒后重新获取");
            timeOut--;
            setTimeout(function () {
                smsTimer();
            }, 1000);
        }
    }

    var dataModel = avalon.define({
        $id:"dataModel",
        newPass:"",
        conPass:"",
        smsNext:true,
        userMobileNo:"",
        code:"",
        codeNext:true,
        mobileChange:function(){
            dataModel.smsNext=true;
            if(dataModel.userMobileNo){
                valMobileNo();
            }
        },
        newPassChange:function(){
            if(dataModel.newPass){
                valPwd();
            }
        },
        conPassChange:function(){
            if(dataModel.conPass){
                valNewPwd();
            }
        },
        codeChange:function(){
            dataModel.codeNext=true;
            if(dataModel.code){
                valCode();
            }
        }
    });

    function valCode(){
        var code =dataModel.code;
        if($.trim(code)==""){
            $("#codeErr").addClass("error-msg").html("请输入手机验证码");
            $("#code").focus();
            return false;
        }
        if(code.length!=6){
            $("#codeErr").addClass("error-msg").html("验证码长度必须是6位");
            $("#code").focus();
            return false;
        }
        $("#codeErr").removeClass("error-msg").html("");
        return true;
    }

    function saveComplete(){
        if(!(valPwd()&&valNewPwd()&&valMobileNo())){
                return;
        }
        if(!valCode()){
            return;
        }
        if(!dataModel.codeNext){
            return;
        }
        $.ajax({
                    type: "POST",
                    data:$("#userForm").serialize(),
                    url: "${path}/frontTerminalUser/completeInfo.do?asm="+new Date().getTime(),
                    dataType: "json",
                    success: function (data) {
                        if(data.code==200){
                            dialogAlert("提示","信息保存成功");
                            setTimeout(function(){
                                window.location.href="${path}/frontActivity/frontActivityIndex.do"
                            },1500);
                        }else if (data.code==404){
                            dataModel.codeNext=false;
                            $("#codeErr").addClass("error-msg").html("验证码验证失败,请确认验证码是否正确");
                            $("#code").focus();
                            return;
                        }else{
                            dialogAlert("提示","抱歉,系统繁忙,请稍后重试");
                        }
                    },
                    error:function(){
                        dialogAlert("提示","抱歉,系统繁忙,请稍后重试");
                    }
           });

    }

    function sendSmsCode(){
        if(!dataModel.smsNext){
            return;
        }
        if(!(valPwd() && valNewPwd() && valMobileNo())){
            return;
        }
        //验证通过
        $("#sendCode").prop("disabled",true);
        var userMobileNo=$("#userMobileNo").val();
                    $.ajax({
                        type: "POST",
                        data:{
                            userId:'${userId}',
                            userMobileNo:userMobileNo
                        },
                        url: "${path}/frontTerminalUser/completeInfoSendCode.do?asm="+new Date().getTime(),
                        dataType: "json",
                        success: function (data) {
                            if(data.result == "success") {
                                smsTimer();
                                $("#userId").val(data.userId);
                            }else if(data.result == "repeat"){
                                dataModel.smsNext=false;
                                $("#codeErr").removeClass("error-msg").html("");
                                $("#userMobileNoErr").addClass("error-msg").html("该手机号码已经注册过");
                                $("#userMobileNo").focus();
                                $("#sendCode").prop("disabled",false);
                            }else if(data.result == "third"){
                                $("#codeErr").addClass("error-msg").html("短信验证码发送超过三次,请明天再试");
                            }else{
                                //不做处理
                                //$("#codeErr").addClass("error-msg").html("短信验证码发送失败,请重试!");
                                //$("#sendCode").prop("disabled",false);
                                //$("#codeErr").addClass("error-msg").html("短信验证码发送失败,请重试!");
                                //$("#sendCode").prop("disabled",false);
                                //dialogAlert("提示","抱歉,当前注册用户过多,请稍后重试!");
                            }
                        },
                        error:function(){
                            //不做处理
                            //$("#codeErr").addClass("error-msg").html("短信验证码发送失败,请重试!");
                           // $("#sendCode").prop("disabled",false);
                        }
                    });
                 }
</script>
<%@include file="../index_foot.jsp"%>
</body>
</html>
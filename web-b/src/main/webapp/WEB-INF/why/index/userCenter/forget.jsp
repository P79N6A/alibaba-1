<%@ page import="com.sun3d.why.model.CmsTerminalUser" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>找回密码--文化云</title>
    <%@include file="/WEB-INF/why/common/frontPageFrame.jsp"%>
    <script src="${path}/STATIC/js/placeholder.js?v=111112222"></script>
    <script src="${path}/STATIC/js/avalon.js"></script>
</head>
<body>
<%@include file="/WEB-INF/why/index/index_top.jsp"%>

<div id="register-content" >
    <div class="register-content">
        <div class="steps">
            <ul class="clearfix">
                <li class="step_1 active">1.验证手机<i class="tab_status"></i></li>
                <li class="step_2">2.设置新密码<i class="tab_status"></i></li>
                <li class="step_3">3.完成</li>
            </ul>
        </div>
        <form id="userForm" action="${path}/frontTerminalUser/setPass.do" method="post" ms-important="forget">
            <div class="register-part part1">
                <dl>
                    <dt>手机号</dt>
                    <dd class="showPlaceholder">
                        <input type="text" class="input-text" value="" id="userMobileNo" maxlength="11"
                               onkeyup="if(this.value!=this.value.replace(/\D/g,'')) this.value=this.value.replace(/\D/g,'')"
                               onafterpaste="this.value=this.value.replace(/\D/g,'')"
                               onblur="this.value=this.value.replace(/\D/g,'')"
                               onfocus="this.value=this.value.replace(/\D/g,'')"
                               ms-duplex="mobile"  data-duplex-changed="mobileChange"  />
                        <label class="placeholder">输入11位手机号码</label>
                        <span id="userMobileNoErr"></span>
                    </dd>
                </dl>
                <dl>
                    <dt>验证码</dt>
                    <dd class="showPlaceholder">
                        <input type="text" class="input-text input-code" value="" name="code" id="code" maxlength="6"
                               onkeyup="if(this.value!=this.value.replace(/\D/g,'')) this.value=this.value.replace(/\D/g,'')"
                               onafterpaste="this.value=this.value.replace(/\D/g,'')"
                               onblur="this.value=this.value.replace(/\D/g,'')"
                               onfocus="this.value=this.value.replace(/\D/g,'')"
                               ms-duplex="code"  data-duplex-changed="codeChange"  />
                        <input type="button" class="send-code" id="sendCode" onclick="sendSmsCode()" value="获取验证码"/>
                        <label class="placeholder">输入手机验证码</label>
                        <span id="codeErr"></span>
                    </dd>
                </dl>
            </div>
            <div class="feedback-form">
                <input value="" name="resCode" type="hidden" ms-duplex="resCode" />
                <input type="button" value="下 一 步" class="btn-submit btn-feedback"  id="nextStep" onclick="passNextStep()"/>
            </div>
        </form>
    </div>
</div>

<script type="text/javascript">


var dataModel = avalon.define({
        $id:"forget",
        mobile:"",
        resCode:"",
        code:"",
        canNext:true,
        codeNext:true,
        mobileChange:function(){
            dataModel.canNext=true;
        },
        codeChange:function(){
            dataModel.codeNext=true;
        }
});

var timeOut = 60;
function smsTimer () {
        if (timeOut <= 0) {
            mySetDisBtn("sendCode",false);
            $("#sendCode").val("获取验证码");
            timeOut = 60;
        } else {
            $("#sendCode").val(timeOut+"秒后重新获取");
            timeOut--;
            setTimeout(function () {
                smsTimer();
            }, 1000);
        }
}
    function mySetDisBtn(id,tf){
        $("#"+id).prop("disabled",tf);
    }
    function addTips(id,content){
        $("#"+id).addClass("error-msg").html(content);
    }
    function rmTips(id,content){
        $("#"+id).removeClass("error-msg").html(content);
    }

function passNextStep(){
        if(!valMobile()){
            return;
        }
        mySetDisBtn("nextStep",true);
        var code =dataModel.code;
        if(!dataModel.resCode){
            addTips("codeErr","未获取验证码！");
            $("#code").focus();
            mySetDisBtn("nextStep",false);
            return;
        }
        if($.trim(code)==""){
            addTips("codeErr","请填写手机验证码！");
            $("#code").focus();
            mySetDisBtn("nextStep",false);
            return;
        }
        if(code.length!=6){
            addTips("codeErr","验证码长度有误！");
            $("#code").focus();
            mySetDisBtn("nextStep",false);
            return;
        }
        //不重复发送请求
        if(!dataModel.codeNext){
            return;
        }
        $.ajax({
            type: "POST",
            data:$("#userForm").serialize(),
            url: "${path}/frontTerminalUser/valForgetCode.do?asm="+new Date().getTime(),
            dataType: "json",
            success: function (data) {
                if(data=="success"){
                    $("#userForm").submit();
                }else if (data=="timeOut"){
                    dialogAlert("提示","请求超时");
                    setTimeout(function(){
                        window.location.reload(true);
                    },1500);
                }else{
                    dataModel.codeNext=false;
                    addTips("codeErr","验证码验证失败！");
                    mySetDisBtn("nextStep",false);
                }
            }
        });
}

function sendSmsCode(){
        if(!dataModel.canNext){
            return;
        }
        dataModel.resCode="";
        if(!valMobile()){
            return;
        }
        mySetDisBtn("sendCode",true);
                    $.ajax({
                        type: "POST",
                        data:{
                            userMobileNo:dataModel.mobile
                        },
                        url: "${path}/frontTerminalUser/sendForgetCode.do?asm="+new Date().getTime(),
                        dataType: "json",
                        success: function (data) {
                            if(data.result == "success") {
                                smsTimer();
                                dataModel.resCode=data.resCode;
                            }else if(data.result == "NotFound"){
                                dataModel.canNext=false;
                                addTips("userMobileNoErr","该用户不存在,请确认手机号是否正确！");
                                rmTips("codeErr","");
                                $("#userMobileNo").focus();
                                mySetDisBtn("sendCode",false);
                            }else if(data.result == "third"){
                                addTips("codeErr","短信验证码发送超过三次,请明天再试！")
                            }else if(data.result=="NotReg"){
                                addTips("userMobileNoErr","该手机号码未完成注册,请重新注册！");
                                //mySetDisBtn("sendCode",false);
                            }else if(data.result="Freeze"){
                                addTips("userMobileNoErr","该用户已冻结！");
                            }
                        },
                        error:function(){
                            mySetDisBtn("sendCode",false);
                        }
                    });
}
function valMobile(){
        var userMobileNo = dataModel.mobile;
        var telReg = (/^1[34578]\d{9}$/);
        if(userMobileNo ==""){
            addTips("userMobileNoErr","请填写手机号码！");
            return false;
        }else if(!userMobileNo.match(telReg)){
            addTips("userMobileNoErr","请正确填写手机号码！");
            return false;
        }else{
            rmTips("userMobileNoErr","");
        }
        return true;
}
$(function(){
        $(".part1 dl dd").on("blur",'.input-text', function() {
                if($(this).attr("id")=="userMobileNo"){
                    valMobile();
                }
        });
        $(".part1 dl dd").on("input propertychange",'.input-text', function(){
            if($(this).val() == ''){
                $(this).parent().addClass("showPlaceholder");
            }else{
                $(this).parent().removeClass("showPlaceholder");
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
            $(".register-part").on("focus",'.input-text', function(){
                $(this).parent().removeClass("showPlaceholder");
            });
        }

});

</script>
<%@include file="../index_foot.jsp"%>
</body>
</html>
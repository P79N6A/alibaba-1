<%@ page import="com.sun3d.why.model.CmsTerminalUser" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>设置新密码--文化安康云</title>
    <%@include file="/WEB-INF/why/common/frontPageFrame.jsp"%>
    <script type="text/javascript"></script>
</head>
<body>
<%@include file="/WEB-INF/why/index/index_top.jsp"%>

<div id="register-content">
    <div class="register-content">
        <div class="steps">
            <ul class="clearfix">
                <li class="step_1 visited_pre">1.验证手机<i class="tab_status"></i></li>
                <li class="step_2 active">2.设置新密码<i class="tab_status"></i></li>
                <li class="step_3">3.完成</li>
            </ul>
        </div>
        <form id="userForm" method="post">
            <div class="register-part part1">
                <dl>
                    <dt>新密码</dt>
                    <dd class="showPlaceholder">
                        <input type="password" class="input-text" id="newPass" name="userPwd"  value="" maxlength="12"/>
                        <label class="placeholder" id="pwdPlaceholder">请输入6-12位字母加数字组合</label>
                        <span id="userPwdErr"></span>
                    </dd>
                </dl>
                <dl>
                    <dt>确认密码</dt>
                    <dd class="showPlaceholder">
                        <input type="password" id="newPass2" class="input-text" value="" maxlength="12" />
                        <label class="placeholder" id="pwdPlaceholder2">请再次输入新密码</label>
                        <span id="confirmPasswordErr"></span>
                    </dd>
                </dl>
            </div>


            <div class="feedback-form">
                <input type="hidden" name="reqCode" value="${reqCode}" />
                <input type="button" value="完  成" class="btn-submit btn-feedback"  id="saveComplete" onclick="saveNewPass()"/>
            </div>
        </form>
    </div>
</div>

<script type="text/javascript">
function saveNewPass(){
                   if(!valUserForm()){
                        return;
                   }
                   $("#saveComplete").prop("disabled",true);
                   $.ajax({
                                type: "POST",
                                data:$("#userForm").serialize(),
                                url: "${path}/frontTerminalUser/setNewPass.do",//发短信地址
                                dataType: "json",
                                success: function (data) {
                                    if(data=="success"){
                                        window.location.href="${path}/frontTerminalUser/setPassSuc.do";
                                    }else if(data=="timeOut"){
                                        dialogAlert("提示","请求超时");
                                        setTimeout(function(){
                                            window.location.href="${path}/frontTerminalUser/forget.do";
                                        },1500);
                                    }else{
                                        dialogAlert("提示","抱歉,系统繁忙,请稍后重试!");
                                    }
                                }
                   });
}

function checkPass(pass){
        var ls = 1;
        if(pass.match(/([0-9])+/)){ls+=1;}
        if(pass.match(/([a-z])+/) || pass.match(/([A-Z])+/)){ls+=1;}
        return ls;
}

function valUserForm(){
        var  userPwd=$("#newPass").val();
        var  confirmPassword=$("#newPass2").val();
        if($.trim(userPwd) ==""){
            $("#userPwdErr").addClass("error-msg").html("请输入密码!");
            $("#newPass").focus();
            return false;
        }else if(userPwd.length<6){
            $("#userPwdErr").addClass("error-msg").html("密码至少6位!");
            $("#newPass").focus();
            return false;
        }else if(userPwd.length>12){
            $("#userPwdErr").addClass("error-msg").html("密码不能超过12位!");
            $("#newPass").focus();
            return false;
        }else  if(checkPass(userPwd)<3){
            $("#userPwdErr").addClass("error-msg").html("密码格式不正确,必须是数字字母组合");
            $("#newPass").focus();
            return false;
        }else{
            $("#userPwdErr").removeClass("error-msg").html("");
        }
        if($.trim(confirmPassword) ==""){
            $("#confirmPasswordErr").addClass("error-msg").html("请输入确认密码");
            $("#newPass2").focus();
            return false;
        }else if(confirmPassword.length<6){
            $("#confirmPasswordErr").addClass("error-msg").html("确认密码至少6位!");
            $("#newPass2").focus();
            return false;
        }else if(confirmPassword.length>12){
            $("#confirmPasswordErr").addClass("error-msg").html("确认密码不能超过12位!");
            $("#newPass2").focus();
            return false;
        }else if(checkPass(userPwd)<3){
            $("#confirmPasswordErr").addClass("error-msg").html("密码格式不正确,必须是数字字母组合");
            $("#newPass2").focus();
            return false;
        }else if(confirmPassword!=userPwd){
            $("#confirmPasswordErr").addClass("error-msg").html("两次输入密码不一致!");
            $("#newPass2").focus();
            return false;
        }else{
            $("#confirmPasswordErr").removeClass("error-msg").html("");
        }
        return true;
}


$(function(){
        $(".part1 dl dd").on("blur",'.input-text', function() {
            if($(this).val() == ''){
                $(this).parent().addClass("showPlaceholder");
            }else{
                $(this).parent().removeClass("showPlaceholder");
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
            $(".part1 dl dd").on("focus",'.input-text', function(){
                $(this).parent().removeClass("showPlaceholder");
            })
        }
});
</script>

<%@include file="../index_foot.jsp"%>
</body>
</html>
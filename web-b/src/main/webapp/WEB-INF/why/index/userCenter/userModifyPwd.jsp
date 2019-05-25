<%@ page import="com.sun3d.why.model.CmsTerminalUser" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>个人中心-修改密码--文化安康云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/frontPageFrame.jsp"%>
    <script src="${path}/STATIC/js/avalon.js"></script>
</head>
<body>
<%--引入个人中心头文件--%>
<%@include file="/WEB-INF/why/index/index_top.jsp"%>

<div id="register-content">
<div class="crumb">您所在的位置： <a href="#">个人主页</a> &gt;<a href="#">修改密码</a></div>
<div class="activity-content user-content clearfix">
<%@include file="user_center_left.jsp"%>
    <div class="user-right fr">
        <div class="setting-content modify-password">
            <h1>修改密码</h1>
            <form action="" id="userForm" ms-controller="dataForm">
                 <dl class="userPassword no-border">
                        <dt>原密码</dt>
                        <dd>
                            <div class="showPlaceholder">
                                <input type="password" class="input-text" id="oldPass" maxlength="12"
                                       ms-duplex="oldPass" data-duplex-changed="oldChange" />
                                <label class="placeholder">输入原密码</label>
                                <span id="oldPassErr"></span>
                            </div>
                        </dd>
                 </dl>
                 <dl class="userPassword no-border">
                    <dt>新密码</dt>
                        <dd>
                            <div class="showPlaceholder">
                                <input type="password" class="input-text" id="newPass" name="userPwd" maxlength="12"
                                       ms-duplex="newPass" data-duplex-changed="newChange" />
                                <label class="placeholder">输入新密码</label>
                                <span id="newPassErr"></span>
                            </div>
                        </dd>
                 </dl>
                 <dl class="userPassword no-border">
                    <dt>确认密码</dt>
                        <dd>
                            <div class="showPlaceholder">
                                <input type="password" class="input-text" id="newPass2" name="confirmPassword"
                                       maxlength="12" ms-duplex="newPass2" data-duplex-changed="confirmChange" />
                                <label class="placeholder">确认新密码</label>
                                <span id="newPass2Err"></span>
                            </div>

                        </dd>
                 </dl>
                <input type="button" class="save-edit" value="提 交" onclick="modifyUserPwd()" id="btnUpdate" />
            </form>
        </div>
    </div>
    </div>
</div>
<script type="text/javascript">
    $(function(){
        $('#userPwd').addClass('cur').siblings().removeClass('cur');
        $(".setting-content dl dd").on("blur input propertychange",'.input-text', function(){
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
            $(".setting-content dl dd").on("focus",'.input-text', function(){
                $(this).parent().removeClass("showPlaceholder");
            });
        }
    });

    function addErrMsg(id,content){
        $("#"+id).addClass("error-msg").html(content);
    }
    function rmErrMsg(id){
        $("#"+id).removeClass("error-msg").html("");
    }

    function setBtnDis(id,tf){
        $("#"+id).prop("disabled",tf);
    }

    function checkPass(pass){
        var ls = 1;
        if(pass.match(/([0-9])+/)){ls+=1;}
        if(pass.match(/([a-z])+/) || pass.match(/([A-Z])+/)){ls+=1;}
        return ls;
    }
    function valOldPass(){
        var  oldPass=$("#oldPass").val();
        if($.trim(oldPass) ==""){
            addErrMsg("oldPassErr","请输入原密码");
            //$("#oldPass").focus();
            return false;
        }else if(oldPass.length<6){
            addErrMsg("oldPassErr","密码至少6位");
            //$("#oldPass").focus();
            return false;
        }else{
            rmErrMsg("oldPassErr");
        }
        return true;
    }
    function valNewPass(){
        var  userPwd=$("#newPass").val();
        if($.trim(userPwd) ==""){
            addErrMsg("newPassErr","请输入新密码");
            //$("#newPass").focus();
            return false;
        }else if(userPwd.length<6){
            addErrMsg("newPassErr","密码至少6位");
            //$("#newPass").focus();
            return false;
        }else if(checkPass(userPwd)<3){
            addErrMsg("newPassErr","密码必须是数字字母组合");
            //$("#newPass").focus();
            return false;
        }else{
            rmErrMsg("newPassErr");
        }
        return true;
    }
    function  valNewPass2(){
        var  userPwd=$("#newPass").val();
        var  confirmPassword=$("#newPass2").val();
        // 确认密码
        if($.trim(confirmPassword) ==""){
            addErrMsg("newPass2Err","请输入确认密码");
            //$("#newPass2").focus();
            return false;
        }else if(confirmPassword.length<6){
            addErrMsg("newPass2Err","密码至少6位");
            //$("#newPass2").focus();
            return false;
        }else if(checkPass(confirmPassword)<3){
            addErrMsg("newPass2Err","密码必须是数字字母组合");
            //$("#newPass2").focus();
            return false;
        }else{
            rmErrMsg("newPass2Err");
        }
        if(userPwd!=confirmPassword){
            addErrMsg("newPass2Err","两次输入密码不一致");
            //$("#newPass2").focus();
            return false;
        }else{
            rmErrMsg("newPass2Err");
        }
        return true;
    }
    function valUserInfo() {
        if(!valOldPass() || !valNewPass() || !valNewPass2()){
            return false;
        }
        return true;
    }
    //修改
    function modifyUserPwd(){
        var  userPwd=$("#newPass").val();
        var  oldPass=dataModel.oldPass;
        if(!valUserInfo()){
            return;
        }
        if(userPwd==oldPass){
            dialogAlert("提示","新密码不能与原密码一致");
            return;
        }
        setBtnDis("btnUpdate",true);
        $.ajax({
            type: "POST",
            data:{
                userName:'${user.userMobileNo}',
                userPwd:oldPass,
                asm:new Date().getTime()
            },
            url: "${path}/frontTerminalUser/terminalLogin.do?"+new Date().getTime(),
            dataType: "json",
            success: function (data) {
            	var c = eval(data);
                if (c.status == "success") {
                    $.post("${path}/frontTerminalUser/userModifyPwd.do?asm="+new Date().getTime(), $("#userForm").serialize(),
                            function(datas) {
                        if (datas == "success") {
                            dialogAlert("提示","修改成功",function(){
                                window.location.reload(true);
                            });
                            setTimeout(function(){
                                window.location.reload(true);
                            },1500);
                        }else if(datas=="timeOut"){
                            dialogAlert("提示","修改成功");
                            setTimeout(function(){
                                window.location.href="${path}/frontTerminalUser/userLogin.do";
                            },1500);
                        }else{
                            dialogAlert("提示","修改失败,请稍后重试");
                        }
                    });
                }else{
                    //setBtnDis("btnUpdate",true);
                    addErrMsg("oldPassErr","原密码错误");
                    $("#oldPass").focus();
                }
            }
        });
    }
    var dataModel = avalon.define({
       $id:"dataForm",
       oldPass:"",
       newPass:"",
       newPass2:"",
       oldChange:function(){
           if(dataModel.oldPass){
               valOldPass();
           }
           setBtnDis("btnUpdate",false);
       },
       newChange:function(){
            if(dataModel.newPass){
                valNewPass();
            }
       },
       confirmChange:function(){
            if(dataModel.newPass2){
                valNewPass2();
            }
       }
    });

</script>

<%@include file="../index_foot.jsp"%>
</body>
</html>
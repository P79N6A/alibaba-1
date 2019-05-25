<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<%
    String path = request.getContextPath();request.setAttribute("path", path);
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path;
    request.setAttribute("basePath",basePath);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>登录页--文化云</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta http-equiv="content-type" content="text/html; charset=UTF-8" >
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <link rel="shortcut icon" href="${path}/STATIC/image/favicon.ico" type="image/x-icon" />
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/reset-index.css" />
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture-index.css" />
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/ui-dialog.css" />
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture.css" />
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture-index-new.css" />
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture-user.css" />
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/index_new.css" />
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/hsCulture.css"/>
    <!--[if lte IE 8]>
        <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture-ie.css" />
    <![endif]-->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/frontpage.css" />
    <style type="text/css">.ms-controller,.ms-important,[ms-controller],[ms-important]{visibility:hidden}</style>
    <script  src="${path}/STATIC/js/jquery.min-1.8.3.js"></script>
    <script  src="${path}/STATIC/js/culture.js"></script>
    <script  src="${path}/STATIC/js/dialog-min.js"></script>
    <script  src="${path}/STATIC/js/placeholder.js"></script>
    <script  src="${path}/STATIC/js/avalon.js"></script>
    <script type="text/javascript">
        var phoneWidth=parseInt(window.screen.width);var phoneScale=phoneWidth/1200;var ua=navigator.userAgent;if(/Android (\d+\.\d+)/.test(ua)){var version=parseFloat(RegExp.$1);if(version>2.3){document.write('<meta name="viewport" content="width=1200, minimum-scale = '+phoneScale+", maximum-scale = "+(phoneScale+1)+', target-densitydpi=device-dpi">')}else{document.write('<meta name="viewport" content="width=1200, target-densitydpi=device-dpi">')}}else{document.write('<meta name="viewport" content="width=1200, user-scalable=yes, target-densitydpi=device-dpi">')};
    </script>
    <style type="text/css">
    .input-text-yzm {width: 120px!important; border: solid 1px #cdcdcd!important;padding-left: 18px!important;padding-right: 18px!important; border-radius: 5px!important;-moz-border-radius: 5px!important;-webkit-border-radius: 5px!important;}
    </style>
</head>
<body style="background-color: #ffffff;"  ms-important="Login">
<div class="fsMain">
<!-- 导入头部文件  无搜索按钮 -->
	<%@include file="../header.jsp" %>


<div id="login-top" class="login-content clearfix"  ms-controller="dataModel" >
  <div class="login-dialog login_div">
    <h2>登录安康文化云</h2>
    <div class="loginQie">
		<a class="cur" href="javascript:;">账号密码登录<em></em></a>
		<a href="javascript:;">手机快捷登录<em></em></a>
	</div>
    

      <!--<div class="msg-error">请输入账户名和密码</div>-->
    <div class="loginContWc">
		<div class="loginCont">
		  <div class="msg-error" ms-if="errTips!=0">{{errTips}}</div>
	      <div class="user name"><label class="txt">账号：</label>
	          <input type="text" id="userName"  class="input-text" ms-duplex="userName" data-duplex-changed="LoginBtn" maxlength="11" onkeyup="if(this.value!=this.value.replace(/\D/g,'')) this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" onblur="this.value=this.value.replace(/\D/g,'')" onfocus="this.value=this.value.replace(/\D/g,'')"  placeholder="请输入您的手机号"  />
	      </div>
	      <div class="user pwd"><label class="txt">密码：</label>
	          <input type="password" id="userPwd" class="pwd_input" placeholder="请输入您的密码"    ms-duplex="userPwd"   data-duplex-changed="LoginBtn"   maxlength="20" />
	      </div>
	      <div class="user submit">
	          <input type="button" class="login-submit" ms-click="toLogin()"  value="登录"/>
	      </div>
	      <div class="forgetPwd">
	          <span class="fl"><label><input type="checkbox"  ms-duplex-checked="rememberUser" />记住账号</label></span>
	          <a class="fr" ms-attr-href="{{$forgetUrl}}">忘记密码</a>
	      </div>
		</div>
		
		<div class="loginCont" style="display: none;">
			<div class="msg-error" ms-if="errCodeTips!=0">{{errCodeTips}}</div>
			<div class="user name">
				<input type="text" class="input-text" id="mobileNo" placeholder="请输入您的手机号" style="width: 242px;padding-left: 18px;padding-right: 18px;">
			</div>
			<div class="user" style="overflow: visible;height: 46px;">
				<input id="loginCode" type="text" class="input-text input-text-yzm" placeholder="请输入验证码">
				<a id="smsCodeBut" href="javascript:;" onclick="sendSms();" style="float: right; width: 110px;height: 44px;line-height: 44px;overflow: hidden;background-color: #dbdbdb;font-size: 14px;color: #333;text-align: center;border-radius: 5px;-moz-border-radius: 5px;-webkit-border-radius: 5px;cursor: pointer;">点击获取</a>
			</div>
			<div class="user submit">
				<input type="button" class="login-submit" value="登录" onclick="userCodeLogin();">
			</div>
			<div class="forgetPwd">
				<!-- <span class="fl"><label><input type="checkbox">记住账号</label></span>
				<a class="fr" href="http://fs.gd.wenhuayun.cn:80/frontTerminalUser/forget.do">忘记密码</a> -->
			</div>
		</div>
<!-- 
    <h4>外部账号登录</h4>
    <div class="login-cate">
        <a class="qq" ms-attr-href="{{$third.qqUrl}}"  title="QQ"></a>
        <a class="sina" ms-attr-href="{{$third.sinaUrl}}"  title="新浪微博" ></a>
        <a class="weixin" ms-attr-href="{{$third.weChatUrl}}" title="微信"><i></i></a>
    </div>
    --> 
  	</div>

	  <div style="margin-top: 20px;">
		  <p style="text-align: center;">——————第三方登录——————</p>
		  <div onclick="readerCardLogin()">
			  <img src="${path}/STATIC/image/fsslhtsh.png" style="display: block;margin: 20px auto 0;" />
		  </div>
	  </div>
	  <div class="user register">
		  <a ms-attr-href="{{$regUrl}}">注册</a>
	  </div>
  </div>

	<!--第三方登录-->
	<div class="login-dialog readerCard_login_div" style="display: none;position:relative;">
        <div style="position:absolute;left:20px;top:30px;font-size:16px;color:#734631;cursor: pointer;" onclick="$('.readerCard_login_div').hide();$('.login_div').show();">返回</div>
		<h2 style="color: #333333;">登录安康文化云</h2>
		<img src="${path}/STATIC/image/fsslhtsh.png" style="display: block;margin: 10px auto 0;" />
		<div class="loginContWc">

			<!--读书正-->
			<div class="loginCont">
				<div class="user name"><label class="txt">读书证：</label>
					<input type="text" id="" name="identifier" class="input-text" placeholder="请输入您的读者证号" />
				</div>
				<div class="user pwd"><label class="txt">密&emsp;码：</label>
					<input type="password" id="" name="password" class="pwd_input" placeholder="请输入您的密码" maxlength="20" />
				</div>
			</div>

			<!--手机验证-->
			<div class="loginCont">
				<%--读者证用户首次登录需进行手机号验证--%>
				<p id="readerCardLogin_tips" style="font-size: 14px;color: #734631;text-align: center;margin: 20px 0 20px;"></p>
				
				<span id="firstLogin" style="display: none;">
				<div class="user name">
					<input type="text" id="readerCard_mobileNo" class="input-text" placeholder="请输入您的手机号" style="width: 242px;padding-left: 18px;padding-right: 18px;">
				</div>
				<div class="user" style="height: 46px;">
					<input type="text" maxlength="6" id="readerCard_code" class="input-text input-text-yzm" placeholder="请输入验证码">
					<a href="javascript:;" style="float: right; width: 110px;height: 44px;line-height: 44px;overflow: hidden;background-color: #dbdbdb;font-size: 14px;color: #333;text-align: center;border-radius: 5px;-moz-border-radius: 5px;-webkit-border-radius: 5px;cursor: pointer;"  onclick="sendReaderCardLoginCode();" id="readerCodeSmsCodeBut">点击获取</a>
				</div>
				</span>
					<p id="readerCardLogin_phone_tips" style="font-size: 14px;color: #734631;text-align: center;margin: 20px 0 20px;"></p>
			</div>

			<div class="user submit">
				<input type="button" id="readerCard_btn" class="login-submit" value="登录" onclick="checkReaderCardLogin()" style="background-color: #734631;" />
			</div>
		</div>
	</div>
</div>

<%@include file="/WEB-INF/why/index/footer.jsp" %>
</div>
<input type="hidden" name="callback" id="callback" value="${callback}"/>
<script>
/****修复IE placeholder 2015.11.04 niu****/
avalon.ready(function() {
    fixPlaceholder();
});
$(function() {
    var a = "${LoginType}";
    if (a) {
        if (a == 2) {
            dialogAlert("QQ登录提示", "该QQ账号已冻结!")
        } else {
            if (a == 3) {
                dialogAlert("微博登录提示", "该微博账号已冻结!")
            } else {
                if (a == 4) {
                    dialogAlert("微信登录提示", "该微信账号已冻结!")
                }
            }
        }
    }
});
$(document).keydown(function(a) {
    if (a.which == 13) {
        userLogin();
        return false
    }
    return true
});
var _thisPath = "${basePath}";
var model = avalon.define({
    $id: "Login",
    $loginUrl: _thisPath + "/frontTerminalUser/terminalLogin.do",
    $actUrl: _thisPath + "/frontIndex/index.do",
    $venueUrl: _thisPath + "/frontVenue/venueIndex.do",
    $forgetUrl: _thisPath + "/frontTerminalUser/forget.do",
    $regUrl: _thisPath + "/frontTerminalUser/userRegister.do?callback=" + $("#callback").val(),
    $logoUrl: _thisPath + "/STATIC/image/logo.png",
    $third: {
        qqUrl: _thisPath + "/qq/login.do?callback=" + $("#callback").val(),
        sinaUrl: _thisPath + "/sina/login.do?callback=" + $("#callback").val(),
        weChatUrl: _thisPath + "/wechat/login.do?callback=" + $("#callback").val()
    },
    errTips: "0",
    errCodeTips: "0",
    canLogin: true,
    toLogin: function() {
        userLogin()
    },
    LoginBtn: function(val) {
        model.canLogin = true
    }
});
var dataModel = avalon.define({
    $id: "dataModel",
    userName: "${userName}",
    $asm: new Date().getTime(),
    userPwd: "",
    rememberUser: 0
});
function userLogin() {
    dataModel.rememberUser = dataModel.rememberUser == true ? "on": "";
    if (!model.canLogin) {
        return
    }
    var a = dataModel.userName;
    if ($.trim(a) == "" || a == "请输入您的手机号") {
        model.errTips = "请输入您的手机号码";
        $("#userName").focus();
        return
    }
    var _thisReg = (/^1[34578]\d{9}$/);
    if (!a.match(_thisReg)) {
        model.errTips = "请输入正确的手机号码";
        $("#userName").focus();
        return
    }
    var b = dataModel.userPwd;
    if ($.trim(b) == "" || b == "请输入您的密码") {
        model.errTips = "请输入密码";
        $("#userPwd").focus();
        return
    }
    $.ajax({
        type: "POST",
        url: model.$loginUrl,
        data: dataModel.$model,
        dataType: "json",
        success: function(data) {
            var c = eval(data);
            if (c.status == "success") {
                //xh365使用跳转回自己的页面
                if ($("#callback").val() != undefined && $("#callback").val() != '') {
                    var  userHeadImgUrl = c.user.userHeadImgUrl;
                    if (userHeadImgUrl == undefined || userHeadImgUrl == null  || userHeadImgUrl == '') {
                        if (c.user.userSex == 1) {
                            userHeadImgUrl= 'http://www.wenhuayun.cn/STATIC/image/face_boy.png';
                        } else {
                            userHeadImgUrl= 'http://www.wenhuayun.cn/STATIC/image/face_girl.png';
                        }
                    }
                    window.location.href = $("#callback").val() + "?userId=" + c.user.userId + "&userName=" + c.user.userName + "&userHeadImgUrl=" + userHeadImgUrl + "&userMobileNo=" +  c.user.userMobileNo;
                } else {
                    window.location.href = model.$actUrl + "?asm=" + new Date().getTime();
                }
            } else {
                model.canLogin = false;
                if (c.status == "noActive") {
                    $("#userName").focus();
                    model.errTips = "账号未完成注册，请重新注册"
                }else if(c.status=="LoginLimit"){
                    model.errTips="密码输错次数过多,请明天再试";
                } else {
                    if (c.status == "isFreeze") {
                        model.errTips = "账号已冻结"
                    } else {
                        model.errTips = "账号和密码不匹配，请重新输入"
                    }
                }
            }
        },
        error: function() {
            model.canLogin = false;
            dialogAlert("提示", "系统繁忙")
        }
    })
};




function readerLogin() {
    $.ajax({
        type: "POST",
        url: model.$loginUrl,
        data: dataModel.$model,
        dataType: "json",
        before: function(){
            $("#readerCard_btn").val("正在登录");
        },
        success: function(data) {
            var c = eval(data);
            if (c.status == "success") {
                //xh365使用跳转回自己的页面
                if ($("#callback").val() != undefined && $("#callback").val() != '') {
                    var  userHeadImgUrl = c.user.userHeadImgUrl;
                    if (userHeadImgUrl == undefined || userHeadImgUrl == null  || userHeadImgUrl == '') {
                        if (c.user.userSex == 1) {
                            userHeadImgUrl= 'http://www.wenhuayun.cn/STATIC/image/face_boy.png';
                        } else {
                            userHeadImgUrl= 'http://www.wenhuayun.cn/STATIC/image/face_girl.png';
                        }
                    }
                    window.location.href = $("#callback").val() + "?userId=" + c.user.userId + "&userName=" + c.user.userName + "&userHeadImgUrl=" + userHeadImgUrl + "&userMobileNo=" +  c.user.userMobileNo;
                } else {
                    window.location.href = model.$actUrl + "?asm=" + new Date().getTime();
                }
            } else {
                $("#readerCard_btn").val("登录");
                model.canLogin = false;
                if (c.status == "noActive") {
                    $("#userName").focus();
                    $("#readerCardLogin_tips").html("账号未完成注册，请重新注册");
                }else if(c.status=="LoginLimit"){
                    $("#readerCardLogin_tips").html("密码输错次数过多,请明天再试");
                } else {
                    if (c.status == "isFreeze") {
                        $("#readerCardLogin_tips").html("账号已冻结");
                    } else {
                        $("#readerCardLogin_tips").html("账号和密码不匹配，请重新输入");
                    }
                }
            }
        },
        error: function() {
            model.canLogin = false;
            dialogAlert("提示", "系统繁忙")
        }
    })
};




//发送验证码
function sendSms() {
	$("#smsCodeBut").attr("onclick", "");
    mobileNo = $("#mobileNo").val();
    var telReg = (/^1[34578]\d{9}$/);
    if (mobileNo == "") {
        model.errCodeTips="请输入手机号！";
        $("#smsCodeBut").attr("onclick", "sendSms();");
        return false;
    } else if (!mobileNo.match(telReg)) {
    	model.errCodeTips="请正确填写手机号！";
    	$("#smsCodeBut").attr("onclick", "sendSms();");
        return false;
    }else{
    	model.errCodeTips="";
    }
    $.post("${path}/muser/loginSendCode.do", {mobileNo: mobileNo}, function (data) {
    	if (data.status == 1) {
              var s = 60;
              $("#smsCodeBut").html(s + "秒后重新获取");
              var ss = setInterval(function () {
                  s -= 1;
                  $("#smsCodeBut").html(s + "秒后重新获取");
                  if (s == 0) {
                      clearInterval(ss);
                      $("#smsCodeBut").attr("onclick", "sendSms();");
                      $("#smsCodeBut").html("发送验证码");
                  }
              }, 1000);
          }else{
          	$("#smsCodeBut").attr("onclick", "sendSms();");
          }
    }, "json");
}
$('.loginQie a').on('click', function () {
	$(this).addClass('cur').siblings().removeClass('cur');
	$(this).parent().parent().find(".loginContWc .loginCont").hide().eq($(this).index()).show();
});	
	//验证码登录
function userCodeLogin() {
	$("#codeLoginBtn").attr("onclick", "");
    if (mobileNo != $("#mobileNo").val()) {
        model.errCodeTips="手机号错误，请重新发送验证码！";
        $("#codeLoginBtn").attr("onclick", "userCodeLogin();");
        return false;
    }else{
    	model.errCodeTips="";
    }
    var code = $("#loginCode").val();
    if(!code){
    	model.errCodeTips="请输入验证码";
    	$("#codeLoginBtn").attr("onclick", "userCodeLogin();");
    	return false;
    }else if(code.length!=6){
    	model.errCodeTips="验证码长度有误";
    	$("#codeLoginBtn").attr("onclick", "userCodeLogin();");
    	return false;
    }else{
    	model.errCodeTips="";
    }
    $.post("${path}/muser/codeLogin.do", {mobileNo: mobileNo,code:code,callback :'${type}'}, function (data) {
    	if (data.status == 1) {
    		if(data.data.status == "success"){
    			var type = '${type}';
                if(type) {
                	if(type.indexOf("?")!=-1){
                		window.location.href = type+"&userId="+data.data.userId;
                	}else{
                		window.location.href = type+"?userId="+data.data.userId;
                	}
                }else {
                    window.location.href = '${path}/bpFrontIndex/index.do';
                }
    		}else{
    			$("#codeLoginBtn").attr("onclick", "userCodeLogin();");
    			model.errCodeTips=data.data.errorMsg;
    		}
          }else{
          	$("#codeLoginBtn").attr("onclick", "userCodeLogin();");
          	model.errCodeTips="响应失败！";
          }
    }, "json");
}


function readerCardLogin() {
	$(".readerCard_login_div").show();
	$(".login_div").hide();
}

var useAddress ="";
var userCardNo ="";
var userName ="";
var userPwd ="";
var userBirth ="";
var readerCard ="";

function checkReaderCardLogin(){
    var identifier = $("input[name='identifier']").val();
    var password = $("input[name='password']").val();
    if(!identifier){
        $("#readerCardLogin_tips").html("请输入读者证号！");
        return;
    }
    if(!password){
        $("#readerCardLogin_tips").html("请输入密码！");
        return;
    }
    $("#readerCardLogin_tips").html('');
    $("#readerCard_btn").val("正在登录");
    $.post("${path}/muser/checkReadCardLogin.do", {identifier: identifier,password:password},
        function (data) {
            data = JSON.parse(data);
            if (data.status == 10001) {
                $("#readerCardLogin_tips").html("账号或密码输入有误！");
            } else {
                useAddress =data.data.useAddress;
                userCardNo =data.data.userCardNo;
                userName =data.data.userName;
                userPwd =data.data.userPwd;
                userBirth =data.data.userBirth;
                readerCard =data.data.readerCard;
                if(data.status==200){
                    mobileNo = data.data.userMobileNo;

                    dataModel.userName = mobileNo;
                    dataModel.userPwd = userPwd;

                    readerLogin();
                }else{
                    $("#readerCard_btn").val("登录");
                    $("#readerCardLogin_tips").html("读者证用户首次登录需进行手机号验证");
                    $("#readerCard_btn").attr("onclick","register()");
                    $("#readerCard_mobileNo").val(data.data.userMobileNo);
                    $("#firstLogin").show();
                }
            }
        }, "json");
}



function register() {
    $("#readerCard_btn").val("正在登录");
    $("#codeLoginBtn").attr("onclick", "");
    if (mobileNo != $("#readerCard_mobileNo").val()) {
        $("#readerCardLogin_phone_tips").html("请获取验证码！");
        $("#readerCard_btn").attr("onclick", "register();");
        return false;
    }
    var code = $("#readerCard_code").val();
    if (!code) {
        $("#readerCardLogin_phone_tips").html("请输入验证码");
        $("#readerCard_btn").attr("onclick", "register();");
        return false;
    } else if (code.length != 6) {
        $("#readerCardLogin_phone_tips").html("验证码长度有误");
        $("#readerCard_btn").attr("onclick", "register();");
        return false;
    }
    $.post("${path}/muser/readerCardRegister.do", {
        userMobileNo: mobileNo,
        useAddress: useAddress,
        userCardNo: userCardNo,
        userName: userName,
        userBirthStr: userBirth,
        readerCard: readerCard,
        userPwd: userPwd,
        code: code,
        callback: '${type}'
    }, function (data) {
        if(data == "success"){
            $("#loginTips").html("")

            dataModel.userName = mobileNo;
            dataModel.userPwd = userPwd;
            readerLogin();
        }else{
            $("#readerCard_btn").val("登录");
            $("#codeLoginBtn").attr("onclick", "register()");
            if (data == "codeOvertime") {
                $("#readerCardLogin_phone_tips").html("验证码已过期，请重新索取！")
            } else if(data == "codeError"){
                $("#readerCardLogin_phone_tips").html("验证码不正确！")
            }else if(data == "mobileRepeat"){
                $("#readerCardLogin_phone_tips").html("手机号已存在！")
            }else if(data == "cardNoRepeat"){
                $("#readerCardLogin_phone_tips").html("身份证号已存在！")
            }else{
                $("#readerCardLogin_phone_tips").html("响应失败！")
            }
        }
    }, "json");
}



//发送验证码
function sendReaderCardLoginCode() {
    $("#readerCodeSmsCodeBut").attr("onclick", "");
    mobileNo = $("#readerCard_mobileNo").val();
    var telReg = (/^1[34578]\d{9}$/);
    if (mobileNo == "") {
        $("#readerCardLogin_phone_tips").html("请输入手机号！");
        $("#readerCodeSmsCodeBut").attr("onclick", "sendReaderCardLoginCode();");
        return false;
    } else if (!mobileNo.match(telReg)) {
        $("#readerCardLogin_phone_tips").html("请正确填写手机号！");
        $("#readerCodeSmsCodeBut").attr("onclick", "sendReaderCardLoginCode();");
        return false;
    }else{
        model.errCodeTips="";
    }
    $.post("${path}/muser/loginSendCode.do", {mobileNo: mobileNo}, function (data) {
        if (data.status == 1) {
            var s = 60;
            $("#readerCodeSmsCodeBut").html(s + "秒后重新获取");
            var ss = setInterval(function () {
                s -= 1;
                $("#readerCodeSmsCodeBut").html(s + "秒后重新获取");
                if (s == 0) {
                    clearInterval(ss);
                    $("#readerCodeSmsCodeBut").attr("onclick", "sendReaderCardLoginCode();");
                    $("#readerCodeSmsCodeBut").html("发送验证码");
                }
            }, 1000);
        }else{
            $("#readerCodeSmsCodeBut").attr("onclick", "sendReaderCardLoginCode();");
        }
    }, "json");
}

</script>
	
</body>
</html>
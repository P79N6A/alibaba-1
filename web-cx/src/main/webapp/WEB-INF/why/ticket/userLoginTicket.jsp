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
  <title>登录页--文化上海云</title>
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
    <!--[if lte IE 8]>
        <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture-ie.css" />
    <![endif]-->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/frontpage.css" />
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/login_key.css" /><!--模拟键盘-->
    <style type="text/css">.ms-controller,.ms-important,[ms-controller],[ms-important]{visibility:hidden}</style>
    <script  src="${path}/STATIC/js/jquery.min.js"></script>
    <script  src="${path}/STATIC/js/culture.js"></script>
    <script  src="${path}/STATIC/js/dialog-min.js"></script>
    <script  src="${path}/STATIC/js/placeholder.js"></script>
    <script  src="${path}/STATIC/js/avalon.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/login_key.js"></script><!--模拟键盘-->
    <script type="text/javascript">
        var phoneWidth=parseInt(window.screen.width);var phoneScale=phoneWidth/1200;var ua=navigator.userAgent;if(/Android (\d+\.\d+)/.test(ua)){var version=parseFloat(RegExp.$1);if(version>2.3){document.write('<meta name="viewport" content="width=1200, minimum-scale = '+phoneScale+", maximum-scale = "+(phoneScale+1)+', target-densitydpi=device-dpi">')}else{document.write('<meta name="viewport" content="width=1200, target-densitydpi=device-dpi">')}}else{document.write('<meta name="viewport" content="width=1200, user-scalable=yes, target-densitydpi=device-dpi">')};
    </script>
</head>
<body style="background-color: #ffffff;"  ms-important="Login">
<div id="login-header">
     <div class="header-con">
         <div class="logo fl">
             <a ms-attr-href="{{$actUrl}}"><img ms-attr-src="{{$logoUrl}}" alt="" width="149" height="39"/></a>
         </div>
         <div class="nav fl">
             <a class="activity" ms-attr-href="{{$actUrl}}" id="activityLabel"><i></i>活动</a>
             <a class="venues" ms-attr-href="{{$venueUrl}}" id="venueLabel"><i></i>场馆</a>
         </div>
     </div>
</div>
<div id="in-top" class="login-content clearfix" ms-controller="dataModel" style="height:580px;">
  <div class="user-login login-dialog">
    <h2>登录安康文化云</h2>
    <div class="msg-error" ms-if="errTips!=0">{{errTips}}</div>
      <div class="user name"><label class="txt">账号：</label>
          <input type="text" id="userName"  class="input-text inputs" ms-duplex="userName" data-duplex-changed="LoginBtn" maxlength="11" onkeyup="if(this.value!=this.value.replace(/\D/g,'')) this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" onblur="this.value=this.value.replace(/\D/g,'')" onfocus="this.value=this.value.replace(/\D/g,'')"  placeholder="请输入您的手机号"  />
      </div>
      <div class="user pwd"><label class="txt">密码：</label>
          <input type="password" id="userPwd" class="pwd_input inputs" placeholder="请输入您的密码"    ms-duplex="userPwd"   data-duplex-changed="LoginBtn"   maxlength="20" />
      </div>

<%--      <div class="user name"><label class="txt">账号：</label><input id="a1" type="text" class="input-text inputs" placeholder="昵称或手机号" /></div>
      <div class="user pwd"><label class="txt">密码：</label><input id="a2"  type="password" class="pwd_input inputs" placeholder="请输入您的密码" id="writes"/></div>--%>

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
      <div class="user submit"><input type="button" class="login-submit" ms-click="toLogin()"  value="登录"/></div>
      <div class="forgetPwd">
         <%-- <span class="fl"><label><input type="checkbox"  ms-duplex-checked="rememberUser" />记住账号</label></span>--%>
         <%-- <a class="fr" ms-attr-href="{{$forgetUrl}}">忘记密码</a>--%>
      </div>
<%--    <h4>外部账号登录</h4>
    <div class="login-cate">
        <a class="qq" ms-attr-href="{{$third.qqUrl}}"  title="QQ"></a>
        <a class="sina" ms-attr-href="{{$third.sinaUrl}}"  title="新浪微博" ></a>
        <a class="weixin" ms-attr-href="{{$third.weChatUrl}}" title="微信"><i></i></a>
    </div>--%>
    <div class="user register"><a ms-attr-href="{{$regUrl}}">注册文化上海云账号</a></div>
  </div>
</div>
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
    funPlaceholder(document.getElementById("username"));
    funPlaceholder(document.getElementById("userpassword"));
</script>
<script>
/****修复IE placeholder 2015.11.04 niu****/
avalon.ready(function(){fixPlaceholder()});$(function(){var a="${LoginType}";if(a){if(a==2){dialogAlert("QQ登录提示","该QQ账号已冻结!")}else{if(a==3){dialogAlert("微博登录提示","该微博账号已冻结!")}else{if(a==4){dialogAlert("微信登录提示","该微信账号已冻结!")}}}}});$(document).keydown(function(a){if(a.which==13){userLogin();return false}return true});var _thisPath="${basePath}";var model=avalon.define({$id:"Login",$loginUrl:_thisPath+"/userTicket/terminalLogin.do",$actUrl:_thisPath+"/frontActivity/venueBookIndex.do",$venueUrl:_thisPath+"/frontVenue/venueList.do",$forgetUrl:_thisPath+"/frontTerminalUser/forget.do",$regUrl:_thisPath+"/userTicket/userRegister.do",$logoUrl:_thisPath+"/STATIC/image/logo.png",$third:{qqUrl:_thisPath+"/qq/login.do",sinaUrl:_thisPath+"/sina/login.do",weChatUrl:_thisPath+"/wechat/login.do"},errTips:"0",canLogin:true,toLogin:function(){userLogin()},LoginBtn:function(val){model.canLogin=true}});var dataModel=avalon.define({$id:"dataModel",userName:"${userName}",$asm:new Date().getTime(),userPwd:"",rememberUser:0});function userLogin(){dataModel.rememberUser=dataModel.rememberUser==true?"on":"";if(!model.canLogin){return}var a=dataModel.userName;if($.trim(a)==""||a=="请输入您的手机号"){model.errTips="请输入您的手机号码";$("#userName").focus();return}var _thisReg=(/^1[34578]\d{9}$/);if(!a.match(_thisReg)){model.errTips="请输入正确的手机号码";$("#userName").focus();return}var b=dataModel.userPwd;if($.trim(b)==""||b=="请输入您的密码"){model.errTips="请输入密码";$("#userPwd").focus();return}$.ajax({type:"POST",url:model.$loginUrl,data:dataModel.$model,dataType:"text",success:function(c){if(c=="success"){window.location.href=model.$actUrl+"?asm="+new Date().getTime()}else{model.canLogin=false;if(c=="noActive"){$("#userName").focus();model.errTips="账号未完成注册，请重新注册"}else{if(c=="isFreeze"){model.errTips="账号已冻结"}else{model.errTips="账号和密码不匹配，请重新输入"}}}},error:function(){model.canLogin=false;dialogAlert("提示","系统繁忙")}})};
</script>
<%@include file="/WEB-INF/why/index/index_foot.jsp"%>
</body>
</html>
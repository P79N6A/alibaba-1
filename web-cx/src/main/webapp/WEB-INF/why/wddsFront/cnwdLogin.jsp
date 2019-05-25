<%@ page language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%
    String path = request.getContextPath();
    request.setAttribute("path", path);
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
    request.setAttribute("basePath", basePath);
%>
<!DOCTYPE html>
<html>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">

<script type="text/javascript" src="${path}/STATIC/wechat/js/wechat-util.js"></script>
<script type="text/javascript" src="${path}/STATIC/wechat/js/jweixin-1.0.0.js"></script>
<script type="text/javascript" src="${path}/STATIC/wechat/js/map-transform.js"></script>
<script type="text/javascript" src="${path}/STATIC/wechat/js/swiper-3.3.1.jquery.min.js"></script>
<script src="${path}/STATIC/js/avalon.js"></script>
<title>登录</title>
</head>
<body>
<div>
	<div class="loginTub"></div>
	<table class="loginTab">
		<tr>
			<td class="td1" colspan="2">
				<div class="txtDiv"><input class="txt txt1" type="text" maxlength="11"  placeholder="请输入您的手机号" name="phoneNo" id="phoneNo"><span class="tishi"></span></div>
			</td>
		</tr>
		<tr>
			<td class="td1">
				<div class="txtDiv"><input class="txt txt2" type="text" placeholder="请输入验证码" name="captcha" id="captcha"><span class="tishi"></span></div>
			</td>
			<td class="td2">
				<div id="smsSend" class="btnCommon yzm">获取验证码</div>
			</td>
		</tr>
		<tr>
			<td class="td1" colspan="2">
				<input class="btnCommon" type="button" value="手机号快捷登录" onclick="fastLogin();">
			</td>
		</tr>
	</table>
</div>
</body>
<script type="text/javascript">
$(function () {
    $('.wrpxPopFC').on('click', '.close', function () {
    	popUps($('.wrpxPopFC'),'hide');
    });
   
    if(!is_weixin()){
    	$("#wxBtn").hide();
    	$("#wxBtnImg").hide();
    	 
    }
});


$("#smsSend").click(function() {
	var phoneNo=$("#phoneNo").val();
	var obj=$("#phoneNo").next();
	
	if(!is_mobile($("#phoneNo").val())){
		if(!obj.hasClass("error")){
			obj.removeClass("correct");
			obj.addClass("error");				
		}
		popUps($('.wrpxPopFC'),'show', '请输入正确手机号', '<div class="btnCommon close">关闭</div>');
		 return; 
	 }else{
		  if(!obj.hasClass("correct")){
				obj.removeClass("error");
				obj.addClass("correct");				
		  }
		 
	 }
	sendCaptha();
});
function sendCaptha(){
	$("#smsSend").unbind();
	$("#smsSend").addClass("gray");
	var phoneNo=$("#phoneNo").val();
 	var smsSendUrl = "${path}/wrpxFrontUser/sendSmsCode.do";
	$.ajax({
		url : smsSendUrl,
		async : true,
		data : {phoneNo:phoneNo},
		method : 'post',
		beforeSend : function(xhr) {
		}
	}).done(function(data) {
		if (data.status == 'ok') {
			// 拿到 userId;
			$("#userId").val(data.usreId);
			smsTimer();
			 
			// 按钮变灰，30秒内 不能重点
		} else {
			$("#smsSend").removeClass("gray");
			  $("#smsSend").click(function () {
	            	sendCaptha();
			 });
			  popUps($('.wrpxPopFC'),'show', data.msg, '<div class="btnCommon close">关闭</div>');
		}

	}).fail(function(data) {

	}).always(function(data) {
	});
}

var timeOut = 60;
function smsTimer() {
        if (timeOut <= 0) {
            $("#smsSend").removeClass("gray");
            $("#smsSend").html("获取验证码");
            $("#smsSend").click(function () {
            	sendCaptha();
			});
            timeOut = 60;
        } else {
            $("#smsSend").html(timeOut+"秒后重新获取");
            timeOut--;
            setTimeout(function () {
                smsTimer();
            }, 1000);
        }
}

function fastLogin(){
	
	var phoneNo=$("#phoneNo").val();
	var obj=$("#phoneNo").next();
	var captcha=$("#captcha").val();
	var capObj=$("#captcha").next();
	if(!is_mobile(phoneNo)){
		popUps($('.wrpxPopFC'),'show', '请输入正确手机号', '<div class="btnCommon close">关闭</div>');
		if(!obj.hasClass("error")){
			obj.removeClass("correct");
			obj.addClass("error");				
		}
		 return; 
	 }else{
		   if(!obj.hasClass("correct")){
				obj.removeClass("error");
				obj.addClass("correct");				
			}
	 }
	if(captcha=='' ||captcha==undefined){
		popUps($('.wrpxPopFC'),'show', '验证码有误/为空，请查证后重新输入，若有疑问，请致电：400-018-2346', '<div class="btnCommon close">关闭</div>');
		
		if(!capObj.hasClass("error")){
			capObj.removeClass("correct");
			capObj.addClass("error");				
		}
		 return;
	}else{
		 if(!capObj.hasClass("correct")){
			 capObj.removeClass("error");
			 capObj.addClass("correct");				
		 }
	}
	
	var smsSendUrl = "${path}/wrpxFrontUser/login.do";
	$.ajax({
		url : smsSendUrl,
		async : true,
		data : {phoneNo:phoneNo,captcha:captcha},
		method : 'post',
		beforeSend : function(xhr) {
		}
	}).done(function(data) {
		if (data.status == 'ok') {
			// 直接选课
			if(data.verfied=='ok'){
				window.location.href='${path}/wrpxFrontCourse/toOrder.do';	
			}else{
				//识别码验证
				window.location.href='${path}/wrpxFrontUser/vertifyVerification.do?wrpxUserId='+data.userId;
			}
		} else {
			/* dialogAlert("提示", data.msg); */
			 popUps($('.wrpxPopFC'),'show', data.msg, '<div class="btnCommon close">关闭</div>');
		}

	}).fail(function(data) {

	}).always(function(data) {
	});
}

</script>
</html>
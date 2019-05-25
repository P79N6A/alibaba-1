<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta charset="utf-8" />
<title>佛山文化云订单找回系统</title>
<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css" />
<script type="text/javascript" src="${path}/STATIC/js/common.js"></script>
<style type="text/css">
	html , body {background-color: #e1e4f1;}
	.inTickets {min-height: 100%;}
</style>
<script>
	$(function() {

	});
	
	   //发送验证码
    function sendSms() {
        var userMobile = $("#userMobile").val();
        var telReg = (/^1[34578]\d{9}$/);
        if (userMobile == "") {
            dialogAlert('系统提示', '请输入手机号码！');
            return false;
        } else if (!userMobile.match(telReg)) {
            dialogAlert('系统提示', '请正确填写手机号码！');
            return false;
        }
        $.post("${path}/wechatActivity/sendCode.do", { userMobileNo: userMobile}, function (data) {
        	
        	if(data=="success"){
        		var s = 60;
                $("#smsCodeBut").attr("onclick", "");
                $("#smsCodeBut").html(s + "s");
                var ss = setInterval(function () {
                    s -= 1;
                    $("#smsCodeBut").html(s + "s");
                    if (s == 0) {
                        clearInterval(ss);
                        $("#smsCodeBut").attr("onclick", "sendSms();");
                        smsCode = '';
                        $("#smsCodeBut").html("发送验证码");

                    }
                }, 1000)	
        	}
              
        }, "json");
    }
	   
	   function getCode(){
		   
		   var userMobile = $("#userMobile").val();
			  var telReg = (/^1[34578]\d{9}$/);
		        if (userMobile == "") {
		            dialogAlert('系统提示', '请输入手机号码！');
		            return false;
		        } else if (!userMobile.match(telReg)) {
		            dialogAlert('系统提示', '请正确填写手机号码！');
		            return false;
		        }  
		        
		        $.post("${path}/wechatActivity/getCode.do", { userMobileNo: userMobile}, function (data) {
			    	  
		  			if(data.status=="success"){
			    		  
		  			$("#code").val(data.code)
			    	}
			    	else
			    	{
			    		  dialogAlert('获取失败', data.errorMsg);
				    	  return false;
			    	}
			    	  
			      }, "json");
		   
	   }
	   
	 function submit(){
		 
		  var userMobile = $("#userMobile").val();
		  var telReg = (/^1[34578]\d{9}$/);
	        if (userMobile == "") {
	            dialogAlert('系统提示', '请输入手机号码！');
	            return false;
	        } else if (!userMobile.match(telReg)) {
	            dialogAlert('系统提示', '请正确填写手机号码！');
	            return false;
	        }  
		 
	      var code=$("#code").val();
	      
	      if(!code){
	    	  
	    	  dialogAlert('系统提示', '请输入验证码！');
	    	  return false;
	      }
	      
	      $.post("${path}/wechatActivity/mobileLogin.do", { userMobileNo: userMobile,code:code}, function (data) {
	    	  
  			if(data.status=="success"){
	    		  
  				 window.location.href = "${path}/wechatActivity/userOrderList.do";
	    	}
	    	else
	    	{
	    		  dialogAlert('登录失败', data.errorMsg);
		    	  return false;
	    	}
	    	  
	      }, "json");
	 }
</script>
</head>
<body>
<div class="inTickets">
		<div class="logotp"></div>
		<p class="logowz">佛山文化云订单找回系统</p>
		<div class="inTicInput clearfix">
			<div class="biao"><span>手机号</span></div>
			<input class="txt" id="userMobile" name="userMobile" type="text">
		</div>
		<div class="inTicInput_yzm clearfix">
			<div class="inTicInput clearfix">
				<div class="biao"><span>验证码</span></div>
				<input class="txt" id="code" name="code" type="text">
			</div>
			<div class="fsyzm" id="smsCodeBut" onclick="sendSms();">发送验证码</div>
			<div style="clear:both;"></div>
		</div> 
		<input class="inTicBtn" type="button" onclick="submit();" value="登  录" >
	</div>
</body>
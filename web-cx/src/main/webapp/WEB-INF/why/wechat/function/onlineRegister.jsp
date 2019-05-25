<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>“文化上海云”应用大赛线上报名</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series-2.css"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		$.ajaxSettings.async = false; 	//同步执行ajax
	
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '2016年上海市民文化节“文化上海云”应用大赛报名';
	    	appShareDesc = '线上报名申请入口';
	    	appShareImgUrl = '${basePath}/STATIC/wxStatic/image/onlineRegister/shareIcon.jpg';
	    	
			injs.setAppShareButtonStatus(true);
		}
	
		//判断是否是微信浏览器打开
		if (is_weixin()) {
			//通过config接口注入权限验证配置
			wx.config({
				debug: false,
				appId: '${sign.appId}',
				timestamp: '${sign.timestamp}',
				nonceStr: '${sign.nonceStr}',
				signature: '${sign.signature}',
				jsApiList: ['onMenuShareAppMessage','onMenuShareTimeline','onMenuShareQQ','onMenuShareWeibo','onMenuShareQZone']
			});
			wx.ready(function () {
				wx.onMenuShareAppMessage({
					title: "2016年上海市民文化节“文化上海云”应用大赛报名",
					desc: '线上报名申请入口',
					imgUrl: '${basePath}/STATIC/wxStatic/image/onlineRegister/shareIcon.jpg'
				});
				wx.onMenuShareTimeline({
					title: "2016年上海市民文化节“文化上海云”应用大赛报名",
					imgUrl: '${basePath}/STATIC/wxStatic/image/onlineRegister/shareIcon.jpg'
				});
				wx.onMenuShareQQ({
					title: "2016年上海市民文化节“文化上海云”应用大赛报名",
					desc: '线上报名申请入口',
					imgUrl: '${basePath}/STATIC/wxStatic/image/onlineRegister/shareIcon.jpg'
				});
				wx.onMenuShareWeibo({
					title: "2016年上海市民文化节“文化上海云”应用大赛报名",
					desc: '线上报名申请入口',
					imgUrl: '${basePath}/STATIC/wxStatic/image/onlineRegister/shareIcon.jpg'
				});
				wx.onMenuShareQZone({
					title: "2016年上海市民文化节“文化上海云”应用大赛报名",
					desc: '线上报名申请入口',
					imgUrl: '${basePath}/STATIC/wxStatic/image/onlineRegister/shareIcon.jpg'
				});
			});
		}
		
		$(function () {
			if(window.screen.width <= 750){
				$(".or_loginBtn").html('请使用电脑登录文化云后台</br>http://www.wenhuayun.cn/login.do');
				$(".or_loginBtn").attr("onclick","");
			}else{
				$(".or_loginBtn").html('登录入口');
				$(".or_loginBtn").attr("onclick","location.href='http://www.wenhuayun.cn/login.do'");
			}
			
			$(window).resize(function() {
				if(window.screen.width <= 750){
					$(".or_loginBtn").html('请使用电脑登录文化云后台</br>http://www.wenhuayun.cn/login.do');
					$(".or_loginBtn").attr("onclick","");
				}else{
					$(".or_loginBtn").html('登录入口');
					$(".or_loginBtn").attr("onclick","location.href='http://www.wenhuayun.cn/login.do'");
				}
			});
		});
		
		
		//保存用户
		function userInfo(){
			$("#merchantUserForm li").removeClass("or_inputRight").removeClass("or_inputWrong");
			
			var userCompany = $("#userCompany").val();
			if(userCompany == ""){
		    	$("#userCompanyLi").addClass("or_inputWrong");
		        return false;
		    }else{
		    	$("#userCompanyLi").addClass("or_inputRight");
		    }
			var userName = $("#userName").val();
			if(userName == ""){
				$("#userNameLi").addClass("or_inputWrong");
		        return false;
		    }else{
		    	$("#userNameLi").addClass("or_inputRight");
		    }
			var userAccount = $("#userAccount").val();
			if(userAccount == ""){
				$("#userAccountLi").addClass("or_inputWrong");
		        return false;
		    }else{
		    	$("#userAccountLi").addClass("or_inputRight");
		    }
			var userPassword = $("#userPassword").val();
			if(userPassword == ""){
				$("#userPasswordLi").addClass("or_inputWrong");
		        return false;
		    }else{
		    	$("#userPasswordLi").addClass("or_inputRight");
		    }
			var userPassword2 = $("#userPassword2").val();
	    	if(userPassword != userPassword2){
	    		$("#userPassword2Li").addClass("or_inputWrong");
	    		return false;
	    	}else{
	    		$("#userPassword2Li").addClass("or_inputRight");
	    	}
    		var userMobileNo = $("#userMobileNo").val();
			var telReg = (/^1[34578]\d{9}$/);
			if(userMobileNo == "" || !userMobileNo.match(telReg)){
				$("#userMobileNoLi").addClass("or_inputWrong");
		        return false;
		    }else{
		    	$("#userMobileNoLi").addClass("or_inputRight");
		    }
			var userEmail = $("#userEmail").val();
			var regMail= /^[a-zA-Z0-9]+([\._\-]*[a-zA-Z0-9])*@([a-zA-Z0-9]+[-a-zA-Z0-9]*[a-zA-Z0-9]+\.){1,63}[a-zA-Z0-9]+$/;
			if(userEmail == "" || !regMail.test(userEmail)){
				$("#userEmailLi").addClass("or_inputWrong");
		        return false;
		    }else{
		    	$("#userEmailLi").addClass("or_inputRight");
		    }
			var userAddress = $("#userAddress").val();
			if(userAddress == ""){
				$("#userAddressLi").addClass("or_inputWrong");
		        return false;
		    }else{
		    	$("#userAddressLi").addClass("or_inputRight");
		    }
			$.post("${path}/wechatFunction/addMerchantUser.do", $("#merchantUserForm").serialize(), function(data) {
				if (data == "200") {
					var replyText = "您的申请已成功提交，我们会在3个工作日内审核，请您耐心等待；<br/>请牢记您的登录名："+userAccount+"，密码："+userPassword+"，一旦您的申请审核通过，您可以使用该用户名登录大赛后台进行操作，后台地址：http://www.wenhuayun.cn/login.do，您也可以在申请页面找到后台入口。";
					responseDialog('系统提示', replyText,function(){
						location.reload();
    				},1);
				}else if(data == "repeat"){
					$("#userAccountLi").removeClass("or_inputRight");
					$("#userAccountLi").addClass("or_inputWrong");
					responseDialog('系统提示', "该登录名已被注册！")
				}else {
					responseDialog('系统提示', "提交失败！")
				}
			},"json");
		}
	</script>
	
	<style>
		html,body {
			width: 100%;
			height: 100%;
		}
	</style>
</head>

<body>
	<div class="or_main">
		<div class="or_topDiv"></div>
		<div class="or_title">2016年上海市民文化节“文化上海云”应用大赛线上报名</div>
		<div class="or_inputList">
			<p class="or_inputTitle">填写信息</p>
			<form id="merchantUserForm">
				<ul>
					<li id="userCompanyLi" class="clearfix">
						<div><span>*</span>单位：</div>
						<div>
							<input id="userCompany" name="userCompany" type="text" placeholder="请输入您所在的单位" maxlength="20"/>
						</div>
					</li>
					<li id="userNameLi" class="clearfix">
						<div><span>*</span>姓名：</div>
						<div>
							<input id="userName" name="userName" type="text" placeholder="请输入您的姓名" maxlength="20"/>
						</div>
					</li>
					<li id="userAccountLi" class="clearfix">
						<div><span>*</span>登录名：</div>
						<div>
							<input id="userAccount" name="userAccount" type="text" placeholder="请输入您的登录名" maxlength="20"/>
						</div>
					</li>
					<li id="userPasswordLi" class="clearfix">
						<div><span>*</span>密码：</div>
						<div>
							<input id="userPassword" name="userPassword" type="password" placeholder="请输入您的密码" maxlength="20"/>
						</div>
					</li>
					<li id="userPassword2Li" class="clearfix">
						<div><span>*</span>密码确认：</div>
						<div>
							<input id="userPassword2" type="password" placeholder="请再次输入您的密码" maxlength="20"/>
						</div>
					</li>
					<li id="userMobileNoLi" class="clearfix">
						<div><span>*</span>手机号：</div>
						<div>
							<input id="userMobileNo" name="userMobileNo" type="text" placeholder="请输入您的手机号" maxlength="20"/>
						</div>
					</li>
					<li id="userEmailLi" class="clearfix">
						<div><span>*</span>邮箱：</div>
						<div>
							<input id="userEmail" name="userEmail" type="text" placeholder="请输入您的邮箱" maxlength="50"/>
						</div>
					</li>
					<li id="userAddressLi" class="clearfix">
						<div><span>*</span>地址：</div>
						<div>
							<input id="userAddress" name="userAddress" type="text" placeholder="请输入您的地址" maxlength="50"/>
						</div>
					</li>
				</ul>
			</form>
			<div class="or_button" onclick="userInfo();">完&emsp;成</div>
			<div class="or_loginBtn"></div>
		</div>
	</div>
</body>
</html>
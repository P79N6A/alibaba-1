<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>佛山文化云·艺术天空</title>

<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
<link rel="stylesheet" type="text/css"
	href="${path}/STATIC/wxStatic/css/style-series.css" />
<style type="text/css">
	html,body{font-family:arial,\5FAE\8F6F\96C5\9ED1,\9ED1\4F53,\5b8b\4f53,sans-serif; -webkit-text-size-adjust:none;/*Google Chrome*/}
	img {vertical-align: middle;}
	html, body , .skydata {height: 100%;}
</style>
<script src="${path}/STATIC/js/common.js"></script>

<script >

	if (userId == null || userId == '') {
		//判断登陆
		publicLogin('${basePath}wechatStatic/artSkyUserInfo.do');
	}

	//分享是否隐藏
	    if(window.injs){
	    	
			injs.setAppShareButtonStatus(false);
		}
	
		$(function() {
			
			$(".btn").click(function(){
				
				var userNickName = $("#userNickName").val();
				var userTelephone = $("#userTelephone").val();
				
				// 真实姓名
				if(userNickName == undefined || $.trim(userNickName) == ""){
					removeMsg("userNickNameLabel");
					appendMsg("userNickNameLabel","请输入真实姓名!");
					$("#userNickName").focus();
					return false;
				}else{
					removeMsg("userNickNameLabel");
				}
				
				var re =/^1\d{10}$/;
				// 手机号码
				if(userTelephone == undefined || $.trim(userTelephone) == ""){
					removeMsg("userTelephoneLabel");
					appendMsg("userTelephoneLabel","请输入手机号码!");
					$("#userTelephone").focus();
					return false;
				}else if(!re.test(userTelephone)){
					removeMsg("userTelephoneLabel");
					appendMsg("userTelephoneLabel","请正确填写手机号码!");
					$("#userTelephone").focus();
					return false;
				}else{
					removeMsg("userTelephoneLabel");
				}
				
				$.post("${path}/terminalUser/editTerminalUser.do", $("#form").serialize(), function(
						data) {
					if (data == "success") {
					
					window.location.href="${path}/wechatStatic/artSkyUserSuccess.do";
					
					}else {
						dialogAlert('系统提示', "提交失败")
					}
				});
				
				
			});
		})
</script>

</head>

<body>

<div class="skydata">
	<div class="skydatatab">
	<form id="form">
	<input id="userId" type="hidden" name="userId" value="${sessionScope.terminalUser.userId}"/>
	<input id="registerOrigin" name="registerOrigin" type="hidden" value="8"/>
		<div class='skdatit clearfix'><img src="${basePath}/STATIC/wxStatic/image/sky/pic3.png"></div>
		<div class="skdaw_1">艺术天空<br>现场索票</div>
		<div class="skdabge">
			<div class="divtxt clearfix td-input" id="userNickNameLabel">
				<div class="bt">姓&nbsp;&nbsp;&nbsp;&nbsp;名</div>
				<input type="text" id="userNickName" name="userNickName">
			</div>
			<div class="divtxt clearfix td-input" id="userTelephoneLabel">
				<div class="bt">手机号</div>
				<input type="text" id="userTelephone" name="userTelephone" maxlength="11"> 
			</div>
			<input class="btn" type="button" value="提   交">
			<p style="font-size:24px;line-height:40px; color:#333;margin-top:30px;">
			本页面为艺术天空现场订票专用<br>
			仅限活动现场工作人员引导订票 自行预约无效<br>
			登记成功即可进入现场余票排队系统，不代表确认订票，余票有限，领完即止<br>
			本页面最终解释权归文化云所有
			</p>
		</div>
		</form>
	</div>
	
</div>

</body>
</html>
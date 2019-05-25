<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>签到</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/cc/css/style.css"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
	
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '互联网+公共文化服务主题研讨会';
	    	appShareDesc = '11月19日-21日';
	    	appShareImgUrl = '${basePath}/STATIC/wx/image/share_120.png';
	    	
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
					title: "互联网+公共文化服务主题研讨会",
					desc: '11月19日-21日',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
				});
				wx.onMenuShareTimeline({
					title: "互联网+公共文化服务主题研讨会",
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
				});
				wx.onMenuShareQQ({
					title: "互联网+公共文化服务主题研讨会",
					desc: '11月19日-21日',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
				});
				wx.onMenuShareWeibo({
					title: "互联网+公共文化服务主题研讨会",
					desc: '11月19日-21日',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
				});
				wx.onMenuShareQZone({
					title: "互联网+公共文化服务主题研讨会",
					desc: '11月19日-21日',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
				});
			});
		}
		
		$(function() {
			
		})
		
		//签到
		function userSign(){
			if (userId == null || userId == '') {
	    		//判断登陆
	        	publicLogin('${basePath}cc/sign.do');
	    	}else{
	    		var userCompany = $("#userCompany").val();
	    		if(userCompany == ""){
			    	dialogAlert('系统提示', '请输入单位！');
			        return false;
			    }
	    		var userName = $("#userName").val();
				if(userName == ""){
			    	dialogAlert('系统提示', '请输入姓名！');
			        return false;
			    }
	    		var userMobile = $("#userMobile").val();
				var telReg = (/^1[34578]\d{9}$/);
				if(userMobile == ""){
			    	dialogAlert('系统提示', '请输入手机号码！');
			        return false;
			    }else if(!userMobile.match(telReg)){
			    	dialogAlert('系统提示', '请正确填写手机号码！');
			        return false;
			    }
				var data = {
					userCompany:userCompany,
					userName:userName,
					userMobile:userMobile,
					userId:userId
				}
	    		$.post("${path}/cc/saveUserSign.do",data, function (data) {
	    			if(data == "200"){
	    				dialogConfirm('系统提示', "签到成功！",function(){
	    					location.href = '${path}/cc/list.do';
	    				});
	    			}else if(data == "repeat") {
	    				dialogAlert('系统提示', "您已签过到！");
	    			}else if(data == "500"){
	    				dialogAlert('系统提示', "签到失败！");
	    			}
	    		},"json");
	    	}
		}
	</script>
	<style>
		html,body,.ccMain {
			width: 750px;
			height: 100%;
			margin: auto;
		}
	</style>
	
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${basePath}/STATIC/wx/image/share_120.png"/></div>
	<%-- <div class="ccMain" style="overflow: hidden;">
		<p class="searchTitle" style="margin-top: 100px;">签到</p>
		<div class="inputBg" style="height: 410px;">
			<div class="ccInpput">
				<p>单位</p>
				<input id="userCompany" type="text" maxlength="50"/>
				<div style="clear: both;"></div>
			</div>
			<div class="ccInpput">
				<p>姓名</p>
				<input id="userName" type="text" maxlength="20"/>
				<div style="clear: both;"></div>
			</div>
			<div class="ccInpput">
				<p>手机</p>
				<input id="userMobile" type="number" maxlength="20"/>
				<div style="clear: both;"></div>
			</div>
		</div>
		<div class="ccSubmitBtn" style="">
			<div class="LBtn" onclick="location.href='${path}/cc/list.do'">返回</div>
			<div class="RBtn" onclick="userSign();">签到</div>
			<div style="clear: both;"></div>
		</div>
	</div> --%>
	<div class="ccMain" style="padding-bottom: 50px;">
		<p class="searchTitle" style="margin-top: 100px;">跟车号查询</p>
		<img src="${path}/STATIC/cc/image/timelist.png" />
	</div>
</body>
</html>
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>互联网+公共文化服务主题研讨会</title>
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
	    	appShareLink = '${basePath}/cc/index.do';
	    	
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
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
					link: '${basePath}/cc/index.do'
				});
				wx.onMenuShareTimeline({
					title: "互联网+公共文化服务主题研讨会",
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
					link: '${basePath}/cc/index.do'
				});
				wx.onMenuShareQQ({
					title: "互联网+公共文化服务主题研讨会",
					desc: '11月19日-21日',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
					link: '${basePath}/cc/index.do'
				});
				wx.onMenuShareWeibo({
					title: "互联网+公共文化服务主题研讨会",
					desc: '11月19日-21日',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
					link: '${basePath}/cc/index.do'
				});
				wx.onMenuShareQZone({
					title: "互联网+公共文化服务主题研讨会",
					desc: '11月19日-21日',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
					link: '${basePath}/cc/index.do'
				});
			});
		}
		
		$(function() {
			
		})
		
		//查询
		function infoSearch(){
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
			location.href = '${path}/cc/toInfoResult.do?type=${type}&userName='+userName+'&userMobile='+userMobile;
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
	<div class="ccMain" style="overflow: hidden;">
		<p class="searchTitle" style="margin-top: 100px;">
			<c:if test="${type == 1}">房间查询</c:if>
			<c:if test="${type == 2}">跟车查询</c:if>
			<c:if test="${type == 3}">分桌查询</c:if>
		</p>
		<div class="inputBg" style="height: 300px;">
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
			<div class="RBtn" onclick="infoSearch();">查询</div>
			<div style="clear: both;"></div>
		</div>
	</div>
</body>
</html>
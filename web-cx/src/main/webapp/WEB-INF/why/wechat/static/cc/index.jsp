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
		
		
	</script>
	<style>
		html,body,.ccindexbg{
			width: 750px;
			height: 100%;
			margin: auto;
		}
	</style>
	
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${basePath}/STATIC/wx/image/share_120.png"/></div>
	<div class="ccindexbg" style="position: relative;">
		<div class="joinBtn" onclick="location.href='${path}/muser/login.do?type=${basePath}cc/list.do'">
			<img src="${path}/STATIC/cc/image/coming.png" />
		</div>
	</div>
</body>
</html>
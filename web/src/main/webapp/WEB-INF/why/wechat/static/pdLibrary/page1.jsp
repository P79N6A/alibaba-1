<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>浦东图书馆总分馆介绍</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '浦东图书馆总分馆介绍';
	    	appShareDesc = '就在你身边的大浦东35家街镇分馆，你去过多少？';
	    	appShareImgUrl = '${basePath}/STATIC/wxStatic/image/pdShareIcon.jpg';
	    	appShareLink = '${basePath}/wechatStatic/pdLibrary.do?page=1';
	    	
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
					title: "浦东图书馆总分馆介绍",
					desc: '就在你身边的大浦东35家街镇分馆，你去过多少？',
					link: '${basePath}wechatStatic/pdLibrary.do?page=1',
					imgUrl: '${basePath}/STATIC/wxStatic/image/pdShareIcon.jpg'
				});
				wx.onMenuShareTimeline({
					title: "浦东图书馆总分馆介绍",
					link: '${basePath}wechatStatic/pdLibrary.do?page=1',
					imgUrl: '${basePath}/STATIC/wxStatic/image/pdShareIcon.jpg'
				});
				wx.onMenuShareQQ({
					title: "浦东图书馆总分馆介绍",
					desc: '就在你身边的大浦东35家街镇分馆，你去过多少？',
					link: '${basePath}/wechatStatic/pdLibrary.do?page=1',
					imgUrl: '${basePath}/STATIC/wxStatic/image/pdShareIcon.jpg'
				});
				wx.onMenuShareWeibo({
					title: "浦东图书馆总分馆介绍",
					desc: '就在你身边的大浦东35家街镇分馆，你去过多少？',
					link: '${basePath}/wechatStatic/pdLibrary.do?page=1',
					imgUrl: '${basePath}/STATIC/wxStatic/image/pdShareIcon.jpg'
				});
				wx.onMenuShareQZone({
					title: "浦东图书馆总分馆介绍",
					desc: '就在你身边的大浦东35家街镇分馆，你去过多少？',
					link: '${basePath}/wechatStatic/pdLibrary.do?page=1',
					imgUrl: '${basePath}/STATIC/wxStatic/image/pdShareIcon.jpg'
				});
			});
		}
		
		$(function () {
			
			//分享
			$(".shareBtn").click(function() {
				if (!is_weixin()&&!(/wenhuayun/.test(ua))) {
					dialogAlert('系统提示', '请用微信浏览器打开分享！');
				}else{
					$("html,body").addClass("bg-notouch");
					$(".background-fx").css("display", "block")
				}
			})
			$(".background-fx").click(function() {
				$("html,body").removeClass("bg-notouch");
				$(".background-fx").css("display", "none")
			})
			//关注
			$(".keepBtn").on("touchstart", function() {
				$('.div-share').show()
				$("body,html").addClass("bg-notouch")
			})
		});
		
	</script>
	
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${basePath}/STATIC/wxStatic/image/pdShareIcon.jpg"/></div>
	<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
		<img src="${path}/STATIC/wechat/image/commonShare.png" style="width: 100%;height: 100%;" />
	</div>
	<div class="div-share">
		<div class="share-bg"></div>
		<div class="share">
			<img src="${path}/STATIC/wechat/image/wx-er2.png" />
			<p style="margin-top: 310px;">扫一扫&nbsp;关注文化云</p>
			<p>更多精彩活动、场馆等你发现</p>
			<button type="button" onclick="$('.div-share').hide();$('body,html').removeClass('bg-notouch')">关闭</button>
		</div>
	</div>
	<div class="pdtsg pdtsgsy">
	    <div class="pdheader">
	        <img src="http://img1.wenhuayun.cn/pdlibraryStatic/logo.png">
	        <ul class="lccshare clearfix">
	            <li><a class="shareBtn" href="javascript:;">分享</a></li>
	            <li><a class="keepBtn" href="javascript:;">关注</a></li>
	        </ul>
	    </div>
	    <img src="http://img1.wenhuayun.cn/pdlibraryStatic/sy1.png" style="display: block;margin: 0 auto;margin-top: 100px;margin-bottom: 120px;">
	    <ul class="pdele_1">
	        <li><a href="${path}/wechatStatic/pdLibrary.do?page=2">前言</a></li>
	        <li><a href="${path}/wechatStatic/pdLibrary.do?page=3">街镇分馆介绍(部分）</a></li>
	        <li><a href="${path}/wechatStatic/pdLibrary.do?page=6&point=0">延伸服务点</a></li>
	        <li><a href="${path}/wechatStatic/pdLibrary.do?page=6&point=2">流动图书车</a></li>
	    </ul>
	    <img src="http://img1.wenhuayun.cn/pdlibraryStatic/sy2.jpg" style="display: block;margin: 0 auto;margin-top: 40px;">
	    <div class="pdewm"><img src="http://img1.wenhuayun.cn/pdlibraryStatic/sy3.jpg"><p>浦东图书馆</p></div>
	</div>
</body>
</html>
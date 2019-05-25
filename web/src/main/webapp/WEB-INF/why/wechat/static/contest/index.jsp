<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>安康文化云·百科全叔</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '文化云|百科全“叔”知识挑战赛';
	    	appShareDesc = '你的知识还给老师了吗？传说中玩了会上瘾的百科知识挑战赛，全球${userSum}人都在玩！';
	    	appShareLink = '${basePath}/wechatStatic/contest.do';
			appShareImgUrl = '${basePath}/STATIC/wxStatic/image/bkqs/shareIcon.png';
	    	
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
					title: "文化云|百科全“叔”知识挑战赛",
					desc: '你的知识还给老师了吗？传说中玩了会上瘾的百科知识挑战赛，全球${userSum}人都在玩！',
					link: '${basePath}wechatStatic/contest.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/bkqs/shareIcon.png'
				});
				wx.onMenuShareTimeline({
					title: "你的知识还给老师了吗？传说中玩了会上瘾的百科知识挑战赛，全球${userSum}人都在玩！",
					imgUrl: '${basePath}/STATIC/wxStatic/image/bkqs/shareIcon.png',
					link: '${basePath}wechatStatic/contest.do'
				});
				wx.onMenuShareQQ({
					title: "文化云|百科全“叔”知识挑战赛",
					desc: '你的知识还给老师了吗？传说中玩了会上瘾的百科知识挑战赛，全球${userSum}人都在玩！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/bkqs/shareIcon.png',
					link: '${path}/muser/login.do?type=${basePath}wechatStatic/contest.do'
				});
				wx.onMenuShareWeibo({
					title: "文化云|百科全“叔”知识挑战赛",
					desc: '你的知识还给老师了吗？传说中玩了会上瘾的百科知识挑战赛，全球${userSum}人都在玩！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/bkqs/shareIcon.png',
					link: '${path}/muser/login.do?type=${basePath}wechatStatic/contest.do'
				});
				wx.onMenuShareQZone({
					title: "文化云|百科全“叔”知识挑战赛",
					desc: '你的知识还给老师了吗？传说中玩了会上瘾的百科知识挑战赛，全球${userSum}人都在玩！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/bkqs/shareIcon.png',
					link: '${path}/muser/login.do?type=${basePath}wechatStatic/contest.do'
				});
			});
		}
		
		$(function () {
          	//分享
			$(".share-button").click(function() {
				if (!is_weixin()&&!(/wenhuayun/.test(ua))) {
					dialogAlert('系统提示', '请用微信浏览器打开分享！');
				}else{
					$("html,body").addClass("bg-notouch");
					$(".background-fx").css("display", "block")
				}
			});
			$(".background-fx").click(function() {
				$("html,body").removeClass("bg-notouch");
				$(".background-fx").css("display", "none")
			});
			//关注
			$(".keep-button").on("touchstart", function() {
				$('.div-share').show();
				$("body,html").addClass("bg-notouch")
			})
            
		});
		
	</script>
	
	<style>
		html,body {
			height: 100%;
			width: 100%;
			overflow: hidden;
		}
	</style>
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${path}/STATIC/wxStatic/image/bkqs/shareIcon.png"/></div>
	<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
		<img src="${path}/STATIC/wxStatic/image/bkqs/shareBg.png" style="width: 100%;height: 100%;" />
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
	<div class="bkqs-main">
		<!--首页-->
		<div class="bkqs-main-cover">
			<div class="bkqs-main-cover-top">
				<img src="${path}/STATIC/wxStatic/image/bkqs/why-logo.png" style="float: left;" />
				<div style="float: right;">
					<img class="share-button" style="float: left;margin-right: 20px;" src="${path}/STATIC/wxStatic/image/bkqs/share-button.png" />
					<img class="keep-button" style="float: left;" src="${path}/STATIC/wxStatic/image/bkqs/keep-button.png" />
					<div style="clear: both;"></div>
				</div>
				<div style="clear: both;"></div>
			</div>
			<img class="bkqs-main-cover-middle" src="${path}/STATIC/wxStatic/image/bkqs/cover-middle.png" />
			<img class="bkqs-main-cover-bottom" src="${path}/STATIC/wxStatic/image/bkqs/cover-bottom.png" />
			<div class="start-button" onclick="location.href='${path}/wechatStatic/topic.do'">
				<img src="${path}/STATIC/wxStatic/image/bkqs/start-button.png" />
			</div>
		</div>
	</div>
</body>
</html>
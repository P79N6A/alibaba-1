<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>安康文化云·百科全叔</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		var topicId = '${topicId}';
		
		//分享是否隐藏
        if(window.injs){
    		injs.setAppShareButtonStatus(false);
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
					desc: '我在【${topicName}${topicTitle}】挑战赛中勇闯${passNumber}关，战胜全球${ranking}名选手，你敢来挑战吗！',
					link: '${basePath}wechatStatic/contest.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/bkqs/shareIcon.png'
				});
				wx.onMenuShareTimeline({
					title: "我在【${topicName}${topicTitle}】挑战赛中勇闯${passNumber}关，战胜全球${ranking}名选手，你敢来挑战吗！",
					imgUrl: '${basePath}/STATIC/wxStatic/image/bkqs/shareIcon.png',
					link: '${basePath}wechatStatic/contest.do'
				});
				wx.onMenuShareQQ({
					title: "文化云|百科全“叔”知识挑战赛",
					desc: '我在【${topicName}${topicTitle}】挑战赛中勇闯${passNumber}关，战胜全球${ranking}名选手，你敢来挑战吗！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/bkqs/shareIcon.png',
					link: '${path}/muser/login.do?type=${basePath}wechatStatic/contest.do'
				});
				wx.onMenuShareWeibo({
					title: "文化云|百科全“叔”知识挑战赛",
					desc: '我在【${topicName}${topicTitle}】挑战赛中勇闯${passNumber}关，战胜全球${ranking}名选手，你敢来挑战吗！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/bkqs/shareIcon.png',
					link: '${path}/muser/login.do?type=${basePath}wechatStatic/contest.do'
				});
				wx.onMenuShareQZone({
					title: "文化云|百科全“叔”知识挑战赛",
					desc: '我在【${topicName}${topicTitle}】挑战赛中勇闯${passNumber}关，战胜全球${ranking}名选手，你敢来挑战吗！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/bkqs/shareIcon.png',
					link: '${path}/muser/login.do?type=${basePath}wechatStatic/contest.do'
				});
			});
		}
		
		$(function () {
			//分享
			$(".button-div1:eq(0)").click(function() {
				var ua = navigator.userAgent.toLowerCase();	
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
		});
		
		//跳转到关卡
		function showQuestion(){
            window.location.href = '${path}/wechatStatic/question.do?topicId='+topicId;
		}
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
	<div class="bkqs-main">
		<!-- 方便分享自动抓取 -->
		<div style="display: none;"><img src="${path}/STATIC/wxStatic/image/bkqs/shareIcon.png"/></div>
		<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
			<img src="${path}/STATIC/wxStatic/image/bkqs/shareBg.png" style="width: 100%;height: 100%;" />
		</div>
		<div class="bkqs-end">
			<div class="end-p">
				<p>你已成功闯过<span style="color: #da555a;">${passNumber}</span>关，成为${passName}！</p>
				<p>已战胜全球<span style="color: #da555a;">${ranking}</span>名挑战者！</p>
			</div>
		</div>
		<div class="answer-button">
			<div class="button-div1">
				<img src="${path}/STATIC/wxStatic/image/bkqs/shareBut.png" />
			</div>
			<div class="button-div1"></div>
			<div class="button-div1" onclick="showQuestion();">
				<img src="${path}/STATIC/wxStatic/image/bkqs/unlockbutton.png" />
			</div>
			<div style="clear: both;"></div>
		</div>
	</div>
</body>
</html>
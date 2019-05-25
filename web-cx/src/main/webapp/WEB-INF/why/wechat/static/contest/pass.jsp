<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>佛山文化云·百科全叔</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		var userHeadImgUrl = '${userHeadImgUrl}';
		
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
					desc: '我在【${topicName}${topicTitle}】挑战赛中全部通关，成为全球第${ranking}通关者，获得了【${passName}】称号，你敢来挑战吗！',
					link: '${basePath}wechatStatic/contest.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/bkqs/shareIcon.png'
				});
				wx.onMenuShareTimeline({
					title: "我在【${topicName}${topicTitle}】挑战赛中全部通关，成为全球第${ranking}通关者，获得了【${passName}】称号，你敢来挑战吗！",
					imgUrl: '${basePath}/STATIC/wxStatic/image/bkqs/shareIcon.png',
					link: '${basePath}wechatStatic/contest.do'
				});
				wx.onMenuShareQQ({
					title: "文化云|百科全“叔”知识挑战赛",
					desc: '我在【${topicName}${topicTitle}】挑战赛中全部通关，成为全球第${ranking}通关者，获得了【${passName}】称号，你敢来挑战吗！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/bkqs/shareIcon.png',
					link: '${path}/muser/login.do?type=${basePath}wechatStatic/contest.do'
				});
				wx.onMenuShareWeibo({
					title: "文化云|百科全“叔”知识挑战赛",
					desc: '我在【${topicName}${topicTitle}】挑战赛中全部通关，成为全球第${ranking}通关者，获得了【${passName}】称号，你敢来挑战吗！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/bkqs/shareIcon.png',
					link: '${path}/muser/login.do?type=${basePath}wechatStatic/contest.do'
				});
				wx.onMenuShareQZone({
					title: "文化云|百科全“叔”知识挑战赛",
					desc: '我在【${topicName}${topicTitle}】挑战赛中全部通关，成为全球第${ranking}通关者，获得了【${passName}】称号，你敢来挑战吗！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/bkqs/shareIcon.png',
					link: '${path}/muser/login.do?type=${basePath}wechatStatic/contest.do'
				});
			});
		}
		
		$(function () {
			//头像
			var userHeadImgHtml = '';
			if(userHeadImgUrl.length>0){
                if(userHeadImgUrl.indexOf("http") == -1){
                	userHeadImgUrl = getImgUrl(userHeadImgUrl);
                }
            }
			if (userHeadImgUrl.indexOf("http") == -1) {
            	userHeadImgHtml = "<img src='../STATIC/wx/image/sh_user_header_icon.png'/>";
            } else if (userHeadImgUrl.indexOf("/front/") != -1) {
                var imgUrl = getIndexImgUrl(userHeadImgUrl, "_300_300");
                userHeadImgHtml = "<img src='" + imgUrl + "' onerror='imgNoFind();'/>";
            } else {
            	userHeadImgHtml = "<img src='" + userHeadImgUrl + "' onerror='imgNoFind();'/>";
            }
			$(".end2-user").append(userHeadImgHtml);
			
			$(".user-card").click(function(){
				$('.user-card').fadeOut();
			})
			
			//分享
			$(".end2-share").click(function() {
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
		
		//跳转到主题
		function showTopic(){
			window.location.href = '${path}/wechatStatic/topic.do';
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
		<div class="bkqs-end2">
			<div class="end2-user">
				<div class="end2-user-div"></div>
			</div>
			<div class="end-p2">
				<p>你已完成<span style="color: #da555a;">${topicName}</span>主题全部关卡</p>
			</div>
			<div class="end2-share">
				<img src="${path}/STATIC/wxStatic/image/bkqs/end2-share.png" />
			</div>
			<div class="end2-change" onclick="showTopic();">
				<img src="${path}/STATIC/wxStatic/image/bkqs/end2-change.png" />
			</div>
			<div class="end2-no" onclick="$('.user-card').fadeIn();">
				<img src="${path}/STATIC/wxStatic/image/bkqs/end2-no.png" />
			</div>
		</div>
		<div class="user-card" style="display: none;">
			<div class="pass-card">
				<img src="${path}/STATIC/wxStatic/image/bkqs/user-card.png" />
				<p class="user-card-p1">全球第<span style="color: #b23e42;">${ranking}</span>位${passName}</p>
				<p class="user-card-p2">${passText}</p>
			</div>
		</div>
	</div>
</body>
</html>
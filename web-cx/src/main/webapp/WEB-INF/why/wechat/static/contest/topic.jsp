<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>佛山文化云·百科全叔</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
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
			
			$.post("${path}/wechatStatic/getAllTopics.do", function (data) {
				if (data.status == 1) {
					$.each(data.data, function (i, dom) {
						if(dom.topicStatus==1){
							var imgUrl = getImgUrl(dom.topicIcon);
							$("#topicUl").append("<li id='"+dom.topicId+"' onclick='showQuestion(\""+dom.topicId+"\")'>" +
									"<img src='"+imgUrl+"' width='220' height='167'/>" +
								 "</li>");
						}
					});
					for(var i=0;i<3;i++){
						$("#topicUl").append("<li>" +
								"<img src='${path}/STATIC/wxStatic/image/bkqs/locked.png'/>" +
							 "</li>");
					}
				}
			}, "json");
		});
		
		//跳转到关卡
		function showQuestion(topicId){
			if (userId == null || userId == '') {
              	//判断登陆
            	publicLogin("${basePath}wechatStatic/topic.do");
            }else{
            	$.post("${path}/wechatStatic/saveOrUpdateContestUser.do",{userId:userId,topicId:topicId}, function (data) {
            		if(data.status==1){
            			window.location.href = '${path}/wechatStatic/question.do?topicId='+topicId;
            		}
            	}, "json");
            }
		}
	</script>
	
	<style>
		html,body {
			height: 100%;
			width: 100%;
			overflow: hidden;
		}
		.bkqs-main {
			overflow-y: scroll;
			-webkit-overflow-scrolling: touch;
		}
	</style>
</head>

<body>
	<div class="bkqs-main">
		<!-- 方便分享自动抓取 -->
		<div style="display: none;"><img src="${path}/STATIC/wxStatic/image/bkqs/shareIcon.png"/></div>
		<div class="bkqs-type">
			<div class="bkqs-type-title">
				<img src="${path}/STATIC/wxStatic/image/bkqs/type.png" />
			</div>
			<div class="bkqs-type-list">
				<ul id="topicUl"></ul>
			</div>
		</div>
	</div>
</body>
</html>
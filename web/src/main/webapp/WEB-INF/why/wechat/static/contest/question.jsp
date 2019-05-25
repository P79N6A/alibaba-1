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
		var passStr = '';	//解锁关卡关数
		var sum = '';	//总关卡数
		
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
			if (userId == null || userId == '') {
				//判断登陆
	        	publicLogin("${basePath}wechatStatic/topic.do");
				return;
			}
			
			$.post("${path}/wechatStatic/getContestUserResult.do",{userId:userId,topicId:topicId}, function (data) {
				if (data.status == 1) {
					var userInfo = data.data;
					var allArray = userInfo.allQuestionNumber!=null?userInfo.allQuestionNumber.split (","):[];
					var trueArray = userInfo.trueQuestionNumber!=null?userInfo.trueQuestionNumber.split (","):[];
					$.post("${path}/wechatStatic/getTopicPassInfo.do",{topicId:topicId}, function (data2) {
						if (data2.status == 1) {
							var topicPass = data2.data;
							$("#topicInfo").html("“"+topicPass.topicName+"”&nbsp;"+topicPass.topicTitle)
							//获取用户已解锁关卡数
							var pass = topicPass.sum;
							sum = topicPass.sum;
							$.each(topicPass.topicPassVOList, function (i, dom) {
								if(i==0){
									pass = dom.passNumber;
									passStr = dom.passNumber;
								}else{
									passStr += ","+dom.passNumber;
								}
								if(userInfo.trueQuestionNumber){
									if(userInfo.trueQuestionNumber.indexOf(getTrueStr(dom.passNumber))>=0){
										if(topicPass.topicPassVOList[i+1]){
											pass = topicPass.topicPassVOList[i+1].passNumber;
										}else{
											pass = topicPass.sum;
										}
									}
								}
							});
							
							$.each(topicPass.questionIdArray, function (i, dom) {
								var n = "";
								var imgSrc = "";
								var onclick = "";
								if(pass>=(i+1)){	//是否解锁
									if($.inArray((i+1).toString(), allArray)!=-1){	//是否答过
										imgSrc = "${path}/STATIC/wxStatic/image/bkqs/btn1.png";
										if($.inArray((i+1).toString(), trueArray)!=-1){	//是否答对
											imgSrc = "${path}/STATIC/wxStatic/image/bkqs/btn2.png";
										}
									}else{
										imgSrc = "${path}/STATIC/wxStatic/image/bkqs/btn3.png";
									}
									onclick = "showAnswer(\""+dom+"\","+(i+1)+")";
									n = (i+1)<10?"0"+(i+1):(i+1);
								}else{
									imgSrc = "${path}/STATIC/wxStatic/image/bkqs/locked.png";
								}
								$("#questionUl").append("<li id='"+dom+"' onclick='"+onclick+"'>" +
															"<img src='"+imgSrc+"' width='220' height='167'/>" +
															"<p class='list-num'>"+n+"</p>" +
														"</li>");
							});
							
							//判断用户是否通关
							if(sum==trueArray.length){
								$(".bkqs-type").prepend("<div class='pass-BTN' onclick='toPass();'>" +
													"<img src='${path}/STATIC/wxStatic/image/bkqs/passBut2.png'/>" +
												"</div>");
							}
						}
					}, "json");
				}
			}, "json");
			
		});
		
		//拼数字字符串
		function getTrueStr(n){
			var str = "1";
			for(var i=1;i<n;i++){
				str += ","+(i+1);
			}
			return str;
		}
		
		//跳转到答题页
		function showAnswer(questionId,n){
			if (userId == null || userId == '') {
				//判断登陆
	        	publicLogin("${basePath}wechatStatic/topic.do");
            }else{
            	$.post("${path}/wechatStatic/saveOrUpdateContestUser.do",{userId:userId,topicId:topicId,answerQuestionNumber:n}, function (data) {
            		if(data.status==1){
            			window.location.href = '${path}/wechatStatic/answer.do?questionId='+questionId+'&topicId='+topicId+'&passStr='+passStr+'&sum='+sum;
            		}
            	}, "json");
            }
		}
		
		//跳转到通关页面
		function toPass(){
			if (userId == null || userId == '') {
				//判断登陆
	        	publicLogin("${basePath}wechatStatic/topic.do");
			}else{
				window.location.href = '${path}/wechatStatic/pass.do?topicId='+topicId+'&sum='+sum+'&userId='+userId;
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
			<div class="change-BTN" onclick="location.href='${path}/wechatStatic/topic.do'">
				<img src="${path}/STATIC/wxStatic/image/bkqs/topicBut.png" />
			</div>
			<div class="bkqs-type-title">
				<img src="${path}/STATIC/wxStatic/image/bkqs/subject.png" />
				<p id="topicInfo" style="position: absolute;width: 680px;text-align: center;font-size: 50px;color: #da555a;left: 35px;top: 50px;"></p>
			</div>
			<div class="bkqs-type-list">
				<ul id="questionUl"></ul>
			</div>
		</div>
	</div>
</body>
</html>
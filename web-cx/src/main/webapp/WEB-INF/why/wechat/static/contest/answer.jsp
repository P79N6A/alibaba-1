<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>佛山文化云·百科全叔</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		var topicId = '${topicId}';
		var questionId = '${questionId}';
		var passStr = '${passStr}';	//解锁关卡关数（所有）
		var passNumber = '';	//解锁关卡关数
		var num = 0		//当前答题序号（0开始）
		var isSuccess = 1;		//判断是否闯关成功（0：失败；1：成功）
		var answerSum = 0;		//答案总数
		var questionNumber = "";	//关卡序号
		var sum = '${sum}';	//总关卡数
		
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
			
			$.post("${path}/wechatStatic/getQuestionAnswerInfo.do",{questionId:questionId,topicId:topicId}, function (data) {
				if (data.status == 1) {
					var info = data.data;
					questionNumber = info.questionNumber;
					var n = questionNumber<10?"0"+questionNumber:questionNumber;
					$("#topicName").html(info.topicName+"<span style='color:#ffe27d ;'>"+n+"</span>关");
					$("#questionNumber").html(n);
					$("#questionTitle").html(info.questionTitle);
					answerSum = info.answerList.length;
					$.each(info.answerList, function (i, dom) {
						var isShow = '';
						if(i==0){
							isShow = "style='display: block;'"
						}
						var imgUrl = getIndexImgUrl(getImgUrl(dom.answerPicUrl),"_750_500");
						$("#answerList").append("<div class='question-answer div' "+isShow+" istrue="+dom.isTrue+" answerno="+i+">" +
													"<img src='"+imgUrl+"'/>" +
													"<p>"+dom.answerText+"</p>" +
												"</div>");
						if(dom.isTrue==1){
							$(".answer-key").append("<p class='answer-key2'>"+dom.answerText+"</p>");
						}
					});
					
					if(localStorage.getItem("conTestHelp")!=1){
						help();
					}else{
						ready();	//开始提示
					}
				}
			}, "json");
			
		});
		
		//切换答案效果
		function NextQuestion() {
			$(".div").eq(num).animate({
				"left": "750px"
			}, 500, function() {
				num += 1;
				$(".div").eq(num).fadeIn()
			})
		};
		
		//开始提示
		function ready() {
			$(".bkqs-main-ready").show();
			$(".ready-button").animate({
				"left": "340px"
			}, 200).animate({
				"left": "285px"
			}, 500)
			setTimeout(function() {
				$(".ready-button").animate({
					"left": "210px"
				}, 500).animate({
					"left": "760px"
				}, 200, function() {
					$(".ready-button").css("left", "-200px")
					$(".bkqs-main-ready").fadeOut();
					
					//对错按钮事件
					$(".question-wrong").on("touchstart", function() {
						$(this).find("img").attr("src", "${path}/STATIC/wxStatic/image/bkqs/wrong_on.png")
						$(this).on("touchend", function() {
							$(".question-wrong").find("img").attr("src", "${path}/STATIC/wxStatic/image/bkqs/wrong.png")
						})
					})
					$(".question-wrong").click(function() {
						if($("div[answerno="+num+"]").attr("istrue")==1){
							isSuccess = 0;
						}
						if(answerSum == (num+1)){
							AnswerTimeReset();
							showResult();
						}else{
							NextQuestion();
							AnswerTimeReset();
							AnswerTime();
						}
					});
					$(".question-right").on("touchstart", function() {
						$(this).find("img").attr("src", "${path}/STATIC/wxStatic/image/bkqs/right_on.png")
						$(this).on("touchend", function() {
							$(".question-right").find("img").attr("src", "${path}/STATIC/wxStatic/image/bkqs/right.png")
						})
					})
					$(".question-right").click(function() {
						if($("div[answerno="+num+"]").attr("istrue")==2){
							isSuccess = 0;
						}
						if(answerSum == (num+1)){
							AnswerTimeReset();
							showResult();
						}else{
							NextQuestion();
							AnswerTimeReset();
							AnswerTime();
						}
					});
					
					AnswerTime();
				})
			}, 1200)
		}

		//帮助页面
		function help() {
			$(".question-answer").addClass("z-10")
			$(".bkqs-help").show()
			$(".help-1").show()
			$(".zindex1").click(function() {
				$(".question-answer").removeClass("z-10")
				$(".zindex1").addClass('z-90')
				$(".question-wrong").addClass("z-10")
				$(".help-1").hide()
				$(".help-2").show()
			})
			$(".zindex2").click(function() {
				$(".question-wrong").removeClass("z-10")
				$(".question-right").addClass("z-10")
				$(".help-2").hide()
				$(".help-3").show()
			})
			$(".help-button").click(function() {
				$(".help-3").hide()
				$(".bkqs-help").hide()
				$(".question-right").removeClass("z-10")
				localStorage.setItem("conTestHelp", 1);	//帮助缓存
				ready();	//开始提示
			})
		}

		//计时器
		function AnswerTime() {
			$(".answer-clock").animate({
				"left": 625
			}, 10000, "linear")
			$(".answer-time").animate({
				"width": 540
			}, 10000, "linear", function() {
				isSuccess = 0;
				if(answerSum == (num+1)){
					AnswerTimeReset();
					showResult();
				}else{
					NextQuestion();
					AnswerTimeReset();
					AnswerTime();
				}
			})

		}

		//重置计时器
		function AnswerTimeReset() {
			$(".answer-clock").stop().css("left", "100px");
			$(".answer-time").stop().css("width", "0px");
		}
		
		//显示结果
		function showResult(){
			if(isSuccess==1){
				$.post("${path}/wechatStatic/getContestUserResult.do",{userId:userId,topicId:topicId}, function (data) {
					if (data.status == 1) {
						var userInfo = data.data;
						var trueArray = userInfo.trueQuestionNumber!=null?userInfo.trueQuestionNumber.split (","):[];
						if($.inArray(questionNumber.toString(), trueArray)==-1){
							trueArray.push(questionNumber.toString());
							var passArray = passStr.split (",");
							for(var i=passArray.length-1;i>=0;i--){
								if(trueArray.length==passArray[i]){
									passNumber = passArray[i];
									$(".button-div1:eq(0) img").remove();
									$(".button-div1:eq(1) img").attr("src","${path}/STATIC/wxStatic/image/bkqs/upBut.png");
									$(".button-div1:eq(2) img").remove();
									$(".button-div1:eq(0)").attr("onclick","");
									$(".button-div1:eq(1)").attr("onclick","toNextPage(4)");
									$(".button-div1:eq(2)").attr("onclick","");
									break;
								}
							};
							if(trueArray.length==sum){
								$(".button-div1:eq(0) img").remove();
								$(".button-div1:eq(1) img").attr("src","${path}/STATIC/wxStatic/image/bkqs/passBut.png");
								$(".button-div1:eq(2) img").remove();
								$(".button-div1:eq(0)").attr("onclick","");
								$(".button-div1:eq(1)").attr("onclick","toNextPage(5)");
								$(".button-div1:eq(2)").attr("onclick","");
							}
						}
					}
				}, "json");
				$(".answer-title2").html("太棒了，闯关成功！");
			}else{
				$(".answer-title2").html("很遗憾，闯关失败！");
				$(".button-div1:eq(2) img").attr("src","${path}/STATIC/wxStatic/image/bkqs/changenum.jpg");
			}
			$(".answer-right").fadeIn();
		}
		
		//跳转至下一页
		function toNextPage(type){
			if(isSuccess==1){
				$.post("${path}/wechatStatic/saveOrUpdateContestUser.do",{userId:userId,topicId:topicId,trueQuestionNumber:questionNumber}, function (data) {
            		if(data.status==1){
            			if(type==1){
            				window.location.reload();
            			}else if(type==2){
            				window.location.href = '${path}/wechatStatic/topic.do';
            			}else if(type==3){
            				window.location.href = '${path}/wechatStatic/question.do?topicId='+topicId;
            			}else if(type==4){
            				window.location.href = '${path}/wechatStatic/upgrade.do?topicId='+topicId+'&passNumber='+passNumber;
            			}else if(type==5){
            				window.location.href = '${path}/wechatStatic/pass.do?topicId='+topicId+'&sum='+sum+'&userId='+userId;
            			}
            		}
            	}, "json");
			}else{
				if(type==1){
    				window.location.reload();
    			}else if(type==2){
    				window.location.href = '${path}/wechatStatic/topic.do';
    			}else if(type==3){
    				window.location.href = '${path}/wechatStatic/question.do?topicId='+topicId;
    			}
			}
		}

		//拼数字字符串
		function getTrueStr(n){
			var str = "1";
			for(var i=1;i<n;i++){
				str += ","+(i+1);
			}
			return str;
		}
	</script>
	
	<style>
		html,body {
			height: 100%;
			width: 100%;
			overflow: hidden;
		}
		.div {
			display: none;
		}
	</style>
</head>

<body>
	<div class="bkqs-main">
		<!-- 方便分享自动抓取 -->
		<div style="display: none;"><img src="${path}/STATIC/wxStatic/image/bkqs/shareIcon.png"/></div>
		<!--readyGo-->
		<div class="bkqs-main-ready">
			<img class="ready-button" src="${path}/STATIC/wxStatic/image/bkqs/ready-button.png" />
		</div>
		<!--题目-->
		<div class="bkqs-main-question">
			<div class="bkqs-main-question-title">
				<p class="question-num" id="topicName"></p>
				<div class="question1"><p id="questionTitle"></p></div>
			</div>
			<!--计时器-->
			<div class="answer-time"></div>
			<div class="answer-clock">
				<img src="${path}/STATIC/wxStatic/image/bkqs/clock.png" />
			</div>

			<!--题目图片-->
			<div id="answerList"></div>

			<div class="question-button">
				<div class="question-wrong">
					<img src="${path}/STATIC/wxStatic/image/bkqs/wrong.png" />
				</div>
				<div class="question-right">
					<img src="${path}/STATIC/wxStatic/image/bkqs/right.png" />
				</div>
				<div style="clear: both;"></div>
			</div>
		</div>
		<!--帮助-->
		<div class="bkqs-help">
			<div class="help-1">
				<div class="zindex1" style="text-align: center;"></div>
				<img src="${path}/STATIC/wxStatic/image/bkqs/help1.png" style="height: 100%;width: 100%;z-index: 1;" />
			</div>
			<div class="help-2">
				<div class="zindex2"></div>
				<img src="${path}/STATIC/wxStatic/image/bkqs/help2.png" style="height: 100%;width: 100%;z-index: 1;" />
			</div>
			<div class="help-3">
				<div class="zindex3"></div>
				<img src="${path}/STATIC/wxStatic/image/bkqs/help3.png" style="height: 100%;width: 100%;z-index: 1;" />
				<div class="help-button">
					<img src="${path}/STATIC/wxStatic/image/bkqs/know.png" />
				</div>
			</div>
		</div>
		<!--回答结果-->
		<div class="answer-right">
			<div class="answer-title">
				<p class="answer-title1">第&nbsp;<span style="color:#ffe27d;font-size: 64px;" id="questionNumber"></span>&nbsp;关</p>
				<p class="answer-title2"></p>
			</div>
			<div class="answer-key">
				<p class="answer-key1">正确答案:</p>
			</div>
			<div class="answer-button">
				<div class="button-div1" onclick="toNextPage(1)">
					<img src="${path}/STATIC/wxStatic/image/bkqs/again.png" />
				</div>
				<div class="button-div1" onclick="toNextPage(2)">
					<img src="${path}/STATIC/wxStatic/image/bkqs/change.png" />
				</div>
				<div class="button-div1" onclick="toNextPage(3)">
					<img src="${path}/STATIC/wxStatic/image/bkqs/next.png" />
				</div>
				<div style="clear: both;"></div>
			</div>
		</div>
	</div>
</body>
</html>
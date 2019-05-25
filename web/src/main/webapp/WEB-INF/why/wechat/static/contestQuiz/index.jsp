<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>安康文化云·${sessionScope.sessionTopic.topicName }</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-contestQuiz.css"/>
	<style>
    #model3 .game-gamepage {overflow: auto;}
    #model3 .fxgame-content {width: 638px;margin: 20px auto;height: auto;padding-bottom: 10px;background: #fff;border: 2px solid #000;
    	-webkit-border-radius: 10px;-moz-border-radius: 10px;-o-border-radius: 10px;border-radius: 10px;
    }
    </style>
	<script type="text/javascript" src="${path}/STATIC/wxStatic/js/swiper.animate1.0.2.min.js"></script>
	<script src="${path}/STATIC/js/common.js"></script>
		<script>
			var qNo = 0;
			var score = 0;
			var progressbar = 0; //题目进度条
			var questionData={content:[]};
			var topicId='${sessionScope.sessionTopic.topicId}'
			
			$.ajaxSettings.async = false; //同步执行ajax
			
			var title='${sessionScope.sessionTopic.shareTitle}';
			var describe='${sessionScope.sessionTopic.shareDescribe}';
			var imgUrl='${sessionScope.sessionTopic.shareLogoImg}?x-oss-process=image/resize,w_150,limit_0';
			
			var coverImgUrl='${sessionScope.sessionTopic.coverImgUrl}'
			var backgroundImgUrl='${sessionScope.sessionTopic.backgroundImgUrl}'
			
			var swiper ;
			
			//分享是否隐藏
	        if(window.injs){
	        	//分享文案
	        	appShareTitle = title;
	        	appShareDesc = describe;
	        	appShareImgUrl = imgUrl;
	        	
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
						title: title,
						desc: describe,
						link: '${basePath}wechatFunction/contestQuiz.do?topicId='+topicId,
						imgUrl: imgUrl
					});
					wx.onMenuShareTimeline({
						title: title,
						link: '${basePath}wechatFunction/contestQuiz.do?topicId='+topicId,
						imgUrl: imgUrl
					});
					wx.onMenuShareQQ({
						title: title,
						desc: describe,
						imgUrl: imgUrl
					});
					wx.onMenuShareWeibo({
						title: title,
						desc: describe,
						imgUrl: imgUrl
					});
					wx.onMenuShareQZone({
						title: title,
						desc: describe,
						imgUrl: imgUrl
					});
				});
			}
			
			$(document).ready(function() {
				
				$(".game-firstpage").css("background","url("+coverImgUrl+") no-repeat center center").css("background-size","100% 100%")
				$(".game-gamepage").css("background","url("+coverImgUrl+") no-repeat center center").css("background-size","100% 100%")
				$(".game-loading").css("background","url("+backgroundImgUrl+") no-repeat center center").css("background-size","100% 100%")
				
				var i = 0;
				var timer = setInterval(function() {
					if(i == 100) {
						$(".game-loading").fadeOut() //loading结束
						qNo++;
						clearInterval(timer)
						$(".game-firstpage").show();
					} else {
						
						$(".fxloading-runcl").css("width", "565px")
						$(".loading-num-n").html(i + "%")
						i += 1;
					}
				}, 20);
				
				loadQuestion();
			})

			//确定按钮
			function confirmBut() {
				quesBar()
				console.log(score)
				if($(".swiper-slide-active").hasClass("true")) { //答对
					score++;
					$(".q-true").show();
					loadQuestion();
					setTimeout(function() {
						if(qNo >= questionData.content.length) {
							$.post("${path}/wechatFunction/saveOrUpdateContestQuizAnswer.do", {
								userId: userId,
								userScore: score,
								answerType: topicId
							}, function(data) {
								if(data == 200) {
									window.location.href = '${path}/wechatFunction/contestQuizShare.do?userId='+userId+'&topicId='+topicId+'&userScore=' + score;
								} else {
									dialogAlert('系统提示', '系统繁忙，请稍后再试！');
								}
							}, "json");
						} else {
							$(".q-true").fadeOut(); 
							qNo++
						}
					}, 1500);
				} else { //答错
					$(".q-false").show();
					loadQuestion();
					setTimeout(function() {
						if(qNo >= questionData.content.length) {
							$.post("${path}/wechatFunction/saveOrUpdateContestQuizAnswer.do", {
								userId: userId,
								userScore: score,
								answerType: topicId
							}, function(data) { 
								if(data == 200) {
									window.location.href = '${path}/wechatFunction/contestQuizShare.do?userId='+userId+'&topicId='+topicId+'&userScore=' + score;
								} else {
									dialogAlert('系统提示', '系统繁忙，请稍后再试！');
								}
							}, "json");
						} else {
							$(".q-false").fadeOut(); 
							qNo++;
						}
					}, 1500);
				}
			}

			//加载题目
			function loadQuestion() {
				
				var answerCount=questionData.content.length;
				
				if(answerCount==0){
					
					$.post("${path}/wechatFunction/getTopicQuestionAnswerInfo.do",{topicId:topicId}, function (data) {
						if (data.status == 1) {
							var questionList = data.data;
							
							$.each(questionList, function (i, dom) {
								var question={};
								
								question.question=dom.questionTitle;
								
								var answerList=[];
								
								$.each(dom.answerList, function (a, answer) {
									
									var isTrue=answer.isTrue;
									var imgUrl = getIndexImgUrl(getImgUrl(answer.answerPicUrl),"_750_500");
									var answerText=answer.answerText;
								
									if(isTrue==1)
										question.answer=a+1;
									
									answerList.push({'answerText':answerText,'imgUrl':imgUrl})
									
								});
								
								question.answerList=answerList;
								
								questionData.content.push(question)
							});
						}
					}, "json");
				}
				
					if(qNo == questionData.content.length) {
						return;
					}
					
					$(".swiper-wrapper").html("");
					
					$.each(questionData.content[qNo].answerList, function (i, dom) {
						
						var div='<div class="swiper-slide">'+
						'<img class="qImg'+(i+1)+'" src="'+dom.imgUrl+'" width="450" height="480" />'+
						'</div>';
						
						if(swiper)
							swiper.prependSlide(div)
						else
							$(".swiper-wrapper").append(div);
					});

					//当前题号
					$("#gameNum").html(qNo + 1)

					$(".swiper-slide").find(".pic-check").addClass("pic-check-none");
					$(".swiper-slide").find(".pic-check").removeClass("chose");
					$(".swiper-slide").removeClass("true");
					
					var question=questionData.content[qNo].question;
					
					var fontSize=28;
					
					var x=65/question.length
					if(x<0.8){
						var y=(1-x)*6
						fontSize-=parseInt(y)
					}
					$("#question").css("font-size",fontSize+"px");

					$("#question").html(question);
					
					$(".qImg" + questionData.content[qNo].answer).parent().addClass("true");
 
					//if(qNo == 0) {
						
					//} else {
					//	$(".swiper-slide-active").find(".pic-check").removeClass("pic-check-none")
					//	$(".swiper-slide-active").find(".pic-check").addClass("chose")
						
					//}
			}

			//答题进度条
			function quesBar() {
				progressbar += 565/questionData.content.length;
				$(".fxgame-runcl").css("width", progressbar);
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
				})
				$(".background-fx").click(function() {
					$("html,body").removeClass("bg-notouch");
					$(".background-fx").css("display", "none")
				})
				//关注
				$(".keep-button").on("touchstart", function() {
					$('.div-share').show()
					$("body,html").addClass("bg-notouch")
				})
	            
				
				//题目提交按钮事件添加
				$(".game-ckb").on("click", function() {
					confirmBut()
				})

				//封面页上滑效果
				$(".btn_start").click(function() {
					
					if (userId == null || userId == '') {
						
						  publicLogin("${basePath}wechatFunction/contestQuiz.do?topicId="+topicId);
		            }
					else{
						
						$.post("${path}/wechatFunction/saveOrUpdateContestQuizAnswer.do", {userId: userId,answerType:topicId}, function (data) {
							
							$(".game-gamepage").css("background","url("+backgroundImgUrl+") no-repeat center center").css("background-size","100% 100%")
							$(".game-firstpage").animate({
								top: "50px",
							}, 500).animate({
								top: "-2000px",
							}, 300)
						});
						
						$(".game-gamepage").show();
						
						swiper= new Swiper('.swiper-container', {
							pagination: '.swiper-pagination',
							effect: 'coverflow',
							grabCursor: true,
							centeredSlides: true,
							slidesPerView: 'auto',
							loop: true,
							coverflow: {
								rotate: 10,
								stretch: 0,
								depth: 100,
								modifier: 1,
								slideShadows: true
							},
							onTransitionEnd: function(swiper) {
								var snapIndex = swiper.snapIndex;
								var $slide = $(".swiper-wrapper .swiper-slide:eq(" + snapIndex + ")");
								$(".swiper-slide").find(".pic-check").addClass("pic-check-none")
								$(".swiper-slide").find(".pic-check").removeClass("chose")
								$slide.find(".pic-check").removeClass("pic-check-none")
								$slide.find(".pic-check").addClass("chose")
							}
						});
					}
					
					
				})
			});

		</script>
		<style>
			html,
			body {
				width: 100%;
				height: 100%;
			}
			
			.swiper-container {
				margin: 10px auto 0px auto;
				width: 560px;
				height: 480px;
			}
			
			.swiper-slide {
				background-color: #ffe983;
				background-position: center;
				background-size: cover;
				width: 450px;
				height: 480px;
			}
			
			.swiper-slide-shadow-left,
			.swiper-slide-shadow-right {
				height: 480px!important;
			}
		</style>

	</head>

	<body id="${sessionScope.sessionTopicTemplate }"> 
		<div class="game-main" >
		
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
			<!--loading-->
			<div class="game-loading">
				<div class="loading">

					<div class="loading-runbg">

					</div>
					<div class="fxloading-runcl">

					</div>
					<div class="loading-num">
						<p>加载中...</p>
						<p class="loading-num-n">10%</p>
					</div>
				</div>
			</div>
			<!--封面-->
			<div class="game-firstpage" style="display: none;">
			
			<c:forEach items="${fn:split(sessionScope.sessionTopic.topicTitle,',')}" var="title" varStatus="sta" >
				<div class="gameFTitle${sta.index+1 }">${title}</div>
			</c:forEach>
					<c:choose>
						<c:when test="${!empty sessionScope.sessionTopic.indexLogo }">
							<img src="${ sessionScope.sessionTopic.indexLogo}?x-oss-process=image/resize,w_70,limit_0" style="position: absolute;top: 30px;left: 40px;" />
						</c:when>
						<c:when test="${!empty logo }">
							<img src="${logo}?x-oss-process=image/resize,w_70,limit_0" style="position: absolute;top: 30px;left: 40px;" />
						</c:when>
						<c:otherwise>
						<img src="${path}/STATIC/wxStatic/image/contestQuiz/logo.png" style="position: absolute;top: 30px;left: 40px;" />
						</c:otherwise>
						</c:choose>
				<img class="" src="${path}/STATIC/wxStatic/image/contestQuiz/index.png" style="position: absolute;top: 30px;right: 260px;" onclick="toWhyIndex();"/>
				<img class="keep-button" src="${path}/STATIC/wxStatic/image/contestQuiz/keep.png" style="position: absolute;top: 30px;right: 40px;" />
				<img class="share-button" src="${path}/STATIC/wxStatic/image/contestQuiz/share.png" style="position: absolute;top: 30px;right: 150px;" />
				<div class="btn_start" >
				</div>
			</div>

			<!--活动页-->
			<div class="game-gamepage"  style="display: none;">
				<div class="game-top">
				
					<c:choose>
						<c:when test="${!empty sessionScope.sessionTopic.indexLogo }">
							<img src="${ sessionScope.sessionTopic.indexLogo}?x-oss-process=image/resize,w_70,limit_0" style="position: absolute;top: 30px;left: 40px;" />
						</c:when>
						<c:otherwise>
						<img src="${path}/STATIC/wxStatic/image/contestQuiz/logo.png" style="position: absolute;top: 30px;left: 40px;" />
						</c:otherwise>
					</c:choose>
					<img class="" src="${path}/STATIC/wxStatic/image/contestQuiz/index.png" style="position: absolute;top: 30px;right: 260px;" onclick="toWhyIndex();"/>
					<img class="keep-button" src="${path}/STATIC/wxStatic/image/contestQuiz/keep.png" style="position: absolute;top: 30px;right: 40px;" />
					<img class="keep-button" src="${path}/STATIC/wxStatic/image/contestQuiz/keep.png" style="position: absolute;top: 30px;right: 40px;" />
					<img class="share-button" src="${path}/STATIC/wxStatic/image/contestQuiz/share.png" style="position: absolute;top: 30px;right: 150px;" />
				</div> 
				<div class="game-num">
					<div class="gameNumTitle">第<span id="gameNum"></span>题 </div>
					<div class="fxgame-runbg">

					</div>
					<div class="fxgame-runcl">

					</div>
				</div>

				<!--游戏问题-->
				<div class="fxgame-content">
					<p class="fxGameTitle" id="question"></p>
					<div class="swiper-container" id="swiper-container3">
						<div class="swiper-wrapper">
							<!-- <div class="swiper-slide">
								<img class="qImg1" src="" width="450" height="480" />
							</div>
							<div class="swiper-slide">
								<img class="qImg2" src="" width="450" height="480" />
							</div>
							<div class="swiper-slide">
								<img class="qImg3" src="" width="450" height="480" />
							</div>
							<div class="swiper-slide">
								<img class="qImg4" src="" width="450" height="480" />
							</div> -->
						</div>
					</div>
					<div class="game-ckb"></div>
				</div>

				<!--正确-->
				<div class="q-true">
					<div>${sessionScope.sessionTopic.answerRightText}</div>
				</div>

				<!--错误-->
				<div class="q-false">
					<div>${sessionScope.sessionTopic.answerWrongText}</div>
				</div>
			</div>
		</div>
		<script>
			$(document).ready(function() {

			})
		</script>

	</body>

</html>
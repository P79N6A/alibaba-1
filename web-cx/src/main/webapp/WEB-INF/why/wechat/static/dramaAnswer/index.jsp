<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>佛山文化云·上海当代戏剧节问答</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<script type="text/javascript" src="${path}/STATIC/wxStatic/js/swiper.animate1.0.2.min.js"></script>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		var qNo = 0;
		var score = 0;
		$.ajaxSettings.async = false; 	//同步执行ajax
		
		//分享是否隐藏
        if(window.injs){
        	//分享文案
        	appShareTitle = '文化云&上海当代戏剧节 | 测测你的人生有几分入戏？';
        	appShareDesc = '测试你的入戏分值，决定如何度过2016年上海当代戏剧节。';
        	appShareImgUrl = '${basePath}/STATIC/wxStatic/image/dramaAnswer/shareIcon.png';
        	
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
					title: "文化云&上海当代戏剧节 | 测测你的人生有几分入戏？",
					desc: '测试你的入戏分值，决定如何度过2016年上海当代戏剧节。',
					link: '${basePath}wechatStatic/dramaAnswer.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/dramaAnswer/shareIcon.png'
				});
				wx.onMenuShareTimeline({
					title: "文化云&上海当代戏剧节 | 测测你的人生有几分入戏？",
					imgUrl: '${basePath}/STATIC/wxStatic/image/dramaAnswer/shareIcon.png',
					link: '${basePath}wechatStatic/dramaAnswer.do'
				});
				wx.onMenuShareQQ({
					title: "文化云&上海当代戏剧节 | 测测你的人生有几分入戏？",
					desc: '测试你的入戏分值，决定如何度过2016年上海当代戏剧节。',
					imgUrl: '${basePath}/STATIC/wxStatic/image/dramaAnswer/shareIcon.png'
				});
				wx.onMenuShareWeibo({
					title: "文化云&上海当代戏剧节 | 测测你的人生有几分入戏？",
					desc: '测试你的入戏分值，决定如何度过2016年上海当代戏剧节。',
					imgUrl: '${basePath}/STATIC/wxStatic/image/dramaAnswer/shareIcon.png'
				});
				wx.onMenuShareQZone({
					title: "文化云&上海当代戏剧节 | 测测你的人生有几分入戏？",
					desc: '测试你的入戏分值，决定如何度过2016年上海当代戏剧节。',
					imgUrl: '${basePath}/STATIC/wxStatic/image/dramaAnswer/shareIcon.png'
				});
			});
		}
		
		$(function () {
			loadQuestion(); //加载题目
			qNo++;
			
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
            
		});
		
		//加载题目
		function loadQuestion(){
			$.getJSON("${path}/STATIC/wxStatic/js/dramaAnswerContent.json", function (data) {
				if(qNo==15){
					return;
				}
				
				$("#quesNum").html(qNo + 1);
				
				//清空已选的答案
				$(".qImg1").attr("src","");
				$(".qImg2").attr("src","");
				$(".swiper-slide").find(".pic-check").addClass("pic-check-none");
				$(".swiper-slide").find(".pic-check").removeClass("chose");
				$(".swiper-slide").removeClass("true");
				
				$("#question").html(data.content[qNo].question);
				$(".qImg1").attr("src","${path}/STATIC/wxStatic/image/dramaAnswer/ques/"+qNo+"-1.jpg");
				$(".qImg2").attr("src","${path}/STATIC/wxStatic/image/dramaAnswer/ques/"+qNo+"-2.jpg");
				$(".qImg"+data.content[qNo].answer).parent().addClass("true");
				
				if(qNo==0){
					var swiper = new Swiper('.swiper-container', {
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
				}else{
					$(".swiper-slide-active").find(".pic-check").removeClass("pic-check-none")
					$(".swiper-slide-active").find(".pic-check").addClass("chose")
				}
	        });
		}
		
		//开始按钮
		function startBut(){
			if (userId == null || userId == '') {
				//判断登陆
	        	publicLogin("${basePath}wechatStatic/dramaAnswer.do");
            }else{
            	$.post("${path}/wechatStatic/saveOrUpdateDramaAnswer.do", {userId: userId,answerType:2}, function (data) {
                    if (data == 200) {
                    	$(".game-firstpage").animate({
    						top: "50px",
    					}, 500).animate({
    						top: "-2000px",
    					}, 300)
                    }else{
                    	dialogAlert('系统提示', '系统繁忙，请稍后再试！');
                    }
                }, "json");
            }
		}
		
		//确定按钮
		function confirmBut(){
			if ($(".swiper-slide-active").hasClass("true")) {	//答对
				score++;
				$(".q-true").show();
				loadQuestion();
				setTimeout(function () {
					if(qNo>=15){
						$.post("${path}/wechatStatic/saveOrUpdateDramaAnswer.do", {userId: userId,userScore: score,answerType: 2}, function (data) {
		                    if (data == 200) {
		                    	window.location.href = '${path}/wechatStatic/dramaAnswerInfo.do?userId=' + userId + '&answerType=2';
		                    }else{
		                    	dialogAlert('系统提示', '系统繁忙，请稍后再试！');
		                    }
		                }, "json");
					}else{
						$(".q-true").fadeOut();
						qNo++;
					}
           		},1500);
			}else{	//答错
				$(".q-false").show();
				loadQuestion();
				setTimeout(function () { 
					if(qNo>=15){
						$.post("${path}/wechatStatic/saveOrUpdateDramaAnswer.do", {userId: userId,userScore: score,answerType: 2}, function (data) {
		                    if (data == 200) {
		                    	window.location.href = '${path}/wechatStatic/dramaAnswerInfo.do?userId=' + userId + '&answerType=2';
		                    }else{
		                    	dialogAlert('系统提示', '系统繁忙，请稍后再试！');
		                    }
		                }, "json");
					}else{
						$(".q-false").fadeOut();
						qNo++;
					}
           		},1500);
			}
		}
		
	</script>
	
	<style>
		html,body {
			width: 100%;
			height: 100%;
		}
		
		.swiper-container {
			margin: 10px auto 0px auto;
			width: 560px;
			height: 500px;
		}
		
		.swiper-slide {
			background-position: center;
			background-size: cover;
			width: 450px;
			height: 500px;
		}
		
		.swiper-slide-shadow-left,
		.swiper-slide-shadow-right {
			height: 480px!important;
		}
	</style>
</head>

<body>
	<div class="game-main">
		<!-- 方便分享自动抓取 -->
		<div style="display: none;"><img src="${path}/STATIC/wxStatic/image/dramaAnswer/shareIcon.png"/></div>
		<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
			<img src="${path}/STATIC/wxStatic/image/movie/shareBg.png" style="width: 100%;height: 100%;" />
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
		
		<!--封面-->
		<div class="game-firstpage">
			<img src="${path}/STATIC/wxStatic/image/dramaAnswer/corverimg.jpg" width="100%" height="100%" />
			<img class="keep-button" src="${path}/STATIC/wxStatic/image/dramaAnswer/keep.png" style="position: absolute;top: 30px;right: 40px;" />
			<img class="share-button" src="${path}/STATIC/wxStatic/image/dramaAnswer/share.png" style="position: absolute;top: 30px;right: 150px;" />
			<img class="btn_start" onclick="startBut();" src="${path}/STATIC/wxStatic/image/dramaAnswer/startbtn.png" style="position: absolute;bottom: 50px;left: 0px;right: 0;margin: auto;" />
		</div>

		<!--活动页-->
		<div class="game-gamepage">
			<img src="${path}/STATIC/wxStatic/image/dramaAnswer/questionbg.jpg" width="100%" height="100%" style="z-index: 0;position: absolute;top: 0px;left: 0px;" />
			<div class="game-top">
				<img src="${path}/STATIC/wxStatic/image/dramaAnswer/keep.png" style="position: absolute;top: 30px;right: 40px;" />
				<img src="${path}/STATIC/wxStatic/image/dramaAnswer/share.png" style="position: absolute;top: 30px;right: 150px;" />
			</div>
			<div style="background: url(${path}/STATIC/wxStatic/image/dramaAnswer/qNo.png) no-repeat center center;height: 103px;width: 750px;margin: 150px auto 0;position: relative;">
				<div style="margin: auto;font-size: 62px;text-align: center;color: #877a66;">第<span id="quesNum"></span>题</div>
			</div>

			<!--游戏问题-->
			<div class="fxgame-content" style="background: url(${path}/STATIC/wxStatic/image/dramaAnswer/qesbg.png) no-repeat center 20px;background-size: 580px 800px;">
				<p class="fs28 fxGameTitle" id="question" style="width: 550px;max-height: 111px;min-height: 50px;"></p>
				<div class="swiper-container" id="swiper-container3">
					<div class="swiper-wrapper">
						<div class="swiper-slide">
							<img class="qImg1" src="" width="450" height="480" />
						</div>
						<div class="swiper-slide">
							<img class="qImg2" src="" width="450" height="480" />
						</div>
					</div>
				</div>
				<div class="game-ckb" onclick="confirmBut();">
					<img src="${path}/STATIC/wxStatic/image/dramaAnswer/submit.png" />
				</div>
			</div>

			<!--正确-->
			<div class="q-true">
				<img src="${path}/STATIC/wxStatic/image/dramaAnswer/right.png" width="100%" height="100%" />
			</div>

			<!--错误-->
			<div class="q-false">
				<img src="${path}/STATIC/wxStatic/image/dramaAnswer/wrong.png" width="100%" height="100%" />
			</div>
		</div>
	</div>
</body>
</html>
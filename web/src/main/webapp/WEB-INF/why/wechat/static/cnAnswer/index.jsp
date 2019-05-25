<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>安康文化云·歌剧小知识问答</title>
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
        	appShareTitle = '文化云｜经典歌剧常识挑战赛，开启你的歌剧之门...';
        	appShareDesc = '你的朋友圈里谁最文艺？一套题目告诉你答案！';
        	appShareImgUrl = '${basePath}/STATIC/wxStatic/image/cnAnswer/shareIcon.png';
        	
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
					title: "文化云｜经典歌剧常识挑战赛，开启你的歌剧之门...",
					desc: '你的朋友圈里谁最文艺？一套题目告诉你答案！',
					link: '${basePath}wechatStatic/cnAnswer.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/cnAnswer/shareIcon.png'
				});
				wx.onMenuShareTimeline({
					title: "文化云｜经典歌剧常识挑战赛，开启你的歌剧之门...",
					imgUrl: '${basePath}/STATIC/wxStatic/image/cnAnswer/shareIcon.png',
					link: '${basePath}wechatStatic/cnAnswer.do'
				});
				wx.onMenuShareQQ({
					title: "文化云｜经典歌剧常识挑战赛，开启你的歌剧之门...",
					desc: '你的朋友圈里谁最文艺？一套题目告诉你答案！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/cnAnswer/shareIcon.png'
				});
				wx.onMenuShareWeibo({
					title: "文化云｜经典歌剧常识挑战赛，开启你的歌剧之门...",
					desc: '你的朋友圈里谁最文艺？一套题目告诉你答案！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/cnAnswer/shareIcon.png'
				});
				wx.onMenuShareQZone({
					title: "文化云｜经典歌剧常识挑战赛，开启你的歌剧之门...",
					desc: '你的朋友圈里谁最文艺？一套题目告诉你答案！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/cnAnswer/shareIcon.png'
				});
			});
		}
		
		$(function () {
			//loading加载
			var i = 0;
			$(".loading-runcl").css("width", "565px")
			$(".loading-img").css("left", "500px")
			var timer = setInterval(function() {
				if (i == 100) {
					$(".game-loading").fadeOut()	//loading结束
					$(".game-firstpage").show();	//显示首页
					$(".game-gamepage").show();		//显示问答
					loadQuestion();		//加载题目
					loadResult();		//加载答案提示文案
					setTimeout(function(){
						$(".third-out").animate({
							top:"600px",
						},300)
					},500)
					clearInterval(timer)
				} else {
					$(".loading-num-n").html(i + "%")
					i += 1;
				}
			}, 20);
			
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
			$.getJSON("${path}/STATIC/wxStatic/js/cnAnswerContent.json", function (data) {
				if(qNo==15){
					return;
				}
				
				//清空已选的答案
				$(".qImg1").attr("src","");
				$(".qImg2").attr("src","");
				$(".qImg3").attr("src","");
				$(".qImg4").attr("src","");
				$(".swiper-slide").find(".pic-check").addClass("pic-check-none");
				$(".swiper-slide").find(".pic-check").removeClass("chose");
				$(".swiper-slide").removeClass("true");
				
				$("#question").html(data.content[qNo].question);
				$(".qImg1").attr("src","${path}/STATIC/wxStatic/image/cnAnswer/operaQues/"+qNo+"-1.jpg");
				$(".qImg2").attr("src","${path}/STATIC/wxStatic/image/cnAnswer/operaQues/"+qNo+"-2.jpg");
				$(".qImg3").attr("src","${path}/STATIC/wxStatic/image/cnAnswer/operaQues/"+qNo+"-3.jpg");
				$(".qImg4").attr("src","${path}/STATIC/wxStatic/image/cnAnswer/operaQues/"+qNo+"-4.jpg");
				$(".qImg"+data.content[qNo].answer).parent().addClass("true");
				
				if(qNo==0){
					var swiper = new Swiper('.swiper-container', {
						pagination: '.swiper-pagination',
						effect: 'coverflow',
						grabCursor: true,
						centeredSlides: true,
						slidesPerView: 'auto',
						loop: true,
						coverflow: { rotate: 10, stretch: 0, depth: 100, modifier: 1, slideShadows: true
						},
						onTransitionEnd: function(swiper) {
							var snapIndex = swiper.snapIndex;
							var $slide = $(".swiper-wrapper .swiper-slide:eq("+snapIndex+")");
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
		
		//加载答案提示文案
		function loadResult(){
			$.getJSON("${path}/STATIC/wxStatic/js/cnAnswerContent.json", function (data) {
				$(".trueAnswerText").html("<span style='font-size:30px;color:#D8B122;'>提示</span>："+data.content[qNo].trueText+"");
				qNo++;
			});
		}
		
		//开始按钮
		function startBut(){
			if (userId == null || userId == '') {
				//判断登陆
	        	publicLogin("${basePath}wechatStatic/cnAnswer.do");
            }else{
            	$.post("${path}/wechatStatic/saveOrUpdateCnAnswer.do", {userId: userId}, function (data) {
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
			if ($(".chose").parent(".swiper-slide").hasClass("true")) {	//答对
				score++;
				$(".q-true").show();
				loadQuestion();
				setTimeout(function () {
					if(qNo>=15){
						$.post("${path}/wechatStatic/saveOrUpdateCnAnswer.do", {userId: userId,userScore: score}, function (data) {
		                    if (data == 200) {
		                    	window.location.href = '${path}/wechatStatic/cnAnswerShare.do?userScore='+score+'&userId='+userId;
		                    }else{
		                    	dialogAlert('系统提示', '系统繁忙，请稍后再试！');
		                    }
		                }, "json");
					}else{
						$(".q-true").fadeOut();
						peopleRun(15);
						setTimeout(function () { 
							loadResult();
						},1000);
					}
           		},1500);
			}else{	//答错
				$(".q-false").show();
				loadQuestion();
				setTimeout(function () { 
					if(qNo>=15){
						$.post("${path}/wechatStatic/saveOrUpdateCnAnswer.do", {userId: userId,userScore: score}, function (data) {
		                    if (data == 200) {
		                    	window.location.href = '${path}/wechatStatic/cnAnswerShare.do?userScore='+score+'&userId='+userId;
		                    }else{
		                    	dialogAlert('系统提示', '系统繁忙，请稍后再试！');
		                    }
		                }, "json");
					}else{
						$(".q-false").fadeOut();
						peopleRun(15);
						setTimeout(function () { 
							loadResult();
						},1000);
					}
           		},4000);
			}
		}
		
		//答题进度动画
		var run_src = "${path}/STATIC/wxStatic/image/movie/people.gif";
		var stand_src = "${path}/STATIC/wxStatic/image/movie/peoplezl.gif";
		var people_run = -50;
		var people_run_bg = 0;
		function peopleRun(all) {
			people_run = people_run + 565 / all;
			people_run_bg = people_run_bg + 565 / all
			$(".game-people").find("img").attr("src", run_src);
			setTimeout(function() {
				$(".game-people").css("left", people_run)
				$(".game-runcl").css("width", people_run_bg)
			}, 300)
			setTimeout(function() {
				$(".game-people").find("img").attr("src", stand_src);
			}, 2000)
		}

		
	</script>
	
	<style>
		html,body {width: 100%;height: 100%;}
		.swiper-container {
			margin: 40px auto 0px auto;
			width: 560px;
			height: 480px;
		}
		.swiper-slide {
			background-position: center;
			background-size: cover;
			width: 450px;
			height: 480px;
		}
		.errormsg{
			display: -webkit-box;
			display: -ms-flexbox;
			display: -webkit-flex;
			display: flex;
			-webkit-box-pack: center;
			-ms-flex-pack: center;
			-webkit-justify-content: center;
			justify-content: center;
			-webkit-box-align: center;
			-ms-flex-align: center;
			-webkit-align-items: center;
			align-items: center;
			width:540px;
			height:200px;
			position:absolute;
			left:0;right:0;bottom:65px;
			margin:auto;
		}
	</style>
</head>

<body>
	<div class="game-main">
		<!-- 方便分享自动抓取 -->
		<div style="display: none;"><img src="${path}/STATIC/wxStatic/image/cnAnswer/shareIcon.png"/></div>
		<div class="game-loading">
			<img src="${path}/STATIC/wxStatic/image/movie/bg.jpg" width="100%" height="100%" style="z-index: 0;position: absolute;top: 0px;left: 0px;" />
			<div class="loading">
				<img class="loading-img" src="${path}/STATIC/wxStatic/image/movie/people2.gif" />
				<div class="loading-runbg"></div>
				<div class="loading-runcl"></div>
				<div class="loading-num fs36">
					<p>加载中...</p>
					<p class="loading-num-n">10%</p>
				</div>
			</div>
		</div>
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
		<div class="game-firstpage" style="display: none;">
			<img src="${path}/STATIC/wxStatic/image/cnAnswer/indexbg.jpg" width="100%" height="100%" />
			<img class="keep-button" src="${path}/STATIC/wxStatic/image/movie/keep.png" style="position: absolute;top: 30px;right: 40px;" />
			<img class="share-button" src="${path}/STATIC/wxStatic/image/movie/share.png" style="position: absolute;top: 30px;right: 150px;" />
			<img class="third-out" src="${path}/STATIC/wxStatic/image/movie/sleep.gif" style="position: absolute;top: -130px;right: 50px;z-index: 2;"/>
			<img class="btn_start" src="${path}/STATIC/wxStatic/image/movie/btn_start.png" style="position: absolute;bottom: 80px;left: 170px;" onclick="startBut();"/>
		</div>

		<!--活动页-->
		<div class="game-gamepage" style="display: none;">
			<img src="${path}/STATIC/wxStatic/image/movie/bg.jpg" width="100%" height="100%" style="z-index: 0;position: absolute;top: 0px;left: 0px;" />
			<div class="game-top">
				<img src="${path}/STATIC/wxStatic/image/movie/logo.png" style="position: absolute;top: 30px;left: 60px;" />
				<img class="keep-button" src="${path}/STATIC/wxStatic/image/movie/keep.png" style="position: absolute;top: 30px;right: 40px;" />
				<img class="share-button" src="${path}/STATIC/wxStatic/image/movie/share.png" style="position: absolute;top: 30px;right: 150px;" />
			</div>
			<div class="game-num">
				<div class="game-people">
					<img src="${path}/STATIC/wxStatic/image/movie/peoplezl.gif" />
				</div>
				<div class="game-runbg"></div>
				<div class="game-runcl"></div>
			</div>

			<!--游戏问题-->
			<div class="game-content">
				<p class="fs28" id="question"></p>
				<div class="swiper-container" id="swiper-container3">
					<div class="swiper-wrapper">
						<!-- 需求修改，不显示选中标记 -->
						<div class="swiper-slide">
							<img class="qImg1" src=""/>
							<img class="pic-check pic-check-none" src="${path}/STATIC/wxStatic/image/movie/chose.png" style="display: none;"/>
						</div>
						<div class="swiper-slide">
							<img class="qImg2" src=""/>
							<img class="pic-check pic-check-none" src="${path}/STATIC/wxStatic/image/movie/chose.png" style="display: none;"/>
						</div>
						<div class="swiper-slide">
							<img class="qImg3" src=""/>
							<img class="pic-check pic-check-none" src="${path}/STATIC/wxStatic/image/movie/chose.png" style="display: none;"/>
						</div>
						<div class="swiper-slide true">
							<img class="qImg4" src=""/>
							<img class="pic-check pic-check-none" src="${path}/STATIC/wxStatic/image/movie/chose.png" style="display: none;"/>
						</div>
					</div>
				</div>
				<div class="game-ckb" onclick="confirmBut();">
					<img src="${path}/STATIC/wxStatic/image/movie/btn_ok.png" />
				</div>
			</div>

			<!--正确-->
			<div class="q-true">
				<div class="q-middle1" style="background: url(${path}/STATIC/wxStatic/image/cnAnswer/right.png) no-repeat center center"></div>
			</div>

			<!--错误-->
			<div class="q-false">
				<div class="q-middle2" style="background: url(${path}/STATIC/wxStatic/image/cnAnswer/wrong.png) no-repeat center center">
					<div class="errormsg">
						<div class="trueAnswerText" style="text-align:center;font-size:28px;color:#333;padding:0 10%"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
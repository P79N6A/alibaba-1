<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%
    String path = request.getContextPath();
    request.setAttribute("path", path);
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
    request.setAttribute("basePath", basePath);
    String error = request.getParameter("error");
    request.setAttribute("error", error);
%>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"/>
	<meta name="format-detection" content="telephone=no"/>
	<meta name="apple-mobile-web-app-capable" content="yes"/>
	<meta name="apple-mobile-web-app-status-bar-style" content="black"/>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/normalize.css"/>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/ui-dialog.css"/>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/swiper-3.3.1.min.css"/>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/animate.min.css"/>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<script type="text/javascript" src="${path}/STATIC/wxStatic/js/jquery-2.1.4.min.js"></script>
	<script type="text/javascript" src="${path}/STATIC/wechat/js/dialog-min.js"></script>
	<script type="text/javascript" src="${path}/STATIC/wxStatic/js/swiper-3.3.1.jquery.min.js"></script>
	<script type="text/javascript" src="${path}/STATIC/wxStatic/js/swiper.animate1.0.2.min.js"></script>
	<script type="text/javascript" src="${path}/STATIC/wechat/js/wechat-util.js"></script>
	<script type="text/javascript" src="${path}/STATIC/wechat/js/jweixin-1.0.0.js"></script>
	<script src="${path}/STATIC/js/common.js"></script>
	<title>“电影节”你猜我答</title>
	
	<script type="text/javascript">
		var phoneWidth = parseInt(window.screen.width);
		var phoneScale = phoneWidth / 750;
		var ua = navigator.userAgent; //浏览器类型
		if (/Android (\d+\.\d+)/.test(ua)) { //判断是否是安卓系统
			var version = parseFloat(RegExp.$1); //安卓系统的版本号
			if (version > 2.3) {
				document.write('<meta name="viewport" content="width=750,user-scalable=no, minimum-scale = ' + phoneScale + ', maximum-scale = ' + (phoneScale) + ', target-densitydpi=device-dpi">');
			} else {
				document.write('<meta name="viewport" content="width=750,user-scalable=no, target-densitydpi=device-dpi">');
			}
		} else {
			document.write('<meta name="viewport" content="width=750,user-scalable=no, target-densitydpi=device-dpi">');
		}
	</script>
	
	<script>
		var userId = '${sessionScope.terminalUser.userId}';
		var error = '${error}';
		var qNo = 0;
		var score = 0;
		$.ajaxSettings.async = false; 	//同步执行ajax
		
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
					title: "单挑上海国际电影节，这些电影你认识几部？",
					desc: '朋友圈里谁最文艺立竿见影！',
					link: '${basePath}/wxUser/silentInvoke.do?type=${path}/wechatStatic/movieAnswer.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/movie/shareIcon.png'
				});
				wx.onMenuShareTimeline({
					title: "单挑上海国际电影节，这些电影你认识几部？",
					imgUrl: '${basePath}/STATIC/wxStatic/image/movie/shareIcon.png',
					link: '${basePath}/wxUser/silentInvoke.do?type=${path}/wechatStatic/movieAnswer.do'
				});
				wx.onMenuShareQQ({
					title: "单挑上海国际电影节，这些电影你认识几部？",
					desc: '朋友圈里谁最文艺立竿见影！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/movie/shareIcon.png'
				});
				wx.onMenuShareWeibo({
					title: "单挑上海国际电影节，这些电影你认识几部？",
					desc: '朋友圈里谁最文艺立竿见影！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/movie/shareIcon.png'
				});
				wx.onMenuShareQZone({
					title: "单挑上海国际电影节，这些电影你认识几部？",
					desc: '朋友圈里谁最文艺立竿见影！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/movie/shareIcon.png'
				});
			});
		}
		
		$(function () {
			if(error=="loginFail"){
				dialogAlert('登录失败', '请重试或通过其他方式登录！');
			}
			
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
					loadResult();		//加载对错文案
					setTimeout(function(){
						$(".first-out").fadeIn()
					},400)
					setTimeout(function(){
						$(".secend-out").fadeIn()
					},1000)
					setTimeout(function(){
						$(".third-out").animate({
							top:"591px",
						},300)
					},2000)
					clearInterval(timer)
				} else {
					$(".loading-num-n").html(i + "%")
					i += 1;
				}
			}, 20);
			
			//文字上下浮动
			var arrow = 0;
			setInterval(function() {
				if (arrow == 0) {
					$(".cai1").css("top", "650px");
					$(".cai2").css("top", "650px");
					arrow = 1
				} else {
					$(".cai1").css("top", "640px");
					$(".cai2").css("top", "640px");
					arrow = 0
				}
			}, 500);
			
          	//分享
			$(".share-button").click(function() {
				if (!is_weixin()) {
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
			$.getJSON("${path}/STATIC/wxStatic/js/answerContent.json", function (data) {
				if(qNo==10){
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
				$(".qImg1").attr("src","${path}/STATIC/wxStatic/image/movie/movieImg/"+qNo+"1.png");
				$(".qImg2").attr("src","${path}/STATIC/wxStatic/image/movie/movieImg/"+qNo+"2.png");
				$(".qImg3").attr("src","${path}/STATIC/wxStatic/image/movie/movieImg/"+qNo+"3.png");
				$(".qImg4").attr("src","${path}/STATIC/wxStatic/image/movie/movieImg/"+qNo+"4.png");
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
		
		//加载对错文案
		function loadResult(){
			$.getJSON("${path}/STATIC/wxStatic/js/answerContent.json", function (data) {
				$("#successText").html(data.content[qNo].successText);
				$("#falseText").html(data.content[qNo].falseText);
				qNo++;
			});
		}
		
		//开始按钮
		function startBut(){
			if (userId == null || userId == '') {
				if (is_weixin()) {
	        		window.location.href = '${path}/wxUser/silentInvoke.do?type=${path}/wechatStatic/movieAnswer.do';
	        	}else{
	        		window.location.href = '${path}/muser/login.do?type=${path}/wechatStatic/movieAnswer.do';
	        	}
				return;
            }else{
            	$.post("${path}/wechatStatic/saveOrUpdateMovieAnswer.do", {userId: userId}, function (data) {
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
					if(qNo>=10){
						$.post("${path}/wechatStatic/saveOrUpdateMovieAnswer.do", {userId: userId,userScore: score}, function (data) {
		                    if (data == 200) {
		                    	window.location.href = '${path}/wechatStatic/movieShare.do?userScore='+score;
		                    }else{
		                    	dialogAlert('系统提示', '系统繁忙，请稍后再试！');
		                    }
		                }, "json");
					}else{
						$(".q-true").fadeOut();
						peopleRun(10);
						setTimeout(function () { 
							loadResult();
						},1000);
					}
           		},1500);
			}else{	//答错
				$(".q-false").show();
				loadQuestion();
				setTimeout(function () { 
					if(qNo>=10){
						$.post("${path}/wechatStatic/saveOrUpdateMovieAnswer.do", {userId: userId,userScore: score}, function (data) {
		                    if (data == 200) {
		                    	window.location.href = '${path}/wechatStatic/movieShare.do?userScore='+score;
		                    }else{
		                    	dialogAlert('系统提示', '系统繁忙，请稍后再试！');
		                    }
		                }, "json");
					}else{
						$(".q-false").fadeOut();
						peopleRun(10);
						setTimeout(function () { 
							loadResult();
						},1000);
					}
           		},1500);
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
	</style>
</head>

<body>
	<div class="game-main">
		<!-- 方便分享自动抓取 -->
		<div style="display: none;"><img src="${path}/STATIC/wxStatic/image/movie/shareIcon.png"/></div>
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
			<img src="${path}/STATIC/wxStatic/image/movie/fengmian_02.jpg" width="100%" height="100%" />
			<img src="${path}/STATIC/wxStatic/image/movie/logo.png" style="position: absolute;top: 30px;left: 60px;" />
			<img class="keep-button" src="${path}/STATIC/wxStatic/image/movie/keep.png" style="position: absolute;top: 30px;right: 40px;" />
			<img class="share-button" src="${path}/STATIC/wxStatic/image/movie/share.png" style="position: absolute;top: 30px;right: 150px;" />
			<img class="secend-out" src="${path}/STATIC/wxStatic/image/movie/pop.gif" style="position:absolute;top: 220px;left: 100px;width: 75%;" />
			<img class="first-out" src="${path}/STATIC/wxStatic/image/movie/yingmi.png" style="position:absolute;top: 640px;left: 15px;z-index: 1;" />
			<img class="third-out" src="${path}/STATIC/wxStatic/image/movie/sleep.gif" style="position: absolute;top: -130px;right: 50px;z-index: 2;"/>
			<img class="cai1 first-out" src="${path}/STATIC/wxStatic/image/movie/cai1.png" />
			<img class="cai2 first-out" src="${path}/STATIC/wxStatic/image/movie/cai2.png" />
			<img src="${path}/STATIC/wxStatic/image/movie/wordbg.png" style="position: absolute;top: 855px;left: 50px;z-index: 0;" />
			<p class="fs36 cfff w630 h100" style="position: absolute;top: 855px;left: 50px;z-index: 0;text-align: center;line-height: 100px;">上海电影节海报挑战赛</p>
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
				<div class="q-middle1">
					<img src="${path}/STATIC/wxStatic/image/movie/a-ture.png" />
					<div class="q-a">
						<p id="successText"></p>
					</div>
				</div>
			</div>

			<!--错误-->
			<div class="q-false">
				<div class="q-middle2">
					<img src="${path}/STATIC/wxStatic/image/movie/a-false.png" />
					<div class="q-a">
						<p id="falseText"></p>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 导入统计文件 -->
	<script type="text/javascript" src="${path}/stat/stat.js"></script>
	<%@include file="/WEB-INF/why/wechat/wechat_statistics.jsp"%>
</body>
</html>
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>佛山文化云·12小时艺术狂欢</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		//分享是否隐藏
        if(window.injs){
        	//分享文案
        	appShareTitle = '【测测看】有一场持续12小时的艺术狂欢就在本周日，你造吗？';
        	appShareDesc = '测测你的艺术细胞有多少？送你去艺术节最火热的狂欢现场~';
        	appShareImgUrl = '${basePath}/STATIC/wxStatic/image/artKH/shareIcon.jpg';
        	appShareLink = '${basePath}/wechatStatic/artAnswer.do';
        	
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
					title: "【测测看】有一场持续12小时的艺术狂欢就在本周日，你造吗？",
					desc: '测测你的艺术细胞有多少？送你去艺术节最火热的狂欢现场~',
					link: '${basePath}wechatStatic/artAnswer.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/artKH/shareIcon.jpg'
				});
				wx.onMenuShareTimeline({
					title: "【测测看】有一场持续12小时的艺术狂欢就在本周日，你造吗？",
					imgUrl: '${basePath}/STATIC/wxStatic/image/artKH/shareIcon.jpg',
					link: '${basePath}wechatStatic/artAnswer.do'
				});
				wx.onMenuShareQQ({
					title: "【测测看】有一场持续12小时的艺术狂欢就在本周日，你造吗？",
					desc: '测测你的艺术细胞有多少？送你去艺术节最火热的狂欢现场~',
					link: '${basePath}/wechatStatic/artAnswer.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/artKH/shareIcon.jpg'
				});
				wx.onMenuShareWeibo({
					title: "【测测看】有一场持续12小时的艺术狂欢就在本周日，你造吗？",
					desc: '测测你的艺术细胞有多少？送你去艺术节最火热的狂欢现场~',
					link: '${basePath}/wechatStatic/artAnswer.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/artKH/shareIcon.jpg'
				});
				wx.onMenuShareQZone({
					title: "【测测看】有一场持续12小时的艺术狂欢就在本周日，你造吗？",
					desc: '测测你的艺术细胞有多少？送你去艺术节最火热的狂欢现场~',
					link: '${basePath}/wechatStatic/artAnswer.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/artKH/shareIcon.jpg'
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
		
	</script>
	
	<style>
		html,body {width: 100%;height: 100%;}
		.swiper-container {
			margin: 50px auto 0px auto;
			width: 560px;
			height: 450px;
		}
		.swiper-slide {
			background-position: center;
			background-size: cover;
			width: 450px;
			height: 450px;
		}
	</style>
	
</head>

<body>
	<div class="game-main">
		<!-- 方便分享自动抓取 -->
		<div style="display: none;"><img src="${basePath}/STATIC/wxStatic/image/artKH/shareIcon.jpg"/></div>
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
		<div class="game-gamepage" style="background: url(${path}/STATIC/wxStatic/image/artKH/qubg.jpg) no-repeat center center;background-size: 100% 100%;">
			<div class="game-top">
				<img class="keep-button" src="${path}/STATIC/wxStatic/image/artKH/keep.png" style="position: absolute;top: 30px;right: 40px;" />
				<img class="share-button" src="${path}/STATIC/wxStatic/image/artKH/share.png" style="position: absolute;top: 30px;right: 150px;" />
			</div>
			<div class="fxComplateBtn-test" style="margin-top: 900px;">
				<div style="float: left;" class="fxComplateBtn" onclick="location.href='${path}/wechatStatic/artAnswer.do';">
					<img src="${path}/STATIC/wxStatic/image/artKH/replay.png" />
				</div>
				<div style="float: right;" class="fxComplateBtn" onclick="location.href='${path}/wechatStatic/artSky.do';">
					<img src="${path}/STATIC/wxStatic/image/artKH/getPoint.png"/>
				</div>
				<div style="clear: both;"></div>
			</div>
		</div>
	</div>
</body>
</html>
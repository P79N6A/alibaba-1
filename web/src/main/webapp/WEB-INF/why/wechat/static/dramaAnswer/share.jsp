<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>安康文化云·上海当代戏剧节问答</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		//分享是否隐藏
        if(window.injs){
        	//分享文案
        	appShareTitle = '文化云&上海当代戏剧节 | 测测你的人生有几分入戏？';
        	appShareDesc = '测试你的入戏分值，决定如何度过2016年上海当代戏剧节。';
        	appShareImgUrl = '${basePath}/STATIC/wxStatic/image/dramaAnswer/shareIcon.png';
        	appShareLink = '${basePath}/wechatStatic/dramaAnswer.do';
        	
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
					link: '${basePath}/wechatStatic/dramaAnswer.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/dramaAnswer/shareIcon.png'
				});
				wx.onMenuShareWeibo({
					title: "文化云&上海当代戏剧节 | 测测你的人生有几分入戏？",
					desc: '测试你的入戏分值，决定如何度过2016年上海当代戏剧节。',
					link: '${basePath}/wechatStatic/dramaAnswer.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/dramaAnswer/shareIcon.png'
				});
				wx.onMenuShareQZone({
					title: "文化云&上海当代戏剧节 | 测测你的人生有几分入戏？",
					desc: '测试你的入戏分值，决定如何度过2016年上海当代戏剧节。',
					link: '${basePath}/wechatStatic/dramaAnswer.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/dramaAnswer/shareIcon.png'
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
		html,body {
			width: 100%;
			height: 100%;
		}
		
		.dramaUserRank{
			margin: 400px auto 0;
		}
		
		.dramaUserRank>img{
			display: block;
			margin: auto;
		}
		.dramaSee{
			margin-top: 20px;
		}
	</style>
	
</head>

<body>
	<div class="game-main">
		<!-- 方便分享自动抓取 -->
		<div style="display: none;"><img src="${basePath}/STATIC/wxStatic/image/dramaAnswer/shareIcon.jpg"/></div>
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
		<div class="game-gamepage" style="background: url(${path}/STATIC/wxStatic/image/dramaAnswer/qubg.jpg) no-repeat center center;background-size: 100% 100%;">
			<div class="game-top">
				<img class="keep-button" src="${path}/STATIC/wxStatic/image/dramaAnswer/keep.png" style="position: absolute;top: 30px;right: 40px;" />
				<img class="share-button" src="${path}/STATIC/wxStatic/image/dramaAnswer/share.png" style="position: absolute;top: 30px;right: 150px;" />
			</div>
			<div class="dramaUserRank">
				<c:if test="${userScore == 0}">
					<img src="${path}/STATIC/wxStatic/image/dramaAnswer/0.png" />
				</c:if>
				<c:if test="${userScore >= 1 && userScore <=7}">
					<img src="${path}/STATIC/wxStatic/image/dramaAnswer/4.png" />
				</c:if>
				<c:if test="${userScore >= 8 && userScore <=14}">
					<img src="${path}/STATIC/wxStatic/image/dramaAnswer/8.png" />
				</c:if>
				<c:if test="${userScore == 15}">
					<img src="${path}/STATIC/wxStatic/image/dramaAnswer/10.png" />
				</c:if>
			</div>
			<div class="fxComplateBtn-test" style="margin-top: 50px;">
				<div style="float: left;" class="fxComplateBtn" onclick="location.href='${path}/wechatStatic/dramaAnswer.do';">
					<img src="${path}/STATIC/wxStatic/image/dramaAnswer/replay.png" />
				</div>
				<div style="float: right;" class="fxComplateBtn share-button">
					<img src="${path}/STATIC/wxStatic/image/dramaAnswer/getPoint.png"/>
				</div>
				<div style="clear: both;"></div>
				<div class="dramaSee" onclick="location.href='${path}/wechatStatic/dramaFestival.do';">
					<img src="${path}/STATIC/wxStatic/image/dramaAnswer/seedrama.png" />
				</div>
			</div>
		</div>
	</div>
</body>
</html>
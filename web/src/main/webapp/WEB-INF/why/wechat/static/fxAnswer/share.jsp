<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>安康文化云·你到底是多少分的奉贤人</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		var userScore = Math.round('${userScore}'/15*100);
		var answerCount = '${userScore}';
		var userName = '${userName}';
		
		//分享是否隐藏
        if(window.injs){
        	//分享文案
        	appShareTitle = "我是"+userScore+"分的奉贤人，你呢？";
        	appShareDesc = '奉贤光明的特产是冰砖？是牛奶？还是黄桃？';
        	appShareImgUrl = '${basePath}/STATIC/wxStatic/image/fxgame/fxShare.jpg';
        	appShareLink = '${basePath}/wechatStatic/fxAnswer.do';
        	
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
					title: "我是"+userScore+"分的奉贤人，你呢？",
					desc: '奉贤光明的特产是冰砖？是牛奶？还是黄桃？',
					link: '${basePath}wechatStatic/fxAnswer.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/fxgame/fxShare.jpg'
				});
				wx.onMenuShareTimeline({
					title: "我是"+userScore+"分的奉贤人，你呢？",
					imgUrl: '${basePath}/STATIC/wxStatic/image/fxgame/fxShare.jpg',
					link: '${basePath}wechatStatic/fxAnswer.do'
				});
				wx.onMenuShareQQ({
					title: "我是"+userScore+"分的奉贤人，你呢？",
					desc: '奉贤光明的特产是冰砖？是牛奶？还是黄桃？',
					link: '${basePath}/wechatStatic/fxAnswer.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/fxgame/fxShare.jpg'
				});
				wx.onMenuShareWeibo({
					title: "我是"+userScore+"分的奉贤人，你呢？",
					desc: '奉贤光明的特产是冰砖？是牛奶？还是黄桃？',
					link: '${basePath}/wechatStatic/fxAnswer.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/fxgame/fxShare.jpg'
				});
				wx.onMenuShareQZone({
					title: "我是"+userScore+"分的奉贤人，你呢？",
					desc: '奉贤光明的特产是冰砖？是牛奶？还是黄桃？',
					link: '${basePath}/wechatStatic/fxAnswer.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/fxgame/fxShare.jpg'
				});
			});
		}
		
		$(function () {
			
			if(userName.length>0){
				$("#toInfo").attr("src","${path}/STATIC/wxStatic/image/fxgame/getOff.png");
			}else{
				$("#toInfo").attr("src","${path}/STATIC/wxStatic/image/fxgame/getPoint.png");
				$("#toInfo").attr("onclick","location.href='${path}/wechatStatic/fxAnswerInfo.do?userId='"+userId);
			}
			
			//得分文案
			$("#userScore").text("经鉴定你是"+userScore+"%的奉贤人");
			if(0<=answerCount&&answerCount<3){
				$(".fxComplateP1").text("我打赌");
				$(".fxComplateP2").text("你压根就不知道奉贤在哪！还不快来了解，小心半夜被人拍黑砖");
			}else if(3<=answerCount&&answerCount<6){
				$(".fxComplateP1").text("我打赌");
				$(".fxComplateP2").text("你大约仅在天黑时从奉贤路过一次吧，今日奉贤今非昔比，点这里看它新颜");
			}else if(6<=answerCount&&answerCount<9){
				$(".fxComplateP1").text("我打赌");
				$(".fxComplateP2").text("你还在努力研究学习在奉贤的生活指南，给你指条明路吧");
			}else if(9<=answerCount&&answerCount<12){
				$(".fxComplateP1").text("我打赌");
				$(".fxComplateP2").text("你有在奉贤定居的意向，送你一本生活秘籍");
			}else if(12<=answerCount&&answerCount<15){
				$(".fxComplateP1").text("我打赌");
				$(".fxComplateP2").text("你一定对奉贤爱的深沉，获取相爱的证据");
			}else if(answerCount==15){
				$(".fxComplateP1").text("愿赌服输");
				$(".fxComplateP2").text("我发誓从此”戒赌”，并且送你去国际青年艺术周嗨到爆");
			}
			
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
	</style>
	
</head>

<body>
	<div class="game-main">
		<!-- 方便分享自动抓取 -->
		<div style="display: none;"><img src="${basePath}/STATIC/wxStatic/image/fxgame/fxShare.jpg"/></div>
		<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
			<img src="${path}/STATIC/wechat/image/commonShare.png" style="width: 100%;height: 100%;" />
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
		<!--活动页-->
		<div class="game-gamepage" style="background: url(${path}/STATIC/wxStatic/image/fxgame/qubg.jpg) no-repeat center center;background-size: 100% 100%;">

			<div class="game-top">
				<img class="keep-button" src="${path}/STATIC/wxStatic/image/movie/keep.png" style="position: absolute;top: 30px;right: 40px;" />
				<img class="share-button" src="${path}/STATIC/wxStatic/image/movie/share.png" style="position: absolute;top: 30px;right: 150px;" />
			</div>
			<div class="complateJd-test">
				<p id="userScore"></p>
			</div>
			<div class="fxComplate">
				<p class="fxComplateP1"></p>
				<p class="fxComplateP2"></p>
			</div>
			<div class="fxLinkBtn">
				<img src="${path}/STATIC/wxStatic/image/fxgame/linkBtn.png" style="display: block;margin: auto;" onclick="location.href='${path}/wechatStatic/fxActivity.do'"/>
			</div>
			<div class="fxComplateBtn-test">
				<div style="float: left;" class="fxComplateBtn">
					<img src="${path}/STATIC/wxStatic/image/fxgame/replay.png" onclick="location.href='${path}/wechatStatic/fxAnswer.do'"/>
				</div>
				<div style="float: right;" class="fxComplateBtn">
					<img id="toInfo" src=""/>
				</div>
				<div style="clear: both;"></div>
			</div>
		</div>
	</div>
</body>
</html>
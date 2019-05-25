<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>佛山文化云·${sessionScope.sessionTopic.topicName }</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-contestQuiz.css"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
	
	var topicId='${sessionScope.sessionTopic.topicId}'
	var title='${sessionScope.sessionTopic.shareTitle}';
	var describe='${sessionScope.sessionTopic.shareDescribe}';
	var imgUrl='${sessionScope.sessionTopic.shareLogoImg}?x-oss-process=image/resize,w_150,limit_0';
	
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
		
		$(function () {
			
			var backgroundImgUrl='${sessionScope.sessionTopic.backgroundImgUrl}'
		
			$(".endpage").css("background","url("+backgroundImgUrl+") no-repeat center center").css("background-size","100% 100%")
			
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
            
			$(".leftBtn").click(function(){
				
				window.location.href = '${path}/wechatFunction/contestQuiz.do?topicId='+topicId;
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

<body id="${sessionScope.sessionTopicTemplate }"> 
		<div class="game-main">
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
			<div class="endpage" style="">
				<div class="game-top">
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
				</div>
				
				<!--中间提示信息-->
				<div class="endMiddle"></div>
				
				<div class="endpageBtnList">
				
					<!--重新挑战按钮-->
					<div class="leftBtn"></div>
					<!-- 回到首页 -->
					<div class="rightBtn" onclick="toWhyIndex();"></div>
				</div>
			</div>
		</div>

	</body>

</body>
</html>
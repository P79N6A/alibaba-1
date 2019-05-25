<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>佛山文化云·电影节你猜我答</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		var total = '${total}';
		var ranking = '${ranking}';
		var proportion = '${proportion}';
		var userScore = '${userScore}'/10*100;
		var userHeadImgUrl = '${userHeadImgUrl}';
		
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
					title: "单挑上海国际电影节，这些电影你认识几部？",
					desc: '我在电影节猜海报活动中排名第'+ranking+'，战胜全国'+proportion+'%的影迷，已有'+total+'人挑战成功！',
					link: '${basePath}wechatStatic/movieAnswer.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/movie/shareIcon.png'
				});
				wx.onMenuShareTimeline({
					title: '我在电影节猜海报活动中排名第'+ranking+'，战胜全国'+proportion+'%的影迷，已有'+total+'人挑战成功！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/movie/shareIcon.png',
					link: '${basePath}wechatStatic/movieAnswer.do'
				});
				wx.onMenuShareQQ({
					title: "单挑上海国际电影节，这些电影你认识几部？",
					desc: '我在电影节猜海报活动中排名第'+ranking+'，战胜全国'+proportion+'%的影迷，已有'+total+'人挑战成功！',
					link: '${basePath}/wechatStatic/movieAnswer.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/movie/shareIcon.png'
				});
				wx.onMenuShareWeibo({
					title: "单挑上海国际电影节，这些电影你认识几部？",
					desc: '我在电影节猜海报活动中排名第'+ranking+'，战胜全国'+proportion+'%的影迷，已有'+total+'人挑战成功！',
					link: '${basePath}/wechatStatic/movieAnswer.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/movie/shareIcon.png'
				});
				wx.onMenuShareQZone({
					title: "单挑上海国际电影节，这些电影你认识几部？",
					desc: '我在电影节猜海报活动中排名第'+ranking+'，战胜全国'+proportion+'%的影迷，已有'+total+'人挑战成功！',
					link: '${basePath}/wechatStatic/movieAnswer.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/movie/shareIcon.png'
				});
			});
		}
		
		$(function () {
			//用户头像
			if (userHeadImgUrl.indexOf("http") == -1) {
            	userHeadImgHtml = "<img src='${path}/STATIC/wx/image/sh_user_header_icon.png' width='210' height='210' onerror='imgNoFind();'/>";
            } else if (userHeadImgUrl.indexOf("/front/") != -1) {
                var imgUrl = getIndexImgUrl(userHeadImgUrl, "_300_300");
                userHeadImgHtml = "<img src='"+imgUrl+"' width='210' height='210' onerror='imgNoFind();'/>";
            } else {
            	userHeadImgHtml = "<img src='"+userHeadImgUrl+"' width='210' height='210' onerror='imgNoFind();'/>";
            }
			$(".user-head-img").html(userHeadImgHtml);
			
			//得分文案
			if(0<=userScore&&userScore<30){
				$(".jdImg").attr("src","${path}/STATIC/wxStatic/image/movie/jd_01.png");
			}else if(30<=userScore&&userScore<60){
				$(".jdImg").attr("src","${path}/STATIC/wxStatic/image/movie/jd_02.png");
			}else if(60<=userScore&&userScore<90){
				$(".jdImg").attr("src","${path}/STATIC/wxStatic/image/movie/jd_03.png");
			}else if(90<=userScore&&userScore<100){
				$(".jdImg").attr("src","${path}/STATIC/wxStatic/image/movie/jd_04.png");
			}else if(userScore==100){
				$(".jdImg").attr("src","${path}/STATIC/wxStatic/image/movie/jd_05.png");
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
		<div style="display: none;"><img src="${path}/STATIC/wxStatic/image/movie/shareIcon.png"/></div>
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
		<!--活动页-->
		<div class="game-gamepage">
			<img src="${path}/STATIC/wxStatic/image/movie/bg.jpg" width="100%" height="100%" style="z-index: 0;position: absolute;top: 0px;left: 0px;" />
			<div class="game-top">
				<img src="${path}/STATIC/wxStatic/image/movie/logo.png" style="position: absolute;top: 30px;left: 60px;" />
				<img class="keep-button" src="${path}/STATIC/wxStatic/image/movie/keep.png" style="position: absolute;top: 30px;right: 40px;" />
				<img class="share-button" src="${path}/STATIC/wxStatic/image/movie/share.png" style="position: absolute;top: 30px;right: 150px;" />
			</div>
			<div class="user-submit">
				<div class="user-head margin-top50">
					<div class="user-head-img"></div>
					<div class="user-head-info fs50">
						<p class="margin-top40">${userName}</p>
						<p class="margin-top30">得分:<span class="cbb5b76"><fmt:formatNumber type="number" value="${userScore/10*100}" maxFractionDigits="0"/></span></p>
					</div>
					<div style="clear: both;"></div>
				</div>
				<img class="jdImg margin-top50" src="" />
				<div class="jd-ranking fs36">
					<p>全国已有${total}人挑战成功</p>
					<p>您的排名为第${ranking}名</p>
					<p>您已击败了全国${proportion}%的网友</p>
					<img class="share-button" src="${path}/STATIC/wxStatic/image/movie/btn_xy.png" />
				</div>
				<div class="replay margin-top30">
					<img src="${path}/STATIC/wxStatic/image/movie/btn_replay.png" onclick="location.href='${path}/wechatStatic/movieAnswer.do';"/>
					<img src="${path}/STATIC/wxStatic/image/movie/btn_over.png" onclick="location.href='${path}/wechatStatic/movieInfo.do';"/>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
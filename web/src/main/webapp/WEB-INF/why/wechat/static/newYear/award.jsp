<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>安康文化云·带你过最文化的新年</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	
	<script>
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '安康文化云·从圣诞到元宵 带你过最文化的新年！';
	    	appShareDesc = '精彩庆新年文化活动正在热订 新年红包文化福袋放送中！';
	    	appShareImgUrl = '${basePath}/STATIC/wxStatic/image/roomagekind/shareIcon.jpg';
	    	
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
					title: "安康文化云·从圣诞到元宵 带你过最文化的新年！",
					desc: '精彩庆新年文化活动正在热订 新年红包文化福袋放送中！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/roomagekind/shareIcon.jpg'
				});
				wx.onMenuShareTimeline({
					title: "安康文化云·从圣诞到元宵 带你过最文化的新年！",
					imgUrl: '${basePath}/STATIC/wxStatic/image/roomagekind/shareIcon.jpg'
				});
				wx.onMenuShareQQ({
					title: "安康文化云·从圣诞到元宵 带你过最文化的新年！",
					desc: '精彩庆新年文化活动正在热订 新年红包文化福袋放送中！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/roomagekind/shareIcon.jpg'
				});
				wx.onMenuShareWeibo({
					title: "安康文化云·从圣诞到元宵 带你过最文化的新年！",
					desc: '精彩庆新年文化活动正在热订 新年红包文化福袋放送中！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/roomagekind/shareIcon.jpg'
				});
				wx.onMenuShareQZone({
					title: "安康文化云·从圣诞到元宵 带你过最文化的新年！",
					desc: '精彩庆新年文化活动正在热订 新年红包文化福袋放送中！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/roomagekind/shareIcon.jpg'
				});
			});
		}
		
		$(function () {
			navFixed($(".kjmbNav"),'touchmove',240);
		    navFixed($(".kjmbNav"),'scroll',240);
		    
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
		
		// 导航固定
	    function navFixed(ele, type, topH) {
	        $(document).on(type, function() {
	            if($(document).scrollTop() > topH) {
	                ele.css('position', 'fixed');
	            } else {
	                ele.css('position', 'static');
	            }
	        });
	    }
		
	</script>
	
	<style>
		html,body {height: 100%;}
		.roomage {min-height: 100%;}
	</style>
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${basePath}/STATIC/wxStatic/image/roomagekind/shareIcon.jpg"/></div>
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
	<div class="roomage">
		<div class="lccbanner">
			<img src="${path}/STATIC/wxStatic/image/roomagekind/ban.jpg" width="750" height="250">
			<ul class="lccshare clearfix">
				<li class="share-button"><a href="javascript:;">分享</a></li>
				<li class="keep-button"><a href="javascript:;">关注</a></li>
			</ul>
		</div>
		<div class="kjmbNav_wc">
			<ul class="kjmbNav clearfix">
				<li><a href="${path}/wechatStatic/nyIndex.do">首页</a></li>
				<li><a href="${path}/wechatStatic/nyRanking.do">排行榜</a></li>
				<li><a href="${path}/wechatStatic/nyRule.do">活动规则</a></li>
				<li class="current"><a href="${path}/wechatStatic/nyAward.do">中奖名单</a></li>
			</ul>
		</div>
		<div class="winList jz700">
	        <img src="${path}/STATIC/wxStatic/image/roomagekind/pic17.jpg">
	    </div>
	</div>
</body>
</html>
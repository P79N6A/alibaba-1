<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>${ccpVote.voteName}</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		var fullUrl = '${fullUrl}';
	
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '${ccpVote.shareTitle}';
	    	appShareDesc = '${ccpVote.shareDescribe}';
	    	appShareImgUrl = '${ccpVote.shareLogoImg}@400w';
	    	
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
					title: '${ccpVote.shareTitle}',
					desc: '${ccpVote.shareDescribe}',
					imgUrl: '${ccpVote.shareLogoImg}@400w',
					link: fullUrl
				});
				wx.onMenuShareTimeline({
					title: '${ccpVote.shareTitle}',
					imgUrl: '${ccpVote.shareLogoImg}@400w',
					link: fullUrl
				});
				wx.onMenuShareQQ({
					title: '${ccpVote.shareTitle}',
					desc: '${ccpVote.shareDescribe}',
					imgUrl: '${ccpVote.shareLogoImg}@400w'
				});
				wx.onMenuShareWeibo({
					title: '${ccpVote.shareTitle}',
					desc: '${ccpVote.shareDescribe}',
					imgUrl: '${ccpVote.shareLogoImg}@400w'
				});
				wx.onMenuShareQZone({
					title: '${ccpVote.shareTitle}',
					desc: '${ccpVote.shareDescribe}',
					imgUrl: '${ccpVote.shareLogoImg}@400w'
				});
			});
		}
		
		$(function () {
			navFixed($(".template .tetit"),'touchmove',240);
		    navFixed($(".template .tetit"),'scroll',240);
			
			//分享
			$(".shareBtn").click(function() {
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
			$(".keepBtn").on("touchstart", function() {
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
		* {-webkit-tap-highlight-color: transparent;}
		html,body{font-family:arial,\5FAE\8F6F\96C5\9ED1,\9ED1\4F53,\5b8b\4f53,sans-serif; -webkit-text-size-adjust:none;}
		img {vertical-align: middle;}
		html,body {background-color: #eee;height: 100%; }
	</style>
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${ccpVote.shareLogoImg}@400w"/></div>
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
	<div class="template">
	    <div class="teban">
	    	<div class="logo"></div>
	        <c:choose>
	    		<c:when test="${not empty ccpVote.coverImgUrl}">
	    			<img src="${ccpVote.coverImgUrl}@750w" width="750" height="250">
	    		</c:when>
	    		<c:otherwise>
	    			<img src="${path}/STATIC/wxStatic/image/vote/defaultImg.jpg" width="750" height="250">
	    		</c:otherwise>
	    	</c:choose>
	        <div class="tebchar">
	            <div class="nc">
	                <p class="w1">${ccpVote.voteTitle}</p>
	                <p class="w2">${ccpVote.voteSecondTitle}</p>
	            </div>
	        </div>
	        <ul class="lccshare clearfix">
	            <li class="shareBtn"><a href="javascript:;">分享</a></li>
	            <li class="keepBtn"><a href="javascript:;">关注</a></li>
	        </ul>
	    </div>
	    <div class="tetit_wc">
	        <ul class="tetit clearfix">
	            <li><a href="${path}/wechatFunction/voteIndex.do?voteId=${ccpVote.voteId}">投票</a></li>
	            <li class="current"><a href="javascript:;">活动规则</a></li>
	            <li><a href="${path}/wechatFunction/voteRanking.do?voteId=${ccpVote.voteId}">排行榜</a></li>
	        </ul>
	    </div>
	    <div class="tecont_wc">
	        <div class="tecont rules jz700">
	            <div class="nc">
	                <div class="t">#&nbsp;&nbsp;&nbsp;&nbsp;活动规则&nbsp;&nbsp;&nbsp;&nbsp;#</div>
	                <div class="xian"></div>
	                <c:set var="items" value="${fn:split(ccpVote.voteRule, ',')}"></c:set>
					<c:forEach items="${items}" var="dom" varStatus="i">
						<p>${i.index+1}.  ${dom}</p>
					</c:forEach>
	            </div>
	        </div>
	    </div>
	</div>
</body>
</html>
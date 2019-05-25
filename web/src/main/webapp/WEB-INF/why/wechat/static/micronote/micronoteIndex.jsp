<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>安康文化云·微笔记大赛</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '市民文化节--云叔喊你来写读书笔记 赢丰富好礼';
	    	appShareDesc = '阅读中的真善美•我的阅读笔记线上“微笔记”征集大赛火热进行中';
	    	appShareImgUrl = '${basePath}/STATIC/wx/image/share_120.png';
	    	
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
					title: "市民文化节--云叔喊你来写读书笔记 赢丰富好礼",
					desc: '阅读中的真善美•我的阅读笔记线上“微笔记”征集大赛火热进行中',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
				});
				wx.onMenuShareTimeline({
					title: "阅读中的真善美•我的阅读笔记线上“微笔记”征集大赛火热进行中",
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
				});
				wx.onMenuShareQQ({
					title: "市民文化节--云叔喊你来写读书笔记 赢丰富好礼",
					desc: '阅读中的真善美•我的阅读笔记线上“微笔记”征集大赛火热进行中',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
				});
				wx.onMenuShareWeibo({
					title: "市民文化节--云叔喊你来写读书笔记 赢丰富好礼",
					desc: '阅读中的真善美•我的阅读笔记线上“微笔记”征集大赛火热进行中',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
				});
				wx.onMenuShareQZone({
					title: "市民文化节--云叔喊你来写读书笔记 赢丰富好礼",
					desc: '阅读中的真善美•我的阅读笔记线上“微笔记”征集大赛火热进行中',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
				});
			});
		}
		
		$(function () {
			//规则
			$(".zsm-hdgz").click(function(){
				$(".zsm-hdgz-pop").show()
			})
			$(".zsm-hdgz-pop").click(function(){
				$(this).hide()
			})
			
			//分享
			$(".zsm-share").click(function() {
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
			$(".zsm-keep").on("touchstart", function() {
				$('.div-share').show()
				$("body,html").addClass("bg-notouch")
			})
		});
		
		
	</script>
	
	<style>
		html,
		body {
			height: 100%;
			width: 100%;
		}
		.zsm-main{
			height: 100%;
			background: url(${path}/STATIC/wxStatic/image/zsm/zsm-bg.jpg) no-repeat center center;
			background-size: 100% 100%;
		}
	</style>
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${basePath}/STATIC/wx/image/share_120.png"/></div>
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
	<div class="zsm-main">
		<div class="zsm-share">
			<img src="${path}/STATIC/wxStatic/image/movie/share.png" />
		</div>
		<div class="zsm-keep">
			<img src="${path}/STATIC/wxStatic/image/movie/keep.png" />
		</div>
		<div class="zsm-wycs" onclick="location.href='${path}/wechatStatic/toMicronoteList.do'">
			<img src="${path}/STATIC/wxStatic/image/zsm/wycs.png" />
		</div>
		<div class="zsm-hdgz">
			<img src="${path}/STATIC/wxStatic/image/zsm/hdgz.png" />
		</div>
		<!-- 规则框 -->
		<div class="zsm-hdgz-pop">
			<div class="noteRole">
				<div class="noteRoleFont">
					<%@include file="/WEB-INF/why/wechat/static/micronote/micronoteRule.jsp"%>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
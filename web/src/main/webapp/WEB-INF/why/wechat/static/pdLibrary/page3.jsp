<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>浦东图书馆总分馆介绍</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '浦东图书馆总分馆介绍';
	    	appShareDesc = '就在你身边的大浦东35家街镇分馆，你去过多少？';
	    	appShareImgUrl = '${basePath}/STATIC/wxStatic/image/pdShareIcon.jpg';
	    	appShareLink = '${basePath}/wechatStatic/pdLibrary.do?page=1';
	    	
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
					title: "浦东图书馆总分馆介绍",
					desc: '就在你身边的大浦东35家街镇分馆，你去过多少？',
					link: '${basePath}wechatStatic/pdLibrary.do?page=1',
					imgUrl: '${basePath}/STATIC/wxStatic/image/pdShareIcon.jpg'
				});
				wx.onMenuShareTimeline({
					title: "浦东图书馆总分馆介绍",
					link: '${basePath}wechatStatic/pdLibrary.do?page=1',
					imgUrl: '${basePath}/STATIC/wxStatic/image/pdShareIcon.jpg'
				});
				wx.onMenuShareQQ({
					title: "浦东图书馆总分馆介绍",
					desc: '就在你身边的大浦东35家街镇分馆，你去过多少？',
					link: '${basePath}/wechatStatic/pdLibrary.do?page=1',
					imgUrl: '${basePath}/STATIC/wxStatic/image/pdShareIcon.jpg'
				});
				wx.onMenuShareWeibo({
					title: "浦东图书馆总分馆介绍",
					desc: '就在你身边的大浦东35家街镇分馆，你去过多少？',
					link: '${basePath}/wechatStatic/pdLibrary.do?page=1',
					imgUrl: '${basePath}/STATIC/wxStatic/image/pdShareIcon.jpg'
				});
				wx.onMenuShareQZone({
					title: "浦东图书馆总分馆介绍",
					desc: '就在你身边的大浦东35家街镇分馆，你去过多少？',
					link: '${basePath}/wechatStatic/pdLibrary.do?page=1',
					imgUrl: '${basePath}/STATIC/wxStatic/image/pdShareIcon.jpg'
				});
			});
		}
		
		$(function () {
			function setStopPropagation(evt) {
		        var e = evt || window.event;
		        if(typeof e.stopPropagation == 'function') {
		            e.stopPropagation();
		        } else {
		            e.cancelBubble = true;
		        }   
		    }
		    $('.pdbacksy  .cover').bind('click', function (evt) {
		        setStopPropagation(evt);
		        $('.pdbacksy').stop().animate({
		            'right':'0'
		        },400);
		        $(this).hide();
		    });
		    $('.pdbacksy , .pdbacksy li , .pdbacksy li a').bind('click',function () {
		        setStopPropagation(evt);
		    });
		    $('html,body').bind('click', function () {
		        $('.pdbacksy').stop().animate({
		            'right':'-433'
		        },400);
		        $('.pdbacksy  .cover').show();
		    });
			
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
		
	</script>
	
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${basePath}/STATIC/wxStatic/image/pdShareIcon.jpg"/></div>
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
	<div class="pdtsg pdtsgsy">
	    <div class="pdheader">
	        <img src="http://img1.wenhuayun.cn/pdlibraryStatic/logo.png">
	        <ul class="lccshare clearfix">
	            <li><a class="shareBtn" href="javascript:;">分享</a></li>
	            <li><a class="keepBtn" href="javascript:;">关注</a></li>
	        </ul>
	    </div>
	
	    <div class="pdsytit jz630"><img src="http://img1.wenhuayun.cn/pdlibraryStatic/tit21.png"></div>
	    <div class="pdfenglist_wc">
		    <ul class="pdfenglist clearfix">
		    	<li class="you clearfix">
		    		<div class="lable_wc clearfix"><div class="lable clearfix"><a href="${path}/wechatStatic/pdLibrary.do?page=5&point=0"><img src="http://img1.wenhuayun.cn/pdlibraryStatic/lable3.png"></a></div></div>
		    	</li>
		    	<li class="zuo clearfix">
		    		<div class="lable_wc clearfix"><div class="lable clearfix"><a href="${path}/wechatStatic/pdLibrary.do?page=5&point=2"><img src="http://img1.wenhuayun.cn/pdlibraryStatic/lable4.png"></a></a></div></div>
		    	</li>
		    	<li class="you clearfix">
		    		<div class="lable_wc clearfix"><div class="lable clearfix"><a href="${path}/wechatStatic/pdLibrary.do?page=5&point=4"><img src="http://img1.wenhuayun.cn/pdlibraryStatic/lable5.png"></a></div></div>
		    	</li>
		    	<li class="zuo clearfix">
		    		<div class="lable_wc clearfix"><div class="lable clearfix"><a href="${path}/wechatStatic/pdLibrary.do?page=5&point=6"><img src="http://img1.wenhuayun.cn/pdlibraryStatic/lable6.png"></a></div></div>
		    	</li>
		    	<li class="you clearfix">
		    		<div class="lable_wc clearfix"><div class="lable clearfix"><a href="${path}/wechatStatic/pdLibrary.do?page=5&point=8"><img src="http://img1.wenhuayun.cn/pdlibraryStatic/lable7.png"></a></div></div>
		    	</li>
		    	<li class="zuo clearfix">
		    		<div class="lable_wc clearfix"><div class="lable clearfix"><a href="${path}/wechatStatic/pdLibrary.do?page=5&point=10"><img src="http://img1.wenhuayun.cn/pdlibraryStatic/lable8.png"></a></div></div>
		    	</li>
		    	<li class="you clearfix">
		    		<div class="lable_wc clearfix"><div class="lable clearfix"><a href="${path}/wechatStatic/pdLibrary.do?page=5&point=12"><img src="http://img1.wenhuayun.cn/pdlibraryStatic/lable9.png"></a></div></div>
		    	</li>
		    	<li class="zuo clearfix">
		    		<div class="lable_wc clearfix"><div class="lable clearfix"><a href="${path}/wechatStatic/pdLibrary.do?page=5&point=14"><img src="http://img1.wenhuayun.cn/pdlibraryStatic/lable10.png"></a></div></div>
		    	</li>
		    	<li class="you clearfix">
		    		<div class="lable_wc clearfix"><div class="lable clearfix"><a href="${path}/wechatStatic/pdLibrary.do?page=5&point=16"><img src="http://img1.wenhuayun.cn/pdlibraryStatic/lable11.png"></a></div></div>
		    	</li>
		    	<li class="zuo clearfix">
		    		<div class="lable_wc clearfix"><div class="lable clearfix"><a href="${path}/wechatStatic/pdLibrary.do?page=5&point=18"><img src="http://img1.wenhuayun.cn/pdlibraryStatic/lable12.png"></a></div></div>
		    	</li>
		    	<li class="you clearfix">
		    		<div class="lable_wc clearfix"><div class="lable clearfix"><a href="${path}/wechatStatic/pdLibrary.do?page=5&point=20"><img src="http://img1.wenhuayun.cn/pdlibraryStatic/lable13.png"></a></div></div>
		    	</li>
		    	<li class="zuo clearfix">
		    		<div class="lable_wc clearfix"><div class="lable clearfix"><a href="${path}/wechatStatic/pdLibrary.do?page=5&point=22"><img src="http://img1.wenhuayun.cn/pdlibraryStatic/lable14.png"></a></div></div>
		    	</li>
		    	<li class="you clearfix">
		    		<div class="lable_wc clearfix"><div class="lable clearfix"><a href="${path}/wechatStatic/pdLibrary.do?page=5&point=24"><img src="http://img1.wenhuayun.cn/pdlibraryStatic/lable15.png"></a></div></div>
		    	</li>
		    	<li class="zuo clearfix">
		    		<div class="lable_wc clearfix"><div class="lable clearfix"><a href="${path}/wechatStatic/pdLibrary.do?page=5&point=26"><img src="http://img1.wenhuayun.cn/pdlibraryStatic/lable16.png"></a></div></div>
		    	</li>
		    	<li class="you clearfix">
		    		<div class="lable_wc clearfix"><div class="lable clearfix"><a href="${path}/wechatStatic/pdLibrary.do?page=5&point=28"><img src="http://img1.wenhuayun.cn/pdlibraryStatic/lable17.png"></a></div></div>
		    	</li>
		    	<li class="zuo clearfix">
		    		<div class="lable_wc clearfix"><div class="lable clearfix"><a href="${path}/wechatStatic/pdLibrary.do?page=5&point=30"><img src="http://img1.wenhuayun.cn/pdlibraryStatic/lable18.png"></a></div></div>
		    	</li>
		    	<li class="you clearfix">
		    		<div class="lable_wc clearfix"><div class="lable clearfix"><a href="${path}/wechatStatic/pdLibrary.do?page=5&point=32"><img src="http://img1.wenhuayun.cn/pdlibraryStatic/lable19.png"></a></div></div>
		    	</li>
		    </ul>
		    <div class="xian"></div>
	    </div>
	</div>
	
	
	<!-- 回到首页 -->
	<div class="pdbacksy">
	    <ul class="clearfix">
	        <li><a href="${path}/wechatStatic/pdLibrary.do?page=1">首页</a><em></em></li>
	        <li><a href="${path}/wechatStatic/pdLibrary.do?page=3">分馆</a><em></em></li>
	        <li><a href="${path}/wechatStatic/pdLibrary.do?page=6&point=0">延伸服务点<em></em></a></li>
	        <li><a href="${path}/wechatStatic/pdLibrary.do?page=6&point=2">流动图书车</a></li>
	    </ul>
	    <div class="cover"></div>
	</div>
</body>
</html>
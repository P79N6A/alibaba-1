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
			var swiper = new Swiper('.swiper-container', {
		        // direction: 'vertical',
		        slidesPerView: 1,
		        // noSwiping : true,
		        mousewheelControl: true,
		        lazyLoading : true,
		        lazyLoadingInPrevNext: true
		    });

		    // 获取url
		    var urlIndex = parseInt('${point}');
		    if(urlIndex) {
		        swiper.slideTo(urlIndex , 0, false);
		    }

		    

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
	<div class="pdheader">
		<img src="http://img1.wenhuayun.cn/pdlibraryStatic/logo.png">
		<ul class="lccshare clearfix">
			<li><a class="shareBtn" href="javascript:;">分享</a></li>
	        <li><a class="keepBtn" href="javascript:;">关注</a></li>
		</ul>
	</div>
	<img class="pdright" src="http://img1.wenhuayun.cn/pdlibraryStatic/icon2.png">
	<!-- <img class="pdfoot" src="http://img1.wenhuayun.cn/pdlibraryStatic/icon2.png"> -->
	
	<div class="swiper-container pdtsg">
	    <div class="swiper-wrapper">
			
			<div class="swiper-slide" style="background-image: url(http://img1.wenhuayun.cn/pdlibraryStatic/bg18.png);">
            <div class="pdtit jz630"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tit18.png"></div>
            <div class="pdcont jz630">
                <img class="wz swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/wz18.png">
                <p style="font-size:30px;color:#333;text-align:center;margin-bottom:40px;margin-top:20px;font-weight:bold;">上海浦东图书馆延伸服务网络图</p>
                <img class="wz swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu117.png">
            </div>
        </div>
        <div class="swiper-slide" style="background-image: url(http://img1.wenhuayun.cn/pdlibraryStatic/bg18.png);">
            <div class="pdtit jz630"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tit18.png"></div>
            <div class="pdcont jz630">
                <h5 style="font-size:30px;color:#333;text-align:center;margin-bottom:20px;">南极长城站延伸点</h5>
                <ul class="pdtupic clearfix">
                    <li>
                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu111.png" width="301" height="181"></div>
                    </li>
                    <li>
                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu112.png" width="301" height="181"></div>
                    </li>
                </ul>
                <h5 style="font-size:30px;color:#333;text-align:center;margin-bottom:20px;">雪龙号船延伸点</h5>
                <ul class="pdtupic clearfix">
                    <li>
                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu113.png" width="301" height="181"></div>
                    </li>
                    <li>
                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu114.png" width="301" height="181"></div>
                    </li>
                </ul>
                <h5 style="font-size:30px;color:#333;text-align:center;margin-bottom:20px;">中国商飞公司延伸点</h5>
                <ul class="pdtupic clearfix">
                    <li>
                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu115.png" width="301" height="181"></div>
                    </li>
                    <li>
                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu116.png" width="301" height="181"></div>
                    </li>
                </ul>
            </div>
        </div>
			
			
	        <div class="swiper-slide" style="background-image: url(http://img1.wenhuayun.cn/pdlibraryStatic/bg19.png);">
	            <div class="pdtit jz630"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tit19.png"></div>
	            <div class="pdcont jz630">
	                <img class="wz swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/wz19.png">
	            </div>
	        </div>
	        <div class="swiper-slide" style="background-image: url(http://img1.wenhuayun.cn/pdlibraryStatic/bg19.png);">
	
	            <div class="pdtit jz630"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tit19.png"></div>
	            <div class="pdcont jz630">
	                <ul class="pdtupic clearfix">
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu105.png" width="301" height="181"></div>
	                        <div class="char">“六一”捐书活动现场</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu106.png" width="301" height="181"></div>
	                        <div class="char">“六一”捐书活动现场2</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu107.png" width="301" height="181"></div>
	                        <div class="char">感恩母亲节活动</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu108.png" width="301" height="181"></div>
	                        <div class="char">感恩母亲节活动2</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu109.png" width="301" height="181"></div>
	                        <div class="char">流动车全貌</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu110.png" width="301" height="181"></div>
	                        <div class="char">流动车内场景</div>
	                    </li>
	                </ul>
	            </div>
	        </div>
	
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
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>佛山文化云·邀你一起打造上海城市名片</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	
	<script>
		var cityType = 7;	//本次活动编号
		var cityImgId = '${cityImgId}';
		var noControl = '${noControl}';	//1：不可操作
	
		$(function () {
			navFixed($(".kjmbNav"),'touchmove',240);
		    navFixed($(".kjmbNav"),'scroll',240);
		    
			$.post("${path}/wechatFunction/queryCityImgList.do",{cityImgId: cityImgId,userId:userId,cityType:cityType}, function (data) {
				if(data.length>0){
					var dom = data[0];
                    if (dom.cityImgUrl) {
                        var cityImgUrls = dom.cityImgUrl.split(";");
                        $.each(cityImgUrls, function (i, cityImgUrl) {
                        	$("#cityImgUrl").append("<li style='background-color:#7c7c7c;' onclick='showPreview(\""+dom.cityImgUrl+"\",$(this));'><img src='" + cityImgUrl + "@700w'></li>");
                        });
                    }
                    imgStyleFormat('roomzpxq');
					$(".userName").text(dom.userName);
					$("#cityImgContent").text(dom.cityImgContent);
					var userHeadImgHtml = getUserHeadImgHtml(dom.userHeadImgUrl);
					$("#userHeadImgUrl").html(userHeadImgHtml);
					$("#voteCount").text(dom.voteCount);
					if(dom.isVote == 1){
						$("#voteLove").addClass("current");
					}
					
					//分享是否隐藏
				    if(window.injs){
				    	//分享文案
				    	appShareTitle = '佛山文化云·邀你一起打造上海城市名片';
				    	appShareDesc = '考验友情的时候到了~给'+dom.userName+'投票，赢文化福袋！你也可以一起结伴参加！';
				    	appShareImgUrl = 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017619141137Pz9rTSsCpWWwOhcnGgZhWu1lxgP9Dh.jpg';
				    	
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
								title: "佛山文化云·邀你一起打造上海城市名片",
								desc: '考验友情的时候到了~给'+dom.userName+'投票，赢文化福袋！你也可以一起结伴参加！',
								imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017619141137Pz9rTSsCpWWwOhcnGgZhWu1lxgP9Dh.jpg'
							});
							wx.onMenuShareTimeline({
								title: "考验友情的时候到了~给"+dom.userName+"投票，赢文化福袋！你也可以一起结伴参加！",
								imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017619141137Pz9rTSsCpWWwOhcnGgZhWu1lxgP9Dh.jpg'
							});
							wx.onMenuShareQQ({
								title: "佛山文化云·邀你一起打造上海城市名片",
								desc: '考验友情的时候到了~给'+dom.userName+'投票，赢文化福袋！你也可以一起结伴参加！',
								imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017619141137Pz9rTSsCpWWwOhcnGgZhWu1lxgP9Dh.jpg'
							});
							wx.onMenuShareWeibo({
								title: "佛山文化云·邀你一起打造上海城市名片",
								desc: '考验友情的时候到了~给'+dom.userName+'投票，赢文化福袋！你也可以一起结伴参加！',
								imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017619141137Pz9rTSsCpWWwOhcnGgZhWu1lxgP9Dh.jpg'
							});
							wx.onMenuShareQZone({
								title: "佛山文化云·邀你一起打造上海城市名片",
								desc: '考验友情的时候到了~给'+dom.userName+'投票，赢文化福袋！你也可以一起结伴参加！',
								imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017619141137Pz9rTSsCpWWwOhcnGgZhWu1lxgP9Dh.jpg'
							});
						});
					}
				}
			},"json");
			
			// 关闭大图
		    $('.roomBigPic').bind('click', function () {
		        $(this).stop().fadeOut(80, function () {
		            outSwiper.removeAllSlides();
		        });
		    });
			
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
		
		//投票
		function cityVote(){
			if(noControl != 1){
				if (userId == null || userId == '') {
	        		//判断登陆
	            	publicLogin("${basePath}wechatFunction/cityDetail.do?cityImgId="+cityImgId);
	        	}else{
	        		$.post("${path}/wechatFunction/addCityVote.do",{userId:userId,cityImgId:cityImgId,cityType:cityType}, function (data) {
	    				if(data == "200"){
	    					var voteCount = $("#voteCount").text();
	    					$("#voteCount").text(eval(voteCount)+1);
	    					$("#voteLove").addClass("current");
	    					dialogAlert('系统提示', '投票成功！');
	    				}else if(data == "repeat"){
	    					dialogAlert('系统提示', '一天只能投一票！');
	    				}else if(data == "500"){
	    					dialogAlert('系统提示', '投票失败！');
	    				}
	    			},"json");
	        	}
			}else{
				dialogAlert('系统提示', '活动已结束！');
			}
		}
		
		//头像
		function getUserHeadImgHtml(userHeadImgUrl){
			var userHeadImgHtml = '';
			if(userHeadImgUrl){
                if(userHeadImgUrl.indexOf("http") == -1){
                	userHeadImgUrl = getImgUrl(userHeadImgUrl);
                }
            }else{
            	userHeadImgUrl = '';
            }
			if (userHeadImgUrl.indexOf("http") == -1) {
            	userHeadImgHtml = "<img src='../STATIC/wx/image/sh_user_header_icon.png'/>";
            } else if (userHeadImgUrl.indexOf("/front/") != -1) {
                var imgUrl = getIndexImgUrl(userHeadImgUrl, "_300_300");
                userHeadImgHtml = "<img src='" + imgUrl + "' onerror='imgNoFind();'/>";
            } else {
            	userHeadImgHtml = "<img src='" + userHeadImgUrl + "' onerror='imgNoFind();'/>";
            }
			return userHeadImgHtml;
		}
		
		//预览大图
	  	var springSwiperFlag = 0;
    	var outSwiper = null;
		function showPreview(imgSrc,$this){
			imgSrc = imgSrc.split(";");
	        var slideAmount = imgSrc.length;
	        var ele_s1 = $('.roomBigPic .amount .s1');
	        $('.roomBigPic .amount .s2').html(slideAmount);
	        var _index = $this.index();

	        $('.roomBigPic').stop().fadeIn(80, function () {
	            if(springSwiperFlag == 0) {
	                outSwiper = new Swiper('.roomBigPic .swiper-container', {
	                    lazyLoading : true,
	                    lazyLoadingInPrevNext : true,
	                    observer:true,
	                    onInit: function(inSwiper){
	                        for(var i = 0; i < slideAmount; i++) {
	                            inSwiper.appendSlide('<div class="swiper-slide"><img class="swiper-lazy" data-src="' + imgSrc[i] + '@800w"><div class="swiper-lazy-preloader"></div></div>');
	                        }

	                        inSwiper.slideTo(_index, 0, false);
	                        ele_s1.html(inSwiper.activeIndex + 1);
	                    },
	                    onSlideChangeEnd: function(inSwiper){
	                        ele_s1.html(inSwiper.activeIndex + 1);
	                    }
	                });
	                springSwiperFlag = 1;
	            } else {
	                outSwiper.removeAllSlides();
	                for(var i = 0; i < slideAmount; i++) {
	                    outSwiper.appendSlide('<div class="swiper-slide"><img class="swiper-lazy" data-src="' + imgSrc[i] + '@800w"><div class="swiper-lazy-preloader"></div></div>');
	                }
	                outSwiper.slideTo(_index, 0, false);
	                ele_s1.html(outSwiper.activeIndex + 1);
	            }
	        });
		}
		
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
	<div style="display: none;"><img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017619141137Pz9rTSsCpWWwOhcnGgZhWu1lxgP9Dh.jpg"/></div>
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
			<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201761910580PO8neFr00YNFpdQh9scgaNJrKOc3wH.jpg" width="750" height="250">
			<ul class="lccshare clearfix">
				<li class="share-button"><a href="javascript:;">分享</a></li>
				<li class="keep-button"><a href="javascript:;">关注</a></li>
			</ul>
		</div>
		<div class="kjmbNav_wc">
			<ul class="kjmbNav clearfix">
				<li><a href="${path}/wechatFunction/cityIndex.do?tab=1">首页</a></li>
				<li><a href="${path}/wechatFunction/cityRanking.do">排行榜</a></li>
				<li><a href="${path}/wechatFunction/cityRule.do">活动规则</a></li>
				<li><a href="${path}/wechatFunction/cityReview.do">往期回顾</a></li>
			</ul>
		</div>
		<div class="roomcont jz700">
	        <div class="roomzpxq">
	            <div class="jinhaotit jz630">
	                <div class="h1">#&nbsp;&nbsp;请为“<span class="userName"></span>”发布的作品投票&nbsp;&nbsp;#</div>
	            </div>
	            <ul class="jiugge clearfix" id="cityImgUrl"></ul>
	            <p id="cityImgContent"></p>
	            <div class="lvvtouc">
	            	<div class="jz630 clearfix">
	            		<div class="pic" id="userHeadImgUrl"></div>
	            		<div class="char userName"></div>
	            		<div class="fu clearfix">
	                        <div id="voteLove" class="f2" onclick="cityVote();"><span></span><em id="voteCount"></em></div>
	                    </div>
	            	</div>
	            </div>
	            <div class="lccDoubleBtn jz630">
	                <a class="lan" href="javascript:cityVote();">投票</a>
	                <a class="hong share-button" href="javascript:;">分享去拉票</a>
	            </div>
	        </div>
	    </div>
	</div>
	<!-- 查看大图 -->
    <div class="roomBigPic" style="display:none;">
        <div class="amount"><span class="s1"></span> / <span class="s2"></span></div>
        <div class="swiper-container">
            <div class="swiper-wrapper"></div>
        </div>
    </div>
</body>
</html>
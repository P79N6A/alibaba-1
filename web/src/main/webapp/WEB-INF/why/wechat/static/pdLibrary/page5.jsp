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
	<!-- <img class="swiper-lazy" class="pdfoot" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/icon2.png"> -->
	
	<div class="swiper-container pdtsg">
	    <div class="swiper-wrapper">
	
	        <div class="swiper-slide" style="background-image: url(http://img1.wenhuayun.cn/pdlibraryStatic/bg1.png);">
	        	<div class="pdtit jz630"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tit1.png"></div>
	        	<div class="pdcont jz630">
	        		<img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/wz1.png">
	        	</div>
	        </div>
	        <div class="swiper-slide" style="background-image: url(http://img1.wenhuayun.cn/pdlibraryStatic/bg1.png);">
	
	        	<div class="pdtit jz630"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tit1.png"></div>
	        	<div class="pdcont jz630">
	        		<ul class="pdtupic clearfix">
	        			<li>
	        				<div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu1.png" width="301" height="181"></div>
	        				<div class="char">暑期学生古诗文硬笔书法比赛</div>
	        			</li>
	        			<li>
	        				<div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu2.png" width="301" height="181"></div>
	        				<div class="char">暑期学生硬笔书法班</div>
	        			</li>
	        			<li>
	        				<div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu3.png" width="301" height="181"></div>
	        				<div class="char">送书致军营</div>
	        			</li>
	        			<li>
	        				<div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu4.png" width="301" height="181"></div>
	        				<div class="char">为即将退伍军人<br>举办电脑培训班</div>
	        			</li>
	        			<li>
	        				<div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu5.png" width="301" height="181"></div>
	        				<div class="char">图书馆乐在棋中休闲区</div>
	        			</li>
	        			<li>
	        				<div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu6.png" width="301" height="181"></div>
	        				<div class="char">图书馆征文活动读者投稿</div>
	        			</li>
	        		</ul>
	        	</div>
	        </div>
	
	        <div class="swiper-slide" style="background-image: url(http://img1.wenhuayun.cn/pdlibraryStatic/bg2.png);">
	            <div class="pdtit jz630"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tit2.png"></div>
	            <div class="pdcont jz630">
	                <img class="wz swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/wz2.png">
	            </div>
	        </div>
	        <div class="swiper-slide" style="background-image: url(http://img1.wenhuayun.cn/pdlibraryStatic/bg2.png);">
	            <div class="pdtit jz630"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tit2.png"></div>
	            <div class="pdcont jz630">
	                <ul class="pdtupic clearfix">
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu7.png" width="301" height="181"></div>
	                        <div class="char">大团文化中心全景</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu8.png" width="301" height="181"></div>
	                        <div class="char">图书馆开展少儿<br>创意彩泥制作比赛</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu9.png" width="301" height="181"></div>
	                        <div class="char">图书馆邀请农业专家<br>指导农民瓜果栽培</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu10.png" width="301" height="181"></div>
	                        <div class="char">图书馆组织开展诵读比赛</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu11.png" width="301" height="181"></div>
	                        <div class="char">文化服务日-图书馆组织<br>读者开展朗诵培训及赏析</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu12.png" width="301" height="181"></div>
	                        <div class="char">学雷锋日-图书馆组织志愿者<br>与希望小学学生一起互动游戏</div>
	                    </li>
	                </ul>
	            </div>
	        </div>
	
	        <div class="swiper-slide" style="background-image: url(http://img1.wenhuayun.cn/pdlibraryStatic/bg3.png);">
	            <div class="pdtit jz630"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tit3.png"></div>
	            <div class="pdcont jz630">
	                <img class="wz swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/wz3.png">
	            </div>
	        </div>
	        <div class="swiper-slide" style="background-image: url(http://img1.wenhuayun.cn/pdlibraryStatic/bg3.png);">
	            <div class="pdtit jz630"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tit3.png"></div>
	            <div class="pdcont jz630">
	                <ul class="pdtupic clearfix">
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu13.png" width="301" height="181"></div>
	                        <div class="char">暑期学生古诗文硬笔书法比赛</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu14.png" width="301" height="181"></div>
	                        <div class="char">暑期学生硬笔书法班</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu15.png" width="301" height="181"></div>
	                        <div class="char">送书致军营</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu16.png" width="301" height="181"></div>
	                        <div class="char">为即将退伍军人<br>举办电脑培训班</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu17.png" width="301" height="181"></div>
	                        <div class="char">图书馆乐在棋中休闲区</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu18.png" width="301" height="181"></div>
	                        <div class="char">图书馆征文活动读者投稿</div>
	                    </li>
	                </ul>
	            </div>
	        </div>
	
	        <div class="swiper-slide" style="background-image: url(http://img1.wenhuayun.cn/pdlibraryStatic/bg4.png);">
	            <div class="pdtit jz630"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tit4.png"></div>
	            <div class="pdcont jz630">
	                <img class="wz swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/wz4.png">
	            </div>
	        </div>
	        <div class="swiper-slide" style="background-image: url(http://img1.wenhuayun.cn/pdlibraryStatic/bg4.png);">
	            <div class="pdtit jz630"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tit4.png"></div>
	            <div class="pdcont jz630">
	                <ul class="pdtupic clearfix">
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu19.png" width="301" height="181"></div>
	                        <div class="char">读书节授书活动</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu20.png" width="301" height="181"></div>
	                        <div class="char">讲座进行时</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu21.png" width="301" height="181"></div>
	                        <div class="char">暑假中的少儿馆一角</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu22.png" width="301" height="181"></div>
	                        <div class="char">暑期志愿者在行动</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu23.png" width="301" height="181"></div>
	                        <div class="char">在镇公园内举办猜谜活动</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu24.png" width="301" height="181"></div>
	                        <div class="char">读报小组正在活动</div>
	                    </li>
	                </ul>
	            </div>
	        </div>
	
	        <div class="swiper-slide" style="background-image: url(http://img1.wenhuayun.cn/pdlibraryStatic/bg5.png);">
	            <div class="pdtit jz630"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tit5.png"></div>
	            <div class="pdcont jz630">
	                <img class="wz swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/wz5.png">
	            </div>
	        </div>
	        <div class="swiper-slide" style="background-image: url(http://img1.wenhuayun.cn/pdlibraryStatic/bg5.png);">
	            <div class="pdtit jz630"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tit5.png"></div>
	            <div class="pdcont jz630">
	                <ul class="pdtupic clearfix">
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu25.png" width="301" height="181"></div>
	                        <div class="char">畅想迪士尼儿童画<br>大赛获奖作品展览</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu26.png" width="301" height="181"></div>
	                        <div class="char">送书进军营活动</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu27.png" width="301" height="181"></div>
	                        <div class="char">夕阳美读书小组活动</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu28.png" width="301" height="181"></div>
	                        <div class="char">写作梦想—名家名作进校园</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu29.png" width="301" height="181"></div>
	                        <div class="char">学说上海话讲座</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu30.png" width="301" height="181"></div>
	                        <div class="char">迎六一向工友学校赠书</div>
	                    </li>
	                </ul>
	            </div>
	        </div>
	
	        <div class="swiper-slide" style="background-image: url(http://img1.wenhuayun.cn/pdlibraryStatic/bg6.png);">
	            <div class="pdtit jz630"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tit6.png"></div>
	            <div class="pdcont jz630">
	                <img class="wz swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/wz6.png">
	            </div>
	        </div>
	        <div class="swiper-slide" style="background-image: url(http://img1.wenhuayun.cn/pdlibraryStatic/bg6.png);">
	            <div class="pdtit jz630"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tit6.png"></div>
	            <div class="pdcont jz630">
	                <ul class="pdtupic clearfix">
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu31.png" width="301" height="181"></div>
	                        <div class="char">诗歌培训</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu32.png" width="301" height="181"></div>
	                        <div class="char">馆铭牌</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu33.png" width="301" height="181"></div>
	                        <div class="char">暑期活动</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu34.png" width="301" height="181"></div>
	                        <div class="char">推广特色“鸟哨”培训</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu35.png" width="301" height="181"></div>
	                        <div class="char">延伸服务部队送书</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu36.png" width="301" height="181"></div>
	                        <div class="char">元宵猜灯谜活动</div>
	                    </li>
	                </ul>
	            </div>
	        </div>
	
	        <div class="swiper-slide" style="background-image: url(http://img1.wenhuayun.cn/pdlibraryStatic/bg7.png);">
	            <div class="pdtit jz630"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tit7.png"></div>
	            <div class="pdcont jz630">
	                <img class="wz swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/wz7.png">
	            </div>
	        </div>
	        <div class="swiper-slide" style="background-image: url(http://img1.wenhuayun.cn/pdlibraryStatic/bg7.png);">
	            <div class="pdtit jz630"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tit7.png"></div>
	            <div class="pdcont jz630">
	                <ul class="pdtupic clearfix">
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu37.png" width="301" height="181"></div>
	                        <div class="char">少年馆</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu38.png" width="301" height="181"></div>
	                        <div class="char">传承沪语文化，学说沪语童谣<br>南码头社区少儿沪语童谣比赛</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu39.png" width="301" height="181"></div>
	                        <div class="char">读者借阅</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu40.png" width="301" height="181"></div>
	                        <div class="char">给消防官兵上门送书</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu41.png" width="301" height="181"></div>
	                        <div class="char">图书馆馆貌</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu42.png" width="301" height="181"></div>
	                        <div class="char">新交规知识竞赛</div>
	                    </li>
	                </ul>
	            </div>
	        </div>
	
	        <div class="swiper-slide" style="background-image: url(http://img1.wenhuayun.cn/pdlibraryStatic/bg8.png);">
	            <div class="pdtit jz630"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tit8.png"></div>
	            <div class="pdcont jz630">
	                <img class="wz swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/wz8.png">
	            </div>
	        </div>
	        <div class="swiper-slide" style="background-image: url(http://img1.wenhuayun.cn/pdlibraryStatic/bg8.png);">
	            <div class="pdtit jz630"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tit8.png"></div>
	            <div class="pdcont jz630">
	                <ul class="pdtupic clearfix">
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu43.png" width="301" height="181"></div>
	                        <div class="char">获奖证书</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu44.png" width="301" height="181"></div>
	                        <div class="char">三林图书馆向镇残联赠送图书</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu45.png" width="301" height="181"></div>
	                        <div class="char">三林镇纪念建党95周年<br>青少年诗歌、散文朗诵比赛</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu46.png" width="301" height="181"></div>
	                        <div class="char">三林镇图书管理员培训班</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu47.png" width="301" height="181"></div>
	                        <div class="char">三林总馆及世博、杨思分馆照片</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu48.png" width="301" height="181"></div>
	                        <div class="char">暑期“小小火山学家”<br>少儿科普教育活动</div>
	                    </li>
	                </ul>
	            </div>
	        </div>
	
	        <div class="swiper-slide" style="background-image: url(http://img1.wenhuayun.cn/pdlibraryStatic/bg9.png);">
	            <div class="pdtit jz630"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tit9.png"></div>
	            <div class="pdcont jz630">
	                <img class="wz swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/wz9.png">
	            </div>
	        </div>
	        <div class="swiper-slide" style="background-image: url(http://img1.wenhuayun.cn/pdlibraryStatic/bg9.png);">
	            <div class="pdtit jz630"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tit9.png"></div>
	            <div class="pdcont jz630">
	                <ul class="pdtupic clearfix">
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu49.png" width="301" height="181"></div>
	                        <div class="char">今天我主讲主题活动</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu50.png" width="301" height="181"></div>
	                        <div class="char">诗歌朗诵大赛</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu51.png" width="301" height="181"></div>
	                        <div class="char">暑期少儿读书活动</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu52.png" width="301" height="181"></div>
	                        <div class="char">图书馆全景</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu53.png" width="301" height="181"></div>
	                        <div class="char">文化讲座</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu54.png" width="301" height="181"></div>
	                        <div class="char">心理健康讲座</div>
	                    </li>
	                </ul>
	            </div>
	        </div>
	
	        <div class="swiper-slide" style="background-image: url(http://img1.wenhuayun.cn/pdlibraryStatic/bg10.png);">
	            <div class="pdtit jz630"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tit10.png"></div>
	            <div class="pdcont jz630">
	                <img class="wz swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/wz10.png">
	            </div>
	        </div>
	        <div class="swiper-slide" style="background-image: url(http://img1.wenhuayun.cn/pdlibraryStatic/bg10.png);">
	            <div class="pdtit jz630"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tit10.png"></div>
	            <div class="pdcont jz630">
	                <ul class="pdtupic clearfix">
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu55.png" width="301" height="181"></div>
	                        <div class="char">馆内书架</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu56.png" width="301" height="181"></div>
	                        <div class="char">书院人家分馆少儿阅览区</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu57.png" width="301" height="181"></div>
	                        <div class="char">文化服务中心领导给农民工送书</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu58.png" width="301" height="181"></div>
	                        <div class="char">特色活动“相约星期二”<br>民间草根书法练习</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu59.png" width="301" height="181"></div>
	                        <div class="char">中久村“严妈妈”<br>读报小组开展活动</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu60.png" width="301" height="181"></div>
	                        <div class="char">少儿阅读活动-绘本“悦”读<br>《猜猜我有多爱你》</div>
	                    </li>
	                </ul>
	            </div>
	        </div>
	
	        <div class="swiper-slide" style="background-image: url(http://img1.wenhuayun.cn/pdlibraryStatic/bg11.png);">
	            <div class="pdtit jz630"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tit11.png"></div>
	            <div class="pdcont jz630">
	                <img class="wz swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/wz11.png">
	            </div>
	        </div>
	        <div class="swiper-slide" style="background-image: url(http://img1.wenhuayun.cn/pdlibraryStatic/bg11.png);">
	            <div class="pdtit jz630"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tit11.png"></div>
	            <div class="pdcont jz630">
	                <ul class="pdtupic clearfix">
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu61.png" width="301" height="181"></div>
	                        <div class="char">唐镇“小青蛙”故事大赛</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu62.png" width="301" height="181"></div>
	                        <div class="char">荣誉证书</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu63.png" width="301" height="181"></div>
	                        <div class="char">奖状</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu64.png" width="301" height="181"></div>
	                        <div class="char">图书馆</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu65.png" width="301" height="181"></div>
	                        <div class="char">场馆</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu66.png" width="301" height="181"></div>
	                        <div class="char">讲故事</div>
	                    </li>
	                </ul>
	            </div>
	        </div>
	
	        <div class="swiper-slide" style="background-image: url(http://img1.wenhuayun.cn/pdlibraryStatic/bg12.png);">
	            <div class="pdtit jz630"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tit12.png"></div>
	            <div class="pdcont jz630">
	                <img class="wz swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/wz12.png">
	            </div>
	        </div>
	        <div class="swiper-slide" style="background-image: url(http://img1.wenhuayun.cn/pdlibraryStatic/bg12.png);">
	            <div class="pdtit jz630"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tit12.png"></div>
	            <div class="pdcont jz630">
	                <ul class="pdtupic clearfix">
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu67.png" width="301" height="181"></div>
	                        <div class="char">仁济讲坛活动</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu68.png" width="301" height="181"></div>
	                        <div class="char">图书馆内景</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu69.png" width="301" height="181"></div>
	                        <div class="char">图书小管家活动</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu70.png" width="301" height="181"></div>
	                        <div class="char">向浦东新区残疾人<br>合唱团赠送书籍</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu71.png" width="301" height="181"></div>
	                        <div class="char">元宵灯谜活会</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu72.png" width="301" height="181"></div>
	                        <div class="char">中央委员、文化部部长雒树刚<br>调研图书馆</div>
	                    </li>
	                </ul>
	            </div>
	        </div>
	
	        <div class="swiper-slide" style="background-image: url(http://img1.wenhuayun.cn/pdlibraryStatic/bg13.png);">
	            <div class="pdtit jz630"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tit13.png"></div>
	            <div class="pdcont jz630">
	                <img class="wz swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/wz13.png">
	            </div>
	        </div>
	        <div class="swiper-slide" style="background-image: url(http://img1.wenhuayun.cn/pdlibraryStatic/bg13.png);">
	            <div class="pdtit jz630"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tit13.png"></div>
	            <div class="pdcont jz630">
	                <ul class="pdtupic clearfix">
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu73.png" width="301" height="181"></div>
	                        <div class="char">诵读大赛</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu74.png" width="301" height="181"></div>
	                        <div class="char">建党90周年演讲</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu75.png" width="301" height="181"></div>
	                        <div class="char">青少年防范知识讲座</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu76.png" width="301" height="181"></div>
	                        <div class="char">学生手工/纸艺</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu77.png" width="301" height="181"></div>
	                        <div class="char">送图书</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu78.png" width="301" height="181"></div>
	                        <div class="char">送书进合作社<br>引导农民科学养殖种植</div>
	                    </li>
	                </ul>
	            </div>
	        </div>
	
	        <div class="swiper-slide" style="background-image: url(http://img1.wenhuayun.cn/pdlibraryStatic/bg14.png);">
	            <div class="pdtit jz630"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tit14.png"></div>
	            <div class="pdcont jz630">
	                <img class="wz swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/wz14.png">
	            </div>
	        </div>
	        <div class="swiper-slide" style="background-image: url(http://img1.wenhuayun.cn/pdlibraryStatic/bg14.png);">
	            <div class="pdtit jz630"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tit14.png"></div>
	            <div class="pdcont jz630">
	                <ul class="pdtupic clearfix">
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu79.png" width="301" height="181"></div>
	                        <div class="char">“我是汉字王“活动</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu80.png" width="301" height="181"></div>
	                        <div class="char">烘焙活动</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu81.png" width="301" height="181"></div>
	                        <div class="char">少儿读者活动</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu82.png" width="301" height="181"></div>
	                        <div class="char">送春联</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu83.png" width="301" height="181"></div>
	                        <div class="char">宣桥养老院</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu84.png" width="301" height="181"></div>
	                        <div class="char">志愿者活动</div>
	                    </li>
	                </ul>
	            </div>
	        </div>
	
	        <div class="swiper-slide" style="background-image: url(http://img1.wenhuayun.cn/pdlibraryStatic/bg15.png);">
	            <div class="pdtit jz630"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tit15.png"></div>
	            <div class="pdcont jz630">
	                <img class="wz swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/wz15.png">
	            </div>
	        </div>
	        <div class="swiper-slide" style="background-image: url(http://img1.wenhuayun.cn/pdlibraryStatic/bg15.png);">
	            <div class="pdtit jz630"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tit15.png"></div>
	            <div class="pdcont jz630">
	                <ul class="pdtupic clearfix">
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu85.png" width="301" height="181"></div>
	                        <div class="char">小读者正在挑选灯谜</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu86.png" width="301" height="181"></div>
	                        <div class="char">捐献图书的小读者正在挑选绿植</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu87.png" width="301" height="181"></div>
	                        <div class="char">”书香张江 幸福家庭”<br>书袋漂流活动</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu88.png" width="301" height="181"></div>
	                        <div class="char">暑期经典电影放映</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu89.png" width="301" height="181"></div>
	                        <div class="char">“作家教你写作文“讲座</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu90.png" width="301" height="181"></div>
	                        <div class="char">暑期“图书小管家”<br>小志愿者活动</div>
	                    </li>
	                </ul>
	            </div>
	        </div>
	
	        <div class="swiper-slide" style="background-image: url(http://img1.wenhuayun.cn/pdlibraryStatic/bg16.png);">
	            <div class="pdtit jz630"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tit16.png"></div>
	            <div class="pdcont jz630">
	                <img class="wz swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/wz16.png">
	            </div>
	        </div>
	        <div class="swiper-slide" style="background-image: url(http://img1.wenhuayun.cn/pdlibraryStatic/bg16.png);">
	            <div class="pdtit jz630"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tit16.png"></div>
	            <div class="pdcont jz630">
	                <ul class="pdtupic clearfix">
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu91.png" width="301" height="181"></div>
	                        <div class="char">暑期和实验学校<br>大手牵小手悦读活动</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu92.png" width="301" height="181"></div>
	                        <div class="char">延伸服务与阳光之家儿童<br>参观图书馆和展厅</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu93.png" width="301" height="181"></div>
	                        <div class="char">元宵少儿环保袋绘画比赛活动</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu94.png" width="301" height="181"></div>
	                        <div class="char">阅读推广活动</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu95.png" width="301" height="181"></div>
	                        <div class="char">周家渡图书馆少儿室</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu96.png" width="301" height="181"></div>
	                        <div class="char">专家义诊活动</div>
	                    </li>
	                </ul>
	            </div>
	        </div>
	
	        <div class="swiper-slide" style="background-image: url(http://img1.wenhuayun.cn/pdlibraryStatic/bg17.png);">
	            <div class="pdtit jz630"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tit17.png"></div>
	            <div class="pdcont jz630">
	                <img class="wz swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/wz17.png">
	            </div>
	        </div>
	        <div class="swiper-slide" style="background-image: url(http://img1.wenhuayun.cn/pdlibraryStatic/bg17.png);">
	            <div class="pdtit jz630"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tit17.png"></div>
	            <div class="pdcont jz630">
	                <ul class="pdtupic clearfix">
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu97.png" width="301" height="181"></div>
	                        <div class="char">2015年暑期儿童画现场展示</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu98.png" width="301" height="181"></div>
	                        <div class="char">傅雷杯2015年上海市中小学生<br>国际跳棋锦标赛</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu99.png" width="301" height="181"></div>
	                        <div class="char">暑期电子小报制作比赛颁奖</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu100.png" width="301" height="181"></div>
	                        <div class="char">银发乐老人成果展</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu101.png" width="301" height="181"></div>
	                        <div class="char">周浦文化服务中心照片</div>
	                    </li>
	                    <li>
	                        <div class="pic"><img class="swiper-lazy" data-src="http://img1.wenhuayun.cn/pdlibraryStatic/tu102.png" width="301" height="181"></div>
	                        <div class="char">周浦镇图书馆外借窗口</div>
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
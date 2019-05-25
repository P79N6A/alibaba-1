<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%
    String path = request.getContextPath();
    request.setAttribute("path", path);
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
    request.setAttribute("basePath", basePath);
    String error = request.getParameter("error");
    request.setAttribute("error", error);
%>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"/>
	<meta name="format-detection" content="telephone=no"/>
	<meta name="apple-mobile-web-app-capable" content="yes"/>
	<meta name="apple-mobile-web-app-status-bar-style" content="black"/>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/normalize.css"/>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/ui-dialog.css"/>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/swiper-3.3.1.min.css"/>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/animate.min.css"/>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<script type="text/javascript" src="${path}/STATIC/wxStatic/js/jquery-2.1.4.min.js"></script>
	<script type="text/javascript" src="${path}/STATIC/wechat/js/dialog-min.js"></script>
	<script type="text/javascript" src="${path}/STATIC/wxStatic/js/swiper-3.3.1.jquery.min.js"></script>
	<script type="text/javascript" src="${path}/STATIC/wxStatic/js/swiper.animate1.0.2.min.js"></script>
	<script type="text/javascript" src="${path}/STATIC/wechat/js/wechat-util.js"></script>
	<script type="text/javascript" src="${path}/STATIC/wechat/js/jweixin-1.2.0.js"></script>
	<script src="${path}/STATIC/js/common.js"></script>
	<title>佛山文化云·上海电影节全攻略</title>
	
	<script type="text/javascript">
		var phoneWidth = parseInt(window.screen.width);
		var phoneScale = phoneWidth / 750;
		var ua = navigator.userAgent; //浏览器类型
		if (/Android (\d+\.\d+)/.test(ua)) { //判断是否是安卓系统
			var version = parseFloat(RegExp.$1); //安卓系统的版本号
			if (version > 2.3) {
				document.write('<meta name="viewport" content="width=750,user-scalable=no, minimum-scale = ' + phoneScale + ', maximum-scale = ' + (phoneScale) + ', target-densitydpi=device-dpi">');
			} else {
				document.write('<meta name="viewport" content="width=750,user-scalable=no, target-densitydpi=device-dpi">');
			}
		} else {
			document.write('<meta name="viewport" content="width=750,user-scalable=no, target-densitydpi=device-dpi">');
		}
	</script>
	
	<script>
		var userId = '${sessionScope.terminalUser.userId}';
		var movies_url = '${url}';	//本页相对路径
		var error = '${error}';
		
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
					title: "不能不看的2016上海电影节全攻略",
					desc: '最全的排片表；一手影讯；VR展全球首发体验团...不收藏就错过了！',
					link: '${path}/muser/login.do?type=' + movies_url,
					imgUrl: '${basePath}/STATIC/wxStatic/image/movies.jpg'
				});
				wx.onMenuShareTimeline({
					title: "不能不看的2016上海电影节全攻略",
					imgUrl: '${basePath}/STATIC/wxStatic/image/movies.jpg',
					link: '${path}/muser/login.do?type=' + movies_url
				});
				wx.onMenuShareQQ({
					title: "不能不看的2016上海电影节全攻略",
					desc: '最全的排片表；一手影讯；VR展全球首发体验团...不收藏就错过了！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/movies.jpg'
				});
				wx.onMenuShareWeibo({
					title: "不能不看的2016上海电影节全攻略",
					desc: '最全的排片表；一手影讯；VR展全球首发体验团...不收藏就错过了！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/movies.jpg'
				});
				wx.onMenuShareQZone({
					title: "不能不看的2016上海电影节全攻略",
					desc: '最全的排片表；一手影讯；VR展全球首发体验团...不收藏就错过了！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/movies.jpg'
				});
			});
		}
		
		$(function () {
			if(error=="loginFail"){
				dialogAlert('登录失败', '请重试或通过其他方式登录！');
			}
			
          	//分享
			$(".header-button2").click(function() {
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
			$(".header-button1").on("touchstart", function() {
				$('.div-share').show()
				$("body,html").addClass("bg-notouch")
			})
            
		});
		
	</script>
	<style>
		.swiper-button-next, .swiper-button-prev{
			top:36%!important;
			width: 70px!important;
    		height: 110px!important;
		}
	</style>
</head>

<body>
	<div class="main">
		<!-- 方便分享自动抓取 -->
		<div style="display: none;"><img src="${path}/STATIC/wxStatic/image/movies.jpg"/></div>
		<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
			<img src="${path}/STATIC/wxStatic/image/fx-bg.png" style="width: 100%;height: 100%;" />
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
		<div class="header">
			<div class="header-logo">
				<img src="${path}/STATIC/wxStatic/image/logo2.png" />
			</div>
			<div class="header-button1">
				<img src="${path}/STATIC/wxStatic/image/keep2.png" />
			</div>
			<div class="header-button2">
				<img src="${path}/STATIC/wxStatic/image/share2.png" />
			</div>
			<div style="clear: both;"></div>
		</div>
		<div class="content">
			<div class="content-top">
				<img src="${path}/STATIC/wxStatic/image/dyjtitle.jpg" />
				<!--<div class="content-top-title1">
					<p>什么样的孩子最快乐</p>
					<div class="content-top-title2">
						<p>你好“六&bull;一”</p>
					</div>
					<div class="border-line-left"></div>
					<div class="border-line-right"></div>
					<div class="content-top-title3">
						<p>云叔永远三岁</p>
					</div>
				</div>-->
			</div>
			<div class="sw-title">
				<p>&mdash;&nbsp;国际影讯&nbsp;&mdash;</p>
			</div>
			<div class="swiper-container swiper-container3">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<a href="${path}/information/preInfo.do?informationId=9e79e28bbe6d40b49930f335cd2bc872">
							<img src="${path}/STATIC/wxStatic/image/brcgddgdy.jpg" />
							<div class="a-p2">
								<p class="p1">不容错过的德国剧情片</p>
								<p class="p2">看完只想呆呆的坐着</p>
								<div class="a-p-bt">查看</div>
							</div>
							<div class="aimg-top2">
								<div class="aimg-font2">
									<p>魔幻剧情</p>
								</div>
							</div>
						</a>
					</div>
					<div class="swiper-slide">
						<a href="${path}/information/preInfo.do?informationId=d71d8b275be14920a7c1b8fdd8e9b706">
							<img src="${path}/STATIC/wxStatic/image/fg.jpg" />
							<div class="a-p2">
								<p class="p1">展现优雅法国风情</p>
								<p class="p2">在你耳边诉说一段段情话</p>
								<div class="a-p-bt">查看</div>
							</div>
							<div class="aimg-top2">
								<div class="aimg-font2">
									<p>法国风情</p>
								</div>
							</div>
						</a>
					</div>
					<div class="swiper-slide">
						<a href="${path}/information/preInfo.do?informationId=e1590987b25f417f8018a4c818673293">
							<img src="${path}/STATIC/wxStatic/image/rbdy.jpg" />
							<div class="a-p2">
								<p class="p1">温暖而治愈的日系回忆</p>
								<p class="p2">多少青春记忆与TA有关</p>
								<div class="a-p-bt">查看</div>
							</div>
							<div class="aimg-top2">
								<div class="aimg-font2">
									<p>精选日系</p>
								</div>
							</div>
						</a>
					</div>
					<div class="swiper-slide">
						<a href="${path}/information/preInfo.do?informationId=409d5b0bad904c8492c6bd63f4804197">
							<img src="${path}/STATIC/wxStatic/image/tgdy.jpg" />
							<div class="a-p2">
								<p class="p1">充满荷尔蒙的泰式电影</p>
								<p class="p2">有一种文艺叫泰国小清新</p>
								<div class="a-p-bt">查看</div>
							</div>
							<div class="aimg-top2">
								<div class="aimg-font2">
									<p>细腻泰式</p>
								</div>
							</div>
						</a>
					</div>
					<div class="swiper-slide">
						<a href="${path}/information/preInfo.do?informationId=10b8660185f842a9bed54ea157f2edf0">
							<img src="${path}/STATIC/wxStatic/image/hgdy.jpg" />
							<div class="a-p2">
								<p class="p1">热爱真理与理想的韩国电影</p>
								<p class="p2">带你体验真实的世界</p>
								<div class="a-p-bt">查看</div>
							</div>
							<div class="aimg-top2">
								<div class="aimg-font2">
									<p>欧巴&欧尼在等你</p>
								</div>
							</div>
						</a>
					</div>
				</div>
				<div class="swiper-button-prev swiper-button-white"></div>
				<div class="swiper-button-next swiper-button-white"></div>
			</div>
			<div class="sw-title">
				<p>&mdash;&nbsp;VR乐园&nbsp;&mdash;</p>
			</div>
			<div class="swiper-container swiper-container4">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<a href="${path}/information/preInfo.do?informationId=4d8be4731ccb4016bdcd13a05f619449">
							<img src="${path}/STATIC/wxStatic/image/VR.jpg" />
							<div class="a-p2">
								<p class="p1">不懂VR你就OUT啦</p>
								<p class="p2">云叔可以带你飞</p>
								<div class="a-p-bt">查看</div>
							</div>
							<div class="aimg-top2">
								<div class="aimg-font2">
									<p>创·视纪</p>
								</div>
							</div>
						</a>
					</div>
				</div>
				<!--<div class="swiper-button-prev swiper-button-white"></div>
				<div class="swiper-button-next swiper-button-white"></div>-->
			</div>
			<div class="sw-title">
				<p>&mdash;&nbsp;向大师致敬&nbsp;&mdash;</p>
			</div>
			<div class="swiper-container swiper-container5">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<a href="${path}/information/preInfo.do?informationId=d9477d20f6c24481bdb097d0b5280ac0">
							<img src="${path}/STATIC/wxStatic/image/jnzgr.jpg" />
							<div class="a-p2">
								<p class="p1">我们都爱张国荣</p>
								<p class="p2">哥哥永远活在最美丽的年纪</p>
								<div class="a-p-bt">查看</div>
							</div>
							<div class="aimg-top2">
								<div class="aimg-font2">
									<p>历数哥哥经典时刻</p>
								</div>
							</div>
						</a>
					</div>
					<div class="swiper-slide">
						<a href="${path}/information/preInfo.do?informationId=b132e8586cef4ec98622b201cfd3645f">
							<img src="${path}/STATIC/wxStatic/image/xdszj.jpg" />
							<div class="a-p2">
								<p class="p1">伍迪·艾伦和他的眼镜</p>
								<p class="p2">这个疯子谁能不爱?</p>
								<div class="a-p-bt">查看</div>
							</div>
							<div class="aimg-top2">
								<div class="aimg-font2">
									<p>伍迪·艾伦力作</p>
								</div>
							</div>
						</a>
					</div>
				</div>
				<div class="swiper-button-prev swiper-button-white"></div>
				<div class="swiper-button-next swiper-button-white"></div>
			</div>
			<div class="sw-title">
				<p>&mdash;&nbsp;莎翁经典&nbsp;&mdash;</p>
			</div>
			<div class="swiper-container swiper-container6">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<a href="${path}/information/preInfo.do?informationId=9943e86e3c824b48859b5435a979da09">
							<img src="${path}/STATIC/wxStatic/image/swfm.jpg" />
							<div class="a-p2">
								<p class="p1">莎翁是世间最大的情圣</p>
								<p class="p2">伴着你成长 伴着他暮色</p>
								<div class="a-p-bt">查看</div>
							</div>
							<div class="aimg-top2">
								<div class="aimg-font2">
									<p>经典莎士比亚重现</p>
								</div>
							</div>
						</a>
					</div>

				</div>
				<!--<div class="swiper-button-prev swiper-button-white"></div>
				<div class="swiper-button-next swiper-button-white"></div>-->
			</div>
		</div>
		<div style = "text-align:center;margin-top:20px;">
		<img  src="${path}/STATIC/image/advice_img.png" width="680" height="375"/>
		 <div style = "margin:40px 20px 20px;padding:20px;border-top:1px solid #262626;text-align:right!important;font-size: 26px;color: #7C7C7C;">文化云出品</div>
		
		</div>
	</div>

	<script type="text/javascript">
		$(document).ready(function() {
			//顶部菜单显示隐藏
			$(window).scroll(function() {
				if ($(document).scrollTop() > 100) {
					$(".header").css("top", "0px")
				} else {
					$(".header").css("top", "-100px")
				}
			})
		});
		
		//swiper1初始化
		var mySwiper = new Swiper('.swiper-container3', {
				slidesPerView: 1,
				paginationClickable: true,
				spaceBetween: 20,
				freeMode: false,
				prevButton: '.swiper-button-prev',
				nextButton: '.swiper-button-next',
		})
		//swiper2初始化
		var mySwiper = new Swiper('.swiper-container4', {
				slidesPerView: 1,
				paginationClickable: true,
				spaceBetween: 20,
				freeMode: false,
		})
		//swiper3初始化
		var mySwiper = new Swiper('.swiper-container5', {
			slidesPerView: 1,
			paginationClickable: true,
			spaceBetween: 20,
			freeMode: false,
			prevButton: '.swiper-button-prev',
			nextButton: '.swiper-button-next',
		})
		//swiper4初始化
		var mySwiper = new Swiper('.swiper-container6', {
			slidesPerView: 1,
			paginationClickable: true,
			spaceBetween: 20,
			freeMode: false,
		})
	</script>
	
	<!-- 导入统计文件 -->
	<script type="text/javascript" src="${path}/stat/stat.js"></script>
	<%@include file="/WEB-INF/why/wechat/wechat_statistics.jsp"%>
</body>
</html>
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
%>
	<head lang="en">
		<meta charset="UTF-8"/>
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
		<title>文化云--文化安康云</title>
		<link rel="stylesheet" type="text/css" href="${path}/STATIC/html/css/reset.css" />
		<link rel="stylesheet" type="text/css" href="${path}/STATIC/html/css/style.css" />
		<script type="text/javascript" src="${path}/STATIC/html/js/jquery.min.js"></script>
		<script type="text/javascript" src="${path}/STATIC/html/js/scroll.js"></script>
		<script type="text/javascript" src="${path}/STATIC/wechat/js/jweixin-1.2.0.js"></script>
		
		<!--移动端版本兼容 -->
		<script type="text/javascript">
			var phoneWidth = parseInt(window.screen.width);
			var phoneScale = phoneWidth / 750;
			var ua = navigator.userAgent; //浏览器类型
			if (/Android (\d+\.\d+)/.test(ua)) { //判断是否是安卓系统
				var version = parseFloat(RegExp.$1); //安卓系统的版本号
				if (version > 2.3) {
					document.write('<meta name="viewport" content="width=750, minimum-scale = ' + phoneScale + ', maximum-scale = ' + (phoneScale) + ', target-densitydpi=device-dpi">');
				} else {
					document.write('<meta name="viewport" content="width=750, target-densitydpi=device-dpi">');
				}
			} else {
				document.write('<meta name="viewport" content="width=750, user-scalable=yes, target-densitydpi=device-dpi">');
			}
		</script>
		<!--移动端版本兼容 end -->
		
		<script>
			$(function () {
				//通过config接口注入权限验证配置
	            wx.config({
	                debug: false,
	                appId: '${sign.appId}',
	                timestamp: '${sign.timestamp}',
	                nonceStr: '${sign.nonceStr}',
	                signature: '${sign.signature}',
	                jsApiList: ['onMenuShareAppMessage','onMenuShareTimeline']
	            });
	            wx.ready(function () {
	            	wx.onMenuShareAppMessage({
	            		title: "安康文化云--文化安康云",
	                    desc: 'Hi~\r\n畅享"文化生活"新体验!\r\n引领"文化生活"最前沿!\r\n···',
	                    imgUrl: '${basePath}/STATIC/html/images/logo2.jpg'
	                });
	            	wx.onMenuShareTimeline({
	                    title: "安康文化云--文化安康云",
	                    imgUrl: '${basePath}/STATIC/html/images/logo2.jpg'
	                });
	            });
			});
		</script>
		
	</head>
	<body>
		<div class="header clearfix">
			<div class="logo fl"><img src="${path}/STATIC/html/images/logo.png" width="95" height="80"></div>
			<div class="txt fr">畅享文化生活新体验</div>
		</div>
		<div class="content">
			<div class="b_cloud"></div>
			<div id="list">
				<div class="links links_one"><span>文化安康云<br>来了</span><em></em></div>
				<div class="links links_two"><span>关注我们</span><em></em></div>
				<div class="links links_three"><span>关于创图</span><em></em></div>
				<div class="links links_four"><span>文化云<br>是什么</span><em></em></div>
				<div class="s_cloud"></div>
				<div class="ball_bg">
					<div class="ball"><img src="${path}/STATIC/html/images/ball-bg.png"></div>
				</div>
				<div class="iphone">
					<div class="fix_img">
						<a href="http://hs.hb.wenhuayun.cn/wechat/index.do"><img src="${path}/STATIC/html/images/fixed.png" width="170" height="83"></a>
					</div>
					<div class="list_lh">
						<ul>
							<li>
								<a href="http://hs.hb.wenhuayun.cn/wechat/index.do"><img src="${path}/STATIC/html/images/scroll_2.png"></a>
							</li>
							<li>
								<a href="http://hs.hb.wenhuayun.cn/wechat/index.do"><img src="${path}/STATIC/html/images/scroll_3.png"></a>
							</li>
							<li>
								<a href="http://hs.hb.wenhuayun.cn/wechat/index.do"><img src="${path}/STATIC/html/images/scroll_4.png"></a>
							</li>
							<li>
								<a href="http://hs.hb.wenhuayun.cn/wechat/index.do"><img src="${path}/STATIC/html/images/scroll_5.png"></a>
							</li>
							<li>
								<a href="http://hs.hb.wenhuayun.cn/wechat/index.do"><img src="${path}/STATIC/html/images/scroll_6.png"></a>
							</li>
							<li>
								<a href="http://hs.hb.wenhuayun.cn/wechat/index.do"><img src="${path}/STATIC/html/images/scroll_7.png"></a>
							</li>
							<li>
								<a href="http://hs.hb.wenhuayun.cn/wechat/index.do"><img src="${path}/STATIC/html/images/scroll_8.png"></a>
							</li>
							<li>
								<a href="http://hs.hb.wenhuayun.cn/wechat/index.do"><img src="${path}/STATIC/html/images/scroll_9.png"></a>
							</li>
							<li>
								<a href="http://hs.hb.wenhuayun.cn/wechat/index.do"><img src="${path}/STATIC/html/images/scroll_10.png"></a>
							</li>
							<li>
								<a href="http://hs.hb.wenhuayun.cn/wechat/index.do"><img src="${path}/STATIC/html/images/scroll_11.png"></a>
							</li>
						</ul>
					</div>
				</div>
				<div class="why_txt"><a href="#">www.wenhuayun.cn</a></div>
			</div>
		</div>
		<script type="text/javascript">
			$(function() {
				$(".links").addClass("link_me");
				setTimeout(function() {
					$(".links").removeClass("link_me").addClass("link_me");
				}, 1000)
			})
		</script>
		<div class="fixbg"></div>
		<!--文化安康云来了-->
		<div class="dialog_one">
			<p>3月26日，全国首个实现省级区域全覆盖的公共文化数字化服务平台——“文化上海云”于市民文化节开幕式上正式上线。</p>
			<p>覆盖全市的370多家市级、区县、街道乡镇三级的文化馆、图书馆、展览馆、美术馆、文化服务中心,通过互联网融合为一朵文化云，每月在线活动数4000多条，用户只需点开文化云手机软件，便可享受便捷、丰富、精彩的公共文化服务。</p>
			</p>
		</div>
		<div class="dialog_two">
			<ul class="clearfix">
				<li><span>创图公众号</span><img src="${path}/STATIC/html/images/num1.png" width="213" height="213"><em>关注创图</em></li>
				<li><span>文化云公众号</span><img src="${path}/STATIC/html/images/num2.png" width="213" height="213"><em>关注文化云</em></li>
			</ul>
		</div>
		<!--关于创图-->
		<div class="dialog_three">
			<p>创图科技是全国公共数字文化服务平台建设&运营领军企业</p>
			<p>1. 全国唯一承担公共数字文化服务国家重点科技支撑计划企业</p>
			<p>2015年承担国家文化部、科技部科技支撑计划项目-文化云服务平台关键技术研发及应用示范。</p>
			<p>2. 全国第一个省级公共数字文化服务平台建设运营企业</p>
			<p>2013年开始建设，互联网+公共文化服务—文化上海云。此外还与银川、马鞍山、中山、石河子30多个地级市广泛合作共建数字公共文化服务平台。</p>
			<p>3.网上世博会VR唯一核心技术提供商</p>
			<p>2010年开创性打造“永不落幕世博会”——网上世博会，始创身临其境的虚拟互动体验，180天之内达成7亿访问量。</p>
		</div>
		<div class="dialog_four">
			<p>“文化云”公共文化服务创新模式是通过构建文化云服务平台，汇聚全区域公共文化资源，整合信息孤岛，为区域内群众提供一站式公共文化服务入口；通过构建文化云服务平台线下互动连接系统，实现线下服务与线上服务互联互通；通过构建文化云服务平台管理系统，实现管理与服务的融合，实现公共文化效能的最大化。</p>
			<p>市民通过“文化云”手机App就解决了公共文化服务体系中的“我要知道、我要参与、我要评论、我要互动”等诸多问题。“文化云”不仅可以帮助你快速找到附近包括讲座、亲子活动、戏曲、电影观摩等大量免费、公益的公共文化活动，同时还能直接预约参加；还可以免费预订、使用全市公共文化场馆的场地设施。方便、快捷、公益，是“文化云”带给每个用户最直观的感受。</p>
		</div>
        <div class="bottom"><img src="${path}/STATIC/html/images/bottom.png"></div>
       
		<script>
			$(document).ready(function() {
				$(".fixbg").click(function() {
					$(".fixbg,.dialog_one,.dialog_two,.dialog_three,.dialog_four").css("display", "none")
				})
				$(".links_one").click(function() {
					$(".fixbg").css("display", "block")
					$(".dialog_one").css("display", "block")
				})
				$(".links_two").click(function() {
					$(".fixbg").css("display", "block")
					$(".dialog_two").css("display", "block")
				})
				$(".links_three").click(function() {
					$(".fixbg").css("display", "block")
					$(".dialog_three").css("display", "block")
				})
				$(".links_four").click(function() {
					$(".fixbg").css("display", "block")
					$(".dialog_four").css("display", "block")
				})
			})
		</script>
		<script type="text/javascript">
			$(function() {
				$("div.list_lh").myScroll({
					speed: 40, //数值越大，速度越慢
					rowHeight: 144 //li的高度
				});
			});
		</script>
		<script type="text/javascript">
			$(function() {
				var $s_width = window.screen.width;
				if ($s_width > 750) {
					$('.fix_img a,.list_lh ul li a').attr('href', 'http://www.wenhuayun.cn');
				} else {
					$('.fix_img a,.list_lh ul li a').attr('href', 'http://hs.hb.wenhuayun.cn/wechat/index.do');
				}
			})
		</script>
		<!-- 导入统计文件 -->
		<%@include file="/WEB-INF/why/wechat/wechat_statistics.jsp"%>
	</body>
</html>
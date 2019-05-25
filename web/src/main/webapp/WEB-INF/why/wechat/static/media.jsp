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
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/common.css">
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css">
	<script type="text/javascript" src="${path}/STATIC/wxStatic/js/jquery-2.1.4.min.js"></script>
	<script type="text/javascript" src="${path}/STATIC/wechat/js/wechat-util.js"></script>
	<script type="text/javascript" src="${path}/STATIC/wechat/js/jweixin-1.2.0.js"></script>
	<script src="${path}/STATIC/js/common.js"></script>
	<title>安康文化云·媒体矩阵</title>
	
	<script type="text/javascript">
		var phoneWidth = parseInt(window.screen.width);
		var phoneScale = phoneWidth / 750;
		var ua = navigator.userAgent; //浏览器类型
		if(/Android (\d+\.\d+)/.test(ua)) { //判断是否是安卓系统
			var version = parseFloat(RegExp.$1); //安卓系统的版本号
			if(version > 2.3) {
				document.write('<meta name="viewport" content="width=750,user-scalable=no, minimum-scale = ' + phoneScale + ', maximum-scale = ' + (phoneScale) + ', target-densitydpi=device-dpi">');
			} else {
				document.write('<meta name="viewport" content="width=750,user-scalable=no, target-densitydpi=device-dpi">');
			}
		} else {
			document.write('<meta name="viewport" content="width=750,user-scalable=no, target-densitydpi=device-dpi">');
		}
	</script>
	
	<script>
		
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
					title: "公共文化媒体联盟矩阵",
					desc: '文化云与之携手共筑公共文化事业',
					imgUrl: '${basePath}/STATIC/wechat/image/mediaList/shareIcon.png'
				});
				wx.onMenuShareTimeline({
					title: "公共文化媒体联盟矩阵",
					imgUrl: '${basePath}/STATIC/wechat/image/mediaList/shareIcon.png'
				});
				wx.onMenuShareQQ({
					title: "公共文化媒体联盟矩阵",
					desc: '文化云与之携手共筑公共文化事业',
					imgUrl: '${basePath}/STATIC/wechat/image/mediaList/shareIcon.png'
				});
				wx.onMenuShareWeibo({
					title: "公共文化媒体联盟矩阵",
					desc: '文化云与之携手共筑公共文化事业',
					imgUrl: '${basePath}/STATIC/wechat/image/mediaList/shareIcon.png'
				});
				wx.onMenuShareQZone({
					title: "公共文化媒体联盟矩阵",
					desc: '文化云与之携手共筑公共文化事业',
					imgUrl: '${basePath}/STATIC/wechat/image/mediaList/shareIcon.png'
				});
			});
		}
		
	</script>
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${path}/STATIC/wechat/image/mediaList/shareIcon.png"/></div>
	<div class="content bgfff padding-bottom0">
		<div class="list-main">
			<div class="list-content">
				<ul>
					<li>
						<a href="http://mp.weixin.qq.com/mp/getmasssendmsg?__biz=MzIyNTU2NzU3MA==#wechat_webview_type=1&wechat_redirect">
							<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201721517263j7CjcFrUmcSngeXBNnlwCnYEq5PRNg.png" />
					</li>
					<li>
						<a href="http://mp.weixin.qq.com/mp/getmasssendmsg?__biz=MzAwNzE2MjEwNA==#wechat_webview_type=1&wechat_redirect">
							<img src="${path}/STATIC/wechat/image/mediaList/logo1.png" />
					</li>
					</a>
					<li>
						<a href="http://mp.weixin.qq.com/mp/getmasssendmsg?__biz=MzA3MzQ5ODA2MA==#wechat_webview_type=1&wechat_redirect">
							<img src="${path}/STATIC/wechat/image/mediaList/logo2.png" />
					</li>
					</a>
					<li>
						<a href="http://mp.weixin.qq.com/mp/getmasssendmsg?__biz=MzA3ODA0ODA3OQ==#wechat_webview_type=1&wechat_redirect">
							<img src="${path}/STATIC/wechat/image/mediaList/logo3.png" />
					</li>
					</a>
					<li>
						<a href="http://mp.weixin.qq.com/mp/getmasssendmsg?__biz=MzI5NTE3ODIwNA==#wechat_webview_type=1&wechat_redirect">
							<img src="${path}/STATIC/wechat/image/mediaList/logo4.png" />
					</li>
					</a>
					<li>
						<a href="http://mp.weixin.qq.com/mp/getmasssendmsg?__biz=MzA5MTMyNzAwOA==#wechat_webview_type=1&wechat_redirect">
							<img src="${path}/STATIC/wechat/image/mediaList/logo5.png" />
					</li>
					</a>
					<li>
						<a href="http://mp.weixin.qq.com/mp/getmasssendmsg?__biz=MzA5NTI1MjYyNQ==#wechat_webview_type=1&wechat_redirect">
							<img src="${path}/STATIC/wechat/image/mediaList/logo6.png" />
					</li>
					</a>
					<li>
						<a href="http://mp.weixin.qq.com/mp/getmasssendmsg?__biz=MzI5NDE3NjYwMg==#wechat_webview_type=1&wechat_redirect">
							<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017217174153XapdlTRF4z9SR3PwPDRr05TkCMvDmx.png" />
					</li>
					</a>
					<li>
						<a href="http://mp.weixin.qq.com/mp/getmasssendmsg?__biz=MzA3OTQwNjcyNg==#wechat_webview_type=1&wechat_redirect">
							<img src="${path}/STATIC/wechat/image/mediaList/logo8.png" />
					</li>
					</a>
					<li>
						<a href="http://mp.weixin.qq.com/mp/getmasssendmsg?__biz=MzA3MzIwMjczOA==#wechat_webview_type=1&wechat_redirect">
							<img src="${path}/STATIC/wechat/image/mediaList/logo9.png" />
					</li>
					</a>
					<li>
						<a href="http://mp.weixin.qq.com/mp/getmasssendmsg?__biz=MzAxOTc5ODc5Ng==#wechat_webview_type=1&wechat_redirect">
							<img src="${path}/STATIC/wechat/image/mediaList/logo10.png" />
					</li>
					</a>
					<li>
						<a href="http://mp.weixin.qq.com/mp/getmasssendmsg?__biz=MjEwNDI4NTA2MQ==#wechat_webview_type=1&wechat_redirect">
							<img src="${path}/STATIC/wechat/image/mediaList/logo11.png" />
					</li>
					</a>
					<li>
						<a href="http://mp.weixin.qq.com/mp/getmasssendmsg?__biz=MzA5NTYwMDkyMw==#wechat_webview_type=1&wechat_redirect">
							<img src="${path}/STATIC/wechat/image/mediaList/logo12.png" />
					</li>
					</a>
					<li>
						<a href="http://mp.weixin.qq.com/mp/getmasssendmsg?__biz=MjM5NTM4MjcwOQ==#wechat_webview_type=1&wechat_redirect">
							<img src="${path}/STATIC/wechat/image/mediaList/logo13.png" />
					</li>
					</a>
					<li>
						<a href="http://mp.weixin.qq.com/mp/getmasssendmsg?__biz=MjM5NDMwNjMwMw==#wechat_webview_type=1&wechat_redirect">
							<img src="${path}/STATIC/wechat/image/mediaList/logo14.png" />
					</li>
					</a>
					<li>
						<a href="http://mp.weixin.qq.com/mp/getmasssendmsg?__biz=MjM5NjM4OTAyMA==#wechat_webview_type=1&wechat_redirect">
							<img src="${path}/STATIC/wechat/image/mediaList/logo15.png" />
					</li>
					</a>
					<li>
						<a href="http://mp.weixin.qq.com/mp/getmasssendmsg?__biz=MjM5NDgyNTQwMQ==#wechat_webview_type=1&wechat_redirect">
							<img src="${path}/STATIC/wechat/image/mediaList/logo16.png" />
					</li>
					</a>
					<li>
						<a href="http://mp.weixin.qq.com/mp/getmasssendmsg?__biz=MzA3MDAwODIzOA==#wechat_webview_type=1&wechat_redirect">
							<img src="${path}/STATIC/wechat/image/mediaList/logo17.png" />
					</li>
					</a>
					<li>
						<a href="http://mp.weixin.qq.com/mp/getmasssendmsg?__biz=MjM5NzQ4MzQ4MQ==#wechat_webview_type=1&wechat_redirect">
							<img src="${path}/STATIC/wechat/image/mediaList/logo18.png" />
					</li>
					</a>
					<div style="clear: both;"></div>
				</ul>
			</div>
		</div>
	</div>
	
	<!-- 导入统计文件 -->
	<script type="text/javascript" src="${path}/stat/stat.js"></script>
	<%@include file="/WEB-INF/why/wechat/wechat_statistics.jsp"%>
</body>
</html>
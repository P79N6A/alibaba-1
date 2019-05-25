<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>佛山文化云·每日诗品</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series-2.css?t=New Date()"/>
	
	<script>
		
		//分享是否隐藏
		if(window.injs){
		   	//分享文案
		   	appShareTitle = '每日诗品-名师古诗赏析+填字游戏，快来挑战你的古诗功底！';
		   	appShareDesc = '每天一位中文名师，带你赏析古诗的独特魅力，争当古诗词达人！';
		   	appShareImgUrl = 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017426143720EKjF9mvXioZA8rrp3DRQXnisSNDRoD.jpg';
		   	
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
				jsApiList: ['previewImage','onMenuShareAppMessage','onMenuShareTimeline','onMenuShareQQ','onMenuShareWeibo','onMenuShareQZone']
			});
			wx.ready(function () {
				wx.onMenuShareAppMessage({
					title: "每日诗品-名师古诗赏析+填字游戏，快来挑战你的古诗功底！",
					desc: '每天一位中文名师，带你赏析古诗的独特魅力，争当古诗词达人！',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017426143720EKjF9mvXioZA8rrp3DRQXnisSNDRoD.jpg'
				});
				wx.onMenuShareTimeline({
					title: "每日诗品-名师古诗赏析+填字游戏，快来挑战你的古诗功底！",
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017426143720EKjF9mvXioZA8rrp3DRQXnisSNDRoD.jpg'
				});
				wx.onMenuShareQQ({
					title: "每日诗品-名师古诗赏析+填字游戏，快来挑战你的古诗功底！",
					desc: '每天一位中文名师，带你赏析古诗的独特魅力，争当古诗词达人！',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017426143720EKjF9mvXioZA8rrp3DRQXnisSNDRoD.jpg'
				});
				wx.onMenuShareWeibo({
					title: "每日诗品-名师古诗赏析+填字游戏，快来挑战你的古诗功底！",
					desc: '每天一位中文名师，带你赏析古诗的独特魅力，争当古诗词达人！',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017426143720EKjF9mvXioZA8rrp3DRQXnisSNDRoD.jpg'
				});
				wx.onMenuShareQZone({
					title: "每日诗品-名师古诗赏析+填字游戏，快来挑战你的古诗功底！",
					desc: '每天一位中文名师，带你赏析古诗的独特魅力，争当古诗词达人！',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017426143720EKjF9mvXioZA8rrp3DRQXnisSNDRoD.jpg'
				});
			});
		}
	
		$(function () {
			//swiper初始化div
		    initSwiper();
			
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
		});
		
	</script>
	
	<style>
		html,body {min-height: 100%;background: url(${path}/STATIC/wxStatic/image/dailyPoetry/bg5.jpg) no-repeat top center;background-color: #eee}
	</style>
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017426143720EKjF9mvXioZA8rrp3DRQXnisSNDRoD.jpg"/></div>
	<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
		<img src="${path}/STATIC/wechat/image/commonShare.png" style="width: 100%;height: 100%;" />
	</div>
	
	<div class="dailyPty">
		<ul class="lccshare clearfix">
			<li><a href="${path}/wechatStatic/poemRule.do">活动规则</a></li>
			<li class="share-button"><a href="javascript:;">分享</a></li>
			<li onclick="toWhyIndex();"><a href="javascript:;">首页</a></li>
		</ul>
		<ul class="jiangshit clearfix">
			<c:forEach items="${poemLector}" var="dom">
				<li>
					<div class="teach clearfix">
						<div class="toux"><div><img src="${dom.lectorHeadImg}@150w" onclick="previewImg('${dom.lectorHeadImg}','${dom.lectorHeadImg}')"></div></div>
						<div class="char">
							<h5>${dom.lectorName}</h5>
							<h6>${dom.lectorJob}</h6>
						</div>
					</div>
					<%request.setAttribute("vEnter", "\r\n");%>
					<div class="neirong">${fn:replace(dom.lectorIntro,vEnter,'<br>')}</div>
				</li>
			</c:forEach>
		</ul>
		
		<!-- 导航 -->
		<div class="shiNav">
			<a href="${path}/wechatStatic/poemComplete.do"><span style="background-position: 0 0;"></span></a>
			<a href="${path}/wechatStatic/poemList.do"><span style="background-position: 0 -55px;"></span></a>
			<a class="cur" href="${path}/wechatStatic/poemLectorList.do"><span style="background-position: 0 -110px;"></span></a>
			<a href="${path}/wechatStatic/poemRule.do"><span style="background-position: 0 -165px;"></span></a>
		</div>
	</div>
</body>
</html>
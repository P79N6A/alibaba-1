<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>佛山文化云·近期大型热门活动汇总</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	
	<script>
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '文化云近期大型热门活动汇总';
	    	appShareDesc = '最热票务/最多奖品/最具逼格 的免费公共文化活动';
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
					title: "文化云近期大型热门活动汇总",
					desc: '最热票务/最多奖品/最具逼格 的免费公共文化活动',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
				});
				wx.onMenuShareTimeline({
					title: "文化云近期大型热门活动汇总",
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
				});
				wx.onMenuShareQQ({
					title: "文化云近期大型热门活动汇总",
					desc: '最热票务/最多奖品/最具逼格 的免费公共文化活动',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
				});
				wx.onMenuShareWeibo({
					title: "文化云近期大型热门活动汇总",
					desc: '最热票务/最多奖品/最具逼格 的免费公共文化活动',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
				});
				wx.onMenuShareQZone({
					title: "文化云近期大型热门活动汇总",
					desc: '最热票务/最多奖品/最具逼格 的免费公共文化活动',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
				});
			});
		}
		
		//跳链接
        function preOutUrl(url){ 
			window.location.href = url; 
		};
	</script>
	
	<style>
		.bannerList{
			width: 750px;
			margin: auto;
		}
		
		.bannerList li{
			border-bottom: 15px solid #eee;
		}
		
		.bannerList li img{
			display: block;
			margin: auto;
			width: 750px;
		}
	</style>
</head>

<body>
	<div class="bannerList">
		<ul>
			<li onclick="preOutUrl('http://ct.wenhuayun.cn/template/activityTopicDetail.do?topicid=49');">
				<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017314195517B1rq0YJnLfA2no7mdrxWgNBVJLlJqI.jpg@800w" />
			</li>
			<li onclick="preOutUrl('http://ct.wenhuayun.cn/template/activityTopicDetail.do?topicid=48');">
				<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017310175025geXBHaYfZgiZH5G9lOzcpgkH9vaFSh.jpg@800w" />
			</li>
			<li onclick="preOutUrl('${path}/wechatFunction/cityIndex.do');">
				<img src="${path}/STATIC/wxStatic/image/bannerList/44_1.jpg" />
			</li>
			<li onclick="toVenueDetail('5e8739f0511b4caeb05c974273b83b96');">
				<img src="${path}/STATIC/wxStatic/image/bannerList/40.jpg" />
			</li>
			<li onclick="toVenueDetail('d057471712e74069ab63dd2c2172d98f');">
				<img src="${path}/STATIC/wxStatic/image/bannerList/20.jpg" />
			</li>
			<li onclick="toVenueDetail('2f579b2d7acd497f9ded78df0542d182');">
				<img src="${path}/STATIC/wxStatic/image/bannerList/6.jpg" />
			</li>
			<li onclick="toVenueDetail('8717cc42e5b54dc0a177db642fe13e6b');">
				<img src="${path}/STATIC/wxStatic/image/bannerList/7.jpg" />
			</li>
			<li onclick="toActDetail('0c9dc0dbd6f84a9c84160e531f481ac2');">
				<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017314135945BsltaUwkhDLEQZbMLV9atwDB2qLzKZ.jpg@800w" />
			</li>
			<li onclick="toActDetail('8dd3bae3355948a2ba58b2e93a9ff974');">
				<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20173616443JxsztTFRVQzvJOlOFngyzW79jgAOKN.jpg@800w" />
			</li>
			<li onclick="toActDetail('19bdf9297a134bb183d95bbf35235013');">
				<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20173616428t8Lrpwellm7tMWsdgLaGGB8xYlsn5o.jpg@800w" />
			</li>
			<li onclick="preOutUrl('http://ct.wenhuayun.cn/template/activityTopicDetail.do?topicid=45&from=singlemessage&isappinstalled=0');">
				<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201733181757rDDNVY6n0Ljfh9ugBdQqmPgdD8rL5O.jpg@800w" />
			</li>
			<li onclick="toActDetail('02ba3f1bce9a4d3cb6c2b873b8b3b9d3');">
				<img src="${path}/STATIC/wxStatic/image/bannerList/45_1.jpg" />
			</li>
			<li onclick="preOutUrl('http://ct.wenhuayun.cn/template/newYearWelcome.do');">
				<img src="${path}/STATIC/wxStatic/image/bannerList/32_3.jpg" />
			</li>
			<%-- <li onclick="preOutUrl('${path}/wechatFunction/cityIndex.do');">
				<img src="${path}/STATIC/wxStatic/image/bannerList/41_1.jpg" />
			</li> --%>
			<li onclick="toActDetail('ed51dd3ce7dd492087c3d63dd37c7f36');">
				<img src="${path}/STATIC/wxStatic/image/bannerList/39_1.jpg" />
			</li>
			<li onclick="preOutUrl('http://ct.wenhuayun.cn/template/activityTopicDetail.do?topicid=36');">
				<img src="${path}/STATIC/wxStatic/image/bannerList/27_1.jpg" />
			</li>
			<li onclick="preOutUrl('http://ct.wenhuayun.cn/template/activityTopicDetail.do?topicid=37');">
				<img src="${path}/STATIC/wxStatic/image/bannerList/28_1.jpg" />
			</li>
			<li onclick="preOutUrl('http://ct.wenhuayun.cn/template/activityTopicDetail.do?topicid=39');">
				<img src="${path}/STATIC/wxStatic/image/bannerList/29_1.jpg" />
			</li>
			<li onclick="preOutUrl('http://ct.wenhuayun.cn/template/activityTopicDetail.do?topicid=35');">
				<img src="${path}/STATIC/wxStatic/image/bannerList/26.jpg" />
			</li>
			<li onclick="preOutUrl('http://ct.wenhuayun.cn/template/activityTopicDetail.do?topicid=24');">
				<img src="${path}/STATIC/wxStatic/image/bannerList/30.jpg" />
			</li>
			<li onclick="preOutUrl('http://ct.wenhuayun.cn/template/activityTopicDetail.do?topicid=22');">
				<img src="${path}/STATIC/wxStatic/image/bannerList/31.jpg" />
			</li>
			<li onclick="preOutUrl('${path}/wechatStatic/hkVenue.do');">
				<img src="${path}/STATIC/wxStatic/image/bannerList/2.jpg" />
			</li>
			<li onclick="preOutUrl('${path}/wechatStatic/artSky.do');">
				<img src="${path}/STATIC/wxStatic/image/bannerList/8.jpg" />
			</li>
			<li onclick="preOutUrl('${path}/wechatRedStar/welcome.do');">
				<img src="${path}/STATIC/wxStatic/image/bannerList/10.jpg" />
			</li>
			<li onclick="preOutUrl('${path}/information/preInfo.do?informationId=e5705198b4654b479bd1688ea6b1478a');">
				<img src="${path}/STATIC/wxStatic/image/bannerList/13.jpg" />
			</li>
			<li onclick="toActDetail('2350150029a743e5beb33b0430534407');">
				<img src="${path}/STATIC/wxStatic/image/bannerList/22.jpg" />
			</li>
			<li onclick="preOutUrl('http://mp.weixin.qq.com/s?__biz=MzA5NTQ1MDM2Mg==&mid=2651695043&idx=1&sn=5b71439c4fdff5292b6e56f9a2ad0694&chksm=8b462256bc31ab40f9654b38d3cc4dfb396542cb313b468a5d3c571e3b3bf759cb4fc8b09532&mpshare=1&scene=1&srcid=1031dMM1SVG5i6kLmilzIzmC#rd');">
				<img src="${path}/STATIC/wxStatic/image/bannerList/21.jpg" />
			</li>
			<li onclick="preOutUrl('${path}/wechatStatic/liveText.do');">
				<img src="${path}/STATIC/wxStatic/image/bannerList/23.jpg" />
			</li>
			<li onclick="preOutUrl('${path}/wechatStatic/beautyCity.do');">
				<img src="${path}/STATIC/wxStatic/image/bannerList/9.jpg" />
			</li>
			<li onclick="preOutUrl('${path}/wechatStatic/cnDance.do');">
				<img src="${path}/STATIC/wxStatic/image/bannerList/15.jpg" />
			</li>
			<li onclick="preOutUrl('${path}/wechatStatic/fxActivity.do');">
				<img src="${path}/STATIC/wxStatic/image/bannerList/1.jpg" />
			</li>
			<li onclick="preOutUrl('http://mp.weixin.qq.com/s?__biz=MzA5NTQ1MDM2Mg==&mid=2651693608&idx=3&sn=bc091a97cc9b74dbb78a0b740bb7e755&scene=1&srcid=09097QhQNIgcM3pm3FzhuUwR&from=singlemessage&isappinstalled=0#wechat_redirect');">
				<img src="${path}/STATIC/wxStatic/image/bannerList/12.jpg" />
			</li>
		</ul>
	</div>
</body>
</html>
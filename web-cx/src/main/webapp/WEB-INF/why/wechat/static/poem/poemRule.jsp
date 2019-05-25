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
				jsApiList: ['onMenuShareAppMessage','onMenuShareTimeline','onMenuShareQQ','onMenuShareWeibo','onMenuShareQZone']
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
		html,body {min-height: 100%;background: url(${path}/STATIC/wxStatic/image/dailyPoetry/bg2.jpg) no-repeat top center;background-color: #eee}
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
		<div class="ruleTit"></div>
		<div class="ruleContWc">
			<div class="ruleCont">
				<div class="tit">活动背景</div>
				<div class="nr">　　为了加深市民对传统文化的认识与理解，中华传统文化作为上海市民文化节每年的常设项目，2017年将继续开展古诗词、中华戏曲、民俗节庆、传统美德等各类传统文化知识的学习、普及、竞赛，传授中华优秀传统文化之美，提升市民中华美学素养。比赛将产生100名 “文化云古诗词达人”。</div>
			</div>
			<div class="ruleCont">
				<div class="tit">活动详情</div>
				<div class="nr">
					　　2017年上海市民文化节开设“每日诗品”专栏，APP与微信同步推送。<br>
					　　“每日诗品”，也是每日“师”品。每天邀请一位重量级得大、中学最受欢迎的中文名师，以诗歌与人生为主题，为市民讲解寻常诗词的精妙之处，发表各位导师的独到见解。<br>
					　　“每日诗品”专栏每天推出：1位重磅的市民导师、1首耳熟能详的古诗、1则妙趣横生的赏析、1个当日古诗的填字游戏。<br>
					　　每日推送的古诗将化身为手机游戏，让用户在兴趣盎然玩游戏的过程中，不知不觉学会一首中华优秀古诗词。<br>
				</div>
			</div>
			<div class="ruleCont">
				<div class="tit">活动规则</div>
				<div class="nr">
					1、活动时间：即日 -2017.12<br>
					2、参与方式：参与“市民艺术素养提升计划”，诗歌赏析天天见，完成每日诗歌游戏，就有机会成为“文化云古诗词达人”百强。
				</div>
			</div>
			<div class="ruleCont">
				<div class="tit">活动奖励</div>
				<div class="nr">
					　　参与每日游戏，答对一道题，即可获得100个文化云积分。<br>
					　　我们将在2017年选出200首精彩诗歌赏析以飨市民，市民在赏析名师点评的同时，完成古诗填字游戏，最终我们会在“游戏通关”用户中选出100名市民，成为“文化云古诗词达人”，获得文化云特制勋章及奖励。
				</div>
			</div>
		</div>
		
		<!-- 导航 -->
		<div class="shiNav">
			<a href="${path}/wechatStatic/poemComplete.do"><span style="background-position: 0 0;"></span></a>
			<a href="${path}/wechatStatic/poemList.do"><span style="background-position: 0 -55px;"></span></a>
			<a href="${path}/wechatStatic/poemLectorList.do"><span style="background-position: 0 -110px;"></span></a>
			<a class="cur" href="${path}/wechatStatic/poemRule.do"><span style="background-position: 0 -165px;"></span></a>
		</div>
	</div>
</body>
</html>
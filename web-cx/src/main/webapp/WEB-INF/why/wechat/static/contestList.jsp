<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>佛山文化云·有奖活动</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	
	<script>
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '佛山文化云·文化竞赛汇总';
	    	appShareDesc = '最有趣的文化百科知识挑战赛';
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
					title: "佛山文化云·文化竞赛汇总",
					desc: '最有趣的文化百科知识挑战赛',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
				});
				wx.onMenuShareTimeline({
					title: "佛山文化云·文化竞赛汇总",
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
				});
				wx.onMenuShareQQ({
					title: "佛山文化云·文化竞赛汇总",
					desc: '最有趣的文化百科知识挑战赛',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
				});
				wx.onMenuShareWeibo({
					title: "佛山文化云·文化竞赛汇总",
					desc: '最有趣的文化百科知识挑战赛',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
				});
				wx.onMenuShareQZone({
					title: "佛山文化云·文化竞赛汇总",
					desc: '最有趣的文化百科知识挑战赛',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
				});
			});
		}
		
		//跳链接
        function preOutUrl(url){ 
			window.location.href = url; 
		};
	</script>
	
	<style type="text/css">
		/*Clear Css*/
		.clear{clear:both; font-size:0px; height:0px; line-height:0;}
		.clearfix:after{content:'\20';display:block;clear:both;visibility:hidden;line-height:0;height:0;}
		.clearb{ clear:both;}
		.clearfix{display:block;zoom:1;}
		html[xmlns] .clearfix{display:block;}
		* html .clearfix{height:1%;}
		.juheye {background: url(${path}/STATIC/wxStatic/image/juheye/bg5.jpg) repeat-y;position: relative;;}
		.juheye .bgdb {width: 100%;height: 250px;background: url(${path}/STATIC/wxStatic/image/juheye/bgdb.jpg) no-repeat;position: absolute;left: 0;bottom: 0;}
	</style>
</head>

<body>
	<div class="juheye">
		<div class="jhtit"><img src="${path}/STATIC/wxStatic/image/juheye/pic1_3.jpg"></div>
		<div class="bgdb"></div>
		<ul class="jhlist clearfix">
			<li>
				<div class="pic"><a href="http://hs.hb.wenhuayun.cn/wechatFunction/contestQuiz.do?topicId=0933bfca389245ff8ba9d80e430ff510"><img src="${path}/STATIC/wxStatic/image/juheye/pic38.png" width="130" height="130"></a></div>
				<div class="char" style="width:150%;margin-left: -25%;"><a href="javascript:;">合格影迷养成记<br>12件事证明自己</a></div>
				<img class="hot current" src="${path}/STATIC/wxStatic/image/juheye/pic3.png">
				<a class="dazt lan" href="javascript:;">答题</a>
			</li>
			<li>
				<div class="pic"><a href="http://hs.hb.wenhuayun.cn/wechatStatic/movieIndex.do"><img src="${path}/STATIC/wxStatic/image/juheye/pic37.png" width="130" height="130"></a></div>
				<div class="char" style="width:150%;margin-left: -25%;"><a href="javascript:;">随手写下观影感受<br>轻松赢取千元现金</a></div>
				<img class="hot current" src="${path}/STATIC/wxStatic/image/juheye/pic3.png">
				<a class="dazt lan" href="javascript:;">征集</a>
			</li>
			<li>
				<div class="pic"><a href="http://hs.hb.wenhuayun.cn/wechatStatic/cultureContestIndex.do"><img src="${path}/STATIC/wxStatic/image/juheye/pic36.png" width="130" height="130"></a></div>
				<div class="char" style="width:150%;margin-left: -25%;"><a href="javascript:;">文化人的挑战赛<br>中华优秀文化知识大赛</a></div>
				<img class="hot current" src="${path}/STATIC/wxStatic/image/juheye/pic3.png">
				<a class="dazt lan" href="javascript:;">答题</a>
			</li>
			<li>
				<div class="pic"><a href="http://hs.hb.wenhuayun.cn/wechatStatic/poemIndex.do"><img src="${path}/STATIC/wxStatic/image/juheye/pic35.png" width="130" height="130"></a></div>
				<div class="char" style="width:150%;margin-left: -25%;"><a href="javascript:;">名师赏析+填字游戏<br>挑战你的古诗功底</a></div>
				<img class="hot current" src="${path}/STATIC/wxStatic/image/juheye/pic3.png">
				<a class="dazt lan" href="javascript:;">答题</a>
			</li>
			<li>
				<div class="pic"><a href="http://hs.hb.wenhuayun.cn/wechatStatic/walkIndex.do"><img src="${path}/STATIC/wxStatic/image/juheye/pic33.png" width="130" height="130"></a></div>
				<div class="char" style="width:150%;margin-left: -25%;"><a href="javascript:;">征集行走故事<br>用镜头讲述旅行瞬间</a></div>
				<img class="hot current" src="${path}/STATIC/wxStatic/image/juheye/pic3.png">
				<a class="dazt lan" href="javascript:;">征集</a>
			</li>
			<li>
				<div class="pic"><a href="http://hs.hb.wenhuayun.cn/wechatFunction/contestQuiz.do?topicId=93f9a80f940e452e9a71bfd3dbd70b68"><img src="${path}/STATIC/wxStatic/image/juheye/pic34_1.png" width="130" height="130"></a></div>
				<div class="char" style="width:150%;margin-left: -25%;"><a href="javascript:;">中华传统知识 大师<br>文化大师争霸挑战赛</a></div>
				<a class="dazt lan" href="javascript:;">答题</a>
			</li>
			<li>
				<div class="pic"><a href="http://hs.hb.wenhuayun.cn/wechatFunction/contestQuiz.do?topicId=c8ee0aa8cad14f1bb39dc31a4ed0ff1c"><img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017426192754JAZh6j90YbqsTEItqw9s7dEBXHCTgd.png" width="130" height="130"></a></div>
				<div class="char" style="width:150%;margin-left: -25%;"><a href="javascript:;">少追剧 多读书<br>文学细胞是个好东西</a></div>
				<a class="dazt lan" href="javascript:;">答题</a>
			</li>
			<li>
				<div class="pic"><a href="http://hs.hb.wenhuayun.cn/wechatFunction/contestQuiz.do?topicId=68c9277c5271407ab527d576c938c774"><img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/image/Img2f8ea70db1e24946a1c8ba0251f82efe.png" width="130" height="130"></a></div>
				<div class="char" style="width:150%;margin-left: -25%;"><a href="javascript:;">古诗释义<br>你是合格的诗人吗？</a></div>
				<a class="dazt lan" href="javascript:;">答题</a>
			</li>
			<li>
				<div class="pic"><a href="http://hs.hb.wenhuayun.cn/wechatFunction/contestQuiz.do?topicId=4dfafcb5a0b74852bf87fdbef8dbc3b0"><img src="${path}/STATIC/wxStatic/image/juheye/pic32.png" width="130" height="130"></a></div>
				<div class="char" style="width:150%;margin-left: -25%;"><a href="javascript:;">古诗接龙<br>“古风幼儿园”入学测试</a></div>
				<a class="dazt lan" href="javascript:;">答题</a>
			</li>
			<li>
				<div class="pic"><a href="http://hs.hb.wenhuayun.cn/wechatFunction/contestQuiz.do?topicId=8270dd1fae8f42779e9fba4ec1ec5412"><img src="${path}/STATIC/wxStatic/image/juheye/pic31_1.png" width="130" height="130"></a></div>
				<div class="char" style="width:150%;margin-left: -25%;"><a href="javascript:;">中华传统知识 进阶版<br>人生处处是高考</a></div>
				<a class="dazt lan" href="javascript:;">答题</a>
			</li>
			<li>
				<div class="pic"><a href="http://hs.hb.wenhuayun.cn/wechatFunction/contestQuiz.do?topicId=97502b087d4c443f89090274effb1492"><img src="${path}/STATIC/wxStatic/image/juheye/pic30.png" width="130" height="130"></a></div>
				<div class="char" style="width:150%;margin-left: -25%;"><a href="javascript:;">新版古诗新解<br>传统文化大师晋升测试</a></div>
				<a class="dazt lan" href="javascript:;">答题</a>
			</li>
			<li>
				<div class="pic"><a href="http://hs.hb.wenhuayun.cn/wechatFunction/contestQuiz.do?topicId=0e1a2057f2434f16a7c43bfd48abf8f9"><img src="${path}/STATIC/wxStatic/image/juheye/pic29.png" width="130" height="130"></a></div>
				<div class="char" style="width:150%;margin-left: -25%;"><a href="javascript:;">第三届“美丽奉贤”戏剧节<br>戏剧迷专属互动挑战赛</a></div>
				<a class="dazt lan" href="javascript:;">答题</a>
			</li>
			<li>
				<div class="pic"><a href="http://hs.hb.wenhuayun.cn/wechatFunction/contestQuiz.do?topicId=ae9ec263f4c64ea999cfba3279c5204a"><img src="${path}/STATIC/wxStatic/image/juheye/pic23.png" width="130" height="130"></a></div>
				<div class="char" style="width:150%;margin-left: -25%;"><a href="javascript:;">中华传统知识 文博篇<br>文理兼修博古通今</a></div>
				<a class="dazt lan" href="javascript:;">答题</a>
			</li>
			<li>
				<div class="pic"><a href="http://hs.hb.wenhuayun.cn/wechatFunction/contestQuiz.do?topicId=0124faa6afc146d3be6f756c8e0a9bc0"><img src="${path}/STATIC/wxStatic/image/juheye/pic24.png" width="130" height="130"></a></div>
				<div class="char" style="width:150%;margin-left: -25%;"><a href="javascript:;">中华传统知识 历史人文<br>文明古国精华挑战赛</a></div>
				<a class="dazt lan" href="javascript:;">答题</a>
			</li>		
			<li>
				<div class="pic"><a href="http://hs.hb.wenhuayun.cn/wechatFunction/contestQuiz.do?topicId=fa0c6b20a42b4a6488d03e4ee9b7fb7e"><img src="${path}/STATIC/wxStatic/image/juheye/pic25.png" width="130" height="130"></a></div>
				<div class="char" style="width:150%;margin-left: -25%;"><a href="javascript:;">中华传统知识 民俗篇<br>身边故事知多少</a></div>
				<a class="dazt lan" href="javascript:;">答题</a>
			</li>	
			<%-- <li>
				<div class="pic"><a href="http://hs.hb.wenhuayun.cn/wechatFunction/contestQuiz.do?topicId=93f9a80f940e452e9a71bfd3dbd70b68"><img src="${path}/STATIC/wxStatic/image/juheye/pic26.png" width="130" height="130"></a></div>
				<div class="char" style="width:150%;margin-left: -25%;"><a href="javascript:;">中华传统知识 大师版<br>据说只有1%的人可以答对</a></div>
				<a class="dazt lan" href="javascript:;">答题</a>
			</li>	
			<li>
				<div class="pic"><a href="http://hs.hb.wenhuayun.cn/wechatFunction/contestQuiz.do?topicId=8270dd1fae8f42779e9fba4ec1ec5412"><img src="${path}/STATIC/wxStatic/image/juheye/pic27.png" width="130" height="130"></a></div>
				<div class="char" style="width:150%;margin-left: -25%;"><a href="javascript:;">中华传统知识 进阶版<br>人生处处是高考</a></div>
				<a class="dazt lan" href="javascript:;">答题</a>
			</li> --%>	
			<li>
				<div class="pic"><a href="http://hs.hb.wenhuayun.cn/wechatStatic/sceneIndex.do"><img src="${path}/STATIC/wxStatic/image/juheye/pic28.png" width="130" height="130"></a></div>
				<div class="char" style="width:150%;margin-left: -25%;"><a href="javascript:;">分享活动现场<br>展现艺术生活</a></div>
				<a class="dazt lan" href="javascript:;">征集</a>
			</li>		
			<%-- <li>
				<div class="pic"><a href="${path}/wechatFunction/cityIndex.do"><img src="${path}/STATIC/wxStatic/image/juheye/pic15.png" width="130" height="130"></a></div>
				<div class="char" style="width:140%;margin-left: -20%;"><a href="javascript:;">VOL.3 我与长宁艺术<br>参与立享500积分</a></div>
				<a class="dazt hong" href="javascript:;">征集</a>
			</li> --%>
			<li>
				<div class="pic"><a href="${path}/wechatStatic/contest.do"><img src="${path}/STATIC/wxStatic/image/juheye/pic8.png" width="130" height="130"></a></div>
				<div class="char"><a href="javascript:;">百科知识全挑战<br>仅限博学文化人</a></div>
				<a class="dazt lan" href="javascript:;">答题</a>
			</li>
			<li>
				<div class="pic"><a href="${path}/wechatStatic/redStarIntro.do"><img src="${path}/STATIC/wxStatic/image/juheye/pic4_2.png" width="130" height="130"></a></div>
				<div class="char"><a href="javascript:;">红星照耀中国<br>线上展览</a></div>
			</li>
			<li>
				<div class="pic"><a href="${path}/xuhui/wapAward.do"><img src="${path}/STATIC/wxStatic/image/juheye/366_1.png" width="130" height="130"></a></div>
				<div class="char"><a href="javascript:;">徐汇366<br>市民摄影大赛</a></div>
			</li>
			<li>
				<div class="pic"><a href="${path}/wechatStatic/nyIndex.do"><img src="${path}/STATIC/wxStatic/image/juheye/pic22_1.png" width="130" height="130"></a></div>
				<div class="char"><a href="javascript:;">从圣诞到元宵<br>福袋红包送不停</a></div>
			</li>
			<li>
				<div class="pic"><a href="${path}/wechatStatic/dramaAnswer.do"><img src="${path}/STATIC/wxStatic/image/juheye/pic13_1.png" width="130" height="130"></a></div>
				<div class="char" style="width:140%;margin-left: -20%;"><a href="javascript:;">你的人生有几分入戏？<br>当代戏剧节知识问答</a></div>
			</li>
			<li>
				<div class="pic"><a href="${path}/wechatStatic/artAnswer.do"><img src="${path}/STATIC/wxStatic/image/juheye/pic10_1.png" width="130" height="130"></a></div>
				<div class="char" style="width:114%;margin-left: -7%;"><a href="javascript:;">国际艺术节知多少<br>艺游嬉梦线上答题</a></div>
			</li>
			<li>
				<div class="pic"><a href="${path}/wechatStatic/cnAnswer.do"><img src="${path}/STATIC/wxStatic/image/juheye/pic9_1.png" width="130" height="130"></a></div>
				<div class="char"><a href="javascript:;">歌剧小知识问答<br>高雅艺术挑战赛</a></div>
			</li>
			<li>
				<div class="pic"><a href="${path}/wechatStatic/fxAnswer.do"><img src="${path}/STATIC/wxStatic/image/juheye/pic6_1.png" width="130" height="130"></a></div>
				<div class="char"><a href="javascript:;">你对奉贤知多少<br>挑战通关就知道</a></div>
			</li>
			<li>
				<div class="pic"><a href="${path}/wechatStatic/comedyFestival.do"><img src="${path}/STATIC/wxStatic/image/juheye/pic12_1.png" width="130" height="130"></a></div>
				<div class="char" style="width:140%;margin-left: -20%;"><a href="javascript:;">上传你的灿烂笑脸<br>分享快乐 赢精美礼品</a></div>
			</li>
			<li>
				<div class="pic"><a href="${path}/wechatStatic/dramaFestival.do"><img src="${path}/STATIC/wxStatic/image/juheye/pic11_1.png" width="130" height="130"></a></div>
				<div class="char"><a href="javascript:;">当代话剧知多少<br>发表剧评赢好礼</a></div>
			</li>
			<li>
				<div class="pic"><a href="${path}/wechatDc/index.do"><img src="${path}/STATIC/wxStatic/image/juheye/pic14_1.png" width="130" height="130"></a></div>
				<div class="char" style="width:140%;margin-left: -20%;"><a href="javascript:;">上海市社区文艺指导员教学成果展演投票有奖</a></div>
			</li>
			<li>
				<div class="pic"><a href="${path}/wechatStatic/beautyCity.do"><img src="${path}/STATIC/wxStatic/image/juheye/pic5_1.png" width="130" height="130"></a></div>
				<div class="char"><a href="javascript:;">爱上海 随手拍<br>电话卡 随便送</a></div>
			</li>
			<li>
				<div class="pic"><a href="${path}/wechatStatic/micronote.do"><img src="${path}/STATIC/wxStatic/image/juheye/pic7_1.png" width="130" height="130"></a></div>
				<div class="char"><a href="javascript:;">读好书 微笔记<br>真善美 等你赞</a></div>
			</li>
			
			<li>
				<div class="pic"><a href="http://hs.hb.wenhuayun.cn/wechatStatic/musicIndex.do"><img src="${path}/STATIC/wxStatic/image/zsm.png" width="130" height="130"></a></div>
				<div class="char" style="width:140%;margin-left: -20%;"><a href="javascript:;">随手写出音乐故事<br>发现音乐中的真善美</a></div>
			</li>
			
			
		</ul>
	</div>
</body>
</html>
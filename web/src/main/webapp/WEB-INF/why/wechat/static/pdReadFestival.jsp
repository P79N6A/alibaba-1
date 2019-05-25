<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>浦东图书馆六届读书节</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	
	<script>
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '又是一年浦东图书馆读书节—— 传播知识，丰富心灵的文化传播！';
	    	appShareDesc = '各种丰富活动等你来参与 一起畅游图书的海洋';
	    	appShareImgUrl = '${basePath}/STATIC/wxStatic/image/read/shareIcon.jpg';
	    	
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
					title: "又是一年浦东图书馆读书节—— 传播知识，丰富心灵的文化传播！",
					desc: '各种丰富活动等你来参与 一起畅游图书的海洋',
					imgUrl: '${basePath}/STATIC/wxStatic/image/read/shareIcon.jpg'
				});
				wx.onMenuShareTimeline({
					title: "又是一年浦东图书馆读书节—— 传播知识，丰富心灵的文化传播！",
					imgUrl: '${basePath}/STATIC/wxStatic/image/read/shareIcon.jpg'
				});
				wx.onMenuShareQQ({
					title: "又是一年浦东图书馆读书节—— 传播知识，丰富心灵的文化传播！",
					desc: '各种丰富活动等你来参与 一起畅游图书的海洋',
					imgUrl: '${basePath}/STATIC/wxStatic/image/read/shareIcon.jpg'
				});
				wx.onMenuShareWeibo({
					title: "又是一年浦东图书馆读书节—— 传播知识，丰富心灵的文化传播！",
					desc: '各种丰富活动等你来参与 一起畅游图书的海洋',
					imgUrl: '${basePath}/STATIC/wxStatic/image/read/shareIcon.jpg'
				});
				wx.onMenuShareQZone({
					title: "又是一年浦东图书馆读书节—— 传播知识，丰富心灵的文化传播！",
					desc: '各种丰富活动等你来参与 一起畅游图书的海洋',
					imgUrl: '${basePath}/STATIC/wxStatic/image/read/shareIcon.jpg'
				});
			});
		}
		
		$(function () {
			var swiper = new Swiper('.swiper-container', {
		        onSlideChangeStart: function () {
			        var shu = swiper.activeIndex;
			        var _slides = swiper.slides
		        	$('.readFes').find($(_slides[shu])).find('.huigtit_left').show();
		        	$('.readFes').find($(_slides[shu])).find('.huigtit_right').show();
		        	if(shu == _slides.length - 1) {
		    			$('.readFes .jian').hide();
		    		} else {
		    			$('.readFes .jian').show();
		    		}
			    }
		    });

			// 点击弹窗
			$('.readFes').on('click', '.benjList li', function () {
				var tan = $(this).parents('.slidefour').find('.tanchu');
				tan.show();
				var text = $(this).find('.readcont').clone();
				tan.html(text);
			});
			// 点击关闭弹窗
			$('.readFes').on('click', '.readcont .tit .close', function () {
				var tan = $('.readFes .tanchu');
				// tan.html('');
				tan.hide();
			});

			
			//分享
			$(".shareBut").click(function() {
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
		
	</script>
	
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${basePath}/STATIC/wxStatic/image/read/shareIcon.jpg"/></div>
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
	<div class="readFes">
		<div class="swiper-container">
		    <div class="swiper-wrapper">
		        <div class="swiper-slide slideOne">
		        	<img class="bg1" src="${path}/STATIC/wxStatic/image/read/pic1.png">
		        	<img class="sytup1 sytup" src="${path}/STATIC/wxStatic/image/read/pic1_1.png">
		        	<img class="sytup2 sytup" src="${path}/STATIC/wxStatic/image/read/pic1_2.png">
		        	<img class="sytup3 sytup" src="${path}/STATIC/wxStatic/image/read/pic1_3.png">
		        	<img class="sytup4 sytup" src="${path}/STATIC/wxStatic/image/read/pic1_4.png">
		        	<img class="sytup5 sytup" src="${path}/STATIC/wxStatic/image/read/pic1_5.png">
		        	<div class="sytup6 sytup"><img src="${path}/STATIC/wxStatic/image/read/pic1_6.png"></div>
		        	<img class="sytup7 sytup" src="${path}/STATIC/wxStatic/image/read/pic1_7.png">
		        	<ul class="readshare clearfix">
				        <li class="shareBut"><a href="javascript:;">分享</a></li>
				        <li class="keep-button"><a href="javascript:;">关注</a></li>
				    </ul>
		        </div>
		        <div class="swiper-slide slideTwo">
		        	<img class="readnyImg1" src="${path}/STATIC/wxStatic/image/read/pic2.png">
					<img class="readnyImg2" src="${path}/STATIC/wxStatic/image/read/pic3.png">
					<img class="readnyImg3" src="${path}/STATIC/wxStatic/image/read/pic4.png">
					<div class="biaotit jz660 clearfix">
						<img class="pic1" src="${path}/STATIC/wxStatic/image/read/tit1.png">
						<img class="pic2" src="${path}/STATIC/wxStatic/image/read/logo.png">
						<img class="pic3" src="${path}/STATIC/wxStatic/image/read/logo2.png">
					</div>
	
					<div class="readintro jz660">
						<div class="nc" style="height: 850px;">
							<p>　　从2011年起，浦东图书馆开始举办读书节，时间贯穿4.23世界读书日至10月浦东图书馆馆庆日，每年一届，旨在打造知识传播的文化品牌，以此来宣传图书馆，并让更多的读者走进图书馆、利用图书馆。今年是第六届。每年活动近千场，不仅参与到上海市振兴中华读书指导委员会举办的市读书节，上海市民艺术节、浦东艺术节等其中，还自主策划各种文化活动。活动内容按主题分十余大项，包括浦东文化讲坛、艺术人文展、少儿读书活动、数字资源专题活动、残疾人读书活动、真实影院、征文演讲比赛、街镇图书馆读书活动、包括我们图书馆的学术论坛等。通过努力，浦东图书馆的阅读推广影响越来越大，2013年在中国图书馆年会上获得“全民阅读示范基地”称号。</p>
							<p><img class="pic2" src="${path}/STATIC/wxStatic/image/read/pic5.jpg"></p>
							<p>　　经过五年科学有效的思考和实践，形成了浦东图书馆特色的阅读推广立体架构。</p>
							<p>
								　　1、确定一个鲜明的立意深远的主题<br>
								　　每届的“浦东图书馆读书节”都确定主题。希望通过这些主题，把正确的舆论导向蕴含其中, 把丰富的人文内涵渗透其间, 营造健康向上的读书氛围。
							</p>
							<p>
								2、亮点纷呈的读书节内容<br>
								浦东图书馆读书节从设立开始就关注读者的阅读需求，每届汇总各部门新一年的读书活动，经过梳理归纳，确立活动项目，立足“高起点、多功能、品牌化”，每年都有市级重点活动的推出。在这样一个框架下，每年不断注入新的项目，并形成品牌效应。
							</p>
							<p>
								3、搭建“高嫁接、横联谊、多辐射”的社会合作机制<br>
								浦东图书馆在开展活动的过程中，单单依靠图书馆自身资源越来越不能满足读者的要求，必须加强与和政府部门、社会各界的合作和联动，实现资源共享、取长补短、协调补充，浦东图书馆逐步建立“高嫁接、横联谊、多辐射”的合作机制，聚集了一批志同道合的优质合作资源。
							</p>
							<p>
								4、灵活多样的宣传推广<br>
								浦东图书馆也非常重视读书节的宣传推广， 临近4.23，汇总活动一览表通过宣传册、馆报的方式以及图书馆的网站、微信、微博、浦东时报、浦东电视台、浦东发布等同时推出，每月安排重点活动安排媒体的宣传和专访，扩大读书节活动的声势和影响力，提高市民的参与度。<br>
    							在实践的基础上，浦东图书馆也在思考阅读推广活动的发展规划和突破方向。<br>
    							16年的读书节将尝试搭建一个浦东新区图书馆系统的活动品牌交流和共享的平台，不但要汇总街镇馆的品牌活动，还将把我们的流通点、中小学分馆等一同纳入进去，在这个平台上参与单位可以通过走出去请进来或者建立合作关系的方式，进行互动与交流。同时吸引更多的单位和团体的合作方，组合出拳，优势互补，将已有的优秀合作项目长期保持下去，并不断拓展一些新的服务和活动内容，扩大读书节活动的影响和效应。 
							</p>
								
						</div>
					</div>
		        </div>
		        <div class="swiper-slide slideThree">
		        	<img class="readnyImg1" src="${path}/STATIC/wxStatic/image/read/pic2.png">
					<img class="readnyImg2" src="${path}/STATIC/wxStatic/image/read/pic3.png">
					<img class="readnyImg3" src="${path}/STATIC/wxStatic/image/read/pic4.png">
	
					<div class="biaotit jz660 clearfix">
						<img class="pic1" src="${path}/STATIC/wxStatic/image/read/tit2.png">
						<img class="pic2" src="${path}/STATIC/wxStatic/image/read/logo.png">
						<img class="pic3" src="${path}/STATIC/wxStatic/image/read/logo2.png">
					</div>
	
					<div class="huigtit huigtit_left"><em>◆</em><span>世界读书日</span><em>◆</em></div>
					<div class="clearfix">
						<ul class="huiList jz660 huigtit_left">
							<li>
								<img src="${path}/STATIC/wxStatic/image/read/pic6.jpg" width="314" height="188">
								<div class="wz">第十三届上海读书节诵读大赛</div>
							</li>
							<li>
								<img src="${path}/STATIC/wxStatic/image/read/pic7.jpg" width="314" height="188">
								<div class="wz">“阅读推广人”计划启动仪式</div>
							</li>
							<li>
								<img src="${path}/STATIC/wxStatic/image/read/pic8.jpg" width="314" height="188">
								<div class="wz">鲍鹏山主讲《孔子的教育》</div>
							</li>
							<li>
								<img src="${path}/STATIC/wxStatic/image/read/pic9.jpg" width="314" height="188">
								<div class="wz">第十四届读书节开幕式</div>
							</li>
						</ul>
					</div>
					<div class="huigtit huigtit_right"><em>◆</em><span>浦东文化讲坛</span><em>◆</em></div>
					<div class="clearfix">
						<ul class="huiList jz660 huigtit_right">
							<li>
								<img src="${path}/STATIC/wxStatic/image/read/pic10.jpg" width="314" height="188">
								<div class="wz">收藏与人生</div>
							</li>
							<li>
								<img src="${path}/STATIC/wxStatic/image/read/pic11.jpg" width="314" height="188">
								<div class="wz">问道教育-校长面对面</div>
							</li>
							<li>
								<img src="${path}/STATIC/wxStatic/image/read/pic12.jpg" width="314" height="188">
								<div class="wz">《跟德鲁克学管理》系列讲座</div>
							</li>
							<li>
								<img src="${path}/STATIC/wxStatic/image/read/pic13.jpg" width="314" height="188">
								<div class="wz">浦江学堂《论语》课程结业典礼</div>
							</li>
						</ul>
					</div>
		        </div>
		        <div class="swiper-slide slideThree">
		        	<img class="readnyImg1" src="${path}/STATIC/wxStatic/image/read/pic2.png">
					<img class="readnyImg2" src="${path}/STATIC/wxStatic/image/read/pic3.png">
					<img class="readnyImg3" src="${path}/STATIC/wxStatic/image/read/pic4.png">
	
					<div class="biaotit jz660 clearfix">
						<img class="pic1" src="${path}/STATIC/wxStatic/image/read/tit2.png">
						<img class="pic2" src="${path}/STATIC/wxStatic/image/read/logo.png">
						<img class="pic3" src="${path}/STATIC/wxStatic/image/read/logo2.png">
					</div>
	
					<div class="huigtit huigtit_left"><em>◆</em><span>少儿活动</span><em>◆</em></div>
					<div class="clearfix">
						<ul class="huiList jz660 huigtit_left">
							<li>
								<img src="${path}/STATIC/wxStatic/image/read/pic14.jpg" width="314" height="188">
								<div class="wz">迪士尼英语故事会</div>
							</li>
							<li>
								<img src="${path}/STATIC/wxStatic/image/read/pic15.jpg" width="314" height="188">
								<div class="wz">作家教你写作文</div>
							</li>
							<li>
								<img src="${path}/STATIC/wxStatic/image/read/pic16.jpg" width="314" height="188">
								<div class="wz">故事妈妈讲故事</div>
							</li>
							<li>
								<img src="${path}/STATIC/wxStatic/image/read/pic17.jpg" width="314" height="188">
								<div class="wz">暑期小小志愿者</div>
							</li>
						</ul>
					</div>
					<div class="huigtit huigtit_right"><em>◆</em><span>人文艺术展</span><em>◆</em></div>
					<div class="clearfix">
						<ul class="huiList jz660 huigtit_right">
							<li>
								<img src="${path}/STATIC/wxStatic/image/read/pic18.jpg" width="314" height="188">
								<div class="wz">脉动江东艺术展</div>
							</li>
							<li>
								<img src="${path}/STATIC/wxStatic/image/read/pic19.jpg" width="314" height="188">
								<div class="wz">相约上海国际艺术展</div>
							</li>
							<li>
								<img src="${path}/STATIC/wxStatic/image/read/pic20.jpg" width="314" height="188">
								<div class="wz">中国历代陶瓷雕塑艺术展</div>
							</li>
							<li>
								<img src="${path}/STATIC/wxStatic/image/read/pic21.jpg" width="314" height="188">
								<div class="wz">圆明园罹难155周年主题展</div>
							</li>
						</ul>
					</div>
		        </div>
		        <div class="swiper-slide slidefour">
		        	<img class="readnyImg1" src="${path}/STATIC/wxStatic/image/read/pic2.png">
					<img class="readnyImg2" src="${path}/STATIC/wxStatic/image/read/pic3.png">
					<img class="readnyImg3" src="${path}/STATIC/wxStatic/image/read/pic4.png">
	
					<div class="biaotit jz660 clearfix">
						<img class="pic1" src="${path}/STATIC/wxStatic/image/read/tit3.png">
						<img class="pic2" src="${path}/STATIC/wxStatic/image/read/logo.png">
						<img class="pic3" src="${path}/STATIC/wxStatic/image/read/logo2.png">
					</div>
					<div class="benxiangq"><a href="javascript:;">点击查看活动详情</a></div>
					<ul class="benjList jz660 clearfix">
						<li>
							<div class="pic"><img class="pic1" src="${path}/STATIC/wxStatic/image/read/pic22.png" width="185" height="185"></div>
							<div class="char">读者服务中心</div>
							<div class="readcont jz660">
								<div class="tit">读者服务中心<img class="close" src="${path}/STATIC/wxStatic/image/read/icon2.png"></div>
								<div class="readintro readcont_tup">
									<div class="nc">
										<div>
											<div class="huigtit"><em>◆</em><span>真人图书馆</span><em>◆</em></div>
											<ul class="tupic clearfix">
												<li><img src="${path}/STATIC/wxStatic/image/read/pic31.jpg" width="270" height="162"></li>
												<li><img src="${path}/STATIC/wxStatic/image/read/pic32.jpg" width="270" height="162"></li>
											</ul>
											<p>　　2014年年底，以“阅有故事的人 读别样人生”为主题的浦东真人图书馆活动闪亮登场，将阅读从文字图书拓展到“真人书”，搭建读者与“真人书”面对面的交流平台。</p>
											<div class="huigtit"><em>◆</em><span>读书沙龙</span><em>◆</em></div>
											<ul class="tupic clearfix">
												<li><img src="${path}/STATIC/wxStatic/image/read/pic33.jpg" width="270" height="162"></li>
												<li><img src="${path}/STATIC/wxStatic/image/read/pic34.jpg" width="270" height="162"></li>
											</ul>
											<p>　　从2013年开始上海浦东图书馆开展“阅读沙龙”阅读推广活动，旨在推广大众阅读。浦图读书沙龙的目标是让读者爱阅读、会阅读，引导读者进行深层次的阅读和交流，让阅读成为每个人生活中的一部分。</p>
											<div class="huigtit"><em>◆</em><span>诗与生活</span><em>◆</em></div>
											<ul class="tupic clearfix">
												<li><img src="${path}/STATIC/wxStatic/image/read/pic66.jpg" width="270" height="162"></li>
												<li><img src="${path}/STATIC/wxStatic/image/read/pic67.jpg" width="270" height="162"></li>
											</ul>
											<p>　　2016年，“诗与生活”活动的开创进一步丰富了阅读沙龙的内容，着重向读者推荐优秀的诗人及诗歌作品，引导读者阅读诗歌欣赏诗歌。</p>
										</div>
									</div>
								</div>
							</div>
						</li>
						<li>
							<div class="pic"><img class="pic1" src="${path}/STATIC/wxStatic/image/read/pic23.png" width="185" height="185"></div>
							<div class="char">阅读推广中心</div>
							<div class="readcont jz660">
								<div class="tit">阅读推广中心<img class="close" src="${path}/STATIC/wxStatic/image/read/icon2.png"></div>
								<div class="readintro readcont_tup">
									<div class="nc">
										<div>
											<div class="huigtit"><em>◆</em><span>浦东文化讲坛</span><em>◆</em></div>
											<ul class="tupic clearfix">
												<li><img src="${path}/STATIC/wxStatic/image/read/pic68.jpg" width="270" height="162"></li>
												<li><img src="${path}/STATIC/wxStatic/image/read/pic69.jpg" width="270" height="162"></li>
												<li><img src="${path}/STATIC/wxStatic/image/read/pic70.jpg" width="270" height="162"></li>
												<li><img src="${path}/STATIC/wxStatic/image/read/pic71.jpg" width="270" height="162"></li>
											</ul>
											<p>　　著名文化学者鲍鹏山教授自2011年4月首次登上浦东图书馆浦东文化讲坛，先后讲过《先秦诸子百家》21讲，《孔子的教育》6讲，《中国文化之旅》5讲，吸引了超过1.6万人次的观众，鲍教授详细解读讲座主题的时代背景、文化的产生和其中所蕴含的丰富情感，让读者了解中华民族几千年的灿烂文化。</p>
											<div class="huigtit"><em>◆</em><span>浦江学堂</span><em>◆</em></div>
											<ul class="tupic clearfix">
												<li><img src="${path}/STATIC/wxStatic/image/read/pic35.jpg" width="270" height="162"></li>
												<li><img src="${path}/STATIC/wxStatic/image/read/pic36.jpg" width="270" height="162"></li>
											</ul>
											<p>　　4月16日上午10点，孔子像揭幕暨浦东图书馆孔子学堂授牌仪式在浦东图书馆一楼隆重举行。</p>
											<div class="huigtit"><em>◆</em><span>人文艺术展</span><em>◆</em></div>
											<ul class="tupic clearfix">
												<li><img src="${path}/STATIC/wxStatic/image/read/pic37.jpg" width="270" height="162"></li>
											</ul>
											<p>　　为纪念建党九十周年、浦东新区开发开放二十六周年，由浦东新区文化艺术指导中心、浦东新区高东镇人民政府、浦东新区美术家协会、上海书画院浦东分院、上海美协海墨画会联袂主办，浦东图书馆和浦东新区高东镇文化服务中心协办的“第二届璀璨浦东·中国画展”，于8月28日下午2点在浦东图书馆一楼展厅隆重开幕。</p>
											
										</div>
									</div>
								</div>
							</div>
						</li>
						<li>
							<div class="pic"><img class="pic1" src="${path}/STATIC/wxStatic/image/read/pic24.png" width="185" height="185"></div>
							<div class="char">校园阅读好声音</div>
							<div class="readcont jz660">
								<div class="tit">校园阅读好声音<img class="close" src="${path}/STATIC/wxStatic/image/read/icon2.png"></div>
								<div class="readintro readcont_tup">
									<div class="nc">
										<div>
											<div class="huigtit"><em>◆</em><span>校园阅读好声音</span><em>◆</em></div>
											<ul class="tupic clearfix">
												<li><img src="${path}/STATIC/wxStatic/image/read/pic38.jpg" width="270" height="162"></li>
												<li><img src="${path}/STATIC/wxStatic/image/read/pic39.jpg" width="270" height="162"></li>
												<li><img src="${path}/STATIC/wxStatic/image/read/pic40.jpg" width="270" height="162"></li>
												<li><img src="${path}/STATIC/wxStatic/image/read/pic41.jpg" width="270" height="162"></li>
											</ul>
											<p>
												　　为了庆祝中国共产党成立95周年暨纪念长征胜利80周年，促进浦东中小学学生对党和国家历史的认识，抒发对爱国主义精神的颂扬、对幸福生活的赞美，丰富中小学学课余生文化生活。浦东图书馆、浦东新区教育发展研究院共同举办了首届“校园阅读好声音”——经典诗歌朗诵大赛。<br>
												　　6月26日下午，首届浦东新区“校园阅读好声音”——经典诗歌朗诵大赛决赛在浦东图书馆举行。 <br>
												　　最终方炯、刘昊易、翁祎琳、蔡怡萱和王乐桐5名一等奖选手将参加上海市民文化节“周家渡杯”经典诗文朗诵大赛决赛。
											</p>
										</div>
									</div>
								</div>
							</div>
						</li>
						<li>
							<div class="pic"><img class="pic1" src="${path}/STATIC/wxStatic/image/read/pic25.png" width="185" height="185"></div>
							<div class="char">盲人读书节活动</div>
							<div class="readcont jz660">
								<div class="tit">盲人读书节<img class="close" src="${path}/STATIC/wxStatic/image/read/icon2.png"></div>
								<div class="readintro readcont_tup">
									<div class="nc">
										<div>
											<ul class="tupic clearfix">
												<li><img src="${path}/STATIC/wxStatic/image/read/pic42.jpg" width="270" height="162"></li>
												<li><img src="${path}/STATIC/wxStatic/image/read/pic43.jpg" width="270" height="162"></li>
												<li><img src="${path}/STATIC/wxStatic/image/read/pic44.jpg" width="270" height="162"></li>
												<li><img src="${path}/STATIC/wxStatic/image/read/pic45.jpg" width="270" height="162"></li>
											</ul>
											<p>　　4月23日世界读书日，浦东图书馆邀请资深语言艺术家唐婷婷为盲人朗诵爱好者开展了以莎士比亚作品为主题的朗诵讲座，并由《为您服务》老小孩好声音团队现场演绎莎士比亚作品经典对白。</p>
										</div>
									</div>
								</div>
							</div>
						</li>
					</ul>
	
					<div class="tanchu"></div>
		        </div>
		        <div class="swiper-slide slidefour">
		        	<img class="readnyImg1" src="${path}/STATIC/wxStatic/image/read/pic2.png">
					<img class="readnyImg2" src="${path}/STATIC/wxStatic/image/read/pic3.png">
					<img class="readnyImg3" src="${path}/STATIC/wxStatic/image/read/pic4.png">
	
					<div class="biaotit jz660 clearfix">
						<img class="pic1" src="${path}/STATIC/wxStatic/image/read/tit3.png">
						<img class="pic2" src="${path}/STATIC/wxStatic/image/read/logo.png">
						<img class="pic3" src="${path}/STATIC/wxStatic/image/read/logo2.png">
					</div>
					<div class="benxiangq"><a href="javascript:;">点击查看活动详情</a></div>
					<ul class="benjList jz660 clearfix">
						<li>
							<div class="pic"><img class="pic1" src="${path}/STATIC/wxStatic/image/read/pic30.png" width="185" height="185"></div>
							<div class="char">专题文化活动</div>
							<div class="readcont jz660">
								<div class="tit">专题文化活动<img class="close" src="${path}/STATIC/wxStatic/image/read/icon2.png"></div>
								<div class="readintro readcont_tup">
									<div class="nc">
										<div>
											<div class="huigtit"><em>◆</em><span>科技之门</span><em>◆</em></div>
											<ul class="tupic clearfix">
												<li><img src="${path}/STATIC/wxStatic/image/read/pic62.jpg" width="270" height="162"></li>
												<li><img src="${path}/STATIC/wxStatic/image/read/pic63.jpg" width="270" height="162"></li>
											</ul>
											<p>　　“科技之门”系列活动主要是以科学、技术方面为主，兼及科技创新发展等方面的讲座活动。活动主要面向普通读者大众，宣传科普知识。</p>
											<div class="huigtit"><em>◆</em><span>艺尚雅集</span><em>◆</em></div>
											<ul class="tupic clearfix">
												<li><img src="${path}/STATIC/wxStatic/image/read/pic64.jpg" width="270" height="162"></li>
												<li><img src="${path}/STATIC/wxStatic/image/read/pic65.jpg" width="270" height="162"></li>
											</ul>
											<p>　　“艺尚雅集”是浦东图书馆专题阅览部艺术·时尚专题的系列读宣扬优秀文化，推荐专题文献，扩展专题服务。该活动的特点：提高读者亲身参与程度，寓教于乐；将活动与专题文献紧密结合，在活动中向读者推荐优秀的相关专题文献，购置相关书籍作为对积极参与活动的读者的奖励，提高读者的参与热情。</p>
											<div class="huigtit"><em>◆</em><span>人文浦东</span><em>◆</em></div>
											<ul class="tupic clearfix">
												<li><img src="${path}/STATIC/wxStatic/image/read/pic74.jpg" width="270" height="162"></li>
												<li><img src="${path}/STATIC/wxStatic/image/read/pic75.jpg" width="270" height="162"></li>
											</ul>
											<p>　　为了丰富浦东地区地方文献和民俗文化，浦东图书馆诚邀非遗专家和民俗开展主题活动。活动的意义在于加强推介浦东图书馆专题的优质文献和服务，深入开展浦东地方文献和信息资源服务，拓展专题服务渠道和服务方式，延伸地方文献专题服务内涵，凸显图书馆教育功能。</p>
										</div>
									</div>
								</div>
							</div>
						</li>
						<li>
							<div class="pic"><img class="pic1" src="${path}/STATIC/wxStatic/image/read/pic27.png" width="185" height="185"></div>
							<div class="char">数字馆</div>
							<div class="readcont jz660">
								<div class="tit">数字馆<img class="close" src="${path}/STATIC/wxStatic/image/read/icon2.png"></div>
								<div class="readintro readcont_tup">
									<div class="nc">
										<div>
											<div class="huigtit"><em>◆</em><span>公益电影</span><em>◆</em></div>
											<ul class="tupic clearfix">
												<li><img src="${path}/STATIC/wxStatic/image/read/pic50.jpg" width="270" height="162"></li>
												<li><img src="${path}/STATIC/wxStatic/image/read/pic51.jpg" width="270" height="162"></li>
											</ul>
											<p>　　全年坚持在周末及国定假期向读者免费播放优秀故事片、专题片、纪录片、地方戏曲影片，推出迪士尼经典影片、BBC纪录片展映等主题电影月，深受读者欢迎，几乎场场座无虚席。</p>
											<div class="huigtit"><em>◆</em><span>影音鉴赏沙龙</span><em>◆</em></div>
											<ul class="tupic clearfix">
												<li><img src="${path}/STATIC/wxStatic/image/read/pic52.jpg" width="270" height="162"></li>
												<li><img src="${path}/STATIC/wxStatic/image/read/pic53.jpg" width="270" height="162"></li>
											</ul>
											<p>　　在本馆6层的专设影音鉴赏室内，配置专业HIFI音响以及5.1声道4K3D蓝光播放设备，每月组织小型影音鉴赏沙龙活动两次，播放馆内典藏的经典音乐与优秀电影作品，为视听爱好者提供高品质的影音鉴赏体验。</p>
											<div class="huigtit"><em>◆</em><span>影音知识系列讲座</span><em>◆</em></div>
											<ul class="tupic clearfix">
												<li><img src="${path}/STATIC/wxStatic/image/read/pic72.jpg" width="270" height="162"></li>
												<li><img src="${path}/STATIC/wxStatic/image/read/pic73.jpg" width="270" height="162"></li>
											</ul>
											<p>　　浦东图书馆开设了 “Hi-fi天地”特色服务项目，与《无线电与电视》杂志社合作，组织举办音响音乐知识系列讲座，全年共12期，全面介绍了音源、功放、胆机、线材、音箱等多方面的音响专业知识。目前该项目已经拥有了一批固定的听众群。图书馆聘请音响领域方面的专家、资深乐评人士与读者面对面，现场解说器材知识，指点技术问题，评介国内国际知名的各种音响器材，普及音乐音响知识，共同欣赏美妙的乐声，比较试听感悟不同风格音乐的魅力，在音乐声中度过难忘的时光。受到发烧友和音乐爱好者的好评和欢迎，甚至有热情读者还特意从外地赶来参加每月一次的音响讲座。</p>
										</div>
									</div>
								</div>
							</div>
						</li>
						<li>
							<div class="pic"><img class="pic1" src="${path}/STATIC/wxStatic/image/read/pic28.png" width="185" height="185"></div>
							<div class="char">数字资源专题活动</div>
							<div class="readcont jz660">
								<div class="tit">数字资源专题活动<img class="close" src="${path}/STATIC/wxStatic/image/read/icon2.png"></div>
								<div class="readintro readcont_tup">
									<div class="nc">
										<div>
											<div class="huigtit"><em>◆</em><span>乐儿主题活动</span><em>◆</em></div>
											<ul class="tupic clearfix">
												<li><img src="${path}/STATIC/wxStatic/image/read/pic54.jpg" width="270" height="162"></li>
												<li><img src="${path}/STATIC/wxStatic/image/read/pic55.jpg" width="270" height="162"></li>
											</ul>
											<p>　　在乐儿科普短片和轻松愉快的比赛氛围中，小朋友们可以学到许多科普知识、智慧、勇气和快乐。充分利于数字资源的推广与普及，增加小朋友对数字资源的有效利用率，调动他们的求知欲，同时还激发学习兴趣和增强团队协作意识。</p>
											<div class="huigtit"><em>◆</em><span>哈利讲故事</span><em>◆</em></div>
											<ul class="tupic clearfix">
												<li><img src="${path}/STATIC/wxStatic/image/read/pic56.jpg" width="270" height="162"></li>
												<li><img src="${path}/STATIC/wxStatic/image/read/pic57.jpg" width="270" height="162"></li>
											</ul>
											<p>　　活动是由玉屋粟公司研发的“易趣少儿数字漫画馆”。内容丰富包括8大类，其中有国学类、幽默类、探险类益智类等在内的超过150部总长超过90000分钟的动画片。</p>
										</div>
									</div>
								</div>
							</div>
						</li>
						<li>
							<div class="pic"><img class="pic1" src="${path}/STATIC/wxStatic/image/read/pic29.png" width="185" height="185"></div>
							<div class="char">学术活动</div>
							<div class="readcont jz660">
								<div class="tit">学术活动<img class="close" src="${path}/STATIC/wxStatic/image/read/icon2.png"></div>
								<div class="readintro readcont_tup">
									<div class="nc">
										<div>
											<div class="huigtit"><em>◆</em><span>学术沙龙</span><em>◆</em></div>
											<ul class="tupic clearfix">
												<li><img src="${path}/STATIC/wxStatic/image/read/pic58.jpg" width="270" height="162"></li>
												<li><img src="${path}/STATIC/wxStatic/image/read/pic59.jpg" width="270" height="162"></li>
											</ul>
											<p>　　2016年读书节期间浦东图书馆每月举行一期学术沙龙活动,将双月讲座设立为名师讲座，邀请行业内外的知名人士前来讲座，分享行业内外的前沿热点，拓展馆员视野。</p>
											<div class="huigtit"><em>◆</em><span>阅读推广培训</span><em>◆</em></div>
											<ul class="tupic clearfix">
												<li><img src="${path}/STATIC/wxStatic/image/read/pic60.jpg" width="270" height="162"></li>
												<li><img src="${path}/STATIC/wxStatic/image/read/pic61.jpg" width="270" height="162"></li>
											</ul>
											<p>　　2016年6月1日至3日上海市图书馆学会第二期“数字阅读推广人”培训班在浦东图书馆举行。本期培训在课程设置和教学内容等方面进行了优化，力求在短时间内帮助学员有效提升数字阅读推广工作的实践能力。</p>
										</div>
									</div>
								</div>
							</div>
						</li>
					</ul>
	
					<div class="tanchu"></div>
		        </div>
		        <div class="swiper-slide slidefour">
		        	<img class="readnyImg1" src="${path}/STATIC/wxStatic/image/read/pic2.png">
					<img class="readnyImg2" src="${path}/STATIC/wxStatic/image/read/pic3.png">
					<img class="readnyImg3" src="${path}/STATIC/wxStatic/image/read/pic4.png">
	
					<div class="biaotit jz660 clearfix">
						<img class="pic1" src="${path}/STATIC/wxStatic/image/read/tit3.png">
						<img class="pic2" src="${path}/STATIC/wxStatic/image/read/logo.png">
						<img class="pic3" src="${path}/STATIC/wxStatic/image/read/logo2.png">
					</div>
					<div class="benxiangq"><a href="javascript:;">点击查看活动详情</a></div>
					<ul class="benjList jz660 clearfix">
						<li>
							<div class="pic"><img class="pic1" src="${path}/STATIC/wxStatic/image/read/pic84.png" width="185" height="185"></div>
							<div class="char">少儿读书活动</div>
							<div class="readcont jz660">
								<div class="tit">少儿读书活动<img class="close" src="${path}/STATIC/wxStatic/image/read/icon2.png"></div>
								<div class="readintro readcont_tup">
									<div class="nc">
										<div>
											<div class="huigtit"><em>◆</em><span>故事妈妈讲故事</span><em>◆</em></div>
											<ul class="tupic clearfix">
												<li><img src="${path}/STATIC/wxStatic/image/read/pic76.jpg" width="270" height="162"></li>
												<li><img src="${path}/STATIC/wxStatic/image/read/pic77.jpg" width="270" height="162"></li>
											</ul>
											<p>　　2012年上海图书馆学会年会上“故事妈妈讲故事”作为未成年阅读推广活动展示项目，得到了浙江大学教授李超平、嘉兴市图书馆馆长的高度评价。2013年“故事妈妈讲故事” 活动荣获中国图书馆学会未成年人服务优秀案例三等奖。</p>
											<div class="huigtit"><em>◆</em><span>作家教你写作文</span><em>◆</em></div>
											<ul class="tupic clearfix">
												<li><img src="${path}/STATIC/wxStatic/image/read/pic78.jpg" width="270" height="162"></li>
												<li><img src="${path}/STATIC/wxStatic/image/read/pic79.jpg" width="270" height="162"></li>
											</ul>
											<p>　　作为浦东新区青少年阅读基地，浦东图书馆少儿馆自2012年1月开始每月为中小学生和家长邀请一位儿童文学作家来馆讲座，就少儿阅读与写作主题作交流指导。</p>
											<div class="huigtit"><em>◆</em><span>少儿国学沙龙</span><em>◆</em></div>
											<ul class="tupic clearfix">
												<li><img src="${path}/STATIC/wxStatic/image/read/pic80.jpg" width="270" height="162"></li>
												<li><img src="${path}/STATIC/wxStatic/image/read/pic81.jpg" width="270" height="162"></li>
											</ul>
											<p>　　浦东图书馆国学沙龙于2012年10月13日在浦东图书馆217多媒体教室正式启动。截止2016年9月底已开展137场，参与人次近7000人次。</p>
											<div class="huigtit"><em>◆</em><span>图书小管家</span><em>◆</em></div>
											<ul class="tupic clearfix">
												<li><img src="${path}/STATIC/wxStatic/image/read/pic82.jpg" width="270" height="162"></li>
												<li><img src="${path}/STATIC/wxStatic/image/read/pic83.jpg" width="270" height="162"></li>
											</ul>
											<p>　　图书小管家活动，使小读者们爱上了图书馆，也让他们更加深刻的体会了“奉献、友爱、互助、进步”的志愿精神。</p>
										</div>
									</div>
								</div>
							</div>
						</li>
						<li>
							<div class="pic"><img class="pic1" src="${path}/STATIC/wxStatic/image/read/pic26.png" width="185" height="185"></div>
							<div class="char">南汇分馆活动</div>
							<div class="readcont jz660">
								<div class="tit">南汇分馆活动<img class="close" src="${path}/STATIC/wxStatic/image/read/icon2.png"></div>
								<div class="readintro readcont_tup">
									<div class="nc">
										<div>
											<div class="huigtit"><em>◆</em><span>我们爱科学</span><em>◆</em></div>
											<ul class="tupic clearfix">
												<li><img src="${path}/STATIC/wxStatic/image/read/pic46.jpg" width="270" height="162"></li>
												<li><img src="${path}/STATIC/wxStatic/image/read/pic47.jpg" width="270" height="162"></li>
											</ul>
											<p>　　南汇分馆特邀共建单位老师为小读者带来主题新颖、寓教于乐的科普知识问答、科普实验揭秘、DIY科技小制作等主题活动。“活动”让读者们增长了科学知识，锻炼了动手能力，受到了读者和家长们的热烈欢迎。</p>
											<div class="huigtit"><em>◆</em><span>英语沙龙</span><em>◆</em></div>
											<ul class="tupic clearfix">
												<li><img src="${path}/STATIC/wxStatic/image/read/pic48.jpg" width="270" height="162"></li>
												<li><img src="${path}/STATIC/wxStatic/image/read/pic49.jpg" width="270" height="162"></li>
											</ul>
											<p>　　南汇分馆“英语沙龙”活动旨在为小读者们带来“惬意美式下午茶”。通过邀请共建单位外教老师为小读者带来主题新颖、寓教于乐的阅读、写作、音乐、DIY制作、才艺等跨文化主题系列活动。活动每两周一次。</p>
										</div>
									</div>
								</div>
							</div>
						</li>
						
					</ul>
					<img class="benewm" style="display:block;width:300px;height:auto; position: absolute;left:50%;margin-left:-150px; bottom:100px;" src="${path}/STATIC/wxStatic/image/read/pic1_7.png">
					<div class="tanchu"></div>
		        </div>
		</div>
	    <img class="jian" src="${path}/STATIC/wxStatic/image/read/icon1.png">
	</div>
</body>
</html>
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>安康文化云·2016曼舞长宁</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	
	<script>
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '安康文化云·2016曼舞长宁';
	    	appShareDesc = '舞蹈艺术欣赏季“乐享节拍”踢踏舞推广秀';
	    	appShareImgUrl = '${basePath}/STATIC/wxStatic/image/changning/cnShare.jpg';
	    	
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
					title: "安康文化云·2016曼舞长宁",
					desc: '舞蹈艺术欣赏季“乐享节拍”踢踏舞推广秀',
					imgUrl: '${basePath}/STATIC/wxStatic/image/changning/cnShare.jpg'
				});
				wx.onMenuShareTimeline({
					title: "安康文化云·2016曼舞长宁",
					imgUrl: '${basePath}/STATIC/wxStatic/image/changning/cnShare.jpg'
				});
				wx.onMenuShareQQ({
					title: "安康文化云·2016曼舞长宁",
					desc: '舞蹈艺术欣赏季“乐享节拍”踢踏舞推广秀',
					imgUrl: '${basePath}/STATIC/wxStatic/image/changning/cnShare.jpg'
				});
				wx.onMenuShareWeibo({
					title: "安康文化云·2016曼舞长宁",
					desc: '舞蹈艺术欣赏季“乐享节拍”踢踏舞推广秀',
					imgUrl: '${basePath}/STATIC/wxStatic/image/changning/cnShare.jpg'
				});
				wx.onMenuShareQZone({
					title: "安康文化云·2016曼舞长宁",
					desc: '舞蹈艺术欣赏季“乐享节拍”踢踏舞推广秀',
					imgUrl: '${basePath}/STATIC/wxStatic/image/changning/cnShare.jpg'
				});
			});
		}
		
		$(function () {
			$('.cnlist ul').css({
				'width' : $('.cnlist li').eq(0).outerWidth(true) * $('.cnlist li').length
			});
			$('.cnlist li').bind('click', function () {
				$('.cnlist li').removeClass('current');
				$(this).addClass('current');
				var txt = $(this).find('.cnrq').clone();
				$('.cnrqcont').html(txt);
			});
			$('.cnlist li').eq(0).click();

			$('.ppsthd_wc .ppsthd .ptit').bind('click',function () {
				var z = $(this).parents('.ppsthd');
				if(z.hasClass('current')) {
					z.removeClass('current');
					z.find('.neir').slideDown(400);
				} else {
					z.addClass('current');
					z.find('.neir').slideUp(400);
				}
			});

			// 社团剧照
			var stjzW = 0;
			$('.ppsthd .neir .stjz li').each(function () {
				stjzW += 314;
			});
			$('.ppsthd .neir .stjz').css('width',stjzW);

			//分享
			$(".fs").click(function() {
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
	</style>
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${basePath}/STATIC/wxStatic/image/changning/cnShare.jpg"/></div>
	<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
		<img src="${path}/STATIC/wechat/image/commonShare.png" style="width: 100%;height: 100%;" />
	</div>
	<div class="chnzt">
		<div class="cban">
			<img src="${path}/STATIC/wxStatic/image/changning/banner.jpg" width="750" height="330">
			<a class="fs"><img src="${path}/STATIC/wxStatic/image/changning/pic1.png"></a>
		</div>
		<div class="cnlist">
			<div class="jz704">
				<ul class="clearfix">
					<li><a href="javascript:;">09/20</a>
						<div class="cnrq">
							<div class="pic"><img src="${path}/STATIC/wxStatic/image/changning/pic2.png" width="750" height="300"></div>
							<div class="char jz704">
								<p>
									演出方：台湾舞工厂踢踏舞团<br>
									时间：9月20日（周二）中午12:00<br>
									地点：茅台路179号 金虹桥国际中心APITA广场LG2<br/>
									直接前往观看，无需订票
								</p>
								<div class="biao">
									<span>快闪</span>
									<span>酷炫</span>
									<span>街头</span>
									<span>正能量</span>
									<span>抛开烦恼</span>
								</div>
							</div>
						</div>
					</li>
					<li><a href="javascript:;">09/21</a>
						<div class="cnrq">
							<div class="pic"><img src="${path}/STATIC/wxStatic/image/changning/pic2.png" width="750" height="300"></div>
							<div class="char jz704">
								<p>
									演出方：台湾舞工厂踢踏舞团<br>
									时间：9月21日（周三）下午3:30<br>
									地点：仙霞路1111号 上海交通大学医学院附属同仁医院候诊大厅<br/>
									直接前往观看，无需订票
								</p>
								<div class="biao">
									<span>快闪</span>
									<span>酷炫</span>
									<span>公益</span>
								</div>
							</div>
						</div>
					</li>
					<li><a href="javascript:;">09/23</a>
						<div class="cnrq">
							<div class="pic"><img src="${path}/STATIC/wxStatic/image/changning/pic2.png" width="750" height="300"></div>
							<div class="char jz704">
								<p>
									演出方：台湾舞工厂踢踏舞团<br>
									时间：9月23日（周五）晚上7:15<br>
									地点：仙霞路650号 长宁文化艺术中心四楼剧场（近安龙路）
								</p>
								<div class="dingp hkActBtnOffline">已结束</div>
							</div>
						</div>
					</li>
					<li><a href="javascript:;">09/24</a>
						<div class="cnrq">
							<div class="pic"><img src="${path}/STATIC/wxStatic/image/changning/pic2.png" width="750" height="300"></div>
							<div class="char jz704">
								<p>
									演出方：台湾舞工厂踢踏舞团<br>
									时间：9月24日（周六）下午4:00<br>
									地点：仙霞西路88号 西郊百联商场中庭广场（近剑河路）<br/>
									直接前往观看，无需订票
								</p>
								<div class="biao">
									<span>商圈</span>
									<span>原创</span>
									<span>中国风</span>
									<span>踢踏舞</span>
								</div>
							</div>
						</div>
					</li>
				</ul>
			</div>
		</div>
		<div class="cnrqcont"></div>
		<div class="ppsthd_wc">
			<div class="ppsthd ppsthd_margin" style="border-top: none;">
				<div class="jz704">
					<h3 class="ptit"><span>品牌介绍</span></h3>
					<div class="neir">
						<p><span class="kt">“曼舞长宁”</span> 是长宁区文化局自2014年起创设的以舞蹈为主题的文化品牌活动，以普及、引领市民对舞蹈艺术的欣赏、学习、交流、体验等为目标，结合国际舞蹈中心在长宁的落成，营造舞蹈艺术的氛围。</p>
						<p><img src="${path}/STATIC/wxStatic/image/changning/pic5.png"></p>
						<p>自2014年起，已经邀请了上海市歌舞团、上海舞蹈学院、内蒙古包头市民族歌舞团、厦门小白鹭民间舞艺术中心等专业舞蹈院团参加，同时也推出了长宁区优秀舞蹈原创作品的展演展评、舞蹈艺术推广秀等一系列以群众舞蹈为基础的活动。</p>
						<p>“曼舞长宁”舞蹈季曾获得2014年上海市群众优秀文化品牌活动，2015舞蹈推广秀获得2015年度上海市创新项目奖。今年，舞蹈季既有和北京西城区第一文化馆的群众舞蹈交流，也有邀请台湾舞团进行踢踏舞的推广活动，还融合了国际艺术节的一些国外舞团的演出等等，内容不断创新和拓展。</p>
						<p>2016年，“曼舞长宁”三岁了，今年将主推踢踏舞推广秀版块，此次邀请到了来自台湾的著名踢踏舞团——舞共厂舞团，在九月将相继深入上海校园、医院、商圈，以教学巡演，快闪，舞剧等形式为踢踏舞推广秀献上精彩的巡演。</p>
						<p>今年将有六场巡演活动相继推出，两场为校园活动——《我的鞋子有铁片》</p>
						<br/>
						<p>校园活动是将踢踏舞艺术，以讲演结合的方式，既能对踢踏舞有基本认识，又能让青少年亲身感受踢踏舞的轻松与活力，借此带给莘莘学子“平易近人”的艺术新体验，寻找出自己的新的兴趣及方向。</p>
						<br/>
						<p>演出时间：9月20日（周二）下午15:00-16:00</p>
						<p>演出地点：江苏路155号上海市第三女子初级中学</p>
						<br/>
						<p>演出时间：9月23日（周五）下午15:00-16:00</p>
						<p>演出地点：茅台路1111号 上海延安中学</p>
						<br/>
						<p>演出时长：60分钟</p>
						<br/>
						<p>（校园活动不对外开演）</p>
						<br/>
						<p>其他四场活动分别为20，21日的“快闪”，23，24日的“演出”，详情请点击上面的日期参与曼舞长宁的活动哦！</p>
					</div>
				</div>
			</div>
			<div class="ppsthd">
				<div class="jz704">
					<h3 class="ptit"><span>社团介绍</span></h3>
					<div class="neir">
						<p><span class="kt">“舞工厂舞团”</span> 自2001年起，由几位年轻舞者胼手胝足发迹，坚持以兴味十足的美式踢踏舞踢出名堂。主张以“创意节奏”与“东方元素”的精彩制作， 融合传统表演再创新的踢踏舞，于国内推广踢踏艺术，并从台湾出发，将创新饶富创意的台湾踢踏舞在国际舞台上发光，目前已成为台湾顶尖专业的踢踏舞团。</p>
						<p><img src="${path}/STATIC/wxStatic/image/changning/pic6.png"></p>
						<p>
							海外演出经历 <br>
							2015.09 受邀【香港踢踏节】演出；<br>
							2013.09 受邀【印度国际工业展】演出；<br>
							...
						</p>
					</div>
				</div>
			</div>
			<div class="ppsthd ppsthd_margin" style="border-top: none;">
				<div class="jz704">
					<h3 class="ptit"><span>活动介绍</span></h3>
					<div class="neir">
						<p class="pp">在紧张高压的工作中，社会人一定有非常多的压力和烦恼,</p>
						<p class="pp">台湾舞工厂踢踏舞团街头（公共场所）巡回演出的目的,</p>
						<p class="pp">主要是利用短暂的30分钟“快闪”,</p>
						<p class="pp">让市民们在剧场外就可以欣赏到剧场表演,</p>
						<p class="pp">不仅是视觉享受，更是通过这种酷炫、好玩的表演方式，</p>
						<p class="pp">带给城市居民们一种轻松动感的艺术新体验。</p>
					</div>
				</div>
			</div>
			<div class="ppsthd ppsthd_margin" style="border-top: none;">
				<div class="jz704">
					<h3 class="ptit"><span>社团剧照</span></h3>
					<div class="neir">
						<ul class="stjz clearfix">
							<li><img src="${path}/STATIC/wxStatic/image/changning/st1.png" width="290" height="170"></li>
							<li><img src="${path}/STATIC/wxStatic/image/changning/st2.png" width="290" height="170"></li>
							<li><img src="${path}/STATIC/wxStatic/image/changning/st3.png" width="290" height="170"></li>
						</ul>
					</div>
				</div>
			</div>
			<%-- <div class="ppsthd ppsthd_margin" style="border-top: none;">
				<div class="jz704">
					<h3 class="ptit"><span>精彩视频</span></h3>
					<div class="neir">
						<ul class="ppvideo">
							<li>
								<video id="video1" src="http://culturecloud.oss-cn-hangzhou.aliyuncs.com/mp4MultibitrateIn55/%E5%9B%9E%E5%AE%B6%E8%BF%87%E5%B9%B4.mp4"></video>
								<div class="pic" onclick="document.getElementById('video1').play()"><img src="${path}/STATIC/wxStatic/image/changning/sp1.png" width="702" height="320"><div class="pplay"></div></div>
							</li>
							<li>
								<video id="video2" src="http://culturecloud.oss-cn-hangzhou.aliyuncs.com/mp4MultibitrateIn55/%E5%9B%9E%E5%AE%B6%E8%BF%87%E5%B9%B4.mp4"></video>
								<div class="pic" onclick="document.getElementById('video2').play()"><img src="${path}/STATIC/wxStatic/image/changning/sp2.png" width="702" height="320"><div class="pplay"></div></div>
							</li>
							<li>
								<video id="video3" src="http://culturecloud.oss-cn-hangzhou.aliyuncs.com/mp4MultibitrateIn55/%E5%9B%9E%E5%AE%B6%E8%BF%87%E5%B9%B4.mp4"></video>
								<div class="pic" onclick="document.getElementById('video3').play()"><img src="${path}/STATIC/wxStatic/image/changning/sp3.png" width="702" height="320"><div class="pplay"></div></div>
							</li>
						</ul>
					</div>
				</div>
			</div> --%>
		</div>
	</div>
</body>
</html>
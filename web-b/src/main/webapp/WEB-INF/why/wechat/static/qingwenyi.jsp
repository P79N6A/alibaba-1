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
<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/normalize.css">
		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/animate.min.css">
		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/swiper-3.3.1.min.css">
		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style2.css">
		<script type="text/javascript" src="${path}/STATIC/wxStatic/js/jquery-2.1.4.min.js"></script>
		<script type="text/javascript" src="${path}/STATIC/wxStatic/js/swiper-3.3.1.jquery.min.js"></script>
		<script type="text/javascript" src="${path}/STATIC/wxStatic/js/swiper.animate1.0.2.min.js"></script>
		<script type="text/javascript" src="${path}/STATIC/wechat/js/jweixin-1.0.0.js"></script>
		<title>轻文艺</title>
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
            		title: "轻文艺|上海免费文化活动周刊",
                    desc: '轻文艺',
                    imgUrl: '${basePath}/STATIC/wxStatic/image/2-1-center.jpg'
                });
            	wx.onMenuShareTimeline({
                    title: "轻文艺|上海免费文化活动周刊",
                    imgUrl: '${basePath}/STATIC/wxStatic/image/2-1-center.jpg'
                });
            });
		});
		</script>
		<style>
			html,
			body,
			.swiper-container {
				width: 100%;
				height: 100%;
			}
			
			p {
				font-size: 12px;
			}
		</style>
	</head>

	<body>
		<div class="swiper-container">

			<div class="swiper-wrapper">

				<!--part1-->
				<div class="swiper-slide">
					<div class="qingwenyi-1">
						<img src="${path}/STATIC/wxStatic/image/2-bg1.jpg" style="" />
						<div class="qingwenyi-1-title" style="">
							<img src="${path}/STATIC/wxStatic/image/2-title.png" width="40%" />
						</div>
						<div class="qingwenyi-1-center" style="">
							<img src="${path}/STATIC/wxStatic/image/2-1-center.jpg" width="95%" />
						</div>
						<div class="qingwenyi-1-down" style="">
							<img src="${path}/STATIC/wxStatic/image/2-title2.png" style="width: 20%;" />
							<p style="font-size: 15px;line-height: 30px;border-bottom: 1px solid #000000;width: 170px;margin: auto;">上海免费文化活动周刊</p>
							<p style="margin-top: 10px;"><img src="${path}/STATIC/wxStatic/image/wenhuayun-logo.png" width="25px"><span style="line-height: 30px;">5月9日上新</span></p>
						</div>
					</div>
				</div>

				<!--part2-->
				<div class="swiper-slide">
					<div class="qingwenyi-2">
						<img src="${path}/STATIC/wxStatic/image/haipaihuihua.jpg" width="95%" style="" />
					</div>
					<div class="qingwenyi-2-title" style="">
						<p style="">海派绘画与文献展|笔墨的超越</p>
					</div>
					<div class="qingwenyi-2-content" style="">
						<p class="qingwenyi-2-content-p1" style=""><img src="${path}/STATIC/wxStatic/image/qingwenyi-icon1.jpg" width="15px" style="margin-right: 5px">刘海粟美术馆分馆(上海市普陀区美术馆)</p>
						<p class="qingwenyi-2-content-p2" style=""><img src="${path}/STATIC/wxStatic/image/qingwenyi-icon2.jpg" width="15px" style="margin-right: 5px">2016.05.18~2016.06.15&nbsp;&nbsp;&nbsp;&nbsp;08:30-16:30</p>
						<p class="qingwenyi-2-content-p3" style="">海派画家是在近两个世纪之交涌现出来的一支活跃而富有生气的画派。他们既秉承传统，又接近现实生活，善于将诗、书、画一体的文人画传统与民间美术传统结合起来…</p>
					</div>
					<div style="text-align: center;position: absolute;bottom: 0px;width: 100%;">
						<button type="button" class="qinwenyi-button" onclick="window.location.href='${path}/wechatActivity/preActivityDetail.do?activityId=e93309717e0c4133a45b872cdc4b2d63'">立即预定</button><br />
						<img src="${path}/STATIC/wxStatic/image/arrow_down.png" />
					</div>
				</div>
				

				<!--part2-->
				<div class="swiper-slide">
					<div class="qingwenyi-2">
						<img src="${path}/STATIC/wxStatic/image/Russia.jpg" width="95%" style="" />
					</div>
					<div class="qingwenyi-2-title" style="">
						<p style="">主题展 | 俄罗斯风情电影主题展</p>
					</div>
					<div class="qingwenyi-2-content" style="">
						<p class="qingwenyi-2-content-p1" style=""><img src="${path}/STATIC/wxStatic/image/qingwenyi-icon1.jpg" width="15px" style="margin-right: 5px">徐汇图书馆满庭芳展厅</p>
						<p class="qingwenyi-2-content-p2" style=""><img src="${path}/STATIC/wxStatic/image/qingwenyi-icon2.jpg" width="15px" style="margin-right: 5px">2016.05.04-2016.06.05&nbsp;&nbsp;&nbsp;&nbsp;10:00-17:00&nbsp;&nbsp;注： 每周四上午休展</p>
						<p class="qingwenyi-2-content-p3" style="">杂今年是俄罗斯的电影年，此次“2016俄罗斯电影主题展”将促进中俄文化交流，帮助读者更深入了解俄罗斯电影，此展将持续至6月5日。</p>
					</div>
					<div style="text-align: center;position: absolute;bottom: 0px;width: 100%;">
						<button type="button" onclick="window.location.href='${path}/wechatActivity/preActivityDetail.do?activityId=c5d8382f65554708a39e55cf1e73ef73'" class="qinwenyi-button">立即预定</button><br />
						<img src="${path}/STATIC/wxStatic/image/arrow_down.png" />
					</div>
				</div>

				<!--part2-->
				<div class="swiper-slide">
					<div class="qingwenyi-2">
						<img src="${path}/STATIC/wxStatic/image/shufazhan.jpg" width="95%" style="" />
					</div>
					<div class="qingwenyi-2-title" style="">
						<p style="">画展 | 海派名家书法画展</p>
					</div>
					<div class="qingwenyi-2-content" style="">
						<p class="qingwenyi-2-content-p1" style=""><img src="${path}/STATIC/wxStatic/image/qingwenyi-icon1.jpg" width="15px" style="margin-right: 5px">长宁.北渔路95号 长宁民俗文化中心二楼海派书画展厅</p>
						<p class="qingwenyi-2-content-p2" style=""><img src="${path}/STATIC/wxStatic/image/qingwenyi-icon2.jpg" width="15px" style="margin-right: 5px">2016.05.09-2016.06.05</p>
						<p class="qingwenyi-2-content-p3" style="">历史有时就像一个万花筒，有些偶然的、并不经意为之的因素出现，往往会导致一种巨大而富有转机的嬗变…</p>
					</div>
					<div style="text-align: center;position: absolute;bottom: 0px;width: 100%;">
						<button type="button" class="qinwenyi-button" onclick="window.location.href='${path}/wechatActivity/preActivityDetail.do?activityId=6e37b7ac659849bb9e6d2480cc12d870'">立即预定</button><br />
						<img src="${path}/STATIC/wxStatic/image/arrow_down.png" />
					</div>
				</div>

				<!--part2-->
				<div class="swiper-slide">
					<div class="qingwenyi-2">
						<img src="${path}/STATIC/wxStatic/image/xuchunyuan.jpg" width="95%" style="" />
					</div>
					<div class="qingwenyi-2-title" style="">
						<p style="">书画展 | 徐纯原书画展</p>
					</div>
					<div class="qingwenyi-2-content" style="">
						<p class="qingwenyi-2-content-p1" style=""><img src="${path}/STATIC/wxStatic/image/qingwenyi-icon1.jpg" width="15px" style="margin-right: 5px">梅陇路415号梅陇文化馆一楼展厅</p>
						<p class="qingwenyi-2-content-p2" style=""><img src="${path}/STATIC/wxStatic/image/qingwenyi-icon2.jpg" width="15px" style="margin-right: 5px">2016.05.10-2016.05.23&nbsp;&nbsp;&nbsp;&nbsp;08:30-21:00</p>
						<p class="qingwenyi-2-content-p3" style="">徐纯原先生是“系出名门”的书画名家。他绘画师从张辛稼、唐云、王雪涛诸公，作画重笔墨技法，写形传神，尤以画鹰著称。书法受业于高二适、林散之先生，书风刚劲遒媚，自然典雅。徐纯原在艺术领域涉及甚广，但在各领域都有精到之处。</p>
					</div>
					<div style="text-align: center;position: absolute;bottom: 0px;width: 100%;">
						<button type="button" onclick="window.location.href='${path}/wechatActivity/preActivityDetail.do?activityId=3e1ab19e2c8643808c127e5394ab0b8b'" class="qinwenyi-button">立即预定</button><br />
						<img src="${path}/STATIC/wxStatic/image/arrow_down.png" />
					</div>
				</div>

				<!--part2-->
				<div class="swiper-slide">
					<div class="qingwenyi-2">
						<img src="${path}/STATIC/wxStatic/image/天竺.jpg" width="95%" style="" />
					</div>
					<div class="qingwenyi-2-title" style="">
						<p style="">摄影 | 感悟天竺摄影展</p>
					</div>
					<div class="qingwenyi-2-content" style="">
						<p class="qingwenyi-2-content-p1" style=""><img src="${path}/STATIC/wxStatic/image/qingwenyi-icon1.jpg" width="15px" style="margin-right: 5px">青浦.公园路78号青浦文化馆</p>
						<p class="qingwenyi-2-content-p2" style=""><img src="${path}/STATIC/wxStatic/image/qingwenyi-icon2.jpg" width="15px" style="margin-right: 5px">2016.04.28~2016.05.18&nbsp;&nbsp;&nbsp;&nbsp;8:00-18:00</p>
						<p class="qingwenyi-2-content-p3" style="">异域风情，公元前第三千纪的印度河流域文明，让你体验神秘国度的别样魅力…</p>
					</div>
					<div style="text-align: center;position: absolute;bottom: 0px;width: 100%;">
						<button onclick="window.location.href='${path}/wechatActivity/preActivityDetail.do?activityId=e5bf93c5171a443a9e9be1ebd9285bde'" type="button" class="qinwenyi-button">立即预定</button><br />
						<img src="${path}/STATIC/wxStatic/image/arrow_down.png" />
					</div>
				</div>

				<!--part3-->
				<div class="swiper-slide">
					<div class="qingwenyi-3">
						<img src="${path}/STATIC/wxStatic/image/2-bg.jpg" style="" />
						<div class="qingwenyi-3-title" style="">
							<p style="font-size: 26px;">浏览其他免费活动周刊</p>
						</div>
						<div class="qingwenyi-3-center" style="">
							<a href="${path}/wechatStatic/aitongxin.do"><img src="${path}/STATIC/wxStatic/image/2-button1.png"></a>
							<a class="expect"><img src="${path}/STATIC/wxStatic/image/2-button2.png"></a>
						</div>
						<div class="qingwenyi-3-down" style="">
							<img src="${path}/STATIC/wxStatic/image/er.jpg" style="width: 40%;" />
							<p style="margin-top: 10px;"><span style="line-height: 30px;">扫描二维码 关注文化云<br />发现更多品质生活</span></p>
						</div>
						<div class="content-bg" style="display: none;width: 100%;height: 100%;position: absolute;top: 0px;">
							<div style="width: 100%;height:100%;filter:alpha(Opacity=80);-moz-opacity:0.5;opacity: 0.5;background-color: #000;"></div>
							<div style="width: 100%;height: 100%;display: table;position: absolute;top: 0px;">
								<p style="display: table-cell;vertical-align: middle;text-align: center;color: #fff;font-size: 20px;">敬请期待</p>
							</div>
						</div>
					</div>
				</div>

			</div>

		</div>
		<script>
			$(document).ready(function() {
				$(".expect").click(function() {
					$(".content-bg").css("display", "block")
				})
				$(".content-bg").click(function() {
					$(".content-bg").css("display", "none")
				})
			})
		</script>
		<script>
			var mySwiper = new Swiper('.swiper-container', {
				direction: 'vertical',
				onInit: function(swiper) { //Swiper2.x的初始化是onFirstInit
					swiperAnimateCache(swiper); //隐藏动画元素 
					swiperAnimate(swiper); //初始化完成开始动画
				},
				onSlideChangeEnd: function(swiper) {
					swiperAnimate(swiper); //每个slide切换结束时也运行当前slide动画
				}
			})
		</script>
		<!-- 导入统计文件 -->
		<%@include file="/WEB-INF/why/wechat/wechat_statistics.jsp"%>
	</body>
</html>
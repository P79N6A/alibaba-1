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
		<title>爱童心</title>
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
            		title: "爱童心|上海免费文化活动周刊",
                    desc: '爱童心',
                    imgUrl: '${basePath}/STATIC/wxStatic/image/2.jpg'
                });
            	wx.onMenuShareTimeline({
                    title: "爱童心|上海免费文化活动周刊",
                    imgUrl: '${basePath}/STATIC/wxStatic/image/2.jpg'
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
		</style>
	</head>

	<body>

		<div class="swiper-container">

			<div class="swiper-wrapper">

				<div class="swiper-slide">
					<div class="content-1-1">
						<img src="${path}/STATIC/wxStatic/image/background2.jpg" />
					</div>
					<div class="content-1-2 ani" swiper-animate-effect="fadeInDown" swiper-animate-duration="0.5s" swiper-animate-delay="0.5s">
						<img src="${path}/STATIC/wxStatic/image/title.png" />
					</div>
					<div class="content-1-3 ani" swiper-animate-effect="fadeInLeft" swiper-animate-duration="0.5s" swiper-animate-delay="1.0s">
						<h2>烽火小课堂</h2>
						<p>美食&nbsp;娱乐&nbsp;亲子&nbsp;手工</p>
					</div>
					<div class="content-1-4 ani" swiper-animate-effect="fadeInLeft" swiper-animate-duration="0.5s" swiper-animate-delay="1.5s">
						<img src="${path}/STATIC/wxStatic/image/font-bg.png" />
						<p>上海免费文化活动周刊</p>
					</div>
					<div class="content-1-5 ani" swiper-animate-effect="fadeInUpBig" swiper-animate-duration="0.5s" swiper-animate-delay="2.0s">
						<img src="${path}/STATIC/wxStatic/image/logo.png" />
						<p>5月9日上新</p>
						<div style="clear: both;"></div>
					</div>
					<div class="content-downpage">
						<img src="${path}/STATIC/wxStatic/image/arrow_down.png" />
					</div>
				</div>

				<div class="swiper-slide">
					<div class="content-2-1 ani" swiper-animate-effect="fadeInLeft" swiper-animate-duration="0.5s" swiper-animate-delay="0.5s">
						<img class="img-2-1" src="${path}/STATIC/wxStatic/image/img-bg.png" />
						<img class="img-2-2" src="${path}/STATIC/wxStatic/image/aiqinzi.jpg" />
					</div>
					<div class="content-2-2 ani" swiper-animate-effect="fadeInRight" swiper-animate-duration="0.5s" swiper-animate-delay="1.0s">
						<img src="${path}/STATIC/wxStatic/image/time.jpg" />
						<p class="p-2-2-1">2016.5.4</p>
						<p class="p-2-2-2">2016.8.31</p>
						<p class="p-2-2-3">09:00-17:00</p>
					</div>
					<div class="content-2-3 ani" swiper-animate-effect="rollIn" swiper-animate-duration="0.5s" swiper-animate-delay="1.5s">
						<img src="${path}/STATIC/wxStatic/image/font-bg2.png" />
						<div class="p-2-3">
							<h2>陈伯吹 | 原创插画展作品征集</h2>
							<p class="p-2-3-2"><img src="${path}/STATIC/wxStatic/image/pce.png" style="width: 15px;height:20px" />上海宝山国际民间艺术博览馆</p>
							<p class="p-2-3-3">无论你是绘画爱好者，还是专业插画师，只要你想一展画技，都可以来报名参展哦！</p>

						</div>
						<button type="button" onclick="window.location.href='${path}/wechatActivity/preActivityDetail.do?activityId=0aaf1ed3f6e44c99b9e83f6f78048fb8'">立即预约</button>
					</div>
					<div class="content-downpage">
						<img src="${path}/STATIC/wxStatic/image/arrow_down.png" />
					</div>
				</div>
				
				<div class="swiper-slide">
					<div class="content-2-1 ani" swiper-animate-effect="fadeInLeft" swiper-animate-duration="0.5s" swiper-animate-delay="0.5s">
						<img class="img-2-1" src="${path}/STATIC/wxStatic/image/img-bg.png" />
						<img class="img-2-2" src="${path}/STATIC/wxStatic/image/1.jpg" />
					</div>
					<div class="content-2-2 ani" swiper-animate-effect="fadeInRight" swiper-animate-duration="0.5s" swiper-animate-delay="1.0s">
						<img src="${path}/STATIC/wxStatic/image/time.jpg" />
						<p class="p-2-2-1">2016.4.7</p>
						<p class="p-2-2-2">2016.5.31</p>
						<p class="p-2-2-3">13:00-15:00</p>
					</div>
					<div class="content-2-3 ani" swiper-animate-effect="rollIn" swiper-animate-duration="0.5s" swiper-animate-delay="1.5s">
						<img src="${path}/STATIC/wxStatic/image/font-bg2.png" />
						<div class="p-2-3">
							<h2>甜点 | 甜心，我们一起来做点心</h2>
							<p class="p-2-3-2"><img src="${path}/STATIC/wxStatic/image/pce.png" style="width: 15px;height:20px" />周家桥.社区文化活动中心</p>
							<p class="p-2-3-3">用简单的食材做出一份属于你和甜心的专属点心，一个慵懒的下午，就是这么幸福…</p>

						</div>
						<button type="button" onclick="window.location.href='${path}/wechatActivity/preActivityDetail.do?activityId=4cb5bbce26cf4f14931b84f3fce18740'">立即预约</button>
					</div>
					<div class="content-downpage">
						<img src="${path}/STATIC/wxStatic/image/arrow_down.png" />
					</div>
				</div>

				<div class="swiper-slide">
					<div class="content-2-1 ani" swiper-animate-effect="fadeInLeft" swiper-animate-duration="0.5s" swiper-animate-delay="0.5s">
						<img class="img-2-1" src="${path}/STATIC/wxStatic/image/img-bg.png" />
						<img class="img-2-2" src="${path}/STATIC/wxStatic/image/caihuimengxiang.jpg" />
					</div>
					<div class="content-2-2 ani" swiper-animate-effect="fadeInRight" swiper-animate-duration="0.5s" swiper-animate-delay="1.0s">
						<img src="${path}/STATIC/wxStatic/image/time.jpg" />
						<p class="p-2-2-1">2016.5.10</p>
						<p class="p-2-2-2">2016.6.9</p>
						<p class="p-2-2-3">08:30-17:00</p>
					</div>
					<div class="content-2-3 ani" swiper-animate-effect="rollIn" swiper-animate-duration="0.5s" swiper-animate-delay="1.5s">
						<img src="${path}/STATIC/wxStatic/image/font-bg2.png" />
						<div class="p-2-3">
							<h2>看展 | 彩绘梦想 墨舞青春</h2>
							<p class="p-2-3-2"><img src="${path}/STATIC/wxStatic/image/pce.png" style="width: 15px;height:20px" />长桥社区文化活动中心</p>
							<p class="p-2-3-3">一幅幅主题突出、形式新颖、风格鲜明、稚趣盎然的绘画作品，凝聚着老师和学生的智慧和心血，家长带着孩子一起来领略校园艺术的盛宴。</p>

						</div>
						<button type="button" onclick="window.location.href='${path}/wechatActivity/preActivityDetail.do?activityId=f77d80455c7243f2b50050b0ee7dc57b'">立即预约</button>
					</div>
					<div class="content-downpage">
						<img src="${path}/STATIC/wxStatic/image/arrow_down.png" />
					</div>
				</div>

				<div class="swiper-slide">
					<div class="content-2-1 ani" swiper-animate-effect="fadeInLeft" swiper-animate-duration="0.5s" swiper-animate-delay="0.5s">
						<img class="img-2-1" src="${path}/STATIC/wxStatic/image/img-bg.png" />
						<img class="img-2-2" src="${path}/STATIC/wxStatic/image/3.jpg" />
					</div>
					<div class="content-2-2 ani" swiper-animate-effect="fadeInRight" swiper-animate-duration="0.5s" swiper-animate-delay="1.0s">
						<img src="${path}/STATIC/wxStatic/image/time.jpg" />
						<p class="p-2-2-1">2016.3.30</p>
						<p class="p-2-2-2">2016.5.31</p>
						<p class="p-2-2-3">9:00-17:00</p>
					</div>
					<div class="content-2-3 ani" swiper-animate-effect="rollIn" swiper-animate-duration="0.5s" swiper-animate-delay="1.5s">
						<img src="${path}/STATIC/wxStatic/image/font-bg2.png" />
						<div class="p-2-3">
							<h2>踏青 | 春季到“河口”来看鸟</h2>
							<p class="p-2-3-2"><img src="${path}/STATIC/wxStatic/image/pce.png" style="width: 15px;height:20px" />宝山.上海长江河口科技馆</p>
							<p class="p-2-3-3">春天，百花盛开，候鸟迁徙，与宝宝一起疯在大自然，看万物复苏，聆听百鸟歌唱…</p>

						</div>
						<button type="button" onclick="window.location.href='${path}/wechatActivity/preActivityDetail.do?activityId=1cd80644d5344449b3c208b2ea609757'">立即预约</button>
					</div>
					<div class="content-downpage">
						<img src="${path}/STATIC/wxStatic/image/arrow_down.png" />
					</div>
				</div>

				<div class="swiper-slide">
					<div class="content-2-1 ani" swiper-animate-effect="fadeInLeft" swiper-animate-duration="0.5s" swiper-animate-delay="0.5s">
						<img class="img-2-1" src="${path}/STATIC/wxStatic/image/img-bg.png" />
						<img class="img-2-2" src="${path}/STATIC/wxStatic/image/5.jpg" />
					</div>
					<div class="content-2-2 ani" swiper-animate-effect="fadeInRight" swiper-animate-duration="0.5s" swiper-animate-delay="1.0s">
						<img src="${path}/STATIC/wxStatic/image/time.jpg" />
						<p class="p-2-2-1">2016.5.13</p>
						<p class="p-2-2-2">2016.5.13</p>
						<p class="p-2-2-3">16:00-17:30</p>
					</div>
					<div class="content-2-3 ani" swiper-animate-effect="rollIn" swiper-animate-duration="0.5s" swiper-animate-delay="1.5s">
						<img src="${path}/STATIC/wxStatic/image/font-bg2.png" />
						<div class="p-2-3">
							<h2>创意 | 万花筒亲子创意沙龙</h2>
							<p class="p-2-3-2"><img src="${path}/STATIC/wxStatic/image/pce.png" style="width: 15px;height:20px" />杨浦.延吉新村街道社区文化活动中心</p>
							<p class="p-2-3-3">嘿，小小的你可知道大大的世界有多斑斓？在色彩斑斓的世界里，窥见探索的创意…</p>

						</div>
						<button type="button" onclick="window.location.href='${path}/wechatActivity/preActivityDetail.do?activityId=9bdd210e009b439f86b00e34d287b3ed'">立即预约</button>
					</div>
					<div class="content-downpage">
						<img src="${path}/STATIC/wxStatic/image/arrow_down.png" />
					</div>
				</div>

				<div class="swiper-slide">
					<div class="content-3-1">
						<img src="${path}/STATIC/wxStatic/image/background.jpg" />
					</div>
					<div class="content-3-2">
						<h2>浏览其他免费活动周刊</h2>
						<a href="${path}/wechatStatic/qingwenyi.do" class="content-3-2-1"><img src="${path}/STATIC/wxStatic/image/end-button2.png" /></a>
						<a class="content-3-2-2"><img src="${path}/STATIC/wxStatic/image/end-button1.png" /></a>
						<img class="content-er" src="${path}/STATIC/wxStatic/image/er.jpg" />
						<p style="color: #489baf;font-size: 12px;">扫描二维码&nbsp;关注文化云</p>
						<p style="color: #489baf;font-size: 12px;">发现更多品质生活</p>
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
		<script>
			$(document).ready(function() {
				$(".content-3-2-2").click(function() {
					$(".content-bg").css("display", "block")
				})
				$(".content-bg").click(function(){
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
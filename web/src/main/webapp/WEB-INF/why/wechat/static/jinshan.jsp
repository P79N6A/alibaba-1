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
		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/normalize.css">
		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/common.css">
		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/animate.min.css">
		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/swiper-3.3.1.min.css">
		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style.css">
		<script type="text/javascript" src="${path}/STATIC/wxStatic/js/jquery-2.1.4.min.js"></script>
		<script type="text/javascript" src="${path}/STATIC/wxStatic/js/swiper-3.3.1.jquery.min.js"></script>
		<script type="text/javascript" src="${path}/STATIC/wxStatic/js/swiper.animate1.0.2.min.js"></script>
		<script type="text/javascript" src="${path}/STATIC/wechat/js/jweixin-1.2.0.js"></script>
		<title>《金山味》第二期 甜瓜篇</title>
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
            		title: "《金山味》第二期 甜瓜篇",
                    desc: '金山味-仲夏之恋的甜瓜和幸福之间',
                    imgUrl: '${basePath}/STATIC/wxStatic/image/jinshan-1.jpg'
                });
            	wx.onMenuShareTimeline({
                    title: "《金山味》第二期 甜瓜篇",
                    imgUrl: '${basePath}/STATIC/wxStatic/image/jinshan-1.jpg'
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
			
			.jinshan-1 {
				position: relative;
			}
			
			.jinshan-1 img {
				display: block;
				border: 0px;
			}
		</style>
	</head>

	<body>
		<div class="swiper-container">

			<div class="swiper-wrapper">

				<!--part1-->
				<div class="swiper-slide">
					<div class="jinshan-1" style="width: 100%;height: 100%;text-align: center;">
						<img src="${path}/STATIC/wxStatic/image/jinshan-1.jpg" width="100%" />

						<div style="padding: 20px;">
							<p><br />记得儿时，在仲夏之夜，捧着瓜儿，听着外婆哼着金山味儿的词曲。<br />重回故里，那段甜蜜不曾忘记，那段感慨不曾减灭。<br /><br />壹城壹味<br /><br /><span style="font-weight: bold;font-size: 16px;">《金山味》第二期 甜瓜篇</span></p>
						</div>

					</div>
					<div class="content-downpage">
						<img src="${path}/STATIC/wxStatic/image/arrow_down.png" />
					</div>
				</div>

				<!--part2-->
				<div class="swiper-slide">
					<div class="jinshan-1" style="width: 100%;height: 100%;text-align: center;">
						<p style="margin-top: 20px;font-weight: bold;font-size: 16px;">Hold in人士主选の珠丰甜瓜<br /></p>
						<img style="width: 100%;margin-top: 20px;" src="${path}/STATIC/wxStatic/image/jinshan-2.jpg" />
						<div style="padding: 20px;text-align: center;"><br />
							<p style="">在金山，夏天的时候一定要吃一下朱泾的珠丰甜瓜。<br />这种瓜瓜瓤淡绿色，肉厚籽小，细嫩多汁。<br />糖度高达17度,远高于普通甜瓜的12~13度。
							</p>
						</div>

					</div>
					<div class="content-downpage">
						<img src="${path}/STATIC/wxStatic/image/arrow_down.png" />
					</div>
				</div>

				<!--part2-->
				<div class="swiper-slide">
					<div class="jinshan-1" style="width: 100%;height: 100%;text-align: center;">
						<p style="margin-top: 20px;font-weight: bold;font-size: 16px;">珠丰甜瓜の传说<br /></p>
						<img style="width: 100%;margin-top: 20px;" src="${path}/STATIC/wxStatic/image/jinshan-3.jpg" />
						<div style="padding: 20px;text-align: left;">
							<p style="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;据说，很久以前，有一个叫船子和尚的佛门高僧，飘然一舟，泛于朱泾日照湾一带，顺便做善事渡客。受惠于船子和尚摆渡便利的当地瓜农，每每以这种甜瓜相馈，船子和尚则把瓜农馈赠的甜瓜，敬献给东林寺佛祖。千百年来，甜瓜成为佛堂供果，自然有了一股仙气、灵气。</p>
						</div>

					</div>
					<div class="content-downpage">
						<img src="${path}/STATIC/wxStatic/image/arrow_down.png" />
					</div>
				</div>

				<!--part2-->
				<div class="swiper-slide">
					<div class="jinshan-1" style="width: 100%;height: 100%;text-align: center;">
						<p style="margin-top: 20px;font-weight: bold;font-size: 16px;">特供の“多利升”西瓜<br /></p>
						<img style="width: 100%;margin-top: 20px;" src="${path}/STATIC/wxStatic/image/jinshan-4.jpg" />
						<div style="padding: 20px;text-align: center;">
							<p style=""><br />在金山东南滨海地区的漕泾，还有一种注册商标为“多利升”的红瓤西瓜。<br />这种西瓜，果型呈椭圆型，单瓜重1.5-2公斤。<br />果皮薄且不易裂果；瓜瓤红色，色泽诱人。<br />08年北京奥运会期间，“多利升”还是特供西瓜。
							</p>
						</div>

					</div>
					<div class="content-downpage">
						<img src="${path}/STATIC/wxStatic/image/arrow_down.png" />
					</div>
				</div>

				<!--part2-->
				<div class="swiper-slide">
					<div class="jinshan-1" style="width: 100%;height: 100%;text-align: center;">
						<p style="margin-top: 20px;font-weight: bold;font-size: 16px;">解渴佳品の“金山小皇冠”西瓜<br /></p>
						<img style="width: 100%;margin-top: 20px;" src="${path}/STATIC/wxStatic/image/jinshan-5.jpg" />
						<div style="padding: 20px;text-align: center;">
							<p style=""><br />我不一样，我不是红囊西瓜，我是黄囊的瓜瓜哦！<br />"金山小皇冠”可是上海市著名商标。<br />它口味个小皮薄、鲜甜多汁，平均瓜重4至5斤，是消暑解渴的绿色佳品

							</p>
						</div>

					</div>
					<div class="content-downpage">
						<img src="${path}/STATIC/wxStatic/image/arrow_down.png" />
					</div>
				</div>

				<!--part2-->
				<div class="swiper-slide">
					<div class="jinshan-1" style="width: 100%;height: 100%;text-align: center;">
						<p style="margin-top: 20px;font-weight: bold;font-size: 16px;">甜心宝贝の“亭林”雪瓜<br /></p>
						<img style="width: 100%;margin-top: 20px;" src="${path}/STATIC/wxStatic/image/jinshan-6.jpg" />
						<div style="padding-left: 20px;padding-right: 20px;text-align: center;">
							<p style="line-height: 14px;"><br />作为上海本地四大名瓜之一，已有百年的种植历史，是珍贵的农家甜瓜品种。<br />亭林雪瓜与三林崩瓜、七宝黄金瓜、崇明金瓜并称为上海四大传统名瓜。<br />成熟的亭林雪瓜每只个头在7、8两左右。<br />切开后，瓜瓤泛白清澈，皮薄肉嫩，香甜脆爽。
							</p>
						</div>

					</div>
					<div class="content-downpage">
						<img src="${path}/STATIC/wxStatic/image/arrow_down.png" />
					</div>
				</div>

				<!--part3-->
				<div class="swiper-slide">
					<div class="jinshan-1" style="width: 100%;height: 100%;text-align: center;">
						<img style="width: 100%;" src="${path}/STATIC/wxStatic/image/jinshan-7.png" />
						<div style="padding: 20px;text-align: center;">
							<p>金山最“嚣张”哒瓜都在这里！你还不赶紧走起来，<br />安慰自己的口水和胃？<br />wuli金山好吃的辣么多！都不着急吃！<br />只有甜瓜！现在不吃，过一阵子就吃不到第一茬了！<br />快点，偷偷去吃到飞起！<br /><br /><br /><span style="font-weight: bold;">•END•</span></p>
						</div>
					</div>
				</div>

			</div>

		</div>
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
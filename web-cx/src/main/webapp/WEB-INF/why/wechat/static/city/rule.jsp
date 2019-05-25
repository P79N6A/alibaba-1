<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>佛山文化云·邀你一起打造上海城市名片</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	
	<script>
		var cityType = 7;	//本次活动编号
	
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '佛山文化云·邀你一起打造上海城市名片';
	    	appShareDesc = '每个月一个主题，征集你在上海各种空间的图片记忆，爱上海，从我做起。';
	    	appShareImgUrl = 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017619141137Pz9rTSsCpWWwOhcnGgZhWu1lxgP9Dh.jpg';
	    	
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
					title: "佛山文化云·邀你一起打造上海城市名片",
					desc: '每个月一个主题，征集你在上海各种空间的图片记忆，爱上海，从我做起。',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017619141137Pz9rTSsCpWWwOhcnGgZhWu1lxgP9Dh.jpg'
				});
				wx.onMenuShareTimeline({
					title: "佛山文化云·邀你一起打造上海城市名片",
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017619141137Pz9rTSsCpWWwOhcnGgZhWu1lxgP9Dh.jpg'
				});
				wx.onMenuShareQQ({
					title: "佛山文化云·邀你一起打造上海城市名片",
					desc: '每个月一个主题，征集你在上海各种空间的图片记忆，爱上海，从我做起。',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017619141137Pz9rTSsCpWWwOhcnGgZhWu1lxgP9Dh.jpg'
				});
				wx.onMenuShareWeibo({
					title: "佛山文化云·邀你一起打造上海城市名片",
					desc: '每个月一个主题，征集你在上海各种空间的图片记忆，爱上海，从我做起。',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017619141137Pz9rTSsCpWWwOhcnGgZhWu1lxgP9Dh.jpg'
				});
				wx.onMenuShareQZone({
					title: "佛山文化云·邀你一起打造上海城市名片",
					desc: '每个月一个主题，征集你在上海各种空间的图片记忆，爱上海，从我做起。',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017619141137Pz9rTSsCpWWwOhcnGgZhWu1lxgP9Dh.jpg'
				});
			});
		}
		
		$(function () {
			navFixed($(".kjmbNav"),'touchmove',240);
		    navFixed($(".kjmbNav"),'scroll',240);
		    
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
			//关注
			$(".keep-button").on("touchstart", function() {
				$('.div-share').show()
				$("body,html").addClass("bg-notouch")
			})
            
		});
		
		// 导航固定
	    function navFixed(ele, type, topH) {
	        $(document).on(type, function() {
	            if($(document).scrollTop() > topH) {
	                ele.css('position', 'fixed');
	            } else {
	                ele.css('position', 'static');
	            }
	        });
	    }
		
	</script>
	
	<style>
		html,body {height: 100%;}
		.roomage {min-height: 100%;}
	</style>
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017619141137Pz9rTSsCpWWwOhcnGgZhWu1lxgP9Dh.jpg"/></div>
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
	<div class="roomage">
		<div class="lccbanner">
			<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201761910580PO8neFr00YNFpdQh9scgaNJrKOc3wH.jpg" width="750" height="250">
			<ul class="lccshare clearfix">
				<li class="share-button"><a href="javascript:;">分享</a></li>
				<li class="keep-button"><a href="javascript:;">关注</a></li>
			</ul>
		</div>
		<div class="kjmbNav_wc">
			<ul class="kjmbNav clearfix">
				<li><a href="${path}/wechatFunction/cityIndex.do?tab=1">首页</a></li>
				<li><a href="${path}/wechatFunction/cityRanking.do">排行榜</a></li>
				<li class="current"><a href="${path}/wechatFunction/cityRule.do">活动规则</a></li>
				<li><a href="${path}/wechatFunction/cityReview.do">往期回顾</a></li>
			</ul>
		</div>
		<div class="roomcont jz700 roomguize_wc">
	        <div class="roomguize">
	            <div class="jz645">
	                <div class="jinhaotit">
	                    <div class="h1">#&nbsp;&nbsp;参与方式&nbsp;&nbsp;#</div>
	                </div>
	                <ol>
	                    <li>将你拍摄的“弄堂里 老洋房”的照片，上传至活动页面，提交时留下正确的个人信息（作为颁发奖品的联系方式）。成功参与立享500积分；
	                        <div class="juh">
	                            <p style="margin-bottom:10px;">* 您可以多次上传图片，但是积分只赠送一次，毕 竟我们共同的目标是让更多人欣赏和接近文化生活。</p>
	                        </div>
	                    </li>
	                    <li>你可以发布多组图片，每组照片最多有9张；</li>
	                    <li>添加照片描述，可让你的作品看起来更富文化魅力；</li>
	                    <li>请亲朋好友为你的作品点赞，即可获得更多奖励。
	                        <div class="juh">
	                            <p style="margin-bottom:10px;">* 每个用户每天可以为多个作品投票，但是对同一个作品每天只能投1票喔！（每天都可以来投票哟~）</p>
	                        </div>
	                    </li>
	                </ol>
	            </div>
	        </div>
	        <div class="roomguize">
	            <div class="jz645">
	                <div class="jinhaotit">
	                    <div class="h1">#&nbsp;&nbsp;活动奖励&nbsp;&nbsp;#</div>
	                </div>
	                <ol>
	                    <li>参与成功可立享500积分，发布9张照片的，可再额外获得200积分（照片不可重复，文化云有权对同一用户同一角度高相似度的作品做删除处理）；</li>
	                    <li>作品每被投票一票，作者即可获得5分积分奖励；</li>
	                    <li><span style="font-weight:bold;">月度之星：</span>月度点赞排名前5的作品，可获得一份特别定制的文化礼包；</li>
	                    <li><span style="font-weight:bold;">最美空间：</span>文化云专家评审团队会对优秀作品做推送展示，评选出最佳作品，给予积分奖励，请关注文化云官方微信公众号。</li>
	                </ol>
	            </div>
	        </div>
	        <div class="roomguize">
	            <div class="jz645">
	                <div class="jinhaotit">
	                    <div class="h1">#&nbsp;&nbsp;特别注意&nbsp;&nbsp;#</div>
	                </div>
	                <ol>
	                    <li>月度之星每位用户只能获奖一次，如同一用户有两幅作品同时上榜，仅计算其票数最高的作品，奖项相应顺延至下一位排名作品。</li>
	                    <li>发布照片须为个人原创，体现空间之美，不得违反国家法律法规，一旦上传将默认授权主办单位刊发出版照片的相关著作权限。</li>
	                    <li>主办方有权对鉴定非本空间或其他违反法律法规的照片做删除处理，一旦作品被删除，其相关积分和奖品权益即被收回。</li>
	                </ol>
	            </div>
	        </div>
		</div>
	</div>
</body>
</html>
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>安康文化云·我在现场</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css?v=01061228"/>
	
	<script>
	
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '安康文化云·互动赢积分，分享活动现场 展现艺术生活';
	    	appShareDesc = '将你真实感受到的精彩活动现场分享给更多人，精彩就会远远大于你的感受';
	    	appShareImgUrl = '${basePath}/STATIC/wxStatic/image/roomagekind/shareIcon2.jpg';
	    	
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
					title: "安康文化云·互动赢积分，分享活动现场 展现艺术生活",
					desc: '将你真实感受到的精彩活动现场分享给更多人，精彩就会远远大于你的感受',
					imgUrl: '${basePath}/STATIC/wxStatic/image/roomagekind/shareIcon2.jpg'
				});
				wx.onMenuShareTimeline({
					title: "安康文化云·互动赢积分，分享活动现场 展现艺术生活",
					imgUrl: '${basePath}/STATIC/wxStatic/image/roomagekind/shareIcon2.jpg'
				});
				wx.onMenuShareQQ({
					title: "安康文化云·互动赢积分，分享活动现场 展现艺术生活",
					desc: '将你真实感受到的精彩活动现场分享给更多人，精彩就会远远大于你的感受',
					imgUrl: '${basePath}/STATIC/wxStatic/image/roomagekind/shareIcon2.jpg'
				});
				wx.onMenuShareWeibo({
					title: "安康文化云·互动赢积分，分享活动现场 展现艺术生活",
					desc: '将你真实感受到的精彩活动现场分享给更多人，精彩就会远远大于你的感受',
					imgUrl: '${basePath}/STATIC/wxStatic/image/roomagekind/shareIcon2.jpg'
				});
				wx.onMenuShareQZone({
					title: "安康文化云·互动赢积分，分享活动现场 展现艺术生活",
					desc: '将你真实感受到的精彩活动现场分享给更多人，精彩就会远远大于你的感受',
					imgUrl: '${basePath}/STATIC/wxStatic/image/roomagekind/shareIcon2.jpg'
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
	<div style="display: none;"><img src="${basePath}/STATIC/wxStatic/image/roomagekind/shareIcon2.jpg"/></div>
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
			<img src="${path}/STATIC/wxStatic/image/roomagekind/ban2.jpg" width="750" height="250">
			<ul class="lccshare clearfix">
				<li class="share-button"><a href="javascript:;">分享</a></li>
				<li class="keep-button"><a href="javascript:;">关注</a></li>
			</ul>
		</div>
		<div class="kjmbNav_wc">
			<ul class="kjmbNav clearfix">
				<li><a href="${path}/wechatStatic/sceneIndex.do">首页</a></li>
				<li><a href="${path}/wechatStatic/sceneRanking.do">排行榜</a></li>
				<li class="current"><a href="${path}/wechatStatic/sceneRule.do">活动规则</a></li>
				<li><a href="${awardUrl}">获奖名单</a></li>
			</ul>
		</div>
		<div class="roomcont jz700 roomguize_wc">
	        <div class="roomguize">
	            <div class="jz645">
	                <div class="jinhaotit">
	                    <div class="h1">#&nbsp;&nbsp;参与方式&nbsp;&nbsp;#</div>
	                </div>
	                <ol>
	                    <li>将你拍摄的活动现场照片，上传至活动页面，提交时留下正确的个人信息（作为颁发奖品的联系方式），并且选择你上传的活动现场照片的场馆标签；
	                        <ul>
	                            <li style="list-style-type:disc;margin-bottom:30px;margin-top:30px;">成功参与立享100积分；</li>
	                            <li style="list-style-type:disc;margin-bottom:30px;">若过去7天内在指定场馆中存在有效订单，即可额外再增加100积分；（1张活动现场照片+1个有效活动订单=100积分）</li>
	                        </ul>
	                        <div class="juh">* 您可以上传多张图片，立享积分只能获得一次；但额外积分可获得多次，自然月内最高可获得额外积分1000分。</div>
	                        <div class="juh">* 指定场馆为：长宁文化艺术中心、东方艺术中心、上海市群众艺术馆、中华艺术宫、三山会馆、上海博物馆。</div>
	                    </li>
	                    <li>请亲朋好友为你的作品点赞，每月对本月点赞排名前三名的用户各赠送1份特制的文化福袋。
	                        <div class="juh">* 每个用户每天只有1次投票权利，但是可以每天都来投1票喔！</div>
	                        <div class="juh">* 中奖名单查看入口：在文化云微信公众号对话框中回复“中奖名单”进行查看。</div>
	                    </li>
	                </ol>
	            </div>
	        </div>
	        <div class="roomguize">
	            <div class="jz645">
	                <div class="jinhaotit">
	                    <div class="h1">#&nbsp;&nbsp;特别注意&nbsp;&nbsp;#</div>
	                </div>
	                <ol>
	                    <li>月度点赞排名前三名的用户只能获奖一次，如同一用户有两幅作品同时上榜，仅计算其票数最高的作品，奖项相应顺延至下一位排名作品。</li>
	                    <li>发布图片须为个人原创，体现活动现场情况，不得违反国家法律法规，一旦上传将默认授权主办单位刊发出版图片的相关著作权限。</li>
	                    <li>主办方有权对鉴定非活动现场或其他违反法律法规的图片做删除处理，一旦作品被删除，其相关积分和奖品权益即被收回。</li>
	                </ol>
	            </div>
	        </div>
	    </div>
	</div>
</body>
</html>
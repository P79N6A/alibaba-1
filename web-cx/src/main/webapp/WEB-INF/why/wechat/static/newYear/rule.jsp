<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>佛山文化云·带你过最文化的新年</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	
	<script>
	
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '佛山文化云·从圣诞到元宵 带你过最文化的新年！';
	    	appShareDesc = '精彩庆新年文化活动正在热订 新年红包文化福袋放送中！';
	    	appShareImgUrl = '${basePath}/STATIC/wxStatic/image/roomagekind/shareIcon.jpg';
	    	
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
					title: "佛山文化云·从圣诞到元宵 带你过最文化的新年！",
					desc: '精彩庆新年文化活动正在热订 新年红包文化福袋放送中！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/roomagekind/shareIcon.jpg'
				});
				wx.onMenuShareTimeline({
					title: "佛山文化云·从圣诞到元宵 带你过最文化的新年！",
					imgUrl: '${basePath}/STATIC/wxStatic/image/roomagekind/shareIcon.jpg'
				});
				wx.onMenuShareQQ({
					title: "佛山文化云·从圣诞到元宵 带你过最文化的新年！",
					desc: '精彩庆新年文化活动正在热订 新年红包文化福袋放送中！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/roomagekind/shareIcon.jpg'
				});
				wx.onMenuShareWeibo({
					title: "佛山文化云·从圣诞到元宵 带你过最文化的新年！",
					desc: '精彩庆新年文化活动正在热订 新年红包文化福袋放送中！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/roomagekind/shareIcon.jpg'
				});
				wx.onMenuShareQZone({
					title: "佛山文化云·从圣诞到元宵 带你过最文化的新年！",
					desc: '精彩庆新年文化活动正在热订 新年红包文化福袋放送中！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/roomagekind/shareIcon.jpg'
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
	<div style="display: none;"><img src="${basePath}/STATIC/wxStatic/image/roomagekind/shareIcon.jpg"/></div>
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
			<img src="${path}/STATIC/wxStatic/image/roomagekind/ban.jpg" width="750" height="250">
			<ul class="lccshare clearfix">
				<li class="share-button"><a href="javascript:;">分享</a></li>
				<li class="keep-button"><a href="javascript:;">关注</a></li>
			</ul>
		</div>
		<div class="kjmbNav_wc">
			<ul class="kjmbNav clearfix">
				<li><a href="${path}/wechatStatic/nyIndex.do">首页</a></li>
				<li><a href="${path}/wechatStatic/nyRanking.do">排行榜</a></li>
				<li class="current"><a href="${path}/wechatStatic/nyRule.do">活动规则</a></li>
				<li><a href="${path}/wechatStatic/nyAward.do">中奖名单</a></li>
			</ul>
		</div>
		<div class="roomcont jz700 roomguize_wc">
	        <div class="roomguize">
	            <div class="jz645">
	                <div class="jinhaotit">
	                    <div class="h1">#&nbsp;&nbsp;参与方式&nbsp;&nbsp;#</div>
	                </div>
	                <ol>
	                    <li>上传跟“文化过新年”有关的图片，可以是参加  圣诞、元旦、除夕、元宵任意新年活动的图片，或者有关的传统风俗，只要你能想到并说出跟 “文化”、“新年”相关的理由，就能参与成功，立享500积分新年红包！</li>
	                    <li>您可以上传多张图片，但是红包只赠送一次。</li>
	                    <li>请亲朋好友为你的作品点赞，即可获得更多奖励。  
	                        <div class="juh">* 每个用户每天只有1次投票权利，但是可以每天都来投1票喔！</div>
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
	                    <li>参与成功可立享500积分新年红包（图片不可重复，文化云有权对同一用户同一角度高相似度的作品做删除处理）；</li>
	                    <li>作品每被投票一票，作者即可获得5分积分奖励；</li>
	                    <!-- <li><span style="font-weight:bold;">月度之星：</span>月度点赞排名前5的作品，可获得一份特别定制的文化礼包；</li> -->
	                    <li>新年福袋限量50份：
	                        <ul>
	                            <li style="list-style-type:disc;margin-bottom:30px;margin-top:30px;">截止2017年2月20日24点，点赞排名前50的作品，可获得一份特别定制的新年福袋；</li>
	                            <li style="list-style-type:disc;margin-bottom:30px;">新年福袋内含上海地区两张文化活动的入场券，电影票、话剧票、演出票随机发放；</li>
	                            <li style="list-style-type:disc;">福袋内容和领奖名单将于2017年3月1日、2017年4月1日各公布一次，每次25份，按排名先后顺序给出。请关注文化云官方微信公众号“文化云”，避免错过颁奖信息。</li>
	                        </ul>
	                    </li>
	                    <li>除夕特别福利：”金鸡送福”中国小钱币珍藏册，由上海群众艺术馆新年特供。
                    		<ul>
                    			<li style="list-style-type:disc;margin-bottom:30px;margin-top:30px;">在参与除夕档晒年夜饭活动的用户中，抽取50份，获奖名单于2月11日（元宵节）公布</li>
                    		</ul>
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
	                    <li>“新年福袋”奖励每位用户（以同一用户名、同一手机号码判定）只能获奖一次，如同一用户有两幅作品同时上榜，仅计算其票数最高的作品，奖项相应顺延至下一位排名作品；</li>
	                    <li>发布照片须为个人原创，体现“文化过新年”的主题，主办方有权对鉴定非本主题或高相似度照片或其他违反法律法规的照片做删除处理，一旦作品被删除，其相关积分和奖品权益即被收回；</li>
	                    <li>不得违反国家法律法规，一旦上传将默认授权主办单位刊发出版照片的相关著作权限；</li>
	                    <li>本次活动最终解释权归文化云所有！</li>
	                </ol>
	            </div>
	        </div>
	    </div>
	</div>
</body>
</html>
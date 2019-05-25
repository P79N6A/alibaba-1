<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>佛山文化云·艺术天空</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		var enterParam = '${enterParam}';
	
		if (userId == null || userId == '') {
    		//判断登陆
        	publicLogin('${basePath}wechatStatic/artSkyIndex.do?enterParam='+enterParam);
    	}
		
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '佛山文化云-这里是上海国际艺术节之“艺术天空”VIP票务兑换通道';
	    	appShareDesc = '近百场国际水准演出票务Y码热兑中，现在索码还有机会！';
	    	appShareImgUrl = '${basePath}/STATIC/wxStatic/image/sky/shareIcon.jpg';
	    	appShareLink = '${basePath}/wechatStatic/artSkyIndex.do?enterParam='+enterParam;
	    	
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
					title: "佛山文化云-这里是上海国际艺术节之“艺术天空”VIP票务兑换通道",
					desc: '近百场国际水准演出票务Y码热兑中，现在索码还有机会！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/sky/shareIcon.jpg',
					link: '${basePath}/wechatStatic/artSkyIndex.do?enterParam='+enterParam
				});
				wx.onMenuShareTimeline({
					title: "佛山文化云-这里是上海国际艺术节之“艺术天空”VIP票务兑换通道",
					imgUrl: '${basePath}/STATIC/wxStatic/image/sky/shareIcon.jpg',
					link: '${basePath}/wechatStatic/artSkyIndex.do?enterParam='+enterParam
				});
				wx.onMenuShareQQ({
					title: "佛山文化云-这里是上海国际艺术节之“艺术天空”VIP票务兑换通道",
					desc: '近百场国际水准演出票务Y码热兑中，现在索码还有机会！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/sky/shareIcon.jpg',
					link: '${basePath}/wechatStatic/artSkyIndex.do?enterParam='+enterParam
				});
				wx.onMenuShareWeibo({
					title: "佛山文化云-这里是上海国际艺术节之“艺术天空”VIP票务兑换通道",
					desc: '近百场国际水准演出票务Y码热兑中，现在索码还有机会！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/sky/shareIcon.jpg',
					link: '${basePath}/wechatStatic/artSkyIndex.do?enterParam='+enterParam
				});
				wx.onMenuShareQZone({
					title: "佛山文化云-这里是上海国际艺术节之“艺术天空”VIP票务兑换通道",
					desc: '近百场国际水准演出票务Y码热兑中，现在索码还有机会！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/sky/shareIcon.jpg',
					link: '${basePath}/wechatStatic/artSkyIndex.do?enterParam='+enterParam
				});
			});
		}
		
		$(function() {
			
			//分享
			$(".shareBtn").click(function() {
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
			$(".keepBtn").on("touchstart", function() {
				$('.div-share').show()
				$("body,html").addClass("bg-notouch")
			})
		})
		
		//我的订单
		function preOrderList(){
			if (userId == null || userId == '') {
	    		//判断登陆
	        	publicLogin('${basePath}wechatStatic/artSkyIndex.do?enterParam='+enterParam);
	    	}else{
	    		if (window.injs) {	//判断是否存在方法
	                injs.accessAppPage(7, 1);
	            } else {
	                window.location.href = "${path}/wechatActivity/wcOrderList.do";
	            }
	    	}
		}
		
		//Y码索取
		function preArtSkyInfo(){
			if (userId == null || userId == '') {
	    		//判断登陆
	        	publicLogin('${basePath}wechatStatic/artSkyInfo.do?enterParam='+enterParam);
	    	}else{
	    		location.href = '${path}/wechatStatic/artSkyInfo.do?enterParam='+enterParam;
	    	}
		}
		
		//兑换Y码
		function checkCode(){
			if (userId == null || userId == '') {
	    		//判断登陆
	        	publicLogin('${basePath}wechatStatic/artSkyIndex.do?enterParam='+enterParam);
	    	}else{
	    		var ycode = $("#ycode").val();
	    		$.post("${path}/wechatStatic/getActivityListByCode.do",{specialCode:ycode}, function (data) {
	    			if (data.status == 1) {
	    				location.href = '${path}/wechatStatic/artSkyList.do?enterParam='+enterParam+'&ycode='+ycode;
	    			}else{
	    				dialogAlert('系统提示', data.msg.errmsg);
	    			}
	    		},"json");
	    	}
		}
	</script>
	
	<style>
		a{color: #666666;}
		body {background-color: #1b1b1b;}
	</style>
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${basePath}/STATIC/wxStatic/image/sky/shareIcon.jpg"/></div>
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
	<div class="skymain">
		<div class="skyban">
			<img src="${enterLogoImageUrl}@750w" style="height: 540px;width: 750px;">
			<ul class="skydfg clearfix">
				<li><a href="javascript:preOrderList();">我的订单</a></li>
				<li><a href="javascript:;" class="shareBtn">分享</a></li>
				<li><a href="javascript:;" class="keepBtn">关注</a></li>
			</ul>
		</div>
	
		<div class="skydhm">
			<table class="dhmTab">
				<tr>
					<td class="td1">
						<input id="ycode" class="txt" type="text" placeholder="请输入你获得的Y码">
					</td>
					<td class="td2">
						<input class="btn" type="button" value="立即兑换" onclick="checkCode();">
					</td>
				</tr>
			</table>
			<p><span class="zhu">注意事项</span></p>
			<p>
				1.     进入Y码兑换专区填写获取Y码，选择任意场次进行兑换；<br>
				2.     一张Y码仅可兑换单一场次的一张票务；<br>
				3.     Y码具有有效期，请在有效期内完成兑换；<br>
				4.     Y码一经兑换立即失效，后续如取消订单，Y码不再生效；<br>
				5.     禁止任何形式的倒卖、刷票等行为，若核查属实，文化云有权取消订单；<br>
				6.     活动最终解释权归文化云所有。
			</p>
			<ul class="dhmbtn clearfix" style="margin-right:0;">
				<li>
					<a href="${path}/information/preInfo.do?informationId=14161febbc024242a894ae56c30b390b">
						<div class="pic"><img src="${path}/STATIC/wxStatic/image/sky/sky7.png" width="140" height="140"></div>
						<div class="wz">取票须知</div>
					</a>
				</li>
				<li>
					<a href="${path}/information/preInfo.do?informationId=d17b74abaf444262b5d999a2598f251f">
						<div class="pic"><img src="${path}/STATIC/wxStatic/image/sky/sky8.png" width="140" height="140"></div>
						<div class="wz">关于艺术天空</div>
					</a>
				</li>
				<li style="margin-right:0;">
					<a href="${path}/wechat/index.do">
						<div class="pic"><img src="${path}/STATIC/wxStatic/image/sky/sky9.png" width="140" height="140"></div>
						<div class="wz">进入文化云</div>
					</a>
				</li>
			</ul>
			<div class="dhmdbPic clearfix"><img src="${path}/STATIC/wxStatic/image/sky/sky10.png"></div>
		</div>
	</div>
</body>
</html>
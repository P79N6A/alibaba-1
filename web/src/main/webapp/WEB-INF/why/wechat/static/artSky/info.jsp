<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>安康文化云·艺术天空</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		var enterParam = '${enterParam}';
		var enterId = '${enterId}';
	
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '安康文化云-这里是上海国际艺术节之“艺术天空”VIP票务兑换通道';
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
					title: "安康文化云-这里是上海国际艺术节之“艺术天空”VIP票务兑换通道",
					desc: '近百场国际水准演出票务Y码热兑中，现在索码还有机会！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/sky/shareIcon.jpg',
					link: '${basePath}/wechatStatic/artSkyIndex.do?enterParam='+enterParam
				});
				wx.onMenuShareTimeline({
					title: "安康文化云-这里是上海国际艺术节之“艺术天空”VIP票务兑换通道",
					imgUrl: '${basePath}/STATIC/wxStatic/image/sky/shareIcon.jpg',
					link: '${basePath}/wechatStatic/artSkyIndex.do?enterParam='+enterParam
				});
				wx.onMenuShareQQ({
					title: "安康文化云-这里是上海国际艺术节之“艺术天空”VIP票务兑换通道",
					desc: '近百场国际水准演出票务Y码热兑中，现在索码还有机会！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/sky/shareIcon.jpg',
					link: '${basePath}/wechatStatic/artSkyIndex.do?enterParam='+enterParam
				});
				wx.onMenuShareWeibo({
					title: "安康文化云-这里是上海国际艺术节之“艺术天空”VIP票务兑换通道",
					desc: '近百场国际水准演出票务Y码热兑中，现在索码还有机会！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/sky/shareIcon.jpg',
					link: '${basePath}/wechatStatic/artSkyIndex.do?enterParam='+enterParam
				});
				wx.onMenuShareQZone({
					title: "安康文化云-这里是上海国际艺术节之“艺术天空”VIP票务兑换通道",
					desc: '近百场国际水准演出票务Y码热兑中，现在索码还有机会！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/sky/shareIcon.jpg',
					link: '${basePath}/wechatStatic/artSkyIndex.do?enterParam='+enterParam
				});
			});
		}
		
		$(function () {
			
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
		});
		
		//返回首页
		function preArtSkyIndex(){
			if (userId == null || userId == '') {
	    		//判断登陆
	        	publicLogin('${basePath}wechatStatic/artSkyIndex.do?enterParam='+enterParam);
	    	}else{
	    		location.href = '${path}/wechatStatic/artSkyIndex.do?enterParam='+enterParam;
	    	}
		}
		
		//提交
		function saveInfo(){
			if (userId == null || userId == '') {
	    		//判断登陆
	        	publicLogin('${basePath}wechatStatic/artSkyIndex.do?enterParam='+enterParam);
	    	}else{
	    		var userName = $("#userName").val();
				if(userName == ""){
			    	dialogAlert('系统提示', '请输入姓名！');
			        return false;
			    }
				var userMobile = $("#userMobile").val();
				var telReg = (/^1[34578]\d{9}$/);
				if(userMobile == ""){
			    	dialogAlert('系统提示', '请输入手机号码！');
			        return false;
			    }else if(!userMobile.match(telReg)){
			    	dialogAlert('系统提示', '请正确填写手机号码！');
			        return false;
			    }
				$.post("${path}/wechatStatic/getYCode.do", {enterId: enterId,name: userName,telphone:userMobile},
						function (data) {
					if (data.status == 1) {
	                	$('.skyhei').show();
	    				$('.skytan_5').show();
	                }else{
	                	dialogAlert('系统提示', data.msg.errmsg);
	                }
	            }, "json");
	    	}
		}
	</script>
	
	<style>
		a{color: #666666;}
		.skyzhuanqu {text-align: center;margin-bottom: 40px;}
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
				<li><a href="javascript:;" class="shareBtn">分享</a></li>
				<li><a href="javascript:;" class="keepBtn">关注</a></li>
			</ul>
		</div>
		<div class="skyzhuanqu"><img src="${path}/STATIC/wxStatic/image/sky/sky10.png"></div>
		<div class="skylzytab jz702">
			<div class="lzytit">我们会定期从参与用户中<br>抽取部分用户获得Y码</div>
			<table class="skylzy_biao">
				<tr>
					<td>
						<div class="txtdiv">
							<input id="userName" class="txt" type="text">
							<span class="lable">姓名</span>
						</div>
					</td>
				</tr>
				<tr>
					<td>
						<div class="txtdiv">
							<input id="userMobile" class="txt" type="text">
							<span class="lable">手机</span>
						</div>
					</td>
				</tr>
				<tr>
					<td>
						<input id="subcg" class="btn hong" type="button" value="提  交" onclick="saveInfo();">
					</td>
				</tr>
			</table>
		</div>
	</div>
	
	<!-- 弹出框 遮罩-->
	<div class="skyhei"></div>
	
	<!-- 提交成功 -->
	<div class="skyWhite skytan_5">
		<div class="skyWhite_nc2">
			<div class="tantit">提交成功</div>
			<p>我们已收到您的信息，请关注文化云公众号及时获得活动详情</p>
			<table class="skybdsj">
				<tr>
					<td class="td1" colspan="2">
						<input id="fanh" class="btn hong" type="button" value="返  回" onclick="preArtSkyIndex();">
					</td>
				</tr>
			</table>
		</div>
	</div>
</body>
</html>
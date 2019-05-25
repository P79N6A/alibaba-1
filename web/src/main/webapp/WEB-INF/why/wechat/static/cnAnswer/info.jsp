<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>安康文化云·歌剧小知识问答</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		//分享是否隐藏
	    if(window.injs){
			injs.setAppShareButtonStatus(false);
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
					title: "文化云｜经典歌剧常识知多少？茶花女，图兰朵，卡门...",
					desc: '你的朋友圈里谁最文艺？一套题目告诉你答案！',
					link: '${basePath}wechatStatic/cnAnswer.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/cnAnswer/shareIcon.png'
				});
				wx.onMenuShareTimeline({
					title: "文化云｜经典歌剧常识知多少？茶花女，图兰朵，卡门...",
					imgUrl: '${basePath}/STATIC/wxStatic/image/cnAnswer/shareIcon.png',
					link: '${basePath}wechatStatic/cnAnswer.do'
				});
				wx.onMenuShareQQ({
					title: "文化云｜经典歌剧常识知多少？茶花女，图兰朵，卡门...",
					desc: '你的朋友圈里谁最文艺？一套题目告诉你答案！',
					link: '${basePath}/wechatStatic/cnAnswer.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/cnAnswer/shareIcon.png'
				});
				wx.onMenuShareWeibo({
					title: "文化云｜经典歌剧常识知多少？茶花女，图兰朵，卡门...",
					desc: '你的朋友圈里谁最文艺？一套题目告诉你答案！',
					link: '${basePath}/wechatStatic/cnAnswer.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/cnAnswer/shareIcon.png'
				});
				wx.onMenuShareQZone({
					title: "文化云｜经典歌剧常识知多少？茶花女，图兰朵，卡门...",
					desc: '你的朋友圈里谁最文艺？一套题目告诉你答案！',
					link: '${basePath}/wechatStatic/cnAnswer.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/cnAnswer/shareIcon.png'
				});
			});
		}
		
		$(function () {
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
		
		function saveInfo(){
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
			$.post("${path}/wechatStatic/saveOrUpdateCnAnswer.do", {userId: userId,userName: userName,userMobile:userMobile},
					function (data) {
                if (data == 200) {
					$(".submit-success").fadeIn();
                }else{
                	dialogAlert('系统提示', '提交失败，请稍后再试！');
                }
            }, "json");
		}
	</script>
	
	<style>
		html,body {width: 100%;height: 100%;}
		.swiper-container {
			margin: 50px auto 0px auto;
			width: 560px;
			height: 450px;
		}
		.swiper-slide {
			background-position: center;
			background-size: cover;
			width: 450px;
			height: 450px;
		}
	</style>
	
</head>

<body>
	<div class="game-main">
		<!-- 方便分享自动抓取 -->
		<div style="display: none;"><img src="${path}/STATIC/wxStatic/image/cnAnswer/shareIcon.png"/></div>
		<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
			<img src="${path}/STATIC/wxStatic/image/movie/shareBg.png" style="width: 100%;height: 100%;" />
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
		<!--活动页-->
		<div class="game-gamepage">
			<img src="${path}/STATIC/wxStatic/image/movie/bg.jpg" width="100%" height="100%" style="z-index: 0;position: absolute;top: 0px;left: 0px;" />
			<div class="game-top">
				<img src="${path}/STATIC/wxStatic/image/movie/logo.png" style="position: absolute;top: 30px;left: 60px;" />
				<img class="keep-button" src="${path}/STATIC/wxStatic/image/movie/keep.png" style="position: absolute;top: 30px;right: 40px;" />
				<img class="share-button" src="${path}/STATIC/wxStatic/image/movie/share.png" style="position: absolute;top: 30px;right: 150px;" />
			</div>
			<div class="user-submit">
				<img class="margin-top50" src="${path}/STATIC/wxStatic/image/cnAnswer/gejumi.png" />
				<div class="game-user-input margin-top30">
					<span class="fs40">姓名</span>
					<input id="userName" class="fs40" type="text" value="${userNickName}" maxlength="20"/>
				</div>
				<div class="game-user-input margin-top30">
					<span class="fs40">手机</span>
					<input id="userMobile" class="fs40" type="text" value="${userTelephone}" maxlength="11"/>
				</div>
				<img class="margin-top30" src="${path}/STATIC/wxStatic/image/cnAnswer/keepwhy.png"/>
				<img class="margin-top50" src="${path}/STATIC/wxStatic/image/movie/btn_submit.png" onclick="saveInfo();"/>
			</div>
			<div class="submit-success" style="display: none;">
				<div class="submit-success-middle" style="background: url(${path}/STATIC/wxStatic/image/cnAnswer/submitsuccess.png) no-repeat center center;bottom:100px;width:680px;">
					<img class="share-button" src="${path}/STATIC/wxStatic/image/movie/btn-share.png" style="position: absolute;bottom: 0px;left: 0px;right:0px;margin:auto;" />
					<img style="position:absolute;left:0;bottom:-130px;" src="${path}/STATIC/wxStatic/image/cnAnswer/whyindex.png" onclick="toWhyIndex();"/>
					<img style="position:absolute;right:0;bottom:-130px;" src="${path}/STATIC/wxStatic/image/cnAnswer/checkintegral.png" onclick="toUserCenter();"/>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
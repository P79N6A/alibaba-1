<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>安康文化云·上海当代戏剧节问答</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		var userScore = '${userScore}'
	
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
					title: "文化云&上海当代戏剧节 | 测测你的人生有几分入戏？",
					desc: '测试你的入戏分值，决定如何度过2016年上海当代戏剧节。',
					link: '${basePath}wechatStatic/dramaAnswer.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/dramaAnswer/shareIcon.png'
				});
				wx.onMenuShareTimeline({
					title: "文化云&上海当代戏剧节 | 测测你的人生有几分入戏？",
					imgUrl: '${basePath}/STATIC/wxStatic/image/dramaAnswer/shareIcon.png',
					link: '${basePath}wechatStatic/dramaAnswer.do'
				});
				wx.onMenuShareQQ({
					title: "文化云&上海当代戏剧节 | 测测你的人生有几分入戏？",
					desc: '测试你的入戏分值，决定如何度过2016年上海当代戏剧节。',
					link: '${basePath}/wechatStatic/dramaAnswer.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/dramaAnswer/shareIcon.png'
				});
				wx.onMenuShareWeibo({
					title: "文化云&上海当代戏剧节 | 测测你的人生有几分入戏？",
					desc: '测试你的入戏分值，决定如何度过2016年上海当代戏剧节。',
					link: '${basePath}/wechatStatic/dramaAnswer.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/dramaAnswer/shareIcon.png'
				});
				wx.onMenuShareQZone({
					title: "文化云&上海当代戏剧节 | 测测你的人生有几分入戏？",
					desc: '测试你的入戏分值，决定如何度过2016年上海当代戏剧节。',
					link: '${basePath}/wechatStatic/dramaAnswer.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/dramaAnswer/shareIcon.png'
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
			$.post("${path}/wechatStatic/saveOrUpdateDramaAnswer.do", {userId: userId,userName: userName,userMobile:userMobile,answerType:2},
					function (data) {
                if (data == 200) {
                	window.location.href = '${path}/wechatStatic/dramaAnswerShare.do?userScore='+userScore;
                }else{
                	dialogAlert('系统提示', '提交失败，请稍后再试！');
                }
            }, "json");
		}
	</script>
	
	<style>
		html,body {
			width: 100%;
			height: 100%;
		}
	</style>
	
</head>

<body>
	<div class="game-main">
		<!-- 方便分享自动抓取 -->
		<div style="display: none;"><img src="${basePath}/STATIC/wxStatic/image/dramaAnswer/shareIcon.jpg"/></div>
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
		
		<div class="game-gamepage">
			<img src="${path}/STATIC/wxStatic/image/dramaAnswer/submit.jpg" width="100%" height="100%" style="z-index: 0;position: absolute;top: 0px;left: 0px;" />
			<div class="game-top">
				<img class="keep-button" src="${path}/STATIC/wxStatic/image/dramaAnswer/keep.png" style="position: absolute;top: 30px;right: 40px;" />
				<img class="share-button" src="${path}/STATIC/wxStatic/image/dramaAnswer/share.png" style="position: absolute;top: 30px;right: 150px;" />
			</div>
			<div class="user-submit" style="margin-top: 450px;">
				<div class="fxgame-user-input margin-top30" style="background: url(${path}/STATIC/wxStatic/image/dramaAnswer/userinput.png) no-repeat center center;">
					<span class="fs40">姓名</span>
					<input class="fs40" id="userName" type="text" value="" maxlength="20" style="margin-top: 18px;background-color: #ede2d2;margin-left: 60px;" />
				</div>
				<div class="fxgame-user-input margin-top30" style="background: url(${path}/STATIC/wxStatic/image/dramaAnswer/userinput.png) no-repeat center center;">
					<span class="fs40">手机</span>
					<input class="fs40" id="userMobile" type="text" value="" maxlength="11" style="margin-top: 18px;background-color: #ede2d2;margin-left: 60px;" />
				</div>
				<div class="jifenBtn" style="margin: 260px auto 0;" onclick="saveInfo();">
					<img src="${path}/STATIC/wxStatic/image/dramaAnswer/submit.png" />
				</div>
			</div>
		</div>
	</div>
</body>
</html>
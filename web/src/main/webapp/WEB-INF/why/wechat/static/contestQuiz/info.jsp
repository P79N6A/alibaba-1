<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>安康文化云·${sessionScope.sessionTopic.topicName }</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-contestQuiz.css"/>
	<script type="text/javascript" src="${path}/STATIC/wxStatic/js/swiper.animate1.0.2.min.js"></script>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script >
	
			var topicId='${sessionScope.sessionTopic.topicId}'
	
			var title='${sessionScope.sessionTopic.shareTitle}';
			var describe='${sessionScope.sessionTopic.shareDescribe}';
			var imgUrl='${sessionScope.sessionTopic.shareLogoImg}?x-oss-process=image/resize,w_150,limit_0';
			
			//分享是否隐藏
	        if(window.injs){
	        	//分享文案
	        	appShareTitle = title;
	        	appShareDesc = describe;
	        	appShareImgUrl = imgUrl;
	        	
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
						title: title,
						desc: describe,
						link: '${basePath}wechatFunction/contestQuiz.do?topicId='+topicId,
						imgUrl: imgUrl
					});
					wx.onMenuShareTimeline({
						title: title,
						link: '${basePath}wechatFunction/contestQuiz.do?topicId='+topicId,
						imgUrl: imgUrl
					});
					wx.onMenuShareQQ({
						title: title,
						desc: describe,
						imgUrl: imgUrl
					});
					wx.onMenuShareWeibo({
						title: title,
						desc: describe,
						imgUrl: imgUrl
					});
					wx.onMenuShareQZone({
						title: title,
						desc: describe,
						imgUrl: imgUrl
					});
				});
			}
			
	    	
			$(function () {
				
				var backgroundImgUrl='${sessionScope.sessionTopic.backgroundImgUrl}'
					
				$(".game-gamepage").css("background","url("+backgroundImgUrl+") no-repeat center center").css("background-size","100% 100%")
				
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
				
				var userScore='${userAnswer.userScore}'
				
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
				$.post("${path}/wechatFunction/saveOrUpdateContestQuizAnswer.do", {userId: userId,userName: userName,userMobile:userMobile,answerType:topicId},
						function (data) {
	                if (data == 200) {
	                	window.location.href = '${path}/wechatFunction/contestQuizEnd.do?topicId='+topicId+'&userScore='+userScore;
	                }else{
	                	dialogAlert('系统提示', '提交失败，请稍后再试！');
	                }
	            }, "json");
			}

		</script>
		
	<body id="${sessionScope.sessionTopicTemplate }"> 
		<div class="game-main">
			<!-- 方便分享自动抓取 -->
		<div style="display: none;"><img src="${path}/STATIC/wxStatic/image/bkqs/shareIcon.png"/></div>
		<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
			<img src="${path}/STATIC/wxStatic/image/bkqs/shareBg.png" style="width: 100%;height: 100%;" />
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
				<div class="game-top">
						<c:choose>
						<c:when test="${!empty sessionScope.sessionTopic.indexLogo }">
							<img src="${ sessionScope.sessionTopic.indexLogo}?x-oss-process=image/resize,w_70,limit_0" style="position: absolute;top: 30px;left: 40px;" />
						</c:when>
						<c:when test="${!empty logo }">
							<img src="${logo}?x-oss-process=image/resize,w_70,limit_0" style="position: absolute;top: 30px;left: 40px;" />
						</c:when>
						<c:otherwise>
						<img src="${path}/STATIC/wxStatic/image/contestQuiz/logo.png" style="position: absolute;top: 30px;left: 40px;" />
						</c:otherwise>
						</c:choose>
					<img class="" src="${path}/STATIC/wxStatic/image/contestQuiz/index.png" style="position: absolute;top: 30px;right: 260px;" onclick="toWhyIndex();"/>
				<img class="keep-button" src="${path}/STATIC/wxStatic/image/contestQuiz/keep.png" style="position: absolute;top: 30px;right: 40px;" />
				<img class="share-button" src="${path}/STATIC/wxStatic/image/contestQuiz/share.png" style="position: absolute;top: 30px;right: 150px;" />
				</div>
				<div class="completeUserInfo">
					<p>完善信息</p>
					<p>请留下你的个人资料</p>
				</div>
				<div class="user-submit">
					<div class="fxgame-user-input">
						<span>姓名</span>
						<input id="userName" type="text" value="${userAnswer.userName }" maxlength="20" />
					</div>
					<div class="fxgame-user-input">
						<span>手机</span>
						<input id="userMobile" type="text" value="${userAnswer.userMobile }" maxlength="11"/>
					</div>
					<div class="whyInfo">
						<p >抽奖规则</p>
						<p style="width: 570px; margin: 0 auto;text-align: left;">${sessionScope.sessionTopic.drawRule }</p>
					</div>
					<div class="jifenBtn" onclick="saveInfo();"></div>
				</div>
			</div>
		</div>

	</body>
		
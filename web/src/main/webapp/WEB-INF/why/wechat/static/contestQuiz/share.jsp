<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>安康文化云·${sessionScope.sessionTopic.topicName }</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-contestQuiz.css"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
	
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
			
				$.post("${path}/wechatUser/queryTerminalUserById.do", {userId: userId}, function (data) {
	            		
	            		 if (data.status == 0) {
	            			 
	            			 var user = data.data[0];
	                         var userHeadImgUrl = user.userHeadImgUrl;
	                         
	                         var userHeadImgHtml="";
	                         
	                         if(userHeadImgUrl){
	                             if(userHeadImgUrl.indexOf("http") == -1){
	                             	userHeadImgUrl = getImgUrl(userHeadImgUrl);
	                             }
	                             if (userHeadImgUrl.indexOf("http")==-1) {
	                             	userHeadImgHtml = '../STATIC/wx/image/sh_user_header_icon.png'
	                             } else if (userHeadImgUrl.indexOf("/front/") != -1) {
	                                 userHeadImgHtml = getIndexImgUrl(userHeadImgUrl, "_300_300"); 
	                             } else {
	                             	userHeadImgHtml =userHeadImgUrl 
	                             }
	                         }else{
	                         	userHeadImgHtml = '../STATIC/wx/image/sh_user_header_icon.png';
	                         }

	                         $(".gameUserImg").find("img").attr("src",userHeadImgHtml);
	                         
	                         
	                         $(".userName").html(user.userName)
	                         
	            		 }
	            		
	            	 }, "json");
			
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
            
			$(".writeInfo").click(function(){
				
				if (userId == null || userId == '') {
					
					var userScore='${userScore}';
					
					  publicLogin("${basePath}wechatFunction/contestQuizShare.do?userId="+userId+"&topicId="+topicId+"&userScore="+userScore);
	            }
				else{
				
					window.location.href ="${path}/wechatFunction/contestQuizInfo.do?answerType="+topicId+"&userId="+userId
				}
			})
		});
		
	</script>
	
	<style>
		html,body {
			width: 100%;
			height: 100%;
		}
		
		.dramaUserRank{
			margin: 400px auto 0;
		}
		
		.dramaUserRank>img{
			display: block;
			margin: auto;
		}
		.dramaSee{
			margin-top: 20px;
		}
	</style>
	
</head>

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
				<div class="gameUserImg"> 
					<img src="" width="210" height="210" />
					
					<div>
						<p class="userName"></p>
						<p>得分：<span>${userScore }</span></p>
					</div>
				</div>
				<div class="gameScore">
					
					<p>${sessionScope.sessionTopic.passText }</p>
					
					<c:if test="${sessionScope.sessionTopic.isDraw ==2&&empty userName}">
						<div class="writeInfo">
						
						</div>
					</c:if>
				</div>
				<div class="gameSubmitBtn">
					<!--重新挑战按钮-->
					<div onclick="location.href='${path}/wechatFunction/contestQuiz.do?topicId=${sessionScope.sessionTopic.topicId }';"></div>
					<!--分享到朋友圈按钮-->
					<div class="share-button"></div>
					<div style="clear: both;"></div>
				</div>
			</div>
		</div>

	</body>

</body>
</html>
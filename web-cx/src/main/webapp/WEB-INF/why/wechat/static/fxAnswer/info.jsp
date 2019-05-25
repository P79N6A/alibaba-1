<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>佛山文化云·你到底是多少分的奉贤人</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		var userHeadImgUrl = '${userHeadImgUrl}';
		var userName = '${userName}';
	
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '【测试】你到底是多少分的奉贤人？';
        	appShareDesc = '奉贤光明的特产是冰砖？是牛奶？还是黄桃？';
        	appShareImgUrl = '${basePath}/STATIC/wxStatic/image/fxgame/fxShare.jpg';
	    	appShareLink = '${basePath}/wechatStatic/fxAnswer.do';
	    	
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
					title: "【测试】你到底是多少分的奉贤人？",
					desc: '奉贤光明的特产是冰砖？是牛奶？还是黄桃？',
					link: '${basePath}wechatStatic/fxAnswer.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/fxgame/fxShare.jpg'
				});
				wx.onMenuShareTimeline({
					title: '【测试】你到底是多少分的奉贤人？',
					imgUrl: '${basePath}/STATIC/wxStatic/image/fxgame/fxShare.jpg',
					link: '${basePath}wechatStatic/fxAnswer.do'
				});
				wx.onMenuShareQQ({
					title: "【测试】你到底是多少分的奉贤人？",
					desc: '奉贤光明的特产是冰砖？是牛奶？还是黄桃？',
					link: '${basePath}/wechatStatic/fxAnswer.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/fxgame/fxShare.jpg'
				});
				wx.onMenuShareWeibo({
					title: "【测试】你到底是多少分的奉贤人？",
					desc: '奉贤光明的特产是冰砖？是牛奶？还是黄桃？',
					link: '${basePath}/wechatStatic/fxAnswer.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/fxgame/fxShare.jpg'
				});
				wx.onMenuShareQZone({
					title: "【测试】你到底是多少分的奉贤人？",
					desc: '奉贤光明的特产是冰砖？是牛奶？还是黄桃？',
					link: '${basePath}/wechatStatic/fxAnswer.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/fxgame/fxShare.jpg'
				});
			});
		}
		
		$(function () {
			//用户头像
			if (userHeadImgUrl.indexOf("http") == -1) {
            	userHeadImgHtml = "<img src='${path}/STATIC/wx/image/sh_user_header_icon.png' width='160' height='160' onerror='imgNoFind();'/>";
            } else if (userHeadImgUrl.indexOf("/front/") != -1) {
                var imgUrl = getIndexImgUrl(userHeadImgUrl, "_300_300");
                userHeadImgHtml = "<img src='"+imgUrl+"' width='160' height='160' onerror='imgNoFind();'/>";
            } else {
            	userHeadImgHtml = "<img src='"+userHeadImgUrl+"' width='160' height='160' onerror='imgNoFind();'/>";
            }
			$("#user-head-img").html(userHeadImgHtml);
			
			if(userName.length>0){
				$(".fxjifen img").attr("src","${path}/STATIC/wxStatic/image/fxgame/submitok.png");
			}else{
				$(".fxjifen img").attr("src","${path}/STATIC/wxStatic/image/fxgame/jifen.png");
			}
			
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
			if (userId == null || userId == '') {
				//判断登陆
	        	publicLogin("${basePath}wechatStatic/fxAnswer.do");
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
    			$.post("${path}/wechatStatic/saveOrUpdateFxAnswer.do", {userId: userId,userName: userName,userMobile:userMobile},
    					function (data) {
                    if (data == 200) {
                    	$(".fxjifen").fadeIn();
                    }else{
                    	dialogAlert('系统提示', '提交失败，请稍后再试！');
                    }
                }, "json");
            }
		}
	</script>
	
	<style>
		html,body {width: 100%;height: 100%;}
	</style>
	
</head>

<body>
	<div class="game-main">
		<!-- 方便分享自动抓取 -->
		<div style="display: none;"><img src="${basePath}/STATIC/wxStatic/image/fxgame/fxShare.jpg"/></div>
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
		<!--活动页-->
		<div class="game-gamepage">
			<img src="${path}/STATIC/wxStatic/image/fxgame/submitbg.png" width="100%" height="100%" style="z-index: 0;position: absolute;top: 0px;left: 0px;" />
			<div class="game-top">
				<img class="keep-button" src="${path}/STATIC/wxStatic/image/movie/keep.png" style="position: absolute;top: 30px;right: 40px;" />
				<img class="share-button" src="${path}/STATIC/wxStatic/image/movie/share.png" style="position: absolute;top: 30px;right: 150px;" />
			</div>
			<div class="fxUserImg">
				<div id="user-head-img"></div>
			</div>
			<div class="user-submit" style="margin-top: 280px;">
				<div class="fxgame-user-input margin-top30">
					<span class="fs40">姓名</span>
					<input id="userName" class="fs40" type="text" value="${userName}" maxlength="20"/>
				</div>
				<div class="fxgame-user-input margin-top30">
					<span class="fs40">手机</span>
					<input id="userMobile" class="fs40" type="text" value="${userMobile}" maxlength="11"/>
				</div>
				<div class="jifenBtn">
					<img src="${path}/STATIC/wxStatic/image/fxgame/submit.png" onclick="saveInfo();"/>
				</div>
			</div>
		</div>
		<div class="fxjifen">
			<img src="" width="100%" height="100%" onclick="location.href='${path}/wechatStatic/fxActivity.do'"/>
		</div>
	</div>
</body>
</html>
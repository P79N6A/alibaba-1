<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>安康文化云·上海当代戏剧节</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css?v=20161021"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		var noControl = '${noControl}'; //1：不可操作
		var dramaId = '${dramaId}';
	
		if (userId == null || userId == '') {
    		//判断登陆
        	publicLogin("${basePath}wechatStatic/dramaFestival.do");
    	}
		
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
        	appShareTitle = '上海当代戏剧节·看完好戏不来说一说？';
        	appShareDesc = '上海艺术节之艺术天空特别策划，全天12小时演出不间断，快来和我一起共享艺术盛宴';
        	appShareImgUrl = '${basePath}/STATIC/wxStatic/image/dramaImg/shareIcon.jpg';
        	appShareLink = '${basePath}/wechatStatic/dramaFestival.do';
        	
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
					title: "安康文化云·上海当代戏剧节·看完好戏不来说一说？",
					desc: '观戏剧，写剧评，分享属于你的“戏如人生”，赢取戏剧节限量礼品。',
					link: '${basePath}wechatStatic/dramaFestival.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/dramaImg/shareIcon.jpg'
				});
				wx.onMenuShareTimeline({
					title: "安康文化云·上海当代戏剧节·看完好戏不来说一说？",
					imgUrl: '${basePath}/STATIC/wxStatic/image/dramaImg/shareIcon.jpg',
					link: '${basePath}wechatStatic/dramaFestival.do'
				});
				wx.onMenuShareQQ({
					title: "安康文化云·上海当代戏剧节·看完好戏不来说一说？",
					desc: '观戏剧，写剧评，分享属于你的“戏如人生”，赢取戏剧节限量礼品。',
					link: '${basePath}/wechatStatic/dramaFestival.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/dramaImg/shareIcon.jpg'
				});
				wx.onMenuShareWeibo({
					title: "安康文化云·上海当代戏剧节·看完好戏不来说一说？",
					desc: '观戏剧，写剧评，分享属于你的“戏如人生”，赢取戏剧节限量礼品。',
					link: '${basePath}/wechatStatic/dramaFestival.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/dramaImg/shareIcon.jpg'
				});
				wx.onMenuShareQZone({
					title: "安康文化云·上海当代戏剧节·看完好戏不来说一说？",
					desc: '观戏剧，写剧评，分享属于你的“戏如人生”，赢取戏剧节限量礼品。',
					link: '${basePath}/wechatStatic/dramaFestival.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/dramaImg/shareIcon.jpg'
				});
			});
		}
		
		$(function () {
			
			//菜单顶部固定
			$(document).on('touchmove', function() {
				if($(document).scrollTop() > 240) {
					$(".dramaMenuList").css('position', 'fixed')
				} else {
					$(".dramaMenuList").css('position', 'relative')
				}
			})
			$(document).on('scroll', function() {
				if($(document).scrollTop() > 240) {
					$(".dramaMenuList").css('position', 'fixed')
				} else{
					$(".dramaMenuList").css('position', 'relative')
				}
			})
			
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
		
		//提交
		function saveInfo(){
			if(noControl != 1){
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
				$.post("${path}/wechatStatic/addDramaUser.do", {userId: userId,userName: userName,userMobile:userMobile},function (data) {
	                if (data == "200") {
	                	location.href = '${path}/wechatStatic/toDramaComment.do?dramaId='+dramaId;
	                }else{
	                	dialogAlert('系统提示', '提交失败，请稍后再试！');
	                }
	            }, "json");
			}else{
				dialogAlert('系统提示', '活动已结束！');
			}
		}
	</script>
	<style>
		html,body{
			height: 100%;
			background-color: #eeeeee;
		}
	</style>
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${basePath}/STATIC/wxStatic/image/dramaImg/shareIcon.jpg"/></div>
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
	<div class="dramaMain">
		<img class="keep-button" src="${path}/STATIC/wxStatic/image/hongkouAct/hkshare.png" style="position: absolute;right: 30px;top: 30px;" />
		<img class="share-button" src="${path}/STATIC/wxStatic/image/hongkouAct/hkkeep.png" style="position: absolute;right: 120px;top: 30px;" />
		<div>
			<img src="${path}/STATIC/wxStatic/image/dramaImg/banner.jpg" />
		</div>
		<div class="dramaMenu">
			<div class="dramaMenuList">
				<ul>
					<li onclick="location.href='${path}/wechatStatic/dramaFestival.do'">
						<div class="dramaMenuOn">参演节目</div>
					</li>
					<li onclick="location.href='${path}/wechatStatic/dramaFestival.do?tab=1'">
						<div>精彩剧评</div>
					</li>
					<li onclick="location.href='${path}/wechatStatic/dramaFestival.do?tab=2'">
						<div>活动规则</div>
					</li>
					<li onclick="location.href='${path}/wechatStatic/dramaFestival.do?tab=3'">
						<div>排行榜</div>
					</li>
					<div style="clear: both;"></div>
				</ul>
			</div>
		</div>
		<div style="padding: 25px;background-color: #eeeeee;">
			<div style="background-color: #fff;padding: 20px;">
				<div class="dramaRule" style="padding-bottom: 40px;border-bottom: 1px solid #262626;">
					<p style="text-align: center;font-size: 34px;color: #262626;font-weight: bold;margin: 20px 0;">#&emsp;&emsp;写剧评&emsp;&emsp;#</p>
					<p style="text-align: center;font-size: 30px;">请先留下你的个人资料</p>
				</div>
				<div style="margin-top: 50px;">
					<div class="dramaInputTitle">
						<div >姓名</div>
						<input id="userName" type="text" value="" maxlength="20"/>
						<div style="clear: both;"></div>
					</div>
					<div class="dramaInputTitle">
						<div >电话</div>
						<input id="userMobile" type="text" value="" maxlength="11" />
						<div style="clear: both;"></div>
					</div>
				</div>
				<div style="width: 540px;margin: 40px auto 0;font-size: 24px;color: #262626;padding-left: 40px;">
					<ol>
						<li style="list-style: decimal;font-size: 24px;color: #262626;margin-bottom: 10px;">参与活动，提交剧评，即可当即获得200文化云积分 （每ID仅获得一次）</li>
						<li style="list-style: decimal;font-size: 24px;color: #262626;margin-bottom: 10px;">我们会在12月12日从所有参与活动的用户中，抽出10名获得上海当代戏剧节限量帆布环保袋1个</li>
						<li style="list-style: decimal;font-size: 24px;color: #262626;margin-bottom: 10px;">活动中奖信息我们将根据您填写的信息进行通知，请正确填写</li>
					</ol>
				</div>
				<div class="dramaSubmitBtn" onclick="saveInfo();">下一步</div>
			</div>
		</div>
	</div>
</body>
</html>
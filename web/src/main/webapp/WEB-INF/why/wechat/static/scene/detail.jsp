<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>安康文化云·我在现场</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css?v=01061228"/>
	
	<script>
		var sceneImgId = '${sceneImgId}';
		var noControl = 0;	//1：不可操作
	
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
				jsApiList: ['previewImage','onMenuShareAppMessage','onMenuShareTimeline','onMenuShareQQ','onMenuShareWeibo','onMenuShareQZone']
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
			//swiper初始化div
		    initSwiper();
			
			navFixed($(".kjmbNav"),'touchmove',240);
		    navFixed($(".kjmbNav"),'scroll',240);
		    
			$.post("${path}/wechatStatic/querySceneImgList.do",{sceneImgId: sceneImgId,userId:userId}, function (data) {
				if(data.length>0){
					var dom = data[0];
					$("#sceneImgUrl").attr("src",dom.sceneImgUrl+"@700w");
					$("#sceneImgUrl").attr("onclick","previewImg(\""+dom.sceneImgUrl+"\",\""+dom.sceneImgUrl+"\")");
					$(".userName").text(dom.userName);
					$("#sceneImgContent").text(dom.sceneImgContent);
					var userHeadImgHtml = getUserHeadImgHtml(dom.userHeadImgUrl);
					$("#userHeadImgUrl").html(userHeadImgHtml);
					$("#voteCount").text(dom.voteCount);
					if(dom.isVote == 1){
						$("#voteLove").addClass("current");
					}
				}
			},"json");
			
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
		
		//投票
		function sceneVote(){
			if(noControl != 1){
				if (userId == null || userId == '') {
	        		//判断登陆
	            	publicLogin("${basePath}wechatStatic/sceneDetail.do?sceneImgId="+sceneImgId);
	        	}else{
	        		$.post("${path}/wechatStatic/addSceneVote.do",{userId:userId,sceneImgId:sceneImgId}, function (data) {
	    				if(data == "200"){
	    					var voteCount = $("#voteCount").text();
	    					$("#voteCount").text(eval(voteCount)+1);
	    					$("#voteLove").addClass("current");
	    					dialogAlert('系统提示', '投票成功！');
	    				}else if(data == "repeat"){
	    					dialogAlert('系统提示', '一天只能投一票！');
	    				}else if(data == "500"){
	    					dialogAlert('系统提示', '投票失败！');
	    				}
	    			},"json");
	        	}
			}else{
				dialogAlert('系统提示', '活动已结束！');
			}
		}
		
		//头像
		function getUserHeadImgHtml(userHeadImgUrl){
			var userHeadImgHtml = '';
			if(userHeadImgUrl){
                if(userHeadImgUrl.indexOf("http") == -1){
                	userHeadImgUrl = getImgUrl(userHeadImgUrl);
                }
            }else{
            	userHeadImgUrl = '';
            }
			if (userHeadImgUrl.indexOf("http") == -1) {
            	userHeadImgHtml = "<img src='../STATIC/wx/image/sh_user_header_icon.png'/>";
            } else if (userHeadImgUrl.indexOf("/front/") != -1) {
                var imgUrl = getIndexImgUrl(userHeadImgUrl, "_300_300");
                userHeadImgHtml = "<img src='" + imgUrl + "' onerror='imgNoFind();'/>";
            } else {
            	userHeadImgHtml = "<img src='" + userHeadImgUrl + "' onerror='imgNoFind();'/>";
            }
			return userHeadImgHtml;
		}
		
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
				<li><a href="${path}/wechatStatic/sceneRule.do">活动规则</a></li>
				<li><a href="${awardUrl}">获奖名单</a></li>
			</ul>
		</div>
		<div class="roomcont jz700">
	        <div class="roomzpxq">
	            <div class="jinhaotit jz630">
	                <div class="h1">#&nbsp;&nbsp;请为“<span class="userName"></span>”发布的作品投票&nbsp;&nbsp;#</div>
	            </div>
	            <div class="tupian jz630" style="background-color: #7c7c7c;">
	                <img id="sceneImgUrl" src="" style="max-height: 570px;max-width: 630px;display: block;margin: auto;position: absolute;left:0;top:0;right:0;bottom:0;" onclick="$('.imgPreview').fadeIn('fast');">
	            </div>
	            <p id="sceneImgContent"></p>
	            <div class="lvvtouc">
	            	<div class="jz630 clearfix">
	            		<div class="pic" id="userHeadImgUrl"></div>
	            		<div class="char userName"></div>
	            		<div class="fu clearfix">
	                        <div id="voteLove" class="f2"><span></span><em id="voteCount"></em></div>
	                    </div>
	            	</div>
	            </div>
	            <div class="lccDoubleBtn jz630">
	                <a class="lan" href="javascript:sceneVote();">投票</a>
	                <a class="hong share-button" href="javascript:;">分享去拉票</a>
	            </div>
	        </div>
	    </div>
	</div>
	<!--点击放大图片-->
	<div class="imgPreview" style="display: none;">
		<img src="" />
	</div>
</body>
</html>
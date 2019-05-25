<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>佛山文化云·我在现场</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css?v=01061228"/>
	
	<script>
	
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '佛山文化云·互动赢积分，分享活动现场 展现艺术生活';
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
					title: "佛山文化云·互动赢积分，分享活动现场 展现艺术生活",
					desc: '将你真实感受到的精彩活动现场分享给更多人，精彩就会远远大于你的感受',
					imgUrl: '${basePath}/STATIC/wxStatic/image/roomagekind/shareIcon2.jpg'
				});
				wx.onMenuShareTimeline({
					title: "佛山文化云·互动赢积分，分享活动现场 展现艺术生活",
					imgUrl: '${basePath}/STATIC/wxStatic/image/roomagekind/shareIcon2.jpg'
				});
				wx.onMenuShareQQ({
					title: "佛山文化云·互动赢积分，分享活动现场 展现艺术生活",
					desc: '将你真实感受到的精彩活动现场分享给更多人，精彩就会远远大于你的感受',
					imgUrl: '${basePath}/STATIC/wxStatic/image/roomagekind/shareIcon2.jpg'
				});
				wx.onMenuShareWeibo({
					title: "佛山文化云·互动赢积分，分享活动现场 展现艺术生活",
					desc: '将你真实感受到的精彩活动现场分享给更多人，精彩就会远远大于你的感受',
					imgUrl: '${basePath}/STATIC/wxStatic/image/roomagekind/shareIcon2.jpg'
				});
				wx.onMenuShareQZone({
					title: "佛山文化云·互动赢积分，分享活动现场 展现艺术生活",
					desc: '将你真实感受到的精彩活动现场分享给更多人，精彩就会远远大于你的感受',
					imgUrl: '${basePath}/STATIC/wxStatic/image/roomagekind/shareIcon2.jpg'
				});
			});
		}
		
		$(function () {
			//swiper初始化div
		    initSwiper();
			
			loadMyImg();
			loadRankingImg();
			
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
		
		//查询自己上传照片
		function loadMyImg(){
			var data = {
            	userId: userId,
            	isMe: 1,
            	isVoteSort: 1,
            	isMonth: 1
            };
			$.post("${path}/wechatStatic/querySceneImgList.do",data, function (data) {
				if(data.length>0){
					$("#userInfo1").show();
					var dom = data[0];
					var userHeadImgHtml = getUserHeadImgHtml(dom.userHeadImgUrl);
					var ImgObj = new Image();
					ImgObj.src = dom.sceneImgUrl+"@200w";
					ImgObj.onload = function(){
						if(ImgObj.width/ImgObj.height>130/130){
							var pLeft = (ImgObj.width*(130/ImgObj.height)-130)/2;
							$("#myImgUrl").css({"height":"130px","position":"absolute","left":"-"+pLeft+"px"});
						}else{
							var pTop = (ImgObj.height*(130/ImgObj.width)-130)/2;
							$("#myImgUrl").css({"width":"130px","position":"absolute","top":"-"+pTop+"px"});
						}
					}
					$("#userInfo1").html("<table class='rankTab myselfTab'>" +
								            "<tr>" +
								                "<td class='td1'><span>"+dom.ranking+"</span></td>" +
								                "<td class='td2'><div><img id='myImgUrl' src='"+dom.sceneImgUrl+"@200w' onclick='previewImg(\""+dom.sceneImgUrl+"\",\""+dom.sceneImgUrl+"\")'></div></td>" +
								                "<td class='td3'>" +
								                	"<div class='nc'>" +
								                		"<div class='touxm clearfix'>" +
								                			"<div class='pic'>"+userHeadImgHtml+"</div>" +
								                			"<div class='char'>"+dom.userName+"</div>" +
								                		"</div>" +
								                		"<p>"+dom.sceneImgContent+"</p>" +
								                	"</div>" +
								                "</td>" +
								                "<td class='td4'><em></em><span>"+dom.voteCount+"</span></td>" +
								            "</tr>" +
								        "</table>");
				}
			},"json");
		}
		
		//ranking照片
		function loadRankingImg(){
			$.post("${path}/wechatStatic/querySceneUserRanking.do", function (data) {
				if(data.length>0){
					$.each(data, function (i, dom) {
						var userHeadImgHtml = getUserHeadImgHtml(dom.userHeadImgUrl);
						var ImgObj = new Image();
						ImgObj.src = dom.sceneImgUrl+"@200w";
						ImgObj.onload = function(){
							if(ImgObj.width/ImgObj.height>130/130){
								var pLeft = (ImgObj.width*(130/ImgObj.height)-130)/2;
								$("img[sceneImgId="+dom.userMaxImg+"]").css({"height":"130px","position":"absolute","left":"-"+pLeft+"px"});
							}else{
								var pTop = (ImgObj.height*(130/ImgObj.width)-130)/2;
								$("img[sceneImgId="+dom.userMaxImg+"]").css({"width":"130px","position":"absolute","top":"-"+pTop+"px"});
							}
						}
						$("#userInfo2").append("<tr>" +
									                "<td class='td1'><span>"+(i+1)+"</span></td>" +
									                "<td class='td2'><div><img sceneImgId='"+dom.userMaxImg+"' src='"+dom.sceneImgUrl+"@200w' onclick='previewImg(\""+dom.sceneImgUrl+"\",\""+dom.sceneImgUrl+"\")'></div></td>" +
									                "<td class='td3'>" +
									                	"<div class='nc'>" +
									                		"<div class='touxm clearfix'>" +
									                			"<div class='pic'>"+userHeadImgHtml+"</div>" +
									                			"<div class='char'>"+dom.userNickName+"</div>" +
									                		"</div>" +
									                		"<p>"+dom.sceneImgContent+"</p>" +
									                	"</div>" +
									                "</td>" +
									                "<td class='td4'><em></em><span>"+dom.userMaxVote+"</span></td>" +
									            "</tr>");
					});
				}
			},"json");
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
				<li class="current"><a href="${path}/wechatStatic/sceneRanking.do">排行榜</a></li>
				<li><a href="${path}/wechatStatic/sceneRule.do">活动规则</a></li>
				<li><a href="${awardUrl}">获奖名单</a></li>
			</ul>
		</div>
		<div id="userInfo1" class="rankingMyself" style="display: none;"></div>
		<div class="ranking">
	        <table id="userInfo2" class="rankTab"></table>
	    </div>
	</div>
</body>
</html>
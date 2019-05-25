<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>安康文化云·微笔记大赛</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		var noteId = '${noteId}';
		var isVote = '${isVote}';	//是否能投票（1：已结束）
	
		$(function () {
			$.post("${path}/wechatStatic/getMicronoteByCondition.do",{userId:userId,noteId:noteId}, function (data) {
				if (data.status == 1) {
					var dom = data.data;
					//头像
        			var userHeadImgHtml = '';
            		var userHeadImgUrl = dom.userHeadImgUrl;
        			if(userHeadImgUrl){
                        if(userHeadImgUrl.indexOf("http") == -1){
                        	userHeadImgUrl = getImgUrl(userHeadImgUrl);
                        }
                        if (userHeadImgUrl.indexOf("http")==-1) {
                        	userHeadImgHtml = "<img src='../STATIC/wx/image/sh_user_header_icon.png'/>";
                        } else if (userHeadImgUrl.indexOf("/front/") != -1) {
                            var imgUrl = getIndexImgUrl(userHeadImgUrl, "_300_300");
                            userHeadImgHtml = "<img src='" + imgUrl + "' onerror='imgNoFind();'/>";
                        } else {
                        	userHeadImgHtml = "<img src='" + userHeadImgUrl + "' onerror='imgNoFind();'/>";
                        }
                    }else{
                    	userHeadImgHtml = "<img src='${basePath}/STATIC/wx/image/sh_user_header_icon.png'/>";
                    }
        			$(".zsm-headimg").html(userHeadImgHtml);
        			$("#notePublisherName").text(("00"+dom.noteNum).substr(-3)+dom.notePublisherName);
        			$("#noteTitle").text(dom.noteTitle);
        			$("#noteContent").text(dom.noteContent);
        			if(dom.noteIsVote==0){
        				$("#voteBut").show();
        			}
        			
        			var shareUrl = $(".zsm-headimg img").attr("src");
        			
        			//分享是否隐藏
        		    if(window.injs){
        		    	//分享文案
        		    	appShareTitle = '市民文化节--云叔喊你来写读书笔记 赢丰富好礼';
        		    	appShareDesc = dom.notePublisherName+'正在参加阅读微笔记大赛，帮他投票，你得积分！投了才是好朋友喔！';
        		    	appShareImgUrl = shareUrl;
        		    	appShareLink = '${basePath}/wechatStatic/toMicronoteShare.do?noteId='+noteId;
        		    	
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
        						title: "市民文化节--云叔喊你来写读书笔记 赢丰富好礼",
        						desc: dom.notePublisherName+'正在参加阅读微笔记大赛，帮他投票，你得积分！投了才是好朋友喔！',
        						imgUrl: shareUrl,
        						link: '${basePath}wechatStatic/toMicronoteShare.do?noteId='+noteId
        					});
        					wx.onMenuShareTimeline({
        						title: dom.notePublisherName+'正在参加阅读微笔记大赛，帮他投票，你得积分！投了才是好朋友喔！',
        						imgUrl: shareUrl,
        						link: '${basePath}wechatStatic/toMicronoteShare.do?noteId='+noteId
        					});
        					wx.onMenuShareQQ({
        						title: "市民文化节--云叔喊你来写读书笔记 赢丰富好礼",
        						desc: dom.notePublisherName+'正在参加阅读微笔记大赛，帮他投票，你得积分！投了才是好朋友喔！',
        						imgUrl: shareUrl,
        						link: '${basePath}/wechatStatic/toMicronoteShare.do?noteId='+noteId
        					});
        					wx.onMenuShareWeibo({
        						title: "市民文化节--云叔喊你来写读书笔记 赢丰富好礼",
        						desc: dom.notePublisherName+'正在参加阅读微笔记大赛，帮他投票，你得积分！投了才是好朋友喔！',
        						imgUrl: shareUrl,
        						link: '${basePath}/wechatStatic/toMicronoteShare.do?noteId='+noteId
        					});
        					wx.onMenuShareQZone({
        						title: "市民文化节--云叔喊你来写读书笔记 赢丰富好礼",
        						desc: dom.notePublisherName+'正在参加阅读微笔记大赛，帮他投票，你得积分！投了才是好朋友喔！',
        						imgUrl: shareUrl,
        						link: '${basePath}/wechatStatic/toMicronoteShare.do?noteId='+noteId
        					});
        				});
        			}
				}
			}, "json");
			
			//分享
			$(".shareBut").click(function() {
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
		});
		
		//投票
		function voteNote(){
			if(isVote == 1){
				dialogAlert('系统提示', '活动结束，已不能投票！');
			}else{
				if (userId == null || userId == '') {
	        		//判断登陆
	            	publicLogin("${basePath}wechatStatic/toMicronoteShare.do?noteId="+noteId);
	        	}else{
					$.post("${path}/wechatStatic/voteMicronote.do",{noteId:noteId,userId:userId}, function (data) {
						if (data.status == 1) {
							$("#voteBut").hide();
							dialogConfirm("提示","投票成功！",function(){
								location.href='${path}/wechatStatic/toMicronoteList.do';
							})
						}
					}, "json");
	        	}
			}
		}
	</script>
	
	<style>
		html,
		body {
			height: 100%;
			width: 100%;
		}
		
		.zsm-main {
			height: 100%;
			background-position: 100% 100%;
		}
	</style>
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${basePath}/STATIC/wx/image/share_120.png"/></div>
	<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
		<img src="${path}/STATIC/wechat/image/commonShare.png" style="width: 100%;height: 100%;" />
	</div>
	<div class="zsm-main">
		<div class="zsm-head">
			<div class="zsm-headimg"></div>
		</div>
		<div class="zsm-vote">
			<p class="zsm-voteName">请为<span style="font-size: 40px;color: #ea593d;" id="notePublisherName"></span>投票</p>
			<p class="zsm-votePoint">参与投票获得积分</p>
		</div>
		<div class="zsm-nameDetail">
			<div>
				<p class="zsm-title" style="margin: 0;color: #6571b0;" id="noteTitle"></p>
				<p id="noteContent"></p>
			</div>
		</div>
		<div class="vote-btn1" id="voteBut" onclick="voteNote();" style="display: none;">
			<img src="${path}/STATIC/wxStatic/image/zsm/vote-btn1.png"/>
		</div>
		<div class="vote-btn2">
			<div class="shareBut">
				<img src="${path}/STATIC/wxStatic/image/zsm/share.png" />
			</div>
			<div onclick="location.href='${path}/wechatStatic/toMicronoteList.do'">
				<img src="${path}/STATIC/wxStatic/image/zsm/goback.png" />
			</div>
		</div>
	</div>
</body>
</html>
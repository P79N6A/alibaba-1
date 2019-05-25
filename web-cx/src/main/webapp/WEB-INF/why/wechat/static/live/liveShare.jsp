<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>佛山文化云·乡土文化大展现场直播</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css?v=20161021"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		var liveType = 3;	//直播类别
		var liveUserId = '${liveUserId}';
	
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
        	appShareTitle = '现场直播 | 精彩跨界演出邀您探访海派文化脉络';
        	appShareDesc = '海上寻源，揭晓市民眼中的100个上海乡土文化符号，颁奖典礼正在直播...';
        	appShareImgUrl = '${basePath}/STATIC/wxStatic/image/live/shareIcon3.jpg';
        	
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
					title: "现场直播 | 精彩跨界演出邀您探访海派文化脉络",
					desc: '海上寻源，揭晓市民眼中的100个上海乡土文化符号，颁奖典礼正在直播...',
					link: '${basePath}wechatStatic/liveShare.do?liveUserId='+liveUserId,
					imgUrl: '${basePath}/STATIC/wxStatic/image/live/shareIcon3.jpg'
				});
				wx.onMenuShareTimeline({
					title: "现场直播 | 精彩跨界演出邀您探访海派文化脉络",
					imgUrl: '${basePath}/STATIC/wxStatic/image/live/shareIcon3.jpg',
					link: '${basePath}wechatStatic/liveShare.do?liveUserId='+liveUserId
				});
				wx.onMenuShareQQ({
					title: "现场直播 | 精彩跨界演出邀您探访海派文化脉络",
					desc: '海上寻源，揭晓市民眼中的100个上海乡土文化符号，颁奖典礼正在直播...',
					imgUrl: '${basePath}/STATIC/wxStatic/image/live/shareIcon3.jpg'
				});
				wx.onMenuShareWeibo({
					title: "现场直播 | 精彩跨界演出邀您探访海派文化脉络",
					desc: '海上寻源，揭晓市民眼中的100个上海乡土文化符号，颁奖典礼正在直播...',
					imgUrl: '${basePath}/STATIC/wxStatic/image/live/shareIcon3.jpg'
				});
				wx.onMenuShareQZone({
					title: "现场直播 | 精彩跨界演出邀您探访海派文化脉络",
					desc: '海上寻源，揭晓市民眼中的100个上海乡土文化符号，颁奖典礼正在直播...',
					imgUrl: '${basePath}/STATIC/wxStatic/image/live/shareIcon3.jpg'
				});
			});
		}
		
		$(function () {
			$.post("${path}/wechatStatic/getLiveUserDetail.do",{liveUserId:liveUserId,liveActivity:liveType}, function (data) {
    			if (data.status == 1) {
    				var dom = data.data;
    				var userHeadImgHtml = '';
					if(dom.userHeadImgUrl){
		                if(dom.userHeadImgUrl.indexOf("http") == -1){
		                	dom.userHeadImgUrl = getImgUrl(dom.userHeadImgUrl);
		                }
		            }else{
		            	dom.userHeadImgUrl = '';
		            }
					if (dom.userHeadImgUrl.indexOf("http") == -1) {
		            	userHeadImgHtml = "<img src='../STATIC/wx/image/sh_user_header_icon.png' width='74' height='74'/>";
		            } else if (dom.userHeadImgUrl.indexOf("/front/") != -1) {
		                var imgUrl = getIndexImgUrl(dom.userHeadImgUrl, "_300_300");
		                userHeadImgHtml = "<img src='" + imgUrl + "' onerror='imgNoFind();' width='74' height='74'/>";
		            } else {
		            	userHeadImgHtml = "<img src='" + dom.userHeadImgUrl + "' onerror='imgNoFind();' width='74' height='74'/>";
		            }
					$("#userHeadImgUrl").html(userHeadImgHtml);
					$("#userName").html(dom.userName);
					var ImgObj = new Image();
					ImgObj.src = dom.userUploadImg;
					ImgObj.onload = function(){
						if(ImgObj.width/ImgObj.height>635/460){
							$("#userUploadImg").css("height","460px");
						}else{
							$("#userUploadImg").css("width","635px");
						}
					}
					$("#userUploadImg").attr("src",dom.userUploadImg+"@700w");
					$("#userUploadImg").attr("onclick","showPreview('"+dom.userUploadImg+"@700w')");
    			}else{
    				dialogAlert('系统提示', data.msg.errmsg);
    			}
    		},"json");
			
			//关闭图片预览
			$(".imgPreview,.imgPreview>img").click(function() {
				$(".imgPreview").fadeOut("fast");
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
		
		//保存用户上传图片
		function toLiveText(){
			if (userId == null || userId == '') {
				//判断登陆
		    	publicLogin('${basePath}wechatStatic/liveText.do');
			}else{
				location.href='${path}/wechatStatic/liveText.do'
			}
		}
		
		//预览大图
		function showPreview(url){
			$(".imgPreview img").attr("src",url);
			$(".imgPreview").fadeIn("fast");
		}
	</script>
	
	<style>
		html,body {
			font-family: arial, \5FAE\8F6F\96C5\9ED1, \9ED1\4F53, \5b8b\4f53, sans-serif;
			-webkit-text-size-adjust: none;
		}
		img {
			vertical-align: middle;
		}
	</style>
	
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${basePath}/STATIC/wxStatic/image/live/shareIcon3.jpg"/></div>
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
	<div class="zhibo">
		<div class="zbban">
			<img src="${path}/STATIC/wxStatic/image/live/ban3.jpg" width="750" height="250">
			<ul class="lccshare clearfix">
				<li>
					<a class="share-button" href="javascript:;">分享</a>
				</li>
				<li>
					<a class="keep-button" href="javascript:;">关注</a>
				</li>
			</ul>
		</div>

		<!-- 传好照片 -->
		<div class="bcSharePageDiv">
			<div class="bcSharePage">
				<div class="livefenx clearfix">
					<div class="fx_1" id="userHeadImgUrl"></div>
					<div class="fx_2" id="userName"></div>
				</div>
				<div style="position: relative;margin: 30px auto 0;width: 635px;height: 460px;overflow: hidden;">
					<img id="userUploadImg" src="" style="display: block;" />
				</div>
				<div style="width: 600px;margin: 60px auto 0;">
					<div class="bcSharePageBtn bcSharePageBtnOff" style="float: left;background-color: #59b8bc!important;" onclick="toLiveText();">更多现场</div>
					<div class="bcSharePageBtn share-button" style="float: right;background-color: #7279a0;">分享</div>
					<div style="clear: both;"></div>
				</div>
			</div>
		</div>
		
		<!--点击放大图片-->
		<div class="imgPreview" style="display: none;">
			<img src="" />
		</div>
	</div>
</body>
</html>
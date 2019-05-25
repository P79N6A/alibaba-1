<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>安康文化云·上海国际喜剧节系列活动</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css?v=1104"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
	
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '文化云 | 快来围观我的笑脸，和我一起哈哈哈哈';
	    	appShareDesc = '哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈';
	    	appShareImgUrl = '${basePath}/STATIC/wxStatic/image/comedy/shareIcon.jpg';
	    	
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
					title: "文化云 | 快来围观我的笑脸，和我一起哈哈哈哈",
					desc: '哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈',
					link: '${basePath}wechatStatic/comedyDetail.do?userId=${userId}',
					imgUrl: '${basePath}/STATIC/wxStatic/image/comedy/shareIcon.jpg',
					success: function () { 
						$('.comedy .bcSharePageDiv').hide();
						$('.comedy .zhuanfcg').show();
						
						//关闭蒙版
						$("html,body").removeClass("bg-notouch");
						$(".background-fx").css("display", "none")
				    }
				});
				wx.onMenuShareTimeline({
					title: "文化云 | 快来围观我的笑脸，和我一起哈哈哈哈",
					link: '${basePath}wechatStatic/comedyDetail.do?userId=${userId}',
					imgUrl: '${basePath}/STATIC/wxStatic/image/comedy/shareIcon.jpg',
					success: function () { 
						$('.comedy .bcSharePageDiv').hide();
						$('.comedy .zhuanfcg').show();
						
						//关闭蒙版
						$("html,body").removeClass("bg-notouch");
						$(".background-fx").css("display", "none")
				    }
				});
				wx.onMenuShareQQ({
					title: "文化云 | 快来围观我的笑脸，和我一起哈哈哈哈",
					desc: '哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈',
					imgUrl: '${basePath}/STATIC/wxStatic/image/comedy/shareIcon.jpg',
					success: function () { 
						$('.comedy .bcSharePageDiv').hide();
						$('.comedy .zhuanfcg').show();
						
						//关闭蒙版
						$("html,body").removeClass("bg-notouch");
						$(".background-fx").css("display", "none")
				    }
				});
				wx.onMenuShareWeibo({
					title: "文化云 | 快来围观我的笑脸，和我一起哈哈哈哈",
					desc: '哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈',
					imgUrl: '${basePath}/STATIC/wxStatic/image/comedy/shareIcon.jpg',
					success: function () { 
						$('.comedy .bcSharePageDiv').hide();
						$('.comedy .zhuanfcg').show();
						
						//关闭蒙版
						$("html,body").removeClass("bg-notouch");
						$(".background-fx").css("display", "none")
				    }
				});
				wx.onMenuShareQZone({
					title: "文化云 | 快来围观我的笑脸，和我一起哈哈哈哈",
					desc: '哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈',
					imgUrl: '${basePath}/STATIC/wxStatic/image/comedy/shareIcon.jpg',
					success: function () { 
						$('.comedy .bcSharePageDiv').hide();
						$('.comedy .zhuanfcg').show();
						
						//关闭蒙版
						$("html,body").removeClass("bg-notouch");
						$(".background-fx").css("display", "none")
				    }
				});
			});
		}
		
		$(function () {
			$.post("${path}/wechatStatic/queryComedyDetail.do",{userId: '${userId}'}, function (data) {
				var dom = data;
				var userHeadImgHtml = '';
				if(dom.userHeadImgUrl){
	                if(dom.userHeadImgUrl.indexOf("http") == -1){
	                	dom.userHeadImgUrl = getImgUrl(dom.userHeadImgUrl);
	                }
	            }else{
	            	dom.userHeadImgUrl = '';
	            }
				if (dom.userHeadImgUrl.indexOf("http") == -1) {
	            	userHeadImgHtml = "<img src='../STATIC/wx/image/sh_user_header_icon.png' width='90' height='90'/>";
	            } else if (dom.userHeadImgUrl.indexOf("/front/") != -1) {
	                var imgUrl = getIndexImgUrl(dom.userHeadImgUrl, "_300_300");
	                userHeadImgHtml = "<img src='" + imgUrl + "' onerror='imgNoFind();' width='90' height='90'/>";
	            } else {
	            	userHeadImgHtml = "<img src='" + dom.userHeadImgUrl + "' onerror='imgNoFind();' width='90' height='90'/>";
	            }
				var comedyBtnHtml = "";
				if(userId == dom.userId){
					comedyBtnHtml = "<div class='bcSharePageBtn btn_2 share-button' style='float: right;background-color: #ffb505;'>分享赢T恤</div>";
				}else{
					comedyBtnHtml = "<div onclick=\"location.href='${path}/wechatStatic/comedyFestival.do'\" class='bcSharePageBtn btn_2' style='float: right;background-color: #ffb505;'>我也要传笑脸</div>";
				}
				$("#comedyCode").text(("000"+dom.comedyCode).substr(-4));
				$("#comedyDiv").html("<div class='livefenx clearfix'>" +
										"<div class='fx_1'>"+userHeadImgHtml+"</div>" +
										"<div class='fx_2'>" +
											"<span class='s1'>"+dom.tuserName+"</span>" +
											"<span class='s2'>我的笑脸你喜欢吗？你也笑一个给我看看</span>" +
										"</div>" +
									 "</div>" +
									 "<div onclick='showPreview(\""+dom.comedyUrl+"@700w\");' style='position: relative;margin: 30px auto 0;width: 630px;height: 570px;overflow:hidden;background-color: #7c7c7c;'>" +
										"<img src='"+dom.comedyUrl+"@600w' style='display: block;max-height: 570px;max-width: 630px;display: block;margin: auto;position: absolute;left:0;top:0;right:0;bottom:0;'>" +
									 "</div>" +
									 "<div style='width: 600px;margin: 60px auto 0;'>" +
										"<div class='bcSharePageBtn bcSharePageBtnOff btn_1' style='float: left;background-color: #7aa9ff!important'><a href='${path}/wechatStatic/comedyFestival.do' style='color:#fff;display:block;'>更多笑脸</a></div>" +
										comedyBtnHtml+
										"<div style='clear: both;'></div>" +
									 "</div>");
				//分享
				$(".share-button").click(function() {
					if (!is_weixin()&&!(/wenhuayun/.test(ua))) {
						dialogAlert('系统提示', '请用微信浏览器打开分享！');
					}else{
						$("html,body").addClass("bg-notouch");
						$(".background-fx").css("display", "block")
					}
				})
			},"json");
			
			//顶部菜单fixed
			$(document).on('scroll', function() {
				if($(document).scrollTop() > 242) {
					$(".comedy .coNav").css("position", "fixed")
				} else {
					$(".comedy .coNav").css("position", "static")
				}
			});
			$(document).on('touchmove', function() {
				if($(document).scrollTop() > 242) {
					$(".comedy .coNav").css("position", "fixed")
				} else {
					$(".comedy .coNav").css("position", "static")
				}
			});
			
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
		
		//预览大图
		function showPreview(url){
			$(".imgPreview img").attr("src",url);
			$(".imgPreview").fadeIn("fast");
		}
	</script>
	
	<style>
		* {-webkit-tap-highlight-color: transparent;}
		html,body {
			font-family: arial, \5FAE\8F6F\96C5\9ED1, \9ED1\4F53, \5b8b\4f53, sans-serif;
			-webkit-text-size-adjust: none;
		}
		html,body,.comedy {min-height: 100%;}
		img {
			vertical-align: middle;
		}
		.comedy {overflow: hidden;}
	</style>
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${basePath}/STATIC/wxStatic/image/comedy/shareIcon.jpg"/></div>
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
	<div class="comedy">
		<div class="coban">
			<img src="${path}/STATIC/wxStatic/image/comedy/ban1.jpg" width="750" height="250">
			<ul class="lccshare clearfix">
				<li class="share-button"><a href="javascript:;">分享</a></li>
				<li class="keep-button"><a href="javascript:;">关注</a></li>
			</ul>
		</div>
		<div class="coNav_wc">
			<ul class="coNav clearfix">
				<li class="current"><a href="${path}/wechatStatic/comedyFestival.do">最美笑脸</a></li>
				<li><a href="${path}/wechatStatic/comedyFestival.do?tab=1">活动规则</a></li>
				<li><a href="http://ct.wenhuayun.cn/template/activityTopicDetail.do?topicid=24">喜剧节</a></li>
			</ul>
		</div>
		<div class="bcSharePageDiv">
			<div class="bcSharePage">
				<div id="comedyDiv" class="nc"></div>
			</div>
		</div>
	
		<!-- 转发成功 -->
		<div class="zhuanfcg">
			<div class="nc">
				<p style="text-align: center;font-size: 32px;border-bottom:1px solid #262626;padding-bottom:50px;">#&nbsp;&nbsp;转发成功&nbsp;&nbsp;#</p>
				<div class="cjm">
					<span class="s1">你的抽奖码为</span>
					<span id="comedyCode" class="s2"></span>
				</div>
				<div class="wz">
					<p><span style="background-color:#af7272;color:#f9f0d3;">请记住你的抽奖码</span></p>
					<p>活动名单会在“文化云”微信公众平台上公布请提前关注“文化云”官方微信公众号</p>
					<img style="display:block;margin: 0 auto;margin-top:20px;" src="${path}/STATIC/wxStatic/image/comedy/pic8.jpg" width="208" height="208">
					<div style="text-align:center;font-weight:bold;">
						【扫一扫】<br>关注“文化云”微信号
					</div>
					<img style="display:block;position:absolute;left:50%;margin-left:-2500px; top:-130px;z-index:10;" src="${path}/STATIC/wxStatic/image/comedy/pic9.png">
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
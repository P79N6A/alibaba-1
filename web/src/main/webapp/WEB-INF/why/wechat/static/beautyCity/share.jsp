<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>安康文化云·发现城市之美</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		var beautycityImgId = '${beautycityImgId}';
		var isEnd = '${isEnd}';		//是否能参与（1：已结束）
	
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '我拍下了上海最美的城市空间，不服来比';
	    	appShareDesc = '用手机镜头，拍下最美空间的最美印记，100元电话卡，最美城市纪念图册等你来拿';
	    	appShareImgUrl = '${basePath}/STATIC/wxStatic/image/beautyCity/beautycityShare.jpg';
	    	
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
					title: "我拍下了上海最美的城市空间，不服来比",
					desc: '用手机镜头，拍下最美空间的最美印记，100元电话卡，最美城市纪念图册等你来拿',
					imgUrl: '${basePath}/STATIC/wxStatic/image/beautyCity/beautycityShare.jpg'
				});
				wx.onMenuShareTimeline({
					title: "我拍下了上海最美的城市空间，不服来比",
					imgUrl: '${basePath}/STATIC/wxStatic/image/beautyCity/beautycityShare.jpg'
				});
				wx.onMenuShareQQ({
					title: "我拍下了上海最美的城市空间，不服来比",
					desc: '用手机镜头，拍下最美空间的最美印记，100元电话卡，最美城市纪念图册等你来拿',
					imgUrl: '${basePath}/STATIC/wxStatic/image/beautyCity/beautycityShare.jpg'
				});
				wx.onMenuShareWeibo({
					title: "我拍下了上海最美的城市空间，不服来比",
					desc: '用手机镜头，拍下最美空间的最美印记，100元电话卡，最美城市纪念图册等你来拿',
					imgUrl: '${basePath}/STATIC/wxStatic/image/beautyCity/beautycityShare.jpg'
				});
				wx.onMenuShareQZone({
					title: "我拍下了上海最美的城市空间，不服来比",
					desc: '用手机镜头，拍下最美空间的最美印记，100元电话卡，最美城市纪念图册等你来拿',
					imgUrl: '${basePath}/STATIC/wxStatic/image/beautyCity/beautycityShare.jpg'
				});
			});
		}
		
		$(function () {
			$.post("${path}/wechatStatic/getBeautycityImgList.do",{userId: userId,beautycityImgId: beautycityImgId}, function (data) {
				if (data.status == 1) {
					$.each(data.data.list, function (i, dom) {
						var beautycityImgUrl = dom.beautycityImgUrl+"@700w";
						$("#beautycityImgUrl").attr("src",beautycityImgUrl);
						if(dom.beautycityImgIsVote!=0){
            				$("#voteBut").addClass("bcSharePageBtnOff");
            			}else{
            				$("#voteBut").attr("onclick","userVote()");
            			}
						if(dom.beautycityImgIsVote==0){
            				voteImg = "${path}/STATIC/wxStatic/image/beautyCity/brvOff.png";
            			}else{
            				voteImg = "${path}/STATIC/wxStatic/image/beautyCity/brvOn.png";
            			}
						$("#voteImg").attr("src",voteImg);
						$("#userName").text(dom.userName);
						$("#venueName").text(dom.venueName);
						$("#voteCount").text(dom.voteCount);
						
					});
				}
			},"json");
			
			//分享
			$(".bcShare,#bcSharePageBtn").click(function() {
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
			$(".bcKeep").on("touchstart", function() {
				$('.div-share').show()
				$("body,html").addClass("bg-notouch")
			})
		});
		
		//投票
		function userVote(){
			if(isEnd == 1){
				dialogAlert('系统提示', '活动结束，已不能投票！');
			}else{
				if (userId == null || userId == '') {
	        		//判断登陆
	            	publicLogin("${basePath}wechatStatic/beautyCityShare.do");
	        	}else{
	        		$("#voteBut").attr("onclick","");
					$.post("${path}/wechatStatic/voteBeautycityImg.do",{beautycityImgId:beautycityImgId,userId:userId}, function (data) {
						if (data.status == 1) {
							var voteCount = $("#voteCount").text();
							$("#voteCount").text(eval(voteCount)+1);
							$("#voteBut").addClass("bcSharePageBtnOff");
							$("#voteImg").attr("src","${path}/STATIC/wxStatic/image/beautyCity/brvOn.png");
						}
					}, "json");
	        	}
			}
		} 
		
	</script>
	
	<style>
		html,body {
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
	<div style="display: none;"><img src="${basePath}/STATIC/wxStatic/image/beautyCity/beautycityShare.jpg"/></div>
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
	<div class="beautyCityMain">
		<div class="bcTop">
			<img src="${path}/STATIC/wxStatic/image/beautyCity/banner.jpg" />
			<div class="bcKeep">
				<img src="${path}/STATIC/wxStatic/image/beautyCity/keep.png" />
			</div>
			<div class="bcShare">
				<img src="${path}/STATIC/wxStatic/image/beautyCity/share.png" />
			</div>
		</div>
		<div class="bcMenu">
			<div class="bcMenuList">
				<ul>
					<li onclick="location.href='${path}/wechatStatic/beautyCity.do'">首页</li>
					<li onclick="location.href='${path}/wechatStatic/beautyCity.do?tagNum=1'">空间之美</li>
					<li onclick="location.href='${path}/wechatStatic/beautyCity.do?tagNum=2'">活动规则</li>
					<li onclick="location.href='${path}/wechatStatic/beautyCity.do?tagNum=3'">排行榜</li>
					<div style="clear: both;"></div>
				</ul>
			</div>
		</div>
		<div class="bcSharePageDiv" style="overflow: hidden;background-color: #eeeeee;">
			<div class="bcSharePage">
				<p style="text-align: center;font-size: 32px;">#&nbsp;请为“<span id="userName"></span>”发布的照片投票&nbsp;#</p>
				<p style="font-size: 28px;text-align: center;margin-top: 20px;"><img style="vertical-align: initial;margin-right: 14px;" src="${path}/STATIC/wxStatic/image/beautyCity/bcplace.png" /><span id="venueName"></span></p>
				<div style="position: relative;margin: 30px auto 0;width: 635px;height: 570px;">
					<img id="beautycityImgUrl" src="" width="635" height="570" style="display: block;" />
					<div style="position: absolute;right: 20px;bottom: 20px;color: #fff;font-size: 26px;background:rgba(0,0,0,0.3);border-radius:10px;padding:5px 10px">
						<img id="voteImg" src="${path}/STATIC/wxStatic/image/beautyCity/brvOff.png" style="vertical-align: text-bottom;margin-right: 14px;" /><span id="voteCount"></span>
					</div>
				</div>
				<div style="width: 600px;margin: 30px auto 0;">
					<div id="voteBut" class="bcSharePageBtn" style="float: left;background-color: #7aa9ff;">投票</div>
					<div id="bcSharePageBtn" class="bcSharePageBtn" style="float: right;background-color: #ff7575;">分享去拉票</div>
					<div style="clear: both;"></div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
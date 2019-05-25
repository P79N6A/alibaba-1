 
 
 <%@ page language="java" pageEncoding="UTF-8" %>
 
 <script type="text/javascript">

//分享是否隐藏
if(window.injs){
	//分享文案
	appShareTitle = '市民文化节中华优秀传统文化知识大赛，等你来挑战！';
	appShareDesc = '戏曲精粹、诗词经典、人文民俗，总有一个你擅长！';
	appShareImgUrl = '${basePath}/STATIC/wxStatic/image/tradKnow/shareIcon.jpg';
	
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
			title: "市民文化节中华优秀传统文化知识大赛，等你来挑战！",
			desc: '戏曲精粹、诗词经典、人文民俗，总有一个你擅长！',
			imgUrl: '${basePath}/STATIC/wxStatic/image/tradKnow/shareIcon.jpg'
		});
		wx.onMenuShareTimeline({
			title: "市民文化节中华优秀传统文化知识大赛，等你来挑战！",
			imgUrl: '${basePath}/STATIC/wxStatic/image/tradKnow/shareIcon.jpg'
		});
		wx.onMenuShareQQ({
			title: "市民文化节中华优秀传统文化知识大赛，等你来挑战！",
			desc: '戏曲精粹、诗词经典、人文民俗，总有一个你擅长！',
			imgUrl: '${basePath}/STATIC/wxStatic/image/tradKnow/shareIcon.jpg'
		});
		wx.onMenuShareWeibo({
			title: "市民文化节中华优秀传统文化知识大赛，等你来挑战！",
			desc: '戏曲精粹、诗词经典、人文民俗，总有一个你擅长！',
			imgUrl: '${basePath}/STATIC/wxStatic/image/tradKnow/shareIcon.jpg'
		});
		wx.onMenuShareQZone({
			title: "市民文化节中华优秀传统文化知识大赛，等你来挑战！",
			desc: '戏曲精粹、诗词经典、人文民俗，总有一个你擅长！',
			imgUrl: '${basePath}/STATIC/wxStatic/image/tradKnow/shareIcon.jpg'
		});
	});
}
 
 $(function() {
 	
 	//封面分享收藏
 	$("#keep").on("click",function(e){
 		$('.div-share').show()
 		$("body,html").addClass("bg-notouch")
 	})

 	$("#share").click(function(e) {
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
 </script>
 
 <div style="display: none;"><img src="${path}/STATIC/wxStatic/image/tradKnow/shareIcon.jpg"/></div>
		<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
			<img src="${path}/STATIC/wxStatic/image/fx-bg.png" style="width: 100%;height: 100%;" />
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
  <div class="clearfix">
            <img class="tkwlogo" src="${path}/STATIC/wxStatic/image/tradKnow/logo1.png">
            <div class="tkBtn clearfix">
                <a href="javascript:;" onclick="toWhyIndex();"></a>
                <a href="javascript:;" id="keep"></a>
                <a href="javascript:;" id="share"></a>
            </div>
        </div>
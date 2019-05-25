<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>

	<head>
		<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
		<title>红星耀中国</title>
		<script>
		
		 var title='同志，这里有一只革命锦囊，组织正式邀请你成为革命的一份子！';
		 var desc= '纪念长征胜利80周年，点亮红星，五千只革命锦囊等你来拿！';
		 var imgUrl='${basePath}/STATIC/wxStatic/image/redStar/share_150.png';
		 
			//分享是否隐藏
	   	 if(window.injs){
	    	//分享文案
	    	appShareTitle = title;
	    	appShareDesc =desc;
	    	appShareImgUrl = imgUrl;
	    	
			injs.setAppShareButtonStatus(true);
			
			injs.changeNavTitle('红星照耀中国'); 
			
	   	}else{
			$(document).attr("title",'红星照耀中国');
		}
			
				$(function(){
					
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
								desc: desc,
								imgUrl: imgUrl,
								link: '${basePath}wechatRedStar/welcome.do'
							});
							wx.onMenuShareTimeline({
								title: title,
								imgUrl: imgUrl,
								link: '${basePath}wechatRedStar/welcome.do'
							});
							wx.onMenuShareQQ({
								title: title,
								desc: desc,
								imgUrl: imgUrl,
								link: '${basePath}/wechatRedStar/welcome.do'
							});
							wx.onMenuShareWeibo({
								title: title,
								desc: desc,
								imgUrl: imgUrl,
								link: '${basePath}/wechatRedStar/welcome.do'
							});
							wx.onMenuShareQZone({
								title: title,
								desc: desc,
								imgUrl: imgUrl,
								link: '${basePath}/wechatRedStar/welcome.do'
							});
						});
					}
				
					
					$("#indexpgBtn").click(function(){
						window.location.href = "index.do"
					})
					
					$("#indexpgBtn2").click(function(){
						window.location.href = "../wechatStatic/redStarIntro.do"
					})
					
					   	 
				})
			</script>
			<style>
				html,body{
					width: 100%;height: 100%;
				}
			</style>
</head>

	<body>
		<div style="width: 750px;height:100%;margin: auto;">
			<div id="indexpg" style="width: 100%;height: 100%;background: url(${path}/STATIC/wxStatic/image/redStar/index.jpg) no-repeat center center;background-size: 100% 100%;">
			<div  style="width: 100%;position: absolute;left: 0;right: 0;bottom: 70px;text-align: center;">
				<img id="indexpgBtn" style="margin-right:20px;" src="${path}/STATIC/wxStatic/image/redStar/pageBtn.png" />
				<img id="indexpgBtn2" src="${path}/STATIC/wxStatic/image/redStar/pageBtn2.png" />
			</div>
		</div>
		</div>
	</body>
</html>
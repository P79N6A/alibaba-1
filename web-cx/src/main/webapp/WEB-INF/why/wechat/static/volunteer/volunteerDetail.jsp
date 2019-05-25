<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title></title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<style>
		.volunteers-content{
			padding-bottom: 100px;
		}
	</style>
	
	<script>
		
		$(function () {
			
			var recruitId=$("#recruitId").val();
			
			 var title='正在佛山文化云招募志愿者';
			 var desc= '期待热爱文化、艺术，热心公益的你的加入';
			 var imgUrl='${basePath}/STATIC/wx/image/share_120.png'; 
			
			$.post("${path}/wechatStatic/getVolunteerDetail.do",{recruitId:recruitId}, function (data) {
				if (data.status == 1) {
					
					var dom=data.data;
					
					var recruitName=dom.recruitName;
					var recruitIconUrl=getImgUrl(dom.recruitIconUrl);
					// 招募条件
					var recruitCondition=dom.recruitCondition;
					// 消费者权益
					var recruitInterest= dom.recruitInterest;
					// 团队介绍
					var teamIntroduce= dom.teamIntroduce;
					
					if(window.injs){	//判断是否存在方法
    					injs.changeNavTitle(recruitName+"招募"); 
    				}else{
    					$(document).attr("title",recruitName+"招募");
    				}
					
					$("#recruitName").html(recruitName);
					$("#recruitIconUrl").attr("src",recruitIconUrl);
					$("#recruitCondition").html('<li>' + recruitCondition + '</li>');
					$("#recruitInterest").html('<li>' + recruitInterest + '</li>');
					$("#teamIntroduce").html('<li>' + teamIntroduce + '</li>');
					
					title=recruitName+title;
				}
			}, "json");
			
			//分享是否隐藏
		    if(window.injs){
		    	//分享文案
		    	appShareTitle = title;
		    	appShareDesc = desc;
		    	appShareImgUrl = imgUrl;
		    	appShareLink = '${basePath}/wechatStatic/toVolunteerDetail.do?recruitId='+recruitId;
		    	
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
						title: title,
						desc: desc,
						imgUrl: imgUrl,
						link: '${basePath}wechatStatic/toVolunteerDetail.do?recruitId='+recruitId
					});
					wx.onMenuShareTimeline({
						title: title,
						imgUrl: imgUrl,
						link: '${basePath}wechatStatic/toVolunteerDetail.do?recruitId='+recruitId
					});
					wx.onMenuShareQQ({
						title: title,
						desc: desc,
						imgUrl: imgUrl,
						link: '${basePath}/wechatStatic/toVolunteerDetail.do?recruitId='+recruitId
					});
					wx.onMenuShareWeibo({
						title: title,
						desc: desc,
						imgUrl: imgUrl,
						link: '${basePath}/wechatStatic/toVolunteerDetail.do?recruitId='+recruitId
					});
					wx.onMenuShareQZone({
						title: title,
						desc: desc,
						imgUrl: imgUrl,
						link: '${basePath}/wechatStatic/toVolunteerDetail.do?recruitId='+recruitId
					});
				});
			}
			
			// 我要报名
			$(".volunteers-footer").click(function () {
				
				if (userId ==null || userId == '') {
		            
		            publicLogin("${basePath}wechatStatic/createVolunteerApply.do?recruitId=" + recruitId);
		        }
				else
				{
					 window.location.href = '${path}/wechatStatic/createVolunteerApply.do?recruitId='+recruitId;
		             return;
				}
		    })
		});
		
		
	</script>
</head>	
	<body>
		<div class="volunteers-main">
		<input type="hidden" value="${recruitId }" name="recruitId" id="recruitId"/>
			<div class="volunteers-content">
				<div class="vHotTitle">
					<img src=""  id="recruitIconUrl"/>
					<p id="recruitName"></p>
				</div>
				<div class="vHotCond">
					<p>招募条件</p>
					<ul id="recruitCondition">
						
					</ul>
				</div>
				<div class="vHotCond">
					<p>志愿者权益</p>
					<ul id="recruitInterest">
						
					</ul>
				</div>
				<div class="vHotCond">
					<p>团队简介</p>
					<ul id="teamIntroduce">
						
					</ul>
				</div>
			</div>
			<div class="volunteers-footer" style="cursor: pointer;">
				<p>我要报名</p>
			</div>
		</div>
	</body>


</html>
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>市民文化节·我们的行走故事摄影大赛</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	
	<script>
		var walkImgId = '${walkImgId}';
		var noVote = '${noVote}';	//1：不可投票
	
		$(function () {
			//swiper初始化div
		    initSwiper();
			
			navFixed($(".kjmbNav"),'touchmove',240);
		    navFixed($(".kjmbNav"),'scroll',240);
		    
			$.post("${path}/wechatStatic/queryWalkImgList.do",{walkImgId: walkImgId,userId:userId}, function (data) {
				if(data.length>0){
					var dom = data[0];
                    if (dom.walkImgUrl) {
                        var walkImgUrls = dom.walkImgUrl.split(";");
                        $.each(walkImgUrls, function (i, walkImgUrl) {
                        	$("#walkImgUrl").append("<li style='background-color:#7c7c7c;' onclick='previewImg(\""+walkImgUrl+"\",\""+dom.walkImgUrl+"\")'><img src='" + walkImgUrl + "@700w'></li>");
                        });
                    }
                    imgStyleFormat('roomzpxq');
					$(".userName").text(dom.userName);
					$("#walkImgSite").append(dom.walkImgTime+"摄于"+dom.walkImgSite);
					$("#walkImgName").text(dom.walkImgName);
					$("#walkImgContent").append(dom.walkImgContent.replace(/\r\n/g,"<br/>"));
					var userHeadImgHtml = getUserHeadImgHtml(dom.userHeadImgUrl);
					$("#userHeadImgUrl").html(userHeadImgHtml);
					$("#voteCount").text(dom.voteCount);
					if(dom.isVote == 1){
						$("#voteLove").addClass("current");
					}
					
					//分享是否隐藏
				    if(window.injs){
				    	//分享文案
				    	appShareTitle = '市民文化节·“我们的行走故事”摄影作品正在征集';
				    	appShareDesc = '助力'+dom.userName+', 帮TA投票将摄影作品陈列展览载入史册！你也可以一起参加哟~';
				    	appShareImgUrl = 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017323101459AcVBGKPrKi9FEFuAXEmrBnn0hfMSDD.jpg';
				    	
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
								title: "市民文化节·“我们的行走故事”摄影作品正在征集",
								desc: '助力'+dom.userName+', 帮TA投票将摄影作品陈列展览载入史册！你也可以一起参加哟~',
								imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017323101459AcVBGKPrKi9FEFuAXEmrBnn0hfMSDD.jpg'
							});
							wx.onMenuShareTimeline({
								title: '助力'+dom.userName+', 帮TA投票将摄影作品陈列展览载入史册！你也可以一起参加哟~',
								imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017323101459AcVBGKPrKi9FEFuAXEmrBnn0hfMSDD.jpg'
							});
							wx.onMenuShareQQ({
								title: "市民文化节·“我们的行走故事”摄影作品正在征集",
								desc: '助力'+dom.userName+', 帮TA投票将摄影作品陈列展览载入史册！你也可以一起参加哟~',
								imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017323101459AcVBGKPrKi9FEFuAXEmrBnn0hfMSDD.jpg'
							});
							wx.onMenuShareWeibo({
								title: "市民文化节·“我们的行走故事”摄影作品正在征集",
								desc: '助力'+dom.userName+', 帮TA投票将摄影作品陈列展览载入史册！你也可以一起参加哟~',
								imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017323101459AcVBGKPrKi9FEFuAXEmrBnn0hfMSDD.jpg'
							});
							wx.onMenuShareQZone({
								title: "市民文化节·“我们的行走故事”摄影作品正在征集",
								desc: '助力'+dom.userName+', 帮TA投票将摄影作品陈列展览载入史册！你也可以一起参加哟~',
								imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017323101459AcVBGKPrKi9FEFuAXEmrBnn0hfMSDD.jpg'
							});
						});
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
		function walkVote(){
			if(noVote != 1){
				if (userId == null || userId == '') {
	        		//判断登陆
	            	publicLogin("${basePath}wechatStatic/walkDetail.do?walkImgId="+walkImgId);
	        	}else{
	        		$.post("${path}/wechatStatic/addWalkVote.do",{userId:userId,walkImgId:walkImgId}, function (data) {
	    				if(data == "200"){
	    					var voteCount = $("#voteCount").text();
	    					$("#voteCount").text(eval(voteCount)+1);
	    					$("#voteLove").addClass("current");
	    					dialogAlert('系统提示', '投票成功！');
	    				}else if(data == "repeat"){
	    					dialogAlert('系统提示', '一天只能投一票！');
	    				}else if(data == "noPass"){
	    					dialogAlert('系统提示', '该作品还未通过审核！');
	    				}else if(data == "500"){
	    					dialogAlert('系统提示', '投票失败！');
	    				}
	    			},"json");
	        	}
			}else{
				dialogAlert('系统提示', '投票已结束！');
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
		.kjmbNav li {width: 130px;padding-left: 60px;padding-right: 60px;}
	</style>
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017323101459AcVBGKPrKi9FEFuAXEmrBnn0hfMSDD.jpg"/></div>
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
			<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20173241350114xTaBebccFZGcBmOZEqGTsc0uLWREb.jpg" width="750" height="250">
			<ul class="lccshare clearfix">
				<li class="share-button"><a href="javascript:;">分享</a></li>
				<li class="keep-button"><a href="javascript:;">关注</a></li>
			</ul>
		</div>
		<div class="kjmbNav_wc">
			<ul class="kjmbNav clearfix">
				<li><a href="${path}/wechatStatic/walkIndex.do">首页</a></li>
				<li><a href="${path}/wechatStatic/walkRule.do">活动规则</a></li>
				<li><a href="${path}/wechatStatic/walkRanking.do">排行榜</a></li>
			</ul>
		</div>
		<div class="roomcont jz700">
	        <div class="roomzpxq">
	            <div class="jinhaotit jz630">
	                <div class="h1">#&nbsp;&nbsp;请为“<span class="userName"></span>”发布的作品投票&nbsp;&nbsp;#</div>
	            </div>
	            <div class="jinhaoAdd" id="walkImgSite"><span></span></div>
	            <ul class="jiugge clearfix" id="walkImgUrl"></ul>
	            <div class="neirong" id="walkImgContent">
	                <div style="font-size:30px;color:#262626;margin-bottom:15px;" id="walkImgName"></div>
	            </div>
	            <div class="lvvtouc">
	            	<div class="jz630 clearfix">
	            		<div class="pic" id="userHeadImgUrl"></div>
	            		<div class="char userName"></div>
	            		<div class="fu clearfix">
	                        <div id="voteLove" class="f2" onclick="walkVote();"><span></span><em id="voteCount"></em></div>
	                    </div>
	            	</div>
	            </div>
	            <div class="lccDoubleBtn jz630">
	                <a class="lan" href="javascript:walkVote();">投票</a>
	                <a class="hong share-button" href="javascript:;">分享去拉票</a>
	            </div>
	        </div>
	    </div>
	</div>
</body>
</html>
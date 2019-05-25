<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>佛山文化云·文化非遗</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		var heritageId = '${heritageId}';
		
		//分享是否隐藏
        if(window.injs){
        	//分享文案
        	appShareTitle = '佛山文化云·非物质文化遗产风貌';
	    	appShareDesc = '感受乐山非遗项目历史传承、发展，体味传统文化和工艺之美和智慧';
	    	appShareImgUrl = '${basePath}/STATIC/wx/image/share_120.png';
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
					title: "佛山文化云·非物质文化遗产风貌",
					desc: '感受乐山非遗项目历史传承、发展，体味传统文化和工艺之美和智慧',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
				});
				wx.onMenuShareTimeline({
					title: "感受乐山非遗项目历史传承、发展，体味传统文化和工艺之美和智慧",
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
				});
				wx.onMenuShareQQ({
					title: "佛山文化云·非物质文化遗产风貌",
					desc: '感受乐山非遗项目历史传承、发展，体味传统文化和工艺之美和智慧',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
				});
				wx.onMenuShareWeibo({
					title: "佛山文化云·非物质文化遗产风貌",
					desc: '感受乐山非遗项目历史传承、发展，体味传统文化和工艺之美和智慧',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
				});
				wx.onMenuShareQZone({
					title: "佛山文化云·非物质文化遗产风貌",
					desc: '感受乐山非遗项目历史传承、发展，体味传统文化和工艺之美和智慧',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
				});
			});
		}
		
		$(function () {
			$.post("${path}/wechatStatic/getCcpHeritageDetail.do",{heritageId:heritageId,userId:userId}, function (data) {
                if (data.status == 1) {
                	var dom = data.data;
                	$(".loveNum").text(dom.heritageWantCount);
                	if (dom.heritageIsWant>0) {		//点赞（我想去）
                		$(".feiyi-love").find("img").attr("src", "${path}/STATIC/wxStatic/image/feiyi/love-on.png");
    					$(".feiyi-love").addClass("love-on");
                    }
                	$("#heritageIntroduce").html(dom.heritageIntroduce);
            		var imgUrls = dom.heritageImg.split(",");
            		$.each(imgUrls, function (i, url) {
            			var imgUrl = getIndexImgUrl(getImgUrl(url),"_750_500");
            			$("#heritageImg").append("<div class='swiper-slide'>" +
					                				"<img src='"+imgUrl+"' width='750' height='500'/>" +
					            				 "</div>");
            		});
            		var mySwiper = new Swiper('.swiper-container', {
            			loop: true,
            			// 如果需要分页器
            			pagination: '.swiper-pagination',
            			paginationType: 'fraction'
            		})
                }
			},"json");
			
			//简介自动高度
			var fy_h = document.body.clientHeight - 640;
			$(".feiyi-detail").css("height", fy_h);
			
			//分享
			$(".feiyi-share").click(function() {
				if (!is_weixin()&&!(/wenhuayun/.test(ua))) {
					dialogAlert('系统提示', '请用微信浏览器打开分享！');
				}else{
					$("html,body").addClass("bg-notouch");
					$(".background-fx").css("display", "block")
				}
			});
			$(".background-fx").click(function() {
				$("html,body").removeClass("bg-notouch");
				$(".background-fx").css("display", "none")
			})

		});
		
		//点赞（我想去）
        function addWantGo() {
            if (userId == null || userId == '') {
            	//判断登陆
	        	publicLogin("${basePath}wechatStatic/heritageDetail.do?heritageId="+heritageId);
            }else{
            	$.post("${path}/wechatUser/addUserWantgo.do", {
            		relateId: heritageId,
                    userId: userId,
                    type: 4
                }, function (data) {
                    if (data.status == 0) {
                    	$(".feiyi-love").find("img").attr("src", "${path}/STATIC/wxStatic/image/feiyi/love-on.png");
    					$(".feiyi-love").addClass("love-on");
    					var num = $(".loveNum").text();
    					$(".loveNum").text(eval(num)+1);
                    } else if (data.status == 14111) {
                        $.post("${path}/wechatUser/deleteUserWantgo.do", {
                        	relateId: heritageId,
                            userId: userId
                        }, function (data) {
                            if (data.status == 0) {
                            	$(".feiyi-love").find("img").attr("src", "${path}/STATIC/wxStatic/image/feiyi/love.png");
            					$(".feiyi-love").removeClass("love-on");
            					var num = $(".loveNum").text();
            					$(".loveNum").text(eval(num-1));
                            }
                        }, "json");
                    }
                }, "json");
            }
        }
	</script>
	
	<style>
		html,
		body {
			height: 100%;
		}
		
		.swiper-container {
			padding:0;
			width: 750px;
			height: 500px;
			margin: auto;
		}
		
		.swiper-pagination {
			position:absolute;
			bottom:auto;
			font-size:40px;
			left: 0px;
			right: 0px;
			margin: auto;
			color: #fff;
			z-index: 10px!important;
			width: 150px;
			height: 50px;
			border-radius: 25px;
			background: url(${path}/STATIC/wxStatic/image/feiyi/70.png);
		}
	</style>
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src=""/></div>
	<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
		<img src="${path}/STATIC/wxStatic/image/bkqs/shareBg.png" style="width: 100%;height: 100%;" />
	</div>
	<div class="feiyi-main">
		<div class="swiper-container">
			<div class="swiper-wrapper" id="heritageImg"></div>
			<!-- 如果需要分页器 -->
			<div class="swiper-pagination"></div>
		</div>

		<div class="feiyi-detail">
			<div>
				<p id="heritageIntroduce"></p>
			</div>
		</div>

		<div class="feiyi-footer">
			<div class="feiyi-btn">
				<div class="feiyi-love" onclick="addWantGo();">
					<p><img src="${path}/STATIC/wxStatic/image/feiyi/love.png"/><span>赞</span><span class="loveNum"></span></p>
				</div>
				<div class="feiyi-share">
					<p><img src="${path}/STATIC/wxStatic/image/feiyi/keep.png"/><span>分享</span></p>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
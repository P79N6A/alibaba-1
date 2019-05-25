<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>社团图片</title>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>
    <script type="text/javascript" src="${path}/STATIC/wxStatic/js/gridify.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/common.js"></script>

    <script>
        var assnId = '${assnId}';
        
      	//分享是否隐藏
        if(window.injs){
        	//分享文案
        	appShareTitle = '文化云大咖圈，精彩连连看';
        	appShareDesc = '众多活跃文艺团体、匠人济济一堂';
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
                    title: "文化云大咖圈，精彩连连看",
                    desc: '众多活跃文艺团体、匠人济济一堂',
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
                wx.onMenuShareTimeline({
                    title: "众多活跃文艺团体、匠人济济一堂",
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
                wx.onMenuShareQQ({
                	title: "文化云大咖圈，精彩连连看",
                	desc: '众多活跃文艺团体、匠人济济一堂',
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
                wx.onMenuShareWeibo({
                	title: "文化云大咖圈，精彩连连看",
                	desc: '众多活跃文艺团体、匠人济济一堂',
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
                wx.onMenuShareQZone({
                	title: "文化云大咖圈，精彩连连看",
                	desc: '众多活跃文艺团体、匠人济济一堂',
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
            });
        
        };
        
        $(function(){
        	$.post("${path}/wechatAssn/getAssnRes.do",{associationId:assnId,resType:1}, function (data) {
    			if(data.status == 1){
    				$.each(data.data, function (i, dom) {
    					var assnResNameHtml = "";
    					if(dom.assnResName){
    						assnResNameHtml = "<p class='pb-font'>"+dom.assnResName+"</p>";
    					}
    					var assnResName = dom.assnResName!=null?dom.assnResName:"";
    					var assnResUrl = dom.assnResUrl.indexOf("http://")<0?getIndexImgUrl(getImgUrl(dom.assnResUrl),"_750_500"):(dom.assnResUrl+"@800w");
    					$("#assnImgList").append("<div class='pb'><img src='"+assnResUrl+"' width='360'>"+assnResNameHtml+"</div>");
    					$("#assnImgDetail").append("<div class='swiper-slide'>" +
														"<img src='"+assnResUrl+"' />" +
						    							"<div class='upload-user'>" +
						    								"<p class='upload-user-p1'>"+assnResName+"</p>" +
						    								"<p class='upload-user-p2'>"+formatTimestamp(dom.createTime).substring(0,10)+" 上传</p>" +
						    								"<div style='clear: both;'></div>" +
						    							"</div>" +
						    						"</div>");
            		});
    				
    				//点击图片放大swiper初始化
    				$(".pb-on").css("display", "block")
    				var mySwiper2 = new Swiper('.swiper-container2', {
    					pagination: '.swiper-pagination',
    					paginationType: "fraction",
    					slidesPerView: 1,
    					spaceBetween: 20,
    					freeMode: false
    				})
    				$(".pb-on").css("display", "none")
    				
    				$(".pb").click(function() {
    					mySwiper2.slideTo($(this).index());
    					$(".pb-on").fadeIn("fast");
    					
    					//点击关闭swiper图片
    					$(".swiper-container2 .swiper-slide").click(function() {
    						$(".pb-on").fadeOut("fast");
    					})
    				})
    				
    				//瀑布流初始化
    				var options = {
   						srcNode: '.pb', // grid items (class, node)
   						margin: '10px', // margin in pixel, default: 0px
   						width: '360px', // grid item width in pixel, default: 220px
   						max_width: '', // dynamic gird item width if specified, (pixel)
   						resizable: true, // re-layout if window resize
   						transition: 'all 0.5s ease' // support transition for CSS3, default: all 0.5s ease
   					}
   					$('.grid').gridify(options);
        		}
        	}, "json");
        })
        
    </script>
    
    <style>
		.swiper-container {
			float: none;
		}
		
		.swiper-container-horizontal>.swiper-pagination-bullets,
		.swiper-pagination-custom,
		.swiper-pagination-fraction {
			top: 200px;
			height: 50px;
			font-size: 40px;
			color: #fff;
		}
		
	</style>
</head>
<body class="photo">
	<div class="main">
		<%-- <div class="header">
			<div class="index-top">
				<span class="index-top-5" onclick="history.go(-1);">
					<img src="${path}/STATIC/wechat/image/arrow1.png" />
				</span>
				<span class="index-top-2">社团照片</span>
			</div>
		</div> --%>
		<div class="content padding-bottom0">
			<div class="grid" id="assnImgList"></div>
			<div class="pb-on">
				<div class="swiper-container2">
					<div class="swiper-wrapper" id="assnImgDetail"></div>
					<!--分页器-->
					<div class="swiper-pagination"></div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
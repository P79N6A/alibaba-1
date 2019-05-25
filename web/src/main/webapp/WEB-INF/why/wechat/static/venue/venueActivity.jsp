<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp" %>
    <script type="text/javascript" src="${path}/STATIC/wechat/js/jquery.lazyload.min.js"></script>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css">
    <script type="text/javascript">
        var startIndex = 0;		//页数
        var venueId = '${venueId}';
        
        $(function () {
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
            }
            
            loadVenue();
            loadActivity(0, 20);
        });
        
        function loadVenue(){
        	$.post("${path}/wechatVenue/venueDetail.do",{venueId: venueId}, function (data) {
        		if (data.status == 0) {
        			var dom = data.data[0];
        			if(window.injs){	//判断是否存在方法
    					injs.changeNavTitle(dom.venueName); 
    				}else{
    					$(document).attr("title",dom.venueName);
    				}
        			//微信分享
        			if (is_weixin()) {
	        			var venueIconUrl = getIndexImgUrl(dom.venueIconUrl, "_750_500");
	                    wx.ready(function () {
	                        wx.onMenuShareAppMessage({
	                            title: "我在安康文化云发现了一个非常棒的地方-["+dom.venueName+"]",
	                            desc: '提供公众文化生活和消费的互联网平台，为公众提供便捷和有品质的文化生活服务。',
	                            imgUrl: venueIconUrl
	                        });
	                        wx.onMenuShareTimeline({
	                            title: "我在安康文化云发现了一个非常棒的地方-["+dom.venueName+"]",
	                            imgUrl: venueIconUrl
	                        });
	                        wx.onMenuShareQQ({
	                        	title: "我在安康文化云发现了一个非常棒的地方-["+dom.venueName+"]",
	                        	desc: '提供公众文化生活和消费的互联网平台，为公众提供便捷和有品质的文化生活服务。',
	                            imgUrl: venueIconUrl
	                        });
	                        wx.onMenuShareWeibo({
	                        	title: "我在安康文化云发现了一个非常棒的地方-["+dom.venueName+"]",
	                        	desc: '提供公众文化生活和消费的互联网平台，为公众提供便捷和有品质的文化生活服务。',
	                            imgUrl: venueIconUrl
	                        });
	                        wx.onMenuShareQZone({
	                        	title: "我在安康文化云发现了一个非常棒的地方-["+dom.venueName+"]",
	                        	desc: '提供公众文化生活和消费的互联网平台，为公众提供便捷和有品质的文化生活服务。',
	                            imgUrl: venueIconUrl
	                        });
	                    });
        			}
        			
        			//分享是否隐藏
        		    if(window.injs){
        		    	//分享文案
        		    	appShareTitle = "我在安康文化云发现了一个非常棒的地方-["+dom.venueName+"]";
        		    	appShareDesc = '提供公众文化生活和消费的互联网平台，为公众提供便捷和有品质的文化生活服务。';
        		    	appShareImgUrl = venueIconUrl;
        		    	
        				injs.setAppShareButtonStatus(true);
        			}
        		}
        	}, "json");
        }

        function loadActivity(index, pagesize) {
        	//图片懒加载开始位置
        	var liCount = $("#activityUl li").length;
            $.post("${path}/wechatVenue/venueWcActivity.do", {
                venueId: venueId,
                pageIndex: index,
                pageNum: pagesize
            }, function (data) {
                if (data.status == 0) {
                	if(data.data.length<20){
                		$(window).off("scroll");	//取消滚动加载
            			if(data.data.length==0&&index==0){
            				$("#loadingDiv").html("<span class='noLoadingSpan' style='padding-left:170px;'>这个场馆目前没有在线活动~</span>");
            			}else{
            				$("#loadingDiv").html("");
            			}
	        		}
                    $.each(data.data, function (i, dom) {
                        var time = dom.activityStartTime.substring(5, 10).replace("-", ".");
                        if (dom.activityEndTime.length > 0&&dom.activityStartTime!=dom.activityEndTime) {
                            time += "-" + dom.activityEndTime.substring(5, 10).replace("-", ".");
                        }
                        var activityIconUrl = getIndexImgUrl(dom.activityIconUrl, "_750_500");
                        var price = "";
                        if(dom.activityAbleCount > 0 || dom.activityIsReservation == 1){
                        	if(dom.activityIsFree==2 || dom.activityIsFree==3){
       	    					if (dom.activityPrice.length != 0 && dom.activityPrice > 0) {
       	    						if(dom.priceType==0){
       	    							price += "<div class='activePay'><p>" + dom.activityPrice + "元起</p></div>";
    	 	   	    				}else if(dom.priceType==1){
    	  								price += "<div class='activePay'><p>" + dom.activityPrice + "元/人</p></div>";
    	 	   	    				}else if(dom.priceType==2){
    	  								price += "<div class='activePay'><p>" + dom.activityPrice + "元/张</p></div>";
    	 	   	    				}else if(dom.priceType==3){
    	  								price += "<div class='activePay'><p>" + dom.activityPrice + "元/份</p></div>";
    	 	   	    				}else{
       	    							price += "<div class='activePay'><p>" + dom.activityPrice + "元/张</p></div>";
       	    						}
       	                        } else {
       	                        	price += "<div class='activePay'><p>收费</p></div>";
       	                        }
       	    				}else{
       	    					price += "<div class='activePay'><p>免费</p></div>";
       	    				}
   	        			}else{
   	        				price += "<div class='activePay actOrderNone'><p>已订完</p></div>";
   	        			}
	        			var tagHtml = "<ul class='activeTab'>";
            			tagHtml += "<li>"+dom.tagName+"</li>";
            			$.each(dom.subList, function (j, sub) {
            				if(j==2){
            					return false;
            				}
            				tagHtml += "<li>"+sub.tagName+"</li>";
            			});
            			tagHtml += "</ul>"
            			var isReservationHtml = "";
            			if(dom.activityIsReservation == 2){
            				if(dom.spikeType == 1){
            					isReservationHtml += "<div class='activeState'><img src='${path}/STATIC/wechat/image/miao.png'/></div>";
            				}else{
            					isReservationHtml += "<div class='activeState'><img src='${path}/STATIC/wechat/image/ding.png'/></div>";
            				}
            			}
            			$("#activityUl").append("<li activityId=" + dom.activityId + " onclick='toActDetail(\"" + dom.activityId + "\")'>" +
					    							"<div class='activeList'>" +
														"<img class='lazy' src='${path}/STATIC/wechat/image/placeholder.png' data-original='" + activityIconUrl + "' width='750' height='475'/>" +
														isReservationHtml + tagHtml + price +
					    							"</div>" +
					    							"<p class='activeTitle'>"+dom.activityName+"</p>" +
					    							"<p class='activePT'>"+time+" | "+dom.activityLocationName+"</p>" +
					    						"</li>");
                    });
                    
                  	//图片懒加载
        			$("#activityUl li:gt("+liCount+") img.lazy,.active ul li:eq("+liCount+") img.lazy").lazyload({
	        		    effect : "fadeIn",
	        		    effectspeed : 1000
	        		});
                }
            }, "json");
        }
        
      	//滑屏分页
        $(window).on("scroll", function () {
            var scrollTop = $(document).scrollTop();
            var pageHeight = $(document).height();
            var winHeight = $(window).height();
            if (scrollTop >= (pageHeight - winHeight - 10)) {
           		startIndex += 20;
           		var index = startIndex;
           		setTimeout(function () { 
           			loadActivity(index, 20);
           		},500);
            }
        });
    </script>
    
    <style>
    	html,body{height:100%;background-color:#f3f3f3}
        #venueName{
        	white-space : nowrap;
	      	text-overflow : ellipsis;
	     	-o-text-overflow : ellipsis;
	      	overflow : hidden;
        	width: 710px;
        	left: 0px;
        	padding: 0 20px;
        }
    </style>
</head>
<body>
	<div class="main" ms-controller="main">
	    <!-- <div class="header">
	        <div class="index-top">
	            <span class="index-top-2" id="venueName"></span>
	        </div>
	    </div> -->
	    <div class="content">
	        <div class="active">
	            <ul id="activityUl" class="activeUl"></ul>
	        </div>
	        <div id="loadingDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>
	    </div>
	</div>
</body>
</html>
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <!-- <title>活动列表</title> -->
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp" %>
    <script type="text/javascript" src="${path}/STATIC/wechat/js/jquery.lazyload.min.js"></script>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css">
    <script type="text/javascript">
        var latitude = 31.22;
        var longitude = 121.48;
        var startIndex = 0;		//页数
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
                    jsApiList: ['getLocation','onMenuShareAppMessage','onMenuShareTimeline','onMenuShareQQ','onMenuShareWeibo','onMenuShareQZone']
                });
                wx.ready(function () {
                	wx.onMenuShareAppMessage({
                        title: "我在“文化云”发现一大波文化活动，快来和我一起预订吧！",
                        desc: '现汇聚上海22万场文化活动及场馆资源',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
                        success: function () {
                            dialogAlert('系统提示', '分享成功！');
                        }
                    });
                    wx.onMenuShareTimeline({
                        title: "我在“文化云”发现一大波文化活动，快来和我一起预订吧！",
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
                        success: function () {
                            dialogAlert('系统提示', '分享成功！');
                        }
                    });
                    wx.onMenuShareQQ({
                        title: "我在“文化云”发现一大波文化活动，快来和我一起预订吧！",
                        desc: '现汇聚上海22万场文化活动及场馆资源',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                    });
                    wx.onMenuShareWeibo({
                        title: "我在“文化云”发现一大波文化活动，快来和我一起预订吧！",
                        desc: '现汇聚上海22万场文化活动及场馆资源',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                    });
                    wx.onMenuShareQZone({
                        title: "我在“文化云”发现一大波文化活动，快来和我一起预订吧！",
                        desc: '现汇聚上海22万场文化活动及场馆资源',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                    });
                    wx.getLocation({
                        type: 'gcj02', // 默认为wgs84的gps坐标，如果要返回直接给openLocation用的火星坐标，可传入'gcj02'
                        success: function (res) {
                            latitude = (res.latitude == null || res.latitude == "") ? 0 : res.latitude; // 纬度，浮点数，范围为90 ~ -90
                            longitude = (res.longitude == null || res.longitude == "") ? 0 : res.longitude; // 经度，浮点数，范围为180 ~ -180。
                            main.loadDate(0, 20);
                        },
    	    		    fail: function (res){
    	    		    	dialogAlert("系统提示", "获取坐标失败，定位未启用");
    	    		    	main.loadDate(0, 20);
    	    		    }
                    });
                });
            } else {
                if (window.navigator.geolocation) {
                    var options = {enableHighAccuracy: true};
                    window.navigator.geolocation.getCurrentPosition(handleSuccess, handleError, options);
                } else {
                    dialogAlert("系统提示", "浏览器不支持html5来获取地理位置信息");
                }
                function handleSuccess(position) {
                    var lng = position.coords.longitude;
                    var lat = position.coords.latitude;
                    longitude = wgs84togcj02(lng, lat)[0];
                    latitude = wgs84togcj02(lng, lat)[1];
                    main.loadDate(0, 20);
                }

                function handleError(error) {
                	dialogAlert("系统提示", "获取坐标失败，定位未启用");
                	main.loadDate(0, 20);
                }
            }
        });


        var main = avalon.define({
            $id: "main",
            count: "",
            active: "",
            venueId: '${venueId}',
            activityList: function (data,index,liCount) {
                main.count = "共为您筛选"+data.pageTotal+"条活动";
                if (data.status == 0) {
                	if(data.data.length<20){
            			if(data.data.length==0&&index==0){
            				$("#loadingDiv").html("<span class='noLoadingSpan'>没有找到合适的结果，换个试试看吧~</span>");
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
                        if(dom.activityIsFree==2){
        					if (dom.activityPrice.length != 0 && dom.activityPrice > 0) {
        						if(dom.priceType==0){
	    							price += "<span style='font-size: 57px;'>" + dom.activityPrice + "</span>元起";
	    						}else{
	    							price += "<span style='font-size: 57px;'>" + dom.activityPrice + "</span>元/人";
	    						}
                            } else {
                            	price += "<span style='font-size: 57px;'>收费</span>";
                            }
        				}else{
        					price += "<span style='font-size: 57px;'>免费</span>";
        				}
                        var tagHtml = "<ul class='tab-p2'>";
            			tagHtml += "<li>"+dom.activitySubject.substring(dom.activitySubject.length-4)+"</li>";
            			tagHtml += "<li>"+dom.tagName+"</li>";
            			if(dom.activitySubject.length>4){
            				tagHtml += "<li>"+dom.activitySubject.substring(0,dom.activitySubject.length-5)+"</li>";
            			}
            			tagHtml += "</ul>"
                        main.active += "<li activityId=" + dom.activityId + " onclick='main.showActivity(\"" + dom.activityId + "\")'>" +
                                "<img class='lazy' src='${path}/STATIC/wechat/image/placeholder.png' data-original='" + activityIconUrl + "' width='750' height='475'/>" +
                                "<img src='${path}/STATIC/wechat/image/蒙板.png' class='masking'/>" +
                                "<span class='tab-p1'>"+dom.activityName+"</span>" +
								tagHtml +
								"<span class='tab-p3'>"+dom.activityLocationName+"</span>" +
								"<span class='tab-p4'>"+price+"</span>" +
								"<span class='tab-p5'>"+time+"</span>" +
                                "</li>";
                    });
                    
                  	//图片懒加载
        			$(".active ul li:gt("+liCount+") img.lazy,.active ul li:eq("+liCount+") img.lazy").lazyload({
	        		    effect : "fadeIn",
	        		    effectspeed : 1000
	        		});
                }

            },
            showActivity: function (activityId) {
                window.location.href = "${path}/wechatActivity/preActivityDetail.do?activityId=" + activityId;
            },
            loadDate: function (index, pagesize) {
            	//图片懒加载开始位置
            	var liCount = $(".active ul li").length;
                if (main.venueId.length > 0) {
                    main.loadDateFromVennue(index, pagesize,liCount)
                }else{
                    $.post("${path}/wechatActivity/wcCmsActivityListByCondition.do", {
                        activityType: '${activityType}',
                        activityName: '${activityName}',
                        activityArea: '${area}',
                        Lon: longitude,
                        Lat: latitude,
                        pageIndex: index,
                        pageNum: pagesize
                    }, function (data) {
                        main.activityList(data,index,liCount);
                    }, "json");
                }
            },
            loadDateFromVennue: function (index, pagesize,liCount) {
                $.post("${path}/wechatVenue/venueWcActivity.do", {
                    venueId: '${venueId}',
                    Lon: longitude,
                    Lat: latitude,
                    pageIndex: index,
                    pageNum: pagesize
                }, function (data) {
                    main.count = "共"+data.pageTotal+"个活动";
                    if (data.status == 0) {
                    	if(data.data.length<20){
                			if(data.data.length==0&&index==0){
                				$("#loadingDiv").html("<span class='noLoadingSpan'>没有找到合适的结果，换个试试看吧~</span>");
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
                            if (dom.activityPrice.length != 0 && dom.activityPrice > 0) {
                            	if(dom.priceType==0){
	    							price += "<span style='font-size: 57px;'>" + dom.activityPrice + "</span>元起";
	    						}else{
	    							price += "<span style='font-size: 57px;'>" + dom.activityPrice + "</span>元/人";
	    						}
                            } else {
                                price += "<span style='font-size: 57px;'>免费</span>";
                            }
                            var tagHtml = "<ul class='tab-p2'>";
                			tagHtml += "<li>"+dom.activitySubject.substring(dom.activitySubject.length-4)+"</li>";
                			tagHtml += "<li>"+dom.tagName+"</li>";
                			if(dom.activitySubject.length>4){
                				tagHtml += "<li>"+dom.activitySubject.substring(0,dom.activitySubject.length-5)+"</li>";
                			}
                			tagHtml += "</ul>"
                            main.active += "<li activityId=" + dom.activityId + " onclick='main.showActivity(\"" + dom.activityId + "\")'>" +
                                    "<img class='lazy' src='${path}/STATIC/wechat/image/placeholder.png' data-original='" + activityIconUrl + "' width='750' height='475'/>" +
                                    "<img src='${path}/STATIC/wechat/image/蒙板.png' class='masking'/>" +
                                    "<span class='tab-p1'>"+dom.activityName+"</span>" +
									tagHtml +
									"<span class='tab-p3'>"+dom.activityLocationName+"</span>" +
									"<span class='tab-p4'>"+price+"</span>" +
									"<span class='tab-p5'>"+time+"</span>" +
                                    "</li>";
                        });
                        
                      	//图片懒加载
            			$(".active ul li:gt("+liCount+") img.lazy,.active ul li:eq("+liCount+") img.lazy").lazyload({
    	        		    effect : "fadeIn",
    	        		    effectspeed : 1000
    	        		});
                    }
                }, "json");
            }
        });
        
      	//滑屏分页
        $(window).on("scroll", function () {
            var scrollTop = $(document).scrollTop();
            var pageHeight = $(document).height();
            var winHeight = $(window).height();
            if (scrollTop >= (pageHeight - winHeight - 100)) {
           		startIndex += 20;
           		var index = startIndex;
           		setTimeout(function () { 
           			main.loadDate(index, 20);
           		},1000);
            }
        });
    </script>
    
    <style>
    	html,body,.main{height:100%}
        .content {padding-top: 100px;padding-bottom: 18px;}
    </style>
</head>
<body>
	<div class="main" ms-controller="main">
	    <div class="header">
	        <div class="index-top">
						<span class="index-top-5">
							<img src="${path}/STATIC/wechat/image/arrow1.png" onclick="history.back(-1);"/>
						</span>
	            <span class="index-top-2">{{count}}</span>
	        </div>
	    </div>
	    <div class="content">
	        <div class="active">
	            <ul>{{active|html}}</ul>
	        </div>
	        <div id="loadingDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>
	    </div>
	</div>
</body>
</html>
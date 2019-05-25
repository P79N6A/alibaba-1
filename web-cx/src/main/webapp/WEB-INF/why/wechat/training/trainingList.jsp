<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <title>艺术培训</title>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp" %>
    <script type="text/javascript" src="${path}/STATIC/wechat/js/jquery.lazyload.min.js"></script>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css">
    <script src="${path}/STATIC/js/avalon.js"></script>
    <script type="text/javascript">
	    var latitude = 22.964305;
		var longitude = 113.116029;
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
                        title: "我在“佛山文化云”发现一大波文化活动，快来和我一起预订吧！",
                        desc: '提供公众文化生活和消费的互联网平台，为公众提供便捷和有品质的文化生活服务。',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
                        success: function () {
                            dialogAlert('系统提示', '分享成功！');
                        }
                    });
                    wx.onMenuShareTimeline({
                        title: "我在“佛山文化云”发现一大波文化活动，快来和我一起预订吧！",
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
                        success: function () {
                            dialogAlert('系统提示', '分享成功！');
                        }
                    });
                    wx.onMenuShareQQ({
                        title: "我在“佛山文化云”发现一大波文化活动，快来和我一起预订吧！",
                        desc: '提供公众文化生活和消费的互联网平台，为公众提供便捷和有品质的文化生活服务。',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                    });
                    wx.onMenuShareWeibo({
                        title: "我在“佛山文化云”发现一大波文化活动，快来和我一起预订吧！",
                        desc: '提供公众文化生活和消费的互联网平台，为公众提供便捷和有品质的文化生活服务。',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                    });
                    wx.onMenuShareQZone({
                        title: "我在“佛山文化云”发现一大波文化活动，快来和我一起预订吧！",
                        desc: '提供公众文化生活和消费的互联网平台，为公众提供便捷和有品质的文化生活服务。',
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
                if (/wenhuayun/.test(ua)) {		//APP端
                    getAppUserLocation();
                    main.loadDate(0,20);
                }else{
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
            }
        });

        var main = avalon.define({
            $id: "main",
            count: "",
            active: "",
            venueId: '${venueId}',
            trainingList: function (data,index,liCount) {
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
                        tagHtml += "</ul>";
                        var isReservationHtml = "";
                        if(dom.activityIsReservation == 2){
                            if(dom.spikeType == 1){
                                isReservationHtml += "<div class='activeState'><img src='${path}/STATIC/wechat/image/miao.png'/></div>";
                            }else{
                                isReservationHtml += "<div class='activeState'><img src='${path}/STATIC/wechat/image/ding.png'/></div>";
                            }
                        }
                        $(".activeUl").append("<li activityId=" + dom.activityId + " onclick='main.showActivity(\"" + dom.activityId + "\")'>" +
                                "<div class='activeList'>" +
                                "<img class='lazy' src='${path}/STATIC/wechat/image/placeholder.png' data-original='" + activityIconUrl + "' width='750' height='475'/>" +
                                isReservationHtml + tagHtml + price +
                                "</div>" +
                                "<p class='activeTitle'>"+dom.activityName+"</p>" +
                                "<p class='activePT'>"+time+" | "+dom.activityLocationName+"</p>" +
                                "</li>");
                    });

                    //图片懒加载
                    $(".active ul li:gt("+liCount+") img.lazy,.active ul li:eq("+liCount+") img.lazy").lazyload({
                        effect : "fadeIn",
                        effectspeed : 1000
                    });
                }

            },
            showActivity: function (activityId) {
                toActDetail(activityId);
            },
            loadDate: function (index, pagesize) {
                //图片懒加载开始位置
                var liCount = $(".active ul li").length;
                    $.post("${path}/wechatActivity/wcCmsActivityListByCondition.do", {
                        activityType: 'e4c2cef5b0d24b2793ac00fd1098e4e7',
                        activityName: '${activityName}',
                        activityArea: '${area}',
                        Lon: longitude,
                        Lat: latitude,
                        pageIndex: index,
                        pageNum: pagesize
                    }, function (data) {
                        main.trainingList(data,index,liCount);
                    }, "json");
            },
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
        html,body,.main{height:100%;background-color:#f3f3f3}
        .content {padding-bottom: 0px;}
    </style>
</head>
<body>
<div class="main" ms-controller="main">
    <div class="content">
        <div class="active">
            <ul class="activeUl"></ul>
        </div>
        <div id="loadingDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>
    </div>
</div>
</body>
</html>
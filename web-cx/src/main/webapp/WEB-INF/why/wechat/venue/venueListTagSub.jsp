<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp" %>
    <!-- <title>场馆搜索列表</title> -->
    <script type="text/javascript" src="${path}/STATIC/wechat/js/jquery.lazyload.min.js"></script>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>
    <script src="${path}/STATIC/js/avalon.js"></script>
    <script type="text/javascript">
	    var latitude = 22.964305;
		var longitude = 113.116029;
        var startIndex = 0;		//页数
        
      //分享是否隐藏
     	 if(window.injs){
      	
	   		injs.setAppShareButtonStatus(false);
	   	}

        $(function () {
        	
        	var tagName='${tagSub.tagName }';
        	
        	if(window.injs){	//判断是否存在方法
				injs.changeNavTitle(tagName); 
			}else{
				$(document).attr("title",tagName);
			}
            
            //判断是否是微信浏览器打开
            if (is_weixin()&&self == top) {
                //通过config接口注入权限验证配置
                wx.config({
                    debug: false,
                    appId: '${sign.appId}',
                    timestamp: '${sign.timestamp}',
                    nonceStr: '${sign.nonceStr}',
                    signature: '${sign.signature}',
                    jsApiList: ['getLocation', 'onMenuShareAppMessage', 'onMenuShareTimeline', 'onMenuShareQQ', 'onMenuShareWeibo', 'onMenuShareQZone']
                });
                wx.ready(function () {
                	wx.onMenuShareAppMessage({
                        title: "我在“佛山文化云”发现一大波文化空间，快来和我一起参观吧！",
                        desc: '提供公众文化生活和消费的互联网平台，为公众提供便捷和有品质的文化生活服务。',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                    });
                    wx.onMenuShareTimeline({
                        title: "我在“佛山文化云”发现一大波文化空间，快来和我一起参观吧！",
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                    });
                    wx.onMenuShareQQ({
                        title: "我在“佛山文化云”发现一大波文化空间，快来和我一起参观吧！",
                        desc: '提供公众文化生活和消费的互联网平台，为公众提供便捷和有品质的文化生活服务。',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                    });
                    wx.onMenuShareWeibo({
                        title: "我在“佛山文化云”发现一大波文化空间，快来和我一起参观吧！",
                        desc: '提供公众文化生活和消费的互联网平台，为公众提供便捷和有品质的文化生活服务。',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                    });
                    wx.onMenuShareQZone({
                        title: "我在“佛山文化云”发现一大波文化空间，快来和我一起参观吧！",
                        desc: '提供公众文化生活和消费的互联网平台，为公众提供便捷和有品质的文化生活服务。',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                    });
                    wx.getLocation({
                        type: 'gcj02', // 默认为wgs84的gps坐标，如果要返回直接给openLocation用的火星坐标，可传入'gcj02'
                        success: function (res) {
                            latitude = (res.latitude == null || res.latitude == "") ? 0 : res.latitude; // 纬度，浮点数，范围为90 ~ -90
                            longitude = (res.longitude == null || res.longitude == "") ? 0 : res.longitude; // 经度，浮点数，范围为180 ~ -180。
                            
                            main.loadDate(0,10);
                        },
    	    		    fail: function (res){
    	    		    	dialogAlert("系统提示", "获取坐标失败，定位未启用");
    	    		    	main.loadDate(0,10);
    	    		    }
                    });
                });
            } else {
            	if (/wenhuayun/.test(ua)) {		//APP端
            		getAppUserLocation();
            		main.loadDate(0,10);
            	}else if(self != top){		//iframe中
            		latitude = parent.latitude;
                    longitude = parent.longitude;
                    main.loadDate(0,10);
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
                        
                        main.loadDate(0,10);
                    }
                    function handleError(error) {
                    	dialogAlert("系统提示", "获取坐标失败，定位未启用");
                    	main.loadDate(0,10);
                    }
            	}
            }
            
        });

        var main = avalon.define({
            $id: "main",
            count: "",
            active:"",
            venueData: function (data,index,liCount) {
                main.count=data.pageTotal;
                if(data.status==1){
                	if(data.data.length<10){
            			if(data.data.length==0&&index==0){
            				$("#loadingDiv").html("<span class='noLoadingSpan'>没有找到合适的结果，换个试试看吧~</span>");
            			}else{
            				$("#loadingDiv").html("");
            			}
	        		}
                    $.each(data.data, function (i, dom) {
                        var venueIconUrl = getIndexImgUrl(dom.venueIconUrl, "_750_500");
                        /* var venueIsReserveHtml = "";
                        if(dom.venueIsReserve==2){
                            venueIsReserveHtml = "<div class='tab-right'></div>";
                        } */
                        $("#venueList").append("<li onclick=\"toVenueDetail('"+dom.venueId+"')\" id='"+dom.venueId+"'>" +
													"<img class='lazy masking-down' src='${path}/STATIC/wechat/image/placeholder.png' data-original=\'" + venueIconUrl + "\'/>" +
													"<div class='whySpace'>" +
														"<div class='whySpace-tag'>" +
															"<div class='whySpace-title'><p>"+dom.venueName+"</p></div>" +
															"<div class='whySpace-place'>" +
																"<p>" +
																	"<img style='display: inline-block;vertical-align: middle;margin-right: 10px;' src='${path}/STATIC/wechat/image/icon_space.png'/>" +
																	"<span>"+dom.venueAddress+"</span>" +
																"</p>" +
															"</div>" +
															"<div class='whySpace-TL'><ul></ul></div>" +
														"</div>" +
													"</div>" +
												"</li>");
                        main.loadCountInfo(dom.venueId);
                    });
                    
                  	//图片懒加载
        			$(".active ul li:gt("+liCount+") img.lazy,.active ul li:eq("+liCount+") img.lazy").lazyload({
	        		    effect : "fadeIn",
	        		    effectspeed : 1000
	        		});
                }
            },
            showActivity: function (venueId) {
                toVenueDetail(venueId);
            },
            loadDate: function (index,pagesize) {
            	//图片懒加载开始位置
            	var liCount = $(".active ul li").length;
            	var tagSubId=$("#tagSubId").val();
                $.post("${path}/wechatVenue/wcVenueList.do", {
                    tagSubId:tagSubId,
                    appType: 1,
                    Lon: longitude,
                    Lat: latitude,
                    pageIndex: index,
                    pageNum: pagesize
                }, function (data) {
                    main.venueData(data,index,liCount);
                }, "json");
            },
            loadCountInfo: function (venueId){
    			var countHtml = "";
    			$.post("${path}/wechatVenue/wcVenueCountInfo.do",{venueId:venueId}, function (countData) {
    				if(countData.status==1){
    					if(countData.data.actCount>0){
        					countHtml += "<li><p><span>"+countData.data.actCount+"</span>个在线活动</p></li>"
        				}
        				if(countData.data.roomCount>0){
        					countHtml += "<li><p><span>"+countData.data.roomCount+"</span>个活动室</p></li>"
        				}
        				$("#venueList li").each(function() {
    						if ($(this).attr("id")==venueId) {
    							$(this).find(".whySpace-TL ul").html(countHtml);
    						}
    					})
    				}
                }, "json");
    		}
        });
      
        if(browser.versions.ios){	//IOS端(在iframe里不识别scroll)
       		$(document).on("touchend",function(){
       			startIndex += 10;
            	var index = startIndex;
            	setTimeout(function () { 
            		main.loadDate(index,10);
            	},1000);
           	})
        }else{
        	$(window).on("scroll", function () {
            	//滑屏分页
                var scrollTop = $(document).scrollTop();
                var pageHeight = $(document).height();
                var winHeight = $(window).height();
                if (scrollTop >= (pageHeight - winHeight - 10)) {
                	startIndex += 10;
               		var index = startIndex;
               		setTimeout(function () { 
               			main.loadDate(index,10);
               		},1000);
                }
                
              	//回到顶部按钮显示
    			var screenheight = $(window).height() * 2
    			if ($(document).scrollTop() > screenheight) {
    				$(".totop").show()
    			} else {
    				$(".totop").hide()
    			}
            });
        }
    </script>
    
    <style>
    	html,body,.main{height:100%}
    </style>
</head>
<body class="body">
<div class="main" ms-controller="main">
    <div class="content padding-bottom0">
        <div class="active">
           <input type="hidden" name="tagSubId" id="tagSubId" value="${tagSub.tagSubId }"/>
            <ul id="venueList"></ul>
        </div>
        <div id="loadingDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>
    </div>
    <div class="footer" style="background-color: transparent;bottom: 40px;border:none;">
		<div class="totop" onclick="$('html,body').animate({scrollTop: 0}, 1000);"><img class="menuBtnShadow" src="${path}/STATIC/wechat/image/newmenu/top.png" /></div>
	</div>
</div>
</body>
</html>
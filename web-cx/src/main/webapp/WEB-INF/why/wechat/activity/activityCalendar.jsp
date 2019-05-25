<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta charset="utf-8"/>
	<title>文化日历</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<script type="text/javascript" src="${path}/STATIC/wechat/js/jquery.lazyload.min.js"></script>
	<%-- <script type="text/javascript" src="${path}/STATIC/wechat/js/date_3.6.js"></script> --%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/hsStyle.css"/>

	<script type="text/javascript">
        $.ajaxSettings.async = false; 	//同步执行ajax
        var startIndex = 0;		//页数
        var latitude = 39.082548;
        var longitude = 117.325275;
        var selectDate = sessionStorage.getItem("selectDate");	//选择日期
        var calendarId = sessionStorage.getItem("calendarId");	//活动ID
        var activityType = sessionStorage.getItem("activityType");	//活动类型(0:附近)
        var tabType = 1;	//2：我的日历（月）3：我的日历（已结束）
        var selectStartDate = '';		//我的活动用
        var selectEndDate = '';	//我的活动用

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
                        title: "我找到了一份佛山精彩文化活动日历-文化云",
                        desc: '提供公众文化生活和消费的互联网平台，为公众提供便捷和有品质的文化生活服务。',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
                        link: '${basePath}wechatActivity/preActivityCalendar.do'
                    });
                    wx.onMenuShareTimeline({
                        title: "我找到了一份佛山精彩文化活动日历-文化云",
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
                        link: '${basePath}wechatActivity/preActivityCalendar.do'
                    });
                    wx.onMenuShareQQ({
                        title: "我找到了一份佛山精彩文化活动日历-文化云",
                        desc: '提供公众文化生活和消费的互联网平台，为公众提供便捷和有品质的文化生活服务。',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                    });
                    wx.onMenuShareWeibo({
                        title: "我找到了一份佛山精彩文化活动日历-文化云",
                        desc: '提供公众文化生活和消费的互联网平台，为公众提供便捷和有品质的文化生活服务。',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                    });
                    wx.onMenuShareQZone({
                        title: "我找到了一份佛山精彩文化活动日历-文化云",
                        desc: '提供公众文化生活和消费的互联网平台，为公众提供便捷和有品质的文化生活服务。',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                    });
                    wx.getLocation({
                        type: 'wgs84', // 默认为wgs84的gps坐标，如果要返回直接给openLocation用的火星坐标，可传入'gcj02'
                        success: function (res) {
                            latitude = (res.latitude==null||res.latitude=="")?0:res.latitude; // 纬度，浮点数，范围为90 ~ -90
                            longitude = (res.longitude==null||res.longitude=="")?0:res.longitude; // 经度，浮点数，范围为180 ~ -180。

                            //如果有需要预加载到的活动
                            if(calendarId!=null){
                                findDataById();
                            }else{
                                loadData(0, 20);
                            }
                        },
                        fail: function (res){
                            dialogAlert("系统提示", "获取坐标失败，定位未启用");
                            //如果有需要预加载到的活动
                            if(calendarId!=null){
                                findDataById();
                            }else{
                                loadData(0, 20);
                            }
                        }
                    });
                });
            } else {
                if (/wenhuayun/.test(ua)) {		//APP端
                    getAppUserLocation();
                    //如果有需要预加载到的活动
                    if(calendarId!=null){
                        findDataById();
                    }else{
                        loadData(0, 20);
                    }
                }else{
                    if (window.navigator.geolocation) {
                        var options = {
                            enableHighAccuracy: true,
                        };
                        window.navigator.geolocation.getCurrentPosition(handleSuccess, handleError, options);
                    } else {
                        dialogAlert("系统提示", "浏览器不支持html5来获取地理位置信息");
                    }

                    function handleSuccess(position){
                        longitude = position.coords.longitude;
                        latitude = position.coords.latitude;
                        //如果有需要预加载到的活动
                        if(calendarId!=null){
                            findDataById();
                        }else{
                            loadData(0, 20);
                        }
                    }
                    function handleError(error){
                        dialogAlert("系统提示", "获取坐标失败，定位未启用");
                        //如果有需要预加载到的活动
                        if(calendarId!=null){
                            findDataById();
                        }else{
                            loadData(0, 20);
                        }
                    }
                }
            }

            //广告位加载
            loadAdvert();
            //标签加载
            loadTag();

            //我的活动月份加载
            loadFiveMonth();

            //去除loading页面
            if($(".bgWhite").attr("display","block")){
                if($("#"+calendarId).offset()){
                    $("html,body").animate({scrollTop:$("#"+calendarId).offset().top-100},1000,function(){
                        $(".bgWhite").fadeOut();
                    });
                }else{
                    $(".bgWhite").fadeOut();
                }
            }

            //我的日历
            $("#dateChange").click(function(){
                if($(this).hasClass("nowChange")){
                    $(this).removeClass("nowChange");
                    $(this).text("我的日历");
                    $("#whyDate").show();
                    $("#myDate").hide();
                    tabType = 1;
                }else{
                    if (userId == null || userId == '') {
                        window.location.href = '${path}/muser/login.do?type=${basePath}wechatActivity/preActivityCalendar.do';
                        return;
                    }
                    $(this).addClass("nowChange");
                    $(this).text("返回");
                    $("#whyDate").hide();
                    $("#myDate").show();
                    tabType = 2;
                }

                reloadHtml();
            })

            //分享
            $(".index-top-6").click(function() {
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
            $(".index-top-7").on("touchstart", function() {
                $('.div-share').show()
                $("body,html").addClass("bg-notouch")
            })

            //底部菜单
            if (!browser.versions.android) {		//非安卓(安卓不识别touchend)
                $(document).on("touchmove", function() {
                    $(".footer").hide()
                }).on("touchend", function() {
                    $(".footer").show()
                })
            }
            $(".newMenuBTN").click(function() {
                $(".newMenuList").animate({
                    "bottom": "0px"
                })
            })
            $(".newMenuCloseBTN>img").click(function() {
                var height = $(".newMenuList").width();
                $(".newMenuList").animate({
                    "bottom": "-"+height+"px"
                })
            })
            //回到顶部按钮显示
            $(window).scroll(function() {
                var screenheight = $(window).height() * 2
                if ($(document).scrollTop() > screenheight) {
                    $(".totop").show()
                } else {
                    $(".totop").hide()
                }
            })
        });

        //加载广告位
        function loadAdvert(){
            if(!selectDate){
                var date = new Date();
                formatDate(date);
            }
            $.post("${path}/wechatActivity/queryCalendarAdvert.do", {date:selectDate}, function (data) {
                if(data.status==200){
                    var dom = data.data;
                    var advImgUrl = getIndexImgUrl(dom.advImgUrl, "_750_380");
                    if(dom.advLink==1){	//外链
                        $("#calendarAdvert").html("<img src='"+advImgUrl+"' height='380' width='750' onclick='preOutUrl(\"" + dom.advUrl + "\");'></img>");
                    }else{	//内链
                        if(dom.advLinkType==0){	//活动列表
                            $("#calendarAdvert").html("<img src='"+advImgUrl+"' height='380' width='750' onclick='preInActList(\"" + dom.advUrl + "\");'/>");
                        }else if(dom.advLinkType==1){	//活动详情
                            $("#calendarAdvert").html("<img src='"+advImgUrl+"' height='380' width='750' onclick='preInActDetail(\"" + dom.advUrl + "\");'/>");
                        }else if(dom.advLinkType==2){	//场馆列表
                            $("#calendarAdvert").html("<img src='"+advImgUrl+"' height='380' width='750' onclick='preInVenList(\"" + dom.advUrl + "\");'/>");
                        }else if(dom.advLinkType==3){	//场馆详情
                            $("#calendarAdvert").html("<img src='"+advImgUrl+"' height='380' width='750' onclick='preInVenDetail(\"" + dom.advUrl + "\");'/>");
                        }
                    }
                }else{
                    $("#calendarAdvert").html("");
                }
            }, "json");
        }

        //跳外链
        function preOutUrl(url){ window.location.href = url; };
        //跳活动列表
        function preInActList(name){ window.location.href = '${path}/wechatActivity/preActivityList.do?activityName='+name; };
        //跳活动详情
        function preInActDetail(id){ window.location.href = '${path}/wechatActivity/preActivityDetail.do?activityId='+id; };
        //跳场馆列表
        function preInVenList(name){ window.location.href = '${path}/wechatVenue/preVenueList.do?venueName='+name; };
        //跳场馆详情
        function preInVenDetail(id){ window.location.href = '${path}/wechatVenue/venueDetailIndex.do?venueId='+id; };

        //加载活动列表
        function loadData(index, pagesize) {
            if(index==0){
                $("#index_list").html("");
            }
            //图片懒加载开始位置
            var liCount = $("#index_list li").length;
            if(tabType==1){		//文化日历
                if(!selectDate){
                    var date = new Date();
                    formatDate(date);
                }
                var data = {
                    userId: userId,
                    selectDate: selectDate,
                    activityType: activityType,
                    pageIndex: index,
                    pageNum: pagesize,
                    lat:latitude,
                    lon:longitude
                };
                $.post("${path}/wechatActivity/wcCultureCalendarList.do", data, function (data) {
                    if(data.status==200){
                        if(data.data.length<20){
                            if(data.data.length==0&&index==0){
                                $("#loadingDiv").html("<span class='noLoadingSpan'>没有找到合适的结果，换个试试看吧~</span>");
                            }else{
                                $("#loadingDiv").html("");
                            }
                        }
                        $.each(data.data, function (i, dom) {
                            if(dom.type == 1){	//体系内活动
                                var time = dom.activityStartTime.substring(5,10).replace("-",".");
                                if(dom.activityEndTime.length>0&&dom.activityStartTime!=dom.activityEndTime){
                                    time += "-"+dom.activityEndTime.substring(5,10).replace("-",".");
                                }
                                var activityIconUrl = getIndexImgUrl(dom.activityIconUrl, "_750_500");
                                var collectHtml = "";
                                if (dom.activityIsCollect == 1) {	//收藏
                                    collectHtml = "<div class='tab-p15'><img src='${path}/STATIC/wechat/image/star-on.png' onclick='collectBut($(this),\""+dom.activityId+"\",2)'/></div>"
                                }else{
                                    collectHtml = "<div class='tab-p15'><img src='${path}/STATIC/wechat/image/star.png' onclick='collectBut($(this),\""+dom.activityId+"\",2)'/></div>"
                                }
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
                                $("#index_list").append("<li activityId=" + dom.activityId + ">" +
                                    "<div class='activeList'>" +
                                    "<img class='lazy' src='${path}/STATIC/wechat/image/placeholder.png' data-original='" + activityIconUrl + "' width='750' height='475' onclick='showActivity(\"" + dom.activityId + "\","+dom.type+")'/>" +
                                    collectHtml + isReservationHtml + tagHtml + price +
                                    "</div>" +
                                    "<p class='activeTitle'>"+dom.activityName+"</p>" +
                                    "<p class='activePT'>"+time+" | "+dom.activityLocationName+"</p>" +
                                    "</li>");
                            }else if(dom.type == 2){	//采集活动
                                loadGather(dom);
                            }
                        });

                        //图片懒加载
                        $("#index_list li:gt("+liCount+") img.lazy,#index_list li:eq("+liCount+") img.lazy").lazyload({
                            effect : "fadeIn",
                            effectspeed : 1000
                        });
                    }
                }, "json");
            }else if(tabType==2){		//我的活动
                var data = {
                    userId: userId,
                    startDate: selectStartDate,
                    endDate: selectEndDate,
                    pageIndex: index,
                    pageNum: pagesize
                };
                $.post("${path}/wechatActivity/wcMyCultureCalendarList.do", data, function (data) {
                    if(data.status==200){
                        if(data.data.length<20){
                            if(data.data.length==0&&index==0){
                                $("#loadingDiv").html("<span class='noLoadingSpan'>没有找到合适的结果，换个试试看吧~</span>");
                            }else{
                                $("#loadingDiv").html("");
                            }
                        }
                        $.each(data.data, function (i, dom) {
                            if(dom.type == 1){	//体系内活动
                                var activityIconUrl = getIndexImgUrl(dom.activityIconUrl, "_750_500");
                                var time = "";
                                if(dom.activityIsReserved==1){
                                    time = "<div class='tab-p14'><p>已预订|"+dom.eventDateTime+"</p></div>"
                                }else if(dom.activityIsReserved==3){
                                    time = "<div class='tab-p14'><p>直接前往|"+dom.eventDateTime+"</p></div>"
                                }else{
                                    time = "<div class='tab-p14'><p>未预订|"+dom.eventDateTime+"</p></div>"
                                }
                                var collectHtml = "";
                                if(dom.orderOrCollect==2){
                                    if (dom.activityIsCollect == 1) {	//收藏
                                        collectHtml = "<div class='tab-p15' activityId="+dom.activityId+"><img src='${path}/STATIC/wechat/image/star-on.png' onclick='collectBut($(this),\""+dom.activityId+"\",2)'/></div>"
                                    }else{
                                        collectHtml = "<div class='tab-p15' activityId="+dom.activityId+"><img src='${path}/STATIC/wechat/image/star.png' onclick='collectBut($(this),\""+dom.activityId+"\",2)'/></div>"
                                    }
                                }
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
                                $("#index_list").append("<li activityId=" + dom.activityId + ">" +
                                    "<div class='activeList'>" +
                                    "<img class='lazy' src='${path}/STATIC/wechat/image/placeholder.png' data-original='" + activityIconUrl + "' width='750' height='475' onclick='showActivity(\"" + dom.activityId + "\","+dom.type+")'/>" +
                                    time + collectHtml + tagHtml + price +
                                    "</div>" +
                                    "<p class='activeTitle'>"+dom.activityName+"</p>" +
                                    "<p class='activePT'>"+dom.activityLocationName+"</p>" +
                                    "</li>");
                            }else if(dom.type == 2){	//采集活动
                                loadGather(dom);
                            }
                        });

                        //图片懒加载
                        $("#index_list li:gt("+liCount+") img.lazy,#index_list li:eq("+liCount+") img.lazy").lazyload({
                            effect : "fadeIn",
                            effectspeed : 1000
                        });
                    }
                }, "json");
            }else if(tabType==3){		//已参加活动
                var data = {
                    userId: userId,
                    pageIndex: index,
                    pageNum: pagesize
                };
                $.post("${path}/wechatActivity/wcHistoryActivityList.do", data, function (data) {
                    if(data.status==100){
                        if(data.data.length<20){
                            if(data.data.length==0&&index==0){
                                $("#loadingDiv").html("<span class='noLoadingSpan'>没有找到合适的结果，换个试试看吧~</span>");
                            }else{
                                $("#loadingDiv").html("");
                            }
                        }
                        $.each(data.data, function (i, dom) {
                            var activityIconUrl = getIndexImgUrl(dom.activityIconUrl, "_750_500");
                            var time = "";
                            if(dom.activityIsReserved==1){
                                time = "<div class='tab-p14'><p>已预订|"+dom.eventDateTime+"</p></div>"
                            }else{
                                time = "<div class='tab-p14'><p>未预订|"+dom.eventDateTime+"</p></div>"
                            }
                            var collectHtml = "";
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
                            $("#index_list").append("<li activityId=" + dom.activityId + ">" +
                                "<div class='activeList'>" +
                                "<img class='lazy' src='${path}/STATIC/wechat/image/placeholder.png' data-original='" + activityIconUrl + "' width='750' height='475' onclick='showActivity(\"" + dom.activityId + "\","+dom.type+")'/>" +
                                time + tagHtml + price +
                                "</div>" +
                                "<p class='activeTitle'>"+dom.activityName+"</p>" +
                                "<p class='activePT'>"+dom.activityLocationName+"</p>" +
                                "</li>");
                        });

                        //图片懒加载
                        $("#index_list li:gt("+liCount+") img.lazy,#index_list li:eq("+liCount+") img.lazy").lazyload({
                            effect : "fadeIn",
                            effectspeed : 1000
                        });
                    }
                    if(data.status==200){
                        window.location.href = '${path}/muser/login.do?type=${basePath}wechatActivity/preActivityCalendar.do';
                        return;
                    }
                }, "json");
            }
        }

        //加载采集活动
        function loadGather(dom){
            var time = dom.gatherStartDate.substring(5,10).replace("-",".");
            if(dom.gatherEndDate.length>0&&dom.gatherStartDate!=dom.gatherEndDate){
                time += "-"+dom.gatherEndDate.substring(5,10).replace("-",".");
            }
            var gatherImgHtml = "";
            var divStyle = "";
            if(dom.gatherImg){
                var gatherImg = getIndexImgUrl(getImgUrl(dom.gatherImg), "_750_500");
                gatherImgHtml = "<img class='masking-down lazy' src='${path}/STATIC/wechat/image/placeholder.png' data-original='"+gatherImg+"'/>";
            }else{
                divStyle = "border-bottom: 1px solid #e2e2e2;";
            }
            var collectHtml = "";
            if (dom.collectNum > 0) {	//收藏
                collectHtml = "<div class='tab-p15'><img src='${path}/STATIC/wechat/image/star-on.png' onclick='collectBut($(this),\""+dom.gatherId+"\",6)'/></div>"
            }else{
                collectHtml = "<div class='tab-p15'><img src='${path}/STATIC/wechat/image/star.png' onclick='collectBut($(this),\""+dom.gatherId+"\",6)'/></div>"
            }
            var gatherType = "";
            var typeClass = "";
            if(dom.gatherType == 0){
                gatherType = "热映影片";
                typeClass = "dateReyingyingpianTag";
            }else if(dom.gatherType == 1){
                gatherType = "舞台演出";
                typeClass = "dateWutaiyanchuTag";
            }else if(dom.gatherType == 2){
                gatherType = "美术展览";
                typeClass = "dateMeishuzhanlanTag";
            }else if(dom.gatherType == 3){
                gatherType = "音乐会";
                typeClass = "dateYinyuehuiTag";
            }else if(dom.gatherType == 4){
                gatherType = "演唱会";
                typeClass = "dateYanchanghuiTag";
            }else if(dom.gatherType == 5){
                gatherType = "舞蹈";
                typeClass = "dateWudaoTag";
            }else if(dom.gatherType == 6){
                gatherType = "话剧歌剧";
                typeClass = "dateHuajugejuTag";
            }else if(dom.gatherType == 7){
                gatherType = "戏曲曲艺";
                typeClass = "dateXiququyiTag";
            }else if(dom.gatherType == 8){
                gatherType = "儿童剧";
                typeClass = "dateErtongjuTag";
            }else if(dom.gatherType == 9){
                gatherType = "杂技魔术";
                typeClass = "dateZajimoshuTag";
            }
            $("#index_list").append("<li activityId="+dom.gatherId+" onclick='showActivity(\"" + dom.gatherId + "\","+dom.type+"," + dom.gatherLink + ")'>" +
                "<div class='activeList'>" +
                gatherImgHtml + collectHtml +
                "</div>" +
                "<div class='iconList"+(dom.gatherType==0?"2":"1")+"' style='padding: 20px 15px 0;'>" +
                "<div class='clearfix' style='"+divStyle+";padding-bottom: 20px;'>" +
                "<p class='"+typeClass+"'>"+gatherType+"</p>" +
                "<p class='dateTagTitle'>"+dom.gatherName+"</p>" +
                "</div>" +
                "<div>" +
                "<ul>" +
                "<li class='clearfix'>" +
                "<div class='dateIcon1 dateIcon'></div><p class='dateList'>"+(dom.gatherType==0?dom.gatherMovieType:dom.gatherAddress)+"</p>" +
                "</li>" +
                "<li class='clearfix'>" +
                "<div class='dateIcon2 dateIcon'></div><p class='dateList'>"+(dom.gatherType==0?dom.gatherMovieTime:dom.gatherHost)+"</p>" +
                "</li>" +
                "<li class='clearfix'>" +
                "<div class='dateIcon3 dateIcon'></div><p class='dateList'>"+(dom.gatherType==0?dom.gatherMovieActor:(time+"&nbsp;"+dom.gatherTime))+"</p>" +
                "</li>" +
                "<li class='clearfix'>" +
                "<div class='dateIcon4 dateIcon'></div><p class='dateList'>"+(dom.gatherType==0?dom.gatherMovieDirector:dom.gatherPrice)+"</p>" +
                "</li>" +
                "</ul>" +
                "</div>" +
                "</div>" +
                "</li>");
        }

        function showActivity(calendarId,type,gatherLink) {
            sessionStorage.setItem("calendarId", calendarId);	//界面位置缓存
            if(type == 1){
                window.location.href = "${path}/wechatActivity/preActivityDetail.do?activityId=" + calendarId;
            }else if(type == 2 && gatherLink){
                window.location.href = gatherLink;
            }
        }

        //判断是否存在预加载Id
        function findDataById() {
            if(!selectDate){
                var date = new Date();
                formatDate(date);
            }
            var data = {
                userId: userId,
                selectDate: selectDate,
                activityType: activityType,
                lat:latitude,
                lon:longitude
            };
            $.post("${path}/wechatActivity/wcCultureCalendarList.do", data, function (data) {
                if(data.status==200){
                    var num = 20;
                    $.each(data.data, function (i, dom) {
                        if(dom.activityId == calendarId){
                            num = Math.ceil((i+1)/20)*20;
                            startIndex = (Math.ceil((i+1)/20)-1)*20;
                        }
                    });
                    loadData(0, num);
                }
            }, "json");
        }

        //活动标签
        function loadTag() {
            $.ajax({type:'POST', url:"${path}/wechatActivity/wcActivityTagList.do",data:{userId: userId},dataType: "json",async: false,
                success: function (data) {
                    if (data.status == 0) {
                        $.each(data.data, function (i, dom) {
                            $("#tagList").append("<li data-option='" + dom.tagId + "');\">"+dom.tagName+"</li>");
                        });

                        var ul_width = 80;	//防止个别手机宽度计算不足，默认+80
                        $(".dateMenuList li").each(function() {
                            ul_width += $(this).outerWidth()
                        })
                        $(".dateMenuList ul").css("width", ul_width)

                        //初始化
                        $(".dateMenuList li").each(function(){
                            if(activityType){
                                if($(this).attr("data-option") == activityType){
                                    $(this).addClass("border-bottom2");
                                    $(this).addClass("font-cb");
                                }
                            }else{
                                $(".dateMenuList li").eq(0).addClass("border-bottom2");
                                $(".dateMenuList li").eq(0).addClass("font-cb");
                            }
                        })
                        $(".dateMenuList").animate({scrollLeft:$(".dateMenuList li.border-bottom2").offset().left-325},1000);

                        $(".dateMenuList li").click(function() {
                            sessionStorage.setItem("activityType", $(this).attr("data-option"));	//界面位置缓存
                            activityType = $(this).attr("data-option");
                            //重新加载页面
                            reloadHtml();
                            $(".dateMenuList li").removeClass("border-bottom2");
                            $(".dateMenuList li").removeClass("font-cb");
                            $(this).addClass("border-bottom2");
                            $(this).addClass("font-cb");
                        })
                    }
                }
            });
        };

        //加载月份（我的活动）
        function loadFiveMonth(){
            var d = new Date().getDate();
            var m = new Date().getMonth() + 1;
            var y = new Date().getFullYear();
            if (d < 10) {
                d = "0" + d;
            }
            for(var i=0;i<5;i++){
                if(m>12){
                    var day = new Date(y+1,m-12,0);
                    var m2 = m;
                    if((m2-12)<10){
                        m2 = "0" + (m2-12);
                    }
                    if(i==0){
                        $("#monthUl").append("<li><a class='border-bottom2 font-cb' s='"+(y+1)+"-"+m2+"-"+d+"' e='"+(y+1)+"-"+m2+"-"+day.getDate()+"'>"+(m-12)+"月</a></li>");
                    }else{
                        $("#monthUl").append("<li><a s='"+(y+1)+"-"+m2+"-01' e='"+(y+1)+"-"+m2+"-"+day.getDate()+"'>"+(m-12)+"月</a></li>");
                    }
                }else{
                    var day = new Date(y,m,0);
                    var m2 = m;
                    if(m2<10){
                        m2 = "0" + m2;
                    }
                    if(i==0){
                        $("#monthUl").append("<li><a class='border-bottom2 font-cb' s='"+y+"-"+m2+"-"+d+"' e='"+y+"-"+m2+"-"+day.getDate()+"'>"+m+"月</a></li>");
                    }else{
                        $("#monthUl").append("<li><a s='"+y+"-"+m2+"-01' e='"+y+"-"+m2+"-"+day.getDate()+"'>"+m+"月</a></li>");
                    }
                }
                m++;
            }

            //默认第一个月参数
            selectStartDate = $("#monthUl li:eq(0) a").attr("s");
            selectEndDate = $("#monthUl li:eq(0) a").attr("e");

            //我的活动切换
            $(".sp-p1 li a,.month-more a").click(function(){
                $(".sp-p1 li a,.month-more a").removeClass("border-bottom2");
                $(".sp-p1 li a,.month-more a").removeClass("font-cb");
                $(this).addClass("border-bottom2");
                $(this).addClass("font-cb");
            });
            //点击月份
            $("#monthUl li a").on("click", function () {
                selectStartDate = $(this).attr("s");	//开始日期
                selectEndDate = $(this).attr("e");	//结束日期
                tabType = 2;
                reloadHtml();	//重新加载列表
            });
            //已参加
            $(".month-more a").click(function(){
                tabType = 3;
                reloadHtml();	//重新加载列表
            })
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
                    loadData(index, 20);
                },200);
            }
        });

        //时间格式转换
        function formatDate(date){
            selectDate = date.getFullYear() + "-";
            var m = date.getMonth() + 1;
            selectDate += m<10?"0"+m:m;
            selectDate += "-";
            selectDate += date.getDate()<10?"0"+date.getDate():date.getDate();
        }

        //重新加载列表
        function reloadHtml(){
            startIndex = 0;		//重置分页
            //重置加载中
            $("#loadingDiv").html("<img class='loadingImg' src='${path}/STATIC/wechat/image/loading.gif'/><span class='loadingSpan'>加载中。。。</span><div style='clear:both'></div>");
            //如果有需要预加载到的活动
            if(tabType == 1){
                if(calendarId!=null){
                    findDataById();
                }else{
                    loadData(0, 20);
                }
            }else{
                loadData(0, 20);
            }
        }

        //收藏
        function collectBut($thisImg,id,type){
            sessionStorage.setItem("calendarId", id);	//界面位置缓存

            if (userId == null || userId == '') {
                window.location.href = '${path}/muser/login.do?type=${basePath}wechatActivity/preActivityCalendar.do';
                return;
            }
            if ($thisImg.attr("src")=="${path}/STATIC/wechat/image/star-on.png") {
                $.post("${path}/wechat/wcDelCollect.do", {
                    relateId: id,
                    userId: userId,
                    type: type
                }, function (data) {
                    if (data.status == 0) {
                        $thisImg.attr("src","${path}/STATIC/wechat/image/star.png");
                        dialogAlert("收藏提示", "已取消收藏");
                        if(tabType==2){
                            $thisImg.parents("li").remove();		//如果在我的活动界面，则同时清除该活动
                        }
                    }
                }, "json");
            } else {
                $.post("${path}/wechat/wcCollect.do", {
                    relateId: id,
                    userId: userId,
                    type: type
                }, function (data) {
                    if (data.status == 0) {
                        $thisImg.attr("src","${path}/STATIC/wechat/image/star-on.png");
                        dialogAlert("收藏成功", "已成功添加到我的文化日历");
                    }
                }, "json");
            }
        }

	</script>

	<style>
		html,
		body,
		.main {
			height: 100%;
			background-color: #f3f3f3
		}

		.content {
			padding-top: 100px;
			padding-bottom: 0;
		}

		.activeUl>li {
			background-color: #fff;
			padding-bottom: 30px;
		}

		.myDate {
			border: 1px solid #fff;
			background-color: #7179a0;
			border-radius: 10px;
			padding: 5px 10px;
			position: absolute;
			text-align: center;
			font-size: 26px;
			color: #fff;
			left: 20px;
			top: 26px;
			width: 112px;
		}

		.dlData{
			padding: 20px 0;
			background-color: #fff;
			margin-bottom: 10px;
		}

		.dlData .week{
			padding-bottom: 10px;
			margin-bottom: 10px;
			border-bottom: 1px solid #ccc;
		}

		.dlData .week li{
			float: left;
			width: 107px;
			text-align: center;
			font-size: 30px;
			color: #262626;
		}

		.dlData .day li{
			float: left;
			width: 107px;
			text-align: center;
			font-size: 30px;
			color: #262626;
		}

		.dlData .day li div{
			border: 1px solid #fff;
			border-radius: 50px;
			line-height: 50px;
			width: 50px;
			height: 50px;
			margin: auto;
		}

		.dlData .day li div.old{
			color: #C6C6C6;
		}

		.dlData .day li div.now{
			border: 1px solid #ff9900;
		}

		.dlData .day li.on div{
			border: 1px solid #56a7d9;
			background-color: #56a7d9;
			color: #fff;
		}

		.header{
			position: static;
		}

		.content{
			padding-top: 0;
		}

		.dateMenuListBotm{
			margin-top: 0;
		}


	</style>
</head>
<body>
<div class="main">
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
	<div class="header">
		<div class="index-top">
			<div class="myDate" id="dateChange">我的日历</div>
			<span class="index-top-2">
					<span id="nowYear"></span>.
				<span id="nowMon"></span>
				</span>
			<span class="index-top-6">
					<img src="${path}/STATIC/wechat/image/share2.png" />
				</span>
		</div>
	</div>
	<div class="content padding-bottom0">
		<div class="bgWhite">
			<p>海量活动正在努力加载中，请不要刷新页面...<br/>把活动收藏进入“我的日历”，加快浏览速度喔！</p>
		</div>
		<div id="whyDate">
			<div class="dlData">
				<ul class="week clearfix">
					<li>日</li>
					<li>一</li>
					<li>二</li>
					<li>三</li>
					<li>四</li>
					<li>五</li>
					<li>六</li>
				</ul>
				<ul class="day clearfix">


				</ul>
			</div>
			<div style="width: 750px;height: 100px;background-color: #fff;">
				<div class="dateMenuListBotm">
					<div class="dateMenuList">
						<ul class="clearfix" id="tagList">
							<li data-option="">全部</li>
							<li data-option="0">附近</li>
						</ul>
					</div>
				</div>
			</div>
		</div>
		<div id="myDate" style="display: none;">
			<div class="sp" style="background-color: #fff;">
				<div class="sp-p1">
					<ul id="monthUl"></ul>
				</div>
				<div class="month-more">
					<div class="month-more-bg"></div>
					<a>已参加</a>
				</div>
				<div style="clear: both;"></div>
			</div>
		</div>
		<div id="calendarAdvert"></div>
		<div class="active">
			<ul id="index_list" class="activeUl"></ul>
		</div>
		<div id="loadingDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>
	</div>
	<%@include file="/WEB-INF/why/wechat/footerMenuList.jsp" %>
</div>

<script>
    var today = "${today}";
    //获取第一天
    function firstDay(date){
        //1.根据年度和月份，创建日期
        var d = new Date(date);
        d.setDate(1);
        //获得周几
        var weeks = [0,1,2,3,4,5,6];

        return weeks[d.getDay()];
    }

    //获取最后一天
    function lastDay(date){
        var nowMon = new Date(date);
        var curMonthDays = new Date(nowMon.getFullYear(), (nowMon.getMonth() + 1), 0).getDate();
        return curMonthDays;
    }

    //初始化日历
    function dlDate(date){
        var _dlDate = date.split('-')[2];
        $('#nowYear').html(date.split('-')[0]);
        $('#nowMon').html(date.split('-')[1]);
        for(var i = 0; i < firstDay(date); i++){
            $(".dlData .day").append("<li><div></div></li>")
        }
        for(var i = 1; i <= lastDay(date); i++){
            if(i < _dlDate){
                $(".dlData .day").append("<li onclick='changeDate("+i+")'><div class='old'>" + i + "</div></li>")
            }else if(i == _dlDate){
                $(".dlData .day").append("<li onclick='changeDate("+i+")'><div class='now'>" + i + "</div></li>")
            }else{
                $(".dlData .day").append("<li onclick='changeDate("+i+")'><div>" + i + "</div></li>")
            }
        }
    }
    function changeDate(day){
        var tempDay = today.substring(0,8);
        if (day < 10){
            tempDay += "0"+day;
        } else {
            tempDay += day;
        }
        sessionStorage.setItem("selectDate", tempDay);	//界面位置缓存
        selectDate = tempDay;
        //重新加载页面
        reloadHtml();
    }

    $(function(){
        dlDate(today);
        $(".dlData .day li").on("click",function(){
            $(".dlData .day li").removeClass("on");
            $(this).addClass("on");
        })

        var _scroll = $(".dlData")[0].clientHeight + $(".header")[0].clientHeight;
        $(document).on("touchmove scroll",function(){
            if($(document).scrollTop() > _scroll){
                $(".dateMenuListBotm").css({
                    "position":"fixed",
                    "left":"0px",
                    "right":"0px",
                    "top":"0px",
                    "margin":"auto",
                    "z-index":"10"
                });
            }else{
                $(".dateMenuListBotm").css("position","static");
            }
        });
    })
</script>
</body>
</html>
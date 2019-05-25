<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
    <!-- <title>近期活动</title> -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wx/css/reset-mc.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wx/css/mc-mobile.css"/>
    <script type="text/javascript" src="${path}/STATIC/wx/js/mc-mobile.js"></script>
    <script type="text/javascript" src="${path}/STATIC/wechat/js/swipe.js"></script>

    <script type="text/javascript">
	    var latitude = 22.964305;
		var longitude = 113.116029;
        var pageSize = 0, startIndex = 0, isScroll = true;
        //微信公众号菜单控制参数
        var wxEvent = '${wxEvent}';

        $(function () {
        	//微信公众号菜单控制
        	if(wxEvent>0){
        		//禁用标签选择
        		$("#title2").css("background","none");
        		$("#title2").unbind( "click" );
        		if(wxEvent==1){
            		$(document).attr("title","闲趣|展览");
            		$("#title2").html("展览");
            		$("#Regional_val").val("526091b990c3494d91275f75726c064f");
            	}else if(wxEvent==2){
            		$(document).attr("title","闲趣|退休");
            		$("#title2").html("退休");
            		$("#Regional_val").val("08f237211b6e4ccfaf14692ff2cc21b2");
            	}else if(wxEvent==3){
            		$(document).attr("title","闲趣|运动");
            		$("#title2").html("运动");
            		$("#Regional_val").val("f01dcacc0bac4e53a6e04adbfa5abb30");
            	}else if(wxEvent==4){
            		$(document).attr("title","闲趣|养生");
            		$("#title2").html("养生");
            		$("#Regional_val").val("ca445e078a22490680980b50300b5438");
            	}else if(wxEvent==5){
            		$(document).attr("title","闲趣|DIY");
            		$("#title2").html("DIY");
            		$("#Regional_val").val("75ee8a017c444903872c59d954644eac");
            	}else if(wxEvent==6){
            		$(document).attr("title","闲趣|赛事");
            		$("#title2").html("赛事");
            		$("#Regional_val").val("2d02a28e61d34c7c81d85710499f38f8");
            	}else if(wxEvent==7){
            		$(document).attr("title","闲趣|培训");
            		$("#title2").html("培训");
            		$("#Regional_val").val("e4c2cef5b0d24b2793ac00fd1098e4e7");
            	}else if(wxEvent==8){
            		$(document).attr("title","闲趣|演出");
            		$("#title2").html("演出");
            		$("#Regional_val").val("bfb37ab6d52f492080469d0919081b2b");
            	}else if(wxEvent==9){
            		$(document).attr("title","闲趣|旅行");
            		$("#title2").html("旅行");
            		$("#Regional_val").val("69fdee1744a74639bcdf0614dbec9435");
            	}else if(wxEvent==10){
            		$(document).attr("title","闲趣|亲子");
            		$("#title2").html("亲子");
            		$("#Regional_val").val("47486962f28e41ceb37d6bcf35d8e5c3");
            	}else if(wxEvent==11){
            		$(document).attr("title","闲趣|电影");
            		$("#title2").html("电影");
            		$("#Regional_val").val("2346ad22d20142c78a42b7326a6bec12");
            	}else if(wxEvent==12){
            		$(document).attr("title","闲趣|聚会");
            		$("#title2").html("聚会");
            		$("#Regional_val").val("f9cf9c257fa540da85a6af7c83ce3fcc");
            	}else if(wxEvent==13){
            		$(document).attr("title","闲趣|讲座");
            		$("#title2").html("讲座");
            		$("#Regional_val").val("cf719729422c497aa92abdd47acdaa56");
            	}else if(wxEvent==14){
            		$(document).attr("title","闲趣|交友");
            		$("#title2").html("交友");
            		$("#Regional_val").val("7b3db00a3d704d45a5e3cb867ae39f8b");
            	}else if(wxEvent==15){
            		$(document).attr("title","闲趣|美食");
            		$("#title2").html("美食");
            		$("#Regional_val").val("57f30b318a29491fbf0a5643dd317f1a");
            	}else if(wxEvent==16){
            		$(document).attr("title","闲趣|戏曲");
            		$("#title2").html("戏曲");
            		$("#Regional_val").val("314f1b8fd6e04f93b5b067ab19d48ea6");
            	}
        	}else{
        		$(document).attr("title","近期活动");
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
                    jsApiList: ['getLocation','onMenuShareAppMessage','onMenuShareTimeline','onMenuShareQQ','onMenuShareWeibo','onMenuShareQZone']
                });
                wx.ready(function () {
                	wx.onMenuShareAppMessage({
                        title: "近期活动",
                        desc: '安康文化云-畅想城市文化生活新体验',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
                        success: function () { 
                        	dialogAlert('系统提示', '分享成功！');
                        }
                    });
                    wx.onMenuShareTimeline({
                        title: "近期活动",
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
                        success: function () { 
                        	dialogAlert('系统提示', '分享成功！');
                        }
                    });
                    wx.onMenuShareQQ({
                    	title: "近期活动",
                    	desc: '安康文化云-畅想城市文化生活新体验',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                    });
                    wx.onMenuShareWeibo({
                    	title: "近期活动",
                    	desc: '安康文化云-畅想城市文化生活新体验',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                    });
                    wx.onMenuShareQZone({
                    	title: "近期活动",
                    	desc: '安康文化云-畅想城市文化生活新体验',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                    });
                    wx.getLocation({
                        type: 'gcj02', // 默认为wgs84的gps坐标，如果要返回直接给openLocation用的火星坐标，可传入'gcj02'
                        success: function (res) {
                            latitude = (res.latitude == null || res.latitude == "") ? 0 : res.latitude; // 纬度，浮点数，范围为90 ~ -90
                            longitude = (res.longitude == null || res.longitude == "") ? 0 : res.longitude; // 经度，浮点数，范围为180 ~ -180。

                            loadArea();
                            loadTag();
                            loadData(0, 20);
                            activityBanner();
                        },
    	    		    fail: function (res){
    	    		    	dialogAlert("系统提示", "获取坐标失败，定位未启用");
    	    		    	loadArea();
                            loadTag();
                            loadData(0, 20);
                            activityBanner();
    	    		    }
                    });
                });
            } else {
            	if (/wenhuayun/.test(ua)) {		//APP端
            		getAppUserLocation();
            		loadArea();
                    loadTag();
                    loadData(0, 20);
                    activityBanner();
            	}else{
            		if (window.navigator.geolocation) {
                        var options = {enableHighAccuracy: true};
                        window.navigator.geolocation.getCurrentPosition(handleSuccess, handleError, options);
                    } else {
                    	dialogAlert("系统提示", "浏览器不支持html5来获取地理位置信息");
                    }
                    
                    function handleSuccess(position){
                    	var lng = position.coords.longitude;
                        var lat = position.coords.latitude;
                        longitude = wgs84togcj02(lng,lat)[0];
                        latitude = wgs84togcj02(lng,lat)[1];
                        
                        loadArea();
                        loadTag();
                        loadData(0, 20);
                        activityBanner();
                    }
                    function handleError(error){
                    	dialogAlert("系统提示", "获取坐标失败，定位未启用");
                    	loadArea();
                        loadTag();
                        loadData(0, 20);
                        activityBanner();
                    }
            	}
            }
        });

        //加载标签
        function loadTag() {
            $.post("${path}/wechatActivity/wcActivityTagList.do", function (data) {
                if (data.status == 0) {
                    $.each(data.data, function (i, dom) {
                        $("#typeList").append("<a date-id=" + dom.tagId + ">" + dom.tagName + "</a>");
                    });
                    
                    //分类 传值
                    $("#groups").find("a").click(function () {
                        var dataId = $(this).attr("date-id");
                        if ($(this).text() == "全部") {
                            $("#Regional_val").val("");
                            $(this).addClass("currblue");
                            $(".g_list").find(".currblue").removeClass("currblue");
                        } else {
                            $("#Regional_val").val(dataId);
                            $(".g_tit").find(".currblue").removeClass("currblue");
                        }
                        var dataName = $(this).text();
                        $("#title2").html(dataName);
                        $(this).parents("#div2").hide();
                        $("#screen_ul li").find("a[tip='#div2']").removeClass("for_on");
                        $(".bgBlack").hide();
                        $("#activityList").html("");
                        loadData(0, 20);
                        $("html").css("overflow", "auto");
                    })
                }
            }, "json");
        }
        ;

        //加载区域
        function loadArea() {
            $.post("${path}/wechatActivity/getAllArea.do", function (data) {
                $("#areaList").append("<a data-option='' class='active'>全上海</a>");
                $("#locationList").append("<div class='list_con'></div>");
                if (data.status == 200) {
                    $.each(data.data, function (i, dom) {
                        $("#areaList").append("<a data-option=" + dom.dictCode + ">" + dom.dictName + "</a>");
                        var addressHtml = "<div class='list_con' style='display:none;'><a data-id='' data-name='" + dom.dictName + "'>全部" + dom.dictName + "</a>";
                        $.each(dom.dictList, function (i, dom2) {
                            addressHtml += "<a date-id=" + dom2.id + " data-name='" + dom2.name + "'>" + dom2.name + "</a>";
                        });
                        addressHtml += "</div>";
                        $("#locationList").append(addressHtml);
                    });

                    var lists = $(".right_list .list_con");
                    $(".nearby_tit a").click(function () {
                        var indexs = $(this).index();
                        var dataOption = $(this).attr("data-option");
                        $("#nearby_val_1").val(dataOption);
                        $(this).addClass("active").siblings().removeClass("active");
                        lists.eq(indexs).show().siblings().hide();
                        if (dataOption == '') {
                            var currParenrIndex = parseInt($("#title1").attr("data-parent"));
                            $(".right_list>.list_con").eq(currParenrIndex).find(".curr").removeClass("curr");
                            $("#nearby_val_2").val('');
                            $("#title1").html("区域")
                            $(this).parents("#div1").hide();
                            $("#screen_ul li").find("a[tip='#div1']").removeClass("for_on");
                            $(".bgBlack").hide();
                            $("#activityList").html("");
                            loadData(0, 20);
                        }
                    })

                    $(".right_list a").click(function () {
                        var currParenrIndex = parseInt($("#title1").attr("data-parent"));
                        $(".right_list>.list_con").eq(currParenrIndex).find(".curr").removeClass("curr");
                        var dataId = $(this).attr("date-id");
                        $("#nearby_val_2").val(dataId);
                        var dataName = $(this).attr("data-name");
                        $("#title1").html(dataName).attr("data-parent", $(this).parent().index());
                        $(this).parents("#div1").hide();
                        $("#screen_ul li").find("a[tip='#div1']").removeClass("for_on");
                        $(".bgBlack").hide();
                        $(this).addClass("curr");
                        $("#activityList").html("");
                        loadData(0, 20);
                        $("html").css("overflow", "auto");
                    })
                }
            }, "json");
        }

        //加载活动
        function loadData(index, pagesize) {
            pageSize = pagesize;
            startIndex = index;
            var activityArea = $("#nearby_val_1").val();
            var activityLocation = $("#nearby_val_2").val();
            var activityType = $("#Regional_val").val();
            var sortType = $("#Sort_val").val();
            var chooseType = $("#Brand_data_val").val();
            var bookType = $("#Brand_status_val").val();
            var isWeekend = $("#Brand_week_val").val();
            var data = {
                activityType: activityType,	//标签
                activityArea: activityArea,	//市区code
                activityLocation: activityLocation,	//区域商圈id
                sortType: sortType,	//排序	1-离我最近 2-即将开始 3-即将结束 4-最新发布 5-人气最高 6-评价最好
                chooseType: chooseType,	//筛选类别1(5天之内) 2(5-10天) 3(10-15天) 4(15天以后)
                isWeekend: isWeekend,	//是否周末	1-周末 0-工作日 空表示不选
                bookType: bookType,	//1-可预订 0-不可预订 空表示所有
                Lon: longitude,
                Lat: latitude,
                pageIndex: startIndex,
                pageNum: pageSize
            }
            $.post("${path}/wechatActivity/wcNearActivity.do", data, function (data) {
                if (data.data.length > 0) {
                    loadIcon.showLoad();
                    isScroll = true;
                } else {
                    isScroll = false;
                    if ($("#pullUp").length > 0) {
                        $("#pullUp").html("<span class=\"pullUpLabel\">没有结果了</span>");
                    } else {
                        $("#scroller").append("<div id=\"pullUp\"><span class=\"pullUpLabel\">没有结果了</span></div>");
                    }
                }

                var activityIds = [];

                $.each(data.data, function (i, dom) {
                    activityIds.push(dom.activityId);
                    var activityIconUrl = getIndexImgUrl(dom.activityIconUrl, "_300_300");
                    var priceTime = "";
                    if (dom.activityPrice.length != 0 && dom.activityPrice > 0) {
                        priceTime = "<p><span class='greens'>" + dom.activityPrice + "元/人</span>" + dom.activityStartTime + "</p>";
                    } else {
                        priceTime = "<p><span class='blued'>免费</span>" + dom.activityStartTime + "</p>";
                    }
                    var activityDistance = "";
                    if (dom.sysNo && dom.sysId) {
                    	activityDistance = "<div class='climb fl'>无信息</div>";
                    }else{
                    	activityDistance = "<div class='climb fl whyDistance'>0km</div>";
                    }
                    var activityTicket = "";
                    if (dom.activityPast == 0) {//未过期
                        if (dom.activityIsReservation == 2) {//可否预订
                            if (dom.sysNo && dom.sysId) {
                                activityTicket = "<div class='has_ticket jd' dataId='" + dom.sysId + "'></div>";
                            }
                            else {
                                activityTicket = "<div class='has_ticket why'></div>";
                            }
                        } else {
                            activityTicket = "<div class='goto'><span>直达现场</span></div>";
                        }
                    } else {
                        activityTicket = "<div class='already_over'><span>已结束</span></div>";
                    }
                    $("#activityList").append("<li activityId=" + dom.activityId + " onclick='showActivity(\"" + dom.activityId + "\")'>" +
                            "<div class='tit'>" + dom.activityName + "</div>" +
                            "<div class='a_con clearfix'>" +
                            "<div class='pic fl'><img src='" + activityIconUrl + "' width='200' height='133'></div>" +
                            "<div class='acon_txt fl'>" +
                            priceTime +
                            "<div class='label_climb clearfix'>" +
                            "<div class='label fl'>" +
                            "<span>" + dom.activityArea.split(",")[1] + "</span>" +
                            "<span>" + dom.tagName + "</span>" +
                            "</div>" +
                            activityDistance +
                            "</div>" +
                            activityTicket +
                            "</div>" +
                            "</div>" +
                            "</li>");
                });
                if (data.data.length > 0) {
                    //查询首页的活动的浏览量、收藏量、评论量、余票、距离
                    $.post("${path}/wechatActivity/wcIndexActivityAllCount.do", {
                        activityIds: activityIds.join(","),
                        Lon: longitude,
                        Lat: latitude
                    }, function (data) {
                        if (data.status == 1) {
                            $.each(data.data, function (i, dom) {
                                var $actDiv = $("#activityList li[activityId=" + dom.activityId + "]");
                                $actDiv.find(".whyDistance").html(new Number(dom.distance).toFixed(2) + "km");
                                if (dom.ticketCount > 0) {
                                    $actDiv.find(".has_ticket.why").html("余票:<span>" + dom.ticketCount + "</span>");
                                } else {
                                    $actDiv.find(".has_ticket.why").html("余票:<span>0</span>");
                                }
                                var dataId = $actDiv.find(".has_ticket.jd").attr("dataId");
                                if (dataId) {
                                    var tcount;
                                    $.post("${path}/appActivity/getSubSystemTicketCount.do", {
                                        sysIds: dataId
                                    }, function (res) {
                                        tcount = res.tickets[dataId];
                                        if (tcount > 0) {
                                            $actDiv.find(".has_ticket.jd").html("余票:<span>" + tcount + "</span>");
                                        } else {
                                            $actDiv.find(".has_ticket.jd").html("余票:<span>0</span>");
                                        }
                                    }, "json");
                                }
                            });
                            loadIcon.hideLoad();
                        }
                    }, "json");
                }

            }, "json");
        }

        $(window).on("scroll", function () {
            var scrollTop = $(document).scrollTop();
            var pageHeight = $(document).height();
            var winHeight = $(window).height();
            if (scrollTop >= (pageHeight - winHeight - 300)) {
                if (isScroll) {
                    startIndex += 20;
                    loadData(startIndex, 20);
                }
            }
        });

        var loadIcon = {
            showLoad: function () {
            	$("#pullUp").remove();
                $("#scroller").append('<div id="pullUp" class="loading"><span class="pullUpIcon"></span><span class="pullUpLabel">加载中...</span></div>');
            },
            hideLoad: function () {
                $("#pullUp").remove();
            }
        }

        //banner轮播图
        function activityBanner() {
            $.post("${path}/wechat/wcActivityBanner.do", {type: 3}, function (data) {
                if (data.status == 0) {
                    $.each(data.data, function (i, dom) {
                        var adverType = dom.adverType;
                        var advertPicUrl = getIndexImgUrl(dom.advertPicUrl, "_750_150");
                        if (dom.advertConnectUrlId != "" && dom.advertConnectUrlId != null) {
                            $("#activityBanner").append(
                                    "<div class='lead_con' onclick='window.location.href=\"" + dom.advertConnectUrlId + "\"'>" +
                                    "<img src='" + advertPicUrl + "' width='750' height='150' class='lead_img'/>" +
                                    "</div>");
                        } else {
                            $("#activityBanner").append(
                                    "<div class='lead_con'>" +
                                    "<img src='" + advertPicUrl + "' width='750' height='150' class='lead_img'/>" +
                                    "</div>");
                        }
                    });

                    //轮播效果
                    var mySwipe = Swipe(document.getElementById('mySwipe'), {
                        auto: 5000,
                    });
                }
            }, "json");
        }

        //跳转到活动详情
        function showActivity(activityId) {
            window.location.href = "${path}/wechatActivity/preActivityDetail.do?activityId=" + activityId;
        }

    </script>
    <style type="">
        body {
            margin: 0;
            padding: 0;
            font: 12px/1 微软雅黑;
        }
    </style>
</head>
<body class="body_scroll">

<div class="screening">
    <ul id="screen_ul">
        <li class="meishi"><a id="title1" tip="#div1">区域</a></li>
        <li class="Regional"><a id="title2" tip="#div2">分类</a></li>
        <li class="Sort"><a id="title3" tip="#div3">排序</a></li>
        <li class="Brand"><a id="title4" tip="#div4">筛选</a></li>
    </ul>
    <input type="hidden" id="nearby_val_1">
    <input type="hidden" id="nearby_val_2">
    <input type="hidden" id="Regional_val">
    <input type="hidden" id="Sort_val">
    <input type="hidden" id="Brand_data_val">
    <input type="hidden" id="Brand_status_val">
    <input type="hidden" id="Brand_week_val">
</div>

<div>
    <div id="div1" style="display:none;">
        <div id="nearby">
            <ul class="nearby_tit" id="areaList"></ul>
            <div class="right_list" id="locationList"></div>
        </div>
    </div>

    <div id="div2" style="display:none;">
        <div id="groups">
            <div class="g_tit"><a>全部</a></div>
            <div class="g_list" id="typeList"></div>
        </div>
    </div>

    <div id="div3" style="display:none;">
        <div id="sort">
            <a date-id="0">智能排序</a>
            <a date-id="1">离我最近</a>
            <a date-id="2">即将开始</a>
            <a date-id="3">即将结束</a>
            <a date-id="4">最新发布</a>
            <a date-id="5">人气最高</a>
            <a date-id="6">评论最多</a>
        </div>
    </div>

    <div id="div4" style="display:none;">
        <div id="brand">
            <div class="datas state clearfix" id="date_list">
                <h3>日期</h3>
                <a date-id="1">5天之内</a>
                <a date-id="2">5-10天</a>
                <a date-id="3">10-15天</a>
                <a date-id="4">15天以上</a>
            </div>
            <div class="state clearfix" id="atatus_list">
                <h3>状态</h3>
                <a date-id="1">需要预定</a>
                <a date-id="0">直接参与</a>
            </div>
            <div class="state clearfix" id="week_list">
                <h3>其它</h3>
                <a date-id="0">工作日</a>
                <a date-id="1">周末</a>
            </div>
            <div class="btn">
                <a id="reset_brand">重置</a>
                <a id="sure_brand">确定</a>
            </div>
        </div>
    </div>
</div>

<div id="scroller">
    <div class="site_ad">
        <div id='mySwipe' class='swipe' style="position:relative;">
            <div class='swipe-wrap' style="z-index:0" id="activityBanner"></div>
        </div>
    </div>
    <div class="recent_alist">
        <div class="bgBlack" style="display:none"></div>
        <ul id="activityList"></ul>
    </div>
    <div class="fixbg"></div>
</div>

<script type="text/javascript">
    //ul tab切换
    $("#screen_ul li a").click(function () {
        var tips = $(this).attr("tip");
        if ($(this).hasClass("for_on")) {
            $(this).removeClass("for_on");
            $(tips).hide();
            $(".bgBlack").hide();
            $("html").css("overflow", "auto");
        } else {
            $(this).addClass("for_on");
            $(this).parent("li").siblings("li").children("a").removeClass("for_on");
            $(tips).show().siblings().hide();
            $(".bgBlack").show();
            $("html").css("overflow", "hidden");
        }
    })

    //排序 传值
    $("#sort").find("a").click(function () {
        var dataId = $(this).attr("date-id");
        $("#Sort_val").val(dataId);
        var dataName = $(this).text();
        $("#title3").html(dataName);
        $(this).parents("#div3").hide();
        $("#screen_ul li").find("a[tip='#div3']").removeClass("for_on");
        $(".bgBlack").hide();
        $("#activityList").html("");
        loadData(0, 20);
        $("html").css("overflow", "auto");
    })
    //筛选
    $("#date_list").find("a").click(function () {
        var dataId = $(this).attr("date-id");
        $("#Brand_data_val").val(dataId);
    })
    $("#atatus_list").find("a").click(function () {
        var dataId = $(this).attr("date-id");
        $("#Brand_status_val").val(dataId);
    })
    $("#week_list").find("a").click(function () {
        var dataId = $(this).attr("date-id");
        $("#Brand_week_val").val(dataId);
    })
    //重置
    $("#reset_brand").click(function () {
        $("#Brand_data_val").val("");
        $("#Brand_status_val").val("");
        $("#Brand_week_val").val("");
        $(".state").find("a").removeClass("curr");
    })
    //确定new
    $("#sure_brand").click(function () {
        $(this).parents("#div4").hide();
        $("#screen_ul li").find("a[tip='#div4']").removeClass("for_on");
        $(".bgBlack").hide();
        $("#activityList").html("");
        loadData(0, 20);
        $("html").css("overflow", "auto");
    })
</script>
</body>
</html>
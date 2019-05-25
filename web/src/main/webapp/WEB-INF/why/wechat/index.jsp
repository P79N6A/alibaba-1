<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>安康文化云</title>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
    <%-- <script type="text/javascript" src="${path}/STATIC/wechat/js/jquery.lazyload.min.js"></script> --%>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="format-detection" content="telephone=no" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-status-bar-style" content="black" />
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/normalize.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/bpStyle.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/hsStyle.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/swiper-3.3.1.min.css"/>
    <%--<link rel="stylesheet" href="${path}/STATIC/wechat/css/bpColorCtrl.css" />--%>
    <script type="text/javascript" src="${path}/STATIC/wechat/js/jquery-2.1.4.min.js"></script>
    <script type="text/javascript" src="${path}/STATIC/wechat/js/swiper-3.3.1.jquery.min.js"></script>

    <script type="text/javascript">


        function moreClick(){
            var open="${path}/STATIC/wechat/image/muluImg/8.png";
			var close="${path}/STATIC/wechat/image/muluImg/8.2.png";
			var imgSrc=$("#moreClick").find("img").attr("src");
			if(imgSrc==open){
                $("#moreMenu1").show();
                $("#moreClick").find("img").attr("src",close);
                $("#moreClick").find("p").text("收起更多");
			}else{
                $("#moreMenu1").hide();
                $("#moreClick").find("img").attr("src",open);
                $("#moreClick").find("p").text("查看更多");
			}

		}

        var advertList = [];	//广告列表
        var advertNo = 3;	//首个广告插入位置
        var latitude = 22.964305;
        var longitude = 113.116029;
        var startIndex = 0;		//页数

        if (is_weixin()) {
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
                    title: "安康文化云-最全文化场馆与文化活动互联网平台",
                    desc: '文化引领 品质生活',
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
                wx.onMenuShareTimeline({
                    title: "安康文化云-最全文化场馆与文化活动互联网平台",
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
                wx.onMenuShareQQ({
                	title: "安康文化云-最全文化场馆与文化活动互联网平台",
                	desc: '文化引领 品质生活',
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
                wx.onMenuShareWeibo({
                	title: "安康文化云-最全文化场馆与文化活动互联网平台",
                	desc: '文化引领 品质生活',
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
                wx.onMenuShareQZone({
                	title: "安康文化云-最全文化场馆与文化活动互联网平台",
                	desc: '文化引领 品质生活',
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
            });
        }

        $(function () {
            activityBanner();	  //广告列表

            //底部菜单
            $(document).on("touchmove", function() {
                $(".footer").hide()
            }).on("touchend", function() {
                $(".footer").show()
            })
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

        //跳转到活动详情
        function showActivity(activityId) {
            window.location.href = "${path}/wechatActivity/preActivityDetail.do?activityId=" + activityId;
        }

        //首页活动加载
        function loadData() {
            //图片懒加载开始位置
            var liCount = $("#index_list li").length;

            $.post("${path}/wechatActivity/getRecommendActivity.do",{lon:longitude,lat:latitude,userId:userId}, function (data) {
                var activityIds = [];
                if(data.data.length==0){
                    $("#loadingDiv").html("<span class='noLoadingSpan'>没有找到合适的结果，换个试试看吧~</span>");
                }
                $.each(data.data, function (i, dom) {
                    if(advertList.length>0){
                        if(i==advertNo){	//插入广告位
                            var advertDom = advertList.shift();
                            var jumpUrl = getAdvertUrl(advertDom.advertLink,advertDom.advertLinkType,advertDom.advertUrl);
                            $("#index_list").append("<li onclick='preOutUrl(\""+jumpUrl+"\");'><img src='"+getIndexImgUrl(advertDom.advertImgUrl, "_750_250")+"' width='750' height='250'/></li>");

                            advertNo += 3;
                            if(advertNo>19){
                                advertNo -= 20;
                            }
                        }
                    }

                    activityIds.push(dom.activityId);
                    var time = dom.activityStartTime.substring(5,10).replace("-",".");
                    if(dom.activityEndTime.length>0&&dom.activityStartTime!=dom.activityEndTime){
                        time += "-"+dom.activityEndTime.substring(5,10).replace("-",".");
                    }
                    var activityIconUrl = getIndexImgUrl(dom.activityIconUrl, "_750_500");
                    var price = "";
                    if(dom.availableCount > 0 || dom.activityIsReservation == 1){
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
                    $("#index_list").append("<li activityId=" + dom.activityId + " onclick='showActivity(\"" + dom.activityId + "\")'>" +
                        "<div class='activeList'>" +
                        "<img src='" + activityIconUrl + "' width='750' height='475'/>" +
                        isReservationHtml + tagHtml + price +
                        "</div>" +
                        "<p class='activeTitle'>"+dom.activityName+"</p>" +
                        "<p class='activePT'>"+time+" | "+dom.activityLocationName+"</p>" +
                        "</li>");
                });

                /* //图片懒加载
                   $("#index_list li:gt("+liCount+") img.lazy,#index_list li:eq("+liCount+") img.lazy").lazyload({
                    effect : "fadeIn",
                    effectspeed : 1000
                }); */
            }, "json");
        };

        //首页banner轮播图
        function activityBanner() {
            $.post("${path}/wechat/getAdvertRecommend.do", {advertPostion: 2,advertType: "A"}, function (data) {
                if (data.status == 1) {
                	$("#indexBannerList").html("");
                    /*var addBanner="<div class='swiper-slide'>" +
                        "<img id='advertImg11' src='${path}/STATIC/wechat/image/muluImg/banner.png' width='750' height='250'/>" +
                        "</div>";
                    $("#indexBannerList").append(addBanner);*/
                	$.each(data.data, function (i, dom) {
                		var jumpUrl = getAdvertUrl(dom.advertLink,dom.advertLinkType,dom.advertUrl,dom.advertTitle);
                		if(dom.advertSort==1||dom.advertSort==8||dom.advertSort==9||dom.advertSort==10){
                			var advertImgUrl = getIndexImgUrl(dom.advertImgUrl, "_750_250");
                			$("#indexBannerList").append("<div class='swiper-slide'>" +
			        							"<img id='advertImg"+dom.advertSort+"' src='' width='750' height='250'/>" +
			    							 "</div>");
                		}else if(dom.advertSort>=2&&dom.advertSort<=4){
                			var advertImgUrl = getIndexImgUrl(dom.advertImgUrl, "_249_215");
                		}else if(dom.advertSort>=5&&dom.advertSort<=6){
                			var advertImgUrl = getIndexImgUrl(dom.advertImgUrl, "_374_220");
                		}
                		$("#advertImg"+dom.advertSort).attr("src",advertImgUrl);
                		$("#advertImg"+dom.advertSort).attr("onclick","preOutUrl(\""+jumpUrl+"\");");
                		if(dom.advertSort==3){
                			$("#canyuliid").attr("onclick","preOutUrl(\""+jumpUrl+"\");");
                		}
                	});

                	if(data.data.length>7){		//广告位A开始轮播
                		$("#swiperPage").show();
                		var mySwiper3 = new Swiper('.swiper-container3', {
        					freeMode: false,
        					autoplay : 3000,
        					loop:true,
        					pagination: '.swiper-pagination'
        				})
                	}
                }
            }, "json");
            $.post("${path}/wechat/getAdvertRecommend.do", {advertPostion: 2,advertType: "B"}, function (data) {
                if (data.status == 1) {
                    $("#indexBannerList2").html("");
                    $.each(data.data, function (i, dom) {
                        var jumpUrl = getAdvertUrl(dom.advertLink,dom.advertLinkType,dom.advertUrl,dom.advertTitle);
                        var advertImgUrl = getIndexImgUrl(dom.advertImgUrl, "_120_120");
                        $("#indexBannerList2").append("<div class='swiper-slide' onclick='location.href=\""+jumpUrl+"\"'>" +
                            "<img src='"+advertImgUrl+"' width='140' height='140' style='border-radius:100%'/>" +
                            "<p>"+dom.advertTitle+"</p>" +
                            "</div>");
                    });
                    if(data.data.length>1){
                        $("#swiperPage2").show();
                        var mySwiper2 = new Swiper('.swiper-container2', {
                            slidesPerView: 4,
                            slidesPerGroup : 4,
                            freeMode: false,
                            pagination: '.swiper-pagination'
                        })
                    }
                }
            }, "json");

            //精彩推荐(为您推荐模块)
            $.post("${path}/wechat/getAdvertRecommend.do", {advertPostion: 2,advertType: "C"}, function (data) {
                if (data.status == 1) {
                    $(".forUlist").html("");
                    $.each(data.data, function (i, dom) {
                        var jumpUrl = getAdvertUrl(dom.advertLink,dom.advertLinkType,dom.advertUrl,dom.advertTitle);
                        var advertImgUrl = getIndexImgUrl(dom.advertImgUrl, "_300_190");
                        $(".forUlist").append("<li onclick='location.href=\""+jumpUrl+"\"'>" +
                            "<img src='"+advertImgUrl+"' width='300' height='190' />" +
                            "<p>"+dom.advertTitle+"</p>" +
                            "</li>");
                    });

                    //计算为您推荐的宽度
                    var L_len = $(".forUlist>li").length;
                    var fu_width = L_len * 322;
                    $(".forUlist").css("width", fu_width);
                }
            }, "json");

            //热门推荐
            $.post("${path}/wechat/getAdvertRecommend.do", {advertPostion: 2,advertType: "D"}, function (data) {
                if (data.status == 1) {
                    advertList = data.data;

                    loadData();
                }
            }, "json");
        }

        //获取广告位链接地址
        function getAdvertUrl(advertLink,advertLinkType,advertUrl,advertTitle){
            var jumpUrl = "";
            if(advertLink==0){
                if(advertLinkType==0){
                    jumpUrl = "${basePath}/wechatActivity/preActivityList.do?activityName="+advertUrl;
                }else if(advertLinkType==1){
                    jumpUrl = "${basePath}/wechatActivity/preActivityDetail.do?activityId="+advertUrl;
                }else if(advertLinkType==2){
                    jumpUrl = "${basePath}/wechatVenue/preVenueList.do?venueName="+advertUrl;
                }else if(advertLinkType==3){
                    jumpUrl = "${basePath}/wechatVenue/venueDetailIndex.do?venueId="+advertUrl;
                }else if(advertLinkType==4){
                    jumpUrl = "${basePath}wechatActivity/preActivityCalendar.do";
                }else if(advertLinkType==5){
                    jumpUrl = "${basePath}wechatActivity/preActivityListTagSub.do?activityType="+advertUrl+"&advertTitle="+advertTitle;
                }
            }else{
                jumpUrl = advertUrl;
            }
            return jumpUrl;
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

        //跳转到日历
        function preCalendar(){
            window.location.href = '${path}/wechatActivity/preActivityCalendar.do';
        }

    </script>

    <script type="text/javascript">
        $(function() {

            //底部菜单
            $(document).on("touchmove", function() {
                $(".footer").hide()
            }).on("touchend", function() {
                $(".footer").show()
            })
            $(".newMenuBTN").click(function() {
                $(".newMenuList").animate({
                    "bottom": "0px"
                })
            })
            $(".newMenuCloseBTN>img").click(function() {
                var height = $(".newMenuList").width();
                $(".newMenuList").animate({
                    "bottom": "-" + height + "px"
                })
            })
            //回到顶部按钮显示
            $(window).scroll(function() {
                var screenheight = $(window).height() * 2
                if($(document).scrollTop() > screenheight) {
                    $(".totop").show()
                } else {
                    $(".totop").hide()
                }
            })
            /*菜单轮播*/
            var mySwiper4 = new Swiper('.swiper-container4', {
                freeMode: false,
                autoplay: false,
                loop: false,
                pagination: '.swiper-pagination'
            });
        });
    </script>

    <style>
        html,
        body {
            height: 100%;
            background-color: #f3f3f3
        }

        .swiper-container .swiper-slide {
            width: auto;
            padding: 0 20px;
        }

        div.main~div {
            display: none!important;
            opacity: 0;
        }

        body>iframe {
            opacity: 0;
            display: none!important;
        }

        .indexTable {
            padding: 5px 0;
            background-color: #fff;
        }

        .indexTable table {
            margin: auto;
        }

        .indexTable td {
            padding: 3px;
        }
        .swiper-container4  > .swiper-pagination-bullets, .swiper-container4 .swiper-pagination-custom, .swiper-container4 .swiper-pagination-fraction{
            bottom: 155px;
        }
    </style>

    <style>
        html,body{height:100%;background-color:#f3f3f3}
        .swiper-container .swiper-slide{width: auto;padding: 0 20px;}
    </style>
</head>

<body>
<div class="ahSearchBar">
    <div class="ahSearch clearfix">
        <input type="text" name="" style="width: 638px" placeholder="点击搜索你感兴趣的文化内容" readonly="readonly" onclick="window.location.href='${path}/wechatActivity/activitySearchIndex.do'">
        <%--<a href="${path}/citySwitch/citySwitchPage.do" class="cityChange"><img src="${path}/STATIC/wechat/image/ah_add.png"><font id="curcity"></font></a>--%>
    </div>
</div>
<div class="main">
    <div class="content padding-bottom0">
        <!-- 推荐页广告位 -->
        <div class="recommendDiv">
            <div class="indexBanner" style="position: relative;overflow:hidden;">
                <div class="swiper-container3 swiper-container-horizontal">
                    <div id="indexBannerList" class="swiper-wrapper">

                    </div>
                    <div id="swiperPage" class="swiper-pagination"></div>

                </div>
            </div>
            <div class="menuRound" style="padding-top: 12px">
                <div class="swiper-container2 swiper-container-horizontal" style="overflow:hidden;">
                    <div id="indexBannerList2" class="swiper-wrapper">

                    </div>
                    <div id="swiperPage2" class="swiper-pagination" style="position: relative;"></div>

                </div>
            </div>

            <div class="forUser">
                <div class="fuRow3" style="margin-bottom: 2px;display: block">
                    <div class="fuRow3-AD1">
                        <a href="###"><img id="advertImg2" src="${path}/STATIC/wechat/image/muluImg/whfw.png" width="250" height="200"/></a>
                    </div>
                    <div class="fuRow3-AD2">
                        <a href="###"><img id="advertImg3" src="${path}/STATIC/wechat/image/muluImg/whkj.png" width="250" height="200"/></a>
                    </div>
                    <div class="fuRow3-AD2">
                        <a href="###"><img id="advertImg4" src="${path}/STATIC/wechat/image/muluImg/whkj.png" width="250" height="200"/></a>
                    </div>
                    <div style="clear: both;"></div>
                </div>
                <div class="fuRow2" style="/*display:none*/">
                    <div class="fuRow2-AD1">
                        <img id="advertImg5" src="" width="374" height="200"/>
                    </div>
                    <div class="fuRow2-AD2">
                        <img id="advertImg6" src="" width="374" height="200"/>
                    </div>
                    <div style="clear: both;"></div>
                </div>
                <%--<div class="fuRow4" style="/*display:none*/">
                    <div class="fuRow4-AD1">
                        <img id="advertImg5" src="" width="374" height="200"/>
                    </div>
                    <div class="fuRow4-AD2">
                        <img id="advertImg6" src="" width="374" height="200"/>
                    </div>
                    <div class="fuRow4-AD3">
                        <img id="advertImg6" src="" width="185" height="215"/>
                    </div>
                    <div class="fuRow4-AD4">
                        <img id="advertImg7" src="" width="185" height="215"/>
                    </div>
                    <div style="clear: both;"></div>
                </div>--%>
            </div>

            <!--公共文化服务-->
            <a href="${path}/wechatInformation/list.do?informationModuleId=ced4b1ebcd524da8b81c2a87968d2013">
                <div style="cursor:pointer;margin-top: 15px;width:100%;height:150px;background: url('${path}/STATIC/wechat/image/muluImg/newCreateImg.png');background-size: 100% 100%;">
                </div>
            </a>
        </div>
            <div class="forU">
                <%--<img src="${path}/STATIC/wechat/image/weinintuijian.png" />--%>
                <div style="margin-left:10px;font-size:20px;font-weight:bold;">为您推荐</div>
                <div class="forUmenu">
                    <ul class="forUlist" style="width: 2254px;">
                        <%--<li onclick="location.href='http://culturecloud.img-cn-hangzhou.aliyuncs.com/beipiao/20194241034Z31TNMxybtjm43kjoEc1HXIkJcyf3h.mp4'">
                            <img src="" width="300" height="190"/>
                            <p>测试1</p>
                        </li>
                        <li onclick="location.href='http://223.84.188.54/beipiaoInfo/bpInfoDetail.do?infoId=269923257473442aa9166e1ba53d7506&module=YSJS'">
                            <img src="" width="300" height="190"/>
                            <p>测试2</p>
                        </li>--%>
                    </ul>
                </div>
            </div>

            <div class="guessU">
                <div style="margin-left:10px;font-size:20px;font-weight:bold;">猜您喜欢</div>
            </div>

        <div class="active" style="margin-top: 0px;">
            <ul id="index_list" class="activeUl">


            </ul>
        </div>
    </div>
    <%@include file="/WEB-INF/why/wechat/footerMenuList.jsp" %>
    <%--<div class="footer" style="background-color: transparent;bottom: 40px;border:none;">--%>
    <%--<div class="totop" onclick="$('html,body').animate({scrollTop: 0}, 1000);"><img class="menuBtnShadow" src="${path}/STATIC/wechat/image/newmenu/top.png" /></div>--%>
    <%--<div style="clear: both;"></div>--%>
    <%--<div class="newMenuBTN">--%>
    <%--<img class="menuBtnShadow" src="${path}/STATIC/wechat/image/newmenu/btn.png" />--%>
    <%--</div>--%>
    <%--</div>--%>
    <%--<div class="newMenuList">--%>
    <%--<div class="swiper-container4 swiper-container-horizontal">--%>
    <%--<div class="swiper-wrapper">--%>
    <%--<div class="swiper-slide">--%>
    <%--<ul>--%>
    <%--<li onclick="location.href='${path}/wechat/index.do'"><img src="${path}/STATIC/wechat/image/newmenu/shouye.png" /></li>--%>
    <%--<li onclick="location.href='${path}/wechatActivity/index.do'"><img src="${path}/STATIC/wechat/image/newmenu/huodong.png" /></li>--%>
    <%--<li onclick="location.href='${path}/wechatVenue/toSpace.do'"><img src="${path}/STATIC/wechat/image/newmenu/kongjian.png" /></li>--%>
    <%--<li onclick="location.href='${path}/wechatActivity/activitySearchIndex.do'"><img src="${path}/STATIC/wechat/image/newmenu/sousuo.png" /></li>--%>
    <%--<li onclick="location.href='${path}/wechatChuanzhou/chuanzhouIndex.do'"><img src="${path}/STATIC/wechat/image/newmenu/rwhs.png" /></li>--%>
    <%--<li onclick="location.href='${path}/wechatChuanzhou/chuanzhouIndex.do'"><img src="${path}/STATIC/wechat/image/newmenu/qzty.png" /></li>--%>
    <%--<li onclick="location.href='${path}/wechatChuanzhou/chuanzhouIndex.do'"><img src="${path}/STATIC/wechat/image/newmenu/szyd.png" /></li>--%>
    <%--<li onclick="location.href='${path}/wechatUser/preTerminalUser.do'"><img src="${path}/STATIC/wechat/image/newmenu/zhongxin.png" /></li>--%>

    <%--&lt;%&ndash;<li onclick="location.href='${path}/wechatBpProduct/preProductList.do'"><img src="${path}/STATIC/wechat/image/newmenu/shangcheng.png" /></li>&ndash;%&gt;--%>
    <%--&lt;%&ndash;<li onclick="location.href='${path}/wechatBpAntique/preAntiqueList.do'"><img src="${path}/STATIC/wechat/image/newmenu/wenwu.png" /></li>&ndash;%&gt;--%>
    <%--&lt;%&ndash; <li onclick="location.href=''"><img src="${path}/STATIC/wechat/image/newmenu/canyu.png" /></li> &ndash;%&gt;--%>


    <%--<div style="clear: both;"></div>--%>
    <%--</ul>--%>
    <%--</div>--%>
    <%--</div>--%>
    <%--&lt;%&ndash;<div id="swiperPage" class="swiper-pagination"></div>&ndash;%&gt;--%>

    <%--</div>--%>
    <%--<div class="newMenuCloseBTN">--%>
    <%--<img src="${path}/STATIC/wechat/image/newmenu/closeBTN.png" />--%>
    <%--</div>--%>
    <%--</div>--%>
</div>
</body>
</html>
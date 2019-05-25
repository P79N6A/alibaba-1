<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<%
    String path = request.getContextPath();
    request.setAttribute("path", path);
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>文化云 - 文化引领品质生活</title>
    <meta name="description" content="文化云-一款聚焦文化领域，提供公众文化生活服务和文化消费的文化互联网平台，现汇聚全上海22万场文化活动、5500余文化场馆资源，为用户提供便捷的文化品质生活服务。
    ">
    <meta name="Keywords" content="文化云、上海市民文化节、活动、场馆、免费活动、文化活动、文化场馆、活动预约、场馆预订、预订活动、预订场馆、群艺馆、博物馆、美术馆、陈列馆、消费、生活、生活消费、休闲、周末去哪儿、展览、演出、活动、旅行
    ">
    <link rel="shortcut icon" href="${path}/STATIC/image/favicon.ico" type="image/x-icon"
          mce_href="${path}/STATIC/image/favicon.ico">
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/reset-index.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/index_new.css"/>
    <!--[if lte IE 8]>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture-ie.css"/>
    <![endif]-->
    <script type="text/javascript" src="${path}/STATIC/js/jquery.min.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/jquery.SuperSlide.2.1.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/culture.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/common.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/index/index/index.js?version=20160506"></script>
    <!--移动端版本兼容 -->
    <script type="text/javascript">
        var phoneWidth = parseInt(window.screen.width);
        var phoneScale = phoneWidth / 1200;
        var ua = navigator.userAgent;            //浏览器类型
        if (/Android (\d+\.\d+)/.test(ua)) {      //判断是否是安卓系统
            var version = parseFloat(RegExp.$1); //安卓系统的版本号
            if (version > 2.3) {
                document.write('<meta name="viewport" content="width=1200, minimum-scale = ' + phoneScale + ', maximum-scale = ' + (phoneScale) + ', target-densitydpi=device-dpi">');
            } else {
                document.write('<meta name="viewport" content="width=1200, target-densitydpi=device-dpi">');
            }
        } else {
            document.write('<meta name="viewport" content="width=1200, user-scalable=yes, target-densitydpi=device-dpi">');
        }


        $(function () {
            $("#weekEndActivity").load("${path}/frontIndex/advert.do?type=C #weekEndActivityDivChild", null, function () {
                $("#weekEndActivity li").each(function (index, item) {
                    var imgUrl = $(this).attr("data-url");
                    if (imgUrl != undefined && imgUrl != "" && imgUrl != null) {
                        $(item).find("img").attr("src", getIndexImgUrl(getImgUrl(imgUrl), "_300_300"));
                    } else {
                        $(item).find("img").attr("src", "../STATIC/image/default.jpg");
                    }
                });
            });
            $("#recommendVenue").load("${path}/frontIndex/advert.do?type=D #recommendVenueChild", null, function () {
                $("#recommendVenueChild li").each(function (index, item) {
                    var imgUrl = $(this).attr("data-url");
                    if (imgUrl != undefined && imgUrl != "" && imgUrl != null) {
                        $(item).find("img").attr("src", getIndexImgUrl(getImgUrl(imgUrl), "_300_300"));
                    } else {
                        $(item).find("img").attr("src", "../STATIC/image/default.jpg");
                    }
                });
            });
            $("#newActivitys").load("${path}/frontIndex/advert.do?type=B #newActivitysChild", null, function () {
                $("#newActivitysChild li").each(function (index, item) {
                    var imgUrl = $(this).attr("data-url");
                    if (imgUrl != undefined && imgUrl != "" && imgUrl != null) {
                        $(item).find("img").attr("src", getIndexImgUrl(getImgUrl(imgUrl), "_300_300"));
                    } else {
                        $(item).find("img").attr("src", "../STATIC/image/default.jpg");
                    }
                });
            });
            $("#t_activity").load("${path}/frontIndex/frontThisWeekActivity.do? #weekActivitysChild", null, function () {

                $("#weekActivitysChild li").each(function (index, item) {
                    var imgUrl = $(this).attr("data-url");
                    if (imgUrl != undefined && imgUrl != "" && imgUrl != null) {
                        $(item).find("img").attr("src", getIndexImgUrl(getImgUrl(imgUrl), "_300_300"));
                    } else {
                        $(item).find("img").attr("src", "../STATIC/image/default.jpg");
                    }
                });
                /*首页星期切换*/
                    $(".navs a").click(function(){
                        var tips=$(this).attr("tip");
                        $(this).addClass("curblue").siblings().removeClass("curblue");
                        $(tips).show().siblings().hide();

                    })
                    $(".navs").on("click","a",function(){
                        var objs=$(this);
                        tabs(objs,"curblue")
                    })
                    $(".navs a.forit").click(function(){
                        alert(1)
                        $("#t_activity ul").show();
                    })
                    function tabs(object,class_name){
                        object.addClass(class_name).siblings().removeClass(class_name);
                        var tips=object.attr("tip");
                        $(tips).show().siblings().hide();
                    }
            });
        });
    </script>
    <!--移动端版本兼容 end -->
</head>
<body class="body">
<!-- 导入头部文件 -->
<%@include file="../index_top.jsp" %>
<!--banner_recommond start-->
<div class="banner_recommond clearfix">
    <!--left start-->
    <div id="banner" class="fl">
        <div class="in-ban">
            <ul class="in-ban-img">
            </ul>
        </div>
    </div>
    <!--left end-->
    <!--right start-->
    <div id="recommond">
        <div class="in-tit clearfix">
            <div class="txt fl"><span>推荐</span><em>RECOMMEND</em></div>
            <div class="arrow fr">
                <a href="javascript:;" class="prev">
                    <img src="${path}/STATIC/image/hp_larrow.jpg" width="25" height="24"/>
                </a>
                <a href="javascript:;" class="next">
                    <img src="${path}/STATIC/image/hp_rarrow.png" width="25" height="24"/>
                </a>
            </div>
        </div>
        <div id="hotelRecommendDiv">
        </div>
    </div>
</div>
<div id="con_p">
    <!--activity start-->
    <div class="con_p1 clearfix" id="newActivitys"></div>
    <!--activity end-->
    <!--weekend start-->
    <div id="weekEndActivity"></div>
    <!--weekend start-->
    <!--venue start-->
    <div id="recommendVenue"></div>
    <!--venue end-->
    <!--this_week start-->
    <div id="t_activity"></div>
    <!--this_week end-->
</div>
<!--list end-->
<%@include file="/WEB-INF/why/index/index_foot.jsp" %>
<!--feet end-->
<!--list end-->
<script>
    var _hmt = _hmt || [];
    (function () {
        var hm = document.createElement("script");
        hm.src = "//hm.baidu.com/hm.js?eec797acd6a9a249946ec421c96aafeb";
        var s = document.getElementsByTagName("script")[0];
        s.parentNode.insertBefore(hm, s);
    })();
</script>

<a class="cd-top"><img src="${path}/STATIC/image/hp_toparrow.png" width="40" height="40"/></a>
<a style="visibility: hidden"><img alt="文化云" src="${path}/STATIC/image/baiduLogo.png" width="121" height="75"/></a>
</body>
</html>

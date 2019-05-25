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
    <script type="text/javascript" src="${path}/STATIC/js/culture.js"></script>

    <script type="text/javascript" src="${path}/STATIC/js/common.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/index/index/frontIndex.js?version=20160513"></script>


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
    </script>
    <!--移动端版本兼容 end -->
</head>
<body class="body">
<!-- 导入头部文件 -->
<%@include file="../index_top.jsp" %>
<!--banner_recommond start-->
<form action="" id="indexForm" method="post">
    <!--banner_recommond end-->
    <input type="hidden" name="activityType" id="activityType"/>
    <input type="hidden" name="activityName" id="activityName" value="${activityName}"/>
    <input type="hidden" name="page" id="page"/>
    <div id="in_search">
        <div class="in_search">
            <div class="prop-attrs prop-attrs-type">
                <div class="attr">
                    <div class="attrKey">类型：</div>
                    <div class="attrValue" id="activitySearchType">
                        <ul class="av_list">
                        </ul>
                    </div>
                    <a class="btn-icon">收起</a>
                </div>
            </div>
            <div class="prop-attrs prop-attrs-area" id="prop-attrs-area" style="display: block" >
                <input type="hidden" name="activityLocation" id="activityLocation" value=""/>
                <div class="attr">
                    <div class="attrKey">区域：</div>
                    <input type="hidden" name="activityArea" id="areaCode" value=""/>
                    <div class="attrValue attr-collapse" id="attr-area">
                        <ul class="av_list">
                            <li class="cur"><a href="javascript:clickArea('');">全部</a></li>
                            <li id="46"><a href="javascript:clickArea('46');">黄浦区</a></li>
                            <li id="48"><a href="javascript:clickArea('48');">徐汇区</a></li>
                            <li id="50"><a href="javascript:clickArea('50');">静安区</a></li>
                            <li id="49"><a href="javascript:clickArea('49');">长宁区</a></li>
                            <li id="51"><a href="javascript:clickArea('51');">普陀区</a></li>
                            <li id="52"><a href="javascript:clickArea('52');">闸北区</a></li>
                            <li id="53"><a href="javascript:clickArea('53');">虹口区</a></li>
                            <li id="54"><a href="javascript:clickArea('54');">杨浦区</a></li>
                            <li id="58"><a href="javascript:clickArea('58');">浦东新区</a></li>
                            <li id="56"><a href="javascript:clickArea('56');">宝山区</a></li>
                            <li id="57"><a href="javascript:clickArea('57');">嘉定区</a></li>
                            <li id="60"><a href="javascript:clickArea('60');">松江区</a></li>
                            <li id="61"><a href="javascript:clickArea('61');">青浦区</a></li>
                            <li id="55"><a href="javascript:clickArea('55');">闵行区</a></li>
                            <li id="59"><a href="javascript:clickArea('59');">金山区</a></li>
                            <li id="63"><a href="javascript:clickArea('63');">奉贤区</a></li>
                            <li id="64"><a href="javascript:clickArea('64');">崇明县</a></li>
                        </ul>
                        <ul class="av_list" id="businessDiv">
                        </ul>
                    </div>
                </div>
                <div class="prop-attrs prop-attrs-other">
                    <div class="attr">
                        <div class="attrKey" style="margin-top:12px; ">时间：</div>
                        <div class="attrValue">
                            <input type="hidden" name="chooseType" id="chooseType"/>
                            <ul class="av_list">
                                <li class="cur"><a href="javascript:setValueById('chooseType','');">不限</a></li>
                                <li><a href="javascript:setValueById('chooseType','1');">5天内</a></li>
                                <li><a href="javascript:setValueById('chooseType','2');">5-10天</a></li>
                                <li><a href="javascript:setValueById('chooseType','3');">10-15天</a></li>
                                <li><a href="javascript:setValueById('chooseType','4');">15天以上</a></li>
                            </ul>
                        </div>
                    </div>
                    <%--<div class="attr">--%>
                        <%--<input type="hidden" name="isWeekend" id="isWeekend"/>--%>
                        <%--<div class="attrKey">其他：</div>--%>
                        <%--<div class="attrValue">--%>
                            <%--<ul class="av_list">--%>
                                <%--<li class="cur"><a href="javascript:setValueById('isWeekend','');">不限</a></li>--%>
                                <%--<li><a href="javascript:setValueById('isWeekend','0');">工作日</a></li>--%>
                                <%--<li><a href="javascript:setValueById('isWeekend','1');">周末</a></li>--%>
                            <%--</ul>--%>
                        <%--</div>--%>
                    <%--</div>--%>
                    <div class="attr">
                        <input type="hidden" name="bookType" id="bookType"/>
                        <div class="attrKey">状态：</div>
                        <div class="attrValue">
                            <ul class="av_list">
                                <li class="cur"><a href="javascript:setValueById('bookType','');">不限</a></li>
                                <li><a href="javascript:setValueById('bookType','1');">需要预订</a></li>
                                <li><a href="javascript:setValueById('bookType','0');">直接前往</a></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!--list start-->
    <div id="hot_list">
        <!--tit start-->
        <div class="tit clearfix">
            <input type="hidden" name="sortType" id="sortType" value=""/>
            <div class="tit_l fl">
                <a href="javascript:setValueById('sortType','');" class="cur">智能排序</a>
                <a href="javascript:setValueById('sortType','2');">即将开始</a>
                <a href="javascript:setValueById('sortType','3');">即将结束</a>
                <a href="javascript:setValueById('sortType','4');">最新发布</a>
                <a href="javascript:setValueById('sortType','5');">人气最高</a>
                <a href="javascript:setValueById('sortType','6');">评价最好</a>
            </div>
            <div class="tit_r fr">
                <label><%--<input type="checkbox" /><span>只显示未订光的</span>--%></label>
            </div>
        </div>
        <!--tit end-->
        <!--list start-->
        <div class="ul_list" id="activityListDivChild">
            <ul class="hl_list clearfix">
            </ul>
            <div id="Sweep" class="clearfix">
                <div class="s_img fl"><img src="${path}/STATIC/image/why_ss.png" width="151" height="152"/></div>
                <div class="s_app fl">
                    <p>浏览更多内容,请下载文化云APP</p>
                    <a class="ios">IOS 下载</a>
                    <a class="android">安卓 下载</a>
                </div>
            </div>
        </div>

    </div>
    <!--list end-->
</form>
<!--feet start-->
<%@include file="/WEB-INF/why/index/index_foot.jsp" %>
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

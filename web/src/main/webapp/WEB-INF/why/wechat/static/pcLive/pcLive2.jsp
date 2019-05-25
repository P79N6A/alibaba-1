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
    <meta name="description" content="安康文化云-一款聚焦文化领域，提供公众文化生活服务和文化消费的文化互联网平台，现汇聚全上海22万场文化活动、5500余文化场馆资源，为用户提供便捷的文化品质生活服务。">
    <meta name="Keywords" content="文化云、上海市民文化节、活动、场馆、免费活动、文化活动、文化场馆、活动预约、场馆预订、预订活动、预订场馆、群艺馆、博物馆、美术馆、陈列馆、消费、生活、生活消费、休闲、周末去哪儿、展览、演出、活动、旅行">
    <link rel="shortcut icon" href="${path}/STATIC/image/favicon.ico" type="image/x-icon" mce_href="${path}/STATIC/image/favicon.ico">
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/reset-index.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/index_new.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/jquery.min.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/jquery.SuperSlide.2.1.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/culture.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/common.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/index/index/index.js?version=20160507"></script>
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
    
    <script>
	    $(function () {
	    	$('.a_time .time em').html(getNowFormatDate());
			// 点赞增加
			$('.a_note .share_l .zan').bind('click', function () {
				var _span =$(this).find('.likeCount');
				if(_span.hasClass('current')) {
					return;
				} else {
					_span.addClass('current');
					_span.html(parseInt(_span.html()) + 1);
				}
				
			});
	    });
	    
	    function getNowFormatDate() {
		    var date = new Date();
		    var seperator1 = "-";
		    var seperator2 = ":";
		    var month = date.getMonth() + 1;
		    var strDate = date.getDate();
		    if (month >= 1 && month <= 9) {
		        month = "0" + month;
		    }
		    if (strDate >= 0 && strDate <= 9) {
		        strDate = "0" + strDate;
		    }
		    var currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate
		            + " " + date.getHours() + seperator2 + date.getMinutes();
		    return currentdate;
		}
    </script>
</head>

<body class="body">
	<%@include file="/WEB-INF/why/index/index_top.jsp" %>

	<div class="crumb"><i></i>您所在的位置：
		<a href="${path}/frontIndex/index.do">直播</a> &gt; lol小智直播 
	</div>

	<div class="detail-content" id="allInfo">
		<div class="detail-left fl">
			<div class="the_one">
				<div class="a_time">
					<div class="time"> <em></em> / 收藏：<span class="likeCount">244</span> / 浏览：<span>3219</span></div>
				</div>
				<div class="a_note" style="padding:34px 15px 35px 15px;">
					<div class="zbTitle clearfix" style="margin-bottom: 30px;">
						<div class="pic" style="width: 56px;height: 56px;overflow: hidden;position: relative;float: left;"><img style="width: 100%;height: 100%;" src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201736174551KKuSbNtMehGI1kIau8VyQYRmjUIbJn.jpg"></div>
						<div class="wenzi" style="float: left;margin-left: 15px;">
							<div class="t" style="font-size: 18px;color: #121212;font-weight: bold;line-height: 26px;height: 26px;overflow: hidden;margin-top: 3px;">lol小智直播，中单剑姬vs飞机，剑姬已经起飞了2017-02-19第六场</div>
							<div class="xg clearfix" style="font-size: 13px;color: #121212;margin-top: 5px;"><div class="x" style="float: left;height: 20px;line-height: 20px;overflow: hidden;max-width: 300px;white-space:nowrap;text-overflow:ellipsis;-o-text-overflow:ellipsis;overflow:hidden;">小智</div><div class="g" style="float: left;height: 20px;line-height: 20px;overflow: hidden;background: url(http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201736154613FHhkIh8Ldz27B9XZCyeFUC8zCiWwpQ.png) no-repeat left center;padding-left: 20px;margin-left: 55px;">4018人</div></div>
						</div>
					</div>

					<video style="display: block;width: 100%;height: auto;" controls="controls" preload="auto" autoplay="autoplay" src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20173895738Z0YS7ocYfIQKQZIKLL5KfHQjcMgRed.mp4"></video>
					
					<div class="download_fj" activityAttachment="">
					</div>
					<div class="shares">
	                    <div class="share_l fl">
	                        <div class="icon">
				        <span class="bdsharebuttonbox bdshare-button-style0-16" data-bd-bind="1488772070934">
				        	
					        <a class="zan" id="zanId"><span class="likeCount">1182</span></a>
					        
						 </span>
	                        </div>
	                    </div>
	                </div>
	                <div style="font-size:16px;color:#fff;text-align:center;width:120px;height:40px;line-height:40px;background-color:#00afef;margin-top:30px;">直播详情</div>
	                <div class="ad_intro" style="padding-top: 20px;">
						<p>
							lol小智直播，中单剑姬vs飞机，剑姬已经起飞了2017-02-19第六场 lol小智直播，中单剑姬vs飞机，剑姬已经起飞了2017-02-19第六场 lol小智直播，中单剑姬vs飞机，剑姬已经起飞了2017-02-19第六场 lol小智直播，中单剑姬vs飞机，剑姬已经起飞了2017-02-19第六场 lol小智直播，中单剑姬vs飞机，剑姬已经起飞了2017-02-19第六场 lol小智直播，中单剑姬vs飞机，剑姬已经起飞了2017-02-19第六场
						</p>
						<p>
							lol小智直播，中单剑姬vs飞机，剑姬已经起飞了2017-02-19第六场 lol小智直播，中单剑姬vs飞机，剑姬已经起飞了2017-02-19第六场 lol小智直播，中单剑姬vs飞机，剑姬已经起飞了2017-02-19第六场 lol小智直播，中单剑姬vs飞机，剑姬已经起飞了2017-02-19第六场 lol小智直播，中单剑姬vs飞机，剑姬已经起飞了2017-02-19第六场 lol小智直播，中单剑姬vs飞机，剑姬已经起飞了2017-02-19第六场
						</p>
						<p>
							lol小智直播，中单剑姬vs飞机，剑姬已经起飞了2017-02-19第六场 lol小智直播，中单剑姬vs飞机，剑姬已经起飞了2017-02-19第六场 lol小智直播，中单剑姬vs飞机，剑姬已经起飞了2017-02-19第六场 lol小智直播，中单剑姬vs飞机，剑姬已经起飞了2017-02-19第六场 lol小智直播，中单剑姬vs飞机，剑姬已经起飞了2017-02-19第六场 lol小智直播，中单剑姬vs飞机，剑姬已经起飞了2017-02-19第六场
						</p>
					</div>

					<div class="go_head" id="go_head">
					</div>
				</div>
			</div>

		</div>

		<div class="detail_right fr">

			<div class="recommend mb20">
				<div class="tit"><i></i>相关直播推荐</div>
				<ul class="recommend-list">

					<li>
						<a href="${path}/wechatStatic/pcLive1.do" class="img">
							<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20173617372KKeIVluPeETL0xpLYedYM7praveatX.png@280w" alt="" width="280" height="210"/>
						</a>
						<div class="info">
							<h3><a target="_blank"href="javascript:;">剑圣打野 无形之浪最为致命</a></h3>
							<p title="">lol小智直播</p>
						</div>
					</li>
				</ul>
			</div>
		</div>
	</div>

	<%@include file="/WEB-INF/why/index/index_foot.jsp" %>
	
	<a class="cd-top"><img src="${path}/STATIC/image/hp_toparrow.png" width="40" height="40"/></a>
	<a style="visibility: hidden"><img alt="文化云" src="${path}/STATIC/image/baiduLogo.png" width="121" height="75"/></a>
</body>
</html>

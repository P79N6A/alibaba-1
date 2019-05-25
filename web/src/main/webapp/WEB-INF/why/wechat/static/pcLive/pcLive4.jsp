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
    </script>
</head>

<body class="body">
	<%@include file="/WEB-INF/why/index/index_top.jsp" %>

	<div class="crumb"><i></i>您所在的位置：
		<a href="${path}/frontIndex/index.do">动漫</a> &gt; 逗逼时代 
	</div>

	<div class="detail-content" id="allInfo">
		<div class="detail-left fl">
			<div class="the_one">
				<div class="a_time">
					<div class="time"> <em></em> / 收藏：<span class="likeCount">46</span> / 浏览：<span>667</span></div>
				</div>
				<div class="a_note">
					<div class="title">
						<h1>逗逼时代</h1>
					</div>
					<div class="tag">
	                    <input type="hidden" value="" name="tagIds" id="tagIds">
	                    <div class="tag" id="tag"><a onclick="setTag('cf719729422c497aa92abdd47acdaa56')">动漫</a></div>
	                </div>
					<div class="ad_intro" style="padding-top:2px;">
						<p>逗比时代是四格系列漫画，每一个故事都用轻松幽默剧情，简单可爱的画风，让您在工作生活之余能放松心情感受快乐。</p>
					</div>
					<div class="ad_intro">
						<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201736152838W0jQdAQse47tacglJ2Zi54Ial3V7OJ.jpg@500w">
						<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201736152850TprouxHhHsVwHS0qNrV5hgOBPIx762.jpg@500w">
						<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20173615295KpUfSGC2ugvEZ8fHDvzCwFSTKKjBek.jpg@500w">
						<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017361529209UltzlPremejphYdL6ykfbercYFUrC.jpg@500w">
						<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201736152931xFbamuqcYVojBIheXXLdJtvYzmV8iE.jpg@500w">
					</div>

					<div class="download_fj" activityAttachment="">
					</div>
					<div class="shares">
	                    <div class="share_l fl">
	                        <div class="icon">
				        <span class="bdsharebuttonbox bdshare-button-style0-16" data-bd-bind="1488772070934">
				        	
					        <a class="zan" id="zanId"><span class="likeCount">141</span></a>
					        
						 </span>
	                        </div>
	                    </div>
	                </div>

					<div class="go_head" id="go_head">
					</div>
				</div>
			</div>
		</div>

		<div class="detail_right fr">

			<div class="recommend mb20">
				<div class="tit"><i></i>相关动漫推荐</div>
				<ul class="recommend-list">

					<li>
						<a href="${path}/wechatStatic/pcLive3.do"" class="img">
							<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20173615211gmWmib34h6YhW8iwusk4FzNESocEDl.jpg@280w" alt=""  width="280" height="210"/>
						</a>
						<div class="info">
							<h3><a target="_blank" href="javascript:;">明卡猫</a></h3>
							<p title="">四格动漫</p>
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

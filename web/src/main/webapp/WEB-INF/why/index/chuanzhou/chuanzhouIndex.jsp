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
    request.setAttribute("basePath", basePath);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>文旅资讯</title>
	<link rel="shortcut icon" href="${path}/STATIC/image/favicon.ico" type="image/x-icon"
          mce_href="${path}/STATIC/image/favicon.ico">
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/bpNormalize.css">
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/hsCulture.css">
	<link rel="stylesheet" href="${path}/STATIC/css/owl.carousel.min.css">
    <link rel="stylesheet" href="${path}/STATIC/css/owl.theme.default.min.css">
	<script type="text/javascript" src="${path}/STATIC/js/frontBp/jquery.min.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/frontBp/jquery.SuperSlide.2.1.1.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/frontBp/owl.carousel.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/frontBp/culture.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/frontBp/qiehuan.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/common.js"></script>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/base.js"></script>
    <script  src="${path}/STATIC/js/dialog-min.js"></script>
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
	    	//初始化轮播图
	        showAdvertPicture();
            $("#chuanzhouIndex").addClass('cur').siblings().removeClass('cur');
	        
	    });
	
	    // 显示轮播图
	    function showAdvertPicture() {
	        $.post("${path}/beipiaoInfo/bpCarouselList.do?carouselType=1&version=" + new Date().getTime(), '', function (data) {
	            if (data != undefined && data != null && data != "" && data.length > 0) {
	                getAdvertHtml(data);
	                jQuery(".bpBannerSlide").slide({
	                	mainCell:".bd ul",
	                	titCell:'.hd span',
	                	effect:"left",
	                	autoPlay:true,
	                	interTime:3000,
	                	delayTime:500
	                });
	            } 
	        });
	    }
	
	    // 拼接轮播图
	    function getAdvertHtml(data) {
	    	var imgUrl = "";
	    	var connectUrl = "";
	    	var li = "<ul class='picList'>";
	    	var span = "";
	    	for (var i in data){
	    		imgUrl = data[i].carouselImage;
	    		connectUrl = data[i].carouselUrl.split(',')[0];
	    		li += "<li style='float: left; width: 1200px;'><a target='_blank' href='" + connectUrl + "'><img  src='" + imgUrl + "'width='750' height='400'/></a></li>";
	    		span += "<span></span>";
	    	}
	    	li += "</ul>" 
	    	$("#carousels .bd").html(li);
	    	$("#carousels .hd").html(span);
	    }
    </script>
    <!--移动端版本兼容 end -->
</head>
<body>
<div class="header">
   <!-- 导入头部文件 -->
<%@include file="/WEB-INF/why/index/header.jsp" %>
</div>
<!-- start banner -->
<div class="bpBannerSlide" id ="carousels">
	<div class="bd">
	</div>
	<div class="hd">
	</div>
</div>
	<!-- end banner -->
<!-- 今日佛山 -->
<div class="floor floor1">
	<h1 class="tit clearfix"><span></span><a href="${path}/beipiaoInfo/czfrontindex.do?module=WHZX" class="more">&#43;&nbsp;&nbsp;查看更多</a></h1>
	<ul class="list clearfix">
        <c:forEach items="${jinribeipiaoList }" var="info">
        	<li>
	            <a href="${path}/beipiaoInfo/bpInfoDetail.do?infoId=${info.beipiaoinfoId}" class="img"><img src="${info.beipiaoinfoHomepage }" width="380" height="284"></a>
	            <div class="conp">
	                <h5><a href="${path}/beipiaoInfo/bpInfoDetail.do?infoId=${info.beipiaoinfoId}">${info.beipiaoinfoTitle }</a></h5>
	                <p class="p2">${info.beipiaoinfoContent }</p>
	            </div>
	        </li>
        </c:forEach>
    </ul> 
</div>
<!-- 历史文化 -->
<div class="floor floor2">
	<h1 class="tit clearfix"><span></span><a href="${path}/beipiaoInfo/chuanzhouList.do?infoTagCode=yuanguwenhua" class="more">&#43;&nbsp;&nbsp;查看更多</a></h1>
	<ul class="list clearfix">
		<c:forEach items="${lishiwenhuaList }" var="info">
			<li class="clearfix">
            <a href="${path}/beipiaoInfo/bpInfoDetail.do?infoId=${info.beipiaoinfoId}" class="img"><img src="${info.beipiaoinfoHomepage }" width="280" height="185"></a>
            <div class="conp">
                <h5><a href="${path}/beipiaoInfo/bpInfoDetail.do?infoId=${info.beipiaoinfoId}">${info.beipiaoinfoTitle }</a></h5>
                <p class="p3">${info.beipiaoinfoContent }</p>
            </div>
        </li>
		</c:forEach>
    </ul> 
</div>
<!-- 文化旅游 -->
<div class="floor floor3">
	<h1 class="tit clearfix"><span></span><a href="${path}/beipiaoInfo/chuanzhouList.do?infoTagCode=lvyou1" class="more">&#43;&nbsp;&nbsp;查看更多</a></h1>
	<!-- 轮播图 -->
	<div class="changgOrder owl-carousel">
		<c:forEach items="${wenhualvyouList }" var="info">
			<div class="item">
			<div class="img"><a href="${path}/beipiaoInfo/bpInfoDetail.do?infoId=${info.beipiaoinfoId}" class="img"><img src="${info.beipiaoinfoHomepage }" /></a></div>
			<p>
				<span class="title">${info.beipiaoinfoTitle }</span>
				<span class="info">${info.beipiaoinfoContent }</span>
			</p >
		</div>
		</c:forEach>
		
	</div>
</div>
<!-- 佛山美食 -->
<div class="floor floor4">
	<h1 class="tit clearfix"><span></span><a href="${path}/beipiaoInfo/chuanzhouList.do?infoTagCode=liaoxitewei" class="more">&#43;&nbsp;&nbsp;查看更多</a></h1>
	<ul class="list clearfix">
        <c:forEach items="${chuanzhoumeishiList }" var="info">
        	<li>
            <a href="${path}/beipiaoInfo/bpInfoDetail.do?infoId=${info.beipiaoinfoId}" class="img"><img src="${info.beipiaoinfoHomepage }" width="280" height="185"></a>
            <div class="conp h184">
                <h5><a href="${path}/beipiaoInfo/bpInfoDetail.do?infoId=${info.beipiaoinfoId}">${info.beipiaoinfoTitle }</a></h5>
                <hr class="hr">
                <p class="p3 cof">${info.beipiaoinfoContent }</p>
            </div>
        </li>
        </c:forEach>
    </ul>
</div>
<!-- 文化遗产 -->
<div class="floor floor5">
	<h1 class="tit clearfix"><span></span><a href="${path}/beipiaoInfo/chuanzhouList.do?infoTagCode=wenhuaxinwen" class="more">&#43;&nbsp;&nbsp;查看更多</a></h1>
	<ul class="list clearfix">
		<c:forEach items="${wenhuayichanList }" var="info">
			<li>
            <a href="${path}/beipiaoInfo/bpInfoDetail.do?infoId=${info.beipiaoinfoId}" class="img"><img src="${info.beipiaoinfoHomepage }" width="280" height="185"></a>
            <div class="conp">
                <h5><a href="${path}/beipiaoInfo/bpInfoDetail.do?infoId=${info.beipiaoinfoId}">${info.beipiaoinfoTitle }</a></h5>
                <p class="p3">${info.beipiaoinfoContent }</p>
            </div>
        </li>
		</c:forEach>
    </ul>
</div>
<%@include file="/WEB-INF/why/index/footer.jsp" %>
</body>
</html>
<script type="text/javascript">
	$(function () {
		jQuery(".bpBannerSlide").slide({mainCell:".bd ul",titCell:'.hd span',effect:"left",autoPlay:true,interTime:3000,delayTime:500});
		var owl = $('.changgOrder').owlCarousel({
		  center: true,
		  loop:true,
		  margin:0,
		  nav:true,
		  autoWidth:true,
		  autoplay:true,
		  autoplayTimeout:3000,
		  autoplayHoverPause:true,
		  items:3,
		  dots:false
		});
	});
</script>
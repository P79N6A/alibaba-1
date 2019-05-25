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
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <title>佛山文化云首页</title>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/bpNormalize.css"/>
	<%-- <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/hsCulture.css"/> --%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/styleChild.css"/>
	<link rel="stylesheet" href="${path}/STATIC/css/owl.carousel.min.css"/>
    <link rel="stylesheet" href="${path}/STATIC/css/owl.theme.default.min.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <%-- <script type="text/javascript" src="${path}/STATIC/js/frontBp/jquery.min.js"></script> --%>
    <script type="text/javascript" src="${path}/STATIC/js/frontBp/jquery-1.9.0.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>	
	<script type="text/javascript" src="${path}/STATIC/js/frontBp/jquery.SuperSlide.2.1.1.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/frontBp/owl.carousel.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/frontBp/culture.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/frontBp/qiehuan.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/common.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/base.js"></script>
    <%-- <script type="text/javascript" src="${path}/STATIC/js/index/index/index.js?version=20160507"></script> --%>
    <script src="http://webapi.amap.com/maps?v=1.3&key=a5b9a436f67422826aef2f4cb7e36910&plugin=AMap.AdvancedInfoWindow"></script>
    <style type="text/css">
	html, body {background-color: #f6f6f6;}
	</style>
</head>
<body>
    <!-- 推荐资讯-->
	    <ul class="newsList clearfix" id="tuijianInfoUl">
	    <c:forEach items="${advertList}" var="advert" varStatus="st">
					<li class="clearfix" data-url="${advert.beipiaoinfoHomepage}">
						<a class="xiang clearfix" href="${path}/beipiaoInfo/bpInfoDetail.do?infoId=${advert.beipiaoinfoId}">
							<div class="pic fl"><img src="${advert.beipiaoinfoHomepage}"></div>
							<div class="char fl">
								<div class="titEr"><c:out escapeXml="true" value="${advert.beipiaoinfoTitle}"/></div>
								<div class="wenSan">${advert.beipiaoinfoContent}</div>
							</div>
						</a>
					</li>
		</c:forEach>
		</ul>
    <!-- 推荐资讯end -->
</body>
</html>
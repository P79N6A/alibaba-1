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
    <title>安康文化云首页</title>
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
    <!-- 推荐文化场馆 -->
    <div class="syVenuesList clearfix" id="tuijianVenuesDiv">
				<ul class="venBoxUl fl">
					<c:forEach items="${advertList}" var="advert" varStatus="st" begin="0" end="0">
					<li class="daLi" data-url="${advert.venueIconUrl}">
						<a href="${path}/frontVenue/venueDetail.do?venueId=${advert.venueId}">
							<img class="tup" src="${advert.venueIconUrl}">
							<div class="black">
								<div class="titYi">${advert.venueName}</div>
								<%--<div class="wenYi">地址：${advert.venueAddress}</div>--%>
								<%--<div class="label">--%>
									<%--<span>${advert.actCount}个在线活动</span>--%>
									<%--<span>${advert.roomCount}个活动室</span>--%>
								<%--</div>--%>
							</div>
						</a>
					</li>
					</c:forEach>
				</ul>
				<ul class="venBoxUl fl">
					<c:forEach items="${advertList}" var="advert" varStatus="st" begin="1" end="4">
					<li data-url="${advert.venueIconUrl}">
						<a href="${path}/frontVenue/venueDetail.do?venueId=${advert.venueId}">
							<img class="tup venueImg"  src="">
							<div class="black">
								<div class="titYi1">${advert.venueName}</div>
								<div class="wenYi">
									<img src="${path}/STATIC/image/locationfill.png">
									<span>地址：${advert.venueAddress}</span>
								</div>
								<div class="label">
									<span><b>${advert.actCount}</b>个在线活动</span>
									<span><b>${advert.roomCount}</b>个活动室</span>
								</div>
							</div>
						</a>
					</li>
					</c:forEach>
				</ul>
	</div>
	
	<div id="tuijiansVenue">
      <ul class="list listWenTwo clearfix">
        <c:forEach items="${advertList}" var="advert" varStatus="st">
          <c:if test="${st.index < 5}">
            <li data-url="${advert.venueIconUrl}">
                 <input type="hidden" name="venueIds" value="${advert.venueId}"/>
                    <a href="${path}/frontActivity/frontActivityDetail.do?activityId=${advert.venueId}"
                       class="img"><img src="" width="280" height="185"/></a>
                    <div class="conp">
                        <h5><a
                                href="${path}/frontActivity/frontActivityDetail.do?activityId=${advert.venueId}"><c:out
                                escapeXml="true" value="${advert.venueName}"/></a></h5>
                        <p>${advert.actCount}活动，${advert.roomCount}活动室</p>
                        <p>地点：${venue.venueAddress}</p>
                    </div>
            </li>
           </c:if>
        </c:forEach>
    </ul>
    </div>
    <!-- 推荐文化场馆end -->
</body>
</html>
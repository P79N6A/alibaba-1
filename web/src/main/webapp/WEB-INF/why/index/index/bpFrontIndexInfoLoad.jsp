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
        .zxTab{
            width:100px;
            text-align: center;
            height:50px;
            line-height:50px;
            font-size:18px;
            border-bottom:#c0c0c0;
            float:left;
        }
        .cur{
            border-bottom:1px solid #36c7de;
        }
        .createDiv{
            background: url(/STATIC/image/child/zxBottom.png) no-repeat center ;
        }
	</style>
</head>
<body>
    <!-- 推荐资讯-->
      <div class="newsList0" id="tuijianInfoUl">
          <div class="newsLeft" id="newsLeft">
              <div class="bd">
                  <div class="swiper-container" style="height:500px;" id="swiper1">
                      <div class="swiper-wrapper" >
                          <c:forEach items="${advertList}" begin="0" end="3" step="1" var="advert" varStatus="st">
                              <div class="swiper-slide">
                                  <ul class="clearfix" data-url="${advert.informationIconUrl}">
                                      <li>
                                          <a class="xiang clearfix" href="${path}/zxInformation/informationDetail.do?informationId=${advert.informationId}">
                                              <div class="pic fl"><img class="bigimg" src="${advert.informationIconUrl}"></div>
                                              <div class="char fl">
                                                  <div style="display:inline-block;width:70px;height:70px;font-size:24px;padding:5px;text-align: center">
                                                      <span style="display:inline-block;"><fmt:formatDate value="${advert.informationCreateTime}" pattern="MM-dd "/> </span>
                                                      <span style="display:inline-block;font-size:14px;text-align: right"><fmt:formatDate value="${advert.informationCreateTime}" pattern="yyyy"/> </span>
                                                  </div>
                                                  <div class="titEr" style="width:450px;height:50px;line-height:25px;overflow:hidden;word-break:break-all;display:inline-block;margin-left:20px;font-size:16px">
                                                      <c:out escapeXml="true" value="${advert.informationTitle}"/>
                                                  </div>
                                              </div>
                                          </a>
                                      </li>
                                  </ul>
                              </div>
                          </c:forEach>
                      </div>
                      <div class="swiper-pagination"></div>
                  </div>
                  <%--<c:forEach items="${advertList}" begin="0" end="2" step="1" var="advert" varStatus="st">
                      <ul class="clearfix" data-url="${advert.informationIconUrl}">
                          <li>
                              <a class="xiang clearfix" href="${path}/zxInformation/informationDetail.do?informationId=${advert.informationId}">
                                  <div class="pic fl"><img class="bigimg" src="${advert.informationIconUrl}"></div>
                                  <div class="char fl">
                                      <div style="display:inline-block;width:70px;height:70px;font-size:24px;padding:5px;text-align: center">
                                          <span style="display:inline-block;"><fmt:formatDate value="${advert.informationCreateTime}" pattern="MM-dd "/> </span>
                                          <span style="display:inline-block;font-size:14px;text-align: right"><fmt:formatDate value="${advert.informationCreateTime}" pattern="yyyy"/> </span>
                                      </div>
                                      <div class="titEr" style="width:450px;height:50px;line-height:25px;overflow:hidden;word-break:break-all;display:inline-block;margin-left:20px;font-size:16px">
                                          <c:out escapeXml="true" value="${advert.informationTitle}"/>
                                      </div>
                                  </div>
                              </a>
                          </li>

                      </ul>
                  </c:forEach>--%>
              </div>
          </div>

          <div class="newsright">
              <%--<div class="zxMenu" style="height:50px;">
                  <div class="zxTab activeTab">通知公告</div>
                  <div class="zxTab">本市资讯</div>
                  <div class="zxTab">辽宁沿海经济带</div>
              </div>--%>
              <c:forEach items="${advertList}" begin="0" end="3" step="1" var="advert" varStatus="st">
                  <div class="clearfix newsItem" data-url="${advert.informationIconUrl}">
                      <a class="xiang clearfix" href="${path}/zxInformation/informationDetail.do?informationId=${advert.informationId}">
                          <div class="newNum">
                              <span ><fmt:formatDate value="${advert.informationCreateTime}" pattern="MM-dd "/> </span>
                              <span style="font-size:14px;text-align: right"><fmt:formatDate value="${advert.informationCreateTime}" pattern="yyyy"/> </span>
                          </div>
                          <div class="newsInfo">
                              <p class="newsTitle">
                                      ${advert.informationTitle}
                              </p>
                              <p class="newsContent">
                                      ${advert.brief}
                              </p>
                          </div>
                      </a>
                  </div>
              </c:forEach>
          </div>
          <%--<div style="display:inline-block;width:30px;margin-left:10px;height:400px;">
              <div>
                   <img src="${path}/STATIC/image/zx1.png"/>
              </div>
              <div>
                  <img src="${path}/STATIC/image/zx2.png"/>
              </div>
          </div>--%>

      </div>

    <!-- 推荐资讯end -->
</body>
</html>
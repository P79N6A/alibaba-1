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
	<title>安康文化云</title>
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
		html, body {background-color: #f6f6f6}
	</style>
</head>
<body>
<!-- 最新文化活动 -->
<!-- <div class="syListWcAll" id="trainNewDiv"> -->
<div class="syVenuesList clearfix" id="trainNewUl">
	<c:set var="nowDate" value="<%=System.currentTimeMillis()%>"></c:set>
	<ul class="venBoxUl fl">
		<c:forEach items="${trainList}" begin="0" end="0" step="1" var="train" varStatus="st">
			<li class="daLi" data-url="${train.trainImgUrl}">
				<a href="${path}/cmsTrain/trainDetail.do?id=${train.id}">
					<img class="tup" src="">
					<div class="black">
						<div class="titYi">${train.trainTitle}</div>
					</div>
				</a>
			</li>
		</c:forEach>
	</ul>
	<ul class="venBoxUl fl">
		<c:forEach items="${trainList}" begin="1" end="4" step="1" var="train" varStatus="st">
			<li data-url="${train.trainImgUrl}">
				<a href="${path}/cmsTrain/trainDetail.do?id=${train.id}">
					<img class="tup venueImg"  src="">
					<div class="black1">
						<div class="titYi">${train.trainTitle}</div>
					</div>
					<c:if test="${train.trainStatus==1}">
						<c:choose>
							<c:when test="${nowDate-train.endTime.time < 0}">
								<c:choose>
									<c:when test="${train.peopleCount} < ${train.maxPeople}">
										<div class="trainStatu">
											即将开始
										</div>
									</c:when>
									<c:otherwise>
										<div class="trainStatu " style="background-color: #c0c0c0">报名人数已满</div>
									</c:otherwise>
								</c:choose>
							</c:when>
							<c:otherwise>
								<div class="done1 trainStatu" style="background-color: #c0c0c0">已结束</div>
							</c:otherwise>
						</c:choose>
					</c:if>
					<%--<div class="trainStatu">
                       即将开始
					</div>--%>
					<div class="black">
						<div class="titYi2">${train.trainTitle}</div>
						<div class="titYi3">地址：${train.trainAddress}</div>
						<div class="titYi3">时间：${train.trainStartTime} 至 ${train.trainEndTime}</div>
						<%--<div class="titYi3">
							这是一个测试详情,这是一个测试详情,这是一个测试详情,
							这是一个测试详情,这是一个测试详情
						</div>--%>
						<%--<div class="wenYi">
							&lt;%&ndash;<img src="${path}/STATIC/image/locationfill.png">&ndash;%&gt;
							<span>时间：${advert.venueAddress}</span>
							<span>地址：${advert.venueAddress}</span>
						</div>--%>
						<%--<div class="label">
							<span><b>${advert.actCount}</b>个在线活动</span>
							<span><b>${advert.roomCount}</b>个活动室</span>
						</div>--%>
					</div>
				</a>
			</li>
		</c:forEach>
	</ul>
	<%--<c:forEach items="${trainList}" var="train" varStatus="st">
		<li data-url="${train.trainImgUrl}">
			<a class="mhActDivLink" href="${path}/cmsTrain/trainDetail.do?id=${train.id}">
				<div class="pic">
					<img src="" alt="" width="285" height="190">
					&lt;%&ndash;<c:if test="${train.trainIsReservation==2}">
						<div class="ding">订</div>
					</c:if>&ndash;%&gt;
				</div>
				<div class="char">
					<div class="titEr">${train.trainTitle}</div>
					<div class="wenYi">地点：${train.trainAddress}</div>
					<div class="wenYi">时间：${train.trainStartTime} 至 ${train.trainEndTime}
						&lt;%&ndash;<c:if test="${train.trainStartTime != train.trainEndTime&&not empty train.trainEndTime}">
							</c:if></div>&ndash;%&gt;
					<!-- 预订-->
					<div style="border-top:1px dashed #e5e5e5;height:80px;margin-top:20px">
						<c:if test="${train.trainStatus==1}">

									<c:choose>
										<c:when test="${nowDate-train.endTime.time < 0}">
											<c:choose>
												<c:when test="${train.peopleCount} < ${train.maxPeople}">
													<div class="ydBtn">我要报名</div>
												</c:when>
												<c:otherwise>
													<div class="ydBtn done">报名人数已满</div>
												</c:otherwise>
											</c:choose>
										</c:when>
										<c:otherwise>
											<div class="ydBtn done">已结束</div>
										</c:otherwise>
									</c:choose>
								&lt;%&ndash;</c:otherwise>
							</c:choose>&ndash;%&gt;
						</c:if>
					</div>
			</a>
		</li>
	</c:forEach>--%>
</div>
<!-- 最新文化活动end -->


</body>
</html>
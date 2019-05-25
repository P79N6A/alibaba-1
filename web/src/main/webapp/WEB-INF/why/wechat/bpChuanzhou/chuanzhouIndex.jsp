<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

	<head>
		<title>动态资讯</title>
		<%@include file="/WEB-INF/why/wechat/commonFrame.jsp" %>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="format-detection" content="telephone=no" />
		<meta name="apple-mobile-web-app-capable" content="yes" />
		<meta name="apple-mobile-web-app-status-bar-style" content="black" />
		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/normalize.css?v=20170223">
		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/hsStyle.css" />
		<%--<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/bpColorCtrl.css">--%>
		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/swiper-3.3.1.min.css">
		<script type="text/javascript" src="${path}/STATIC/js/jquery-2.1.4.min.js"></script>
		<script type="text/javascript" src="${path}/STATIC/js/swiper-3.3.1.jquery.min.js"></script>

		<script type="text/javascript">
			$(function() {

				var mySwiper3 = new Swiper('.swiper-container3', {
					freeMode: false,
					autoplay: 3000,
					loop: true,
					pagination: '.swiper-pagination'
				})
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
		</style>
	</head>

	<body>
		<div class="main">
			<div class="content padding-bottom0">
				<!-- 广告位 -->
				<div class="recommendDiv">
					<div class="indexBanner" style="position: relative;overflow:hidden;">
						<div class="swiper-container3 swiper-container-horizontal">
							<div id="indexBannerList" class="swiper-wrapper">
								<c:forEach items="${resultList }" var="carousel">
									<div class="swiper-slide"><a href="${carousel.carouselUrl.split(',')[1]}"><img src="${carousel.carouselImage}" width="750" height="250"></a></div>
								</c:forEach>
							</div>
							<div id="swiperPage" class="swiper-pagination"></div>

						</div>
					</div>
				</div>
				<!-- 人文佛山菜单 -->
				<div class="bpRwczMenu">
					<table>
						<tbody>
							<tr>
								<td rowspan="2" style="background-color: #e86d6d;">
									<a href="${path}/wechatChuanzhou/chuanzhouList.do?infoTagCode=zuixinzixun">
										<img src="${path}/STATIC/wechat/image/jinribeipiao.png" />
									</a>
								</td>
								<td style="background-color: #2eb4db;">
									<a href="${path}/wechatChuanzhou/chuanzhouList.do?infoTagCode=yuanguwenhua">
										<img src="${path}/STATIC/wechat/image/lishiwenhua.png" />
									</a>
								</td>
								<td style="background-color: #87cb9f;">
									<a href="${path}/wechatChuanzhou/chuanzhouList.do?infoTagCode=lvyou1">
										<img src="${path}/STATIC/wechat/image/wenhualvyou.png" />
									</a>
								</td>
							</tr>
							<tr>
								<td style="background-color: #c587cb;">
									<a href="${path}/wechatChuanzhou/chuanzhouList.do?infoTagCode=liaoxitewei">
										<img src="${path}/STATIC/wechat/image/chuanzhoumeishi.png" />
									</a>
								</td>
								<td style="background-color: #e8aa6d;">
									<a href="${path}/wechatChuanzhou/chuanzhouList.do?infoTagCode=wenhuaxinwen">
										<img src="${path}/STATIC/wechat/image/wenhuayichan.png" />
									</a>
								</td>
							</tr>
						</tbody>
					</table>
				</div>

				<div class="active" style="margin-top: 0px;">
					<ul id="index_list" class="activeUl">
						<c:forEach items="${bpInfoListNum1 }" var="bpInfo">
							<li>
								<a href="${path}/wechatChuanzhou/chuanzhouDetail.do?infoId=${bpInfo.beipiaoinfoId }" >
									<div class="activeList"><img src="${bpInfo.beipiaoinfoHomepage }" width="750" height="500" style="display: block;">
										<div class="${bpInfo.beipiaoinfoTag }">${bpInfo.parentTagInfo }</div>
									</div>
								</a>
								<p class="activeTitle">${bpInfo.beipiaoinfoTitle }</p>
							</li>
						</c:forEach>
					</ul>
				</div>
			</div>

		</div>
	</body>

</html>
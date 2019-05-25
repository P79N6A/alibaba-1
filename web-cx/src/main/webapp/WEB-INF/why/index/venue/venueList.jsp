<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<title>文化场馆</title>
	<meta name="description" content="登录文化云，5500余场优质场地免费预订，22万场文化活动随心参与，万家文化团队轻松加入，体验您身边的品质文化生活，尽在文化云！">
	<meta name="Keywords" content="文化云、上海市场馆、附近场馆、活动、场馆、免费场地、文化活动、文化场馆、场馆预订、预订活动、预订场馆、群艺馆、博物馆、美术馆、陈列馆、消、展览、演出、讲座、活动、旅行">
	<%@include file="/WEB-INF/why/common/frontIndexPageFrame.jsp"%>
	 <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/hsCulture.css"/>
	<script type="text/javascript" src="${path}/STATIC/js/index/venue/venueListFront.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/frontBp/culture.js"></script>
	<script type="text/javascript">
		$(function () {
			loadArea();
		})
	
		//加载区域
	    function loadArea(){
			var provinceNo = '${provinceNo}';
	   	 	var cityNo = '${cityNo}';
			var loc = new Location();
			var area = loc.find('0,' + provinceNo);
	        $.each(area , function(k , v) {
	        	if(k == cityNo){
	            	$('#areaUl').append("<li class='cur'><a onclick='clickArea(\"\");'>"+v+"</a></li>");
	        	}
			});
	        area = loc.find('0,' + provinceNo + ',' + cityNo);
	        $.each(area , function(k , v) {
	            $('#areaUl').append("<li><a onclick='clickArea(\""+k+"\");'>"+v+"</a></li>");
			});
		}
	    /* function loadArea(){
			var provinceNo = '${provinceNo}';
	   	 	var cityNo = '${cityNo}';
            clickArea(cityNo);
			
		} */
	
		$('#venueIndex').parent().addClass("h_nav");
	</script>
</head>
<body>
<!-- 导入头部文件 -->
	<div class="header">
	<%@include file="../header.jsp" %>
	</div>

<%-- <div id="venue_banner">
	<div class="venue_banner">
		<ul class="in-ban-img">
			<li><a href="#"><img src="${path}/STATIC/image/zlist_03_img.jpg" alt="" width="1200" height="530"/></a></li>
			<li><a href="#"><img src="${path}/STATIC/image/zlist_03_img.jpg" alt="" width="1200" height="530"/></a></li>
			<li><a href="#"><img src="${path}/STATIC/image/zlist_03_img.jpg" alt="" width="1200" height="530"/></a></li>
			<li><a href="#"><img src="${path}/STATIC/image/zlist_03_img.jpg" alt="" width="1200" height="530"/></a></li>
			<li><a href="#"><img src="${path}/STATIC/image/zlist_03_img.jpg" alt="" width="1200" height="530"/></a></li>
		</ul>
		<ul class="in-ban-icon"></ul>
	</div>
	<script type="text/javascript">
		/*SuperSlide图片切换*/
		jQuery(".venue_banner").slide({ titCell:".in-ban-icon", mainCell:".in-ban-img",effect:"fold", autoPlay:true, autoPage:true, delayTime:600, trigger:"click"});
	</script>
</div> --%>

<input type="hidden" name="venueMood" id="venueLocation" value="" />
<input type="hidden" id="keywordVal" value="${keyword}"/>
<input type="hidden" name="areaCode" id="areaCode" />


<div id="search" class="venues-search">
	<div class="search">
		<div class="prop-attrs">
			<div class="attr">
				<div class="attrKey">区域</div>
				<div class="attrValue">
					<ul class="av-expand" id="areaUl"></ul>
				</div>
			</div>
		</div>
		<div class="hot-attrs" id="businessDiv" style="display: none">
			<div class="attr">
				<div class="attrKey" style="background:none;"></div>
				<div class="attrValue">
					<ul class="av-expand" id="businessUl"></ul>
				</div>
			</div>
		</div>
		<div class="prop-attrs" style="display: none;">
			<div class="attr">
				<div class="attrKey">类型</div>
				<div class="attrValue" id="tag-div">
					<ul class="av-collapse">
						<li class="cur"><a href="javascript:;" data-option="" onclick="clickVenueType(this)">全部</a></li>
						<c:forEach items="${typeList}" varStatus="s" var="c">
							<li><a href="javascript:;" data-option="${c.tagId}" onclick="clickVenueType(this)">${c.tagName}</a></li>
						</c:forEach>
					</ul>
					<c:if test="${fn:length(typeList) gt 8}">
						<a  class="av-more"><b></b>展开</a>
					</c:if>
				</div>
			</div>
		</div>
		<div class="prop-attrs" style="display: none;">
			<div class="attr" id="reserve-div">
				<div class="attrKey">状态</div>
				<div class="attrValue search_last">
					<ul class="av-collapse">
						<li class="cur"><a href="javascript:;" data-option="" onclick="clickStatus(this)">全部</a></li>
						<li><a href="javascript:;" data-option="2" onclick="clickStatus(this)">可预订</a></li>
					</ul>
				</div>
			</div>
		</div>
	</div>
	<%--<div class="search-btn">
		<input type="button" value="搜索" onclick="searchVenueList(1)"/>
	</div>--%>
	<div class="advanced">
		<div class="attr-extra">更多选项<b></b></div>
	</div>
</div>

<div id="venue_content">

</div>

<input type="hidden" id="reqPage"  value="1">

<%@include file="/WEB-INF/why/index/footer.jsp" %>
<%-- <a style="visibility: hidden"><img alt="文化云"src="${path}/STATIC/image/baiduLogo.png" width="121" height="75" /></a> --%>
</body>
</html>
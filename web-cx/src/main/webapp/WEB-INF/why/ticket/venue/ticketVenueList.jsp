<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<title>取票机--活动列表--文化云</title>
	<%@include file="/WEB-INF/why/common/ticketFrame.jsp"%>

	<script type="text/javascript" src="${path}/STATIC/js/ticket/venue/ticketVenueList.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/ticket/venue/ticketVenueSelectedLabel.js"></script>
	<script type="text/javascript">
		$(function(){
			$(".search-menu .icon").each(function(){
				if($(this).hasClass("cur")) {
					var thisHoverImgUrl = $(this).find("img").attr("data-hover");
					$(this).find("img").attr("src", thisHoverImgUrl);
				}
			});
			$(".search-menu").on("click", ".icon", function(){
				$(".search-menu .icon").each(function(){
					if($(this).hasClass("cur")) {
						var thisImgUrl = $(this).find("img").attr("data-img");
						$(this).find("img").attr("src", thisImgUrl);
					}
				});
				var $this = $(this);
				/*if(!$this.hasClass("cur")){*/
					var $img = $this.find("img");
					var imgUrl = $img.attr("src");
					var hoverImgUrl = $img.attr("data-hover");
					$this.addClass("cur").siblings().removeClass("cur");
					$img.attr("src", hoverImgUrl);
			/*	}*/
			});
		});
	</script>
</head>
<body style="background: #eef4f7;">
<input type = "hidden" name="venueMood" id="venueLocation" value="" />
<input type="hidden" name="venueArea" id="areaCode" />
<input type="hidden" name="venueType" id="venueType" />
<%--导航--%>
<%@include file="../ticket-nav.jsp"%>
<%--场馆内容页--%>
<div class="venue_list_content ticket-activity-list">
	<div id="search" class="activity-search venue-search">
		<div class="search-menu" id="type-div">
			<a class="icon cur" href="javascript:;" data-id="" onclick="setValueById('venueType','')">
				<img src="${path}/STATIC/image/search-icon1.png" data-img="${path}/STATIC/image/search-icon1.png" data-hover="${path}/STATIC/image/search-icon1a.png"/>
				<span>全 部</span>
			</a>
			<c:forEach items="${typeList}" var="c">
				<a class="icon" href="javascript:;" data-id="${c.tagId}" onclick="setValueById('venueType','${c.tagId}')">
					<%--<img imgPath="${c.tagImageUrl}"/>--%>
					<%--<img src="${path}/STATIC/image/search-icon1.png" data-img="${path}/STATIC/image/search-icon1.png" data-hover="${path}/STATIC/image/search-icon1a.png"/>--%>
					<c:choose>
						<c:when test="${c.tagName == '文化馆'}">
							<img src="${path}/STATIC/image/search-icon6.png" data-img="${path}/STATIC/image/search-icon6.png" data-hover="${path}/STATIC/image/search-icon6a.png"/>
						</c:when>
						<c:when test="${c.tagName == '美术馆'}">
							<img src="${path}/STATIC/image/search-icon7.png" data-img="${path}/STATIC/image/search-icon7.png" data-hover="${path}/STATIC/image/search-icon7a.png"/>
						</c:when>
						<c:when test="${c.tagName == '图书馆'}">
							<img src="${path}/STATIC/image/search-icon8.png" data-img="${path}/STATIC/image/search-icon8.png" data-hover="${path}/STATIC/image/search-icon8a.png"/>
						</c:when>
						<c:when test="${c.tagName == '博物馆'}">
							<img src="${path}/STATIC/image/search-icon9.png" data-img="${path}/STATIC/image/search-icon9.png" data-hover="${path}/STATIC/image/search-icon9a.png"/>
						</c:when>
						<c:when test="${c.tagName == '陈列馆'}">
							<img src="${path}/STATIC/image/search-icon10.png" data-img="${path}/STATIC/image/search-icon10.png" data-hover="${path}/STATIC/image/search-icon10a.png"/>
						</c:when>

						<c:when test="${c.tagName == '艺术馆'}">
							<img src="${path}/STATIC/image/search-icon11.png" data-img="${path}/STATIC/image/search-icon11.png" data-hover="${path}/STATIC/image/search-icon11a.png"/>
						</c:when>

						<c:when test="${c.tagName == '科技馆'}">
							<img src="${path}/STATIC/image/search-icon12.png" data-img="${path}/STATIC/image/search-icon12.png" data-hover="${path}/STATIC/image/search-icon12a.png"/>
						</c:when>

						<c:otherwise>
							<img src="${path}/STATIC/image/search-icon1.png" data-img="${path}/STATIC/image/search-icon1.png" data-hover="${path}/STATIC/image/search-icon1a.png"/>
						</c:otherwise>
					</c:choose>
					<span>${c.tagName}</span>
				</a>
			</c:forEach>
		</div>
		<div class="search">
			<div class="prop-attrs">
				<div class="attr">
					<div class="attrKey">区域</div>
					<div class="attrValue">
						<ul class="av-expand">
							<li class="cur"><a onclick="clickArea('');">上海市</a></li>
							<li ><a onclick="clickArea('46');">黄浦区</a></li>
							<li><a onclick="clickArea('48');">徐汇区</a></li>
							<li><a onclick="clickArea('50');">静安区</a></li>
							<li><a onclick="clickArea('49');">长宁区</a></li>
							<li><a onclick="clickArea('51');">普陀区</a></li>
							<li><a onclick="clickArea('52');">闸北区</a></li>
							<li><a onclick="clickArea('53');">虹口区</a></li>
							<li><a onclick="clickArea('54');">杨浦区</a></li>
							<li><a onclick="clickArea('58');">浦东新区</a></li>
							<li><a onclick="clickArea('56');">宝山区</a></li>
							<li><a onclick="clickArea('57');">嘉定区</a></li>
							<li><a onclick="clickArea('60');">松江区</a></li>
							<li><a onclick="clickArea('61');">青浦区</a></li>
							<li><a onclick="clickArea('55');">闵行区</a></li>
							<li><a onclick="clickArea('59');">金山区</a></li>
							<li><a onclick="clickArea('63');">奉贤区</a></li>
							<li><a onclick="clickArea('64');">崇明县</a></li>
						</ul>
					</div>
				</div>
			</div>
			<div class="prop-attrs hot-attrs" id="businessDiv" style="display: none;">
				<div class="attr">
					<div class="attrKey" style="background:none;"></div>
					<div class="attrValue">
						<ul class="av-expand" id="businessUl"></ul>
					</div>
				</div>
			</div>
		</div>
		<%--<div class="search-btn">
			<input type="button" value="搜索" onclick="searchVenueList(1)"/>
		</div>--%>
	</div>
	<%--场馆列表数据--%>
	<div id="venue_content"></div>
	<input type="hidden" id="reqPage"  value="1">
</div>

<script type="text/javascript">
	/*星星个数*/
	$(function(){
		function starts(obj,n){
			for(i=0;i<obj.length;i++){
				var num=parseInt($(obj[i]).attr("tip"));
				var width=num*n;
				$(obj[i]).children("p").css("width",width);
			}
		}
		starts($(".start"),18);
	})
</script>

</body>
</html>
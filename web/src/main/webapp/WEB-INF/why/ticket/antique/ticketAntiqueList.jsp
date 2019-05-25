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
	<title>取票机--藏品列表--文化云</title>
	<%@include file="/WEB-INF/why/common/ticketFrame.jsp"%>
	<script type="text/javascript" src="${path}/STATIC/js/ticket/antique/ticketAntiqueList.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/ticket/venue/ticketVenueSelectedLabel.js"></script>
	<script type="text/javascript">
		$(function(){
			var venueId = $("#venueId").val();
			$.post("${path}/antiqueType/getTypeList.do", {'venueId' : venueId},
					function(data) {
						if (data != '' && data != null) {
							var list = eval(data);
							var ulHtml='<li class="cur"><a href="javascript:; " data-option="">全部</a></li>';
							for (var i in data) {
								var dict = list[i];
								ulHtml += '<li><a href="javascript:;" data-option="'+dict.antiqueTypeId+'">'
								+ dict.antiqueTypeName + '</a></li>';
							}
							$('#tagTypeUl').html(ulHtml);
						}
					});
		});
	</script>
</head>
<body style="background: #eef4f7;">

<%--导航--%>
<%@include file="../ticket-nav.jsp"%>

<input type="hidden" id="venueId" value="${cmsVenue.venueId}"/>
<div class="venue_list_content ticket-activity-list ticket-collect-list">
	<div id="search" class="activity-search">
		<div class="search">
			<div class="prop-attrs">
				<div class="attr">
					<div class="attrKey">类别</div>
					<div class="attrValue">
						<ul class="av-expand" id="tagTypeUl">
						</ul>
					</div>
				</div>
			</div>
			<%--<div class="prop-attrs">
				<div class="attr">
					<div class="attrKey">区域</div>
					<div class="attrValue">
						<ul class="av-expand">
							<li><a>上海市</a></li>
							<li class="cur"><a>黄浦区</a></li>
							<li><a>徐汇区</a></li>
							<li><a>静安区</a></li>
							<li><a>长宁区</a></li>
							<li><a>普陀区</a></li>
							<li><a>闸北区</a></li>
							<li><a>虹口区</a></li>
							<li><a>浦东区</a></li>
							<li><a>宝山区</a></li>
							<li><a>嘉定区</a></li>
							<li><a>松江区</a></li>
							<li><a>青浦区</a></li>
							<li><a>闵行区</a></li>
							<li><a>金山区</a></li>
							<li><a>奉贤区</a></li>
							<li><a>崇明县</a></li>
						</ul>
					</div>
				</div>
			</div>
			<div class="prop-attrs hot-attrs" id="businessDiv">
				<div class="attr">
					<div class="attrKey" style="background:none;"></div>
					<div class="attrValue">
						<ul class="av-expand" id="businessUl">
							<li class="cur"><a href="#">全部</a></li>
							<li><a href="#">瑞金宾馆</a></li>
							<li><a href="#">新天地</a></li>
							<li><a href="#">打浦桥</a></li>
							<li><a href="#">淮海路</a></li>
							<li><a href="#">董家渡</a></li>
							<li><a href="#">老西门</a></li>
							<li><a href="#">城隍庙</a></li>
							<li><a href="#">南京路</a></li>
							<li><a href="#">人民广场</a></li>
							<li><a href="#">外滩</a></li>
						</ul>
					</div>
				</div>
			</div>--%>
		</div>
		<div class="search-btn">
			<input type="button" value="搜索" id="antiqueClick"/>
		</div>
	</div>
	<div id="activty_content">

	</div>
	<input type="hidden" id="reqPage"  value="1">
</div>

</body>
</html>
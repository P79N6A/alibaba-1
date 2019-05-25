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
	<title>藏品--文化云</title>

	<%@include file="../../common/frontPageFrame.jsp"%>
	<script type="text/javascript" src="${path}/STATIC/js/index/antique/antiqueListFront.js"></script>
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
<body>
<%@include file="../index_top.jsp"%>

<div class="crumb">您所在的位置：<a href="${path}/frontVenue/venueIndex.do">场馆</a>&gt; <a href="${path}/frontVenue/venueDetail.do?venueId=${cmsVenue.venueId}">${cmsVenue.venueName}&gt; <a href="${path}/frontAntique/antiqueList.do?venueId=${cmsVenue.venueId}">藏品列表</a></div>
<input type="hidden" id="venueId" value="${cmsVenue.venueId}"/>
<div class="venue_list_content">
	<div id="search" class="venues-search">
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
			<div class="prop-attrs">
				<div class="attr">
					<div class="attrKey">朝代</div>
					<div class="attrValue" id="dict-div">
						<ul class="av-expand" >
							<li <c:if test="${empty dynasty || dynasty eq null}"> class="cur" </c:if>><a href="javascript:;" data-option="">全部</a></li>
							<c:forEach items="${dictList}" varStatus="s" var="c">
								<li><a href="javascript:;" data-option="${c.dictId}">${c.dictName}</a></li>
							</c:forEach>
						</ul>
					</div>
				</div>
			</div>
			<div class="search-btn">
				<input type="button" value="搜索" id="antiqueClick"/>
			</div>
		</div>
	</div>
</div>
<div class="in-part3 activity-content" id="activty_content">

</div>
<input type="hidden" id="reqPage"  value="1">

<%@include file="../index_below.jsp"%>

</body>
</html>
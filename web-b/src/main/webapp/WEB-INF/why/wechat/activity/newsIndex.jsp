<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<c:if test="${empty dataList}">
    <input type="hidden" id="newsNoData" value="1"/>
</c:if>

<c:forEach items="${dataList}" var="t">
    <li class="border-bottom" onclick="window.location.href='${path}/frontNews/detail.do?dataId=${t.newsId}'">
		<div class="live-1">
			<div class="live-left">
				<img data-src="${t.newsImgUrl}" width='230' height='150'/>
			</div>
			<div style="margin-left: 10px;" class="live-left">
				<p class="p1">${t.newsTitle}</p>
				<p class="p2">${t.newsDesc}</p>
			</div>
			<div style="clear: both;"></div>
		</div>
	</li>
</c:forEach>


<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ page import="java.util.Date"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    String path = request.getContextPath();
    request.setAttribute("path", path);
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>
<script>
$(function () {
	
});

</script>
<c:if test="${empty assnList}">
	 <div class="sort-box search-result">
        <div class="no-result">
            <h2>抱歉，没有找到符合条件的结果</h2>
            <h4>您可以修改搜索条件重新尝试</h4>
        </div>
    </div>
</c:if> 
<c:if test="${not empty assnList}">
<div class="qyListWrap">
			<ul class="clearfix">
			<c:forEach items="${assnList}" var="c">
				<li class="qyItem" onclick="toAssnDetail('${c.assnId}')">				
					<div class="img">
						<c:if test="${c.recruitStatus==1 }">
						<img src="${path}/STATIC/image/zhaomu.png" style="position:absolute;left:10px;top:0px;z-index:1;"/>
						</c:if>
						<img class="assn" src="${c.assnImgUrl }" width="280" height="185">
						<div class="flower">${c.flowerCount+c.assnFlowerInit}</div>
					</div>
					<div class="qyInfo">
						<p class="name">${c.assnName }</p>
						<div class="tagWrap">
						<c:set value="${ fn:split(c.assnTag, ',') }" var="tags" />
						<c:forEach items="${ tags }" var="tag">
						<span>${tag }</span>
						</c:forEach>
						</div>
						<p class="info">${c.assnIntroduce }</p>
					</div>
				</li>
				</c:forEach>					
			</ul>
		</div>
	</div>
	<div id="kkpager" width:750px;margin:10 auto;></div>
    <input type="hidden" id="pages" value="${page.page}">
    <input type="hidden" id="countpage" value="${page.countPage}">
    <input type="hidden" id="total" value="${page.total}">
</c:if>
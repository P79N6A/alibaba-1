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
<div id="picDiv">
	<ul class="clearfix" id="assnImgUl">
		<c:forEach items="${resList}" var="c">
			<li>
				<div class="img"><img src="${c.assnResUrl}" width="240px" height="155px"></div>
			</li>				
		</c:forEach>					
	</ul>
	<div id="kkpager" width:750px;margin:10 auto;></div>
    <input type="hidden" id="pages" value="${page.page}">
    <input type="hidden" id="countpage" value="${page.countPage}">
    <input type="hidden" id="total" value="${page.total}">
</div>
<div id="videoDiv">
	<ul class="clearfix" id="assnVideoUl">
		<c:forEach items="${resList}" var="c">
			<li>
				<div class="img"><video src="${c.assnResUrl}" width="240px" height="155px" poster="${c.assnResCover}" controls/></div>
				<div class="stName">${c.assnResName}</div>
			</li>				
		</c:forEach>					
	</ul>
	<div id="kkpager" width:750px;margin:10 auto;></div>
    <input type="hidden" id="pages" value="${page.page}">
    <input type="hidden" id="countpage" value="${page.countPage}">
    <input type="hidden" id="total" value="${page.total}">	
</div>
<div id="hisActDiv">
	<ul class="clearfix" id="assnHisActUl">
		<c:forEach items="${actList}" var="c">
			<li data-url="${c.activityIconUrl}" onclick="toAssnHisAct('${c.activityId}')">
				<div class="img"><img src="" width="240px" height="155px" /></div>
				<div class="stName">${c.activityName}</div>
			</li>				
		</c:forEach>					
	</ul>
	<div id="kkpager" width:750px;margin:10 auto;></div>
    <input type="hidden" id="pages" value="${page.page}">
    <input type="hidden" id="countpage" value="${page.countPage}">
    <input type="hidden" id="total" value="${page.total}">
	
</div>
			
	
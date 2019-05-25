<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java"  pageEncoding="UTF-8"%>

<%
  String path = request.getContextPath();
  request.setAttribute("path", path);
  String basePath = request.getScheme() + "://"
          + request.getServerName() + ":" + request.getServerPort()
          + path + "/";
%>
<%--<script>
	$(function(){
		var list = '${activityList}';
		if(list.length==2){
			$("#search").hide();
		}else{
			$("#search").show();
		}
	});
</script>--%>
<!-- 未搜到内容时 -->
  <c:if test="${empty activityList }">
	<div class="null_result">
        <div class="cont">
            <h2>抱歉，没有找到相关结果</h2>
            <p>您可以修改搜索条件重新尝试</p>
        </div>
    </div>
    <div class="in-part3 activity-content">
	    <div id="data-ul">
	        <h2 class="search-other">其他人都在搜</h2>
	        <ul class="activity_ul">
		        <c:forEach items="${activityListOther}" var="activity" >
		        <li data-li-url="${activity.activityIconUrl}">
		        <a href="${path}/frontActivity/frontActivityDetail.do?activityId=${activity.activityId}" title="${activity.activityName}"
				   class="img" target="_blank">
		        <img src="${activity.activityIconUrl}" onload="fixImage(this, 280, 187)"/>
		        </a>
		        <div class="info">
			        <h1 title="${activity.activityName}">
			        <a href="${path}/frontActivity/frontActivityDetail.do?activityId=${activity.activityId}" target="_blank">
			          <c:out escapeXml="true" value="${activity.activityName}"/>
			        </a>
			        </h1>
			        <div class="text">
						<c:set var="activityAddress" value="${activity.activityAddress}"/>
						<p title="<%--${fn:split(activity.activityCity, ',')[1]}&nbsp;<c:if test="${fn:split(activity.activityArea, ',')[1] != fn:split(activity.activityCity, ',')[1]}">${fn:split(activity.activityArea, ',')[1]}&nbsp;</c:if>--%><c:out value="${activityAddress}" escapeXml="true"/>">
							<a title="<%--${fn:split(activity.activityCity, ',')[1]}&nbsp;<c:if test="${fn:split(activity.activityArea, ',')[1] != fn:split(activity.activityCity, ',')[1]}">${fn:split(activity.activityArea, ',')[1]}&nbsp;</c:if>--%><c:out value="${fn:substring(activityAddress,0,10)}" escapeXml="true"/>">
								<%--${fn:split(activity.activityCity, ',')[1]}&nbsp;<c:if test="${fn:split(activity.activityArea, ',')[1] != fn:split(activity.activityCity, ',')[1]}">${fn:split(activity.activityArea, ',')[1]}&nbsp;</c:if>--%><c:out value="${fn:substring(activityAddress,0,10)}" escapeXml="true"/>
							</a>
				        </p>
				        <%--<p>时间：${activity.activityStartTime}<c:if test="${not empty activity.activityEndTime && activity.activityStartTime != activity.activityEndTime}">&nbsp;至&nbsp;${activity.activityEndTime}</c:if></p>--%>
						<p>时间：
							<fmt:parseDate value="${activity.activityStartTime}" pattern="yyyy-MM-dd" var="startTime"/>
							<fmt:parseDate value="${activity.activityEndTime}" pattern="yyyy-MM-dd" var="endTime"/>
							<fmt:formatDate value="${startTime}" pattern="yyyy-MM-dd"/>
							<c:if test="${startTime eq endTime}"></c:if>
							<c:if test="${not empty endTime && startTime != endTime}" >
								至 <fmt:formatDate value="${endTime}" pattern="yyyy-MM-dd"/>&nbsp;
							</c:if>
						</p>
						<p>
						<!-- 
				        	<c:if test="${activity.activityIsReservation==2}" >
								<c:if test="${empty activity.sysNo || '0' eq activity.sysNo}">
									余票：
						                <span class="red">
							                <c:if test="${empty activity.activityReservationCount}"> 0</c:if>
							                <c:if test="${not empty activity.activityReservationCount}"> ${activity.activityReservationCount}</c:if>
						                </span>
									张
								</c:if>
					        </c:if>
					         -->
				        </p>
			        </div>
			        <div class="number">
			        	<span class="heart"><i></i>${activity.collectNum}<%--<label id="${activity.activityId}" mid="${activity.activityId}"></label>--%></span>
		        		<span class="view"><i></i><c:if test="${empty activity.yearBrowseCount}">0</c:if><c:if test="${not empty activity.yearBrowseCount}">${activity.yearBrowseCount}</c:if></span>
			        </div>
		        </div>
		        </li>
		        </c:forEach>
		      </ul>
	    </div>
	</div>
  </c:if>

  <c:if test="${not empty activityList }">
	  <div class="in-part3 activity-content" id="loadListIdDiv">
	    <div id="data-ul">
	      <c:if test="${not empty searchList}" >
	      	<h2 style="color: #4a4a4a;"> 为您搜索到<span class="red"> ${page.total} </span>条相关的结果</h2>
	      </c:if>
	      <ul class="activity_ul">
	        <c:forEach items="${activityList}" var="activity" >
				<c:if test="${not empty activity.sysNo and not empty activity.sysId}" >
					<input name="sysId" type="hidden" value="${activity.sysId}" />
				</c:if>
	        <li data-li-url="${activity.activityIconUrl}">
	        <a href="${path}/frontActivity/frontActivityDetail.do?activityId=${activity.activityId}" class="img"
			   title="${activity.activityName}" target="_blank">
	        <img src="${activity.activityIconUrl}" onload="fixImage(this, 280, 187)"/>
	        </a>
	        <div class="info">
		        <h1 title="${activity.activityName}">
		        <a href="${path}/frontActivity/frontActivityDetail.do?activityId=${activity.activityId}" target="_blank">
		          <c:out escapeXml="true" value="${activity.activityName}"/>
		        </a>
		        </h1>
		        <div class="text">
					<c:set var="activityAddress" value="${activity.activityAddress}"/>
					<p title="${fn:split(activity.activityCity, ',')[1]}&nbsp;<c:if test="${fn:split(activity.activityArea, ',')[1] != fn:split(activity.activityCity, ',')[1]}">${fn:split(activity.activityArea, ',')[1]}&nbsp;</c:if><c:out value="${activityAddress}" escapeXml="true"/>">
						地址：
						<c:out value="${fn:substring(activityAddress,0,10)}" escapeXml="true"/>
			        </p>
			        <%--<p>时间：${activity.activityStartTime}<c:if test="${not empty activity.activityEndTime && activity.activityStartTime != activity.activityEndTime}">&nbsp;至&nbsp;${activity.activityEndTime}</c:if>--%>
					<p>时间：
						<fmt:parseDate value="${activity.activityStartTime}" pattern="yyyy-MM-dd" var="startTime"/>
						<fmt:parseDate value="${activity.activityEndTime}" pattern="yyyy-MM-dd" var="endTime"/>
						<fmt:formatDate value="${startTime}" pattern="yyyy-MM-dd"/>
						<c:if test="${startTime eq endTime}"></c:if>
						<c:if test="${not empty endTime && startTime != endTime}" >
							至 <fmt:formatDate value="${endTime}" pattern="yyyy-MM-dd"/>&nbsp;
						</c:if>
					</p>
			        <p>
			        <!--  
						<c:if test="${activity.activityIsReservation==2}" >
							<c:if test="${empty activity.sysNo || '0' eq activity.sysNo || '1' eq activity.sysNo}">
								余票：
						                <span class="red" id="${activity.sysId}">
							                <c:if test="${empty activity.activityReservationCount}"> <label id="${activity.sysId}">0</label></c:if>
							                <c:if test="${not empty activity.activityReservationCount}"> <label id="${activity.sysId}">${activity.activityReservationCount}</label></c:if>
						                </span>
								张
							</c:if>
						</c:if>
-->
					</p>
		        </div>
		        <div class="number">
		        	<span class="heart"><i></i>${activity.collectNum}<%--<label id="${activity.activityId}" mid="${activity.activityId}"></label>--%></span>
	        		<span class="view"><i></i><c:if test="${empty activity.yearBrowseCount}">0</c:if><c:if test="${not empty activity.yearBrowseCount}">${activity.yearBrowseCount}</c:if></span>
		        </div>
	        </div>
	        </li>
	        </c:forEach>
	      </ul>
	      <c:if test="${fn:length(activityList) gt 0}">
	        <div id="kkpager" width:750px;margin:10 auto;></div>
	        <input type="hidden" id="pages" value="${page.page}">
	        <input type="hidden" id="countpage" value="${page.countPage}">
	        <input type="hidden" id="total" value="${page.total}">
	
	      </c:if>
	    </div>
	  </div>
 </c:if>

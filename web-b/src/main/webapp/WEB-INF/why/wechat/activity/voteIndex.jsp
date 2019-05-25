<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<%String path = request.getContextPath();request.getSession().setAttribute("path", path);%>
<c:if test="${empty list}">
  <input type="hidden" id="voteNoData"  value="1"/>
</c:if>

<c:if test="${null != list}">
	<c:forEach items="${list}" var="dataList">
		<li class="p3-video-right" onclick="window.location.href='${path}/frontVote/detail.do?dataId=${dataList.voteId}'">
			<div class="p3-video-1">
				<img data-src="${dataList.voteCoverImgUrl}" width='230' height='150'/>
				<label>${dataList.voteTitel}</label>
				<div style="clear: both;"></div>
			</div>
		</li>
	</c:forEach>
</c:if>

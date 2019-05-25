<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<%
  String path = request.getContextPath();
  request.setAttribute("path", path);
  String basePath = request.getScheme() + "://"
          + request.getServerName() + ":" + request.getServerPort()
          + path + "/";
%>
<div class="collection_manage">
  <ul id="venueUl" class="venue_ul">
    <c:forEach items="${venueList}" var="venue">
      <li data-icon-url="${venue.venueIconUrl}">
        <a class="img " href="${path}/frontVenue/venueDetail.do?venueId=${venue.venueId}"><img width="250" height="168"/></a>
        <div class="info ">
          <h1><a href="${path}/frontVenue/venueDetail.do?venueId=${venue.venueId}">${venue.venueName}</a></h1>
          <div class="start" tip="${venue.venueStars}"><p></p></div>
          <div class="text"><p class="site">地址：${fn:substringAfter(venue.venueCity, ',')}&nbsp;${fn:substringAfter(venue.venueArea, ',')}&nbsp;${venue.venueAddress}</p>
            <p>
              <c:choose>
                <c:when test="${venue.venueHasMetro == 2 && venue.venueHasBus == 2 }"><span>交通:</span>地铁、公交</c:when>
                <c:when test="${venue.venueHasMetro == 2 && venue.venueHasBus == 1}"><span>交通:</span>地铁</c:when>
                <c:when test="${venue.venueHasMetro == 1 && venue.venueHasBus == 2}"><span>交通:</span>公交</c:when>
                <c:otherwise></c:otherwise>
              </c:choose>
            </p>
          </div>
        </div>
        <a class="del-btn" onclick="deleteCollectVenue('${venue.venueId}')"></a>
      </li>
    </c:forEach>
  </ul>
  <c:if test="${empty venueList}">
      <div class="null_info">
        <h3>没有收藏的场馆，<a href="${path}/frontVenue/venueList.do">去看看</a></h3>
      </div>
  </c:if>
  <%--动态取值分页--%>
  <c:if test="${fn:length(venueList) gt 0}">
    <div id="kkpager" width:750px;margin:10 auto;></div>
    <input type="hidden" id="pages" value="${page.page}">
    <input type="hidden" id="countPage" value="${page.countPage}">
    <input type="hidden" id="total" value="${page.total}">
    <input type="hidden" id="reqPage"  value="1">
  </c:if>
</div>
<script type="text/javascript">
  /*星星个数*/
  $(function(){
    function starts(obj,n){
      for(i=0;i<obj.length;i++){
        var num=parseFloat($(obj[i]).attr("tip"));
        var width=num*n;
        $(obj[i]).children("p").css("width",width);
      }
    }
    starts($(".start"),18);
  })
</script>
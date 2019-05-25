<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
    String path = request.getContextPath();
    request.setAttribute("path", path);
    String basePath = request.getScheme() + "://"
        + request.getServerName() + ":" + request.getServerPort()
        + path + "/";
%>

<c:if test="${empty venueList}">
    <div class="sort-box search-result">
        <div class="no-result">
            <h2 id="tip1">抱歉，没有找到符合条件的结果</h2>
            <h4>您可以修改搜索条件重新尝试</h4>
        </div>
    </div>
</c:if>

<c:if test="${not empty venueList}">
    <ul id="venue-list-ul" class="venue_ul clearfix">
        <c:forEach items="${venueList}" varStatus="s" var="c">


            <li data-id="${c.venueIconUrl}">
                <c:if test="${c.venueIsReserve == 2}">
                    <div class="order">订</div>
                </c:if>

                <a href="${path}/ticketVenue/venueDetail.do?venueId=${c.venueId}" class="img fl">
                    <img onload="fixImage(this, 280, 187)"/>
                </a>
                <div class="info fr">
                    <h1><a href="${path}/ticketVenue/venueDetail.do?venueId=${c.venueId}"><c:out escapeXml="true" value="${c.venueName}"/></a></h1>
                   <!-- <div class="start" tip="${c.venueStars}"><p></p></div> --> 
                    <p class="site" title="${fn:substringAfter(c.venueCity, ',')}&nbsp;${fn:substringAfter(c.venueArea, ',')}&nbsp;<c:out escapeXml='true' value='${c.venueAddress}'/>"><span>地址:</span>${fn:substringAfter(c.venueCity, ',')}&nbsp;${fn:substringAfter(c.venueArea, ',')}&nbsp;<c:out escapeXml="true" value="${c.venueAddress}"/></p>
                    <p>
                        <c:choose>
                            <c:when test="${c.venueHasMetro == 2 && c.venueHasBus == 2 }"><span>交通:</span>地铁、公交</c:when>
                            <c:when test="${c.venueHasMetro == 2 && c.venueHasBus == 1}"><span>交通:</span>地铁</c:when>
                            <c:when test="${c.venueHasMetro == 1 && c.venueHasBus == 2}"><span>交通:</span>公交</c:when>
                            <c:otherwise></c:otherwise>
                        </c:choose>
                    </p>
                </div>
            </li>
        </c:forEach>
    </ul>

    <div id="kkpager" width:750px;margin:10 auto;></div>
    <input type="hidden" id="pages" value="${page.page}">
    <input type="hidden" id="countpage" value="${page.countPage}">
    <input type="hidden" id="total" value="${page.total}">
</c:if>

<!--  <script type="text/javascript">
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
</script>-->
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
        <h2 id="tip2">抱歉，没有找到符合“<span class="red" id="searchTip"></span>”的结果</h2>
        <h4>您可以修改搜索条件重新尝试</h4>
    </div>
</div>
</c:if>

<c:if test="${not empty venueList}">
<div style="display: none;">
    <div class="clearfix" id="recordResultDiv1"> 共为您搜索到<span style="color:red;" id="recordSize1"></span>条相关结果</div>
    <div class="clearfix" id="recordResultDiv2"> 共为您搜索到<span class="red" id="recordSize2"></span>条<span class="red" id="searchContent"></span>相关结果</div>
</div>

    <ul id="venue-list-ul" class="venue_ul clearfix">
        <c:forEach items="${venueList}" var="c">
            <li data-id="${c.venueIconUrl}">
                <c:if test="${c.venueIsReserve == 2}">
                    <div class="order">订</div>
                </c:if>

                <a href="${path}/venue/${c.venueId}/detail.html" class="img" target="_blank">
                    <img onload="fixImage(this, 280, 187)"/>
                </a>
                <div class="info">
                    <h1><a target="_blank" href="${path}/venue/${c.venueId}/detail.html"><c:out escapeXml="true" value="${c.venueName}"/></a></h1>
                    <div class="start" tip="${c.venueStars}"><p></p></div>
                    <div class="text">
                    <p title="${fn:substringAfter(c.venueCity, ',')}&nbsp;${fn:substringAfter(c.venueArea, ',')}&nbsp;<c:out escapeXml='true' value='${c.venueAddress}'/>"><span>地址:</span>${fn:substringAfter(c.venueCity, ',')}&nbsp;${fn:substringAfter(c.venueArea, ',')}&nbsp;<c:out escapeXml="true" value="${c.venueAddress}"/></p>
                    <p>
                        <c:choose>
                            <c:when test="${c.venueHasMetro == 2 && c.venueHasBus == 2 }"><span>交通:</span>地铁、公交</c:when>
                            <c:when test="${c.venueHasMetro == 2 && c.venueHasBus == 1}"><span>交通:</span>地铁</c:when>
                            <c:when test="${c.venueHasMetro == 1 && c.venueHasBus == 2}"><span>交通:</span>公交</c:when>
                            <c:otherwise></c:otherwise>
                        </c:choose>
                    </p>
                    </div>
                </div>
            </li>
        </c:forEach>
    </ul>

    <div id="kkpager" width:750px;margin:10 auto;></div>
    <input type="hidden" id="pages" value="${page.page}">
    <input type="hidden" id="countpage" value="${page.countPage}">
    <input type="hidden" id="total" value="${page.total}">
</c:if>

<script type="text/javascript">
    var venueName =  $("#searchVal").val();
    if($.trim(venueName)==""){
        $("#tip2").css("display","none");
    }else{
        $("#searchTip").html(venueName.replace(/</g,'&lt;').replace(/>/g,'&gt;'));
        $("#tip1").css("display","none");
    }

    var totalSize = $("#total").val();
    if(totalSize == undefined){
        $("#recordSize1").html(0);
        $("#recordSize2").html(0);
    }else{
        $("#recordSize1").html(totalSize);
        $("#recordSize2").html(totalSize);
    }

    if($.trim(venueName)==""){
        $("#recordResultDiv2").css("display","none");
        $("#recordResultDiv1").css("display","block");
    }else{
        $("#searchContent").html(venueName);
        $("#recordResultDiv1").css("display","none");
        $("#recordResultDiv2").css("display","block");
    }

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
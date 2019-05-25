<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<style type="text/css">
    .hl_list .fire {
        float: right;
        position: relative;
        padding-right: 18px;
        margin-right: 10px;
    }
    .hl_list .fire span {
        display: block;
        float: left;
        width: 20px;
        height: 28px;
        background: url(${path}/STATIC/wechat/image/fire.png) no-repeat center;
        background-size: 12px auto;
    }
    .hl_list .fire:before {
        content: '';
        display: block;
        width: 1px;
        height: 14px;
        background-color: #a3a3a3;
        position: absolute;
        right: 0;
        top: 50%;
        margin-top: -7px;
    }
    .hl_list .zan {
        float: right;
        font-size: 14px;
        color: #c99228;
        line-height: 28px;
        height: 28px;
        overflow: hidden;
        padding: 0 5px 0 25px;
        background: url(${path}/STATIC/wechat/image/zan-fen.png) no-repeat;
        background-size: 50px auto;
        background-position: -14px -62px;
    }


</style>
<%
    String path = request.getContextPath();
    request.setAttribute("path", path);
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>
<c:if test="${empty infoList}">
<div class="sort-box search-result">
    <div class="no-result">
        <h2 id="tip1">抱歉，没有找到符合条件的结果</h2>
        <h2 id="tip2">抱歉，没有找到符合“<span class="red" id="searchTip"></span>”的结果</h2>
        <h4>您可以修改搜索条件重新尝试</h4>
    </div>
</div>
</c:if>

<c:if test="${not empty infoList}">
<!-- <div style="display: none;">
    <div class="clearfix" id="recordResultDiv1"> 共为您搜索到<span style="color:red;" id="recordSize1"></span>条相关结果</div>
    <div class="clearfix" id="recordResultDiv2"> 共为您搜索到<span class="red" id="recordSize2"></span>条<span class="red" id="searchContent"></span>相关结果</div>
</div> -->

    <ul id="venue-list-ul" class="hl_list clearfix">
        <c:forEach items="${infoList}" var="c">
            <li data-id="${c.beipiaoinfoHomepage}">
				<div class="info img">
				<c:if test="${c.beipiaoinfoIsTop==1 }">
				<div style="position:absolute;left:0;top:0;z-index:1;background-color:#a09ee0;font-size:14px;color:#fff;padding:3px 5px;">置顶</div>
				</c:if>				
				<%-- <c:choose>
				       <c:when test="${c.beipiaoinfoShowtype=='1'}">
			              <a href="javascript:void(0)" class="img" target="_blank">
			              	<video src="${c.beipiaoinfoVideo}" width="280" height="185"></video>
               			   </a>
				       </c:when>
				       <c:otherwise>
				       		<a href="${path}/beipiaoInfo/bpInfoDetail.do?infoId=${c.beipiaoinfoId}" class="img" target="_blank">
				              <img src="${c.beipiaoinfoHomepage}" width="280" height="185">
                			</a>
				       </c:otherwise>
				</c:choose> --%>
                <a href="${path}/beipiaoInfo/bpInfoDetail.do?infoId=${c.beipiaoinfoId}&module=${module}" class="img" target="_blank">
                    <!-- <img onload="fixImage(this, 280, 187)"/> -->
                    <c:choose>
				       <c:when test="${c.beipiaoinfoShowtype=='1' || c.beipiaoinfoShowtype=='3'}">
				              <img src="${c.beipiaoinfoHomepage}" width="280" height="185">
				              <%--<div class="video"></div>--%>
				       </c:when>
				       
				       <c:otherwise>
                    		<img src="${c.beipiaoinfoHomepage}" width="280" height="185">
				       </c:otherwise>
				</c:choose>
                </a>
                </div>
                <div class="intro">
                    <h3 style="padding-bottom: 6px;"><a target="_blank" href="${path}/beipiaoInfo/bpInfoDetail.do?infoId=${c.beipiaoinfoId}&module=${module}"><c:out escapeXml="true" value="${c.beipiaoinfoTitle}"/></a></h3>
                    <%-- <p title="<c:out escapeXml='true' value='${c.beipiaoinfoTitle}'/>"><span></span><c:out escapeXml="true" value="${c.beipiaoinfoTitle}"/></p> --%>
                    <p title="${c.beipiaoinfoContent}">
                    <c:choose>
                    <c:when test="${fn:length(c.beipiaoinfoContent)>40}">
                    	${fn:substring(c.beipiaoinfoContent,0,40)}...
                    </c:when>
                    <c:otherwise>
                    ${c.beipiaoinfoContent}
                    </c:otherwise>
                        
                    </c:choose>
                    </p>
                    <div class="clearfix">
                        <div class="zan">${c.userWantGo}</div>
                        <div class="fire clearfix">
                            <c:if test="${c.userWantGo < 10}"><span></span></c:if>
                            <c:if test="${c.userWantGo >= 10 && c.userWantGo < 50}"><span></span><span></span></c:if>
                            <c:if test="${c.userWantGo >= 50}"><span></span><span></span><span></span></c:if>
                        </div>
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

</script>
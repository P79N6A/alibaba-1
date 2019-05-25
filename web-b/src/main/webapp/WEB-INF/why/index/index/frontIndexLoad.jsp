<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java" pageEncoding="UTF-8" %>

<%
    String path = request.getContextPath();
    request.setAttribute("path", path);
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>


<!-- 周末去哪儿 begin -->
<div class="con_p1 clearfix" id="weekEndActivityDivChild">
    <div class="titl clearfix"><img src="${path}/STATIC/image/hl3.png"/>周末去哪儿</div>
    <ul class="clearfix">
        <c:forEach items="${advertList}" var="activity">
            <li data-url="${activity.activityIconUrl}">
                <a href="${path}/frontActivity/frontActivityDetail.do?activityId=${activity.activityId}"
                   class="img"><img src="" width="280" height="185"/></a>
                <div class="conp">
                    <h5>${activity.activityName}</h5>
                    <p>时间：${activity.activityStartTime}<c:if
                            test="${not empty activity.activityEndTime && activity.activityStartTime != activity.activityEndTime}">&nbsp;至&nbsp;${activity.activityEndTime}</c:if></p>
                    </p>
                    <p>地点：
                        <c:set var="activitySite" value="${activity.activitySite}"/>
                        <c:out value="${fn:substring(activitySite,0,35)}"/>
                        <c:if test="${fn:length(activitySite) > 35}">...</c:if></p>
                </div>
            </li>
        </c:forEach>
    </ul>
</div>
<!-- 周末去哪儿 end -->

<%--热门场馆 begin--%>

<div id="recommendVenueChild">
    <div class="con_p1 clearfix">
        <div class="titl clearfix"><img src="${path}/STATIC/image/hl2.png"/>热门场馆</div>
        <ul class="clearfix">
            <c:forEach items="${advertVenueList}" var="venue" varStatus="status">
                <li data-url="${venue.venueIconUrl}" class="h285">
                    <a href="${path}/venue/${venue.venueId}/detail.html"
                       class="img"><img src="" width="280" height="185"/></a>
                    <div class="conp h100">
                        <h5>${venue.venueName}</h5>
                        <p>地点：${venue.venueAddress}</p>
                    </div>
                </li>
            </c:forEach>
        </ul>
    </div>
</div>
<%--热门场馆 end--%>

<!-- 本周活动 -->
<div id="weekActivitysChild">
    <div class="ti_nav clearfix">
        <div class="ti fl"><img src="${path}/STATIC/image/hl1.png" width="20" height="20"/>本周活动</div>
        <div class="navs fl clearfix">
            <c:forEach items="${thisWeekActivityList}" var="map" varStatus="st">
                <c:if test="${st.index==0}">
                    <a href="javascript:void(0)" tip="#for_1" class="curblue">今天</a>
                </c:if>
                <c:if test="${st.index==1}">
                    <a href="javascript:void(0)" tip="#for_2">明天</a>
                </c:if>
                <c:if test="${st.index!=0 && st.index!=1}">
                    <a href="javascript:void(0)" tip="#for_${st.index+1}">${map.key}</a>
                </c:if>
            </c:forEach>
        </div>
    </div>
    <!--ul start-->
    <!--list start-->
    <div>
        <c:forEach items="${thisWeekActivityList}" var="map" varStatus="st">
            <ul class="clearfix" id="for_${st.index+1}" <c:if test="${st.index != 0}">style="display:none;"</c:if>>
                <c:choose>
                    <c:when test="${not empty map.value}">
                        <c:forEach items="${map.value}" var="activity" varStatus="sta">
                            <c:if test="${sta.index < 4}">
                                <li data-url="${activity.activityIconUrl}">
                                    <a href="${path}/activity/${activity.activityId}/detail.html"
                                       class="img"><img src="" width="280" height="185"/></a>
                                    <div class="conp">
                                        <h5 href="${path}/activity/${activity.activityId}/detail.html">
                                            <c:out escapeXml='true' value='${activity.activityName}'/></h5>
                                        <p>时间：${activity.activityStartTime}<c:if
                                                test="${activity.activityStartTime != activity.activityEndTime&&not empty activity.activityEndTime}">
                                            至 ${activity.activityEndTime}</c:if></p>
                                        <p>${fn:substringAfter(activity.activityCity, ',')}&nbsp;&nbsp;${fn:substringAfter(activity.activityArea, ',')}</p>
                                    </div>
                                </li>
                            </c:if>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="txt_tip"
                             style="width:1200px; height:255px ;margin:0 auto; margin-top:90px; text-align:center; color:#817C7C; font-size:24px;">
                            今天没有活动哟，看看其他活动吧！
                        </div>

                    </c:otherwise>
                </c:choose>
            </ul>
        </c:forEach>
    </div>
    <!--list end-->
</div>
<!-- 本周活动 end-->


<!-- 最新活动 -->
<div id="newActivitysChild">
    <div class="titl clearfix"><img src="${path}/STATIC/image/hl4.png"/>最新活动</div>
    <ul class="clearfix">
        <c:forEach items="${advertList}" var="activity" varStatus="st">
            <c:if test="${st.index < 4}">
                <li data-url="${activity.activityIconUrl}">
                    <input type="hidden" name="activityIds" value="${activity.activityId}"/>
                    <a href="${path}/frontActivity/frontActivityDetail.do?activityId=${activity.activityId}"
                       class="img"><img src="" width="280" height="185"/></a>
                    <div class="conp">
                        <h5><a
                                href="${path}/activity/${activity.activityId}/detail.html"><c:out
                                escapeXml="true" value="${activity.activityName}"/></a></h5>
                        <p>时间：${activity.activityStartTime}<c:if
                                test="${activity.activityStartTime != activity.activityEndTime&&not empty activity.activityEndTime}">
                            至 ${activity.activityEndTime}</c:if></p>
                        <p>地点：<c:set var="activitySite" value="${activity.activitySite}"/>
                            <c:out value="${fn:substring(activitySite,0,35)}"/>
                            <c:if test="${fn:length(activitySite) > 35}">...</c:if></p>
                    </div>
                </li>
            </c:if>
        </c:forEach>
    </ul>
</div>
<!-- 最新活动 end-->
<!-- 首页推荐 -->
<div class="in-hot" id="hotelRecommendDivChild">
    <ul>

        <c:forEach items="${advertList}" var="advert" varStatus="status">
            <c:if test="${status.index == 0 or status.index == 3 or status.index == 6}">
                <li>
            </c:if>
            <div class="hot_con">
                <a target="_blank" href="${path}/frontActivity/frontActivityDetail.do?activityId=${advert.activityId}" class="img fl"
                   data-url="${advert.activityIconUrl}"><img src="${path}/STATIC/image/in-hot-img.jpg" height="86"
                                                          width="135" alt=""></a>
                <div class="info fr">
                    <h3><a target="_blank" href="${advert.activityIconUrl}"><c:out escapeXml='true'
                                                                                    value='${advert.activityName}'/></a>
                    </h3>
                    <p>地址：${advert.activitySite}</p>
                    <p>时间：${advert.activityStartTime}<c:if
                            test="${not empty advert.activityEndTime && advert.activityStartTime != advert.activityEndTime}">&nbsp;至&nbsp;
                        ${advert.activityEndTime}</c:if></p>
                </div>
            </div>
            <c:if test="${status.index == 2 or status.index == 5 or status.index == 8}">
                </li>
            </c:if>
        </c:forEach>

    </ul>
</div>
<!-- 首页推荐 end -->
<%--<!-- 热点推荐 -->--%>
<%--<div id="recommendActivitysChild">--%>
<%--<div class="in-content in-part1 clearfix">--%>
<%--<div class="in-tit">--%>
<%--<span class="in-hot fl"><i></i>热点推荐</span>--%>
<%--<div class="in-hot-search fr">--%>
<%--<input type="text" name="activityName"--%>
<%--id="activityName" onblur="toSearchPage()" onfocus="clearData()"--%>
<%--onkeydown="if(window.event.keyCode==13){ toSearchPage(); return false; }"--%>
<%--<c:if test="${empty activityName}"> value="请输入关键字" </c:if> <c:if--%>
<%--test="${not empty activityName}"> value="${activityName}" </c:if> data-val="请输入关键字"--%>
<%--class="input-text"/>--%>
<%--</div>--%>
<%--</div>--%>
<%--<div class="in-hotList">--%>
<%--<ul>--%>
<%--<c:forEach items="${recommendActivity}" var="activity">--%>
<%--<li activity-icon-url="${activity.activityIconUrl}">--%>
<%--<input type="hidden" name="activityIds" value="${activity.activityId}"/>--%>
<%--<img src="${activity.activityIconUrl}" onload="fixImage(this, 216, 216)"/>--%>
<%--<div class="shade"></div>--%>
<%--<a href="${path}/frontActivity/frontActivityDetail.do?activityId=${activity.activityId}"--%>
<%--class="txt">--%>
<%--<h3> ${activity.activityStartTime}<br/><c:out escapeXml="true"--%>
<%--value="${activity.activityName}"/><br/></h3>--%>
<%--<span class="heart"><i></i><label id="recommend_${activity.activityId}"--%>
<%--tid="${activity.activityId}"></label></span>--%>
<%--</a>--%>
<%--</li>--%>
<%--</c:forEach>--%>
<%--</ul>--%>
<%--</div>--%>
<%--</div>--%>
<%--</div>--%>
<%--<!-- 热点推荐 end -->--%>


<%--<!-- 你可能喜欢的 -->--%>
<%--<div id="likeActivitysChild">--%>
<%--<div class="in-content in-part2 clearfix">--%>
<%--<div class="in-tit">--%>
<%--<span class="in-love fl"><i></i>你可能喜欢的</span>--%>
<%--</div>--%>
<%--<div class="in-loveList">--%>
<%--<ul>--%>
<%--<c:forEach items="${likeActivity}" var="activity">--%>
<%--<li activity-icon-url="${activity.activityIconUrl}">--%>
<%--<a href="${path}/frontActivity/frontActivityDetail.do?activityId=${activity.activityId}"--%>
<%--class="img fl"><img src="" onload="fixImage(this, 120, 120)"/></a>--%>
<%--<div class="info fr">--%>
<%--<span></span>--%>
<%--<h3 style="height: 56px;"><a--%>
<%--href="${path}/frontActivity/frontActivityDetail.do?activityId=${activity.activityId}"><c:out--%>
<%--escapeXml="true" value="${activity.activityName}"/></a></h3>--%>
<%--<p>地址：--%>
<%--<c:set var="activityAddress" value="${activity.activityAddress}"/>--%>
<%--<c:out value="${fn:substring(activityAddress,0,8)}" escapeXml="true"/>--%>
<%--<c:if test="${fn:length(activityAddress) > 8}">...</c:if>--%>
<%--</p>--%>
<%--<p>时间：${activity.activityStartTime}<c:if--%>
<%--test="${activity.activityStartTime != activity.activityEndTime&&not empty activity.activityEndTime}}">--%>
<%--至 ${activity.activityEndTime}</c:if></p>--%>
<%--</div>--%>
<%--</li>--%>
<%--</c:forEach>--%>
<%--</ul>--%>
<%--</div>--%>
<%--</div>--%>
<%--</div>--%>
<%--<!-- 你可能喜欢的 end -->--%>


<%--<!-- 即将开始活动 begin -->--%>
<%--<div id="willStartActivityDivChild">--%>
<%--<div class="in-tit in-tit2"><i></i><span>即将开始</span></div>--%>
<%--<div class="in-begin">--%>
<%--<ul>--%>
<%--<c:forEach var="activity" items="${willStartActivityList}">--%>
<%--<li data-url="${activity.activityIconUrl}">--%>
<%--<a class="img" href="${path}/frontActivity/frontActivityDetail.do?activityId=${activity.activityId}"--%>
<%--target="_blank">--%>
<%--<img onload="fixImage(this, 224, 168)"/>--%>
<%--<div class="info">--%>
<%--<p title="${activity.activityAddress}">地点：${activity.activityAddress}</p>--%>
<%--<p>时间：${activity.activityStartTime}<c:if--%>
<%--test="${not empty activity.activityEndTime && activity.activityStartTime != activity.activityEndTime}">&nbsp;至&nbsp;${activity.activityEndTime}</c:if></p>--%>
<%--</div>--%>
<%--</a>--%>
<%--<h3>--%>
<%--<a href="${path}/frontActivity/frontActivityDetail.do?activityId=${activity.activityId}"--%>
<%--title="<c:out escapeXml='true' value='${activity.activityName}'/>" target="_blank"><c:out--%>
<%--escapeXml="true" value="${activity.activityName}"/></a></h3>--%>
<%--</li>--%>
<%--</c:forEach>--%>
<%--</ul>--%>
<%--</div>--%>
<%--</div>--%>
<%--<!-- 即将开始活动 end -->--%>

<%--&lt;%&ndash;本周活动 beign&ndash;%&gt;--%>
<%--<div id="thisWeekActivityDivChild">--%>
<%--<div class="tab-name">--%>
<%--<ul>--%>
<%--<c:forEach items="${thisWeekActivityList}" var="map" varStatus="st">--%>
<%--<c:if test="${st.index==0}">--%>
<%--<li>今天</li>--%>
<%--</c:if>--%>
<%--<c:if test="${st.index==1}">--%>
<%--<li>明天</li>--%>
<%--</c:if>--%>
<%--<c:if test="${st.index!=0 && st.index!=1}">--%>
<%--<li>${map.key}</li>--%>
<%--</c:if>--%>
<%--</c:forEach>--%>
<%--</ul>--%>
<%--</div>--%>
<%--<div class="tab-cont">--%>
<%--<c:forEach items="${thisWeekActivityList}" var="map">--%>
<%--<ul class="tab-week">--%>
<%--<c:choose>--%>
<%--<c:when test="${not empty map.value}">--%>
<%--<c:forEach items="${map.value}" var="activity">--%>
<%--<li data-url="${activity.activityIconUrl}">--%>
<%--<a href="${path}/frontActivity/frontActivityDetail.do?activityId=${activity.activityId}"--%>
<%--class="img" target="_blank"><img onload="fixImage(this, 133, 99)"/></a>--%>
<%--<h3>--%>
<%--<a href="${path}/frontActivity/frontActivityDetail.do?activityId=${activity.activityId}"--%>
<%--title="<c:out escapeXml='true' value='${activity.activityName}'/>"--%>
<%--target="_blank"><c:out escapeXml='true' value='${activity.activityName}'/></a>--%>
<%--</h3>--%>
<%--<p>${fn:substringAfter(activity.activityCity, ',')}&nbsp;&nbsp;${fn:substringAfter(activity.activityArea, ',')}</p>--%>
<%--</li>--%>
<%--</c:forEach>--%>
<%--</c:when>--%>
<%--<c:otherwise>--%>
<%--<li class="null-info">--%>
<%--今天没有活动哟，看看其他活动吧！--%>
<%--</li>--%>
<%--</c:otherwise>--%>
<%--</c:choose>--%>
<%--</ul>--%>
<%--</c:forEach>--%>
<%--</div>--%>
<%--</div>--%>
<%--&lt;%&ndash;本周活动 end&ndash;%&gt;--%>

<%--&lt;%&ndash;猜你喜欢的活动 begin&ndash;%&gt;--%>
<%--<div class="in-interest" id="mayLikeActivityDivChild">--%>
<%--<div class="in-tit in-tit7"><i></i><span>猜你喜欢</span></div>--%>
<%--<ul class="list">--%>
<%--<c:forEach items="${mayLikeActivityList}" var="activity" varStatus="status">--%>
<%--<li data-url="${activity.activityIconUrl}" <c:if test="${status.index == 0}">class="on"</c:if>>--%>
<%--<a class="img" href="${path}/frontActivity/frontActivityDetail.do?activityId=${activity.activityId}"--%>
<%--target="_blank"><img onload="fixImage(this, 280, 210)"/></a>--%>
<%--<h3><a href="${path}/frontActivity/frontActivityDetail.do?activityId=${activity.activityId}"--%>
<%--title="<c:out escapeXml='true' value='${activity.activityName}'/>" target="_blank"><c:out--%>
<%--escapeXml='true' value='${activity.activityName}'/></a></h3>--%>
<%--<p title="${activity.activityAddress}">地址：${activity.activityAddress}</p>--%>
<%--<p>时间：${activity.activityStartTime}<c:if--%>
<%--test="${not empty activity.activityEndTime && activity.activityStartTime != activity.activityEndTime}">&nbsp;至&nbsp;${activity.activityEndTime}</c:if></p>--%>
<%--</li>--%>
<%--</c:forEach>--%>
<%--</ul>--%>
<%--</div>--%>
<%--&lt;%&ndash;猜你喜欢的活动 end&ndash;%&gt;--%>

<%--&lt;%&ndash;免费看演出 begin&ndash;%&gt;--%>
<%--<div class="in-perform" id="showActivityDivChild">--%>
<%--<ul>--%>
<%--<c:forEach items="${showActivityList}" var="activity">--%>
<%--<li data-url="${activity.activityIconUrl}">--%>
<%--<a href="${path}/frontActivity/frontActivityDetail.do?activityId=${activity.activityId}" class="img"--%>
<%--target="_blank"><img onload="fixImage(this, 260, 174)"/></a>--%>
<%--<h3><a href="${path}/frontActivity/frontActivityDetail.do?activityId=${activity.activityId}"--%>
<%--title="<c:out escapeXml='true' value='${activity.activityName}'/>" target="_blank"><c:out--%>
<%--escapeXml='true' value='${activity.activityName}'/></a></h3>--%>
<%--<div class="info">--%>
<%--<p>时间：${activity.activityStartTime}<c:if--%>
<%--test="${not empty activity.activityEndTime && activity.activityStartTime != activity.activityEndTime}">&nbsp;至&nbsp;${activity.activityEndTime}</c:if></p>--%>
<%--<p title="${activity.activityAddress}">地点：${activity.activityAddress}</p>--%>
<%--<p>费用：<span class="red"><c:if test="${activity.activityIsFree == 1}">免费</c:if><c:if--%>
<%--test="${activity.activityIsFree == 2}">${activity.activityPrice}</c:if></span></p>--%>
<%--<p>--%>
<%--<c:if test="${activity.activityIsReservation == 2}">--%>
<%--余票：<span class="red">--%>
<%--<c:choose>--%>
<%--<c:when test="${not empty activity.availableCount}">${activity.availableCount}</c:when><c:otherwise>0</c:otherwise>--%>
<%--</c:choose></span>张--%>
<%--</c:if>--%>
<%--</p>--%>
<%--</div>--%>
<%--<div class="extra">--%>
<%--<span class="heart"><i></i><em><c:choose><c:when--%>
<%--test="${not empty activity.collectNum}">${activity.collectNum}</c:when><c:otherwise>0</c:otherwise></c:choose></em></span>--%>
<%--<span class="view"><i></i><em><c:choose><c:when--%>
<%--test="${not empty activity.yearBrowseCount}">${activity.yearBrowseCount}</c:when><c:otherwise>0</c:otherwise></c:choose></em></span>--%>
<%--</div>--%>
<%--</li>--%>
<%--</c:forEach>--%>
<%--</ul>--%>
<%--</div>--%>
<%--&lt;%&ndash;免费看演出 end&ndash;%&gt;--%>

<%--<!-- 孩子学艺术 begin -->--%>
<%--<div class="in-perform" id="artActivityDivChild">--%>
<%--<ul>--%>
<%--<c:forEach items="${artActivityList}" var="activity">--%>
<%--<li data-url="${activity.activityIconUrl}">--%>
<%--<a href="${path}/frontActivity/frontActivityDetail.do?activityId=${activity.activityId}" class="img"--%>
<%--target="_blank"><img onload="fixImage(this, 260, 174)"/></a>--%>
<%--<h3><a href="${path}/frontActivity/frontActivityDetail.do?activityId=${activity.activityId}"--%>
<%--title="<c:out escapeXml='true' value='${activity.activityName}'/>" target="_blank"><c:out--%>
<%--escapeXml='true' value='${activity.activityName}'/></a></h3>--%>
<%--<div class="info">--%>
<%--<p>时间：${activity.activityStartTime}<c:if--%>
<%--test="${not empty activity.activityEndTime && activity.activityStartTime != activity.activityEndTime}">&nbsp;至&nbsp;${activity.activityEndTime}</c:if></p>--%>
<%--<p title="${activity.activityAddress}">地点：${activity.activityAddress}</p>--%>
<%--<p>费用：<span class="red"><c:if test="${activity.activityIsFree == 1}">免费</c:if><c:if--%>
<%--test="${activity.activityIsFree == 2}">${activity.activityPrice}</c:if></span></p>--%>
<%--<p>--%>
<%--<c:if test="${activity.activityIsReservation == 2}">--%>
<%--余票：<span class="red">--%>
<%--<c:choose>--%>
<%--<c:when test="${not empty activity.availableCount}">${activity.availableCount}</c:when><c:otherwise>0</c:otherwise>--%>
<%--</c:choose></span>张--%>
<%--</c:if>--%>
<%--</p>--%>
<%--</div>--%>
<%--<div class="extra">--%>
<%--<span class="heart"><i></i><em><c:choose><c:when--%>
<%--test="${not empty activity.collectNum}">${activity.collectNum}</c:when><c:otherwise>0</c:otherwise></c:choose></em></span>--%>
<%--<span class="view"><i></i><em><c:choose><c:when--%>
<%--test="${not empty activity.yearBrowseCount}">${activity.yearBrowseCount}</c:when><c:otherwise>0</c:otherwise></c:choose></em></span>--%>
<%--</div>--%>
<%--</li>--%>
<%--</c:forEach>--%>
<%--</ul>--%>
<%--</div>--%>
<%--<!-- 孩子学艺术 end -->--%>


<%--&lt;%&ndash;互动天地 begin&ndash;%&gt;--%>
<%--<div id="interactDivChild">--%>
<%--<h2>互动天地</h2>--%>
<%--<div class="cont" data-url="${answer.anwserImgUrl}">--%>
<%--<input type="hidden" id="selectAnswer"/>--%>
<%--<input type="hidden" id="okAnswer" value="${answer.anwserCode}"/>--%>
<%--<input type="hidden" id="page" value="${page.page}"/>--%>
<%--<input type="hidden" id="total" value="${total}"/>--%>

<%--<div class="img"><img alt="" onload="fixImage(this, 300, 200)"/></div>--%>
<%--<h4>${answer.anwserQuestion}</h4><c:set value="${fn:split(answer.anwserAllCode, '*/*')}" var="anwserAllCode"/>--%>
<%--<c:forEach items="${anwserAllCode}" var="code" varStatus="status">--%>
<%--<label><input type="radio" name="venues" value="${status.index+1}"/>${code}</label>--%>
<%--</c:forEach>--%>
<%--<div class="error-msg" style="display: none" id="interactMessage"><i></i><em>答错了 请继续</em></div>--%>
<%--<input type="button" class="submit-btn" value="提 交" id="interactButton"/>--%>
<%--<p class="tip">您可以在本平台寻找答案哦</p>--%>
<%--</div>--%>
<%--</div>--%>
<%--&lt;%&ndash;互动天地 end&ndash;%&gt;--%>

<%--&lt;%&ndash;热点推荐 begin&ndash;%&gt;--%>
<%--<div id="hotelRecommendDivChild">--%>
<%--<div class="in-tit in-tit1"><i></i><span>热点推荐</span></div>--%>
<%--<div class="in-hot">--%>
<%--<ul>--%>
<%--<c:forEach items="${advertList}" var="advert">--%>
<%--<li data-url="${advert.advertPicUrl}">--%>
<%--<a href="${advert.advertConnectUrl}" class="img fl" target="_blank"><img--%>
<%--onload="fixImage(this, 133, 100)"/></a>--%>
<%--<div class="info fr">--%>
<%--<h3><a href="${advert.advertConnectUrl}"--%>
<%--title="<c:out escapeXml='true' value='${advert.advertTitle}'/>" target="_blank"><c:out--%>
<%--escapeXml='true' value='${advert.advertTitle}'/></a></h3>--%>
<%--<c:if test="${advert.activityIsReservation != 2}"><p></p></c:if>--%>
<%--<p title="${advert.advertAdress}">地址：${advert.advertAdress}</p>--%>
<%--<p>时间：<fmt:formatDate value="${advert.activityTime}" pattern="yyyy-MM-dd"/><c:if--%>
<%--test="${not empty advert.activityEndTime && advert.activityTime != advert.activityEndTime}">&nbsp;至&nbsp;--%>
<%--<fmt:formatDate value="${advert.activityEndTime}" pattern="yyyy-MM-dd"/></c:if></p>--%>
<%--<c:if test="${advert.activityIsReservation == 2}">--%>
<%--<p>余票：--%>
<%--<span class="red">--%>
<%--<c:choose><c:when--%>
<%--test="${not empty advert.availableCount}">${advert.availableCount}</c:when><c:otherwise>0</c:otherwise></c:choose>--%>
<%--</span>张--%>
<%--</p>--%>
<%--</c:if>--%>
<%--</div>--%>
<%--</li>--%>
<%--</c:forEach>--%>
<%--</ul>--%>
<%--</div>--%>
<%--</div>--%>
<%--&lt;%&ndash;热点推荐 end&ndash;%&gt;--%>
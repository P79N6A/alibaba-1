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
<div class="activity-manage">
    <ul>
        <c:forEach items="${cmsRoomOrders}" var="cmsRoomOrders">
            <li data-orderNum="${cmsRoomOrders.orderNo}">
                <div class="tit">
                    <span class="lightred">订单号： ${cmsRoomOrders.orderNo}</span>
                    <i class="btn-status btn-chupiao">
                        <c:choose>
                         <c:when test="${cmsRoomOrders.bookStatus == 0 && cmsRoomOrders.checkStatus == 0}">
                                待审核
                            </c:when>
                            <c:when test="${cmsRoomOrders.bookStatus == 1}">
                                未使用
                            </c:when>
                            <c:when test="${cmsRoomOrders.bookStatus == 2}">
                                已取消
                            </c:when>
                            <c:when test="${cmsRoomOrders.bookStatus == 3}">
                                已使用
                            </c:when>
                            <c:when test="${cmsRoomOrders.bookStatus == 5}">
                                已出票
                            </c:when>
                            <c:otherwise>
                                已失效
                            </c:otherwise>
                        </c:choose>
                    </i>
                    <em> 订单时间：<fmt:formatDate value="${cmsRoomOrders.orderCreateTime}" pattern="yyyy-MM-dd HH:mm" /></em>
                </div>
                <div class="info">
                    <div>
                        <h3>场馆名称：${cmsRoomOrders.venueName}</h3>
                        <p>地址：${fn:substringAfter(cmsRoomOrders.venueCity, ',')}&nbsp;${fn:substringAfter(cmsRoomOrders.venueArea, ',')}&nbsp;${cmsRoomOrders.venueAddress}&nbsp;${cmsRoomOrders.roomNo}</p>
                        <p>使用时间：<fmt:formatDate value="${cmsRoomOrders.curDate}" pattern="yyyy-MM-dd" />&nbsp;&nbsp;&nbsp;&nbsp;${cmsRoomOrders.openPeriod}</p>
                        <p>活动室：${cmsRoomOrders.roomName}</p>
                        <p>使用团体：${cmsRoomOrders.tuserTeamName}</p>
                        <p><%--取票码：${cmsRoomOrders.validCode}<em></em>--%>手机： ${cmsRoomOrders.userTel}</p>
                    </div>
                </div>
                <div class="activity-comment" data-id="${cmsRoomOrders.roomId}" id="${cmsRoomOrders.roomId}${cmsRoomOrders.roomOrderId}"></div>
                <c:if test="${cmsRoomOrders.roomIsFree ==1}">
                    <div class="total">费用：免费</div>
                </c:if>
                <c:if test="${cmsRoomOrders.roomIsFree != 1}">
                    <div class="total">费用：收费</div>
                </c:if>
                <a class="btn btn-red btn-cancel-order" id="${cmsRoomOrders.roomOrderId}">取消预订</a>
                <a class="btn btn-blue btn-order-detail">订单详情</a>
            </li>
        </c:forEach>
        <c:if test="${empty cmsRoomOrders}">
            <div class="null_info">
                <h3>您还没有预订场馆，<a href="${path}/frontVenue/venueList.do">去看看</a></h3>
            </div>
        </c:if>
    </ul>

    <c:if test="${fn:length(cmsRoomOrders) gt 0}">
        <div id="kkpager"></div>
        <input type="hidden" id="pages" value="${page.page}">
        <input type="hidden" id="countPage" value="${page.countPage}">
        <input type="hidden" id="total" value="${page.total}">
    </c:if>
</div>

<script type="text/javascript">

    $(document).ready(function(){
        $(".activity-manage ul li").each(function () {
            var roomId = $(this).find(".activity-comment").attr("data-id");
            var roomOrderId = $(this).find(".btn-cancel-order").attr("id");
            var html = "";
            $.post("${path}/roomOrder/getCommentCountById.do",{"roomId":roomId}, function(data) {
                if(data >0){
                    html = "共有"+data+"条评论，<a href='javascript:;' onclick=goToDetail('"+ roomId +"')>去看看</a>";
                }
                $("#"+roomId+roomOrderId).html(html);
            });
        });
    });

    /**
     * 去看看
     * @param roomId
     */
    function goToDetail(roomId){
        $("#roomId").val(roomId);
        $("#roomDetailForm").submit();
    }
</script>
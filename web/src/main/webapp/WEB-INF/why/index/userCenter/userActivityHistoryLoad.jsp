<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String path = request.getContextPath();
    request.setAttribute("path", path);
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>

<style>
	.msZhanshi {
		width: 540px;
		background-color: #f8f8f8;
		padding: 10px 0;
		-webkit-border-radius: 4px;
		-moz-border-radius: 4px;
		border-radius: 4px;
		margin-top: 10px;
		display: none;
	}
	.msZhanshi li {
		padding: 8px 18px;
		border:none;
		margin:0;
	}
	.msZhanshi .titMs {
		font-size: 14px;
		color: #686868;
		line-height: 1.5;
		margin-bottom: 5px;
	}
	.msZhanshi .ner {
		font-size: 14px;
		color: #999;
		line-height: 1.5;
	}
</style>

<%--<div class="user-part user-part-b">--%>
    <div class="activity-manage">
        <c:set var="nowDate" value="<%=System.currentTimeMillis()%>"></c:set>
        <ul>
            <c:if test="${not empty activityList}">
                <c:forEach items="${activityList}" var="activityList">
                    <fmt:parseDate value="${activityList.eventDateTime}" pattern="yyyy-MM-dd HH:mm" var="startTime"/>
                    <li data-orderNum="${activityList.activityOrderId}">
                        <div class="tit"><span class="lightred">订单号：  ${activityList.orderNumber}</span>
                            <i class="btn-status btn-chupiao">
                                <c:choose>
                                    <c:when test="${activityList.orderPayStatus == 1}">
                                        <c:if test="${startTime.time - nowDate >= 0}" >
                                            已取消
                                        </c:if>
                                        <c:if test="${startTime.time - nowDate < 0}" >
                                            已失效
                                        </c:if>
                                    </c:when>
                                    <c:when test="${activityList.orderPayStatus == 2}">
                                        已取消
                                    </c:when>
                                    <c:when test="${activityList.orderPayStatus == 3}">
                                        已出票
                                    </c:when>
                                    <c:when test="${activityList.orderPayStatus == 4}">
                                        已验票
                                    </c:when>
                                    <c:otherwise>
                                        <c:if test="${startTime.time - nowDate >= 0}" >
                                            已取消
                                        </c:if>
                                        <c:if test="${startTime.time - nowDate < 0}" >
                                            已失效
                                        </c:if>
                                    </c:otherwise>
                                </c:choose>
                            </i>
                            <em>订单时间： <fmt:formatDate value="${activityList.orderCreateTime}" pattern="yyyy-MM-dd HH:mm" /></em>
                        </div>
                        <div class="info activityOrderInfo">
                            <div>
                                <h3>活动：${activityList.activityName}</h3>
                                <p>地址：<%--${fn:split(activityList.activityCity, ',')[1]}&nbsp;<c:if test="${fn:split(activityList.activityArea, ',')[1] != fn:split(activityList.activityCity, ',')[1]}">${fn:split(activityList.activityArea, ',')[1]}&nbsp;</c:if>--%><c:out escapeXml="true" value="${activityList.activityAddress}"/></p>
                                <p>活动时间：${activityList.eventDateTime}</p>
                                <% int i= 0;%>

                                <c:if test="${activityList.activitySalesOnline == 'Y'}" >
                                    <p>座位：
                                        <c:forEach items="${activityList.activityOrderDetailList}" var="detail">
                                            <c:if test="${nowDate-startTime.time <= 0}">
<%--                                                <c:if test="${detail.seatStatus == 1}" >
                                                    <span cancelSeat="${detail.orderLine}">${fn:split(detail.seatVal,'_')[0]}排${fn:split(detail.seatVal,'_')[1]}座(<font color="red">未入场</font>)</span>
                                                </c:if>--%>

                                                <c:if test="${detail.seatStatus == 2}" >
                                                    <span cancelSeat="${detail.orderLine}">${fn:split(detail.seatVal,'_')[0]}排${fn:split(detail.seatVal,'_')[1]}座(<font color="red">已退订</font>)</span>
                                                    <% i++;%>
                                                </c:if>
                                                <c:if test="${detail.seatStatus == 3}" >
                                                    <span cancelSeat="${detail.orderLine}">${fn:split(detail.seatVal,'_')[0]}排${fn:split(detail.seatVal,'_')[1]}座(<font color="red">已取票</font>)</span>
                                                    <% i++;%>
                                                </c:if>
                                                <c:if test="${detail.seatStatus == 4}" >
                                                    <span cancelSeat="${detail.orderLine}">${fn:split(detail.seatVal,'_')[0]}排${fn:split(detail.seatVal,'_')[1]}座(<font color="red">已入场</font>)</span>
                                                    <% i++;%>
                                                </c:if>
                                            </c:if>
                                            <c:if test="${nowDate-startTime.time > 0}">
                                                <c:if test="${detail.seatStatus == 2}" >
                                                    <span cancelSeat="${detail.orderLine}">${fn:split(detail.seatVal,'_')[0]}排${fn:split(detail.seatVal,'_')[1]}座(<font color="red">已退订</font>)</span>
                                                    <% i++;%>
                                                </c:if>
                                                <c:if test="${detail.seatStatus == 3}" >
                                                    <span cancelSeat="${detail.orderLine}">${fn:split(detail.seatVal,'_')[0]}排${fn:split(detail.seatVal,'_')[1]}座(<font color="red">已失效</font>)</span>
                                                    <% i++;%>
                                                </c:if>
                                                <c:if test="${detail.seatStatus == 4}" >
                                                    <span cancelSeat="${detail.orderLine}">${fn:split(detail.seatVal,'_')[0]}排${fn:split(detail.seatVal,'_')[1]}座(<font color="red">已入场</font>)</span>
                                                    <% i++;%>
                                                </c:if>
                                                <c:if test="${detail.seatStatus == 1}" >
                                                    <span cancelSeat="${detail.orderLine}">${fn:split(detail.seatVal,'_')[0]}排${fn:split(detail.seatVal,'_')[1]}座(<font color="red">已失效</font>)</span>
                                                    <% i++;%>
                                                </c:if>

                                            </c:if>

                                        </c:forEach>
                                    </p>
                                </c:if>
                                <c:if test="${activityList.activitySalesOnline == 'Y'}" >
                                <p>票数：<%=i%></p>
                                </c:if>
                                <c:if test="${activityList.activitySalesOnline == 'N'}" >
                                    <p>票数：${activityList.orderVotes}</p>
                                </c:if>
                                
                                <p>取票码：${activityList.orderValidateCode}<em></em>手机： ${activityList.orderPhoneNo}</p>
                                
                                <input class="orderCustomInfo" type="hidden" value="${fn:escapeXml(activityList.orderCustomInfo)}"/>
                				<ul class="msZhanshi"></ul>
                            </div>
                        </div>
                        <div class="activity-comment" data-id="${activityList.activityId}" id="${activityList.activityOrderId}"></div>
                        <a onclick="javascript:;" class="btn btn-red btn-delete-order">删除订单</a>
                        <a onclick="javascript:;" class="btn btn-blue btn-order-detail">订单详情</a>
                    </li>
                </c:forEach>
            </c:if>
            <c:if test="${empty activityList}">
                <div  class="null_info">
                    <h3>您还没有历史记录哦。</h3>
                </div>
            </c:if>
        </ul>
        <%--动态取值分页--%>
        <c:if test="${fn:length(activityList) gt 0}">
            <div id="kkpager"></div>
            <input type="hidden" id="pages" value="${page.page}">
            <input type="hidden" id="countPage" value="${page.countPage}">
            <input type="hidden" id="total" value="${page.total}">
            <input type="hidden" id="reqPage"  value="1">
        </c:if>
    </div>
<%--</div>--%>
<%--</div>--%>
<%--</div>--%>
<script type="text/javascript">

$(document).ready(function(){
	$(".activity-manage ul li").each(function () {
	var activityId = $(this).find(".activity-comment").attr("data-id");
	var html = "";
	var activityOrderId = $(this).find(".activity-comment").attr("id");
	$.post("${path}/frontActivity/getCommentCountById.do",{"activityId":activityId}, function(data) {
	if(data >0){
	html = "共有"+data+"条评论，<a target='_blank' href='${path}/frontActivity/frontActivityDetail.do?activityId="+ activityId +"'>去看看</a>";
	}
	$("#"+activityOrderId).html(html);
	});
	});
	
	//加载自定义信息
    $(".activityOrderInfo").each(function(){
    	if($(this).find(".orderCustomInfo").val().length>0){
    		var orderCustomInfoObj = JSON.parse($(this).find(".orderCustomInfo").val());
       		for (var i=0;i<orderCustomInfoObj.length;i++){
       			$(this).find(".msZhanshi").append("<li>" +
														"<div class='titMs'>"+orderCustomInfoObj[i].title+"：</div>" +
														"<div class='ner'>"+orderCustomInfoObj[i].value+"</div>" +
													"</li>");
       		};
       		$(this).find(".msZhanshi").show();
    	}
    });
});


</script>

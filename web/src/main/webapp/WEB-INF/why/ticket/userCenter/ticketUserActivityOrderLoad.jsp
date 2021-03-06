<%@ page import="com.sun3d.why.model.CmsTerminalUser" %>
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
      <c:if test="${not empty activityOrderList}" >
        <c:forEach items="${activityOrderList}" var="activityList">
          <li data-orderNum="${activityList.activityOrderId}" data-orderValidateCode="${activityList.orderValidateCode}">
            <div class="tit"><span class="lightred">订单号：${activityList.orderNumber}</span>
              <i class="btn-status btn-chupiao">
                <c:choose>
                  <c:when test="${activityList.orderPayStatus == 1}">
                    未出票
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
                      已失效
                  </c:otherwise>
                </c:choose>
                </i>
              <em>订单时间： <fmt:formatDate value="${activityList.orderCreateTime}" pattern="yyyy-MM-dd HH:mm" /></em></div>
            <div class="info">
              <div>
                <h3>活动：${activityList.activityName}</h3>
                <%--<p>地址：${fn:split(activityList.activityCity, ',')[1]}&nbsp;<c:if test="${fn:split(activityList.activityArea, ',')[1] != fn:split(activityList.activityCity, ',')[1]}">${fn:split(activityList.activityArea, ',')[1]}&nbsp;</c:if><c:out escapeXml="true" value="${activityList.activityAddress}"/></p>--%>
                <p>地址：<c:out escapeXml="true" value="${activityList.activityAddress}"/></p>
                <p>活动时间：${activityList.eventDateTime}</p>
                  <% int i= 0;%>
                <c:if test="${not empty activityList.orderSummary}" >
                <p>座位：
                    <c:forEach items="${activityList.activityOrderDetailList}" var="detail">
                        <c:if test="${detail.seatStatus == 1}" >
                            <label class="r-on"><input type="checkbox" checked="true" style="display: none;"/><span cancelSeat="${detail.orderLine}">${fn:split(detail.seatVal,'_')[0]}排${fn:split(detail.seatVal,'_')[1]}座</span> </label>
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
                    </c:forEach>
                </p>
              </c:if>
                  <c:if test="${not empty activityList.orderSummary}" >
                      <p>票数：<span  id="votes${activityList.activityOrderId}"><%=i%></span></p>
                  </c:if>
                  <c:if test="${empty activityList.orderSummary}">
                     <p>票数：<span  id="votes${activityList.activityOrderId}"> ${activityList.orderVotes}</span></p>
                  </c:if>
                <p>取票码：${activityList.orderValidateCode}</p>

                  <p>手机： ${activityList.orderPhoneNo}</p>
              </div>
            </div>

            <%--<div class="activity-comment" data-id="${activityList.activityId}" id="${activityList.activityOrderId}"></div>--%>
              <c:if test="${activityList.orderPayStatus == 1}">
                <a  class="btn btn-red btn-get-ticket">取 票</a>
              </c:if>
              <c:if test="${activityList.orderPayStatus==1 && activityList.orderPaymentStatus != 2 && activityList.orderPaymentStatus != 3 && activityList.orderPaymentStatus != 4}">
            	<a  class="btn btn-red btn-cancel-order">取消订单</a>
           	  </c:if>
              <a  class="btn btn-blue btn-order-detail">订单详情</a>
          </li>
        </c:forEach>
      </c:if>
      <c:if test="${empty activityOrderList}" >
        <li>
          <div class="null_info">
            <h3>您还没有预订活动哦，<a href="${path}/ticketActivity/ticketActivityList.do" >去看看</a>。</h3>
          </div>
        </li>
      </c:if>
    </ul>

    <%--动态取值分页--%>
    <c:if test="${fn:length(activityOrderList) gt 0}">
      <div id="kkpager"></div>
      <input type="hidden" id="pages" value="${page.page}">
      <input type="hidden" id="countPage" value="${page.countPage}">
      <input type="hidden" id="total" value="${page.total}">
      <input type="hidden" id="reqPage"  value="1">
    </c:if>

  </div>

<%--
<script type="text/javascript">

  $(document).ready(function(){
    $(".activity-manage ul li").each(function () {
      var activityId = $(this).find(".activity-comment").attr("data-id");
      var html = "";
      var activityOrderId = $(this).find(".activity-comment").attr("id");
      $.post("${path}/ticketActivity/getCommentCountById.do",{"activityId":activityId}, function(data) {
        if(data >0){
          html = "共有"+data+"条评论，<a href='${path}/ticketActivity/ticketActivityDetail.do?activityId="+ activityId +"'>去看看</a>";
        }
        $("#"+activityOrderId).html(html);
      });
    });
  });


</script>--%>

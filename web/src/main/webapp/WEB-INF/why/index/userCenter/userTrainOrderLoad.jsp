<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
    String path = request.getContextPath();
    request.setAttribute("path", path);
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>
<div class="orders">
    <input type="hidden" name="status" id="status" value="${status}">
    <c:if test="${not empty trainOrderList}" >
        <c:forEach items="${trainOrderList}" var="order">
            <div class="orderMsg">
                <div class="title clearfix">
                    <div class="orderNum">订单号：${order.orderNum}</div>
                    <div class="orderTime">报名时间：<fmt:formatDate type="both" value="${order.createTime}" /></div>
                </div>
                    <%--              <div class="info">
                                      <div>
                                          <h3>培训名称：${order.trainTitle}</h3>
                                          <p>地址：${order.trainAddress}</p>
                                          <p>活动时间：${fn:substring(order.trainStartTime,0 ,16 )}～${fn:substring(order.trainEndTime,0 ,16 )}</p>
                                      </div>
                                  </div>
                                  <div class="situation">
                                      <div class="fail">未通过</div>
                                  </div>--%>
                <div class="courseMsg clearfix">
                    <div class="img">
                        <img src="${order.trainImgUrl}" alt="">
                    </div>
                    <div class="content">
                        <div class="traintit">${order.trainTitle}</div>
                        <div class="traintime">培训时间：${fn:substring(order.trainStartTime,0 ,16 )}～${fn:substring(order.trainEndTime,0 ,16 )}</div>
                        <div class="trainadd">培训地址：${order.trainAddress}</div>
                    </div>
                    <div class="situation">
                        <c:if test="${order.state == 1}">
                            <div class="success">已录取</div>
                            <c:if test="${order.admissionType==1}">
                                <div class="unsubscribe" id="${order.id}">退订</div>
                            </c:if>
                        </c:if>
                        <c:if test="${order.state == 2}">
                            <div class="cancel">已取消</div>
                        </c:if>
                        <c:if test="${order.state == 3}">
                            <div class="examine">待审核...</div>
                            <div class="unsubscribe" id="${order.id}">退订</div>
                        </c:if>
                        <c:if test="${order.state == 4}">
                            <div class="fail">未通过</div>
                        </c:if>
                    </div>
                </div>
            </div>
        </c:forEach>
    </c:if>
    <c:if test="${empty trainOrderList}" >
        <div class="null_info">
            <h3>暂时没有查找到相关培训信息哦，<a href="${path}/cmsTrain/cmsTrainIndex.do" >去看看</a>。</h3></div>
    </c:if>
    <c:if test="${not empty trainOrderList}">
        <div id="kkpager"></div>
        <div id="kkpager"></div>
        <input type="hidden" id="pages" value="${page.page}">
        <input type="hidden" id="countPage" value="${page.countPage}">
        <input type="hidden" id="total" value="${page.total}">
        <input type="hidden" id="reqPage"  value="1">
    </c:if>

</div>

<script type="text/javascript">

</script>
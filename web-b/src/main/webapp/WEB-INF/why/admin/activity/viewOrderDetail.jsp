<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:setLocale value="zh_CN"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/html">
<head>
    <title>查看订单</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
</head>
<body>
<div class="site">
    <em>您现在所在的位置：</em> 活动管理 &gt; 查看订单
</div>
<div class="site-title">查看订单</div>
<!-- 正中间panel -->
<input type="hidden" value="${fn:escapeXml(activityOrder.orderCustomInfo)}" id="orderCustomInfo"/>
<div class="main-publish">
            <table class="form-table" width="100%">
                <tbody>
                            <tr>
                                <td width="150px">活动名称：</td>
                                <td class="td-input" >
                                   <span > ${activityOrder.activityName} </span>
                                </td>
                            </tr>
                            <tr>
                                <td ><span class="td-prompt"></span>活动时间：</td>
                                <td  >
                                    <span > ${activityOrder.eventDate}&nbsp;&nbsp;${activityOrder.eventTime}</span>
                                </td>
                            </tr>
                            <tr>
                                <td ><span class="td-prompt"></span>所属场馆：</td>
                                <td class="td-input" >
                                  <span >
                                      <c:choose>
                                          <c:when test="${activityOrder.createActivityCode == 1}">市级自建</c:when>
                                          <c:when test="${activityOrder.createActivityCode == 2}">区级自建</c:when>
                                          <c:otherwise>
                                              <c:if test="${not empty activityOrder.venueName}">
                                                  <c:out escapeXml="true" value="${activityOrder.venueName}"/>
                                              </c:if>
                                              <c:if test="${ empty activityOrder.venueName}">
                                                  未知场馆
                                              </c:if>
                                          </c:otherwise>
                                      </c:choose>
                                  </span>
                                </td>
                            </tr>
                            <tr>
                                <td ><span class="td-prompt"></span>选座方式：</td>
                                <td class="td-input-two">
                                 <span >   <c:choose>
                                        <c:when test="${activityOrder.activitySalesOnline =='Y'}">
                                            在线选座
                                        </c:when>
                                        <c:otherwise>
                                            自由入座
                                        </c:otherwise>
                                    </c:choose>
                                 </span>
                                </td>
                            </tr>
                            <tr>
                                <td ><span class="td-prompt"></span>订单号：</td>
                                <td class="td-input" >
                                   <span > ${activityOrder.orderNumber}</span>
                                </td>
                            </tr>
                            <tr>
                                <td >票数：</td>
                                <td class="td-input" >
                                   <span > ${activityOrder.orderVotes}</span>
                                </td>
                            </tr>
                            <c:if test="${not empty activityOrder.orderSummary}" >
                                    <tr>
                                        <td >座位：</td>
                                        <td class="yd_numlist yd_numlist_bg" >
                                            <c:forEach items="${activityOrder.activityOrderDetailList}" var="detail">
<%--                                                <c:if test="${detail.seatStatus == 1}" >
                                                    <input type="checkbox" checked name="cancelSeat" value="${detail.orderLine}">
                                                </c:if>--%>
                                                ${fn:split(detail.seatVal,'_')[0]}排${fn:split(detail.seatVal,'_')[1]}座
                                                <c:if test="${detail.seatStatus == 2}" >
                                                    (<span class="red">已退订</span>)
                                                </c:if>
                                                <c:if test="${detail.seatStatus == 3}" >
                                                    (<span class="red">已取票</span>)
                                                </c:if>
                                                <c:if test="${detail.seatStatus == 4}" >
                                                    (<span class="red">已入场</span>)
                                                    (<span class="red">验票时间:<fmt:formatDate value="${detail.updateTime}" pattern="yyyy-MM-dd HH:mm:ss"/></span>)
                                                </c:if> &nbsp;&nbsp;
                                            </c:forEach>
                                            <%--<br>&nbsp;(勾选需要取消的座位)--%>
                                        </td>
                                    </tr>
                            </c:if>
                            <tr>
                                <td >预订人：</td>
                                <td class="td-input" >
                                   <span >
                                       <c:if test="${not empty activityOrder.orderName}">
                                        ${activityOrder.orderName}
                                       </c:if>
                                        <c:if test="${ empty activityOrder.orderName}">
                                            未知预订人
                                        </c:if>
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <td >预订号码：</td>
                                <td class="td-input" >
                                   <span >
                                       <c:if test="${not empty activityOrder.orderPhoneNo}">
                                           ${activityOrder.orderPhoneNo}
                                       </c:if>
                                        <c:if test="${ empty activityOrder.orderPhoneNo}">
                                            未知号码
                                        </c:if>
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <td >取票码：</td>
                                <td class="td-input">
                                   <span > ${activityOrder.orderValidateCode} </span>
                                </td>
                            </tr>
                            <tr id="orderCustomInfoTr">
                                <td style="vertical-align:top">自定义信息：</td>
                                <td class="td-input" id="orderCustomInfoTd">
                                   
                                </td>
                            </tr>
                            <tr class="submit-btn">
                                <td></td>
                                <td class="td-btn">
                                    <input type="button" class="btn-publish" value="返回" onclick="javascript :history.back(-1);"/>
                                </td>
                            </tr>
                </tbody>
                        </table>
    </div>
<script type="text/javascript">
    //提交表单
    function formSub(formName){
        $(formName).submit();
    }
    $(function(){
    	var orderCustomInfo = $('#orderCustomInfo').val();
    	if (orderCustomInfo == ""){
    		//$('#orderCustomInfoTr').hide();
    		$('#orderCustomInfoTd').html("无");
    	} else {
    		orderCustomInfo = eval("("+orderCustomInfo+")");
        	var customInfoHtml = "";
            for (var i=0;i<orderCustomInfo.length;i++){
            	customInfoHtml = customInfoHtml + orderCustomInfo[i].title + "：" + orderCustomInfo[i].value + "<br/>";
            }
            if (customInfoHtml == ""){
            	//$('#orderCustomInfoTr').hide();
            	$('#orderCustomInfoTd').html("无");
            } else {
            	$('#orderCustomInfoTd').html(customInfoHtml);
            }
    	}
    });
</script>
</body>
</html>

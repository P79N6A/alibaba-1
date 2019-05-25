<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>文化点单列表--文化云</title>
    <%@include file="../../common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
<script type="text/javascript">
$(function(){
    kkpager.generPageHtml({
        pno : '${page.page}',
        total : '${page.countPage}',
        totalRecords :  '${page.total}',
        mode : 'click',//默认值是link，可选link或者click
        click : function(n){
            this.selectPage(n);
            $("#page").val(n);
            formSub('#culturalOrderForm');
            return false;
        }
    });
    //加载地区
	var venueProvince = '804,辽宁省';
	var venueCity = '900,安康市';
    //省市区
    var loc = new Location();
    var json = loc.find( '0,' + venueProvince.split(",")[0] + ',' + venueCity.split(",")[0]);
    if (json){
		$.each(json , function(k , v) {
			var option = '<li data-option="'+k+","+v+'">'+v+'</li>';
			$('#culturalOrderAreaUl').append(option);
		});
	}
  	//加载类型
    $.ajax({
        type: "POST",
        url: "${path}/sysdict/queryChildSysDictByDictCode.do?dictCode=CULTURAL_ORDER_TYPE",
        data: {},
        dataType: "json",
        success: function(data){
            for (var i=0;i<data.length;i++){
            	$('#culturalOrderTypeUl').append("<li data-option='"+data[i].dictId+"'>"+data[i].dictName+"</li>");
            }
            selectModel();
        }
    });
});
//提交表单
function formSub(formName) {
	$(formName).submit();
}
//搜索
function search(){
	$('#page').val(1);
	formSub('#culturalOrderForm');
}
function toAddCulturalOrder(){
	window.location.href="${path}/culturalOrder/toAddCulturalOrder.do?culturalOrderLargeType="+$('#culturalOrderLargeType').val();
}
function setCulturalOrderStatus(culturalOrderId,status){
	var str = "";
	if (status == 1){
		str = "您确定要上架该产品吗？";
	} else if (status == 0){
		str = "您确定要下架该产品吗？";
	}
	dialogConfirm("系统提示",str,function(){
		$.post("${path}/culturalOrder/setCulturalOrderStatus.do",{culturalOrderId:culturalOrderId,status:status},function(data){
			switch (data) {
				case("success"):
					dialogAlert("系统提示", "保存成功", function () {
						search();
					});
					break; 
				case("noActive"):
	          		dialogAlert("系统提示", "请登陆后再进行操作", function () {
						window.location.href = "../admin.do";
					});
					break;
				default:
					dialogAlert("系统提示", "发生错误，请查看数据是否完整", function () {
					});
					break;
			}
		});
	});
}
function delCulturalOrder(culturalOrderId){
	dialogConfirm("系统提示","您确定要删除该产品吗？",function(){
		$.post("${path}/culturalOrder/delCulturalOrder.do",{culturalOrderId:culturalOrderId},function(data){
			switch (data) {
				case("success"):
					dialogAlert("系统提示", "删除成功", function () {
						search();
					});
					break; 
				case("noActive"):
	          		dialogAlert("系统提示", "请登陆后再进行操作", function () {
						window.location.href = "../admin.do";
					});
					break;
				case("hasOrder"):
					dialogAlert("系统提示", "该产品已存在订单，不能删除", function () {
					});
					break;
				default:
					dialogAlert("系统提示", "发生错误，请查看数据是否完整", function () {
					});
					break;
			}
		});
	});
}
function editCulturalOrder(culturalOrderId){
	window.location.href="${path}/culturalOrder/toEditCulturalOrder.do?culturalOrderId="+culturalOrderId;
}
</script>
</head>
<body>
<form id="culturalOrderForm" name="culturalOrderForm" action="${path}/culturalOrder/culturalOrderList.do?culturalOrderLargeType=${cmsCulturalOrder.culturalOrderLargeType}" method="post">
	<input type="hidden" value="${cmsCulturalOrder.culturalOrderLargeType}" id="culturalOrderLargeType"/> 
    <div class="site">
        <em>您现在所在的位置：</em>我要参与&gt; 点单列表
    </div>	
    <div class="search">
        <div class="search-box">
            <i></i><input id="culturalOrderName" name="culturalOrderName" class="input-text" data-val="请输入标题" 
            type="text" value="${cmsCulturalOrder.culturalOrderName}"/>
        </div>
        <div class="select-box w135">
            <input type="hidden" name="culturalOrderType" id="culturalOrderType" value="${cmsCulturalOrder.culturalOrderType}"/>
            <div id="culturalOrderTypeDiv" class="select-text" data-value="">点单类型</div>
	            <ul id="culturalOrderTypeUl" class="select-option">
	            	<li data-option="">点单类型</li>
	            </ul>            
        </div>
        <div class="select-box w135">
            <input type="hidden" name="culturalOrderArea" id="culturalOrderArea" value="${cmsCulturalOrder.culturalOrderArea}"/>
            <div id="culturalOrderAreaDiv" class="select-text" data-value="">所属区域</div>
	            <ul id="culturalOrderAreaUl" class="select-option">
	            	<li data-option="">所属区域</li>
	            </ul>
        </div>
        <div class="select-box w135">
            <input type="hidden" name="culturalOrderStatus" id="culturalOrderStatus" value="${cmsCulturalOrder.culturalOrderStatus}"/>
            <div id="culturalOrderStatusDiv" class="select-text" data-value="">状态</div>
	            <ul id="culturalOrderStatusUl" class="select-option">
	            	<li data-option="">状态</li>
	            	<li data-option="0">已下架</li>
	            	<li data-option="1">已上架</li>
	            </ul>            
        </div>
        <div class="select-btn">
            <input type="button" value="搜索" onclick="search();"/>
        </div>
        <div class="select-btn" style="float:right;margin-right:40px">
			<input type="button" onclick="toAddCulturalOrder();" value="新增" style="margin-right:5px;"/>
		</div>
    </div>
	<div class="main-content pt10">
	    <table width="100%">
	        <thead>
	        <tr>
	            <th>序号</th>
	            <th class="title">标题</th>
	            <th class="info">类型</th>
	            <th>服务日期</th>
	            <th>
	            	<c:if test="${cmsCulturalOrder.culturalOrderLargeType == 1}">
	            	详细地址
	            	</c:if>
	            	<c:if test="${cmsCulturalOrder.culturalOrderLargeType == 2}">
	            	点单区域限制
	            	</c:if>
	            </th>
	            <c:if test="${cmsCulturalOrder.culturalOrderLargeType == 1}">
	            <th>票数</th>
	            </c:if>
	            <th>状态</th>
	            <th>创建人</th>
	            <th>最新操作人</th>
	            <th>最新操作时间</th>
	            <th>管理</th>
	        </tr>
	        </thead>
	        <c:if test="${empty orderList}">
	            <tr>
	            	<c:if test="${cmsCulturalOrder.culturalOrderLargeType == 1}">
	                <td colspan="11"><h4 style="color:#DC590C">暂无数据!</h4></td>
	                </c:if>
	                <c:if test="${cmsCulturalOrder.culturalOrderLargeType == 2}">
	                <td colspan="10"><h4 style="color:#DC590C">暂无数据!</h4></td>
	                </c:if>
	            </tr>
	        </c:if>
	        <tbody>
	        <c:forEach items="${orderList}" var="order" varStatus="st">
	            <tr>
	                <td>${st.index+1}</td>
	                <td class="title">${order.culturalOrderName}</td>
	             	<td>${order.culturalOrderTypeName}</td>
	                <td>
	                	<c:if test="${cmsCulturalOrder.culturalOrderLargeType == 1}">
	                	<fmt:formatDate value="${order.startDate}" pattern="yyyy-MM-dd"/>至<fmt:formatDate value="${order.endDate}" pattern="yyyy-MM-dd"/>
	                	</c:if>
	                	<c:if test="${cmsCulturalOrder.culturalOrderLargeType == 2}">
	                	<fmt:formatDate value="${order.culturalOrderStartDate}" pattern="yyyy-MM-dd"/>至<fmt:formatDate value="${order.culturalOrderEndDate}" pattern="yyyy-MM-dd"/>
	                	</c:if>
	                </td>
	                <td>
	                	<c:if test="${cmsCulturalOrder.culturalOrderLargeType == 1}">
		                ${order.culturalOrderAddress}
	                	</c:if>
	                	<c:if test="${cmsCulturalOrder.culturalOrderLargeType == 2}">
	                	${fn:split(order.culturalOrderAreaLimit,',')[1]}
	                	</c:if>
	                </td>
	                <c:if test="${cmsCulturalOrder.culturalOrderLargeType == 1}">
	                <td>${order.ticketNum}</td>
	                </c:if>
	                <td>
	                	<c:choose>
	                		<c:when test="${order.culturalOrderStatus == 0}">
	                			已下架
	                		</c:when>
	                		<c:when test="${order.culturalOrderStatus == 1}">
	                			已上架
	                		</c:when>
	                	</c:choose>
	                </td>
	                <td>${order.createUserName}</td>
	                <td>${order.updateUserName}</td>
	                <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${order.updateTime}"></fmt:formatDate></td>
	                <td>
	                	<c:if test="${order.ifHasOrder == 0}">
	                		<a href="javascript:editCulturalOrder('${order.culturalOrderId}')" style="margin-left:8px;">编辑</a>
	                		<a href="javascript:delCulturalOrder('${order.culturalOrderId}')" style="margin-left:8px;">删除</a>
	                	</c:if>
	                	<%if (orderPutawayButton) {%>
	                	<c:if test="${order.culturalOrderStatus == 0}">
	                		<a href="javascript:setCulturalOrderStatus('${order.culturalOrderId}',1)" style="margin-left:8px;">上架</a>
	                	</c:if>
	                	<%}%>
                        <%if (orderSoldoutButton) {%>
	                	<c:if test="${order.culturalOrderStatus == 1}">
	                		<a href="javascript:setCulturalOrderStatus('${order.culturalOrderId}',0)" style="margin-left:8px;">下架</a>
	                	</c:if>
	                	<%}%>
	                </td>
	            </tr>
	        </c:forEach>
	        </tbody>
	    </table>
	    <c:if test="${not empty orderList}">
	        <input type="hidden" id="page" name="page" value="${page.page}" />
	        <div id="kkpager"></div>
	    </c:if>
	</div>
</form>
</body>
</html>
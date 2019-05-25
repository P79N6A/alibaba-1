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
    <link rel="Stylesheet" type="text/css" href="${path}/STATIC/css/DialogBySHF.css" />
    <script type="text/javascript" src="${path}/STATIC/js/DialogBySHF.js"></script>
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
            formSub('#culturalOrderOrderForm');
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
	formSub('#culturalOrderOrderForm');
}
function checkAll(){
	if ($('#chooseAll').is(":checked")){
		$(":checkbox").each(function(){
			$(this).prop('checked',true);
		});
	} else {
		$(":checkbox").each(function(){
			$(this).prop('checked',false);
		});
	}
}
function checkCheckbox(){
	var flag = true;
	$("input[type='checkbox'][id!='chooseAll']").each(function(){
		if (!$(this).is(":checked")){
			flag = false;
		}
		return;
	});
	if (flag){
		$('#chooseAll').prop('checked',true);
	} else {
		$('#chooseAll').prop('checked',false);
	}
}
function toBatchDeal(){
	var ids = "";
	$("input[type='checkbox'][id!='chooseAll']").each(function(){
		if ($(this).is(":checked")){
			ids = ids + $(this).val() +",";
		}
	});
	if (ids == ""){
		dialogAlert("系统提示","请选择要批量处理的订单！");
		return;
	} else {
		ids = ids.substring(0,ids.length-1);
	}
	var winH = parseInt($(window).height() * 0.85);
	$.DialogBySHF.Dialog({
		Width: 880,
		Height: winH,
		URL:"${path}/culturalOrderOrder/dealCulturalOrderOrder.do?ids="+ids
	}); 
}
function dealCulturalOrderOrder(culturalOrderOrderId){
	var winH = parseInt($(window).height() * 0.85);
	$.DialogBySHF.Dialog({
		Width: 880,
		Height: winH,
		URL:"${path}/culturalOrderOrder/dealCulturalOrderOrder.do?ids="+culturalOrderOrderId
	}); 
}
function editCulturalOrderOrder(culturalOrderOrderId){
	window.location.href="${path}/culturalOrderOrder/editCulturalOrderOrder.do?culturalOrderOrderId="+culturalOrderOrderId;
}
</script>
</head>
<body>
<form id="culturalOrderOrderForm" name="culturalOrderOrderForm" action="${path}/culturalOrderOrder/culturalOrderOrderList.do?culturalOrderLargeType=${cmsCulturalOrderOrder.culturalOrderLargeType}" method="post">
	<input type="hidden" value="${cmsCulturalOrderOrder.culturalOrderLargeType}" id="culturalOrderLargeType"/> 
    <div class="site">
        <em>您现在所在的位置：</em>我要参与&gt; 点单列表
    </div>	
    <div class="search">
        <div class="search-box">
            <i></i><input id="culturalOrderName" name="culturalOrderName" class="input-text" data-val="请输入标题" 
            type="text" value="${cmsCulturalOrderOrder.culturalOrderName}"/>
        </div>
        <div class="select-box w135">
            <input type="hidden" name="culturalOrderType" id="culturalOrderType" value="${cmsCulturalOrderOrder.culturalOrderType}"/>
            <div id="culturalOrderTypeDiv" class="select-text" data-value="">点单类型</div>
	            <ul id="culturalOrderTypeUl" class="select-option">
	            	<li data-option="">点单类型</li>
	            </ul>            
        </div>
        <div class="select-box w135">
            <input type="hidden" name="culturalOrderOrderStatus" id="culturalOrderOrderStatus" value="${cmsCulturalOrderOrder.culturalOrderOrderStatus}"/>
            <div id="culturalOrderStatusDiv" class="select-text" data-value="">状态</div>
	            <ul id="culturalOrderStatusUl" class="select-option">
	            	<li data-option="">状态</li>
	            	<li data-option="0">待处理</li>
	            	<li data-option="1">已确认</li>
	            	<li data-option="2">已拒绝</li>
	            </ul>            
        </div>
        <div class="select-btn">
            <input type="button" value="搜索" onclick="search();"/>
        </div>
        <div class="select-btn" style="float:right;margin-right:40px">
			<input type="button" onclick="toBatchDeal();" value="批量处理" style="margin-right:5px;"/>
		</div>
    </div>
	<div class="main-content pt10">
	    <table width="100%">
	        <thead>
	        <tr>
	        	<th width="20px"><input type="checkbox" id="chooseAll" onclick="checkAll();"/></th>
	            <th width="30px">序号</th>
	            <th width="200px" class="title">标题</th>
	            <th width="50px">类型</th>
	            <th width="100px">日期</th>
	            <th width="100px">时段</th>
	            <th width="200px">地址</th>
	            <th>说明</th>
	            <th width="80px">账户</th>
	            <th width="80px">电话</th>
	            <th width="200px">报名时间</th>
	            <th width="60px">订单状态</th>
	            <th width="100px">管理</th>
	        </tr>
	        </thead>
	        <c:if test="${empty orderOrderList}">
	            <tr>
	                <td colspan="13"><h4 style="color:#DC590C">暂无数据!</h4></td>
	            </tr>
	        </c:if>
	        <tbody>
	        <c:forEach items="${orderOrderList}" var="order" varStatus="st">
	            <tr>
	            	<td>
	            		<c:if test="${order.culturalOrderOrderStatus == 0}">
	            		<input type="checkbox" value="${order.culturalOrderOrderId}" onclick="checkCheckbox();"/>
	            		</c:if>
	            	</td>
	                <td>${st.index+1}</td>
	                <td class="title">${order.culturalOrderName}</td>
	             	<td>${order.culturalOrderTypeName}</td>
	                <td>
	                	<c:if test="${order.culturalOrderLargeType == 1}">
	                		<fmt:formatDate pattern="yyyy-MM-dd" value="${order.culturalOrderEventDate}"/>
	                		
	                	</c:if>
	                	<c:if test="${order.culturalOrderLargeType == 2}">
	                		<fmt:formatDate pattern="yyyy-MM-dd" value="${order.culturalOrderOrderDate}"/>
	                	</c:if>
	                </td>
	                <td>
	                	<c:if test="${order.culturalOrderLargeType == 1}">
	                		${order.culturalOrderEventTime}
	                	</c:if>
	                	<c:if test="${order.culturalOrderLargeType == 2}">
	                		${order.culturalOrderOrderPeriod}
	                	</c:if>
	                </td>
	                <td>
	                	<c:if test="${order.culturalOrderLargeType == 1}">
	                		${order.culturalOrderAddress}
	                	</c:if>
	                	<c:if test="${order.culturalOrderLargeType == 2}">
	                		${order.culturalOrderOrderAddress}
	                	</c:if>
	                </td>
	                <td>${order.userDescription}</td>
	                <td>${order.userName}</td>
	                <td>${order.userMobileNo} </td>
	                <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${order.createTime}"/></td>
	                <td>
	                	<c:choose>
	                		<c:when test="${order.culturalOrderOrderStatus == 0}">
	                			待处理
	                		</c:when>
	                		<c:when test="${order.culturalOrderOrderStatus == 1}">
	                			已确认
	                		</c:when>
	                		<c:when test="${order.culturalOrderOrderStatus == 2}">
	                			已拒绝
	                		</c:when>
	                		<c:when test="${order.culturalOrderOrderStatus == 3}">
	                			已取消
	                		</c:when>
	                	</c:choose>
	                </td>
	                <td>
	                	<c:if test="${order.culturalOrderOrderStatus == 0}">
	                		<c:if test="${order.culturalOrderLargeType == 2}">
	                		<a href="javascript:editCulturalOrderOrder('${order.culturalOrderOrderId}')" style="margin-left:8px;">修改</a>
	                		</c:if>
	                		<a href="javascript:dealCulturalOrderOrder('${order.culturalOrderOrderId}')" style="margin-left:8px;">处理订单</a>
	                	</c:if>
	                </td>
	            </tr>
	        </c:forEach>
	        </tbody>
	    </table>
	    <c:if test="${not empty orderOrderList}">
	        <input type="hidden" id="page" name="page" value="${page.page}" />
	        <div id="kkpager"></div>
	    </c:if>
	</div>
</form>
</body>
</html>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="java.util.Date"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>活动列表--文化云</title>
<%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
<%@include file="/WEB-INF/why/common/limit.jsp"%>
<link rel="stylesheet" type="text/css"
	href="${path}/STATIC/css/dialog-back.css" />
<script type="text/javascript"
	src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
<script type="text/javascript">
	seajs.use([ '${path}/STATIC/js/dialogBack/src/dialog-plus' ], function(
			dialog) {
		window.dialog = dialog;
	});

	//** 日期控件
	$(function() {
		$(".cur-date-start-btn").on("click", function() {
			WdatePicker({
				el : 'curDateStartHidden',
				dateFmt : 'yyyy-MM-dd',
				doubleCalendar : true,
				minDate : '',
				maxDate : '#F{$dp.$D(\'curDateEndHidden\')}',
				position : {
					left : -224,
					top : 8
				},
				isShowClear : false,
				isShowOK : true,
				isShowToday : false,
				onpicked : pickedStartFunc
			})
		})
		$(".cur-date-end-btn").on("click", function() {
			WdatePicker({
				el : 'curDateEndHidden',
				dateFmt : 'yyyy-MM-dd',
				doubleCalendar : true,
				minDate : '#F{$dp.$D(\'curDateStartHidden\')}',
				position : {
					left : -224,
					top : 8
				},
				isShowClear : false,
				isShowOK : true,
				isShowToday : false,
				onpicked : pickedendFunc
			})
		}) 
		$(".order-start-btn").on("click", function() {
			WdatePicker({
				el : 'orderCreateTimeStartHidden',
				dateFmt : 'yyyy-MM-dd',
				doubleCalendar : true,
				minDate : '',
				maxDate : '#F{$dp.$D(\'orderCreateTimeEndHidden\')}',
				position : {
					left : -224,
					top : 8
				},
				isShowClear : false,
				isShowOK : true,
				isShowToday : false,
				onpicked : pickedOrderStartFunc
			})
		})
		$(".order-end-btn").on("click", function() {
			WdatePicker({
				el : 'orderCreateTimeEndHidden',
				dateFmt : 'yyyy-MM-dd',
				doubleCalendar : true,
				minDate : '#F{$dp.$D(\'orderCreateTimeStartHidden\')}',
				position : {
					left : -224,
					top : 8
				},
				isShowClear : false,
				isShowOK : true,
				isShowToday : false,
				onpicked : pickedOrderendFunc
			})
		})
		
		 $(".cancelRoomOrder").on("click",function(){
	         var roomOrderId = $(this).attr("id");
	         var html = "您确定要取消该订单吗？";
	         dialogConfirm("提示", html, function(){
	           $.post("${path}/cmsRoomOrder/cancelRoomOrder.do",{"roomOrderId":roomOrderId}, function(data) {
	             if (data!=null && data=='success') {
	               window.location.href="${path}/cmsRoomOrder/roomOrderCheckIndex.do";
	             }else{
	               dialogAlert("提示","取消活动室预订订单失败!");
	             }
	           });
	         })
	       });
		
		$(".userInfo").on("click",function(){
			
			var userId=$(this).attr("userId");
			
			 window.location.href="${path}/terminalUser/authInfo.do?userId="+userId;
			
		});
		
	});
	function pickedStartFunc() {
		$dp.$('curDateStart').value = $dp.cal.getDateStr('yyyy-MM-dd');
	}
	function pickedendFunc() {
		$dp.$('curDateEnd').value = $dp.cal.getDateStr('yyyy-MM-dd');
	}
	function pickedOrderStartFunc() {
		$dp.$('orderCreateTimeStart').value = $dp.cal.getDateStr('yyyy-MM-dd');
	}
	function pickedOrderendFunc() {
		$dp.$('orderCreateTimeEnd').value = $dp.cal.getDateStr('yyyy-MM-dd');
	}
	
	$(function() {
		$("input").focus();
		kkpager.generPageHtml({
			pno : '${page.page}',
			total : '${page.countPage}',
			totalRecords : '${page.total}',
			mode : 'click',//默认值是link，可选link或者click
			click : function(n) {
				this.selectPage(n);
				$("#page").val(n);
				formSub('#roomOrderForm');
				return false;
			}
		});
	});


	
	//提交表单
	function formSub(formName) {
		

		 var roomName = $('#roomName').val();
        if (roomName != undefined && roomName == '输入活动室名称') {
            $('#roomName').val("");
        }
		
		$(formName).submit();
	}

	$(function() {
		selectModel();
	});


</script>
<style type="text/css">
.search .search-box input {
    width: 150px!important;
}
.ui-dialog-title, .ui-dialog-content textarea {
	font-family: Microsoft YaHei;
}

.ui-dialog-header {
	border-color: #9b9b9b;
}

.ui-dialog-close {
	display: none;
}

.ui-dialog-title {
	color: #F23330;
	font-size: 20px;
	text-align: center;
}

.ui-dialog-content {
	
}

.ui-dialog-body {
	
}
</style>
</head>
<body>
	<form id="roomOrderForm" action="" method="post">
		
		<div class="site">
			<em>您现在所在的位置：</em>活动室管理&gt;历史订单

		</div>
		<div class="search" style="height:auto">
			<div class="select-box w135">
				<input type="hidden" id="bookStatus" name="bookStatus"
					value="${bookStatus}" />
				<div id="bookStatusDiv" class="select-text" data-value="">
					<c:choose>
						<c:when test="${bookStatus==2 }">
	              	已取消
	            </c:when>
						<c:when test="${bookStatus==3 }">
	               	已验票
	            </c:when>
						<c:when test="${bookStatus==4 }">
	                                                已删除
	            </c:when>
						<c:when test="${bookStatus==5 }">
	               	 已取票
	            </c:when>
	            <c:when test="${bookStatus==6 }">
	               	  已失效
	            </c:when>
						<c:otherwise>
           		  订单状态
				</c:otherwise>
					</c:choose>
				</div>
				<ul class="select-option">
					<li data-option="">订单状态</li>
					<li data-option="2">已取消</li>
					<li data-option="3">已验票</li>
					<li data-option="4">已删除</li>
					<li data-option="5">已取票</li>
					<li data-option="6">已失效</li>
				</ul>
			</div>
				

			<div class="form-table" style="float: left;">
				<p style="float: left; line-height: 42px">活动室开放日期</p>
				<div class="td-time" style="margin-top: 0px; float: left">

					<div class="start w240" style="margin-left: 8px;">
						<span class="text">开始日期</span> <input type="hidden"
							id="curDateStartHidden" /> <input type="text" id="curDateStart"
							name="curDateStart" value="${curDateStart}" readonly /> <i
							class="data-btn cur-date-start-btn"></i>
					</div>
					<span class="txt" style="line-height: 42px;">至</span>
					<div class="end w240">
						<span class="text">结束日期</span> <input type="hidden"
							id="curDateEndHidden" /> <input type="text" id="curDateEnd"
							name="curDateEnd" value="${curDateEnd}" readonly /> <i
							class="data-btn cur-date-end-btn"></i>
					</div>
					<div style="clear:both"></div>
				</div>
				<div style="clear: both"></div>
			</div>

			<div class="search-box" style="width:190px">
				<i></i><input  type="text" id="roomName" name="roomName"
					value="${roomName}" data-val="输入活动室名称" class="input-text" />
			</div>


			<div class="select-btn">
				<input type="button"
					onclick="$('#page').val(1);formSub('#roomOrderForm');" value="搜索" />
			</div>
			<div style="clear: both"></div>
			
		</div>
		<div class="main-content">
			<table width="100%">
				<thead>
					<tr>
						<th>订单号</th>
						<th>预订人</th>
						<th>预订人手机号</th>
						<th>使用者</th>
						<th class="venue">场馆名称</th>
						<th>活动室名称</th>
						<th>订单状态</th>
						<th>活动室日期</th>
						<th>场次</th>
						<th>提交时间</th>
						
					</tr>
				</thead>

				<tbody>

					<c:forEach items="${roomOrderList}" var="roomOrder"
						varStatus="varSta">
						<tr>
							<td>${roomOrder.orderNo }</td>
							<td>${roomOrder.userName }</td>
							<td>${roomOrder.userTel }</td>
							
							<td>${ roomOrder.tuserName}</td>
							
							<td class="venue">${ roomOrder.venueName}</td>
							<td>${ roomOrder.roomName}</td>
							<td>
							<c:choose>
								<c:when test="${roomOrder.bookStatus==2 &&roomOrder.checkStatus ==0}">
									已取消（审核前退订）
								</c:when>
								<c:when test="${roomOrder.bookStatus==2 &&roomOrder.checkStatus ==1}">
									已取消（审核后退订）
								</c:when>
								<c:when test="${roomOrder.bookStatus==2 &&roomOrder.checkStatus ==2}">
									已取消（审核未通过）
								</c:when>
								<c:when test="${roomOrder.bookStatus==6}">
									已过期
								</c:when>
								<c:when test="${roomOrder.bookStatus==4}">
									已删除
								</c:when>
								<c:when test="${roomOrder.bookStatus==3}">
									已验票
								</c:when>
								<c:when test="${roomOrder.bookStatus==5}">
									已取票
								</c:when>
							</c:choose>
								</td>
							<td>${ roomOrder.curDates}</td>
							<td>${ roomOrder.openPeriod }</td>
							<td><fmt:formatDate value="${roomOrder.orderCreateTime }"
									pattern="yyyy/MM/dd HH:mm:ss" /></td>
							
						</tr>
					</c:forEach>
					<c:if test="${empty roomOrderList}">
						<tr>
							<td colspan="10"><h4 style="color: #DC590C">暂无数据!</h4></td>
						</tr>
					</c:if>
				</tbody>
			</table>
			<c:if test="${not empty roomOrderList}">
				<input type="hidden" id="page" name="page" value="${page.page}" />
				<div id="kkpager"></div>
			</c:if>
		</div>
	</form>
</body>
</html>
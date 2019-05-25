<%@ page language="java" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>

<title>文化云</title>
<%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
<%@include file="/WEB-INF/why/common/limit.jsp"%>
<script type="text/javascript"
	src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
<script type="text/javascript">
	seajs.use([ '${path}/STATIC/js/dialogBack/src/dialog-plus' ], function(
			dialog) {
		window.dialog = dialog;
	});
</script>

<script type="text/javascript">
	$(function() {
		kkpager.generPageHtml({
			pno : '${page.page}',
			total : '${page.countPage}',
			totalRecords : '${page.total}',
			mode : 'click',//默认值是link，可选link或者click
			click : function(n) {
				this.selectPage(n);
				$("#page").val(n);
				doSearchUser('#form');
				return false;
			}
		});

	});

		

	function doSearchUser(formName) {
		if ($("#machineCode").val() == "输入取票机编码") {
			$("#machineCode").val("");
		}
		 $(formName).submit();
	}


</script>
</head>
<body>

	<div class="site">
		<em>您现在所在的位置：</em>运维管理 &gt;取票机管理
	</div>
	<form action="${path}/ticketMachine/list.do"
		id="form" method="post">
	
	
		<div class="form-table" style="width: 600px; font-size: 16px">
			
			<table>
			<thead>
					<tr>
						<th>取票机编码</th>
						<th>最后链接时间</th>
					</tr>
			</thead>
			
			<c:forEach items="${allTicketMachineList }" var="ticketMachine">
			<tr>
				<td>${ticketMachine.machineCode }</td>
				<td><fmt:formatDate value="${ ticketMachine.dateTime }"  pattern="yyyy-MM-dd HH:mm" /></td>
			</tr>
			</c:forEach>
			</table>
			<div style="clear: both"></div>
		</div>
		<div class="search">
			<div class="search-box" style="float: left;">
				<i></i><input class="input-text" data-val="输入取票机编码"
					name="machineCode"
					value="<c:if test="${not empty ticketMachine.machineCode}">${ticketMachine.machineCode}</c:if><c:if test="${empty ticketMachine.machineCode}">输入取票机编码</c:if>"
					type="text" id="machineCode" />
			</div>
			


			<div class="select-btn" style="float: left;">
				<input type="button" value="搜索"
					onclick="$('#page').val(1);doSearchUser('#form')" />
			</div>
		
			
			<div style="clear: both"></div>
		</div>
		
		<div class="main-content">
			<table width="100%">
				<thead>
					<tr>
						<th>取票机</th>
						<th>订单号</th>
						<th>活动名称</th>
						<th>打印时间</th>
						<th>取票数</th>
					</tr>
				</thead>
				<tbody id="list-table">
					
					<c:if test="${null != list}">
						<c:forEach items="${list}" var="dataList" varStatus="status">
						
							<tr>
							<td>${dataList.machineCode }</td>
							<td>${dataList.orderNumber }</td>
							<td>${dataList.activityName }</td>
							<td><fmt:formatDate value="${ dataList.dateTime }"  pattern="yyyy-MM-dd HH:mm" /></td>
							<td>${dataList.ticketCount }</td>
							</tr>
						</c:forEach>
					</c:if>
					<c:if test="${empty list}">
						<tr>
							<td colspan="5">
								<h4 style="color: #DC590C">暂无数据!</h4>
							</td>
						</tr>
					</c:if>
				</tbody>
			</table>
			<c:if test="${not empty list}">
				<input type="hidden" id="page" name="page" value="${page.page}" />
				<div id="kkpager"></div>
			</c:if>
		</div>
	</form>
</body>
</html>
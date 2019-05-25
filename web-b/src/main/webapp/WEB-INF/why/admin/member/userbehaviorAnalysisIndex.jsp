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

	seajs.config({
	    alias: {
	        "jquery": "jquery-1.10.2.js"
	    }
	});

	seajs.use([ '${path}/STATIC/js/dialogBack/src/dialog-plus' ], function(
			dialog) {
		window.dialog = dialog;
	});
	
	function cloudInt(){
		
		var ids="";
		
		$("#list-table :checkbox").each(function () {
			  
			var checked=$(this).prop("checked");
			
			if(checked)
				ids+=$(this).val()+",";
		  });
		
		if(ids.length>0)
		{
			ids = ids.substring(0, ids.length-1);
			
			dialog(
    				{
    					url : '${path}/userIntegral/cloudIntegral.do?userId='+ids,
    					title : '云叔积分',
    					width : 520,
    					height : 360,
    					fixed : true

    				}).showModal();
    		return false;
		}
	}
	
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
				doSearchUser('#terminalUserForm');
				return false;
			}
		});

		$(".userId").click(function() {

			var result = false;

			$("#list-table :checkbox").each(function() {

				var checked = $(this).prop("checked");

				if (checked) {
					result = true;
					return false;
				}
			});

			if (result) {
				$("#cloudBtn").prop("disabled", false);
			} else {
				$("#cloudBtn").prop("disabled", true);
			}
		});

		selectModel();

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
		

		

	});

	function doSearchUser(formName) {
		if ($("#userMobileNo").val() == "输入手机号码") {
			$("#userMobileNo").val("");
		}
		$(formName).submit();
	}

	function pickedStartFunc() {
		$dp.$('curDateStart').value = $dp.cal.getDateStr('yyyy-MM-dd');
	}
	function pickedendFunc() {
		$dp.$('curDateEnd').value = $dp.cal.getDateStr('yyyy-MM-dd');
	}

	//全选或全不选
	function selectActivityIds() {

		var checked = $("#checkAll").prop("checked");

		$("#list-table :checkbox").each(function() {

			if (checked) {
				$(this).prop("checked", true);
			} else {
				$(this).prop("checked", false);
			}
		});

		if (!checked) {
			$("#cloudBtn").prop("disabled", true);
		} else {
			$("#cloudBtn").prop("disabled", false);
		}
	}
	
	function exportExcel() {
		
		var dateNowNum=parseInt($("#dateNowNum").val());
		var dateStartDateNum=parseInt($("#dateStartDateNum").val());
		
		var day=dateNowNum-dateStartDateNum;
		
		if(day<=30)
		{
			if ($("#userMobileNo").val() == "输入手机号码") {
				$("#userMobileNo").val("");
			}
			
			data=$("#terminalUserForm").serialize();
			
			 location.href = "${path}/terminalUser/exportUserAnalysisList.do?"+data
		}
		else
		{
			alert("请搜索近30天内数据进行导出！")
		}
		
	 }
	
	
	function importUser(){
		
		dialog({
            url: '${path}/terminalUser/importUser.do',
            title: '导入用户',
            width: 500,
            height: 300,
            fixed: true
        }).showModal();
        return false;          
		
	}

	
</script>
</head>
<body>

	<div class="site">
		<em>您现在所在的位置：</em>运维管理 &gt;用户行为分析
	</div>
	<form action="${path}/terminalUser/userbehaviorAnalysisIndex.do"
		id="terminalUserForm" method="post">
	
		<input type="hidden" value="${user.userIsDisable}"
			name="userIsDisable" id="userIsDisable" />
		<input type="hidden" value="${dateNowNum }" id="dateNowNum" />
		<input type="hidden" value="${dateStartDateNum }" id="dateStartDateNum" />
		<div class="form-table" style="width: 600px; font-size: 16px">
			
			<p style="float: left; line-height: 42px">微信注册数：</p>
			<div class="select-btn"
				style="float: left; line-height: 42px; width: 100px">${ userRegisterCountList[0] }
			</div>
			<p style="float: left; line-height: 42px">子平台注册数：</p>
			<div class="select-btn"
				style="float: left; line-height: 42px; width: 100px">${ userRegisterCountList[1] }
			</div>
			<p style="float: left; line-height: 42px">注册数：</p>
			<div class="select-btn"
				style="float: left; line-height: 42px; width: 100px">${ userRegisterCountList[2] }
			</div>
			<div style="clear: both"></div>
		</div>
		<div class="search">
			<div class="search-box" style="float: left;">
				<i></i><input class="input-text" data-val="输入手机号码"
					name="userMobileNo"
					value="<c:if test="${not empty user.userMobileNo}">${user.userMobileNo}</c:if><c:if test="${empty user.userMobileNo}">输入手机号码</c:if>"
					type="text" id="userMobileNo" />
			</div>
			


			<div class="form-table" style="float: left;margin-left:20px;">
				<p style="float: left; line-height: 42px">注册日期</p>
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
					<div style="clear: both"></div>
				</div>
				<div style="clear: both"></div>
			</div>
			<div class="select-btn" style="float: left;">
				<input type="button" value="搜索"
					onclick="$('#page').val(1);doSearchUser('#terminalUserForm')" />
			</div>
			
			<div class="select-btn" style=" float: right;">
				<input type="button" value="导出"
					onclick="exportExcel();" />
			</div>
			
			<div class="select-btn" style=" float: right; padding-right: 10px">
				<input type="button" value="导入账号"
					onclick="importUser();" />
			</div>
			
			<div style="clear: both"></div>
			
			<div class="form-table" style="float: left;width:480px">
			<p style="float: left; line-height: 42px">批量操作：</p>
		<div class="select-btn">
					<input type="button"
					onclick="cloudInt();" id="cloudBtn" disabled="true" value="云叔积分" />
					</div>			
		</div>
		</div>
		
		<div class="main-content">
			<table width="100%">
				<thead>
					<tr>
						<th ><input type="checkbox" name="checkAll" id="checkAll" onclick="selectActivityIds()" />全选 </th>
						<th>用户名</th>
						<%--<th>所属站点</th>--%>
						<th>真实姓名</th>
						<th>注册手机号</th>
						<th>个人信息手机号</th>
						<th>订单使用手机号</th>
						<th>积分</th>
						<th>注册来源</th> 
						<th>注册时间</th>
					</tr>
				</thead>
				<tbody id="list-table">
					<%
						int i = 0;
					%>
					<c:if test="${null != userList}">
						<c:forEach items="${userList}" var="dataList" varStatus="status">
							<%
								i++;
							%>
							<tr>

								<td><input type="checkbox" class="userId" name="userId"  value="${dataList.userId}" /></td> 
								<c:choose>
									<c:when test="${not empty dataList.userName}">
										<td><a
											href="${path}/terminalUser/viewTerminalUser.do?userId=${dataList.userId}"
											target="main">${dataList.userName}</a></td>
									</c:when>
									<c:otherwise>
										<td class="title"><a href="javascript:;"></a></td>
									</c:otherwise>
								</c:choose>
								<td>${dataList.userNickName}</td>
								<%--<c:choose>--%>
								<%--<c:when test="${not empty dataList.userArea}">--%>
								<%--<td>${fn:substringAfter(dataList.userArea, ',')}</td>--%>
								<%--</c:when>--%>
								<%--<c:otherwise>--%>
								<%--<td></td>--%>
								<%--</c:otherwise>--%>
								<%--</c:choose>--%>
								<td><c:choose>
										<c:when test="${! empty dataList.userMobileNo}">
							
							 ${dataList.userMobileNo }
							</c:when>
										<c:otherwise>

										</c:otherwise>

									</c:choose></td>
								<td><c:choose>
										<c:when test="${! empty dataList.userTelephone}">
							
							${dataList.userTelephone}
							</c:when>
										<c:otherwise>

										</c:otherwise>
									</c:choose></td>

								<td><c:choose>
										<c:when test="${! empty dataList.orderUserTelephone }">
							
							${dataList.orderUserTelephone}
							</c:when>
										<c:otherwise>

										</c:otherwise>
									</c:choose></td>

								<td><a
									href="${path}/userIntegral/userIntegralIndex.do?userId=${dataList.userId}"
									target="main">${dataList.integralNow}</a></td>
								
								<td>
									<c:choose>
										<c:when test="${!empty dataList.sysId}">
											子平台
										</c:when>
										<c:when test="${ dataList.registerOrigin==1}">
											文化云
										</c:when>
										<c:when test="${ dataList.registerOrigin==2}">
											QQ
										</c:when>
										<c:when test="${ dataList.registerOrigin==3}">
											新浪微博 
										</c:when>
										<c:when test="${ dataList.registerOrigin==4}">
											微信
										</c:when>
										<c:when test="${ dataList.registerOrigin==5}">
											地推
										</c:when>
										<c:when test="${ dataList.registerOrigin==6}">
											市场导入
										</c:when>
										<c:when test="${ dataList.registerOrigin==7}">
											渠道导入
										</c:when>
										<c:when test="${ dataList.registerOrigin==8}">
											微信(地推)
										</c:when>
										<c:when test="${ dataList.registerOrigin==9}">
											微信(春华秋实)
										</c:when>
										<c:when test="${ dataList.registerOrigin==10}">
											手机验证码登录注册
										</c:when>
										<c:when test="${ dataList.registerOrigin==11}">
											配送中心投票
										</c:when>
										<c:otherwise>
											文化云
										</c:otherwise>
									</c:choose>
								</td>
								<td><fmt:formatDate value="${dataList.createTime}"
										pattern="yyyy-MM-dd HH:mm" /></td>
								

							</tr>
						</c:forEach>
					</c:if>
					<c:if test="${empty userList}">
						<tr>
							<c:choose>
								<c:when test="${user.userIsDisable == 1}">
									<td colspan="10">
										<h4 style="color: #DC590C">暂无数据!</h4>
									</td>
								</c:when>
								<c:otherwise>
									<td colspan="9">
										<h4 style="color: #DC590C">暂无数据!</h4>
									</td>
								</c:otherwise>
							</c:choose>
						</tr>
					</c:if>
				</tbody>
			</table>
			<c:if test="${not empty userList}">
				<input type="hidden" id="page" name="page" value="${page.page}" />
				<div id="kkpager"></div>
			</c:if>
		</div>
	</form>
</body>
</html>
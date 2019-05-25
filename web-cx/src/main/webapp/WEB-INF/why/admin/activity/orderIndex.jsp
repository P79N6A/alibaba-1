<%@ page import="java.util.Date"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>订单列表--文化云</title>
<%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
<%@include file="/WEB-INF/why/common/limit.jsp"%>
<link rel="stylesheet" type="text/css"
	href="${path}/STATIC/css/dialog-back.css" />
<script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
<!--文本编辑框 end-->
<!-- dialog start -->
<link rel="stylesheet" type="text/css"
	href="${path}/STATIC/css/dialog-back.css" />
<script type="text/javascript"
	src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
<script type="text/javascript"
	src="${path}/STATIC/js/ckeditor/sample.js"></script>
<script type="text/javascript">
	//导出excel
	function exportOrderExcel() {
		var searchKey = $("#searchKey").val();
		if (searchKey == undefined || searchKey == "请输入订单号\\手机号\\活动名称") {
			searchKey = "";
		}
		var activityArea = $("#activityArea").val();
		if (activityArea == undefined) {
			activityArea = "";
		}
		var orderVotes = $("#orderVotes").val();
		if (orderVotes == undefined || orderVotes == "预定票数") {
			orderVotes = "";
		}
		var orderPayStatus = $("#orderPayStatus").val();
		if (orderPayStatus == undefined || orderPayStatus == "订单状态") {
			orderPayStatus = "";
		}
		var activitySalesOnline = $("#activitySalesOnline").val();
		if (activitySalesOnline == undefined || activitySalesOnline == "选座方式") {
			activitySalesOnline = "";
		}
		location.href = "${path}/order/exportOrderExcel.do?searchKey="
				+ searchKey + "&activityArea=" + activityArea + "&orderVotes="
				+ orderVotes + "&orderPayStatus=" + orderPayStatus
				+ "&activitySalesOnline=" + activitySalesOnline;
	}

	$(function() {
		seajs.use([ '${path}/STATIC/js/dialogBack/src/dialog-plus' ], function(
				dialog) {
			window.dialog = dialog;
		});
		$("input").focus();
		selectModel();

		page();//分页

		/*
		全 部区县
		 */
		var venueProvince = '${user.userProvince}';
		var venueCity = '${user.userCity}';
		var venueArea = '${user.userCounty}';
		var ulHtml = "<li data-option=''>全部区县</li>";
		var divText = "全部区县";
		var loc = new Location();
		var a = new Array();
		var defaultAreaId = $("#activityArea").val();
		a = loc.find('0,' + venueProvince.split(",")[0]);
		$.each(a, function(k, v) {
			var Id = k;
			var Text = v;
			ulHtml += '<li data-option="' + Id + '">' + Text + '</li>';
			if (defaultAreaId == Id) {
				divText = Text;
			}
		})
		a = loc.find('0,' + venueProvince.split(",")[0] + ','
				+ venueCity.split(",")[0]);
		$.each(a, function(k, v) {
			var area = a[k];
			var areaId = k;
			var areaText = v;
			ulHtml += '<li data-option="' + areaId + '">' + areaText + '</li>';
			if (defaultAreaId == areaId) {
				divText = areaText;
			}
		})
		$("#areaDiv").html(divText);
		$("#areaUl").append(ulHtml);

	});

	window.console = window.console || {
		log : function() {
		}
	}
	function cancelUserOrder(activityOrderId) {
		/*var dialogWidth = ($(window).width() * 0.8);*/
		var dialogWidth = ($(window).width() < 800) ? ($(window).width() * 0.6)
				: 800;
		/* var dialogHeight = ($(window).height() < 600) ? ($(window).height() * 0.6) : 600;*/
		dialog(
				{
					url : '${path}/order/preCancelUserOrder.do?activityOrderId='
							+ activityOrderId,
					title : '取消用户订单',
					width : 500,
					/*  height:dialogHeight,*/
					fixed : false,
					data : {
					/*  seatInfo: $("#seatInfo").val()*/
					}, // 给 iframe 的数据
					onclose : function() {
						if (this.returnValue) {
							//console.log(this.returnValue);
							windows.reload();
						}
						//dialog.focus();
					}
				}).showModal();
		return false;
	}

	function page() {
		kkpager.generPageHtml({
			pno : '${page.page}',
			total : '${page.countPage}',
			totalRecords : '${page.total}',
			mode : 'click',
			click : function(n) {
				this.selectPage(n);
				$("#page").val(n);
				formSub('#activityForm');
				return false;
			}
		});
	}
	//提交表单
	//    function formSub(formName){
	//
	//      var orderNumber=$('#orderNumber').val();
	//
	//      var orderPayStatus =$('#orderPayStatus').val();
	//
	//      var activitySalesOnline =$('#activitySalesOnline').val();
	//
	//      var activityIsFree = $('#activityIsFree').val();
	//
	//      if(orderNumber!=undefined && orderNumber=='输入订单号'){
	//        $('#orderNumber').val("");
	//      }
	//
	//      if(orderPayStatus != undefined && orderPayStatus == '订单状态' && orderPayStatus == 0){
	//        $('#orderPayStatus').val("");
	//      }
	//      if(activitySalesOnline != undefined && activitySalesOnline == '选坐方式' && activitySalesOnline ==0){
	//        $('#activitySalesOnline').val("");
	//      }
	//      if(activityIsFree != undefined && activityIsFree == '全部订单' && activityIsFree == 0){
	//        $('#activityIsFree').val("");
	//      }
	//
	///*      if(activityArea != undefined && activityArea == '全部订单' && activityArea == 0){
	//        $('#activityArea').val("");
	//      }*/
	//
	//      //场馆
	////      $('#venueId').val($('#loc_venue').val());
	////      $('#venueType').val($('#loc_category').val());
	////      $('#venueArea').val($('#loc_area').val());
	//      $(formName).submit();
	//    }
	function formSub(formName) {
		var searchKey = $("#searchKey").val();
		var orderVotes = $("#orderVotes").val();
		var orderPayStatus = $("#orderPayStatus").val();
		var activitySalesOnline = $("#activitySalesOnline").val();
		if (searchKey == "请输入订单号\\手机号\\活动名称") { //"\\"代表一个反斜线字符\
			$("#searchKey").val("");
		}
		if (orderVotes == "预定票数") {
			$("#orderVotes").val("");
		}
		if (orderPayStatus == "订单状态") {
			$("#orderPayStatus").val("");
		}
		if (activitySalesOnline == "选座方式") {
			$("#activitySalesOnline").val("");
		}
		$(formName).submit();
	}
	/**
	 *  取消订单
	 */
	function cancelOrder(id) {

		dialogConfirm("取消订单", "您确定要取消该订单吗？", removeParent);
		function removeParent() {
			$.post("${path}/order/updateOrderByActivityOrderId.do", {
				activityOrderId : id
			}, function(data) {
				if (data == 'success') {
					dialogAlert("提示", "订单取消成功", function() {
						location.reload();
					});
				} else {
					dialogAlert("提示", "订单取消失败:" + data);
				}
			});
		}
	}

	/**
	 *  发送消息
	 */
	function sendMessger(id) {
		dialogConfirm("发送短消息", "您确定发送短消息吗？", removeParent);
		function removeParent() {
			$.post("${path}/order/sendSmsMessage.do", {
				'activityOrderId' : id
			}, function(data) {
				if (data == "success") {
					dialogAlert("提示", "短信发送成功!");
					//$("#activityForm").submit();
				} else {
					dialogAlert("提示", "短信发送失败!");
				}
			});
		}
	}

	function check(orderValidateCode) {

		dialogConfirm("核销", "您确定要核销此订单吗？", function() {

			orderValidateCode = trim(orderValidateCode);
			var asm = new Date().getTime();
			$.post("${path}/order/checkOrderNumValid.do?asm=" + asm, {
				orderValidateCode : orderValidateCode
			}, function(data) {
				var json = $.parseJSON(data);
				if (json != undefined && json.status == "0") {

					var formData = new Array();

					var userId = json.data[0].userId;
					var orderPayStatus = json.data[0].orderPayStatus;
					var seats = json.data[0].activitySeats;

					formData.push({
						'name' : 'orderValidateCode',
						'value' : orderValidateCode
					});
					formData.push({
						'name' : 'userId',
						'value' : userId
					});
					formData.push({
						'name' : 'orderPayStatus',
						'value' : orderPayStatus
					});
					formData.push({
						'name' : 'seats',
						'value' : seats
					});

					$.post("${path}/order/updateOrderNumStatus.do?asm=" + asm,
							formData, function(data) {
								var json = $.parseJSON(data);
								if (json != undefined && json.status == "0") {
									dialogAlert('提示', json.data);
									location.reload();
								} else {
									dialogAlert('提示', json.data);
								}
							});
				} else {
					dialogAlert('提示', json.data);
				}
			});

		});
	}

	function trim(str) {
		return str.replace(/[ ]/g, ""); //去除字符算中的空格
	}
</script>
</head>
<body>
	<form id="activityForm"
		action="${path}/order/queryAllUserOrderIndex.do" method="post">

		<div class="site">
			<em>您现在所在的位置：</em>订单管理 &gt;订单列表
		</div>
		<div class="search">
			<div class="search-box">
				<i></i><input id="searchKey" name="searchKey" class="input-text"
					data-val="请输入订单号\手机号\活动名称" type="text"
					value="<c:choose><c:when test="${not empty searchKey}">${searchKey}</c:when><c:otherwise>请输入订单号\手机号\活动名称</c:otherwise></c:choose>" />
			</div>

			<div class="select-box w135">
				<input type="hidden" id="activityArea" name="activityArea"
					value="${activity.activityArea}" />
				<div id="areaDiv" class="select-text" data-value="">全部区县</div>
				<ul class="select-option" id="areaUl">
				</ul>
			</div>

			<div class="select-box w135">
				<input type="hidden"
					value="<c:choose><c:when test="${not empty activity.orderVotes}">${activity.orderVotes}</c:when><c:otherwise>预定票数</c:otherwise></c:choose>"
					name="orderVotes" id="orderVotes" />
				<div class="select-text" data-value="">
					<c:choose>
						<c:when test="${activity.orderVotes == 1}">
            1张
          </c:when>
						<c:when test="${activity.orderVotes == 2}">
            2张
          </c:when>
						<c:when test="${activity.orderVotes == 3}">
            3张
          </c:when>
						<c:when test="${activity.orderVotes == 4}">
            4张
          </c:when>
						<c:when test="${activity.orderVotes == 5}">
            5张
          </c:when>
						<c:otherwise>
            预定票数
          </c:otherwise>
					</c:choose>
				</div>
				<ul class="select-option">
					<li data-option="">全部</li>
					<li data-option="1">1张</li>
					<li data-option="2">2张</li>
					<li data-option="3">3张</li>
					<li data-option="4">4张</li>
					<li data-option="5">5张</li>
				</ul>
			</div>

			<div class="select-box w135">
				<input type="hidden"
					value="<c:choose><c:when test="${not empty activity.orderPayStatus}">${activity.orderPayStatus}</c:when><c:otherwise>订单状态</c:otherwise></c:choose>"
					name="orderPayStatus" id="orderPayStatus" />
				<div class="select-text" data-value="">
					<c:choose>
						<c:when test="${activity.orderPayStatus==1}">
            未出票
          </c:when>
						<c:when test="${activity.orderPayStatus==2}">
            已取消
          </c:when>
						<c:when test="${activity.orderPayStatus==3}">
            已出票
          </c:when>
						<c:when test="${activity.orderPayStatus==4}">
            已验票
          </c:when>
						<c:when test="${activity.orderPayStatus ==5}">
            已失效
          </c:when>
						<c:otherwise>
            订单状态
          </c:otherwise>
					</c:choose>
				</div>
				<ul class="select-option">
					<li data-option="">全部</li>
					<li data-option="1">未出票</li>
					<li data-option="2">已取消</li>
					<li data-option="3">已出票</li>
					<li data-option="4">已验票</li>
					<li data-option="5">已失效</li>
				</ul>
			</div>

			<div class="select-box w135">
				<input type="hidden"
					value="<c:choose><c:when test="${not empty activity.activitySalesOnline}">${activity.activitySalesOnline}</c:when><c:otherwise>选座方式</c:otherwise></c:choose>"
					name="activitySalesOnline" id="activitySalesOnline" />
				<div class="select-text" data-value="">
					<c:choose>
						<c:when test="${activity.activitySalesOnline == 'Y'}">
            在线选座
          </c:when>
						<c:when test="${activity.activitySalesOnline == 'N'}">
            自由入座
          </c:when>
						<c:otherwise>
            选座方式
          </c:otherwise>
					</c:choose>
				</div>
				<ul class="select-option">
					<li data-option="">全部</li>
					<li data-option="Y">在线选座</li>
					<li data-option="N">自由入座</li>
				</ul>
			</div>

			<%--    <div class="select-box w110">
          <input type="hidden" value="${activity.activityIsFree}" name="activityIsFree" id="activityIsFree" />
          <div class="select-text"  data-value="">
            <c:choose>
              <c:when test="${activity.activityIsFree == 1}">
                免费订单
              </c:when>
              <c:when test="${activity.activityIsFree == 2}">
                收费订单
              </c:when>
              <c:otherwise>
                全部订单
              </c:otherwise>
            </c:choose>
          </div>
          <ul class="select-option">
            <li data-option="">全部订单</li>
            <li data-option="1">免费</li>
            <li data-option="2" >收费</li>
          </ul>
        </div>--%>

			<div class="select-btn">
				<input type="button"
					onclick="$('#page').val(1);formSub('#activityForm');" value="搜索" />
			</div>
			<div class="search-total">
				<div class="select-btn">
					<input type="button" onclick="exportOrderExcel();" value="导出" />
				</div>
				<%--待审核活动<span class="red">20</span>条--%>
			</div>
		</div>
		<div class="main-content">
			<table width="100%">
				<thead>
					<tr>
						<th>订单号</th>
						<th class="title">活动名称</th>
						<th>所属区县</th>
						<th class="venue">所属场馆</th>
						<th>票数</th>
						<th>类型</th>
						<th>日期</th>
						<th>场次</th>
						<th>预订人</th>
						<th>订单时间</th>
						<th>订单状态</th>
						<th>验票人</th>
						<th>验票时间</th>
						<th>管理</th>
					</tr>
				</thead>

				<tbody>
					<%
						int i = 0;
					%>
					<c:forEach items="${activityList}" var="avct">
						<%
							i++;
						%>
						<tr>
							<td>${avct.orderNumber}</td>
							<td class="title"><c:if
									test="${not empty avct.activityName}">
									<c:set var="activityName" value="${avct.activityName}" />
									<c:out value="${fn:substring(activityName,0,19)}" />
									<c:if test="${fn:length(activityName) > 19}">...</c:if>
								</c:if></td>
							<td><c:if test="${not empty avct.activityArea}">
              ${fn:split(avct.activityArea,",")[1]}
            </c:if> <c:if test="${empty avct.activityArea}">
              未知
            </c:if></td>

							<td class="venue"><c:choose>
									<c:when test="${avct.createActivityCode == 1}">市级自建</c:when>
									<c:when test="${avct.createActivityCode == 2}">区级自建</c:when>
									<c:otherwise>
										<c:if test="${not empty avct.venueName}">
											<c:out escapeXml="true" value="${avct.venueName}" />
										</c:if>
										<c:if test="${ empty avct.venueName}">
                  未知场馆
                </c:if>
									</c:otherwise>
								</c:choose> <%--            <c:if test="${not empty avct.venueName}">
                            <c:out escapeXml="true" value="${avct.venueName}"/>
                          </c:if>
                          <c:if test="${ empty avct.venueName}">
                            未知场馆
                          </c:if>--%></td>
							<td><c:if test="${not empty avct.orderVotes}">
              ${avct.orderVotes}
            </c:if> <c:if test="${empty avct.orderVotes}">
              未知
            </c:if></td>
							<td><c:if test="${not empty avct.activitySalesOnline}">
									<c:if test="${avct.activitySalesOnline=='Y'}">
                在线选座
              </c:if>
									<c:if test="${avct.activitySalesOnline=='N'}">
                自由入座
              </c:if>
								</c:if> <c:if test="${empty avct.activitySalesOnline}">
              未知
            </c:if></td>
							<!-- 新增日期和场次  start  -->
							<td>${avct.eventDate}</td>
							<td>${avct.eventTime}</td>
							<!-- 新增日期和场次  end  -->
							<td><c:if test="${not empty avct.orderName}">
              ${avct.orderName}
            </c:if> <c:if test="${ empty avct.orderName}">
              未知预订人
            </c:if></td>
							<td><c:if test="${not empty avct.orderCreateTime}">
									<fmt:formatDate value="${avct.orderCreateTime}"
										pattern="yyyy-MM-dd HH:mm" />
								</c:if></td>
							<td>
								<!-- 已失效的订单通过时间比较得出 数据库失效状态并没有作用 --> <c:if
									test="${not empty avct.orderPayStatus}">
									<c:if test="${avct.orderPayStatus ==1}">
                未出票
              </c:if>
									<c:if test="${avct.orderPayStatus ==2}">
                已取消
              </c:if>
									<c:if test="${avct.orderPayStatus ==3}">
                已出票
              </c:if>
									<c:if test="${avct.orderPayStatus ==4}">
                已验票
              </c:if>
									<c:if test="${avct.orderPayStatus ==5}">
                已失效
              </c:if>
								</c:if>
							</td>
							<td><c:if test="${not empty avct.orderCheckUser}">
              ${avct.orderCheckUser}
            </c:if></td>
							<td><c:if test="${not empty avct.orderCheckTime}">
									<fmt:formatDate value="${avct.orderCheckTime}"
										pattern="yyyy-MM-dd HH:mm" />
								</c:if></td>
							<td>
								<%--<a  target="main" href="/order/preEditActivity.do?id=${avct.activityId}">修改</a>&nbsp;|&nbsp;--%>
								<%
									if (activityOrderDetailButton) {
								%> <a
								href="${path}/order/viewOrderDetail.do?activityOrderId=${avct.activityOrderId}">查看</a>
								| <a target="_blank"
								onclick="check('${avct.orderValidateCode}')">核销</a> <%
 	}
 %> <c:if
									test="${avct.orderPayStatus ==1}">
									<%
										if (activityOrderCancelButton) {
									%>
									<%
										if (activityOrderDetailButton) {
									%> | <%
										}
									%>
									<c:if test="${avct.activitySalesOnline == 'Y'}">
										<a
											href="javascript:cancelUserOrder('${avct.activityOrderId}')">取消</a>
									</c:if>
									<c:if test="${avct.activitySalesOnline == 'N'}">
										<a href="javascript:cancelOrder('${avct.activityOrderId}')">取消</a>
									</c:if>
									<%
										}
									%>
									<%
										if (activityOrderSendSmsButton) {
									%>
									<%
										if (activityOrderSendSmsButton) {
									%> | <%
										}
									%><a target="_blank"
										onclick="sendMessger('${avct.activityOrderId}')">发消息</a>
									<%
										}
									%>
								</c:if>
							</td>
						</tr>
					</c:forEach>
					<c:if test="${empty activityList}">
						<tr>
							<td colspan="14"><h4 style="color: #DC590C">暂无数据!</h4></td>
						</tr>
					</c:if>
				</tbody>
			</table>
			<c:if test="${not empty activityList}">
				<input type="hidden" id="page" name="page" value="${page.page}" />
				<div id="kkpager"></div>
			</c:if>
		</div>
	</form>
</body>
</html>
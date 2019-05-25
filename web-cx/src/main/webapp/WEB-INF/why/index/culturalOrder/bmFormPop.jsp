<%@ page import="org.apache.commons.lang3.StringUtils ,com.sun3d.why.model.CmsTerminalUser" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
	<%@include file="/WEB-INF/why/common/frontIndexPageFrame.jsp"%>
	<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
	<link type="text/css" rel="stylesheet" href="${path}/STATIC/css/normalize.css" />
	<link type="text/css" rel="stylesheet" href="${path}/STATIC/css/style.css" />
	<link type="text/css" rel="stylesheet" href="${path}/STATIC/css/styleChild.css" />
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
	<script type="text/javascript" src="${path}/STATIC/js/jquery-1.9.0.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/layer/layer.js"></script>

	<title>佛山文化云</title>
	<script type="text/javascript">
		var culturalOrderId 		= '${culturalOrderId}';
		var culturalOrderEventId 	= '${culturalOrderEventId}';
		var culturalOrderEventTime	= '${culturalOrderEventTime}';
		var eventTicketNum			= '${eventTicketNum}';
		var usedTicketNum			= '${usedTicketNum}';
		var culturalOrderEventDate	= '${culturalOrderEventDate}';
		var userId					= '${sessionScope.terminalUser.userId}';
		
		var frameIndex = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
		
		function addBookingInformation(){
			if(userId == ''){
				layer.close(layer.index);
				dialogAlert("系统提示", "请先登录");
                return;	
			}
			
			var params = {
					'culturalOrderId': culturalOrderId,
					'culturalOrderEventId' : culturalOrderEventId,
					'userDescription' : $(".txtArea").val()
			};
			$.post("${path}/culturalOrderOrder/addUserOrder.do", params, function(result){
				parent.layer.close(frameIndex);
				if(result == 'success'){
					successPop();
				}else{
					dialogAlert('系统提示', '添加订单失败');
				}
			});
		}
		
		function closePop(){
			layer.close(layer.index);
			parent.window.location.href = '${path}/culturalOrder/culturalOrderDetail.do?culturalOrderId=' + id + '&culturalOrderLargeType=1&userId=' + userId;
		}
		
		function successPop() {
			// 报名成功
			var successHtml =
				'<div style="padding-top:40px;padding-bottom:20px;">'+
					'<div style="font-size:18px;color:#333333;text-align: center;margin-bottom:15px;">已报名</div>'+
					'<div style="font-size:14px;color:#333333;text-align: center;">请耐心等待确认！</div>'+
				'</div>'+
				'<div class="popBtnBox clearfix">'+
					'<a class="popBtn red" href="javascript:void(0);" onclick="layer.close(layer.index);parent.window.location.href=\'${path}/culturalOrder/culturalOrderDetail.do?culturalOrderId=' + culturalOrderId + '&culturalOrderLargeType=1&userId=' + userId + '\'">关闭</a>'+
					'<a class="popBtn yellow" href="javascript:void(0);" onclick="parent.window.location.href=\'${path}/culturalOrderOrder/culturalOrderUserOrderList.do?culturalOrderLargeType=1\'">查看报名记录</a>'+
				'</div>';
			parent.layer.open({
				type: 1,
				title: '我要报名',
				closeBtn: 1,
				shade: 0.01,
				shadeClose: true,
				resize: false,
				area: ['600px', '270px'],
				content: successHtml
			});
		}
	</script>
</head>

<body style="min-width: auto;">
	<div class="bmInfo">
		<div class="infoWrap clearfix">
			<span class="name">请选择服务日期：</span>
			<div class="txtDiv"><div class="wuChar">${culturalOrderEventDate}</div></div>
		</div>
		<div class="infoWrap clearfix">
			<span class="name">请选择服务时段：</span>
			<div class="txtDiv"><div class="wuChar">${culturalOrderEventTime}</div></div>
		</div>
		<div class="infoWrap clearfix">
			<span class="name">剩余名额：</span>
			<div class="txtDiv">
				<div class="wuChar"><em style="font-size:18px;color: #e63917; ">${eventAvailableTicketNum}</em> / ${eventTicketNum}</div>
			</div>
		</div>
		<div class="infoWrap clearfix">
			<div class="txtDiv" style="width: 100%;">
				<textarea class="txtArea" placeholder="请填写报名说明，限200字以内" maxlength="200"></textarea>
			</div>
		</div>
		<div class="tipsBox">
			<p class="tipsTit">*报名须知</p>
			<p class="tips">${culturalOrderMustKnow}</p>
		</div>
	</div>

	<div class="popBtnBox clearfix" style="padding-bottom: 30px;">
		<a class="popBtn red" id="subBaom" href="javascript:void(0);" onclick="addBookingInformation()">提交报名</a>
	</div>

</body>

</html>

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
	<title>安康文化云</title>
	<script type="text/javascript">
		var culturalOrderId = '${culturalOrderId}';
		var culturalOrderDate = '${culturalOrderDate}';
		var culturalOrderAreaLimit = '${culturalOrderAreaLimit}';
		var culturalOrderDemandLimit = '${culturalOrderDemandLimit}';
		var userId = '${sessionScope.terminalUser.userId}';
		
		var townName = '';
		$(function () {
			var areaLimits = culturalOrderAreaLimit.split(',');
			if(areaLimits[0] == '-1'){
				loadOrderArea();
			}else{
				showAreaLimit(areaLimits[1]);
				loadOrderTown(areaLimits[0]);
			}
		});
		
		function loadOrderTown(townCode){
			$.post("${path}/sysdict/queryChildSysDictByDictCode.do", {dictCode: townCode}, function (data) {
    	        var list = eval(data);
    	        var dictHtml = '';
    	        var otherHtml = '';
    	        for (var i = 0; i < list.length; i++) {
    	            var obj = list[i];
    	            var dictId = obj.dictId;
    	            var dictName = obj.dictName;
    	            $("#orderTownSelect").append('<option value="' + dictId + '">' + dictName + '</option>');
    	        }
    	    });
		}
		
		function loadOrderTownByArea(obj){
			var areaCode = obj.options[obj.selectedIndex].value;
			if(areaCode == 0){
				return;
			}
			$.post("${path}/sysdict/queryChildSysDictByDictCode.do", {dictCode: areaCode}, function (data) {
    	        var list = eval(data);
    	        var dictHtml = '';
    	        var otherHtml = '';
    	        $("#orderTownSelect").empty();
    	        $("#orderTownSelect").append('<option value="0">街道</option>');
    	        for (var i = 0; i < list.length; i++) {
    	            var obj = list[i];
    	            var dictId = obj.dictId;
    	            var dictName = obj.dictName;
    	            $("#orderTownSelect").append('<option value="' + dictId + '">' + dictName + '</option>');
    	        }
    	    });
		}
		
		function loadOrderArea(){
		    var provinceNo = '2822';
	   	 	var cityNo = '2958';
			var loc = new Location();
			var area;
			var area = loc.find('0,' + provinceNo + ',' + cityNo);
	        $.each(area , function(k , v) {
           		$('#orderAreaSelect').append("<option value=\"" + k + "\" onclick='loadOrderTown(\"" + k + "\")'>"+v+"</a></li>");
			});
	        $("#orderAreaSelectDiv").show();
		}
		
		function showAreaLimit(name){
			var str = "<span style='color: red;'>该邀请仅限 : " + name + "</span>";
			$("#townLabelWithDefaultArea").append(str);
		}
		
		function addInvitationInformation(){
			var periodWanted = $('#periodWanted').val();
			var detailedAddress = $('#detailedAddress').val();
			var areaLimits = culturalOrderAreaLimit.split(',');
			if(userId == ''){
				showAlertInfo("请先登录");
				return;
			}
			if(periodWanted == '' || periodWanted == null){
				showAlertInfo("请填写服务时段");
				return;
			}
			if(detailedAddress == '' || detailedAddress == null){
				showAlertInfo("请填写详细地址");
				return;
			}
			
			if(areaLimits[0] == "-1"){
				if($("#orderAreaSelect option:selected").length < 1 || $("#orderAreaSelect option:selected").val() == '0'){
					showAlertInfo("请选择市区");
					return;
				}
			}
			
			if($("#orderTownSelect option:selected").length < 1 || $("#orderTownSelect option:selected").val() == '0'){
				showAlertInfo("请选择县镇");
				return;
			}
			
			var frameIndex = parent.layer.getFrameIndex(window.name);
			var date = new Date(culturalOrderDate);
			
			var params = {
					'culturalOrderId': culturalOrderId,
					'userDescription' : $(".txtArea").val(),
					'culturalOrderOrderDate' : date,
					'culturalOrderOrderPeriod' : periodWanted,
					'culturalOrderOrderArea' :  areaLimits[0] == "-1" ? $("#orderAreaSelect option:selected").attr('value') : culturalOrderAreaLimit,
					'culturalOrderOrderAddress' : detailedAddress,
					'culturalOrderOrderTown' : $("#orderTownSelect option:selected").attr('value')
			};
			$.post("${path}/culturalOrderOrder/addUserOrder.do", params, function(result){
				parent.layer.close(frameIndex);
				if(result == 'success'){
					successPop();
				}else{
					dialogAlert('系统提示', '提交邀请失败');
					return;
				}
			});
			
		}
		
		function showAlertInfo(alertInfo){
			var context = '<div style="font-size:18px;color:#333333;text-align: center;margin-bottom:15px; margin-top: 30px">' + alertInfo + '</div>';
			parent.layer.open({
				type: 1,
				title: '系统提示',
				closeBtn: 1,
				shade: 0.01,
				shadeClose: true,
				resize: false,
				area: ['400px', '200px'],
				content: context
			});
		}
		
		function successPop(){
			var successHtml = 	'<div style="padding-top:40px;padding-bottom:20px;">'+
									'<div style="font-size:18px;color:#333333;text-align: center;margin-bottom:15px;">已邀请</div>'+
									'<div style="font-size:14px;color:#333333;text-align: center;">请耐心等待确认！</div>'+
								'</div>'+
								'<div class="popBtnBox clearfix">'+
									'<a class="popBtn red" href="javascript:void(0);" onclick="layer.close(layer.index);parent.window.location.href=\'${path}/culturalOrder/culturalOrderDetail.do?culturalOrderId=' + culturalOrderId + '&culturalOrderLargeType=2&userId=' + userId + '\'">关闭</a>'+
									'<a class="popBtn yellow" href="javascript:void(0);" onclick="parent.window.location.href=\'${path}/culturalOrderOrder/culturalOrderUserOrderList.do?culturalOrderLargeType=2\'">查看报名记录</a>'+
								'</div>';
			parent.layer.open({
				type: 1,
				title: '我要邀请',
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
			<div class="txtDiv">
				<select class="selInput" >
					<option>${culturalOrderDate}</option>
				</select>
			</div>
		</div>
		<div class="infoWrap clearfix">
			<span class="name">请填写服务时段：</span>
			<div class="txtDiv"><input class="txtInput" type="text" placeholder="例如：14:00-15:00" id="periodWanted"></div>
		</div>
		<div class="infoWrap clearfix">
			<span class="name" style="margin-bottom: 0; width: 300px;" id="townLabelWithDefaultArea">请选择服务地址：</span>
			<div class="txtDiv clearfix" id="orderAreaSelectDiv" style="width: 100%; display: none;">
				<select class="selInput w150" id="orderAreaSelect" onclick="loadOrderTownByArea(this)">
					<option value="0">市区</option>
				</select>
			</div>
			<div class="txtDiv clearfix" style="width: 100%;">
				<select class="selInput w150" id="orderTownSelect">
					<option value="0">街道</option>
				</select>
			</div>
			<div class="txtDiv clearfix" style="width: 100%;">
				<input class="txtInput w440" type="text" placeholder="请填写详细地址" id="detailedAddress">
			</div>
		</div>
		<div class="infoWrap clearfix">
			<div class="txtDiv" style="width: 100%;">
				<textarea class="txtArea" placeholder="请填写邀请说明，限200字以内" id="userDescription" maxlength="200"></textarea>
			</div>
		</div>
		<div class="tipsBox">
			<p class="tipsTit">*报名须知</p>
			<p class="tips">${culturalOrderMustKnow}</p>
		</div>
	</div>

	<div class="popBtnBox clearfix" style="padding-bottom: 30px;">
		<a class="popBtn red" id="subBaom" href="javascript:void(0);" onclick="addInvitationInformation()">提交邀请</a>
	</div>

</body>
</html>

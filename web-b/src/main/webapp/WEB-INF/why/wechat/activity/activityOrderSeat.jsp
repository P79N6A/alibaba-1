<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta charset="utf-8"/>
<!-- <title>在线选座</title> -->
<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wx/css/reset-mc.css" />
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wx/css/mc-mobile.css" />
<script type="text/javascript" src="${path}/STATIC/wechat/js/jquery.SuperSlide.2.1.js"></script>
<script type="text/javascript" src="${path}/STATIC/wx/js/mc-mobile.js"></script>
</head>
<body class="map_body">
<div class="select-seat">
	<div class="tit">
		<h2>在线选座</h2>
		<form action="${path}/wechatActivity/finishSeat.do" id="finishForm">
			<div class="select-box" id="selected-seats"></div>
			<input type="hidden" value="${activityId}" name="activityId"/>
			<input type="hidden" value="${activityEventimes}" name="activityEventimes"/>
			<input type="hidden" value="${userName}" name="userName"/>
			<input type="hidden" value="${userIdCard}" name="userIdCard"/>
			<input type="hidden" value="${userPhone}" name="userPhone"/>
		</form>
	</div>
	<div class="seat-box clearfix">
		<div class="legend">
			<span class="unavailable">已售</span>
			<span class="selected">已选</span>
			<span class="available">可选</span>
		</div>
		<div class="seat-map">
			<div class="front">中心舞台</div>
			<%--<input type="hidden" name="seatInfo" id="seatInfo" value="_a[1_8-19]_a[1_9-17]a[1_10-15]a[1_11-13]a[1_12-11]a[1_13-9]a[1_14-7]a[1_15-5]a[1_16-3]a[1_17-1]a[1_18-2]a[1_19-4]a[1_20-6]a[1_21-8]a[1_22-10]a[1_23-12]a[1_24-14]a[1_25-16]a[1_26-18],a[2_8-19]a[2_9-17]a[2_10-15]a[2_11-13]a[2_12-11]a[2_13-9]a[2_14-7]a[2_15-5]a[2_16-3]a[2_17-1]a[2_18-2]a[2_19-4]a[2_20-6]a[2_21-8]a[2_22-10]a[2_23-12]a[2_24-14]a[2_25-16]a[2_26-18],a[3_8-19]a[3_9-17]a[3_10-15]a[3_11-13]a[3_12-11]a[3_13-9]a[3_14-7]a[3_15-5]a[3_16-3]a[3_17-1]a[3_18-2]a[3_19-4]a[3_20-6]a[3_21-8]a[3_22-10]a[3_23-12]a[3_24-14]a[3_25-16]a[3_26-18],a[4_9-17]a[4_10-15]a[4_11-13]a[4_12-11]a[4_13-9]a[4_14-7]a[4_15-5]a[4_16-3]a[4_17-1]a[4_18-2]a[4_19-4]a[4_20-6]a[4_21-8]a[4_22-10]a[4_23-12]a[4_24-14]a[4_25-16],a[5_8-19]a[5_9-17]a[5_10-15]a[5_11-13]a[5_12-11]a[5_13-9]a[5_14-7]a[5_15-5]a[5_16-3]a[5_17-1]a[5_18-2]a[5_19-4]a[5_20-6]a[5_21-8]a[5_22-10]a[5_23-12]a[5_24-14]a[5_25-16]a[5_26-18]">--%>
			<input type="hidden" name="seatInfo" id="seatInfo">
			<%--<input type="hidden" name="vipInfo" id="vipInfo" value="1_11,1_12,1_13,1_14,1_15,1_16,1_17,1_18,1_19,1_20,1_21,1_22,1_23,2_8,2_9,2_10,2_11,2_12,2_13,2_14,2_15,2_16,2_17,2_18,2_19,2_20,2_21,2_22,2_23,3_13,3_14,3_15,3_16,3_17,3_18,3_19,3_20,3_21,4_10,4_11,4_12,4_13,4_14,4_15,4_16,4_17,4_18,4_19,4_20,5_8,5_9,5_10,5_13,5_14,5_15,5_16,5_17,5_18,5_19,5_20,5_21,5_22,5_23,6_12,6_13,6_14,6_15,6_16,6_17,6_18,6_19,6_20,7_15,7_16,7_17,7_18,7_19,8_14,8_15,8_16,8_17,8_18,8_19,8_20,9_17,9_18,10_15,10_16,10_17,10_18,10_19,10_20,11_17,11_18,12_17,12_18,13_17,13_18,14_17,14_18,15_17,15_18,16_17,16_18,17_1,17_17,17_18,17_33" />--%>
			<input type="hidden" name="vipInfo" id="vipInfo"/>
			<input type="hidden" name="activityId" id="activityId" value="36b149c339834df98470641e80fff500" />
			<input type="hidden" name="maxColumn" id="maxColumn" value="" />
			<input type="hidden" name="selectSeatInfo" id="selectSeatInfo" value=""/>
			<div id="seat-map"></div>
		</div>
	</div>
	<div class="btn-finish" onclick="setOnlineOver()">完成选座</div>
</div>
<script type="text/javascript" src="${path}/STATIC/wx/js/jquery.seat-charts-aisle.js"></script>
<script type="text/javascript">
	$(function(){
		showSeat();
	});

	function setOnlineOver(){
		$("#finishForm").submit();
	}

	function showSeat(){
		$.post("${path}/wechatActivity/appActivityBook.do",
				{activityId:'${activityId}',activityEventimes:'${activityEventimes}',userId:'${sessionScope.terminalUser.userId}'},function(result){
					if(result.status == 0){
						var seatValue = "";
						var vipValue = "";
						var seats = result.data[0].seatList;
						for(var i=0;i<seats.length;i++){
							var seat = seats[i];
							if (i == seats.length -1) {
								var maxColumn =  seat.seatColumn;
								$("#maxColumn").val(maxColumn);
							}
							if(seat.seatStatus == 3){ //座位状态(1-正常2-待修 3-不存在)
								if(i > 0){
									if(parseInt(seat.seatRow) == parseInt(seats[i-1].seatRow)){
										seatValue += "_";
									}else{
										seatValue += ",_";
									}
								}else{
									seatValue += "_";
								}
								continue;
							}else if(seat.seatStatus == 2){
								if(vipValue == ""){
									vipValue += seat.seatRow+"_"+seat.seatColumn;
								}else{
									vipValue += ","+seat.seatRow+"_"+seat.seatColumn;
								}
							}

							if(i > 0){
								if(parseInt(seat.seatRow) == parseInt(seats[i-1].seatRow)){
									seatValue += "a["+seat.seatRow+"_"+seat.seatColumn+"-"+seat.seatVal+"]";
								}else{
									seatValue += ",a["+seat.seatRow+"_"+seat.seatColumn+"-"+seat.seatVal+"]";
								}
							}else{
								seatValue += "a["+seat.seatRow+"_"+seat.seatColumn+"-"+seat.seatVal+"]";
							}
						}
						$("#seatInfo").val(seatValue);
						$("#vipInfo").val(vipValue);
					}
				},"json").success(function(){
					seatMethod();
				}
		);

	}

	function seatMethod(){
		//显示所有座位信息
		var seatInfo = $("#seatInfo").val();
		if (seatInfo != "" && seatInfo != undefined) {
			var seatInfoArr = seatInfo.split(",");
			var column = parseInt($("#maxColumn").val());
			var reg=new RegExp("-","g"); //创建正则RegExp对象
			for(var i=0; i< seatInfoArr.length; i++){
				seatInfoArr[i] = seatInfoArr[i].replace(reg,"\,");
			}

			//显示维修座位信息
			/*var maintananceInfo = $("#maintananceInfo").val();
			 var mtananceInfoArr = maintananceInfo.split(",");
			 for(var i=0; i< mtananceInfoArr.length; i++){
			 mtananceInfoArr[i] = mtananceInfoArr[i];
			 }*/

			//显示VIP座位信息
			var vipInfo = $("#vipInfo").val();
			var vipInfoArr = vipInfo.split(",");
			for(var i=0; i< vipInfoArr.length; i++){
				vipInfoArr[i] = vipInfoArr[i];
			}

			var $cart = $('#selected-seats'); //座位区

			var sc = $('#seat-map').seatCharts({
				map: seatInfoArr,
				columnNum: column,
				seats: {
					a: {
						classes : 'first-level', //your custom CSS class
						category: '一等座'
					}
				},
				naming : {
					top : false,
					getLabel : function (character, row, column) {
						return column;
					}
				},
				legend : { //定义图例
					node : $('#legend'),
					items : [
						[ 'a', 'available'],
						[ 'b', 'available'],
						[ 'c', 'available']
					]
				},
				click: function () { //点击事件
					if (this.status() == 'available') { //可选座
						if((sc.find('selected').length+1) < 6){
							$('<span class="seat-txt"><input type="hidden" name="seatId" value="'+ this.settings.id +'" /><input type="hidden" name="seatValue" value="'+ (this.settings.row+1) +'_'+ this.settings.label +'" />'+(this.settings.row+1) +'排'+ this.settings.label+'座</span>')
									.attr('id', 'cart-item-'+this.settings.id)
									.data('seatId', this.settings.id)
									.appendTo($cart);

							return 'selected';
						}else{
							dialogAlert("提示", "每单最多可预订5个座位");
							return 'available';
						}
					} else if (this.status() == 'selected') { //已选中

						//删除已预订座位
						$('#cart-item-'+this.settings.id).remove();
						//可选座
						return 'available';
					} else if (this.status() == 'unavailable') { //已售出
						return 'unavailable';
					} else {
						return this.style();
					}
				}
			});
			//已售出的座位
			sc.get(vipInfoArr).status('unavailable');
			var columnNum = column+1;
			var oRowWidth, columnWidth = 65;
			oRowWidth = (columnWidth+12)*column;
			$("#seat-map .seatCharts-row").css({"width": oRowWidth, "margin": "0 auto", "padding": "0 20px"});
			$(".select-seat .front").css({"width": Math.max(oRowWidth,710), "padding": "0 20px"});
			var maxWidth = Math.min(Math.max(oRowWidth,222), 700);
			$(".seat-container").css({"width": maxWidth});
			$(".seat-wrap").css({"width": Math.min(maxWidth,700)});
		}
	}
</script>
</body>
<!--时间插件-->
</html>
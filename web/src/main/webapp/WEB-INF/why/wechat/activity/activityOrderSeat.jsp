<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>在线选座</title>
<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wx/css/reset-mc.css" />
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style${empty sourceCode?'':sourceCode}.css"/>
<script type="text/javascript" src="${path}/STATIC/wx/js/mc-mobile.js"></script>
<script type="text/javascript" src="${path}/STATIC/wx/js/jquery.seat-charts-aisle.js"></script>

<script >
	//分享是否隐藏
	if (is_weixin()) {
	    //通过config接口注入权限验证配置
	    wx.config({
	        debug: false,
	        appId: '${sign.appId}',
	        timestamp: '${sign.timestamp}',
	        nonceStr: '${sign.nonceStr}',
	        signature: '${sign.signature}',
	        jsApiList: ['hideAllNonBaseMenuItem']
	    });
	    wx.ready(function () {
	    	wx.hideAllNonBaseMenuItem();
	    });
	}
</script>

<style>
	html,body{
		height: 100%!important;
		background-color: #f3f3f3;
	}
	
	.select-seat{
		background-color: #fff;
	}
	.seatCharts-cell{
		position: relative;
	}
	.seatCharts-cell p{
		font-size: 20px;
		color: #fff;
		text-align: center;
		position: absolute;
		left: 0;
		right: 0;
		line-height: 25px;
	}
</style>
</head>
<body class="seat_body">
	<div class="activeTopTitle">
		<p class="fs32 padding-top20 padding-bottom20" id="activityName"></p>
	</div>
	<div class="seat-row-fixed">
		<div class="seat-row" style="height: 1650px; display: block; top: 153px;">
			<ul></ul>
		</div>
	</div>
	<div class="select-seat">
		<div class="seat-box clearfix">
			<div class="legend">
				<span class="unavailable">已售</span>
				<span class="selected">已选</span>
				<span class="available">可选</span>
			</div>
			<div class="seat-map">
				<div class="front" style="position: relative;background: none!important;">
					<img src="${path}/STATIC/wechat/image/z_circle.png" style="position: absolute;top: 0;right: 0;left: 0;margin: auto;" />
					<p style="line-height: 100px;">中心舞台</p>
				</div>

				<input type="hidden" name="seatInfo" id="seatInfo">
				<input type="hidden" name="vipInfo" id="vipInfo"/>
				<input type="hidden" name="maxColumn" id="maxColumn" value="" />
				<input type="hidden" name="selectSeatInfo" id="selectSeatInfo" value=""/>
				<div id="seat-map"></div>
			</div>
		</div>
		<div class="tit">
			<h2>在线选座</h2>
			<form action="${path}/wechatActivity/finishSeat.do" id="finishForm">
				<div class="select-box" >
					<div id="selected-seats" style="height: 100%;width: 760px;"></div>
				</div>
				<input type="hidden" value="${activityId}" name="activityId"/>
				<input type="hidden" value="${activityEventimes}" name="activityEventimes"/>
				<input type="hidden" value="${userName}" name="userName"/>
				<input type="hidden" value="${userIdCard}" name="userIdCard"/>
				<input type="hidden" value="${userPhone}" name="userPhone"/>
				<input type="hidden" value="${callback}" name="callback"/>
				<input type="hidden" value="${sourceCode}" name="sourceCode"/>
				<input type="hidden" value="${userId}" name="userId"/>
			</form>
			<div style="clear: both;"></div>
		</div>
		<div class="btn-finish" onclick="setOnlineOver()">完成选座</div>
	</div>

	<script type="text/javascript">
		var count = '${count}';		//最大购票数
	
		//分享是否隐藏
	    if(window.injs){
			injs.setAppShareButtonStatus(false);
		}
	
		$(function(){
			//计算座位界面高度
			var map_h = document.body.clientHeight - 205 - 210 - 15;
			$(".seat-map").css("height", map_h);
			$(".seat-row-fixed").css("height", map_h);
			
			showSeat();
		});
	
		function setOnlineOver(){
			$("#finishForm").submit();
		}
	
		function showSeat(){
			$.post("${path}/wechatActivity/appActivityBook.do",
					{activityId:'${activityId}',activityEventimes:'${activityEventimes}',userId:userId},function(result){
						if(result.status == 0){
							$("#activityName").text(result.data[0].activityName);
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
						
						//计算导航条高度
						var seat_h = $("#seat-map").height()

						$(".seat-row").css("height", seat_h)

						var li_num = $(".seat-row").height() / 75

						for(var i = 1; i <= li_num; i++) {
							$(".seat-row>ul").append("<li><p>" + i + "</p></li>")
						}
						if (!browser.versions.android) {		//非安卓(安卓不识别touchend)
							$(".seat-map").on("touchmove", function() {
								$(".seat-row").hide()
							}).on("touchend", function() {
								$(".seat-row").show()
							})
						}
						//导航条滚动
						$(".seat-map").scroll(function(e) {
							e.preventDefault()
							var sear_sl = $(".seat-map").scrollTop();
							$(".seat-row").css("top", -sear_sl + 160)
						})
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
							if((sc.find('selected').length+1) <= count){
								$('<span class="seat-txt"><input type="hidden" name="seatId" value="'+ this.settings.id +'" /><input type="hidden" name="seatValue" value="'+ (this.settings.row+1) +'_'+ this.settings.label +'" />'+(this.settings.row+1) +'排'+ this.settings.label+'座</span>')
										.attr('id', 'cart-item-'+this.settings.id)
										.data('seatId', this.settings.id)
										.appendTo($cart);
								//座位中添加座位号
								$('#' + this.settings.id).append("<p>" + (this.settings.row + 1) + '排' + '<br />' + this.settings.label  + "</p>")
								return 'selected';
							}else{
								dialogAlert("提示", "每单最多可预订"+count+"个座位");
								return 'available';
							}
						} else if (this.status() == 'selected') { //已选中
	
							//删除已预订座位
							$('#cart-item-'+this.settings.id).remove();
							//删除座位中座位号
							$('#' + this.settings.id).find("p").remove()
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
</html>
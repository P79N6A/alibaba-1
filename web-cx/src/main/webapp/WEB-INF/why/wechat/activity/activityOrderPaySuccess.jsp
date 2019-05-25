
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>支付成功</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wx/css/mc-mobile.css"/>
	<script src="${path}/STATIC/js/common.js"></script>

	<style>
			body {
				position: relative;
				height: 100%;
			}
			
			.orderInput {
				text-align: left !important;
				padding-left: 40px;
				padding-top: 1px;
			}
			
			.set_block {
				position: relative;
			}
			
			.payfont {
				color: #C05459!important;
			}
			
			.payChoose {
				float: right;
			}
			
			.payMoney {
				float: left;
				width: 430px;
				height: 100%;
				background-color: #f4f4f4;
				padding-top: 10px;
			}
			
			.payMoney p:nth-child(1) {
				font-size: 32px;
				padding-left: 20px;
				line-height: 40px;
				color: #262626;
			}
			
			.payMoney p:nth-child(2) {
				font-size: 22px;
				padding-left: 20px;
				line-height: 22px;
				margin-top: 10px;
				color: #808080;
			}
			
			.payBtn {
				float: right;
				width: 320px;
				height: 100%;
				text-align: center;
				line-height: 90px;
				font-size: 40px;
				background-color: #7279A0;
				color: #fff;
			}
			
			.bgNone {
				background: none!important;
			}
			
			.setMapList li {
				float: left;
				margin-right: 15px;
			}
			.orderErCode{
				margin-left: 140px;
			}
			.orderErCode p{
				margin-top: 10px;
				font-size: 28px;
			}
			.orderErCode img{
				width: 300px;
				height: 300px;
				display: block;
			}
			
			.list_block .set_block{
				padding: 15px 0;
			}
		</style>
		<script>

			var activityOrderId = '${activityOrderId}';
		
			$(function() {
				
				if (userId == null || userId == '') {
		            window.location.href = "${path}/wechatUser/preTerminalUser.do";
		        }
				
				$.post("${path}/wechatUser/userActivityOrderDetail.do",{activityOrderId:activityOrderId,userId:userId}, function(data) {
					if(data.status==200){
						var dom = data.data;
						$("#activityName").html(dom.activityName);
						
						$("#activitySite").html(dom.activityAddress.length>19?(dom.activityAddress.substring(0,19)+"..."):dom.activityAddress);
					
						if(dom.eventDate==dom.eventEndDate){
							var d = new Date(dom.eventDate.replace(/-/g,   "/"));
							var dayNames = new Array("周日","周一","周二","周三","周四","周五","周六");  
							$("#eventDate").html(dom.eventDate.replace("-","年").replace("-","月")+"日&nbsp;"+dayNames[d.getDay()]);
						}else{
							$("#eventDate").html(dom.eventDate.replace("-","年").replace("-","月")+"日&nbsp;至&nbsp;"+dom.eventEndDate.replace("-","年").replace("-","月")+"日");
						}
						
						//座位
	                    if (dom.activitySalesOnline == "Y") {
	                    	var setSeatHtml = "";
	                        var activitySeats = new Array();
	                        activitySeats = dom.activitySeats.split(",");
	                        if (activitySeats != undefined && activitySeats != '' && activitySeats.length > 0) {
	                            for (var j = 0; j < activitySeats.length; j++) {
	                                if (activitySeats[j] == null || activitySeats[j] == "") {
	                                    continue;
	                                }
	                                var activitySeat = activitySeats[j].split("_");
	                                setSeatHtml +=  "<li><span>"+activitySeat[0] + "排" + activitySeat[1] + "座</span></li> ";
	                            }
	                        }
	                        $("#seatUl").html(setSeatHtml);
	                        $("#seatDiv").show();
	                    }
						
						$("#activitySite2").html(dom.activityAddress+(dom.activitySite!=""?dom.activitySite:dom.venueName));

	                    $("#orderName").html(dom.orderName+"&emsp;"+dom.orderPhoneNo)
	                    
	                    if(dom.orderValidateCode){
							$("#orderValidateCode").html(dom.orderValidateCode);
							$("#activityQrcodeUrl").attr("src",dom.activityQrcodeUrl);
						}
						else{
							$("#orderValidateCodeDiv").remove();
						}
						
					}
				},"json");
				
				
				$(".payBtn").click(function(){
					 window.location.href = '${path}/wechatActivity/wcOrderList.do';
				})
			})
		</script>
</head>

<body>
		<div class="common_container">
			<div class="list_block" style="margin: 0;padding-bottom:30px;">
				<div style="width: 100%;height: 200px;background-color: #646C9B;color: #fff;text-align: center;line-height: 200px;font-size: 50px;">
					支付成功!
				</div>
				<div class="set_block bgNone">
					<p id="activityName" class="" style="font-size: 32px;color: #262626;"></p>
				</div>
				<div class="set_block bgNone">
					<span>场&nbsp;&nbsp;&nbsp;&nbsp;馆：</span>
					<p id="activitySite2" class="f-right rig" style="width: 500px;"></p>
					<div style="clear: both;"></div>
				</div>
				<div class="set_block bgNone">
					<span>日&nbsp;&nbsp;&nbsp;&nbsp;期：</span>
					<p id="eventDate" class="f-right rig" style="width: 500px;"></p>
					<div style="clear: both;"></div>
				</div>
				<div id="seatDiv" class="set_block bgNone setMapList" style="display: none;">
					<span>座&nbsp;&nbsp;&nbsp;&nbsp;位：</span>
					<ul id="seatUl" class="f-right rig" style="width: 500px;">
						
					</ul>
					<div style="clear: both;"></div>
				</div>
				<div class="set_block bgNone">
					<span>联系人：</span>
					<p id="orderName" class="f-right rig" style="width: 500px;"></p>
					<div style="clear: both;"></div>
				</div>
			</div>
			<div class="list_block" id="orderValidateCodeDiv" style="padding-top:30px;">
				<div class="set_block bgNone">
					<span>取票码：</span>
					<p class="f-right rig payfont" style="width: 500px;" id="orderValidateCode"></p>
					<div style="clear: both;"></div>
				</div>
				<div class="set_block bgNone">
					<div class="orderErCode">
						<img id="activityQrcodeUrl"  src="">
						<p>出示二维码或者取票码验证使用</p>
					</div>
				</div>
			</div>
		</div>
		<div class="M_activity_due" style="height: 100px;">
			<div class="payBtn" style="float: none;width: 100%;background-color: #f4f4f4;color: #646c9b;">进入我的订单</div>
		</div>

	</body>


</html>


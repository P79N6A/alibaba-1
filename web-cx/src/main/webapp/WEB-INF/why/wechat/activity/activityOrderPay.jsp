                 <%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>等待支付</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wx/css/mc-mobile.css"/>
		
	<script>
		var activityOrderId = '${activityOrderId}';
		var lat = '';
        var lon = '';
        var now;
        var orderTime;
        var countDown;
     
		$(function(){
			if (userId == null || userId == '') {
	            window.location.href = "${path}/wechatUser/preTerminalUser.do";
	        }
			var m = 15*60;
			$.post("${path}/wechatUser/userActivityOrderDetail.do",{activityOrderId:activityOrderId,userId:userId}, function(data) {
				if(data.status==200){
					var dom = data.data;
					
					if(dom.orderPaymentStatus!=1)
					{
						sessionStorage.setItem("orderList", "history");
						window.location.href="${path}/wechatActivity/wcOrderList.do";
					}
					
					if(dom.orderPayStatus==1){
						orderTime=dom.orderTime;
						now= dom.now/1000;
						countDown=(now-orderTime)
						if(countDown>(m)){
						
							 $.post("${path}/wechatActivity/removeAppActivity.do", {
					                userId: userId,
					                activityOrderId: activityOrderId
					            }, function (result) {
					                if (result.status == 0) {
					                	window.location.href="${path}/wechatActivity/preActivityOrderDetail.do?activityOrderId="+activityOrderId;
									} 
					            }, "json");
						
						}
						else{
							
							startCountDown();
							setInterval(
									function(){
										
										startCountDown();
										countDown+=1;
									}
								,1000);		
						}
					}
					
					$("#activityName").html(dom.activityName);
					
					if(dom.eventDate==dom.eventEndDate){
						var d = new Date(dom.eventDate.replace(/-/g,   "/"));
						var dayNames = new Array("周日","周一","周二","周三","周四","周五","周六");  
						$("#eventDate").html(dom.eventDate.replace("-","年").replace("-","月")+"日&nbsp;"+dayNames[d.getDay()]+" "+dom.eventTime);
					}else{
						$("#eventDate").html(dom.eventDate.replace("-","年").replace("-","月")+"日&nbsp;至&nbsp;"+dom.eventEndDate.replace("-","年").replace("-","月")+"日"+" "+dom.eventTime);
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
					
					$("#orderName").html(dom.orderName+"&emsp;"+dom.orderPhoneNo)
					
					$("#orderVotes").html(dom. orderVotes);
					if(dom.costTotalCredit>0){
						$("#costTotalCreditDiv").show();
						$("#costTotalCredit").html("-"+dom.costTotalCredit);
					}
					
					if(dom.orderValidateCode){
						$("#orderValidateCode").html(dom.orderValidateCode);
						$("#activityQrcodeUrl").attr("src",dom.activityQrcodeUrl);
					}
					else{
						$("#orderValidateCodeLi").remove();
					}
					
					if(dom.activityPayPrice){
						
						var orderPrice=dom.activityPayPrice*dom.orderVotes;
						
						$("#activityPayPrice").html("￥"+dom.activityPayPrice)
						
						$("#orderPrice").html("￥"+orderPrice)
					}
					
					$("#activitySite2").html(dom.activityAddress+(dom.activitySite!=""?dom.activitySite:dom.venueName));
					//$("#activityAddress").html(dom.activityAddress);
					//$("#orderNumber").html(dom.orderNumber);
					//var d = new Date(dom.orderTime * 1000);
					//$("#orderTime").html(d.format("yyyy.MM.dd hh:mm:ss"));
					
				}
			},"json");
			
			$(".wayToPay").on("click",function(){
				$(".wayToPay").find(".payChoose img").attr("src","${path}/STATIC/wechat/image/choose.png")
				$(this).find(".payChoose img").attr("src","${path}/STATIC/wechat/image/chooseOn.png")
			})
		});
		
		
		// 开始倒计时
		function startCountDown(){
			
			var m = 15*60;
			
			var s=countDown;
			
			if(s>=m){
					sessionStorage.setItem("orderList", "history");
					window.location.href="${path}/wechatActivity/wcOrderList.do";
			}
			
			s= m-s
			
			// 秒
			if(s<60&& s>0){
				$("#time").html("请在"+parseInt(s)+"秒内完成付款，逾期订单将自动取消。");
				return false;
			}
			var c=s/60
			
			$("#time").html("请在"+Math.ceil(c) +"分钟内完成付款，逾期订单将自动取消。");
		}
		
		function pay(){
			
			 if(!is_weixin()&&!(/wenhuayun/.test(ua))) {
				 dialogAlert('系统提示', '请用微信浏览器打开！');
			 }else {
				 window.location.href = '${path}/wechat/getOpenId.do?callback=' + "${basePath}wechatPay/index.do?activityOrderId=" + activityOrderId;
			 }
			
		}
		
		//跳转到活动详情
        function showActivity(activityId) {
            window.location.href = "${path}/wechatActivity/preActivityDetail.do?activityId=" + activityId;
        }
		
		//地址地图
	    function preAddressMap() {
	        window.location.href = "${path}/wechat/preAddressMap.do?lat=" + lat + "&lon=" + lon;
	    }
		
	  	//取消按钮
	    function cancelDialog() {
	        var winW = Math.min(parseInt($(window).width() * 0.82), 670);
	        var d = dialog({
	            width: winW,
	            title: '取消提示',
	            content: '确定取消该订单？',
	            fixed: true,
	            button: [{
	                value: '确定',
	                callback: function () {
	                	cancelActivityOrder();
	                }
	            },{
	                value: '取消'
	            }]
	        });
	        d.showModal();
	    }
		
		//取消订单
	    function cancelActivityOrder() {
            $.post("${path}/wechatActivity/removeAppActivity.do", {
                userId: userId,
                activityOrderId: activityOrderId
            }, function (result) {
                if (result.status == 0) {
                    dialogAlert("提示", "退订成功！");
                    location.href = "${path}/wechatActivity/wcOrderList.do";
                } else if (result.status == 10111) {
                    dialogAlert("提示", "用户不存在");
                } else if (result.status == 1) {
                    dialogAlert("提示", "退票失败");
                } else if (result.status == 10112) {
                    dialogAlert("提示", "用户与活动订单id缺失");
                }
            }, "json");
        }
	 
</script>

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
			.setMapList li{
				float: left;
				margin-right: 15px;
			}
		</style>
</head>
<body>
	<div class="common_container">
			<div class="list_block" style="margin: 0;">
				<div id="time" style="width: 100%;height: 110px;background-color: #646C9B;color: #fff;text-align: center;line-height: 110px;font-size: 28px;">
				</div>
				<div class="set_block bgNone">
					<p class="" style="font-size: 32px;color: #262626;" id="activityName"></p>
				</div>
				<div class="set_block bgNone">
					<span>场&nbsp;&nbsp;&nbsp;&nbsp;馆：</span>
					<p class="f-right rig" style="width: 500px;" id="activitySite2"></p>
					<div style="clear: both;"></div>
				</div>
				<div class="set_block bgNone">
					<span>日&nbsp;&nbsp;&nbsp;&nbsp;期：</span>
					<p class="f-right rig" style="width: 500px;" id="eventDate"></p>
					<div style="clear: both;"></div>
				</div> 
				<div class="set_block bgNone setMapList" id="seatDiv" style="display: none;">
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
			<div class="list_block" id="userInfoDiv">
				<div class="set_block bgNone">
					<span>价&nbsp;&nbsp;&nbsp;&nbsp;格：</span>
					<div class="f-right rig" style="width: 400px;text-align: right;" id="activityPayPrice">
					</div>
					<div style="clear: both;"></div>
				</div>
				<div class="set_block bgNone">
					<span>数&nbsp;&nbsp;&nbsp;&nbsp;量：</span>
					<div class="f-right rig" style="width: 400px;text-align: right;" id="orderVotes">
					</div>
					<div style="clear: both;"></div>
				</div>
				<!-- <div class="set_block bgNone">
					<span>积&nbsp;&nbsp;&nbsp;&nbsp;分：</span>
					<div class="f-right rig payfont" style="width: 400px;text-align: right;">
						-50
					</div>
					<div style="clear: both;"></div>
				</div>
				<div class="set_block bgNone">
					<span>优惠卷：</span>
					<div class="f-right rig" style="width: 400px;text-align: right;">
						-￥50
					</div>
					<div style="clear: both;"></div>
				</div> -->
				<div class="set_block bgNone">
					<span>总&nbsp;&nbsp;&nbsp;&nbsp;价：</span>
					<div class="f-right rig payfont" style="width: 400px;text-align: right;" id="orderPrice">
					</div>
					<div style="clear: both;"></div>
				</div>
			</div> 
			<div class="list_block">
				<div class="set_block set_date bgNone">
					<span class="f-left">支付方式：</span>
					<div style="clear: both;"></div>
				</div>
				<div class="set_block set_date wayToPay bgNone">
					<div class="f-left">
						<img class="f-left" src="${path }/STATIC/wechat/image/wechatPay.png" />
						<span class="f-left margin-left20">微信支付</span>
					</div>
					<div class="payChoose">
						<img src="${path }/STATIC/wechat/image/chooseOn.png" />
					</div>
					<div style="clear: both;"></div>
				</div>
				<!-- <div class="set_block set_date wayToPay bgNone">
					<div class="f-left">
						<img class="f-left" src="${path }/STATIC/wechat/image/aliPay.png" />
						<span class="f-left margin-left20">支付宝支付</span>
					</div>
					<div class="payChoose">
						<img src="${path }/STATIC/wechat/image/choose.png" />
					</div>
					<div style="clear: both;"></div>
				</div> -->
			</div>
			<!--<div class="list_block">
				<div class="set_block bgNone">
					<span>支付方式：支付宝</span>
				</div>
				<div class="set_block bgNone">
					<img style="float: left;margin-top: 15px;" src="image/Group2.png">
					<p style="float: left;margin-left: 15px;">不可退款</p>
					<div style="clear: both;"></div>
				</div>
			</div>-->
		</div>
		<div class="M_activity_due" style="height: 100px;">
			<div id="payBtn" class="payBtn" style="float: none;width: 100%;" onclick="pay();">立即支付</div>
		</div>
		
		</body>
</html>
                 <%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>订单详情</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style${empty sourceCode?'':sourceCode}.css"/>
		
	<script>
		var activityOrderId = '${activityOrderId}';
		var lat = '';
        var lon = '';
	
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
        
		$(function(){
			if (userId == null || userId == '') {
	            window.location.href = "${path}/wechatUser/preTerminalUser.do";
	        }
			
			$.post("${path}/wechatUser/userActivityOrderDetail.do",{activityOrderId:activityOrderId,userId:userId}, function(data) {
				if(data.status==200){
					var dom = data.data;
					$("#activityIconUrl").attr("src", getIndexImgUrl(dom.activityIconUrl, "_300_300"));
					$("#activityName").html(dom.activityName);
					$("#activitySite").html(dom.activityAddress.length>19?(dom.activityAddress.substring(0,19)+"..."):dom.activityAddress);
					
					lat=dom.activityLat;
					lon=dom.activityLon;
					
					var activityIsDel=dom.activityIsDel;
					if(activityIsDel==1){
						$(".activity-title").removeClass("bgNone");
						$(".activity-title").attr("onclick","showActivity('" + dom.activityId + "')");
					}
					
					if(dom.eventDate==dom.eventEndDate){
						var d = new Date(dom.eventDate.replace(/-/g,   "/"));
						var dayNames = new Array("周日","周一","周二","周三","周四","周五","周六");  
						$("#eventDate").html(dom.eventDate.replace("-","年").replace("-","月")+"日&nbsp;"+dayNames[d.getDay()]);
					}else{
						$("#eventDate").html(dom.eventDate.replace("-","年").replace("-","月")+"日&nbsp;至&nbsp;"+dom.eventEndDate.replace("-","年").replace("-","月")+"日");
					}
					$("#eventTime").html(dom.eventTime);
					
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
					
					$(".orderVotes").html(dom. orderVotes);
					if(dom.costTotalCredit>0){
						$("#costTotalCreditDiv").show();
						$("#costTotalCredit").html("-"+dom.costTotalCredit);
					}
					
					if(dom.orderValidateCode){
						$("#orderValidateCode").html(dom.orderValidateCode);
						$("#activityQrcodeUrl").attr("src",dom.activityQrcodeUrl);
						$("#orderValidateCodeLi").show();
					}
					else{
						$("#orderValidateCodeLi").remove();
					}
					
					if(dom.orderPaymentStatus!=0){
						
						$("#orderVotesDiv").hide();
						
						//var orderPrice=dom.activityPayPrice*dom.orderVotes;
						
						var orderVotes=dom.orderVotes;
						
						var orderPrice= dom.orderPrice;
						
						$("#activityPayPrice").html("￥"+dom.orderPrice/orderVotes)
						
						$("#orderPrice").html("￥"+orderPrice)
						
						$("#priceLi").show();
					}
					
					if(dom.orderPayType){
						
						if(dom.orderPayType==2){
							$("#orderPayType").html("微信")
						}else if(dom.orderPayType==1){
							$("#orderPayType").html("支付宝")
						}
						
						$("#payTypeLi").show();
					}
					
					$("#activitySite2").html(dom.activityAddress+(dom.activitySite!=""?dom.activitySite:dom.venueName));
					$("#activityAddress").html(dom.activityAddress);
					$("#orderNumber").html(dom.orderNumber);
					var d = new Date(dom.orderTime * 1000);
					$("#orderTime").html(d.format("yyyy.MM.dd hh:mm:ss"));
					
					//if(dom.orderPaymentStatus==0)
					//{
					var jsDate=new Date(dom.cancelEndTime.time); 
					if(dom.cancelEndTime != null && jsDate < new Date()){
						$(".order-button").html("<button style='width:750px;' class='f-left bgccc w50-pc height100 fs30 cfff'>待使用</button>");
					}else{
						if(dom.orderPaymentStatus==1&&dom.orderPayStatus==1){
							$(".order-button").html(
								'<div class="order-button"><button class="f-left w50-pc height100 fs30 c6771a7 bgf4f4f4" onclick="cancelDialog();">取消订单</button><button class="f-left bg7279a0 w50-pc height100 fs30 cfff" onclick="gotoPay();">去付款</button></div>'
							);
						}else if(dom.orderPaymentStatus==2&&dom.orderPayStatus==1){
							$(".order-button").html(
								"<button class='bgccc w100-pc height100 fs30 cfff'>待使用</button>");
						}else if(dom.orderPaymentStatus==3&&dom.orderPayStatus==1){
							$(".order-button").html(
							"<button class='bgccc w100-pc height100 fs30 cfff'>申请退款中</button>");
						}else if(dom.orderPayStatus==1){
								$(".order-button").html("<button class='f-left w50-pc height100 fs30 c6771a7 bgf4f4f4' onclick='cancelDialog();'>取消订单</button>" +
										"<button class='f-left bgccc w50-pc height100 fs30 cfff'>待使用</button>");
						}else if(dom.orderPayStatus==2){
							$(".order-button").html("<button class='bgccc w100-pc height100 fs30 cfff'>已取消</button>");
						}else if(dom.orderPayStatus==3){
							$(".order-button").html("<button class='bgccc w100-pc height100 fs30 cfff'>待使用</button>");
						}else if(dom.orderPayStatus==4){
							$(".order-button").html("<button class='bgccc w100-pc height100 fs30 cfff'>已使用</button>");
						}else if(dom.orderPayStatus==5){
							$(".order-button").html("<button class='bgccc w100-pc height100 fs30 cfff'>已过期</button>");
						}
					}
				//	}else if(dom.orderPaymentStatus==1){
					//	$(".order-button").html(
					//	'<div class="order-button"><button class="f-left w50-pc height100 fs30 c6771a7 bgf4f4f4" onclick="cancelDialog();">取消订单</button><button class="f-left bg7279a0 w50-pc height100 fs30 cfff" onclick="gotoPay();">去付款</button></div>'
					//	);
					//}
					//else if(dom.orderPaymentStatus==2){
					//	$(".order-button").html("<button class='f-left w50-pc height100 fs30 c6771a7 bgf4f4f4' onclick='cancelDialog();'>申请退款</button>" +
					//	"<button class='f-left bgccc w50-pc height100 fs30 cfff'>待使用</button>");
					//}
				
					if(dom.orderCustomInfo && dom.orderCustomInfo.length>0){
						var orderCustomInfoObj = JSON.parse(dom.orderCustomInfo);
	                	$.each(orderCustomInfoObj, function (i, dom) {
	                		$("#orderCustomInfoLi div ul").append("<li>" +
																		"<div class='tit'>"+dom.title+"：</div>" +
																		"<div class='nerTxt'>"+dom.value+"</div>" +
																  "</li>");
	                	});
	                	$("#orderCustomInfoLi").show();
					}
				}
			},"json");
		});
		
		// 去支付
		function gotoPay(){
		
			window.location.href = "${basePath}wechatActivity/preActivityOrderPay.do?activityOrderId=" + activityOrderId;
			 
		}
		
		//跳转到活动详情
        function showActivity(activityId) {
        	window.location.href = "${path}/wechatActivity/preActivityDetail.do?activityId="+activityId+"&userId="+userId+"&callback=${callback}&sourceCode=${sourceCode}";
        }
		
		//地址地图
	    function preAddressMap() {
	        window.location.href = "${path}/wechat/preAddressMap.do?lat=" + lat + "&lon=" + lon;
	    }
		
		// 申请退款
		function applyforRefund() {
			
			  window.location.href = "${path}/wechatActivity/preActivityOrderRefund.do?activityOrderId=" + activityOrderId;
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
                    location.href = "${path}/wechatActivity/wcOrderList.do?userId="+userId+"&callback=${callback}&sourceCode=${sourceCode}";
                } else if (result.status == 10111) {
                    dialogAlert("提示", "用户不存在");
                } else if (result.status == 1) {
                    dialogAlert("提示", "退票失败");
                } else if (result.status == 10112) {
                    dialogAlert("提示", "用户与活动订单id缺失");
                }else if(result.status == 2){
                	dialogAlert("提示", "订单取消失败，超出取消截止时间");
                }
            }, "json");
        }
		
	  //日期格式化
	    Date.prototype.Format = function (fmt) {  
	        var o = {
	            "M+": this.getMonth() + 1, //月份 
	            "d+": this.getDate(), //日 
	            "H+": this.getHours(), //小时 
	            "m+": this.getMinutes(), //分 
	            "s+": this.getSeconds(), //秒 
	            "q+": Math.floor((this.getMonth() + 3) / 3), //季度 
	            "S": this.getMilliseconds() //毫秒 
	        };
	        if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
	        for (var k in o)
	        if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
	        return fmt;
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
			
			.setMapList li {
				float: left;
				margin-right: 15px;
			}
			
			.bgNone {
				background: none!important;
			}
			
			.msZhanshi li {
				border-top: 1px solid #f5f9fb;
				padding: 32px 0 !important;
			}
			.msZhanshi li:first-child {
				border-top: 0;
			}
			.msZhanshi .tit {
				font-size: 32px;
				color: #333333;
				line-height: 1.5;
				margin-bottom: 20px;
			}
			.msZhanshi .ner {
				font-size: 28px;
				color: #999999;
				line-height: 40px;
				height: 120px;
				border: none;
				resize: none;
				width: 100%;
			}
			.msZhanshi .nerTxt {
				font-size: 28px;
				color: #999999;
				line-height: 40px;
				border: none;
				resize: none;
				width: 100%;
			}
		</style>
</head>
<body>
	<div class="main">
		<div class="header">
			<%-- <div class="index-top">
				<span class="index-top-5">
					<img src="${path}/STATIC/wechat/image/arrow1.png" onclick="history.go(-1);"/>
				</span>
				<span class="index-top-2">订单详情</span>
			</div> --%>
		</div>
		<div class="content padding-bottom110">
			<div class="my-order">
				<ul>
					<li>
						<div class="activity-title bgNone bgfff list-div-arrow-right ">
							<img id="activityIconUrl" src="" height="170" width="270"/>
							<div class="activity-p">
								<p id="activityName" class="fs30 c26262 w300"></p>
								<p id="activitySite" class="fs26 c808080 activity-p-place w300"></p>
							</div>
							<div style="clear: both;"></div>
						</div>
					</li>
					<li>
						<div class="list-div fs30 c26262">
							<ul>
								<li class="border-bottom">
									<label>日&nbsp;&nbsp;期：</label><span id="eventDate"></span>
								</li>
								<li class="border-bottom">
									<label>时&nbsp;&nbsp;间：</label><span id="eventTime"></span>
								</li>
								<li class="border-bottom" id="seatDiv" style="display: none;">
									<label class="f-left">座&nbsp;&nbsp;位：</label>
									<ul class="set-num c6771a7"	id="seatUl"></ul>
									<div style="clear: both;"></div>
								</li>
								<li id="orderVotesDiv" class="border-bottom">
									<label>数&nbsp;&nbsp;量：</label><span class="orderVotes"></span>
								</li>
								<li id="costTotalCreditDiv" style="display: none;">
									<label>积&nbsp;&nbsp;分：</label><span id="costTotalCredit" class="ca9c7ff"></span>
								</li>
							</ul>
						</div>
					</li>
					<li id="orderValidateCodeLi" style="display: none;">
						<div class="list-div fs30">
							<p class="padding-top20 padding-bottom20">取票码：<span id="orderValidateCode" class="cd58185"></span></p>
							<img id="activityQrcodeUrl" style="margin-left: 120px;height: 288px;width: 288px;" src=""/>
							<p class="fs24 c26262" style="margin-left: 120px;">出示二维码获取票验证使用</p>
						</div>
					</li>
					<li id="priceLi" style="display: none;">
						<div class="list-div fs30 c26262">
							<ul>
								<li class="border-bottom">
									<label>价&emsp;格：</label><span style="float: right;" id="activityPayPrice">￥50</span>
									<div style="clear: both;"></div>
								</li>
								<li class="border-bottom">
									<label>数&emsp;量：</label><span style="float: right;" class="orderVotes"></span>
									<div style="clear: both;"></div>
								</li>
								<!-- <li class="border-bottom">
									<label>积&emsp;分：</label><span class="payfont" style="float: right;" id="">123123</span>
									<div style="clear: both;"></div>
								</li>
								<li class="border-bottom">
									<label>优惠卷：</label><span style="float: right;" id=""></span>
									<div style="clear: both;"></div>
								</li> -->
								<li class="border-bottom">
									<label>总&emsp;价：</label><span class="payfont" style="float: right;" id="orderPrice">123123</span>
									<div style="clear: both;"></div>
								</li>
							</ul>
						</div>
					</li>
					
					<li id="payTypeLi" style="display: none;">
						<div class="list-div fs30 c26262">
								<ul>
									<li class="border-bottom">
										<label>支付方式：</label><span style="float: right;" id="orderPayType"></span>
										<div style="clear: both;"></div>
									</li>
								</ul>
						</div>
					</li>
					<li>
						<div class="list-div padding-bottom20 padding-top20 list-div-arrow-right" onclick="preAddressMap();">
							<p id="activitySite2" class="fs30 c262626"></p>
							<p id="activityAddress" class="fs26 c808080"></p>
						</div>
					</li>
					<li id="orderCustomInfoLi" style="display: none;">
						<div class="list-div fs30 c26262">
							<ul class="msZhanshi"></ul>
						</div>
					</li>
					<li>
						<div class="list-div padding-bottom20 padding-top20">
							<ul class="border-bottom padding-bottom20">
								<li class="f-left p2-font">
									<div>
										<p class="w3">订单号</p>
										<p>下单时间</p>
									</div>
								</li>
								<li class="f-left">
									<div>
										<p>&nbsp;:&nbsp;&nbsp;<span id="orderNumber"></span></p>
										<p>&nbsp;:&nbsp;&nbsp;<span id="orderTime"></span></p>
									</div>
								</li>
								<div style="clear: both;"></div>
							</ul>
							<div class="help-center fs30 padding-bottom20 padding-top20" onclick="javascript:location.href='${path}/wechat/help.do'">
								<p>帮助中心</p>
							</div>
						</div>
					</li>
				</ul>
			</div>
		</div>
		<div class="footer">
			<div class="order-button"></div>
		</div>
	</div>
</body>
</html>
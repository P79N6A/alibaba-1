<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta charset="utf-8"/>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<!-- <title>活动订单详情</title> -->
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>
	<script type="text/javascript">
		var phoneWidth = parseInt(window.screen.width);
		var phoneScale = phoneWidth / 750;
		var ua = navigator.userAgent; //浏览器类型
		if (/Android (\d+\.\d+)/.test(ua)) { //判断是否是安卓系统
			var version = parseFloat(RegExp.$1); //安卓系统的版本号
			if (version > 2.3) {
				document.write('<meta name="viewport" content="width=750, minimum-scale = ' + phoneScale + ', maximum-scale = ' + (phoneScale) + ', target-densitydpi=device-dpi">');
			} else {
				document.write('<meta name="viewport" content="width=750, target-densitydpi=device-dpi">');
			}
		} else {
			document.write('<meta name="viewport" content="width=750, user-scalable=no, target-densitydpi=device-dpi">');
		}
	</script>
		
	<script>
		var activityOrderId = '${activityOrderId}';
		var userId = '${sessionScope.terminalUser.userId}';
		var lat = '';
        var lon = '';
	
		$(function(){
			if (userId == null || userId == '') {
	            window.location.href = "${path}/wechatUser/preTerminalUser.do";
	            return;
	        }
			
			$.post("${path}/wechatUser/userActivityOrderDetail.do",{activityOrderId:activityOrderId,userId:userId}, function(data) {
				if(data.status==200){
					var dom = data.data;
					$("#activityIconUrl").attr("src", getIndexImgUrl(dom.activityIconUrl, "_300_300"));
					$("#activityName").html(dom.activityName);
					$("#activitySite").html(dom.activitySite!=""?dom.activitySite:dom.venueName);
					$(".activity-title").attr("onclick","showActivity('" + dom.activityId + "')");
					lat=dom.activityLat;
					lon=dom.activityLon;
					if(dom.eventDate==dom.eventEndDate){
						var d = new Date(parseInt(dom.eventDate));
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
					
					$("#orderVotes").html(dom.orderVotes);
					if(dom.costTotalCredit>0){
						$("#costTotalCreditDiv").show();
						$("#costTotalCredit").html("-"+dom.costTotalCredit);
					}
					$("#orderValidateCode").html(dom.orderValidateCode);
					$("#activityQrcodeUrl").attr("src",dom.activityQrcodeUrl);
					$("#activitySite2").html(dom.activitySite!=""?dom.activitySite:dom.venueName);
					$("#activityAddress").html(dom.activityAddress);
					$("#orderNumber").html(dom.orderNumber);
					var d = new Date(dom.orderTime * 1000);
					$("#orderTime").html(d.format("yyyy.MM.dd hh:mm:ss"));
					
					if(dom.orderPayStatus==1){
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
			},"json");
		});
		
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
</head>
<body>
	<div class="main">
		<div class="header">
			<div class="index-top">
				<span class="index-top-5">
					<img src="${path}/STATIC/wechat/image/arrow1.png" onclick="history.go(-1);"/>
				</span>
				<span class="index-top-2">订单详情</span>
			</div>
		</div>
		<div class="content margin-top100 padding-bottom110">
			<div class="my-order">
				<ul>
					<li>
						<div class="activity-title bgfff list-div-arrow-right ">
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
								<li class="border-bottom">
									<label>数&nbsp;&nbsp;量：</label><span id="orderVotes"></span>
								</li>
								<li id="costTotalCreditDiv" style="display: none;">
									<label>积&nbsp;&nbsp;分：</label><span id="costTotalCredit" class="ca9c7ff"></span>
								</li>
							</ul>
						</div>
					</li>
					<li>
						<div class="list-div fs30">
							<p class="padding-top20 padding-bottom20">取票码：<span id="orderValidateCode" class="cd58185"></span></p>
							<img id="activityQrcodeUrl" style="margin-left: 120px;height: 288px;width: 288px;" src=""/>
							<p class="fs24 c26262" style="margin-left: 120px;">出示二维码获取票验证使用</p>
						</div>
					</li>
					<li>
						<div class="list-div padding-bottom20 padding-top20 list-div-arrow-right" onclick="preAddressMap();">
							<p id="activitySite2" class="fs30 c262626"></p>
							<p id="activityAddress" class="fs26 c808080"></p>
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
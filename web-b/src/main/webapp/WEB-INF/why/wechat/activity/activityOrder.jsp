<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <!-- <title>活动预订</title> -->
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wx/css/reset-mc.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wx/css/mc-mobile.css"/>
    <script type="text/javascript" src="${path}/STATIC/wechat/js/jquery.SuperSlide.2.1.js"></script>
    <script type="text/javascript" src="${path}/STATIC/wx/js/mc-mobile.js"></script>
    <script type="text/javascript" src="${path}/STATIC/wx/js/mobile_date/mobiscroll_002.js"></script>
    <script type="text/javascript" src="${path}/STATIC/wx/js/mobile_date/mobiscroll.js"></script>
    <link href="${path}/STATIC/wx/js/mobile_date/mobiscroll_002.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript" src="${path}/STATIC/wx/js/mobile_date/mobiscroll_003.js"></script>
    <script type="text/javascript" src="${path}/STATIC/wx/js/mobile_date/mobiscroll_005.js"></script>
    
    <style>
    	body{position: relative;height: 100%;}
    	.orderInput{text-align: left!important;padding-left: 40px;padding-top: 1px;}
    	.set_block{position: relative;}
    </style>
</head>

<body>
	<div class="header">
		<div class="index-top">
			<span class="index-top-5">
					<img src="${path}/STATIC/wechat/image/arrow1.png" onclick="history.go(-1);"/>
				</span>
			<span class="index-top-2">我的订单</span>
		</div>
	</div>
	<!-- 系统时间 -->
	<input type="hidden" id="currentDate" value="${currentDate}"/>
	<input type="hidden" id="activityStartTime" />
	<input type="hidden" id="activityEndTime" />
	<input type="hidden" id="activityEventPrices" />
	<input type="hidden" id="activityEventIds"/>
	<input type="hidden" id="activityEventCounts"/>
	<input type="hidden" id="acticitySpikeDifferences"/>
	<input type="hidden" id="seats" value="${seats}"/>
	<input type="hidden" id="seatValues" value="${seatValues}"/>
	<input type="hidden" id="activityEventime" value="${activityEventimes}"/>
	<div class="common_container" style="margin-top: 100px;">
	    <div class="list_block block_activity">
	        <div class="activity-title">
				<img id="activityUrl" src="" height="170" width="270"/>
				<div class="activity-p">
					<p class="fs30 c26262" id="activityNameDiv"></p>
					<p class="fs26 c808080 activity-p-place" id="activitySiteDiv"></p>
				</div>
				<div style="clear: both;"></div>
			</div>
	    </div>
	    <div class="list_block">
	        <div class="set_block set_date" style="background: none;">
	            <span class="f-left">日&nbsp;&nbsp;&nbsp;&nbsp;期：</span><input type="hidden" id="activityEventimes"/>
	            <div class="f-left rig padding0" id="set_date">
	            	<input class="orderInput" type="text" name="appDate" id="appDate" readonly placeholder="请选择活动日期" 
	            			style="background:url(${path}/STATIC/wx/image/p_join.png) no-repeat right center;width: 510px; "/>
	            </div>
	            <div style="clear: both;"></div>
	        </div>
	        <div class="set_block set_time">
	            <span class="f-left">时&nbsp;&nbsp;&nbsp;&nbsp;间：</span>
	            <div class="f-left rig" id="set_time">
	            	<input class="orderInput" type="text" readonly placeholder="请选择活动时间" id="orderTime"/>
	            </div>
	            <div style="clear: both;"></div>
	        </div>
	        <div class="time_blocks clearfix" id="activityEventDiv"></div>
	        <div class="set_block set_online set_nbg" id="onlineDiv"></div>
	        <div class="seat_blocks clearfix" id="seatDiv" style="display: none;"></div>
	        <div class="set_block set_mount set_nbg">
	            <span class="f-left">数&nbsp;&nbsp;&nbsp;&nbsp;量：</span>
	            <div class="f-left mode_button ticket_btn" id="bookCountDiv"></div>
	            <div style="clear: both;"></div>
	        </div>
	        <div class="set_block set_ticket set_nbg" id="costCreditDiv"></div>
	    </div>
	    <div class="list_block" id="userInfoDiv">
	        <div class="set_block set_nbg clearfix">
	            <span class="f-left">手机号：</span>
	            <input id="order_phone" class="fs28" type="text" style="float:left;height: 52px;border: none;" placeholder="请输入手机号" maxlength="11"></input>
	        </div>
	        <div class="set_block set_nbg clearfix">
				<span class="f-left">验证码：</span>
				<input id="order_code" class="fs28" type="text" style="float:left;height: 52px;border: none;" placeholder="请输入6位验证码" maxlength="6"></input>
				<span id="smsCodeBut" class="fs26 c26262" style="width: 160px;padding: 5px 10px 5px 10px;border-radius: 
								10px;float: right;background-color:#eaeaea;text-align: center;" onclick="sendSms();">发送验证码</span>
			</div>
			<div class="set_block set_nbg clearfix">
				<span class="f-left">姓&nbsp;&nbsp;&nbsp;&nbsp;名：</span>
				<input id="order_name" class="fs28" type="text" style="float:left;height: 52px;border: none;" placeholder="预订人姓名" maxlength="20"></input>
			</div>
			<div id="userIdCard" class='set_block set_nbg clearfix'></div>
	    </div>
	    <div class="list_block">
	        <div id="orderNoticeDiv" class="set_block set_notes" onclick="orderNotice()" style="display: none">
	            <span>活动须知、退改说明</span>
	        </div>
	    </div>
	</div>
	<div class="M_activity_due">
	    <a id="orderSubmit" onclick="orderSubmit()">提交订单</a>
	</div>
	<div class="content-bg" style="display: none;width: 100%;height: 100%;position: absolute;top: 0px;z-index: 999">
		<div style="width: 100%;height:100%;filter:alpha(Opacity=80);-moz-opacity:0.5;opacity: 0.5;background-color: #000;"></div>
		<div style="width: 100%;height: 100%;display: table;position: absolute;top: 0px;">
			<p style="display: table-cell;vertical-align: middle;text-align: center;color: #fff;font-size: 40px;font-weight: bold;">正在为您预订...</p>
		</div>
	</div>
	
	<form action="${path}/wechatActivity/wcOrderNotice.do" id="orderNoticeForm" method="post">
	    <input type="hidden" id="orderNotice" name="orderNotice"/>
	</form>
</body>

<script type="text/javascript">
	var userId = '${sessionScope.terminalUser.userId}';
	var activityId = '${activityId}';
    var orderTypeName;		//自由入座、在线选座
    var smsCode;
    var identityCard = 0;		//是否需要买票时添加身份证号 0：不需要   1：需要
    var count = 0;		//最大购票数
    var costCredit = '';	//参与此活动消耗的积分数
    var singleEvent = 0;	//是否是单场次活动 0：非单场次 1：单场次
    var eventId = "";	//场次ID
    var eventPrice = "";	//场次票价
    var activitySalesOnline = "";	//是否在线选座
    
    $(function () {
    	if (userId == null || userId == '') {
            window.location.href = "${path}/wechatActivity/preActivityDetail.do?activityId=" + activityId;
            return;
        }
    	
		showActivityOrder();
    });

    //发送验证码
    function sendSms(){
    	var userMobile = $("#order_phone").val();
		var telReg = (/^1[34578]\d{9}$/);
		if(userMobile == ""){
	    	dialogAlert('系统提示', '请输入手机号码！');
	        return false;
	    }else if(!userMobile.match(telReg)){
	    	dialogAlert('系统提示', '请正确填写手机号码！');
	        return false;
	    }
    	$.post("${path}/wechatUser/sendAuthCode.do", {userId: userId,userTelephone: userMobile}, function (data) {
    		if(data.status==0){
    			smsCode = data.data1;
    			var s = 60;
    			$("#smsCodeBut").attr("onclick","");
    			$("#smsCodeBut").html(s+"s");
    			var ss = setInterval(function() {
    				s -= 1;
    				$("#smsCodeBut").html(s+"s");
    				if (s == 0) {
    					clearInterval(ss);
    					$("#smsCodeBut").attr("onclick","sendSms();");
    					smsCode = '';
    					$("#smsCodeBut").html("发送验证码");

    				}
    			}, 1000)
    		}
    	}, "json");
    }
    
    // 时间控制显示
    function showTime() {
		var minDate = $("#activityStartTime").val();;;
		var maxDate = $("#activityEndTime").val();;;
        var opt = {};
        opt.date = {preset: 'date'};
        opt.datetime = {preset: 'datetime'};
        opt.time = {preset: 'time'};
        opt.default = {
            theme: 'android-ics light', //皮肤样式
            display: 'modal', //显示方式
            mode: 'scroller', //日期选择模式
            dateFormat: 'yyyy-mm-dd',
            lang: 'zh',
            showNow: true,
            nowText: "今天",
            setText: '确定',
            cancelText: '取消',
			minDate: new Date(minDate),//月份减1 从0开始
			maxDate: new Date(maxDate),
			onSelect: function (valueText, inst) {
				$("#orderTime").val("");	//清空时间段，重新选择
				
				//根据所选日期匹配时间段
				setEventTime(valueText);
				
				var result = $("#activityEventDiv").find("span");
				var resultLen = $("#activityEventDiv").find("span").length;
				if(resultLen == 1){
					$("#orderTime").val(result.eq(0).html());
				}
				getPeriod(valueText);
				
				//重置选座
			    $("#seats").val("");
			    $("#seatValues").val("");
			    $("#activityEventime").val("");
			    initMethod();
				
			    //判断是否可选择票数
			    showSetMount();
			}
        };
        $("#appDate").mobiscroll($.extend(opt['date'], opt['default']));
    }
    
  	//根据所选日期匹配时间段
    function setEventTime(valueText){
    	var activityEventDiv = "";
		var activityEventimes = $("#activityEventimes").val();
        if (activityEventimes != "" && activityEventimes != null) {
            var timeEvents = activityEventimes.split(",");
            $.each(timeEvents, function (index, timeEvent) {
            	if(valueText==timeEvent.substring(0,10)){
            		activityEventDiv += "<span>" + timeEvent.substring(11,22) + "</span>";
            	}
            });
        }
        $("#activityEventDiv").html(activityEventDiv);
        
      	//活动时间选择
	    $(".set_time").attr("onclick","$('.time_blocks').toggle();");
    }

	function formatStr(str){
		var formatStr = str < 10 ? ("0"+str) : str;
		return formatStr
	}

	//时间格式化
	Date.prototype.format = function(format) {
		var date = {
			"M+": this.getMonth() + 1,
			"d+": this.getDate(),
			"h+": this.getHours(),
			"m+": this.getMinutes(),
			"s+": this.getSeconds(),
			"q+": Math.floor((this.getMonth() + 3) / 3),
			"S+": this.getMilliseconds()
		};
		if (/(y+)/i.test(format)) {
			format = format.replace(RegExp.$1, (this.getFullYear() + '').substr(4 - RegExp.$1.length));
		}
		for (var k in date) {
			if (new RegExp("(" + k + ")").test(format)) {
				format = format.replace(RegExp.$1, RegExp.$1.length == 1
						? date[k] : ("00" + date[k]).substr(("" + date[k]).length));
			}
		}
		return format;
	};

	//判断场次是否过期
	function getPeriod(val){
		var dateStr = $("#currentDate").val();
		var Data = new Date(parseInt(dateStr)).format("yyyy-MM-dd hh:mm");
		var curData = Data.split(" ")[0].split("-").join("");
		var curTime = Data.split(" ")[1];
		$("#activityEventDiv").find("span").each(function(i, v){
			var formatVal = val.split("-").join("");
			if(formatVal == curData) {
				var time = $(this).html();
				if (comparePeriod(curTime, time)) {
					$(this).addClass("enable");
				}else{
					$(this).removeClass("enable");
				}
			}else if(formatVal < curData){
				$(this).addClass("enable");
			}else{
				$(this).removeClass("enable");
			}
		});
	}

	//时间比较
	function comparePeriod(curTime, str){
		var curStr = parseInt(curTime.split(":").join(""));
		var starStr = parseInt(str.split("-")[0].split(":").join(""));
		if(curStr > starStr){
			return true;
		}else {
			return false;
		}
	}

	//时间段点击时间
    $("body").on("click", ".time_blocks span", function () {
    	if(!$(this).hasClass("enable")){
    		var txt = $(this).text();
            $("#set_time").find("input").val(txt);
            $(".time_blocks").hide();
            
          	//重置选座
		    $("#seats").val("");
		    $("#seatValues").val("");
		    $("#activityEventime").val("");
		    initMethod();
            
            showSetMount();		//判断是否可选择票数
    	}
    });

    // 活动订单显示
    function showActivityOrder() {
        $.post("${path}/wechatActivity/activityWcDetail.do", {
            activityId: activityId,
            userId: userId
        }, function (result) {
            if (result != null && result != undefined && result.data.length > 0) {
            	$("#activityUrl").attr("src", getIndexImgUrl(result.data[0].activityIconUrl, "_300_300"));
                $("#activityNameDiv").html(result.data[0].activityName);
                $("#activitySiteDiv").html(result.data[0].activitySite!=""?result.data[0].activitySite:result.data[0].venueName);
				$("#activityStartTime").val(result.data[0].activityStartTime);
				$("#activityEndTime").val(result.data[0].activityEndTime==''?result.data[0].activityStartTime:result.data[0].activityEndTime);
				costCredit = result.data[0].costCredit;
				if(result.data[0].ticketSettings=='N'){
					if(result.data[0].ticketNumber!=''&&result.data[0].ticketCount!=''){
						$(".set_mount").append("<p style='margin-left: 165px;padding-left: 40px;background: url(${path}/STATIC/wechat/image/li.png) no-repeat 5px 13px;" +
							"font-size: 24px;'>此活动同一ID限购买"+result.data[0].ticketNumber+"次，每次不超过"+result.data[0].ticketCount+"张票</p>");
						count = result.data[0].ticketNumber;
					}else if(result.data[0].ticketNumber==''&&result.data[0].ticketCount!=''){
						$(".set_mount").append("<p style='margin-left: 165px;padding-left: 40px;background: url(${path}/STATIC/wechat/image/li.png) no-repeat 5px 13px;" +
							"font-size: 24px;'>此活动同一ID限购买"+result.data[0].ticketNumber+"次</p>");
					}else if(result.data[0].ticketNumber!=''&&result.data[0].ticketCount==''){
						$(".set_mount").append("<p style='margin-left: 165px;padding-left: 40px;background: url(${path}/STATIC/wechat/image/li.png) no-repeat 5px 13px;" +
							"font-size: 24px;'>此活动同一ID每次购买不超过"+result.data[0].ticketCount+"张票</p>");
						count = result.data[0].ticketNumber;
					}
				}else{
					$(".set_mount").append("<p style='margin-left: 165px;padding-left: 40px;background: url(${path}/STATIC/wechat/image/li.png) no-repeat 5px 13px;" +
							"font-size: 24px;'>此活动同一ID限购买5张票</p>");
					count = 5;
				}
                $("#orderNotice").val(result.data[0].activityNotice);
                if (result.data[0].activityNotice != "") {
                    $("#orderNoticeDiv").css("display", "");
                }
                /* var activityEventDiv = "";
                if (result.data[0].timeQuantum != "" && result.data[0].timeQuantum != null) {
                    var timeEvents = result.data[0].timeQuantum.split(",");
                    $.each(timeEvents, function (index, timeEvent) {
                        activityEventDiv += "<span>" + timeEvent + "</span>";
                    });
                }
                $("#activityEventDiv").html(activityEventDiv); */
                $("#order_phone").val('${sessionScope.terminalUser.userMobileNo}');
                $("#order_name").val('${sessionScope.terminalUser.userName}');
                activitySalesOnline = result.data[0].activitySalesOnline;
                var onlineHtml = "";
                if (activitySalesOnline == "Y") {
                    orderTypeName = "在线选座";
                    $("#onlineDiv").removeClass('set_nbg');
                    onlineHtml = "<a onclick='showOnlineSeat()'><span>在线选座：</span><div class='rig' id='set_online'>在线选座</div></a>";

                    var seats = $("#seats").val();
                    if (seats == undefined || seats == null || seats == "") {
                        $("#bookCountDiv").html(0+"<input type='hidden' value='0' id='bookCount'/>");
                    } else {
                        $("#bookCountDiv").html(seats.split(",").length+"<input type='hidden' value='"+seats.split(",").length+"' id='bookCount'/>");
                    }
                } else if (activitySalesOnline == "N") {
                    orderTypeName = "自由入座";
                    $("#onlineDiv").addClass('set_nbg');
                    onlineHtml = "<span>在线选座：</span><div class='rig' id='set_online'>该活动不支持在线选座</div>";

                    $("#bookCountDiv").html("<a class='ticket_reduce'></a>" +
                    						"<input type='text' readonly  value='1' onkeyup=\"this.value=this.value.replace(/\D/g,'')\" onafterpaste=\"this.value=this.value.replace(/\D/g,\'\')\" id='bookCount'/>" +
                    						"<a class='ticket_add'/></a>");
                }
                $("#onlineDiv").html(onlineHtml);
                if(result.data[0].costCredit!=''){
                	$("#costCreditDiv").html("<span class='f-left'>积分消耗：</span><div class='f-left rig cd58185'>"+result.data[0].costCredit+"</div><div style='clear: both;'></div>")
                }
                if(result.data[0].identityCard==1){
                	identityCard = result.data[0].identityCard;
                	$("#userIdCard").html("<span class='f-left'>身份证：</span>" +
				            			  "<input id='order_idcard' class='fs28' type='text' style='float:left;height: 52px;border: none;' placeholder='预订人身份证号' maxlength='18'></input>");
                }
                //单场次
                if(result.data[0].singleEvent==1){
                	singleEvent = 1;
                	$.post("${path}/wechatActivity/wcActivityEventList.do", {activityId: activityId}, function (data) {
                		if(data.status==200){
                			$.each(data.data, function (i, dom) {
                				if(dom.availableCount>0){
                					eventId = dom.eventId;
                					eventPrice = dom.orderPrice;
                					if(count==0||count>dom.availableCount){
                			        	count = dom.availableCount;
                			        }
                					$("#appDate").val(dom.eventEndDate);
                			        $("#orderTime").val(dom.eventTime);
                			        if(dom.eventDate == dom.eventEndDate){
                			        	$(".set_date").append("<div id='singleDate' style='position: absolute;height: 90px;width:535px;line-height: 90px;font-size: 30px;left: 170px;top: 3px;background-color: #fff;color: #9b9b9b;'>" +
    			        						dom.eventDate+"</div>");
                			        }else{
                			        	$(".set_date").append("<div id='singleDate' style='position: absolute;height: 90px;width:535px;line-height: 90px;font-size: 30px;left: 170px;top: 3px;background-color: #fff;color: #9b9b9b;'>" +
    			        						dom.eventDate+"至"+dom.eventEndDate+"</div>");
                			        }
                			        $(".set_time").append("<div id='singleTime' style='position: absolute;height: 90px;width:535px;line-height: 90px;font-size: 30px;left: 170px;top: 3px;background-color: #fff;color: #9b9b9b;'>" +
			        						dom.eventTime+"</div>");
                			        $(".ticket_add").attr("onclick","ticketBtn(1)");
                			        $(".ticket_reduce").attr("onclick","ticketBtn(0)");
                			        return false;
                				}
                			});
                		}
                	}, "json");
                }

                // 隐藏值
                $("#activityEventimes").val(result.data[0].activityEventimes);
                $("#activityEventIds").val(result.data[0].activityEventIds);
                $("#activityEventPrices").val(result.data[0].eventPrices);
                $("#activityEventCounts").val(result.data[0].eventCounts);
                $("#acticitySpikeDifferences").val(result.data[0].spikeDifferences);
            }
        }, "json").success(function(){
			showTime();
			initMethod();
		});
    }

    //在线选座事件
    function showOnlineSeat() {
        var appDate = $("#appDate").val();
        var orderTime = $("#orderTime").val();
        if (appDate == undefined || appDate == null || appDate == "") {
            dialogAlert("提示", "请选择预订日期");
            return;
        }
        if (orderTime == undefined || orderTime == null || orderTime == "") {
            dialogAlert("提示", "请选择预订时间");
            return;
        }

        var activityEventimes = $("#activityEventimes").val();
        var activityEventime = appDate + " " + orderTime;
        var eventTimes = activityEventimes.split(",");
        var fool = "failure";
        for (var i = 0; i < eventTimes.length; i++) {
            if (eventTimes[i] == activityEventime) {
                fool = "success";
                break;
            }
        }
        if (fool == "failure") {
            dialogAlert("提示", activityEventime + "没有此活动");
            return;
        }
        window.location.href = "${path}/wechatActivity/wcOrderSeat.do?activityId=${activityId}&activityEventimes="+activityEventime+"&userName="+$("#order_name").val()+"&userIdCard="+$("#order_idcard").val()+"&userPhone="+$("#order_phone").val();
    }
    
    //判断是否可选择票数
    function showSetMount(){
    	var appDate = $("#appDate").val();
        var orderTime = $("#orderTime").val();
        var activityEventimes = $("#activityEventimes").val();
        var activityEventCounts = $("#activityEventCounts").val();
        var acticitySpikeDifferences = $("#acticitySpikeDifferences").val();
        var activityEventime = appDate + " " + orderTime;
        if (appDate == undefined || appDate == null || appDate == "") {
            return;
        }
        if (orderTime == undefined || orderTime == null || orderTime == "") {
            return;
        }
        var eventTimes = activityEventimes.split(",");
        var eventCounts = activityEventCounts.split(",");
        var spikeDifferences = acticitySpikeDifferences.split(",");
        var eventCount = "";
        var spikeDifference = 0;
        for (var i = 0; i < eventTimes.length; i++) {
            if (eventTimes[i] == activityEventime) {
            	eventCount = eventCounts[i];
            	spikeDifference = spikeDifferences[i];
                break;
            }
        }
        
        if(count==0||count>eventCount){
        	count = eventCount;
        }
        
        if(spikeDifference>0){
        	$(".ticket_add").attr("onclick","");
            $(".ticket_reduce").attr("onclick","");
        	dialogAlert("提示", "该场次尚未开始秒杀！");
        	return;
        }
        
        if(eventCount==0){
        	$(".ticket_add").attr("onclick","");
            $(".ticket_reduce").attr("onclick","");
        	dialogAlert("提示", "该场次已售完！");
        	return;
        }
        
        $(".ticket_add").attr("onclick","ticketBtn(1)");
        $(".ticket_reduce").attr("onclick","ticketBtn(0)");
    }
    
  	//活动人数加减按钮
    function ticketBtn(tip){
        var mount = parseInt($("#bookCount").val());
        if (tip == "0") {	//减
            if (mount > 1) {
                mount = mount - 1;
            } else {
                mount = 1;
            }
        } else {	//加
            if (mount < count) {
                mount = mount + 1;
            } else {
                mount = count;
            }
        }
        $("#bookCount").val(mount);
    }
    
    // 提交订单
    function orderSubmit() {
    	$("#orderSubmit").attr("onclick","");
        var appDate = $("#appDate").val();
        var orderTime = $("#orderTime").val();
        var activityEventimes = $("#activityEventimes").val();
        var activityEventIds = $("#activityEventIds").val();
        var activityEventPrices = $("#activityEventPrices").val();
        var acticitySpikeDifferences = $("#acticitySpikeDifferences").val();
        var userSmsCode = $("#order_code").val();
        var userName = $("#order_name").val();
        var userIdCard = $("#order_idcard").val();
        if (appDate == undefined || appDate == null || appDate == "") {
            dialogAlert("提示", "请选择预订日期");
            $("#orderSubmit").attr("onclick","orderSubmit();");
            return;
        }
        if (orderTime == undefined || orderTime == null || orderTime == "") {
            dialogAlert("提示", "请选择预订时间");
            $("#orderSubmit").attr("onclick","orderSubmit();");
            return;
        }
        var activityEventime = appDate + " " + orderTime;
        var eventTimes = activityEventimes.split(",");
        var eventIds = activityEventIds.split(",");
        var eventPrices = activityEventPrices.split(",");
        var spikeDifferences = acticitySpikeDifferences.split(",");
        var spikeDifference = 0;
        var fool = "failure";
        for (var i = 0; i < eventTimes.length; i++) {
            if (eventTimes[i] == activityEventime) {
           		fool = "success";
           		if(singleEvent!=1){
           			eventId = eventIds[i];
           			eventPrice = eventPrices[i];
           			spikeDifference = spikeDifferences[i];
           		}
                break;
            }
        }
        if(spikeDifference>0){
        	$(".ticket_add").attr("onclick","");
            $(".ticket_reduce").attr("onclick","");
        	dialogAlert("提示", "该场次尚未开始秒杀！");
        	$("#orderSubmit").attr("onclick","orderSubmit();");
        	return;
        }
        if(count==0){
        	dialogAlert("提示", "该场次已售完！");
        	$("#orderSubmit").attr("onclick","orderSubmit();");
            return;
        }
        if (fool == "failure") {
            dialogAlert("提示", activityEventime + "没有此活动");
            $("#orderSubmit").attr("onclick","orderSubmit();");
            return;
        }
        var bookCount = $("#bookCount").val();
		if(${sessionScope.terminalUser.userMobileNo}!=$("#order_phone").val()){
			if(userSmsCode!=smsCode){
				dialogAlert("提示", "短信验证码错误！");
				$("#orderSubmit").attr("onclick","orderSubmit();");
				return;
			}
		}

        if(userName.trim().length==0){
        	dialogAlert("提示", "请输入姓名！");
            $("#orderSubmit").attr("onclick","orderSubmit();");
            return;
        }
        var nameReg = (/^[a-zA-Z0-9\u4e00-\u9fa5]+$/);
    	if(!userName.match(nameReg)){
	    	dialogAlert('提示', '姓名只能由中文，字母，数字组成！');
	    	$("#orderSubmit").attr("onclick","orderSubmit();");
	        return false;
	    }
        if(identityCard==1){
    		var idCardReg = (/^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|X)$/);
    		if(userIdCard.trim().length==0){
    	    	dialogAlert('系统提示', '请输入身份证号！');
    	    	$("#orderSubmit").attr("onclick","orderSubmit();");
    	        return false;
    	    }else if(!userIdCard.match(idCardReg)){
    	    	dialogAlert('系统提示', '请正确填写身份证号！');
    	    	$("#orderSubmit").attr("onclick","orderSubmit();");
    	        return false;
    	    }
        }
        var costTotalCredit = (costCredit==''?0:costCredit*bookCount);
        var orderTotalPrice = (eventPrice==''?0:eventPrice*bookCount);
        $(".content-bg").show();
        $.post("${path}/wechatActivity/wcActivityOrder.do", {
            activityId: activityId,
            userId: userId,
            activityEventIds: eventId,
            bookCount: bookCount,
            orderMobileNum: $("#order_phone").val(),
            orderName: userName,
            orderIdentityCard: userIdCard,
            orderPrice: orderTotalPrice,
            activityEventimes: activityEventime,
            seatIds: $("#seats").val(),
            seatValues: $("#seatValues").val(),
            costTotalCredit: costTotalCredit
        }, function (result) {
        	$(".content-bg").hide();
            if (result.status == 0) {
            	var time = "";
            	//单场次
                if(singleEvent==1){
                	time = $("#singleDate").text()+"&nbsp;"+$("#singleTime").text();
                }else{
                	time = appDate+"&nbsp;"+orderTime;
                }
                dialogBookSuccess("预订成功","您已成功预订："+time+"&nbsp;"+$("#activityNameDiv").html()+"&nbsp;"+bookCount+"张票，短信已发至您"+$("#order_phone").val()+"手机，请查收。");
            } else {
                dialogAlert("提示", result.data);
                $("#orderSubmit").attr("onclick","orderSubmit();");
            }
        }, "json");
    };;;
    
    //预订成功dialog
    function dialogBookSuccess(title, content) {
        var winW = Math.min(parseInt($(window).width() * 0.82), 670);
        var d = dialog({
            width: winW,
            title: title,
            content: content,
            fixed: true,
            button: [{
                value: '我知道了',
                callback: function () {
                    window.location.href = "${path}/wechatActivity/preActivityDetail.do?activityId=${activityId}";
                }
            }, {
                value: '查看订单',
                callback: function () {
                    window.location.href = "${path}/wechatActivity/wcOrderList.do";
                }
            }]
        });
        d.showModal();
    }

    //显示已选座位(从选座页面跳回来)
    function initMethod() {
        var activityEventimes = $("#activityEventime").val();
        if (activityEventimes != undefined && activityEventimes != null && activityEventimes != "") {
            var activityEventime = activityEventimes.split(" ");
            $("#appDate").val(activityEventime[0]);
            $("#orderTime").val(activityEventime[1]);
          	//多场次
            if(singleEvent==0){
            	//根据所选日期匹配时间段
    			setEventTime(activityEventime[0]);
            }
        }

        var seats = $("#seatValues").val();
        if (seats != undefined && seats != null && seats != "") {
            var seatId = seats.split(",");
            var seatHtml = "";
            for (var i = 0; i < seatId.length; i++) {
                var seatRowColumn = seatId[i].split("_");
				seatHtml += "<span>" + seatRowColumn[0] + "排" + seatRowColumn[1] + "座</span>";
            }
            $("#seatDiv").html(seatHtml);
            $("#seatDiv").show();
            $("#order_name").val('${userName}');
            $("#order_idcard").val('${userIdCard}');
            $("#order_phone").val('${userPhone}');
        }else{
        	$("#seatDiv").html("");
            $("#seatDiv").hide();
            if (activitySalesOnline == "Y") {
                $("#bookCountDiv").html(0+"<input type='hidden' value='0' id='bookCount'/>");
            }
        }
        
    }

  	//跳转到活动须知页面
    function orderNotice() {
        $("#orderNoticeForm").submit();
    }
</script>
</html>
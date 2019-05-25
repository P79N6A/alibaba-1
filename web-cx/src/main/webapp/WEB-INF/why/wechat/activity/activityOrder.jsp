<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>活动预订</title>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp" %>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style${empty sourceCode?'':sourceCode}.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wx/css/reset-mc.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wx/css/mc-mobile.css"/>
    <script type="text/javascript" src="${path}/STATIC/wechat/js/jquery.SuperSlide.2.1.js"></script>
    <script type="text/javascript" src="${path}/STATIC/wx/js/mc-mobile.js"></script>
    <script type="text/javascript" src="${path}/STATIC/wx/js/mobile_date/mobiscroll_002.js"></script>
    <script type="text/javascript" src="${path}/STATIC/wx/js/mobile_date/mobiscroll.js"></script>
    <link href="${path}/STATIC/wx/js/mobile_date/mobiscroll_002.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript" src="${path}/STATIC/wx/js/mobile_date/mobiscroll_003.js"></script>
    <script type="text/javascript" src="${path}/STATIC/wx/js/mobile_date/mobiscroll_005.js"></script>

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
			
			.payChoose{
				float: right;
			}
			
			
			
			
			.payMoney{
				float: left;width: 430px;height: 100%;background-color: #f4f4f4;
			}
			.payMoney p:nth-child(1){
				font-size: 36px;line-height: 100px;color: #262626;padding-left: 20px;
			}
			/* .payMoney p:nth-child(1){
				font-size: 32px;padding-left: 20px;line-height: 40px;color: #262626;
			}
			.payMoney p:nth-child(2){
				font-size: 22px;padding-left: 20px;line-height: 22px;margin-top:10px;color: #808080;
			} */
			.payBtn{
				float: right;width: 320px;height: 100%;text-align: center;line-height: 90px;font-size: 40px;background-color: #7279A0;color: #fff;
			}
    </style>
</head>

<body>
<%-- <div class="header">
    <div class="index-top">
        <span class="index-top-5">
                <img src="${path}/STATIC/wechat/image/arrow1.png" onclick="history.go(-1);"/>
            </span>
        <span class="index-top-2">我的订单</span>
    </div>
</div> --%>
<!-- 系统时间 -->
<input type="hidden" id="currentDate" value="${currentDate}"/>
<input type="hidden" id="activityStartTime"/>
<input type="hidden" id="activityEndTime"/>
<input type="hidden" id="activityEventPrices"/>
<input type="hidden" id="activityEventIds"/>
<input type="hidden" id="activityEventCounts"/>
<input type="hidden" id="acticitySpikeDifferences"/>
<input type="hidden" id="seats" value="${seats}"/>
<input type="hidden" id="seatValues" value="${seatValues}"/>
<input type="hidden" id="activityEventime" value="${activityEventimes}"/>
<div class="common_container">
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
        <div class="set_block set_time" >
            <span class="f-left">时&nbsp;&nbsp;&nbsp;&nbsp;间：</span>
            <div class="f-left rig" id="set_time" style="width: 320px">
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
        <div class="set_block set_ticket set_nbg" id="costCreditDiv" style="display: none;background: none;"></div>
        <div class="set_block set_block" id="orderPriceDiv" style="display: none;background: none;">
					<span>价&nbsp;&nbsp;&nbsp;&nbsp;格：</span>
					<div class="f-right rig payfont activityPrice" style="width: 490px;">
						
					</div>
					<input type="hidden" name="orderPrice" id="orderPrice" />
					<div style="clear: both;"></div>
				</div>	
    </div>
    <div class="list_block" id="userInfoDiv">
        <div class="set_block set_nbg clearfix">
            <span class="f-left">手机号：</span>
            <input id="order_phone" class="fs28" type="text" style="float:left;height: 52px;border: none;"
                   placeholder="请输入手机号" maxlength="11" onchange="phoneCheck(this.value)" />
        </div>
        <div class="set_block set_nbg clearfix" id="iCode">
            <span class="f-left">验证码：</span>
            <input id="order_code" class="fs28" type="text" style="float:left;height: 52px;border: none;"
                   placeholder="请输入6位验证码" maxlength="6"/>
				<span id="smsCodeBut" class="fs26 c26262" style="width: 160px;padding: 5px 10px 5px 10px;border-radius: 
								10px;float: right;background-color:#eaeaea;text-align: center;" onclick="sendSms();">发送验证码</span>
        </div>
        <div class="set_block set_nbg clearfix">
            <span class="f-left">姓&nbsp;&nbsp;&nbsp;&nbsp;名：</span>
            <input id="order_name" class="fs28" type="text" style="float:left;height: 52px;border: none;"
                   placeholder="预订人姓名" maxlength="20"/>
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
		<div id="orderPaySubmitDiv"  class="M_activity_due" style="height: 100px;display: none;">
			<div class="payMoney">
				<p>总金额：<span class="payfont orderPrice"></span><!-- <span class="payfont" style="font-size: 26px;">（50积分）</span>--></p> 
				<!-- <p>订单：<span>￥270</span>&emsp;优惠：<span>￥70</span></p> -->
			</div>
			<div class="payBtn" id="orderSubmit" onclick="orderSubmit()">提交订单</div>
		</div>
		<div id="orderSubmitDiv" style="display: none;">
   			 <a id="orderSubmit" onclick="orderSubmit()">提交订单</a> 
   		</div>
</div>
<div class="content-bg" style="display: none;width: 100%;height: 100%;position: fixed;top: 0px;z-index: 999">
    <div style="width: 100%;height:100%;filter:alpha(Opacity=80);-moz-opacity:0.5;opacity: 0.5;background-color: #000;"></div>
    <div style="width: 100%;height: 100%;display: table;position: absolute;top: 0px;">
        <p style="display: table-cell;vertical-align: middle;text-align: center;color: #fff;font-size: 40px;font-weight: bold;">
            正在为您预订...</p>
    </div>
</div>

<form action="${path}/wechatActivity/wcOrderNotice.do" id="orderNoticeForm" method="post">
    <input type="hidden" id="orderNotice" name="orderNotice"/>
</form>
</body>

<script type="text/javascript">
    var activityId = '${activityId}';
    var orderTypeName;		//自由入座、在线选座
    var smsCode;
    var identityCard = 0;		//是否需要买票时添加身份证号 0：不需要   1：需要
    var count = 0;		//最大购票数
    var actCount = 0;		//记录活动最大购票数（多场次时记录，防止多时间段来回点出错）
    var costCredit = '';	//参与此活动消耗的积分数
    var singleEvent = 0;	//是否是单场次活动 0：非单场次 1：单场次
    var eventId = "";	//场次ID
    var eventPrice = "";	//场次票价
    var activitySalesOnline = "";	//是否在线选座
    var spikeDifference = 0;	//距离秒杀时间
    var activityPayPrice=0.0 // 价格
    var activityIsFree =0 // 是否免费 

    //分享是否隐藏
    if (window.injs) {
        injs.setAppShareButtonStatus(false);
    }

    $(function () {
        if (userId == null || userId == '') {
            //判断登陆
            publicLogin("${basePath}wechatActivity/preActivityDetail.do?activityId=" + activityId);
        } else {
            showActivityOrder();
        }
        $("#iCode").hide();
    });

    //发送验证码
    function sendSms() {
        var userMobile = $("#order_phone").val();
        var telReg = (/^1[34578]\d{9}$/);
        if (userMobile == "") {
            dialogAlert('系统提示', '请输入手机号码！');
            return false;
        } else if (!userMobile.match(telReg)) {
            dialogAlert('系统提示', '请正确填写手机号码！');
            return false;
        }
        $.ajax({
    		type: 'post',  
  			url : "${path}/wechatUser/sendAuthCode.do",  
  			dataType : 'json',  
  			data: {userId: userId, userTelephone: userMobile},
  			success: function (data) {
  				if (data.status == 0) {
  	                smsCode = data.data1;
  	                var s = 60;
  	                $("#smsCodeBut").attr("onclick", "");
  	                $("#smsCodeBut").html(s + "s");
  	                var ss = setInterval(function () {
  	                    s -= 1;
  	                    $("#smsCodeBut").html(s + "s");
  	                    if (s == 0) {
  	                        clearInterval(ss);
  	                        $("#smsCodeBut").attr("onclick", "sendSms();");
  	                        smsCode = '';
  	                        $("#smsCodeBut").html("发送验证码");

  	                    }
  	                }, 1000)
  	            }
  			}
        });
    }

    // 时间控制显示
    function showTime() {
        var minDate = $("#activityStartTime").val();
        var maxDate = $("#activityEndTime").val();
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
                if (resultLen == 1) {
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
    function setEventTime(valueText) {
        var activityEventDiv = "";
        var activityEventimes = $("#activityEventimes").val();
        if (activityEventimes != "" && activityEventimes != null) {
            var timeEvents = activityEventimes.split(",");
            $.each(timeEvents, function (index, timeEvent) {
                if (valueText == timeEvent.substring(0, 10)) {
                    activityEventDiv += "<span>" + timeEvent.substring(11, 22) + "</span>";
                }
            });
        }
        
      	//选座页面进入，如已选时间段，则不显示时间段选框
        if($("#orderTime").val()){
        	$(".time_blocks").hide();
        }
        
        $("#activityEventDiv").html(activityEventDiv);

        //活动时间选择
        $(".set_time").attr("onclick", "$('.time_blocks').toggle();");
    }

    function formatStr(str) {
        var formatStr = str < 10 ? ("0" + str) : str;
        return formatStr
    }

    //时间格式化
    Date.prototype.format = function (format) {
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
    function getPeriod(val) {
        var dateStr = $("#currentDate").val();
        var Data = new Date(parseInt(dateStr)).format("yyyy-MM-dd hh:mm");
        var curData = Data.split(" ")[0].split("-").join("");
        var curTime = Data.split(" ")[1];
        $("#activityEventDiv").find("span").each(function (i, v) {
            var formatVal = val.split("-").join("");
            if (formatVal == curData) {
                var time = $(this).html();
                if (comparePeriod(curTime, time)) {
                    $(this).addClass("enable");
                } else {
                    $(this).removeClass("enable");
                }
            } else if (formatVal < curData) {
                $(this).addClass("enable");
            } else {
                $(this).removeClass("enable");
            }
        });
    }

    //时间比较
    function comparePeriod(curTime, str) {
        var curStr = parseInt(curTime.split(":").join(""));
        var starStr = parseInt(str.split("-")[0].split(":").join(""));
        if (curStr > starStr) {
            return true;
        } else {
            return false;
        }
    }

    //时间段点击时间
    $("body").on("click", ".time_blocks span", function () {
        if (!$(this).hasClass("enable")) {
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
            if (result.status == 1) {
                $("#activityUrl").attr("src", getIndexImgUrl(result.data.activityIconUrl, "_300_300"));
                $("#activityNameDiv").html(result.data.activityName);
                $("#activitySiteDiv").html(result.data.activityAddress.length>27?(result.data.activityAddress.substring(0,27)+"..."):result.data.activityAddress);
                $("#activityStartTime").val(result.data.activityStartTime);
                $("#activityEndTime").val(result.data.activityEndTime == '' ? result.data.activityStartTime : result.data.activityEndTime);
                costCredit = result.data.costCredit;
                if (result.data.ticketSettings == 'N') {
                    if (result.data.ticketNumber && result.data.ticketCount) {
                        $(".set_mount").append("<p style='margin-left: 165px;padding-left: 40px;background: url(${path}/STATIC/wechat/image/li.png) no-repeat 5px 13px;" +
                                "font-size: 24px;'>此活动同一ID限购买" + result.data.ticketNumber + "次，每次不超过" + result.data.ticketCount + "张票</p>");
                        count = result.data.ticketCount;
                    } else if (result.data.ticketNumber && !result.data.ticketCount) {
                        $(".set_mount").append("<p style='margin-left: 165px;padding-left: 40px;background: url(${path}/STATIC/wechat/image/li.png) no-repeat 5px 13px;" +
                                "font-size: 24px;'>此活动同一ID限购买" + result.data.ticketNumber + "次</p>");
                    } else if (!result.data.ticketNumber && result.data.ticketCount) {
                        $(".set_mount").append("<p style='margin-left: 165px;padding-left: 40px;background: url(${path}/STATIC/wechat/image/li.png) no-repeat 5px 13px;" +
                                "font-size: 24px;'>此活动同一ID每次购买不超过" + result.data.ticketCount + "张票</p>");
                        count = result.data.ticketCount;
                    }
                } else {
                    $(".set_mount").append("<p style='margin-left: 165px;padding-left: 40px;background: url(${path}/STATIC/wechat/image/li.png) no-repeat 5px 13px;" +
                            "font-size: 24px;'>此活动同一ID限购买5张票</p>");
                    count = 5;
                }
                $("#orderNotice").val(result.data.activityNotice);
                if (result.data.activityNotice != "") {
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
                $("#order_phone").val(window.localStorage.getItem("orderMobileNum") != null ? window.localStorage.getItem("orderMobileNum") : '${userMobileNo}');
                $("#order_name").val(window.localStorage.getItem("orderName") != null ? window.localStorage.getItem("orderName") : '${userName}');
                activitySalesOnline = result.data.activitySalesOnline;
                var onlineHtml = "";
                if (activitySalesOnline == "Y") {
                    orderTypeName = "在线选座";
                    $("#onlineDiv").removeClass('set_nbg');
                    onlineHtml = "<a onclick='showOnlineSeat()'><span>在线选座：</span><div class='rig' id='set_online'>在线选座</div></a>";

                    var seats = $("#seats").val();
                    if (seats == undefined || seats == null || seats == "") {
                        $("#bookCountDiv").html(0 + "<input type='hidden' value='0' id='bookCount'/>");
                    } else {
                        $("#bookCountDiv").html(seats.split(",").length + "<input type='hidden' value='" + seats.split(",").length + "' id='bookCount'/>");
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
                if (result.data.costCredit) {
                    $("#costCreditDiv").html("<span class='f-left'>积分消耗（每张）：</span><div class='f-left rig cd58185'>" + result.data.costCredit + "</div><div style='clear: both;'></div>")
               
                	$("#costCreditDiv").show();
                }
                
                if (result.data.identityCard == 1) {
                    identityCard = result.data.identityCard;
                    $("#userIdCard").html("<span class='f-left'>身份证：</span>" +
                            "<input id='order_idcard' class='fs28' type='text' style='float:left;height: 52px;border: none;' placeholder='预订人身份证号' maxlength='18'></input>");
                }
                //单场次
                if (result.data.singleEvent == 1) {
                    singleEvent = 1;
                    $.post("${path}/wechatActivity/wcActivityEventList.do", {activityId: activityId}, function (data) {
                        if (data.status == 200) {
                            $.each(data.data, function (i, dom) {
                                if (dom.availableCount > 0) {
                                    eventId = dom.eventId;
                                    eventPrice = dom.orderPrice;
                                    spikeDifference = dom.spikeDifference;
                                    if (count == 0 || count > dom.availableCount) {
                                        count = dom.availableCount;
                                    }
                                    $("#appDate").val(dom.eventEndDate);
                                    $("#orderTime").val(dom.eventTime);
                                    if (dom.eventDate == dom.eventEndDate) {
                                        $(".set_date").append("<div id='singleDate' style='position: absolute;height: 90px;width:550px;line-height: 90px;font-size: 30px;left: 150px;top: 3px;background-color: #fff;color: #9b9b9b;'>" +
                                                dom.eventDate + "</div>");
                                    } else {
                                        $(".set_date").append("<div id='singleDate' style='position: absolute;height: 90px;width:550px;line-height: 90px;font-size: 30px;left: 150px;top: 3px;background-color: #fff;color: #9b9b9b;'>" +
                                                dom.eventDate + "至" + dom.eventEndDate + "</div>");
                                    }
                                    $(".set_time").append("<div id='singleTime' style='position: absolute;height: 90px;width:550px;line-height: 90px;font-size: 30px;left: 150px;top: 3px;background-color: #fff;color: #9b9b9b;'>" +
                                            dom.eventTime + "</div>");
                                    $(".ticket_add").attr("onclick", "ticketBtn(1)");
                                    $(".ticket_reduce").attr("onclick", "ticketBtn(0)");
                                    return false;
                                }
                            });
                        }
                    }, "json");
                }else{
                	actCount = count;	//记录当前活动预订票数限制（防止多时间段来回点出错）
                }
                activityIsFree = result.data.activityIsFree
                if (activityIsFree == 3) {
                	activityPayPrice=result.data.activityPayPrice
                	var bookCount=$("#bookCount").val();
                	var orderPrice=bookCount * result.data.activityPayPrice
                	$(".orderPrice").html("￥"+orderPrice)
                	$(".activityPrice").html("￥"+activityPayPrice)
                	$("#orderPrice").val(orderPrice);
                	$("#orderPriceDiv").show();
                	
                	$("#orderPaySubmitDiv").show();
                	$("#orderSubmitDiv").remove();
                }
                else{
                	$("#orderPaySubmitDiv").remove();
                	$("#orderSubmitDiv").show();
                }
                	

                // 隐藏值
                $("#activityEventimes").val(result.data.activityEventimes);
                $("#activityEventIds").val(result.data.activityEventIds);
                $("#activityEventPrices").val(result.data.eventPrices);
                $("#activityEventCounts").val(result.data.eventCounts);
                $("#acticitySpikeDifferences").val(result.data.spikeDifferences);
            }
            else if (result.status == 500) {

                window.location.href = "../../../../timeOut.html";
            }
        }, "json").success(function () {
            showTime();
            initMethod();
        });
    }

    //在线选座事件
    function showOnlineSeat() {
        if (userId == null || userId == '') {
            //判断登陆
            publicLogin("${basePath}wechatActivity/preActivityOrder.do?activityId=" + activityId);
        } else {
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
            window.location.href = "${path}/wechatActivity/wcOrderSeat.do?userId="+userId+"&activityId=${activityId}&activityEventimes=" + activityEventime + "&userName=" + $("#order_name").val() + "&userIdCard=" + $("#order_idcard").val() + "&userPhone=" + $("#order_phone").val() + "&count=" + count + "&callback=${callback}&sourceCode=${sourceCode}";
        }
    }

    //判断是否可选择票数
    function showSetMount() {
    	//多场次重置最大票数（防止多时间段来回点出错）
        if (singleEvent != 1) {
        	count = actCount;
        }
    	
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
        for (var i = 0; i < eventTimes.length; i++) {
            if (eventTimes[i] == activityEventime) {
                eventCount = eventCounts[i];
                spikeDifference = spikeDifferences[i];
                break;
            }
        }

        if (count == 0 || count > eventCount) {
            count = eventCount;
        }

        if (spikeDifference > 0) {
            $(".ticket_add").attr("onclick", "");
            $(".ticket_reduce").attr("onclick", "");
            dialogAlert("提示", "该场次尚未开始秒杀！");
            return;
        }

        if (eventCount == 0) {
            $(".ticket_add").attr("onclick", "");
            $(".ticket_reduce").attr("onclick", "");
            dialogAlert("提示", "该场次已售完！");
            return;
        }

        $(".ticket_add").attr("onclick", "ticketBtn(1)");
        $(".ticket_reduce").attr("onclick", "ticketBtn(0)");
    }

    //活动人数加减按钮
    function ticketBtn(tip) {
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
        
        var orderPrice=mount * activityPayPrice
    	$(".orderPrice").html("￥"+orderPrice)
    	$("#orderPrice").val(orderPrice);
        
        $("#bookCount").val(mount);
    }

    // 提交订单
    function orderSubmit() {
        if (userId == null || userId == '') {
            //判断登陆
            publicLogin("${basePath}wechatActivity/preActivityOrder.do?activityId=" + activityId);
        } else {
            $("#orderSubmit").attr("onclick", "");
            
            if(activityIsFree==3){	//安卓版本3.7.0之前版本不可支付
            	if (/wenhuayun/.test(ua)) {
	            	var ver = ua.substring(ua.indexOf('wenhuayun/')+10,ua.indexOf(' platform/'));
	    			if (browser.versions.android && compareArray(ver, '3.7.0') == -1) {		
	    				window.location.href = "../../../../timeOut.html?noPay";
	    				return;
	    			}
            	}
            }
            
            var appDate = $("#appDate").val();
            var orderTime = $("#orderTime").val();
            var activityEventimes = $("#activityEventimes").val();
            var activityEventIds = $("#activityEventIds").val();
            var activityEventPrices = $("#activityEventPrices").val();
            var acticitySpikeDifferences = $("#acticitySpikeDifferences").val();
            var orderMobileNum = $("#order_phone").val();
            var userSmsCode = $("#order_code").val();
            var userName = $("#order_name").val();
            var userIdCard = $("#order_idcard").val();
            if (appDate == undefined || appDate == null || appDate == "") {
                dialogAlert("提示", "请选择预订日期");
                $("#orderSubmit").attr("onclick", "orderSubmit();");
                return;
            }
            if (orderTime == undefined || orderTime == null || orderTime == "") {
                dialogAlert("提示", "请选择预订时间");
                $("#orderSubmit").attr("onclick", "orderSubmit();");
                return;
            }
            var activityEventime = appDate + " " + orderTime;
            var eventTimes = activityEventimes.split(",");
            var eventIds = activityEventIds.split(",");
            var eventPrices = activityEventPrices.split(",");
            var spikeDifferences = acticitySpikeDifferences.split(",");
            var fool = "failure";
            for (var i = 0; i < eventTimes.length; i++) {
                if (eventTimes[i] == activityEventime) {
                    fool = "success";
                    if (singleEvent != 1) {
                        eventId = eventIds[i];
                        eventPrice = eventPrices[i];
                        spikeDifference = spikeDifferences[i];
                    }
                    break;
                }
            }
            if (spikeDifference > 0) {
                $(".ticket_add").attr("onclick", "");
                $(".ticket_reduce").attr("onclick", "");
                dialogAlert("提示", "该场次尚未开始秒杀！");
                $("#orderSubmit").attr("onclick", "orderSubmit();");
                return;
            }
            if (count == 0) {
                dialogAlert("提示", "该场次已售完！");
                $("#orderSubmit").attr("onclick", "orderSubmit();");
                return;
            }
            if (fool == "failure") {
                dialogAlert("提示", activityEventime + "没有此活动");
                $("#orderSubmit").attr("onclick", "orderSubmit();");
                return;
            }
            var bookCount = $("#bookCount").val();
            if (bookCount == 0) {
                if (activitySalesOnline == "Y") {
                    dialogAlert("提示", "请选择座位！");
                    $("#orderSubmit").attr("onclick", "orderSubmit();");
                    return;
                } else if (activitySalesOnline == "N") {
                    dialogAlert("提示", "请选择票数！");
                    $("#orderSubmit").attr("onclick", "orderSubmit();");
                    return;
                }
            }
            if(orderMobileNum==''){
                dialogAlert("提示", "请输入手机号！");
                $("#orderSubmit").attr("onclick","orderSubmit();");
                return;
            }
            if(userSmsCode!=smsCode && orderMobileNum != '${userMobileNo}' && orderMobileNum != window.localStorage.getItem("orderMobileNum")){
            	$("#iCode").show();
                dialogAlert("提示", "请输入正确的短信验证码！");
                $("#orderSubmit").attr("onclick","orderSubmit();");
                return;
            }
            if (userName.trim().length == 0) {
                dialogAlert("提示", "请输入姓名！");
                $("#orderSubmit").attr("onclick", "orderSubmit();");
                return;
            }
            var nameReg = (/^[a-zA-Z0-9\u4e00-\u9fa5]+$/);
            if (!userName.match(nameReg)) {
                dialogAlert('提示', '姓名只能由中文，字母，数字组成！');
                $("#orderSubmit").attr("onclick", "orderSubmit();");
                return false;
            }
            var identityCardHtml = "";
            if (identityCard == 1) {
                var idCardReg = (/^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|X)$/);
                if (userIdCard.trim().length == 0) {
                    dialogAlert('系统提示', '请输入身份证号！');
                    $("#orderSubmit").attr("onclick", "orderSubmit();");
                    return false;
                } else if (!userIdCard.match(idCardReg)) {
                    dialogAlert('系统提示', '请正确填写身份证号！');
                    $("#orderSubmit").attr("onclick", "orderSubmit();");
                    return false;
                }else{
                	identityCardHtml = "<p>身份证："+userIdCard+"</p>";
                }
            }
            var costTotalCredit = (costCredit == '' ? 0 : costCredit * bookCount);
            var orderTotalPrice = (eventPrice == '' ? 0 : eventPrice * bookCount);
            
            var bookCountHtml = "";
        	if(activitySalesOnline == "Y") {	//在线选座票数赋值
       			var seatInfo = "";
        	    $("#seatDiv>span").each(function(){
        	    	seatInfo += $(this).text() + "，";
        	    });
        	    bookCountHtml = bookCount + "张 （" + seatInfo.substring(0,seatInfo.length-1) + "）";
        	} else if (activitySalesOnline == "N") {
        		bookCountHtml = bookCount + "张 ";
            }
            var bookConfirmText = "<p><b>当前用户：${userName}</b></p>" +
            					  "<p>活动："+$("#activityNameDiv").text()+"</p>" +
            					  "<p>时间："+appDate+" "+orderTime+"</p>" +
            					  "<p>订票数："+bookCountHtml+"</p>" +
            					  "<p>手机："+orderMobileNum+"</p>" +
            					  "<p>预订人："+userName+"</p>" +
            					  identityCardHtml;
            
            dialogBookConfirm("订单确认",bookConfirmText ,function(){
	            $(".content-bg").show();
	            $.post("${path}/wechatActivity/wcActivityOrder.do", {
	                activityId: activityId,
	                userId: userId,
	                activityEventIds: eventId,
	                bookCount: bookCount,
	                orderMobileNum: orderMobileNum,
	                orderName: userName,
	                orderIdentityCard: userIdCard,
	                orderPrice: orderTotalPrice,
	                activityEventimes: activityEventime,
	                seatIds: $("#seats").val(),
	                seatValues: $("#seatValues").val(),
	                costTotalCredit: costTotalCredit
	            }, function (result) {
	                $(".content-bg").hide();
	                var result=eval(result);
	                if (result.status == "1") {
						if(activityIsFree==3){
							 //缓存预订人姓名和手机
	                        window.localStorage.setItem("orderName", userName);
	                        window.localStorage.setItem("orderMobileNum", $("#order_phone").val());
	                		if (/wenhuayun/.test(ua)) {		//APP端
	                			injs.appOrderPay(result.data);
	                     	}else{	//H5
	                     		window.location.href = "${path}/wechatActivity/preActivityOrderPay.do?activityOrderId="+result.data;
	                     	}
						}else{
							if (result.data.length==10) {
	                            //缓存预订人姓名和手机
	                            window.localStorage.setItem("orderName", userName);
	                            window.localStorage.setItem("orderMobileNum", $("#order_phone").val());
	                            var time = "";
	                            //单场次
	                            if (singleEvent == 1) {
	                                time = $("#singleDate").text() + "&nbsp;" + $("#singleTime").text();
	                            } else {
	                                time = appDate + "&nbsp;" + orderTime;
	                            }
	                          	dialogBookSuccess("预订成功", "您已成功预订：" + time + "&nbsp;" + $("#activityNameDiv").html() + "&nbsp;" + bookCount + "张票，短信已发至您" + $("#order_phone").val() + "手机，请查收。");
							}
						}
	                } else if(result.status == "0") {
	                    dialogAlert("提示", result.msg?result.msg.errmsg:result.data);
	                    $("#orderSubmit").attr("onclick", "orderSubmit();");
	                }if (result.status == 500) {
	                    window.location.href = "../../../../timeOut.html";
	                }
	            }, "json");
            })
        }
        
      	//预订确认dialog
    	function dialogBookConfirm(title, content, fn){
    		var winW = Math.min(parseInt($(window).width()*0.82), 575);
    		var d = dialog({
    			width:winW,
    			title:title,
    			content:content,
    			fixed: true,
    			button:[{
    				value: '提交订单',
    				callback: function () {
    					if(fn)  fn();
    				},
    				autofocus: true
    			},{
    				value: '更换用户',
    				callback: function () {
    					if (/wenhuayun/.test(ua) && window.injs) {		//APP端
    						injs.appSignOut('${basePath}wechatActivity/preActivityDetail.do?activityId=${activityId}&callback=${callback}&sourceCode=${sourceCode}');
    					}else{
    						location.href = '${callback}muser/outLogin.do?type=${basePath}wechatActivity/preActivityDetail.do?activityId=${activityId}';
    					}
    				},
    				autofocus: true
    			}]
    		});
    		d.showModal();
    	}
	
        //判断安卓版本好大小
        function compareArray(str1, str2) {
            var arr1 = str1.split('.');
            var arr2 = str2.split('.');
            var i = -1;
            // f=0 相等 ; 
            // f=1   第一个>第二个 ; 
            // f=-1  第一个<第二个
            var f = 0;
            function digiu() {
                if(i < arr1.length) {
                    i++;
                    if(Number(arr1[i]) > Number(arr2[i])) {
                        f = 1;
                    } else if(Number(arr1[i]) < Number(arr2[i])) {
                        f = -1;
                    } else {
                        f = 0;
                        digiu();
                    }
                }
                return f;
            }
            return digiu();
        }

        
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
                        if (window.injs) {	//判断是否存在方法
                            injs.appPageJumpAfterBooking(1);
                        } else {
                            window.location.href = "${path}/wechatActivity/preActivityDetail.do?activityId=${activityId}&userId=${userId}&callback=${callback}&sourceCode=${sourceCode}";
                        }
                    }
                }, {
                    value: '查看订单',
                    callback: function () {
                        if (window.injs) {	//判断是否存在方法
                            injs.accessAppPage(7, 1);
                        } else {
                            window.location.href = "${path}/wechatActivity/wcOrderList.do?userId=${userId}&callback=${callback}&sourceCode=${sourceCode}";
                        }
                    }
                }]
            });
            d.showModal();
        }
    }

    //显示已选座位(从选座页面跳回来)
    function initMethod() {
        var activityEventimes = $("#activityEventime").val();
        if (activityEventimes != undefined && activityEventimes != null && activityEventimes != "") {
            var activityEventime = activityEventimes.split(" ");
            $("#appDate").val(activityEventime[0]);
            $("#orderTime").val(activityEventime[1]);
            //多场次
            if (singleEvent == 0) {
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
        } else {
            $("#seatDiv").html("");
            $("#seatDiv").hide();
            if (activitySalesOnline == "Y") {
                $("#bookCountDiv").html(0 + "<input type='hidden' value='0' id='bookCount'/>");
            }
        }

        showSetMount();
    }
    function phoneCheck(phone){
        if( phone == '${userMobileNo}'||phone == window.localStorage.getItem("orderMobileNum") ){
            $("#iCode").hide()
        }else{
            $("#iCode").show()
        }
    }
    //跳转到活动须知页面
    function orderNotice() {
        $("#orderNoticeForm").submit();
    }
</script>
</html>
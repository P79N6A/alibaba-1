/**
 * 预定
 */
function doBook() {

    /* 下面所有验证通过后再走这个  必须要取到正确的手机号码  2015.10.20 niubiao添加逻辑*/
    var mark = $("#mark").val();
    if (!mark) {
        //绑定手机
        top.dialog({
            url: '../frontActivity/dialog.do?code=' + $("#orderPhoneNo").val() + "&code=" + new Date().getTime(),
            title: '验证手机',
            width: 560,
            fixed: true,
            data: $(this).attr("data-name")
        }).showModal();
        return;
    }

    if ($("#orderPhoneNo").val() != undefined && $("#orderPhoneNo").val() == '') {
        removeMsg("orderPhoneNoMsg");
        appendMsg("orderPhoneNoMsg", "请输入预订电话号码");
        $('#orderPhoneNo').focus();
        return;
    } else {
        removeMsg("orderPhoneNoMsg");
    }
    var reg = /^1\d{10}$/;
    if (!reg.test($("#orderPhoneNo").val())) {
        removeMsg("orderPhoneNoMsg");
        appendMsg("orderPhoneNoMsg", "请输入正确的手机号码!");
        $('#orderPhoneNo').focus();
        return;
    } else {
        removeMsg("orderPhoneNoMsg");
    }
    var telReg = (/^1[34578]\d{9}$/);
    if (!telReg.test($("#orderPhoneNo").val())) {
        removeMsg("orderPhoneNoMsg");
        appendMsg("orderPhoneNoMsg", "请输入正确的手机号码!");
        $('#orderPhoneNo').focus();
        return;
    } else {
        removeMsg("orderPhoneNoMsg");
    }

    if ($("#bookCount").val() == undefined && (document.getElementsByName("seatId") == null || document.getElementsByName("seatId").length == 0)) {
        dialogAlert("提示", "请选择座位!");
        return;
    }
    if ($("#bookCount").val() != undefined && $("#bookCount").val() == '') {
        removeMsg("bookCountMsg");
        appendMsg("bookCountMsg", "请输入预订数量!");
        $('#bookCount').focus();
        return;
    } else {
        removeMsg("bookCountMsg");
    }

    if ($("#bookCount").val() != undefined) {
        var reg = new RegExp("^[0-9]*$");
        if (!reg.test($("#bookCount").val()) || $("#bookCount").val() <= 0) {
            removeMsg("bookCountMsg");
            appendMsg("bookCountMsg", "请输入正确的预订数量!");
            $('#bookCount').focus();
            return;
        } else {
            removeMsg("bookCountMsg");
        }


        var ticketSetting = $('#ticketSettings').val();
        var ticketCount = $('#ticketCountInfo').val();
        var ticketNumber = $('#ticketNumberInfo').val();
        if (ticketSetting != undefined && ticketSetting == 'N' && ticketCount != undefined && parseInt(ticketCount) > 0) {
            if (parseInt($("#bookCount").val()) > parseInt(ticketCount)) {
                removeMsg("bookCountMsg");
                appendMsg("bookCountMsg", "单次最多可预定" + ticketCount + "张");
                $('#bookCount').focus();
                return;
            }
        }
    }

    if(!$("#bookCount").val()){
        $("#costTotalCredit").val(document.getElementsByName("seatId").length*costCredit);
    }else{
        $("#costTotalCredit").val($("#bookCount").val()*costCredit);
    }


    if (!valCode()) {
        removeMsg("idcodeMsg");
        appendMsg("idcodeMsg", "请输入正确的验证码!");
        return;
    } else {
        removeMsg("idcodeMsg");
    }
    if ($("#eventEndDate").val()!="") {
        var eventDateTime = $("#eventEndDate").val() + " " + $("#eventTime").val();
    } else {
        var eventDateTime = $("#date-input").val() + " " + $("#eventTime").val();
    }
    $("#eventDateTime").val(eventDateTime);
    var ticketNumber = $('#ticketNumberInfo').val();
    
    
	/*var activityCustomInfo = '${cmsActivity.activityCustomInfo}'
	var orderCustomInfo = "";
    if(activityCustomInfo && activityCustomInfo.length>0){
        var orderCustomInfoObj = [];
        var cusindex = 0;
        var orderCustomInfoFlag = true;
        $("#orderCustomInfoTable tr").each(function(){
        	var customInfotd = "customInfotd"+cusindex;
        	if($(this).find("textarea").val().length==0){
        		appendMsg(customInfotd, "请输入"+$(this).find("td .textareaspanclass").attr("text")+"!");
        		return false;
        	}else{
        		removeMsg(customInfotd);
        	}
        	orderCustomInfoObj.push({"title":$(this).find("td .textareaspanclass").attr("text"),"value":$(this).find("td div textarea").val()});
        	cusindex++;
        })
        if(!orderCustomInfoFlag){
        	return;
        }
        if(orderCustomInfoObj.length>0){
        	orderCustomInfo = JSON.stringify(orderCustomInfoObj);
        	console.log(orderCustomInfo);
        	$("#orderCustomInfo").val(orderCustomInfo);
        }else{
        	$("#orderCustomInfo").val("");
        }
    }*/
    var activityCustomInfo = '${cmsActivity.activityCustomInfo}'
    	var orderCustomInfo = "";
    if(activityCustomInfo && activityCustomInfo.length>0){
    	var orderCustomInfoObj = [];
    	var cusindex = 0;
    	var orderCustomInfoFlag = true;
    	console.log($(".actOrderBaoInfo .aobItem"));
    	$(".actOrderBaoInfo .aobItem").each(function(){
    		var customInfotd = "customInfotd"+cusindex;
    		if($(this).find("textarea").val().length==0){
    			removeMsg(customInfotd);
    			appendMsg(customInfotd, "请输入"+$(this).find(".wenti").attr("text"));
    			$(this).find("#"+customInfotd+"vPanel").css("width","500px");
    			orderCustomInfoFlag = false;
    			$(this).find("textarea").focus();
    			return false;
    		}else{
    			removeMsg(customInfotd);
    		}
    		orderCustomInfoObj.push({"title":$(this).find(".wenti").attr("text"),"value":$(this).find("textarea").val(),"desc":$(this).find("textarea").attr("maxlength")});
    		cusindex++;
    	})
    	if(!orderCustomInfoFlag){
    		return;
    	}
    	if(orderCustomInfoObj.length>0){
    		orderCustomInfo = JSON.stringify(orderCustomInfoObj);
    		console.log(orderCustomInfo);
    		$("#orderCustomInfo").val(orderCustomInfo);
    	}else{
    		$("#orderCustomInfo").val("");
    	}
    }
    
    
    $.ajax({
        type: 'POST',
        dataType: "json",
        data: $("#bookForm").serialize(),
        url: "../frontActivity/checkFrontActivityBook.do",//请求的action路径
        error: function () {//请求失败处理函数
            alert('error');
        },
        success: function (data) { //请求成功后处理函数。
            if (data.success == 'Y') {
                $("#seatValues").val(data.seatValues);
                $("#bookForm").submit();
                //location.href= "../frontActivity/preSaveActivityOder.do?activityOrderId="+ data.msg + "&" + $("#bookForm").serialize();
            } else {
                if (data.msg == 'activityEmpty') {
                    dialogAlert("提示", "活动不能为空!");
                } else if (data.msg == 'seatEmpty') {
                    dialogAlert("提示", "请选择座位!");
                } else if (data.msg == 'more') {
                    dialogAlert("提示", "购票数不能超过5张!");
                } else if (data.msg == 'login') {
                    dialogAlert("提示", "请先登录!");
                } else if (data.msg == 'overtime') {
                    dialogAlert("提示", "不在可预订时间内!");
                } else if (data.msg == 'overCount') {
                    dialogAlert("提示", "剩余票数不够!");
                } else if (data.msg == 'errorCount') {
                    dialogAlert("提示", "请输入正确的票数!");
                } else if (data.msg == 'moreLimit') {
                    dialogAlert("提示", "本场活动最多可预定" + ticketNumber + "次，你已预定" + ticketNumber + "次");
                }
                else {
                    dialogAlert("提示", "预订失败:" + data.msg + "!");
                }
            }

        }
    });
}

/**
 * 是否同意条款
 */
function acceptItem() {
    if ($("#agreement").prop("checked")) {
        $("#subOrder").removeAttr("style");
        $("#subOrder").prop('disabled', false);
    } else {
        $("#subOrder").css('background', '#808080');
        $("#subOrder").prop('disabled', true);
    }
}


//初始化 验证码
$(function () {
    $.idcode.setCode();
    /*window.code = $.idcode;
     code.setCode();*/
});
//验证验证码  true,false
function valCode() {
    if ($.idcode.validateCode()) {
        return true;
    } else {
        return false;
    }
}


/*
 * 选择时间时展示对应的座位信息
 */
$(function () {
    //选择日期
    if ($("#eventDateTime").val() != undefined && $("#eventDateTime").val() != '') {
        var dateInfo = $("#eventDateTime").val().split(" ");
        var eventDate = dateInfo[0];
        var eventTime = dateInfo[1];
        $("#date-input").val(eventDate);
        var index = 0;
        $("#eventTime option").each(function () {
            if ($(this).text() == eventTime) {
                //$("#eventTime").get(0).selectedIndex=index;
                $('#eventTime')[0].selectedIndex = index;
                $("#date-caption").html(eventTime);
            }
            index++;
        });
    }

    /*  showSeatInfo();*/
    //日期变化时
    /*    $(".data-btn").on("click", function(){
     WdatePicker({el:'minDateHidden',dateFmt:'yyyy-MM-dd',
     doubleCalendar:true,minDate:'#F{$dp.$D(\'minDate\')}',maxDate:'#F{$dp.$D(\'maxDateHidden\')}',position:{left:-163,top:4},isShowClear:false,isShowOK:false,isShowToday:false,onpicked:pickedFunc})
     });*/
    //时间段变化时


});
function pickedFunc() {
    $dp.$('date-input').value = $dp.cal.getDateStr('yyyy-MM-dd');
    $dp.$('data-week').innerHTML = $dp.cal.getDateStr('DD');
    //切换场次的时候清空已选的座位
    $("#selected-seats").html("");
    $("#selectSeatInfo").val("");
    showSeatInfo();
    queryEventTime();
}

/**
 * 显示座位信息模板
 */
function showSeatInfo() {
    if ($("#eventEndDate").val()!="") {
        var eventDateTime = $("#eventEndDate").val() + " " + $("#eventTime").val();
    } else {
        var eventDateTime = $("#date-input").val() + " " + $("#eventTime").val();
    }
    $("#eventDateTime").val(eventDateTime);
    $.post("../frontActivity/showActivitySeatInfo.do", $("#bookForm").serialize(),
        function (map) { //请求成功后处理函数。
            var data = eval(map);
            if (data.success == 'Y') {
                $("#seatInfo").val(data.seatInfo);
                $("#maintananceInfo").val(data.maintananceInfo);
                $("#vipInfo").val(data.vipInfo);
                $("#eventId").val(data.eventId);
                $("#ticketCount").html(data.ticketCount);
                $("#maxColumn").val(data.maxColumn);
                $("#seat-map").html("");
                $("#seat-tit").html("");
                showSeat();
            } else {
                $("#seatInfo").val("");
                $("#vipInfo").val("");
                $("#ticketCount").html("0");
                $("#seat-map").html("");
                showSeat();
            }
        });

}
//function showSeat() {
//    var seatInfo = $("#seatInfo").val();
//    if (seatInfo != "" && seatInfo != undefined) {
//        var seatInfoArr = seatInfo.split(",");
//        var column = parseInt($("#maxColumn").val());
//        var reg = new RegExp("-", "g"); //创建正则RegExp对象
//        for (var i = 0; i < seatInfoArr.length; i++) {
//            seatInfoArr[i] = seatInfoArr[i].replace(reg, "\,");
//        }
//
//        //显示VIP座位信息
//        var vipInfo = $("#vipInfo").val();
//        if (vipInfo != '' && vipInfo != undefined) {
//            var vipInfoArr = vipInfo.split(",");
//            for (var i = 0; i < vipInfoArr.length; i++) {
//                vipInfoArr[i] = vipInfoArr[i];
//            }
//        }
//
//
//        var $cart = $('#selected-seats'), //座位区
//            $counter = $('#counter'), //票数
//            $total = $('#total'); //总计金额
//
//        var sc = $('#seat-map').seatCharts({
//            map: seatInfoArr,
//            columnNum: column,
//            seats: {
//                a: {
//                    price: 20,
//                    classes: 'first-level', //your custom CSS class
//                    category: '一等座'
//                },
//                b: {
//                    price: 15,
//                    classes: 'second-level', //your custom CSS class
//                    category: '二等座'
//                },
//                c: {
//                    price: 10,
//                    classes: 'third-level', //your custom CSS class
//                    category: '三等座'
//                }
//
//            },
//            naming: {
//                top: false,
//                getLabel: function (character, row, column) {
//                    return column;
//                }
//            },
//            legend: { //定义图例
//                node: $('#legend'),
//                items: [
//                    ['a', 'available', '¥20'],
//                    ['b', 'available', '¥15'],
//                    ['c', 'available', '¥10']
//                ]
//            },
//            click: function () { //点击事件
//                if (this.status() == 'available') { //可选座
//                    $(".ticket-list").fadeIn();
//                    var ticketStatus = '${cmsActivity.ticketSettings}';
//                    var ticketCount = parseInt('${cmsActivity.ticketCount}') + parseInt(1);
//                    var ticketNumber = parseInt('${cmsActivity.ticketNumber}');
//                    if (ticketStatus != undefined && ticketStatus == 'Y') {
//                        if ((sc.find('selected').length + 1) < 6) {
//                            $('<span class="seat-txt"><input type="hidden" name="seatValues" value="' + (this.settings.row + 1) + '排' + this.settings.label + '座' + '" /><input type="hidden" name="seatId" value="' + this.settings.id + '" /> ' + (this.settings.row + 1) + '排' + this.settings.label + '座</span>')
//                                .attr('id', 'cart-item-' + this.settings.id)
//                                .data('seatId', this.settings.id)
//                                .appendTo($cart);
//
//                            $counter.text(sc.find('selected').length + 1);
//                            $total.text(recalculateTotal(sc) + this.data().price);
//
//                            return 'selected';
//                        } else {
//                            alert("每单最多可预订5个座位");
//                            return 'available';
//                        }
//                    } else if (ticketStatus != undefined && ticketStatus == 'N') {
//                        if (ticketCount != undefined && parseInt(ticketCount) > 0) {
//                            if ((sc.find('selected').length + 1) < ticketCount) {
//                                $('<span class="seat-txt"><input type="hidden" name="seatValues" value="' + (this.settings.row + 1) + '排' + this.settings.label + '座' + '" /><input type="hidden" name="seatId" value="' + this.settings.id + '" /> ' + (this.settings.row + 1) + '排' + this.settings.label + '座</span>')
//                                    .attr('id', 'cart-item-' + this.settings.id)
//                                    .data('seatId', this.settings.id)
//                                    .appendTo($cart);
//
//                                $counter.text(sc.find('selected').length + 1);
//                                $total.text(recalculateTotal(sc) + this.data().price);
//
//                                return 'selected';
//                            } else {
//                                alert("单次最多可预定" + (parseInt(ticketCount) - parseInt(1)) + "张");
//                                return 'available';
//                            }
//                        }
//                        if (ticketNumber != undefined && parseInt(ticketNumber) > 0) {
//                            $('<span class="seat-txt"><input type="hidden" name="seatValues" value="' + (this.settings.row + 1) + '排' + this.settings.label + '座' + '" /><input type="hidden" name="seatId" value="' + this.settings.id + '" /> ' + (this.settings.row + 1) + '排' + this.settings.label + '座</span>')
//                                .attr('id', 'cart-item-' + this.settings.id)
//                                .data('seatId', this.settings.id)
//                                .appendTo($cart);
//
//                            $counter.text(sc.find('selected').length + 1);
//                            $total.text(recalculateTotal(sc) + this.data().price);
//
//                            return 'selected';
//                        }
//                    }
//                } else if (this.status() == 'selected') { //已选中
//                    //更新数量
//                    $counter.text(sc.find('selected').length - 1);
//                    //票数小于1，隐藏票数列表
//                    if ((sc.find('selected').length - 1) <= 0) {
//                        $(".ticket-list").fadeOut();
//                    }
//                    //更新总计
//                    $total.text(recalculateTotal(sc) - this.data().price);
//
//                    //删除已预订座位
//                    $('#cart-item-' + this.settings.id).remove();
//                    //可选座
//                    return 'available';
//                } else if (this.status() == 'unavailable') { //已售出
//                    return 'unavailable';
//                } else {
//                    return this.style();
//                }
//            }
//        });
//        //已售出的座位
//        if (vipInfo != '' && vipInfo != undefined) {
//            sc.get(vipInfoArr).status('unavailable');
//        }
//        var columnNum = column + 1;
//        var oRowWidth, columnWidth = 36;
//        oRowWidth = (columnWidth + 8) * column;
//        $("#seat-map .seatCharts-row").css({"width": oRowWidth, "margin": "0 auto"});
//        var maxWidth = Math.min(Math.max(oRowWidth, 222), 528);
//        $(".seat-container").css({"width": maxWidth});
//        $(".seat-wrap").css({"width": Math.min(maxWidth + 46, 574)});
//        if ($("#selectSeatInfo").val() != undefined && $("#selectSeatInfo").val() != '') {
//            var selectSeatInfo = $("#selectSeatInfo").val();
//            var arr = new Array();
//            arr = selectSeatInfo.split(",");
//            for (var i = 0; i < arr.length; i++) {
//                $("#" + arr[i]).trigger("click");
//            }
//        }
//    }
//}

//查询可以预定的时间段场次
$(function () {
    queryEventTime();
});

function queryEventTime() {
    var formData = {eventDate: $("#date-input").val(), activityId: $("#activityId").val()};
    $.post("../frontActivity/queryCanBookEventTime.do", formData,
        function (map) { //请求成功后处理函数。
            var list = eval(map);
            var innerHtml = "";
            var firstEventTime = ""
            innerHtml += '<span class="caption" id="date-caption"></span> <select name="eventTime" id="eventTime">'
            for (var i = 0; i < list.length; i++) {
                var obj = list[i];
                innerHtml += '<option value="' + obj.eventTime + '">' + obj.eventTime + '</option>';
                if (i == 0) {
                    firstEventTime = obj.eventTime;
                    if (obj.eventEndDate!=obj.eventDate) {
                        $("#eventEndDate").val(obj.eventEndDate);
                    }
                }
            }

            innerHtml += '</select><span class="arrow" >▼</span>'
            $("#activityTimeList").html(innerHtml);
            $("#date-caption").html(firstEventTime);
            $('#eventTime')[0].selectedIndex = 0;
            $("#eventTime").get(0).value = firstEventTime;
            showSeatInfo();
        }).success(function () {
        var eventDateTime = $("#date-input").val() + " " + $("#eventTime").val();
        $("#eventDateTime").val(eventDateTime);
        $("#eventTime").change(function () {
            //切换场次的时候清空已选的座位
            $("#selected-seats").html("");
            $("#selectSeatInfo").val("");
            showSeatInfo();
        });
    });

}


//get Img
$(function () {
    var imgUrl = $("#iconUrl").attr("iconUrl");
    imgUrl = getImgUrl(imgUrl);
    $("#iconUrl").attr("src", imgUrl);
});

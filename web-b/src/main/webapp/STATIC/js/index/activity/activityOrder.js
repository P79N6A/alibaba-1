
/**
 * 预定
 */
function doBook() {

    /* 下面所有验证通过后再走这个  必须要取到正确的手机号码  2015.10.20 niubiao添加逻辑*/
    var mark = $("#mark").val();
    if(!mark){
        //绑定手机
        top.dialog({
            url: '../frontActivity/dialog.do?code='+$("#orderPhoneNo").val()+"&code="+new Date().getTime(),
            title: '验证手机',
            width: 560,
            fixed: true,
            data: $(this).attr("data-name")
        }).showModal();
        return;
    }

    if($("#orderPhoneNo").val() != undefined && $("#orderPhoneNo").val() == ''){
        removeMsg("orderPhoneNoMsg");
        appendMsg("orderPhoneNoMsg","请输入预订电话号码");
        $('#orderPhoneNo').focus();
        return;
    } else {
        removeMsg("orderPhoneNoMsg");
    }
    var reg = /^1\d{10}$/;
    if(!reg.test($("#orderPhoneNo").val())){
        removeMsg("orderPhoneNoMsg");
        appendMsg("orderPhoneNoMsg","请输入正确的手机号码!");
        $('#orderPhoneNo').focus();
        return;
    } else {
        removeMsg("orderPhoneNoMsg");
    }
    var telReg = (/^1[34578]\d{9}$/);
    if(!telReg.test($("#orderPhoneNo").val())){
        removeMsg("orderPhoneNoMsg");
        appendMsg("orderPhoneNoMsg","请输入正确的手机号码!");
        $('#orderPhoneNo').focus();
        return;
    }  else {
        removeMsg("orderPhoneNoMsg");
    }

    if($("#bookCount").val() == undefined && (document.getElementsByName("seatId") == null || document.getElementsByName("seatId").length ==0)) {
        dialogAlert("提示", "请选择座位!");
        return;
    }
    if($("#bookCount").val() != undefined && $("#bookCount").val() == ''){
        removeMsg("bookCountMsg");
        appendMsg("bookCountMsg","请输入预订数量!");
        $('#bookCount').focus();
        return;
    } else {
        removeMsg("bookCountMsg");
    }
    if($("#bookCount").val() != undefined) {
        var reg = new RegExp("^[0-9]*$");
        if(!reg.test($("#bookCount").val()) || $("#bookCount").val() <= 0){
            removeMsg("bookCountMsg");
            appendMsg("bookCountMsg","请输入正确的预订数量!");
            $('#bookCount').focus();
            return;
        } else {
            removeMsg("bookCountMsg");
        }

        var ticketSetting=$('#ticketSettings').val();
        var ticketCount=$('#ticketCountInfo').val();
        var ticketNumber=$('#ticketNumberInfo').val();
        if(ticketSetting!=undefined&&ticketSetting=='N'&&ticketCount!=undefined&&parseInt(ticketCount)>0){
            if(parseInt($("#bookCount").val())>parseInt(ticketCount)){
                removeMsg("bookCountMsg");
                appendMsg("bookCountMsg","单次最多可预定"+ticketCount +"张");
                $('#bookCount').focus();
                return;
            }
        }
    }

    if(!valCode()) {
        removeMsg("idcodeMsg");
        appendMsg("idcodeMsg","请输入正确的验证码!");
        return;
    } else {
        removeMsg("idcodeMsg");
    }
    var eventDateTime = $("#date-input").val() + " " + $("#eventTime").val();
    $("#eventDateTime").val(eventDateTime);
    var ticketNumber=$('#ticketNumberInfo').val();
    $.ajax({
        type: 'POST',
        dataType : "json",
        data: $("#bookForm").serialize(),
        url: "../frontActivity/checkFrontActivityBook.do",//请求的action路径
        error: function () {//请求失败处理函数
            alert('error');
        },
        success:function(data){ //请求成功后处理函数。
            //if(data.success == 'Y') {
                $("#seatValues").val(data.seatValues);
                 $("#bookForm").submit();
               // location.href= "../frontActivity/preSaveActivityOder.do?activityOrderId="+ data.msg + "&" + $("#bookForm").serialize();
            //} else {
            //    if (data.msg == 'activityEmpty') {
            //        dialogAlert("提示", "活动不能为空!");
            //    } else if (data.msg == 'seatEmpty') {
            //        dialogAlert("提示", "请选择座位!");
            //    } else if (data.msg == 'more') {
            //        dialogAlert("提示", "购票数不能超过5张!");
            //    }  else if (data.msg == 'login') {
            //        dialogAlert("提示", "请先登录!");
            //    } else if (data.msg == 'overtime') {
            //        dialogAlert("提示", "不在可预订时间内!");
            //    } else if (data.msg == 'overCount') {
            //        dialogAlert("提示", "剩余票数不够!");
            //    } else if (data.msg == 'errorCount') {
            //        dialogAlert("提示", "请输入正确的票数!");
            //    } else if(data.msg=='moreLimit'){
            //        dialogAlert("提示", "本场活动最多可预定"+ticketNumber+"次，你已预定"+ticketNumber+"次");
            //    }
            //    else {
            //        dialogAlert("提示", "预订失败:" + data.msg + "!");
            //    }
            //}

        }
    });
}

/**
 * 是否同意条款
 */
function acceptItem(){
    if($("#agreement").prop("checked")){
        $("#subOrder").removeAttr("style");
        $("#subOrder").prop('disabled',false);
    }else{
        $("#subOrder").css('background','#808080');
        $("#subOrder").prop('disabled',true);
    }
}


//初始化 验证码
$(function(){
    $.idcode.setCode();
    /*window.code = $.idcode;
    code.setCode();*/
});
//验证验证码  true,false
function valCode(){
    if($.idcode.validateCode()){
        return true;
    }else{
        return false;
    }
}




/*
 * 选择时间时展示对应的座位信息
 */
$(function(){
    //选择日期
    if($("#eventDateTime").val() != undefined && $("#eventDateTime").val() != '') {
        var dateInfo = $("#eventDateTime").val().split(" ");
        var eventDate = dateInfo[0];
        var eventTime = dateInfo[1];
        $("#date-input").val(eventDate);
        var index = 0;
        $("#eventTime option").each(function(){
            if($(this).text() == eventTime){
                //$("#eventTime").get(0).selectedIndex=index;
                $('#eventTime')[0].selectedIndex = index;
                $("#date-caption").html(eventTime);
            }
            index ++;
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
function pickedFunc(){
    $dp.$('date-input').value=$dp.cal.getDateStr('yyyy-MM-dd');
    $dp.$('data-week').innerHTML=$dp.cal.getDateStr('DD');
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
    var eventDateTime = $("#date-input").val() + " " + $("#eventTime").val();
    $("#eventDateTime").val(eventDateTime);
    $.post("../frontActivity/showActivitySeatInfo.do", $("#bookForm").serialize(),
        function(map){ //请求成功后处理函数。
            var data = eval(map);
            if(data.success == 'Y') {
                $("#seatInfo").val(data.seatInfo);
                $("#maintananceInfo").val(data.maintananceInfo);
                $("#vipInfo").val(data.vipInfo);
                $("#eventId").val(data.eventId);
                $("#ticketCount").html(data.ticketCount);
                $("#maxColumn").val(data.maxColumn);
                $("#seat-map").html("");
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
//查询可以预定的时间段场次
$(function () {
    queryEventTime();
});

function queryEventTime() {
    var formData = {eventDate:$("#date-input").val(),activityId:$("#activityId").val()};
    $.post("../frontActivity/queryCanBookEventTime.do", formData,
        function(map){ //请求成功后处理函数。
            var list = eval(map);
            var innerHtml = "";
            var firstEventTime = ""
            innerHtml += '<span class="caption" id="date-caption"></span> <select name="eventTime" id="eventTime">'
            for (var i = 0; i < list.length; i++) {
                var obj = list[i];
                innerHtml += '<option value="' + obj.eventTime +'">' + obj.eventTime + '</option>';
                if (i == 0) {
                    firstEventTime = obj.eventTime;
                }
            }
            innerHtml += '</select><span class="arrow" >▼</span>'
            $("#activityTimeList").html(innerHtml);
            $("#date-caption").html(firstEventTime);
            $('#eventTime')[0].selectedIndex = 0;
            $("#eventTime").get(0).value = firstEventTime;
            showSeatInfo();
        }).success( function () {
            var eventDateTime = $("#date-input").val() + " " + $("#eventTime").val();
            $("#eventDateTime").val(eventDateTime);
            $("#eventTime").change(function(){
                //切换场次的时候清空已选的座位
                $("#selected-seats").html("");
                $("#selectSeatInfo").val("");
                showSeatInfo();
            });
        });

}


//get Img
$(function() {
    var imgUrl = $("#iconUrl").attr("iconUrl");
    imgUrl= getImgUrl(imgUrl);
    $("#iconUrl").attr("src", imgUrl);
});


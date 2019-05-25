<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<head>
    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>

    <script type="text/javascript" src="${path}/STATIC/js/admin/activity/UploadActivityFile.js?version=20151230"></script>
    <%--<script type="text/javascript" src="${path}/STATIC/js/admin/activity/getActivityFile.js"></script>--%>
    <script type="text/javascript" src="${path}/STATIC/js/area.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/area-venues-admin.js?version=20151125"></script>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    <!-- dialog start -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/ckeditor/sample.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/admin/activity/editActivity.js?version=20160302"></script>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    <script type="text/javascript">

        // 日期 票务
        $(function () {
            $("#activityPrice").keyup(function(){
                $(this).val($(this).val().replace(/[^0-9.]/g,''));
            }).bind("paste",function(){  //CTR+V事件处理
                $(this).val($(this).val().replace(/[^0-9.]/g,''));
            }).css("ime-mode", "disabled"); //CSS设置输入法不可用
            //自建活动不显示在线选坐
            if ($("#createActivityCode").val() == '1' || $("#createActivityCode").val() == '2') {
                //自由入座
                $("#onlineTicket").hide();
                $("#notOnlineText").show();
                $("#notOnlineTicket").show();
                $("#onlineTicket").html("");
                $("#onlineText").val("0");
                $(this).parents(".td-fees").find(".extra").css("display", "inline-block");
                $("#setSeat").hide();
                $("#onlineSelectLabel").hide();
            }
            /*是否收费*/
            $(".form-table .td-fees").on("click", "input[type=radio]", function(){
                if($(this).val() == '2'){
                    $(this).parents(".td-fees").find(".extra").css("display", "inline-block");
                }else{
                    $(this).parents(".td-fees").find(".extra").css("display", "none");
                }
            });
            /*设置票务*/
            $(".form-table .td-online").on("click", "input[type=radio]", function(){
                if($(this).val() == "3"){
                    //自由入座
                    $("#onlineTicket").hide();
                    $("#notOnlineText").show();
                    $("#notOnlineTicket").show();
                    $("#onlineTicket").html("");
                    $("#onlineText").val("0");
                    $(this).parents(".td-fees").find(".extra").css("display", "inline-block");
                    $("#setSeat").hide();
                    $('#ticketlabel').show();
                }else if($(this).val() == "2"){
                    //在线选择
                    if('${activity.activitySalesOnline}' == 'Y'){

                        $("#setSeat").show();
                        $("#notOnlineText").val("");
                        $("#notOnlineTicket").hide();
                        $("#onlineTicket").show();
                        $("#onlineTicket").html('${activity.eventCount}');
                        $("#onlineText").val('${activity.eventCount}');
                        $(this).parents(".td-fees").find(".extra").css("display", "inline-block");
                    }else{
                        $("#setSeat").show();
                        $("#notOnlineText").val("");
                        $("#notOnlineTicket").hide();
                        $("#onlineTicket").show();
                        $("#extra").css("display", "none");
                        //$(this).parents(".td-fees").find(".extra").css("display", "inline-block");
                    }
                    $('#ticketlabel').show();
                } else if($(this).val() == "1"){
                    $("#setSeat").hide();
                    $("#onlineTicket").html("");
                    $("#notOnlineText").val("");
                    $("#onlineText").val("0");
                    $(this).parents(".td-fees").find(".extra").css("display", "none");
                    $('#ticketlabel').hide();
                }

            });

            /*单个账号订票设置*/
            $(".form-table .td-ticket").on("click", "input[type=radio]", function(){
                if($(this).val() == 'Y'){

                    $(this).parents(".td-ticket").find(".extra").css("display", "none");
                }else{
                    $(this).parents(".td-ticket").find(".extra").css("display", "inline-block");

                }
            });
            
          //获取经纬度
            $('#getMapAddressPoint').on('click', function () {
                var address =$('#activityAddress').val();
                dialog({
                    url: '${path}/activity/queryMapAddressPoint.do?address='+encodeURI(encodeURI(address)),
                    title: '获取经纬度',
                    width: 700,
                    fixed: true,
                    onclose: function () {
                        if(this.returnValue){

                            $('#activityLon').val(this.returnValue.xPoint);
                            $("#activityLat").val(this.returnValue.yPoint);

                        }
                        //dialog.focus();
                    }
                }).showModal();
                return false;
            });

        });



        seajs.config({
            alias: {
                "jquery": "jquery-1.10.2.js"
            }
        });

        seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
            window.dialog = dialog;
        });

        // 日期控件
        $(function(){
            if ('${isPayStatus}' != '1') {
                $(".start-btn").on("click", function(){
                    WdatePicker({el:'startDateHidden',dateFmt:'yyyy-MM-dd',doubleCalendar:true,minDate:'%y-%M-{%d+1}', maxDate:'#F{$dp.$D(\'endDateHidden\')}',position:{left:-224,top:8},isShowClear:false,isShowOK:true,isShowToday:false,onpicked:pickedStartFunc})
                })
                $(".end-btn").on("click", function(){
                    WdatePicker({el:'endDateHidden',dateFmt:'yyyy-MM-dd',doubleCalendar:true,minDate:'#F{$dp.$D(\'startDateHidden\')}',position:{left:-224,top:8},isShowClear:false,isShowOK:true,isShowToday:false,onpicked:pickedendFunc})
                })
            }
            var weekDay = ["星期天", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"];
            var dateStr = $("#activityStartTime").val();
            var dateStr2 = $("#activityEndTime").val();
            var myDate = new Date(Date.parse(dateStr.replace(/-/g, "/")));
            var myDate2 = new Date(Date.parse(dateStr2.replace(/-/g, "/")));
            $("#startWeek").html(weekDay[myDate.getDay()]);
            $("#endWeek").html(weekDay[myDate2.getDay()]);

        });
        seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
            window.dialog = dialog;
        });

        window.console = window.console || {log:function () {}}


        function  checkActivityTime() {
            getEventDateInfo();
            /*alert(eventStartTime+ eventEndTime);*/
            var eventStartTime = $("#eventStartTimes").val();
            var eventEndTime =  $("#eventEndTimes").val();
            var startTimeArray = eventStartTime.split(",");
            var endTimeArray = eventEndTime.split(",");
            for(var i = 0; i< startTimeArray.length ; i ++) {
                //正常判断时间的大小
                var eventStartStr = $("#activityStartTime").val() + " " + startTimeArray[i];
                var eventEndStr = $("#activityStartTime").val() + " " + endTimeArray[i];
                var eventStartDate;
                var eventEndDate;
                try {
                    eventStartDate = new Date(eventStartStr.replace(/-/g,"/"));
                    eventEndDate = new Date(eventEndStr.replace(/-/g,"/"));
                } catch (e) {
                    appendMsg("activityTimeLabel"+(i+1),"输入正确的时间格式");
                    return false;
                }
                if (eventEndDate <= eventStartDate ) {
                    removeMsg('activityTimeLabel'+(i+1));
                    appendMsg("activityTimeLabel"+(i+1),"结束时间不能小于等于开始时间");
                    $('#activityTimeLabel'+(i+1)).focus();
                    return false;
                } else {
                    removeMsg('activityTimeLabel'+(i+1));
                }
                //当下标大于1时 跟上面的结束时间进行比较
                if (i > 0) {
                    /*var preEventStartStr = $("#activityStartTime").val() + " " + startTimeArray[i - 1];*/
                    var preEventEndStr = $("#activityStartTime").val() + " " + endTimeArray[i - 1];
                    var preEventEndDate;
                    try {
                        /*preEventStartDate = new Date(preEventStartStr);*/
                        preEventEndDate = new Date(preEventEndStr.replace(/-/g,"/"));
                    } catch (e) {
                        appendMsg("activityTimeLabel"+(i+1),"输入正确的时间格式");
                        return false;
                    }
                    //当前开始时间 和上一个结束时间进行比较
                    if (eventStartDate < preEventEndDate) {
                        removeMsg('activityTimeLabel'+(i+1));
                        appendMsg("activityTimeLabel"+(i+1),"活动开始时间不能比上一场次的结束时间小");
                        $('#activityTimeLabel'+(i+1)).focus();
                        return false;
                    } else {
                        removeMsg('activityTimeLabel'+(i+1));
                    }
                }
            }
            return true;
        }


        function getEventDateInfo() {
            var tindex = 0;
            var eventStartTime = new Array();
            var eventEndTime = new Array();
            var eventStartMinuteTimes = new Array();
            var eventEndMinuteTimes = new Array();
            var eventEndHourTimes = new Array();
            $("input[name='eventStartMinuteTime']").each(function(i,o) {
                eventStartMinuteTimes.push($(o).val());
            }) ;//;document.getElementsByName("eventStartMinuteTime");
            $("input[name='eventEndMinuteTime']").each(function(i,o) {
                eventEndMinuteTimes.push($(o).val());
            })
            $("input[name='eventEndHourTime']").each(function(i,o) {
                eventEndHourTimes.push($(o).val());
            })
            /*              eventEndHourTimes =  $("input[name='eventEndMinuteTime']");//document.getElementsByName("eventEndMinuteTime");
             eventEndHourTimes=   $("input[name='eventEndHourTime']");//document.getElementsByName("eventEndHourTime");*/
            $("[name='eventStartHourTime']").each(function(){
                var sHour = $(this).val();
                var sMinute = eventStartMinuteTimes[tindex];
                var eHour = eventEndHourTimes[tindex];
                var eMinute =  eventEndMinuteTimes[tindex];
                eventStartTime.push(sHour + ":" + sMinute);
                eventEndTime.push(eHour + ":" + eMinute )
                tindex++;
            });
            $("#eventEndTimes").val(eventEndTime.join(","));
            $("#eventStartTimes").val(eventStartTime.join(","));
        }



        //弹出座位编辑框
        $(function(){
            var dialogWidth = ($(window).width() < 800) ? ($(window).width() * 0.8) : 800;
            $('.set-ticket').on('click', function () {
                if ($('#loc_venue').val() == null || $('#loc_venue').val() == '') {
                    dialogAlert('系统提示', '请先选择场馆');
                    return;
                }
                dialog({
                    url: '${path}/activity/queryVenueSeatTemplateList.do?venueId=' + $('#loc_venue').val(),
                    title: '设置座位模板',
                    width: dialogWidth,
                    fixed: false,
                    data: {
                        seatInfo: $("#seatInfo").val()
                    }, // 给 iframe 的数据
                    onclose: function () {
                        if(this.returnValue){
                            //console.log(this.returnValue);
                            $('#seatIds').val(this.returnValue.dataStr);
                            $('#validCount').val(this.returnValue.validCount);
                            $("#activityReservationCount").val(this.returnValue.validCount);
                            $("#onlineText").val(this.returnValue.validCount);
                            $("#seatInfo").val(this.returnValue.seatInfo);
                            $("#onlineTicket").html(this.returnValue.validCount);
                            $("#notOnlineText").val(this.returnValue.validCount);
                            getTotalTicketCount();
                            $("#extra").css("display", "inline");
                            removeMsg("activityReservationCountLabel");
                        }
                        //dialog.focus();
                    }
                }).showModal();
                return false;
            });
        });
    </script>
    <script type="text/javascript">
        $(function() {
            $('#loc_area').change(function() {
                // 位置字典根据区域变更
                dictLocation($("#loc_area").find("option:selected").val());
				$("#activityLocation").val("0");
            });

            var venueArea ='${activity.activityArea}';
            var venueType ='${activity.venueType}';
            if($("#createActivityCode").val()==2){	//区自建
            	venueType = "1";
        	}
            //场馆
            showVenueData(venueArea.split(",")[0],venueType,'${activity.venueId}');
            //获取活动主题
//            var venueType = $('#activityType').val();
            //获取位置
            dictLocation('${fn:substringBefore(activity.activityArea,",")}');
        });

        function updateActivity(type,showText){

            var isCutImg =$("#isCutImg").val();
            if("N"==isCutImg) {
                dialogAlert("提示","请先裁剪系统要求尺寸(750*500)的图片，再提交！",function(){
                });
                return;
            }


            getEventDateInfo();
            $("#activityState").val(type);
            var activityName=$('#activityName').val();
            var activityIconUrl = $('#activityIconUrl').val();
            var activityType=$('#activityType').val();
            var activityArea =  $("#loc_area").val()  + "," +$("#loc_area").find("option:selected").text();
            $("#activityArea").val(activityArea);
            var tagIds=$('#tagIds').val();
            var loc_venue=$('#loc_venue').val();
            var venueId=$('#venueId').val();
            var activityLinkman=$('#activityLinkman').val();
            var activityTel=$('#activityTel').val();
            var activityStartTime=$('#activityStartTime').val();
            var activityEndTime=$('#activityEndTime').val();
            var activitySite = $("#activitySite").val().trim();
            var activityAddress=$('#activityAddress').val();
            var activityLon=$('#activityLon').val();
            var activityLat=$('#activityLat').val();
            var activityPrice=$('#activityPrice').val();
            var activityIconUrl=$('#activityIconUrl').val();
            var activityIsReservation = $('input:radio[name="activityIsReservation"]:checked').val();
            var createActivityCode = $('#createActivityCode').val();
            var activitySubject = $("#activitySubject").val().trim();
            var ticketSettings = $('input:radio[name="ticketSettings"]:checked').val();
            if ($("#activityTimeDes").val() == '例如：每周三上午8:00-11:30') {
                $("#activityTimeDes").val('');
            }

          //活动名称
            if(activityName==undefined||activityName.trim()==""){
                removeMsg("activityNameLabel");
                appendMsg("activityNameLabel","活动名称为必填项!");
                $('#activityName').focus();
                $(".room-order-info .btn-loading").remove();
                return;
            }else{
                removeMsg("activityNameLabel");
                if(activityName.length>20){
                	appendMsg("activityNameLabel","活动名称只能输入20字以内!");
                    $('#activityName').focus();
                    return false;
                }
            }

            if(activityIconUrl==undefined||activityIconUrl==""){
                removeMsg("activityIconUrlLabel");
                appendMsg("activityIconUrlLabel","上传封面为必填项!");
                $('#activityIconUrl').focus();
                return;
            }else{
                removeMsg("activityIconUrlLabel");
            }

            //所属场所
            if(loc_venue!=undefined){
                $('#venueId').val(loc_venue);
                venueId=loc_venue;
            }

            if(createActivityCode!=1&&createActivityCode!=2){
            	if(venueId==undefined||venueId==""){
                    removeMsg("venueIdLabel");
                    appendMsg("venueIdLabel","请选择发布者!");
                    $('#venueId').focus();
                    $(".room-order-info .btn-loading").remove()
                    return;
                }else{
                    removeMsg("venueIdLabel");
                }
            }

            //活动类型
            if(activityType==undefined||activityType==""){
                removeMsg("activityTypeLabel");
                appendMsg("activityTypeLabel","请选择活动类型!");
                $('#activityType').focus();
                $(".room-order-info .btn-loading").remove();
                return;
            }else{
                removeMsg("activityTypeLabel");
            }

            //活动主题
            if(activitySubject==undefined||activitySubject==""){
                removeMsg("activitySubjectTipLabel");
                $("#activitySubjectTipLabel").text("请填写活动主题!")
                $('#activitySubject').focus();
                return;
            }else{
                removeMsg("activitySubjectTipLabel");
            }

            if($("#loc_area").val() !=undefined && $("#loc_area").val() != ''){
                if ($("#activityLocation").val() == undefined || $("#activityLocation").val() == '' || $("#activityLocation").val() == 0) {
                    removeMsg("activityLocationLabel");
                    appendMsg("activityLocationLabel","请选择位置!");
                    $('#activityType').focus();
                    return;
                } else {
                    removeMsg("activityLocationLabel");
                }
            }

            if(activityStartTime==undefined||activityStartTime==""){
                removeMsg("activityStartTimeLabel");
                appendMsg("activityStartTimeLabel","请选择活动开始时间!");
                $('#activityStartTime').focus();
                return;
            }else{
                removeMsg("activityStartTimeLabel");
            }
            //活动结束时间
            if(activityEndTime==undefined||activityEndTime==""){
                removeMsg("activityStartTimeLabel");
                appendMsg("activityStartTimeLabel","请选择活动结束时间!");
                $('#activityEndTime').focus();
                $(".room-order-info .btn-loading").remove();
                return;
            }else{
                removeMsg("activityStartTimeLabel");
            }

            var startTime=$("#activityStartTime").val();
             var start=new Date(startTime.replace("-", "/").replace("-", "/"));
             var endTime=$("#activityEndTime").val();
             var end=new Date(endTime.replace("-", "/").replace("-", "/"));
            if(end <start){
             appendMsg("activityStartTimeLabel","结束时间不能小于等于开始时间!");
             $('#activityEndTime').focus();
             return;
             } else {
             removeMsg("activityStartTimeLabel");
             }
            var flag = checkActivityTime();
            if (!flag) {
                return;
            }

            //活动地点
            if(activitySite==undefined||activitySite==""){
                removeMsg("activitySiteLabel");
                appendMsg("activitySiteLabel","活动地点为必填项!");
                $('#activitySite').focus();
                $(".room-order-info .btn-loading").remove();
                return;
            }else{
                removeMsg("activitySiteLabel");
            }

            //活动详细地址
            if(activityAddress==undefined||activityAddress.trim()==""||activityAddress=='输入详细地址'){
                removeMsg("activityAddressLabel");
                appendMsg("activityAddressLabel","活动详细地址为必填项!");
                $('#activityAddress').focus();
                $(".room-order-info .btn-loading").remove();
                
                return;
            }else{
                removeMsg("activityAddressLabel");
            }

            //地图坐标
            if(activityLon == undefined || activityLon.trim() =="" || activityLon == "X"){
                removeMsg("LonLabel");
                appendMsg("LonLabel","请输入地图坐标!");
                $('#activityLon').focus();
                return;
            }else{
                removeMsg("LonLabel");
            }

            if(activityLat == undefined || activityLat.trim() =="" || activityLat == "Y"){
                removeMsg("LonLabel");
                appendMsg("LonLabel","请输入地图坐标!");
                $('#activityLat').focus();
                return;
            }else{
                removeMsg("LonLabel");
            }

            //联系电话
            if(activityTel==undefined||activityTel.trim()==""){
                removeMsg("activityTelLabel");
                appendMsg("activityTelLabel","联系电话为必填项!");
                $('#activityTel').focus();
                $(".room-order-info .btn-loading").remove();
                return;
            }/*else if(!is_mobile(activityTel)){
                removeMsg("activityTelLabel");
                appendMsg("activityTelLabel","请正确填写活动电话!");
                $('#activityTel').focus();
                $(".room-order-info .btn-loading").remove();
                return;
            }*/else{
                removeMsg("activityTelLabel");
            }

            if(isNaN(activityPrice)){
                removeMsg("activityPriceLabel");
                appendMsg("activityPriceLabel","请输入正确的价格!");
                return;
            }else{
                removeMsg("activityPriceLabel");
            }

            if(activityIsReservation == 1){
                $('#activityReservationCount').val("");
            }else if(activityIsReservation == 2){
                var onlineText = $("#onlineText").val();
                if(onlineText == undefined || onlineText == "" || onlineText == 0){
                    removeMsg("activityReservationCountLabel");
                    appendMsg("activityReservationCountLabel","请设置在线选座!");
                    $('#activityReservationCount').focus();
                    return;
                }else{
                    $('#activityReservationCount').val(onlineText);
                    removeMsg("activityReservationCountLabel");
                }
            }else if(activityIsReservation == 3){
                var notOnlineText = $("#notOnlineText").val();
                if(notOnlineText == undefined || notOnlineText == "" || notOnlineText == 0){
                    removeMsg("activityReservationCountLabel");
                    appendMsg("activityReservationCountLabel","在线发售总票数必须大于零!");
                    $('#activityReservationCount').focus();
                    return;
                }else{
                    $('#activityReservationCount').val(notOnlineText);
                    removeMsg("activityReservationCountLabel");
                }
            }

            //单个账号票务设置
            if(ticketSettings!=undefined&&ticketSettings=='N'){
                var number=$('input:checkbox[name="ticketNumberCheck"]:checked').val();
                var count=$('input:checkbox[name="ticketCountCheck"]:checked').val();
                var ticketCount=$('#ticketCount').val();
                var ticketNumber=$('#ticketNumber').val();

                if(number==undefined&&count==undefined){
                    removeMsg("ticketSettingsLabel");
                    appendMsg("ticketSettingsLabel","请至少选择一个选项!");
                    return;
                }
                if(number!=undefined){
                    if(ticketNumber==undefined||ticketNumber.trim()==""){
                        removeMsg("ticketSettingsLabel");
                        appendMsg("ticketSettingsLabel","请填写限制次数!");
                        return;
                    }
                }
                if(count!=undefined){
                    if(ticketCount==undefined||ticketCount.trim()==""){
                        removeMsg("ticketSettingsLabel");
                        appendMsg("ticketSettingsLabel","请填写单次最多预定张数!");
                        return;
                    }
                    var total=  $("#totalEventCount").html();
                    if(total!=undefined&&parseInt(total)<parseInt(ticketCount)){
                        removeMsg("ticketSettingsLabel");
                        appendMsg("ticketSettingsLabel","设置的条件已超过活动发布的总票数!");
                        return;
                    }
                }

                if(number!=undefined&&count!=undefined){
                    if(ticketCount!=undefined&&parseInt(ticketCount)>0&&ticketNumber==undefined&&parseInt(ticketNumber)>0){
                        var total=  $("#totalEventCount").html();
                        if(total!=undefined&&parseInt(total)<(parseInt(ticketCount)*parseInt(ticketNumber))){
                            removeMsg("ticketSettingsLabel");
                            appendMsg("ticketSettingsLabel","设置的条件已超过活动发布的总票数!");
                            return;
                        }
                    }
                }

            }
            //富文本编辑器
            $('#activityMemo').val(CKEDITOR.instances.activityMemo.getData());
            var html = '<div class="btn-loading" id="btn-tip-loading"><h3>正在提交，请稍等...</h3><div class="img"></div></div>';
            $(this).parent().append(html);

            $.post("${path}/activity/editActivity.do", $("#activityForm").serialize(),
                    function(data) {
                        if (data!=null && data=='success') {
                            dialogAlert('系统提示', showText + '成功',function (r){
                                window.location.href="${path}/activity/activityIndex.do?activityState=${activity.activityState}";
                            });

                        } else if(data!=null && data=='failure'){
                            dialogAlert('系统提示', showText +'失败');
                            $(".room-order-info .btn-loading").remove();
                        }else if(data!=null && data=='repeat'){
                            dialogAlert('系统提示', '活动名称重复');
                            $(".room-order-info .btn-loading").remove();
                        } else if (data != null && data =='doBook'){
                            dialogAlert('系统提示', '在修改期间有人进行了订座,暂时不能修改,请刷新页面重试');
                            $(".room-order-info .btn-loading").remove();
                        }
                        $(".room-order-info .btn-loading").remove();
                    });

        }
        function callBackActivityPage(){
            window.location.href="${path}/activity/activityIndex.do?activityState=${activity.activityState}";
        }


        //监听 时间段的文本失去焦点事件
        $(function (){
            $('#free-time-set').on('blur','input',function () {
                var reg = /^[0-9]*$/;
                if(!reg.test($(this).val())){
                    $(this).val("00");
                }
                if (parseInt($(this).val()) < 10 && $(this).val().length < 2) {
                    $(this).val("0" + $(this).val());
                }
                if ($(this).attr("data-type") == "hour") {
                    if (parseInt($(this).val()) >= 24 || parseInt($(this).val()) < 0) {
                        $(this).val("00");
                    }
                }
                if ($(this).attr("data-type") == "minute") {
                    if (parseInt($(this).val()) >= 60 || parseInt($(this).val()) < 0) {
                        $(this).val("00");
                    }
                }
                checkActivityTime();
            })
        });

        function searchInitImage(){
            var imgaeInitUrl = $("#activityIconUrl").val();
            var url = getImgUrl(imgaeInitUrl);
            var html='<img src="'+url+'" target="_blank"/>';
            dialogInitImgConfirm("原图", html, function(){

            })
        }

        $(function() {
            var templId = $("#templId").val();

            $.post("../activityTemplate/queryTemplateList.do",function(data) {
                if (data != '' && data != null) {
                    var list = eval(data);
                    var ulHtml = '<li data-option="">基础模板</li>';
                    for (var i = 0; i <list.length; i++) {
                        var template = list[i];
                        ulHtml += '<li data-option="'+template.templId+'">'+ template.templName+ '</li>';
                        if(templId != '' && templId == template.templId){
                            $('#templIdDiv').html(template.templName);
                        }
                    }
                    $('#templIdUl').html(ulHtml);
                }
            }).success(function() {
                selectModel();
            });
        });
    </script>

</head>

<body >
<form action="${path}/activity/editActivity.do" id="activityForm" method="post">
    <input type="hidden" id="userCounty" name="userCounty" value="${sessionScope.user.userCounty}">
    <input type="hidden" id="activityId" name="activityId" value="${activity.activityId}">
    <input type="hidden" id="activityIsDel" name="activityIsDel" value="${activity.activityIsDel}">
    <input type="hidden" id="activityState" name="activityState" value="${activity.activityState}"/>
    <input type="hidden" id="seatIds" name="seatIds" value="${seatIds}"/>
    <input type="hidden" id="seatInfo" name="seatInfo" value="${seatInfo}"/>
    <input type="hidden" id="validCount" name="validCount" value=""/>
    <input type="hidden" id="activityArea" name="activityArea" value=""/>
    <input type="hidden" id="sessionId" value="${pageContext.session.id}"/>
    <input type="hidden" name="eventStartTimes" value="" id="eventStartTimes" />
    <input type="hidden" name="eventEndTimes" value="" id="eventEndTimes" />

    <input type="hidden" id="isCutImg" value="Y"/>
    <!--  -->
    <input type="hidden" id="createActivityCode" name="createActivityCode" value="<c:if test="${empty activity.createActivityCode}">0</c:if><c:if test="${not empty activity.createActivityCode}">${activity.createActivityCode}</c:if>"/>
    <div class="site">
        <em>您现在所在的位置：</em>活动管理 &gt; 活动编辑
    </div>
    <input type="hidden" value="${sessionScope.user.userIsManger}" id="userIsManager"/>
    <div class="site-title">活动发布</div>
    <div class="main-publish">
        <table width="100%" class="form-table">
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>活动名称：</td>

                <td class="td-input" id="activityNameLabel">
                    <input <c:if test="${isPayStatus == 1}" > readonly="readonly" </c:if> type="text" value='<c:out value="${activity.activityName}" escapeXml="true"/>' id="activityName" name="activityName" class="input-text w510" maxlength="20"/></td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>上传封面：</td>
                <td class="td-upload" id="activityIconUrlLabel">
                    <table>
                        <tr>
                            <td>
                                <input type="hidden"  name="activityIconUrl" id="activityIconUrl" value="${activity.activityIconUrl}">
                                <input type="hidden" name="uploadType" value="Img" id="uploadType"/>
                                <div class="img-box">
                                    <div  id="imgHeadPrev" class="img"> </div>
                                </div>
                                <div class="controls-box">
                                    <div class="dot" style="margin-bottom:10px; height: 20px;line-height:20px; margin-left: 112px;"><img src="/STATIC/html/images/ask.png"  alt="" style="vertical-align:middle;padding-bottom:3px;margin-right:5px;"/><a style="color:red;font-size: 12px;display:none;" href="${path}/help.do?link=" target="_blank">封面图上传失败怎么办？</a></div>
                                    <div style="height: 46px; position:relative;">
                                        <div class="controls" style="float:left;">
                                            <input type="file" name="file" id="file">
                                        </div>
                                        <input type="button" class="upload-cut-btn" onclick="searchInitImage();" value="查看原图" style="width:102px;height:48px;position:absolute;bottom:50px;left:-10px;"/>
                                        <span class="upload-tip">可上传1张图片，建议尺寸750*500像素，格式为jpg,jpeg,png,gif，大小不超过2M</span>
                                    </div>
                                    <div id="fileContainer"></div>
                                    <div id="btnContainer" style="display: none;">
                                        <a style="margin-left:335px;" href="javascript:clearQueue();" class="btn">取消</a>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>发布者：</td>
                <td class="td-select" id="venueIdLabel">
                    <input type="hidden" style="position: absolute; left: -9999px;" id="venueId" value="${activity.venueId}" name="venueId"/>
                    <c:if test="${sessionScope.user.userIsManger==2}" >
	                  	<select id="create_activity_code" style="width:142px; margin-right: 8px"><option value="2">${fn:split(activity.activityProvince, ",")[1]}</option><option value="1">市级自建活动</option></select>
	                  	<script>

                            $('#loc_category').change(function() {
                                if($(this).val()==1){

                                }
                            });

							$('#create_activity_code').change(function() {
								if($(this).val()==2){
									$("#loc_s").css("display", 'block');
									$("#createActivityCode").val("0");
                                    $("#onlineSelect").show();
								}else if($(this).val()==1){

                                    $("#onlineSelectLabel").hide();
                                    $("#notBook").trigger("click");
									$("#loc_s").css("display", 'none');
									$('#loc_area').empty();
									$('#loc_area').append('<option value="">所有区县</option>');
									loadingVenueData('loc_area');
									$('#loc_category').empty();
									$('#loc_category').append('<option value="">场馆类型</option>');
									$('#loc_category').select2("val", "");
									$('#loc_venue').empty();
									$('#loc_venue').append('<option value="">所有场馆</option>');
									$('#loc_venue').select2("val", "");
						            $("#activityArea").val("");
									$('#venueId').val("");
									$("#createActivityCode").val("1");
									dictLocation($("#loc_area").find("option:selected").val());		//位置重置
									$("#activityLocation").val("0");

								}
							})
						</script>
	                </c:if>
	                <div id="loc_s">
	                    <select id="loc_area" style="width:142px; margin-right: 8px"></select>
	                    <select id="loc_category" style="width:142px; margin-right: 8px"></select>
	                    <div id="loc_q">
	                    	<select id="loc_venue" style="width:142px; margin-right: 8px"></select>
	                    </div>
	                </div>
                    <script type="text/javascript">
                        if($("#userIsManager").val() == 4){
                            $("#loc_area").prop("disabled", true);
                            $("#loc_category").prop("disabled", true);
                            $("#loc_venue").prop("disabled", true);
                        }
                    </script>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>位置：</td>
                <td class="td-tag">
                    <input id="activityLocation" name="activityLocation" value="${activity.activityLocation}" style="position: absolute; left: -9999px;" type="hidden"/>
                    <dd id="activityLocationLabel">
                    </dd>
                    <dd>

                    </dd>
                    </dl>
                </td>
                <td>
                    <div class="dot" style="margin-left:-190px;"><img src="/STATIC/html/images/ask.png" alt="" style="vertical-align:middle;padding-bottom:3px;margin-right:5px;"/><a style="color:red;font-size: 12px;display:none;" href="${path}/help.do?link=fail2" target="_blank">没有对应的热区位置怎么办？</a></div>

                </td>

            </tr>
            <tr>
                <td width="100" class="td-title">主办方：</td>
                <td class="td-input" id="activityHostLabel">
                    <input type="text" value='<c:out value="${activity.activityHost}" escapeXml="true"/>'  id="activityHost" name="activityHost" class="input-text w210" maxlength="100"/>
                    &nbsp; &nbsp;承办单位：
                    <input type="text" value='<c:out value="${activity.activityOrganizer}" escapeXml="true"/>'  id="activityOrganizer" name="activityOrganizer" class="input-text w210" maxlength="100"/>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title">协办单位：</td>
                <td class="td-input" id="activityCoorganizerLabel">
                    <input type="text" value='<c:out value="${activity.activityCoorganizer}" escapeXml="true"/>'  id="activityCoorganizer" name="activityCoorganizer" class="input-text w210" maxlength="100"/>
                    &nbsp; &nbsp;演出单位：
                    <input type="text" value='<c:out value="${activity.activityPerformed}" escapeXml="true"/>'  id="activityPerformed" name="activityPerformed" class="input-text w210" maxlength="100"/>
                </td>
            </tr>

            <tr>
                <td width="100" class="td-title">主讲人：</td>
                <td class="td-input" id="activitySpeakerLabel"><input type="text" value='<c:out value="${activity.activitySpeaker}" escapeXml="true"/>'  id="activitySpeaker" name="activitySpeaker" class="input-text w210" maxlength="20"/></td>
            </tr>

            <tr>
                <td width="100" class="td-title"><span class="red">*</span>活动模板：</td>
                <td class="td-input search" id="templIdLabel">

                    <div class="select-box w135" style="margin-left: 0px;">
                        <input type="hidden" value="${activity.templId}" name="templId" id="templId"/>
                        <div class="select-text" data-value="" id="templIdDiv">基础模板</div>
                        <ul class="select-option" style="display: none"  id="templIdUl">
                        </ul>
                    </div>
                </td>
            </tr>

            <tr>
                <td width="100" class="td-title">友情提示：</td>
                <td class="td-input" id="activityPromptLabel"><input type="text" value='<c:out value="${activity.activityPrompt}" escapeXml="true"/>'  id="activityPrompt" name="activityPrompt" class="input-text w510" maxlength="100"/></td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>活动标签：</td>
                <td class="td-tag">
                    <%--<dl>--%>
                        <%--<dt>人群</dt>--%>
                        <%--<input id="activityCrowd" name="activityCrowd" style="position: absolute; left: -9999px;" type="hidden" value="${activity.activityCrowd}"/>--%>
                        <%--<dd id="activityCrowdLabel">--%>
                        <%--</dd>--%>
                    <%--</dl>--%>
                    <%--<dl>--%>
                        <%--<dt>心情</dt>--%>
                        <%--<input id="activityMood" name="activityMood" style="position: absolute; left: -9999px;" type="hidden" value="${activity.activityMood}"/>--%>
                        <%--<dd id="activityMoodLabel" class="labl_class">--%>
                        <%--</dd>--%>
                    <%--</dl>--%>
                    <dl>
                        <dt>类型</dt>
                        <input id="activityType" name="activityType" style="position: absolute; left: -9999px;" type="hidden" value="${activity.activityType}"/>
                        <dd id="activityTypeLabel">
                        </dd>
                    </dl>
                    <%--<dl>--%>
                        <%--<dt>主题</dt>--%>
                        <%--<input id="activityTheme" name="activityTheme"  style="position: absolute; left: -9999px;" type="hidden" value="${activity.activityTheme}"/>--%>
                        <%--<dd id="activityThemeLabel">--%>
                        <%--</dd>--%>
                    <%--</dl>--%>
<%--                    <dl>
                        <dt>位置</dt>
                        <input id="activityLocation" name="activityLocation" value="${activity.activityLocation}" style="position: absolute; left: -9999px;" type="hidden"/>
                        <dd id="activityLocationLabel">
                        </dd>
                    </dl>--%>
                </td>
            </tr>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>主题：</td>
                <td class="td-input" id="activitySubjectLabel">
                    <input type="text" id="activitySubject" name="activitySubject" value="${activity.activitySubject}" class="input-text w510" maxlength="7"/>
                    <span class="upload-tip" style="color:#ff0000" id="activitySubjectTipLabel">主题请在7个字以内</span>
                </td>
                <td>
                    <div style="margin-left:-860px;"  class="dot"><img src="/STATIC/html/images/ask.png" alt="" style="vertical-align:middle;padding-bottom:3px;margin-right:5px;"/><a style="color:red;font-size: 12px;display:none;" href="${path}/help.do?link=fail3" target="_blank">主题位置是什么？</a></div>


                </td>
            </tr>

            <input id="tagIds" name="tagIds" type="hidden"   style="position: absolute; left: -9999px;" value="${tagIds}"/>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>活动日期：</td>
                <td class="td-time" id="activityStartTimeLabel">
                        <div  class="start w340">
                            <span class="text">开始日期</span>
                            <input type="hidden" id="startDateHidden"/>
                            <c:if test="${isPayStatus != 1}"><input  type="text"  id="activityStartTime" name="activityStartTime" value="${activity.activityStartTime}"/></c:if>
                            <c:if test="${isPayStatus == 1}"><input  type="hidden"  id="activityStartTime" name="activityStartTime" value="${activity.activityStartTime}"/><span class="dateSpan gray">${activity.activityStartTime}</span></c:if>
                            <span class="week <c:if test='${isPayStatus == 1}'>gray</c:if>" id="startWeek">星期五</span>
                            <i class="data-btn start-btn"></i>
                        </div>
                        <span class="txt">至</span>
                        <div  class="end w340">
                            <span class="text">结束日期</span>
                            <input type="hidden" id="endDateHidden"/>
                            <c:if test="${isPayStatus != 1}"><input type="text" id="activityEndTime" name="activityEndTime"  value="${activity.activityEndTime}" /></c:if>
                            <c:if test="${isPayStatus == 1}"><input type="hidden" id="activityEndTime" name="activityEndTime"  value="${activity.activityEndTime}"/><span class="dateSpan gray">${activity.activityEndTime}</span></c:if>
                            <span class="week <c:if test='${isPayStatus == 1}'>gray</c:if>" id="endWeek">星期六</span>
                            <i class="data-btn end-btn" ></i>
                        </div>

                        <span class="txt des">具体描述</span>
                    <input type="text" maxlength="100" name="activityTimeDes" id="activityTimeDes" class="input-text w210" value='<c:out value="${activity.activityTimeDes}" escapeXml="true"/>'/>
                </td>
                <td><div style="float:left; margin-left: -700px;"  class="dot"><img src="/STATIC/html/images/ask.png" alt="" style="vertical-align:middle;padding-bottom:3px;margin-right:5px;"/><a style="color:red;font-size: 12px;display:none;" href="${path}/help.do?link=fail4" target="_blank">为什么日期选择不成功？</a></div>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>活动时间：</td>
                <td class="td-input">
                    <div id="free-time-set">
                        <div id="put-ticket-list" style="width: 800px;">
                            <c:if test="${not empty activityEventTimes}" >
                            <c:forEach items="${activityEventTimes}"  var="activityEventTime" varStatus="varStatus">
                                <c:set value="${ fn:split(activityEventTime.eventTime, '-')[0]}" var="startTime" />
                                <c:set value="${ fn:split(activityEventTime.eventTime, '-')[1]}" var="endTime" />
                                    <div class="ticket-item"  id="activityTimeLabel${varStatus.index+1}">
                                        <input onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" type="text"  data-type="hour" id="startHourTime${varStatus.index+1}"  name="eventStartHourTime" maxlength="2"  <c:if test="${isPayStatus == 1}" > readonly="readonly" </c:if> class="input-text w64" value="${fn:split(startTime, ':')[0]}"/><em>：</em>
                                        <input onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" type="text"  data-type="minute" id="startMinuteTime${varStatus.index+1}" name="eventStartMinuteTime" maxlength="2" <c:if test="${isPayStatus == 1}" > readonly="readonly" </c:if>   class="input-text w64" value="${fn:split(startTime, ':')[1]}"/>
                                        <span class="zhi">至</span>
                                        <input onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" type="text"  data-type="hour" id="endHourTime${varStatus.index+1}"  maxlength="2" <c:if test="${isPayStatus == 1}" > readonly="readonly" </c:if>  name="eventEndHourTime" class="input-text w64" value="${fn:split(endTime, ':')[0]}"/><em>：</em>
                                        <input onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" type="text"  data-type="minute" id="endMinuteTime${varStatus.index+1}"  maxlength="2" <c:if test="${isPayStatus == 1}" >  readonly="readonly" </c:if>  name="eventEndMinuteTime" class="input-text w64" value="${fn:split(endTime, ':')[1]}"/>
                                        <c:if test="${varStatus.index > 0}" ><a class="timeico jianhao"></a></c:if> <c:if test="${varStatus.index == 0}" ><a href="javascript:void(0)" class="timeico tianjia"></a></c:if>
                                    </div>
                            </c:forEach>
                            </c:if>
                            <c:if test="${empty activityEventTimes}" >
                                <div class="ticket-item"  id="activityTimeLabel1">
                                    <input onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" type="text"  data-type="hour" id="startHourTime1"  name="eventStartHourTime" maxlength="2"  <c:if test="${isPayStatus == 1}" > readonly="readonly" </c:if> class="input-text w64" value="00"/><em>：</em>
                                    <input onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" type="text"  data-type="minute" id="startMinuteTime1" name="eventStartMinuteTime" maxlength="2" <c:if test="${isPayStatus == 1}" > readonly="readonly" </c:if>   class="input-text w64" value="00"/>
                                    <span class="zhi">至</span>
                                    <input onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" type="text"  data-type="hour" id="endHourTime1"  maxlength="2" <c:if test="${isPayStatus == 1}" > readonly="readonly" </c:if>  name="eventEndHourTime" class="input-text w64" value="00"/><em>：</em>
                                    <input onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" type="text"  data-type="minute" id="endMinuteTime1"  maxlength="2" <c:if test="${isPayStatus == 1}" >  readonly="readonly" </c:if>  name="eventEndMinuteTime" class="input-text w64" value="00"/>
                                    <a href="javascript:void(0)" class="timeico tianjia"></a>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </td>
            </tr>

            <tr>
                <td width="100" class="td-title"><span class="red">*</span>活动地点：</td>
                <td class="td-input" id="activitySiteLabel">
                    <input type="text" id="activitySite" name="activitySite" value="<c:out value="${activity.activitySite}" escapeXml="true"/>" class="input-text w510"/>
                </td>
            </tr>

            <tr>
                <td width="100" class="td-title"><span class="red">*</span>活动地址：</td>
                <td class="td-input" id="activityAddressLabel">
                    <input type="text" id="activityAddress" value="<c:out value="${activity.activityAddress}" escapeXml="true"/>" name="activityAddress" data-val="输入详细地址" class="input-text w510"/>
                </td>
            </tr>

            <tr>
                <td width="100" class="td-title"><span class="red">*</span>地图坐标：</td>
                <td class="td-input td-coordinate" id="LonLabel">
                    <input type="text" value="${activity.activityLon}" data-val="" id="activityLon" name="activityLon" class="input-text w120" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" readonly="readonly"/>
                    <span class="txt">X</span>
                    <input type="text" value="${activity.activityLat}" data-val="" id="activityLat" name="activityLat" class="input-text w120" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" readonly="readonly"/>
                    <span class="txt">Y</span>
                	<input type="button" class="upload-btn" id="getMapAddressPoint" value="查询坐标"/>
                </td>
                <td>
                    <div style="float:left; margin-left: -1000px;"  class="dot"><img src="/STATIC/html/images/ask.png" alt="" style="vertical-align:middle;padding-bottom:3px;margin-right:5px;"/><a style="color:red;font-size: 12px;display:none;" href="${path}/help.do?link=fail5" target="_blank">如何添加地图坐标？</a></div>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>活动电话：</td>
                <td class="td-input" id="activityTelLabel">
                    <input type="text" class="input-text w210" id="activityTel" name="activityTel" value="<c:out value="${activity.activityTel}" escapeXml="true"/>" maxlength="50"/>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>是否收费：</td>
                <td class="td-input td-fees" id="activityPriceLabel">
                    <label><input type="radio" <c:if test="${isPayStatus == 1}"> disabled</c:if> <c:if test="${activity.activityIsFree ==1}"> checked="checked" </c:if> name="activityIsFree" value="1" /><em>免费</em></label>
                    <label><input type="radio" <c:if test="${isPayStatus == 1}"> disabled</c:if> <c:if test="${activity.activityIsFree ==2}"> checked="checked" </c:if>  id="isFree" name="activityIsFree" value="2" /><em>收费</em></label>
                    <div class="extra">
                        <input type="text" id="activityPrice" name="activityPrice" value="${activity.activityPrice}" maxlength="10" class="input-text w60"/>￥
                        <em></em>
                        收费说明：<input type="text" id="priceDescribe" name="priceDescribe" value="${activity.priceDescribe}" maxlength="100"  class="input-text w120" style="width:140px;"/>
                    </div>
                </td>
            </tr>
            <c:if test="${activity.activityIsFree ==2}">
                <script>

                    $(function() {
                        $('#isFree').trigger("click");
                        //showSeatTemplate("Y");
                    });
                </script>

            </c:if>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>在线售票：</td>
                <td class="td-input td-fees td-online" id="activityReservationCountLabel">
                    <label>
                        <input type="radio" id="notBook"  <c:if test="${isPayStatus == 1}"> disabled</c:if> <c:if test="${activity.activityIsReservation == 1}"> checked="checked" </c:if>  name="activityIsReservation" value="1"/><em>不可预订</em>
                    </label>
                    <label>
                        <input type="radio" <c:if test="${isPayStatus == 1}"> disabled</c:if> <c:if test="${activity.activitySalesOnline =='N' and activity.activityIsReservation == 2}"> checked="checked" </c:if>  id="freeSelect"  name="activityIsReservation" value="3"/><em>自由入座</em>
                    </label>
                    <label id="onlineSelectLabel">
                        <input type="radio" <c:if test="${isPayStatus == 1}"> disabled</c:if>  id="onlineSelect"  <c:if test="${activity.activitySalesOnline =='Y'}"> checked="checked" </c:if> name="activityIsReservation" value="2"/><em>在线选座</em>
                    </label>
                    <c:if test="${activitySeat == 'Y'}" >
                        <input type="button" id="setSeat" class="set-ticket"  value="重新设置座位">
                    </c:if>
                    <c:if test="${activitySeat == 'N'}" >
                        <input type="button" class="set-ticket" id="setSeat"  value="设置座位">
                    </c:if>
                    <div class="extra" id="extra">
                        <em>每场次售票数</em>
                            <span id="notOnlineTicket" style="display:inline-block;">
                                <input type="hidden" name="activityReservationCount" id="activityReservationCount" value="${activity.eventCount}"/>
                                <input <c:if test="${isPayStatus == 1}"> readonly="readonly" </c:if> type="text" id="notOnlineText" class="input-text w120" onkeyup="this.value=this.value.replace(/\D/g,'')"  value="${activity.eventCount}"  <c:if test="${activity.activitySalesOnline =='N' and activity.activityIsReservation == 2}"></c:if> />
                                <input type="hidden" id="onlineText" <c:if test="${activity.activitySalesOnline =='Y'}"> value="${activity.eventCount}" </c:if>/>
                            </span>
                            <span id="onlineTicket" style="display:inline-block;"><c:choose><c:when test="${not empty activity.eventCount}">${activity.eventCount}</c:when><c:otherwise>0</c:otherwise></c:choose></span>
                            <em >张&nbsp;,总售票数:</em><span  id="totalEventCount" style="display:inline-block;"></span><em> 张</em>
                    </div>
                </td>
                <td>
                    <div style="float:left; margin-left: -840px;" class="dot"><img src="/STATIC/html/images/ask.png" alt="" style="vertical-align:middle;padding-bottom:3px;margin-right:5px;"/><a style="color:red;font-size: 12px; display: none;" href="${path}/help.do?link=fail6" target="_blank">如何选择售票类型？</a></div>
                </td>
            </tr>
            <c:if test="${activity.activitySalesOnline =='N' and activity.activityIsReservation == 2}">
                <script>
                    $(function() {
                        $('#freeSelect').trigger("click");
                        //showSeatTemplate("Y");
                        $("#setSeat").hide();
                        $("#notOnlineText").show();
                        $("#onlineTicket").hide();
                        $("#onlineTicket").html('${activity.eventCount}');
                        $("#onlineText").val('${activity.eventCount}');
                        $("#freeSelect").parents(".td-fees").find(".extra").css("display", "inline-block");
                    });
                </script>
            </c:if>
            <c:if test="${activitySeat == 'Y'}">
                <script>
                    $(function() {
                        $('#onlineSelect').trigger("click");
                        $("#onlineTicket").show();
                        $("#setSeat").show();
                        $("#notOnlineText").hide();
                        $("#notOnlineText").val(${activity.eventCount});
                        $("#onlineText").val("${activity.eventCount}");
                        $("#onlineText").html('${activity.eventCount}');
                        $("#freeSelect").parents(".td-fees").find(".extra").css("display", "inline-block");
                    });
                </script>
            </c:if>
            </tr>

            <%--<tr>--%>
                <%--<td width="100" class="td-title">视频地址：</td>--%>
                <%--<td class="td-input" id="activityVideoURLLabel">--%>
                    <%--<input type="text" value='<c:out value="${activity.activityVideoURL}" escapeXml="true"/>'  id="activityVideoURL" name="activityVideoURL" data-val="" class="input-text w510"/>--%>
                <%--</td>--%>
            <%--</tr>--%>
            <tr id="ticketlabel" style="display: none;">
                <td width="130" class="td-title"><span class="red">*</span>单个账号预定设置：</td>
                <td class="td-input td-ticket" id="ticketSettingsLabel">
                    <label><input type="radio"
                    <c:if test="${activity.ticketSettings == 'Y'}">  checked="checked" </c:if>
                                  name="ticketSettings" value="Y" /> <em>默认</em>
                        <span>(每场最多订5张)</span>
                    </label>
                    <%if(activityTicketSettings){%>
                    <br>
                    <label><input type="radio"  name="ticketSettings"
                            <c:if test="${activity.ticketSettings == 'N'}">  checked="checked" </c:if>
                                  value="N" /><em>自定义</em></label>
                    <br>
                    <div class="extra"  <c:if test="${activity.ticketSettings == 'N'}"> style="display: block;" </c:if>
                            <c:if test="${activity.ticketSettings == 'Y'}"> style="display: none;" </c:if>
                            >
                        <input type="checkbox" id="ticketNumberCheck" name="ticketNumberCheck" <c:if test="${not empty activity.ticketNumber}">checked="checked" </c:if>>
                        限制<input type="text" id="ticketNumber" name="ticketNumber"  value="${activity.ticketNumber}" maxlength="8" class="input-text w60" onkeyup="this.value=this.value.replace(/\D/g,'')"/>次
                        <em></em>
                        <input type="checkbox" id="ticketCountCheck" name="ticketCountCheck" <c:if test="${not empty activity.ticketCount}">checked="checked" </c:if> >

                        单次最多预订 <input type="text" id="ticketCount" name="ticketCount" value="${activity.ticketCount}" maxlength="8"  class="input-text w60"  onkeyup="this.value=this.value.replace(/\D/g,'')"/>张
                    </div>
                    <%}%>
                </td>
            </tr>

            <tr>
                <td width="100" class="td-title">购票须知：</td>
                <td class="td-input">
                    <div class="editor-box">
                        <textarea name="activityNotice" rows="4" class="textareaBox"  maxlength="300" style="width: 500px;resize: none">${activity.activityNotice}</textarea>
                    </div>
                </td>
            </tr>
            <tr class="">
                <td width="100" class="td-title">活动描述：</td>
                <td class="td-content">
                    <div class="editor-box">
                        <textarea name="activityMemo" id="activityMemo">
                           ${activity.activityMemo}
                        </textarea>
                    </div>
                </td>
            </tr>



            <tr>
                <td width="100" class="td-title"></td>
                <td class="td-input td-upload">
                    <input type="hidden" name="uploadType" value="Attach" id="uploadType2"/>
                    <input type="hidden" name="activityAttachment" id="activityAttachment"/>
                    <div class="controls" style="float: left;">
                        <input type="button" id="file2" class="upload-btn"/>
                    </div>
                    <span class="upload-tip">附件格式支持.doc\.docx\.xls\.xlsx\.txt\.pdf，不支持压缩文件和.exe等可运行文件</span>
                    <div class="controls">
                        <div id="fileContainer2">
                            <div id="SWFUpload_1_0" class="uploadify-queue-item">
                                <div class="cancel"></div>
                                <c:forEach items="${fileUrlList}" var="list">
                                    <span class="fileName">${list}</span><br/>
                                </c:forEach>
                                <div class="uploadify-progress">
                                    <div class="uploadify-progress-bar" style="width: 100%;"><!--Progress Bar--></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="btnContainer2" style="display: none;">
                        <a style="margin-left:335px;" href="javascript:clearQueue2();" class="btn">取消</a>
                    </div>
                    <script>
                    var fileUrlList = '${fileUrlList}';
                    if(fileUrlList.length>0){
                    	$("#btnContainer2").show();
                    }
                    </script>
                </td>
            </tr>


            <tr>
                <td width="100" class="td-title"></td>
                <td class="td-btn">
                    <div class="room-order-info info2" style="position: relative;">
                    <c:if test="${not empty activity.activityState&&activity.activityState==6}">
                        <input type="button"  class="btn-publish" onclick="updateActivity(6,'保存修改')" value="保存修改"/>
                        <input type="button"   class="btn-save" onclick="javascript:history.go(-1);" value="返回"/>
                    </c:if>
                    <c:if test="${not empty activity.activityState&&activity.activityState!=6}">
                        <input type="button"   class="btn-save" onclick="updateActivity('${activity.activityState}','保存修改')" value="保存修改"/>

                        <%if(activityPublishDraftButton){%>
                            <c:if test="${sessionScope.user.userIsManger<=3}" >
                                <input type="button"  class="btn-publish" onclick="updateActivity(6,'发布')" value="发布"/>
                            </c:if>
                            <c:if test="${sessionScope.user.userIsManger == 4}" >
                                <input class="btn-publish" type="button" onclick="updateActivity(6,'发布')" value="发布"/>
                            </c:if>
                        <%}%>

                    </c:if>
                    </div>
                </td>
            </tr>
        </table>
    </div>
    <script type="text/javascript">
        $(function () {
            //var i = 1;
            if ("${isPayStatus}" != "1") {

                var mindex = 1;
            $("#free-time-set").on("click", ".timeico", function(){
                var $this = $(this);
                var $ticketList = $("#put-ticket-list");
                var $ticketItem = $ticketList.find(".ticket-item");
                if($this.hasClass("tianjia")) {
                    $ticketList.find(".ticket-item:gt(0)").find(".tianjia").hide();
                    mindex++;
                    var html =' <div class="ticket-item" id="activityTimeLabel' + mindex +'"><input onkeyup="if(isNaN(value))execCommand(\'undo\')" data-type="hour" onafterpaste="if(isNaN(value))execCommand(\'undo\')" type="text" id="startHourTime' +  mindex + '" maxlength="2" <c:if test="${isPayStatus == 1}" > readonly="readonly" </c:if>   name="eventStartHourTime" class="input-text w64" value="00"/><em>：</em>' +
                            '<input onkeyup="if(isNaN(value))execCommand(\'undo\')" onafterpaste="if(isNaN(value))execCommand(\'undo\')" type="text" data-type="minute" id="startMinuteTime' +  mindex + '" name="eventStartMinuteTime" maxlength="2" <c:if test="${isPayStatus == 1}" > readonly="readonly" </c:if>  class="input-text w64" value="00"/>'+
                            '<span class="zhi"> 至 </span>'+
                            '<input onkeyup="if(isNaN(value))execCommand(\'undo\')" onafterpaste="if(isNaN(value))execCommand(\'undo\')"  type="text" data-type="hour" id="endHourTime' + mindex +'" name="eventEndHourTime" maxlength="2" <c:if test="${isPayStatus == 1}" > readonly="readonly" </c:if>  class="input-text w64" value="00"/><em>：</em>' +
                            ' <input onkeyup="if(isNaN(value))execCommand(\'undo\')" onafterpaste="if(isNaN(value))execCommand(\'undo\')" type="text" data-type="minute" id="endMinuteTime' + mindex +'" name="eventEndMinuteTime" maxlength="2" <c:if test="${isPayStatus == 1}" > readonly="readonly" </c:if>  class="input-text w64" value="00"/>' +
                            '<a class="timeico jianhao"></a></div>';
                    $ticketList.append(html);
                    getTotalTicketCount();
                }else if($this.hasClass("jianhao")){
                    if(mindex == $ticketItem.length){
                        $ticketItem.eq(mindex-2).find(".add-time-btn").show();
                    }
                    mindex--;
                    $ticketItem.eq($ticketItem.length - 1).remove();
                    getTotalTicketCount();
                }
            });
            }

            //监听 时间段的文本失去焦点事件
            $('#free-time-set').on('blur','input',function () {
                var reg = /^[0-9]*$/;
                if(!reg.test($(this).val())){
                    $(this).val("00");
                }
                if (parseInt($(this).val()) < 10 && $(this).val().length < 2) {
                    $(this).val("0" + $(this).val());
                }
                if ($(this).attr("data-type") == "hour") {
                    if (parseInt($(this).val()) >= 24 || parseInt($(this).val()) < 0) {
                        $(this).val("00");
                    }
                }
                if ($(this).attr("data-type") == "minute") {
                    if (parseInt($(this).val()) >= 60 || parseInt($(this).val()) < 0) {
                        $(this).val("00");
                    }
                }
                checkActivityTime();
            })

        });
    </script>
</form>
<script type="text/javascript">
    $(".dot").hover(function(){
        $(this).children("a").toggle();
    })
</script>
</body>
</html>
/**
 * Created by yujinbing on 2015/12/14.
 */

$(function() {
    fixPlaceholder();
    /*tag类型*/
    //时间段 加  减
    var mindex = 1;
    $("#free-time-set").on("click", ".timeico", function(){
        var $this = $(this);
        var $ticketList = $("#put-ticket-list");
        var $ticketItem = $ticketList.find(".ticket-item");
        if($this.hasClass("add-btn")) {
            $ticketList.find(".ticket-item:gt(0)").find(".add").hide();
            mindex++;
            var html =' <div class="ticket-item" id="activityTimeLabel' + mindex +'">' +
                '<input type="text" name="eventStartHourTime" id="startHourTime' +  mindex + '" class="input-text" value="00"/><em>:</em>' +
                ' <input type="text" name="eventStartMinuteTime" id="startMinuteTime' +  mindex + '"  class="input-text" value="00"/><span class="zhi">至</span>' +
                '<input type="text" name="eventEndHourTime" id="endHourTime' +  mindex + '" class="input-text" value="00"/><em>:</em>' +
                '<input type="text" name="eventEndMinuteTime" id="endMinuteTime' +  mindex + '" class="input-text" value="00"/><span class="timeico del-btn"></span> </div>';
            $ticketList.append(html);
        }else if($this.hasClass("del-btn")){
            if(mindex == $ticketItem.length){
                $ticketItem.eq(mindex-2).find(".add-time-btn").show();
            }
            mindex--;
            $ticketItem.eq($ticketItem.length - 1).remove();
        }
    });
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


    //获取经纬度
    $('#getMapAddressPoint').on('click', function () {
        var address =$('#activityAddress').val();
        dialog({
            url: '../activity/queryMapAddressPoint.do?address='+encodeURI(encodeURI(address)),
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

$(function () {
//类型标签
    $.post("../tag/getChildTagByType.do?code=ACTIVITY_TYPE", function(data) {
        var list = eval(data);
        var tagHtml = '';
        var tagIds = $("#activityType").val();
        var ids = '';
        if (tagIds.length > 0) {
            ids = tagIds.substring(0, tagIds.length - 1).split(",");
        }
        for (var i = 0; i < list.length; i++) {
            var obj = list[i];
            var tagId = obj.tagId;
            var tagName = obj.tagName;
            var result = false;
            if (ids != '') {
                for (var j = 0; j <ids.length; j++) {
                    if (list[i].tagId == ids[j]) {
                        result = true;
                        break;
                    }
                }
            }
            var cl = '';
            if (result) {
                cl = 'class="cur"';
            }
            tagHtml += '<a '+ cl + 'onclick="setActivityTag(\''
            + tagId + '\',\'activityType\')">' + tagName
            + '</a>';
        }
        $("#activityTypeLabel").html(tagHtml);
        tagSelect("activityTypeLabel");
    });
});

/* tag标签选择 */
function tagSelect(id) {
    $('#'+id).find('a').click(function() {
        if ($(this).hasClass('cur')) {
            $(this).removeClass('cur');
        } else {
            $(this).addClass('cur');
        }
    });
}

//保存前台用户发布的活动
function savePublicActivity(state) {
    var showText = "提交";
    if (state == 8) {
        showText= "保存草稿箱"
    }
    var isCutImg =$("#isCutImg").val();
    if("N"==isCutImg) {
        dialogAlert("提示","请先裁剪系统要求尺寸(750*500)的图片，再提交！",function(){
        });
        return;
    }


    checkActivityTime();
    if(!checkActivityData()) {
        return;
    }
    $("#activityProvince").val($("#loc_province").val() + "," + $("#loc_province").find("option:selected").text());
    $("#activityCity").val($("#loc_city").val() + "," +  $("#loc_city").find("option:selected").text());
    $("#activityArea").val($("#loc_town").val() + "," + $("#loc_town").find("option:selected").text());
    $("#activityState").val(state);
    $.post("../userActivity/editPublicActivity.do",$("#publicActivityForm").serialize(),
        function (data) {
            if (data == 'success') {
                dialogAlert('系统提示', showText + "成功",function() {
                    location.href = "../userActivity/prePublicActivityList.do";
                });
            } else {
                dialogAlert('系统提示', showText + "失败:" + data,function() {

                });
            }
        });
}


//选择关键字标签时，赋值
function setActivityTag(value,id) {
    var tagIds = $("#"+id).val();
    if (tagIds != '') {
        var ids = tagIds.substring(0, tagIds.length - 1).split(",");
        var data = '', r = true;
        for (var i = 0; i < ids.length; i++) {
            if (ids[i] == value) {
                r = false;
            } else {
                data = data + ids[i] + ',';
            }
        }
        if (r) {
            data += value + ',';
        }
        $("#"+id).val(data);
    } else {
        $("#"+id).val(value + ",");
    }
}


//比较时间
function  checkActivityTime() {
    if ($("#activityStartTime").val() == '' || $("#activityStartTime").val() == undefined) {
        removeMsg("activityStartTimeLabel");
        appendMsg("activityStartTimeLabel","请先选择活动开始时间!");
    } else {
        removeMsg("activityStartTimeLabel");
    }
    getEventDateInfo();
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

//得到时间
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

$(document).ready(function(){
    getPicture();
    uploadImage();
    getTotalTicketCount();
});



function checkActivityData(){
    var activityName =  $("#activityName").val();
    var activityIconUrl =  $("#activityIconUrl").val();
    var activityIconUrl =  $("#activityIconUrl").val();
    var loc_town = $("#loc_town").val();
    var activityAddress = $("#activityAddress").val();
    var activityTel = $("#activityTel").val();
    var activityLon =  $("#activityLon").val();
    var activityLat =  $("#activityLat").val();
    $('#activityMemo').val(CKEDITOR.instances.activityMemo.getData());
    var activityMemo = $("#activityMemo").val();
    var activityType = $("#activityType").val();
    var activityStartTime = $("#activityStartTime").val();
    var activityEndTime = $("#activityEndTime").val();
    //活动名称
    if(activityName==undefined||activityName.trim()==""){
        removeMsg("activityNameLabel");
        appendMsg("activityNameLabel","活动名称为必填项!");
        $('#activityName').focus();
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

    if(loc_town==undefined||loc_town==""){

        removeMsg("loc_townLabel");
        appendMsg("loc_townLabel","请选择所属区县!");
        $('#loc_town').focus();

        return;
    }else{
        removeMsg("loc_townLabel");
    }



    //活动详细地址
    if(activityAddress==undefined||activityAddress.trim()==""||activityAddress=='输入详细地址'){
        removeMsg("activityAddressLabel");
        appendMsg("activityAddressLabel","活动详细地址为必填项!");
        $('#activityAddress').focus();

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

    //活动类型
    if(activityType==undefined||activityType==""){
        removeMsg("activityTypeLabel");
        appendMsg("activityTypeLabel","请选择活动类型!");
        $('#activityType').focus();
        return;
    }else{
        removeMsg("activityTypeLabel");
    }

    //开始时间
    if(activityStartTime==undefined||activityStartTime.trim()==""){
        removeMsg("activityStartTimeLabel");
        appendMsg("activityStartTimeLabel","活动开始时间为必填项!");
        $('#activityStartTime').focus();
        return;
    }else{
        removeMsg("activityStartTimeLabel");
    }

    //结束时间
    if(activityEndTime==undefined||activityEndTime.trim()==""){
        removeMsg("activityStartTimeLabel");
        appendMsg("activityStartTimeLabel","活动结束时间为必填项!");
        $('#activityEndTime').focus();
        return;
    }else{
        removeMsg("activityStartTimeLabel");
    }

    if (!checkActivityTime()) {
        return false;
    }

    //联系电话
    if(activityTel==undefined||activityTel.trim()==""){
        removeMsg("activityTelLabel");
        appendMsg("activityTelLabel","联系电话为必填项!");
        $('#activityTel').focus();
        return;
    }else{
        removeMsg("activityTelLabel");
    }
    var isMobile = /^([0-9]|-)*$/;
    if(!isMobile.test(activityTel)){
        removeMsg("activityTelLabel");
        appendMsg("activityTelLabel","请输入正确的联系电话!");
        $('#activityTel').focus();
        return;
    }else{
        removeMsg("activityTelLabel");
    }
    if(activityMemo==undefined||activityMemo.trim()==""){
        removeMsg("activityMemoLabel");
        appendMsg("activityMemoLabel","活动描述为必填项!");
        $('#activityMemo').focus();
        return;
    }else{
        removeMsg("activityMemoLabel");
    }
    return true;

}

function showCount(type) {
    if (type == 2) {
        $("#showCount").show();
    } else {
        $("#showCount").hide();
    }
}

function getPicture(){
    var imgUrl = $("#activityIconUrl").val();
    if(imgUrl!=""){
        imgUrl = getImgUrl(imgUrl);
        imgUrl = getIndexImgUrl(imgUrl,"_300_300");
        $("#imgHeadPrev").attr("src",imgUrl);
    }
}


//计算日期相隔的天数
function getDateDiff(startDate, endDate){
    var startTime = new Date(Date.parse(startDate.replace(/-/g,   "/"))).getTime();
    var endTime = new Date(Date.parse(endDate.replace(/-/g,   "/"))).getTime();
    var dates = Math.abs((startTime - endTime))/(1000*60*60*24);
    return dates + 1;
}


//计算总票数
//得到售票的总数量
function getTotalTicketCount() {
    if ($("#activityStartTime").val() != '' && $("#activityEndTime").val() != '') {
        //相隔时间段
        var dayCount  = getDateDiff($("#activityStartTime").val(),$("#activityEndTime").val());
        //每天的场次数量
        var $ticketList = $("#put-ticket-list");
        var $ticketItem = $ticketList.find(".ticket-item");
        var eventCount = $ticketItem.length;
        //每个场次的放票数量
        var ticketCount = $("#eventCount").val();
        var totalCount = eventCount*ticketCount*dayCount;
        $("#totalEventCount").html("总票数:"+ totalCount);
    }
}


function pickedStartFunc(){
    getTotalTicketCount();
}
function pickedendFunc(){
    getTotalTicketCount();
}
// 日期控件
$(function(){
	$(".start-btn").on("click", function(){
        WdatePicker({el:'startDateHidden',dateFmt:'yyyy-MM-dd',doubleCalendar:true,minDate:'%y-%M-{%d}',maxDate:'#F{$dp.$D(\'endDateHidden\')}',position:{left:-224,top:8},isShowClear:false,isShowOK:true,isShowToday:false,onpicked:pickedStartFunc})
    })
    $(".end-btn").on("click", function(){
        WdatePicker({el:'endDateHidden',dateFmt:'yyyy-MM-dd',doubleCalendar:true,minDate:'#F{$dp.$D(\'startDateHidden\')}',position:{left:-224,top:8},isShowClear:false,isShowOK:true,isShowToday:false,onpicked:pickedendFunc})
    })
    
    var weekDay = ["星期天", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"];
    var dateStr = $("#activityStartTime").val();
    var dateStr2 = $("#activityEndTime").val();
    var myDate = new Date(Date.parse(dateStr.replace(/-/g, "/")));
    var myDate2 = new Date(Date.parse(dateStr2.replace(/-/g, "/")));
    $("#startWeek").html(weekDay[myDate.getDay()]);
    $("#endWeek").html(weekDay[myDate2.getDay()]);

});

function pickedStartFunc(){
    $dp.$('activityStartTime').value=$dp.cal.getDateStr('yyyy-MM-dd');
    $dp.$('startWeek').innerHTML=$dp.cal.getDateStr('DD');
}
function pickedendFunc(){
    $dp.$('activityEndTime').value=$dp.cal.getDateStr('yyyy-MM-dd');
    $dp.$('endWeek').innerHTML=$dp.cal.getDateStr('DD');
}

$(function() {
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
            tagHtml += '<a id="'+ tagId +'"' + cl + 'onclick="setActivityTag(\''
            + tagId + '\',\'activityType\')">' + tagName
            + '</a>';
        }
        $("#activityTypeLabel").html(tagHtml);
        tagSelect("activityTypeLabel");
    });
});

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
            if(ids.length<3) {
                data += value + ',';
            }else{
                dialogAlert("系统提示","最多选择三个标签！",function(){
                    $("#"+value).removeClass("cur");
                });
            }
        }
        $("#"+id).val(data);
    } else {
        $("#"+id).val(value + ",");
    }
}

function tagSelect(id) {
    /* tag标签选择 */
    $('#'+id).find('a').click(function() {
        if ($(this).hasClass('cur')) {
            $(this).removeClass('cur');
        } else {
            $(this).addClass('cur');
        }
    });
}

$(function () {
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

function  checkActivityTime() {
    if ($("#activityStartTime").val() == '' || $("#activityStartTime").val() == undefined) {
        removeMsg("activityStartTimeLabel");
        appendMsg("activityStartTimeLabel","请先选择活动开始时间!");
    } else {
        removeMsg("activityStartTimeLabel");
    }
    getEventDateInfo();
    var eventStartTime = $("#eventStartTime").val();
    var eventEndTime =  $("#eventEndTime").val();
    //正常判断时间的大小
    var eventStartStr = $("#activityStartTime").val() + " " + eventStartTime;
    var eventEndStr = $("#activityEndTime").val() + " " + eventEndTime;
    var eventStartDate;
    var eventEndDate;
    try {
        eventStartDate = new Date(eventStartStr.replace(/-/g,"/"));
        eventEndDate = new Date(eventEndStr.replace(/-/g,"/"));
    } catch (e) {
        appendMsg("activityTimeLabel1","输入正确的时间格式");
        return false;
    }
    if (eventEndDate <= eventStartDate ) {
        removeMsg('activityTimeLabel1');
        appendMsg("activityTimeLabel1","结束时间不能小于等于开始时间");
        $('#activityTimeLabel1').focus();
        return false;
    } else {
        removeMsg('activityTimeLabel1');
    }
    return true;
}

//时间段赋值
function getEventDateInfo() {
    var sHour = $("input[name='eventStartHourTime']").val();
    var eHour = $("input[name='eventEndHourTime']").val();
    var sMinute = $("input[name='eventStartMinuteTime']").val();
    var eMinute = $("input[name='eventEndMinuteTime']").val();
    
    $("#eventStartTime").val(sHour + ":" + sMinute);
    $("#eventEndTime").val(eHour + ":" + eMinute);
}

//保存信息
function updateActivity(){
    //验证
    var activityName=$('#activityName').val();
    var activitySubject = $("#activitySubject").val();
    var activityIconUrl = $("#activityIconUrl").val();
    var isCutImg =$("#isCutImg").val();
    var activityUrl = $("#activityUrl").val();
    var activityType=$('#activityType').val();
    var activityStartTime=$('#activityStartTime').val();
    var activityEndTime=$('#activityEndTime').val();
    var activityAddress = $("#activityAddress").val();
    
    if ($("#activityTimeDes").val() == '例如：每周三上午8:00-11:30') {
        $("#activityTimeDes").val('');
    }

    //活动名称
    if(activityName==undefined||activityName.trim()==""){
        removeMsg("activityNameLabel");
        appendMsg("activityNameLabel","活动标题为必填项!");
        $('#activityName').focus();
        return;
    }else{
        removeMsg("activityNameLabel");
        if(activityName.length>13){
            appendMsg("activityNameLabel","活动标题只能输入13字以内!");
            $('#activityName').focus();
            return false;
        }
    }
    
    //活动主题
    if(activitySubject==undefined||activitySubject.trim()==""){
        removeMsg("activitySubjectLabel");
        appendMsg("activitySubjectLabel","活动主题为必填!");
        $('#activitySubject').focus();
        return;
    }else{
        removeMsg("activitySubjectLabel");
        if(activitySubject.length>7){
            appendMsg("activitySubjectLabel","活动主题只能输入7字以内!");
            $('#activitySubject').focus();
            return false;
        }
    }

    //活动图片
    if(activityIconUrl==undefined||activityIconUrl==""){
        removeMsg("activityIconUrlLabel");
        appendMsg("activityIconUrlLabel","上传封面为必填项!");
        $('#activityIconUrl').focus();
        return;
    }else{
        removeMsg("activityIconUrlLabel");
    }
    
    if("N"==isCutImg) {
        dialogAlert("提示","请先裁剪系统要求尺寸(750*500)的图片，再提交！",function(){
        });
        return;
    }
    
    //活动Url
    //if(activityUrl==undefined||activityUrl.trim()==""){
    //    removeMsg("activityUrlLabel");
    //    appendMsg("activityUrlLabel","活动URL为必填!");
    //    $('#activityUrl').focus();
    //    return;
    //}
    //
    if(activityUrl!=undefined&&activityUrl.trim().length>0) {
        removeMsg("activityUrlLabel");
        if(activityUrl.indexOf("http") == -1){
            appendMsg("activityUrlLabel","活动URL必须以http开头!");
            $('#activityUrl').focus();
            return false;
        }
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

    //活动开始时间
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
        return;
    }else{
        removeMsg("activityStartTimeLabel");
    }

    var flag = checkActivityTime();
    if (!flag) {
        return;
    }

    //活动地点
    if(activityAddress == undefined||activityAddress ==""){
        removeMsg("activityAddressLabel");
        appendMsg("activityAddressLabel","活动地点为必填项!");
        $('#activityAddress').focus();
        return;
    }else{
        removeMsg("activityAddressLabel");
    }

    //保存活动信息
    $.post("../activityEditorial/editActivityEditorial.do", $("#activityEditorialForm").serialize(),
        function(data) {
            if (data!=null&&data=='success') {
                dialogAlert('系统提示', "保存成功!",function (r){
                	window.location.href="../activityEditorial/activityEditorialIndex.do?activityState=" + $("#activityState").val();
                });

            } else if(data!=null && data=='failure'){
                dialogAlert('系统提示', '保存失败');
            }else if(data!=null && data=='repeat'){
                dialogAlert('系统提示', '活动名称重复');
            }
     	}
    );
}

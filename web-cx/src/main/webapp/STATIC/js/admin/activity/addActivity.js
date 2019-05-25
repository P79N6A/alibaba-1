//是否显示座位
function seatSeat() {

    if ($("#onlineSeat").attr("checked")) {
        $("#setSeat").show();
    } else {
        $("#setSeat").hide();
    }
}

$(function () {
    $("#setSeat").hide();
    /*是否收费*/
    $(".form-table .td-fees").on("click", "input[type=radio]", function () {
        if ($(this).val() == "2") {
            $(this).parents(".td-fees").find(".extra").css("display", "inline-block");
        } else {
            $(this).parents(".td-fees").find(".extra").css("display", "none");
        }
    });
    /*单个账号订票设置*/
    $(".form-table .td-ticket").on("click", "input[type=radio]", function () {
        if ($(this).val() == 'Y') {

            $(this).parents(".td-ticket").find(".extra").css("display", "none");
        } else {
            $(this).parents(".td-ticket").find(".extra").css("display", "inline-block");

        }
    });

    /*设置票务*/
    $(".form-table .td-online").on("click", "input[type=radio]", function () {
        removeMsg("activityReservationCountLabel");
        if ($(this).val() == "3") {
            $("#setSeat").hide();
            $("#reservationSpan").show();
            $("#notOnlineTicket").show();
            $("#onlineTicket").hide();
            $("#onlineText").val("");
            $(this).parents(".td-fees").find(".extra").css("display", "inline-block");
            $('#ticketlabel').show();
        } else if ($(this).val() == "2") {
            $(this).parents(".td-fees").find(".extra").css("display", "inline-block");
            $("#reservationSpan").hide();
            $("#notOnlineText").val("");
            $("#setSeat").show();
            $('#ticketlabel').show();
        } else if ($(this).val() == "1") {
            $("#setSeat").hide();
            $("#notOnlineText").val("");
            $("#onlineText").val("");
            $(this).parents(".td-fees").find(".extra").css("display", "none");
            $('#ticketlabel').hide();
        }
    });
});


//字典位置变化的js
function dictLocation(code) {
    // 位置字典
    $.post("../sysdict/queryChildSysDictByDictCode.do", {dictCode: code}, function (data) {
        var list = eval(data);
        var dictHtml = '';
        var otherHtml = '';
        for (var i = 0; i < list.length; i++) {
            var obj = list[i];
            var dictId = obj.dictId;
            var dictName = obj.dictName;
            if (dictName == '其他') {
                otherHtml = '<a onclick="setActivityDict(\''
                    + dictId + '\',\'activityLocation\')">' + dictName
                    + '</a>';
                continue;
            }
            dictHtml += '<a onclick="setActivityDict(\''
                + dictId + '\',\'activityLocation\')">' + dictName
                + '</a>';
        }
        $("#activityLocationLabel").html(dictHtml + otherHtml);
        tagSelectDict("activityLocationLabel");
    });
}
//点击选择区域 触发
function setActivityDict(value, id) {
    $("#" + id).val(value);
    $('#' + id).find('a').removeClass('cur');
}


//标签
$(function () {

    //主题标签
    $.post("../tag/getChildTagByType.do?code=ACTIVITY_THEME", function (data) {
        var list = eval(data);
        var tagHtml = '';
        for (var i = 0; i < list.length; i++) {
            var obj = list[i];
            var tagId = obj.tagId;
            var tagName = obj.tagName;
            var cl = '';
            cl = 'class="cur"';
            tagHtml += '<a class="" onclick="setActivityTag(\''
                + tagId + '\',\'activityTheme\')">' + tagName
                + '</a>';
        }
        $("#activityThemeLabel").html(tagHtml);
        tagSelect("activityThemeLabel");
    });
//类型标签
    $.post("../tag/getChildTagByType.do?code=ACTIVITY_TYPE", function (data) {
        var list = eval(data);
        var tagHtml = '';
        for (var i = 0; i < list.length; i++) {
            var obj = list[i];
            var tagId = obj.tagId;
            var tagName = obj.tagName;
            var cl = '';
            cl = 'class="cur"';
            tagHtml += '<a id="' + tagId + '" class="" onclick="setActivityTag(\''
                + tagId + '\',\'activityType\')">' + tagName
                + '</a>';
        }
        $("#activityTypeLabel").html(tagHtml);
        tagSelect("activityTypeLabel");
    });


    $('#loc_area').change(function () {
        // 位置字典根据区域变更
        dictLocation($("#loc_area").find("option:selected").val());
        $("#activityLocation").val("0");
    });

});

//富文本编辑器
window.onload = function () {
    var editor = CKEDITOR.replace('activityMemo');
}


$(function () {
    //获取活动主题
    var venueType = $('#activityType').val();
    $.post("../sysdict/queryCode.do", {'dictCode': 'ACTIVITY_TYPE'}, function (data) {
        if (data != '' && data != null) {
            var list = eval(data);
            var ulHtml = '';
            for (var i = 0; i < list.length; i++) {
                var dict = list[i];
                ulHtml += '<li data-option="' + dict.dictId + '">' + dict.dictName + '</li>';
                if (venueType != '' && dict.dictId == venueType) {
                    $('#activityTypeDiv').html(dict.dictName);
                }
            }
            $('#activityUl').html(ulHtml);
        }
    }).success(function () {
        //selectModel();
    });
});


//选择关键字标签时，赋值
function setActivityTag(value, id) {
    var tagIds = $("#" + id).val();
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
            if (ids.length < 3) {
                data += value + ',';
            } else {
                dialogAlert("系统提示", "最多选择三个标签！", function () {
                    $("#" + value).removeClass("cur");
                });
            }
        }
        $("#" + id).val(data);
    } else {
        $("#" + id).val(value + ",");
    }
}


function tagSelectDict(id) {
    /* tag标签选择 */

    $('#' + id).find('a').click(function () {
        $('#' + id).find('a').removeClass('cur');
        $(this).addClass('cur');
    });
}


function tagSelect(id) {
    /* tag标签选择 */
    $('#' + id).find('a').click(function () {
        if ($(this).hasClass('cur')) {
            $(this).removeClass('cur');
        } else {
            $(this).addClass('cur');
        }
    });
}

//          //选择关键字标签时，赋值
function setTag(id) {
    var tagIds = $("#tagIds").val();
    if (tagIds != '') {
        var ids = tagIds.substring(0, tagIds.length - 1).split(",");
        var data = '', r = true;
        for (var i = 0; i < ids.length; i++) {
            if (ids[i] == id) {
                r = false;
            } else {
                data = data + ids[i] + ',';
            }
        }
        if (r) {
            data += id + ',';
        }
        $("#tagIds").val(data);
    } else {
        $("#tagIds").val(id + ",");
    }
}

//监听 时间段的文本失去焦点事件
$(function () {
    $('#free-time-set').on('blur', 'input', function () {
        var reg = /^[0-9]*$/;
        if (!reg.test($(this).val())) {
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

function checkActivityTime() {
    if ($("#activityStartTime").val() == '' || $("#activityStartTime").val() == undefined) {
        removeMsg("activityStartTimeLabel");
        appendMsg("activityStartTimeLabel", "请先选择活动开始时间!");
    } else {
        removeMsg("activityStartTimeLabel");
    }
    getEventDateInfo();
    var eventStartTime = $("#eventStartTimes").val();
    var eventEndTime = $("#eventEndTimes").val();
    var startTimeArray = eventStartTime.split(",");
    var endTimeArray = eventEndTime.split(",");
    for (var i = 0; i < startTimeArray.length; i++) {
        //正常判断时间的大小
        var eventStartStr = $("#activityStartTime").val() + " " + startTimeArray[i];
        var eventEndStr = $("#activityStartTime").val() + " " + endTimeArray[i];
        var eventStartDate;
        var eventEndDate;
        try {
            eventStartDate = new Date(eventStartStr.replace(/-/g, "/"));
            eventEndDate = new Date(eventEndStr.replace(/-/g, "/"));
        } catch (e) {
            appendMsg("activityTimeLabel" + (i + 1), "输入正确的时间格式");
            return false;
        }
        if (eventEndDate <= eventStartDate) {
            removeMsg('activityTimeLabel' + (i + 1));
            appendMsg("activityTimeLabel" + (i + 1), "结束时间不能小于等于开始时间");
            $('#activityTimeLabel' + (i + 1)).focus();
            return false;
        } else {
            removeMsg('activityTimeLabel' + (i + 1));
        }
        //当下标大于1时 跟上面的结束时间进行比较
        if (i > 0) {
            /*var preEventStartStr = $("#activityStartTime").val() + " " + startTimeArray[i - 1];*/
            var preEventEndStr = $("#activityStartTime").val() + " " + endTimeArray[i - 1];
            var preEventEndDate;
            try {
                /*preEventStartDate = new Date(preEventStartStr);*/
                preEventEndDate = new Date(preEventEndStr.replace(/-/g, "/"));
            } catch (e) {
                appendMsg("activityTimeLabel" + (i + 1), "输入正确的时间格式");
                return false;
            }
            //当前开始时间 和上一个结束时间进行比较
            if (eventStartDate < preEventEndDate) {
                removeMsg('activityTimeLabel' + (i + 1));
                appendMsg("activityTimeLabel" + (i + 1), "活动开始时间不能比上一场次的结束时间小");
                $('#activityTimeLabel' + (i + 1)).focus();
                return false;
            } else {
                removeMsg('activityTimeLabel' + (i + 1));
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
    $("input[name='eventStartMinuteTime']").each(function (i, o) {
        eventStartMinuteTimes.push($(o).val());
    });//;document.getElementsByName("eventStartMinuteTime");
    $("input[name='eventEndMinuteTime']").each(function (i, o) {
        eventEndMinuteTimes.push($(o).val());
    })
    $("input[name='eventEndHourTime']").each(function (i, o) {
        eventEndHourTimes.push($(o).val());
    })
    /*              eventEndHourTimes =  $("input[name='eventEndMinuteTime']");//document.getElementsByName("eventEndMinuteTime");
     eventEndHourTimes=   $("input[name='eventEndHourTime']");//document.getElementsByName("eventEndHourTime");*/
    $("[name='eventStartHourTime']").each(function () {
        var sHour = $(this).val();
        var sMinute = eventStartMinuteTimes[tindex];
        var eHour = eventEndHourTimes[tindex];
        var eMinute = eventEndMinuteTimes[tindex];
        eventStartTime.push(sHour + ":" + sMinute);
        eventEndTime.push(eHour + ":" + eMinute)
        tindex++;
    });
    $("#eventEndTimes").val(eventEndTime.join(","));
    $("#eventStartTimes").val(eventStartTime.join(","));
}

//保存座位信息
function saveActivity(type) {


    var isCutImg = $("#isCutImg").val();
    if ("N" == isCutImg) {
        dialogAlert("提示", "请先裁剪系统要求尺寸(750*500)的图片，再提交！", function () {
        });
        return;
    }


    getEventDateInfo();
    /* checkActivityTime();*/


    $("#activityState").val(type);
    //验证
    var activityName = $('#activityName').val();
    var activityIconUrl = $("#activityIconUrl").val();
    var activityType = $('#activityType').val();
    var activityArea = $("#loc_area").val() + "," + $("#loc_area").find("option:selected").text();
    $("#activityArea").val(activityArea);
    var tagIds = $('#tagIds').val();
    var loc_venue = $('#loc_venue').val();
    var venueId = $('#venueId').val();
    var activityLinkman = $('#activityLinkman').val();
    var activityTel = $('#activityTel').val();
    var activityStartTime = $('#activityStartTime').val();
    var activityEndTime = $('#activityEndTime').val();
    var activitySite = $("#activitySite").val().trim();
    var activityAddress = $('#activityAddress').val();
    var activityLon = $('#activityLon').val();
    var activityLat = $('#activityLat').val();
    var activityPrice = $('#activityPrice').val();
    var activityIconUrl = $('#activityIconUrl').val();
    var activityIsReservation = $('input:radio[name="activityIsReservation"]:checked').val();
    var createActivityCode = $('#createActivityCode').val();
    var activitySubject = $("#activitySubject").val();
    var ticketSettings = $('input:radio[name="ticketSettings"]:checked').val();

    if ($("#activityTimeDes").val() == '例如：每周三上午8:00-11:30') {
        $("#activityTimeDes").val('');
    }

    //活动名称
    if (activityName == undefined || activityName.trim() == "") {
        removeMsg("activityNameLabel");
        appendMsg("activityNameLabel", "活动名称为必填项!");
        $('#activityName').focus();

        return;
    } else {
        removeMsg("activityNameLabel");
        if (activityName.length > 20) {
            appendMsg("activityNameLabel", "活动名称只能输入20字以内!");
            $('#activityName').focus();
            return false;
        }
    }

    if (activityIconUrl == undefined || activityIconUrl == "") {
        removeMsg("activityIconUrlLabel");
        appendMsg("activityIconUrlLabel", "上传封面为必填项!");
        $('#activityIconUrl').focus();
        return;
    } else {
        removeMsg("activityIconUrlLabel");
    }

    //所属场所
    if (loc_venue != undefined) {

        $('#venueId').val(loc_venue);
        venueId = loc_venue;
    }

    if (createActivityCode != 1 && createActivityCode != 2) {
        if (venueId == undefined || venueId == "") {

            removeMsg("venueIdLabel");
            appendMsg("venueIdLabel", "请选择发布者!");
            $('#venueId').focus();

            return;
        } else {
            removeMsg("venueIdLabel");
        }
    }

    //活动类型
    if (activityType == undefined || activityType == "") {
        removeMsg("activityTypeLabel");
        appendMsg("activityTypeLabel", "请选择活动类型!");
        $('#activityType').focus();
        return;
    } else {
        removeMsg("activityTypeLabel");
    }

    //活动主题
    if (activitySubject == undefined || activitySubject.trim() == "") {
        removeMsg("activitySubjectTipLabel");
        appendMsg("activitySubjectTipLabel", "请填写活动主题!");
        $('#activitySubject').focus();
        return;
    } else {
        removeMsg("activitySubjectTipLabel");
    }

    if ($("#loc_area").val() != undefined && $("#loc_area").val() != '') {
        if ($("#activityLocation").val() == undefined || $("#activityLocation").val() == '' || $("#activityLocation").val() == 0) {
            removeMsg("activityLocationLabel");
            appendMsg("activityLocationLabel", "请选择位置!");
            $('#activityType').focus();
            return;
        } else {
            removeMsg("activityLocationLabel");
        }
    }

    if (activityStartTime == undefined || activityStartTime == "") {
        removeMsg("activityStartTimeLabel");
        appendMsg("activityStartTimeLabel", "请选择活动开始时间!");
        $('#activityStartTime').focus();
        return;
    } else {
        removeMsg("activityStartTimeLabel");
    }
    //活动结束时间
    if (activityEndTime == undefined || activityEndTime == "") {
        removeMsg("activityStartTimeLabel");
        appendMsg("activityStartTimeLabel", "请选择活动结束时间!");
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
    if (activitySite == undefined || activitySite == "") {
        removeMsg("activitySiteLabel");
        appendMsg("activitySiteLabel", "活动地点为必填项!");
        $('#activitySite').focus();
        $(".room-order-info .btn-loading").remove();
        return;
    } else {
        removeMsg("activitySiteLabel");
    }

    //活动详细地址
    if (activityAddress == undefined || activityAddress.trim() == "" || activityAddress == '输入详细地址') {
        removeMsg("activityAddressLabel");
        appendMsg("activityAddressLabel", "活动详细地址为必填项!");
        $('#activityAddress').focus();

        return;
    } else {
        removeMsg("activityAddressLabel");
    }


    //地图坐标
    if (activityLon == undefined || activityLon.trim() == "" || activityLon == "X") {
        removeMsg("LonLabel");
        appendMsg("LonLabel", "请输入地图坐标!");
        $('#activityLon').focus();
        return;
    } else {
        removeMsg("LonLabel");
    }

    if (activityLat == undefined || activityLat.trim() == "" || activityLat == "Y") {
        removeMsg("LonLabel");
        appendMsg("LonLabel", "请输入地图坐标!");
        $('#activityLat').focus();
        return;
    } else {
        removeMsg("LonLabel");
    }

    //联系电话
    if (activityTel == undefined || activityTel.trim() == "") {
        removeMsg("activityTelLabel");
        appendMsg("activityTelLabel", "联系电话为必填项!");
        $('#activityTel').focus();
        return;
    }/*else if(!is_mobile(activityTel)){
     removeMsg("activityTelLabel");
     appendMsg("activityTelLabel","请正确填写活动电话!");
     $('#activityTel').focus();
     return;
     }*/ else {
        removeMsg("activityTelLabel");
    }
    if (isNaN(activityPrice)) {
        removeMsg("activityPriceLabel");
        appendMsg("activityPriceLabel", "请输入正确的价格!");
        return;
    } else {
        removeMsg("activityPriceLabel");
    }

    if (activityIsReservation == 1) {
        $('#activityReservationCount').val("");
    } else if (activityIsReservation == 2) {
        var onlineText = $("#onlineText").val();
        if (onlineText == undefined || onlineText == "" || onlineText == 0) {
            removeMsg("activityReservationCountLabel");
            appendMsg("activityReservationCountLabel", "请设置在线选座!");
            $('#activityReservationCount').focus();
            return;
        } else {
            $('#activityReservationCount').val(onlineText);
            removeMsg("activityReservationCountLabel");
        }
    } else if (activityIsReservation == 3) {
        var notOnlineText = $("#notOnlineText").val();
        if (notOnlineText == undefined || notOnlineText == "" || notOnlineText == 0) {
            removeMsg("activityReservationCountLabel");
            appendMsg("activityReservationCountLabel", "在线发售总票数必须大于零!");
            $('#activityReservationCount').focus();
            return;
        } else {
            $('#activityReservationCount').val(notOnlineText);
            removeMsg("activityReservationCountLabel");
        }
    }
    //单个账号票务设置
    if (ticketSettings != undefined && ticketSettings == 'N') {
        var number = $('input:checkbox[name="ticketNumberCheck"]:checked').val();
        var count = $('input:checkbox[name="ticketCountCheck"]:checked').val();
        var ticketCount = $('#ticketCount').val();
        var ticketNumber = $('#ticketNumber').val();

        if (number == undefined && count == undefined) {
            removeMsg("ticketSettingsLabel");
            appendMsg("ticketSettingsLabel", "请至少选择一个选项!");
            return;
        }

        if (number != undefined) {
            if (ticketNumber == undefined || ticketNumber.trim() == "") {
                removeMsg("ticketSettingsLabel");
                appendMsg("ticketSettingsLabel", "请填写限制次数!");
                return;
            }
        }
        if (count != undefined) {
            if (ticketCount == undefined || ticketCount.trim() == "") {
                removeMsg("ticketSettingsLabel");
                appendMsg("ticketSettingsLabel", "请填写单次最多预定张数!");
                return;
            }
            var total = $("#totalEventCount").html();
            if (total != undefined && parseInt(total) < parseInt(ticketCount)) {
                removeMsg("ticketSettingsLabel");
                appendMsg("ticketSettingsLabel", "设置的条件已超过活动发布的总票数!");
                return;
            }
        }
        if (number != undefined && count != undefined) {
            if (ticketCount != undefined && parseInt(ticketCount) > 0 && ticketNumber == undefined && parseInt(ticketNumber) > 0) {
                var total = $("#totalEventCount").html();
                if (total != undefined && parseInt(total) < (parseInt(ticketCount) * parseInt(ticketNumber))) {
                    removeMsg("ticketSettingsLabel");
                    appendMsg("ticketSettingsLabel", "设置的条件已超过活动发布的总票数!");
                    return;
                }
            }
        }


    }
    var showText = "发布成功!";
    if (type == 1) {
        showText = "保存成功!";
    }

    //富文本编辑器
    $('#activityMemo').val(CKEDITOR.instances.activityMemo.getData());
    //保存活动信息
    $.post("../activity/addActivity.do", $("#activityForm").serialize(),
        function (data) {
            $(this).attr("disabled", false);
            if (data != null && data == 'success') {
                dialogAlert('系统提示', showText, function (r) {
                    //启动服务监听
                    $.post("../frontActivity/saveActivityOder.do", null, function (rsdata) {
                        window.location.href = "../activity/activityIndex.do?activityState=" + $("#activityState").val();
                    });
                });

            } else if (data != null && data == 'failure') {
                dialogAlert('系统提示', '保存失败');
            } else if (data != null && data == 'repeat') {
                dialogAlert('系统提示', '活动名称重复');
            }
        });
}


//时间段 加  减
$(function () {

    var mindex = 1;
    $("#free-time-set").on("click", ".timeico", function () {
        var $this = $(this);
        var $ticketList = $("#put-ticket-list");
        var $ticketItem = $ticketList.find(".ticket-item");
        if ($this.hasClass("tianjia")) {
            $ticketList.find(".ticket-item:gt(0)").find(".tianjia").hide();
            mindex++;
            var html = ' <div class="ticket-item" id="activityTimeLabel' + mindex + '">' +
                '<input onkeyup="if(isNaN(value))execCommand(\'undo\')" onafterpaste="if(isNaN(value))execCommand(\'undo\')" data-type="hour" type="text" id="startHourTime' + mindex + '" name="eventStartHourTime"  maxlength="2" class="input-text w64" value="00"/><em>：</em> <input onkeyup="if(isNaN(value))execCommand(\'undo\')" onafterpaste="if(isNaN(value))execCommand(\'undo\')" data-type="minute" type="text" id="startMinuteTime' + mindex + '" name="eventStartMinuteTime" maxlength="2" class="input-text w64" value="00"/><span class="zhi">至</span><input onkeyup="if(isNaN(value))execCommand(\'undo\')" onafterpaste="if(isNaN(value))execCommand(\'undo\')" data-type="hour" type="text" id="endHourTime' + mindex + '" name="eventEndHourTime" maxlength="2" class="input-text w64" value="00"/><em>：</em><input onkeyup="if(isNaN(value))execCommand(\'undo\')" onafterpaste="if(isNaN(value))execCommand(\'undo\')" data-type="minute" type="text" id="endMinuteTime' + mindex + '" name="eventEndMinuteTime" maxlength="2" class="input-text w64" value="00"/><span class="timeico jianhao"></span> </div>';
            $ticketList.append(html);
            getTotalTicketCount();
        } else if ($this.hasClass("jianhao")) {
            if (mindex == $ticketItem.length) {
                $ticketItem.eq(mindex - 2).find(".add-time-btn").show();
            }
            mindex--;
            $ticketItem.eq($ticketItem.length - 1).remove();
            getTotalTicketCount();
        }
    });


    //监听 时间段的文本失去焦点事件
    $('#free-time-set').on('blur', 'input', function () {
        var reg = /^[0-9]*$/;
        if (!reg.test($(this).val())) {
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


//** 日期控件
$(function () {
    $(".start-btn").on("click", function () {
        WdatePicker({
            el: 'startDateHidden',
            dateFmt: 'yyyy-MM-dd',
            doubleCalendar: true,
            minDate: '%y-%M-{%d}',
            maxDate: '#F{$dp.$D(\'endDateHidden\')}',
            position: {left: -224, top: 8},
            isShowClear: false,
            isShowOK: true,
            isShowToday: false,
            onpicked: pickedStartFunc
        })
    })
    $(".end-btn").on("click", function () {
        WdatePicker({
            el: 'endDateHidden',
            dateFmt: 'yyyy-MM-dd',
            doubleCalendar: true,
            minDate: '#F{$dp.$D(\'startDateHidden\')}',
            position: {left: -224, top: 8},
            isShowClear: false,
            isShowOK: true,
            isShowToday: false,
            onpicked: pickedendFunc
        })
    })
});
function pickedStartFunc() {
    $dp.$('activityStartTime').value = $dp.cal.getDateStr('yyyy-MM-dd');
    $dp.$('startWeek').innerHTML = $dp.cal.getDateStr('DD');
    getTotalTicketCount();
}
function pickedendFunc() {
    $dp.$('activityEndTime').value = $dp.cal.getDateStr('yyyy-MM-dd');
    $dp.$('endWeek').innerHTML = $dp.cal.getDateStr('DD');
    getTotalTicketCount();
}


//计算日期相隔的天数
function getDateDiff(startDate, endDate) {
    var startTime = new Date(Date.parse(startDate.replace(/-/g, "/"))).getTime();
    var endTime = new Date(Date.parse(endDate.replace(/-/g, "/"))).getTime();
    var dates = Math.abs((startTime - endTime)) / (1000 * 60 * 60 * 24);
    return dates + 1;

}

//监听 时间段的文本失去焦点事件
$(function () {
    $('#notOnlineTicket').on('blur', 'input', function () {
        getTotalTicketCount();
    })
});

//得到售票的总数量
function getTotalTicketCount() {
    if ($("#activityStartTime").val() != '' && $("#activityEndTime").val() != '' && $("#notOnlineText").val() != '') {
        //相隔时间段
        var dayCount = getDateDiff($("#activityStartTime").val(), $("#activityEndTime").val());
        //每天的场次数量
        var $ticketList = $("#put-ticket-list");
        var $ticketItem = $ticketList.find(".ticket-item");
        var eventCount = $ticketItem.length;
        //每个场次的放票数量
        var ticketCount = $("#notOnlineText").val();
        $("#totalEventCount").html(eventCount * ticketCount * dayCount);
    }
}
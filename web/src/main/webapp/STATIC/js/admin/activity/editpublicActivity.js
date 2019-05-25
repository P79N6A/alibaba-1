

function pickedStartFunc(){
    $dp.$('activityStartTime').value=$dp.cal.getDateStr('yyyy-MM-dd');
    $dp.$('startWeek').innerHTML=$dp.cal.getDateStr('DD');
    getTotalTicketCount();
}
function pickedendFunc(){
    $dp.$('activityEndTime').value=$dp.cal.getDateStr('yyyy-MM-dd');
    $dp.$('endWeek').innerHTML=$dp.cal.getDateStr('DD');
    getTotalTicketCount();
}


//富文本编辑器
$(function() {
    var editor = CKEDITOR.replace('activityMemo');
    //img
    var imgUrl = $("#activityIconUrl").val();
    imgUrl = getImgUrl(imgUrl);
    $("#activityImg").attr('src',imgUrl);
});



// 标签
$(function() {
    $("#create_activity_code").select2();
    //载入createActivityCode自建活动编码
    if($("#createActivityCode").val()==1){		//市自建
        $("#create_activity_code").select2("val", "1");
        $("#loc_s").css("display", 'none');
    }else if($("#createActivityCode").val()==2){	//区自建
        $('#create_activity_code').select2("val", "2");
        $('#loc_category').val("1");
        $("#loc_q").css("display", 'none');
    }else{
        if ($('#create_activity_code').val() != undefined) {
            $('#create_activity_code')[0].selectedIndex = 0;
        }
        $('#loc_category').val("1");
    }

    //主题标签
    $.post("../tag/getChildTagByType.do?code=ACTIVITY_THEME", function(data) {
        var list = eval(data);
        var tagHtml = '';
        var tagIds = $("#activityTheme").val();
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
            tagHtml += '<a disable="true"' + cl + 'onclick="setActivityTag(\''
            + tagId + '\',\'activityTheme\')">' + tagName
            + '</a>';
        }
        $("#activityThemeLabel").html(tagHtml);
        tagSelect("activityThemeLabel");
    });


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
            tagHtml += '<a ' + cl + 'onclick="setActivityTag(\''
            + tagId + '\',\'activityType\')">' + tagName
            + '</a>';
        }
        $("#activityTypeLabel").html(tagHtml);
        tagSelect("activityTypeLabel");
    });

    //人群标签
/*    $.post("../tag/getChildTagByType.do?code=ACTIVITY_CROWD", function(data) {
        var list = eval(data);
        var tagHtml = '';
        var tagIds = $("#activityCrowd").val();
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
            tagHtml += '<a ' + cl +'onclick="setActivityTag(\''
            + tagId + '\',\'activityCrowd\')">' + tagName
            + '</a>';
        }
        $("#activityCrowdLabel").html(tagHtml);
        tagSelect("activityCrowdLabel");
    });

    //勾选选中心情的标签
    $.post("../tag/getChildTagByType.do?code=ACTIVITY_MOOD", function(data) {
        var list = eval(data);
        var tagHtml = '';
        var tagIds = $("#activityMood").val();
        var ids = '';
        if (tagIds.length > 0) {
            ids = tagIds.substring(0, tagIds.length - 1).split(",");
        }
        for (var i = 0; i < list.length; i++) {
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
            tagHtml += '<a href="#" ' + cl + ' onclick="setActivityTag(\''
            + list[i].tagId + '\',\'activityMood\')">' + list[i].tagName
            + '</a>';
        }
        $(".labl_class").html(tagHtml);
        tagSelect("activityMoodLabel");
    });*/

    //var venueArea ='${activity.venueArea}';

});

function setActivityDict(value,id){
    $("#"+id).val(value);
    $('#'+id).find('a').removeClass('cur');
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

/* tag标签选择 */
function tagSelectDict(id) {
    $('#'+id).find('a').click(function() {
        $('#'+id).find('a').removeClass('cur');
        $(this).addClass('cur');
    });
}


function dictLocation(code){
    // 位置字典
    $.post("../sysdict/queryChildSysDictByDictCode.do",{dictCode:code}, function(data) {
        var list = eval(data);
        var dictHtml = '';
        var otherHtml = '';
        var tid = $("#activityLocation").val();
        for (var i = 0; i < list.length; i++) {
            var obj = list[i];
            var dictId = obj.dictId;
            var dictName = obj.dictName;
            var result = false;
            if (tid == dictId) {
                result = true;
            }
            var cl = '';
            if (result) {
                cl = 'class="cur"';
            }

            if(dictName == '其他'){
                otherHtml = '<a '+cl+' onclick="setActivityDict(\''
                + dictId + '\',\'activityLocation\')">' + dictName
                + '</a>';
                continue;
            }
            dictHtml += '<a '+cl+' onclick="setActivityDict(\''
            + dictId + '\',\'activityLocation\')">' + dictName
            + '</a>';
        }
        $("#activityLocationLabel").html(dictHtml+otherHtml);
        tagSelectDict("activityLocationLabel");
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

//选择关键字标签时，赋值
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

function tagSelect(id) {
    /* tag标签选择 */
    $('#'+id).find('a').click(function() {
        if($(this).attr("disable") == "true") return;
        if ($(this).hasClass('cur')) {
            $(this).removeClass('cur');
        } else {
            $(this).addClass('cur');
        }
    });
}


//计算日期相隔的天数
function getDateDiff(startDate, endDate){
    var startTime = new Date(Date.parse(startDate.replace(/-/g,   "/"))).getTime();
    var endTime = new Date(Date.parse(endDate.replace(/-/g,   "/"))).getTime();
    var dates = Math.abs((startTime - endTime))/(1000*60*60*24);
    return dates + 1;
}

//监听 时间段的文本失去焦点事件
$(function (){
     getTotalTicketCount();
    $('#notOnlineTicket').on('blur','input',function () {
        getTotalTicketCount();
    })
});

//得到售票的总数量
function getTotalTicketCount() {
    if ($("#activityStartTime").val() != '' && $("#activityEndTime").val() != '' && $("#notOnlineText").val() != '') {
        //相隔时间段
        var dayCount  = getDateDiff($("#activityStartTime").val(),$("#activityEndTime").val());
        //每天的场次数量
        var $ticketList = $("#put-ticket-list");
        var $ticketItem = $ticketList.find(".ticket-item");
        var eventCount = $ticketItem.length;
        //每个场次的放票数量
        var ticketCount = $("#notOnlineText").val();
        $("#totalEventCount").html(eventCount*ticketCount*dayCount);
    }
}
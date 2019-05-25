$(function () {

    loadAreaData(0, "../dept/queryAreaList.do?pid=be4cb27979a845c1b42153adc442b117");
    /*$("#trainArea").change(function () {*/

        var code = $(this).val().split(',')[0];
        //loadAreaData(1, "../venue/getVenueTypeByArea.do?areaId=" + $(this).val().split(',')[0]);
        if(code.indexOf("1335")>-1){
            code = 1;
        }
    var html = '';
    var userIsManger = $("#userIsManger").val();
    var userTown = $("#userTown").val();
        code = $("#userDeptId").val();
    var deptId =  $("#userDeptId").val();//userTown.split(",")[0];
    var deptName = '';//userTown.split(",")[1];
    var userCounty = $("#userCounty").val();
    var userDeptId = userCounty.split(",")[0];
    var userDeptName = userCounty.split(",")[1];
    var trainLocation = $("#trainLocation").val();
    var trainTitle = $("#trainTitle").val();

        if(code == 'be4cb27979a845c1b42153adc442b117'){
            html += '<a id="be4cb27979a845c1b42153adc442b117,安康市" onclick="setActivityLocation(\'be4cb27979a845c1b42153adc442b117,安康市\')" class="ng-binding ng-scope ">安康市</a>';
        }else{
            if(userIsManger == 4){
                html += '<a id="' + deptId + '" onclick="setActivityLocation(\'' + deptId + '\')" class="ng-binding ng-scope cur">' + deptName + '</a>';
                $("#trainLocation").attr('value',deptId);
                $("#activityLocationLabel dd").html(html);
            }else{
                html += '<a id="' + deptId + '" onclick="setActivityLocation(\'' + deptId + '\')" class="ng-binding ng-scope cur">' + userDeptName + '</a>';
                $("#trainLocation").attr('value',deptId);
                $("#activityLocationLabel dd").html(html);
            }
        }
    if (trainLocation && trainTitle) {
        $('.ng-binding').addClass("cur")
    }
    /*})*/

    $("#venueType").change(function () {
        var areaId = $("#trainArea").val().split(',')[0];
        if ($(this).val() == 2) {
            $("#venueId").hide();
        } else if($(this).val() == 1){
            $("#venueId").html('<option value="1">所有场馆</option>');
            $("#venueId").val('1');
        }else{
            $("#venueId").show();
            var trainArea = $("#trainArea").val();
            if(trainArea.indexOf("1335")>-1){
                loadAreaData(2, '../venue/getVenueName.do?areaId=' + areaId + "&venueType=" + $(this).val() + "&area=kong")
            }else{
                loadAreaData(2, '../venue/getVenueName.do?areaId=' + areaId + "&venueType=" + $(this).val())
            }
        }
    })


    $("input[name=trainField]").click(function () {
        if ($(this).val() == 1) {
            $("#more_field_tr").hide();
        } else {
            $("#more_field_tr").show();
        }
    });
    $("input[name=maxPeopleClick]").click(function () {
        if ($(this).val() == 1) {
            $("#maxPeople_tr").hide();
            $("#maxPeople").val('');
            $("#maxPeople").attr('value',0);
            $("#maxPeople").val(0);
        } else {
            $("#maxPeople").attr('value','');
            $("#maxPeople_tr").show();
        }
    });
    loadTrainType();

})

function loadAreaData(type, url) {
    $.ajax({
        type: "get",
        url: url,
        dataType: "json",
        cache: false,//缓存不存在此页面
        async: true,//异步请求
        success: function (result) {
            var data = eval(result);
            //var data = json.data;
            var htmlFirst = ''
            var html = '';
            if (data != null) {
                for (var i = 0; i < data.length; i++) {
                    var obj = data[i];
                    var deptId = $("#userDeptId").val();
                    var userCounty = $("#userCounty").val().split(',')[0];
                    if (obj.deptId == deptId || obj.deptId == userCounty) {
                        htmlFirst = ' <option value="' + obj.deptId + ',' + obj.deptName + '">' + obj.deptName + '</option>';
                        $("#trainArea").html(' <option value="' + obj.deptId + ',' + obj.deptName + '">' + obj.deptName + '</option>');
                        return;
                    }else{
                        $("#trainArea").html('<option value="be4cb27979a845c1b42153adc442b117,安康市">安康市</option>');
                    }
                    // switch (type) {
                    //      case (0):
                    //          var va = obj.deptId + ',' + obj.deptName;
                    //          //if(trainArea == va){
                    //          //    html += ' <option selected value="' + obj.id + ',' + obj.text + '">' + obj.text + '</option>';
                    //          //}else{
                    //          html += ' <option value="' + obj.deptId + ',' + obj.deptName + '">' + obj.deptName + '</option>';
                    //          //}
                    //          break;
                    //      case (1):
                    //          html += ' <option value="' + obj.id + '">' + obj.text + '</option>';
                    //          break;
                    //      case (2):
                    //          html += ' <option value="' + obj.id + '">' + obj.text + '</option>';
                    //          break;
                    //      default:
                    //
                    // }
                    // $("#trainArea").html(htmlFirst+html);
                }
                /*            switch (type) {
                                case (0):
                                    $("#trainArea").html('<option value="02dee52e685f4df9976dc294710e969a,重庆市">所有区县</option>' + html);
                                    if (trainArea) {
                                        $("#trainArea").val(trainArea).change();
                                    }
                                    break;
                                case (1):
                                    $("#venueType").html('<option value="1">场馆类型</option><option value="2">区级自建</option>' + html);
                                    if (venueType) {
                                        $("#venueType").val(venueType).change();
                                    }
                                    break;
                                case (2):
                                    $("#venueId").html('<option value="1">所有场馆</option>' + html);
                                    if (venueId) {
                                        $("#venueId").val(venueId);
                                    }
                                    break;
                                default:
                            }*/
            }
        }
    });
}

function setActivityLocation(value) {
    $("#trainLocation").val(value);
    if(value != '1'){
        //$('#activityLocationLabel').find('a').removeClass('cur');
        $('#' + value).addClass('cur');
    }
}


/**
 * 类型单选
 * @param id
 */
function setTrainType(id) {
    $('#' + id).find('a').click(function () {
        if ($(this).hasClass("cur")) {
            return;
        } else {
            $('#' + id).find('a').removeClass('cur');
            $(this).addClass('cur');
            $("#trainType").val($(this).attr("id"));
            setParentId($(this).attr("id"));
            $("#trainTag").val('');
        }
    });
}

//标签多选
function setTrainTag() {
    $('#childTagLabel').find('a').click(function() {
        if ($(this).hasClass('cur')) {
            $(this).removeClass('cur');
        } else {
            $(this).addClass('cur');
        }
    });
};

function setAdmissionType(value) {
    $('.admissionType').removeClass('cur');
    $(this).addClass('cur');
    $("#admissionType").val(value);
    if (value == 4) {
        $("#interviewTimeTR").show();
        $("#interviewAddressTR").show();
    } else {
        $("#interviewTimeTR").hide();
        $("#interviewAddressTR").hide();
    }
}

function setCourseType(value){
    $('.courseType').removeClass('cur');
    $(this).addClass('cur');
    $("#courseType").val(value);
}


/**
 * 单选
 * @param id
 */
function tagSelectSingle(id) {
    /* tag标签选择 */
    $('#' + id).find('a').click(function () {
        $('#' + id).find('a').removeClass('cur');
        $(this).addClass('cur');
    });
}


function deleteCourseTime(o) {
    $(o).parent('div').remove();
}

function addCourseTime(o) {
    var len = $(".more_field").find(".fieldTimeDiv").length;
    var html = '<div class="fieldTimeDiv" style="margin-top: 20px;">\n' +
        '                        <div class="start w340">\n' +
        '                            <span class="text">培训时间</span>\n' +
        '                            <input type="text" name="fieldTime" id="fieldTime' + len + '" value="" readonly="">\n' +
        '                            <i date-picker="" class="fieldTime'+len+'"></i>\n' +
        '                        </div>\n' +
        '  <div class="end w64" style="width: 100px;">\n' +
        '                            <input type="text" style="width: 70px;" name="fieldStartTime" id="fieldStartTime' + len + '" value="" readonly="">\n' +
        '                            <i date-picker="" class="fieldStartTime'+len+'"></i>\n' +
        '                        </div>\n' +
        '                        <span class="txt">至</span>\n' +
        '                        <div class="end w64" style="width: 100px;">\n' +
        '                            <input type="text" style="width: 70px;" name="fieldEndTime" id="fieldEndTime' + len + '" value="" readonly="">\n' +
        '                            <i date-picker="" class="fieldEndTime'+len+'"></i>\n' +
        '                        </div>\n' +
        '\n' +
        '                        <a onclick="deleteCourseTime(this)" class="timeico jianhao" style="background: url(/STATIC/image/remove.png) no-repeat center center;width: 25px;height: 42px;display: block;float: left"></a>\n' +
        '                        <div style="clear: both;"></div>\n' +
        '                       </div>\n' +
        '                    </div>';
    $(o).before(html);
    setFieldTime(len);
    setFieldStartTime(len);
    setFieldEndTime(len)
}


//** 日期控件
$(function () {
    $(".registrationStartTime").on("click", function () {
        WdatePicker({
            el: 'registrationStartTime',
            dateFmt: 'yyyy-MM-dd HH:mm',
            doubleCalendar: true,
            minDate: '',
            maxDate: '#F{$dp.$D(\'registrationEndTime\')}',
            position: {left: -69, top: 12},
            isShowClear: false,
            isShowOK: true,
            isShowToday: false,
            // onpicked: pickedStartFunc
        })
    });
    $(".registrationEndTime").on("click", function () {
        WdatePicker({
            el: 'registrationEndTime',
            dateFmt: 'yyyy-MM-dd HH:mm',
            doubleCalendar: true,
            minDate: '#F{$dp.$D(\'registrationStartTime\')}',
            position: {left: -69, top: 12},
            isShowClear: false,
            isShowOK: true,
            isShowToday: false,
            //onpicked: pickedendFunc
        })
    })

    $(".trainStartTime").on("click", function () {
        WdatePicker({
            el: 'trainStartTime',
            dateFmt: 'yyyy-MM-dd HH:mm',
            doubleCalendar: true,
            maxDate: '#F{$dp.$D(\'trainEndTime\')}',
            position: {left: -69, top: 12},
            isShowClear: false,
            isShowOK: true,
            isShowToday: false,
            //onpicked: pickedendFunc
        })
    })

    $(".trainEndTime").on("click", function () {
        WdatePicker({
            el: 'trainEndTime',
            dateFmt: 'yyyy-MM-dd HH:mm',
            doubleCalendar: true,
            minDate: '#F{$dp.$D(\'trainStartTime\')}',
            position: {left: -69, top: 12},
            isShowClear: false,
            isShowOK: true,
            isShowToday: false,
            //onpicked: pickedendFunc
        })
    })
    setFieldTime(0);
    setFieldStartTime(0);
    setFieldEndTime(0);
});

function setFieldTime(i) {
    $(".fieldTime"+i).on("click", function () {
        WdatePicker({
            el: 'fieldTime' + i,
            dateFmt: 'yyyy-MM-dd',
            doubleCalendar: true,
            minDate: '#F{$dp.$D(\'trainStartTime\')}',
            maxDate: '#F{$dp.$D(\'trainEndTime\')}',
            position: {left: -69, top: 12},
            isShowClear: false,
            isShowOK: true,
            isShowToday: false,
            // onpicked: pickedStartFunc
        })
    });
}

function setFieldStartTime(i) {
    $(".fieldStartTime"+i).on("click", function () {
        WdatePicker({
            el: 'fieldStartTime' + i,
            dateFmt: 'HH:mm',
            //doubleCalendar: true,
            //minDate: '#F{$dp.$D(\'trainStartTime\')}',
            position: {left: -69, top: 12},
            isShowClear: false,
            isShowOK: true,
            isShowToday: false,
            //onpicked: pickedendFunc
        })
    })
}

function setFieldEndTime(i) {
    $(".fieldEndTime"+i).on("click", function () {
        WdatePicker({
            el: 'fieldEndTime' + i,
            dateFmt: 'HH:mm',
            //doubleCalendar: true,
            //minDate: '#F{$dp.$D(\'trainStartTime\')}',
            position: {left: -69, top: 12},
            isShowClear: false,
            isShowOK: true,
            isShowToday: false,
            //onpicked: pickedendFunc
        })
    })
}


function pickedStartFunc() {
    $dp.$('registrationStartTime').value = $dp.cal.getDateStr('yyyy-MM-dd HH:mm');
}

function pickedendFunc() {
    $dp.$('registrationEndTime').value = $dp.cal.getDateStr('yyyy-MM-dd HH:mm');
}

//前端校验数据
function addInfo(trainStatus) {
    $("#trainStatus").val(trainStatus);
    var trainTitle = $("#trainTitle").val();
    if(!trainTitle){
        dialogAlert("系统提示", "填写标题！");
        return;
    }
    if(trainStatus != 2){
        var trainImgUrl = $("#trainImgUrl").val();
        if(!trainImgUrl){
            dialogAlert("系统提示", "填写封面图片！");
            return;
        }
    }
    var trainArea = $("#trainArea").val();
    if(trainArea==1){
        dialogAlert("系统提示", "请选择地区！");
        return;
    }
    var venueType = $("#venueType").val();
    var venueId = $("#venueId").val();
    if(venueType!=2){
        if(venueType==1 || venueId==1){
            dialogAlert("系统提示", "请选择场馆！");
            return;
        }
    }
    var trainLocation2 = $("#trainLocation").val();
    if(!trainLocation2){
        dialogAlert("系统提示", "请选择位置！");
        return;
    }


    var trainAddress = $("#trainAddress").val();
    if(!trainAddress){
        dialogAlert("系统提示", "请填写培训地址！");
        return;
    }

    var lon = $("#lon").val();
    if(!lon){
        dialogAlert("系统提示", "请选择位置坐标！");
        return;
    }
    var lat = $("#lat").val();
    if(!lat){
        dialogAlert("系统提示", "请选择位置坐标！");
        return;
    }

    var trainTag = "";
    $("#childLabel dl").find(".cur").each(function () {
        trainTag += $(this).attr("data-v")+',';
    });
    if(!trainTag){
        dialogAlert("系统提示", "请选择培训标签！");
        return;
    }
    $("#trainTag").val(trainTag.substr(0,trainTag.length-1));


    var admissionType = $("#admissionType").val();
    if(!admissionType){
        dialogAlert("系统提示", "请选择录取方式！");
        return;
    }

    var maleMinAge = $("#maleMinAge").val();
    if(!maleMinAge) {
        dialogAlert("系统提示", "请填写男性最小年龄要求！");
        return;
    }

    var maleMaxAge = $("#maleMaxAge").val();
    if(!maleMaxAge) {
        dialogAlert("系统提示", "请填写男性最高年龄要求！");
        return;
    }

    var femaleMinAge = $("#femaleMinAge").val();
    if(!femaleMinAge) {
        dialogAlert("系统提示", "请填写女性最小年龄要求！");
        return;
    }

    var femaleMaxAge = $("#femaleMaxAge").val();
    if(!femaleMaxAge){
        dialogAlert("系统提示", "请填写女性最高年龄要求！");
        return;
    }


/*    var maxPeople = $("#maxPeople").val();
    if(!maxPeople){
        dialogAlert("系统提示", "请填写录取人数上限！");
        return;
    }*/
    var registrationStartTime = $("#registrationStartTime").val();
    var registrationEndTime = $("#registrationEndTime").val();
    if(!registrationStartTime || !registrationEndTime){
        dialogAlert("系统提示", "请选择报名时间！");
        return;
    }

    var courseType = $("#courseType").val();
    if(!courseType){
        dialogAlert("系统提示", "请填写报名次数上限！");
        return;
    }
    var trainStartTime = $("#trainStartTime").val();
    var trainEndTime = $("#trainEndTime").val();
    if(!trainStartTime || !trainEndTime){
        dialogAlert("系统提示", "请选择培训周期！");
        return;
    }


    var consultingPhone = $("#consultingPhone").val();
    if(!consultingPhone){
        dialogAlert("系统提示", "请填写咨询电话！");
        return;
    }

    var trainField = $("#trainField").val();
    if ($("input[name=trainField]:checked").val() == 2) {
        var arr = new Array();
        $(".more_field .fieldTimeDiv").each(function () {
            var obj = new Object();
            var fieldTime = $(this).find("input[name='fieldTime']").val();
            var fieldStartTime = $(this).find("input[name='fieldStartTime']").val();
            var fieldEndTime = $(this).find("input[name='fieldEndTime']").val();
            obj.fieldTimeStr = fieldTime + " " + fieldStartTime + "-" + fieldEndTime;
            obj.fieldStartTime = fieldTime + " " + fieldStartTime;
            obj.fieldEndTime = fieldTime + " " + fieldEndTime;
            arr[arr.length] = obj;
        })
        var jsonArr = JSON.stringify(arr);
        $("#fieldStr").val(jsonArr);
    }

    if(trainField==2){
        var fieldStr = $('#fieldStr').val();
        if(!fieldStr){
            dialogAlert("系统提示", "多场次培训需填写培训场次信息！");
            return;
        }
    }

    $('#registrationRequirements').val(CKEDITOR.instances.registrationRequirements.getData());
    $('#courseIntroduction').val(CKEDITOR.instances.courseIntroduction.getData());
    $('#teachersIntroduction').val(CKEDITOR.instances.teachersIntroduction.getData());

    var registrationRequirements = $("#registrationRequirements").val();
    if(!registrationRequirements){
        dialogAlert("系统提示", "请填写报名要求！");
        return;
    }
    var courseIntroduction = $("#courseIntroduction").val();
    if(!courseIntroduction){
        dialogAlert("系统提示", "请填写课程简介！");
        return;
    }
    var teachersIntroduction = $("#teachersIntroduction").val();
    if(!teachersIntroduction){
        dialogAlert("系统提示", "请填写师资介绍！");
        return;
    }



    $.post("../train/save.do", $('#infoForm').serialize(), function (data) {
        data = JSON.parse(data);
        if (data.status==200) {
            dialogAlert("提示", "保存成功！", function () {
                window.location.href = "../train/trainList.do?trainStatus=1";
            });
        } else if (data.status == "400") {
            dialogConfirm("提示", "请先登录！", function () {
                window.location.href = "${path}/login.do";
            });
        } else {
            dialogConfirm("提示", "保存培训失败！")
        }
    });
}

function loadTrainType() {
    var html = "";
    $.post("../tag/getCommonTag.do?type=10", function (data) {
        var html = "";
        var list = eval(data);
        for (var i = 0; i < list.length; i++) {
            var obj = list[i];
            html += '<a data-v="' + obj.tagName + '" id="' + obj.tagName + '" style="width: auto; text-align: center">' + obj.tagName + '</a>';
        }
        $("#commonTagLabel").html(html);
        if (list.length > 0) {
            $("#childTagTr").show();

            $('#commonTagLabel').find('a').click(function () {
                if ($(this).hasClass('cur')) {
                    $(this).removeClass('cur');
                } else {
                    $(this).addClass('cur');
                }
            });
        }
        setTrainTag();
    });

    $.post("../tag/getChildTagByType.do?code=TRAIN_TYPE", function (data) {
        var list = eval(data);
        for (var i = 0; i < list.length; i++) {
            var obj = list[i];
            html += '<a id="' + obj.tagId + '" style="width: auto; text-align: center">' + obj.tagName + '</a>';
        }
        $("#TypeLabel").append(html);
        $("#" + trainType).addClass("cur");
        if(trainType) {
            setParentId(trainType);
        }
        setTrainType("TypeLabel");
    });
}

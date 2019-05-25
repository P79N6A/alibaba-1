<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>产品统计--场馆统计</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <link rel="shortcut icon" href="/STATIC/image/favicon.ico" type="image/x-icon" mce_href="/STATIC/image/favicon.ico">
    <link href="/STATIC/image/favicon.ico" rel="icon" type="image/x-icon" mce_href="/STATIC/image/favicon.ico">
    <link rel="stylesheet" type="text/css" href="/STATIC/css/reset.css"/>
    <link rel="stylesheet" type="text/css" href="/STATIC/css/main.css"/>
    <link rel="stylesheet" type="text/css" href="/STATIC/css/jquery.alerts.css">
    <!--[if lte IE 8]>
    <link rel="stylesheet" type="text/css" href="/STATIC/css/main-ie.css"/>
    <![endif]-->
    <link rel="stylesheet" type="text/css" href="/STATIC/css/page.css"/>
    <link rel="stylesheet" type="text/css" href="/STATIC/css/select2.css"/>
    <link rel="stylesheet" type="text/css" href="/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="/STATIC/js/jquery.min.js"></script>
    <script type="text/javascript" src="/STATIC/js/base.js"></script>
    <script type="text/javascript" src="/STATIC/js/DatePicker/WdatePicker.js"></script>
    <script type="text/javascript" src="/STATIC/js/common.js"></script>
    <script type="text/javascript" src="/STATIC/js/jquery.alerts.js"></script>
    <script type="text/javascript" src="/STATIC/js/location.js"></script>
    <script type="text/javascript" src="/STATIC/js/page.min.js"></script>
    <script type="text/javascript" src="/STATIC/js/jquery.uploadify-3.1.min.js"></script>
    <script type="text/javascript" src="/STATIC/js/dialog-min.js"></script>
    <script type="text/javascript" src="/STATIC/js/birthday.js"></script>
    <script type="text/javascript" src="/STATIC/js/clipboard.min.js"></script>
    <!--搜索场馆三级联动 start-->
    <script type="text/javascript" src="/STATIC/js/area.js"></script>
    <script type="text/javascript" src="/STATIC/js/select2.js"></script>
    <script type="text/javascript" src="/STATIC/js/select2_locale_zh-CN.js"></script>
    <script src="/STATIC/js/avalon.js"></script>
    <script src="/STATIC/js/angular.js"></script>
    <script type="text/javascript" src="/STATIC/js/ckeditor/ckeditor.js"></script>
    <script type="text/javascript" src="/STATIC/js/ckeditor/sample.js"></script>
    <!--富文本编辑器 end-->
    <link rel="stylesheet" type="text/css" href="/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="/STATIC/js/dialogBack/lib/sea.js"></script>
    <link rel="Stylesheet" type="text/css" href="/STATIC/css/DialogBySHF.css" />
    <script type="text/javascript" src="/STATIC/js/DialogBySHF.js"></script>
    <script type="text/javascript" src="/STATIC/js/location.js"></script>
    <script type="text/javascript">
        seajs.use(['/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
            window.dialog = dialog;
        });
        function exportExcel() {
            var activityName = $('#activityName').val();
            if (activityName != undefined && activityName == '输入名称') {
                $('#activityName').val("");
            }
            /*            $.post("
             /activity/exportActivityExcel.do",$("#activityForm").serialize(), function(rsData) {
             });*/
            location.href = "/activity/exportActivityExcel.do?" + $("#activityForm").serialize();
        }
        //** 日期控件
        $(function () {

            $(".start-btn").on("click", function () {
                WdatePicker({
                    el: 'startDateHidden',
                    dateFmt: 'yyyy-MM-dd',
                    doubleCalendar: true,
                    minDate: '',
                    maxDate: '#F{$dp.$D(\'endDateHidden\')}',
                    position: {left: -224, top: 8},
                    isShowClear: false,
                    isShowOK: true,
                    isShowToday: false,
                    onpicked: pickedStartFunc
                })
            });
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
            $dp.$('startDate').value = $dp.cal.getDateStr('yyyy-MM-dd');
        }
        function pickedendFunc() {
            $dp.$('endDate').value = $dp.cal.getDateStr('yyyy-MM-dd');
        }

        $(function () {
            selectModel();
        });



        //查询活动中存在的活动类型
        $(function () {
            var venueProvince = '${user.userProvince}';
            var venueCity = '${user.userCity}';
            var venueArea = '${user.userCounty}';
            var ulHtml = "<li data-option=''>全部区县</li>";
            var divText = "全部区县";
            var loc = new Location();
            var a = new Array();
            var defaultAreaId = $("#activityArea").val();
            a=loc.find('0,' + venueProvince.split(",")[0]);
            $.each(a , function(k , v) {
                var Id =k;
                if(Id == venueCity.split(",")[0]){
                    var Text = v;
                    ulHtml += '<li data-option="' + Id + '">'
                            + Text
                            + '</li>';
                    if(defaultAreaId==Id){
                        divText=Text;
                    }
                }
            })
            a=loc.find('0,' + venueProvince.split(",")[0] + ',' + venueCity.split(",")[0]);
            $.each(a , function(k , v) {
                var area = a[k];
                var areaId =k;
                var areaText = v;
                ulHtml += '<li data-option="' + areaId + '">'
                        + areaText
                        + '</li>';
                if(defaultAreaId==areaId){
                    divText=areaText;
                }
            })
            $("#areaDiv").html(divText)
            $("#areaUl").append(ulHtml);
            var activityType = $('#activityType').val();
            $.post("../tag/getChildTagByType.do?code=ACTIVITY_TYPE", function (data) {
                if (data != '' && data != null) {
                    var list = eval(data);
                    var ulHtml = '<li data-option="">全部类型</li>';
                    for (var i = 0; i < list.length; i++) {
                        var dict = list[i];
                        ulHtml += '<li data-option="' + dict.tagId + '">' + dict.tagName + '</li>';
                        if (activityType != '' && dict.tagId == activityType) {
                            $('#activityTypeDiv').html(dict.tagName);
                        }
                    }
                    $('#activityUl').html(ulHtml);
                }
            }).success(function () {
                //selectModel();
            });
        });





    </script>
    <style type="text/css">
        .ui-dialog-title, .ui-dialog-content textarea {
            font-family: Microsoft YaHei;
        }
        .ui-dialog-header {
            border-color: #9b9b9b;
        }
        .ui-dialog-close {
            display: none;
        }
        .ui-dialog-title {
            color: #F23330;
            font-size: 20px;
            text-align: center;
        }
        .ui-dialog-content {
        }
        .ui-dialog-body {
        }
    </style>
</head>
<body>
<form id="activityForm" action="" method="post">
    <div class="site">
        <em>您现在所在的位置：</em>产品统计
        &gt; 场馆统计
    </div>
    <div class="search">
        <div class="select-box w110">
            <input type="hidden" id="activityArea" name="activityArea" value=""/>
            <div id="areaDiv" class="select-text" data-value="">全部区县</div>
            <ul class="select-option" id="areaUl">
            </ul>
        </div>

        <%--String country;--%>
        <%--String province;--%>
        <%--String area;--%>
        <%--String activityType;--%>
        <%--String activityId;--%>
        <%--String venueId;--%>
        <%--String dayDuration;--%>
        <%--String weekDuration;--%>
        <%--String monthDuration;--%>
        <%--String startDate;--%>
        <%--String endDate;--%>
        <%--String userSource;--%>
        <%--String platform;--%>

        <div class="select-box w110">
            <input type="hidden" name="venueId" />
            <input type="hidden" name="venueName" />
            <div  class="select-text" data-value="" id="venueDiv" style="white-space:nowrap;">全部场馆</div>
            <ul class="select-option" id="venueUl">
            </ul>
        </div>

        <div class="select-box w110">
            <input type="hidden" id="datetype" name="datetype" value=""/>
            <div id="datetypeDiv" class="select-text" data-value="">日期类型</div>
            <ul class="select-option" id="datetypeUl">
                <li data-option="" class="seleced">日期类型</li>
                <li data-option="day" class="">按日筛选</li>
                <li data-option="week" class="">按周筛选</li>
                <li data-option="month" class="">按月筛选</li>
            </ul>
        </div>

        <div class="select-box w110">
            <input type="hidden" id="dateDuratiion" name="dateDuratiion" value="7"/>
            <div id="dateDuratiionDiv" class="select-text" data-value="">最近7个日期单位</div>
            <ul class="select-option" id="dateDuratiionUl">
                <li data-option="7" class="seleced">最近7个日期单位</li>
                <li data-option="30" class="">最近30个日期单位</li>
            </ul>
        </div>


        <%--<div class="select-box w110">--%>
        <%--<input type="hidden" id="weeksegment" name="weeksegment" value=""/>--%>
        <%--<div id="weekDiv" class="select-text" data-value="">按周筛选</div>--%>
        <%--<ul class="select-option" id="weeksegmentUl">--%>
        <%--<li data-option="" class="seleced">按周筛选</li>--%>
        <%--<li data-option="1" class="">上周</li>--%>
        <%--<li data-option="2" class="">最近两周</li>--%>
        <%--<li data-option="4" class="">最近四周</li>--%>
        <%--</ul>--%>
        <%--</div>--%>

        <%--<div class="select-box w110">--%>
        <%--<input type="hidden" id="monthsegment" name="monthsegment" value=""/>--%>
        <%--<div id="monthDiv" class="select-text" data-value="">按月筛选</div>--%>
        <%--<ul class="select-option" id="monthsegmentUl">--%>
        <%--<li data-option="" class="seleced">按月筛选</li>--%>
        <%--<li data-option="0" >本月</li>--%>
        <%--<li data-option="1" class="">上月</li>--%>
        <%--</ul>--%>
        <%--</div>--%>
        <%--<table width="100%" class="form-table">--%>
        <%--<tr>--%>
        <%--<td width="100" class="td-title">主办单位：</td>--%>
        <%--<td class="td-input">--%>
        <%--<input type="text" ng-model="activity.activityHost" class="input-text w510 ng-pristine ng-untouched ng-valid ng-empty">--%>
        <%--</td>--%>
        <%--</tr>--%>

        <%--</table>--%>




        <div class="form-table" style="float: left;">
            <div class="td-time" style="margin-top: 0px;">
                <div class="start w240" style="margin-left: 8px;">
                    <span class="text">开始日期</span>
                    <input type="hidden" id="startDateHidden"/>
                    <input type="text" id="startDate" name="startDate"
                           value="" readonly/>
                    <i class="data-btn start-btn"></i>
                </div>
                <span class="txt" style="line-height: 42px;">至</span>
                <div class="end w240">
                    <span class="text">结束日期</span>
                    <input type="hidden" id="endDateHidden"/>
                    <input type="text" id="endDate" name="endDate" value=""
                           readonly/>
                    <i class="data-btn end-btn"></i>
                </div>


            </div>
        </div>
        <div class="select-btn" style="width: 250px;">
            <input type="button" value="重置条件" class='resetbutton' />
            <input type="button" onclick="formSub();" value="搜索"/>
        </div>
    </div>
    <div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th>日期</th>
                <th>活动室发布量 </th>
                <th>可预订活动室发布量</th>
            </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
        <input type="hidden" id="page" name="page" value="1"/>
        <div id="kkpager"></div>
    </div>
</form>
</body>
<script type="text/javascript">
    $(".resetbutton").click(function(){

        $("input[name='venueId']").val('');
        $("input[name='venueName']").val('');
        $("input[name='activityArea']").val('');
        $("input[name='datetype']").val('');
        $("input[name='dateDuratiion']").val('7');
        $("input[name='startDate']").val('');
        $("input[name='endDate']").val('');

        $("#areaDiv").html('全部区县');
        $("#venueDiv").html('全部场馆');
        $("#dateDuratiionDiv").html('最近7个日期单位');
        $("#datetypeDiv").html('日期类型');
        $("#activityTypeDiv").html('活动类型');

    });

    function formSub()
    {
        $.post("/statistics/getVenueStatisticData.do", $("#activityForm").serialize(),
                function(data) {
                    $("tbody").empty();
                    var json = JSON.parse(data)
                    var c1 = 0,c2 = 0;
                    var a1 = 0,a2 = 0;
                    for(var i=0;i<json.length;i++)
                    {//class="odd"

                        c1 += parseInt(json[i]["val1"])
                        c2 += parseInt(json[i]["val2"])

                        $("tbody").append("<tr  "+((i%2==0)?"class=\"odd\"":"")+"><td>"+json[i]["cdate"]+"</td><td>"+json[i]["val1"]+"</td><td>"+json[i]["val2"]+"</td></tr>")
                    }
                    a1 = Math.floor(c1/json.length);
                    a2 = Math.floor(c2/json.length);
                    $("tbody").append("<tr  class=\"odd\"><td>合计</td><td>"+c1+"</td><td>"+c2+"</td></tr>");
                    $("tbody").append("<tr  class=\"odd\"><td>平均值</td><td>"+a1+"</td><td>"+a2+"</td></tr>");


                }
        );
    }



    $("#venueDiv").click(function()
    {

        var areaid  = $("#activityArea").val();
        if(areaid == '')
        {
            dialogAlert("提示", "请先选择区县", function () {});
            return;
        }
        var areaname  = $("#areaDiv").html();
        $.post("/statistics/getVenueBySearchkey.do", "searchkey=&area="+areaid+","+areaname,
                function(data) {
                    var element = $("input[name='venueName']")
                    $("#venueUl").empty();
                    var json = JSON.parse(data)
                    for(var i=0;i<json.length;i++)
                    {
                        $("#venueUl").append("<li data-option=\""+json[i]["venue_id"]+"\">"+json[i]["venue_name"]+"</li>")

                    }
                    element.siblings('ul.select-option').show();
                    // element.siblings('ul.select-option').slideUp(10, function() {})
                    // element.siblings('ul.select-option').slideToggle(10, function() {

                    // });
                    // int($(this));

                }
        );
    });







</script>
</html>
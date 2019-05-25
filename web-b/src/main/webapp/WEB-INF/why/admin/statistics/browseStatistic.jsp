<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>产品统计--活动统计</title>
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
            $dp.$('activityStartTime').value = $dp.cal.getDateStr('yyyy-MM-dd');
        }
        function pickedendFunc() {
            $dp.$('activityEndTime').value = $dp.cal.getDateStr('yyyy-MM-dd');
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
    <input type="hidden" name="activityState" id="activityState" value="6"/>
    <div class="site">
        <em>您现在所在的位置：</em>产品统计
        &gt; 活动统计
    </div>
    <div class="search">
        <div class="select-box w110">
            <input type="hidden" id="activityArea" name="activityArea" value=""/>
            <div id="areaDiv" class="select-text" data-value="">全部区县</div>
            <ul class="select-option" id="areaUl">
            </ul>
        </div>



        <div class="select-box" style="width:140px">
            <input type="text"   style="line-height: 41px;border-style: none;padding-left: 5px;width: 135px" placeholder="场馆名称">
            <ul class="select-option" id="venueUl">
            </ul>
        </div>


        <div class="select-box w110">
            <input type="hidden" id="daysegment" name="daysegment" value=""/>
            <div id="dayDiv" class="select-text" data-value="">日期筛选</div>
            <ul class="select-option" id="daysegmentUl">
                <li data-option="0" class="seleced">日期筛选</li>
                <li data-option="1" >昨日</li>
                <li data-option="7" class="">最近7天</li>
                <li data-option="30" class="">最近30天</li>
            </ul>
        </div>


        <div class="select-box w110">
            <input type="hidden" id="weeksegment" name="weeksegment" value=""/>
            <div id="weekDiv" class="select-text" data-value="">按周筛选</div>
            <ul class="select-option" id="weeksegmentUl">
                <li data-option="" class="seleced">按周筛选</li>
                <li data-option="0" class="">本周</li>
                <li data-option="1" class="">上周</li>
                <li data-option="2" class="">最近两周</li>
                <li data-option="4" class="">最近四周</li>
            </ul>
        </div>

        <div class="select-box w110">
            <input type="hidden" id="monthsegment" name="monthsegment" value=""/>
            <div id="monthDiv" class="select-text" data-value="">按月筛选</div>
            <ul class="select-option" id="monthsegmentUl">
                <li data-option="" class="seleced">按月筛选</li>
                <li data-option="0" >本月</li>
                <li data-option="1" class="">上月</li>
            </ul>
        </div>
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
                    <input type="text" id="activityStartTime" name="activityStartTime"
                           value="" readonly/>
                    <i class="data-btn start-btn"></i>
                </div>
                <span class="txt" style="line-height: 42px;">至</span>
                <div class="end w240">
                    <span class="text">结束日期</span>
                    <input type="hidden" id="endDateHidden"/>
                    <input type="text" id="activityEndTime" name="activityEndTime" value=""
                           readonly/>
                    <i class="data-btn end-btn"></i>
                </div>

                <div class="select-box w135">
                    <input type="hidden" id="activityType" name="activityType" value=""/>
                    <div id="activityTypeDiv" class="select-text" data-value="">活动类型</div>
                    <ul class="select-option" id="activityUl">
                    </ul>
                </div>
            </div>
        </div>
        <div class="select-btn">
            <input type="button" onclick="$('#page').val(1);formSub('#activityForm');" value="搜索"/>
        </div>
    </div>
    <div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th>ID</th>
                <th class="title">活动名称</th>
                <th>选座方式</th>
                <th>剩余票数</th>
                <th>开始时间</th>
                <th>结束时间</th>
                <th>创建人</th>
                <th>创建时间</th>
                <th>最新操作人</th>
                <th>最新操作时间</th>
                <th>评级信息</th>
                <th>状态</th>
                <th>管理</th>
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
</html>
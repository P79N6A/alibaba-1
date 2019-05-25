<%@ page language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<html>
<head>
    <title>活动常规统计</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <%@include file="/WEB-INF/why/common/limit.jsp" %>
    <script type="text/javascript" src="${path}/STATIC/js/area-venues-admin.js?version=20151125"></script>

</head>
<body>
<div class="site">
    <em>您现在所在的位置：</em>活动常规统计
</div>
<script type="text/javascript">

</script>
<table width="100%" class=" main-publish form-table">

</table>
<div class="site-title">安康市</div>
<table width="100%" class=" main-publish form-table">
    <form action="" id="fm">
    <tr>
        <td width="100" class="td-title"><span class="red">*</span>活动名称：</td>
        <td class="td-input" width="280"><input type="text" id="activityName" name="activityName" class="input-text w240" maxlength="50"/>
        </td>

        <td width="100" class="td-title"><span class="red">*</span>场馆名称：</td>
        <td class="td-input" width="260"><input type="text" id="venueName"  name="venueName" class="input-text w240" maxlength="50"/></td>

        <td width="10" style="margin-left: 8px;" class="td-title"></td>
        <td class="search">
            <div class="form-table" style="float: left;">
                <div class="td-time" style="margin-top: 0px;">
                    <div class="start w240" style="margin-left: 70px;">
                        <span class="text">开始日期</span>
                        <input type="hidden" id="startDateHidden"/>
                        <input type="text" id="startTime" name="startTime"
                               value="" readonly/>
                        <i class="data-btn start-btn"></i>
                    </div>
                    <span class="txt" style="line-height: 42px;">至</span>
                    <div class="end w240">
                        <span class="text">结束日期</span>
                        <input type="hidden" id="endDateHidden"/>
                        <input type="text" id="endTime" name="endTime" value=""
                               readonly/>
                        <i class="data-btn end-btn"></i>
                    </div>
                    <div class="select-btn">
                        <input type="button" style="text-align: center;color: white" onclick="doSubmit()" value="搜索"/>
                    </div>
                    <div class="select-btn">
                        <input type="button" style="text-align: center;color: white" onclick="exportExcel()" value="导出"/>
                    </div>
                </div>
            </div>
        </td>
    </tr>
    </form>
    <tr><td colspan="12" style="line-height: 8px"><span style="margin-left: 24px;color: #EC3838;">*&nbsp;订票率 = 订票数 / 总票数&nbsp;&nbsp;&nbsp;&nbsp;取票率 = 取票数 / 订票数&nbsp;&nbsp;&nbsp;&nbsp<%--;活动到场率 = 验票数 / 总票数--%></span></td></tr>
</table>
<div class="data-content table-cont">
    <div class="table-cont">
        <table width="100%" class="tab-data" id="Area_Info">
            <thead class="tab-data">
            <tr>
                <td>活动名称</td>
                <td>活动场馆名称</td>
                <td>活动场次</td>
                <td>有效订单数</td>
                <%--<td>验票订单数</td>--%>
                <td>总票数</td>
                <td>订票数</td>
                <td>订票率</td>
                <td>取票数</td>
                <td>取票率</td>
                <%--<td>验票数</td>--%>
                <%--<td>活动到场率</td>--%>
            </tr>
            </thead>
            <tbody id="tbody">

            </tbody>
        </table>
    </div>
</div>
</body>
<script type="text/javascript">


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
        $dp.$('startTime').value = $dp.cal.getDateStr('yyyy-MM-dd');
    }

    function pickedendFunc() {
        $dp.$('endTime').value = $dp.cal.getDateStr('yyyy-MM-dd');
    }


    function doSubmit() {
        var activityName = $("#activityName").val();
        var venueName = $("#venueName").val();
        var startTime = $("#startDateHidden").val();
        var endTime = $("#endDateHidden").val();
        if(activityName=='' && venueName=='' && startTime=='' && endTime=='') {
            dialogAlert("提示","请输入查询条件搜索！")
            return;
        };
        $.post("${path}/activityStatistics/activityRoutineStatisticsData.do", {activityName:activityName,venueName:venueName,startTime:startTime,endTime:endTime}, function (data) {
            var tbody = '';
            if (data != '' && data != null) {
                var list = eval(data);
                for(var i =0;i<list.length;i++){
                    tbody+='<tr>';
                    tbody+='<td>'+list[i].activityName+'</td>';
                    tbody+='<td>'+list[i].venueName+'</td>';
                    tbody+='<td>'+list[i].eventDateTime+'</td>';
                    tbody+='<td>'+list[i].validOrders+'</td>';
                    // tbody+='<td>'+list[i].checkOrders+'</td>';
                    tbody+='<td>'+list[i].tickets+'</td>';
                    tbody+='<td>'+list[i].validTickets+'</td>';
                    tbody+='<td>'+list[i].bookPer+'</td>';
                    tbody+='<td>'+list[i].takeTickets+'</td>';
                    tbody+='<td>'+list[i].takeTicketsPer+'</td>';
                    // tbody+='<td>'+list[i].checkTickets+'</td>';
                    // tbody+='<td>'+list[i].presentPer+'</td>';
                    tbody+='</tr>';
                }
            }
            $('#tbody').html(tbody);
        });
    }

    function exportExcel() {
        var activityName = $("#activityName").val();
        var venueName = $("#venueName").val();
        var startTime = $("#startDateHidden").val();
        var endTime = $("#endDateHidden").val();
        if(activityName=='' && venueName=='' && startTime=='' && endTime=='') {
            dialogAlert("提示","请输入查询条件进行导出！")
            return;
        };

//        var day=dateNowNum-dateStartDateNum;
//        if(day<=30)
//        {
            var data=$("#fm").serialize();
            location.href = "${path}/activityStatistics/exportActivityRoutineStatisticsData.do?"+data
//        }
//        else
//        {
//            dialogAlert("提示","请搜索近30天内数据进行导出！")
//        }
    }

</script>
</html>

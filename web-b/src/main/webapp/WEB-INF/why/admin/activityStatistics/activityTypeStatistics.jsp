<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>

<head>
    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <script type="text/javascript" src="${path}/STATIC/js/jquery.epiclock.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/highcharts/highcharts.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/Statistics/Statistics.js"></script>
    <script type="text/javascript">
        $(function () {
            doQuery();
            selectModel(function () {
                var dataVal = $("#activity-select-ul").find("input").val();
                doQuery();
            });
            $.epiclock(); //开始运行

            $(".start-btn").on("click", function () {
                WdatePicker({
                    el: 'activityStartTime',
                    dateFmt: 'yyyy-MM-dd',
                    doubleCalendar: true,
                    minDate: '',
                    maxDate: '#F{$dp.$D(\'activityEndTime\')}',
                    position: {left: -69, top: 12},
                    isShowClear: false,
                    isShowOK: true,
                    isShowToday: false,
                    onpicked: doQueryTime
                })
            });
            $(".end-btn").on("click", function () {
                WdatePicker({
                    el: 'activityEndTime',
                    dateFmt: 'yyyy-MM-dd',
                    doubleCalendar: true,
                    minDate: '#F{$dp.$D(\'activityStartTime\')}',
                    position: {left: -69, top: 12},
                    isShowClear: false,
                    isShowOK: true,
                    isShowToday: false,
                    onpicked: doQueryTime
                })
            })
        });

        //导出excel表格
        function exportExcel() {
            location.href = "${path}/activityStatistics/exportActivityByAreaExcel.do?" + $("#activityForm").serialize();
        }

        //获取数据
        var flag = true;

        function doQueryTime(){
            var queryType = $("#queryType").val();
            if(queryType ==4){
                doQuery();
            }
        }

        function doQuery() {
            $("#Area_Info").html("");
            var dataVal = $("#activity-select-ul").find("input").val();
            var areaData = [];
            var activityCount = [];
            var bookActivityCount = [];

            $.post("${path}/activityStatistics/queryActivityTypeData.do",$("#jvm").serialize(), function (data) {
                list = eval(data);

                for (var i = 0; i < list.length; i++) {
                    var obj = list[i];
                    var dictName = obj.dictName;

                    $("#Area_Info").append('<tr><td width="10%">' + dictName + '</td>' +
                        //'<td width="10%">' + obj.activityCount + '</td>' +
                        '<td>' + obj.activityCount + '</td>' +
                        '<td>' + obj.bookActivityCount + '</td>' +
                        '<td>' + obj.orderCount + '</td>' +
                        '<td>' + obj.activityTicketCount + '</td>' +
                        '<td>' + obj.orderTicketCount + '</td>'
                    );

                    activityCount.push(obj.activityCount);
                    bookActivityCount.push(obj.bookActivityCount);
                    areaData.push(dictName);
                    //向柱状图里塞数据
                }
                ;

                /*各区县活动发布情况*/
                $('#activityStatistic2').highcharts({
                    chart: {
                        backgroundColor: '#F4F6F7',
                        type: 'column'
                    },
                    title: {
                        text: ''
                    },
                    legend: {
                        enabled: false  //去掉底部图例
                    },
                    exporting: {
                        enabled: false  //去掉打印按钮
                    },
                    credits: {
                        enabled: false  //去掉官网链接
                    },
                    xAxis: [{
                        categories: areaData,
                        title: {
                            enabled: false
                        },
                        labels: {
                            style: {color: '#142340', fontWeight: 'bold', fontFamily: '微软雅黑'}
                        },
                        lineWidth: 4,
                        lineColor: '#374E65',
                        tickLength: 0
                    }],
                    yAxis: [{ // Primary yAxis
                        title: {
                            text: ''
                        },
                        labels: {
                            format: '{value}',
                            style: {
                                color: '#142340', fontWeight: 'bold', fontFamily: '微软雅黑'
                            }
                        },
                        opposite: true
                    }, { // Secondary yAxis
                        labels: {
                            format: '{value}',
                            style: {
                                color: '#142340', fontWeight: 'bold', fontFamily: '微软雅黑'
                            }
                        },
                        title: {
                            text: ''
                        }
                    }],
                    tooltip: {
                        shared: true
                    },
                    series: [{
                        name: '活动供应量',
                        color: '#33a7da',
                        type: 'column',
                        yAxis: 1,
                        data: activityCount,
                        tooltip: {
                            valueSuffix: ''
                        }
                    }, {
                        name: '可预订活动供应量',
                        color: '#ffcc00',
                        type: 'column',
                        yAxis: 1,
                        data: bookActivityCount,
                        tooltip: {
                            valueSuffix: ''
                        }
                    }]
                });
                $('#epiClock').epiclock({
                    format: ' Y-F-j　G:i:s'
                }); //绑定
            });
        }
    </script>
</head>
<body>
<div class="site">
    <em>您现在所在的位置：</em>数据管理 &gt; 活动数据统计 &gt; 活动类型情况
</div>
<div class="site-title">活动信息数据</div>
<div class="in-content">
    <div class="search in-tit1">
    <form id="jvm">
        <h2>安康市各活动类型情况图</h2>
        <div class="form-table" style="float: right;width: 620px;">
            <div class="td-time" style="margin-top: 0px;">
                <input type="hidden" value="${data.area}" name="area">
                <div class="select-box w110" id="activity-select-ul" style="float: left">
                    <input type="hidden" name="queryType" id="queryType" value="1"/>
                    <div class="select-text" data-value="1">昨日</div>
                    <ul class="select-option">
                        <li data-option="1">昨日</li>
                        <li data-option="2">本周</li>
                        <li data-option="3">本月</li>
                        <li data-option="4">自定义</li>
                    </ul>
                </div>
                <div id="times">
                    <div class="start w240" style="margin-left: 30px;">
                        <span class="text">开始日期</span>
                        <input type="text" id="activityStartTime" value="${data.activityStartTime}" name="activityStartTime" readonly/>
                        <i class="data-btn start-btn"></i>
                    </div>
                    <span class="txt" style="line-height: 42px;">至</span>
                    <div class="end w240">
                        <span class="text">结束日期</span>
                        <input type="text" id="activityEndTime" value="${data.activityEndTime}"  name="activityEndTime" readonly/>
                        <i class="data-btn end-btn"></i>
                    </div>
                </div>
            </div>
        </div>
    </form>
    </div>
    <div class="in-part1">
        <div class="in-part1-tip">
            <%--，环比增长 <span id="activityPresent" class="red">3</span>%--%>
            <div class="legend fr">
                <%--<span><i class="icon1"></i><em>环比变化曲线图</em></span>--%>
                    <span><i class="icon2" style="background: #0D9BF2;height: 10px;margin-top: 10px;"></i><em>活动供应量</em></span>
                    <span><i class="icon2" style="background: #ffcc00;height: 10px;margin-top: 10px;"></i><em>可预订活动供应量</em></span>
            </div>
        </div>
        <div class="in-container">
            <div id="activityStatistic2"></div>
        </div>
    </div>
</div>
<div class="data-content">
    <div class="table-tit">
        <h1>安康市活动类型情况对比表</h1>
        <%--<a class="export" onclick="exportExcel();">导出</a>--%>
    </div>
    <div class="in-container">
        <div id="totalStatistic"></div>
    </div>
    <div class="table-cont">
        <table width="100%" class="tab-data">
            <thead class="tab-data">
            <tr>
                <td>类型名称</td>
                <%--<td>查询时间</td>--%>
                <td>活动供应量</td>
                <td>可预订活动供应量</td>
                <td>订单量</td>
                <td>发票量</td>
                <td>订票量</td>
            </tr>
            </thead>
            <tbody id="Area_Info">
            </tbody>
        </table>
    </div>
</div>


</body>
</html>
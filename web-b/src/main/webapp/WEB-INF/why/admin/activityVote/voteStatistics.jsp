<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <script type="text/javascript" src="${path}/STATIC/js/jquery.epiclock.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/highcharts/highcharts.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/highcharts/exporting.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/Statistics/Statistics.js"></script>
    <script type="text/javascript">

    </script>
</head>
<body>
<form id="activityTag" action="" method="post">
    <div class="site">
        <em>您现在所在的位置：</em>投票管理 &gt; 投票统计
    </div>
    <div class="site-title">活动名称</div>
    <div class="in-content">
        <div class="search in-tit1">
            <h2>${activityName}</h2>
        </div>
    </div>
    <div class="data-content">
        <div class="in-container">
            <div id="totalStatistic"></div>
        </div>

        <%--<div class="table-cont vote-table">
            <table width="100%" class="tab-data" id="Area_Info">

                <c:if test="${not empty listData}">
                    <c:forEach items="${listData}" var="list">
                    <tr>
                       <td width="16%">${list.voteContent}</td>
                        <td id="voteNum" width="84%" align="left"><span class="column"></span><em>${list.voteCount}票</em></td>
                    </tr>
                    </c:forEach>
                </c:if>
            </table>
        </div>--%>
    </div>
    <script type="text/javascript">
        $(function() {

            var voteId = '${voteId}'
           $.post("${path}/vote/loadVoteStatisticsData.do?voteId="+voteId, function(data) {

            var list = eval(data);
               $(".data-content").append('<div class="table-cont" id="container"  style="height: '+60*list.length+'px;"></div>');
            var voteContentData =[] ;
            var voteStatisticsData =[];
            for(var i=0;i<list.length;i++){

                var obj = list[i];
                voteContentData[i]= obj.voteContent;
                voteStatisticsData[i] = obj.voteCount;
            }

            $('#container').highcharts({
                chart: {
                    backgroundColor: '#ECF0F2',
                    type: 'bar',
                    plotBorderColor: '#C0D0E0',
                    plotBorderWidth: 1
                },
                colors: ['#596988'],
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
                xAxis: {
                    categories: voteContentData ,
                    title: {
                        text: null
                    },
                    tickInterval: 0,
                    lineWidth: 1,
                    tickLength: 200,
                    gridLineWidth: 1
                },
                yAxis: {
                    min: 0,
                    title: {
                        text: '',
                        align: 'high'
                    },
                    labels: {
                        enabled: false
                    },
                    gridLineWidth: 0,

                },
                tooltip: {
                    valueSuffix: ' 票'
                },
                plotOptions: {
                    series: {
                        pointWidth: 22
                    },
                    bar: {
                        dataLabels: {
                            format: '{y}票',
                            enabled: true
                        }
                    }
                },
                series: [{
                    name: '票数统计',
                    data: voteStatisticsData
                }]
            });

        });
        });
    </script>
</form>
</body>
</html>
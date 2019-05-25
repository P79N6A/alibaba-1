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
  <script type="text/javascript" src="${path}/STATIC/js/Statistics/Statistics.js"></script>
  <script type="text/javascript">
    $(function(){
      doQuery();
      selectModel(doQuery);
      $.epiclock(); //开始运行
    });
//导出excel表格
    function exportExcel() {
      location.href = "${path}/activityStatistics/exportActivityByAreaExcel.do?" + $("#activityForm").serialize();
    }
//获取数据
    var flag = true;
    function doQuery() {
      $("#thead").next().remove();
      var dataVal = $("#activity-select-ul").find("input").val();
      var areaData = [];
      var areaCount = [];
      var areaPre = [];
      var dayCount = 0;
      var weekCount = 0;
      var monthCount = 0;
      var quarterCount = 0;
      var yearCount =0;
      var twoDayCount = 0;
      var twoWeekCount = 0;
      var twoMonthCount = 0;
      var twoQuarterCount = 0;
      var twoYearCount =0;
      var Today=0;
      var Week=0;
      var Month=0;
      var Quarter= 0;
      var Year= 0;
      var twoToday= 0;
      var twoWeek= 0;
      var twoMonth= 0;
      var twoQuarter=0;
      var twoYear=0;
        $.post("${path}/activityStatistics/queryAreaCountInfo.do", function(data) {
        var list = eval(data);

        for (var i = 0; i < list.length; i++) {
          var obj = list[i];
          var Area= obj.activityArea.split(',')[1];
           Today= obj.todayPublic;
           Week= obj.weekPublic;
           Month= obj.monthPublic;
           Quarter= obj.seasonPublic;
           Year= obj.yearPublic;
           twoToday= obj.twoTodayPublic;
           twoWeek= obj.twoWeekPublic;
           twoMonth= obj.twoMonthPublic;
           twoQuarter= obj.twoSeasonPublic;
           twoYear= obj.twoYearPublic;
          var Look= obj.numLook;
          var Order= obj.numOrder;
          var Book= obj.bookOrder;
          var Pre= obj.preOrder;
          twoToday=(Today/(twoToday-Today+1))*100-100;
          twoWeek=(Week/(twoWeek-Week+1))*100-100;
          twoMonth=(Month/(twoMonth-Month+1))*100-100;
          twoQuarter=(Quarter/(twoQuarter-Quarter+1))*100-100;
          twoYear=(Year/(twoYear-Year+1))*100-100;
          dayCount=dayCount+Today;
          weekCount=weekCount+Week;
          monthCount=monthCount+Month;
          quarterCount=quarterCount+Quarter;
          yearCount=yearCount+Year;
          twoDayCount=twoDayCount+twoToday;
          twoWeekCount =twoWeekCount+twoWeek;
          twoMonthCount=twoMonthCount+twoMonth;
          twoQuarterCount=twoQuarterCount+twoQuarter;
          twoYearCount =twoYearCount+twoYear;
            $("#Area_Info").append('<tr><td width="10%">' + Area + '</td>' +
                    '<td width="10%">' + Today + '</td>' +
                    '<td width="10%">' + Week + '</td>' +
                    '<td width="10%">' + Month + '</td>' +
                    '<td width="10%">' + Quarter + '</td>' +
                    '<td width="10%">' + Year + '</td>' +
                    '<td width="10%">' + Look + '</td>' +
                    '<td width="10%">' + Order + '</td>' +
                    '<td width="10%">' + Book + '</td>' +
                    '<td width="10%">' + Pre + '</td></tr>'
            );

            areaData.push(Area);
//向柱状图里塞数据
               if(dataVal == 1) areaCount.push(Today),areaPre.push(twoToday);
          else if(dataVal == 2) areaCount.push(Week),areaPre.push(twoWeek);
          else if(dataVal == 3) areaCount.push(Month),areaPre.push(twoMonth);
          else if(dataVal == 4) areaCount.push(Quarter),areaPre.push(twoQuarter);
          else if(dataVal == 5) areaCount.push(Year),areaPre.push(twoYear);
        };
          if(dataVal == 1) $("#searchType").html("本日"),$("#activityCount").html(dayCount);
          else if(dataVal == 2) $("#searchType").html("本周"),$("#activityCount").html(weekCount);
          else if(dataVal == 3) $("#searchType").html("本月"),$("#activityCount").html(monthCount);
          else if(dataVal == 4) $("#searchType").html("本季"),$("#activityCount").html(quarterCount);
          else if(dataVal == 5) $("#searchType").html("本年"),$("#activityCount").html(yearCount);
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
              format: '{value}%',
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
            name: '活动发布量',
            color: '#596988',
            type: 'column',
            yAxis: 1,
            data: areaCount,
            tooltip: {
              valueSuffix: ''
            }

          }, /*{
            name: '环比趋势',
            color: '#ED3838',
            type: 'spline',
            data: areaPre,
            tooltip: {
              valueSuffix: '%'
            }
          }*/]
        });
      $('#epiClock').epiclock({
        format : ' Y-F-j　G:i:s'
      }); //绑定
      });
    }
  </script>
</head>
<body>
<div class="site">
  <em>您现在所在的位置：</em>数据管理 &gt; 活动数据统计 &gt; 各区县活动情况
</div>
<div class="site-title">活动信息数据</div>
<div class="in-content">
  <div class="search in-tit1">
    <h2>上海市各区县活动情况图</h2>
    <div class="select-box w110" id="activity-select-ul">
      <input type="hidden" name="type" id="type" value="1"/>
      <div class="select-text" data-value="1">本日</div>
      <ul class="select-option">
        <li data-option="1">本日</li>
        <li data-option="2">本周</li>
        <li data-option="3">本月</li>
        <li data-option="4">本季</li>
        <li data-option="5">本年</li>
      </ul>
    </div>
  </div>
  <div class="in-part1">
    <div class="in-part1-tip">
      <div class="txt1 fl">截至目前数据统计，<span id="searchType">本周</span>上海市活动发布总计为 <span id="activityCount" class="red">265</span> 场</div>
        <%--，环比增长 <span id="activityPresent" class="red">3</span>%--%>
      <div class="legend fr">
        <%--<span><i class="icon1"></i><em>环比变化曲线图</em></span>--%>
        <span><i class="icon2"></i><em>活动统计柱状图</em></span>
      </div>
    </div>
    <div class="in-container">
      <div id="activityStatistic2"></div>
    </div>
  </div>
</div>
<div class="data-content">
  <div class="table-tit">
    <h1>上海市各区县活动情况对比表</h1>
    <a class="export" onclick="exportExcel();">导出</a>
  </div>
  <div class="in-container">
    <div id="totalStatistic"></div>
  </div>
  <div class="table-cont"  >
    <table width="100%" class="tab-data" id="Area_Info">
      <thead id="thead" class="tab-data">
      <tr>
        <td >区县名称</td>
        <td >本日发布</td>
        <td >本周发布</td>
        <td >本月发布</td>
        <td >本季发布</td>
        <td >本年发布</td>
        <td >活动浏览量</td>
        <td >发布总票数</td>
        <td >预订总票数</td>
        <td >预订百分比</td>
      </tr>
      </thead>
    </table>
  </div>
</div>


</body>
</html>
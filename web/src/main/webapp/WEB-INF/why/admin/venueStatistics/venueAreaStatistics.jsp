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
  <link rel="stylesheet" type="text/css" href="css/reset.css"/>
  <link rel="stylesheet" type="text/css" href="css/main.css"/>
  <script type="text/javascript" src="js/jquery.min.js"></script>
  <script type="text/javascript" src="js/base.js"></script>
  <script type="text/javascript">
    $(function(){
      doQuery();
      selectModel(doQuery);
      $.epiclock(); //开始运行
    });
    function exportExcel() {
      location.href = "${path}/venueStatistics/exportVenueByAreaExcel.do?" + $("#activityForm").serialize();
    }
    var flag = true;
    function doQuery() {
      var dataVal = $("#activity-select-ul").find("input").val();
      var areaData = [];
      var areaCount = [];
      $.post("${path}/venueStatistics/queryAreaCountInfo.do", function(data) {
        var list = eval(data);
        for (var i = 0; i < list.length; i++) {
          var obj = list[i];
          var Area= obj.venueArea.split(',')[1];
          var Today= obj.todayLook;
          var Week= obj.weekLook;
          var Month= obj.monthLook;
          var Quarter= obj.quarterLook;
          var Year= obj.yearLook;
          var Look= obj.weekBook;
          var Order= obj.monthBook;
          var Book= obj.quarterBook;
          var Pre= obj.yearBook;
          if(flag) {
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
          }
            areaData.push(Area);

          if(dataVal == 1) areaCount.push(Today),$("#searchType").html("本日浏览量");
          else if(dataVal == 2) areaCount.push(Week),$("#searchType").html("本周浏览量");
          else if(dataVal == 3) areaCount.push(Month),$("#searchType").html("本月浏览量");
          else if(dataVal == 4) areaCount.push(Quarter),$("#searchType").html("本季浏览量");
          else if(dataVal == 5) areaCount.push(Year),$("#searchType").html("本年浏览量");
          else if(dataVal == 6) areaCount.push(Look),$("#searchType").html("本周预订次数");
          else if(dataVal == 7) areaCount.push(Order),$("#searchType").html("本月预订次数");
          else if(dataVal == 8) areaCount.push(Book),$("#searchType").html("本季预订次数");
          else if(dataVal == 9) areaCount.push(Pre),$("#searchType").html("本年预订次数");
        }flag = false;
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

          }/*, {
           name: '环比趋势',
           color: '#ED3838',
           type: 'spline',
           data: areaScale,
           tooltip: {
           valueSuffix: '%'
           }
           }*/]
        });
        $('#epiClock').epiclock({
          //format : ' Y-F-j　G:i:s'
          format : ' Y-F-j　G:i:s'
        }); //绑定
      });
    }
  </script>
</head>
<body>
<div class="site">
  <em>您现在所在的位置：</em>数据管理 &gt; 场馆数据统计 &gt; 各区县场馆情况
</div>
<div class="site-title">场馆信息数据</div>
<div class="in-content">
  <div class="search in-tit1">
    <h2>上海市各区县场馆情况图</h2>
    <div class="select-box w110" id="activity-select-ul">
      <input type="hidden" name="type" id="type" value="1"/>
      <div class="select-text" data-value="1">本日浏览量</div>
      <ul class="select-option">
        <li data-option="1">本日浏览量</li>
        <li data-option="2">本周浏览量</li>
        <li data-option="3">本月浏览量</li>
        <li data-option="4">本季浏览量</li>
        <li data-option="5">本年浏览量</li>
        <li data-option="6">本周预订次数</li>
        <li data-option="7">本月预订次数</li>
        <li data-option="8">本季预订次数</li>
        <li data-option="9">本年预订次数</li>
      </ul>
    </div>
  </div>
  <div class="in-part1">
    <div class="in-part1-tip">
      <div class="legend fr">
        <span><i class="icon2"></i><em>场馆统计柱状图</em></span>
      </div>
    </div>
    <div class="in-container">
      <div id="activityStatistic2"></div>
    </div>
  </div>
</div>
<div class="data-content">
  <div class="table-tit">
    <h1>上海市各区县场馆情况对比表</h1>
    <a class="export" onclick="exportExcel();">导出</a>
  </div>
  <div class="in-container">
    <div id="totalStatistic"></div>
  </div>
  <div class="table-cont"  >
    <table width="100%" class="tab-data" id="Area_Info">
      <tr>
        <td >区县名称</td>
        <td >本日浏览量</td>
        <td >本周浏览量</td>
        <td >本月浏览量</td>
        <td >本季浏览量</td>
        <td >本年浏览量</td>
        <td >本周预订次数</td>
        <td >本月预订次数</td>
        <td >本季预订次数</td>
        <td >本年预订次数</td>
      </tr>
    </table>
  </div>
</div>
</body>
</html>
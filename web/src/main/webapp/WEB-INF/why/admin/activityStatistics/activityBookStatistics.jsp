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
    $(function(){
      doQuery();
      selectModel(doQuery);
      $.epiclock(); //开始运行
    });
//导出excel表格
    function exportExcel() {
      location.href = "${path}/activityStatistics/exportActivityByBookExcel.do?" + $("#activityForm").serialize();
    }
//获取数据
    var flag = true;
    function doQuery() {
      var activityStartTime
      var activityEndTime
      activityStartTime=$dp.$('activityStartTime').value
      activityEndTime=$dp.$('activityEndTime').value

      $("#thead").next().remove();
      var dataVal = $("#activity-select-ul").find("input").val();
      var areaData = [];
      var areaCount = [];
      var areaPre = [];
        $.post("${path}/activityStatistics/queryBookCountInfo.do",{activityStartTime:activityStartTime,activityEndTime:activityEndTime},  function(data) {
        var list = eval(data);

        for (var i = 0; i < list.length; i++) {
          var obj = list[i];
          var Area= obj.activityArea.split(',')[1];
          var Order= obj.numOrder;
          var Book= obj.bookOrder;
          var Use= obj.useOrder;
          var PreUse= obj.preUse;
          var Pre= obj.preOrder;
            $("#Area_Info").append('<tr><td width="20%">' + Area + '</td>' +
                    '<td width="16%">' + Order + '</td>' +
                    '<td width="16%">' + Book + '</td>' +
                    '<td width="16%">' + Use + '</td>' +
                    '<td width="16%">' + Pre + '</td>' +
                    '<td width="16%">' + PreUse + '</td></tr>'
            );

            areaData.push(Area);
//向柱状图里塞数据
          if(dataVal == 1) areaCount.push(Order);
          else if(dataVal == 2) areaCount.push(Book);
          else if(dataVal == 3) areaCount.push(Use);
        };
          /*if(dataVal == 1) $("#searchType").html("票务发布总量"),$("#activityCount").html(dayCount);
          else if(dataVal == 2) $("#searchType").html("活动预定量"),$("#activityCount").html(weekCount);
          else if(dataVal == 3) $("#searchType").html("活动入场量"),$("#activityCount").html(monthCount);*/
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
  <em>您现在所在的位置：</em>数据管理 &gt; 活动数据统计 &gt; 活动预约情况
</div>
<div class="site-title">活动预约情况</div>
<div class="in-content">
  <div class="search in-tit1">
    <h2>上海市各区县活动情况图</h2>
    <div class="select-box w110" id="activity-select-ul">
      <input type="hidden" name="type" id="type" value="1"/>
      <div class="select-text" data-value="1">票务发布总量</div>
      <ul class="select-option">
        <li data-option="1">票务发布总量</li>
        <li data-option="2">活动预定量</li>
        <li data-option="3">活动入场量</li>
      </ul>
    </div>
  </div>
  <div class="in-part1">
    <div class="in-part1-tip">
      <div class="txt1 fl">截至昨日数据统计，<%--<span id="searchType">本周</span>--%>各区县活动预订情况图</div>
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
    <h1>截至昨日数据统计，各区县活动预订情况表</h1>
    <div class="form-table">
      <a class="export" onclick="exportExcel();">导出</a>
      <input class="export" type="button" value="确定" onclick="doQuery( )"/>
      <div class="td-time" style="margin-top: 0px;">
        <div class="start w240" style="margin-left: 8px;">
          <span class="text">开始日期</span>
          <input type="hidden" id="startDateHidden"/>
          <input type="text" id="activityStartTime" name="activityStartTime" value="" readonly/>
          <i class="data-btn start-btn"></i>
        </div>
        <span class="txt" style="line-height: 42px;">至</span>
        <div class="end w240">
          <span class="text">结束日期</span>
          <input type="hidden" id="endDateHidden"/>
          <input type="text" id="activityEndTime" name="activityEndTime" value="" readonly/>
          <i class="data-btn end-btn"></i>
        </div>
      </div>
    </div>
  </div>
  <div class="in-container">
    <div id="totalStatistic"></div>
  </div>
  <div class="table-cont"  >
    <table width="100%" class="tab-data" id="Area_Info">
      <thead id="thead" class="tab-data">
      <tr>
        <td >区县</td>
        <td >票务发布总量</td>
        <td >活动预定量</td>
        <td >活动入场量</td>
        <td >活动预订率</td>
        <td >活动入场率</td>
      </tr>
      </thead>
    </table>
  </div>
</div>
</body>
</html>
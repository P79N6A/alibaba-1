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

    //** 获取数据
        function doQuery() {
          var activityStartTime
          var activityEndTime
          activityStartTime=$dp.$('activityStartTime').value
          activityEndTime=$dp.$('activityEndTime').value
          //** 清空表格
          $("#thead").next().remove();
          var dataVal = $("#activity-select-ul").find("input").val();
          var areaData = [];
          var areaCount = [];
          $.post("${path}/activityStatistics/queryTagCountInfo.do",{activityStartTime:activityStartTime,activityEndTime:activityEndTime}, function(data) {
            var list = eval(data);
            flag = true;
            for (var i = 0; i < list.length; i++) {
              var obj = list[i];
              var Name= obj.tagName;
              var Activity= obj.numActivity;
              var Look= obj.numLook;
          var Order= obj.numOrder;
          var Book= obj.bookOrder;
          var Pre= obj.preOrder;
            $("#Area_Info").append('<tr><td width="10%">' + Name + '</td>' +
                    '<td width="10%">' + Activity + '</td>' +
                    '<td width="10%">' + Look + '</td>' +
                    '<td width="10%">' + Order + '</td>' +
                    '<td width="10%">' + Book + '</td>' +
                    '<td width="10%">' + Pre + '%</td></tr>'
            );
            areaData.push(Name);
          if(dataVal == 1) areaCount.push(Activity);
          else if(dataVal == 2) areaCount.push(Look);
          else if(dataVal == 3) areaCount.push(Order);
          else if(dataVal == 4) areaCount.push(Book);
        }

        /*活动标签热度情况*/
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
          }]
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
<form id="activityTag" action="" method="post">
<div class="site">
  <em>您现在所在的位置：</em>数据管理 &gt; 活动数据统计 &gt; 活动标签热度
</div>
<div class="site-title">活动信息数据</div>
<div class="in-content">
  <div class="search in-tit1">
    <h2>活动标签热度图</h2>
    <div class="select-box w110" id="activity-select-ul">
      <input type="hidden" name="type" id="type" value="1"/>
      <div class="select-text" data-value="1">活动总数</div>
      <ul class="select-option">
        <li data-option="1">活动总数</li>
        <li data-option="2">活动浏览量</li>
        <li data-option="3">发布总票数</li>
        <li data-option="4">预订总票数</li>
      </ul>
    </div>
  </div>
  <div class="in-part1">
    <div class="in-part1-tip">
      <div class="legend fr">
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
    <h1>活动标签热度表</h1>
    <div class="form-table">
      <a class="export" onclick="exportactivityTagExcel();">导出</a>
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
        <td >活动标签</td>
        <td >活动总数</td>
        <td >活动浏览量</td>
        <td >发布总票数</td>
        <td >预订总票数</td>
        <td >预约百分比</td>
      </tr>
      </thead>
    </table>
  </div>
</div>
</form>
</body>
</html>
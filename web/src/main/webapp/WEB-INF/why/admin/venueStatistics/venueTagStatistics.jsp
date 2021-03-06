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
      location.href = "${path}/venueStatistics/exportVenueByTagExcel.do?" + $("#comment").serialize();
    }



    //** 日期控件
    $(function(){
      $(".start-btn").on("click", function(){
        WdatePicker({el:'startDateHidden',dateFmt:'yyyy-MM-dd',doubleCalendar:true,minDate:'',maxDate:'#F{$dp.$D(\'endDateHidden\')}',
          oncleared:function() {
            $("#activityStartTime").val("");
          },position:{left:-224,top:8},isShowOK:true,isShowToday:false,onpicked:pickedStartFunc})
      })
      $(".end-btn").on("click", function(){
        WdatePicker({el:'endDateHidden',dateFmt:'yyyy-MM-dd',doubleCalendar:true,minDate:'#F{$dp.$D(\'startDateHidden\')}',oncleared:function() {
          $("#activityEndTime").val("");
        },position:{left:-224,top:8},isShowOK:true,isShowToday:false,onpicked:pickedendFunc})
      })
    });

    function pickedStartFunc(){
      $dp.$('activityStartTime').value=$dp.cal.getDateStr('yyyy-MM-dd');
    }
    function pickedendFunc(){
      $dp.$('activityEndTime').value=$dp.cal.getDateStr('yyyy-MM-dd');
    }



    var flag = true;
    function doQuery() {

      var listType = $("#listType2").val();
      if(listType==2){
        window.location="${path}/venueStatistics/RoomTagStatisticsIndex.do";
      }
      var activityStartTime
      var activityEndTime
      activityStartTime=$dp.$('activityStartTime').value
      activityEndTime=$dp.$('activityEndTime').value
      var dataVal = $("#activity-select-ul").find("input").val();
      var areaData = [];
      var areaCount = [];
      $.post("${path}/venueStatistics/queryTagCountInfo.do",{activityStartTime:activityStartTime,activityEndTime:activityEndTime}, function(data) {     $("#thead1").next().remove();
        var list = eval(data);

        for (var i = 0; i < list.length; i++) {
          var obj = list[i];
          var Area= obj.tagName;
          var Venue= obj.numVenue;
          var Look= obj.numLook;
          var Room= obj.bookRoom;
          var Message= obj.venueMessage;

            $("#Area_Info").append('<tr><td width="10%">' + Area + '</td>' +
                    '<td width="10%">' + Venue + '</td>' +
                    '<td width="10%">' + Look + '</td>' +
                    '<td width="10%">' + Room + '</td>' +
                    '<td width="10%">' + Message + '</td></tr>'
            );

            areaData.push(Area);

          if(dataVal == 1) areaCount.push(Venue),$("#searchType").html("场馆数量");
          else if(dataVal == 2) areaCount.push(Look),$("#searchType").html("用户浏览量");
          else if(dataVal == 3) areaCount.push(Room),$("#searchType").html("预订活动室量");
          else if(dataVal == 4) areaCount.push(Message),$("#searchType").html("评论数");
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
<form id="comment" action="" method="post">
<div class="site">
  <em>您现在所在的位置：</em>数据管理 &gt; 场馆数据统计 &gt; 场馆标签热度
</div>
<div class="site-title">场馆信息数据</div>
<div class="in-content">
  <div class="search in-tit1">
    <h2>上海市各区县场馆情况图</h2>
    <div class="form-table">
      <div class="search">
        <div class="select-box w110" id="activity-select-ul">
          <input type="hidden" name="type" id="type" value="1"/>
          <div class="select-text" data-value="1">场馆数量</div>
          <ul class="select-option">
            <li data-option="1">场馆数量</li>
            <li data-option="2">用户浏览量</li>
            <li data-option="3">预订活动室量</li>
            <li data-option="4">评论数</li>
          </ul>
        </div>
        <div class="select-box w135">
          <input type="hidden" value="${listType2}" name="listType2" id="listType2"/>
          <div class="select-text" data-value="1">场馆</div>
          <ul class="select-option">
            <li data-option="1">场馆</li>
            <li data-option="2">活动室</li>
          </ul>
        </div>
      </div>
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
      <thead id="thead1" class="tab-data">
      <tr>
        <td >场馆标签</td>
        <td >场馆数量</td>
        <td >用户浏览量</td>
        <td >预订活动室量</td>
        <td >评论数</td>
      </tr>
      </thead>
    </table>
  </div>
</div>
  </form>
</body>
</html>
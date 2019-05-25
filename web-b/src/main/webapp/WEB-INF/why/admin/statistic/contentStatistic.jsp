<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <title>会员数据统计--文化云</title>
  <%@include file="../../common/pageFrame.jsp"%>
  <script type="text/javascript" src="${path}/STATIC/js/jquery.epiclock.js"></script>
  <script type="text/javascript" src="${path}/STATIC/js/highcharts/highcharts.js"></script>
  <script type="text/javascript" src="${path}/STATIC/js/highcharts/exporting.js"></script>
  <script type="text/javascript">
    $(function() {
      $('#epiClock').epiclock({
        //format : ' Y-F-j　G:i:s'
        format : ' Y-F-j　G:i:s'
      }); //绑定
      $.epiclock(); //开始运行

      //----------------****************场馆数据
      var venueCategories = '${venueCategories}';
      var venueCategoriesArr = venueCategories.split(",");
      var venueData = '${venueData}';
      var venueDataArr = venueData.split(",");
      var venueCategoriesData = [];
      var venueTotal = 0;
      if(venueData.length > 0){
          $.each(venueDataArr,function(i,v){
            var count = parseInt(v,10);
            venueTotal = venueTotal + count;
            venueCategoriesData.push(count);
          });
      }
      $("#venueTotal").html(venueTotal);
      //----------------****************藏品数据
      var antiqueCategories = '${antiqueCategories}';
      var antiqueCategoriesArr = antiqueCategories.split(",");
      var antiqueData = '${antiqueData}';
      var antiqueDataArr = antiqueData.split(",");
      var antiqueCategoriesData = [];
      var antiqueTotal = 0;
      if(antiqueData.length > 0) {
          $.each(antiqueDataArr, function (i, v) {
            var count = parseInt(v, 10);
            antiqueTotal = antiqueTotal + count;
            antiqueCategoriesData.push(count);
          });
      }
      $("#antiqueTotal").html(antiqueTotal);
      //----------------****************活动室数据
      var roomCategories = '${roomCategories}';
      var roomCategoriesArr = roomCategories.split(",");
      var roomData = '${roomData}';
      var roomDataArr = roomData.split(",");
      var roomCategoriesData = [];
      var roomTotal = 0;
      if(roomData.length > 0) {
          $.each(roomDataArr, function (i, v) {
            var count = parseInt(v, 10);
            roomTotal = roomTotal + count;
            roomCategoriesData.push(count);
          });
      }
      $("#roomTotal").html(roomTotal);

      /*场馆数据统计*/
      $('#venuesData').highcharts({
        chart: {
          backgroundColor: '#F4F6F7',
          type: 'column'
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
          categories: venueCategoriesArr,
          title: {
            enabled: false
          },
          labels: {
            style: {color: '#142340', fontWeight: 'bold', fontFamily: '微软雅黑'}
          },
          lineWidth: 4,
          lineColor: '#374E65',
          tickLength: 0
        },
        yAxis: {
          min: 0,
          title: {
            text: ''
          },
          labels: {
            style: {color: '#142340', fontWeight: 'bold', fontFamily: '微软雅黑'}
          },
          gridLineColor: '#D9E1E6' //网格线颜色
        },
        tooltip: {
          shared: true
        },
        plotOptions: {
          column: {
            pointPadding: 0.2,
            borderWidth: 0
          }
        },
        series: [{
          name: '场馆数量',
          data: venueCategoriesData
        }]
      });
      /*场馆藏品数据统计*/
      $('#collectionData').highcharts({
        chart: {
          backgroundColor: '#F4F6F7',
          type: 'column'
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
          categories: antiqueCategoriesArr,
          title: {
            enabled: false
          },
          labels: {
            style: {color: '#142340', fontWeight: 'bold', fontFamily: '微软雅黑'}
          },
          lineWidth: 4,
          lineColor: '#374E65',
          tickLength: 0
        },
        yAxis: {
          min: 0,
          title: {
            text: ''
          },
          labels: {
            style: {color: '#142340', fontWeight: 'bold', fontFamily: '微软雅黑'}
          },
          gridLineColor: '#D9E1E6' //网格线颜色
        },
        tooltip: {
          shared: true
        },
        plotOptions: {
          column: {
            pointPadding: 0.2,
            borderWidth: 0
          }
        },
        series: [{
          name: '藏品数量',
          data: antiqueCategoriesData
        }]
      });
      /*活动室数据统计*/
      $('#roomData').highcharts({
        chart: {
          backgroundColor: '#F4F6F7',
          type: 'column'
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
          categories: roomCategoriesArr,
          title: {
            enabled: false
          },
          labels: {
            style: {color: '#142340', fontWeight: 'bold', fontFamily: '微软雅黑'}
          },
          lineWidth: 4,
          lineColor: '#374E65',
          tickLength: 0
        },
        yAxis: {
          min: 0,
          title: {
            text: ''
          },
          labels: {
            style: {color: '#142340', fontWeight: 'bold', fontFamily: '微软雅黑'}
          },
          gridLineColor: '#D9E1E6' //网格线颜色
        },
        tooltip: {
          shared: true
        },
        plotOptions: {
          column: {
            pointPadding: 0.2,
            borderWidth: 0
          }
        },
        series: [{
          name: '活动室数量',
          data: roomCategoriesData
        }]
      });
    });
  </script>
</head>
<body>
<div class="site">
  <em>您现在所在的位置：</em>数据管理 &gt; 平台内容统计
</div>
<div class="site-title">平台内容统计</div>
<div class="in-content">
  <div class="search in-tit1">
    <h2>场馆数据统计</h2>
  </div>
  <div class="in-part1">
    <div class="in-part1-tip">
      <div class="txt1 fl">截至昨日数据统计，文化云平台共有场馆 <span class="red" id="venueTotal"></span> 个</div>
    </div>
    <div class="in-container">
      <div id="venuesData"></div>
    </div>
  </div>
</div><div class="in-content">
  <div class="search in-tit1">
    <h2>场馆藏品数据统计</h2>
  </div>
  <div class="in-part1">
    <div class="in-part1-tip">
      <div class="txt1 fl">截至昨日数据统计，文化云平台共有藏品 <span class="red" id="antiqueTotal"></span> 件</div>
    </div>
    <div class="in-container">
      <div id="collectionData"></div>
    </div>
  </div>
</div><div class="in-content">
  <div class="search in-tit1">
    <h2>活动室数据统计</h2>
  </div>
  <div class="in-part1">
    <div class="in-part1-tip">
      <div class="txt1 fl">截至昨日数据统计，文化云平台共有活动室 <span class="red" id="roomTotal"></span> 间</div>
    </div>
    <div class="in-container">
      <div id="roomData"></div>
    </div>
  </div>
</div>
</body>
</html>
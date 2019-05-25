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
  <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
  <script type="text/javascript" src="${path}/STATIC/js/jquery.epiclock.js"></script>
  <script type="text/javascript" src="${path}/STATIC/js/highcharts/highcharts.js"></script>
  <script type="text/javascript" src="${path}/STATIC/js/highcharts/exporting.js"></script>
  <script type="text/javascript">
    $(function() {
      selectModel();
      $('#epiClock').epiclock({
        //format : ' Y-F-j　G:i:s'
        format : ' Y-F-j　G:i:s'
      }); //绑定
      $.epiclock(); //开始运行
      setPieHeight();  //设置饼图的高度

      /*highcharts*/
      $('#UserRegister').highcharts({
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
          categories: ['周一', '周二', '周三', '周四', '周五', '周六', '周日'],
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
          data: [75, 106, 116, 64, 76, 65, 63],
          tooltip: {
            valueSuffix: ''
          }

        }, {
          name: '环比趋势',
          color: '#ED3838',
          type: 'spline',
          data: [7.0, 8.0, 11.0, 11.5, 8.5, 7.0, 2.5],
          tooltip: {
            valueSuffix: '%'
          }
        }]
      });

      /*会员年龄分布*/
       var userAgeList = '${userAgeDate}';
       var userAgeData = userAgeList.split(",");
       var ageData = new Array();
       $.each(userAgeData,function(i,v){
         if(v != undefined && v != ""){
           var age = v.split("-");
           var arr = new Array();
           arr.push(age[0]);
           arr.push(parseInt(age[1],10));
           ageData.push(arr);
         }
       });
      $('#userAgePie').highcharts({
        chart: {
          backgroundColor: '#ECF0F2',
          plotBackgroundColor: null,
          plotBorderWidth: null,
          plotShadow: false
        },
        title: {
          text: ''
        },
        exporting: {
          enabled: false  //去掉打印按钮
        },
        credits: {
          enabled: false  //去掉官网链接
        },
        tooltip: {
          pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
        },
        plotOptions: {
          pie: {
            allowPointSelect: true,  //点击饼图放大
            cursor: 'pointer',
            dataLabels: {
              enabled: true,
              color: '#000000',
              connectorColor: '#000000',
              format: '<b>{point.name}</b>: {point.percentage:.1f} %'
            },
            showInLegend: true  //地图图例
          }
        },
        series: [{
          type: 'pie',
          name: '百分比',
          data: ageData
        }]
      });

      /*会员性别分布*/
      var userSexList = '${userSexDate}';
      var userSexData = userSexList.split(",");
      var sexData = new Array();
      $.each(userSexData,function(i,v){
        if(v != undefined && v != ""){
          var sex = v.split("-");
          var arr = new Array();
          arr.push(sex[0]);
          arr.push(parseInt(sex[1],10));
          sexData.push(arr);
        }
      });
      $('#userSexPie').highcharts({
        chart: {
          backgroundColor: '#F4F6F7',
          plotBackgroundColor: null,
          plotBorderWidth: null,
          plotShadow: false
        },
        title: {
          text: ''
        },
        exporting: {
          enabled: false  //去掉打印按钮
        },
        credits: {
          enabled: false  //去掉官网链接
        },
        tooltip: {
          pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
        },
        plotOptions: {
          pie: {
            allowPointSelect: true,  //点击饼图放大
            cursor: 'pointer',
            dataLabels: {
              enabled: true,
              color: '#000000',
              connectorColor: '#000000',
              format: '<b>{point.name}</b>: {point.percentage:.1f} %'
            },
            showInLegend: true  //地图图例
          }
        },
        series: [{
          type: 'pie',
          name: '百分比',
          data: sexData
        }]
      });
      /*会员登陆渠道分布*/
      function getUserLogin(type){
        var userLoginDataArr = new Array();
        $.ajax({
          type: "POST",
          url: "${path}/userLoginStatistic/userLoginStatistic.do",
          data: {type:type},
          async:false,
          success: function(data){
            if(data != undefined && data != ""){
              var userLoginData = data.split(",");
              $.each(userLoginData,function(i,v){
                if(v != undefined && v != ""){
                  var userLogin = v.split("-");
                  var arr = new Array();
                  arr.push(userLogin[0]);
                  arr.push(parseInt(userLogin[1],10));
                  userLoginDataArr.push(arr);
                }
              });
            }
          }
        });
        return userLoginDataArr;
      }

      userLogin(getUserLogin(1));

      $("#userLoginUl li").mousedown(function(){
        userLogin(getUserLogin($(this).attr("data-option")));
      });

      function userLogin(userLoginArr){
        $('#userLoginMode').highcharts({
          chart: {
            backgroundColor: '#F4F6F7',
            plotBackgroundColor: null,
            plotBorderWidth: null,
            plotShadow: false
          },
          title: {
            text: ''
          },
          exporting: {
            enabled: false  //去掉打印按钮
          },
          credits: {
            enabled: false  //去掉官网链接
          },
          tooltip: {
            pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
          },
          plotOptions: {
            pie: {
              allowPointSelect: true,  //点击饼图放大
              cursor: 'pointer',
              dataLabels: {
                enabled: true,
                color: '#000000',
                connectorColor: '#000000',
                format: '<b>{point.name}</b>: {point.percentage:.1f} %'
              },
              showInLegend: true  //地图图例
            }
          },
          series: [{
            type: 'pie',
            name: '百分比',
            data: userLoginArr
          }]
        });
      }

      /*会员每周平均订票率分布*/
      function getUserOrder(type){
        var userOrderDataArr = new Array();
        $.ajax({
          type: "POST",
          url: "${path}/userOrderStatistic/userOrderStatistic.do",
          data: {type:type},
          async:false,
          success: function(data){
            if(data != undefined && data != ""){
              var userOrderData = data.split(",");
              $.each(userOrderData,function(i,v){
                if(v != undefined && v != ""){
                  var userOrder = v.split("@");
                  var arr = new Array();
                  arr.push(userOrder[0]);
                  arr.push(parseFloat(userOrder[1]));
                  userOrderDataArr.push(arr);
                }
              });
            }
          }
        });
        return userOrderDataArr;
      }

      userOrder(getUserOrder(1));

      $("#userOrderUl li").mousedown(function(){
        userOrder(getUserOrder($(this).attr("data-option")));
      });

      function userOrder(userOrderArr){
        $('#userBookRate').highcharts({
          chart: {
            backgroundColor: '#ECF0F2',
            plotBackgroundColor: null,
            plotBorderWidth: null,
            plotShadow: false
          },
          title: {
            text: ''
          },
          exporting: {
            enabled: false  //去掉打印按钮
          },
          credits: {
            enabled: false  //去掉官网链接
          },
          tooltip: {
            pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
          },
          plotOptions: {
            pie: {
              allowPointSelect: true,  //点击饼图放大
              cursor: 'pointer',
              dataLabels: {
                enabled: true,
                color: '#000000',
                connectorColor: '#000000',
                format: '<b>{point.name}</b>: {point.percentage:.1f} %'
              },
              showInLegend: true  //地图图例
            }
          },
          series: [{
            type: 'pie',
            name: '百分比',
            data: userOrderArr
          }]
        });
      }


    });

    $(window).resize(function(){
      setPieHeight();  //设置饼图的高度
    });

    function setPieHeight(){
      var winW = $(window).width();
      $(".pie-box>div").css({"height": Math.min(Math.floor(winW*0.4),550)});
    }
  </script>
</head>
<body>
<div class="site">
  <em>您现在所在的位置：</em>数据管理 &gt; 会员数据统计
</div>
<div class="site-title">会员数据统计</div>
<div class="in-content">
  <div class="search in-tit1">
    <h2>截至昨日数据统计，安康文化云注册会员共有 <span class="red">${userStatistics.sCount}</span> 人</h2>
    <%--<div class="select-box w110">
      <input type="hidden"/>
      <div class="select-text" data-value="">本周</div>
      <ul class="select-option">
        <li data-option="1">本周</li>
        <li data-option="2">本月</li>
        <li data-option="3">本季度</li>
        <li data-option="4">本年</li>
      </ul>
    </div>--%>
  </div>
  <%--<div class="in-part1">
    <div class="in-part1-tip">
      <div class="txt1 fl">截至昨日数据统计，安康文化云注册会员共有 <span class="red">${userStatistics.sCount}</span> 个</div>
      &lt;%&ndash;<div class="legend fr">
        <span><i class="icon1"></i><em>环比变化曲线图</em></span>
        <span><i class="icon2"></i><em>会员注册统计柱状图</em></span>
      </div>&ndash;%&gt;
    </div>
    &lt;%&ndash;<div class="in-container" id="UserRegister"></div>&ndash;%&gt;
  </div>--%>
  <div class="in-part2">
    <div class="pie-part pie-part1">
      <div class="search in-tit1">
        <h2>安康文化云会员年龄分布图（以注册时勾选为主）</h2>
      </div>
      <div class="pie-box pie-box1">
        <div id="userAgePie">

        </div>
      </div>
    </div>
    <div class="pie-part pie-part2">
      <div class="search in-tit1">
        <h2>安康文化云会员性别分布图（以注册时勾选为主）</h2>
      </div>
      <div class="pie-box">
        <div id="userSexPie"></div>
      </div>
    </div>
  </div>
  <div class="in-part2">
    <div class="pie-part pie-part2">
      <div class="search in-tit1">
        <h2>安康文化云会员登录渠道分布图</h2>
        <div class="select-box w110">
          <input type="hidden" value="1"/>
          <div class="select-text" data-value="">周</div>
          <ul class="select-option" id="userLoginUl">
            <li data-option="1">周</li>
            <li data-option="2">月</li>
            <li data-option="3">季度</li>
            <li data-option="4">年</li>
          </ul>
        </div>
      </div>
      <div class="pie-box pie-box1">
        <div id="userLoginMode">

        </div>
      </div>
    </div>
    <div class="pie-part pie-part1">
      <div class="search in-tit1">
        <h2>安康文化云会员每周平均订票率分布图</h2>
        <div class="select-box w110">
          <input type="hidden"/>
          <div class="select-text" data-value="">周</div>
          <ul class="select-option" id="userOrderUl">
            <li data-option="1">周</li>
            <li data-option="2">月</li>
            <li data-option="3">季度</li>
            <li data-option="4">年</li>
          </ul>
        </div>
      </div>
      <div class="pie-box">
        <div id="userBookRate"></div>
      </div>
    </div>
  </div>
</div>
</body>
</html>
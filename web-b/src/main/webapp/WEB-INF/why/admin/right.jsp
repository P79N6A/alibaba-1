<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%
  String path = request.getContextPath();
  request.setAttribute("path", path);
  String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <%@include file="/WEB-INF/why/common/limit.jsp"%>
  <title>首页--文化云</title>
  <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/reset.css"/>
  <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/main.css"/>

  <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/main-ie.css"/>

  <script type="text/javascript" src="${path}/STATIC/js/jquery.min.js"></script>
  <script type="text/javascript" src="${path}/STATIC/js/base.js"></script>
  <script type="text/javascript" src="${path}/STATIC/js/jquery.epiclock.js"></script>
  <script type="text/javascript" src="${path}/STATIC/js/highcharts/highcharts.js"></script>
  <script type="text/javascript" src="${path}/STATIC/js/highcharts/exporting.js"></script>
  <script type="text/javascript">

      function doQuery() {
          var labelNames = new Array();
          var labelCount = new Array();
          $.post("${path}/activityStatistics/queryRightIndex.do",{"area" : $("#area").val()}, function(rsData) {
              var map = eval(rsData);
              var names =map.names;
              var counts = map.counts;
              if (names != undefined) {
                  labelNames = names.split(",");
                  labelCount = counts.split(",");
                  for (var i = 0;i < labelCount.length;i++) {
                      labelCount[i] = parseInt(labelCount[i]);
                  }
              }

              /*文化云平台整体数据统计*/
              $('#dataStatistic').highcharts({
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
                      categories: labelNames,
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
                      /*backgroundColor: 'rgba(0, 0, 0, 0.6)',
                       borderWidth: 0,
                       borderRadius: 4,
                       shadow: false,
                       shared: true,
                       useHTML: true,
                       valueSuffix: '',
                       headerFormat: '',
                       pointFormat: '<span style="color: #FFFFFF"> {point.y}</span>'*/
                  },
                  plotOptions: {
                      column: {
                          pointPadding: 0.2,
                          borderWidth: 0
                      }
                  },
                  series: [{
                      name: '数量',
                      data: labelCount

                  }]
              });
          });
      }


      $(function() {

          $('#epiClock').epiclock({
              //format : ' Y-F-j　G:i:s'
              format : ' Y-F-j　G:i:s'
          }); //绑定
          $.epiclock(); //开始运行

          doQuery();
      });

      //
      $(function() {
          selectModel();
      });
  </script>
</head>
<body>
<div class="site">
  <em>您现在所在的位置：</em>首页
</div>
<div class="site-title">当前时间：<span id="epiClock"></span>
</div>
<div>

  <div class="select-box w110">
    <div>
      <%--<select name="area" id="area" onchange="doQuery()">--%>
      <%--<option value="${sessionScope.user.userCounty}"> ${fn:split(sessionScope.user.userCounty,',')[1]}</option>--%>

      <%--</select>--%>
    </div>
  </div>

</div>
<div class="in-content">

  <%--2015.10.16--%>
  <div class="add_btn_do">
    <%if(activityPublishButton){%>
    <a href="${path}/activity/preAddActivity.do"><img src="${path}/STATIC/image/add_icon2.png" width="132" height="132" /></a>
    <%}%>
    <%if(addVenueButton){%>
    <a href="${path}/venue/preAddVenue.do"><img src="${path}/STATIC/image/add_icon3.png" width="132" height="132" /></a>
    <%}%>
    <%if(terminalAddButton){%>
    <a href="${path}/terminalUser/preAddTerminalUser.do"><img src="${path}/STATIC/image/add_icon1.png" width="132" height="132" /></a>
    <%}%>
  </div>
  <%--2015.10.16--%>


  <div class="search in-tit1">
    <h2>截至昨日统计数据，文化云平台整体数据情况：</h2>

    <div class="select-box w110">
      <input type="hidden"  name="area" id="area" />
      <div class="select-text" data-value="${sessionScope.user.userCounty}">${fn:split(sessionScope.user.userCounty,',')[1]}</div>
      <ul class="select-option" onmouseleave="doQuery()">
        <!-- <li data-option="45,上海市">上海市</li>
        <li data-option="46,黄浦区">黄浦区</li>
        <li data-option="48,徐汇区">徐汇区</li>
        <li data-option="49,长宁区">长宁区</li>
        <li data-option="50,静安区">静安区</li>
        <li data-option='51,普陀区'>普陀区</li>
        <li data-option='52,闸北区'>闸北区</li>
        <li data-option='53,虹口区'>虹口区</li>
        <li data-option='54,杨浦区'>杨浦区</li>
        <li data-option='56,宝山区'>宝山区</li>
        <li data-option='55,闵行区'>闵行区</li>
        <li data-option='57,嘉定区'>嘉定区</li>
        <li data-option='58,浦东新区'>浦东新区</li>
        <li data-option='60,松江区'>松江区</li>
        <li data-option='59,金山区'>金山区</li>
        <li data-option='61,青浦区'>青浦区</li>
        <li data-option='63,奉贤区'>奉贤区</li>
        <li data-option='64,崇明县'>崇明县</li> -->
      </ul>
    </div>



  </div>
  <div class="in-part1">
    <div class="in-container">
      <div id="dataStatistic"></div>
    </div>
  </div>
  <%--<div class="in-tit2"><h3>当前版本提示</h3></div>
  <div class="in-article">
    <p>当前版本为云平台“文化上海云”一期稳定版，此版本提供<a href="#">场馆信息</a>，<a href="#">活动信息</a>，<a href="#">藏品信息</a>，<a href="#">活动室信息管理</a>的基础上传，编辑，删除在内的信息发布功能体系。</p>
    <p>为各区县后台管理者分配对应的分系统管理权限，分系统管理员可对本区县数据进行管理，市级管理员可整体统筹数据的权限管理系统。</p>
    <p>为满足各区县对信息以及用户行为的大数据分析，此版本提供云端信息汇总，分析，以及实时平台数据调用，包括用户访问渠道，用户活跃率、活动，场馆的发布情况等云端统计系统。</p>
    <p>同时，所有区县信息也将自动推送至文化上海总平台，为用户提供集中展示，索引信息的服务。更多使用请下载<a href="#">后台管理使用说明</a>。</p>
  </div>
  <div class="in-tit2"><h3>开发团队联系及反馈方式</h3></div>
  <div class="in-article">
    <p>上海创图科技网络发展有限公司&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;版权所有</p>
    <p>联系地址：上海市广中西路777弄，10号楼3楼</p>
    <p>联系电话：021-36696098</p>
  </div>--%>
</div>
</body>
</html>
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
 <script type="text/javascript" src="${path}/STATIC/js/DatePicker/WdatePicker.js"></script>
  <script type="text/javascript" src="${path}/STATIC/js/jquery.min.js"></script>
  <script type="text/javascript" src="${path}/STATIC/js/base.js"></script>
  <script type="text/javascript" src="${path}/STATIC/js/jquery.epiclock.js"></script>
  <script type="text/javascript" src="${path}/STATIC/js/highcharts/highcharts.js"></script>
  <script type="text/javascript" src="${path}/STATIC/js/highcharts/exporting.js"></script>
  <script type="text/javascript">

    function doQuery() {
    	if ($('#activityCreateTime').val() == ''){
    		return;
    	}
      var labelNames = new Array();
      var labelpvCount = new Array();
      var labeluvCount = new Array();
      var labelipCount = new Array();
      $.post("${path}/Statistic/flowWebStatisticIndex.do",{"time" : $("#activityCreateTime").val()}, function(rsData) {
        var map = eval('('+rsData+')');
        var list = map.resultList;
        for (var i=0;i<list.length;i++){
        	var item = list[i];
        	labelNames.push(item.time);
        	labelpvCount.push(Number(item.pvcount));
        	labeluvCount.push(Number(item.uvcount));
        	labelipCount.push(Number(item.ipcount));
        }
        statistic(labelNames,labelpvCount,labeluvCount,labelipCount);
      });
    }
    
    function statistic(labelNames,labelpvCount,labeluvCount,labelipCount){
        /*文化云平台整体数据统计*/
        $('#dataStatistic').highcharts({
          chart: {
            backgroundColor: '#F4F6F7',
            type: 'column'
          },
          title: {
            text: 'web流量统计(日)'
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
              style: {color: '#142340', fontWeight: 'bold', fontFamily: '微软雅黑'},
              rotation:-45,
              fontStyle:'italic'
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
        
              shared: true,
             
          },
          plotOptions: {
            column: {
              pointPadding: 0.2,
              borderWidth: 0
            }
          },
          series: [
          {
            name: 'pv',
            data: labelpvCount,
          },
          {
        	name:'uv',
        	data:labeluvCount,
          },
          {
          	name:'ip',
          	data:labelipCount,
           }
          ]
        });
    }
    
    function mouthList(){
    	if ($('#year').val() == ''){
    		return;
    	}
    	 var labelNames = new Array();
         var labelpvCount = new Array();
         var labeluvCount = new Array();
         var labelipCount = new Array();
         $.post("${path}/Statistic/flowWebStatisticyearIndex.do",{"year" : $("#year").val()}, function(rsData) {
           var map = eval('('+rsData+')');
           var list = map.resultList;
           for (var i=0;i<list.length;i++){
           	var item = list[i];
           	labelNames.push(item.time);
           	labelpvCount.push(Number(item.pvcount));
        	labeluvCount.push(Number(item.uvcount));
        	labelipCount.push(Number(item.ipcount));
           }
           /*文化云平台整体数据统计*/
           $('#dataStatisticMouth').highcharts({
             chart: {
               backgroundColor: '#F4F6F7',
               type: 'column'
             },
             title: {
               text: 'web流量统计(月)'
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
                 style: {color: '#142340', fontWeight: 'bold', fontFamily: '微软雅黑'},
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
             series: [
                      {
            name: 'pv',
            data: labelpvCount,
          },
          {
        	name:'uv',
        	data:labeluvCount,
          },
          {
          	name:'ip',
          	data:labelipCount,
           }   
                     ]
           });
           
    });
   }
    
    function grandChange(){
    	var type=$('#webStatistic option:selected') .val();
    	if(type=='Wap'){
    		window.location.href ="../Statistic/flowStatistic.do"
    	}
    }

    $(function() {
    	if($("#activityCreateTime").val()==undefined || $("#activityCreateTime").val()=="" ){
    		
    		$('#activityCreateTime').val((new Date()).getFullYear() + '-' + (((new Date()).getMonth() + 1) < 10 ? '0' + ((new Date()).getMonth() + 1) : ((new Date()).getMonth() + 1)));
    	}
    	
    	$('#activityCreateTime').bind('focus', function () {
            WdatePicker({
                dateFmt:'yyyy-MM',
                minDate:'%y-{%M-12}',
                maxDate:'%y-{%M+11}',
                onpicked:function () {
                	$('#activityCreateTime').val($dp.cal.getP('y')+'-'+$dp.cal.getP('M'));
                }
            });
            $("#dataStatisticMouth").hide();
            $("#dataStatistic").show();
            doQuery();
        });
    	$('#year').bind('focus', function () {
    		WdatePicker({
            	skin:'default',
                dateFmt:'yyyy',
                minDate:'1900',
                maxDate:'2099',
                onpicked:function () {
                	$('#year').val($dp.cal.getP('y'));
                }
            });
    		var yeard= $('#year').val();
            $('#year').val(yeard.substring(0,4));
            $("#dataStatistic").hide();
            $("#dataStatisticMouth").show();
    		mouthList();
        });
      $('#epiClock').epiclock({
        //format : ' Y-F-j　G:i:s'
        format : ' Y-F-j　G:i:s'
      }); //绑定
      $.epiclock(); //开始运行
      doQuery();
    });

  </script>
</head>
<body>
<div class="site">
  <em>您现在所在的位置：</em>数据统计>>流量统计>web流量统计
</div>
<div class="site-title">当前时间：<span id="epiClock"></span></div>
<div class="in-content">
    <div class="search in-tit1">
    	<div class="td-time" style="margin-top: 0px;">
	       <div class="start" style="margin-left: 20px;width: 700px;height: 42px;">
	           <input type="radio" name="test" onclick="$('#test1').show();$('#test2').hide();" checked="checked"/>按日&nbsp;&nbsp;&nbsp;<input type="radio" name="test" onclick="$('#test2').show();$('#test1').hide();" />按月&nbsp;&nbsp;&nbsp;&nbsp;
	           <span id="test1">按日：<input type="text" id="activityCreateTime" name="activityCreateTime" value='' readonly style="border:1px solid #dcdcdc;width:178px;height: 28px;padding: 0 6px;background:#fff url(${path}/STATIC/image/data-icon1.png) no-repeat right 6px top 50%;"/></span>
          	   <span id="test2" style="display:none;">按月：<input type="text" id="year" name="year" value='' readonly style="border:1px solid #dcdcdc;width:178px;height: 28px;padding: 0 6px;background:#fff url(${path}/STATIC/image/data-icon1.png) no-repeat right 6px top 50%;"/></span>
                          类别：<select id="webStatistic" onchange="grandChange()" style="width:180px;height:30px;border:1px solid #dcdcdc;">
                    <option value="Wap">Wap</option>
                    <option value="Web" selected = "selected">Web</option>
               </select>
	       </div>
	    </div>
  </div>
  <div class="in-part1">
    <div class="in-container">
        <div id="dataStatistic"></div>
        <div id="dataStatisticMouth"></div>
    </div>
  </div>
</div>
</body>
</html>
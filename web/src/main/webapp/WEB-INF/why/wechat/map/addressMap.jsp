<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" id="map_html">
<head>
<title>详细地址</title>
<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wx/css/reset-mc.css" />
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wx/css/mc-mobile.css" />
<script type="text/javascript" src="${path}/STATIC/wx/js/mc-mobile.js"></script>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>
</head>
<body class="map_body">
	<%-- <div class="header">
		<div class="index-top">
			<span class="index-top-5">
				<img src="${path}/STATIC/wechat/image/arrow1.png" onclick="history.go(-1);"/>
			</span>
			<span class="index-top-2">详细地址</span>
		</div>
	</div> --%>
	<div class="map_container" id="mapContainer"></div>
</body>
</html>

<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=7bq0ISXbRLNBthNB3qzakG6g"></script>
<script type="text/javascript">
	var lat = ${lat};
    var lon = ${lon};
    // 百度地图API功能
    var map = new BMap.Map("mapContainer");            // 创建Map实例
    map.enableScrollWheelZoom();// 启用地图滚轮放大缩小
    var point = new BMap.Point(lon,lat);
    
    //坐标转换完之后的回调函数
    translateCallback = function (data){
      if(data.status === 0) {
    	var myIcon = new BMap.Icon("${path}/STATIC/wx/image/map-activity.png", new BMap.Size(46,60));
        var marker = new BMap.Marker(data.points[0],{icon:myIcon});
        map.addOverlay(marker);
        map.centerAndZoom(data.points[0],17);
      }
    }
    
    setTimeout(function(){
        var convertor = new BMap.Convertor();
        var pointArr = [];
        pointArr.push(point);
        convertor.translate(pointArr, 3, 5, translateCallback)
    }, 1000);
</script>
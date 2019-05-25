<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>文化地图</title>
  <!-- 导入头部文件 start -->
  <%@include file="/WEB-INF/why/common/frontIndexPageFrame.jsp"%>
  	<link type="text/css" rel="stylesheet" href="${path}/STATIC/css/normalize.css" />
	<link type="text/css" rel="stylesheet" href="${path}/STATIC/css/style.css" />
	<link type="text/css" rel="stylesheet" href="${path}/STATIC/css/styleChild.css" />
	<script src="http://webapi.amap.com/maps?v=1.3&key=a5b9a436f67422826aef2f4cb7e36910&plugin=AMap.AdvancedInfoWindow"></script>
</head>
<body>
<div class="fsMain">
  
  <%@include file="../header.jsp" %>
	
     <ul class="filterTypeUl clearfix " id="tagList">
		<li class="cur" venueType="">全部</li>
	</ul>
	<div class="cultureMap" id="cultureMap" style="margin-bottom: 40px;">
		<div class="mapSear clearfix">
			<input class="txt" type="text" id="venueName" name="venueName" placeholder="请输入场馆名称" />
			<span class="close" onclick="$(this).siblings('.txt').val('');"></span>
			<span class="ssBtn" onclick="loadData()"></span>
		</div>
	</div>
</div>
<%@include file="/WEB-INF/why/index/footer.jsp" %>
</body>
<script type="text/javascript">
	var infoJson;
	//初始化地图，只需要初始化一次
	var culMapInit;
	var infoMapWindow;
	var markerObject;
	var infoWindowVerticalOffset;
	$(function () {
        $("#pageName").html("所在位置：文化地图");
		culMapInit = initMap();
		toLoadTag();
		// 筛选
 		$('.filterTypeUl').on('click', 'li', function () {
 			$(this).parent().find('li').removeClass('cur');
 			$(this).addClass('cur');
 			loadData();
 		});
		// 切换
		$('body').on('click', '.culNav span', function () {
			$(this).addClass('cur').siblings().removeClass('cur');
			$('.culContWc .culCont').hide();
			if($(this).index() == 0){
				markerClick(markerObject);
			}else{
				showRoomInfo();
			}
			//$('.culContWc .culCont').eq($(this).index()).show();
		});
		$("#cultureMapIndex").addClass('cur').siblings().removeClass('cur');
	});
	// 初始化地图
	function initMap() {
		// 初始化地图
		var map = new AMap.Map("cultureMap", {
			// 地图缩放
			zoomEnable: true,
			resizeEnable: false,
			zoom: 15
			// 设置中心点
			// center:[121.438199, 31.284143],
		});
		return map;
	}
	function toLoadTag(){
		 $.post("${path}/wechatVenue/venueTagByType.do", function (data) {
	         if (data.data.length > 0) {
	             $.each(data.data, function (i, dom) {
	                 $("#tagList").append('<li venueType='+dom.tagId+'><a href="javascript:;">'+dom.tagName+'</a></li>');
	             });
	            loadData();
	         }
	     }, "json");
	}
	function loadData(){
		var data = {
		    venueType: $("#tagList li.cur").attr("venueType"),
		    venueName: $("#venueName").val()
		}
		$.post("${path}/wechatVenue/queryVenueByType.do",data, function (data) {
			if(data.status==1){
				infoJson = new Array();
				$.each(data.data, function (i, dom) {
						infoJson.push({
		                    'venueId' : dom.venueId,
		                    'venueName' : dom.venueName,
		                    'venueAddress' : dom.venueAddress,
		                    'venueLat' : dom.venueLat,
		                    'venueLon': dom.venueLon,
		                    'venueIconUrl': dom.venueIconUrl
		                });
					
				});
				loadMap(culMapInit,infoJson);
			}
		}, "json");
	}
	// 地图上添加单个点
	function addMarket(map, pos, zx, id) {
		var marker = new AMap.Marker({
			map: map,
			position: pos,
			extData:id
		});
		
		if(typeof zx == 'undefined') {
			marker.setContent('<img src="${path}/STATIC/image/child/hp_site.png"/>');
		} else {
			if(zx == 'center') {
				// 是中心点
				marker.setContent('<img src="${path}/STATIC/image/child/hp_sites.png"/>');
				map.setCenter(pos);
			} else {
				// 不是是中心点
				marker.setContent('<img src="${path}/STATIC/image/child/hp_site.png"/>');
			}
		}
		return marker;
	}
	// 信息提示窗
    function markerClick(e) {
        var venueId=e.target.getExtData()[0];
        var venueName=e.target.getExtData()[1];
        markerObject = e;
    	var aa = '<div class="fs-cultureMapInfo">'+
		'<div class="tit"><span>' +venueName+ '</span><a href="javascript:toVenueDetail(\''+venueId+'\');">场馆详情&nbsp;&gt;&gt;</a></div>' +
		'<div class="culNav clearfix"><span class="cur">相关活动</span><span>场馆预约</span><em></em></div>' +
		'<div class="culContWc">' + 
			'<div class="culCont">' +
			'<ul class="culActVenList" id="activityList">';
        
		var data={
        		venueId:venueId,
        		pageIndex:0,
    			pageNum:2
        }
        var activityDiv = "";
        var venueDiv = "";
        
        $.ajax({
            type: "post",
            url: "${path}/wechatVenue/venueWcMapActivity.do",
            data: data,
            async: false,
            dataType: "json",
            success: function(data){
            	if(data.status==0){
            		if(data.data.length == 2){
            			if(venueName.length >= 16){
            				infoWindowVerticalOffset = 350;
            			}else{
            				infoWindowVerticalOffset = 325;
            			}
            		}else if(data.data.length == 1){
            			if(venueName.length >= 16){
            				infoWindowVerticalOffset = 275;
            			}else{
            				infoWindowVerticalOffset = 250;
            			}
            		}else{
            			if(venueName.length >= 16){
        					infoWindowVerticalOffset = 185;
	        			}else{
	            			infoWindowVerticalOffset = 160;
	        			}
            		}
            		
            		$.each(data.data,function(i,dom){
            			activityDiv=activityDiv+"<li class='clearfix'>"+
    	        			"<a href='javascript:activityDetail(\""+dom.activityId+"\");'>"+
    	        			"<div class='pic'><img src='"+dom.activityIconUrl+"'/></div>"+
    	        			"<div class='char'>"+
    		        			"<div class='titYi'>"+dom.activityName+"</div>"+
    		        			"<div class='wenYi'>时间："+dom.activityStartTime+"</div>"+
    	        			"</div>"+
    	        			"</a>"+
            			"</li>";
            			
            			});
            		}
             	}
        });
        /*$.ajax({
            type: "post",
            url: "${path}/wechatVenue/activityWcRoom.do",
            data: data,
            async: false,
            dataType: "json",
            success: function(data){
            	if(data.status==0){
            		$.each(data.data,function(i,dom){
            			venueDiv=venueDiv+"<li class='clearfix'>"+
    	        					"<a href='javascript:roomDetail(\""+dom.roomId+"\");'>"+
    		        					"<div class='pic'><img src='"+dom.roomPicUrl+"'/></div>"+
    		        					"<div class='char'>"+
    			        					"<div class='titYi'>"+dom.roomName+"</div>"+
    			        					"<div class='wenYi'>面积："+dom.roomArea+"㎡</div>"+
    			        					"<div class='wenYi'>容纳："+dom.roomCapacity+"人</div>"+
    		        					"</div>"+
    	        					"</a>"+
            					"</li>";	
            			
            		});
            	}
             }
        });*/
        
        aa=aa+activityDiv+'</ul>' +
			'<a class="more" href="javascript:moreActivity(\''+venueId+'\',\''+venueName+'\');">查看更多&nbsp;&gt;&gt;</a>' +
			'</div>' /*+
			'<div class="culCont" style="display:none;">' +
			'<ul class="culActVenList" id="venueRoom">';
				
		aa=aa+venueDiv+'</ul>' +
		'<a class="more" href="javascript:moreRoom(\''+venueId+'\',\''+venueName+'\');">查看更多&nbsp;&gt;&gt;</a>' +
		'</div>' +
		'</div>';*/
		infoMapWindow = new AMap.AdvancedInfoWindow({
	    	offset: new AMap.Pixel(240,infoWindowVerticalOffset)
	    });
        infoMapWindow.setContent(aa);
        infoMapWindow.open(culMapInit, e.target.getPosition());
    }
	
	function showRoomInfo(){
		var venueId = markerObject.target.getExtData()[0];
        var venueName = markerObject.target.getExtData()[1];
        
    	var aa = '<div class="fs-cultureMapInfo">'+
		'<div class="tit"><span>' +venueName+ '</span><a href="javascript:toVenueDetail(\''+venueId+'\');">场馆详情&nbsp;&gt;&gt;</a></div>' +
		'<div class="culNav clearfix"><span>相关活动</span><span  class="cur">场馆预约</span><em></em></div>' +
		'<div class="culContWc">' + 
			'<div class="culCont">' +
			'<ul class="culActVenList" id="venueRoom">';
        
		var data={
        		venueId:venueId,
        		pageIndex:0,
    			pageNum:2
        }
       
        var venueDiv = "";
       
        $.ajax({
            type: "post",
            url: "${path}/wechatVenue/activityWcRoom.do",
            data: data,
            async: false,
            dataType: "json",
            success: function(data){
            	if(data.status==0){
            		if(data.data.length == 2){
            			if(venueName.length >= 16){
            				infoWindowVerticalOffset = 350;
            			}else{
            				infoWindowVerticalOffset = 325;
            			}
            		}else if(data.data.length == 1){
            			if(venueName.length >= 16){
            				infoWindowVerticalOffset = 275;
            			}else{
            				infoWindowVerticalOffset = 250;
            			}
            		}else{
            			if(venueName.length >= 16){
        					infoWindowVerticalOffset = 185;
	        			}else{
	            			infoWindowVerticalOffset = 160;
	        			}
            		}
            		$.each(data.data,function(i,dom){
            			venueDiv=venueDiv+"<li class='clearfix'>"+
    	        					"<a href='javascript:roomDetail(\""+dom.roomId+"\");'>"+
    		        					"<div class='pic'><img src='"+dom.roomPicUrl+"'/></div>"+
    		        					"<div class='char'>"+
    			        					"<div class='titYi'>"+dom.roomName+"</div>"+
    			        					"<div class='wenYi'>面积："+dom.roomArea+"㎡</div>"+
    			        					"<div class='wenYi'>容纳："+dom.roomCapacity+"人</div>"+
    		        					"</div>"+
    	        					"</a>"+
            					"</li>";	
            			
            		});
            	}
             }
        });
        		
		aa=aa+venueDiv+'</ul>' +
		'<a class="more" href="javascript:moreRoom(\''+venueId+'\',\''+venueName+'\');">查看更多&nbsp;&gt;&gt;</a>' +
		'</div>' +
		'</div>';
		infoMapWindow = new AMap.AdvancedInfoWindow({
	    	offset: new AMap.Pixel(240,infoWindowVerticalOffset)
	    });
        infoMapWindow.setContent(aa);
        infoMapWindow.open(culMapInit, markerObject.target.getPosition());
	}
    
    
    function loadMap(map, infoJson) {
    	// 清空地图的点
		map.clearMap();
		// 中心点
		var center_dot = null;
		// 添加点的集合
		var markers = [];
		// 数据的条数
		var len_dot = infoJson.length;
		// 弹窗内容
		var contentNeir = '';
	    for (var i = 0; i < len_dot; i++) {
	        var marker = null;
			if(i == 0) {
				// 第一个设置为中心点，并且添加不同的样式
				marker = addMarket(map, [infoJson[i].venueLon, infoJson[i].venueLat], 'center',new Array(infoJson[i].venueId,infoJson[i].venueName));
				// 把中心点赋给全局变量
				center_dot = marker;
			} else {
				// 除了中心点，添加其他点，并且设置普通样式
				marker = addMarket(map, [infoJson[i].venueLon, infoJson[i].venueLat],null,new Array(infoJson[i].venueId,infoJson[i].venueName));
			}
			// 给每个点赋予一个这些内容的信息框
			contentNeir = '';/* '<div class="fs-cultureMapInfo">'+
				'<div class="tit"><span>' + infoJson[i].venueName + '</span><a href="javascript:toVenueDetail(\''+infoJson[i].venueId+'\');">场馆详情&nbsp;&gt;&gt;</a></div>' +
				'<div class="culNav clearfix"><span class="cur">相关活动</span><span>场馆预约</span><em></em></div>' +
				'<div class="culContWc">' + 
					'<div class="culCont">' +
					'<ul class="culActVenList" id="activityList">' +
						
					'</ul>' +
					'<a class="more" href="javascript:moreActivity(\''+infoJson[i].venueId+'\',\''+infoJson[i].venueName+'\');">查看更多&nbsp;&gt;&gt;</a>' +
					'</div>' +
					'<div class="culCont" style="display:none;">' +
					'<ul class="culActVenList" id="venueRoom">' +
						
					'</ul>' +
					'<a class="more" href="javascript:moreRoom(\''+infoJson[i].venueId+'\',\''+infoJson[i].venueName+'\');">查看更多&nbsp;&gt;&gt;</a>' +
					'</div>' +
				'</div>'; */
			marker.content = contentNeir;
			markers.push(marker);
	    }
	    if (center_dot != null){
		    center_dot.setzIndex(101);
		}
	    // 默认第一个弹窗
	   /*   if(markers[0]!=undefined&&markers[0].length!=0){
	    	markers[0].on('click', markerClick);
			markers[0].emit('click', {target: markers[0]}); 
	    }  */
	    for(var i = 0; i < len_dot; i++) {
			(function(i) {
				markers[i].on("click", function(e) {
					// 弹窗显示，这必须放在下面的return前面，因为这个必须执行
					markerClick(e);
	        		// 设置中心点并更新样式
	        		if(center_dot == this) {
	                    return;
	                }

	                center_dot.setzIndex(100);
	                markers[i].setzIndex(101);

	                center_dot.setContent('<img src="${path}/STATIC/image/child/hp_site.png"/>');
	                markers[i].setContent('<img src="${path}/STATIC/image/child/hp_sites.png"/>');
	                map.setCenter([infoJson[i].venueLon,infoJson[i].venueLat]);
	                center_dot = this;
				});
			})(i);
		}
	}
    
  //跳转到活动详情页
    function activityDetail(activityId){
    	window.location.href = "${path}/frontActivity/frontActivityDetail.do?activityId="+activityId;
    }
  //活动室详情
  function roomDetail(roomId){
	  window.location.href = "${path}/frontRoom/roomDetail.do?roomId="+roomId;
  }
  //场馆详情
  function toVenueDetail(venueId){
	  window.location.href = "${path}/frontVenue/venueDetail.do?venueId="+venueId;
  }
  //更多相关活动
  function moreActivity(venueId,venueName){
	  window.location.href = "${path}/cultureMap/relativeActivityList.do?venueId="+venueId+"&venueName="+venueName;
  }
  //更多活动室
  function moreRoom(venueId,venueName){
	  window.location.href = "${path}/cultureMap/relativeRoomList.do?venueId="+venueId+"&venueName="+venueName;
  }
	</script>
</html>
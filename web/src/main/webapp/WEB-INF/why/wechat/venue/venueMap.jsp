<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" id="map_html">
<head>
<meta charset="utf-8"/>
<title>文化地图</title>
<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
<%-- <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style_hp.css"/>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/styleChild_hp.css"/> --%>
<script type="text/javascript" src="http://webapi.amap.com/maps?v=1.3&key=322057e2a214acc35616d9071ededcce"></script>
<style>
.hpMain {
    width: 750px;
    margin: 0 auto;
    overflow: hidden;
}
.mapInfo {
  width: 690px;
  padding: 0 30px;
  background-color: white;
  position: fixed;
  bottom: 0;
  left: 50%;
  margin-left: -375px;
  z-index: 200;
}

.mapInfo .mapName {
  font-size: 28px;
  color: #333333;
  padding: 25px 0 12px;
  border-bottom: 1px solid #e2e2e2;
}

.mapInfo .mapName span {
  font-size: 24px;
  color: #666666;
  margin-left: 33px;
}

.mapInfo p {
  font-size: 24px;
  margin: 18px 0;
  color: #666666;
}

.mapInfo .mapBtn {
  width: 140px;
  height: 60px;
  font-size: 24px;
  background-color: #eb778e;
  color: #fff;
  text-align: center;
  line-height: 60px;
  position: absolute;
  right: 28px;
  bottom: 24px;
  -webkit-border-radius: 4px;
  -moz-border-radius: 4px;
  border-radius: 4px;
}
.mapInfo .gotoAdd { 
	width: 98px; 
	height: 98px; 
	background: url(${path}/STATIC/h5/image/bp_go.png) no-repeat center; 
	position: absolute; 
	top: -50px; 
	right: 25px; 
	cursor: pointer; 
}

.mapNav {
	width: 750px;
	background-color: #fff;
	position: fixed;
	top: 0;
	right: 0;
	left: 0;
	margin: auto;
    z-index: 1;
    border-bottom: 1px solid #ccc;
    display: none;
}
.mapNav a {
	display: block;
	width: 50%;
	float: left;
	height: 78px;
	line-height: 78px;
	font-size: 30px;
	color: #666;
	text-align: center;
	position: relative;
}
.mapNav a:after {
	content: '';
	display: block;
	width: 140px;
	height: 3px;
	position: absolute;
	left: 50%;
	margin-left: -70px;
	bottom: -2px;
}
.mapNav a:before {
	content: '';
	display: block;
	width: 1px;
	height: 34px;
	background-color: #ccc;
	position: absolute;
	left: 0;
	top: 50%;
	margin-top: -17px;
}
.mapNav a:first-child:before {
	display: none;
}
.mapNav a.cur {
	color: #333333;
}
.mapNav a.cur:after {
	background-color: #f46f4a;
}


.hpTopMenu {
    width: 750px;
    background-color: #fff;
    position: fixed;
	/*top: 79px;*/
	top: 0;
	right: 0;
	left: 0;
	margin: auto;
    z-index: 1;
    padding: 22px 0;
    overflow: hidden;
}
.hpTopMenu .swiper-slide {
    padding: 0 16px;
    width: auto;
    font-size: 24px;
    color: #262626;
    line-height: 43px;
    height: 43px;
    background-color: #f0f0f0;
    border: 1px solid #d3d3d3;
    margin-right: 20px;
    -webkit-border-radius: 4px;
    -moz-border-radius: 4px;
    border-radius: 4px;
}
.hpTopMenu .swiper-slide:first-child {
	margin-left: 25px;
}
.hpTopMenu .swiper-slide.on {
    border-color: #eb778e;
    color: #eb778e;
}
</style>
<script type="text/javascript">
if (is_weixin()) {
	    wx.config({
	        debug: false,
	        appId: '${sign.appId}',
	        timestamp: '${sign.timestamp}',
	        nonceStr: '${sign.nonceStr}',
	        signature: '${sign.signature}',
	        jsApiList: ['onMenuShareAppMessage','onMenuShareTimeline','onMenuShareQQ','onMenuShareWeibo','onMenuShareQZone']
	    });
	    wx.ready(function () {
	    	wx.onMenuShareAppMessage({
	            title: "我在“北票文化云”发现一大波文化活动，快来和我一起预订吧！",
	            desc: '文化引领 品质生活',
	            imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
	        });
	        wx.onMenuShareTimeline({
	            title: "我在“北票文化云”发现一大波文化活动，快来和我一起预订吧！",
	            imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
	        });
	        wx.onMenuShareQQ({
	        	title: "我在“北票文化云”发现一大波文化活动，快来和我一起预订吧！",
	        	desc: '文化引领 品质生活',
	            imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
	        });
	        wx.onMenuShareWeibo({
	        	title: "我在“北票文化云”发现一大波文化活动，快来和我一起预订吧！",
	        	desc: '文化引领 品质生活',
	            imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
	        });
	        wx.onMenuShareQZone({
	        	title: "我在“北票文化云”发现一大波文化活动，快来和我一起预订吧！",
	        	desc: '文化引领 品质生活',
	            imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
	        });
	    });
}
	var culMapInit;
	$(function(){
	 	// 初始化地图，只需要初始化一次
	 	culMapInit = initMap();
	    loadTag('VENUE_TYPE');		//加载标签
        loadData();		//加载数据
	});

	function loadData(){
		var data = {
			selectType: $("#tagList div.swiper-slide.on").attr("selectType"),
			pageIndex:0,
			pageNum:100
		}
		$.post("${path}/wechatVenue/wcVenueMapList.do",data, function (data) {
    		if(data.status==200){
    			var infoJson = new Array();
    			$.each(data.data, function (i, dom) {
   					infoJson.push({
   	                    'venueId' : dom.venueId,
   	                    'venueName' : dom.venueName,
   	                    'venueAddress' : dom.venueAddress,
   	                    'extBusinessName' : dom.extBusinessName,
   	                    'venueLat' : dom.venueLat,
   	                    'venueLon': dom.venueLon,
   	                    'venueMobile': dom.venueMobile,
   	                    'venueIsFree': dom.venueIsFree,
   	                    'venuePrice': dom.venuePrice
   	                });
    			});
    			loadMap(culMapInit,infoJson);
    		}
    	}, "json");
	}
	
  	//加载标签
    function loadTag(code) {
        $.post("${path}/tag/getChildTagByType.do",{code: code}, function (data) {//${path}/wechatVenue/venueTagByType.do
        	var list = eval(data);
        	if (list.length > 0) {
                $.each(list, function (i, dom) {
                    $("#tagList").append('<div class="swiper-slide" selectType='+dom.tagId+'>'+dom.tagName+'</div>');
                });
                
                var mySwiper = new Swiper('.hpTopMenu', {
    				slidesPerView: 'auto',
    				spaceBetween: 20,
    			})
    			
                $("#tagList").on("click",'div',function(){
                	$(this).addClass("on").siblings().removeClass("on");
                	loadData();
    			});
            }
        }, "json");
    };
	
  	//跳转到场馆活动列表
    function toVenueActList(venueId){
    	/* if (userId == null || userId == '') {
    		window.location.href = '${path}/muser/login.do?type=${path}/wechatVenue/preMap.do';
            return;
        } */
    	//window.parent.location.href = whyConfig.middlewareUrl + "wechatActivity/preActivityList.do?venueId="+venueId+"&userId="+userId+"&callback="+whyConfig.frontUrl+"&sourceCode="+whyConfig.sourceCode;
    	window.parent.location.href = "${path}/wechatActivity/preActivityList.do?venueId="+venueId;
    }
  	
  //跳转到场馆详情页
    function tovenueDetailIndex(venueId){
    	window.parent.location.href = "${path}/wechatVenue/venueDetailIndex.do?venueId="+venueId;
    }
</script>

<style type="text/css">
	body,html{
		background-color: #f1f1f1;
		height: 100%;
	}
	.hpMain{
		height: 100%;
	}
	#container{
		height: 100%;
	}
</style>

</head>
<body>
	<div class="hpMain">
		<div class="mapNav clearfix">
	    	<a class="cur" href="javascript:;">文化活动</a>
	    	<a href="javascript:;">文化场馆</a>
	    </div>
		<div class="hpTopMenu">
			<div class="swiper-wrapper" id="tagList">
				<div class="swiper-slide on" data-type="all">全部</div>
			</div>
		</div>
		<div class="mapInfo">
			<div class="mapName" id="venueName"></div>
			<p id="venueAddr"></p>
			<p id="venueTel"></p>
			<a href="javascript:;" class="mapBtn" id="venueActList" style="right: 190px;">场馆活动</a>
			<a href="javascript:;" class="mapBtn" id="venueDetailIndex">场馆详情</a>
			<div class="gotoAdd" id="gotoAdd"></div>
		</div>
		<div id="container"></div>
	</div>
</body>
<script type="text/javascript">
	//初始化地图
	function initMap() {
		var map = new AMap.Map('container', {
	        resizeEnable: true,
	        //center: [121.482838,31.217272],
	        zoom: 15,
	        features: ["bg", "road", "building"]
	    });
		return map;
	}
	
	// 地图上添加单个点
	function addMarket(map,pos,zx) {
		var marker = new AMap.Marker({
            map: map,
			icon: new AMap.Icon({
			 	size: new AMap.Size(38, 57), 
                image: "${path}/STATIC/h5/image/bp_site.png"
            }),
            //offset: new AMap.Pixel(-20, -40),
            position: pos
        });
	    if(typeof zx == 'undefined') {
	        marker.setContent('<img src="${path}/STATIC/h5/image/bp_site.png"/>');
	    } else {
	        if(zx == 'center') {
	            // 是中心点
	            marker.setContent('<img src="${path}/STATIC/h5/image/bp_sites.png"/>');
	            map.setCenter(pos);
	        } else {
	            // 不是是中心点
	            marker.setContent('<img src="${path}/STATIC/h5/image/bp_site.png"/>');
	        }
	    }
	    return marker;
	}

	// 加载地图
	function loadMap(map,infoJson) {
	    // 清空地图的点
	    map.clearMap();
	    // 中心点
	    var center_dot = null;
	    // 添加点的集合
	    var markers = [];
	    // 数据的条数
	    var len_dot = infoJson.length;
	    // 页面上dom
	    var title = $('#venueName');
	    var s1 = $('#venueAddr');
	    var s2 = $('#venueTel');
        var b1 = $('#venueActList');
        var b2 = $('#venueDetailIndex');
	    for(var i = 0; i < len_dot; i++) {
	        var marker = null;
	        if(i == 0) {
	            // 第一个设置为中心点，并且添加不同的样式
	            marker = addMarket(map, [infoJson[i].venueLon,infoJson[i].venueLat],'center');
	            // 把中心点赋给全局变量
	            center_dot = marker;
	            // 填初始中心点数据
	            title.html(infoJson[i].venueName);
	            if (infoJson[i].venueIsFree == 1){
	            	title.html(title.html()+"<span>免费</span>");
	            } else {
	            	title.html(title.html()+"<span>"+infoJson[i].venuePrice+"</span>");
	            }
	            s1.html('地址：' + infoJson[i].venueAddress);
	            s2.html('电话：' + infoJson[i].venueMobile);
	            b1.attr("href","javascript:toVenueActList('"+infoJson[i].venueId+"')");
	            b2.attr("href","javascript:tovenueDetailIndex('"+infoJson[i].venueId+"')");
	        } else {
	            // 除了中心点，添加其他点，并且设置普通样式
	            marker = addMarket(map, [infoJson[i].venueLon,infoJson[i].venueLat]);
	        }
	        markers.push(marker);
	    }
	    center_dot.setzIndex(101);
	    
	    /* start 给默认第一个点调用高德地图导航 */
		$("#gotoAdd").off('click');
		$("#gotoAdd").on('click',function() {
			markers[0].markOnAMAP()
		});
		/* end 给默认第一个点调用高德地图导航 */
		
	    // 给多个点添加事件 并设置为中心点
	    for(var i = 0; i < len_dot; i++) {
	        (function(i){
	            markers[i].on("click", function(e){
	            	
	            	/* start 调用高德地图导航 */
					$("#gotoAdd").off('click');
					$("#gotoAdd").on('click',function() {
						markers[i].markOnAMAP()
					});
					/* end 调用高德地图导航 */
					
					
	                if(center_dot == this) {
	                    return;
	                }
	                center_dot.setzIndex(100);
	                markers[i].setzIndex(101);
	                
	                center_dot.setContent('<img src="${path}/STATIC/h5/image/bp_site.png">');
	                markers[i].setContent('<img src="${path}/STATIC/h5/image/bp_sites.png">');
	                map.setCenter([infoJson[i].venueLon,infoJson[i].venueLat]);
	                center_dot = this;
	                
	                // 填数据
	                title.html(infoJson[i].venueName);
	                if (infoJson[i].venueIsFree == 1){
		            	title.html(title.html()+"<span>免费</span>");
		            } else {
		            	title.html(title.html()+"<span>"+infoJson[i].venuePrice+"</span>");
		            }
	                s1.html('地址：' + infoJson[i].venueAddress);
	                s2.html('电话：' + infoJson[i].venueMobile);
                    b1.attr("href","javascript:toVenueActList('"+infoJson[i].venueId+"')");
	            });
	        })(i);
	    }
	}
</script>
</html>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" id="map_html">
<head>
<meta charset="utf-8"/>
<!-- <title>活动地图</title> -->
<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
<script type="text/javascript" src="${path}/STATIC/wechat/js/jquery.lazyload.min.js"></script>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>

<script type="text/javascript">
	var activityThemeTagId = '${sessionScope.terminalUser.activityThemeTagId}';
	var selectTagId = '';
	var userId = '${sessionScope.terminalUser.userId}';
	var latitude = 31.22;
	var longitude = 121.48;
	
	$(function(){
		//判断是否是微信浏览器打开
	    if (is_weixin()) {
	
	        //通过config接口注入权限验证配置
	        wx.config({
	            debug: false,
	            appId: '${sign.appId}',
	            timestamp: '${sign.timestamp}',
	            nonceStr: '${sign.nonceStr}',
	            signature: '${sign.signature}',
	            jsApiList: ['getLocation','onMenuShareAppMessage','onMenuShareTimeline','onMenuShareQQ','onMenuShareWeibo','onMenuShareQZone']
	        });
	        wx.ready(function () {
	        	wx.onMenuShareAppMessage({
                    title: "我在“文化云”发现一大波文化活动，快来和我一起预订吧！",
                    desc: '现汇聚上海22万场文化活动及场馆资源',
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
                    success: function () {
                        dialogAlert('系统提示', '分享成功！');
                    }
                });
                wx.onMenuShareTimeline({
                    title: "我在“文化云”发现一大波文化活动，快来和我一起预订吧！",
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
                    success: function () {
                        dialogAlert('系统提示', '分享成功！');
                    }
                });
                wx.onMenuShareQQ({
                    title: "我在“文化云”发现一大波文化活动，快来和我一起预订吧！",
                    desc: '现汇聚上海22万场文化活动及场馆资源',
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
                wx.onMenuShareWeibo({
                    title: "我在“文化云”发现一大波文化活动，快来和我一起预订吧！",
                    desc: '现汇聚上海22万场文化活动及场馆资源',
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
                wx.onMenuShareQZone({
                    title: "我在“文化云”发现一大波文化活动，快来和我一起预订吧！",
                    desc: '现汇聚上海22万场文化活动及场馆资源',
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
	        	wx.getLocation({
	    		    type: 'wgs84', // 默认为wgs84的gps坐标，如果要返回直接给openLocation用的火星坐标，可传入'gcj02'
	    		    success: function (res) {
	    		    	latitude = (res.latitude==null||res.latitude=="")?0:res.latitude; // 纬度，浮点数，范围为90 ~ -90
				        longitude = (res.longitude==null||res.longitude=="")?0:res.longitude; // 经度，浮点数，范围为180 ~ -180。
				        
				        loadTag();
	    		    },
	    		    fail: function (res){
	    		    	dialogAlert("系统提示", "获取坐标失败，定位未启用");
	    		    	loadTag();
	    		    }
	    		});
	        });
	    } else {
	    	if (window.navigator.geolocation) {
	            var options = {
	                enableHighAccuracy: true,
	            };
	            window.navigator.geolocation.getCurrentPosition(handleSuccess, handleError, options);
	        } else {
	        	dialogAlert("系统提示", "浏览器不支持html5来获取地理位置信息");
	        }
	        
	        function handleSuccess(position){
	        	longitude = position.coords.longitude;
	            latitude = position.coords.latitude;
	            loadTag();
	        }
	        function handleError(error){
	        	dialogAlert("系统提示", "获取坐标失败，定位未启用");
	        	loadTag();
	        }
	    }
		
	    $(".swiper-slide a").click(function() {
			$(".swiper-slide a").css("font-weight", "normal")
			$(this).css("font-weight", "bold")
		})
		
		//筛选列表
		$(".data-menu2").on("click", function() {
			$(".data-menu1,.data-menu2,.data-menu3").hide()
			$(".data-menu").animate({
				width: "170px",
				left: "290px",
				height: "265px"
			})
			$(".data-menu2-on").show()
		})
		$(".data-menu3").on("click", function() {
			$(".data-menu1,.data-menu2,.data-menu3").hide()
			$(".data-menu").animate({
				width: "170px",
				left: "290px",
				height: "215px"
			})
			$(".data-menu3-on").show()
		})
		$(".close-button").on("click", function() {
			closeMenu();
		})
		//底部菜单
		$(document).on("touchmove", function() {
			$(".footer").hide()
		}).on("touchend", function() {
			$(".footer").show()
		})
		$(".footer-menu-button").click(function() {
			if ($(".footer-menu-list").offset().left == 25) {
				$(".footer-menu-list").animate({
					"left": "630px",
				},200);
			} else {
				$(".footer-menu-list").animate({
					"left": "0px",
				},200);
			}
		})
		//回到顶部按钮显示
		$(window).scroll(function() {
			var screenheight = $(window).height() * 2
			if ($(document).scrollTop() > screenheight) {
				$(".totop").show()
			} else {
				$(".totop").hide()
			}
		})
	});

	//活动标签
	function loadTag(){
		$.post("${path}/wechatActivity/wcActivityTagList.do", {userId: userId}, function (data) {
            if (data.status == 0) {
                var domStr = '<div class="swiper-slide"><a onclick="selectTagId=\'\';reloadMenu();tagSelect();" class="select_it" style="font-weight: bold;">全部</a></div>';
                var tagHasNum = 0;	//判断是否有标签显示
                $.each(data.data, function (i, dom) {
                	if (dom.status == 1&&userId != "") {
                    	tagHasNum++;
                        domStr += '<div class="swiper-slide"><a id=' + dom.tagId + ' onclick="selectTagId=\''+dom.tagId+'\';reloadMenu();tagSelect();">' + dom.tagName + '</a></div>';
                    }
                    if (activityThemeTagId.indexOf(dom.tagId) != -1 && userId == "") {
                    	tagHasNum++;
                        domStr += '<div class="swiper-slide"><a id=' + dom.tagId + ' onclick="selectTagId=\''+dom.tagId+'\';reloadMenu();tagSelect();">' + dom.tagName + '</a></div>';
                    }
                });
                if(tagHasNum==0){
            		domStr += '<div style="font-size:40px;color:#000;">点击右侧+号添加更多喜爱的类型</div>'
            	}
                $("#tagList").html(domStr);
                var mySwiper = new Swiper('.swiper-container', {
        			slidesPerView: 6, //显示
        			paginationClickable: true,
        			spaceBetween: 20, //间距
        			freeMode: false
        		})
                $(".swiper-slide a").click(function() {
					$(".swiper-slide a").css("font-weight", "normal")
					$(this).css("font-weight", "bold")
				})
				acticityLoad();
            }
        }, "json")
	};
	
	//加载活动
	function acticityLoad(){
		//图片懒加载开始位置
    	var liCount = $("#index_list li").length;
		var activityType;
		if (selectTagId == "") {	//全部
			activityType = activityThemeTagId;
		}else{	//其余标签
			activityType = selectTagId;
		}
		var data = {
				activityType:activityType,
				sortType: $("#sortVal").val(),
            	activityIsFree: $("#isFreeVal").val(),
            	activityIsReservation: $("#isReservationVal").val(),
				Lon:longitude,
				Lat:latitude,
				pageIndex:0,
				pageNum:20
			}
		$.post("${path}/wechatActivity/wcNearActivityList.do",data, function(data) {
			var json_data = [];
   			if(data.data.length==0){
   				$("#loadingDiv").html("<span class='noLoadingSpan'>没有找到合适的结果，换个试试看吧~</span>");
   			}else{
   				$("#loadingDiv").html("");
   			}
			$.each(data.data,function(i,dom){
				var time = dom.activityStartTime.substring(5,10).replace("-",".");
				if(dom.activityEndTime.length>0&&dom.activityStartTime!=dom.activityEndTime){
					time += "-"+dom.activityEndTime.substring(5,10).replace("-",".");
				}
				var priceMap
				if(dom.activityIsFree==2){
					if (dom.activityPrice.length != 0 && dom.activityPrice > 0) {
						if(dom.priceType==0){
							priceMap = dom.activityPrice + '元起';
						}else{
							priceMap = dom.activityPrice + '元/人';
						}
                    } else {
                    	priceMap = '收费';
                    }
				}else{
					priceMap = '免费';
				}
				var distance = '无信息';
				if(dom.sysId==''){
					if(dom.distance>=1){
						distance = new Number(dom.distance).toFixed(1)+"KM";
					}else{
						distance = new Number(dom.distance*1000).toFixed(0)+"M";
					}
				}
				var distanceHtml = "<div class='f-left padding-left50 distance'><p>"+distance+"</p></div>";
				json_data.push([dom.activityLon,dom.activityLat,[dom.activityName,dom.activityLocationName,time,priceMap,dom.activityId,distance]]);
				
				var activityIconUrl = getIndexImgUrl(dom.activityIconUrl, "_750_500");
    			var price = "";
    			if(dom.activityIsFree==2){
					if (dom.activityPrice.length != 0 && dom.activityPrice > 0) {
						if(dom.priceType==0){
							price += "<span style='font-size: 57px;'>" + dom.activityPrice + "</span>元起";
						}else{
							price += "<span style='font-size: 57px;'>" + dom.activityPrice + "</span>元/人";
						}
                    } else {
                    	price += "<span style='font-size: 57px;'>收费</span>";
                    }
				}else{
					price += "<span style='font-size: 57px;'>免费</span>";
				}
    			var tagHtml = "<ul class='tab-p2'>";
    			tagHtml += "<li>"+dom.activitySubject.substring(dom.activitySubject.length-4)+"</li>";
    			tagHtml += "<li>"+dom.tagName+"</li>";
    			if(dom.activitySubject.length>4){
    				tagHtml += "<li>"+dom.activitySubject.substring(0,dom.activitySubject.length-5)+"</li>";
    			}
    			tagHtml += "</ul>"
    			$("#index_list").append("<li activityId=" + dom.activityId + " onclick='showActivity(\"" + dom.activityId + "\")'>" +
											"<img src='" + activityIconUrl + "' width='750' height='475'/>" +
											"<img src='${path}/STATIC/wechat/image/蒙板.png' class='masking'/>" +
											"<span class='tab-p1'>"+dom.activityName+"</span>" +
											"<div class='address fs24 cfff'>" +
												"<div class='f-left address-place'>" +
													"<p>"+dom.activityLocationName+"</p>" +
												"</div>" +
												distanceHtml +
												"<div style='clear: both;'></div>" +
											"</div>" +
											tagHtml +
											"<span class='tab-p4'>"+price+"</span>" +
											"<span class='tab-p5'>"+time+"</span>" +
										"</li>");
			});
			
			//图片懒加载
			$("#index_list li:gt("+liCount+") img.lazy,#index_list li:eq("+liCount+") img.lazy").lazyload({
    		    effect : "fadeIn",
    		    effectspeed : 1000
    		});
			
			drawMap(json_data);
		},"json");
	}
	
	//跳转到活动详情
	function showActivity(activityId){
    	window.location.href="${path}/wechatActivity/preActivityDetail.do?activityId="+activityId;
    }
	
	//选择标签
    function tagSelect() {
        $("#index_list").html("");
        $("#loadingDiv").html("<img class='loadingImg' src='${path}/STATIC/wechat/image/loading.gif'/><span class='loadingSpan'>加载中。。。</span><div style='clear:both'></div>");
        acticityLoad();
    }
	
	//界面切换
	function switchContainer(){
		if($("#containerValue").val()==1){	//切换到列表
			$("#mapList").hide();
			$("#containerImg").attr("src","${path}/STATIC/wechat/image/icon_maptop.png");
			$("#mapContainer").hide();
			$("#listContainer").show();
			$("#containerValue").val("2");
		}else{	//切换到地图
			$("#mapList").show();
			acticityLoad();		//防止地图中心错位，重新加载活动
			$("#containerImg").attr("src","${path}/STATIC/wechat/image/icon_list.png");
			$("#mapContainer").show();
			$("#listContainer").hide();
			$("#containerValue").val("1");
		}
	}
	
	//跳转到日历
    function preCalendar(){
    	if (is_weixin()) {
    		window.location.href = '${path}/wxUser/silentInvoke.do?type=${path}/wechatActivity/preActivityCalendar.do';
    	}else{
    		window.location.href = '${path}/wechatActivity/preActivityCalendar.do';
    	}
    }
	
  //重新加载筛选界面
    function reloadMenu(){
    	$('.data-menu1').html('全部商区');
    	$('.data-menu2').html('智能排序');
    	$('.data-menu3').html('筛选');
    	$("#areaVal").val('');
    	$("#locationVal").val('');
    	$("#sortVal").val('1');
    	$("#isFreeVal").val('');
    	$("#isReservationVal").val('');
    	
    	//选中全上海
		$("#areaList p").removeClass("bg262626");
		$("#areaList p:eq(0)").addClass("bg262626");
		$(".data-menu-place2 div").not(".close-button").hide();
		$(".data-menu-place2 div:eq(1)").show();
    }
  	
  	//收起筛选界面
    function closeMenu(){
    	$(".data-menu1-on").hide();
		$(".data-menu2-on").hide();
		$(".data-menu3-on").hide();
		$(".data-menu").animate({
			width: "370px",
			height: "60px",
			left: "206px",
		});
		$(".data-menu1,.data-menu2,.data-menu3").show();
    }
  	
</script>

<style>
	.header,.content {
		background-color: #fff;
	}
	.map-list-2{
		padding-top:200px;
	}
	html,body,.main,.content{height: 100%;}
	.info {
		background-color: #fff;
		width: 710px;
		position: absolute;
		bottom: 125px;
		left: 0px;
		padding-bottom: 20px;
		padding-left: 20px;
		padding-right: 20px;
	}
	.info h3 {
		margin-top: 20px;
		font-size: 30px;
		color: #808080;
	}
	.info hr {margin-top: 30px;}
	.info p {
		font-size: 24px;
		color: #808080;
		line-height: 28px;
		height: 30px;
		width: 550px;
		float: left;
		text-overflow:ellipsis;
	}
	.info span {
		font-size: 26px;
		float: right;
	}
	.mm {margin-top: 23px;}
	.menu-near {background: url(${path}/STATIC/wechat/image/menu-icon01.png) no-repeat -105px center;}
</style>

</head>
<body>
	<div class="main">
		<div class="header">
			<div class="index-top">
				<span class="index-top-2">附近</span>
				<span class="index-top-3" onclick="switchContainer();">
					<input type="hidden" value="2" id="containerValue"/>
					<img src="${path}/STATIC/wechat/image/icon_maptop.png" width="28px" height="42px" id="containerImg"/>
				</span>
			</div>
			<div class="swiper-container">
				<div class="swiper-wrapper" id="tagList"></div>
			</div>
			<div class="menu-more">
				<a href="${path}/wechat/openEdit.do?type=${path}/wechatActivity/preMap.do"><img src="${path}/STATIC/wechat/image/more.png" /></a>
			</div>
		</div>
		<div class="map-list-2" id="listContainer">
			<div class="active" style="margin: 0">
				<div class="data-menu top-fixed3" style="width: 370px;left:206px;top:240px;">
					<div class="data-menu2" style="width: 46%;">智能排序</div>
					<div class="data-menu3" style="width: 46%;">筛选</div>
					<div style="clear: both;"></div>
					<div class="data-menu2-on">
						<div class="close-button"><img src="${path}/STATIC/wechat/image/arrow.png" /></div>
						<div>
							<p onclick="$('#sortVal').val(1);tagSelect();closeMenu();$('.data-menu2').html('智能排序');">智能排序</p>
							<p onclick="$('#sortVal').val(2);tagSelect();closeMenu();$('.data-menu2').html('热门排序');">热门排序</p>
							<p onclick="$('#sortVal').val(3);tagSelect();closeMenu();$('.data-menu2').html('最新上线');">最新上线</p>
							<p onclick="$('#sortVal').val(4);tagSelect();closeMenu();$('.data-menu2').html('即将结束');">即将结束</p>
						</div>
						<input type="hidden" id="sortVal" value="1"/>
					</div>
					<div class="data-menu3-on">
						<div class="close-button"><img src="${path}/STATIC/wechat/image/arrow.png" /></div>
						<div>
							<p onclick="$('#isFreeVal').val('');$('#isReservationVal').val('');tagSelect();closeMenu();$('.data-menu3').html('筛选');">全部</p>
							<p onclick="$('#isFreeVal').val(1);$('#isReservationVal').val('');tagSelect();closeMenu();$('.data-menu3').html('免费');">免费</p>
							<p onclick="$('#isReservationVal').val(2);$('#isFreeVal').val('');tagSelect();closeMenu();$('.data-menu3').html('在线预订');">在线预订</p>
						</div>
						<input type="hidden" id="isFreeVal"/>
						<input type="hidden" id="isReservationVal"/>
					</div>
				</div>
				<ul id="index_list"></ul>
			</div>
			<div id="loadingDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>
		</div>
		<div class="content" style="display:none;padding-bottom:0px;" id="mapContainer">
			<div style="width: 100%;height: 100%;" class="map_container"></div>
		</div>
		<div class="footer" style="background-color: transparent;bottom: 40px;border:none;">
			<div class="totop" onclick="$('html,body').animate({scrollTop: 0}, 200);"><img src="${path}/STATIC/wechat/image/totop.png" /></div>
			<div style="clear: both;"></div>
			<div class="footer-menu">
				<div class="footer-menu-list">
					<ul>
						<li><a href="${path}/wechat/index.do"><div class="menu-home"></div><p>首页</p></a></li>
						<li><a><div class="menu-near"></div><p class="c7279a0">附近</p></a></li>
						<li><a href="javascript:preCalendar();"><div class="menu-data"></div><p>日历</p></a></li>
						<li><a href="${path}/wechatVenue/venueIndex.do"><div class="menu-venue"></div><p>场馆</p></a></li>
						<li><a href="${path}/wechatUser/preTerminalUser.do"><div class="menu-me"></div><p>我</p></a></li>
						<div style="clear: both;"></div>
					</ul>
				</div>
			</div>
			<div class="footer-menu-button">
				<img src="${path}/STATIC/wechat/image/menu-button.png" />
			</div>
		</div>
	</div>
</body>
</html>

<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=7bq0ISXbRLNBthNB3qzakG6g"></script>
<script type="text/javascript">
    Array.prototype.indexOf = function(e){
        for(var i=0,j; j=this[i]; i++){
            if(j==e){return i;}
        }
        return -1;
    }
    Array.prototype.lastIndexOf = function(e){
        for(var i=this.length-1,j; j=this[i]; i--){
            if(j==e){return i;}
        }
        return -1;
    }

    // 百度地图API功能
    var map = new BMap.Map("mapContainer");
    map.enableScrollWheelZoom();// 启用地图滚轮放大缩小
    
    //单击获取点击的经纬度
    function drawMap(json_data){
    	map.clearOverlays();
    	
    	var point = new BMap.Point(longitude, latitude);  // 创建点坐标
    	
    	//坐标转换完之后的回调函数
        translateCallback = function (data){
          if(data.status === 0) {
        	var myIcon = new BMap.Icon("${path}/STATIC/wechat/image/Slice-1.png", new BMap.Size(70,70));
            var marker = new BMap.Marker(data.points[0],{icon:myIcon});
            map.addOverlay(marker);
            map.centerAndZoom(data.points[0],14);
          }
        }
        
		var convertor = new BMap.Convertor();
		var pointArr = [];
		pointArr.push(point);
		convertor.translate(pointArr, 1, 5, translateCallback);
        
        var $mapList = $("#mapList");
        if($mapList.length > 0){
            $mapList.empty();
        }
        var marker2;
        var pointArray = new Array();
        for(var i=0;i<json_data.length;i++){
            var curData = json_data[i];
			var myIcon = new BMap.Icon('${path}/STATIC/wechat/image/icon_map.png', new BMap.Size(45, 60));
			var myIcon2 = new BMap.Icon('${path}/STATIC/wechat/image/icon_mapon.png', new BMap.Size(60, 80));
			var point = new BMap.Point(curData[0], curData[1]); // 创建点
			var marker = new BMap.Marker(point, {icon: myIcon});
			marker.content = curData[2];
			marker.addEventListener("click", function() {
				map.removeOverlay(marker2)
				var marker1 = new BMap.Marker(this.point, {icon: myIcon2});
				map.addOverlay(marker1);
				marker2 = marker1;
				
				attribute(this.content);
			})
			map.addOverlay(marker);
			pointArray[i] = new BMap.Point(curData[0], curData[1]);
        }
    }
    
    //获取覆盖物位置
    function attribute(content){
        var mapList = document.getElementById('mapList');
        if(!mapList) {
            mapList = document.createElement("div");
            mapList.className = "map_list";
            mapList.id = 'mapList';
            document.getElementsByTagName("body")[0].appendChild(mapList);
        }else {
            mapList.innerHTML = '';
        }
        var html = '<div class="info" onclick="showActivity(\''+content[4]+'\');">' +
	        			'<h3>'+content[0].substring(0,20)+'</h3>' +
						'<p>'+content[2]+'</p>' + 
						'<span>'+content[3]+'</span>' + 
						'<div style="clear:both;"></div>' + 
						'<hr style="color:#808080">' +
						'<p class="my-comment-place">'+content[1]+'</p>' + 
						'<span class="mm">'+content[5]+'</span>' + 
						'<div style="clear:both;">' +
				   '</div>';
        mapList.innerHTML = html;
    }
    
</script>
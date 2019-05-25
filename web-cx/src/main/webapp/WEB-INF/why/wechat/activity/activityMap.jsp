<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" id="map_html">
<head>
<meta charset="utf-8"/>
<title>活动地图</title>
<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
<script type="text/javascript" src="${path}/STATIC/wechat/js/jquery.lazyload.min.js"></script>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/hsStyle.css"/>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/swiper-3.3.1.min.css"/>
<%--<link rel="stylesheet" href="${path}/STATIC/wechat/css/bpColorCtrl.css" />--%>
<script type="text/javascript" src="${path}/STATIC/wechat/js/swiper-3.3.1.jquery.min.js"></script>

<script type="text/javascript">
	var activityThemeTagId = '${sessionScope.terminalUser.activityThemeTagId}';
	var selectTagId = '';
	var latitude = 22.964305;
	var longitude = 113.116029;
	
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
                    title: "我在“佛山文化云”发现一大波文化活动，快来和我一起预订吧！",
                    desc: '提供公众文化生活和消费的互联网平台，为公众提供便捷和有品质的文化生活服务。',
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
                    success: function () {
                        dialogAlert('系统提示', '分享成功！');
                    }
                });
                wx.onMenuShareTimeline({
                    title: "我在“佛山文化云”发现一大波文化活动，快来和我一起预订吧！",
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
                    success: function () {
                        dialogAlert('系统提示', '分享成功！');
                    }
                });
                wx.onMenuShareQQ({
                    title: "我在“佛山文化云”发现一大波文化活动，快来和我一起预订吧！",
                    desc: '提供公众文化生活和消费的互联网平台，为公众提供便捷和有品质的文化生活服务。',
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
                wx.onMenuShareWeibo({
                    title: "我在“佛山文化云”发现一大波文化活动，快来和我一起预订吧！",
                    desc: '提供公众文化生活和消费的互联网平台，为公众提供便捷和有品质的文化生活服务。',
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
                wx.onMenuShareQZone({
                    title: "我在“佛山文化云”发现一大波文化活动，快来和我一起预订吧！",
                    desc: '提供公众文化生活和消费的互联网平台，为公众提供便捷和有品质的文化生活服务。',
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
	    	if (/wenhuayun/.test(ua)) {		//APP端
        		getAppUserLocation();
        		loadTag();
        	}else{
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
			$(".newMenuBTN").click(function() {
				$(".newMenuList").animate({
					"bottom": "0px"
				})
			})
			$(".newMenuCloseBTN>img").click(function() {
				var height = $(".newMenuList").width();
				$(".newMenuList").animate({
					"bottom": "-"+height+"px"
				})
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
			/*菜单轮播*/
			var mySwiper4 = new Swiper('.swiper-container4', {
				freeMode: false,
				autoplay: false,
				loop: false,
				pagination: '.swiper-pagination'
			});
	});

	//活动标签
	function loadTag(){
		$.post("${path}/wechatActivity/wcActivityTagList.do", {userId: userId}, function (data) {
            if (data.status == 0) {
                var domStr = '<div class="swiper-slide border-bottom2"><a onclick="selectTagId=\'\';reloadMenu();tagSelect();" class="select_it" style="font-weight: bold;">全部</a></div>';
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
            		domStr += '<div style="font-size:34px;color:#ccc;line-height: 100px;">点击右侧+号添加更多喜爱的类型</div>'
            	}
                $("#tagList").html(domStr);
                var mySwiper = new Swiper('.swiper-container', {
        			slidesPerView: 6, //显示
        			paginationClickable: true,
        			spaceBetween: 10, //间距
        			slidesOffsetBefore:10,
        			freeMode: false
        		})
                $(".swiper-slide a").click(function() {
                	$(".swiper-slide ").removeClass("border-bottom2");
					$(".swiper-slide a").css("font-weight", "normal");
					$(this).css("font-weight", "bold");
					$(this).parent().addClass("border-bottom2");
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
				if(dom.activityAbleCount > 0 || dom.activityIsReservation == 1){
					if(dom.activityIsFree==2 || dom.activityIsFree==3){
    					if (dom.activityPrice.length != 0 && dom.activityPrice > 0) {
    						if(dom.priceType==0){
    							priceMap = dom.activityPrice + "元起";
	   	    				}else if(dom.priceType==1){
	   	    					priceMap = dom.activityPrice + "元/人";
	   	    				}else if(dom.priceType==2){
	   	    					priceMap = dom.activityPrice + "元/张";
	   	    				}else if(dom.priceType==3){
	   	    					priceMap = dom.activityPrice + "元/份";
	   	    				}else{
	   	    					priceMap = dom.activityPrice + "元/张";
    						}
                        } else {
                        	priceMap = '收费';
                        }
    				}else{
    					priceMap = '免费';
    				}
				}else{
					priceMap = '已订完';
				}
				var distance = '';
				if((dom.sysNo==1&&dom.sysId.length>0)||dom.distance.length<1){
					distance = '无信息';
				}else{
					if(dom.distance>=1){
						distance = new Number(dom.distance).toFixed(1)+"KM";
					}else{
						distance = new Number(dom.distance*1000).toFixed(0)+"M";
					}
				}
				var distanceHtml = "<div class='activeDistance'>"+distance+"</div>";
				json_data.push([dom.activityLon,dom.activityLat,[dom.activityName,dom.activityLocationName,time,priceMap,dom.activityId,distance]]);
				
				var activityIconUrl = getIndexImgUrl(dom.activityIconUrl, "_750_500");
				var price = "";
				if(dom.activityAbleCount > 0 || dom.activityIsReservation == 1){
					if(dom.activityIsFree==2 || dom.activityIsFree==3){
    					if (dom.activityPrice.length != 0 && dom.activityPrice > 0) {
    						if(dom.priceType==0){
    							price += "<div class='activePay'><p>" + dom.activityPrice + "元起</p></div>";
	   	    				}else if(dom.priceType==1){
 								price += "<div class='activePay'><p>" + dom.activityPrice + "元/人</p></div>";
	   	    				}else if(dom.priceType==2){
 								price += "<div class='activePay'><p>" + dom.activityPrice + "元/张</p></div>";
	   	    				}else if(dom.priceType==3){
 								price += "<div class='activePay'><p>" + dom.activityPrice + "元/份</p></div>";
	   	    				}else{
    							price += "<div class='activePay'><p>" + dom.activityPrice + "元/张</p></div>";
    						}
                        } else {
                        	price += "<div class='activePay'><p>收费</p></div>";
                        }
    				}else{
    					price += "<div class='activePay'><p>免费</p></div>";
    				}
       			}else{
       				price += "<div class='activePay actOrderNone'><p>已订完</p></div>";
       			}
    			var tagHtml = "<ul class='activeTab'>";
    			tagHtml += "<li>"+dom.tagName+"</li>";
    			$.each(dom.subList, function (j, sub) {
    				if(j==2){
    					return false;
    				}
    				tagHtml += "<li>"+sub.tagName+"</li>";
    			});
    			tagHtml += "</ul>"
    			var isReservationHtml = "";
    			if(dom.activityIsReservation == 2){
    				if(dom.spikeType == 1){
    					isReservationHtml += "<div class='activeState'><img src='${path}/STATIC/wechat/image/miao.png'/></div>";
    				}else{
    					isReservationHtml += "<div class='activeState'><img src='${path}/STATIC/wechat/image/ding.png'/></div>";
    				}
    			}
    			$("#index_list").append("<li activityId=" + dom.activityId + " onclick='showActivity(\"" + dom.activityId + "\")'>" +
											"<div class='activeList'>" +
												"<img class='lazy' src='${path}/STATIC/wechat/image/placeholder.png' data-original='" + activityIconUrl + "' width='750' height='475'/>" +
												isReservationHtml + distanceHtml + tagHtml + price +
											"</div>" +
											"<p class='activeTitle'>"+dom.activityName+"</p>" +
											"<p class='activePT'>"+time+" | "+dom.activityLocationName+"</p>" +
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
		window.location.href="${path}/wechatActivity/preActivityDetail.do?activityId="+activityId+"&userId="+userId+"&callback=${callback}&sourceCode=${sourceCode}";
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
			$("#containerImg").attr("src","${path}/STATIC/wechat/image/newmenu/map.png");
			$("#mapContainer").hide();
			$("#listContainer").show();
			$("#containerValue").val("2");
		}else{	//切换到地图
			$("#mapList").show();
			acticityLoad();		//防止地图中心错位，重新加载活动
			$("#containerImg").attr("src","${path}/STATIC/wechat/image/newmenu/map2.png");
			$("#mapContainer").show();
			$("#listContainer").hide();
			$("#containerValue").val("1");
		}
	}
	
	//跳转到日历
    function preCalendar(){
    	window.location.href = '${path}/wechatActivity/preActivityCalendar.do';
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
		padding-top:110px;
	}
	html,body,.main,.content{height: 100%;background-color:#f3f3f3}
	.info {
		background-color: #fff;
		width: 710px;
		position: absolute;
		bottom: 0px;
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
	.swiper-container4  > .swiper-pagination-bullets, .swiper-container4 .swiper-pagination-custom, .swiper-container4 .swiper-pagination-fraction{
				bottom: 155px;
			}
</style>

</head>
<body>
	<div class="main">
		<div class="header">
			<div class="swiper-container">
				<div class="swiper-wrapper" id="tagList"></div>
			</div>
			<div class="menu-more">
				<a href="${path}/wechat/openEdit.do?type=${basePath}wechatActivity/preMap.do"><img src="${path}/STATIC/wechat/image/more.png" /></a>
			</div>
		</div>
		<div class="map-list-2" id="listContainer" style="display: none;">
			<div class="active" style="margin: 0">
				<div class="data-menu top-fixed3" style="width: 370px;left:206px;top:130px;">
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
				<ul id="index_list" class="activeUl"></ul>
			</div>
			<div id="loadingDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>
		</div>
		<div class="content" style="padding-bottom:0px;" id="mapContainer">
			<div style="width: 100%;height: 100%;" class="map_container"></div>
		</div>

		<%@include file="/WEB-INF/why/wechat/footerMenuList.jsp" %>
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
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>文化地图</title>
  <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp" %>
	<script type="text/javascript" src="http://webapi.amap.com/maps?v=1.3&key=322057e2a214acc35616d9071ededcce"></script>
	<style type="text/css">
html,
body {
	height: 100%;
}

.bsTopMenu{
	width: 750px;
	height: 75px;
	margin: 0 auto;
	position: relative;
	overflow: hidden;
	background-color: #fff;
	z-index: 5;
}

.bsTopMenu .swiper-wrapper {
	padding: 0 25px;
}

.bsTopMenu .swiper-slide{
	height: 70px;
	line-height: 70px;
	padding: 0 10px;
	width: auto;
	display: inline-block;
	font-size: 28px;
	border-bottom: 2px solid transparent;
}

.bsTopMenu .swiper-slide.bsTopMenuOn{
	color: #36c7de;
	border-bottom-color: #36c7de;
}

.amap-logo, .amap-copyright { display: none !important; }

.cultureMap { width: 750px; height: 100%; position: absolute; top: 0; right: 0; bottom: 0; left: 0; margin: auto; }

.cultureMapInfo { width: 700px; padding: 0 25px; height: 310px; background-color: #fff; position: absolute; right: 0; left: 0; bottom: 0; margin: auto; z-index: 5; }
.cultureMapInfo .bt { font-size: 28px; color: #333; padding: 12px 0;  white-space: nowrap; text-overflow: ellipsis; -o-text-overflow: ellipsis; overflow: hidden; }
.cultureMapInfo .bt .more {font-size: 24px; color: #e63917;padding-left: 18px;}
.cultureMapInfo .gotoAdd { width: 100px; height: 100px; background: url(${path}/STATIC/wechat/image/mapIcon3.png) no-repeat center; position: absolute; top: -50px; right: 25px; cursor: pointer; }
.cultureMapInfo .culNav {width: 692px;margin: 0 auto; position: relative;background-color: #fff;border-left: 1px solid #e9e9e9;}
.cultureMapInfo .culNav span {display: block;float: left;font-size: 22px;color: #656565;line-height: 48px;height: 48px;text-align: center;width: 153px;border-top: 1px solid #e9e9e9;border-right: 1px solid #e9e9e9;border-bottom: 1px solid #e9e9e9;background-color: #f3f3f3;cursor: pointer;}
.cultureMapInfo .culNav span.cur {background-color: #fff;border-bottom: none;}
.cultureMapInfo .culNav em {display: block;width: 385px;height: 1px;background-color: #e9e9e9;position: absolute;right: 0;bottom: 0;}
.cultureMapInfo .culContWc {width: 691px;margin: 0 auto; border-left: 1px solid #e9e9e9;border-right: 1px solid #e9e9e9;height: 142px;padding-top: 20px;}
.culActVenList {}
.culActVenList li {width: 204px;float: left;margin-left: 20px;position: relative;}
.culActVenList .pic {width: 204px;height: 126px;position: relative;overflow: hidden;}
.culActVenList .pic img {display: block;width: 100%;height: 100%;}
.culActVenList .char {font-size: 24px;color: #424242;text-align: center; line-height: 40px;white-space: nowrap; text-overflow: ellipsis; -o-text-overflow: ellipsis; overflow: hidden;}
.culActVenList .black {width: 100%;height: 126px;line-height: 126px; position: absolute;left: 0;top: 0;background-color: rgba(0,0,0,.6);font-size: 24px;color: #fff;text-align: center;}
input::-webkit-input-placeholder { color: #aaa; }
input:-moz-placeholder { color: #aaa; }
input::-moz-placeholder { color: #aaa; }
input:-ms-input-placeholder { color: #aaa; }
.mapSear {width: 670px;position: fixed;top: 92px;left: 50%;margin-left: -335px;z-index: 90;border: 1px solid #e2e2e2;-webkit-border-radius: 26px;-moz-border-radius: 26px;border-radius: 26px;overflow: hidden;}
.mapSear .txt {display: block;float: left; width: 430px;padding-left: 40px;padding-right: 80px; height: 50px;line-height: 50px;overflow: hidden;border: none;outline: none;font-size: 24px;color: #262626;}
.mapSear .close {display: block;width: 80px;height: 50px;background: url(${path}/STATIC/image/mapClose.png) no-repeat center;position: absolute;top: 0;right: 120px;cursor: pointer;}
.mapSear .ssBtn {display: block;float: left;width: 120px;height: 50px;line-height: 50px;font-size: 24px;color: #ffffff;text-align: center;background-color: #36c7de;cursor: pointer; -webkit-user-select:none;-moz-user-select:none;-ms-user-select:none;user-select:none;-khtml-user-select:none;}
</style>
</head>
<body>
  <div class="bsMain">
			<div class="bsTopMenu bsTopMCollect">
				<div class="swiper-wrapper" id="tagList">
					<div class="swiper-slide bsTopMenuOn" venueType="">全部</div>
				</div>
			</div>
			<div class="mapSear clearfix">
		        <input class="txt" type="text" id="venueName" name="venueName" placeholder="请输入场馆名称" />
		        <span class="close" onclick="$(this).siblings('.txt').val('');"></span>
		        <span class="ssBtn" onclick="loadData()">搜索</span>
		     </div>
			<!-- 文化地图 -->
			<div class="cultureMap" id="cultureMap"></div>
			<div class="cultureMapInfo" id="mapInfo">
				<div class="bt"></div>
				<div class="culNav clearfix">
					<span class="cur">相关活动</span>
					<span>场馆预约</span>
					<em></em>
				</div>
				<div class="culContWc">
					<ul class="culActVenList clearfix" id="activityList">
						
					</ul>
					<ul class="culActVenList clearfix" id="venueRoom" style="display: none;">
						
					</ul>
				</div>
				<div class="gotoAdd" id="gotoAdd"></div>
			</div>

		</div>
</body>
<script type="text/javascript">
var infoJson;
//初始化地图，只需要初始化一次
var culMapInit;
		$(function() {
			culMapInit = initMap();
			toLoadTag();
			loadData();
			
			// 切换
			$('body').on('click', '.culNav span', function () {
				$(this).addClass('cur').siblings().removeClass('cur');
				$('.culContWc .culActVenList').hide();
				$('.culContWc .culActVenList').eq($(this).index()).show();
			});
	
		})

		
		function toLoadTag(){
		 $.post("${path}/wechatVenue/venueTagByType.do", function (data) {
	         if (data.data.length > 0) {
	             $.each(data.data, function (i, dom) {
	                 $("#tagList").append('<div venueType='+dom.tagId+' class="swiper-slide">'+dom.tagName+'</div>');
	             });
	             var mySwiper = new Swiper('.bsTopMenu', {
					slidesPerView: 'auto',
					spaceBetween: 20,
				});
	             
	           //顶部菜单点击事件
	 			$(".bsTopMenu .swiper-slide").on("click", function() {
	 				$(".bsTopMenu .swiper-slide").removeClass("bsTopMenuOn")
	 				$(this).addClass("bsTopMenuOn");
	 				loadData();
	 			});
	         }
	     }, "json");
	}
		
		// 初始化地图
		function initMap() {
			// 初始化地图
			var map = new AMap.Map("cultureMap", {
				// 地图缩放
				zoomEnable: true,
				resizeEnable: false,
				zoom: 16
				// 设置中心点
				// center:[121.438199, 31.284143],
			});

			return map;
		}
		
		function loadData(){
			var venueType=$("#tagList div.bsTopMenuOn").attr("venueType");
			var data = {
			    venueType:venueType,
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
					if(data.data.length==0||venueType==""){
						$("#mapInfo").hide();
					}else{
						$("#mapInfo").show();
					}
					loadMap(culMapInit,infoJson);
				}
			}, "json");
		}

		// 地图上添加单个点
		function addMarket(map, pos, zx,id) {

			var marker = new AMap.Marker({
				map: map,
				position: pos,
				extData:id
			});
			if(typeof zx == 'undefined') {
				marker.setContent('<img src="${path}/STATIC/wechat/image/mapIcon1.png">');
			} else {
				if(zx == 'center') {
					// 是中心点
					marker.setContent('<img src="${path}/STATIC/wechat/image/mapIcon2.png">');
					map.setCenter(pos);
				} else {
					// 不是是中心点
					marker.setContent('<img src="${path}/STATIC/wechat/image/mapIcon1.png">');
				}
			}
			return marker;
		}
		function markerClick(e){
			$("#mapInfo").show();
			 var venueId=e.target.getExtData();
			 relativeAct(venueId);
			 relativeRoom(venueId);
		}
		
		function relativeAct(venueId){
			 var data={
		        		venueId:venueId,
		        		pageIndex:0,
		    			pageNum:2
		        }
		        $.post("${path}/wechatVenue/venueWcMapActivity.do",data,function(data){
		        	if(data.status==0){
		        		$("#activityList").html("");
		        		$.each(data.data,function(i,dom){
		        			$("#activityList").append("<li onclick='activityDetail(\""+dom.activityId+"\");'>"+
		        			"<div class='pic'><img src='"+dom.activityIconUrl+"'/></div>"+
		        			"<div class='char'>"+dom.activityName+"</div>"+
		        			"</li>"
		        			)
		        		});
		        		if(data.data.length>0){
		        		$("#activityList").append("<li>"+
			        			"<div class='pic'><img src=''/></div>"+
			        			"<div class='black' onclick='loadMoreAct(\""+venueId+"\")'>查看更多</div>"+
			        			"</li>")
		        		}
		        	}
		        },"json");
		}
		
		function relativeRoom(venueId){
			 var data={
		        		venueId:venueId,
		        		pageIndex:0,
		    			pageNum:2
		        }
		 $.post("${path}/wechatVenue/activityWcRoom.do",data,function(data){
	        	if(data.status==0){
	        		$("#venueRoom").html("");
	        		$.each(data.data,function(i,dom){
	        			$("#venueRoom").append(
	        					"<li onclick='roomDetail(\""+dom.roomId+"\")'>"+
			        			"<div class='pic'><img src='"+dom.roomPicUrl+"'/></div>"+
			        			"<div class='char'>"+dom.roomName+"</div>"+
			        			"</li>"			
	        			);
	        		});
	        		if(data.data.length>0){
	        		$("#venueRoom").append("<li>"+
		        			"<div class='pic'><img src=''/></div>"+
		        			"<div class='black' onclick='loadMoreRoom(\""+venueId+"\")'>查看更多</div>"+
		        			"</li>")
	        		}
	        	}
	        },"json");
		}
		
		// 加载地图
		function loadMap(map, infoJson) {
			// 清空地图的点
			map.clearMap();

			// 中心点
			var center_dot = null;
			// 添加点的集合
			var markers = [];
			// 数据的条数
			var len_dot = infoJson.length;

			// 页面上dom
			var title = $('.cultureMapInfo .bt');
			var s1 = $('.cultureMapInfo .addsq .s1');
			var s2 = $('.cultureMapInfo .addsq .s2');

			for(var i = 0; i < len_dot; i++) {
				var marker = null;
				if(i == 0) {
					// 第一个设置为中心点，并且添加不同的样式
					marker = addMarket(map, [infoJson[i].venueLon, infoJson[i].venueLat], 'center',infoJson[i].venueId);
					// 把中心点赋给全局变量
					center_dot = marker;

					// 填初始中心点数据
					title.html(infoJson[i].venueName + '<a class="more" href="javascript:moreVenueList();">查看更多&nbsp;&gt;&gt;</a>');
					s1.html('地址：' + infoJson[i].venueAddress);
					s2.html('商圈：' + infoJson[i].extBusinessName);

				} else {
					// 除了中心点，添加其他点，并且设置普通样式
					marker = addMarket(map, [infoJson[i].venueLon, infoJson[i].venueLat],null,infoJson[i].venueId);
				}
				markers.push(marker);
			}

			/* marker.on('click', markerClick); */
			/* start 给默认第一个点调用高德地图导航 */
			$("#gotoAdd").off('click');
			$("#gotoAdd").on('click',function() {
				markers[0].markOnAMAP({
				name:infoJson[0].venueName
				})
			});
			/* end 给默认第一个点调用高德地图导航 */
            // 默认第一个弹窗
          /*   if(markers[0]!=undefined&&markers[0].length!=0){
            	markers[0].on('click', markerClick);
    			markers[0].emit('click', {target: markers[0]});
            } */
			// 给多个点添加事件 并设置为中心点
			for(var i = 0; i < len_dot; i++) {
				(function(i) {
					markers[i].on("click", function(e) {

						/* start 调用高德地图导航 */
						$("#gotoAdd").off('click');
						$("#gotoAdd").on('click',function() {
							markers[i].markOnAMAP({
							name:infoJson[i].venueName
							});
						});
						/* end 调用高德地图导航 */
                        markerClick(e);
		                if(center_dot == this) {
		                    return;
		                }
		                center_dot.setzIndex(100);
	                	markers[i].setzIndex(101);
		                center_dot.setContent('<img src="${path}/STATIC/wechat/image/mapIcon1.png">');
		                markers[i].setContent('<img src="${path}/STATIC/wechat/image/mapIcon2.png">');
		                map.setCenter([infoJson[i].venueLon,infoJson[i].venueLat]);
		                center_dot = this;

		                // 填数据
		                title.html(infoJson[i].venueName+'<a class="more" href="javascript:moreVenueList();">查看更多&nbsp;&gt;&gt;</a>');
		                s1.html('地址：' + infoJson[i].venueAddress);
		                s2.html('商圈：' + infoJson[i].extBusinessName);

					});
				})(i);

			}


		}
		
		function loadMoreAct(venueId){
			window.location.href = "${path}/wechatClutureMap/relativeActivityList.do?venueId="+venueId;
		}
		function loadMoreRoom(venueId){
			window.location.href = "${path}/wechatClutureMap/relativeRoomList.do?venueId="+venueId;
		}
		
		function activityDetail(activityId){
			window.location.href = "${path}/wechatActivity/preActivityDetail.do?activityId="+activityId;
		}
		function roomDetail(roomId){
			window.location.href="${path}/wechatRoom/preRoomDetail.do?roomId="+roomId;
		}
		function moreVenueList(){
			window.location.href="${path}/wechatVenue/toSpace.do";
		}
	</script>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

	<head>
		<title>文化点单</title>
		<%@include file="/WEB-INF/why/wechat/commonFrame.jsp" %>
		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/fsStyle.css" />
		<script type="text/javascript" src="${path}/STATIC/js/location.js"></script>

		<style type="text/css">
			.whlmBanner .swiper-pagination-fraction{
				font-size: 22px;color: #ffffff;
			}
			.whlmBanner .swiper-pagination-current{
				color: #e63917;
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
	                jsApiList: ['previewImage','onMenuShareAppMessage','onMenuShareTimeline','onMenuShareQQ','onMenuShareWeibo','onMenuShareQZone']
	            });
	          //微信分享
	            wx.ready(function () {
	            	var culturalOrderIconUrl = '${basePath}/STATIC/wx/image/share_120.png';
	                wx.onMenuShareAppMessage({
	                    title: "文化点单-精彩节目、文化大餐看不停",
	                    desc: '欢迎进入安康文化云·文化点单',
	                    imgUrl: culturalOrderIconUrl,
	                    success: function () { 
	                    	shareIntegral();
	                    }
	                });
	                wx.onMenuShareTimeline({
	                    title: "文化点单-精彩节目、文化大餐看不停",
	                    imgUrl: culturalOrderIconUrl,
	                    success: function () { 
	                    	shareIntegral();
	                    }
	                });
	                wx.onMenuShareQQ({
	                	title: "文化点单-精彩节目、文化大餐看不停",
	                	desc: '欢迎进入安康文化云·文化点单',
	                    imgUrl: culturalOrderIconUrl,
	                    success: function () { 
	                    	shareIntegral();
	                    }
	                });
	                wx.onMenuShareWeibo({
	                	title: "文化点单-精彩节目、文化大餐看不停",
	                	desc: '欢迎进入安康文化云·文化点单',
	                    imgUrl: culturalOrderIconUrl,
	                    success: function () { 
	                    	shareIntegral();
	                    }
	                });
	                wx.onMenuShareQZone({
	                	title: "文化点单-精彩节目、文化大餐看不停",
	                	desc: '欢迎进入安康文化云·文化点单',
	                    imgUrl: culturalOrderIconUrl,
	                    success: function () { 
	                    	shareIntegral();
	                    }
	                });
	            });
		 }
		//滑屏分页
		var startIndex = 1;
		var pageSize = 20;
		var isNext = true;
		$(function(){
			queryOrderType();
			
			$(".menuTabUl").on('click','li',function(){
				window.location.href="${path}/wechatCulturalOrder/culturalCyOrderIndex.do";
			});
			
			$(".filterWrap").on('click','li',function(){
				var liIndex = $(this).index();
				if($(this).hasClass('open')) {
					$(this).removeClass('open');
					$(".filterListWrap .filterList").eq(liIndex).hide();
					$('.mask').hide();
				} else {
					$(this).addClass('open').siblings('li').removeClass('open');
					$(".filterListWrap .filterList").hide();
					$(".filterListWrap .filterList").eq(liIndex).show();
					
					$('.mask').show();
				}
			});
			
			$('.filterWrap').on('click touchstart', function(e) {
				e = e || e.event;
				e.stopPropagation();
			});
			
			$('.mask').on('click touchmove', function() {
				close();
			});
			
			$('.filterRight').on('click','li',function(){
				var val = $(this).html();console.log(val)
				$(".filterWrap .open").html(val+'<span class="xjt"></span>')
				$(this).addClass('cur').siblings().removeClass('cur');
				close();
			});
		})
			
		function queryOrderType(){				
			//加载类型
			$.post("${path}/sysdict/queryChildSysDictByDictCode.do?dictCode=CULTURAL_ORDER_TYPE",function(data){
				var typeHtml = "";
				 for (var i=0;i<data.length;i++){
		              typeHtml +='<li class="clearfix" value="'+data[i].dictId+'">'+data[i].dictName+'</li>';
		            }
				 $("#qblx").append(typeHtml);
			});
			
			//加载地区
		    var venueProvince = '2822,广东省';
		    var venueCity = '2958,佛山市';
		    //省市区
		    var loc = new Location();
		    var json = loc.find( '0,' + venueProvince.split(",")[0] + ',' + venueCity.split(",")[0]);
		    if (json){
		    $.each(json , function(k , v) {
		      var option = '<li class="clearfix" value="'+k+','+v+'">'+v+'</li>';
		      $("#qbqy").append(option);
		    });
		  }
		    		    							 											   				
		    queryOrderList(startIndex,pageSize);
		}
		
		function queryOrderList(startIndex,pageSize){
			var orderType = $("#zxfb .cur").attr("value");
			if(!orderType){
				orderType = 1;
			}
			$.post("${path}/wechatCulturalOrder/culturalOrderList.do",{
				culturalOrderLargeType:$(".menuTabUl .on").attr("value"),
				culturalOrderType:$("#qblx .cur").attr("value"),
				culturalOrderArea:$("#qbqy .cur").attr("value"),
				culturalOrderDemandLimit:$("#fwdx .cur").attr("value"),
				orderType:orderType,
				page:startIndex,
				rows:pageSize
			},function(data){
				var ltHtml = "";
				var dom = JSON.parse(data);
				if(dom.status == 200){
					var listInfo = dom.data;
					if(listInfo != null){
						$.each(listInfo, function (i, v) {
							ltHtml += '<li onclick="toDetail(\''+v.culturalOrderId+'\',\''+v.culturalOrderLargeType+'\')">'+ 
										'<div class="img"><img src="'+ v.culturalOrderImg +'" width="336px" height="213px"></div>'+
										'<div class="char">'+
										'<p class="tit">'+ v.culturalOrderName +'</p>'+
										'<p class="info">日期：'+ v.startDateStr +'</p>';
										
										if(v.culturalOrderLargeType == 1){
											ltHtml +='<p class="info">地址：'+ v.culturalOrderAddress +'</p>';
										}	
										
										ltHtml +='</div>'+
									'</li>';
						});
					}
				}else{
					isNext = false;
				}	
				$(".whzsList").append(ltHtml);
				isNext = true;
			});
		}	
		
		//跳转到详情页
        function toDetail(culturalOrderId,culturalOrderLargeType){
        	window.location.href='${path}/wechatCulturalOrder/culturalOrderDetail.do?culturalOrderId='+culturalOrderId+'&culturalOrderLargeType='+culturalOrderLargeType+'&userId='+userId;
        }
			
		// 左侧筛选
		function close(){
			$('.filterWrap li').removeClass('open');
			$(".filterListWrap .filterList").hide();
			
			$('.mask').hide();
			$(".whzsList").html("");
			queryOrderList(startIndex,pageSize);
		}	
			
		$(window).on("scroll", function () {
            var scrollTop = $(document).scrollTop();
            var pageHeight = $(document).height();
            var winHeight = $(window).height();
            if (scrollTop >= (pageHeight - winHeight - 100)) {
            	console.log(scrollTop);
           		setTimeout(function () { 
           			if(isNext){
           				startIndex += 1;
           				queryOrderList(startIndex,pageSize);
           			}else{
           			}
           		},800);
            }
        });
		</script>
	</head>

<body style="background-color: #f3f3f3;">
	<div class="fsMain">
		<div class="dhshWrap ddWrap">
			<div class="whzsWrap dhshListWrap">
				<ul class="menuTabUl clearfix">
					<li>我要参与</li>
					<li class="on" value="2">我要邀请</li>
				</ul>
				<div class="fixDiv clearfix">
					<ul class="filterWrap yqFilter clearfix">
						<li>全部类型<span class="xjt"></span></li>
						<li>全部区域<span class="xjt"></span></li>
						<li>服务对象<span class="xjt"></span></li>
						<li>最新发布<span class="xjt"></span></li>
					</ul>
					<div class="filterListWrap">
						<div class="filterList clearfix" style="display: none;">
							<ul id="qblx" class="filterRight" style="width: 720px;">
							</ul>
						</div>
						<div class="filterList clearfix" style="display: none;">
							<ul id="qbqy" class="filterRight" style="width: 720px;">
							</ul>
						</div>
						<div class="filterList clearfix" style="display: none;">
							<ul id="fwdx" class="filterRight" style="width: 720px;">
								<li class="clearfix" value="1">个人</li>
								<li class="clearfix" value="2">单位</li>
								<li class="clearfix" value="3">不限</li>
							</ul>
						</div>
						<div class="filterList clearfix" style="display: none;">
							<ul id="zxfb" class="filterRight" style="width: 720px;">
								<li class="clearfix" value="1">最新发布</li>
								<li class="clearfix" value="2">邀请次数</li>
							</ul>
						</div>
					</div>
				</div>

				<div class="mask" style="display: none;width: 100%;height: 100%;background-color: rgba(0,0,0,.6);position: fixed;left: 0;top: 0;z-index: 9;"></div>
				<ul class="whzsList clearfix"></ul>
			</div>
		</div>
	</div>
</body>

</html>
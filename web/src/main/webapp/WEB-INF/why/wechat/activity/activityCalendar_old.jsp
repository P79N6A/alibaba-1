<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <!-- <title>活动列表</title> -->
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
    <script type="text/javascript" src="${path}/STATIC/wechat/js/jquery.lazyload.min.js"></script>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>

    <script type="text/javascript">
    	$.ajaxSettings.async = false; 	//同步执行ajax
    	var userId = '${sessionScope.terminalUser.userId}';
    	var calendar_url = '${url}';	//本页相对路径
        var select_startData = '';	//开始日期
        var select_endData = '';	//结束日期
        var startIndex = 0;		//页数
        var tabType = 1;	//默认加载接口类型
        
        var calendarTab1 = localStorage.getItem("calendarTab1");
        var calendarTab2 = localStorage.getItem("calendarTab2");
        var calendarId = localStorage.getItem("calendarId");
        var calendarTab2Time = localStorage.getItem("calendarTab2Time");
        var calendarSearch1 = localStorage.getItem("calendarSearch1");	//区域
        var calendarSearch2 = localStorage.getItem("calendarSearch2");	//类型
        var calendarSearch3 = localStorage.getItem("calendarSearch3");	//筛选
        var calendarSearch4 = localStorage.getItem("calendarSearch4");	//商圈
        
      	//判断是否是微信浏览器打开
        if (is_weixin()) {
        	//通过config接口注入权限验证配置
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
                    title: "我找到了一份上海精彩文化活动日历-文化云",
                    desc: '提供公众文化生活和消费的互联网平台，为公众提供便捷和有品质的文化生活服务。',
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
                    link: '${basePath}wechatActivity/preActivityCalendar.do'
                });
                wx.onMenuShareTimeline({
                    title: "我找到了一份上海精彩文化活动日历-文化云",
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
                    link: '${basePath}wechatActivity/preActivityCalendar.do'
                });
                wx.onMenuShareQQ({
                	title: "我找到了一份上海精彩文化活动日历-文化云",
                	desc: '提供公众文化生活和消费的互联网平台，为公众提供便捷和有品质的文化生活服务。',
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
                wx.onMenuShareWeibo({
                	title: "我找到了一份上海精彩文化活动日历-文化云",
                	desc: '提供公众文化生活和消费的互联网平台，为公众提供便捷和有品质的文化生活服务。',
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
                wx.onMenuShareQZone({
                	title: "我找到了一份上海精彩文化活动日历-文化云",
                	desc: '提供公众文化生活和消费的互联网平台，为公众提供便捷和有品质的文化生活服务。',
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
            });
        }
        
        $(function () {

			//分享
			$(".index-top-6").click(function() {
				if (!is_weixin()&&!(/wenhuayun/.test(ua))) {
					dialogAlert('系统提示', '请用微信浏览器打开分享！');
				}else{
					$("html,body").addClass("bg-notouch");
					$(".background-fx").css("display", "block")
				}
			})
			$(".background-fx").click(function() {
				$("html,body").removeClass("bg-notouch");
				$(".background-fx").css("display", "none")
			})
			//关注
			$(".index-top-7").on("touchstart", function() {
				$('.div-share').show()
				$("body,html").addClass("bg-notouch")
			})
				
			//筛选列表
			$(".data-menu1").on("click", function() {
				$(".data-menu1,.data-menu2,.data-menu3").hide()
				$(".data-menu").animate({
					height: "315px"
				})
				$(".data-menu1-on").show()
			})
			$(".data-menu2").on("click", function() {
				$(".data-menu1,.data-menu2,.data-menu3").hide()
				$(".data-menu").animate({
					width: "170px",
					left: "290px",
					height: "315px"
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
			
			//fixed	
			$(document).on("touchmove", function() {
				var height_top = $(".active-num-div").position().top - 100;
				var height_top2 = $(".data-menu-m").position().top - 110;
				$(window).scroll(function() {
					if ($(document).scrollTop() > height_top) {
						$(".active-num").addClass("top-fixed")
					} else if ($(document).scrollTop() < height_top) {
						$(".active-num").removeClass("top-fixed")
					}

					//筛选列表浮动
					if ($(document).scrollTop() > height_top2) {
						$(".data-menu").addClass("top-fixed2")
					} else if ($(document).scrollTop() < height_top2) {
						$(".data-menu").removeClass("top-fixed2")
					}

				})
			});
			//底部菜单
			if (!browser.versions.android) {		//非安卓(安卓不识别touchend)
				$(document).on("touchmove", function() {
					$(".footer").hide()
				}).on("touchend", function() {
					$(".footer").show()
				})
			}
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
        });
        
        //加载广告位
        function loadAdvert(){
        	if(select_startData==''&&select_endData==''){
        		var date = new Date();
        		formatDate(date);
        	}
        	$.post("${path}/wechatActivity/queryCalendarAdvert.do", {date:select_startData}, function (data) {
        		if(data.status==200){
        			var dom = data.data;
        			var advImgUrl = getIndexImgUrl(dom.advImgUrl, "_750_380");
        			if(dom.advLink==1){	//外链
        				$("#calendarAdvert").html("<img src='"+advImgUrl+"' height='380' width='750' onclick='preOutUrl(\"" + dom.advUrl + "\");'></img>");
                    }else{	//内链
                    	if(dom.advLinkType==0){	//活动列表
                    		$("#calendarAdvert").html("<img src='"+advImgUrl+"' height='380' width='750' onclick='preInActList(\"" + dom.advUrl + "\");'/>");
                    	}else if(dom.advLinkType==1){	//活动详情
                    		$("#calendarAdvert").html("<img src='"+advImgUrl+"' height='380' width='750' onclick='preInActDetail(\"" + dom.advUrl + "\");'/>");
                    	}else if(dom.advLinkType==2){	//场馆列表
                    		$("#calendarAdvert").html("<img src='"+advImgUrl+"' height='380' width='750' onclick='preInVenList(\"" + dom.advUrl + "\");'/>");
                    	}else if(dom.advLinkType==3){	//场馆详情
                    		$("#calendarAdvert").html("<img src='"+advImgUrl+"' height='380' width='750' onclick='preInVenDetail(\"" + dom.advUrl + "\");'/>");
                    	}
                    }
        		}else{
        			$("#calendarAdvert").html("");
        		}
        	}, "json");
        }
        
      	//跳外链
        function preOutUrl(url){ window.location.href = url; };
        //跳活动列表
        function preInActList(name){ window.location.href = '${path}/wechatActivity/preActivityList.do?activityName='+name; };
        //跳活动详情
		function preInActDetail(id){ window.location.href = '${path}/wechatActivity/preActivityDetail.do?activityId='+id; };
		//跳场馆列表
        function preInVenList(name){ window.location.href = '${path}/wechatVenue/preVenueList.do?venueName='+name; };
        //跳场馆详情
        function preInVenDetail(id){ window.location.href = '${path}/wechatVenue/venueDetailIndex.do?venueId='+id; };
        
        //活动场数（日日历）
        function loadCount(){
        	if(select_startData==''&&select_endData==''){
        		var date = new Date();
        		formatDate(date);
        	}
        	$.post("${path}/wechatActivity/wcEveryDateActivityCount.do", {startDate:select_startData,endDate:select_endData}, function (data) {
        		if(data.status==1){
        			$.each(data.data,function(key,values){
        				$("#calendarTitle").html(key.replace("-", "年").replace("-", ".")+"（共"+values+"场）");
        			});
        		}
        	}, "json");
        }
        
        //活动场数（周日历）
        function loadCountByTime(startDate,endDate,n){
        	$.post("${path}/wechatActivity/wcDatePartActivityCount.do", {startDate:startDate,endDate:endDate}, function (data) {
        		if(data.status==100){
        			count = data.data;
        			$("#weekDate"+n).html(startDate.substring(5,10).replace("-",".")+"-"+endDate.substring(5,10).replace("-","."));
					$("#weekCount"+n).html("[共"+data.data+"场]");
        		}
        	}, "json");
        }

        //加载活动列表
        function loadData(index, pagesize) {
        	if(index==0){
    			$("#index_list").html("");
    		}
        	//图片懒加载开始位置
        	var liCount = $("#index_list li").length;
        	if(select_startData==''&&select_endData==''){
        		var date = new Date();
        		formatDate(date);
        	}
        	if(tabType==1){	//日周月
        		var data = {
                	userId: userId,
                	startDate: select_startData,
                	endDate: select_endData,
                	activityArea: $("#areaVal").val(),
                	activityLocation: $("#locationVal").val(),
                	activityType: $("#tagVal").val(),
                	activityIsFree: $("#isFreeVal").val(),
                	activityIsReservation: $("#isReservationVal").val(),
                    pageIndex: index,
                    pageNum: pagesize
                };
        		if($(".data-tab-bgon").text()=="月"){
        			data = {
                    	userId: userId,
                    	startDate: select_startData,
                    	endDate: select_endData,
                    	activityArea: $("#areaVal").val(),
                    	activityLocation: $("#locationVal").val(),
                    	activityType: $("#tagVal").val(),
                    	activityIsFree: $("#isFreeVal").val(),
                    	activityIsReservation: $("#isReservationVal").val(),
                        pageIndex: index,
                        pageNum: pagesize,
                        type: "month"
                    };
        		}
                $.post("${path}/wechatActivity/wcActivityCalendarList.do", data, function (data) {
                	if(data.status==100){
                		if(data.data.length<20){
                			if(data.data.length==0&&index==0){
                				$("#loadingDiv").html("<span class='noLoadingSpan'>没有找到合适的结果，换个试试看吧~</span>");
                			}else{
                				$("#loadingDiv").html("");
                			}
    	        		}
                		$.each(data.data, function (i, dom) {
                			var time = dom.activityStartTime.substring(5,10).replace("-",".");
            				if(dom.activityEndTime.length>0&&dom.activityStartTime!=dom.activityEndTime){
            					time += "-"+dom.activityEndTime.substring(5,10).replace("-",".");
            				}
                			var activityIconUrl = getIndexImgUrl(dom.activityIconUrl, "_750_500");
                			var collectHtml = "";
                			if (dom.activityIsCollect == 1) {	//收藏
                				collectHtml = "<div class='tab-p15' activityId="+dom.activityId+"><img src='${path}/STATIC/wechat/image/star-on.png' onclick='collectBut($(this),\""+dom.activityId+"\")'/></div>"
                            }else{
                            	collectHtml = "<div class='tab-p15' activityId="+dom.activityId+"><img src='${path}/STATIC/wechat/image/star.png' onclick='collectBut($(this),\""+dom.activityId+"\")'/></div>"
                            }
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
                			$("#index_list").append("<li activityId=" + dom.activityId + ">" +
						    							"<div class='activeList'>" +
															"<img class='lazy' src='${path}/STATIC/wechat/image/placeholder.png' data-original='" + activityIconUrl + "' width='750' height='475' onclick='showActivity(\"" + dom.activityId + "\")'/>" +
															collectHtml + isReservationHtml + tagHtml + price +
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
                	}
                }, "json");
        	}else if(tabType==2){		//我的活动
        		var data = {
                	userId: userId,
                	startDate: select_startData,
                	endDate: select_endData,
                    pageIndex: index,
                    pageNum: pagesize
                };
                $.post("${path}/wechatActivity/wcMonthActivityList.do", data, function (data) {
                	if(data.status==100){
                		if(data.data.length<20){
                			if(data.data.length==0&&index==0){
                				$("#loadingDiv").html("<span class='noLoadingSpan'>没有找到合适的结果，换个试试看吧~</span>");
                			}else{
                				$("#loadingDiv").html("");
                			}
    	        		}
                		$.each(data.data, function (i, dom) {
                			var activityIconUrl = getIndexImgUrl(dom.activityIconUrl, "_750_500");
                			var time = "";
                			if(dom.activityIsReserved==1){
                				time = "<div class='tab-p14'><p>已预订|"+dom.eventDateTime+"</p></div>"
                			}else if(dom.activityIsReserved==3){
                				time = "<div class='tab-p14'><p>直接前往|"+dom.eventDateTime+"</p></div>"
                			}else{
                				time = "<div class='tab-p14'><p>未预订|"+dom.eventDateTime+"</p></div>"
                			}
                			var collectHtml = "";
                			if(dom.orderOrCollect==2){
                				if (dom.activityIsCollect == 1) {	//收藏
                    				collectHtml = "<div class='tab-p15' activityId="+dom.activityId+"><img src='${path}/STATIC/wechat/image/star-on.png' onclick='collectBut($(this),\""+dom.activityId+"\")'/></div>"
                                }else{
                                	collectHtml = "<div class='tab-p15' activityId="+dom.activityId+"><img src='${path}/STATIC/wechat/image/star.png' onclick='collectBut($(this),\""+dom.activityId+"\")'/></div>"
                                }
                			}
                			var price = "";
                			if(dom.activityAbleCount > 0 || dom.activityIsReservation == 1){
       	        				if(dom.activityIsFree==2){
       	   	    					if (dom.activityPrice.length != 0 && dom.activityPrice > 0) {
       	   	    						if(dom.priceType==0){
       	   	    							price += "<div class='activePay'><p>" + dom.activityPrice + "元起</p></div>";
       	   	    						}else{
       	   	    							price += "<div class='activePay'><p>" + dom.activityPrice + "元/人</p></div>";
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
                			$("#index_list").append("<li activityId=" + dom.activityId + ">" +
						    							"<div class='activeList'>" +
															"<img class='lazy' src='${path}/STATIC/wechat/image/placeholder.png' data-original='" + activityIconUrl + "' width='750' height='475' onclick='showActivity(\"" + dom.activityId + "\")'/>" +
															time + collectHtml + tagHtml + price +
						    							"</div>" +
						    							"<p class='activeTitle'>"+dom.activityName+"</p>" +
						    							"<p class='activePT'>"+dom.activityLocationName+"</p>" +
						    						"</li>");
                		});
                		
                		//图片懒加载
            			$("#index_list li:gt("+liCount+") img.lazy,#index_list li:eq("+liCount+") img.lazy").lazyload({
    	        		    effect : "fadeIn",
    	        		    effectspeed : 1000
    	        		});
                	}
                	if(data.status==200){
                		window.location.href = '${path}/muser/login.do?type=${basePath}wechatActivity/preActivityCalendar.do';
		                return;
                	}
                }, "json");
        	}else if(tabType==3){		//已参加活动
        		var data = {
                	userId: userId,
                    pageIndex: index,
                    pageNum: pagesize
                };
                $.post("${path}/wechatActivity/wcHistoryActivityList.do", data, function (data) {
                	if(data.status==100){
                		if(data.data.length<20){
                			if(data.data.length==0&&index==0){
                				$("#loadingDiv").html("<span class='noLoadingSpan'>没有找到合适的结果，换个试试看吧~</span>");
                			}else{
                				$("#loadingDiv").html("");
                			}
    	        		}
                		$.each(data.data, function (i, dom) {
                			var activityIconUrl = getIndexImgUrl(dom.activityIconUrl, "_750_500");
                			var time = "";
                			if(dom.activityIsReserved==1){
                				time = "<div class='tab-p14'><p>已预订|"+dom.eventDateTime+"</p></div>"
                			}else{
                				time = "<div class='tab-p14'><p>未预订|"+dom.eventDateTime+"</p></div>"
                			}
                			var collectHtml = "";
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
                			$("#index_list").append("<li activityId=" + dom.activityId + ">" +
						    							"<div class='activeList'>" +
															"<img class='lazy' src='${path}/STATIC/wechat/image/placeholder.png' data-original='" + activityIconUrl + "' width='750' height='475' onclick='showActivity(\"" + dom.activityId + "\")'/>" +
															time + tagHtml + price +
						    							"</div>" +
						    							"<p class='activeTitle'>"+dom.activityName+"</p>" +
						    							"<p class='activePT'>"+dom.activityLocationName+"</p>" +
						    						"</li>");
                		});
                		
                		//图片懒加载
            			$("#index_list li:gt("+liCount+") img.lazy,#index_list li:eq("+liCount+") img.lazy").lazyload({
    	        		    effect : "fadeIn",
    	        		    effectspeed : 1000
    	        		});
                	}
                	if(data.status==200){
                		window.location.href = '${path}/muser/login.do?type=${basePath}wechatActivity/preActivityCalendar.do';
		                return;
                	}
                }, "json");
        	}
        }

        function showActivity(activityId) {
        	localStorage.setItem("calendarId", activityId);	//界面位置缓存
        	
            window.location.href = "${path}/wechatActivity/preActivityDetail.do?activityId=" + activityId;
        }
        
        //判断是否存在预加载Id
        function findDataById() {
        	if(select_startData==''&&select_endData==''){
        		var date = new Date();
        		formatDate(date);
        	}
        	if(tabType==1){	//日周月
        		var data = {
                	userId: userId,
                	startDate: select_startData,
                	endDate: select_endData,
                	activityArea: $("#areaVal").val(),
                	activityLocation: $("#locationVal").val(),
                	activityType: $("#tagVal").val(),
                	activityIsFree: $("#isFreeVal").val(),
                	activityIsReservation: $("#isReservationVal").val()
                };
                $.post("${path}/wechatActivity/wcActivityCalendarList.do", data, function (data) {
                	if(data.status==100){
                		var num = 20;
                		$.each(data.data, function (i, dom) {
                			if(dom.activityId == calendarId){
                				num = Math.ceil((i+1)/20)*20;
                				startIndex = (Math.ceil((i+1)/20)-1)*20;
                			}
                		});
                		loadData(0, num);
                	}
                }, "json");
        	}else if(tabType==2){		//我的活动
        		var data = {
                	userId: userId,
                	startDate: select_startData,
                	endDate: select_endData
                };
                $.post("${path}/wechatActivity/wcMonthActivityList.do", data, function (data) {
                	if(data.status==100){
                		var num = 20;
                		$.each(data.data, function (i, dom) {
                			if(dom.activityId == calendarId){
                				num = Math.ceil((i+1)/20)*20;
                				startIndex = (Math.ceil((i+1)/20)-1)*20;
                			}
                		});
                		loadData(0, num);
                	}
                	if(data.status==200){
                		window.location.href = '${path}/muser/login.do?type=${basePath}wechatActivity/preActivityCalendar.do';
		                return;
                	}
                }, "json");
        	}else if(tabType==3){		//已参加活动
        		var data = {
                	userId: userId
                };
                $.post("${path}/wechatActivity/wcHistoryActivityList.do", data, function (data) {
                	if(data.status==100){
                		var num = 20;
                		$.each(data.data, function (i, dom) {
                			if(dom.activityId == calendarId){
                				num = Math.ceil((i+1)/20)*20;
                				startIndex = (Math.ceil((i+1)/20)-1)*20;
                			}
                		});
                		loadData(0, num);
                	}
                	if(data.status==200){
                		window.location.href = '${path}/muser/login.do?type=${basePath}wechatActivity/preActivityCalendar.do';
		                return;
                	}
                }, "json");
        	}
        }
        
      	//加载区域
        function loadArea() {
        	$.ajax({type:'POST', url:"${path}/wechatActivity/getAllArea.do",dataType: "json",async: false,
        		success: function (data) {
	                if (data.status == 200) {
	                	$.each(data.data, function (i, dom) {
	                		$("#areaList").append("<p data-option=" + dom.dictCode + ">"+dom.dictName+"</p>");
	                		var addressHtml = "<div style='display:none;'><p data-option='' data-name='"+dom.dictName+"'>全部" + dom.dictName + "</p>";
	                        $.each(dom.dictList, function (i, dom2) {
	                            addressHtml += "<p data-option=" + dom2.id + " data-name='"+dom2.name+"'>" + dom2.name + "</p>";
	                        });
	                        addressHtml += "</div>";
	                        $("#locationList").append(addressHtml);
	                	});
	                	
	                	$("#areaList p").on("click", function () {
	                		localStorage.setItem("calendarSearch1", $(this).attr("data-option"));	//界面位置缓存
	                		$("#areaVal").val($(this).attr("data-option"));
	                		
	                		//选中区域，显示相应商圈
	                		$("#areaList p").removeClass("bg262626");
	                		$(this).addClass("bg262626");
	                		$(".data-menu-place2 div").not(".close-button").hide();
							$(".data-menu-place2 div:eq(" + ($(this).index()+1) + ")").show();
	                		
	                		if($(this).attr("data-option")==''){	//全上海
	                			localStorage.removeItem("calendarSearch4");
	                			//重新加载页面
		        				reloadHtml();
		                		//收起筛选界面
		                		closeMenu();
	                			$('.data-menu1').html('全部商区');
	                		}
	                	});
	                	
	                	$("#locationList p").on("click", function () {
	                		localStorage.setItem("calendarSearch4", $(this).attr("data-option"));	//界面位置缓存
	                		$("#locationVal").val($(this).attr("data-option"));
	                		
                			//重新加载页面
	        				reloadHtml();
	                		//收起筛选界面
	                		closeMenu();
                			$('.data-menu1').html($(this).attr('data-name').length>3?$(this).attr('data-name').substring(0,3)+"...":$(this).attr('data-name'));
	                	});
	                	
	                	//载入历史选择1、4
	                	if(calendarSearch1!=null){
	                    	$("#areaVal").val(calendarSearch1);
	                    	$("#areaList p").each(function () {
	                    		if($(this).attr("data-option")==calendarSearch1){
	                    			if(calendarSearch1!=''){
	                    				$(this).addClass("bg262626");
	                    				$(".data-menu-place2 div").not(".close-button").hide();
            							$(".data-menu-place2 div:eq(" + ($(this).index()+1) + ")").show();
	                    				if(calendarSearch4!=null){
	                    					$("#locationVal").val(calendarSearch4);
	                    					$("#locationList p").each(function () {
	                    						if($(this).attr("data-option")==calendarSearch4){
	                    							$('.data-menu1').html($(this).attr('data-name').length>3?$(this).attr('data-name').substring(0,3)+"...":$(this).attr('data-name'));
	                    						}
	                    					});
	                    				}
	                    			}else{
	                        			$('.data-menu1').html('全部商区');
	                        		}
	                    		}
	                    	});
	                    }
	                }
        		}
            });
        }
      	
      	//活动标签
        function loadTag() {
        	$.ajax({type:'POST', url:"${path}/wechatActivity/wcActivityTagList.do",data:{userId: userId},dataType: "json",async: false,
        		success: function (data) {
	                if (data.status == 0) {
	                    $.each(data.data, function (i, dom) {
	                        $("#tagList").append("<p data-option='" + dom.tagId + "');\">"+dom.tagName+"</p>");
	                    });
	            
	                    $("#tagList p").on("click", function () {
	                    	localStorage.setItem("calendarSearch2", $(this).attr("data-option"));	//界面位置缓存
	                		$("#tagVal").val($(this).attr("data-option"));
	                		//重新加载页面
	        				reloadHtml();
	        				//收起筛选界面
	                		closeMenu();
	                		//显示所选内容
	                		if($(this).attr("data-option")!=''){
	                			$('.data-menu2').html($(this).html());
	                		}else{
	                			$('.data-menu2').html('分类');
	                		}
	                	});
	                    
	                  	//载入历史选择2
	                	if(calendarSearch2!=null){
	                    	$("#tagVal").val(calendarSearch2);
	                    	$("#tagList p").each(function () {
	                    		if($(this).attr("data-option")==calendarSearch2){
	                    			if(calendarSearch2!=''){
	                    				$('.data-menu2').html($(this).html());
	    	                		}else{
	    	                			$('.data-menu2').html('分类');
	    	                		}
	                    		}
	                    	});
	                    }
	                }
        		}
            });
        };
        
       	//加载月份（我的活动）
        function loadFiveMonth(){
        	var d = new Date().getDate();
        	var m = new Date().getMonth() + 1;
        	var y = new Date().getFullYear();
        	if (d < 10) {
                d = "0" + d;
            }
       		for(var i=0;i<5;i++){
       			if(m>12){
       				var day = new Date(y+1,m-12,0);
       				var m2 = m;
       				if((m2-12)<10){
       					m2 = "0" + (m2-12);
       				}
       				if(i==0){
       					$("#monthUl").append("<li><a class='border-bottom2 font-cb' s='"+(y+1)+"-"+m2+"-"+d+"' e='"+(y+1)+"-"+m2+"-"+day.getDate()+"'>"+(m-12)+"月</a></li>");
           			}else{
           				$("#monthUl").append("<li><a s='"+(y+1)+"-"+m2+"-01' e='"+(y+1)+"-"+m2+"-"+day.getDate()+"'>"+(m-12)+"月</a></li>");
           			}
       			}else{
       				var day = new Date(y,m,0);
       				var m2 = m;
       				if(m2<10){
       					m2 = "0" + m2;
       				}
       				if(i==0){
       					$("#monthUl").append("<li><a class='border-bottom2 font-cb' s='"+y+"-"+m2+"-"+d+"' e='"+y+"-"+m2+"-"+day.getDate()+"'>"+m+"月</a></li>");
       				}else{
       					$("#monthUl").append("<li><a s='"+y+"-"+m2+"-01' e='"+y+"-"+m2+"-"+day.getDate()+"'>"+m+"月</a></li>");
       				}
       			}
       			m++;
       		}
       		//我的活动切换
			$(".sp-p1 li a,.month-more a").click(function(){
				reloadMenu();
				$(".sp-p1 li a,.month-more a").removeClass("border-bottom2");
				$(".sp-p1 li a,.month-more a").removeClass("font-cb");
				$(this).addClass("border-bottom2");
				$(this).addClass("font-cb");
			});
       		//点击月份
       		$("#monthUl li a").on("click", function () {
       			localStorage.setItem("calendarTab2", $(this).parent("li").index());	//界面位置缓存
       			
       			select_startData = $(this).attr("s");	//开始日期
		        select_endData = $(this).attr("e");	//结束日期
		        tabType = 2;
		        reloadHtml();	//重新加载列表
       		});
       		//已参加
			$(".month-more a").click(function(){
				localStorage.setItem("calendarTab2", "5");	//界面位置缓存
				
				tabType = 3;
		        reloadHtml();	//重新加载列表
			})
        }
       	
      	//日、周、月、我的活动切换
        function selectTab1(num){
        	localStorage.setItem("calendarTab1", num);	//界面位置缓存
        	
        	$('.data-tab1 li').removeClass("data-tab-bgon");
        	$('.data-tab1 li:eq('+num+')').addClass("data-tab-bgon");
			var data_tab2 = $('.data-tab2>li');
			data_tab2.css('display', 'none');
			data_tab2.eq(num).css('display', 'block');
			if(num==0){		//日日历
				$(".data-menu").show();
				$(".dbd a ").removeClass("selected");	//清除已选日期
				
				select_startData = '';	//开始日期
		        select_endData = '';	//结束日期
		        loadCount();
				$(".active-num-div").show();
		        tabType = 1;
				reloadHtml();	//重新加载列表
			}
			if(num==1){		//周日历
				$("#calendarAdvert").empty();
				loadCountByTime(getdaybytype(1)[0],getdaybytype(1)[1],1);	//本周
				loadCountByTime(getdaybytype(2)[0],getdaybytype(2)[1],2);	//本周末
				loadCountByTime(getdaybytype(3)[0],getdaybytype(3)[1],3);	//下周
				$(".active-num-div").show();
				$(".data-menu").show();
		        tabType = 1;
				selectTab2(0);	//默认加载第一个分类
			}
			if(num==2){		//月日历
				$("#calendarAdvert").empty();
				$(".active-num-div").hide();
				$(".data-menu").show();
		        tabType = 1;
				selectTab3(0);	//默认加载第一个分类
			}
			if(num==3){		//我的活动日历
				$("#calendarAdvert").empty();
				if (userId == null || userId == '') {
	                window.location.href = '${path}/muser/login.do?type=${basePath}wechatActivity/preActivityCalendar.do';
	                return;
	            }
				
				$(".active-num-div").hide();
				$(".data-menu").hide();		//隐藏筛选界面
				
				//恢复默认选择
				$(".sp-p1 li a,.month-more a").removeClass("border-bottom2");
				$(".sp-p1 li a,.month-more a").removeClass("font-cb");
				$(".sp-p1 li a:eq(0)").addClass("border-bottom2");
				$(".sp-p1 li a:eq(0)").addClass("font-cb");
				
				select_startData = getdaybytype(6)[0];	//开始日期
		        select_endData = getdaybytype(6)[1];	//结束日期
		        tabType = 2;
				reloadHtml();	//重新加载列表
			}
        }
      	
      	//本周、本周末、下周切换
      	function selectTab2(num){
      		if(num>2){	//以防万一
      			num = 0;
      		}
      		
      		var $this = $(".data-tab2-week-p-bb:eq("+num+")");
			localStorage.setItem("calendarTab2", num);	//界面位置缓存
			
			$(".data-tab2-week-p-bb").removeClass("border-bottom2");
			$(".data-tab2-week-p1").removeClass("data-tab2-week-p1-bold");
			$this.addClass("border-bottom2");
			$this.find(".data-tab2-week-p1").addClass("data-tab2-week-p1-bold");
			
			$("#calendarTitle").html(getdaybytype(eval($this.attr("weekType")))[0].substring(5,10).replace("-",".")+"-"+getdaybytype(eval($this.attr("weekType")))[1].substring(5,10).replace("-","."));
			select_startData = getdaybytype(eval($this.attr("weekType")))[0];	//开始日期
	        select_endData = getdaybytype(eval($this.attr("weekType")))[1];	//结束日期
	        reloadHtml();	//重新加载列表
      	}
      	
      	//下月、全年切换
      	function selectTab3(num){
      		if(num>1){	//以防万一
      			num = 0;
      		}
      		
      		var $this = $(".data-tab2-month-p1:eq("+num+")");
			localStorage.setItem("calendarTab2", num);	//界面位置缓存
			
			$(".data-tab2-month-p1").removeClass("border-bottom2");
			$this.addClass("border-bottom2");
			
			select_startData = getdaybytype(eval($this.attr("monthType")))[0];	//开始日期
	        select_endData = getdaybytype(eval($this.attr("monthType")))[1];	//结束日期
	        reloadHtml();	//重新加载列表
      	}
        
      	//滑屏分页
        $(window).on("scroll", function () {
            var scrollTop = $(document).scrollTop();
            var pageHeight = $(document).height();
            var winHeight = $(window).height();
            if (scrollTop >= (pageHeight - winHeight - 10)) {
           		startIndex += 20;
           		var index = startIndex;
           		setTimeout(function () { 
   					loadData(index, 20);
           		},200);
            }
        });
        
        //时间格式转换
        function formatDate(date){
        	select_startData = date.getFullYear() + "-";
        	var m = date.getMonth() + 1;
        	select_startData += m<10?"0"+m:m;
        	select_startData += "-";
        	select_startData += date.getDate()<10?"0"+date.getDate():date.getDate();
        	select_endData = select_startData;
        }
        
        //重新加载列表
        function reloadHtml(){
    		startIndex = 0;		//重置分页
        	//重置加载中
        	$("#loadingDiv").html("<img class='loadingImg' src='${path}/STATIC/wechat/image/loading.gif'/><span class='loadingSpan'>加载中。。。</span><div style='clear:both'></div>");
    		loadData(startIndex, 20);
        }
        
        //收起筛选界面
        function closeMenu(){
        	$(".data-menu1-on").hide();
			$(".data-menu2-on").hide();
			$(".data-menu3-on").hide();
			$(".data-menu").animate({
				width: "500px",
				height: "60px",
				left: "128px",
			});
			$(".data-menu1,.data-menu2,.data-menu3").show();
        }
        
        //重新加载筛选界面
        function reloadMenu(){
        	$('.data-menu1').html('全部商区');
        	$('.data-menu2').html('分类');
        	$('.data-menu3').html('筛选');
        	$("#areaVal").val('');
        	$("#locationVal").val('');
        	$("#tagVal").val('');
        	$("#isFreeVal").val('');
        	$("#isReservationVal").val('');
        	localStorage.removeItem("calendarSearch1");
        	localStorage.removeItem("calendarSearch2");
        	localStorage.removeItem("calendarSearch3");
        	localStorage.removeItem("calendarSearch4");
        	localStorage.removeItem("calendarId");
        	
        	//选中全上海
    		$("#areaList p").removeClass("bg262626");
    		$("#areaList p:eq(0)").addClass("bg262626");
    		$(".data-menu-place2 div").not(".close-button").hide();
			$(".data-menu-place2 div:eq(1)").show();
        }
        
      	//收藏
        function collectBut($thisImg,id){
        	localStorage.setItem("calendarId", id);	//界面位置缓存
      		
            if (userId == null || userId == '') {
                window.location.href = '${path}/muser/login.do?type=${basePath}wechatActivity/preActivityCalendar.do';
                return;
            }
            if ($thisImg.attr("src")=="${path}/STATIC/wechat/image/star-on.png") {
                $.post("${path}/wechatActivity/wcDelCollectActivity.do", {
                    activityId: $thisImg.parent().attr("activityId"),
                    userId: userId
                }, function (data) {
                    if (data.status == 0) {
                    	$thisImg.attr("src","${path}/STATIC/wechat/image/star.png");
                        dialogAlert("收藏提示", "已取消收藏");
                        if(tabType==2){
                        	$thisImg.parents("li").remove();		//如果在我的活动界面，则同时清除该活动
                        }
                    }
                }, "json");
            } else {
                $.post("${path}/wechatActivity/wcCollectActivity.do", {
                    activityId: $thisImg.parent().attr("activityId"),
                    userId: userId
                }, function (data) {
                    if (data.status == 0) {
                    	$thisImg.attr("src","${path}/STATIC/wechat/image/star-on.png");
                        dialogAlert("收藏成功", "已成功添加到我的文化日历");
                    }
                }, "json");
            }
        }
      	
    </script>
	
	<style>
		html,body,.main{height: 100%;background-color:#f3f3f3}
		.active{margin-top: 0px;}
		.content {padding-top: 100px;}
		.tab-po1 {
			position: absolute;
			bottom: 75px;
			left: 28px;
			font-size: 36px;
			color: #fff;
		}
		
		.tab-po2 {
			position: absolute;
			bottom: 25px;
			left: 33px;
			font-size: 24px;
			color: #fff;
			letter-spacing: 1px;
			padding-left: 31px;
			width: 250px;
			white-space: nowrap;
			text-overflow: ellipsis;
			-o-text-overflow: ellipsis;
			overflow: hidden;
			background: url(${path}/STATIC/wechat/image/ICON.png) no-repeat 0px 0px;
		}
	</style>
</head>
<body>
	<div class="main">
		<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
			<img src="${path}/STATIC/wxStatic/image/fx-bg.png" style="width: 100%;height: 100%;" />
		</div>
		<div class="div-share">
			<div class="share-bg"></div>
			<div class="share">
				<img src="${path}/STATIC/wechat/image/wx-er2.png" />
				<p style="margin-top: 310px;">扫一扫&nbsp;关注文化云</p>
				<p>更多精彩活动、场馆等你发现</p>
				<button type="button" onclick="$('.div-share').hide();$('body,html').removeClass('bg-notouch')">关闭</button>
			</div>
		</div>
		<div class="header">
			<div class="index-top">
				<span class="index-top-5">
					<img src="${path}/STATIC/wechat/image/logo2.png" />
				</span>
				<span class="index-top-2">文化日历</span>
				<span class="index-top-6">
					<img src="${path}/STATIC/wechat/image/share2.png" />
				</span>
				<span class="index-top-7">
					<img src="${path}/STATIC/wechat/image/keep2.png" />
				</span>
			</div>
		</div>
		<div class="content padding-bottom0">
			<div class="bgWhite">
				<p>海量活动正在努力加载中，请不要刷新页面...<br/>把活动收藏进入“我的日历”，加快浏览速度喔！</p>
			</div>
			<div class="data-tab">
				<ul class="data-tab1">
					<li class="data-tab1-w158 data-tab-bgon" ontouchstart="selectTab1(0);localStorage.setItem('calendarTab2', 0);localStorage.removeItem('calendarTab2Time');reloadMenu();">日</li>
					<li class="data-tab1-w158" ontouchstart="selectTab1(1);reloadMenu();">周</li>
					<li class="data-tab1-w160" ontouchstart="selectTab1(2);reloadMenu();">月</li>
					<li class="data-tab1-w270" style="background-color: #6771a7;color: #fff;" ontouchstart="selectTab1(3);localStorage.setItem('calendarTab2', 0);reloadMenu();">我的活动日历</li>
					<div style="clear: both;"></div>
				</ul>
				<ul class="data-tab2">
					<li style="display: block;">
						<div id="J_mindate_maxdate"></div>
					</li>
					<li>
						<div class="data-tab2-week">
							<div class="data-tab2-week-p">
								<div class="border-marker"></div>
								<div class="data-tab2-week-p-bb border-bottom2" weekType="1" ontouchstart="selectTab2(0);reloadMenu();">
									<p class="data-tab2-week-p1 data-tab2-week-p1-bold">本周活动</p>
									<p class="data-tab2-week-p2" id="weekDate1"></p>
									<p class="data-tab2-week-p3" id="weekCount1"></p>
								</div>
							</div>
							<div class="data-tab2-week-p">
								<div class="border-marker"></div>
								<div class="data-tab2-week-p-bb" weekType="2" ontouchstart="selectTab2(1);reloadMenu();">
									<p class="data-tab2-week-p1">本周末活动</p>
									<p class="data-tab2-week-p2" id="weekDate2"></p>
									<p class="data-tab2-week-p3" id="weekCount2"></p>
								</div>
							</div>
							<div class="data-tab2-week-p">
								<div class="data-tab2-week-p-bb" weekType="3" ontouchstart="selectTab2(2);reloadMenu();">
									<p class="data-tab2-week-p1">下周活动</p>
									<p class="data-tab2-week-p2" id="weekDate3">05.09-05.13</p>
									<p class="data-tab2-week-p3" id="weekCount3"></p>
								</div>
							</div>
							<div style="clear: both;"></div>
						</div>
					</li>
					<li>
						<div class="data-tab2-month">
							<div class="data-tab2-month1 data-tab2-month-p">
								<div class="data-tab2-month-p1 border-bottom2" monthType="4" ontouchstart="selectTab3(0);reloadMenu();">
									<p>下月精彩活动</p>
								</div>
								<div class="border-marker2"></div>
							</div>
							<div class="data-tab2-month2 data-tab2-month-p">
								<div class="data-tab2-month-p1" monthType="5" ontouchstart="selectTab3(1);reloadMenu();">
									<p>全年精彩活动</p>
								</div>
							</div>
							<div style="clear: both;"></div>
						</div>
					</li>
					<li class="sp">
						<div class="sp-p1">
							<ul id="monthUl"></ul>
						</div>
						<div class="month-more">
							<div class="month-more-bg"></div>
							<a>已参加</a>
						</div>
						<div style="clear: both;"></div>
					</li>
				</ul>
			</div>
			<div id="calendarAdvert"></div>
			<div class="active-num-div" style="width: 750px;margin: auto;height: 55px;">
				<div class="active-num"><p class="active-title" id="calendarTitle"></p></div>
			</div>
			<div class="data-menu-m" style="width: 750px;margin: auto;height: 1px;"></div>
			<div class="active">
				<div class="data-menu" style="width: 500px;left:128px;">
					<div class="data-menu1">全部商区</div>
					<div class="data-menu2">分类</div>
					<div class="data-menu3">筛选</div>
					<div style="clear: both;"></div>
					<div class="data-menu1-on">
						<div class="data-menu-place" style="float: left;overflow-y: scroll;width: 170px;height: 250px;margin-top: 50px;">
							<div id="areaList"><p data-option='' class='bg262626'>全上海</p></div>
						</div>
						<input type="hidden" id="areaVal"/>
						<div id="locationList" class="data-menu-place2 bg262626" style="float: left;overflow-y: scroll;width: 280px;text-align: left;height: 315px;border-radius: 25px;padding-left: 50px;">
							<div class="close-button"><img src="${path}/STATIC/wechat/image/arrow.png" /></div>
							<div></div>
						</div>
						<input type="hidden" id="locationVal"/>
					</div>
					<div class="data-menu2-on" style="overflow-y: scroll;height: 290px;">
						<div class="close-button"><img src="${path}/STATIC/wechat/image/arrow.png" /></div>
						<div id="tagList"><p data-option=''>全部</p></div>
						<input type="hidden" id="tagVal"/>
					</div>
					<div class="data-menu3-on">
						<div class="close-button"><img src="${path}/STATIC/wechat/image/arrow.png" /></div>
						<div>
							<p onclick="$('#isFreeVal').val('');$('#isReservationVal').val('');reloadHtml();closeMenu();$('.data-menu3').html('筛选');localStorage.setItem('calendarSearch3','');">全部</p>
							<p onclick="$('#isFreeVal').val(1);$('#isReservationVal').val('');reloadHtml();closeMenu();$('.data-menu3').html('免费');localStorage.setItem('calendarSearch3','1');">免费</p>
							<p onclick="$('#isReservationVal').val(2);$('#isFreeVal').val('');reloadHtml();closeMenu();$('.data-menu3').html('在线预订');localStorage.setItem('calendarSearch3','2');">在线预订</p>
						</div>
						<input type="hidden" id="isFreeVal"/>
						<input type="hidden" id="isReservationVal"/>
					</div>
				</div>
				<ul id="index_list" class="activeUl"></ul>
			</div>
			<div id="loadingDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>
		</div>
		<%@include file="/WEB-INF/why/wechat/footerMenuList.jsp" %>
	</div>

	<script>
		//取得本周，周末，下一周，下个月，全年，本月的第一天和最后一天
        function getdaybytype(type) {
            switch (type) {
                case 1:
                    return [getthisDay(0),obaganlestyle(1, 7)[1]];
                case 2:
                	if(new Date().getDay()==0){
                		return [getthisDay(0),obaganlestyle(6, 7)[1]];
                	}else{
                		return [obaganlestyle(6, 7)[0],obaganlestyle(6, 7)[1]];
                	}
                case 3:
                    return obaganlestyle(8, 14);
                case 4:
                	return getNextMonth();
                case 5:
                	return getAllYear();
                case 6:
                	return getThisMonth();
                default:
                    break;
            }
        }
		function obaganlestyle(snum,lnum){
            var myDate = new Date();
            var day = myDate.getDay();//返回0-6('星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六')
            
            var endday = getthisDay(-day + lnum); //最后一天
            var startday = getthisDay(-day + snum);//第一天
            
            return [startday,endday];
        }
		function getNextMonth(){
			var date_ = new Date();  
			var year = date_.getFullYear();  
			var month = date_.getMonth() + 2;
			if(month>12){
				month = 1;
				year++;
			}
			if(month<10){
				month = "0" + month;
			}
			var firstdate = year + '-' + month + '-01'  
			var day = new Date(year,month,0);      
			var lastdate = year + '-' + month + '-' + day.getDate();  
			return [firstdate,lastdate];
		}
		function getAllYear(){
			var date_ = new Date();  
			var year = date_.getFullYear();  
			var month = date_.getMonth() + 3;
			if(month>12){
				month = month-12;
				year++;
			}
			if(month<10){
				month = "0" + month;
			}
			var firstdate = year + '-' + month + "-01";  
			var lastdate = year + '-12-31';  
			return [firstdate,lastdate];
		}
		function getThisMonth(){
			var date_ = new Date();  
			var tDate = date_.getDate();
			var year = date_.getFullYear();  
			var month = date_.getMonth() + 1;
			if (tDate < 10) {
                tDate = "0" + tDate;
            }
			if(month<10){
				month = "0" + month;
			}
			var firstdate = year + '-' + month + '-' + tDate;  
			var day = new Date(year,month,0);      
			var lastdate = year + '-' + month + '-' + day.getDate();  
			return [firstdate,lastdate];
		}
        //取得日期
        function getthisDay(day) {
            var today = new Date();
            var targetday_milliseconds = today.getTime() + 1000 * 60 * 60 * 24 * day;
            today.setTime(targetday_milliseconds); //关键
            var tyear = today.getFullYear();
            var tMonth = today.getMonth();
            var tDate = today.getDate();
            if (tDate < 10) {
                tDate = "0" + tDate;
            }
            tMonth = tMonth + 1;
            if (tMonth < 10) {
                tMonth = "0" + tMonth;
            }
            return tyear + "-" + tMonth + "-" + tDate;
        }
	</script>
</body>
</html>
<script type="text/javascript" src="${path}/STATIC/wechat/js/yui-min.js"></script>
<script type="text/javascript" src="${path}/STATIC/wechat/js/dump-min.js"></script>
<script type="text/javascript" src="${path}/STATIC/wechat/js/loader-min.js"></script>
<script>
	//日历加载
	var c = {};
	var showdate = function(n, d) { //计算d天的前几天或者后几天，返回date,注：chrome下不支持date构造时的天溢出
		var uom = new Date(d - 0 + n * 86400000);
		uom = uom.getFullYear() + "/" + (uom.getMonth() + 1) + "/" + uom.getDate();
		return new Date(uom);
	};
	YUI({
		combine: true,
		comboBase: 'http://a.tbcdn.cn/??',
		root: 's/yui/3.3.0/build/',
		filter: {
			'searchExp': "&",
			'replaceStr': ","
		},
		modules: {
			'calendar-skin': { //默认皮肤
				fullpath: '${path}/STATIC/wechat/css/default.css',
				type: 'css'
			},
			'calendar': {
				fullpath: '${path}/STATIC/wechat/js/calendar.js',
				requires: ['calendar-skin', 'node']
			}
		}
	}).use('calendar', 'console', 'dump', function(Y) {
		var selectDate = 0;		//默认选中（和今天的差值）
		if(calendarTab1!=null&&calendarTab1==0&&calendarTab2!=null){	//日
			selectDate = calendarTab2;
			}
		c = new Y.Calendar('J_mindate_maxdate', {
			mindate: new Date(),
			maxdate: showdate(new Date()),
			selected: showdate(selectDate, new Date())
		});
		c.on('select', function(d) {
			//获取点击时间
			formatDate(d);
			
	        var cha = (Date.parse(select_startData.replace("-", "/").replace("-", "/")) - Date.parse(new Date())) / 86400000;
	        
	        localStorage.removeItem("calendarId");
			localStorage.setItem('calendarTab2',Math.ceil(cha));
			localStorage.setItem('calendarTab2Time',select_startData);
			//重新加载页面
			reloadHtml();
			loadCount();
			loadAdvert();
		});
	});

	//我的活动月份加载
	loadFiveMonth();
	
	//加载历史选择栏目
	if(calendarTab1!=null){
		selectTab1(calendarTab1);
		if(calendarTab2!=null){
			if(calendarTab1==0){
				if(calendarTab2Time!=null){
					select_startData = calendarTab2Time;
	  				select_endData = calendarTab2Time;
	  				loadCount();
				}
			}else if(calendarTab1==1){	//周
				selectTab2(calendarTab2);
			}else if(calendarTab1==2){	//月
				selectTab3(calendarTab2);
			}else if(calendarTab1==3){	//我的活动
				$(".sp-p1 li a,.month-more a").removeClass("border-bottom2");
				$(".sp-p1 li a,.month-more a").removeClass("font-cb");
				if(calendarTab2<5){
					var $this = $(".sp-p1 li a:eq("+calendarTab2+")");
					$this.addClass("border-bottom2");
					$this.addClass("font-cb");
					select_startData = $this.attr("s");	//开始日期
			        select_endData = $this.attr("e");	//结束日期
			        tabType = 2;
				}else if(calendarTab2==5){
					$(".month-more a").addClass("border-bottom2");
					$(".month-more a").addClass("font-cb");
					tabType = 3;
				}
			}
		}
	}else{
		selectTab1(0);	//默认第一栏目
	}
	
	//区域、标签加载
	loadArea();
	loadTag();
	loadAdvert();
	
	//载入历史选择3
	if(calendarSearch3!=null){
		if(calendarSearch3==1){
			$('#isFreeVal').val(1);
			$('.data-menu3').html('免费');
		}else if(calendarSearch3==2){
			$('#isReservationVal').val(2);
			$('.data-menu3').html('在线预订');
		}else if(calendarSearch3==''){
			$('#isFreeVal').val('');
			$('#isReservationVal').val('');
			$('.data-menu3').html('筛选');
		}
	}

	//如果有需要预加载到的活动
	if(calendarId!=null){
		findDataById();
	}else{
		loadData(0, 20);
	}
	
	//去除loading页面
	if($(".bgWhite").attr("display","block")){
		if($("#"+calendarId).offset()){
	  		$("html,body").animate({scrollTop:$("#"+calendarId).offset().top-100},1000,function(){
	  			$(".bgWhite").fadeOut();
	  		});
		}else{
			$(".bgWhite").fadeOut();
		}
	}
</script>
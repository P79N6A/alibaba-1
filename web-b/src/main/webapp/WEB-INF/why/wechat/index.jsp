<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <!-- <title>文化云首页</title> -->
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
    <script type="text/javascript" src="${path}/STATIC/wechat/js/jquery.lazyload.min.js"></script>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>
    
    <script type="text/javascript">
        var activityThemeTagId = '${sessionScope.terminalUser.activityThemeTagId}';
        var selectTagId = '';
        var advertList = [];	//广告列表
        var advertNo = 3;	//首个广告插入位置
        var userId = '${sessionScope.terminalUser.userId}';
        var latitude = 31.22;
    	var longitude = 121.48;
    	var startIndex = 0;		//页数

        $(function () {
            loadTag();		//加载标签
            loadArea();		//加载区域
            activityBanner(0);	  //广告列表（推荐）
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
                        title: "这里汇聚了上海22万场文化活动及场馆资源-文化云",
                        desc: '文化引领 品质生活',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
                        success: function () { 
                        	dialogAlert('系统提示', '分享成功！');
                        }
                    });
                    wx.onMenuShareTimeline({
                        title: "这里汇聚了上海22万场文化活动及场馆资源-文化云",
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
                        success: function () { 
                        	dialogAlert('系统提示', '分享成功！');
                        }
                    });
                    wx.onMenuShareQQ({
                    	title: "这里汇聚了上海22万场文化活动及场馆资源-文化云",
                    	desc: '文化引领 品质生活',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                    });
                    wx.onMenuShareWeibo({
                    	title: "这里汇聚了上海22万场文化活动及场馆资源-文化云",
                    	desc: '文化引领 品质生活',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                    });
                    wx.onMenuShareQZone({
                    	title: "这里汇聚了上海22万场文化活动及场馆资源-文化云",
                    	desc: '文化引领 品质生活',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                    });
                });
            }
            
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
			//fixed	
    		$(document).on("touchmove", function() {
    			var height_top = $(".data-menu-m").position().top - 170;
    			$(window).scroll(function() {
					//筛选列表浮动
					if ($(document).scrollTop() > height_top) {
						$(".data-menu").addClass("top-fixed3")
					} else if ($(document).scrollTop() < height_top) {
						$(".data-menu").removeClass("top-fixed3")
					}
				})
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
					},200)
				}
			});
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

        //跳转到活动详情
        function showActivity(activityId) {
            window.location.href = "${path}/wechatActivity/preActivityDetail.do?activityId=" + activityId;
        }

        //首页活动加载
        function loadData(index, pagesize) {
        	//图片懒加载开始位置
        	var liCount = $("#index_list li").length;
        	if (selectTagId == "") {	//推荐
        		if($("#areaVal").val()!=""||$("#locationVal").val()!=""||$("#sortVal").val()!=""||$("#isFreeVal").val()!=""||$("#isReservationVal").val()!=""){
        			var data = {
                        	activityArea: $("#areaVal").val(),
                        	activityLocation: $("#locationVal").val(),
                        	sortType: $("#sortVal").val(),
                        	activityIsFree: $("#isFreeVal").val(),
                        	activityIsReservation: $("#isReservationVal").val(),
                            pageIndex: index,
                            pageNum: pagesize
                        };
            		$.post("${path}/wechatActivity/wcFilterActivityList.do",data, function (data) {
            			if(data.data.length<20){
                			if(data.data.length==0&&index==0){
                				$("#loadingDiv").html("<span class='noLoadingSpan'>没有找到合适的结果，换个试试看吧~</span>");
                			}else{
                				$("#loadingDiv").html("");
                			}
    	        		}
    	        		var activityIds = [];
    	        		$.each(data.data, function (i, dom) {
    	        			if(advertList.length>0){
    	        				if(i==advertNo){	//插入广告位
    		        				var advertDom = advertList.shift();
    		        				$("#index_list").append("<li onclick='preOutUrl(\""+advertDom.advertUrl+"\");'><img class='lazy' data-original='"+getIndexImgUrl(advertDom.advertImgUrl, "_750_250")+"' width='750' height='250'/></li>");
    		        			
    		        				advertNo += 3;
    			        			if(advertNo>19){
    			        				advertNo -= 20;
    			        			}
    	        				}
    	        			}
    	        			
    	        			activityIds.push(dom.activityId);
    	        			var time = dom.activityStartTime.substring(5,10).replace("-",".");
    	    				if(dom.activityEndTime.length>0&&dom.activityStartTime!=dom.activityEndTime){
    	    					time += "-"+dom.activityEndTime.substring(5,10).replace("-",".");
    	    				}
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
    													"<img class='lazy' src='${path}/STATIC/wechat/image/placeholder.png' data-original='" + activityIconUrl + "' width='750' height='475'/>" +
    													"<img src='${path}/STATIC/wechat/image/蒙板.png' class='masking'/>" +
    													"<span class='tab-p1'>"+dom.activityName+"</span>" +
        												tagHtml +
        												"<span class='tab-p3'>"+dom.activityLocationName+"</span>" +
        												"<span class='tab-p4'>"+price+"</span>" +
        												"<span class='tab-p5'>"+time+"</span>" +
    												"</li>");
    	        		});
    	        		
    	        		//图片懒加载
            			$("#index_list li:gt("+liCount+") img.lazy,#index_list li:eq("+liCount+") img.lazy").lazyload({
    	        		    effect : "fadeIn",
    	        		    effectspeed : 1000
    	        		});
    	        	}, "json");
        		}else{
        			$.post("${path}/wechatActivity/wcRecommendActivityList.do",{pageIndex:index,pageNum:pagesize}, function (data) {
    	        		var activityIds = [];
    	        		if(data.data.length<20){
                			if(data.data.length==0&&index==0){
                				$("#loadingDiv").html("<span class='noLoadingSpan'>没有找到合适的结果，换个试试看吧~</span>");
                			}else{
                				$("#loadingDiv").html("");
                			}
    	        		}
    	        		$.each(data.data, function (i, dom) {
    	        			if(advertList.length>0){
    	        				if(i==advertNo){	//插入广告位
    		        				var advertDom = advertList.shift();
    		        				$("#index_list").append("<li onclick='preOutUrl(\""+advertDom.advertUrl+"\");'><img class='lazy' data-original='"+getIndexImgUrl(advertDom.advertImgUrl, "_750_250")+"' width='750' height='250'/></li>");
    		        				
    		        				advertNo += 3;
    			        			if(advertNo>19){
    			        				advertNo -= 20;
    			        			}
    	        				}
    	        			}
    	        			
    	        			activityIds.push(dom.activityId);
    	        			var time = dom.activityStartTime.substring(5,10).replace("-",".");
    	    				if(dom.activityEndTime.length>0&&dom.activityStartTime!=dom.activityEndTime){
    	    					time += "-"+dom.activityEndTime.substring(5,10).replace("-",".");
    	    				}
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
    													"<img class='lazy' src='${path}/STATIC/wechat/image/placeholder.png' data-original='" + activityIconUrl + "' width='750' height='475'/>" +
    													"<img src='${path}/STATIC/wechat/image/蒙板.png' class='masking'/>" +
    													"<span class='tab-p1'>"+dom.activityName+"</span>" +
        												tagHtml +
        												"<span class='tab-p3'>"+dom.activityLocationName+"</span>" +
        												"<span class='tab-p4'>"+price+"</span>" +
        												"<span class='tab-p5'>"+time+"</span>" +
    												"</li>");
    	        		});
    	        		
    	        		//图片懒加载
            			$("#index_list li:gt("+liCount+") img.lazy,#index_list li:eq("+liCount+") img.lazy").lazyload({
    	        		    effect : "fadeIn",
    	        		    effectspeed : 1000
    	        		});
    	        	}, "json");
        		}
        	}else{		//其余标签
        		var data = {
        				tagId: selectTagId,
                    	activityArea: $("#areaVal").val(),
                    	activityLocation: $("#locationVal").val(),
                    	sortType: $("#sortVal").val(),
                    	activityIsFree: $("#isFreeVal").val(),
                    	activityIsReservation: $("#isReservationVal").val(),
                        pageIndex: index,
                        pageNum: pagesize
                    };
        		$.post("${path}/wechatActivity/wcTopActivityList.do",data, function (data) {
        			if(data.data.length<20){
            			if(data.data.length==0&&index==0){
            				$("#loadingDiv").html("<span class='noLoadingSpan'>没有找到合适的结果，换个试试看吧~</span>");
            			}else{
            				$("#loadingDiv").html("");
            			}
	        		}
	        		var activityIds = [];
	        		$.each(data.data, function (i, dom) {
	        			if(advertList.length>0){
	        				if(i==advertNo){	//插入广告位
		        				var advertDom = advertList.shift();
		        				$("#index_list").append("<li onclick='preOutUrl(\""+advertDom.advertUrl+"\");'><img class='lazy' data-original='"+getIndexImgUrl(advertDom.advertImgUrl, "_750_250")+"' width='750' height='250'/></li>");
		        			
		        				advertNo += 3;
			        			if(advertNo>19){
			        				advertNo -= 20;
			        			}
	        				}
	        			}
	        			
	        			activityIds.push(dom.activityId);
	        			var time = dom.activityStartTime.substring(5,10).replace("-",".");
	    				if(dom.activityEndTime.length>0&&dom.activityStartTime!=dom.activityEndTime){
	    					time += "-"+dom.activityEndTime.substring(5,10).replace("-",".");
	    				}
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
													"<img class='lazy' src='${path}/STATIC/wechat/image/placeholder.png' data-original='" + activityIconUrl + "' width='750' height='475'/>" +
													"<img src='${path}/STATIC/wechat/image/蒙板.png' class='masking'/>" +
													"<span class='tab-p1'>"+dom.activityName+"</span>" +
    												tagHtml +
    												"<span class='tab-p3'>"+dom.activityLocationName+"</span>" +
    												"<span class='tab-p4'>"+price+"</span>" +
    												"<span class='tab-p5'>"+time+"</span>" +
												"</li>");
	        		});
	        		
	        		//图片懒加载
        			$("#index_list li:gt("+liCount+") img.lazy,#index_list li:eq("+liCount+") img.lazy").lazyload({
	        		    effect : "fadeIn",
	        		    effectspeed : 1000
	        		});
	        	}, "json");
        	}
        };
		
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
        
        //首页banner轮播图
        function activityBanner(advertTagId) {
            $.post("${path}/wechatActivity/wcAdvertRecommendList.do", {tagId: advertTagId}, function (data) {
                if (data.status == 1) {
                	emptyHtml();	//清空HTML
                	
                	if(data.data.length>0){
                		$("#advertBanner").show();
                		var dom = data.data[0];
                		var advBannerFImgUrl = getIndexImgUrl(dom.advBannerFImgUrl, "_750_250");
                    	var advBannerSImgUrl = getIndexImgUrl(dom.advBannerSImgUrl, "_748_310");
                    	var advBannerLImgUrl = getIndexImgUrl(dom.advBannerLImgUrl, "_748_310");
                    	
                        if(dom.advBannerFIsLink==1){	//外链
                        	$("#advBannerFImg").append("<img src='"+advBannerFImgUrl+"' width='750' height='250' onclick='preOutUrl(\"" + dom.advBannerFUrl + "\");'/>");
                        }else{	//内链
                        	if(dom.advBannerFLinkType==0){	//活动列表
                        		$("#advBannerFImg").append("<img src='"+advBannerFImgUrl+"' width='750' height='250' onclick='preInActList(\"" + dom.advBannerFUrl + "\");'/>");
                        	}else if(dom.advBannerFLinkType==1){	//活动详情
                        		$("#advBannerFImg").append("<img src='"+advBannerFImgUrl+"' width='750' height='250' onclick='preInActDetail(\"" + dom.advBannerFUrl + "\");'/>");
                        	}else if(dom.advBannerFLinkType==2){	//场馆列表
                        		$("#advBannerFImg").append("<img src='"+advBannerFImgUrl+"' width='750' height='250' onclick='preInVenList(\"" + dom.advBannerFUrl + "\");'/>");
                        	}else if(dom.advBannerFLinkType==3){	//场馆详情
                        		$("#advBannerFImg").append("<img src='"+advBannerFImgUrl+"' width='750' height='250' onclick='preInVenDetail(\"" + dom.advBannerFUrl + "\");'/>");
                        	}
                        }
                        if(dom.advBannerSIsLink==1){	//外链
                        	$("#advBannerSImg").append("<img src='"+advBannerSImgUrl+"' width='374' height='155' onclick='preOutUrl(\"" + dom.advBannerSUrl + "\");'/>");
                        }else{	//内链
                        	if(dom.advBannerSLinkType==0){	//活动列表
                        		$("#advBannerSImg").append("<img src='"+advBannerSImgUrl+"' width='374' height='155' onclick='preInActList(\"" + dom.advBannerSUrl + "\");'/>");
                        	}else if(dom.advBannerSLinkType==1){	//活动详情
                        		$("#advBannerSImg").append("<img src='"+advBannerSImgUrl+"' width='374' height='155' onclick='preInActDetail(\"" + dom.advBannerSUrl + "\");'/>");
                        	}else if(dom.advBannerSLinkType==2){	//场馆列表
                        		$("#advBannerSImg").append("<img src='"+advBannerSImgUrl+"' width='374' height='155' onclick='preInVenList(\"" + dom.advBannerSUrl + "\");'/>");
                        	}else if(dom.advBannerSLinkType==3){	//场馆详情
                        		$("#advBannerSImg").append("<img src='"+advBannerSImgUrl+"' width='374' height='155' onclick='preInVenDetail(\"" + dom.advBannerSUrl + "\");'/>");
                        	}
                        }
                        if(dom.advBannerLIsLink==1){	//外链
                        	$("#advBannerLImg").append("<img src='"+advBannerLImgUrl+"' width='374' height='155' onclick='preOutUrl(\"" + dom.advBannerLUrl + "\");'/>");
                        }else{	//内链
                        	if(dom.advBannerLLinkType==0){	//活动列表
                        		$("#advBannerLImg").append("<img src='"+advBannerLImgUrl+"' width='374' height='155' onclick='preInActList(\"" + dom.advBannerLUrl + "\");'/>");
                        	}else if(dom.advBannerLLinkType==1){	//活动详情
                        		$("#advBannerLImg").append("<img src='"+advBannerLImgUrl+"' width='374' height='155' onclick='preInActDetail(\"" + dom.advBannerLUrl + "\");'/>");
                        	}else if(dom.advBannerLLinkType==2){	//场馆列表
                        		$("#advBannerLImg").append("<img src='"+advBannerLImgUrl+"' width='374' height='155' onclick='preInVenList(\"" + dom.advBannerLUrl + "\");'/>");
                        	}else if(dom.advBannerLLinkType==3){	//场馆详情
                        		$("#advBannerLImg").append("<img src='"+advBannerLImgUrl+"' width='374' height='155' onclick='preInVenDetail(\"" + dom.advBannerLUrl + "\");'/>");
                        	}
                        }
                        
                        if(dom.isContainActivtiyAdv==1){
                        	advertList = dom.dataList;
                        }else{
                        	advertList = [];
                        }
                	}else{
                		$("#advertBanner").hide();
                	}
                    loadData(startIndex, 20);
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
		
        //活动标签
        function loadTag() {
            $.post("${path}/wechatActivity/wcActivityTagList.do", {userId: userId}, function (data) {
                if (data.status == 0) {
                    var domStr = '<div class="swiper-slide"><a onclick="selectTagId=\'\';reloadMenu();tagSelect();closeMenu();" class="select_it" style="font-weight: bold;">推荐</a></div>';
                    var tagHasNum = 0;	//判断是否有标签显示
                    $.each(data.data, function (i, dom) {
                    	if (dom.status == 1&&userId != "") {
                        	tagHasNum++;
                            domStr += '<div class="swiper-slide"><a id=' + dom.tagId + ' onclick="selectTagId=\''+dom.tagId+'\';reloadMenu();tagSelect();closeMenu();">' + dom.tagName + '</a></div>';
                        }
                        if (activityThemeTagId.indexOf(dom.tagId) != -1 && userId == "") {
                        	tagHasNum++;
                            domStr += '<div class="swiper-slide"><a id=' + dom.tagId + ' onclick="selectTagId=\''+dom.tagId+'\';reloadMenu();tagSelect();closeMenu();">' + dom.tagName + '</a></div>';
                        }
                    });
                    if(tagHasNum==0){
	            		domStr += '<div style="font-size:34px;color:#000;line-height:100px;color:#ccc;">点击右侧+号添加更多喜爱的类型</div>'
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
                }
            }, "json")
        };
        
      	//加载区域
        function loadArea() {
        	$.ajax({type:'POST', url:"${path}/wechatActivity/getAllArea.do",dataType: "json",async: true,
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
	                		$("#areaVal").val($(this).attr("data-option"));
	                		
	                		//选中区域，显示相应商圈
	                		$("#areaList p").removeClass("bg262626");
	                		$(this).addClass("bg262626");
	                		$(".data-menu-place2 div").not(".close-button").hide();
							$(".data-menu-place2 div:eq(" + ($(this).index()+1) + ")").show();
	                		
	                		if($(this).attr("data-option")==''){	//全上海
	                			//重新加载页面
		        				tagSelect();
		                		//收起筛选界面
		                		closeMenu();
	                			$('.data-menu1').html('全部商区');
	                		}
	                	});
	                	
	                	$("#locationList p").on("click", function () {
	                		$("#locationVal").val($(this).attr("data-option"));
	                		
                			//重新加载页面
	        				tagSelect();
	                		//收起筛选界面
	                		closeMenu();
                			$('.data-menu1').html($(this).attr('data-name').length>3?$(this).attr('data-name').substring(0,3)+"...":$(this).attr('data-name'));
	                	});
	                }
        		}
            });
        }
        
        //选择标签
        function tagSelect() {
        	advertNo = 3;	//重置广告位置
        	startIndex = 0;		//重置分页
        	//重置加载中
        	$("#loadingDiv").html("<img class='loadingImg' src='${path}/STATIC/wechat/image/loading.gif'/><span class='loadingSpan'>加载中。。。</span><div style='clear:both'></div>");
        	if (selectTagId!='') {
                activityBanner(selectTagId);	//广告列表（其它标签）
            } else {
                activityBanner(0);	  //广告列表（推荐）
            }
        }
        
        //清空HTML
        function emptyHtml(){
        	$("#advBannerFImg").html('');
        	$("#advBannerSImg").html('');
        	$("#advBannerLImg").html('');
        	$("#index_list").html("");
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
        	
        	$('.data-menu3').html('筛选');
        	$("#areaVal").val('');
        	$("#locationVal").val('');
        	
        	$("#isFreeVal").val('');
        	$("#isReservationVal").val('');
        	if(selectTagId==''){
        		$('.data-menu2').html('排序');
        		$("#sortVal").val('');
        	}else{
        		$('.data-menu2').html('智能排序');
        		$("#sortVal").val('1');
        	}
        	
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
				width: "500px",
				height: "60px",
				left: "128px",
			});
			$(".data-menu1,.data-menu2,.data-menu3").show();
        }
      	
    </script>
    
    <style>
    	html,body,.main{height:100%}
		.content {padding-top: 200px;}
		.menu-home {background: url(${path}/STATIC/wechat/image/menu-icon01.png);}
	</style>
</head>

<body>
	<div class="main">
		<div class="header downLoadApp">
			<div class="index-top">
				<span class="index-top-1">上海</span>
				<span class="index-top-2">文化云</span>
				<span class="index-top-3">
					<img src="${path}/STATIC/wechat/image/放大镜.png" width="38px" height="30px" onclick="window.location.href='${path}/wechatActivity/activitySearchIndex.do'"/>
				</span>
			</div>
			<div class="swiper-container">
				<div class="swiper-wrapper" id="tagList"></div>
			</div>
			<div class="menu-more">
				<a href="${path}/wechat/openEdit.do?type=${path}/wechat/index.do"><img src="${path}/STATIC/wechat/image/more.png" /></a>
			</div>
			<div style="clear: both;"></div>
		</div>
		<div class="content padding-bottom0">
			<div class="banner" style="display: none;" id="advertBanner">
				<div class="banner-img" id="advBannerFImg"></div>
				<div class="banner-button">
					<div class="banner-button-left" id="advBannerSImg"></div>
					<div class="banner-button-right" id="advBannerLImg"></div>
					<div style="clear: both;"></div>
				</div>
			</div>
			<div class="data-menu-m" style="width: 750px;margin: auto;height: 1px;"></div>
			<div class="active">
				<div class="data-menu" style="width: 500px;left:128px;">
					<div class="data-menu1">全部商区</div>
					<div class="data-menu2">排序</div>
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
					<div class="data-menu2-on">
						<div class="close-button"><img src="${path}/STATIC/wechat/image/arrow.png" /></div>
						<div>
							<p onclick="$('#sortVal').val(1);tagSelect();closeMenu();$('.data-menu2').html('智能排序');">智能排序</p>
							<p onclick="$('#sortVal').val(2);tagSelect();closeMenu();$('.data-menu2').html('热门排序');">热门排序</p>
							<p onclick="$('#sortVal').val(3);tagSelect();closeMenu();$('.data-menu2').html('最新上线');">最新上线</p>
							<p onclick="$('#sortVal').val(4);tagSelect();closeMenu();$('.data-menu2').html('即将结束');">即将结束</p>
						</div>
						<input type="hidden" id="sortVal" value=""/>
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
		<div class="footer" style="background-color: transparent;bottom: 40px;border:none;">
			<div class="totop" onclick="$('html,body').animate({scrollTop: 0}, 200);"><img src="${path}/STATIC/wechat/image/totop.png" /></div>
			<div style="clear: both;"></div>
			<div class="footer-menu">
				<div class="footer-menu-list">
					<ul>
						<li><a><div class="menu-home"></div><p class="c7279a0">首页</p></a></li>
						<li><a href="${path}/wechatActivity/preMap.do"><div class="menu-near"></div><p>附近</p></a></li>
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
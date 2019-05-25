<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>文化活动</title>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
      <script type="text/javascript" src="${path}/STATIC/wechat/js/jquery.lazyload.min.js"></script>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/normalize.css"/>

	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/hsStyle.css"/>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/swiper-3.3.1.min.css"/>
	<%--<link rel="stylesheet" href="${path}/STATIC/wechat/css/bpColorCtrl.css" />--%>
	<script type="text/javascript" src="${path}/STATIC/wechat/js/jquery-2.1.4.min.js"></script>
	<script type="text/javascript" src="${path}/STATIC/wechat/js/swiper-3.3.1.jquery.min.js"></script>
    <script type="text/javascript">
        var activityThemeTagId = '${sessionScope.terminalUser.activityThemeTagId}';
        var selectTagId = '';
        var advertList = [];	//广告列表
        var advertNo = 3;	//首个广告插入位置
        var latitude = 22.964305;
    	var longitude = 113.116029;
    	var startIndex = 0;		//页数
    	
    	//活动筛选
    	var sortVal = 1;
    	var isFreeVal = '';
    	var isReservationVal = '';

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
                    title: "我在“佛山文化云”发现一大波文化活动，快来和我一起预订吧！",
                    desc: '文化引领 品质生活',
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
                wx.onMenuShareTimeline({
                    title: "我在“佛山文化云”发现一大波文化活动，快来和我一起预订吧！",
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
                wx.onMenuShareQQ({
                	title: "我在“佛山文化云”发现一大波文化活动，快来和我一起预订吧！",
                	desc: '文化引领 品质生活',
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
                wx.onMenuShareWeibo({
                	title: "我在“佛山文化云”发现一大波文化活动，快来和我一起预订吧！",
                	desc: '文化引领 品质生活',
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
                wx.onMenuShareQZone({
                	title: "我在“佛山文化云”发现一大波文化活动，快来和我一起预订吧！",
                	desc: '文化引领 品质生活',
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
            });
        }
    	
        $(function () {
            loadTag();		//加载标签
            
          	//活动筛选标签点击效果
			$(".menuTab-whhdlist ul li").on("click", function() {
				$(".menuTab-whhdlist ul li").removeClass("current")
				$(this).addClass("current")
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
        });

        //跳转到活动详情
        function showActivity(activityId) {
            window.location.href = "${path}/wechatActivity/preActivityDetail.do?activityId=" + activityId;
        }

        //首页活动加载
        function loadData(index, pagesize) {
        	//图片懒加载开始位置
        	var liCount = $("#index_list li").length;
       		var data = {
       				tagId: selectTagId,
                   	sortType: sortVal,
                   	activityIsFree: isFreeVal,
                   	activityIsReservation: isReservationVal,
                   	Lon:longitude,
       				Lat:latitude,
                    pageIndex: index,
                    pageNum: pagesize
            };
       		$.post("${path}/wechatActivity/wcTopActivityList.do",data, function (data) {
       			if(data.data.length<20){
           			if(data.data.length==0&&index==0){
           				$("#loadingDiv").html("<span class='noLoadingSpan'>没有找到合适的结果，换个试试看吧~</span>");
           				//插入活动标签
   	        			getActivityListTagSub();
           			}else{
           				$("#loadingDiv").html("");
           			}
        		}
        		var activityIds = [];
        		$.each(data.data, function (i, dom) {
        			if(advertList.length>0){
        				if(i==advertNo){	//插入广告位
	        				var advertDom = advertList.shift();
	        				$("#index_list").append("<li onclick='preOutUrl(\""+advertDom.advertUrl+"\");'><img src='"+getIndexImgUrl(advertDom.advertImgUrl, "_750_250")+"' width='750' height='250'/></li>");
	        			
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
        											"<img src='" + activityIconUrl + "' width='750' height='475'/>" +
        											isReservationHtml + tagHtml + price +
				    							"</div>" +
				    							"<p class='activeTitle'>"+dom.activityName+"</p>" +
				    							"<p class='activePT'>"+time+" | "+dom.activityLocationName+"</p>" +
				    						"</li>");
        		
        			//插入活动标签
        			if(i==0 && index==0){
        				getActivityListTagSub();
        			}
        		});
        		
        		/* //图片懒加载
       			$("#index_list li:gt("+liCount+") img.lazy,#index_list li:eq("+liCount+") img.lazy").lazyload({
        		    effect : "fadeIn",
        		    effectspeed : 1000
        		}); */
        	}, "json");
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
        function activityBanner() {
    		$.post("${path}/wechatActivity/wcAdvertRecommendList.do", {tagId: selectTagId}, function (data) {
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
        
        //获取活动页面标签
        function getActivityListTagSub(){
        	$.ajax({
	    		type: 'post',  
	  			url : "${path}/wechatActivity/wcActivityListTagSub.do",  
	  			dataType : 'json',  
	  			async : false,
	  			success: function (data) {
	  				if (data.status == 200) {
	                	var tagSubHtml = "";
	                	$.each(data.data, function (i, dom) {
	                		var link = "${path}/wechatActivity/preActivityListTagSub.do?activityType="+dom.tagSubId+"&advertTitle="+dom.title;
	                		tagSubHtml += "<span onclick='location.href=\""+link+"\"'>"+dom.title+"</span>";
	                	});
	                	$("#index_list").append("<li class='lableList'>" +
													"<div class='clearfix'>"+tagSubHtml+"</div>" +
												"</li>");
	                }
				}
			});
        }
        
        //获取广告位链接地址
        function getAdvertUrl(advertLink,advertLinkType,advertUrl,advertTitle){
        	var jumpUrl = "";
			if(advertLink==0){
				if(advertLinkType==0){
					jumpUrl = "${basePath}/wechatActivity/preActivityList.do?activityName="+advertUrl;
				}else if(advertLinkType==1){
					jumpUrl = "${basePath}/wechatActivity/preActivityDetail.do?activityId="+advertUrl;
				}else if(advertLinkType==2){
					jumpUrl = "${basePath}/wechatVenue/preVenueList.do?venueName="+advertUrl;
				}else if(advertLinkType==3){
					jumpUrl = "${basePath}/wechatVenue/venueDetailIndex.do?venueId="+advertUrl;
				}else if(advertLinkType==4){
		        	jumpUrl = "${basePath}wechatActivity/preActivityCalendar.do";
				}else if(advertLinkType==5){
					jumpUrl = "${basePath}wechatActivity/preActivityListTagSub.do?activityType="+advertUrl+"&advertTitle="+advertTitle;
				}
			}else{
				jumpUrl = advertUrl;
			}
			return jumpUrl;
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
                    var domStr = '';
                    var tagHasNum = 0;	//判断是否有标签显示
                    $.each(data.data, function (i, dom) {
                    	if (dom.status == 1&&userId != "") {
                        	tagHasNum++;
                            domStr += '<div class="swiper-slide"><a id=' + dom.tagId + ' onclick="selectTagId=\''+dom.tagId+'\';tagSelect();">' + dom.tagName + '</a></div>';
                    	}
                        if (activityThemeTagId.indexOf(dom.tagId) != -1 && userId == "") {
                        	tagHasNum++;
                            domStr += '<div class="swiper-slide"><a id=' + dom.tagId + ' onclick="selectTagId=\''+dom.tagId+'\';tagSelect();">' + dom.tagName + '</a></div>';
                        }
                    });
                    if(tagHasNum==0){
	            		domStr += '<div style="font-size:34px;line-height:100px;color:#ccc;">点击右侧+号添加更多喜爱的类型</div>'
	            	}
	                $("#tagList").append(domStr);
	                var mySwiper = new Swiper('.swiper-container', {
	        			slidesPerView: 'auto', //显示
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
					
					$(".swiper-slide a:eq(0)").css("font-weight", "bold");
					$(".swiper-slide a:eq(0)").parent().addClass("border-bottom2");
					selectTagId = $("#tagList div:eq(0)").find("a").attr("id");		//第一个类别ID
					activityBanner();	  //广告列表
                }
            }, "json")
        };
        
        //选择标签
        function tagSelect(param1,param2,param3) {
        	advertNo = 3;	//重置广告位置
        	startIndex = 0;		//重置分页
        	//重置加载中
        	$("#loadingDiv").html("<img class='loadingImg' src='${path}/STATIC/wechat/image/loading.gif'/><span class='loadingSpan'>加载中。。。</span><div style='clear:both'></div>");
        	
    		if(param1!=null) sortVal = param1;
    		if(param2!=null) isFreeVal = param2;
    		if(param3!=null) isReservationVal = param3;
            activityBanner();	//广告列表（其它标签）
        }
        
        //清空HTML
        function emptyHtml(){
        	$("#advBannerFImg").html('');
        	$("#advBannerSImg").html('');
        	$("#advBannerLImg").html('');
        	$("#index_list").html("");
        	$("#advertBanner").hide();
        }

        //跳转到日历
        function preCalendar(){
        	window.location.href = '${path}/wechatActivity/preActivityCalendar.do';
        }
        
    </script>
    
    <script type="text/javascript">
			$(function() {

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
						"bottom": "-" + height + "px"
					})
				})
				//回到顶部按钮显示
				$(window).scroll(function() {
					var screenheight = $(window).height() * 2
					if($(document).scrollTop() > screenheight) {
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

				var mySwiper3 = new Swiper('.swiper-container3', {
					freeMode: false,
					autoplay: 3000,
					loop: true,
					pagination: '.swiper-pagination'
				})

				var mySwiper2 = new Swiper('.swiper-container2', {
					slidesPerView: 4,
					slidesPerGroup: 4,
					freeMode: false,
					pagination: '.swiper-pagination'
				})

			});
		</script>

		<style>
			html,
			body {
				height: 100%;
				background-color: #f3f3f3
			}
			
			.swiper-container .swiper-slide {
				width: auto;
				padding: 0 20px;
			}
			
			div.main~div {
				display: none!important;
				opacity: 0;
			}
			
			body>iframe {
				opacity: 0;
				display: none!important;
			}
			
			.indexTable {
				padding: 5px 0;
				background-color: #fff;
			}
			
			.indexTable table {
				margin: auto;
			}
			
			.indexTable td {
				padding: 3px;
			}
			.swiper-container4  > .swiper-pagination-bullets, .swiper-container4 .swiper-pagination-custom, .swiper-container4 .swiper-pagination-fraction{
				bottom: 155px;
			}
		</style>
    
    
    <style>
    	html,body{height:100%;background-color:#f3f3f3}
		.content {padding-top: 100px;}
		.swiper-container .swiper-slide{width: auto;padding: 0 20px;}
	</style>
</head>

<body>
	<div class="main">
		<div class="header" style="border-bottom: 1px solid #f3f3f3;">
			<div class="swiper-container">
				<div class="swiper-wrapper" id="tagList">
					<div class="swiper-slide"><a id="0" onclick="selectTagId='0';tagSelect();">全部</a></div>
				</div>
			</div>
			<div class="menu-more">
				<a href="${path}/wechat/openEdit.do?type=${basePath}wechatActivity/index.do"><img src="${path}/STATIC/wechat/image/more.png" /></a>
			</div>
			<div style="clear: both;"></div>
		</div>
		<div class="content padding-bottom0">
			<!-- 标签广告位 -->
			<div class="banner" style="display: none;" id="advertBanner">
				<div class="banner-img" id="advBannerFImg"></div>
				<div class="banner-button">
					<div class="banner-button-left" id="advBannerSImg"></div>
					<div class="banner-button-right" id="advBannerLImg"></div>
					<div style="clear: both;"></div>
				</div>
			</div>
			<!-- 筛选标签 -->
			<div class="menuTab" id="actMenuTab">
				<div class="menuTab-whhdlist">
					<ul class="clearfix">
						<li class="current" onclick="tagSelect(1,'','');">
							<div class="pic"><img src="${path}/STATIC/wechat/image/actIcon1.png"></div>
							<div class="char">全部</div>
						</li>
						<li onclick="location.href='${path}/wechatActivity/preMap.do'">
							<div class="pic"><img src="${path}/STATIC/wechat/image/actIcon2.png"></div>
							<div class="char">附近</div>
						</li>
						<li onclick="tagSelect(2,'','');">
							<div class="pic"><img src="${path}/STATIC/wechat/image/actIcon3.png"></div>
							<div class="char">人气</div>
						</li>
						<li onclick="tagSelect(3,1,'');">
							<div class="pic"><img src="${path}/STATIC/wechat/image/actIcon4.png"></div>
							<div class="char">免费</div>
						</li>
						<li onclick="tagSelect(4,'',2);">
							<div class="pic"><img src="${path}/STATIC/wechat/image/actIcon5.png"></div>
							<div class="char">可预订</div>
						</li>
						<li onclick="tagSelect(5,'','');">
							<div class="pic"><img src="${path}/STATIC/wechat/image/actIcon6.png"></div>
							<div class="char">最新</div>
						</li>
					</ul>
				</div>
			</div>
			<div class="active" style="margin-top: 15px;">
				<ul id="index_list" class="activeUl"></ul>
			</div>
			<div id="loadingDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>
		</div>
		<%@include file="/WEB-INF/why/wechat/footerMenuList.jsp" %>
	</div>
</body>
</html>
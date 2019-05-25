<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>资讯</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css">
	</link>
	<style type="text/css">
	html,body {height: 100%;background: #f4f4f4;}
	</style>
	
	<script type="text/javascript">
	$.ajaxSettings.async = false; 	//同步执行ajax
	
	
	
	//分享是否隐藏
    if(window.injs){
    	//分享文案
    	appShareTitle = '文化云-专注文化直播上万家文化机构活动现场正在播报，抢鲜看';
    	appShareDesc = '导赏看展览，专业艺术启蒙，文化大咖面对面，艺术活动现场看.....文化活动尽在掌握';
    	appShareImgUrl = '${basePath}STATIC/wx/image/share_120.png';
    	
		injs.setAppShareButtonStatus(true);
	}

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
				title: "文化云-专注文化直播上万家文化机构活动现场正在播报，抢鲜看",
				desc: '导赏看展览，专业艺术启蒙，文化大咖面对面，艺术活动现场看.....文化活动尽在掌握',
				link: '${basePath}wechatInformation/index.do',
				imgUrl: '${basePath}/STATIC/wechat/image/live/shareIcon.jpg'
			});
			wx.onMenuShareTimeline({
				title: "文化云-专注文化直播上万家文化机构活动现场正在播报，抢鲜看",
				imgUrl: '${basePath}/STATIC/wechat/image/live/shareIcon.jpg',
				link: '${basePath}wechatInformation/index.do'
			});
			wx.onMenuShareQQ({
				title: "文化云-专注文化直播上万家文化机构活动现场正在播报，抢鲜看",
				desc: '导赏看展览，专业艺术启蒙，文化大咖面对面，艺术活动现场看.....文化活动尽在掌握',
				imgUrl: '${basePath}/STATIC/wechat/image/live/shareIcon.jpg'
			});
			wx.onMenuShareWeibo({
				title: "文化云-专注文化直播上万家文化机构活动现场正在播报，抢鲜看",
				desc: '导赏看展览，专业艺术启蒙，文化大咖面对面，艺术活动现场看.....文化活动尽在掌握',
				imgUrl: '${basePath}/STATIC/wechat/image/live/shareIcon.jpg'
			});
			wx.onMenuShareQZone({
				title: "文化云-专注文化直播上万家文化机构活动现场正在播报，抢鲜看",
				desc: '导赏看展览，专业艺术启蒙，文化大咖面对面，艺术活动现场看.....文化活动尽在掌握',
				imgUrl: '${basePath}/STATIC/wechat/image/live/shareIcon.jpg'
			});
		});
	}
	
	$(function () {
		
		 activityBanner();	  //广告列表
		
		loadInformationList(p,num)
		
		 $('.zixunList').on('click', '.swiper-slide', function () {
		    	$(this).parent().find('.swiper-slide').removeClass('cur');
		    	$(this).addClass('cur');
		    	
		    	$(".zSyList").find("li").remove();
		    	startIndex = 0;
		    	loadInformationList(startIndex, num)
		    });
		
		
		var zixunList = new Swiper('.zixunList', {
	        slidesPerView: 'auto',
	        spaceBetween: 0
	    });
	})
	
	var startIndex = 0;		//页数
	var num=20
	var p=0;
	var toDay='${toDay}'
	
	//滑屏分页
	 $(window).on("scroll", function () {
	            var scrollTop = $(document).scrollTop();
	            var pageHeight = $(document).height();
	            var winHeight = $(window).height();
	            if (scrollTop >= (pageHeight - winHeight - 80)) {
	           		setTimeout(function () { 
	           			if(p==0){
	           				startIndex += num;
	                  		var index = startIndex;
	                  		loadInformationList(index,num);
	           			}
	           		},800);
	            }
	        });
	
    //首页banner轮播图
    function activityBanner() {
		$.post("${path}/wechatInformation/getAdvertRecommend.do", {advertPostion: 2,advertType: "A"}, function (data) {
            if (data.status == 1) {
            	$("#indexBannerList").html("");
            	$.each(data.data, function (i, dom) {
            		var jumpUrl = getAdvertUrl(dom.advertLink,dom.advertLinkType,dom.advertUrl,dom.advertTitle);
            		if(dom.advertSort==1||dom.advertSort==8||dom.advertSort==9||dom.advertSort==10){
            			var advertImgUrl = getIndexImgUrl(dom.advertImgUrl, "_750_250");
            			$("#indexBannerList").append("<div class='swiper-slide'>" +
		        							"<img id='advertImg"+dom.advertSort+"' src='' width='750' height='250'/>" +
		    							 "</div>");
            		}else if(dom.advertSort>=2&&dom.advertSort<=3){
            			var advertImgUrl = getIndexImgUrl(dom.advertImgUrl, "_750_440");
            		}else if(dom.advertSort>=4&&dom.advertSort<=7){
            			var advertImgUrl = getIndexImgUrl(dom.advertImgUrl, "_374_430");
            		}
            		$("#advertImg"+dom.advertSort).attr("src",advertImgUrl);
            		$("#advertImg"+dom.advertSort).attr("onclick","preOutUrl(\""+jumpUrl+"\");");
            	});
            	if(data.data.length>0){		//广告位A开始轮播
            		var zixunIndexBan = new Swiper('.zixunIndexBan', {
            	        pagination: '.zixunIndexBan .swiper-pagination',
            	        paginationClickable: true,
            	        autoplay : 3000,
            	        loop:true
            	    });
            	}
            }
        }, "json");
		$.post("${path}/wechatInformation/getAdvertRecommend.do", {advertPostion: 2,advertType: "B"}, function (data) {
            if (data.status == 1) {
            	$.each(data.data, function (i, dom) {
            		var jumpUrl = getAdvertUrl(dom.advertLink,dom.advertLinkType,dom.advertUrl,dom.advertTitle);
            		var advertImgUrl = getIndexImgUrl(dom.advertImgUrl, "_250_120");

			//		$("#indexBannerList2").append("<div class='swiper-slide' onclick='location.href=\""+jumpUrl+"\"'>" +
	    		//						"<img src='"+advertImgUrl+"' width='140' height='120'/>" +
				//						"<p>"+dom.advertTitle+"</p>" +
				//				  	  "</div>");
			
				$(".advertTypeB").eq(i).attr("href",jumpUrl)
				
				$(".advertTypeB").eq(i).find("img").attr("src",advertImgUrl);
            	});
            	
            }
        }, "json");
		
    }
    
    //跳外链
    function preOutUrl(url){ window.location.href = url; };
    
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
				if (is_weixin()) {
					jumpUrl = getChinaServerUrl()+"wxUser/silentInvoke.do?type=${basePath}wechatActivity/preActivityCalendar.do";
	        	}else{
	        		jumpUrl = "${basePath}wechatActivity/preActivityCalendar.do";
	        	}
			}else if(advertLinkType==5){
				jumpUrl = "${basePath}wechatActivity/preActivityListTagSub.do?activityType="+advertUrl+"&advertTitle="+advertTitle;
			}
		}else{
			jumpUrl = advertUrl;
		}
		return jumpUrl;
    }
	
	function loadInformation(informationId){
		
		window.location.href='${basePath}wechatInformation/informationDetail.do?informationId='+informationId;
	}
	
	function loadInformationList(index, pagesize){
		p=1;
		
		$("#loadingDiv").show();
		
		
		
		var data = {
				userId:userId,
				informationIsRecommend:1,
               	pageIndex: index,
               	pageNum: pagesize
            };
		
		$.post("${path}/wechatInformation/queryInformationList.do",data, function (data) {
				if(data.length<num){
           			$("#loadingDiv").hide();
	        	}else{
					p=0;
				}
				
				$.each(data, function (i, dom) {
					var date =formatTimeStr(dom.informationCreateTime);
					
					var informationTags=dom.informationTags;
					
					var tagDiv="";
					
					if(informationTags){
						
						tagDiv='<div class="label fl">'+informationTags.split(",")[0]+'</div>';
					}
					
					var informationIconUrl=getIndexImgUrl(getImgUrl(dom.informationIconUrl), "_730_375");
					
					
					var li=
						
				'<li class="jzCenter" onclick="loadInformation(\''+dom.informationId+'\');">'+
		    		'<div class="tit">'+dom.informationTitle+'</div>'+
		    		'<div class="pic"><img src="'+informationIconUrl+'"></div>'+
		    		'<div class="clearfix">'+
		    			tagDiv+
		    			'<div class="time fl">'+date+'</div>'+
		    			'<div class="dianz fr"><span></span>'+dom.wantCount+'</div>'+
		    			'<div class="pingl fr"><span></span>'+dom.commentCount+'</div>'+
		    		'</div>'+
		    	'</li>'
					
		    	$(".zSyList").append(li);
		    	
				});
		},"json");
		
	}
	
	
	</script>
	<script>
   
</script>
	</head>
	
	<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${basePath}/STATIC/wechat/image/live/shareIcon.jpg"/></div>
	<div class="zMain">	
	<div class="zixunIndexBan swiper-container">
        <div id="indexBannerList" class="swiper-wrapper">
        
        </div>
        <!-- Add Pagination -->
        <div id="swiperPage" class="swiper-pagination"></div>
    </div>
    <div class="zColumn colColor clearfix">
		<a class="item advertTypeB" href="javascript:;"><img src=""><em></em></a>
		<a class="item advertTypeB" href="javascript:;"><img src=""><em></em></a>
		<a class="item advertTypeB" href="javascript:;"><img src=""><em></em></a>
		<a class="item advertTypeB" href="javascript:;"><img src=""><em></em></a>
		<a class="item advertTypeB" href="javascript:;"><img src=""><em></em></a>
		<a class="item advertTypeB" href="javascript:;"><img src=""><em></em></a>
    </div>
    <ul class="zSyList colColor">
    	
    	
    	 <div id="loadingDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>
    	
    </ul>
</div>
</body>
</html>
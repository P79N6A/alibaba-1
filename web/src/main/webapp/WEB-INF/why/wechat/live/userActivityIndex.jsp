<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>安康文化云·直播</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css">
	</link>
	<style >
		html,body {height: 100%;}
    .twzbMain {background-color: #eee;}
	</style>
	
	<script type="text/javascript">
	$.ajaxSettings.async = false; 	//同步执行ajax
	
	var startIndex = 0;		//页数
	var liveId = sessionStorage.getItem("liveId");
	var liveCreateUser="${liveCreateUser}";
	
	if (userId == null || userId == '') {
		//判断登陆
    	publicLogin('${basePath}wechatLive/userActivityIndex.do?liveCreateUser='+liveCreateUser);
	}
	
	//分享是否隐藏
    if(window.injs){
    	//分享文案
    	appShareTitle = '安康文化云-专注文化直播上万家文化机构活动现场正在播报，抢鲜看';
    	appShareDesc = '导赏看展览，专业艺术启蒙，文化大咖面对面，艺术活动现场看.....文化活动尽在掌握';
    	appShareImgUrl = '${basePath}/STATIC/wechat/image/live/shareIcon.jpg';
    	
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
				title: "安康文化云-专注文化直播上万家文化机构活动现场正在播报，抢鲜看",
				desc: '导赏看展览，专业艺术启蒙，文化大咖面对面，艺术活动现场看.....文化活动尽在掌握',
				link: '${basePath}wechatLive/userActivityIndex.do?liveCreateUser='+liveCreateUser,
				imgUrl: '${basePath}/STATIC/wechat/image/live/shareIcon.jpg'
			});
			wx.onMenuShareTimeline({
				title: "安康文化云-专注文化直播上万家文化机构活动现场正在播报，抢鲜看",
				imgUrl: '${basePath}/STATIC/wechat/image/live/shareIcon.jpg',
				link: '${basePath}wechatLive/userActivityIndex.do?liveCreateUser='+liveCreateUser
			});
			wx.onMenuShareQQ({
				title: "安康文化云-专注文化直播上万家文化机构活动现场正在播报，抢鲜看",
				desc: '导赏看展览，专业艺术启蒙，文化大咖面对面，艺术活动现场看.....文化活动尽在掌握',
				imgUrl: '${basePath}/STATIC/wechat/image/live/shareIcon.jpg'
			});
			wx.onMenuShareWeibo({
				title: "安康文化云-专注文化直播上万家文化机构活动现场正在播报，抢鲜看",
				desc: '导赏看展览，专业艺术启蒙，文化大咖面对面，艺术活动现场看.....文化活动尽在掌握',
				imgUrl: '${basePath}/STATIC/wechat/image/live/shareIcon.jpg'
			});
			wx.onMenuShareQZone({
				title: "安康文化云-专注文化直播上万家文化机构活动现场正在播报，抢鲜看",
				desc: '导赏看展览，专业艺术启蒙，文化大咖面对面，艺术活动现场看.....文化活动尽在掌握',
				imgUrl: '${basePath}/STATIC/wechat/image/live/shareIcon.jpg'
			});
		});
	}
	
	$(function () {
		
		if(liveId){
			
			var data = {
					liveActivityId:liveId,
					liveActivityTimeStatus:0,
					liveStatus:1,
					liveCreateUser:liveCreateUser,
					liveType:1
	            };
			
			$.post("${path}/wechatLive/selectIndexNum.do",data, function (data) {
				
				var n = num;
				
				if (data.status == 1) {
					if(data.data>0){
						n = Math.ceil(data.data/20)*20;
        				startIndex = (Math.ceil(data.data/20)-1)*20;
					}
				}
				loadLiveActivityList(0,n);
				
			},"json");
		}
		else{
			loadLiveActivityList(0,num);
		}
		
		$.post("${path}/wechatLive/createUserInfo.do",{userId:liveCreateUser}, function (data) {
			
			if (data.status == 1) {
				
				var dom=data.data;
				
				var userName=dom.userName;
				var userHeadImgUrl=dom.userHeadImgUrl;
				
				$("#userName").html(userName);
				$("#userHeadImgUrl").attr("src",getUserHead(userHeadImgUrl))
			}
			
		},"json");
		
	});
	
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
	                  		loadLiveActivityList(index,num);
	           			}
	           		},800);
	            }
	        });
	
	
	function getUserHead(userHeadImgUrl){
		
		if(!userHeadImgUrl||userHeadImgUrl.indexOf("http") == -1){
			userHeadImgUrl='../STATIC/wx/image/sh_user_header_icon.png'
        }else if (userHeadImgUrl.indexOf("aliyuncs.com") != -1) {
        	userHeadImgUrl=userHeadImgUrl+"@50w"
        }
		else if (userHeadImgUrl.indexOf("/front/") != -1) {
            var imgUrl = getIndexImgUrl(userHeadImgUrl, "_300_300");
            userHeadImgUrl = imgUrl
        } 
		return userHeadImgUrl;
	}
	
	function loadLiveActivity(liveId){
		
		sessionStorage.setItem("liveId", liveId);
		
		window.location.href='${basePath}wechatLive/liveActivity.do?liveActivityId='+liveId;
	}
	
	function loadLiveActivityList(index, pagesize){
		p=1;
		var data = {
				liveActivityTimeStatus:0,
				liveStatus:1,
				liveCreateUser:liveCreateUser,
				liveType:1,
				liveCheck:2,
               	resultFirst: index,
               	resultSize: pagesize
            };
		
		$.post("${path}/wechatLive/getLiveActivityList.do",data, function (data) {
			if (data.status == 1) {
				if(data.data.list.length<num){
           			$("#loadingLiveActivityDiv").html("");
	        	}else{
					p=0;
				}
				
				$("#sum").text(data.data.sum)
				
				$.each(data.data.list, function (i, dom) {
					
					var liveActivityTimeStatus=dom.liveActivityTimeStatus;
					var liveType=dom.liveType;
					var liveTitle=dom.liveTitle;
					
					var divStatus="";
					if(liveActivityTimeStatus==1){
						divStatus='<div class="biao b1">正在直播<span></span></div>'
					}else if(liveActivityTimeStatus==2){
						divStatus='<div class="biao b2">尚未开始<span></span></div>'
					}else if(liveActivityTimeStatus==3){
						divStatus='<div class="biao b3">已结束<span></span></div>'
					}
					
					var divTitle='<div class="tit"><span>图文</span>'+liveTitle+'</div>';
					
					if(liveType==2){
						divTitle='<div class="tit blue"><span>视频</span>'+liveTitle+'</div>';
					}
					
					var imgWidth =750
					var imgHeight=320
					
					var ImgObj = new Image();
					ImgObj.src = dom.liveCoverImg+"@750w";
					ImgObj.onload = function(){
						if(ImgObj.width/ImgObj.height>imgWidth/imgHeight){
							var pLeft = (ImgObj.width*(imgHeight/ImgObj.height)-imgWidth)/2;
							$("img[liveActivityId="+dom.liveActivityId+"]").css({"height":imgHeight+"px","position":"absolute","left":"-"+pLeft+"px"});
						}else{
							var pTop = (ImgObj.height*(imgWidth/ImgObj.width)-imgHeight)/2;
							$("img[liveActivityId="+dom.liveActivityId+"]").css({"width":imgWidth+"px","position":"absolute","top":"-"+pTop+"px"});
						}
					}
					// 换算到天的基数 1000毫秒 * 60秒 * 60分钟* 24
					var n=86400000;
					var date =formatTimestamp(dom.liveStartTime/1000).substring(5,16);
					if((toDay-dom.liveStartTime)/n>365){
						 date =formatTimestamp(dom.liveStartTime/1000);
					}
					
					var userName=dom.userName;
					var userHeadImgUrl=dom.userHeadImgUrl;
					
					var li=
					'<li id="'+dom.liveActivityId+'" onclick="loadLiveActivity(\''+dom.liveActivityId+'\');">'+
		    		'<div class="pic">'+
		    			'<img liveActivityId="'+dom.liveActivityId+'" src="'+dom.liveCoverImg+'@750w">'+
		    			divStatus	+
		    		'</div>'+
		    		'<div class="char">'+
		    			divTitle+
		    			'<div class="clearfix">'+
		    				'<div class="bz"><img src="'+getUserHead(userHeadImgUrl)+'"></div>'+
		    				'<div class="cs">'+userName+'</div>'+
		    				'<div class="time">'+date+'</div>'+
		    				//'<div class="rens">1000</div>'+
		    			'</div>'+
		    		'</div>'+
		    	'</li>';
					
		    	$(".twzbListUl").append(li);
		    	
				});
			}
		},"json");
		
	}

	</script>
	<style>
		.twzbMain .listNr .toux{
			background:none;
		}
		</style>
	
	</head>
	
	<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${basePath}/STATIC/wechat/image/live/shareIcon.jpg"/></div>
	<div class="twzbMain" >
		<input type="hidden" id="liveCreateUser" name="liveCreateUser" value="${liveCreateUser }"/>
		<div class="banDetail clearfix">
	        <div class="toux"><img id="userHeadImgUrl" src=""></div>
	        <div id="userName" class="char"></div>
	    </div>
	     <div class="twchose clearfix">
	        <div class="tit">全部直播&nbsp;&nbsp;<span id="sum"></span></div>
	        <div class="xuan">
	            <!-- <div class="icon">筛选</div>
	            <div class="xiala">
	                <span class="current">不限</span>
	                <span>正在直播</span>
	                <span>尚未开始</span>
	                <span>已结束</span>
	            </div> -->
	        </div>
	    </div>
	    <ul class="twzbListUl">
	    	<!-- <li onclick="window.location.href='tw.html'">
	    		<div class="pic">
	    			<img src="../image/twzb/pic1.jpg">
	    			<div class="biao b1">正在直播<span></span></div>
	    		</div>
	    		<div class="char">
	    			<div class="tit"><span>图文</span>文化乡土成果展图文直播</div>
	    			<div class="clearfix">
	    				<div class="bz"><img src="../image/twzb/pic2.jpg"></div>
	    				<div class="cs">中华艺术宫</div>
	    				<div class="time">03-16 12：15</div>
	    				<div class="rens">1000</div>
	    			</div>
	    		</div>
	    	</li>
	    	<li onclick="window.location.href='tw.html'">
	    		<div class="pic">
	    			<div class="biao b2">尚未开始<span></span></div>
	    		</div>
	    		<div class="char">
	    			<div class="tit"><span>图文</span>文化乡土成果展图文直播</div>
	    			<div class="clearfix">
	    				<div class="bz"><img src="../image/twzb/pic2.jpg"></div>
	    				<div class="cs">中华艺术宫</div>
	    				<div class="time">03-16 12：15</div>
	    				<div class="rens">1000</div>
	    			</div>
	    		</div>
	    	</li>
	    	<li onclick="window.location.href='tw.html'">
	    		<div class="pic">
	    			<img src="../image/twzb/pic1.jpg">
	    			<div class="biao b1">已结束<span></span></div>
	    		</div>
	    		<div class="char">
	    			<div class="tit"><span>图文</span>文化乡土成果展图文直播</div>
	    			<div class="clearfix">
	    				<div class="bz"><img src="../image/twzb/pic2.jpg"></div>
	    				<div class="cs">中华艺术宫</div>
	    				<div class="time">03-16 12：15</div>
	    				<div class="rens">1000</div>
	    			</div>
	    		</div>
	    	</li> -->
	    </ul>
	    <div id="loadingLiveActivityDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>
	</div>
</body>
<script type="text/javascript">
$(function () {
	
	activityBanner();
	// banner
	/**var swiper = new Swiper('.swiper-container', {
        pagination: '.swiper-pagination',
        paginationClickable: true,
        autoplay : 5000,
        speed:500
    });
	**/
	if($(".bgWhite").attr("display","block")){
		
		if($("#"+liveId).offset()){
	  		$("html,body").animate({scrollTop:$("#"+liveId).offset().top-100},1000,function(){
	  			
	  			sessionStorage.removeItem("liveId")
	  			$(".bgWhite").fadeOut();
	  		});
		}else{
			$(".bgWhite").fadeOut();
		}
	}
	
	
	
});

//跳外链
function preOutUrl(url){ window.location.href = url; };

//首页banner轮播图
function activityBanner() {
		$.post("${path}/wechat/getAdvertRecommend.do", {advertPostion: 5,advertType: "A"}, function (data) {
            if (data.status == 1) {
            	$("#indexBannerList").html("");
            	$.each(data.data, function (i, dom) {
            		
            		if(dom.advertState==1){
            	  		var jumpUrl = dom.advertUrl;
            			var advertImgUrl = getIndexImgUrl(dom.advertImgUrl, "_750_250");
            			$("#indexBannerList").append("<div class='swiper-slide'>" +
					        							"<img id='advertImg"+dom.advertSort+"' src='"+advertImgUrl+"' width='750' height='250'/>" +
					    							 "</div>");
            			$("#advertImg"+dom.advertSort).attr("onclick","preOutUrl(\""+jumpUrl+"\");");
            		}
            	});
            	if(data.data.length>1){		//广告位A开始轮播
            		// banner
            		var swiper = new Swiper('.swiper-container', {
            	        pagination: '.swiper-pagination',
            	        paginationClickable: true,
            	        autoplay : 5000,
            	        speed:500
            	    });
            	}
            	
            	
            }
        }, "json");
}

</script>

</html>
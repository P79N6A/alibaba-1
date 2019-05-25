<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<title>公益艺术普及平台</title>
<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
<link rel="stylesheet" type="text/css" href="${path }/STATIC/css/yket/cjekt.css">
<script type="text/javascript">
if (userId == null || userId == '') {
	//判断登陆
	publicLogin("${basePath}myCourse/info.do");
}
//分享是否隐藏
if(window.injs){
	//分享文案
	var appShareTitle = '艺课e堂-市民艺术教育服务平台';
	var appShareDesc = '播撒艺术的种子，绽放梦想的光芒';
	var appShareImgUrl = '${basePath}/STATIC/image/cjekt/share.jpg';
	var appShareLink = '${basePath}/yketIndex/index.do';
	injs.setAppShareButtonStatus(true);
}

$(function () {
	//通过config接口注入权限验证配置
	 if (is_weixin()) {
		    wx.config({
		        debug: false,
		        appId: '${sign.appId}',
		        timestamp: '${sign.timestamp}',
		        nonceStr: '${sign.nonceStr}',
		        signature: '${sign.signature}',
		        jsApiList: ['onMenuShareAppMessage','onMenuShareTimeline']
		    });
		    wx.ready(function () {
		    	wx.onMenuShareAppMessage({
		    		title: "艺课e堂-市民艺术教育服务平台",
		    		link:'${basePath}/myCourse/info.do',
		            desc: "播撒艺术的种子，绽放梦想的光芒",
		            imgUrl: '${basePath}/STATIC/image/cjekt/share.jpg'
		        });
		    	wx.onMenuShareTimeline({
		            title: "艺课e堂-市民艺术教育服务平台",
		            link:'${basePath}/myCourse/info.do',
		            imgUrl: '${basePath}/STATIC/image/cjekt/share.jpg'
		        });
		    }); 
	 }
});

</script>
</head>
<body>
<!-- 分享的图片 -->
 <div id="indexShareBg" class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
		<img src="${path}/STATIC/image/cjekt/commonShare.png" style="width: 100%;height: 100%;" />
 </div>

<div class="ektMain">
	<div class="banner">
		<div class="circleWc">
			<div class="circle"><img src="${path}/STATIC/image/cjekt/bg6.png"></div>
		</div>
		<div class="anniu">
			<a href="http://hs.hb.wenhuayun.cn/wechat/index.do"></a>
			<a  class="yiqixx" href="javascript:;"></a>
 		</div>
		<div class="banPic"><img src="${path}/STATIC/image/cjekt/banPic1.png"></div>
		<div class="gongn"> 
			 <c:forEach items="${externalLinkList }" var="link">
		       <a href="${link.url }"></a>
		    </c:forEach>
		</div>
	</div>
	<div class="allNanWc">
		<ul class="allNan clearfix">
			 <c:choose>
		      <c:when test="${tab=='1' }">
		         <li onclick="goSkipTo(1)"   class="cur"><span style="background-image: url(${path }/STATIC/image/cjekt/nav1.png);"></span><em></em></li>
				 <li onclick="goSkipTo(2)"><span style="background-image: url(${path }/STATIC/image/cjekt/nav2.png);"></span><em></em></li>
				 <li onclick="goSkipTo(3)"><span style="background-image: url(${path }/STATIC/image/cjekt/nav3.png);"></span><em></em></li>
				 <li onclick="goSkipTo(4)"><span style="background-image: url(${path }/STATIC/image/cjekt/nav4.png);"></span><em></em></li>
				 <li onclick="goSkipToInfo();"><span style="background-image: url(${path }/STATIC/image/cjekt/nav5.png);"></span><em></em></li>
		      </c:when>
		      <c:when test="${tab=='2' }">
		         <li onclick="goSkipTo(1)"><span style="background-image: url(${path }/STATIC/image/cjekt/nav1.png);"></span><em></em></li>
				 <li onclick="goSkipTo(2)" class="cur"><span style="background-image: url(${path }/STATIC/image/cjekt/nav2.png);"></span><em></em></li>
				 <li onclick="goSkipTo(3)"><span style="background-image: url(${path }/STATIC/image/cjekt/nav3.png);"></span><em></em></li>
				 <li onclick="goSkipTo(4)"><span style="background-image: url(${path }/STATIC/image/cjekt/nav4.png);"></span><em></em></li>
				 <li onclick="goSkipToInfo();"><span style="background-image: url(${path }/STATIC/image/cjekt/nav5.png);"></span><em></em></li>
		      </c:when>
		      <c:when test="${tab=='3' }">
		         <li onclick="goSkipTo(1)"><span style="background-image: url(${path }/STATIC/image/cjekt/nav1.png);"></span><em></em></li>
				 <li onclick="goSkipTo(2)"><span style="background-image: url(${path }/STATIC/image/cjekt/nav2.png);"></span><em></em></li>
				 <li onclick="goSkipTo(3)" class="cur"><span style="background-image: url(${path }/STATIC/image/cjekt/nav3.png);"></span><em></em></li>
				 <li onclick="goSkipTo(4)"><span style="background-image: url(${path }/STATIC/image/cjekt/nav4.png);"></span><em></em></li>
				 <li onclick="goSkipToInfo();"><span style="background-image: url(${path }/STATIC/image/cjekt/nav5.png);"></span><em></em></li>
		      </c:when>
		      <c:when test="${tab=='4' }">
		         <li onclick="goSkipTo(1)"><span style="background-image: url(${path }/STATIC/image/cjekt/nav1.png);"></span><em></em></li>
				 <li onclick="goSkipTo(2)"><span style="background-image: url(${path }/STATIC/image/cjekt/nav2.png);"></span><em></em></li>
				 <li onclick="goSkipTo(3)"><span style="background-image: url(${path }/STATIC/image/cjekt/nav3.png);"></span><em></em></li>
				 <li onclick="goSkipTo(4)" class="cur"><span style="background-image: url(${path }/STATIC/image/cjekt/nav4.png);"></span><em></em></li>
				 <li onclick="goSkipToInfo();"><span style="background-image: url(${path }/STATIC/image/cjekt/nav5.png);"></span><em></em></li>
		      </c:when>
		      <c:otherwise>
		         <li onclick="goSkipTo(1)" ><span style="background-image: url(${path }/STATIC/image/cjekt/nav1.png);"></span><em></em></li>
				 <li onclick="goSkipTo(2)"><span style="background-image: url(${path }/STATIC/image/cjekt/nav2.png);"></span><em></em></li>
				 <li onclick="goSkipTo(3)"><span style="background-image: url(${path }/STATIC/image/cjekt/nav3.png);"></span><em></em></li>
				 <li onclick="goSkipTo(4)"><span style="background-image: url(${path }/STATIC/image/cjekt/nav4.png);"></span><em></em></li>
				 <li onclick="goSkipToInfo();" class="cur"><span style="background-image: url(${path }/STATIC/image/cjekt/nav5.png);"></span><em></em></li>
		      </c:otherwise>
		   </c:choose>
		</ul>
	</div>

	<div class="zujiShou">
		<div class="zTitNav">
			<div class="char clearfix">
				<a class="cur" href="javascript:;" data-type="trace">学习足迹</a>
				<a href="javascript:;" data-type="favorite">我的收藏</a>
			</div>
			<span class="bg"></span>
		</div>
		<div class="zujiList">
			<ul class="clearfix" id="containerData">
			</ul>
		</div>
		<div class="yiqixx"></div>
		<div class="yiqiKong">
			<!-- 没有内容显示的东西 -->
			<!-- <img class="kongPic" src="image/cjekt/icon7.png"> -->
			<!-- <img class="kongPic" src="image/cjekt/icon8.png"> -->
			<!-- <a class="qukankan" href="javascript:;">去看看</a> -->
		</div>
	</div>
	<div class="kengcTj">
		<div class="kctjTit"></div>
		<ul class="kengcTjList clearfix">
			     <c:forEach items="${recommend}" var="item">
			<li onclick="goSkipToDetail('${item.courseId}');">
				<img src="${item.courseImgUrl }">
				<div class="hei"></div>
				<div class="char">
					<div class="tit">${item.courseName }</div>
					<div class="keshi"><em>${item.hoursCount }</em>&nbsp;课时</div>
				</div>
			</li>
			</c:forEach>
			   
		</ul>
	</div>
	
</div>

</body>
<script type="text/javascript" src="${path }/STATIC/js/yket/cjekt.js"></script>
<script type="text/javascript">

if (userId == null || userId == '') {
	//判断登陆
	publicLogin("${basePath}myCourse/info.do");
}

$(function () {
	
	//分享
	$(".yiqixx").click(function() {
		$("html,body").addClass("bg-notouch");
		$(".background-fx").css("display", "block");
	})
	
	//分享的背景图
	$(".background-fx").click(function() {
		$("html,body").removeClass("bg-notouch");
		$(".background-fx").css("display", "none")
	})

    // 导航切换
    $('.allNan li').bind('click', function () {
    	$(this).parent('.allNan').find('li').removeClass('cur');
    	$(this).addClass('cur');
    });
    
    var baseUrl ='${path}/ykytCourseDetail/detail.do?userId='+userId+'&courseId=';
    $.post("${path}/myCourse/trace.do",{userId:userId},function(data){
		   if(data.result.data.length==0){
			   var url='${path}/yketIndex/index.do?userId='+userId;
			   $(".yiqixx").hide();
			   $(".yiqiKong").html('<img class="kongPic" src="${path}/STATIC/image/cjekt/icon7.png"><a class="qukankan" href='+url+'>去看看</a>');
		   }else{
			   $(".yiqixx").show();
		   } 
			// 学习足迹和我的收藏 的列表长度
		    $('.zujiList ul').css({
		    	'width' : data.result.data.length * 323 + 15
		    });
		
		   var htmlDiv='';
		   if(data.result.status=='ok' && data.result.data.length>0){
			   var itemStr='';
		  	$.each(data.result.data, function (i, dom) {
		  		 if(dom && dom.courseId){
		  			itemStr="<li onclick=window.location.href='"+baseUrl+dom.courseId+"' ><div class='pic'><img src="+dom.courseImgUrl+"></div><div class='wen'>"+dom.courseName+"</div></li>" 
		  		 }
		  		htmlDiv+=itemStr;
	    	})
	    	$("#containerData").html(htmlDiv);
	    	// 学习足迹和我的收藏图片
	        $('.zujiList ul li .pic img').picFullCentered({'boxWidth' : 270,'boxHeight' : 185});
	    	
		   }
     })
    
    
    // 学习足迹和我的收藏按钮切换
    $('.zTitNav .char a').bind('click', function () {
    	$(this).parent('.char').find('a').removeClass('cur');
    	$(this).addClass('cur');
    	var _left = $(this).position().left;
    	if(_left == 0) {
    		_left = -1;
    	}
    	var url='${path}/yketIndex/index.do?userId='+userId;
    	var baseUrl ='${path}/ykytCourseDetail/detail.do?userId='+userId+'&courseId=';
    	if($(this).attr("data-type")=='trace'){
    		   $.post("${path}/myCourse/trace.do",{userId:userId},function(data){
    			   $("#containerData").html('');
    			   if(data.result.data.length==0){
    				   $(".yiqixx").hide();
    				   $(".yiqiKong").html('<img class="kongPic" src="${path}/STATIC/image/cjekt/icon7.png"><a class="qukankan" href='+url+'>去看看</a>');
    			   }else{
    				   $(".yiqixx").show();
    			   }
    				// 学习足迹和我的收藏 的列表长度
    			    $('.zujiList ul').css({
    			    	'width' : data.result.data.length * 323 + 15
    			    });
    			
    			   var htmlDiv='';
    			   if(data.result.status=='ok' && data.result.data.length>0){
    				   var itemStr='';
    			  	$.each(data.result.data, function (i, dom) {
    			  		 if(dom && dom.courseId){
    			  			itemStr="<li onclick=window.location.href='"+baseUrl+dom.courseId+"' ><div class='pic'><img src="+dom.courseImgUrl+"></div><div class='wen'>"+dom.courseName+"</div></li>" 
    			  		 }
    			  		htmlDiv+=itemStr;
        	    	})
         	    	$("#containerData").html(htmlDiv);
        	    	// 学习足迹和我的收藏图片
        	        $('.zujiList ul li .pic img').picFullCentered({'boxWidth' : 270,'boxHeight' : 185});
        	    	
    			   }
    	        })
    	}else{
    		
        	  var url='${path}/yketIndex/index.do?userId'+userId;
    		   $.post("${path}/myCourse/favoirte.do",{userId:userId},function(data){
    			   
    			   $("#containerData").html('');
    			   if(data.result.data.length==0){
    				   $(".yiqixx").hide();
     				   $(".yiqiKong").html('<img class="kongPic" src="${path}/STATIC/image/cjekt/icon8.png"><a class="qukankan" href='+url+'>去看看</a>');
    			   } 
   				// 学习足迹和我的收藏 的列表长度
   			    $('.zujiList ul').css({
   			    	'width' : data.result.data.length * 323 + 15
   			    });
   			
   			   var htmlDiv='';
   			   if(data.result.status=='ok' && data.result.data.length>0){
   				   var itemStr='';
   			  	$.each(data.result.data, function (i, dom) {
   			  		 if(dom && dom.courseId){
   			  			itemStr="<li onclick=window.location.href='"+baseUrl+dom.courseId+"' ><div class='pic'><img src="+dom.courseImgUrl+"></div><div class='wen'>"+dom.courseName+"</div></li>" 
   			  		 }
   			  		htmlDiv+=itemStr;
       	    	})
        	    	$("#containerData").html(htmlDiv);
       	    	// 学习足迹和我的收藏图片
       	        $('.zujiList ul li .pic img').picFullCentered({'boxWidth' : 270,'boxHeight' : 185});
       	    	
   			   }
   	        })
    	}
    	$('.zTitNav .bg').stop().animate({'left':_left},150,'linear')
    });

    
    
    
    // 课程推荐图片
    $('.kengcTjList li img').picFullCentered({'boxWidth' : 348,'boxHeight' : 246});


});

function goSkipTo(tab){
	  window.location.href='${path}/yketIndex/index.do?tab='+tab+'&userId='+userId;
}
function goSkipToInfo(){
	  window.location.href='${path}/myCourse/info.do?userId='+userId;
}
function goSkipToDetail(courseId){
	  window.location.href='${path}/ykytCourseDetail/detail.do?courseId='+courseId+'&userId='+userId
}
</script>
</html>
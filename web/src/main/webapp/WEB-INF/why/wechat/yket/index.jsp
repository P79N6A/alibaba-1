<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<title>公益艺术普及平台</title>

<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
<link rel="stylesheet" type="text/css" href="${path }/STATIC/css/yket/cjekt.css?d=dfgsdfgdfgdf">
<script type="text/javascript">
if (userId == null || userId == '') {
	//判断登陆
	publicLogin("${basePath}yketIndex/index.do");
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
		    		link:'${basePath}/yketIndex/index.do',
		            desc: "播撒艺术的种子，绽放梦想的光芒",
		            imgUrl: '${basePath}/STATIC/image/cjekt/share.jpg'
		        });
		    	wx.onMenuShareTimeline({
		            title: "艺课e堂-市民艺术教育服务平台",
		            link:'${basePath}/yketIndex/index.do',
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
			<div class="circle">
			<c:choose>
			 <c:when test="${tab eq	'1'  or  tab eq	'2' }">
			 	<img src="${path }/STATIC/image/cjekt/bg5.png">
			 </c:when>
			<c:otherwise>
				<img src="${path }/STATIC/image/cjekt/bg6.png">
			</c:otherwise>
			</c:choose>
			
			
			</div>
		</div>
		<div class="anniu">
			<a href="http://hs.hb.wenhuayun.cn/wechat/index.do"></a>
			<a id="fxIndex" href="javascript:;"></a>
 		</div>
		<div class="banPic"><img src="${path }/STATIC/image/cjekt/banPic1.png"></div>
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
		         <li onclick="goSkipTo(1);"   class="cur"><span style="background-image: url(${path }/STATIC/image/cjekt/nav1.png);"></span><em></em></li>
				 <li onclick="goSkipTo(2);"><span style="background-image: url(${path }/STATIC/image/cjekt/nav2.png);"></span><em></em></li>
				 <li onclick="goSkipTo(3);"><span style="background-image: url(${path }/STATIC/image/cjekt/nav3.png);"></span><em></em></li>
				 <li onclick="goSkipTo(4);"><span style="background-image: url(${path }/STATIC/image/cjekt/nav4.png);"></span><em></em></li>
				 <li onclick="goSkipToInfo();"><span style="background-image: url(${path }/STATIC/image/cjekt/nav5.png);"></span><em></em></li>
		      </c:when>
		      <c:when test="${tab=='2' }">
		         <li onclick="goSkipTo(1);"><span style="background-image: url(${path }/STATIC/image/cjekt/nav1.png);"></span><em></em></li>
				 <li onclick="goSkipTo(2);" class="cur"><span style="background-image: url(${path }/STATIC/image/cjekt/nav2.png);"></span><em></em></li>
				 <li onclick="goSkipTo(3);"><span style="background-image: url(${path }/STATIC/image/cjekt/nav3.png);"></span><em></em></li>
				 <li onclick="goSkipTo(4);"><span style="background-image: url(${path }/STATIC/image/cjekt/nav4.png);"></span><em></em></li>
				 <li onclick="goSkipToInfo();"><span style="background-image: url(${path }/STATIC/image/cjekt/nav5.png);"></span><em></em></li>
		      </c:when>
		      <c:when test="${tab=='3' }">
		         <li onclick="goSkipTo(1);"><span style="background-image: url(${path }/STATIC/image/cjekt/nav1.png);"></span><em></em></li>
				 <li onclick="goSkipTo(2);"><span style="background-image: url(${path }/STATIC/image/cjekt/nav2.png);"></span><em></em></li>
				 <li onclick="goSkipTo(3);" class="cur"><span style="background-image: url(${path }/STATIC/image/cjekt/nav3.png);"></span><em></em></li>
				 <li onclick="goSkipTo(4);"><span style="background-image: url(${path }/STATIC/image/cjekt/nav4.png);"></span><em></em></li>
				 <li onclick="goSkipToInfo();"><span style="background-image: url(${path }/STATIC/image/cjekt/nav5.png);"></span><em></em></li>
		      </c:when>
		      <c:when test="${tab=='4' }">
		         <li onclick="goSkipTo(1);"><span style="background-image: url(${path }/STATIC/image/cjekt/nav1.png);"></span><em></em></li>
				 <li onclick="goSkipTo(2);"><span style="background-image: url(${path }/STATIC/image/cjekt/nav2.png);"></span><em></em></li>
				 <li onclick="goSkipTo(3);"><span style="background-image: url(${path }/STATIC/image/cjekt/nav3.png);"></span><em></em></li>
				 <li onclick="goSkipTo(4);" class="cur"><span style="background-image: url(${path }/STATIC/image/cjekt/nav4.png);"></span><em></em></li>
				 <li onclick="goSkipToInfo();"><span style="background-image: url(${path }/STATIC/image/cjekt/nav5.png);"></span><em></em></li>
		      </c:when>
		      <c:otherwise>
		         <li onclick="goSkipTo(1);" ><span style="background-image: url(${path }/STATIC/image/cjekt/nav1.png);"></span><em></em></li>
				 <li onclick="goSkipTo(2);"><span style="background-image: url(${path }/STATIC/image/cjekt/nav2.png);"></span><em></em></li>
				 <li onclick="goSkipTo(3);"><span style="background-image: url(${path }/STATIC/image/cjekt/nav3.png);"></span><em></em></li>
				 <li onclick="goSkipTo(4);"><span style="background-image: url(${path }/STATIC/image/cjekt/nav4.png);"></span><em></em></li>
				 <li onclick="goSkipToInfo();" class="cur"><span style="background-image: url(${path }/STATIC/image/cjekt/nav5.png);"></span><em></em></li>
		      </c:otherwise>
		   </c:choose>
		</ul>
	</div>
	<div class="allFilter" style="height: 100px;">
		<div class="jz700 clearfix" >
			<!-- <div class="qbkc">全部课程</div> -->
			<!-- <div class="xDiv clearfix">
			   
			</div> -->
		</div>
	</div>
	<div class="allCourseWC">
		<div class="allCourse">
		 <c:forEach items="${list}" var="item">
			<div class="item clearfix" onclick="goSkipToDetail('${item.courseId}');">
				<div class="char">
					<div class="wenz clearfix">
						<div class="tit">${item.courseName}</div>
						 <div class="xian"></div>
						<div class="zhu"><span>主讲人</span>${item.teacher.teacherName}</div>
					</div>
					 
						<div class="ks"><span>${item.courseTimeCount}</span>课时</div>
					 
					
				</div>
				<div class="pic"><img 
				
				<c:if test="${empty item.courseImgUrl or item.courseImgUrl==''}">
				src="${path }/STATIC/image/cjekt/pic1.jpg"  
				</c:if>
				<c:if test="${not empty item.courseImgUrl and item.courseImgUrl!=''}">
				src="${item.courseImgUrl}"  
				</c:if>
				>
				
				<c:if test="${empty item.likeCount or item.likeCount le 0 }">
					<span class="collect" data-objectId="${item.courseId }"  ></span>
				</c:if>
				<c:if test="${not empty item.likeCount and item.likeCount gt 0 }">
					<span class="collect active"  data-objectId="${item.courseId }"  ></span>
				</c:if>
				 
				
				</div>
			</div>
		</c:forEach>
		</div>
	</div>
</div>

</body>
<script type="text/javascript" src="${path }/STATIC/js/yket/cjekt.js"></script>
<script type="text/javascript">
$(function () {
	
	//分享
	$("#fxIndex").click(function() {
		$("html,body").addClass("bg-notouch");
		$(".background-fx").css("display", "block");
	});
	
	//分享的背景图
	$(".background-fx").click(function() {
		$("html,body").removeClass("bg-notouch");
		$(".background-fx").css("display", "none")
	});
    
    // 导航切换
    $('.allNan li').bind('click', function () {
    	$(this).parent('.allNan').find('li').removeClass('cur');
    	$(this).addClass('cur');
    });


    // 点赞
    $('.allCourse .item .collect').bind('click', function (evt) {
    	var e = evt || window.event;
        e.stopPropagation();
        
    	if($(this).hasClass('active')) {
    		$(this).removeClass('active');
    	} else {
    		$(this).addClass('active');
    	}
        $.post('${path}/common/like.do',{userId:userId,likeType:'COURSE',objectId:$(this).attr("data-objectId")},function(data){
         
        });
    	
    });

    // 课程列表图片
    $('.allCourse .item .pic img').picFullCentered({'boxWidth' : 490,'boxHeight' : 340});
    
     /*     $.post('${path}/yketIndex/labelTypeList.do',{labelType:'COURSE'},function(data){
    	
    	var curTab=getUrlParam('tab');
    	$.each(data, function (i, dom) {
    		$('.xDiv').append("<a href='${path}/yketIndex/index.do?tab="+curTab+"&course="+dom.labelId+"' >" +dom.labelName+ "<em></em></a>")
    	})
    }) */
    
     function getUrlParam(name) {
            var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
            var r = window.location.search.substr(1).match(reg);  //匹配目标参数
            if (r != null) return unescape(r[2]); return null; //返回参数值
      }

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
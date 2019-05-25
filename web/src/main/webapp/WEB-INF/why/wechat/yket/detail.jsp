<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html >
<html>
<head>
<title>公益艺术普及平台</title>
<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>

<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/yket/cjekt.css">
<script type="text/javascript" src="${path}/STATIC/mobileLayer/need/layer.css"></script>
<script type="text/javascript" src="${path}/STATIC/mobileLayer/layer.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/common.js"></script>

 

<script type="text/javascript">
if (userId == null || userId == '') {
	//判断登陆
	publicLogin("${basePath}ykytCourseDetail/detail.do?courseId="+'${courseDetail.courseId}');
}

//分享是否隐藏
if(window.injs){
	//分享文案
	var appShareTitle = '艺课e堂-市民艺术教育服务平台';
	var appShareDesc = '播撒艺术的种子，绽放梦想的光芒';
	var appShareImgUrl = '${basePath}/STATIC/image/cjekt/share.jpg';
	var appShareLink = '${basePath}/ykytCourseDetail/detail.do';
	
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
		    		link:'${basePath}/ykytCourseDetail/detail.do',
		            desc: "播撒艺术的种子，绽放梦想的光芒",
		            imgUrl: '${basePath}/STATIC/image/cjekt/share.jpg'
		        });
		    	wx.onMenuShareTimeline({
		            title: "艺课e堂-市民艺术教育服务平台",
		            link:'${basePath}/ykytCourseDetail/detail.do',
		            imgUrl: '${basePath}/STATIC/image/cjekt/share.jpg'
		        });
		    }); 
	 }

});
 






</script>

<style type="text/css">
html,body {background-color: #f5f5f5;}
</style>
</head>
<body>
<!-- 分享的图片 -->
 <div id="indexShareBg" class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
		<img src="${path}/STATIC/image/cjekt/commonShare.png" style="width: 100%;height: 100%;" />
 </div>

<div class="ektMain">
	<div class="shipinEle"  style="background-image: url(${courseDetail.courseImgUrl });">
		<video controls="controls" src=""></video>
	</div>
	<%-- <div class="shipinEle">
		<video controls="controls" src="" poster="${courseDetail.courseImgUrl }"></video>
	</div> --%>
	<div class="miaosDet">
		<div class="jz700">
			<div class="tit">${courseDetail.courseName }</div>
			<div class="xueks">${courseDetail.coursePress } <c:if test="${not empty courseDetail.coursePress }">&nbsp;&nbsp;|&nbsp;&nbsp;</c:if><span>${courseDetail.courseHours.size()}课时</span></div>
			<div class="gongBtn clearfix">
				<span class="pl"><em></em><b id="plSum">${courseDetail.commentCount }</b>评论</span>
				<c:if test="${courseDetail.isLiked=='Y' }">
				<span class="dz active"><em></em><b  id="dzSum">${courseDetail.likeCount }</b></span>
				</c:if>
				<c:if test="${courseDetail.isLiked=='N' }">
				<span class="dz "><em></em><b  id="dzSum">${courseDetail.likeCount }</b></span>
				</c:if>
				
				<c:if test="${courseDetail.isFavorite=='Y' }">
				<span class="sc active"><em></em>收藏</span>
				</c:if>
				<c:if test="${courseDetail.isFavorite=='N' }">
				<span class="sc"><em></em>收藏</span>
				</c:if>
				
				<span class="fx"><em></em>分享</span>
			</div>
		</div>
	</div>
	<div class="classList">
		<ul class="clearfix">
		<c:forEach items="${courseDetail.courseHours }" var="item">
			<li onclick="huiguFun(this)" _src="${item.videoUrl}" _poster="image/cjekt/pic2.jpg">
				<div class="tit">${item.hourName}</div>
				<div class="shi">${item.courseDuration}</div>
			</li>
		</c:forEach>
			 
		</ul>
	</div>
	<div class="jianshuDet">
		<div class="jz700">
			<div class="cont">${courseDetail.msg }</div>
			<div class="lable clearfix">
			  <c:forEach  items="${courseDetail.courseFormlabels}" var="item"> 
				<span>${item.labelName}</span>
			 </c:forEach>					
			</div>
		</div>
	</div>
	<!-- 主讲老师 -->
	<div class="detailCont">
	
	   <c:forEach items="${courseDetail.teachers }" var="item">
	
	
		<div class="ztit">主讲老师</div>
		<div class="zhujiang clearfix">
			<div class="pic"><div class="nc"><img src="${item.teacherHeaderImg}"></div></div>
			<div class="char">
				<div class="xm">${item.teacherName }</div>
				<div class="zc">${item.teacherTitle }</div>
			</div>
		</div>	
		<div class="zhujiangneir">${item.teacherIntro}</div>


   </c:forEach>








	</div>
	<!-- 课程推荐 -->
	<div class="detailCont">
		<div class="ztit">课程推荐</div>
		<ul class="kengcTjList clearfix">
		   
		   <c:forEach items="${recommend}" var="item">
			<li onclick="goSkipToDetail('${item.courseId}')">
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
	<!-- 课程评论 -->
	<div class="detailCont kecplunCont">
		<div class="kecplunFixedWc"     
		
		 <c:if test="${ not empty courseDetail.pickUpcomment }">
				style="height:360px;"					 
		 </c:if>
		 <c:if test="${ empty courseDetail.pickUpcomment }">
				style="height:204px;"					 
		 </c:if>
		 
		>
			<div class="kecplunFixed">
				<div class="ztit" style="border-bottom-color:transparent;">课程评论</div>
				<div class="commentInput">
					<input type="text" placeholder="发表伟大的言论...">
					<div class="anBtn"></div>
				</div>
				<c:if test="${ not empty courseDetail.pickUpcomment }">
				<div class="commentJc clearfix">
					<div class="zuo">精选<br>评论</div>
				
					<div class="you">${courseDetail.pickUpcomment.content}</div>
				</div>
				</c:if>
				
			</div>
		</div>
		<ul class="conmmentList">
		</ul>
		<!-- <div class="more">查看更多</div> -->
	</div>
	<!-- 回到顶部 -->
	<!-- <div class="hdtop"></div> -->
	<!-- 返回首页 -->
	<div class="hdShouye" onclick="backToHome();"></div>
</div>

</body>
<script type="text/javascript" src="${path }/STATIC/js/yket/cjekt.js"></script>
<script type="text/javascript">



function huiguFun(ele) {
    var _index = $(ele).index();
    if(_index >= 2) {
        $('.classList').animate({scrollLeft : (_index - 1) * 307 + 90},200);
    } else {
        $('.classList').animate({scrollLeft : 0},200);
    }
}
function defaultCourse(strTime) {
    $('.classList ul li').each(function () {
    	
    	var _video = $('.shipinEle video');
    	_video.attr("src",$(this).attr("_src"));
    	
        if($(this).index() == strTime) {
            $(this).addClass('cur');
            var _index = $(this).index();
            if(_index >= 2) {
                $('.classList').scrollLeft((_index - 1) * 307 + 90);
            } else {
                $('.classList').scrollLeft(0);
            }
        }
    });
}

var firstResult=0;
var rows=10;
var page=1;
var remain=0;
var leftRemain=0;
$(function () {
	
	//分享
	$(".fx").click(function() {
		$("html,body").addClass("bg-notouch");
		$(".background-fx").css("display", "block");
	})
	
	//分享的背景图
	$(".background-fx").click(function() {
		$("html,body").removeClass("bg-notouch");
		$(".background-fx").css("display", "none")
	})
	

    // 课时的列表长度
    $('.classList ul').css({
    	'width' : $('.classList ul li').length * 307 + 15
    });
    // 课时选择
    $('.classList ul li').bind('click', function () {
    	var _video = $('.shipinEle video');
    	$(this).parent('ul').find('li').removeClass('cur');
    	$(this).addClass('cur');
    	_video.attr('src',$(this).attr('_src'));
    	/* _video.attr('poster',$(this).attr('_poster')); */
    });
    

    // 课程列表图片
    $('.kengcTjList li img').picFullCentered({'boxWidth' : 490,'boxHeight' : 340});

    // 回到顶部
   // $(".hdtop").backTop();

    
    
    // 课程评论
    function kecplunFun() {
    	var _kecplun = $('.kecplunCont').offset().top;
    	if($(document).scrollTop() >= _kecplun) {
    		$('.kecplunCont .kecplunFixed').css('position','fixed');
    	} else {
    		$('.kecplunCont .kecplunFixed').css('position','static');
    	}
    }
    /* kecplunFun();
    $(window).bind('scroll',kecplunFun); */
    $('.miaosDet .gongBtn .pl').bind('click', function () {
    	$("html,body").animate({scrollTop : $('.kecplunCont').offset().top},200);
    });
    $('html,body').bind('touchstart', function () {
    	$('.commentInput input').blur();
    });
    $('.commentInput input').bind('touchstart', function (evt) {
    	var e = evt || window.event;
        e.stopPropagation();
    });

    $(document).keyup(function (evt) {
    	if(($('.commentInput input').val()).trim().length) {
    		$('.commentInput .anBtn').addClass('gou');
    	} else {
    		$('.commentInput .anBtn').removeClass('gou');
    	}
    });
    $('.commentInput .anBtn').bind('click', function () {
    	if($(this).hasClass('gou')) {
    		// 发送消息
    		
       var content=$('.commentInput input').val();
        $.post('${path}/common/comment.do',{userId:userId,commentType:'COURSE',objectId:'${courseDetail.courseId}',content:content},function(data){
         if(data.result.status=='ok'){
        	 $('.commentInput .anBtn').removeClass('gou');
        	 var plSum= $("#plSum").text();
    		 if(plSum==''){
    			 plSum=0;
    		 }
    		 $("#plSum").text(parseInt(plSum)+1);
    		// $(".more").click();  start   
    		    var imgUrl='';
 	    	    if(data.result.data && (!data.result.data.userHeadImgUrl ||  data.result.data.userHeadImgUrl=='')){
  				    imgUrl='${path}/STATIC/image/cjekt/pic1.jpg';
		  		 }else{
		  			imgUrl=data.result.data.userHeadImgUrl; 
		  		 }
 	    	    var userName='';
 	    	    if(data.result.data && (!data.result.data.userName ||  data.result.data.userName=='')){
 	    	    	userName='子思';
		  		 }else{
		  			userName=data.result.data.userName; 
		  		 }
	    		$(".conmmentList").prepend("<li class='clearfix'><div class='pic'><img src='"+imgUrl+"'></div><div class='you'><div class='xm'>"+userName+"</div><div class='sj'>"+getNowFormatDate()+"</div><div class='ms'>"+content+"</div></div></li>");
    		//end 
    		
    		 $('.commentInput input').val("");
         }else{
        	  
        	 //TODO
        	 layer.open({
     		    content: data.result.msg
     		    ,skin: 'msg'
     		    ,time: 2 //2秒后自动关闭
     		    ,style:'font-size:32px;width:60%;height:70px;padding-top:25px'
              });
        	 
        	 
         }
        })
    		
    	} else {
    		// 回到顶部
    		$("html,body").animate({scrollTop:0},400);
    	}
    });


    // 点赞
    $('.miaosDet .gongBtn .dz').bind('click', function () {
    	if($(this).hasClass('active')) {
    		$(this).removeClass('active');
    		 var dzSum= $("#dzSum").text();
    		 if(dzSum==''){
    			 dzSum=0;
    		 }
    		 $("#dzSum").text(parseInt(dzSum)-1);
    	} else {
    		$(this).addClass('active');
    		 var dzSum= $("#dzSum").text();
    		 if(dzSum==''){
    			 dzSum=0;
    		 }
    		 $("#dzSum").text(parseInt(dzSum)+1);
    	}
    	
  	  // 点赞
        $.post('${path}/common/like.do',{userId:userId,likeType:'COURSE',objectId:'${courseDetail.courseId }'},function(data){
         
        })
    	
    });
    
    // 点赞
    $('.miaosDet .gongBtn .sc').bind('click', function () {
    	if($(this).hasClass('active')) {
    		$(this).removeClass('active');
    	} else {
    		$(this).addClass('active');
    	}
    	
  	  // 点赞
        $.post('${path}/common/favorite.do',{userId:userId,likeType:'COURSE',objectId:'${courseDetail.courseId }'},function(data){
         
        })
    	
    });
    
    
    
    
    

    // 	$("html,body").animate({scrollTop:0},400);
    
    defaultCourse(0);

    //加载评论列表
    $.post("${path}/common/commentList.do",{userId:userId,commentType:'COURSE',objectId:'${courseDetail.courseId}',firstResult:'',rows:''},function(data){
    	if(data.result.status=='ok'){
	    	$.each(data.result.data, function (i, dom) {
	      		     var imgUrl='';
			  		 if(dom && (!dom.userHeadImgUrl ||  dom.userHeadImgUrl=='')){
 	  				    imgUrl='${path}/STATIC/image/cjekt/pic1.jpg';
			  		 }else{
			  			imgUrl=dom.userHeadImgUrl; 
			  		 }
			  		    var userNickName='';
	     	    	    if(dom && (!dom.userNickName ||  dom.userNickName=='')){
	     	    	    	userNickName='子思';
				  		 }else{
				  			userNickName=dom.userNickName; 
				  		 }
	    			$(".conmmentList").append("<li class='clearfix'><div class='pic'><img src='"+imgUrl+"'></div><div class='you'><div class='xm'>"+userNickName+"</div><div class='sj'>"+dom.createTime+"</div><div class='ms'>"+dom.content+"</div></div></li>");
	    	})
     		if(data.result.data.length==rows){
    			page+=1;
    			leftRemain=0;	
    		}else{
    			// 已经显示了的条数
   	    	 leftRemain=data.result.data.length;	
    		} 
    	    
    		 
    	}
    })
    
     
    /*
    $(".more").click(function () {
        $.post("${path}/common/commentList.do",{commentType:'COURSE',objectId:'${courseDetail.courseId}',firstResult:rows*(page-1),rows:rows},function(data){
         
        	
        	if(data.result.status=='ok'){
        		
        	    // 是否有更新
                if(leftRemain==data.result.data.length || data.result.data.length==0){
               	 layer.open({
            		    content: '没有更多评论了'
            		    ,skin: 'msg'
            		    ,time: 2 //2秒后自动关闭
            		    ,style:'font-size:32px;width:50%;height:70px;padding-top:25px'
                 });
               	 return ;
                }
        		
     	    	$.each(data.result.data, function (i, dom) {
     	    	     var imgUrl='';
     	    	    if(dom && (!dom.userHeadImgUrl ||  dom.userHeadImgUrl=='')){
	  				    imgUrl='${path}/STATIC/image/cjekt/pic1.jpg';
			  		 }else{
			  			imgUrl=dom.userHeadImgUrl; 
			  		 }
     	    	    var userNickName='';
     	    	    if(dom && (!dom.userNickName ||  dom.userNickName=='')){
     	    	    	userNickName='子思';
			  		 }else{
			  			userNickName=dom.userNickName; 
			  		 }
     	    	    
    	    		if(i<data.result.data.length-leftRemain){
    	    			$(".conmmentList").append("<li class='clearfix'><div class='pic'><img src='"+imgUrl+"'></div><div class='you'><div class='xm'>"+userNickName+"</div><div class='sj'>"+dom.createTime+"</div><div class='ms'>"+dom.content+"</div></div></li>");
    	    		}
    	    	})
    	    	
    	    	
    	    	if(data.result.data.length==rows){
        			page+=1;
        			leftRemain=0;
        		}else{
        			leftRemain=data.result.data.length;
        		}
        	}
        })
    	
	});   */
   
});

function getNowFormatDate() {
    var date = new Date();
    var seperator1 = "-";
    var seperator2 = ":";
    var year = date.getFullYear();
    var month = date.getMonth() + 1;
    var strDate = date.getDate();
    if (month >= 1 && month <= 9) {
        month = "0" + month;
    }
    if (strDate >= 0 && strDate <= 9) {
        strDate = "0" + strDate;
    }
    var currentdate = year + seperator1 + month + seperator1 + strDate
            + " " + date.getHours() + seperator2 + date.getMinutes()
            + seperator2 + date.getSeconds();
    return currentdate;
}
function goSkipToDetail(courseId){
	  window.location.href='${path}/ykytCourseDetail/detail.do?courseId='+courseId+'&userId='+userId
}

function backToHome(){
	window.location.href='${path}/yketIndex/index.do?userId='+userId;
}
</script>
</html>
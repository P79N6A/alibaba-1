<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>文化佛山</title>
  <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp" %>
    <script type="text/javascript" src="${path}/STATIC/wechat/js/jquery.lazyload.min.js"></script>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/hsStyle.css"/>
</head>
<body>
	<div class="main">
		<div class="content padding-bottom0">
			<div class="active" style="margin-top: 15px;">
				<ul id="index_list" class="activeUl"></ul>
			</div>
			<div id="loadingDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>
		</div>
	</div>
</body>
<script>
var startIndex = 0;		//页数
var venueId='${venueId}';
$(function(){
	toLoadRoomList(venueId,0,20);
})

function toLoadRoomList(venueId,index,pagesize){
	var data={
      		venueId:venueId,
      		pageIndex:index,
  			pageNum:pagesize
      }
	 $.post("${path}/wechatVenue/activityWcRoom.do",data,function(data){
		 if(data.status==0){
				 if(data.data.length==0&&index==0){
		   				$("#loadingDiv").html("<span class='noLoadingSpan'>没有找到合适的结果，换个试试看吧~</span>");
		   			}else{
			 $.each(data.data,function(i,dom){
				 $("#loadingDiv").html("");
	             var imgUrl = getIndexImgUrl(dom.roomPicUrl, "_750_500");
	             $("#index_list").append(
	            		 "<li onclick='roomDeatil(\""+dom.roomId+"\")'>"+
	            		    "<div class='activeList'>"+
	            		      "<img src='"+imgUrl+"' width='750' height='475'/>"+
	            		     "</div>"+
	            		    "<p class='activeTitle'>"+dom.roomName+"</p>"+
	            		    "<p class='activePT'>面积："+dom.roomArea+"㎡</p>" +
	            		    "<p class='activePT'>容纳人数："+dom.roomCapacity+"人</p>" +
	            		 "</li>"
	             );
			 });
			}
		}
	 },"json");
}

function roomDeatil(roomId){
	window.location.href="${path}/wechatRoom/preRoomDetail.do?roomId="+roomId;
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
   			toLoadRoomList(venueId,index, 20);
   		},200);
    }
});
</script>
</html>
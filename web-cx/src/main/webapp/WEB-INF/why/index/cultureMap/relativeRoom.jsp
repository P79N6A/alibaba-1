<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>文化佛山</title>
  <!-- 导入头部文件 start -->
  <%@include file="/WEB-INF/why/common/frontIndexPageFrame.jsp"%>
  	<link type="text/css" rel="stylesheet" href="${path}/STATIC/css/normalize.css" />
	<link type="text/css" rel="stylesheet" href="${path}/STATIC/css/style.css" />
	<link type="text/css" rel="stylesheet" href="${path}/STATIC/css/styleChild.css" />
</head>
<body>
<!-- 导入头部文件 -->
	<div class="header">
		<%@include file="../header.jsp" %>
	</div>
	<div id="hot_list">
        <!--list start-->
        <h2 style="font-size: 18px;color: #333;font-weight: normal;background-color: #fafafa;padding: 15px 20px;border-radius: 4px;margin: 20px auto 10px auto">${venueName}</h2>
        <div class="ul_list" id="activityListDivChild" style="min-height: 600px;">
            <ul class="hl_list clearfix">
            
            </ul>
        </div>
    </div>
		<%@include file="/WEB-INF/why/index/footer.jsp" %>
</body>
<script type="text/javascript">
var startIndex = 0;		//页数
var venueId='${venueId}';
 $(function(){
	 roomList(venueId,0,20);
	 $("#cultureMapIndex").addClass('cur').siblings().removeClass('cur');
 });
 
 function roomList(venueId,index, pagesize){
	 var data={
	      		venueId:venueId,
	      		pageIndex:index,
	  			pageNum:pagesize
	      }
	 $.post("${path}/wechatVenue/activityWcRoom.do",data,function(data){
		 var str = '';
		 if(data.status==0){
			 if(data.data.length==0&&index==0){
				 if ($(".null_result").length < 1) {
	                    $('<div class="null_result"><div class="cont"><h2>抱歉，没有找到相关结果</h2></div></div>').insertBefore(".ul_list");
	                }
	                return;
			 }else{
			 $.each(data.data,function(i,dom){
	             str += '<li>';
	             str += '  <div class="img">';
	             var imgUrl = dom.roomPicUrl;
	             var trueImgUrl;
	             var index=imgUrl.lastIndexOf("http:");
	             if(index>-1){
	             	trueImgUrl = imgUrl;
	             }
	             else
	             	trueImgUrl = getIndexImgUrl(getImgUrl(imgUrl), "_300_300");

	             str += '    <a target="_blank" href="../frontRoom/roomDetail.do?roomId=' + dom.roomId + '"><img src="' + trueImgUrl + '" width="280" height="185" /></a>';
	             str += '  </div>';
	             str += '  <div class="intro">';
	             str += '   <h3><a target="_blank" href="../frontRoom/roomDetail.do?roomId=' + dom.roomId + '">' + dom.roomName + '</a></h3>';
	             str += '   <p>面积：'+dom.roomArea+'㎡<p>';
	             str += '   <p>容纳人数：'+dom.roomCapacity+'人<p>';
	             str += '  </div>';
	             str += '</li>';
			 });
			   $(".ul_list>ul").append(str);
			 }
		 }
	 },"json");
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
    			roomList(venueId,index, 20);
    		},200);
     }
 });
</script>
</html>
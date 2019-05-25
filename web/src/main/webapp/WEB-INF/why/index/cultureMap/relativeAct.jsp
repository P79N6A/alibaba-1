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
        <h2 style="font-size: 18px;color: #333;font-weight: normal;background-color: #fafafa;padding: 15px 20px;border-radius: 4px;margin: 20px auto 10px auto">${venueName}</h2>
        <div class="ul_list" id="activityListDivChild" style="min-height: 600px;">
            <ul class="hl_list clearfix" id="activityList">
            </ul>
        </div>
    </div>
		<%@include file="/WEB-INF/why/index/footer.jsp" %>
</body>
<script type="text/javascript">
var startIndex = 0;		//页数
var venueId='${venueId}';
 $(function(){
	 activityList(venueId,0,20);
	 $("#cultureMapIndex").addClass('cur').siblings().removeClass('cur');
 });
 
 function activityList(venueId,index, pagesize){
	  var data={
      		venueId:venueId,
      		pageIndex:index,
  			pageNum:pagesize
      }
	 $.post("${path}/wechatVenue/venueWcMapActivity.do",data,function(data){
		 var str = '';
		 if(data.status==0){
			 if(data.data.length==0&&index==0){
				 if ($(".null_result").length < 1) {
	                    $('<div class="null_result"><div class="cont"><h2>抱歉，没有找到相关结果</h2></div></div>').insertBefore(".ul_list");
	                }
	                return;
			 }else{
				 $(".null_result").remove();
			 $.each(data.data,function(i,dom){
	             str += '<li>';
	             str += '  <div class="img">';
	             var imgUrl = dom.activityIconUrl;
	             var trueImgUrl;
	             var index=imgUrl.lastIndexOf("http:");
	             if(index>-1){
	             	trueImgUrl = imgUrl;
	             }
	             else
	             	trueImgUrl = getIndexImgUrl(getImgUrl(imgUrl), "_300_300");
	             
	             var activityTime = dom.activityStartTime;
	             //判断是否过期
	             var maxDateTime = "";
	             if (dom.activityEndTime != undefined && dom.activityEndTime != '') {
	                 var maxDate = dom.activityEndTime.substr(0, 16);
	                 maxDateTime = new Date(maxDate.replace(/-/g, "/"));
	             }
	             var nowDateTime = new Date();
	             //是否收藏
	             var collectNum = dom.collectNum;
	             var availableCount = dom.activityAbleCount;
	             if (dom.activityEndTime != undefined &&dom.activityEndTime != '') {
	                 activityTime += "至" + dom.activityEndTime;
	             }
	             var activitySite = dom.activitySite;
	             if (activitySite == undefined || activitySite == '') {
	                 activitySite = dom.activityAddress;
	             }
	             if(activitySite!=undefined&&activitySite!=''){
		             if(activitySite.length>36){
		                 activitySite=activitySite.substr(0,36);
		                 activitySite+="...";
		             }
	             }
	             if (dom.sysNo != undefined && dom.sysNo != '' && dom.sysId != undefined && dom.sysId != '') {
	                 str += '<input name="sysId" type="hidden" value="' + dom.sysId + '" />';
	             }


	             str += '    <a target="_blank" href="../frontActivity/frontActivityDetail.do?activityId=' + dom.activityId + '"><img src="' + trueImgUrl + '" width="280" height="185" /></a>';
	             str += '  </div>';
	             str += '  <div class="intro">';
	             str += '    <h3><a target="_blank" href="../frontActivity/frontActivityDetail.do?activityId=' + dom.activityId + '">' + dom.activityName + '</a></h3>';
	             str += '    <p>时间：' + activityTime + '</p>';
	             str += '    <p>地点：' + activitySite + '</p>';
	             str += '  </div>';
	             str += '  <div class="do">';
	             if (collectNum > 0) {
	                 str += '     <div class="collect"><a class="collected"></a><span>收藏</span></div>';
	             } else {
	                 str += '    <div class="collect"><a></a><span>收藏</span></div>';
	             }
	             if (dom.activityIsReservation == 2) {

	                 if (nowDateTime - maxDateTime < 0) {
	                     if (availableCount > 0) {
	                         str += '    <div class="ticket"><em id="' + dom.sysId + '">' + availableCount + '</em><span>余票</span></div>';
	                         str += ' <a target="_blank" dataId=' + dom.activityId + ' id="bookType' + dom.sysId + '" href="../frontActivity/frontActivityDetail.do?activityId=' + dom.activityId + '" class="reserve">预 订</a>';
	                     } else {
	                         str += '    <div class="ticket"><em id="' + data[k].sysId + '">' + 0 + '</em><span>余票</span></div>';
	                         str += ' <a dataId=' + dom.activityId + ' class="reserve gray" id="bookType' + dom.sysId + '">已 订 完</a>';
	                     }
	                 } else {
	                     str += '    <div class="ticket"><em id="' + dom.sysId + '">' + 0 + '</em><span>余票</span></div>';
	                     str += ' <a  dataId=' + dom.activityId + ' class="reserve gray" id="bookType' + dom.sysId + '">已 结 束</a>';
	                 }

	             }else{
	                 if (nowDateTime - maxDateTime < 0) {
	                     str += ' <a href="../frontActivity/frontActivityDetail.do?activityId=' + dom.activityId + '"  dataId=' + dom.activityId + ' class="traffic" id="bookType' + dom.sysId + '">直 接 前 往</a>';

	                 } else {
	                     str += ' <a href="../frontActivity/frontActivityDetail.do?activityId=' + dom.activityId + '"  dataId=' + dom.activityId + ' class="traffic gray" id="bookType' + dom.sysId + '">已 结 束</a>';
	                 }
	             }
	             str += '  </div>';
	             str += '</li>';
			 });
			   $(".ul_list>ul").append(str);
			 }
		 }
	 },"json")
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
    			activityList(venueId,index, 20);
    		},200);
     }
 });
</script>
</html>
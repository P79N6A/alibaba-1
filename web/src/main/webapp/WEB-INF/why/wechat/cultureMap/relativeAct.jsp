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
	toLoadActList(venueId,0,20);
})

function toLoadActList(venueId,index,pagesize){
	var data={
      		venueId:venueId,
      		pageIndex:index,
  			pageNum:pagesize
      }
	$.post("${path}/wechatVenue/venueWcMapActivity.do",data,function(data){
   			if(data.data.length==0&&index==0){
   				$("#loadingDiv").html("<span class='noLoadingSpan'>没有找到合适的结果，换个试试看吧~</span>");
   			}else{
   				$("#loadingDiv").html("");
   			}
		
		var activityIds = [];
		$.each(data.data, function (i, dom) {
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
		});
	
	},"json");
}
//跳转到活动详情
function showActivity(activityId) {
    window.location.href = "${path}/wechatActivity/preActivityDetail.do?activityId="+activityId;
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
   			toLoadActList(venueId,index, 20);
   		},200);
    }
});
</script>
</html>
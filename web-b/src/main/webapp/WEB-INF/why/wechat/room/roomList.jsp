<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta charset="utf-8"/>
<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
<!-- <title>相关活动室</title> -->
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>

<script type="text/javascript">
	var venueId='${venueId}';
	var startIndex = 0;		//页数
	
	$(function(){
		loadData(0,20);
	});
	
	//相关活动室列表
	function loadData(index,pagesize){
		var data = {
				venueId:venueId,
				pageIndex:index,
				pageNum:pagesize
			};
		$.post("${path}/wechatVenue/activityWcRoom.do",data, function(data) {
			if (data.status == 0) {
				if(data.data.length<20){
	        		$("#loadingDiv").html("");
        		}
                $.each(data.data, function (i, dom) {
                    var roomPicUrl = getIndexImgUrl(dom.roomPicUrl, "_300_300");
                    var roomOrder = "";
                    if (dom.roomIsReserve > 0) {
                        roomOrder = "<div class='venue-detail-button' onclick='showRoom(\"" + dom.roomId + "\")'>" +
										"<button type='button'>预订</button>" +
									"</div>";
                    }
                    var price = '';
                    if(dom.roomIsFree==2){
    					price = "收费";
    				}else{
    					price = "免费";
    				}
                    $("#venueRoom").append("<li>" +
												"<div class='live-1'>" +
													"<div class='live-left' onclick='showRoom(\"" + dom.roomId + "\");'>" +
														"<img src='" + roomPicUrl + "' width='230' height='150'/>" +
													"</div>" +
													"<div style='margin-left: 10px;' class='live-left' onclick='showRoom(\"" + dom.roomId + "\");'>" +
														"<p class='p1'>" + dom.roomName + "</p>" +
														"<p class='p2'>面积"+dom.roomArea+"平米&nbsp;容纳"+dom.roomCapacity+"人</p>" +
														"<p class='p2'>"+price+"</p>" +
													"</div>" +
													roomOrder +
													"<div style='clear: both;'></div>" +
												"</div>" +
											"</li>");
                });
            }
		},"json");
	};
	
	function showRoom(roomId){
    	window.location.href="${path}/wechatRoom/preRoomDetail.do?roomId="+roomId;
    }
	
	//滑屏分页
    $(window).on("scroll", function () {
        var scrollTop = $(document).scrollTop();
        var pageHeight = $(document).height();
        var winHeight = $(window).height();
        if (scrollTop >= (pageHeight - winHeight - 100)) {
       		startIndex += 20;
       		setTimeout(function () { 
					loadData(startIndex, 20);
       		},1000);
        }
    });
	
	var userId = '${sessionScope.terminalUser.userId}';
	var userType = '${sessionScope.terminalUser.userType}';
	
	function roomBook(roomId){
		if (userId ==null || userId == '') {
			window.location.href = "${path}/muser/login.do?type=${path}/wechatRoom/preRoomList.do?venueId=" + venueId;
			return;
		}
		
		window.location.href="${path}/wechatVenue/roomBook.do?roomId="+roomId;
		
	}
</script>

<style>
	html,body,.main{height:100%}
	.content {padding-top: 100px;padding-bottom: 18px;}
</style>
</head>

<body>
	<c:if test="${not empty sessionScope.terminalUser}">
		<input type="hidden" id="teamUserSize" value="${fn:length(teamUserList)}"/>
	</c:if>
	<div class="header">
		<div class="index-top">
			<span class="index-top-5">
				<img src="${path}/STATIC/wechat/image/arrow1.png" onclick="history.go(-1);"/>
			</span>
			<span class="index-top-2">相关活动室</span>
		</div>
	</div>
	<div class="content">
		<div class="live">
			<ul id="venueRoom"></ul>
		</div>
		<div id="loadingDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>
	</div>
</body>
</html>
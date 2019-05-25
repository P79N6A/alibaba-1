<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>视频列表</title>
<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wx/css/reset-mc.css" />
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wx/css/mc-mobile.css" />
<script type="text/javascript" src="${path}/STATIC/wx/js/mc-mobile.js"></script>

<script type="text/javascript">
	var activityId = '${activityId}';
	var userId = '${sessionScope.terminalUser.userId}';
	$(function(){
		$.post("${path}/wechatActivity/activityWcDetail.do",{activityId:activityId,userId:userId}, function(data) {
			if(data.status==0){
				//视频
		        var video = data.data2;
		        $("#videoTitle").html(video[0].videoTitle);
	        	$("#btn-play").attr("poster",video[0].videoImgUrl);
	        	$("#btn-play").attr("src",video[0].videoLink);
	        	$("#videoTotal").html(video.length);
	        	$.each(video,function(i,dom){
	        		var videoTitle = dom.videoTitle.length>31?dom.videoTitle.substring(0,30)+"...":dom.videoTitle;
	        		$("#videoList").append("<li videoTitle="+dom.videoTitle+" videoImgUrl="+dom.videoImgUrl+" videoLink="+dom.videoLink+">" +
					        		           "<div class='video_img fl'>" +
					        		             "<a><img src="+dom.videoImgUrl+" width='200' height='135'></a>" +
					        		           "</div>" +
					        		           "<div class='video_txt fr'>" +
					        		             "<p>"+videoTitle+"</p>" +
					        		             "<a>"+dom.videoCreateTime+"</a>" +
					        		           "</div>" +
					        		       "</li>");
	        	});
	        	
	        	$("#videoList li").click(function(){
	        		$("#videoTitle").html($(this).attr("videoTitle"));
		        	$("#btn-play").attr("poster",$(this).attr("videoImgUrl"));
		        	$("#btn-play").attr("src",$(this).attr("videoLink"));
	        	});
			}
		},"json");
	});

</script>

</head>
<body>
	<div id="M_video_more">
	  <div class="M_video">
	   <h3 id="videoTitle"></h3>
	   <div class="M-on-video-block">
	        <video id="btn-play" poster="" src="" style="width:750px; height:500px;" controls></video>
	    </div>
	    <div class="M_video_list">
			<div class="video_tit clearfix">
				<span>选集</span>
				<a>共 <total id="videoTotal"></total> 个视频</a>
	       </div>
	       <ul class="clearfix" id="videoList"></ul>
		</div>
	  </div>
	</div>
</body>
</html>
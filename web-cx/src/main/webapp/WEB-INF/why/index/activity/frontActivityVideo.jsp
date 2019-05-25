<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>视频点播--文化云</title>
  <!-- 导入头部文件 start -->
  <%@include file="/WEB-INF/why/common/frontPageFrame.jsp"%>
  <script type="text/javascript" src="${path}/STATIC/js/jquery.mCustomScrollbar.concat.min.js"></script>
  <script type="text/javascript" >

    $(function () {
  	  //默认选中当前label
      $('#activityLabel').addClass('cur').siblings().removeClass('cur');
    	
  	  //搜索设置默认值
      $("#searchSltVal").val("活动");
      $("#searchSltSpan").html("活动");
      
      //图片载入
      $(".video-list li").each(function (index, item) {
          var imgUrl = $(this).attr("activity-icon-url");
          if(imgUrl==undefined||imgUrl==""){
          	$(item).find("img").attr("src", "../STATIC/image/default.jpg");
          }else{
          	imgUrl=getIndexImgUrl(getImgUrl(imgUrl),"_300_300");
            	$(item).find("img").attr("src", imgUrl);
          }
       });
      
      //加载滚动条
      if($("#video-right").length > 0){
          $.mCustomScrollbar.defaults.scrollButtons.enable = true;
          $.mCustomScrollbar.defaults.axis = "yx";
          $("#video-right").mCustomScrollbar();
      }
    });
  </script>
  
 
</head>
<body>
	<!-- 导入头部文件 -->
	<%@include file="../index_top.jsp"%>
	
	<div class="crumb"><i></i>您所在的位置：<a href="${path}/frontActivity/frontActivityList.do" >活动</a> &gt; <a href="${path}/frontActivity/frontActivityDetail.do?activityId=${cmsActivity.activityId}" ><c:out escapeXml="true" value="${cmsActivity.activityName}"/></a> &gt; 视频点播</div>
		
	<div class="detail-content detail-video">
      <div class="detail-left fl">
         <div class="the_one">
         <div class="a_note">
            <div class="title">
               <h2>${CmsVideo.videoTitle}</h2>
            </div>
            <div class="ad_intro">
                <div class="player" id="player">
                    <embed src="${CmsVideo.videoLink}" quality="high" width="800" height="600" align="middle" allowScriptAccess="sameDomain" allowFullscreen="true"></embed>
                </div>
            </div>
         </div>
         </div>
      </div>
      <div class="detail_right fr">
        <div class="recommend video mb20">
            <div class="tit"><i></i>相关视频</div>
            <div id="video-right">
	            <ul class="video-list">
	            	<c:forEach items="${cmsVideoList}" var="video">
			       	   <li activity-icon-url="${video.videoImgUrl}" onclick="showVideo('${video.videoId}','${cmsActivity.activityId}');">
			               <a class="img"><img src="" width="136" height="100"/><span></span></a>
			               <div class="info">
			                 <h3><a><c:out value="${video.videoTitle}" escapeXml="true"/></a></h3>
			               </div>
			           </li>
		       	    </c:forEach>
		       	    <script>
		       	   		function showVideo(videoId,activityId){
		       	   			window.location.href="${path}/frontActivity/frontActivityVideo.do?videoId="+videoId+"&activityId="+activityId;
		       	   		}
		       	    </script>
	            </ul>
	         </div>
        </div>
      </div>
    </div>
	
	<!-- 导入尾部文件 -->
	<%@include file="../index_foot.jsp"%>
</body>
</html>
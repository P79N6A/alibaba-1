<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>文化联盟</title>
  <!-- 导入头部文件 start -->
  <%@include file="/WEB-INF/why/common/frontIndexPageFrame.jsp"%>
  	<link type="text/css" rel="stylesheet" href="${path}/STATIC/css/normalize.css" />
	<link type="text/css" rel="stylesheet" href="${path}/STATIC/css/styleChild.css" />
</head>
<body>
     <div class="header">
		<%@include file="../header.jsp" %>
	</div>

	 <!-- start banner -->
	 <div class="unionBanner jzCenter clearfix">
		 <div class="unionScroll picScroll-top">
			 <div class="bd">
				 <ul class="picList">
				 </ul>
			 </div>
			 <div class="hd">
				 <a class="prev"></a>
				 <a class="next"></a>
			 </div>
		 </div>
		 <div class="unionBigPic">
			 <a target='_blank'>

			 </a>
		 </div>
	 </div>
	 <!-- end banner -->

	 <div class="jzCenter clearfix" style="padding-bottom: 80px;">
		 <div class="unionNews">
			 <div class="tit">最新活动</div>
			 <ul class="unionNewsList clearfix">
				 <c:forEach items="${list}" var="obj">
					 <li class="clearfix">
						 <a class="char" href="${path}/frontActivity/frontActivityDetail.do?activityId=${obj.activityId}">${obj.activityName}</a>
						 <div class="time"><fmt:formatDate value="${obj.activityCreateTime}" pattern="yyyy-MM-dd HH:mm"/></div>
					 </li>
				 </c:forEach>
			 </ul>
		 </div>
		 <div class="unionXiang clearfix">
			 <div style="cursor: pointer" class="uxItem" onclick="location.href='${path}/league/leagueForType.do?type=f8c643716b6c4cc397eedbae7318c425&typeName=文化中枢'">
				 <div class="pic"><img src="${path}/STATIC/image/child/union1.png"></div>
				 <a href="${path}/league/leagueForType.do?type=f8c643716b6c4cc397eedbae7318c425&typeName=文化中枢">查看详情</a>
			 </div>
			 <div  style="cursor: pointer" class="uxItem" onclick="location.href='${path}/league/leagueForType.do?type=c451ac6b931d495387d0307a7bf1e4a4&typeName=设施联盟'">
				 <div class="pic"><img src="${path}/STATIC/image/child/union2.png"></div>
				 <a href="${path}/league/leagueForType.do?type=c451ac6b931d495387d0307a7bf1e4a4&typeName=设施联盟">查看详情</a>
			 </div>
		 </div>
	 </div>
	 <%@include file="/WEB-INF/why/index/footer.jsp" %>
</body>
<script type="text/javascript">
$(function(){
     showAdvertPicture();
	 $("#leagueIndex").addClass('cur').siblings().removeClass('cur');
 });

// 显示轮播图
function showAdvertPicture() {
    $.post("${path}/beipiaoInfo/bpCarouselList.do?carouselType=2&version=" + new Date().getTime(), '', function (data) {
        if (data != undefined && data != null && data != "" && data.length > 0) {
            getAdvertHtml(data);
            /* start banner */
            jQuery(".unionScroll").slide({
                mainCell:".bd ul",
                autoPage:true,
                effect: "top",
                autoPlay: false,
                interTime: 3000,
                delayTime: 500,
                vis: 4,
                trigger: "click",
                pnLoop: false
            });
            $('.unionScroll .picList').on('click', 'li', function () {
                $(this).addClass('on').siblings().removeClass('on');
                $('.unionBigPic .img').attr('src', $(this).find('img').attr('src'));
                $('.unionBigPic a').attr("href", $(this).find('img').attr('data-uri'));
            });
            /* end banner */
        }
    });
}

// 拼接轮播图
function getAdvertHtml(data) {
    var imgUrl = "";
    var connectUrl = "";
    var li = "";
    var span = "";
	if(data.length>=0){
        for (var i in data) {
            imgUrl = data[i].carouselImage;
            connectUrl = data[i].carouselUrl.split(',')[0];
            if(i==0){
                $('.unionBigPic a').attr("href",connectUrl);
                $(".unionBigPic a").html('<img  data-uri="'+connectUrl+'" class="img" src="'+data[0].carouselImage+'">');
                li += "<li class='on'><div class=\"pic\"><img data-uri=\""+connectUrl+"\" src='" + imgUrl + "'/></div></li>";
			}else{
                li += "<li><div class=\"pic\"><img data-uri=\""+connectUrl+"\"  src='" + imgUrl + "'/></div></li>";
			}
        }
	}
    $(".picList").html(li);
}
 </script>
</html>
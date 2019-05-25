<%@ page import="org.apache.commons.lang3.StringUtils,com.sun3d.why.model.CmsTerminalUser" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>${cmsVenue.venueName}_${cmsVenue.venueAddress}_活动_免费场地-文化云</title>
    <meta name="description"
          content="${cmsVenue.venueAddress}/<c:forEach items="${typeList}" var="c">${c.tagName}/</c:forEach>${cmsVenue.venueMobile}
文化云为您提供${cmsVenue.venueName}活动在线预订，购票，免费预约场地等服务">
    <meta name="Keywords" content="${cmsVenue.venueName}、地址、开馆时间、网上预订、免费预订、免费场地、公交、地图、舞蹈室、培训、投影仪">
    <%@include file="/WEB-INF/why/common/frontIndexPageFrame.jsp" %>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/hsCulture.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/index/venue/venueDetailFront.js?version=20150101201"></script>
    <script type="text/javascript" src="${path}/STATIC/js/jquery.uploadify-3.1.min.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/audio.min.js"></script>
    <script type="text/javascript">

        function starts(obj, n) {
            var $obj = $(obj);
            $obj.each(function (index, element) {
                var num = parseFloat($(this).attr("tip"));
                var width = num * n;
                $(this).children("p").css("width", width);
            });
        }
        
      //点赞（我想去）
        function addWantGo() {
        	if ('${sessionScope.terminalUser}' == null || '${sessionScope.terminalUser}' == "") {
                dialogAlert("提示", "登录之后才能点赞");
                return;
            }
        	var venueId = $("#venueId").val();
        	var userId = "${sessionScope.terminalUser.userId}";
            $.post("${path}/wechatVenue/wcAddVenueUserWantgo.do", {
            	venueId: venueId,
                userId: userId
            }, function (data) {
                if (data.status == 0) {
                    wantGo();
                    $("#zanId").addClass("love");
                } else if (data.status == 14111) {
                    $.post("${path}/wechatVenue/wcDeleteVenueUserWantgo.do", {
                    	venueId: venueId,
                        userId: userId
                    }, function (data) {
                        if (data.status == 0) {
                            wantGo();
                            $("#zanId").removeClass("love");
                        }
                    }, "json");
                }
            }, "json");
        }

        	//我想去列表
        function wantGo() {
        	var venueId = $("#venueId").val();
            var data = {
            	venueId: venueId,
                pageIndex: 0,
                pageNum: 10
            };
            $.post("${path}/wechatVenue/wcVenueUserWantgoList.do", data, function (data) {
                if (data.status == 1) {
                	var userId = "${sessionScope.terminalUser.userId}";
                	if(userId != ""){
                		$.each(data.data, function (i, dom) {
                            if (dom.userId == userId) {
                            	$("#zanId").addClass("love");
                            }
                        });
                	}
                	
                  	$("#zanId").html(data.pageTotal);
                }
            }, "json")
        }

        $(function () {
            $(".play-btn").click(function () {
                var $triangle = $(this).siblings("b");
                var $audio = $("#audio-box");
                if ($audio.is(":visible")) {
                    $triangle.hide();
                    $audio.hide();
                } else {
                    $triangle.show();
                    $audio.show();
                }
            });
			
            $("#searchSltVal").val("场馆");
            $("#searchSltSpan").html("场馆");
            
            wantGo();
        });
    </script>
    <style type="text/css">
        #file {
            position: relative;
        }
        .metroLine {
        height:auto!important;
        		overflow: visible!important;
				background: url("../STATIC/image/hd_icon5.png") no-repeat 2px 1px;
			}
			
			.busLine {
			height:auto!important;
				overflow: visible!important;
				background: url("../STATIC/image/hd_icon6.png") no-repeat 3px 1px;
			}
			
			.deviceList {
				padding: 15px 20px 5px;
				background-color: #f2f2f2;
				margin-top: 50px;
				border-radius: 5px;
			}
			
			.deviceList .deviceListTittle {
				padding-left: 10px;
				padding-bottom: 10px;
				border-bottom: 2px solid #fff;
				font-size: 12px;
				color: #4a4a4a;
			}
			
			.deviceList .deviceListTab {
				padding-top: 15px;
				padding-left: 10px;
			}
			
			.deviceList .deviceListTab ul li{
				margin-bottom: 10px;
				width: 60px;
				margin-right: 9px;
				float: left;
			}
			
			.deviceList .deviceListTab ul li:nth-last-child(2){
				margin: 0;
			}
			
			.deviceList .deviceListTab ul li img{
				display: block;
				margin: auto;
			}
			
			.deviceList .deviceListTab ul li p{
				margin-top: 5px;
				text-align: center;
			}
			
			.deviceList .deviceListTab p {
				font-size: 12px;
				color: #909090;
			}
    </style>
</head>
<body>
<!-- 导入头部文件 -->
<div class="header">
	<%@include file="../header.jsp" %>
</div>

<%
    String userMobileNo = "";
    if (session.getAttribute("terminalUser") != null) {
        CmsTerminalUser terminalUser = (CmsTerminalUser) session.getAttribute("terminalUser");
        if (StringUtils.isNotBlank(terminalUser.getUserMobileNo())) {
            userMobileNo = terminalUser.getUserMobileNo();
        } else {
            userMobileNo = "0000000";
        }
    }
%>
<input type="hidden" id="userMobileNo" value="<%=userMobileNo%>"/>
<form action="${path}/frontVenue/venueDetail.do" id="venueDetailForm" method="get" target="_blank">
    <input type="hidden" id="detailVenueId" name="venueId" value="${cmsVenue.venueId}"/>
</form>
<input type="hidden" id="venueId" name="venueId" value="${cmsVenue.venueId}"/>
<!--活动详情 start-->
<!--tit start-->
<div class="crumb">您所在的位置：<a href="${path}/frontVenue/venueList.do">场馆</a> &gt; <c:out escapeXml="true"
                                                                                       value="${cmsVenue.venueName}"/>
</div>
<!--tit end-->
<!--con start-->
<div class="detail-content">
    <!--left start-->
    <div class="detail-left fl">
        <!--the_one start-->
        <div class="the_one">
            <!--time start-->
            <div class="a_time">
                收藏： <span id="likeCount">0</span>&nbsp;&nbsp;/&nbsp;
                浏览：
				<%--<span>
					<c:if test="${statistics.yearBrowseCount != null}">
                        ${statistics.yearBrowseCount}
                    </c:if>
					<c:if test="${statistics.yearBrowseCount == null}">
                        0
                    </c:if>
				</span>--%>
            </div>
            <!--time end-->
            <div class="a_note">
                <!--time start-->
                <div class="title">
                    <h2 class="fl"><c:out escapeXml="true" value="${cmsVenue.venueName}"/></h2>
                    <div class="w_star fl" id="${c.venueId}">
                        <div class="start fl" tip="${cmsVenue.venueStars}">
                            <p></p>
                        </div>
                        <span class="txt fl">${cmsVenue.venueStars}分</span>
                    </div>
                </div>
                <!--time end-->
                <div class="tag">
                    <c:forEach items="${typeList}" var="c">
                        <a href="javascript:;">${c.tagName}</a>
                    </c:forEach>
                    <c:if test="${not empty location}">
                        <a href="javascript:;">${location.dictName}</a>
                    </c:if>
                </div>
                <div class="address v_address">
                    <div class="vl_img fl">
                        <img id="venueIcon" alt="文化云_${cmsVenue.venueName}" data-id="${cmsVenue.venueIconUrl}" width="400" height="264"/>
                    </div>
                    <div class="al_r fl">
                        <!--do start-->
                        <c:if test="${not empty cmsVenue.venuePanorama || not empty cmsVenue.venueVoiceUrl || not empty cmsVenue.venueRoamUrl}">
                            <div class="commentary">
                                <ul>
                                    <c:if test="${not empty cmsVenue.venuePanorama}">
                                        <li class="fl">
                                            <a onclick="showPanorama('${cmsVenue.venuePanorama}');" id="map_display">
                                                <img src="${path}/STATIC/image/v_icon1.png" width="52" height="50"/>
                                            </a>
                                            <span>360全景</span>
                                        </li>
                                    </c:if>
                                    <c:if test="${not empty cmsVenue.venueVoiceUrl}">
                                        <li class="voice fl">
                                            <input type="hidden" id="venueVoiceUrl" value="${cmsVenue.venueVoiceUrl}">
                                            <a class="play-btn"><img src="${path}/STATIC/image/v_icon2.png" width="52"
                                                                     height="50"/></a><span>语音解说</span><b></b>
                                        </li>
                                    </c:if>
                                    <c:if test="${not empty cmsVenue.venueRoamUrl}">
                                        <li class="fl m_r">
                                            <a href="${cmsVenue.venueRoamUrl}" target="_blank"><img
                                                    src="${path}/STATIC/image/v_icon3.png" width="52"
                                                    height="50"/></a><span>三维讲解</span>
                                        </li>
                                    </c:if>
                                </ul>
                                <c:if test="${not empty cmsVenue.venueVoiceUrl}">
                                    <div class="audio-box" id="audio-box">
                                        <audio preload="auto" id="audioPlay"></audio>
                                    </div>
                                </c:if>
                            </div>
                        </c:if>
                        <!--do end-->
                        <div class="list" style="width: auto;">
                            <p class="site">
                                <input type="hidden" id="venueCity" value="${cmsVenue.venueCity}">
                                <input type="hidden" id="venueArea" value="${cmsVenue.venueArea}">
                                <input type="hidden" id="venueAddress" value="${cmsVenue.venueAddress}">
                                <span id="areaSpan"></span>
                            </p>
                            <c:if test="${cmsVenue.venueOpenTime != null && cmsVenue.venueEndTime != null}">
                                <p class="time">
                                    <span>${venueTime} ${cmsVenue.venueOpenTime}-${cmsVenue.venueEndTime}</span>
                                </p>
                            </c:if>
                            <c:if test="${not empty cmsVenue.openNotice}">
                                <p style="height: auto;">注：<c:out escapeXml="true" value="${cmsVenue.openNotice}"/></p>
                            </c:if>
                            <p class="phone"><span>${cmsVenue.venueMobile}</span></p>
                            <p class="free">
								<span>
									<c:if test="${cmsVenue.venueIsFree == 1}">
                                        免费
                                    </c:if>
									<c:if test="${cmsVenue.venueIsFree == 2}">
                                        ${cmsVenue.venuePrice}
                                    </c:if>
								</span>
                            </p>
                            
                            <c:if test="${cmsVenue.venueHasMetro == 2 }">
                            <p class="metroLine">
										${cmsVenue.venueMetroText}
									</p>
                            </c:if>
                             <c:if test="${cmsVenue.venueHasBus == 2 }">
                             		<p class="busLine">
										${cmsVenue.venueBusText}
									</p>
                             </c:if>
                        </div>
                    </div>
                </div>
                <c:if test="${!empty venueFacilityList }">
                <div class="deviceList">
							<p class="deviceListTittle">提供设施：</p>
							<div class="deviceListTab">
								<ul>
									<c:forEach items="${ venueFacilityList}" var="venueFacility">
									
									<li>
										<img src="../STATIC/image/venue/${venueFacility.dictCode }.png" />
										<p class="dlTag">${venueFacility.dictName }</p>
									</li>
									</c:forEach>
									
									<div style="clear: both;"></div>
								</ul>
							</div>
						</div>
                </c:if>
                <!--detail_intro start-->
                <div class="ad_intro">
                    <p>
                        ${cmsVenue.venueMemo}
                    </p>
                </div>
                <div class="extra">
                    <c:if test="${not empty cmsVenue.venueLinkman}">
                        <p>
                            联系人：<c:out value="${cmsVenue.venueLinkman}" escapeXml="true"/>
                        </p>
                    </c:if>
                    <c:if test="${not empty cmsVenue.venueMail}">
                        <p>
                            联系邮箱：<c:out value="${cmsVenue.venueMail}" escapeXml="true"/>
                        </p>
                    </c:if>
                    <c:if test="${not empty cmsVenue.venueSites}">
                        <p>
                            场馆网址：<c:out value="${cmsVenue.venueSites}" escapeXml="true"/>
                        </p>
                    </c:if>
                </div>
                <!--detail_intro end-->
                <!--share start-->
                <div class="shares" style="border-bottom:none; padding-bottom: 0;">
                    <!--left start-->
                    <div class="share_l fr">
                        <span><a class="collect fl" id="collectId" onclick="changeClass()"></a></span>
                        <span><a class="zan fl" id="zanId" onclick="addWantGo()"></a></span>
						 <span class="bdsharebuttonbox fl">

			                 <a href="#" class="bds_qzone" style="padding-left:20px;" data-cmd="qzone"></a>
                             <a href="#" class="bds_tsina" style="padding-left:20px;" data-cmd="tsina"></a>
                             <a href="#" class="bds_weixin" style="padding-left:20px;" data-cmd="weixin"></a>
						 </span>
                        <!--分享代码 start-->
                        <%--<script type="text/javascript">

                            /*with (document)0[(getElementsByTagName('head')[0] || body).appendChild(createElement('script')).src = 'http://bdimg.share.baidu.com/static/api/js/share.js?v=89860593.js?cdnversion=' + ~(-new Date() / 36e5)];*/
                            with(document)0[(getElementsByTagName('head')[0]||body).appendChild(createElement('script')).src='http://bdimg.share.baidu.com/static/api/js/share.js?v=89860593.js?cdnversion='+~(-new Date()/36e5)];
                        </script>--%>
                        <!--分享代码 end-->
                    </div>
                    <!--left end-->
                </div>
                <!--share end-->
            </div>
        </div>
        <!--the_one end-->
        <!--the_two start-->
        <div class="the_two">
            <!--评论start-->
            <input type="hidden" value="${pageContext.session.id}" id="sessionId"/>
            <div class="comment mt20 clearfix">
                <a name="comment"></a>
                <div class="comment-tit">
                    <h3>我要评论</h3>
                </div>
                <form id="commentForm">

                    <div class="score-box">
                        <span class="txt">场馆评分</span>
                        <div class="star-list">
                            <div class="star-score" id="star-score">
                                <a class="star1">1</a>
                                <a class="star2">2</a>
                                <a class="star3">3</a>
                                <a class="star4">4</a>
                                <a class="star5">5</a>
                            </div>
                            <span><em id="score-num">0</em>分</span>
                            <input type="hidden" name="commentStar" id="activityScore" value="0"/>
                        </div>
                    </div>


                    <input type="hidden" id="tmpVenueId" name="venueId" value="${cmsVenue.venueId}"/>
                    <textarea class="text" name="commentRemark" id="commentRemark" maxLength="200"></textarea>
                    <div class="tips">
                        <!--update start-->
                        <div class="wimg fl">
                            <input type="hidden" name="commentImgUrl" id="headImgUrl" value="">
                            <input type="hidden" name="uploadType" value="Img" id="uploadType"/>
                            <div id="imgHeadPrev" style="position: relative; overflow: hidden;  float: left;">
                            </div>

                            <div style="float: left;margin-top: 0px;">
                                <div>
                                    <input type="file" name="file" id="file"/>
                                </div>
                                <div class="comment_message" style="display: none">(最多三张图片)</div>
                                <div id="fileContainer" style="display: none;"></div>
                                <div id="btnContainer" style="display: none;"></div>
                            </div>
                        </div>
                        <!--upadate end-->
                        <div class="fr r_p">
                            <p>文明上网理性发言，请遵守新闻评论服务协议</p>
                            <input type="button" class="btn_red" value="发表评论" onclick="addComment()">
                        </div>
                        <!--update end-->
                    </div>
                </form>
                <div class="comment-list" id="comment-list-div">
                    <ul id="lrk_listpl">

                    </ul>

                    <c:if test="${commentCount >= 5}">
                        <a class="load-more" onclick="loadMoreComment()" id="viewMore">查看更多...</a>
                        <input type="hidden" id="commentPageNum" value="1"/>
                    </c:if>
                </div>
            </div>
            <!--评论end-->
        </div>
        <!--the_two end-->
    </div>
    <!--left end-->
    <!--right start-->
    <div class="detail_right fr">
        <!--map start-->
        <div class="map mb20">
            <div id="map-site" class="amap-container">
                <div class="amap-maps">
                    <div class="amap-drags">
                        <div class="amap-layers" style="-webkit-transform: translateZ(0px);">
                            <div style="position: absolute; z-index: 0; top: 107.5px; left: 160px;">
                                <canvas height="256" width="256"
                                        style="position: absolute; top: -16px; left: 1px; width: 256px; height: 256px; z-index: 18;"></canvas>
                                <canvas height="256" width="256"
                                        style="position: absolute; top: -272px; left: 1px; width: 256px; height: 256px; z-index: 18;"></canvas>
                                <canvas height="256" width="256"
                                        style="position: absolute; top: -16px; left: -255px; width: 256px; height: 256px; z-index: 18;"></canvas>
                                <canvas height="256" width="256"
                                        style="position: absolute; top: -272px; left: -255px; width: 256px; height: 256px; z-index: 18;"></canvas>
                            </div>
                            <canvas width="320" height="215"
                                    style="position: absolute; z-index: 1; height: 215px; width: 320px; top: 0px; left: 0px;"></canvas>
                            <div style="position: absolute; z-index: 120; top: 107.5px; left: 160px;">
                                <div class="amap-marker"
                                     style="top: -31px; left: -9px; z-index: 100; -webkit-transform: translate(9px, 31px) rotate(0deg) translate(-9px, -31px); display: block;">
                                    <div class="amap-icon"
                                         style="position: absolute; width: 19px; height: 33px; opacity: 1;"><img
                                            src="http://webapi.amap.com/theme/v1.3/markers/n/mark_bs.png"
                                            style="width: 19px; height: 33px; top: 0px; left: 0px;"></div>
                                </div>
                            </div>
                        </div>
                        <div class="amap-overlays"></div>
                    </div>
                </div>
                <div style="display: none;"></div>
                <div class="amap-controls"></div>
                <a class="amap-logo" href="http://gaode.com" target="_blank"><img
                        src="http://webapi.amap.com/theme/v1.3/autonavi.png"></a>
                <div class="amap-copyright"></div>
            </div>
            <!--<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=7bq0ISXbRLNBthNB3qzakG6g"></script>-->
            <script type="text/javascript"
                    src="http://webapi.amap.com/maps?v=1.3&amp;key=de421f9a41545db0c1c39cbb84f32163"></script>
            <script type="text/javascript">
                // 百度地图API功能
                var map, marker;
                //初始化地图对象，加载地图
                map = new AMap.Map("map-site", {
                    resizeEnable: true,
                    //二维地图显示视口
                    view: new AMap.View2D({
                        center: new AMap.LngLat(${cmsVenue.venueLon}, ${cmsVenue.venueLat}),//地图中心点
                        zoom: 15 //地图显示的缩放级别
                    })
                });
                //实例化点标记
                marker = new AMap.Marker({
                    position: map.getCenter()
                });
                marker.setMap(map);  //在地图上添加点
            </script>
        </div>
        <!--map end-->        
        <!--视频点播 start-->
        <div class="recommend video mb20" <c:if test="${fn:length(cmsVideoList)==0}">style="display:none;"</c:if>>
            <div class="tit"><i></i>视频点播</div>
            <ul class="video-list" id="videoList">
                <c:forEach items="${cmsVideoList}" var="video" varStatus="s">
                    <c:if test="${s.index<3}">
                        <li data-id="${video.videoImgUrl}"
                            onclick="showVideo('${video.videoId}','${cmsVenue.venueId}');">
                            <a class="img"><img src="" width="136" height="100"/><span></span></a>
                            <div class="info">
                                <h3><a><c:out value="${video.videoTitle}" escapeXml="true"/></a></h3>
                            </div>
                        </li>
                    </c:if>
                </c:forEach>
                <script>
                    $("#videoList li").each(function (index, item) {
                        var imgUrl = $(this).attr("data-id");
                        if (imgUrl == undefined || imgUrl == null || imgUrl == "") {
                            $(item).find("img").attr("src", "../STATIC/image/default.jpg");
                        } else {
                            imgUrl = getImgUrl(imgUrl);
                            imgUrl = getIndexImgUrl(imgUrl, "_300_300")
                            $(item).find("img").attr("src", imgUrl);
                        }
                    });

                    function showVideo(videoId, venueId) {
                        window.open("${path}/frontVenue/frontVenueVideo.do?videoId=" + videoId + "&venueId=" + venueId);
                    }
                </script>
            </ul>
            <c:if test="${fn:length(cmsVideoList)>3}">
                <a class="load-more" target="_blank"
                   onclick="showVideo('${cmsVideoList[0].videoId}','${cmsVenue.venueId}');">查看更多></a>
            </c:if>
        </div>
        <!--视频点播 end-->

        <!--馆藏 start-->
        <div class="recommend mb20 p_bottom" id="antique-list-div">
            <div class="tit fd_bg">推荐馆藏</div>
            <!--list start-->
            <ul class="recommend-collection">

            </ul>
            <a href="${path}/frontAntique/antiqueList.do?venueId=${cmsVenue.venueId}" class="load-more" target="_blank">查看更多></a>
            <form action="${path}/frontAntique/antiqueDetail.do" id="antiqueDetailForm" method="get" target="_blank">
                <input type="hidden" id="antiqueId" name="antiqueId"/>
            </form>

            <!--list end-->
        </div>
        <!--馆藏 end-->
        <!--推荐活动室 start-->
        <div class="recommend mb20 p_bottom" id="room-list-div">
            <div class="tit fd_bg">推荐活动室</div>
            <!--list start-->
            <ul class="ra_room">
            </ul>
            <a id="roomViewMore" onclick="loadMoreRoom()" style="display: none;" class="load-more"
               style="margin-top:15px;">查看更多></a>
            <input type="hidden" id="roomPageNum" value="1"/>
            <!--list end-->
        </div>

        <form action="${path}/frontRoom/roomDetail.do" id="roomDetailForm" method="get" target="_blank">
            <input type="hidden" id="roomId" name="roomId"/>

        </form>

        <form action="${path}/frontRoom/roomBook.do" id="roomBookForm" method="post" target="_blank">
            <input type="hidden" id="roomId2" name="roomId"/>
        </form>
        <!--推荐活动室 end-->
        <!-- 推荐活动 -->
        <div class="recommend mb20 p_bottom" id="activity-list-div">
            <div class="tit fd_bg">推荐活动</div>
            <ul class="ra_room">
            </ul>
            <a id="activityViewMore" onclick="loadMoreActivity()" style="display: none;" class="load-more"
               style="margin-top:15px;">查看更多></a>
            <input type="hidden" id="activityPageNum" value="1"/>
        </div>
        <form action="${path}/frontActivity/frontActivityDetail.do" id="activityDetailForm" method="get" target="_blank">
    		<input type="hidden" id="activityId" name="activityId" value=""/>
	</form>
        <!-- 推荐活动end -->
        <!--推荐场馆 start-->
        <div class="recommend mb20 p_bottom" id="venue-list-div">
            <div class="tit fd_bg">推荐场馆</div>
            <!--list start-->
            <ul class="ra_room">
            </ul>
            <!--list end-->
        </div>
        <!--推荐场馆 end-->
        <%--推荐馆藏 推荐活动室 推荐场馆--%>
        <%-- 只有登录之后的用户才可以预订 --%>
        <c:if test="${not empty sessionScope.terminalUser}">
            <input type="hidden" id="isLogin" value="1"/>
            <input type="hidden" id="accountStatus" value="${sessionScope.terminalUser.commentStatus}"/>
            <input type="hidden" id="teamUserSize" value="${fn:length(teamUserList)}"/>
            <input type="hidden" id="teamUserType" value="${sessionScope.terminalUser.userType}"/>
        </c:if>
    </div>
    <!--right end-->
</div>
<!--con end-->
<%@include file="/WEB-INF/why/index/footer.jsp" %>
<!--360全景图 start-->
<div id="panorama"></div>
<!--360全景图 end-->

<script type="text/javascript">
    /*星星个数*/
    $(function () {
        /*		function starts(obj,n){
         for(i=0;i<obj.length;i++){
         var num=parseFloat($(obj[i]).attr("tip"));
         var width=num*n;
         $(obj[i]).children("p").css("width",width);
         }
         }*/
        starts($(".start"), 28);
    });

    function setScore() {
        var num = 0, starW = 0, scoreNum = 0;
        $("#star-score a").each(function (index, element) {
            $(this).click(function () {
                $("#star-score a").removeClass("cur");
                $(this).addClass("cur");
                $(this).css({"width": starW, "left": "0"});
                $("#score-num").text(scoreNum);
                $("#activityScore").val(scoreNum);
            });
            $(this).hover(function () {
                scoreNum = $(this).text();
                num = parseInt(index) + 1;
                starW = 28 * num;
            });
        });
    }
    
    /*评论星级设置*/
    $(function () {
        setScore();
    })
</script>
<%-- <a style="visibility: hidden"><img alt="文化云" src="${path}/STATIC/image/baiduLogo.png" width="121" height="75"/></a> --%>
</body>
</html>
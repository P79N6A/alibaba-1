<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@ page import="com.sun3d.why.model.CmsTerminalUser" %>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <title>取票机--活动详情--文化云</title>
  <%@include file="/WEB-INF/why/common/ticketFrame.jsp"%>
  <style>
    .overDiv{
      display:none;
      position: fixed;
      left:0;
      top:0;
      width:100%;
      background:#000;
      z-index: 999;
      height:100%;
      opacity:0.7;
    }
.closeDiv{
  position: fixed;
  width:30px;
  background-color:#c0c0c0;
  top:0px;
  right:0px;
  cursor:pointer;
}
  </style>
  <script type="text/javascript" src="${path}/STATIC/js/placeholder.js"></script>
  <script type="text/javascript" src="${path}/STATIC/js/keyboard.js"></script>
  <script type="text/javascript" src="${path}/STATIC/js/ticket/activity/ticketActivityDetail.js"></script>
  <script type="text/javascript" src="${path}/STATIC/js/ticket/activity/ticketActivitySelectTopLabel.js"></script>
  <script type="text/javascript">
    $(function(){
      /**活动头像展开**/
      $(function(){
        var $parent = $(".head_list");
        var $toggleBtn = $('#show_btn');
        $parent.css({"height": "40px"});
        $toggleBtn.click(function(){
          var $this = $(this);
          $this.hide();
          $parent.css({"height": "auto"});
          /*if($this.hasClass("show")){
           $this.removeClass("show");
           $parent.css({"height": "40px"});
           }else{
           $this.addClass("show");
           $parent.css({"height": "auto"});
           }*/
          return false;
        });
      });
    });
  </script>
</head>
<%
  String userMobileNo = "";
  if(session.getAttribute("terminalUser") != null){
    CmsTerminalUser terminalUser = (CmsTerminalUser)session.getAttribute("terminalUser");
    if(StringUtils.isNotBlank(terminalUser.getUserMobileNo())){
      userMobileNo = terminalUser.getUserMobileNo();
    }else{
      userMobileNo = "0000000";
    }
  }
%>
<body style="background: #eef4f7;">

<!-- ticket_top start -->
<%@include file="/WEB-INF/why/ticket/ticket-nav.jsp"%>
<!-- ticket_top end -->

<c:if test="${not empty sessionScope.terminalUser}">
  <input type="hidden" id="isLogin" value="1"/>
</c:if>
<input type="hidden" id="wantGoFlag" value="1"/>
<input type="hidden" id="userMobileNo" value="<%=userMobileNo%>"/>
<input type="hidden" id="page" name="page" value="1"/>
<input type="hidden" id="activityId" name="activityId" value="${cmsActivity.activityId}"/>
<input type="hidden" id="userId" name="userId" value="${sessionScope.terminalUser.userId}"/>
<!--con start-->
<div class="detail-content ticket-activity-detail"  id="allInfo">
  <!--left start-->
  <div class="detail-left fl">
    <!--the_one start-->
    <div class="the_one">
      <!--time start-->
      <div class="a_time"><span>${createTime}</span>&nbsp;&nbsp;/&nbsp;收藏：<span  id="likeCount">0</span>&nbsp;&nbsp;/&nbsp;浏览：<span>${cmsActivity.yearBrowseCount==null?0:cmsActivity.yearBrowseCount}</span></div>
      <!--time end-->
      <div class="a_note">
        <div class="title">
          <h1><c:out escapeXml="true" value="${cmsActivity.activityName}"/></h1>
        </div>

        <input type="hidden" value="${tagIds}" name="tagIds" id="tagIds" />
        <div class="tag" id="tag"></div>

        <div class="address">
          <div class="al_img fl">
            <c:if test="${empty cmsActivity.activityVideoURL}">
              <li activity-icon-url="${cmsActivity.activityIconUrl}">
                <img src="" alt="" style="width: 320px;height: 213px;"/>
              </li>
            </c:if>
            <c:if test="${not empty cmsActivity.activityVideoURL}">
              <li activity-icon-url="${cmsActivity.activityIconUrl}">
                <input type="hidden" name="activityVideoURL" id="activityVideoURL"  value="${cmsActivity.activityVideoURL}" />
                <dd id="vedioDiv">
                </dd>
              </li>
            </c:if>
          </div>
          <div class="al_r fl">
            <c:if test="${cmsActivity.activityIsReservation==2 and cmsActivity.activityIsDel == 1 and cmsActivity.activityState == 6}" >
              <div class="yd_btn" style="width: 396px;">
                <c:if test="${isOver == 'Y'}" >
                  <a class="book-btn" style="background: #808080;cursor:default;margin-right:12px;" href="#">活动已结束</a>
                </c:if>
                <c:if test="${isOver == 'N'}" >
                  <c:if test="${empty cmsActivity.activityReservationCount || cmsActivity.activityReservationCount == 0 }">
                    <a class="book-btn" style="background: #808080;cursor:default;margin-right:12px;" href="#">预订人数已满</a>
                    余票：
			              	<span>
				                <c:if test="${empty cmsActivity.activityReservationCount}"> 0</c:if>
				                <c:if test="${not empty cmsActivity.activityReservationCount}"> ${cmsActivity.activityReservationCount}</c:if>
			                </span>
                    张
                  </c:if>
                  <c:if test="${cmsActivity.activityReservationCount > 0}">
                    <a class="book-btn" style="margin-right:12px;"
                       href="javascript:bookActivityPic('${basePath}','${cmsActivity.activityId}')">我要预订</a>
	                  	<%--<c:choose>--%>
	                    	<%--<c:when test="${cmsActivity.activityIsFree == 3}">--%>
	                    		<%--<a class="book-btn" style="margin-right:12px;"--%>
	                          <%--href="${path}/frontIndex/phone.do">请至app预订</a>--%>
	                		<%--</c:when>--%>
	                   		<%--<c:otherwise>--%>
	                   			<%--<c:if test="${(cmsActivity.sysNo=='0'||empty cmsActivity.sysNo) && orderLimit!=1}">--%>
			                    	<%--<c:choose>--%>
			                       		<%--<c:when test="${not empty cmsActivity.lowestCredit || not empty cmsActivity.costCredit || cmsActivity.spikeType == 1}">--%>
			                       			<%--<a class="book-btn" style="margin-right:12px;"--%>
			                           <%--href="javascript:;">请至app预订</a>--%>
			                       		<%--</c:when>--%>
			                       		<%--<c:otherwise>--%>
			                       			<%--<a class="book-btn" style="margin-right:12px;"--%>
			                           <%--href="javascript:bookActivityPic('${basePath}','${cmsActivity.activityId}')">我要预订</a>--%>
			                       		<%--</c:otherwise>--%>
			                       	<%--</c:choose>--%>
			                      <%--&lt;%&ndash;<a class="book-btn" style="margin-right:12px;padding: 0 10px;width: 340px;" href="javascript:;">订票系统维护中 请先使用文化云移动端预订</a>&ndash;%&gt;--%>
			                      <%--&lt;%&ndash; 余票：--%>
								                <%--<span>--%>
									                <%--<c:if test="${empty cmsActivity.activityReservationCount}"> 0</c:if>--%>
									                <%--<c:if test="${not empty cmsActivity.activityReservationCount}"> ${cmsActivity.activityReservationCount}</c:if>--%>
								                <%--</span>--%>
			                      <%--张 &ndash;%&gt;--%>
			                    <%--</c:if>--%>
			                    <%--<c:if test="${not empty cmsActivity.sysId || orderLimit==1}">--%>
			                      <%--<a class="book-btn" style="margin-right:12px;" href="javascript:;">请至app预订</a>--%>
			                      <%--余票：--%>
								                <%--<span>--%>
									                <%--<c:if test="${empty cmsActivity.activityReservationCount}"> 0</c:if>--%>
									                <%--<c:if test="${not empty cmsActivity.activityReservationCount}"> ${cmsActivity.activityReservationCount}</c:if>--%>
								                <%--</span>--%>
			                      <%--张--%>
			                    <%--</c:if>--%>
	                   		<%--</c:otherwise>--%>
	                    <%--</c:choose>--%>
                  </c:if>
                </c:if>
              </div>
            </c:if>
            <div class="list">
              <p class="site">
                  <%--${fn:split(cmsActivity.activityCity, ',')[1]}&nbsp;<c:if test="${fn:split(cmsActivity.activityArea, ',')[1] != fn:split(cmsActivity.activityCity, ',')[1]}">${fn:split(cmsActivity.activityArea, ',')[1]}&nbsp;</c:if><c:out  value="${cmsActivity.activityAddress}" escapeXml="true" />--%>
                  <c:out  value="${cmsActivity.activityAddress}" escapeXml="true" />
              </p>
              <p class="time">
                <fmt:parseDate value="${cmsActivity.activityStartTime}" pattern="yyyy-MM-dd" var="startTime"/>
                <fmt:parseDate value="${cmsActivity.activityEndTime}" pattern="yyyy-MM-dd" var="endTime"/>

                <fmt:formatDate value="${startTime}" pattern="yyyy年MM月dd日"/>
                <c:if test="${startTime eq endTime}">

                </c:if>
                <c:if test="${not empty endTime && startTime != endTime}" >
                  - <fmt:formatDate value="${endTime}" pattern="yyyy年MM月dd日"/>&nbsp;
                </c:if>
              </p>
              <c:if test="${not empty activityEventList}" >
                <p class="period">
		              <span>
		                 <%--<fmt:formatDate value="${startTime}" pattern="HH:mm"/> - <fmt:formatDate value="${endTime}" pattern="HH:mm"/>--%>
		                <c:forEach items="${activityEventList}" var="event" >
                          ${event.eventTime}  &nbsp; &nbsp; &nbsp;
                        </c:forEach>
		             </span>
                </p>
              </c:if>
              <c:if test="${not empty cmsActivity.activityTimeDes}">
                <p style="height: auto;">注： <c:out escapeXml="true" value="${cmsActivity.activityTimeDes}"/></p>
              </c:if>
              <p class="phone"><c:out value="${cmsActivity.activityTel}" escapeXml="true"/></p>
            </div>
          </div>
        </div>
        <!--detail_intro start-->
        <div class="ad_intro">
          <p>${cmsActivity.activityMemo}</p>
        </div>

        <div class="extra">
          <c:if test="${not empty cmsActivity.createActivityCode}" >
            <p>
              发布者：


              <c:choose>
                <c:when test="${not empty cmsActivity.venueName}">
                  ${cmsActivity.venueName}
                </c:when>
                <c:otherwise>
                  <c:choose>
                    <c:when test="${cmsActivity.createActivityCode == 0}">
                      ${fn:split(cmsActivity.activityProvince, ',')[1]}&nbsp;市自建活动
                    </c:when>
                    <c:when test="${cmsActivity.createActivityCode == 1}">
                      ${fn:split(cmsActivity.activityCity, ',')[1]}&nbsp;市自建活动
                    </c:when>
                    <c:when test="${cmsActivity.createActivityCode == 2}">
                      ${fn:split(cmsActivity.activityArea, ',')[1]}&nbsp;区自建活动
                    </c:when>
                  </c:choose>
                </c:otherwise>
              </c:choose>
            </p>
          </c:if>
          <c:if test="${not empty cmsActivity.activityOrganizer}" >
            <p>
              承办单位：<c:out value="${cmsActivity.activityOrganizer}" escapeXml="true"/>
            </p>
          </c:if>
          <c:if test="${not empty cmsActivity.activityCoorganizer}" >
            <p>
              协办单位：<c:out value="${cmsActivity.activityCoorganizer}" escapeXml="true"/>
            </p>
          </c:if>
          <c:if test="${not empty cmsActivity.activityPerformed}" >
            <p>
              演出单位：<c:out value="${cmsActivity.activityPerformed}" escapeXml="true"/>
            </p>
          </c:if>
          <c:if test="${not empty cmsActivity.activitySpeaker}" >
            <p>
              主讲人：<c:out value="${cmsActivity.activitySpeaker}" escapeXml="true"/>
            </p>
          </c:if>
          <c:if test="${not empty cmsActivity.activityPrompt}" >
            <p>
              友情提示：<c:out value="${cmsActivity.activityPrompt}" escapeXml="true"/>
            </p>
          </c:if>
        </div>

        <!--detail_intro end-->
        <!--附件start-->
        <div class="download_fj" activityAttachment="${cmsActivity.activityAttachment}">
        </div>
        <!--附件end-->
        <!--share start-->
        <div class="shares">
          <!--left start-->
          <div class="share_l fl">
            <a class="zan fl" id="zan-btn" onclick="changeClass()"></a>
          </div>
          <!--left end-->
        </div>
        <!--share end-->
        <!--go start-->
        <div class="go_head" id="go_head">
        </div>
        <!--go end-->
      </div>
      <div>
        <div align="center" class="overDiv" id="dpic">
          <div atyle="width:400px;height:400px;background:write">
            <img id='pic' style="width:200px;height:200px;margin-top:200px;" alt=''
               src="">
          </div>
          <div class="closeDiv" onclick="closeOverDiv()"><span>X</span></div>
        </div>
      </div>
    </div>
    <!--the_one end-->
    <!--the_two start-->
    <div class="the_two">
      <!--评论start-->
      <div class="comment mt20 clearfix">
        <a name="comment"></a>
        <div class="comment-list" id="comment-list-div">
          <ul>
          </ul>
          <input type="hidden" id="tuserId" name="tuserId" value="${teamUser.tuserId}"/>
          <input type="hidden" id="commentRkId" name="commentRkId" value="${cmsActivity.activityId}"/>
          <input type="hidden" id="commentPageNum" value="1"/>
          <a class="load-more" onclick="loadMoreComment()" id="moreComment">查看更多...</a>
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
      <div id="map-site"></div>
      <script type="text/javascript" src="http://webapi.amap.com/maps?v=1.3&amp;key=de421f9a41545db0c1c39cbb84f32163"></script>
      <script type="text/javascript">
        var map, marker;
        //初始化地图对象，加载地图
        map = new AMap.Map("map-site",{
          resizeEnable: true,
          //二维地图显示视口
          view: new AMap.View2D({
            center:new AMap.LngLat(${cmsActivity.activityLon}, ${cmsActivity.activityLat}),//地图中心点
            zoom:19 //地图显示的缩放级别
          })
        });
        //实例化点标记
        marker = new AMap.Marker({
          //复杂图标
          /* icon: new AMap.Icon({
           //图标大小
           size:new AMap.Size(32,39),
           //大图地址
           image:"image/map-icon1.png"
           }),
           position:new AMap.LngLat(121.452481,31.23504)*/
          position:map.getCenter()
        });
        marker.setMap(map);  //在地图上添加点
      </script>
    </div>
    <!--map end-->
    <!--activity_list start-->
    <div class="recommend mb20">
      <div class="tit"><i></i>相关活动推荐</div>
      <ul class="recommend-list">
          <c:forEach items="${cmsActivityList}" var="activity">
              <li activity-icon-url="${activity.activityIconUrl}">
                <a href="${path}/ticketActivity/ticketActivityDetail.do?activityId=${activity.activityId}" class="img"><img onload="fixImage(this, 280, 210)"></a>
                <div class="info">
                  <h3><a href="${path}/ticketActivity/ticketActivityDetail.do?activityId=${activity.activityId}"><c:out escapeXml="true" value="${activity.activityName}"/></a></h3>
                  <p>地址：<c:set var="activityAddress" value="${activity.activityAddress}"/>
                      <%--${fn:split(activity.activityCity, ',')[1]}&nbsp;<c:if test="${fn:split(activity.activityArea, ',')[1] != fn:split(activity.activityCity, ',')[1]}">${fn:split(activity.activityArea, ',')[1]}&nbsp;</c:if><c:out value="${fn:substring(activityAddress,0,22)}" escapeXml="true"/>--%>
                      <c:out value="${fn:substring(activityAddress,0,22)}" escapeXml="true"/>
                  </p>
                  <p>时间：${activity.activityStartTime}</p>
                </div>
              </li>
            </c:forEach>

      </ul>
    </div>
    <!--activity_list end-->
  </div>
  <!--right end-->
</div>
<!--con end-->
</body>
</html>

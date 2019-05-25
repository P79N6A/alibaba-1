<%@ page import="com.sun3d.why.model.SysUser" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<%
    String path = request.getContextPath();
    request.setAttribute("path", path);
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>活动列表--文化云</title>
    <link rel="shortcut icon" href="${path}/STATIC/image/favicon.ico" type="image/x-icon"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/reset.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/left.css"/>
    <!--[if lte IE 8]>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/main-ie.css"/>
    <![endif]-->
    <script type="text/javascript" src="${path}/STATIC/js/jquery.min.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/jquery.mCustomScrollbar.concat.min.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/left.js"></script>
    <%@include file="/WEB-INF/why/common/limit.jsp" %>
    
</head>
<body>

<div class="left">
    <div class="left-top">
        <div class="logo line"><img src="${path}/STATIC/image/logo-back.png" alt=""/></div>
        <div class="user-box line">
            <div class="img fl">
                <%
                    if (session.getAttribute("user") != null) {
                        SysUser user = (SysUser) session.getAttribute("user");
                        if (user.getUserSex() == 1) {
                %>
                <img src="${path}/STATIC/image/face_boy.png" alt="" width="50" height="50"/>
                <%
                } else if (user.getUserSex() == 2) {
                %>
                <img src="${path}/STATIC/image/face_girl.png" alt="" width="50" height="50"/>
                <%
                } else {
                %>
                <img src="${path}/STATIC/image/face_secrecy.png" alt="" width="50" height="50"/>
                <%
                        }
                    }
                %>
            </div>
            <div class="info fl">
                <p>${sessionScope.user.userAccount} <a class="edit-info" href="${path}/user/preEditPass.do"
                                                       target="main"></a></p>

                <p>
                    <%--权限：3 --%>
                    <a href="${path}/user/sysUserLoginOut.do" target="_top" style="color:#ffffff">退出</a></p>
            </div>
        </div>
    </div>
    <div class="left-tree" id="left-tree">
        <div class="tree-panel">
            <ul class="tree">
                <%if (!(trainButton || courseButton || courseOrderButton || trianUserListButton)) {%>
                	<%if (whyIndex) {%>
		                <li class="tree-selected">
		                    <a href="javascript:;" target="main" class="tree-node tree-index" onclick="toIndex();">
		                        <span class="tree-icon"></span><span class="tree-title">首页</span>
		                    </a>
		                </li>
		            <%}%>
	                <%if (whyStatistics) {%>
	                <li>
	                    <a href="javascript:;" class="tree-node">
	                        <span class="tree-icon tree-collapsed"></span><span class="tree-title">数据管理</span>
	                    </a>
	                    <ul class="tree-child" style="display: none;">
	                        <li>
	                            <a href="javascript:;" class="tree-node tree-node2"><span class="tree-line"></span><span
	                                    class="tree-icon tree-collapsed"></span><span class="tree-title">活动数据统计</span></a>
	                            <ul class="tree-child2" style="display: none;">
	                                <li><a href="${path}/activityStatistics/activityAreaStatisticsIndex.do"
	                                       target="main"><span class="tree-line"></span><span class="tree-icon"></span><span
	                                        class="tree-title">各区县活动情况</span></a></li>
	                                <li><a href="${path}/activityStatistics/activityBookStatisticsIndex.do"
	                                       target="main"><span class="tree-line"></span><span class="tree-icon"></span><span
	                                        class="tree-title">活动预约情况</span></a></li>
	                                <li><a href="${path}/activityStatistics/activityTagStatisticsIndex.do"
	                                       target="main"><span class="tree-line"></span><span class="tree-icon"></span><span
	                                        class="tree-title">活动标签热度</span></a></li>
	                                <li class="tree-node-last"><a
	                                        href="${path}/activityStatistics/activityMessageStatisticsIndex.do"
	                                        target="main"><span class="tree-line"></span><span
	                                        class="tree-icon"></span><span class="tree-title">活动评论报表</span></a></li>
	                            </ul>
	                        </li>
	                        <li>
	                            <a href="javascript:;" class="tree-node tree-node2"><span class="tree-line"></span><span
	                                    class="tree-icon tree-collapsed"></span><span class="tree-title">场馆数据统计</span></a>
	                            <ul class="tree-child2" style="display: none;">
	                                <li><a href="${path}/venueStatistics/VenueAreaStatisticsIndex.do" target="main"><span
	                                        class="tree-line"></span><span class="tree-icon"></span><span
	                                        class="tree-title">各区县场馆情况</span></a></li>
	                                <li><a href="${path}/venueStatistics/RoomAreaStatisticsIndex.do" target="main"><span
	                                        class="tree-line"></span><span class="tree-icon"></span><span
	                                        class="tree-title">活动室预约实况</span></a></li>
	                                <li><a href="${path}/venueStatistics/VenueTagStatisticsIndex.do" target="main"><span
	                                        class="tree-line"></span><span class="tree-icon"></span><span
	                                        class="tree-title">场馆标签热度</span></a></li>
	                                <li class="tree-node-last"><a
	                                        href="${path}/venueStatistics/VenueMessageStatisticsIndex.do"
	                                        target="main"><span class="tree-line"></span><span
	                                        class="tree-icon"></span><span class="tree-title">场馆评论报表</span></a></li>
	                            </ul>
	                        </li>
	                        <li><a href="${path}/userStatistic/userStatistic.do" target="main"><span
	                                class="tree-line"></span><span class="tree-icon"></span><span
	                                class="tree-title">会员数据统计</span></a></li>
	
	                        <li class="tree-node-last"><a href="${path}/contentStatistic/showStatistic.do"
	                                                      target="main"><span class="tree-line"></span><span
	                                class="tree-icon"></span><span class="tree-title">平台内容统计</span></a></li>
	                    </ul>
	                </li>
	                <li>
	                    <a href="javascript:;" class="tree-node">
	                        <span class="tree-icon tree-collapsed"></span><span class="tree-title">数据查看</span>
	                    </a>
	                    <ul class="tree-child" style="display: none;">
	                        <li><a href="${path}/activityStatistics/activityPublicStatistics.do" target="main"><span
	                                class="tree-line"></span><span class="tree-icon"></span><span
	                                class="tree-title">活动发布统计</span></a></li>
	
	                        <li><a href="${path}/activityStatistics/activityAlternatelyStatistics.do" target="main"><span
	                            class="tree-line"></span><span class="tree-icon"></span><span
	                            class="tree-title">活动交互统计</span></a></li>
	                        <li><a href="${path}/activityStatistics/activityIdAltStatistics.do" target="main"><span
	                                class="tree-line"></span><span class="tree-icon"></span><span
	                                class="tree-title">单场活动交互统计</span></a></li>
	                        <li><a href="${path}/venueStatistics/venuePublicStatistics.do" target="main"><span
	                                class="tree-line"></span><span class="tree-icon"></span><span
	                                class="tree-title">活动室发布统计</span></a></li>
	
	                        <li class="tree-node-last"><a href="${path}/venueStatistics/venueAlternatelyStatistics.do"
	                                                      target="main"><span class="tree-line"></span><span
	                                class="tree-icon"></span><span class="tree-title">场馆交互统计</span></a></li>
	                                
	                        <!--  区县活动，活动室数据统计 -->        
	                           <%if (countyStatistics) {%>
	                         <li class="tree-node-last"><a href="${path}/countyStatistics/countyStatisticsPage.do"
	                                                      target="main"><span class="tree-line"></span><span
	                                class="tree-icon"></span><span class="tree-title">区县活动数据统计</span></a></li>  
	                         <li class="tree-node-last"><a href="${path}/countyStatistics/countyRoomStatisticsPage.do"
	                                                      target="main"><span class="tree-line"></span><span
	                                class="tree-icon"></span><span class="tree-title">区县活动室数据统计</span></a></li>  
	                                 
	                             <%}%>   
	                                
	                    </ul>
	                </li>
	                <%}%>
	                
	                      <% if(!whyStatistics&& countyStatistics ){ %>
	                     <li>
	                    <a href="javascript:;" class="tree-node">
	                        <span class="tree-icon tree-collapsed"></span><span class="tree-title">数据查看</span>
	                    </a>
	                    <ul class="tree-child" style="display: none;">
	                                
	                        <!--  区县活动，活动室数据统计 -->        
	                           <%if (countyStatistics) {%>
	                         <li class="tree-node-last"><a href="${path}/countyStatistics/countyStatisticsPage.do"
	                                                      target="main"><span class="tree-line"></span><span
	                                class="tree-icon"></span><span class="tree-title">区县活动数据统计</span></a></li>
	                         <li class="tree-node-last"><a href="${path}/countyStatistics/countyRoomStatisticsPage.do"
	                                                      target="main"><span class="tree-line"></span><span
	                                class="tree-icon"></span><span class="tree-title">区县活动室数据统计</span></a></li>   
	                             <%}%>   
	                    </ul>
	                    
	                    <%}%>
	                
                <%}%>
					
				<li>
                    <a href="javascript:;" class="tree-node">
                        <span class="tree-icon tree-collapsed"></span><span class="tree-title">配送中心</span>
                    </a>
                    <ul class="tree-child" style="display: none;">
                    	<%if (dcStatisticsIndexButton) {%>
                        <li><a href="${path}/dcVideo/dcStatisticsIndex.do" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">统计汇总</span></a></li>
                        <%}%>
                        <%if (dcVideoIndex1Button) {%>
                        <li><a href="${path}/dcVideo/dcVideoIndex.do?reviewType=1" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">技术评审</span></a></li>
                        <%}%>
                        <%if (dcVideoIndex2wButton) {%>
                        <li><a href="${path}/dcVideo/dcVideoIndex.do?reviewType=2&videoType=舞蹈" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">舞蹈类-海选评审</span></a></li>
                        <%}%>
                        <%if (dcVideoIndex2hButton) {%>
                        <li><a href="${path}/dcVideo/dcVideoIndex.do?reviewType=2&videoType=合唱" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">合唱类-海选评审</span></a></li>
                        <%}%>
                        <%if (dcVideoIndex2sButton) {%>
                        <li><a href="${path}/dcVideo/dcVideoIndex.do?reviewType=2&videoType=时装" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">时装类-海选评审</span></a></li>
                        <%}%>
                        <%if (dcVideoIndex2xButton) {%>
                        <li><a href="${path}/dcVideo/dcVideoIndex.do?reviewType=2&videoType=戏曲/曲艺" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">戏曲/曲艺类-海选评审</span></a></li>
                        <%}%>
                        <%if (dcVideoIndex3Button) {%>
                        <li><a href="${path}/dcVideo/dcVideoIndex.do?reviewType=3" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">海选复审</span></a></li>
                        <%}%>
                        <%if (dcVideoIndex4wButton) {%>
                        <li><a href="${path}/dcVideo/dcVideoIndex.do?reviewType=4&videoType=舞蹈" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">舞蹈类-专家评审</span></a></li>
                        <%}%>
                        <%if (dcVideoIndex4hButton) {%>
                        <li><a href="${path}/dcVideo/dcVideoIndex.do?reviewType=4&videoType=合唱" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">合唱类-专家评审</span></a></li>
                        <%}%>
                        <%if (dcVideoIndex4sButton) {%>
                        <li><a href="${path}/dcVideo/dcVideoIndex.do?reviewType=4&videoType=时装" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">时装类-专家评审</span></a></li>
                        <%}%>
                        <%if (dcVideoIndex4xButton) {%>
                        <li><a href="${path}/dcVideo/dcVideoIndex.do?reviewType=4&videoType=戏曲/曲艺" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">戏曲/曲艺类-专家评审</span></a></li>
                        <%}%>
                        <%if (dcVideoIndex5Button) {%>
                        <li class="tree-node-last"><a href="${path}/dcVideo/dcVideoIndex.do?reviewType=5" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">评分汇总</span></a></li>
                    	<%}%>
                    </ul>
                </li>
				
                <%if (!(trainButton || courseButton || courseOrderButton || trianUserListButton)) {%>
                <li>
                    <a href="javascript:;" class="tree-node">
                        <span class="tree-icon tree-collapsed"></span><span class="tree-title">活动管理</span>
                    </a>
                    <ul class="tree-child" style="display: none;">
                        <%if (activityPublishButton) {%>
                        <li><a href="${path}/activity/preAddActivity.do" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">发布活动</span></a></li>
                        <%}%>
                        <%if (activityDeleteButton) {%>
                        <li><a href="${path}/activity/activityExamineIndex.do?activityState=6" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">审核活动</span></a></li>
                        <%}%>
                        <%if (activityIndexButton) {%>
                        <li><a href="${path}/activity/activityIndex.do?activityState=6" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">活动列表</span></a></li>
                        <%}%>
                        <%if (activityTemplateIndexButton) {%>
                        <li><a href="${path}/activityTemplate/activityTemplateIndex.do" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">活动模板管理</span></a></li>
                        <%}%>
                        <%if (functionIndexButton) {%>
                        <li><a href="${path}/function/functionIndex.do" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">模板功能管理</span></a></li>
                        <%}%>
                        <%if (activityPersonalIndexButton) {%>
                        <li><a href="${path}/activity/activityPersonalIndex.do?activityState=3&activityPersonal=1"
                               target="main"><span class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">个人活动审核</span></a></li>
                        <%}%>
                        <c:if test="${sessionScope.user.userAccount eq 'shqyg01'}">
                            <li>
                                <a href="${path}/activity/activityUnderling.do?type=3" target="main"><span
                                        class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">下属活动</span></a>
                            </li>
                        </c:if>
                        <c:if test="${sessionScope.user.userAccount eq 'shtsg01'}">
                            <li>
                                <a href="${path}/activity/activityBookUnderling.do?type=3" target="main"><span
                                        class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">下属活动</span></a>
                            </li>
                        </c:if>
                        <%if (activityOrderIndexButton) {%>
                        <li><a href="${path}/order/queryAllUserOrderIndex.do" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">订单列表</span></a></li>
                        <%}%>
                        <%--<li><a href="${path}/activity/activityIndex.do?activityState=3"  target="main"><span class="tree-line"></span><span class="tree-icon"></span><span class="tree-title">待审核</span></a></li>--%>
                        <%if (activityOrderDraftIndexButton) {%>
                        <li><a href="${path}/activity/activityIndex.do?activityState=1" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">草稿箱</span></a></li>
                        <%}%>
                        <%if (activityRecycleIndexButton) {%>
                        <li class="tree-node-last"><a
                                href="${path}/activity/activityIndex.do?activityState=5&activityIsDel=1"
                                target="main"><span class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">回收站</span></a></li>
                        <%}%>
                    </ul>
                </li>
                <%}%>

                <li>
                    <a href="javascript:;" class="tree-node">
                        <span class="tree-icon tree-collapsed"></span><span class="tree-title">场馆管理</span>
                    </a>
                    <ul class="tree-child" style="display: none;">
                        <li class="tree-selected">
                            <a href="javascript:;" class="tree-node tree-node2">
                                <span class="tree-line"></span><span class="tree-icon tree-collapsed"></span><span
                                    class="tree-title">场馆信息管理</span>
                            </a>
                            <ul class="tree-child2" style="display: none;">

                                <!--hucheng-->
                                <%
                                    if (selectVenueListButton) {
                                %>
                                <li><a target="main" href="${path}/venue/venueIndex.do"><span
                                        class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">场馆列表</span></a></li>
                                <%
                                    }
                                %>

                                <%
                                    if (addVenueButton) {
                                %>
                                <li><a target="main" href="${path}/venue/preAddVenue.do"><span class="tree-line"></span><span
                                        class="tree-icon"></span><span class="tree-title">新建场馆</span></a></li>

                                <%
                                    }
                                %>

                                <%
                                    if (venueDraftListButton) {
                                %>
                                <li><a target="main" href="${path}/venue/venueDraftList.do"><span
                                        class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">场馆草稿箱</span></a></li>

                                <%
                                    }
                                %>

                                <%
                                    if (venueRecycleListButton) {
                                %>
                                <li><a target="main" href="${path}/venue/venueRecycleList.do"><span
                                        class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">场馆回收站</span></a></li>

                                <%
                                    }
                                %>

                                <%
                                    if (venueCommentIndexButton) {
                                %>
                                <li class="tree-node-last"><a target="main"
                                                              href="${path}/venue/venueCommentIndex.do"><span
                                        class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">场馆评论管理</span></a></li>

                                <%
                                    }
                                %>

                            </ul>
                        </li>

                        <li class="tree-selected">
                            <a href="javascript:;" class="tree-node tree-node2">
                                <span class="tree-line"></span><span class="tree-icon tree-collapsed"></span><span
                                    class="tree-title">藏品信息管理</span>
                            </a>
                            <ul class="tree-child2" style="display: none;">
                                <%
                                    if (antiqueIndexButtonA1) {
                                %>
                                <li><a target="main" href="${path}/antique/antiqueIndex.do?antiqueState=1"><span
                                        class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">藏品草稿箱</span></a></li>
                                <%
                                    }
                                %>
                                <%
                                    if (antiqueIndexButtonA5) {
                                %>
                                <li><a target="main" href="${path}/antique/antiqueIndex.do?antiqueState=5"><span
                                        class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">藏品回收站</span></a></li>
                                <%
                                    }
                                %>
                                <%
                                    if (antiqueTypeIndexButton) {
                                %>
                                <li class="tree-node-last"><a target="main" href="${path}/antiqueType/index.do"><span
                                        class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">藏品类型管理</span></a></li>
                                <%
                                    }
                                %>
                                <%--<li><a target="main" href="${path}/antiqueType/preAddAntiqueType.do"><span class="tree-icon"></span><span class="tree-title">新建藏品类型</span></a></li>--%><%--<li><a target="main" href="${path}/antiqueType/preAddAntiqueType.do"><span class="tree-icon"></span><span class="tree-title">新建藏品类型</span></a></li>--%>
                            </ul>
                        </li>
            
                        <li class="tree-selected tree-node-last">
                            <a href="javascript:;" class="tree-node tree-node2">
                                <span class="tree-line"></span><span class="tree-icon tree-collapsed"></span><span
                                    class="tree-title">活动室信息管理</span>
                            </a>
                            <ul class="tree-child2" style="display: none;">
                                <%
                                    if (activityRoomDraftIndexButton) {
                                %>
                                <li><a target="main" href="${path}/activityRoom/roomDraftList.do"><span
                                        class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">活动室草稿箱</span></a></li>
                                <%
                                    }
                                %>
                                <%
                                    if (activityRoomRecycleIndexButton) {
                                %>
                                <li class="tree-node-last"><a target="main"
                                                              href="${path}/activityRoom/roomRecycleList.do"><span
                                        class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">活动室回收站</span></a></li>
                                <%
                                    }
                                %>
                            </ul>
                        </li>
                    </ul>
                </li>
                <%
                    if (activityRoomOrderIndexButton) {
                %>
				<li>
                   <a href="javascript:;" class="tree-node">
                     <span class="tree-icon tree-collapsed"></span><span class="tree-title">活动室订单管理</span>
                   </a>
					<ul class="tree-child" style="display: none;">
						
						<li class="tree-node-last"><a target="main"
                                                              href="${path}/cmsRoomOrder/roomOrderCheckIndex.do"><span
                                        class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">待审核</span></a></li>
                        <li class="tree-node-last"><a target="main"
                                                              href="${path}/cmsRoomOrder/roomOrderIndex.do"><span
                                        class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">当前订单</span></a></li>
                         <li class="tree-node-last"><a target="main"
                                                              href="${path}/cmsRoomOrder/roomOrderHistoryIndex.do"><span
                                        class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">历史订单</span></a></li>                           
					</ul>
				</li>
                <%
                    }
                %>
                <li>
                    <a href="javascript:;" class="tree-node">
                        <span class="tree-icon tree-collapsed"></span><span class="tree-title">会员管理</span>
                    </a>
                    <ul class="tree-child" style="display: none;">
                        <%-- <li class="tree-selected">
                            <a href="javascript:;" class="tree-node tree-node2">
                                <span class="tree-line"></span><span class="tree-icon tree-collapsed"></span><span
                                    class="tree-title">用户管理</span>
                            </a>
                            <ul class="tree-child2" style="display: none;">
                                <%if (terminalIndexButton) {%>
                                <li><a target="main"
                                       href="${path}/terminalUser/terminalUserIndex.do?userIsDisable=1"><span
                                        class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">用户列表</span></a></li>
                                <%}%>
                                <%if (terminalAddButton) {%>
                               <!--  <li><a target="main" href="${path}/terminalUser/preAddTerminalUser.do"><span
                                        class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">新建用户</span></a></li>--> 
                                <%}%>
                                <%if (terminalWaiteActiveButton) {%>
                                <li class="tree-node-last"><a target="main"
                                                              href="${path}/terminalUser/terminalUserIndex.do"><span
                                        class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">待激活</span></a></li>
                                <%}%>
                            </ul>
                        </li> --%>
                        <li class="tree-node-last tree-selected">
                            <a href="javascript:;" class="tree-node tree-node2">
                                <span class="tree-line"></span><span class="tree-icon tree-collapsed"></span><span
                                    class="tree-title">使用者列表</span>
                            </a>
                            <ul class="tree-child2" style="display: none;">
                                <%if (teamIndexButton) {%>
                                <li><a target="main" href="${path}/teamUser/teamUserIndex.do?tuserIsActiviey=1"><span
                                        class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">使用者列表</span></a></li>
                                <%}%>
                                <%if (teamPreAddButton) {%>
                               <!-- <li><a target="main" href="${path}/teamUser/preAddTeamUser.do"><span
                                        class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">新建团体</span></a></li> --> 
                                <%}%>
                                <%if (teamWaiteActiveIndexButton) {%>
                                <li class="tree-node-last"><a target="main"
                                                              href="${path}/teamUser/teamUserIndex.do?tuserIsActiviey=2"><span
                                        class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">待激活</span></a></li>
                                <%}%>
                            </ul>
                        </li>
                    </ul>
                </li>

                <%--<li  class="tree-selected">--%>
                <%--<a href="javascript:;" class="tree-node">--%>
                <%--<span class="tree-icon tree-collapsed"></span><span class="tree-title">非遗管理</span>--%>
                <%--</a>--%>
                <%--<ul class="tree-child" style="display: none;">--%>
                <%--<li><a href="${path}/culture/getList.do?cultureState=1" target="main"><span class="tree-line"></span><span class="tree-icon"></span><span class="tree-title">非遗列表</span></a></li>--%>
                <%--<li><a href="${path}/culture/toAdd.do" target="main"><span class="tree-line"></span><span class="tree-icon"></span><span class="tree-title">添加非遗</span></a></li>--%>
                <%--<li><a href="${path}/culture/getList.do?cultureState=2" target="main"><span class="tree-line"></span><span class="tree-icon"></span><span class="tree-title">非遗草稿箱</span></a></li>--%>
                <%--<li class="tree-node-last"><a href="${path}/culture/getList.do?cultureState=3" target="main"><span class="tree-line"></span><span class="tree-icon"></span><span class="tree-title">非遗回收站</span></a></li>--%>
                <%--</ul>--%>
                <%--</li>--%>
                <%if (!(trainButton || courseButton || courseOrderButton || trianUserListButton)) {%>
                <li>
                    <a href="javascript:;" class="tree-node">
                        <span class="tree-icon tree-collapsed"></span><span class="tree-title">运维管理</span>
                    </a>
                    <ul class="tree-child" style="display: none;">
                        <%
                            if (activityEditorial) {
                        %>
                        <li>
                            <a href="javascript:;" class="tree-node tree-node2"><span class="tree-line"></span><span
                                    class="tree-icon tree-collapsed"></span><span class="tree-title">采编活动管理</span></a>
                            <ul class="tree-child2" style="display: none;">
                                <%if (addActivityEditorial) {%>
                                <li><a href="${path}/activityEditorial/preAddActivityEditorial.do" target="main"><span
                                        class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">新增采编</span></a></li>
                                <%}%>
                                <%if (activityEditorialIndex) {%>
                                <li><a href="${path}/activityEditorial/activityEditorialIndex.do?activityState=6"
                                       target="main"><span class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">采编列表</span></a></li>
                                <li><a href="${path}/activityEditorial/activityEditorialIndex.do?activityState=1"
                                       target="main"><span class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">草稿箱</span></a></li>
                                <li class="tree-node-last"><a
                                        href="${path}/activityEditorial/activityEditorialIndex.do?activityState=5"
                                        target="main"><span class="tree-line"></span><span
                                        class="tree-icon"></span><span class="tree-title">回收站</span></a></li>
                                <%}%>
                            </ul>
                        </li>
                        <%
                            }
                        %>
                        <%
                            if (Information) {
                        %>
                        <li>
                            <a href="javascript:;" class="tree-node tree-node2"><span class="tree-line"></span><span
                                    class="tree-icon tree-collapsed"></span><span class="tree-title">资讯管理</span></a>
                            <ul class="tree-child2" style="display: none;">
                                <li><a href="${path}/information/preAddInformation.do" target="main"><span
                                        class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">新建资讯</span></a></li>
                                <li class="tree-node-last"><a href="${path}/information/informationIndex.do"
                                                              target="main"><span class="tree-line"></span><span
                                        class="tree-icon"></span><span class="tree-title">资讯列表</span></a></li>
                            </ul>
                        </li>
                        <%
                            }
                        %>
                        <%
                            if (contactIndexButton) {
                        %>
                        <li><a href="${path}/contact/contactPage.do" target="main"><span class="tree-line"></span><span
                                class="tree-icon"></span><span class="tree-title">联系我们</span></a></li>
                        <%
                            }
                        %>
                        <%
                            if (commentIndexButton) {
                        %>
                        <li><a href="${path}/comment/commentIndex.do" target="main"><span class="tree-line"></span><span
                                class="tree-icon"></span><span class="tree-title">评论管理</span></a></li>
                        <%
                            }
                        %>

                        <%
                            if (dictIndexButton) {
                        %>
                        <li><a href="${path}/sysdict/dictIndex.do" target="main"><span class="tree-line"></span><span
                                class="tree-icon"></span><span class="tree-title">字典管理</span></a></li>
                        <%
                            }
                        %>
                        <%if (sensitiveWordsIndexButton) {%>
                        <li><a href="${path}/sensitiveWords/sensitiveWordsIndex.do" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">敏感词管理</span></a></li>
                        <%}%>
                        <%if (androidVersionIndexButton) {%>
                        <li><a href="${path}/androidVersion/androidVersionIndex.do" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">手机版本管理</span></a></li>
                        <%}%>
						<%if (appSettingIndexButton) {%>
                        <li><a href="${path}/appSetting/appSettingIndex.do" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">App设置</span></a></li>
                        <%}%>
                        <%
                            if (tagListButton) {
                        %>
                        <li>
                            <a href="javascript:;" class="tree-node tree-node2"><span class="tree-line"></span><span
                                    class="tree-icon tree-collapsed"></span><span class="tree-title">标签管理</span></a>
                            <ul class="tree-child2" style="display: none;">
                                <li><a target="main" href="${path}/tag/tagList.do?tagType=2"><span
                                        class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">活动标签</span></a></li>
                                <li><a target="main" href="${path}/tag/tagList.do?tagType=3"><span
                                        class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">场馆标签</span></a></li>
                                <li class="tree-node-last"><a target="main"
                                                              href="${path}/tag/tagList.do?tagType=4"><span
                                        class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">团体标签</span></a></li>
                                <li class="tree-node-last"><a target="main"
                                                              href="${path}/tag/tagList.do?tagType=5"><span
                                        class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">新闻标签</span></a></li>
                            </ul>
                        </li>
                        <%
                            }
                        %>
                        <%
                            if (messageIndexButton) {
                        %>
                        <li><a href="${path}/message/messageIndex.do" target="main"><span class="tree-line"></span><span
                                class="tree-icon"></span><span class="tree-title">系统消息</span></a></li>
                        <%
                            }
                        %>
                        <%
                            if (questionAnwserIndexButton) {
                        %>
                        <li class="tree-node-last"><a href="${path}/questionAnwser/questionAnwserIndex.do"
                                                      target="main"><span class="tree-line"></span><span
                                class="tree-icon"></span><span class="tree-title">互动管理</span></a></li>
                        <%
                            }
                        %>
                        <%if (cultureTeamIndexButton) {%>
                        <li class="tree-node-last"><a href="${path}/cultureTeam/cultureTeamIndex.do"
                                                      target="main"><span class="tree-line"></span><span
                                class="tree-icon"></span><span class="tree-title">浦东文化社团评选</span></a></li>
		                <%}%>
                    </ul>
                </li>
                <%}%>
                
                  <%if ((contestQuizIndex || exhibitionIndexButton || voteIndex || applicationContestConfigIndexButton)) {%>
                <li>
                    <a href="javascript:;" class="tree-node">
                        <span class="tree-icon tree-collapsed"></span><span class="tree-title">文化云应用大赛</span>
                    </a>
                    <ul class="tree-child" style="display: none;">
                
                 <%
                            if (contestQuizIndex) {
                        %>
                        <li><a href="${path}/contestTopic/contestQuizIndex.do"
                               target="main"><span class="tree-line"></span><span
                                class="tree-icon"></span><span class="tree-title">知识问答</span></a></li>
                        <%
                            }
                        %>
                       <%
                            if (exhibitionIndexButton) {
                        %>
                      
                        <li><a href="${path}/exhibition/exhibitionIndex.do"
                               target="main"><span class="tree-line"></span><span
                                class="tree-icon"></span><span class="tree-title">线上展览</span></a></li>
                        <%
                            }
                        %>
                        
                        
                        <%
                            if (voteIndex) {
                        %>
                        <li><a href="${path}/vote/voteIndex.do"
                               target="main"><span class="tree-line"></span><span
                                class="tree-icon"></span><span class="tree-title">线上投票</span></a></li>
                        <%
                            }
                        %>
                        
                       <%
                            if (applicationContestConfigIndexButton) {
                        %>
                        <li><a href="${path}/applicationContestConfig/index.do"
                               target="main"><span class="tree-line"></span><span
                                class="tree-icon"></span><span class="tree-title">应用大赛配置管理</span></a></li>
                        <%
                            }
                        %>
                        
                  </ul>
                </li>
                <%}%>
                
                <%
                    if (appAdvertRecommendIndexButton) {
                %>
                <li>
                    <a href="javascript:;" class="tree-node">
                        <span class="tree-icon tree-collapsed"></span><span class="tree-title">推荐管理</span>
                    </a>
                    <ul class="tree-child" style="display: none;">
                        <li>
                            <a href="javascript:;" class="tree-node tree-node2"><span class="tree-line"></span><span
                                    class="tree-icon tree-collapsed"></span><span class="tree-title">Web端推荐</span></a>
                            <ul class="tree-child2" style="display: none;">
                                <%
                                    if (webHomeNavigationRecommendButton) {
                                %>

                                <li><a target="main" href="${path}/webIndex/webIndex.do"><span class="tree-line"></span><span
                                        class="tree-icon"></span><span class="tree-title">首页栏目推荐</span></a></li>
                                <%
                                    }
                                %>

                                <%
                                    if (homeHotRecommendButton) {
                                %>
                                <li><a target="main" href="${path}/recommend/homeHotRecommendIndex.do"><span
                                        class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">首页热点推荐</span></a></li>
                                <%
                                    }
                                %>

                                <%
                                    if (webAdvertIndexButton) {
                                %>
                                <li><a href="${path}/advert/advertIndex.do?displayPosition=1" target="main"><span
                                        class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">轮播图管理</span></a></li>
                                <%
                                    }
                                %>
                                <%
                                    if (homeVenueRecommendIndexButton) {
                                %>
                                <li class="tree-node-last"><a target="main"
                                                              href="${path}/recommend/homeVenueRecommendIndex.do"><span
                                        class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">首页场馆推荐</span></a></li>
                                <%
                                    }
                                %>
                            </ul>
                        </li>

                        <li class="tree-node-last">
                            <a href="javascript:;" class="tree-node tree-node2"><span class="tree-line"></span><span
                                    class="tree-icon tree-collapsed"></span><span class="tree-title">App端推荐</span></a>
                            <ul class="tree-child2" style="display: none;">
                                <%
                                    if (apprecommendRelateButton) {

                                %>
                                <li><a target="main" href="${path}/recommendRelate/recommendIndex.do"><span
                                        class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">活动推荐置顶</span></a></li>
                                <%
                                    }
                                %>
                                <%
                                    if (apprecommendRelateTopButton) {

                                %>
                                <li><a target="main" href="${path}/recommendRelate/activityIndex.do"><span
                                        class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">活动标签置顶</span></a></li>
                                <%
                                    }
                                %>
                                <%
                                    if (activityHomeRecommendIndexButton) {

                                %>
                                <li><a target="main" href="${path}/recommend/appActivityHomeRecommendIndex.do"><span
                                        class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">首页栏目推荐</span></a></li>
                                <%
                                    }
                                %>

                                <%
                                    if (cmsListRecommendTagButton) {

                                %>
                                <li><a target="main" href="${path}/recommend/preCmsListRecommendTag.do"><span
                                        class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">活动列表页推荐</span></a></li>
                                <%
                                    }
                                %>

                                <%
                                    if (appAdvertIndexButton) {
                                %>
                                <li class="tree-node-last"><a href="${path}/advert/appRecommendadvertlist.do"
                                                              target="main"><span class="tree-line"></span><span
                                        class="tree-icon"></span><span class="tree-title">轮播图管理</span></a></li>
                                <%
                                    }
                                %>
                                <%
                                    if (appAdvertRecommendIndexButton) {
                                %>
                                <li class="tree-node-last"><a href="${path}/advertRecommend/appAdvertRecommendIndex.do"
                                                              target="main"><span class="tree-line"></span><span
                                        class="tree-icon"></span><span class="tree-title">广告位管理</span></a></li>

                                <li class="tree-node-last"><a href="${path}/advertCalendar/appAdvertCalendarIndex.do"
                                                              target="main"><span class="tree-line"></span><span
                                        class="tree-icon"></span><span class="tree-title">日历广告位</span></a></li>
                                <%
                                    }
                                %>
                            </ul>
                        </li>
                    </ul>

                </li>
                <%
                    }
                %>
                <li>
                    <a href="javascript:;" class="tree-node">
                        <span class="tree-icon tree-collapsed"></span><span class="tree-title">站点管理</span>
                    </a>
                    <ul class="tree-child" style="display: none;">
                        <%
                            if (sysUserIndexButton) {
                        %>
                        <li><a href="${path}/user/sysUserIndex.do" target="main"><span class="tree-line"></span><span
                                class="tree-icon"></span><span class="tree-title">管理员列表</span></a></li>
                        <%
                            }
                        %>
                        <%
                            if (sysUserAddButton) {
                        %>
                        <li><a href="${path}/user/preAddSysUser.do" target="main"><span class="tree-line"></span><span
                                class="tree-icon"></span><span class="tree-title">新建管理员</span></a></li>
                        <%
                            }
                        %>
                        <%
                            if (departmentIndexButton) {
                        %>
                        <li><a href="${path}/dept/deptIndex.do" target="main"><span class="tree-line"></span><span
                                class="tree-icon"></span><span class="tree-title">部门列表</span></a></li>
                        <%
                            }
                        %>
                        <%
                            if (roleIndexButton) {
                        %>
                        <li><a href="${path}/role/roleIndex.do" target="main"><span class="tree-line"></span><span
                                class="tree-icon"></span><span class="tree-title">角色列表</span></a></li>
                        <%
                            }
                        %>
                        <%
                            if (preInitModuleButton) {
                        %>
                        <li><a href="${path}/module/preInitModule.do" target="main"><span class="tree-line"></span><span
                                class="tree-icon"></span><span class="tree-title">权限初始化</span></a></li>
                        <%
                            }
                        %>
                        <%
                            if (userFanKuiButton) {
                        %>
                        <li><a href="${path}/feedInformation/feedIndex.do" target="main"><span class="tree-line"></span><span
                                class="tree-icon"></span><span class="tree-title">用户反馈</span></a></li>
                        <%
                            }
                        %>
                        <%
                            if (shareDeptIndexButton) {
                        %>
                        <li class="tree-node-last"><a href="${path}/shareDept/shareDeptIndex.do" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">信息共享</span></a></li>
                        <%
                            }
                        %>
                    </ul>
                </li>
                <%if (!(trainButton || courseButton || courseOrderButton || trianUserListButton)) {%>
                <li>
                    <a href="javascript:;" class="tree-node">
                        <span class="tree-icon tree-collapsed"></span><span class="tree-title">主题管理</span>
                    </a>
                    <ul class="tree-child" style="display: none;">
                        <%if (mcVideoButton) {%>
                        <li><a href="${path}/mcVideo/videoIndex.do" target="main"><span class="tree-line"></span><span
                                class="tree-icon"></span><span class="tree-title">视频管理</span></a></li>
                        <%}%>
                        <%if (mcNewsButton) {%>
                        <li><a href="${path}/mcNews/mcNewsIndex.do" target="main"><span class="tree-line"></span><span
                                class="tree-icon"></span><span class="tree-title">新闻管理</span></a></li>
                        <%}%>
						<%if (activityVoteIndexButton) {%>
                        <li class="tree-node-last"><a href="${path}/vote/activityVoteIndex.do" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">投票管理</span></a></li>
                        <%}%>
                    </ul>
                </li>
                <%}%>

                <%-- <%if (!(trainButton || courseButton || courseOrderButton || trianUserListButton)) {%>
                <li>
                    <a href="javascript:;" class="tree-node">
                        <span class="tree-icon tree-collapsed"></span><span class="tree-title">微信管理</span>
                    </a>
                    <ul class="tree-child" style="display: none;">
                        <li><a href="${path}/weiXin/weiXinIndex.do" target="main"><span class="tree-line"></span><span
                                class="tree-icon"></span><span class="tree-title">自动回复</span></a></li>
                    </ul>
                </li>
                <%}%> --%>
                
                <li>
                    <a href="javascript:;" class="tree-node">
                        <span class="tree-icon tree-collapsed"></span><span class="tree-title">培训管理</span>
                    </a>
                    <ul class="tree-child" style="display: none;">
                        <%if (courseButton) {%>
                        <li><a href="${path}/peopleTrain/courseList.do" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">课程列表</span></a></li>
                        <%}%>
                        <%if (courseOrderButton) {%>
                        <li><a href="${path}/peopleTrain/applyList.do" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">报名列表</span></a></li>
                        <%}%>
                        <%if (trianUserListButton) {%>
                        <li><a href="${path}/peopleTrain/peopleTrainList.do" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">用户注册列表</span></a></li>
                        <%}%>
                    </ul>
                </li>

                <%-- <li>
                    <a href="${path}/help.do" target="main" class="tree-node tree-index">
                        <span class="tree-icon"></span><span class="tree-title">使用帮助</span>
                    </a>
                </li> --%>
            </ul>
        </div>
        <div class="left-statistic">
            <ul>
                <li><i></i><a href="#"></a></li>
            </ul>
        </div>
    </div>
</div>
<script type="text/javascript">
    $(function () {
        var selectUls = $(".tree-selected");
        for (var i = 0; i < selectUls.length; i++) {
            var selectUl = selectUls[i];
            if ($(selectUl).find("a[target='main']").length <= 0) {
                $(selectUl).hide();
            }
        }

        var selectUs = $(".tree-child");
        for (var j = 0; j < selectUs.length; j++) {
            var selectU = selectUs[j];
            if ($(selectU).find("a[target='main']").length <= 0) {
                $(selectU).parent().hide();
            }
        }
    });
    
	function toIndex(){
		<%if (whyIndex) {%>
			$('#main', window.parent.document).attr("src","${path}/loading.do");
			setTimeout(function(){
				$('#main', window.parent.document).attr("src","${path}/right.do");
			},100)
		<%}else{%>
			$('#main', window.parent.document).attr("src","${path}/right.do");
		<%}%>
	}     
</script>
</body>
</html>

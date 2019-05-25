<%@ page import="com.sun3d.why.model.SysUser" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
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
                <%if (whyStatistics) {%>
                <%--<li>
                    <a href="javascript:;" class="tree-node">
                        <span class="tree-icon tree-collapsed"></span><span class="tree-title">数据管理</span>
                    </a>
                    <ul class="tree-child" style="display: none;">
                        <li><a href="${path}/statistics/activityStatistic.do" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">活动统计</span></a></li>
                        <li><a href="${path}/statistics/venueStatistic.do" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">场馆活动室统计</span></a></li>
                        <li><a href="${path}/statistics/userStatistic.do" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">用户统计</span></a></li>
                        <li><a href="${path}/statistics/browseStatistic.do" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">流量统计</span></a></li>
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
                </li>--%>
                <li>
                    <a href="javascript:;" class="tree-node">
                        <span class="tree-icon tree-collapsed"></span><span class="tree-title">数据查看</span>
                    </a>
                    <ul class="tree-child" style="display: none;">
                        <li>
                            <a href="${path}/activityStatistics/activityRoutineStatistics.do" target="main">
                                <span class="tree-line"></span>
                                <span class="tree-icon"></span>
                                <span class="tree-title">活动常规统计</span>
                            </a>
                        </li>
                        <li>
                            <a href="${path}/activityStatistics/activityAreaStatisticsIndex.do" target="main">
                            <span class="tree-line"></span>
                            <span class="tree-icon"></span>
                            <span class="tree-title">区县数据</span>
                            </a>
                        </li>
                        <li>
                            <a href="${path}/activityStatistics/activityTypeStatisticsIndex.do" target="main">
                            <span class="tree-line"></span>
                            <span class="tree-icon"></span>
                            <span class="tree-title">类型数据</span>
                            </a>
                        </li>
                        <li>
                            <a target="main" href="${path}/Statistic/flowStatistic.do">
                            <span class="tree-line"></span>
                            <span class="tree-icon"></span>
                            <span class="tree-title">访问统计</span>
                        </a>
                        </li>
                    </ul>
                </li>
                <%}%>
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

                <li>
                    <a href="javascript:;" class="tree-node">
                        <span class="tree-icon tree-collapsed"></span><span class="tree-title">培训管理</span>
                    </a>
                    <ul class="tree-child" style="display: none;">
                        <%if (addTrainButton) {%>
                        <li><a href="${path}/train/add.do" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">发布培训</span></a></li>
                        <%}%>
                        <%if (trainListButton) {%>
                        <li><a href="${path}/train/trainList.do?trainStatus=1" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">培训列表</span></a></li>
                        <%}%>
                        <%if (trainDraftButton) {%>
                        <li><a href="${path}/train/trainList.do?trainStatus=2" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">草稿箱</span></a></li>
                        <%}%>
                        <%if (trainCommentPreListButton) {%>
                        <li><a target="main" href="${path}/train/trainCommentPreList.do"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">评论管理</span></a></li>
                        <%}%>
                        <%if (allTrainOrderListButton) {%>
                        <li><a target="main" href="${path}/train/allTrainOrderList.do"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">报名管理</span></a></li>
                        <%}%>
                    </ul>
                </li>

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
                            </ul>
                        </li>
                               <%-- <%
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
                                %>--%>
                            </ul>
                        </li>
				
                <li>
                    <a href="javascript:;" class="tree-node"><span class="tree-icon tree-collapsed"></span><span
                            class="tree-title">社团管理</span></a>
                    <ul class="tree-child" style="display: none;">
                    	<%if (assnIndexButton) {%>
                        <li>
                            <a target="main" href="${path}/association/assnIndex.do">
                                <span class="tree-line"></span>
                                <span class="tree-icon"></span>
                                <span class="tree-title">社团列表</span>
                            </a>
                        </li>
                        <%}%>
                        <%if (assnApplyIndexButton) {%>
                        <li class="tree-node-last">
                            <a target="main" href="${path}/association/associationApplyIndex.do">
                                <span class="tree-line"></span>
                                <span class="tree-icon"></span>
                                <span class="tree-title">社团申请列表</span>
                            </a>
                        </li>
                        <%}%>
                        <%if (recruitApplyIndexButton) {%>
                        <li class="tree-node-last">
                            <a target="main" href="${path}/association/recruitApplyIndex.do">
                                <span class="tree-line"></span>
                                <span class="tree-icon"></span>
                                <span class="tree-title">社团招募列表</span>
                            </a>
                        </li>
                        <%}%>
                    </ul>
                </li>

                <%
                    if (activityRoomIndexButton) {
                %>
                <li>
                    <a href="javascript:;" class="tree-node">
                        <span class="tree-icon tree-collapsed"></span><span class="tree-title">活动室管理</span>
                    </a>
                    <ul class="tree-child" style="display: none;">

                        <li class="tree-node-last"><a target="main"
                                                      href="${path}/activityRoom/activityRoomIndex.do"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">活动室列表</span></a></li>

                        <%
                            if (activityRoomAddButton) {
                        %>
                        <li><a target="main" href="${path}/activityRoom/preAddActivityRoom.do"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">新建活动室</span></a></li>
                        <%
                            }
                        %>
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
                <%
                    }
                %>
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
                        <li class="tree-selected">
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
                                                              href="${path}/terminalUser/terminalUserIndex.do?userIsDisable=0"><span
                                        class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">待激活</span></a></li>
                                <%}%>
                            </ul>
                        </li>
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


                <li>
                    <a href="javascript:;" class="tree-node">
                        <span class="tree-icon tree-collapsed"></span><span class="tree-title">文化志愿者</span>
                    </a>
                    <ul class="tree-child" style="display: none;">
                        <li>
                            <a href="javascript:;" class="tree-node tree-node2"><span class="tree-line"></span><span
                                    class="tree-icon tree-collapsed"></span><span class="tree-title">志愿者活动</span></a>
                            <ul class="tree-child2" style="display: none;">
                                <li>
                                    <a href="${path}/newVolunteerActivity/queryNewVolunteerActivityList.do" target="main">
                                        <span class="tree-line"></span><span class="tree-icon"></span><span class="tree-title">活动管理</span>
                                    </a>
                                </li>
                                <li>
                                    <a href="${path}/newVolunteerActivity/queryNewVolunteerActivityBusinessList.do" target="main">
                                        <span class="tree-line"></span><span class="tree-icon"></span><span class="tree-title">业务管理</span>
                                    </a>
                                </li>
                            </ul>
                        </li>
                        <li>
                            <a href="${path}/newVolunteer/volunteerManager.do" target="main">
                                <span class="tree-line"></span><span class="tree-icon"></span><span class="tree-title">志愿者管理</span>
                            </a>
                        </li>

                    </ul>
                </li>

                <li>
                    <a href="javascript:;" class="tree-node">
                        <span class="tree-icon tree-collapsed"></span><span class="tree-title">运维管理</span>
                    </a>
                    <ul class="tree-child" style="display: none;">                                              
                        <%-- <%if (Information) {%>
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
                        <%}%>
                        <%
                            if (templateTopicButton) {
                        %>
                        <li><a href="${path}/template/templateIndex.do"
                               target="main"><span class="tree-line"></span><span
                                class="tree-icon"></span><span class="tree-title">专题模版管理</span></a></li>
                        <%
                            }
                        %>
                        <%if (contactIndexButton) {%>
                        <li><a href="${path}/contact/contactPage.do" target="main"><span class="tree-line"></span><span
                                class="tree-icon"></span><span class="tree-title">联系我们</span></a></li>
                        <%}%> --%>
                        
                        <%if (commentIndexButton) {%>
                        <li><a href="${path}/comment/commentIndex.do" target="main"><span class="tree-line"></span><span
                                class="tree-icon"></span><span class="tree-title">评论管理</span></a></li>
                        <%}%>

                        <%if (dictIndexButton) {%>
                        <li><a href="${path}/sysdict/dictIndex.do" target="main"><span class="tree-line"></span><span
                                class="tree-icon"></span><span class="tree-title">字典管理</span></a></li>
                        <%}%>
                        
                        <%if (sensitiveWordsIndexButton) {%>
                        <li><a href="${path}/sensitiveWords/sensitiveWordsIndex.do" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">敏感词管理</span></a></li>
                        <%}%>
                       
                        <%if (tagListButton) {%>
                        <li>
                            <a href="javascript:;" class="tree-node tree-node2"><span class="tree-line"></span><span
                                    class="tree-icon tree-collapsed"></span><span class="tree-title">标签管理</span></a>
                            <ul class="tree-child2" style="display: none;">
                                <li><a target="main" href="${path}/tag/tagList.do?tagType=2"><span
                                        class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">活动类型</span></a></li>
                                <li><a target="main" href="${path}/tag/tagList.do?tagType=3"><span
                                        class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">场馆类型</span></a></li>
                                <li class="tree-node-last"><a target="main" href="${path}/tag/tagList.do?tagType=4"><span
                                        class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">活动室类型</span></a></li>
                                <li class="tree-node-last"><a target="main"
                                                              href="${path}/tag/tagList.do?tagType=6"><span
                                        class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">社团性质</span></a></li>
                                <li><a target="main" href="${path}/tag/tagList.do?tagType=10"><span
                                        class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">培训类型</span></a></li>
                            </ul>
                        </li>
                        <%}%>


                        
                        <%-- <%if (messageIndexButton) {%>
                        <li><a href="${path}/message/messageIndex.do" target="main"><span class="tree-line"></span><span
                                class="tree-icon"></span><span class="tree-title">系统消息</span></a></li>
                        <%}%>

                        <%if (importNearSynonym) {%>
                        <li><a href="${path}/nearSynonym/nearSynonymIndex.do"
                               target="main"><span class="tree-line"></span><span
                                class="tree-icon"></span><span class="tree-title">近义词导入</span></a></li>
                        <%}%>

                        <%if (heritageIndexButton) {%>
                        <li>
                            <a href="${path}/heritage/heritageIndex.do" target="main">
                                <span class="tree-line"></span><span class="tree-icon"></span><span class="tree-title">非遗管理</span>
                            </a>
                        </li>
                        <%}%>
	                	
	                	 <%if (volunteerIndexButton) {%>
	                        <li>
	                        	<a href="${path}/volunteer/volunteerApplyIndex.do" target="main">
		                        	<span class="tree-line"></span><span class="tree-icon"></span><span class="tree-title">文化志愿者管理</span>
	                        	</a>
	                        </li>
	                	<%}%>
	                		
	                	 <%if (userbehaviorAnalysisButton) {%>
	                        <li>
	                        	<a href="${path}/terminalUser/userbehaviorAnalysisIndex.do" target="main">
		                        	<span class="tree-line"></span><span class="tree-icon"></span><span class="tree-title">用户行为分析</span>
	                        	</a>
	                        </li>
	                	<%}%>	                		                	                                                                   
                        
                        <%if (ticketMachineIndex) {%>
	                        <li>
	                        	<a href="${path}/ticketMachine/list.do" target="main">
		                        	<span class="tree-line"></span><span class="tree-icon"></span><span class="tree-title">取票机管理</span>
	                        	</a>
	                        </li>
	                	 <%}%>
	                		                	
                        <%if (sendSMSIndex) {%>
                        <li><a href="${path}/sendSMS/sendSMSIndex.do"
                               target="main"><span class="tree-line"></span><span
                                class="tree-icon"></span><span class="tree-title">后台发送短信</span></a></li>
                        <%}%>                       
                        
                       <%if (volunteerVenueManageIndex) {%>
                        <li><a href="${path}/volunteerVenueManage/volunteerVenueManageIndex.do"
                               target="main"><span class="tree-line"></span><span class="tree-icon"></span><span class="tree-title">志愿者场馆管理</span></a></li>
                        <%}%>		

                            <%if (virtuosityIndex) {%>
                        <li><a href="${path}/virtuosity/virtuosityIndex.do"
                               target="main"><span class="tree-line"></span><span class="tree-icon"></span><span class="tree-title">艺术鉴赏管理</span></a></li>
                        <%}%> --%>
                    </ul>

                <%--  <%if ((contestQuizIndex || voteIndex || applicationContestConfigIndexButton)) {%>
                <li>
                    <a href="javascript:;" class="tree-node">
                        <span class="tree-icon tree-collapsed"></span><span class="tree-title">文化云应用大赛</span>
                    </a>
                    <ul class="tree-child" style="display: none;">
                        <%
                            if (contestQuizIndex) {
                        %>
                        <li><a href="http://fs.gd.wenhuayun.cn/contestTopic/contestQuizIndex.do"
                               target="main"><span class="tree-line"></span><span
                                class="tree-icon"></span><span class="tree-title">知识问答</span></a></li>
                        <%
                            }
                        %>
                        <%
                            if (voteIndex) {
                        %>
                        <li><a href="http://fs.gd.wenhuayun.cn/vote/voteIndex.do"
                               target="main"><span class="tree-line"></span><span
                                class="tree-icon"></span><span class="tree-title">线上投票</span></a></li>
                        <%
                            }
                        %>
                        <%
                            if (applicationContestConfigIndexButton) {
                        %>
                        <li><a href="http://fs.gd.wenhuayun.cn/applicationContestConfig/index.do"
                               target="main"><span class="tree-line"></span><span
                                class="tree-icon"></span><span class="tree-title">应用大赛配置管理</span></a></li>
                        <%
                            }
                        %>
                    </ul>
                </li>
                <%}%>--%>
                <%if (appAdvertRecommendIndexButton) {%>
                <li>
                    <a href="javascript:;" class="tree-node">
                        <span class="tree-icon tree-collapsed"></span><span class="tree-title">推荐管理</span>
                    </a>
                    <ul class="tree-child" style="display: none;">
                        <li>
                            <a href="javascript:;" class="tree-node tree-node2"><span class="tree-line"></span><span
                                    class="tree-icon tree-collapsed"></span><span class="tree-title">Web端推荐</span></a>
                            <ul class="tree-child2" style="display: none;">
                                <%if (webAdvertIndexButton) {%>
                                <li><a href="${path}/ccpAdvert/advertIndex.do" target="main"><span
                                        class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">轮播图管理</span></a></li>
                                <%}%>
                                
                                <%if (webHomeNavigationRecommendButton) {%>
                                <li class="tree-node-last"><a target="main"
                                                              href="${path}/ccpAdvert/frontAdvertIndex.do"><span
                                        class="tree-line"></span><span
                                        class="tree-icon"></span><span class="tree-title">首页栏目推荐</span></a></li>
                                <%}%>
                            </ul>
                        </li>
                        
                        <li>
                            <a href="javascript:;" class="tree-node tree-node2"><span class="tree-line"></span><span
                                    class="tree-icon tree-collapsed"></span><span class="tree-title">H5端推荐</span></a>
                            <ul class="tree-child2" style="display: none;">
                                <li>
                                    <a href="javascript:;" class="tree-node tree-node2"><span class="tree-line"></span><span
                                            class="tree-icon tree-collapsed"></span><span class="tree-title">首页-运营位管理</span></a>
                                    <ul class="tree-child2" style="display: none;">
                                        <%if (apprecommendRelateButton) {%>
                                        <li><a target="main" href="${path}/recommendRelate/recommendIndex.do"><span
                                                class="tree-line"></span><span class="tree-icon"></span><span
                                                class="tree-title">活动推荐置顶</span></a></li>
                                        <%}%>
                                        
                                        <%if (apprecommendRelateTopButton) {%>
                                      <%--   <li><a target="main" href="${path}/recommendRelate/activityIndex.do"><span
                                                class="tree-line"></span><span class="tree-icon"></span><span
                                                class="tree-title">活动标签置顶</span></a></li> --%>
                                        <li><a href="${path}/ccpAdvert/appFrontAdvertIndex.do"
                                               target="main"><span class="tree-line"></span><span
                                                class="tree-icon"></span><span class="tree-title">运营位管理</span></a></li>

                                        <%-- <li class="tree-node-last"><a href="${path}/advertCalendar/appAdvertCalendarIndex.do"
                                               target="main"><span class="tree-line"></span><span
                                                class="tree-icon"></span><span class="tree-title">日历广告位</span></a></li> --%>
                                        <%}%>
                                        
                                        <%if (appAdvertRecommendIndexButton) {%>
                                    </ul>
                                </li>

                                <li><a href="${path}/ccpAdvert/appSpaceAdvertIndex.do"
                                       target="main"><span class="tree-line"></span><span
                                        class="tree-icon"></span><span class="tree-title">空间-运营位管理</span></a></li>
                                <%-- <li class="tree-node-last"><a href="${path}/advertRecommend/appAdvertRecommendIndex.do"
                                                              target="main"><span class="tree-line"></span><span
                                        class="tree-icon"></span><span class="tree-title">活动-运营位管理</span></a></li> --%>
                                <%}%>
                            </ul>
                        </li>
                        <%-- <li class="tree-node-last"><a href="${path}/ccpAdvert/appHotWordIndex.do"
                                                      target="main"><span class="tree-line"></span><span
                                class="tree-icon"></span><span class="tree-title">热门搜索设置</span></a></li> --%>
                    </ul>
                </li>
                <%}%>
                
                <li>
                    <a href="javascript:;" class="tree-node">
                        <span class="tree-icon tree-collapsed"></span><span class="tree-title">站点管理</span>
                    </a>
                    <ul class="tree-child" style="display: none;">
                        <%if (sysUserIndexButton) {%>
                        <li><a href="${path}/user/sysUserIndex.do" target="main"><span class="tree-line"></span><span
                                class="tree-icon"></span><span class="tree-title">管理员列表</span></a></li>
                        <%}%>
                        
                        <%if (sysUserAddButton) {%>
                        <li><a href="${path}/user/preAddSysUser.do" target="main"><span class="tree-line"></span><span
                                class="tree-icon"></span><span class="tree-title">新建管理员</span></a></li>
                        <%}%>
                        
                        <%if (departmentIndexButton) {%>
                        <li><a href="${path}/dept/deptIndex.do" target="main"><span class="tree-line"></span><span
                                class="tree-icon"></span><span class="tree-title">部门列表</span></a></li>
                        <%}%>
                        
                        <%if (roleIndexButton) {%>
                        <li><a href="${path}/role/roleIndex.do" target="main"><span class="tree-line"></span><span
                                class="tree-icon"></span><span class="tree-title">角色列表</span></a></li>
                        <%}%>
                        
                        <%if (preInitModuleButton) {%>
                        <li><a href="${path}/module/preInitModule.do" target="main"><span class="tree-line"></span><span
                                class="tree-icon"></span><span class="tree-title">权限初始化</span></a></li>
                        <%}%>
                        
                        <%if (userFanKuiButton) {%>
                        <li><a href="${path}/feedInformation/feedIndex.do" target="main"><span class="tree-line"></span><span
                                class="tree-icon"></span><span class="tree-title">用户反馈</span></a></li>
                        <%}%>
                        
                        <%if (shareDeptIndexButton) {%>
                        <li class="tree-node-last"><a href="${path}/shareDept/shareDeptIndex.do" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">信息共享</span></a></li>
                        <%}%>

                        <%if (informationModuleButton) {%>
                        <li><a href="${path}/ccpInformationModule/informationModuleIndex.do" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">资讯模块配置</span></a></li>
                        <%}%>
                    </ul>
                </li>

                <!-- 资讯类权限 -->
                <c:forEach items="${sessionScope.user.sysModuleList}" var="module">
                    <c:if test="${fn:contains(module.moduleUrl,'${path}/ccpInformation/informationIndex.do?informationModuleId=')}">
                        <li>
                            <a href="javascript:;" class="tree-node"> <span
                                    class="tree-icon tree-collapsed"></span><span class="tree-title">${module.moduleName}</span>
                            </a>
                            <ul class="tree-child" style="display: none;">
                                <li><a href="${path}/ccpInformation/informationIndex.do?informationModuleId=${module.moduleRemark}"
                                       target="main"><span class="tree-line"></span><span
                                        class="tree-icon"></span><span class="tree-title">${module.moduleName}列表</span></a></li>
                                <li class="tree-node-last"><a
                                        href="${path}/ccpInformationType/informationTypeIndex.do?informationModuleId=${module.moduleRemark}"
                                        target="main"><span class="tree-line"></span><span
                                        class="tree-icon"></span><span class="tree-title">${module.moduleName}类型管理</span></a></li>
                            </ul>
                        </li>
                    </c:if>
                </c:forEach>
              <%--  <!--文化文物 -->
				 <li>
                    <a href="javascript:;" class="tree-node">
                        <span class="tree-icon tree-collapsed"></span><span class="tree-title">文化文物管理</span></a>
                        <ul class="tree-child" style="display: none;">
                    	<% if (bpAntiquePrePublishButton) {%>
                                <li><a target="main" href="${path}/bpAntique/prePublishAntique.do">
                                <span class="tree-line"></span>
                                <span class="tree-icon"></span><span class="tree-title">发布文化文物</span></a></li>                               
                                <% }%>
                        <%if (bpAntiqueListButton) {%>
                        <li class="tree-node-last"><a target="main" href="${path}/bpAntique/antiqueIndex.do">
                                <span class="tree-line"></span>
                                <span class="tree-icon"></span><span class="tree-title">文化文物列表</span></a></li>   
                        <%}%>
                    </ul> 
                 </li>--%>
                 
                 <!--文化商城 -->
				<%-- <li>
                    <a href="javascript:;" class="tree-node">
                        <span class="tree-icon tree-collapsed"></span><span class="tree-title">文化商城</span></a>
                        <ul class="tree-child" style="display: none;">
                    	<% if (bpProductPrePublishButton) {%>
                                <li><a target="main" href="${path}/bpProduct/prePublishProduct.do">
                                <span class="tree-line"></span>
                                <span class="tree-icon">
                                </span><span class="tree-title">发布文化商城</span></a></li>
                        <%}%>
                        <%if (bpProductListButton) {%>
                            	<li class="tree-node-last"><a target="main" href="${path}/bpProduct/productIndex.do">
                                <span class="tree-line"></span>
                                <span class="tree-icon"></span><span class="tree-title">文化商城列表</span></a></li>        
                        <%}%>
                    </ul> 
                 </li>--%>
                 
                <!--人文佛山 -->
<%--                <li>--%>
<%--                    <a href="javascript:;" class="tree-node">--%>
<%--                        <span class="tree-icon tree-collapsed"></span><span class="tree-title">动态资讯</span>--%>
<%--                    </a>--%>
<%--                    <ul class="tree-child" style="display: none;">--%>
<%--                        <%if (beipiaoInfoAddButton) {%>--%>
<%--                        <li><a href="${path}/beipiaoInfo/addPage.do" target="main"><span--%>
<%--                                class="tree-line"></span><span class="tree-icon"></span><span--%>
<%--                                class="tree-title">发布动态资讯</span></a></li>--%>
<%--                        <%}%>--%>
<%--                        <%if (beipiaoInfoListButton) {%>--%>
<%--                        <li><a href="${path}/beipiaoInfo/infoList.do" target="main"><span--%>
<%--                                class="tree-line"></span><span class="tree-icon"></span><span--%>
<%--                                class="tree-title">动态资讯列表</span></a></li>--%>
<%--                        <%}%>--%>
<%--                        <%if (beipiaoCarouselListButton) {%>--%>
<%--                        <li><a href="${path}/beipiaoCarousel/carouselList.do?carouselType=1" target="main"><span--%>
<%--                                class="tree-line"></span><span class="tree-icon"></span><span--%>
<%--                                class="tree-title">动态资讯轮播图</span></a></li>--%>
<%--                        <%}%>--%>
<%--                        <%if (beipiaoInfoTagListButton) {%>--%>
<%--                        <li><a href="${path}/beipiaoInfoTag/tagList.do" target="main"><span--%>
<%--                                class="tree-line"></span><span class="tree-icon"></span><span--%>
<%--                                class="tree-title">标签管理</span></a></li>--%>
<%--                        <%}%>--%>
<%--                        <%if (beipiaoReportListButton) {%>--%>
<%--                        <li class="tree-node-last"><a href="${path}/beipiaoInfoReport/reportList.do" target="main"><span--%>
<%--                                class="tree-line"></span><span class="tree-icon"></span><span--%>
<%--                                class="tree-title">举报管理</span></a></li>--%>
<%--                        <%}%>--%>
<%--                    </ul>--%>
<%--                </li>--%>

                <!--精彩赏析 -->
<%--                <%if (ysjsButton) {%>--%>
<%--                <li>--%>
<%--                    <a href="javascript:;" class="tree-node">--%>
<%--                        <span class="tree-icon tree-collapsed"></span><span class="tree-title">艺术鉴赏 </span>--%>
<%--                    </a>--%>
<%--                    <ul class="tree-child" style="display: none;">--%>
<%--                        <li><a href="${path}/beipiaoInfo/addPage.do?module=YSJS" target="main"><span--%>
<%--                                class="tree-line"></span><span class="tree-icon"></span><span--%>
<%--                                class="tree-title">发布艺术鉴赏 </span></a></li>--%>
<%--                        <li><a href="${path}/beipiaoInfo/infoList.do?module=YSJS" target="main"><span--%>
<%--                                class="tree-line"></span><span class="tree-icon"></span><span--%>
<%--                                class="tree-title">艺术鉴赏列表</span></a></li>--%>
<%--                        &lt;%&ndash;<li><a href="${path}/beipiaoInfoTag/tagList.do?module=YSJS" target="main"><span--%>
<%--                                class="tree-line"></span><span class="tree-icon"></span><span--%>
<%--                                class="tree-title">类型管理</span></a></li>&ndash;%&gt;--%>
<%--                    </ul>--%>
<%--                </li>--%>
<%--                <%}%>--%>

                <%--<!--影视天地 -->
                <%if (ystdButton) {%>
                <li>
                    <a href="javascript:;" class="tree-node">
                        <span class="tree-icon tree-collapsed"></span><span class="tree-title">影视天地 </span>
                    </a>
                    <ul class="tree-child" style="display: none;">
                        <li><a href="${path}/beipiaoInfo/addPage.do?module=YSTD" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">发布影视天地 </span></a></li>
                        <li><a href="${path}/beipiaoInfo/infoList.do?module=YSTD" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">影视天地列表</span></a></li>
                        &lt;%&ndash;<li><a href="${path}/beipiaoInfoTag/tagList.do" target="main"><span&ndash;%&gt;
                                &lt;%&ndash;class="tree-line"></span><span class="tree-icon"></span><span&ndash;%&gt;
                                &lt;%&ndash;class="tree-title">类型管理</span></a></li>&ndash;%&gt;
                    </ul>
                </li>
                <%}%>--%>
                <!--文化创意 -->
                <%--<%if (whcyButton) {%>
                <li>
                    <a href="javascript:;" class="tree-node">
                        <span class="tree-icon tree-collapsed"></span><span class="tree-title">文化创意 </span>
                    </a>
                    <ul class="tree-child" style="display: none;">
                        <li><a href="${path}/beipiaoInfo/addPage.do?module=WHCY" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">发布文化创意 </span></a></li>
                        <li><a href="${path}/beipiaoInfo/infoList.do?module=WHCY" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">文化创意列表</span></a></li>
                        &lt;%&ndash;<li><a href="${path}/beipiaoInfoTag/tagList.do" target="main"><span&ndash;%&gt;
                        &lt;%&ndash;class="tree-line"></span><span class="tree-icon"></span><span&ndash;%&gt;
                        &lt;%&ndash;class="tree-title">类型管理</span></a></li>&ndash;%&gt;
                    </ul>
                </li>
                <%}%>--%>

                <%--<li>
                    <a href="javascript:;" class="tree-node">
                        <span class="tree-icon tree-collapsed"></span><span class="tree-title">文化联盟</span>
                    </a>
                    <ul class="tree-child" style="display: none;">
                        <%if (leagueCarouselButton) {%>
                        <li><a href="${path}/beipiaoCarousel/carouselList.do?carouselType=2" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">文化联盟轮播图</span></a></li>
                        <%}%>
                        <%if (leagueListButton) {%>
                        <li><a href="${path}/league/list.do" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">联盟列表</span></a></li>
                        <%}%>
                        <%if (memberListButton) {%>
                        <li><a href="${path}/member/list.do" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">成员列表</span></a></li>
                        <%}%>
                        <%if (leagueTypeListButton) {%>
                        <li><a href="${path}/tag/tagList.do?tagType=7" target="main"><span
                                class="tree-line"></span><span class="tree-icon"></span><span
                                class="tree-title">联盟类型</span></a></li>
                        <%}%>
                    </ul>
                </li>--%>
                <%--<%if (orderAttendListBtn || orderAttendOrderListBtn || orderInviteListBtn || orderInviteOrderListBtn) { %>
                <li>
                    <a href="javascript:;" class="tree-node">
                        <span class="tree-icon tree-collapsed"></span><span class="tree-title">文化点单</span>
                    </a>
                    <ul class="tree-child" style="display: none;">
                    	<%if (orderAttendListBtn || orderAttendOrderListBtn) {%>
                        <li class="tree-selected">
                            <a href="javascript:;" class="tree-node tree-node2">
                                <span class="tree-line"></span><span class="tree-icon tree-collapsed"></span><span
                                    class="tree-title">我要参与</span>
                            </a>
                            <ul class="tree-child2" style="display: none;">
                            	<%if (orderAttendListBtn) {%>
                                <li><a target="main" href="${path}/culturalOrder/culturalOrderList.do?culturalOrderLargeType=1"><span
                                        class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">我要参与列表</span></a></li>
                                <%} %>
                                <%if (orderAttendOrderListBtn) {%>
                                <li class="tree-node-last"><a target="main" href="${path}/culturalOrderOrder/culturalOrderOrderList.do?culturalOrderLargeType=1"><span 
                                		class="tree-line"></span><span class="tree-icon"></span><span 
                                		class="tree-title">点单列表</span></a></li>
                                <%} %>
                            </ul>
                         </li>
                         <%} %>
                         	<%if (orderInviteListBtn || orderInviteOrderListBtn) {%>
                          <li class="tree-selected">
                          	 <a href="javascript:;" class="tree-node tree-node2">
                                <span class="tree-line"></span><span class="tree-icon tree-collapsed"></span><span
                                    class="tree-title">我要邀请</span>
                              </a>
                             <ul class="tree-child2" style="display: none;">
                             	<%if (orderInviteListBtn) {%>
                                <li><a target="main" href="${path}/culturalOrder/culturalOrderList.do?culturalOrderLargeType=2"><span
                                        class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">我要邀请列表</span></a></li>
                                 <%} %>
                                 <%if (orderInviteOrderListBtn) {%>
                                <li class="tree-node-last"><a target="main" href="${path}/culturalOrderOrder/culturalOrderOrderList.do?culturalOrderLargeType=2"><span
                                        class="tree-line"></span><span class="tree-icon"></span><span
                                        class="tree-title">点单列表</span></a></li>
                                 <%} %>
                            </ul>
                        </li>
                        <%} %>
                    </ul>
                </li>
                <%} %>--%>
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
</script>
</body>
</html>

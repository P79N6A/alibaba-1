<%@ page import="java.util.Date" %>
<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>活动列表--文化嘉定云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>

</head>
<body>
<form id="activityForm" action="" method="post">

<div class="main-content">
    <table width="100%">
        <thead>
        <tr>
            <th >ID</th>
            <th class="title">活动名称</th>
            <th>选座方式</th>
            <th>放票总数</th>
            <th>有效订单票数</th>
            <th class="venue">redis余票数量</th>
            <th>数据库余票数量</th>
            <th>同步后可以预定票数</th>
            <th>时间场次</th>
            <th>管理</th>
        </tr>
        </thead>

        <tbody>
        <%int i=0;%>
        <c:forEach items="${activityList}" var="avct">
            <%i++;%>
            <tr>
                <td ><%=i%></td>

                <td class="title">
<%--                    <c:if test="${not empty avct.activityName}">
                        <c:if test="${not empty avct.linkUrl}" >
                            <a target="_blank" title="${avct.activityName}" href="${avct.linkUrl}">
                                <c:set var="activityName" value="${avct.activityName}"/>
                                <c:out value="${fn:substring(activityName,0,19)}"/>
                                <c:if test="${fn:length(activityName) > 19}">...</c:if>
                            </a>
                        </c:if>--%>

                            <a target="_blank" title="${avct.activityName}" href="${path}/frontActivity/frontActivityDetail.do?activityId=${avct.activityId}">
                                <c:set var="activityName" value="${avct.activityName}"/>
                                <c:out value="${fn:substring(activityName,0,19)}"/>
                                <c:if test="${fn:length(activityName) > 19}">...</c:if>
                            </a>


                </td>
                <td>
                    <c:choose>
                        <c:when test="${avct.type == 'Y'}">
                            在线选座
                        </c:when>
                        <c:otherwise>
                            自由入座
                        </c:otherwise>
                    </c:choose>

                </td>
                <td>${avct.totalCount}</td>
                <td>${avct.bookCount}</td>
                <td>${avct.redisCount}</td>
                <td>${avct.dataBaseCount}</td>
                <td>${avct.rightCount}</td>
                <td>${avct.eventDateTime}</td>
                <td><a href="javascript:setRightToRedisAndDataBase('${avct.activityId}','${avct.eventId}');">同步票数</a></td>
            </tr>
        </c:forEach>
        <c:if test="${empty activityList}">
            <tr>
                <td colspan="5"> 暂无数据!</td>
            </tr>
        </c:if>
        </tbody>
    </table>
</div>

    <script type="text/javascript" >
        function setRightToRedisAndDataBase(activityId,eventId) {
            $.get("${path}/activity/setActivityDataBaseAndRedisCount.do",{"activityId" :activityId,"eventId" : eventId}, function(rsData) {
                if (rsData == 'success') {
                    window.location.reload();
                } else {
                    dialogAlert("提示", "操作失败:" + rsData);
                    window.location.reload();
                }
            });
        }

    </script>
</form>
</body>
</html>
<%@ page import="org.apache.commons.lang3.StringUtils ,com.sun3d.why.model.CmsTerminalUser" %>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
    String userId = "";
    if (session.getAttribute("terminalUser") != null) {
        CmsTerminalUser terminalUser = (CmsTerminalUser) session.getAttribute("terminalUser");
        userId = terminalUser.getUserId();
        if (StringUtils.isNotBlank(terminalUser.getUserId())) {
            userId = terminalUser.getUserId();
        } else {
            userId = "";
        }
    }
%>
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <!-- 导入头部文件 start -->
    <meta charset="UTF-8">
    <%@include file="/WEB-INF/why/common/frontPageFrame.jsp" %>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/hsCulture.css"/>
    <title>${cmsActivity.activityName}${listL}_更多免费活动_品质生活-文化云</title>
    <meta name="Keywords" content="${cmsActivity.activityName}、地址、时间、电话、公交、简介、免费、免费预订、免费参与">
    <style>
        .basicDiv{
            width:1200px;
            height:400px;
            margin:0 auto 20px;
            background-color: #fff;
        }
        .volunteerImg{
            float:left;
            height:392px;
            width:490px;
            margin-right:40px;
            border:1px solid #C0EBEF;
        }
        .volunteerDetails{
            float:left;
            height:392px;
            width:620px;
            margin-right:20px;
        }
        .volunteerTitle{
            margin:20px;
        }
        .volunteerDetail{
            margin:30px 20px 20px 20px;
        }
        .volunteerDetail p{
            color:#766e6e;
            margin-bottom:15px;
            font-size: 15px;
        }
        .volunteerDetail a{

        }
        .sign{
            float:left;
            margin-right:20px;
            margin-left:20px;
            width:100px;
            height:30px;
            line-height:30px;
            text-align:center;
            border:1px solid #00a0e9;
            background-color:#00a0e9;
            margin-top:15px;
            border-radius: 5%;
        }
        .otherInform{
            width:100%;
            height:auto;
            margin:0 auto 20px;
            background-color: #fff;
        }
        .otherInform .tabBtn{
            width:100%;
            height:50px;
            border-bottom: 1px solid #c0c0c0;
        }
        .tabMenu li{
            float:left;
            line-height:30px;
            font-size:20px;
            padding:10px;
            cursor: pointer;
        }
        .tabMenu .cur{
            /*border:1px solid #00a0e9;*/
            color:#00a0e9;
        }
        .tabContent{
            padding:10px;
        }
        .tabContent p{
            line-height:20px;
        }
        .volunteerComment{
            width:100%;
            height:200px;
            background-color: #fff;
        }
        .commentBtn{
            margin-left:20px;
            width:100px;
            height:30px;
            line-height:30px;
            text-align:center;
            border:1px solid #00a0e9;
            background-color:#00a0e9;
            margin-top:10px;
            margin-bottom:20px;
            border-radius: 5%;
            float:right;
            margin-right:100px;
        }
        .xqdiv{
            height:auto;
            padding:20px;
        }
        .documentorydiv{
            height:auto;
            padding:20px;
        }
        .annexdiv{
            height:auto;
            padding:20px;
        }
        .showDocumentImg{
            width:300px;
            height:350px;
            text-align: center;
        }
        .showDocumentImg img{
            width:100%;
            height:300px;
        }
        .showDocumentImg audio{
            width:100%;
            height:300px;
        }
        .showDocumentImg video{
            width:100%;
            height:300px;
        }
        .showDocumentImg p{
            width:100%;
            line-height:50px;
        }
    </style>
</head>
<body>
<div class="header">
    <%@include file="../header.jsp" %>
</div>
<c:set var="volunteerActivity" value="${volunteerActivity}"></c:set>
<div class="main" style=" min-height: 500px;">
<c:forEach items="${volunteerActivityList}" varStatus="s" var="volunteerActivity">
    <div class="basicDiv">
        <div class="volunteerImg">
            <img style="width:100%;height:100%" src="${volunteerActivity.picUrl}"/>
        </div>
        <div class="volunteerDetails">
            <div class="volunteerTitle">
                <h1>${volunteerActivity.name}</h1>
            </div>
            <div class="volunteerDetail">
                <p>时间：<fmt:formatDate value="${volunteerActivity.startTime}" pattern="yyyy-MM-dd HH:mm:ss" />
                    <c:if test="${volunteerActivity.startTime != volunteerActivity.endTime&&not empty volunteerActivity.endTime}">
                        至 <fmt:formatDate value="${volunteerActivity.endTime}" pattern="yyyy-MM-dd HH:mm:ss" />
                    </c:if>

                </p>
                <p>地址：${volunteerActivity.address}</p>
                <p>电话：${volunteerActivity.phone}</p>
                <p>报名条件：
                    <c:if test="${volunteerActivity.recruitObjectType == null}">
                        <a style="border:1px solid #00a0e9">个人</a>
                    </c:if>
                    <c:if test="${volunteerActivity.recruitObjectType == 1&&not empty volunteerActivity.recruitObjectType}">
                        <a style="border:1px solid #00a0e9">个人</a>
                    </c:if>
                    <c:if test="${volunteerActivity.recruitObjectType == 2&&not empty volunteerActivity.recruitObjectType}">
                        <a style="border:1px solid #00a0e9">团队</a>
                    </c:if>
                </p>
                <p>预计服务时长：${volunteerActivity.serviceTime}小时</p>
            </div>
        </div>
    </div>
</c:forEach>
</div>
<%@include file="/WEB-INF/why/index/footer.jsp" %>
</body>
</html>

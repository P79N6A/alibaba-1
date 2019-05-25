<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>场馆--文化云</title>
    <%@include file="/WEB-INF/why/common/frontIndexPageFrame.jsp"%>

    <script type="text/javascript" src="${path}/STATIC/js/index/venue/venueIndexFront.js"></script>
</head>
<body>

<%@include file="/WEB-INF/why/index/index_top.jsp"%>

<%--场馆首页banner--%>
<div id="venue_banner">
    <div class="venue_banner">

    </div>
</div>
<%--场馆首页主体内容部分--%>
<div id="venue_content">
    <input type="hidden" value="${path}" id="path"/>
    <%--场馆首页搜索标签--%>
    <div id="search_more" class="clearfix">
        <c:forEach items="${typeList}" var="c">
            <a href="javascript:;" data-option="${c.tagId}">${c.tagName}</a>
        </c:forEach>
        <a href="${path}/frontVenue/venueList.do">更多</a>
    </div>
    <%--场馆首页列表页--%>
    <div id="venueListDiv">
    </div>
    <%--分页所用参数、初始为1--%>
    <input type="hidden" id="reqPage"  value="1">
</div>

<%@include file="../index_below.jsp"%>

</body>
</html>


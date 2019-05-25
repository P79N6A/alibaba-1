<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>首页--文化云</title>
	<%@include file="/WEB-INF/why/common/frontIndexPageFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/hsCulture.css"/>
	<script type="text/javascript" src="${path}/STATIC/js/index/activity/venueBookIndex.js"></script>
</head>
<body>

<!-- 导入头部top文件 start -->

<div class="header">
	<%@include file="../header.jsp" %>
</div>

<input type="hidden" id="type" value="3"/>
<input type="hidden" id="disableSort" value="Y"/>

<div class="crumb">您所在的位置：<a href="${path}/frontIndex/index.do">首页</a>&gt;<a href="#">上海图书馆</a></div>
<div class="venue_list_content">
	<div class="libra_banner">
		<img src="${path}/STATIC/image/libra_03_img.jpg" />
	</div>

	<form action="${path}/frontActivity/frontActivityDetail.do"  id="activityDetailForm" method="post">
		<input type="hidden" id="venueId" name="venueId"/>
		<input type="hidden" id="venueName" name="venueName"/>
		<input type="hidden" id="activityId" name="activityId"/>
		<input type="hidden" id="keywordVal" value="${keyword}"/>
	</form>

	<div id="search" style="display: none">
		<%--<div class="search">
            <div class="prop-attrs">
                <div class="attr">
                    <div class="attrKey">场馆</div>
                    <div class="attrValue" id="area_div">
                        <ul class="av-expand" style="margin-left:20px; margin-right: 20px;">
                            <li class="w162"><a href="javascript:searchVenueList(1);" data-option='青浦区图书馆'>青浦区图书馆</a></li>
                            <li class="w162"><a href="javascript:searchVenueList(1);" data-option='普陀区图书馆'>普陀区图书馆</a></li>
                            <li class="w162"><a href="javascript:searchVenueList(1);" data-option="嘉定区图书馆">嘉定区图书馆</a></li>
                            <li class="w162"><a href="javascript:searchVenueList(1);" data-option="长宁区图书馆">长宁区图书馆</a></li>
                            <li class="w162"><a href="javascript:searchVenueList(1);" data-option="闸北区图书馆">闸北区图书馆</a></li>
                            <li class="w162"><a href="javascript:searchVenueList(1);" data-option="静安区图书馆">静安区图书馆</a></li>
                            <li class="cur w162"><a class="cur" href="javascript:searchVenueList(1);" data-option="">全部</a></li>
                        </ul>

                    </div>
                </div>
            </div>
        </div>--%>
		<div class="search-btn">
			<input type="button" value="搜索" onclick="searchVenueList(1)"/>
		</div>
		<div class="advanced">
			<div class="attr-extra">
				<span>更多选项</span><b></b>
			</div>
		</div>
	</div>

	<div id="activity_content">

	</div>
</div>
<input type="hidden" id="reqPage"  value="1">

<%@include file="/WEB-INF/why/index/footer.jsp" %>

</body>
</html>

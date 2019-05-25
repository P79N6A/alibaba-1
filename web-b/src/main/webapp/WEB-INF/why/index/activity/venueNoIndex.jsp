<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>首页--文化云</title>
	<%@include file="/WEB-INF/why/common/frontIndexPageFrame.jsp"%>
	<script type="text/javascript" src="${path}/STATIC/js/index/activity/venueNoIndex.js"></script>
</head>
<body>

<!-- 导入头部top文件 start -->
<%@include file="../index_top.jsp"%>

<input type="hidden" id="type" value="3"/>
<input type="hidden" id="disableSort" value="Y"/>

<div class="crumb">您所在的位置：<a href="${path}/frontIndex/index.do">首页</a>&gt;<a>数字文化馆</a></div>
<div class="venue_list_content">
	<div class="libra_banner">
		<img src="${path}/STATIC/image/banner_sz.jpg" width="1200" height="530"/>
	</div>
	<div id="search">
		<div class="search search-culture">
			<div class="prop-attrs">
				<div class="attr">
					<div class="attrKey">场馆</div>
					<div class="attrValue" id="area_div">
						<ul class="av-expand">
							<li class="cur"><a href="javascript:searchVenueList(1);" data-option="">全部</a></li>
							<li><a href="javascript:searchVenueList(1);" data-option='上海市群众艺术馆'>上海市群众艺术馆</a></li>
							<li><a href="javascript:searchVenueList(1);" data-option='普陀区甘泉文化馆'>普陀区甘泉文化馆</a></li>
							<li><a href="javascript:searchVenueList(1);" data-option='普陀区桃浦文化馆'>普陀区桃浦文化馆</a></li>
							<li><a href="javascript:searchVenueList(1);" data-option='闵行区群众艺术馆'>闵行区群众艺术馆</a></li>
							<li><a href="javascript:searchVenueList(1);" data-option='崇明县文化馆'>崇明县文化馆</a></li>
							<li><a href="javascript:searchVenueList(1);" data-option='松江区文化馆'>松江区文化馆</a></li>
							<li><a href="javascript:searchVenueList(1);" data-option='静安区文化馆'>静安区文化馆</a></li>
							<li><a href="javascript:searchVenueList(1);" data-option='徐汇区文化馆'>徐汇区文化馆</a></li>
							<li><a href="javascript:searchVenueList(1);" data-option='青浦区文化馆'>青浦区文化馆</a></li>
							<li><a href="javascript:searchVenueList(1);" data-option='浦南文化馆'>浦南文化馆</a></li>
							<li><a href="javascript:searchVenueList(1);" data-option='长宁民俗文化中心'>长宁民俗文化中心</a></li>
							<li><a href="javascript:searchVenueList(1);" data-option='浦东新区文化艺术指导中心'>浦东新区文化艺术指导中心</a></li>
							<li><a href="javascript:searchVenueList(1);" data-option='嘉定区文化馆'>嘉定区文化馆</a></li>
							<li><a href="javascript:searchVenueList(1);" data-option='长宁文化艺术中心'>长宁文化艺术中心</a></li>
							<li><a href="javascript:searchVenueList(1);" data-option='虹口区文化馆'>虹口区文化馆</a></li>
							<li><a href="javascript:searchVenueList(1);" data-option='浦东文化馆'>浦东文化馆</a></li>
							<li><a href="javascript:searchVenueList(1);" data-option='黄浦区文化馆'>黄浦区文化馆</a></li>
							<li><a href="javascript:searchVenueList(1);" data-option='宝山区文化馆'>宝山区文化馆</a></li>
							<li><a href="javascript:searchVenueList(1);" data-option='宝山区罗店文化中心'>宝山区罗店文化中心</a></li>
							<li><a href="javascript:searchVenueList(1);" data-option='奉贤区文化馆'>奉贤区文化馆</a></li>
							<li><a href="javascript:searchVenueList(1);" data-option='普陀区文化馆'>普陀区文化馆</a></li>
							<li><a href="javascript:searchVenueList(1);" data-option='闸北区文化馆'>闸北区文化馆</a></li>
							<li><a href="javascript:searchVenueList(1);" data-option='金山区文化馆'>金山区文化馆</a></li>
							<li><a href="javascript:searchVenueList(1);" data-option='川沙文化馆'>川沙文化馆</a></li>
							<li><a href="javascript:searchVenueList(1);" data-option='杨浦区文化馆'>杨浦区文化馆</a></li>
						</ul>

					</div>
				</div>
			</div>
		</div>
		<div class="search-btn" style="display: none;">
			<input type="button" value="搜索" onclick="searchVenueList(1)">
		</div>
		<div class="advanced" style="display: none;">
			<div class="attr-extra open">收起<b></b></div>
		</div>
	</div>

	<%--活动列表 begin--%>
	<div id="activity_content">

	</div>
	<%--活动列表 end--%>
</div>
<input type="hidden" id="reqPage"  value="1">

<div id="in-footer">
	<div class="in-footer">
		<div class="in-footer1">
			<p>文化上海云 版权所有 | 未经授权禁止复制或镜像 | 联系电话:021-58741254 | 传真:65874269 | 沪ICP备06021945号| <a href="/legal.do" style="color:#999999;">服务条款</a></p>
			<p>Copyright © 2014 - 2020 www.culture.com All Rights Reserved.</p>
		</div>
		<a href="javascript:;" onclick="scrollTo(0,0);" id="toTop"></a>
	</div>
</div>

</body>
</html>
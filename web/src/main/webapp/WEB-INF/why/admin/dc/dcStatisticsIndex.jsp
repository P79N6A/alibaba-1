<%@ page language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>配送中心列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <%@include file="/WEB-INF/why/common/limit.jsp" %>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/dc/css/lcc.css"/>

    <script type="text/javascript">
        $(function () {
        	$('.tjtable tr:odd').addClass('hui');
        	$('.tjtable tr:even').addClass('bai');
        	$('.tjtable tr:nth(1) td').addClass('lan');
        	$('.tjtable tr').each(function () {
        		$(this).find('td').eq(0).addClass('shen');
        		$(this).find('td:last').addClass('lan');
        	});
        	
        });

    </script>
</head>
<body>
	<div class="lccmain">
		<div class="site">
			<em>您现在所在的位置：</em>配送中心 &gt; 统计汇总
		</div>
		<div class="site-title">统计汇总</div>
		<div class="tjshuju">昨日上传：<span>${statisticsMap.yesterdayTotal}</span>条视频&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;累计上传：<span>${statisticsMap.total}</span>条视频</div>
		<div class="tjttab_wc">
			<table class="tjtable" id="statisticsList">
				<tr>
					<th class="biao">区县</th>
					<th>10-21</th>
					<th>10-22</th>
					<th>10-23</th>
					<th>10-24</th>
					<th>10-25</th>
					<th>10-26</th>
					<th>10-27</th>
					<th>10-28</th>
					<th>10-29</th>
					<th>10-30</th>
					<th>10-31</th>
					<th>累计</th>
				</tr>
				<c:forEach items="${statisticsMap.statisticsList}" var="list" varStatus="i">
					<tr>
						<c:forEach items="${list}" var="dom" varStatus="j">
							<td>${dom}</td>
						</c:forEach>
					</tr>
				</c:forEach>
			</table>
		</div>
	</div>
</body>
</html>

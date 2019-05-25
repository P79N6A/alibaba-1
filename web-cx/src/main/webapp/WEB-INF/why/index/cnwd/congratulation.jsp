<%@ page language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <%@include file="/WEB-INF/why/common/limit.jsp" %>
	<meta charset="UTF-8">
	<title>恭喜你！</title>
	<link rel="stylesheet" type="text/css" href="${path }/STATIC/css/cnwd/reset.css">
	<link rel="stylesheet" type="text/css" href="${path }/STATIC/css/cnwd/dance.css">
</head>
<body>
	<%@include file="/WEB-INF/why/index/cnwd/header.jsp"%>

	<p class="crumbs">我的位置：2017年舞蹈大赛</p>
	<div class="content_wrap">
		<div class="content clear">
			<h1>恭喜您通过专家评审，进入决赛</h1>
			<p>1、流行舞大赛将于2017年6月19日-6月23日，在佛山文化云举办“最佳网络人气团队评选”活动；</p>
			<p>2、进入决赛的团队，您可提前关注文化云官微，或者下载文化云app（补充文案）；</p>
			<p>3、增设最佳网络人气团队评选，由佛山文化云发布，广大市民投票产生，网络票选与决赛比分无关，为独立奖项。</p>
			<p class="question">如有疑问，请致电：周老师、李老师</p>
			<p class="number">62421443、62421436</p>
			<a href="javascript:;" class="btn btn_bgtwo fl">修改信息</a>
			<a href="login.html" class="btn btn_bgone fl">退出登录</a>
		</div>
	</div>
	<%@include file="/WEB-INF/why/index/cnwd/footer.jsp"%>
</body>
</html>
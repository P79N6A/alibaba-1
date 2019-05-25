<%@ page language="java"  pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	request.setAttribute("path", path);
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=basePath%>">

<title>文化云后台管理系统</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<link rel="shortcut icon" href="${path}/STATIC/image/favicon.ico" type="image/x-icon" />
<%@include file="/WEB-INF/why/common/limit.jsp"%>
</head>


<script>tp://fsct.gd.wenhuayun.cn";
    window.location.href="ht
</script>


<%--<%if(request.getSession().getAttribute("user")==null){%>
<script>
	window.location.href="${pageContext.request.contextPath}/login.do";
</script>
<%}%>

<%if (whyIndex) {%>
	<script>
		window.onload = function(){
			document.getElementById("main").src = "${path}/right.do"
		}
	</script>
<%}%>

<frameset cols="220,*" cols="*" scrolling="no" framespacing="0" frameborder="no" border="0">
	<frame src="${path}/left.do" name="leftFrame" scrolling="no" noresize="noresize" id="leftFrame" />
	<% if(!(trainButton || courseButton || courseOrderButton || trianUserListButton)){ %>
		<%if (whyIndex) {%>
			<frame src="${path}/loading.do" id="main" name="main"/>
		<%}else{%>
			<frame src="${path}/right.do" id="main" name="main"/>
		<%}%>
	<% }else{ %>
		<% if(courseButton) { %>
			<frame src="${path}/peopleTrain/courseList.do" id="main" name="main"/>
		<% }else if(!courseButton && courseOrderButton) {%>
			<frame src="${path}/peopleTrain/applyList.do" id="main" name="main"/>
		<%}%>
	 <%}%>
</frameset>--%>
</html>

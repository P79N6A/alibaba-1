<%@ page language="java"  pageEncoding="UTF-8"%>
<%
  String path = request.getContextPath();
  request.setAttribute("path", path);
  String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <title>文化云</title>
</head>

<body>
<script type="text/javascript" src="/stat/stat.js"></script>
<script language="javascript">location.href="${path}/frontIndex/index.do"</script>
<%--<script language="javascript">location.href="${path}/frontIndex/index.do"</script>--%>
<%--<script language="javascript">location.href="${path}/frontActivity/frontActivityIndex.do"</script>--%>
</body>
</html>


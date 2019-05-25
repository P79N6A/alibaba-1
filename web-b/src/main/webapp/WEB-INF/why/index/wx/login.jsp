<%--
  Created by IntelliJ IDEA.
  User: niub
  Date: 2015/8/28
  Time: 13:49
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%
  String path = request.getContextPath();
  request.setAttribute("path",path);
%>
<html>
<head>
    <title>文化云平台</title>
</head>
<body>
<div id="tips"></div>
<a id="toLogin"  href="https://open.weixin.qq.com/connect/qrconnect?appid=wx4f0874059d0a25cd&redirect_uri=${redUrl}&response_type=code&scope=snsapi_login&state=${wxState}#wechat_redirect"></a>
<script>
  <c:choose>
      <c:when test="${not empty extUser}">
          $("#tips").html("当前已存在登录用户,请退出后使用微信登录!正在跳转到首页.....");
          setTimeout(function(){
            window.location.href="${path}/frontActivity/frontActivityIndex.do";
          },1500);
      </c:when>
      <c:otherwise>
          document.getElementById("toLogin").click();
      </c:otherwise>
  </c:choose>
</script>
</body>
</html>

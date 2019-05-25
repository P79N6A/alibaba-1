<%--
  Created by IntelliJ IDEA.
  User: niub
  Date: 2015/8/28
  Time: 13:49
  To change this template use File | Settings | File Templates.
--%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String path = request.getContextPath();
  request.setAttribute("path", path);
%>
<html>
<head>
    <title>佛山文化云</title>
</head>
<body>
<%--========= timeOut
${serverBusy}----${accessToken.openid}---${e}
==============--%>

<c:if test="${not empty timeOut}">
页面超时,请重新扫描二维码! 正在跳转.....
  <script type="text/javascript">
    setTimeout(function(){
      window.location.href="${path}/wechat/login.do";
    },1500);
  </script>
</c:if>
<%--</c:if><c:if test="${not empty extLogin}">
  连接超时,请重新扫描二维码! 正在跳转.....
  <script type="text/javascript">
    setTimeout(function(){
      window.location.href="${path}/wx/login.do";
    },1500);
  </script>
</c:if>--%>

<c:if test="${not empty extUser}">
微信登录成功,正在跳转.....请稍后
  <script type="text/javascript">
      setTimeout(function(){
        window.location.href="${path}/frontIndex/index.do";
      },1500);
  </script>
</c:if>

<c:if test="${not empty code}">
微信登录成功,正在跳转.....请稍后
  <script type="text/javascript">
    setTimeout(function(){
      window.location.href="${path}/frontIndex/index.do?code=${code}";
    },1500);
  </script>
</c:if>

<c:if test="${not empty serverBusy}">
微信系统繁忙,请稍后重试!正在跳转到首页.....
  <script type="text/javascript">
    setTimeout(function(){
      window.location.href="${path}/frontIndex/index.do";
    },2000);
  </script>
</c:if>

</body>
</html>

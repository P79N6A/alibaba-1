<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
  String path = request.getContextPath();
  String basePath = request.getScheme() + "://"
          + request.getServerName() + ":" + request.getServerPort()
          + path + "/";
%>
<html>
<head>
    <title>支持多文件上传</title>
  <script type="text/javascript">
    function doSubmit(){
      form2.submit();
    }
  </script>
</head>
<body>

<form id="form2" action="<%=basePath%>user/uploadAppFiles.do" enctype="multipart/form-data" method="post">
  用户id:<input type="text" name="userId" id="userId" />
  <p>
  选择文件: <input type="file" name="file"  />
   <p>
    文件类型: <input type="text" name="uploadType"  />

  <input type="button" value="提交" onclick="doSubmit()"/>
</form>
</body>
</html>

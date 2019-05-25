<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
  String path = request.getContextPath();
  request.setAttribute("path", path);
  String basePath = request.getScheme() + "://"
          + request.getServerName() + ":" + request.getServerPort()
          + path + "/";
%>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <title>弹出对话框jQuery插件Dialog - xw素材网</title>
  <link rel="Stylesheet" type="text/css" href="${path}/STATIC/css/DialogBySHF.css" />
<%--  <style type="text/css">
    input[type='button']{margin:100px 20px;padding: 10px;}
  </style>--%>
</head>
<body>
<center><br/>
  <input type="button" value="弹出提示框" id="btnAlert" />
  <input type="button" value="弹出确认框" id="btnConfirm" />
  <input type="button" value="弹出iframe" id="btnDialog" />
  <input type="button" value="关闭iframe" id="Close" />

</center>
<script type="text/javascript" src="${path}/STATIC/js/jquery.min.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/DialogBySHF.js"></script>
<script type="text/javascript">
  $(document).ready(function () {
    $("#btnAlert").click(function () {
      $.DialogBySHF.Alert({ Width: 350, Height: 200, Title: "xw素材网", Content: '你好，这是弹出提示，即JS中的alert', ConfirmFun: test });
    })
    $("#btnConfirm").click(function () {
      $.DialogBySHF.Confirm({ Width: 350, Height: 200, Title: "提示信息", Content: '${path}/activity/activityIndex.do?activityState=6', ConfirmFun: test, CancelFun: testCancel });
    })
    $("#btnDialog").click(function () {
      $.DialogBySHF.Dialog({ Width: 1024, Height: 500, Title: "xw素材网", URL: 'http://www.xwcms.net' });
    })
    $("#Close").click(function () {
      $.DialogBySHF.Close();
    })
  })
  function test() {
    $.DialogBySHF.Alert({ Width: 350, Height: 200, Title: "确认后执行方法", Content: '确认后执行的方法' });
  }
  function testCancel() {
    $.DialogBySHF.Alert({ Width: 350, Height: 200, Title: "取消后执行方法", Content: '取消后执行的方法' });
  }
</script>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>取票机--手机端--文化云</title>
  <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/reset-index.css"/>
  <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture.css"/>
  <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture-user.css"/>
  <!--[if lte IE 8]>
  <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture-ie.css"/>
  <![endif]-->
  <script type="text/javascript" src="${path}/STATIC/js/jquery.min.js"></script>
  <script type="text/javascript" src="${path}/STATIC/js/culture.js"></script>
  <script type="text/javascript">
    $(function(){
      $(".mobile-content").height(window.screen.height-60);
      $('#ticketMobileId').addClass('cur').siblings().removeClass('cur');

    });
  </script>
</head>
<body style="background: #eef4f7;">

<!-- ticket_top start -->
<%@include file="/WEB-INF/why/ticket/ticket-nav.jsp"%>
<!-- ticket_top end -->

<div class="mobile-content">
  <div id="ticket-mobile">
    <div class="ticket-mobile">
      <div class="phone"><img src="${path}/STATIC/image/phone2.jpg" alt="" width="260" height="448"/></div>
      <div class="right">
        <div class="in-sweep">
          <h2>扫一扫<br>进入佛山文化云移动端页面</h2>
          <%--<h4>精彩尽在www.wenhuayun.cn</h4>--%>
        </div>
        <div class="in-app">
          <div class="in-iphone">
            <img src="${path}/STATIC/image/download-iphone.png" alt="" width="216" height="216">
            <%--<span><i></i>App Store下载</span>--%>
          </div>
          <%--<div class="in-android">
            <img src="${path}/STATIC/image/download-android.png" alt="" width="216" height="216">
            <span><i></i><a href="#" target="_blank" style="color:#FFFFFF">Android下载</a></span>
          </div>--%>
        </div>
      </div>
    </div>
  </div>
</div>

</body>
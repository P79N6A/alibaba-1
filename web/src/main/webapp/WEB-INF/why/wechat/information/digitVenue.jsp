<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>数字展馆</title>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp" %>
    <%-- <script type="text/javascript" src="${path}/STATIC/wechat/js/jquery.lazyload.min.js"></script> --%>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="format-detection" content="telephone=no"/>
    <meta name="apple-mobile-web-app-capable" content="yes"/>
    <meta name="apple-mobile-web-app-status-bar-style" content="black"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/normalize.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/hsStyle.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/swiper-3.3.1.min.css"/>
    <%--<link rel="stylesheet" href="${path}/STATIC/wechat/css/bpColorCtrl.css" />--%>
    <script type="text/javascript" src="${path}/STATIC/wechat/js/jquery-2.1.4.min.js"></script>
    <script type="text/javascript" src="${path}/STATIC/wechat/js/swiper-3.3.1.jquery.min.js"></script>

    <style type="text/css">
        html, body {
            height: 100%;
            /*background-color: #f3f3f3;*/
        }
        ._main_box{
            display: flex;
            flex-direction: column;
            align-items: center;
            width: 100%;
            height: 100%;
            background-color: #ffffff;
        }
        ._main_box div{
            cursor:pointer;
            margin-bottom: 20px;
        }
        img{
            width: 750px;
        }
    </style>
</head>

<body>
<div class="main">

    <div class="_main_box">
        <div>
            <a href="${path}/wechatInformation/list.do?informationModuleId=afa6dfe23a9745afa749f89e1f5b9b8a"><img src="${path}/STATIC/image/cultureVenue.png"/></a>
        </div>
        <div>
            <a href="${path}/wechatInformation/list.do?informationModuleId=12df5837827741c1a53424ceffbaeada"><img src="${path}/STATIC/image/cultureResource.png"/></a>
        </div>
    </div>

</div>
</body>
</html>
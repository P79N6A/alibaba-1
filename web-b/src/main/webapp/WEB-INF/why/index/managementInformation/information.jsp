<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<html >
<head lang="en">
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>${managementInformation.shareTitle}</title>
    <meta name="info.shareSummary" content="内容"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/info.css?20160516"/>
    <script type="text/javascript" src="${path}/STATIC/js/jquery.min.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/common.js"></script>
    <script type="text/javascript" src="${path}/STATIC/wechat/js/jweixin-1.0.0.js"></script>
    <script type="text/javascript">
        (function () {
            var phoneWidth = parseInt(window.screen.width);
            var phoneScale = phoneWidth / 750;
            var ua = navigator.userAgent;            //浏览器类型
            if (/Android (\d+\.\d+)/.test(ua)) {      //判断是否是安卓系统
                var version = parseFloat(RegExp.$1); //安卓系统的版本号
                if (version > 2.3) {
                    document.write('<meta name="viewport" content="width=750, minimum-scale = ' + phoneScale + ', maximum-scale = ' + phoneScale + ', target-densitydpi=device-dpi">');
                } else {
                    document.write('<meta name="viewport" content="width=750, target-densitydpi=device-dpi">');
                }
            } else {
                document.write('<meta name="viewport" content="width=750, user-scalable=no, target-densitydpi=device-dpi">');
            }
        }());
        <%--//判断是否是微信浏览器--%>
        function is_weixin() {
            var ua = navigator.userAgent.toLowerCase();
            if (ua.match(/MicroMessenger/i) == "micromessenger") {
                return true;
            } else {
                return false;
            }
        }

        //判断是否是微信浏览器打开
        if (is_weixin()) {

            //通过config接口注入权限验证配置
            wx.config({
                debug: false,
                appId: '${sign.appId}',
                timestamp: '${sign.timestamp}',
                nonceStr: '${sign.nonceStr}',
                signature: '${sign.signature}',
                jsApiList: ['onMenuShareAppMessage', 'onMenuShareTimeline', 'onMenuShareQQ', 'onMenuShareWeibo', 'onMenuShareQZone']
            });
            wx.ready(function () {
                wx.onMenuShareAppMessage({
                    title:'${managementInformation.shareTitle}',
                    desc: '${managementInformation.shareSummary}',
                    imgUrl:getIndexImgUrl(getImgUrl($('#shareIconUrl').val()),"_500_500"),
                    success: function () {
                        dialogAlert('系统提示', '分享成功！');
                    }
                });
                wx.onMenuShareTimeline({
                    title: '${managementInformation.shareTitle}',
                    imgUrl: getIndexImgUrl(getImgUrl($('#shareIconUrl').val()), "_500_500"),
                    success: function () {
                        dialogAlert('系统提示', '分享成功！');
                    }
                });
                wx.onMenuShareQQ({
                    title: '${managementInformation.shareTitle}',
                    desc: '${managementInformation.shareSummary}',
                    imgUrl:getIndexImgUrl(getImgUrl($('#shareIconUrl').val()), "_500_500"),
                });
                wx.onMenuShareWeibo({
                    title:' ${managementInformation.shareTitle}',
                    desc: '${managementInformation.shareSummary}',
                    imgUrl:getIndexImgUrl(getImgUrl($('#shareIconUrl').val()), "_500_500"),
                });
                wx.onMenuShareQZone({
                    title:' ${managementInformation.shareTitle}',
                    desc:' ${managementInformation.shareSummary}',
                    imgUrl: getIndexImgUrl(getImgUrl($('#shareIconUrl').val()), "_500_500"),
                });
            });
        }

    </script>
</head>
<body>
<div class="advice_con">
    <div class="titl">${managementInformation.informationTitle}</div>
    <div class="author">by:${managementInformation.authorName}</div>
    <div class="label">
        <c:forEach items="${managementInformation.informationTags}" var="avct">
            <a><c:out escapeXml="true" value="${avct}"/></a>
        </c:forEach>
    </div>
    <div class="c_list" ng-bind-html-unsafe="info.informationContent">
        ${managementInformation.informationContent}
    </div>
    <c:if test="${managementInformation.informationFooter == 1}">
        <div class="change_img" ng-show="info.informationFooter">
            <img src="${path}/STATIC/image/advice_img.png" width="680" height="375">
        </div>
    </c:if>
    <div class="sum_author clearfix">
        <div class="sa_l fl">浏览量：${managementInformation.browseCount}</div>
        <div class="sa_r fr">发布者：${managementInformation.publisherName}</div>
    </div>
</div>
<input type="hidden" id="shareIconUrl" name="shareIconUrl" value="${managementInformation.shareIconUrl}">
</body>

</html>

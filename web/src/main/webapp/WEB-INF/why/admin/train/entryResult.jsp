<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <title>文化培训</title>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp" %>
    <script type="text/javascript" src="${path}/STATIC/wechat/js/jquery.lazyload.min.js"></script>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/peixun.css"/>
    <script type="text/javascript">
        $(function () {
            //判断是否是微信浏览器打开
            if (is_weixin()) {
                //通过config接口注入权限验证配置
                wx.config({
                    debug: false,
                    appId: '${sign.appId}',
                    timestamp: '${sign.timestamp}',
                    nonceStr: '${sign.nonceStr}',
                    signature: '${sign.signature}',
                    jsApiList: ['getLocation', 'onMenuShareAppMessage', 'onMenuShareTimeline', 'onMenuShareQQ', 'onMenuShareWeibo', 'onMenuShareQZone']
                });
                wx.ready(function () {
                    wx.onMenuShareAppMessage({
                        title: "我在“镇江文化云”发现一大波文化活动，快来和我一起预订吧！",
                        desc: '汇聚镇江最全文化活动',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
                        success: function () {
                            dialogAlert('系统提示', '分享成功！');
                        }
                    });
                    wx.onMenuShareTimeline({
                        title: "我在“镇江文化云”发现一大波文化活动，快来和我一起预订吧！",
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
                        success: function () {
                            dialogAlert('系统提示', '分享成功！');
                        }
                    });
                    wx.onMenuShareQQ({
                        title: "我在“镇江文化云”发现一大波文化活动，快来和我一起预订吧！",
                        desc: '汇聚镇江最全文化活动',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                    });
                    wx.onMenuShareWeibo({
                        title: "我在“镇江文化云”发现一大波文化活动，快来和我一起预订吧！",
                        desc: '汇聚镇江最全文化活动',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                    });
                    wx.onMenuShareQZone({
                        title: "我在“镇江文化云”发现一大波文化活动，快来和我一起预订吧！",
                        desc: '汇聚镇江最全文化活动',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                    });
                });
            }
        });

    </script>
    <style type="text/css">
        html, body {
            height: 100%;
            background-color: #ededed;
        }
        .main {
            width: 750px;
            min-height: 100%;
            margin: 0 auto;
        }
    </style>
</head>
<body>

    <!-- 报名成功 -->
    <c:if test="${order.state==1}">
        <div class="px-baomSucess">
            <img src="${path}/STATIC/wechat/image/dh-peixun/px-su1.png"
                 style="display: block;margin: 0 auto;margin-top: 240px;"/>
            <p style="font-size: 34px;color: #1a1a1a;text-align: center;margin-top: 70px;">您的培训报名成功!</p>
            <a class="bmsuBtn" href="${path}/wechatTrain/index.do">返回培训首页</a>
        </div>
    </c:if>
    <!-- 审核中 -->
    <c:if test="${order.state!=1}">
        <div class="px-baomSucess" style="background-image: url(${path}/STATIC/wechat/image/dh-peixun/px-subg.jpg);">
            <div class="circle">
                <span></span>
                <img style="position: absolute;left: 6px;top: 0;" src="${path}/STATIC/wechat/image/dh-peixun/px-su4.png"/>
            </div>
            <div style="width: 100%;position: absolute;left: 0;bottom: 290px;">
                <p style="font-size: 34px;color: #666;text-align: center;margin-bottom: 30px;">您的培训报名信息提交成功</p>
                <p style="font-size: 28px;color: #999;text-align: center;">请等待管理员审核！</p>
            </div>
            <a class="bmsuBtn" href="${path}/wechatTrain/index.do">返回培训首页</a>
        </div>
    </c:if>

</body>
<script>

</script>
</html>
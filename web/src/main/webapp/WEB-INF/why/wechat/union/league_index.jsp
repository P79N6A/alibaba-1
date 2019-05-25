<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="en">
<head>
    <title>文化联盟</title>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp" %>
    <script type="text/javascript" src="${path}/STATIC/js/common.js"></script>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/normalize.css">
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/swiper-3.3.1.min.css">
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/fsStyle.css">


    <style type="text/css">
        .whlmBanner .swiper-pagination-bullet {
            width: 10px;
            height: 10px;
            background-color: #fff;
            opacity: 1;
            margin: 0 8px !important;
        }

        .whlmBanner .swiper-pagination-bullet-active {
            background-color: #e63917;
            opacity: 1;
        }
    </style>


</head>
<body style="background-color: #f3f3f3;">
<div class="fsMain">
    <div class="swiper-container whlmBanner" style="float: none;">
        <div class="swiper-wrapper">
        </div>
        <div class="swiper-pagination"></div>
    </div>
    <div class="newActWrap">
        <h1 class="newActTit">最新活动</h1>
        <ul class="newActList">
            <c:forEach items="${list}" var="obj">
                <li onclick="location.href='${path}/wechatActivity/preActivityDetail.do?activityId=${obj.activityId}'">
                    <p class="tit">${obj.activityName}</p>
                    <p class="time"><fmt:formatDate value="${obj.activityCreateTime}" pattern="yyyy.MM.dd HH:mm"/></p>
                </li>
            </c:forEach>

        </ul>
    </div>
    <div class="fsBookWrap">
        <ul class="fsBookList clearfix">
            <li onclick="location.href='${path}/wechatUnion/leagueForType.do?type=f8c643716b6c4cc397eedbae7318c425&typeName=文化中枢'">
                <div class="img"><img src="${path}/STATIC/wechat/image/fslmIcon2.png"></div>
                <p class="total"></p>
                <a href="${path}/wechatUnion/leagueForType.do?type=f8c643716b6c4cc397eedbae7318c425" class="fsLookBtn">查看详情</a>
            </li>
            <li onclick="location.href='${path}/wechatUnion/leagueForType.do?type=c451ac6b931d495387d0307a7bf1e4a4&typeName=设施联盟'">
                <div class="img"><img src="${path}/STATIC/wechat/image/fslmIcon3.png"></div>
                <p class="total"></p>
                <a href="${path}/wechatUnion/leagueForType.do?type=c451ac6b931d495387d0307a7bf1e4a4" class="fsLookBtn">查看详情</a>
            </li>
        </ul>
    </div>
</div>
</body>
<script>
    $(document).ready(function () {
        //分享是否隐藏
        if (window.injs) {
            //分享文案
            appShareTitle = '安康“文化联盟”，致力打造全国文化名片！';
            appShareDesc = '欢迎进入安康文化云·文化联盟"';
            appShareImgUrl = '${basePath}STATIC/wx/image/share_120.png';
            injs.setAppShareButtonStatus(true);
        }
        if (is_weixin()) {
            var title = "安康“文化联盟”，致力打造全国文化名片！";
            var desc = "欢迎进入安康文化云·文化联盟";
            var imgUrl = '${basePath}/STATIC/wx/image/share_120.png';
            var link = "${basePath}/wechatUnion/leagueIndex.do";

            wx.config({
                debug: false,
                appId: '${sign.appId}',
                timestamp: '${sign.timestamp}',
                nonceStr: '${sign.nonceStr}',
                signature: '${sign.signature}',
                jsApiList: ['previewImage', 'onMenuShareAppMessage', 'onMenuShareTimeline', 'onMenuShareQQ', 'onMenuShareWeibo', 'onMenuShareQZone']
            });
            wx.ready(function () {

                wx.onMenuShareAppMessage({
                    title: title,
                    desc: desc,
                    imgUrl: imgUrl,
                    link: link,
                    success: function () {
                        //shareIntegral();
                    }
                });
                wx.onMenuShareTimeline({
                    title: title,
                    imgUrl: imgUrl,
                    link: link,
                    success: function () {
                        //shareIntegral();
                    }
                });
                wx.onMenuShareQQ({
                    title: title,
                    desc: desc,
                    link: link,
                    imgUrl: imgUrl,
                    success: function () {
                        //shareIntegral();
                    }
                });
                wx.onMenuShareWeibo({
                    title: title,
                    desc: desc,
                    link: link,
                    imgUrl: imgUrl,
                    success: function () {
                        //shareIntegral();
                    }
                });
                wx.onMenuShareQZone({
                    title: title,
                    desc: desc,
                    link: link,
                    imgUrl: imgUrl,
                    success: function () {
                        //shareIntegral();
                    }
                });
            });
        }
    })


    $(function () {
        showAdvertPicture();
        $("#leagueIndex").addClass('cur').siblings().removeClass('cur');
    });

    // 显示轮播图
    function showAdvertPicture() {
        $.post("${path}/beipiaoInfo/bpCarouselList.do?carouselType=2&version=" + new Date().getTime(), '', function (data) {
            if (data != undefined && data != null && data != "" && data.length > 0) {
                getAdvertHtml(data);
                /* start banner */
                /*轮播图*/
                var mySwiper3 = new Swiper('.whlmBanner', {
                    freeMode: false,
                    autoplay: 5000,
                    loop: true,
                    pagination: '.swiper-pagination',
                    autoplayDisableOnInteraction: false,
                });
                /* end banner */
            }
        });
    }

    // 拼接轮播图
    function getAdvertHtml(data) {
        var imgUrl = "";
        var connectUrl = "";
        var li = "";
        var span = "";
        if (data.length >= 0) {
            for (var i in data) {
                imgUrl = data[i].carouselImage;
                connectUrl = data[i].carouselUrl.split(',')[1];
                li += ' <a href="' + connectUrl + '" class="swiper-slide"><img style="width: 100%;height: 100%" src="' + imgUrl + '"></a>';
            }
        }
        $(".swiper-wrapper").html(li);
        //$('.swiper-wrapper a img').picFullCentered({'boxWidth': 750, 'boxHeight': 260});
    }

</script>
</html>
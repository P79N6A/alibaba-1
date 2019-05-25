
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>艺术培训</title>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp" %>
    <script type="text/javascript" src="${path}/STATIC/js/common.js"></script>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/normalize.css">
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css">
    <script>

        $(function () {
            $("#trainingVideo li").each(function (index, item) {
                var imgUrl = $(this).attr("data-url");
                if (imgUrl != undefined && imgUrl != "" && imgUrl != null) {
                    $(item).find("img").attr("src", getIndexImgUrl(getImgUrl(imgUrl), "_750_500"));
                } else {
                    $(item).find("img").attr("src", "../STATIC/image/default.jpg");
                }
            });

        });

        function showTraining(Id) {
            window.location.href = "${path}/wechatTraining/trainingDetail.do?trainingId=" + Id;
        }
    </script>
    <script>
        //分享是否隐藏
        if (window.injs) {
            //分享文案
            appShareTitle = '我正在佛山文化云参加艺术培训，你也一起来看看吧';
            appShareDesc = '佛山文化云·艺术培训，精彩培训视频在线观看，丰富培训课程在线报名';
            appShareImgUrl = '${basePath}/STATIC/wx/image/share_120.png';
            injs.setAppShareButtonStatus(true);
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
                    title: "我正在佛山文化云参加艺术培训，你也一起来看看吧",
                    desc: '佛山文化云·艺术培训，精彩培训视频在线观看，丰富培训课程在线报名',
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
                wx.onMenuShareTimeline({
                    title: "我正在佛山文化云参加艺术培训，你也一起来看看吧",
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
                wx.onMenuShareQQ({
                    title: "我正在佛山文化云参加艺术培训，你也一起来看看吧",
                    desc: '佛山文化云·艺术培训，精彩培训视频在线观看，丰富培训课程在线报名',
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
                wx.onMenuShareWeibo({
                    title: "我正在佛山文化云参加艺术培训，你也一起来看看吧",
                    desc: '佛山文化云·艺术培训，精彩培训视频在线观看，丰富培训课程在线报名',
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
                wx.onMenuShareQZone({
                    title: "我正在佛山文化云参加艺术培训，你也一起来看看吧",
                    desc: '佛山文化云·艺术培训，精彩培训视频在线观看，丰富培训课程在线报名',
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
            });
        }
        $(function() {
            $(".dropdownMenu>ul>li").click(function() {
                var num = $(this).index();
                $(".dropdownMenu").hide();
                $(".dropdownList>ul>li").eq(num).fadeIn();
                $(".dropdown").css({
                    "width":"200px",
                    "height":"300px"
                })
            });
            $(".dropdownCbtn").click(function(){
                $(".dropdownList>ul>li").hide();
                $(".dropdownMenu").fadeIn();
                $(".dropdown").css({
                    "width":"450px",
                    "height":"60px"
                })
            })
        })
    </script>
</head>
<body>
<div class="artFa-main">

    <div class="artDibKT" id="trainingVideo">
        <ul class="artCourse2">
           <c:forEach items="${trainingList}" var="tra">
                <li data-url="${tra.trainingImgUrl}" onclick="showTraining('${tra.trainingId}')" >
                    <img src="" width="360" height="230"/>
                    <p class="artCourse2Title1 artFaVideoTitle">${tra.trainingTitle}</p>
                    <p class="artCourse2Title2 artFaVideoTitle">${tra.trainingSubtitle}</p>
                </li>
            </c:forEach>
            <div style="clear: both;"></div>
        </ul>
    </div>
</div>
</body>
</html>

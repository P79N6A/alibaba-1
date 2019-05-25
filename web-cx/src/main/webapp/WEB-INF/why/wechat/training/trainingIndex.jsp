<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>艺术培训</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp" %>
    <script type="text/javascript" src="${path}/STATIC/js/common.js"></script>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css">
</head>

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
    $(function () {
        $("#hotTraining li").each(function (index, item) {
            var imgUrl = $(this).attr("data-url");
            if (imgUrl != undefined && imgUrl != "" && imgUrl != null) {
                $(item).find("img").attr("src", getIndexImgUrl(getImgUrl(imgUrl), "_750_500"));
            } else {
                $(item).find("img").attr("src", "../STATIC/image/default.jpg");
            }
        });

        $("#trainingVideo li").each(function (index, item) {
            var imgUrl = $(this).attr("data-url");
            if (imgUrl != undefined && imgUrl != "" && imgUrl != null) {
                $(item).children("img").attr("src", getIndexImgUrl(getImgUrl(imgUrl), "_750_500"));
            } else {
                $(item).children("img").attr("src", "../STATIC/image/default.jpg");
            }
        });

    })
    ;
    function showTraining(Id) {
        window.location.href = "${path}/wechatTraining/trainingDetail.do?trainingId=" + Id;
    }
    function showtrainingVideoList() {
        window.location.href = "${path}/wechatTraining/trainingVideoList.do";
    }
    function showTrainingList() {
        window.location.href = "${path}/wechatTraining/trainingList.do";
    }
</script>
<style>
	.artDibList>li {
		position: relative;
	}
	
	.artPlayBtn {
		position: absolute;
		left: 0;
		right: 0;
		top: 70px;
		margin: auto;
		width: 90px;
		height: 92px;
	}
</style>
<body>
<div class="artFa-main">
    <div class="feiyi-top" style="border-bottom: 15px solid #f5f5f5;">
        <div onclick="showtrainingVideoList()">
            <img src="${path}/STATIC/wechat/image/training/zaixianketang.png"/>
        </div>
        <div onclick="showTrainingList()">
            <img src="${path}/STATIC/wechat/image/training/peixunbaoming.png"/>
        </div>
    </div>
    <div class="artDib" id="trainingVideo">
        <p class="artClaTitle">——&nbsp;点播最多&nbsp;——</p>
        <ul class="artDibList">
            <c:forEach items="${trainingList}" var="tra" begin="0" end="3">

                    <li data-url="${tra.trainingImgUrl}" onclick="showTraining('${tra.trainingId}')">
                        <img src="" width="360" height="240"/>
                        <p class="artFaVideoTitle">${tra.trainingTitle}</p>
                        <div class="artPlayBtn">
							<img src="${path}/STATIC/wechat/image/training/pic7.png" />
						</div>
                    </li>

            </c:forEach>
            <div style="clear: both;"></div>
        </ul>
    </div>
    <div class="artDibKT" id="hotTraining">
        <p class="artClaTitle">——&nbsp;热门课程&nbsp;——</p>
        <ul class="artCourse">
            <c:forEach items="${actList}" var="activity">
                <c:if test="${activity.activityState eq 6}">
                <li data-url="${activity.activityIconUrl}" onclick="toActDetail('${activity.activityId}')">
                    <img src="" width="750" height="500"/>
                    <p class="artDibTitle1">${activity.activityName}</p>
                    <p class="artDibTitle2">${activity.venueName}</p>
                    <c:if test="${activity.activityIsFree eq 1}">
                        <div class="artDibTag">免费</div>
                    </c:if>
                    <c:if test="${activity.activityIsFree eq 2}">
                        <div class="artDibTag">收费</div>
                    </c:if>
                </li>
                </c:if>
            </c:forEach>
        </ul>
    </div>
</div>
</body>
</html>

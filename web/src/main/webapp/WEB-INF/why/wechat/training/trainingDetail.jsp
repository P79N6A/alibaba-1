
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>艺术培训</title>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp" %>
    <script type="text/javascript" src="${path}/STATIC/js/common.js"></script>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/normalize.css">
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css">
    <script>
        //分享是否隐藏
        if (window.injs) {
            //分享文案
            appShareTitle = '我正在安康文化云观看艺术培训课程“${training.trainingTitle}”';
            appShareDesc = '安康文化云·艺术培训，精彩培训视频在线观看';
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
                    title: "我正在安康文化云观看艺术培训课程“${training.trainingTitle}”",
                    desc: '安康文化云·艺术培训，精彩培训视频在线观看',
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
                wx.onMenuShareTimeline({
                    title: "我正在安康文化云观看艺术培训课程“${training.trainingTitle}”",
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
                wx.onMenuShareQQ({
                    title: "我正在安康文化云观看艺术培训课程“${training.trainingTitle}”",
                    desc: '安康文化云·艺术培训，精彩培训视频在线观看',
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
                wx.onMenuShareWeibo({
                    title: "我正在安康文化云观看艺术培训课程“${training.trainingTitle}”",
                    desc: '安康文化云·艺术培训，精彩培训视频在线观看',
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
                wx.onMenuShareQZone({
                    title: "我正在安康文化云观看艺术培训课程“${training.trainingTitle}”",
                    desc: '安康文化云·艺术培训，精彩培训视频在线观看',
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
            });
        }
        $(function () {

            if (${userWantgo}>0) {		//点赞（我想去）
                $(".artDis-love").find("img").attr("src", "${path}/STATIC/wxStatic/image/feiyi/love-on.png");
                $(".artDis-love").addClass("love-on");
            }
            //分享
            $(".artDis-share").click(function() {
                if (!is_weixin()&&!(/wenhuayun/.test(ua))) {
                    dialogAlert('系统提示', '请用微信浏览器打开分享！');
                }else{
                    $("html,body").addClass("bg-notouch");
                    $(".background-fx").css("display", "block")
                }
            });
            $(".background-fx").click(function() {
                $("html,body").removeClass("bg-notouch");
                $(".background-fx").css("display", "none")
            });



            var trainingImgUrl = getIndexImgUrl(getImgUrl('${training.trainingImgUrl}'),"_750_500");
            $("#training").append("<video id='assnVideo' src='${training.trainingVideoUrl}' poster='"+trainingImgUrl+"' style='width:750px;' controls></video>"+
                    "<p class='claName'>${training.trainingTitle}</p>" +
                    "<p class='claTip'>${training.trainingSubtitle}</p>"
            );
            var speakerImgUrl = getIndexImgUrl(getImgUrl('${training.speakerImgUrl}'),"_190_190");
            $("#speakerImgUrl").append("<img src='"+speakerImgUrl+"' width='190' height='190'/>"
            );
        });

        //点赞（我想去）
        function addWantGo() {
            var trainingId='${training.trainingId}';
            if (userId == null || userId == '') {
                //判断登陆
                publicLogin("${basePath}wechatTraining/trainingDetail.do?trainingId="+trainingId);
            }else{
                $.post("${path}/wechatUser/addUserWantgo.do", {
                    relateId: trainingId,
                    userId: userId,
                    type: 6
                }, function (data) {
                    if (data.status == 0) {
                        $(".artDis-love").find("img").attr("src", "${path}/STATIC/wxStatic/image/feiyi/love-on.png");
                        $(".artDis-love").addClass("love-on");
                        var num = $(".loveNum").text();
                        $(".loveNum").text(eval(num)+1);
                    } else if (data.status == 14111) {
                        $.post("${path}/wechatUser/deleteUserWantgo.do", {
                            relateId: trainingId,
                            userId: userId
                        }, function (data2) {
                            if (data2.status == 0) {
                                $(".artDis-love").find("img").attr("src", "${path}/STATIC/wxStatic/image/feiyi/love.png");
                                $(".artDis-love").removeClass("love-on");
                                var num = $(".loveNum").text();
                                $(".loveNum").text(eval(num-1));
                            }
                        }, "json");
                    }
                }, "json");
            }
        }
    </script>
</head>
<body>
<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
    <img src="${path}/STATIC/wechat/image/commonShare.png" style="width: 100%;height: 100%;" />
</div>
<div class="artDisMain">
    <div class="content" style="padding-bottom: 70px;">
        <div class="artCla" id="training">
        </div>
        <div class="artDis">
            <p class="artDisTitle">简介</p>
            <p class="artDisLT">${training.trainingIntroduce}</p>
        </div>
        <div class="artDis">
            <p class="artDisTitle">主讲人介绍</p>
            <div class="atrTeacher">
                <div class="atrTeacherImg" id="speakerImgUrl">
                </div>
                <div class="atrTeacherName">
                    <p class="artTname1">${training.speakerName}</p>
                    <p class="artTname2">${training.speakerSubtitle}</p>
                </div>
                <div style="clear: both;"></div>
            </div>
            <p class="artDisLT">${training.speakerIntroduce}</p>
        </div>
    </div>

    <!--借用非遗底部按钮样式-->
    <div class="artFooter">
        <div class="artDis-btn">
            <div class="artDis-share" >
                <p><img src="${path}/STATIC/wechat/image/training/keep.png" alt="" style="vertical-align: middle;margin-right: 10px;" /><span>分享</span></p>
            </div>
            <div class="artDis-love" onclick="addWantGo();">
                <p><img src="${path}/STATIC/wechat/image/training/love.png" alt="" style="vertical-align: middle;margin-right: 10px;" /><span>赞</span><span class="loveNum">${want}</span></p>
            </div>

            <div style="clear: both;"></div>
        </div>
    </div>
</div>
</body>
</html>

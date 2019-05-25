<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="en">
<head>
    <title>${param.typeName}</title>
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

    <script>
        $(document).ready(function () {
            /*菜单*/
            var mySwiper = new Swiper('.whzsMenu .swiper-container', {
                slidesPerView: 'auto',
                spaceBetween: 50,
            })
            $(".whzsMenu .swiper-slide").on('click', function () {

                $(this).addClass('on').siblings().removeClass("on");
            });

            //分享是否隐藏
            if (window.injs) {
                //分享文案
                appShareTitle = '汇聚各行各业文化艺术成员，打造佛山最具影响力的艺术文化大平台！';
                appShareDesc = '欢迎进入安康文化云·文化联盟';
                appShareImgUrl = '${basePath}STATIC/wx/image/share_120.png';
                injs.setAppShareButtonStatus(true);
            }
            if (is_weixin()) {
                var title = "汇聚各行各业文化艺术成员，打造佛山最具影响力的艺术文化大平台！";
                var desc = "欢迎进入安康文化云·文化联盟";
                var imgUrl = '${basePath}STATIC/wx/image/share_120.png';
                var link = window.location.href;

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
    </script>

</head>
<body style="background-color: #f3f3f3;">
<div class="fsMain">
    <div class="whzsMenu">
        <div class="swiper-container">
            <div class="swiper-wrapper">
                <div class="swiper-slide on">全部</div>
                <c:forEach items="${list}" var="obj">
                    <div id="${obj.id}" class="swiper-slide">${obj.title}</div>
                </c:forEach>
            </div>
        </div>
    </div>
    <div class="whzsWrap">
        <ul class="whzsList clearfix">
        </ul>
        <div id="loadingDiv" class="loadingDiv" style=""><img class="loadingImg"
                                                              src="${path}/STATIC/wechat/image/loading.gif"/><span
                class="loadingSpan">加载中。。。</span>
            <div style="clear:both"></div>
        </div>
    </div>
</div>

</body>
<script>
    $(function () {
        loadLeagueMember('', 1)
        $('.swiper-wrapper .swiper-slide').on('click', function () {
            var leagueId = $(this).attr("id");
            $('#leagueName').html($(this).attr("data-name"));
            loadLeagueMember(leagueId, 1);
        })
    });

    var leagueId = '';
    var ajaxPage = 1;
    var dataLength = 0;

    //滑屏分页
    $(window).on("scroll", function () {
        var scrollTop = $(document).scrollTop();
        var pageHeight = $(document).height();
        var winHeight = $(window).height();
        if (scrollTop >= (pageHeight - winHeight - 10) && dataLength==10) {
            setTimeout(function () {
                loadLeagueMember(leagueId, ajaxPage);
            },1000);
        }
    });

    function loadLeagueMember(id, page) {
        $("#loadingDiv").show();
        leagueId = id;
        var html = '';
        $.ajax({
            type: 'POST',
            dataType: "json",
            url: "${path}/member/leagueMember.do",//请求的action路径
            async: false,
            data:{leagueType:'${league.type}',leagueId:leagueId,page:page,rows:10},
            beforeSend:function () {
                $("#loadingDiv").show();
            },
            error: function () {//请求失败处理函数
                alert('请求失败');
            },
            success: function (data) {
                ajaxPage = page + 1;
                data = JSON.parse(data);
                var list = data.list;
                var member = data.member;
                dataLength = list.length;
                if (list.length > 0) {
                    for (var i = 0; i < list.length; i++) {
                        var obj = list[i];
                        var image = obj.images.split(',')[0];
                        html += '<li onclick="window.location=\'${path}/wechatUnion/index.do?member=' + obj.id + '\'">\n' +
                            '\t\t\t\t<div class="img"><img src="' + image + '" style="width:336px;height:213px;"></div>\n' +
                            '\t\t\t\t<div class="char">\n' +
                            '\t\t\t\t\t<p class="tit">' + obj.memberName + '</p>\n' +
                            '\t\t\t\t\t<p class="info">' + obj.introduction + '</p>\n' +
                            '\t\t\t\t</div>\n' +
                            '\t\t\t</li>';
                    }
                }
                if (page == 1) {
                    $('.whzsList').html(html);
                } else {
                    $(".whzsList").append(html);
                }
                if(dataLength<10) {
                    $("#loadingDiv").hide();
                }
            }
        });
    }
</script>
</html>
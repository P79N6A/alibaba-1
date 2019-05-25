<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <title>文化培训</title>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp" %>
    <script type="text/javascript" src="${path}/STATIC/wechat/js/jquery.lazyload.min.js"></script>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/peixun.css"/>

    <script src="${path}/STATIC/js/avalon.js"></script>
    <script type="text/javascript">
        var startIndex = 0;		//页数
        $(function () {
            if(window.injs){
                //分享文案
                appShareTitle = '${train.trainTitle}';
                appShareDesc = '欢迎进入安康群众文化云·文化培训';
                appShareImgUrl = '${basePath}/STATIC/wx/image/share_120.png';
                appShareLink = '${basePath}wechatTrain/trainDetail.do?id=${train.id}';
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
                    jsApiList: ['previewImage', 'onMenuShareAppMessage', 'onMenuShareTimeline', 'onMenuShareQQ', 'onMenuShareWeibo', 'onMenuShareQZone']
                });
                wx.ready(function () {
                    wx.onMenuShareAppMessage({
                        title: "我在安康文化云报名了“${train.trainTitle}”，名额有限，快来参与吧！",
                        desc: '欢迎进入安康群众文化云·文化培训',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
                        success: function () {
                            dialogAlert('系统提示', '分享成功！');
                        }
                    });
                    wx.onMenuShareTimeline({
                        title: "我在安康群众文化云报名了“${train.trainTitle}”，名额有限，快来参与吧！",
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
                        success: function () {
                            dialogAlert('系统提示', '分享成功！');
                        }
                    });
                    wx.onMenuShareQQ({
                        title: "我在安康群众文化云报名了“${train.trainTitle}”，名额有限，快来参与吧！",
                        desc: '欢迎进入安康群众文化云·文化培训',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                    });
                    wx.onMenuShareWeibo({
                        title: "我在安康群众文化云报名了“${train.trainTitle}”，名额有限，快来参与吧！",
                        desc: '欢迎进入安康群众文化云·文化培训',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                    });
                    wx.onMenuShareQZone({
                        title: "我在安康群众文化云报名了“${train.trainTitle}”，名额有限，快来参与吧！",
                        desc: '欢迎进入安康群众文化云·文化培训',
                        imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                    });
                });
            } else {
                loadDate(0, 20);
            }
        });

        function loadDate(index, pagesize) {
            $.post("${path}/wechatTrain/trainList.do", {
                pageIndex: index,
                pageNum: pagesize
            }, function (data) {
                $("#loadingDiv").hide();
                if (data.status == 0) {
                    var html = "";
                    console.log(data.data.length);
                    for (var i = 0; i < data.data.length; i++) {
                        var obj = data.data[i];
                        var tags = obj.trainTag;
                        html += '<li id="' + obj.id + '">' +
                            '<div class="pic">' +
                            '<img src="' + data.data[i].trainImgUrl + '" />';
                        html += '<div class="pxLabel clearfix">';

                        $(obj.trainTag.split(',')).each(function (i, n) {
                            html += '<span>' + n + '</span>'
                        });

                        html += '</div></div>';
                        html += '<div class="char">' +
                            '<div class="tit">' + data.data[i].trainTitle + '</div>' +
                            '<div class="time">' + data.data[i].registrationStartTime + '—' + data.data[i].registrationEndTime + '（报名时间）</div>' +
                            '<div class="time">' + data.data[i].trainStartTime + '—' + data.data[i].trainEndTime + '（开课时间）</div>' +
                            '</div>' +
                            '<div class="bottBox clearfix">';
                        html += '<div class="collect">收藏</div>';
                        if(obj.maxPeople != null && obj.maxPeople > 0){
                            html += '<div class="people"><i>'+obj.admissionsPeoples+'</i>/'+obj.maxPeople+'人</div>';
                        }else{
                            html += '<div class="people"><i>'+obj.admissionsPeoples+'</i>人</div>';
                        }

                        html += '</div>';
                        html += '</li>';
                    }
                    $(".peixunList").append(html);
                    $(".peixunList li").on('click', function () {
                        location.href = '${path}/wechatTrain/trainDetail.do?id=' + $(this).attr('id');
                    })
                }
            }, "json");
        }

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
<div class="main">
    <div class="pxd-cover">
        <div class="imgShadow"></div>
        <img src="${train.trainImgUrl}"/>
        <div class="detailLlabel clearfix">
            <span>${train.tagName}</span>
            <span>${train.trainTag}</span>
        </div>
    </div>
    <div class="pxd-biao clearfix">
        <div class="tit">${train.trainTitle}</div>
        <div class="people">报名人数：<i>
            <c:if test="${not empty train.maxPeople}">${train.admissionsPeoples}</i>/${train.maxPeople}</c:if>
            <c:if test="${empty train.maxPeople}">${train.admissionsPeoples}</i></c:if>
            人</div>
        <div class="bottBox ${train.isCollect==1?'bottBoxChoose':''}">
            <div class="colImg"></div>
            <div class="collect" id="collectSign">
                <c:if test="${train.isCollect==1}">已收藏</c:if>
                <c:if test="${train.isCollect!=1}">收藏</c:if>
            </div>
        </div>
    </div>
    <div class="pxd-infoBox">
        <div class="pxd-infoItem clearfix">
            <div class="lab"><img src="${path}/STATIC/wechat/image/time.png"></div>
            <div class="cont">${train.registrationStartTime.replace('-','.')}
                —${train.registrationEndTime.replace('-','.')}
            </div>
        </div>
        <div class="pxd-infoItem clearfix"
                 onclick="location.href='${path}/wechatTrain/trainField.do?id=${train.id}'">
            <div class="lab date"><img src="${path}/STATIC/wechat/image/date.png"></div>
            <div class="cont countDate">${fn:substring(train.trainStartTime,0,16).replace('-','.')} -
                ${fn:substring(train.trainEndTime,0,16).replace('-','.')}</div>
            <div class="dateArrow">查看课程表</div>
        </div>
        <div class="pxd-infoItem clearfix preAddressMap">
            <div class="lab"><img src="${path}/STATIC/wechat/image/add.png"></div>
            <div class="cont address">${train.trainAddress}</div>
            <div class="arrow"></div>
        </div>
        <div class="pxd-infoItem clearfix">
            <div class="lab"><img src="${path}/STATIC/wechat/image/person.png"></div>
            <div class="cont">报名年龄限制：男（${train.maleMinAge}-${train.maleMaxAge}岁）；女（${train.femaleMinAge}-${train.femaleMaxAge}岁）</div>
        </div>
        <div class="pxd-infoItem clearfix">
            <div class="lab"><img src="${path}/STATIC/wechat/image/phone.png"></div>
            <div class="cont"><a href="tel:${train.consultingPhone}">${train.consultingPhone}</a></div>
            <div class="arrow"></div>
        </div>
    </div>
    <div class="pxFilter" style="position: static;border-bottom: 1px solid #ededed;">
        <ul class="shaiBox clearfix">
            <li>报名要求<i class="x"></i></li>
            <li class="cur">课程简介<i class="x"></i></li>
            <li>师资介绍<i class="x"></i></li>
        </ul>
    </div>
    <div class="px-zongCont" id="content">
        <div class="kcszbm" style="display: none;">
            ${train.registrationRequirements}
        </div>
        <div class="kcszbm">
            ${train.courseIntroduction}
        </div>
        <div class="kcszbm" style="display: none;">
            ${train.teachersIntroduction}
        </div>
    </div>
    <c:if test="${not empty train.reminder}">
        <div class="px-zongTit"><span>温馨提示</span></div>
        <div class="px-zongCont">
                ${train.reminder}
        </div>
    </c:if>
    <c:if test="${train.admissionType ==4}">
        <div class="px-zongTit"><span>面试信息</span></div>
        <div class="px-zongCont">
            面试时间：${train.interviewTime} <br>
            面试地点：${train.interviewAddress}
        </div>
    </c:if>
    <div class="px-zongTit"><span id="commentToatl">评论（共128条）</span><em class="more">更多&gt;&gt;</em></div>
        <ul class="px-commentList">

        </ul>
    <a class="px-plTiao" href="javascript:toComment()"><img
            src="${path}/STATIC/wechat/image/px-pl.png"/>评论</a>
    <div class="px-btBtn-wc">
    </div>
</div>
</body>
<script type="text/javascript">
    getAppUserId();
    function toComment() {
        console.log(userId);
        if (userId == null || userId == '') {
            //判断登陆
            publicLogin("${basePath}wechatTrain/trainDetail.do?id=${train.id}&userId="+userId);
        } else {
            window.location.href = '${path}/wechat/preAddWcComment.do?moldId=${train.id}&type=10&commentRkName=${train.trainTitle}';
        }
    }

    $(function () {
        $('.pxd-biao').on('click', '.bottBox', function () {

            if (userId == null || userId == '') {
                publicLogin('${basePath}wechatTrain/trainDetail.do?id=${train.id}&userId='+userId);
                return;
            }
            if ($(this).hasClass("bottBoxChoose")) {
                $.post("${path}/wechat/wcDelCollect.do", {
                    relateId: '${train.id}',
                    userId: userId,
                    type: 2,
                }, function (data) {
                    if (data.status == 0) {
                        console.log($(this));
                        $("#collectSign").html('收藏')
                        dialogAlert("收藏提示", "已取消收藏！");
                    }
                }, "json");
            } else {
                $.post("${path}/wechat/wcCollect.do", {
                    relateId: '${train.id}',
                    userId: userId,
                    type: 2,
                }, function (data) {
                    if (data.status == 0) {
                        console.log($(this));
                        $("#collectSign").html('已收藏')
                        dialogAlert("收藏提示", "收藏成功！");
                    }
                }, "json");
            }
            $(this).toggleClass("bottBoxChoose")
        });

        $('.shaiBox').on('click', 'li', function () {
            $(this).addClass('cur').siblings('li').removeClass('cur');
            $('.px-zongCont .kcszbm').hide();
            $('.px-zongCont .kcszbm').eq($(this).index()).show();
        });

        //关闭弹窗
        $(".know").click(function(){
            $(".alertMsg").hide()
        })

        //地址地图
        $('.preAddressMap').on('click', function () {
            window.location.href = "${path}/wechat/preAddressMap.do?lat=${train.lat}&lon=${train.lon}";
        })

        var regStarttime = '${train.registrationStartTime}';
        var regEndtime = '${train.registrationEndTime}';
        var traStarttime = '${train.trainStartTime}';
        var traEndtime = '${train.trainEndTime}';
        var now = '${now}';

        if(now < traEndtime){
            if (${train.admissionsPeoples >= train.maxPeople}) {
                $('.px-btBtn-wc').html('<a class="px-btBtn gray" href="javascript:;">报名名额已满</a>');
            } else {
                if (now < regStarttime) {
                    $('.px-btBtn-wc').html('<a class="px-btBtn gray" href="javascript:;">报名未开始</a>');
                } else if (now > regEndtime) {
                    $('.px-btBtn-wc').html('<a class="px-btBtn gray" href="javascript:;">报名已结束</a>');
                } else {
                    $('.px-btBtn-wc').html('<a class="px-btBtn signBtn" href="###">立即报名</a>');
                }
            }
            /*if (${train.isRegistration>=1}) {
                $('.px-btBtn-wc').html('<a class="px-btBtn gray" href="###">您已报名</a>');
            } else {
                if (${train.admissionsPeoples >= train.maxPeople}) {
                    $('.px-btBtn-wc').html('<a class="px-btBtn gray" href="javascript:;">报名名额已满</a>');
                } else {
                    if (now < regStarttime) {
                        $('.px-btBtn-wc').html('<a class="px-btBtn gray" href="javascript:;">报名未开始</a>');
                    } else if (now > regEndtime) {
                        $('.px-btBtn-wc').html('<a class="px-btBtn gray" href="javascript:;">报名已结束</a>');
                    } else {
                        $('.px-btBtn-wc').html('<a class="px-btBtn signBtn" href="###">立即报名</a>');
                    }
                }
            }*/
        }else{
            $('.px-btBtn-wc').html('<a class="px-btBtn gray" href="javascript:;">培训已结束</a>');
        }
/*        if (${train.isRegistration>=1}) {
            $('.px-btBtn-wc').html('<a class="px-btBtn gray" href="###">您已报名</a>');
        } else {
            if (${train.admissionsPeoples >= train.maxPeople}) {
                $('.px-btBtn-wc').html('<a class="px-btBtn gray" href="javascript:;">报名名额已满</a>');
            } else {
                if (now < starttime) {
                    $('.px-btBtn-wc').html('<a class="px-btBtn gray" href="javascript:;">报名未开始</a>');
                } else if (now > endtime) {
                    $('.px-btBtn-wc').html('<a class="px-btBtn gray" href="javascript:;">报名已结束</a>');
                } else {
                    $('.px-btBtn-wc').html('<a class="px-btBtn signBtn" href="###">立即报名</a>');
                }
            }
        }*/

        $(".signBtn").on('click', function () {
            if (userId == null || userId == '') {
                publicLogin('${basePath}wechatTrain/trainDetail.do?id=${train.id}&userId='+userId);
                return;
            }
            $.post('${path}/wechatTrain/checkEntry.do', {id: '${train.id}'}, function (data) {
                data = JSON.parse(data);
                if (data.status != 200) {
                    dialogAlert("报名提示", data.data);
                } else {
                    window.location.href = '${path}/wechatTrain/toEntry.do?id=${train.id}&userId='+userId;
                }
            })
        })

        $(".more").on('click', function () {
            if (userId == null || userId == '') {
                publicLogin('${path}/wechatTrain/trainComment.do?id=${train.id}');
            }else{
                window.location.href= '${path}/wechatTrain/trainComment.do?id=${train.id}';
            }
        })
        loadComment();

        formatStyle('content');
    });


    //评论列表
    function loadComment() {
        var data = {
            moldId: '${train.id}',
            type: 10,
            pageIndex: 0,
            pageNum: 3
        };
        $.post("${path}/wechat/weChatComment.do", data, function (data) {
            $("#commentToatl").html('评论（共' + data.pageTotal + '条）');
            if (data.status == 0) {
                if (data.data.length > 0) {
                    $("#commentLi").show();
                }
                var html = "";
                $.each(data.data, function (i, dom) {

                    var userHeadImgUrl = '';
                    if (dom.userHeadImgUrl.indexOf("http") == -1) {
                        userHeadImgUrl = '../STATIC/wx/image/sh_user_header_icon.png';
                    } else if (dom.userHeadImgUrl.indexOf("front") != -1) {
                        userHeadImgUrl = getIndexImgUrl(dom.userHeadImgUrl, "_300_300");
                    } else {
                        userHeadImgUrl = dom.userHeadImgUrl;
                    }

                    html += "<li class=\"clearfix\">";
                    html += '<div class="clearfix">';
                    html += '<div class="avatar"><img src="' + userHeadImgUrl + '"></div>';
                    html += '<div class="youwz">';
                    html += '<div class="name">' + dom.commentUserNickName + '</div>';
                    html += '<div class="time">' + dom.commentTime + '</div>';
                    html += '</div>';
                    html += '</div>';
                    html += '<div class="cont">' + dom.commentRemark + '</div>';
                    html += '<div class="picList clearfix">';
                    var commentImgUrlHtml = "";
                    if (dom.commentImgUrl.length != 0) {
                        var commentImgUrls = dom.commentImgUrl.substring(0, dom.commentImgUrl.length - 1).split(",");
                        $.each(commentImgUrls, function (i, commentImgUrl) {
                            var smallCommentImgUrl = getIndexImgUrl(commentImgUrl, "_150_150");
                            html += '<div class="pItem"><img src="' + smallCommentImgUrl + '" onclick="previewImage(\'' + commentImgUrl + '\',\'' + dom.commentImgUrl + '\')"></div>';
                        });
                    }

                    html += '<div>';
                    html += ' </li>';

                });
                $(".px-commentList").html(html);
                //imgStyleFormat('commentImgHtml','commentImgUrlHtml');
            }
        }, "json");
    }

    //图片预览
    function previewImage(url, urls) {
        wx.previewImage({
            current: url, // 当前显示图片的http链接
            urls: urls.substring(0, urls.length - 1).split(",")	 // 需要预览的图片http链接列表
        });
    }

    //富文本格式修改
    function formatStyle(id) {
        var $cont = $("#" + id);
        $cont.find("img").each(function () {
            var $this = $(this);
            $this.css({"max-width": "690px"});
        });
        $cont.find("p,font").each(function () {
            var $this = $(this);
            $this.css({
                "font-size": "24px",
                "line-height": "34px",
                "color": "#7C7C7C",
                "font-family": "Microsoft YaHei"
            });
        });
        $cont.find("span").each(function () {
            var $this = $(this);
            $this.css({
                "font-size": "24px",
                "line-height": "34px",
                "font-family": "Microsoft YaHei"
            });
        });
        $cont.find("a").each(function () {
            var $this = $(this);
            $this.css({
                "text-decoration": "underline",
                "color": "#7C7C7C"
            });
        });
        var str = $cont.html();
        str.replace(/<span>/g, "").replace(/<\/span>/g, "");
        $cont.html(str);
    }
</script>
</html>
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
    <!-- <title>评论列表</title> -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wx/css/reset-mc.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wx/css/mc-mobile.css"/>
    <script type="text/javascript" src="${path}/STATIC/wx/js/mc-mobile.js"></script>
    <script type="text/javascript" src="${path}/STATIC/wx/js/iscroll.js"></script>
    <script type="text/javascript" src="${path}/STATIC/wx/js/scrollLoadData.js"></script>

    <script type="text/javascript">
        var moldId = '${moldId}';
        var type = '${type}';
        var userId = '${sessionScope.terminalUser.userId}';

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
                    jsApiList: ['previewImage']
                });
            }

            loadData(0, 20);
        });

        //评论列表
        function loadData(index, pagesize) {
            pageSize = pagesize;
            startIndex = index;
            var data = {
                moldId: moldId,
                type: type,
                pageIndex: startIndex,
                pageNum: pageSize
            };
            $.post("${path}/wechat/weChatComment.do", data, function (data) {

                if (data.data.length > 0) {
                    isScroll = true;
                } else {
                    isScroll = false;
                    pullUpEl.className = 'none';
                    pullUpEl.querySelector('.pullUpLabel').innerHTML = '没有结果了';
                }

                if (startIndex == 0) {  //如果是第一页
                    setTimeout(function () {
                        if (data.status == 0) {
                            $.each(data.data, function (i, dom) {
                                var commentImgUrlHtml = "";
                                if (dom.commentImgUrl.length != 0) {
                                    var commentImgUrls = dom.commentImgUrl.substring(0, dom.commentImgUrl.length - 1).split(",");
                                    $.each(commentImgUrls, function (i, commentImgUrl) {
                                        smallCommentImgUrl = getIndexImgUrl(commentImgUrl, "_150_150");
                                        commentImgUrlHtml += "<img src='" + smallCommentImgUrl + "' width='168' height='168' onclick='previewImage(\"" + commentImgUrl + "\");'>"
                                    });
                                }
                                var userHeadImgUrl = '';
                                if (dom.userHeadImgUrl.indexOf("http") == -1) {
                                    userHeadImgUrl = '../STATIC/wx/image/sh_user_header_icon.png';
                                } else if (dom.userHeadImgUrl.indexOf("/front/") != -1) {
                                	var smallUrl = getIndexImgUrl(dom.userHeadImgUrl, "_72_72");
                                    var bigUrl = getIndexImgUrl(dom.userHeadImgUrl, "_300_300");
                                    var ImgObj = new Image();
                                    ImgObj.src = smallUrl;
                                    if (ImgObj.fileSize > 0 || (ImgObj.width > 0 && ImgObj.height > 0)) {
                                        userHeadImgUrl = smallUrl;
                                    } else {
                                        userHeadImgUrl = bigUrl;
                                    }
                                } else {
                                    userHeadImgUrl = dom.userHeadImgUrl;
                                }
                                $("#commentList").append(
                                        "<dl class='clearfix'>" +
                                        "<dt>" +
                                        "<a><img src='" + userHeadImgUrl + "' width='65' height='65' onerror='imgNoFind();'></a>" +
                                        "</dt>" +
                                        "<dd>" +
                                        "<div class='name_date'>" +
                                        "<a>" + dom.commentUserNickName + "</a>" +
                                        "<span>" + dom.commentTime + "</span>" +
                                        "</div>" +
                                        "<p>" + dom.commentRemark + "</p>" +
                                        "<div class='pic'>" +
                                        commentImgUrlHtml +
                                        "</div>" +
                                        "</dd>" +
                                        "</dl>");
                            });
                        }
                        myScroll.refresh();
                    }, 0);

                    $("html,body").animate({scrollTop: 0}, 200);
                } else {
                    setTimeout(function () {
                        if (data.status == 0) {
                            $.each(data.data, function (i, dom) {
                                var commentImgUrlHtml = "";
                                if (dom.commentImgUrl.length != 0) {
                                    var commentImgUrls = dom.commentImgUrl.substring(0, dom.commentImgUrl.length - 1).split(",");
                                    $.each(commentImgUrls, function (i, commentImgUrl) {
                                        var smallCommentImgUrl = getIndexImgUrl(commentImgUrl, "_150_150");
                                        commentImgUrlHtml += "<img src='" + smallCommentImgUrl + "' width='168' height='168' onclick='previewImage(\"" + commentImgUrl + "\");'>"
                                    });
                                }
                                var userHeadImgUrl = '';
                                if (dom.userHeadImgUrl == undefined || dom.userHeadImgUrl.indexOf("front") == -1) {
                                    userHeadImgUrl = '../STATIC/wx/image/sh_user_header_icon.png';
                                } else {
                                    userHeadImgUrl = getIndexImgUrl(dom.userHeadImgUrl, "_72_72");
                                }
                                $("#commentList").append(
                                        "<dl class='clearfix'>" +
                                        "<dt>" +
                                        "<a><img src='" + userHeadImgUrl + "' width='65' height='65' onerror='imgNoFind();'></a>" +
                                        "</dt>" +
                                        "<dd>" +
                                        "<div class='name_date'>" +
                                        "<a>" + dom.commentUserNickName + "</a>" +
                                        "<span>" + dom.commentTime + "</span>" +
                                        "</div>" +
                                        "<p>" + dom.commentRemark + "</p>" +
                                        "<div class='pic'>" +
                                        commentImgUrlHtml +
                                        "</div>" +
                                        "</dd>" +
                                        "</dl>");
                            });
                        }
                        myScroll.refresh();
                    }, 500);
                }

                if (isScroll) {
                    startIndex += pageSize;
                }
            }, "json");
        }
        ;

        //图片预览
        function previewImage(url) {
            wx.previewImage({
                current: url, // 当前显示图片的http链接
                urls: [url]
            });
        }
    </script>
    <script>
        //初始化绑定iScroll控件
        document.addEventListener('touchmove', function (e) {
            e.preventDefault();
        }, false);
        document.addEventListener('DOMContentLoaded', function () {
            loaded();
        }, false);
    </script>
</head>
<body class="body">
<div id="wrapper">
    <div id="scroller" style="position:relative;">
        <div class="M_mydiscuss" id="commentList"></div>
        <div id="pullUp">
            <span class="pullUpIcon"></span><span class="pullUpLabel">上拉加载更多...</span>
        </div>
    </div>
</div>
</body>
</html>
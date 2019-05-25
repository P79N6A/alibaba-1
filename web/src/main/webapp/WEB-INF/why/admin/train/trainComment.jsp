<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
	<title>评论列表</title>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp" %>
    <script type="text/javascript" src="${path}/STATIC/wechat/js/jquery.lazyload.min.js"></script>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/peixun.css" />

    <script src="${path}/STATIC/js/avalon.js"></script>
	<script type="text/javascript">
        var startIndex = 0;		//页数


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
<div class="px-commentAllTop clearfix">
	<div class="pic"><img src="${train.trainImgUrl}"></div>
	<div class="char">
		<div class="tit">${train.trainTitle}</div>
		<div class="wz">报名时间：${fn:substring(train.registrationStartTime,0,10).replace('-','.')}-${fn:substring(train.registrationEndTime,0,10).replace('-','.')}</div>
		<div class="wz">开课时间：${fn:substring(train.trainStartTime,0,10).replace('-','.')}-${fn:substring(train.trainEndTime,0,10).replace('-','.')}</div>
		<div class="wz">上课地址：${train.trainAddress}</div>
	</div>
</div>
<div class="px-zongTit" onclick="window.location.href='comment.html'"><span id="commentToatl"></span></div>
<ul class="px-commentList" style="min-height: 1020px;">

</ul>
</div>
</body>
<script type="text/javascript">


	var dataLength = 0;
    //滑屏分页
    $(window).on("scroll", function () {
        $("#loadingDiv").show();
        var scrollTop = $(document).scrollTop();
        var pageHeight = $(document).height();
        var winHeight = $(window).height();
        if (scrollTop >= (pageHeight - winHeight - 100) && dataLength >= 20) {
            startIndex += 20;
            var index = startIndex;
            setTimeout(function () {
                loadComment(index, 20);
            },1000);
        }
    });

    loadComment(0,20);

    //评论列表
    function loadComment(startIndex,pageNum) {
        var data = {
            moldId: '${train.id}',
            type: 10,
            pageIndex: startIndex,
            pageNum: pageNum
        };
        $.post("${path}/wechat/weChatComment.do", data, function (data) {
            $("#commentToatl").html('评论（共'+data.pageTotal+'条）');
            if (data.status == 0) {
           		dataLength = data.data.length;
                if(data.data.length>0){
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

					html +="<li class=\"clearfix\">";
					html+='<div class="clearfix">';
					html+='<div class="avatar"><img src="'+userHeadImgUrl+'"></div>';
					html+='<div class="youwz">';
					html+='<div class="name">'+dom.commentUserNickName+'</div>';
					html+='<div class="time">'+dom.commentTime+'</div>';
					html+='</div>';
					html+='</div>';
					html+='<div class="cont">'+ dom.commentRemark+'</div>';
					html+='<div class="picList clearfix">';
                    var commentImgUrlHtml = "";
                    if (dom.commentImgUrl.length != 0) {
                        var commentImgUrls = dom.commentImgUrl.substring(0, dom.commentImgUrl.length - 1).split(",");
                        $.each(commentImgUrls, function (i, commentImgUrl) {
                            var smallCommentImgUrl = getIndexImgUrl(commentImgUrl, "_150_150");
                            html+='<div class="pItem"><img src="'+ smallCommentImgUrl+'" onclick="previewImage(\''+commentImgUrl+'\',\''+dom.commentImgUrl+'\')"></div>';
                        });
                    }

					html+='<div>';
					html+=' </li>';

                });
                $(".px-commentList").append(html);
                //imgStyleFormat('commentImgHtml','commentImgUrlHtml');
            }
        }, "json");
    }
    //图片预览
    function previewImage(url,urls) {
        wx.previewImage({
            current: url, // 当前显示图片的http链接
            urls: urls.substring(0, urls.length - 1).split(",")	 // 需要预览的图片http链接列表
        });
    }
</script>
</html>
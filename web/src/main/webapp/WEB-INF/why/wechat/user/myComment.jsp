<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>我的评论</title>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp" %>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>
    <script src="${path}/STATIC/js/avalon.js"></script>
    <style>
   		html,body{
    		height: 100%;
    		background-color: #f3f3f3;
    	}
        .content {
            padding-top: 90px;
            padding-bottom: 18px;
        }
    </style>
</head>
<body>
<div class="main">
    <div class="header" ms-controller="header">
        <%-- <div class="index-top">
			<span class="index-top-5">
				<img src="${path}/STATIC/wechat/image/arrow1.png"  onclick="history.go(-1);"/>
			</span>
            <span class="index-top-2">我的评论</span>
        </div> --%>
        <div class="my-keep-place">
            <ul>
                <li>
                    <a>
                        <div ms-click="pick('activity')" id="activityTag" class="border-right border-bottom"
                             ms-class="keep-bottom-br:toggle">
                            <p style="line-height: 90px;">活动</p>
                        </div>
                    </a>
                </li>
                <li>
                    <a>
                        <div ms-click="pick('venue')" id="venueTag" class="border-bottom"
                             ms-class="keep-bottom-br:!toggle">
                            <p style="line-height: 90px;">场馆</p>
                        </div>
                    </a>
                </li>
                <div style="clear: both;"></div>
            </ul>
        </div>
    </div>
    <div class="content" ms-controller="content">
        <div class="my-comment">
            <ul>{{comment|html}}</ul>
        </div>
        {{page|html}}
    </div>
</div>
</body>
<script type="text/javascript">
    //滑屏分页
    $(window).on("scroll", function () {
        var scrollTop = $(document).scrollTop();
        var pageHeight = $(document).height();
        var winHeight = $(window).height();
        if (scrollTop >= (pageHeight - winHeight - 100)) {
            setTimeout(function () {
                hd.pageSel();
            },1000);
        }
    });
    var hd = avalon.define({
        $id: "header",
        toggle: false,
        pageNum: 20,
        pageIndex: 0,
        pageSel: function () {
            hd.pageIndex += 20;
            if (hd.toggle) {
                hd.activity();
            } else {
                hd.venue();
            }
        },
        activity: function () {
            hd.toggle = true;
            $.post("${path}/wechatUser/activityCommentList.do", {
                userId: userId,
                pageNum: hd.pageNum,
                pageIndex: hd.pageIndex
            }, function (data) {
                if (data.status == 1) {
                	if(data.data.length<20){
            			if(data.data.length==0&&hd.pageIndex==0){
            				co.page="<div id='loadingDiv' class='loadingDiv'><span class='noLoadingSpan' style='padding-left:196px;'>您还没评论过任何活动~</span></div>";
            			}else{
            				co.page="";
            			}
	        		}
                    $.each(data.data, function (i, dom) {
                        var commentImgUrlHtml = "";
                        if (dom.commentImgUrl.length != 0) {
                            var commentImgUrls = dom.commentImgUrl.substring(0, dom.commentImgUrl.length).split(",");
                            $.each(commentImgUrls, function (i, commentImgUrl) {
                                var smallCommentImgUrl = getIndexImgUrl(commentImgUrl, "_150_150");
                                commentImgUrlHtml += "<li><img  src='" + smallCommentImgUrl + "' onclick='hd.previewImage(\"" + commentImgUrl + "\",\""+dom.commentImgUrl+"\");'></li>"
                            });
                        }
                        co.comment += "<li><div class=\"my-comment-p\"><h2>" + dom.activityName + "</h2> <div class=\"my-comment-place\">" + dom.venueName + "</div><div class=\"comment-p1\"><p>“" + dom.commentRemark + "”</p><ul style='width:560px;'>" + commentImgUrlHtml + "</ul><div style='clear: both;'></div> </div> <p class=\"comment-p2\">" + dom.commentTime + "</p></div> </li>";
                    });
                    imgStyleFormat('my-comment', 'comment-p1');
                }
            }, "json");
        },
        venue: function () {
            hd.toggle = false;
            $.post("${path}/wechatUser/venueCommentList.do", {
                userId: userId,
                pageNum: hd.pageNum,
                pageIndex: hd.pageIndex
            }, function (data) {
                if (data.status == 1) {
                	if(data.data.length<20){
            			if(data.data.length==0&&hd.pageIndex==0){
            				co.page="<div id='loadingDiv' class='loadingDiv'><span class='noLoadingSpan' style='padding-left:196px;'>您还没评论过任何场馆~</span></div>";
            			}else{
            				co.page="";
            			}
	        		}
                    $.each(data.data, function (i, dom) {
                        var commentImgUrlHtml = "";
                        if (dom.commentImgUrl.length != 0) {
                            var commentImgUrls = dom.commentImgUrl.substring(0, dom.commentImgUrl.length).split(",");
                            $.each(commentImgUrls, function (i, commentImgUrl) {
                                var smallCommentImgUrl = getIndexImgUrl(commentImgUrl, "_150_150");
                                commentImgUrlHtml += "<li><img  src='" + smallCommentImgUrl + "' onclick='hd.previewImage(\"" + commentImgUrl + "\",\""+dom.commentImgUrl+"\");'></li>"
                            });
                        }
                        co.comment += "<li><div class=\"my-comment-p\"><h2>" + dom.venueName + "</h2><div class=\"comment-p1\"><p>“" + dom.commentRemark + "”</p><ul style='width:560px;'>" + commentImgUrlHtml + "</ul><div style='clear: both;'></div> </div> <p class=\"comment-p2\">" + dom.commentTime + "</p></div> </li>";
                    });
                    imgStyleFormat('my-comment', 'comment-p1');
                }
            }, "json");
        },
        pick: function (choose) {
            co.comment = "";
            hd.pageIndex = 0;
            co.page=co.pageLoad;
            if (choose == 'activity') {
                hd.activity();
            } else {
                hd.venue();
            }
        },
        //图片预览
        previewImage: function (url,urls) {
        wx.previewImage({
            current: url, // 当前显示图片的http链接
            urls: urls.substring(0, urls.length).split(",")	 // 需要预览的图片http链接列表
        })
    }
    });
    var co = avalon.define({
        $id: "content",
        comment: "",
        page: "",
        pageLoad: "<div id='loadingDiv' class='loadingDiv'><img class='loadingImg' src='${path}/STATIC/wechat/image/loading.gif' /><span class='loadingSpan'>加载中。。。</span><div style='clear:both'></div></div>",
    });
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
        hd.pick("activity");
    });
</script>

</html>

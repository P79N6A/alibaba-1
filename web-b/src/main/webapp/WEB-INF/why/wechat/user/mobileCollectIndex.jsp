<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp" %>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>
    <style>
    	html,body{
    		height: 100%;
    		background-color: #f3f3f3;
    	}
        .content {
        	padding-top: 190px;
            padding-bottom: 18px;
        }
    </style>
</head>
<body>
<div class="main">
    <div class="header" ms-controller="header">
        <div class="index-top">
					<span class="index-top-5">
						<img src="${path}/STATIC/wechat/image/arrow1.png"  onclick="history.go(-1);"/>
					</span>
            <span class="index-top-2">我的收藏</span>
        </div>
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
        <div class="keep-list">
            <ul> {{collect|html}}</ul>
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
                hd.page();
            },1000);
        }
    });
    var userId = '${sessionScope.terminalUser.userId}';
    var hd = avalon.define({
        $id: "header",
        toggle: false,
        pageNum: 20,
        pageIndex: 0,
        page: function () {
            hd.pageIndex += 20;
            if (hd.toggle) {
                hd.activity();
            } else {
                hd.venue();
            }
        },
        activity: function () {
            hd.toggle = true;
            $.post("${path}/wechatUser/userCollectAct.do", {
                userId: userId,
                pageNum: hd.pageNum,
                pageIndex: hd.pageIndex
            }, function (data) {
                if (data.status == 0) {
                    if(data.data.length<20){
            			if(data.data.length==0&&hd.pageIndex==0){
            				co.page="<div id='loadingDiv' class='loadingDiv'><span class='noLoadingSpan' style='padding-left:196px;'>您还没收藏过任何活动~</span></div>";
            			}else{
            				co.page="";
            			}
	        		}
                    $.each(data.data, function (i, dom) {
                        co.collect += "<li><div class='keep-list-p'><div onclick=\"hd.showActivity('" + dom.activityId + "')\" class='keep-list-img'><img width='270' height='180' src='"+dom.activityIconUrl+"' /></div><div class='keep-list-detail'><h2>"+dom.activityName+"</h2><p>"+dom.activityStartTime.substring(5,10).replace('-','.')+"-"+dom.activityEndTime.substring(5,10).replace('-','.')+"</p></div><div style='clear: both;'></div> <div class='keep-detail-place'>"+dom.venueName+"</div><div onclick=\"hd.wcDelCollect('" + dom.activityId + "')\" class='keep-list-del'><img src='${path}/STATIC/wechat/image/mobile_close.png'/></div></div></li>";
                    });
                }
            }, "json");
        },
        venue: function () {
            hd.toggle = false;
            $.post("${path}/wechatUser/userCollectVen.do", {
                userId: userId,
                pageNum: hd.pageNum,
                pageIndex: hd.pageIndex
            }, function (data) {
                if (data.status == 0) {
                	if(data.data.length<20){
            			if(data.data.length==0&&hd.pageIndex==0){
            				co.page="<div id='loadingDiv' class='loadingDiv'><span class='noLoadingSpan' style='padding-left:196px;'>您还没收藏过任何场馆~</span></div>";
            			}else{
            				co.page="";
            			}
	        		}
                    $.each(data.data, function (i, dom) {
                        co.collect += "<li><div class='keep-list-p'><div onclick=\"hd.showVenue('" + dom.venueId + "')\" class='keep-list-img'><img width='270' height='180' src='"+dom.venueIconUrl+"' /></div><div class='keep-list-detail'><h2>"+dom.venueName+"</h2></div><div style='clear: both;'></div> <div class='keep-detail-place'>"+dom.venueAddress+"</div><div onclick=\"hd.wcDelCollectVenue('" + dom.venueId + "')\" class='keep-list-del'><img src='${path}/STATIC/wechat/image/mobile_close.png' /></div> </div> </li>";
                    });
                }
            }, "json");
        },
        pick: function (choose) {
            co.collect = "";
            hd.pageIndex = 0;
            co.page=co.pageLoad;
            if (choose == 'activity') {
                hd.activity();
            } else {
                hd.venue();
            }
        },
        wcDelCollect: function (activityId) {
            $.post("${path}/wechatActivity/wcDelCollectActivity.do", {
                activityId: activityId,
                userId: userId
            }, function (data) {
                if (data.status == 0) {
                    dialogAlert("收藏提示", "已取消收藏！" );
                    hd.pick("activity");
                }
            }, "json");
        },
        wcDelCollectVenue: function (venueId) {
            $.post("${path}/wechatVenue/wcDelCollectVenue.do", {
                venueId: venueId,
                userId: userId
            }, function (data) {
                if (data.status == 0) {
                    dialogAlert("收藏提示", "已取消收藏！");
                    hd.pick("venue");
                }
            }, "json");
        },
        showActivity: function (activityId) {
            window.location.href = "${path}/wechatActivity/preActivityDetail.do?activityId=" + activityId;
        },
        showVenue: function (venueId) {
            window.location.href = "${path}/wechatVenue/venueDetailIndex.do?venueId=" + venueId;
        }
    });

    var co = avalon.define({
        $id: "content",
        collect: "",
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

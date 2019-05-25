<%@ page language="java" pageEncoding="UTF-8" %>
<link rel="stylesheet" href="//g.alicdn.com/msui/sm/0.6.2/css/sm.min.css">
<link rel="stylesheet" href="//g.alicdn.com/msui/sm/0.6.2/css/sm-extend.min.css">
<script type='text/javascript' src='//g.alicdn.com/sj/lib/zepto/zepto.min.js' charset='utf-8'></script>
<script type='text/javascript' src='//g.alicdn.com/msui/sm/0.6.2/js/sm.min.js' charset='utf-8'></script>
<script type='text/javascript' src='//g.alicdn.com/msui/sm/0.6.2/js/sm-extend.min.js' charset='utf-8'></script>
<style>
    .vol-menu {
        position: absolute;
        bottom: 60px;
        right: 60px;
        width: 50px;
        height: 50px;
        border-radius: 50%;
        opacity: .5;
    }
    .vol-menu .vol-menu-icon{
        width: 100%;
    }
</style>
<div class="vol-menu">
    <img class="vol-menu-icon" src="${path}/STATIC/wechat/image/menu.png">
</div>
<div class="panel-overlay"></div>
<!-- Left Panel with Reveal effect -->
<div class="panel panel-left panel-cover theme-dark" id='panel-js-demo'>
    <div class="list-block">
        <ul>
            <li class="item-content item-link" onclick="location.href='${path}/wechat/index.do'">
                <div class="item-media"><i class="icon icon-f7"></i></div>
                <div class="item-inner">
                    <div class="item-title">首页</div>
                    <div class="item-after"></div>
                </div>
            </li>
            <li class="item-content item-link" onclick="location.href='${path}/wechatActivity/index.do'">
                <div class="item-media"><i class="icon icon-f7"></i></div>
                <div class="item-inner">
                    <div class="item-title">活动</div>
                    <div class="item-after"></div>
                </div>
            </li>
            <li class="item-content item-link" onclick="location.href='${path}/wechatVenue/toSpace.do'">
                <div class="item-media"><i class="icon icon-f7"></i></div>
                <div class="item-inner">
                    <div class="item-title">场馆</div>
                    <div class="item-after"></div>
                </div>
            </li>
            <li class="item-content item-link" onclick="location.href='${path}/wechatActivity/activitySearchIndex.do'">
                <div class="item-media"><i class="icon icon-f7"></i></div>
                <div class="item-inner">
                    <div class="item-title">搜索</div>
                    <div class="item-after"></div>
                </div>
            </li>
            <li class="item-content item-link" onclick="location.href='${path}/wechatUser/preTerminalUser.do'">
                <div class="item-media"><i class="icon icon-f7"></i></div>
                <div class="item-inner">
                    <div class="item-title">个人中心</div>
                    <div class="item-after"></div>
                </div>
            </li>
        </ul>
    </div>
</div>
<script>
    $(document).on("click", ".vol-menu", function() {
        $.openPanel("#panel-js-demo");
    });
</script>
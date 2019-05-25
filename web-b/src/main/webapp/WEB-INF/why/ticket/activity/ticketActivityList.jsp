
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>取票机--活动列表--文化云</title>
    <%@include file="/WEB-INF/why/common/ticketFrame.jsp"%>
    <script type="text/javascript" src="${path}/STATIC/js/ticket/activity/ticketActivityList.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/ticket/activity/ticketActivitySelectTopLabel.js"></script>
</head>
<body style="background: #eef4f7;">

<!-- ticket_top start -->
<%@include file="/WEB-INF/why/ticket/ticket-nav.jsp"%>
<!-- ticket_top end -->

<form action="" id="ticketForm" name="ticketForm" method="post" >
    <input type = "hidden" name="activityLocation" id="activityLocation" value="${activity.activityLocation}" />
    <input type="hidden" name="activityType" id="activityType" value="${activity.activityType}"/>
    <input type="hidden" id="page" name="page" value="1">
    <input type="hidden" name="activityArea" id="areaCode" value="${activity.activityArea}" />

<div class="venue_list_content ticket-activity-list">
    <div id="search" class="activity-search">
        <div class="search-menu" id="activityTypeMenu">
            <a class="icon cur"><img src="${path}/STATIC/image/search-icon1.png" data-img="${path}/STATIC/image/search-icon1.png" data-hover="${path}/STATIC/image/search-icon1a.png"/><span>全部</span></a>
            <a class="icon"><img src="${path}/STATIC/image/search-icon2.png" data-img="${path}/STATIC/image/search-icon2.png" data-hover="${path}/STATIC/image/search-icon2a.png"/><span>展览</span></a>
            <a class="icon"><img src="${path}/STATIC/image/search-icon3.png" data-img="${path}/STATIC/image/search-icon3.png" data-hover="${path}/STATIC/image/search-icon3a.png"/><span>影视</span></a>
            <a class="icon"><img src="${path}/STATIC/image/search-icon4.png" data-img="${path}/STATIC/image/search-icon4.png" data-hover="${path}/STATIC/image/search-icon4a.png"/><span>歌舞</span></a>
            <a class="icon"><img src="${path}/STATIC/image/search-icon5.png" data-img="${path}/STATIC/image/search-icon5.png" data-hover="${path}/STATIC/image/search-icon5a.png"/><span>戏剧</span></a>
        </div>
        <div class="search">
            <div class="prop-attrs">
                <div class="attr">
                    <div class="attrKey">区域</div>
                    <div class="attrValue">
                        <ul class="av-expand">
                            <li class="cur"><a href="javascript:clickArea('');">上海市</a></li>
                            <li id="46"><a href="javascript:clickArea('46');">黄浦区</a></li>
                            <li id="48"><a href="javascript:clickArea('48');">徐汇区</a></li>
                            <li id="50"><a href="javascript:clickArea('50');">静安区</a></li>
                            <li id="49"><a href="javascript:clickArea('49');">长宁区</a></li>
                            <li id="51"><a href="javascript:clickArea('51');">普陀区</a></li>
                            <li id="52"><a href="javascript:clickArea('52');">闸北区</a></li>
                            <li id="53"><a href="javascript:clickArea('53');">虹口区</a></li>
                            <li id="54"><a href="javascript:clickArea('54');">杨浦区</a></li>
                            <li id="58"><a href="javascript:clickArea('58');">浦东新区</a></li>
                            <li id="56"><a href="javascript:clickArea('56');">宝山区</a></li>
                            <li id="57"><a href="javascript:clickArea('57');">嘉定区</a></li>
                            <li id="60"><a href="javascript:clickArea('60');">松江区</a></li>
                            <li id="61"><a href="javascript:clickArea('61');">青浦区</a></li>
                            <li id="55"><a href="javascript:clickArea('55');">闵行区</a></li>
                            <li id="59"><a href="javascript:clickArea('59');">金山区</a></li>
                            <li id="63"><a href="javascript:clickArea('63');">奉贤区</a></li>
                            <li id="64"><a href="javascript:clickArea('64');">崇明县</a></li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="prop-attrs hot-attrs" id="businessDiv" style="display:none;">
                <div class="attr">
                    <div class="attrKey" style="background:none;"></div>
                    <div class="attrValue">
                        <ul class="av-expand" id="businessUl">
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <%--<div class="search-btn">
            <input type="button" onclick="doQuery(1);" value="搜索"/>
        </div>--%>
    </div>
    <!-- list load  start-->
    <div id="activity_content">
    </div>
    <!-- list load  end-->
</div>
</form>
</body>
</html>
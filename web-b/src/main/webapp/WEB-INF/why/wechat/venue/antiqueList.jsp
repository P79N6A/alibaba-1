<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<script src="${path}/STATIC/js/common.js"></script>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css">
    <!-- <title>文物列表</title> -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/css2.css"/>
    <script type="text/javascript" src="${path}/STATIC/wechat/js/wechat.js"></script>
    <script type="text/javascript" src="${path}/STATIC/wx/js/wxcommon.js"></script>
    
    <script type="text/javascript">
        var str = "";
        var str1 = "";
        var str2 = "";
        var venueId = '${venueId}';
        $(function () {
            loadData(0, 999);
        });

        //朝代搜索
        function antiqueDynasty(dynasty) {
            $.post("${path}/wechatAntique/screenAppAntiqueDynasty.do", {
                antiqueDynasty: dynasty,
                venueId: venueId,
                pageNum: 99,
                pageIndex: 0
            }, function (data) {
                $("#antiqueList").html('');
                str = "";
                if (data.status == 0) {
                    $.each(data.data, function (i, dom) {
                        str += "<li onclick=\"window.location.href='${path}/wechatAntique/preAntiqueDetail.do?antiqueId=" + dom.antiqueId + "'\">";
                        str += "<img src='" + dom.antiqueImgUrl + "'>";
                        str += "<span>" + dom.antiqueName + "</span>";
                        str += "</li>";
                    });
                    $("#antiqueList").append(str);
                }
            }, "json");
        }
        //类型搜索
        function antiqueType(antique) {
            $.post("${path}/wechatAntique/screenAppAntiqueTypeName.do", {
                antiqueTypeName: antique,
                venueId: venueId,
                pageNum: 99,
                pageIndex: 0
            }, function (data) {
                $("#antiqueList").html('');
                str = "";
                if (data.status == 0) {
                    $.each(data.data, function (i, dom) {
                        str += "<li onclick=\"window.location.href='${path}/wechatAntique/preAntiqueDetail.do?antiqueId=" + dom.antiqueId + "'\">";
                        str += "<img src='" + dom.antiqueImgUrl + "'>";
                        str += "<span>" + dom.antiqueName + "</span>";
                        str += "</li>";
                    });
                    $("#antiqueList").append(str);
                }
            }, "json");
        }
        function loadData(index, pagesize) {
            pageSize = pagesize;
            startIndex = index;
            //载入搜索结果
            var data = {
                venueId: venueId,
                pageIndex: startIndex,
                pageNum: pageSize
            };
            $.post("${path}/wechatAntique/antiqueAppIndex.do", data, function (data) {
                $("#antiqueList").html('');
                $("#genre_list").html('');
                $("#dynasty_list").html('');
                str = "";
                str1 = "";
                str2 = "";
                if (data.status == 0) {
                	$("#antiqueTotal").html(data.data3);
                    $.each(data.data, function (i, dom) {
                        str += "<li onclick=\"window.location.href='${path}/wechatAntique/preAntiqueDetail.do?antiqueId=" + dom.antiqueId + "'\">";
                        str += "<img src='" + dom.antiqueImgUrl + "'>";
                        str += "<span>" + dom.antiqueName + "</span>";
                        str += "</li>";
                    });
                    $("#antiqueList").append(str);
                    str1 += "<a onclick=\"loadData(0, 999)\">查看全部</a>";
                    $.each(data.data1, function (i, dom) {
                        str1 += "<a onclick=\"antiqueType('" + dom.antique + "')\">" + dom.antique + "</a>";
                    });
                    $("#genre_list").append(str1);
                    str2 += "<a onclick=\"loadData(0, 999)\">查看全部</a>";
                    $.each(data.data2, function (i, dom) {
                        str2 += "<a onclick=\"antiqueDynasty('" + dom.dynasty + "')\">" + dom.dynasty + "</a>";
                    });
                    $("#dynasty_list").append(str2);
                }
            }, "json");
        }
        ;
    </script>

</head>
<body class="body">
	<div class="search_top">
	    <div class="l_arrow fl" style="margin-top: 32px;"><a href="javascript:history.back(-1);"><img src="${path}/STATIC/wechat/image/arrow1.png"/></a></div>
	    <div class="look fl" style="margin-left: 210px;">共计<span id="antiqueTotal"></span>件藏品</div>
	    <div class="clear"></div>
	</div>
	<div class="genre_dynasty clearfix" style="margin-top: 100px;">
	    <a class="genre" data-id="">类别</a>
	    <a class="dynasty" data-id="">朝代</a>
	    <div class="genre_list" id="genre_list" style="display:none;">
	        <a onclick="loadData(0, 999);" data-id="0">查看全部</a>
	    </div>
	    <div class="dynasty_list" id="dynasty_list" style="display:none;">
	        <a onclick="loadData(0, 999);" data-id="0">查看全部</a>
	    </div>
	</div>
	<div class="collect_display clearfix">
	    <ul id="antiqueList"></ul>
	</div>
</body>
</html>
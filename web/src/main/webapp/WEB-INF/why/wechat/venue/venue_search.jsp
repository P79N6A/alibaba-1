<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8">
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp" %>
    <!-- <title>场馆搜索</title> -->
    <%--<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/css.css"/>--%>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css">
    <script type="text/javascript" src="${path}/STATIC/wechat/js/wechat.js"></script>

    <script type="text/javascript">
        $(function () {

            empty();
            loadHistory();
            //loadWord()

        });

        //热门词汇
        function loadWord() {
            $.post("${path}/wechatVenue/getVenueHot.do", function (data) {
                if (data.status == 0) {
                    var hotArea = data.data;
                    var hotTag = data.data1;
                    var hotWord = data.data2;
                    hotAreaStr = "";
                    hotTagStr = "";
                    hotWordStr = "";
                    if (hotArea != null) {
                        for (var i = 0; i < hotArea.length; i++) {
                            hotAreaStr += '<li onclick="areaSearch(\'' + hotArea[i].areaCode.substring(0, 2) + '\')"><div>' + hotArea[i].areaCode.split(":")[1] + '</div></li>'
                        }
                        $("#hotArea").html(hotAreaStr);
                    }
                    if (hotTag != null) {
                        for (var i = 0; i < hotTag.length; i++) {
                            hotTagStr += '<li onclick="tagSearch(\'' + hotTag[i].tagId + '\')"><div>' + hotTag[i].tagName + '</div></li>'
                        }
                        $("#hotTag").html(hotTagStr);
                    }
                    if (hotWord != null) {
                        for (var i = 0; i < hotWord.length; i++) {
                            hotWordStr += '<li onclick="historySearch(\'' + hotWord[i].hotKeywords + '\')"><div>' + hotWord[i].hotKeywords + '</div></li>'
                        }
                        $("#hotWord").html(hotWordStr);
                    }

                }
            }, "json");
        }
        ;

        //响应搜索历史
        function historySearch(txt) {
            window.location.href = '${path}/wechatVenue/preVenueList.do?venueName=' + txt;
        }
        //响应搜索历史
        function areaSearch(txt) {
            window.location.href = '${path}/wechatVenue/preVenueList.do?venueArea=' + txt;
        }
        //响应搜索历史
        function tagSearch(txt) {
            window.location.href = '${path}/wechatVenue/preVenueList.do?venueType=' + txt;
        }
        //清空上次搜索
        function empty() {
            $("#venueName").val("搜索场馆");
            $("#venueType").val("");
            $("#venueIsReserve").val("");
            $("#venueArea").val("");
        }
        //搜索按钮
        function searchBtn() {
            var venueName = $("#venueName").val();
            var venueType = $("#venueType").val();
            var venueIsReserve = $("#venueIsReserve").val();
            var venueArea = $("#venueArea").val();
            if (venueName == "搜索场馆") {
                venueName = "";
            }
            //保存搜索历史
            if (venueName && $.trim(venueName)) {
                venueName = $.trim(venueName.split(",").join(''));
                var searchValue = window.localStorage.getItem("venueKey");
                if (searchValue) {
                    searchValue = venueName + "," + searchValue;
                    var arr = searchValue.split(",");
                    if (arr.length > 5) {
                        arr.pop();
                        window.localStorage.setItem("venueKey", arr.join());
                    } else {
                        window.localStorage.setItem("venueKey", searchValue);
                    }
                } else {
                    window.localStorage.setItem("venueKey", venueName);
                }
            }

            window.location.href = "${path}/wechatVenue/preVenueList.do?venueName=" + encodeURI(venueName);

        }
        //展示搜索历史
        function loadHistory() {
            var searchValue = window.localStorage.getItem("venueKey");
            if (searchValue) {
                $("#historyDiv").show();
                var arr = searchValue.split(",");
                var tempStr = "";
                $.each(arr, function (i, n) {
                    tempStr += '<li onclick="historySearch(\'' + n + '\')">' + n + '</li>'
                });
                $("#searchList").html(tempStr);
            } else {
                $("#historyDiv").hide();
            }
        }
        //清空搜索历史
        function emptyHistory() {
            window.localStorage.removeItem("venueKey");
            loadHistory();
        }
    </script>
    <style>
        .content {
            padding: 0;
            padding-top: 100px;
        }
    </style>
    <script>
        $(document).ready(function () {
            $(".classify-button").on("touchstart", function() {
                var listnum = $(this).parent().nextAll(".classify-list").find("li");
                if (listnum.length > 5) {
                    for (var i = 5; i < listnum.length; i++) {
                        listnum.eq(i).toggleClass("classify-list-none")
                    }
                }
                if (listnum.hasClass("classify-list-none")) {
                    $(this).html("展开")
                } else {
                    $(this).html("收起")
                }
            })
        })
        //清空上次搜索
        function empty() {
            $("#activityName").val("搜索活动");
        }

    </script>
</head>
<body class="body">
<div class="main">
    <div class="header">
        <span class="index-top-5" style="top:30px;">
						<img src="${path}/STATIC/wechat/image/arrow1.png"onclick="history.go(-1);"/>
					</span>
        <div class="classify-seach">
            <input id="venueName" type="text" value="搜索场馆" onfocus="if (value =='搜索场馆'){value=''}"
                   onblur="if (value==''){value='搜索场馆'}"/>
            <button type="button" onclick="searchBtn()" >确定</button>
            <div style="clear: both;"></div>
        </div>
    </div>
    <div class="content">
        <!-- <div class="classify">
            <ul>
                <li>
                    <div>
                        <h2>热门类型</h2>
                        <div class="classify-button">收起</div>
                        <div style="clear: both;"></div>
                    </div>
                    <div class="classify-list">
                        <ul id="hotArea">
                            <div style="clear: both;"></div>
                        </ul>
                    </div>
                </li>
                <li>
                    <div>
                        <h2>热门分类</h2>
                        <div class="classify-button">收起</div>
                        <div style="clear: both;"></div>
                    </div>
                    <div class="classify-list">
                        <ul id="hotTag">
                            <div style="clear: both;"></div>
                        </ul>
                    </div>
                </li>
                <li>
                    <div>
                        <h2>热门搜索</h2>
                        <div class="classify-button">收起</div>
                        <div style="clear: both;"></div>
                    </div>
                    <div class="classify-list">
                        <ul id="hotWord">
                            <div style="clear: both;"></div>
                        </ul>
                    </div>
                </li>
            </ul>
        </div> -->
        <div class="classify-history" id="historyDiv">
            <h2>历史搜索</h2>
            <ul id="searchList">
            </ul>
            <button type="button" onclick="emptyHistory()">清空历史记录</button>
        </div>
    </div>
</div>
</body>
</html>
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <!-- <title>活动搜索</title> -->
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp" %>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css">
    <script type="text/javascript" src="${path}/STATIC/wx/js/mc-mobile.js"></script>

    <script>

        $(function () {
            empty();
            //loadWord();		//热门搜索
            loadHistory();
        });

        //响应搜索历史
        function historySearch(txt) {
            window.location.href = '${path}/wechatActivity/preActivityList.do?activityName=' + txt;
        }
        //响应搜索历史
        function tagSearch(txt) {
            window.location.href = '${path}/wechatActivity/preActivityList.do?activityType=' + txt;
        }
        //响应搜索历史
        function areaSearch(txt) {
            window.location.href = '${path}/wechatActivity/preActivityList.do?area=' + txt;
        }
        //展示搜索历史
        function loadHistory() {
            var searchValue = window.localStorage.getItem("activityKey");
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

        //搜索按钮
        function searchBtn(word) {
            var activityName = $("#activityName").val();
            if (word) {
                activityName = word;
            }
            if (activityName == "搜索活动") {
                activityName = "";
            }
            //保存搜索历史
            if (activityName && $.trim(activityName)) {
                activityName = $.trim(activityName.split(",").join(''));
                var searchValue = window.localStorage.getItem("activityKey");
                if (searchValue) {
                    searchValue = activityName + "," + searchValue;
                    var arr = searchValue.split(",");
                    if (arr.length > 5) {
                        arr.pop();
                        window.localStorage.setItem("activityKey", arr.join());
                    } else {
                        window.localStorage.setItem("activityKey", searchValue);
                    }
                } else {
                    window.localStorage.setItem("activityKey", activityName);
                }
            }

            window.location.href = "${path}/wechatActivity/preActivityList.do?activityName=" + activityName;

        }

        //热门词汇
        function loadWord() {
            $.post("${path}/wechatActivity/getActivityHot.do", function (data) {
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

        //标签选择赋值
        function selectTag(type, id) {
            $("#" + id).val(type);
            searchBtn();
        }

        //清空上次搜索
        function empty() {
            $("#activityName").val("搜索活动");
        }

        //清空搜索历史
        function emptyHistory() {
            window.localStorage.removeItem("activityKey");
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
            /*				$(".classify-list li div").click(function(){
             $(this).toggleClass("topic-tag-bg")
             })*/
        })
    </script>
</head>
<body style="background-color: #fff;">
<div class="main">
    <div class="header">
        <span class="index-top-5" style="top:30px;">
						<img src="${path}/STATIC/wechat/image/arrow1.png"onclick="history.go(-1);"/>
					</span>
        <div class="classify-seach">
            <input id="activityName" type="text" value="搜索活动" onfocus="if (value =='搜索活动'){value=''}"
                   onblur="if (value==''){value='搜索活动'}"/>
            <button type="button" onclick="searchBtn()">确定</button>
            <div style="clear: both;"></div>
        </div>
    </div>
    <div class="content">
        <!-- <div class="classify">
            <ul>
                <li>
                    <div>
                        <h2>热门区域</h2>
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
                        <h2>热门标签</h2>
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
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
    <!-- <title>选择你喜欢的主题</title> -->
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>

    <script type="text/javascript">
        var userId = '${sessionScope.terminalUser.userId}';
        var userTags = '${sessionScope.terminalUser.activityThemeTagId}';
        var type = '${type}';
        $(function () {
            loadTag();		//活动标签
            
            //全选
            $(".topic-all").on("touchstart", function() {
				if ($(".topic-all").hasClass("topic-tag-bg")) {
					$(this).removeClass("topic-tag-bg")
					$(".topic-tag div").removeClass("topic-tag-bg")
				} else {
					$(this).addClass("topic-tag-bg")
					$(".topic-tag div").addClass("topic-tag-bg")
				}
			})
        });

        //活动标签
        function loadTag() {
            $.post("${path}/wechatActivity/wcActivityTagList.do", {userId: userId}, function (data) {
                if (data.status == 0) {
                    $.each(data.data, function (i, dom) {
                        $("#tagList").append("<li tagId='" + dom.tagId + "');\"><div>"+dom.tagName+"</div></li>");
                        if (dom.status == 1 && userId != "") {
                            $("li[tagId=" + dom.tagId + "] div").addClass("topic-tag-bg");
                        }
                        if (userTags.indexOf(dom.tagId) != -1) {
                            $("li[tagId=" + dom.tagId + "] div").addClass("topic-tag-bg");
                        }
                    });
                    $(".topic-tag div").on("touchstart", function() {
        				$(this).toggleClass("topic-tag-bg")
        			})
                }
            }, "json");
        };

        //修改标签信息
        function doIndex() {
            var tagIds = new Array();
            $("#tagList li").each(function (index, item) {
                if ($(this).find("div").hasClass("topic-tag-bg")) {
                    tagIds.push($(this).attr("tagId"));
                }
            });
            var userSelectTag = tagIds.join(',');
            if (userSelectTag == '') {
                dialogAlert('系统提示', '请至少选择一个标签！');
                return;
            }
            if (userId == '') {
                $.post("${path}/wechat/wcUserSelectedTag.do", {userSelectTag: userSelectTag}, function (data) {
                    if (data.result == 'success') {
                    	window.location.href = type;
                    }
                }, "json");
            } else {
                $.post("${path}/wechat/wcEditUser.do", {userSelectTag: userSelectTag}, function (data) {
                    if (data.result == 'success') {
                    	window.location.href = type;
                    }
                }, "json");
            }

        }

    </script>

	<style>
		.content {padding: 0;}
	</style>
</head>
<body>
	<div class="main">
		<div class="header"></div>
		<div class="content">
			<div class="topic">
				<div>
					<div class="topic-back" onclick="history.go(-1);"></div>
					<div class="topic-middle"></div>
					<div class="topic-all"><p>全选</p></div>
					<div style="clear: both;"></div>
				</div>
				<p>选择你感兴趣的主题</p>
				<div class="topic-tag">
					<ul id="tagList"></ul>
				</div>
				<div class="topic-button">
					<button type="button" ontouchstart="doIndex();">确定</button>
				</div>
			</div>
		</div>
		<div class="footer"></div>
	</div>
</body>
</html>
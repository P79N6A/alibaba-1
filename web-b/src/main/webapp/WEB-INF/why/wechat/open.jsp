<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
    <!-- <title>你喜欢的主题</title> -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wx/css/reset-mc.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wx/css/mc-mobile.css"/>
    <script type="text/javascript" src="${path}/STATIC/wx/js/mc-mobile.js"></script>

    <script type="text/javascript">
        var userId = '${sessionScope.terminalUser.userId}';

        $(function () {
            if (userId == '') {
                window.location.href = "${path}/muser/login.do";
            }

            loadTag();		//活动标签
        });

        //活动标签
        function loadTag() {
            $.post("${path}/wechatActivity/wcActivityTagList.do", {userId: userId}, function (data) {
                if (data.status == 0) {
                    $.each(data.data, function (i, dom) {
                        $("#tagList").append("<li tagId='" + dom.tagId + "');\"><a><img src='" + dom.tagImageUrl + "' width='157' height='157'><em>"+dom.tagName+"</em></a><span class='spans'></span></li>");
                        if (dom.status == 1) {
                            $("li[tagId=" + dom.tagId + "]").addClass("spans");
                        }
                    });
                }
            }, "json");
        }
        ;

        //添加用户性别、年龄、标签信息
        function doIndex() {
            var tagIds = new Array();
            $("#tagList li").each(function (index, item) {
                if ($(this).hasClass("spans")) {
                    tagIds.push($(this).attr("tagId"));
                }
            });
            var userSelectTag = tagIds.join(',');
            if (userSelectTag == '') {
                dialogAlert('系统提示', '请至少选择一个标签！');
                return;
            }
            $.post("${path}/wechat/wcEditUser.do", {userSelectTag: userSelectTag}, function (data) {
                if (data.result == 'success') {
                    window.location.href = "${path}/wechat/index.do";
                }
            }, "json");
        }

    </script>

</head>
<body class="body">
<div id="M_open">
    <div class="logo"><a><img src="${path}/STATIC/wx/image/first_logo.png" width="120" height="30"/></a></div>
    <div class="arrow_choose clearfix"><a class="all_choose fr">全选</a>
        <h5>请选择你喜欢的主题</h5>
    </div>
    <div id="open_two">
        <div class="list clearfix" id="tagList"></div>
        <div class="open_btn"><a href="javascript:doIndex();">GO!</a></div>
    </div>
</div>
</body>
</html>
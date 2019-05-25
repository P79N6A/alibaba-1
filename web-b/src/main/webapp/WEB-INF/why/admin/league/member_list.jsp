<%@ page language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>活动列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <%@include file="/WEB-INF/why/common/limit.jsp" %>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    <link rel="Stylesheet" type="text/css" href="${path}/STATIC/css/DialogBySHF.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/DialogBySHF.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/location.js"></script>
    <script type="text/javascript">
        seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
            window.dialog = dialog;
        });

        $(function () {
            $("input").focus();
            kkpager.generPageHtml({
                pno: '${member.page}',
                total: '${member.countPage}',
                totalRecords: '${member.total}',
                mode: 'click',//默认值是link，可选link或者click
                click: function (n) {
                    this.selectPage(n);
                    $("#page").val(n);
                    formSub('#activityForm');
                    return false;
                }
            });
        });


        function delMember(id) {
            var showText = "删除后不可恢复！您确定要删除该成员吗？";
            dialogConfirm("提示", showText, removeParent);

            function removeParent() {
                $.post("${path}/member/save.do", {"id": id, state: 0}, function (data) {
                    data = JSON.parse(data);
                    if ('200' == data.status) {
                        dialogAlert('提示', '删除成功', function () {
                            formSub('#activityForm');
                        });
                    } else {
                        dialogAlert('提示', data.msg);
                    }
                });
            }
        }


        //提交表单
        function formSub(formName) {
            $(formName).submit();
        }


        function relateVenue(id) {
            var winW = parseInt($(window).width() * 0.8);
            var winH = parseInt($(window).height() * 0.95);
            $.DialogBySHF.Dialog({
                Width: winW,
                Height: winH,
                Title:'关联场馆',
                URL: '${index}/venue/relationVenueIndex.do?memberId='+id
            });

           /* dialog({
                url: '${index}/venue/relationVenueIndex.do?memberId='+id,
                title: '关联场馆',
                width: winW,
                height:winH,
                fixed: true
            }).showModal();*/

        };

    </script>
    <style type="text/css">
        .ui-dialog-title, .ui-dialog-content textarea {
            font-family: Microsoft YaHei;
        }

        .ui-dialog-header {
            border-color: #9b9b9b;
        }

        .ui-dialog-title {
            color: #F23330;
            font-size: 20px;
            text-align: center;
        }

        .ui-dialog-content {
        }

        .ui-dialog-body {
        }
    </style>
</head>
<body>
<form id="activityForm" action="" method="post">
    <div class="site">
        <em>您现在所在的位置：</em>文化联盟 &gt; 成员列表
    </div>

    <div class="search">
        <div class="search-box">
            <i></i><input type="text" id="searchName" name="searchName" value="${member.searchName}" placeholder="成员名称/所属联盟" class="input-text">
        </div>

        <div class="select-btn">
            <input type="button" onclick="$('#page').val(1);formSub('#activityForm');" value="搜索"/>
        </div>
        <div class="search menage">
            <div class="menage-box">
                <a class="btn-add" href="${path}/member/toSave.do">新增</a>
            </div>
        </div>
    </div>

    <div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th>序号</th>
                <th class="title">成员名称</th>
                <th>所属联盟</th>
                <th>地址</th>
                <th width="500">简介</th>
                <th>创建人</th>
                <th>创建时间</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${list}" var="o" varStatus="i">
                <tr>
                    <td>${i.index+1}</td>
                    <td class="title">${o.memberName}</td>
                    <td>${o.leagueName}</td>
                    <td>${o.address}</td>
                    <td>${o.introduction}</td>
                    <td>${o.createUserName}</td>
                    <td><fmt:formatDate value="${o.createTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                    <td>
                        <a target="main" href="${path}/member/toSave.do?id=${o.id}">编辑</a> |
                        <a target="main" href="javascript:delMember('${o.id}')">删除</a> |
                        <a target="main" href="javascript:relateVenue('${o.id}')">关联场馆</a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty list}">
                <tr>
                    <td colspan="9"><h4 style="color:#DC590C">暂无数据!</h4></td>
                </tr>
            </c:if>
            </tbody>
        </table>
        <c:if test="${not empty list}">
            <input type="hidden" id="page" name="page" value="${member.page}"/>
            <div id="kkpager"></div>
        </c:if>
    </div>
</form>
</body>
</html>
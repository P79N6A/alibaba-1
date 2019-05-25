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
    <link rel="Stylesheet" type="text/css" href="${path}/STATIC/css/DialogBySHF.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/DialogBySHF.js"></script>

    <script type="text/javascript">
        $(function () {
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

            /*点击确定按钮，关闭登录框*/
            $(".btn-publish").on("click", function(){
                $("body",parent.document).find('#DialogBySHFLayer,#DialogBySHF').remove();
            });

            selectModel();
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



        //全选或全不选
        function checkAll() {
            $("#list-table :checkbox").each(function () {
                if ($('#all').prop('checked')) {
                    $(this).prop("checked", true);
                } else {
                    $(this).prop("checked", false);
                }
            });
        }

        function relationAllMember(){
            var arr = new Array();
            $("#list-table :checkbox").each(function () {
                var checked=$(this).prop("checked");
                if(checked)   arr.push($(this).val());
            });
            if(arr.length==0) {
                dialogAlert("提示", "请选择需要关联的数据！");
                return;
            }
            dialogConfirm("提示", "您确定要关联所选成员吗？", function () {
                $.post("${path}/member/relationMember.do", {memberIds: arr.toString(),infoId:'${member.id}',state:1}, function (data) {
                    data = JSON.parse(data);
                    if ('200' == data.status) {
                        dialogAlert('提示', '操作成功', function () {
                            formSub('#activityForm');
                        });
                    } else {
                        dialogAlert('提示', data.data, function () {
                            formSub('#activityForm');
                        });
                    }
                });
            });
        }


        function relationMember(memberId,state) {
            $.post("${path}/member/relationMember.do", {memberIds: memberId,infoId:'${member.id}',state:state}, function (data) {
                data = JSON.parse(data);
                if ('200' == data.status) {
                    dialogAlert('提示', '操作成功', function () {
                        formSub('#activityForm');
                    });
                } else {
                    dialogAlert('提示', data.data);
                }
            });
        }


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
  <%--  <div class="site">
        <em>您现在所在的位置：</em>文化联盟 &gt; 关联成员
    </div>--%>
    <div class="search"  style="height: 30px;">
        <div class="search-box">
            <i></i><input type="text" id="searchName" name="searchName" value="${member.searchName}" placeholder="成员名称/所属联盟" class="input-text">
        </div>


        <div class="select-box w135">
            <input type="hidden" name="relationType" id="relationType" value="${member.relationType}"/>
            <div id="relationTypeDiv" class="select-text" data-value="">关联状态</div>
            <ul id="relationTypeUl" class="select-option">
                <li data-option="" class="">关联状态</li>
                <li data-option="1">已关联</li>
                <li data-option="0">未关联</li>
            </ul>
        </div>

        <div class="select-btn">
            <input type="button" onclick="$('#page').val(1);formSub('#activityForm');" value="搜索"/>
        </div>
        <div class="select-btn" style="margin-left: 20px;">
            <input type="button" value="批量关联" onclick="relationAllMember()"/>
        </div>

        <div class="form-table form_table_btn" style="float: right;">
            <input class="btn-publish" type="button" value="关闭"/>
        </div>
    </div>

    <div class="main-content">
        <table width="100%" style="margin-top: 10px;">
            <thead>
            <tr>
                <th><input type="checkbox" id="all" onclick="checkAll()" /></th>
                <th class="title">成员名称</th>
                <th width="300">所属联盟</th>
                <th>地址</th>
                <th width="300">简介</th>
                <th>创建人</th>
                <th>创建时间</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody id="list-table">
            <c:forEach items="${list}" var="o" varStatus="i">
                <tr>
                    <td>
                        <input type="checkbox" name="venueId" value="${o.id}"/>
                    </td>
                    <td class="title">${o.memberName}</td>
                    <td>${o.leagueName}</td>
                    <td>${o.address}</td>
                    <td>${o.introduction}</td>
                    <td>${o.createUserName}</td>
                    <td><fmt:formatDate value="${o.createTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                    <td>
                        <c:if test="${o.relationType==0}">
                            <a target="main" href="javascript:relationMember('${o.id}',1)">关联</a>
                        </c:if>
                        <c:if test="${o.relationType==1}">
                            <a target="main" href="javascript:relationMember('${o.id}',0)">取消关联</a>
                        </c:if>
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
            <div id="kkpager" style="padding-top: 14px;"></div>
        </c:if>
    </div>
</form>
</body>
</html>
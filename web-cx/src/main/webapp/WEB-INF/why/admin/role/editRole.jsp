<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>编辑角色--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
</head>
<body style="background: none;">
<form id="roleForm">
    <input type="hidden" value="${role.roleId}" name="roleId"/>
    <div class="main-publish tag-add">
        <table width="100%" class="form-table">
            <tr>
                <td class="td-title" width="100"><span class="red">*</span>角色名称：</td>
                <td class="td-input"><input type="text" class="input-text w210" id="roleName" name="roleName" value="${role.roleName}"/><span class="error-msg" id="roleNameSpan"></span></td>
            </tr>
            <tr class="td-line">
                <td class="td-title">描述：</td>
                <td class="td-input">
                    <textarea rows="4" name="roleRemark" class="textareaBox" style="width: 340px;resize: none" maxlength="100">${role.roleRemark}</textarea><span style="color:red">200字内</span>
                </td>
            </tr>
            <tr>
                <td class="td-title"></td>
                <td class="td-btn">
                    <input class="btn-save" type="button"  value="修改"/>
                    <input class="btn-cancel" type="button" value="关闭"/>
                </td>
            </tr>
        </table>
    </div>
</form>
<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
<script type="text/javascript">
    seajs.config({
        alias: {
            "jquery": "jquery-1.10.2.js"
        }
    });
    seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
        window.dialog = dialog;
    });

    window.console = window.console || {log:function () {}}
    seajs.use(['jquery'], function ($) {
        $(function () {
            var dialog = parent.dialog.get(window);
            /*点击确定按钮*/
            $(".btn-save").on("click", function(){
                var roleName = $("#roleName").val();
                if(roleName==undefined||$.trim(roleName)==""){
                    $("#roleNameSpan").html("请输入角色名称");
                    $('#roleName').focus();
                    return;
                }else{
                    $("#roleNameSpan").html("");
                }

                $.post("${path}/role/editRole.do", $("#roleForm").serialize(), function(result) {
                    if(result == "repeat"){
                        $("#roleNameSpan").html("角色名称不可重复!");
                        $('#roleName').focus();
                    }else if (result == "success") {
                        dialogTypeSaveDraft("提示", "修改成功", function(){
                            parent.location.href="${path}/role/roleIndex.do";
                            dialog.close().remove();
                        });
                    }else{
                        dialogTypeSaveDraft("提示", "修改失败");
                    }
                });
            });
            /*点击取消按钮，关闭登录框*/
            $(".btn-cancel").on("click", function(){
                dialog.close().remove();
            });
        });
    });

    function dialogTypeSaveDraft(title, content, fn){
        var d = parent.dialog({
            width:400,
            title:title,
            content:content,
            fixed: true,
            okValue: '确 定',
            ok: function () {
                if(fn)  fn();
            }
        });
        d.showModal();
    }
</script>
</body>
</html>
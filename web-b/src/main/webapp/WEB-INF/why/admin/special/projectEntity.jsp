<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>活动列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>

<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
<script type="text/javascript">
    $(function(){
        selectModel();
    });
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
                var projectName = $("#projectName").val();
                if(projectName==undefined||$.trim(projectName)==""){
                    $("#projectNameSpan").html("活动主题名称");
                    $('#projectName').focus();
                    return;
                }else{
                    $("#projectNameSpan").html("");
                }
                
                var projectIndexUrl = $("#projectIndexUrl").val();
                if(projectIndexUrl==undefined||$.trim(projectIndexUrl)==""){
                    $("#projectIndexUrlSpan").html("活动主题url");
                    $('#projectIndexUrl').focus();
                    return;
                }else{
                    $("#projectIndexUrlSpan").html("");
                }

                $.post("${path}/specialProject/saveProject.do", $("#form").serialize(), function(result) {
                	
                    if (result == "success") {
                        dialogTypeSaveDraft("提示", "保存成功", function(){
                            parent.location.href="${path}/specialProject/index.do";
                            dialog.close().remove();
                        });
                    }else{
                        dialogTypeSaveDraft("提示", "保存失败");
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
</head>

<body style="background: none;">
<form id="form">
    <div class="main-publish tag-add" style="overflow:visible;">
    	<input type="hidden" name="projectId" id="projectId" value="${entity.projectId }"/>
            <table width="100%" class="form-table">
                <tr>
                    <td class="td-title" width="20%"><span class="red">*</span>活动主题名称：</td>
                    <td class="td-input"><input type="text" class="input-text w210" id="projectName" name="projectName" value="${entity.projectName }"/><span class="error-msg" id="projectNameSpan"></span></td>
                </tr>
                <tr>
                    <td class="td-title" width="20%"><span class="red">*</span>活动主题url：</td>
                    <td class="td-input"><input type="text" class="input-text w210" id="projectIndexUrl" name="projectIndexUrl" value="${entity.projectIndexUrl }"/><span class="error-msg" id="projectIndexUrlSpan"></span></td>
                </tr>
             
                <tr>
                    <td class="td-title"></td>
                    <td class="td-btn">
                        <input class="btn-save" type="button"  value="保存"/>
                        <input class="btn-cancel" type="button" value="关闭"/>
                    </td>
                </tr>
            </table>
    </div>
</form>


</body>
</html>
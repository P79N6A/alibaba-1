<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>添加修改专属也--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>

<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
<script type="text/javascript">
	$.ajaxSettings.async = false; 	//同步执行ajax

    seajs.config({
        alias: {
            "jquery": "jquery-1.10.2.js"
        }
    });

    seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
        window.dialog = dialog;
    });

    window.console = window.console || {log:function () {}}
    
    $(function(){
    	//主题
		$.post("../specialProject/searchProjectList.do",function(data) {
    		var projectId = $("#projectId").val();
            if (data != '' && data != null) {
                var list = eval(data);
                var ulHtml = '<li data-option="">请选择</li>';
                for (var i = 0; i <list.length; i++) {
                    var project = list[i];
                    ulHtml += '<li data-option="'+project.projectId+'">'+ project.projectName+ '</li>';
                }
                $('#projectIdUl').html(ulHtml);
            }
        }).success(function() {
            selectModel();
        });
    });
    
    seajs.use(['jquery'], function ($) {
        $(function () {
        	var dialog = parent.dialog.get(window);
        	
        	/*点击确定按钮*/
            $(".btn-save").on("click", function(){
                var pageName = $("#pageName").val();
                var projectId = $("#projectId").val();
                
                if(pageName==undefined||$.trim(pageName)==""){
                    $("#pageNameSpan").html("专属页名称为必填");
                    $('#pageName').focus();
                    return;
                }else{
                	$("#pageNameSpan").html("");
                }
                
                if(projectId==undefined||$.trim(projectId)==""){
                    $("#projectIdSpan").html("选择活动主题为必选");
                    $('#projectId').focus();
                    return;
                }else{
                	$("#projectIdSpan").html("");
                }

                $.post("${path}/specialPage/saveOrUpdatePage.do", $("#form").serialize(), function(result) {
                	
                    if (result == "success") {
                    	dialogTypeSaveDraft("提示", "保存成功", function(){
                            parent.location.href="${path}/specialPage/index.do";
                            dialog.close().remove();
                        });
                    }else{
                    	dialogTypeSaveDraft("提示", "保存失败");
                    }
                });
            });
        	
        	/*点击取消按钮，关闭弹出框*/
            $(".btn-cancel").on("click", function(){
                dialog.close().remove();
            });
        })
    })

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
	    <div class="main-publish tag-add" style="overflow: visible;">
	    	<input type="hidden" name="pageId" id="pageId" value="${entity.pageId}"/>
	        <table width="100%" class="form-table">
	            <tr>
	                <td class="td-title" width="20%"><span class="red">*</span>专属页名称：</td>
	                <td class="td-input"><input type="text" class="input-text w210" id="pageName" name="pageName" value="${entity.pageName }"/><span class="error-msg" id="pageNameSpan"></span></td>
	            </tr>
	            <tr>
                    <td class="td-title" width="20%"><span class="red">*</span>选择活动主题：</td>
                    <td class="td-input search" id="projectIdLabel">
	                    <div class="select-box w230" style="margin-left: 0px;">
	                        <input type="hidden" value="${entity.projectId }" name="projectId" id="projectId"/>
	                        <div class="select-text" data-value="" id="projectIdDiv">请选择</div>
	                        <ul class="select-option" style="display: none;max-height:100px" id="projectIdUl"></ul>
	                    </div>
                    	<span class="error-msg" id="projectIdSpan"></span>
              	    </td>
                </tr>
	            <tr>
	                <td class="td-title"></td>
	                <td class="td-btn" style="padding: 36px 0;">
	                    <input class="btn-save" type="button"  value="保存"/>
	                    <input class="btn-cancel" type="button" value="关闭"/>
	                </td>
	            </tr>
	        </table>
	    </div>
	</form>
</body>
</html>
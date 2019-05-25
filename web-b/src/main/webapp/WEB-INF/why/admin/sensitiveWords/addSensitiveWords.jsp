<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>文化云</title>
	<!-- 导入头部文件 start -->
	<%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
</head>
<body style="background: none;">
<!-- 正中间panel -->
<form id="sys_form" action="" method="post">
<div class="main-publish tag-add">
	<div class="content">
		<table width="100%" class="form-table">
			<tbody>
				<tr>
					<td width="28%" class="td-title">敏感词：</td>
					<td class="td-input"  id="sensitiveWordsLable">
						<input type="text" id="sensitiveWords" name="sensitiveWords" class="input-text w220" maxlength="20" />
					</td>
				</tr>

				<tr>
					<td class="td-btn" align="center" colspan="2">
						<input class="btn-save" type="button"  value="保存" />
						<input class="btn-cancel" type="button" value="取消" />
					</td>
				</tr>
			</tbody>

		</table>


	</div>


<%--						<tr>
							<td class="td-title" width="28%"><span class="td-prompt">*</span></td>
							<td class="td-input-two" ><input type="text" value="" id="sensitiveWords" name="sensitiveWords"/></td>
						</tr>--%>
<%--						<tr class="submit-btn">
							<td colspan="2">
								<!-- <input type="button" value="保存草稿"/> -->
								<input type="button" value="保存" onclick="javascript:return doSubmit();"/>
								<input type="button" value="返回" onclick="javascript:location.href='${path}/sensitiveWords/sensitiveWordsIndex.do'"/>
							</td>
						</tr>--%>

</form>
<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
<script type="text/javascript">
	$(function(){
		$("#sensitiveWords").focus();
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
				var  sensitiveWords=$("#sensitiveWords").val();
				if(sensitiveWords==""){
					removeMsg("sensitiveWordsLable");
					appendMsg("sensitiveWordsLable","请输入敏感词!");
					return;
				}else{
					removeMsg("sensitiveWordsLable");
				}
				/*					$.post("${path}/sensitiveWords/saveSensitiveWords.do", $("#sys_form").serialize(), function(data) {
				 if (data == "success") {
				 jAlert('保存成功', '系统提示','success',function (r){
				 window.location.href="${path}/sensitiveWords/sensitiveWordsIndex.do";
				 });
				 }else if (data =='repeat'){
				 jAlert('保存失败该敏感词已经存在', '系统提示','failure',function (r){});
				 }
				 else {
				 jAlert('保存失败'+ data, '系统提示','failure',function (r){});
				 }
				 });*/

				$.post("${path}/sensitiveWords/saveSensitiveWords.do", $("#sys_form").serialize(), function(
						datas) {
					if (datas == "success") {
						dialogTypeSaveDraft("提示","保存成功",function(){
							parent.location.href="${path}/sensitiveWords/sensitiveWordsIndex.do";
							dialog.close().remove();
						});
					}else if(datas == "repeat"){
						dialogTypeSaveDraft("提示","该敏感词已经存在",function(){
						});
					}else {
						dialogTypeSaveDraft("提示","保存失败!",function(){
						});
					}

				});
			});
			/*点击取消按钮，关闭登录框*/
			$(".btn-cancel").on("click", function(){
				dialog.close().remove();
			});
		});
	});
</script>
</body>
</html>
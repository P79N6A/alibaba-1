<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>编辑标签</title>
<!-- 导入头部文件 start -->
	<%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
<%--<script type="text/javascript">
	//编辑表单
	function editDit() {
		$.post("${path}/sysdict/dictSave.do", $("#dictForm").serialize(), function(
				data) {
			if (data == "success") {
				dialogSaveDraft('系统提示', '保存成功',function (){
					window.location.href="${path}/sysdict/dictIndex.do";
				});
			} else {
				//alert("更新失败!");
				dialogSaveDraft("系统提示","更新失败",'');
			}
		});
	}
</script>--%>
</head>
<body>
<form action="" id="dictForm">
	<div class="main-publish tag-add">
		<table width="100%" class="form-table">
			<input type="hidden" name="dictId" id="dictId" value="${sysDict.dictId }"/>
			<tr>
				<td width="28%" class="td-title">字典编码：</td>
				<td class="td-input">
					<input type="text" value="${sysDict.dictCode}" id="dictCode" name="dictCode" class="input-text w220"/>
				</td>
			</tr>
			<tr>
				<td width="28%" class="td-title">字典名称：</td>
				<td class="td-input">
					<input type="text" value="${sysDict.dictName}" id="dictName" name="dictName" class="input-text w220" maxlength="20"/>
				</td>
			</tr>
			<tr>
				<td class="td-title">字典描述：</td>

				<td class="td-content" id="updateDescrLable">
					<textarea  id="dictRemark" name="dictRemark" class="text-des" maxlength="500">${sysDict.dictRemark}</textarea><span style="color:red">500字内</span>
				</td>
			</tr>
			<tr>
				<td class="td-btn" align="center" colspan="2">
					<input class="btn-save" type="button"  value="保存"/>
					<input class="btn-cancel" type="button" value="取消"/>
				</td>
			</tr>
		</table>
	</div>
</form>


<%--<form id="dictForm" method="post">
	<div class="site">
		<em>您现在所在的位置：</em>字典管理 &gt; 字典编辑
	</div>
	<div class="site-title">字典编辑</div>
	<input type="hidden" name="dictId" id="dictId" value="${sysDict.dictId }"/>
	<div id="main-publish">
		<table class="form-table">
			<tr>
				<td class="td-title" width="120"><span class="red">*</span>编码：</td>
				<td class="td-input"><input type="text" value="${sysDict.dictCode}" id="dictCode" name="dictCode" class="input-text w510"/></td>
			</tr>
			<tr>
				<td class="td-title"><span class="red">*</span>名称：</td>
				<td class="td-input"><input type="text" value="${sysDict.dictName}" id="dictName" name="dictName" class="input-text w510"/></td>
			</tr>
			<tr>
				<td class="td-title"><span class="red">*</span>描述：</td>
				<td class="td-content">
					<textarea rows="5" style="width:532px" id="dictRemark" name="dictRemark" onkeydown="checkForm();">${sysDict.dictRemark}</textarea><span id="textCount">剩下200字</span>
				</td>
			</tr>
			<tr class="td-btn">
				<td></td>
				<td>
					<!-- <input type="button" value="保存草稿"/> -->
					<input type="button" value="发布" class="btn-save" onclick="javascript:return editDit();"/>
					<input type="button" value="返回" class="btn-publish" onclick="javascript:location.href='${path}/sysdict/dictIndex.do'"/>
				</td>
			</tr>
		</table>
	</div>
</form>--%>

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
				//特殊字符处理
				var iu, iuu, regArray=new Array("◎","■","●","№","↑","→","↓"+
				"!","@","#","$","%","^","&","*","(",")","+","=","|","[","]","？","~","`"+
				"!","<",">","‰","→","←","↑","↓","¤","§","＃","＆","＆","＼","≡","≠"+
				"≈","∈","∪","∏","∑","∧","∨","⊥","‖","‖","∠","⊙","≌","≌","√","∝","∞","∮"+
				"∫","≯","≮","＞","≥","≤","≠","±","＋","÷","×","/","Ⅱ","Ⅰ","Ⅲ","Ⅳ","Ⅴ","Ⅵ","Ⅶ","Ⅷ","Ⅹ","Ⅻ"+
				"╄","╅","╇","┻","┻","┇","┭","┷","┦","┣","┝","┤","┷","┷","┹","╉","╇","【","】"+
				"①","②","③","④","⑤","⑥","⑦","⑧","⑨","⑩","┌","├","┬","┼","┍","┕","┗","┏","┅","—"+
				"〖","〗","←","〓","☆","§","□","‰","◇","＾","＠","△","▲","＃","℃","※",".","≈","￠");
				iuu=regArray.length;
				var  dictCode=$("#dictCode").val();
				if($.trim($("#dictCode").val())==""){
					dialogTypeSaveDraft("提示","请输入编码!",function(){
					});
					return;
				}
				var dictName=$("#dictName").val();
				if($.trim($("#dictName").val())==""){
						dialogTypeSaveDraft("提示","请输入编码名称!",function(){
					});
					return;
				}
				for(iu=0;iu<=iuu;iu++){
					if ($.trim($("#dictCode").val()).indexOf(regArray[iu])!=-1){
						dialogTypeSaveDraft("提示","字典编码中不可以包含特殊字符  "+regArray[iu]+"",function(){
						});
						return false;
					}
					if($.trim($("#dictName").val()).indexOf(regArray[iu])!=-1) {
						dialogTypeSaveDraft("提示","字典名称中不可以包含特殊字符  "+regArray[iu]+"",function(){
							regArray[iu];
						});
						return false;
					}
				}
				$.post("${path}/sysdict/dictSave.do", $("#dictForm").serialize(), function(datas) {
					if (datas == "success") {
						dialogTypeSaveDraft("提示","修改成功",function(){
							parent.location.href="${path}/sysdict/dictIndex.do";
							dialog.close().remove();
						});
					}
					else {
						dialogTypeSaveDraft("提示", "修改失败!", function () {
						});
					}
				});
			});
			/*点击取消按钮，关闭弹出框*/
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
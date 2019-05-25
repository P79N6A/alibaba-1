<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<head>
	<title>文化云</title>
	<!-- 导入头部文件 start -->
	<%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
</head>
<body class="rbody">
<!-- 正中间panel -->
<form action="" id="dictForm">
	<div class="main-publish tag-add">
		<%--<input type="hidden" value="${tag.tagType}" name="tagType" id="tagType"/>--%>
		<table width="100%" class="form-table">
			<tr>
				<td class="td-title" width="28%"> 父节点：</td>
				<td class="td-select"  id="dictParenetCodeLable">
					<div class="select-box w140">
						<input type="hidden" name="dictParentId" id="dictParentId"
							   value="${tag.tagType}" />
						<div data-value="选择标签分类"
							 id="tagTypeDiv" class="select-text">无父节点</div>
						<ul class="select-option" id="tagTypeUl">
							<li data-option="">无父节点</li>
						</ul>
					</div>
				</td>
			</tr>
			<tr>
				<td width="28%" class="td-title">字典编码：</td>
				<td class="td-input">
					<input type="text" value="" id="dictCode" name="dictCode" class="input-text w220"/>
				</td>
			</tr>
			<tr>
				<td width="28%" class="td-title">字典名称：</td>
				<td class="td-input">
					<input type="text" value="" id="dictName" name="dictName" class="input-text w220" maxlength="20"/>
				</td>
			</tr>
			<tr>
				<td class="td-title">字典描述：</td>

				<td class="td-content" id="updateDescrLable">
					<textarea  id="dictRemark" name="dictRemark" onkeydown="checkForm('dictRemark');" class="text-des" maxlength="500"></textarea><span style="color:red">500字内</span>
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




<%--
<form action="" id="dictForm">
	<div class="main-publish tag-add">
		<table width="100%" class="form-table">
				<tr>
					<td class="td-title" width="28%"> 父节点：</td>
					<td class="td-select"  id="dictParenetCodeLable">
						<div class="select-box w135">
							<input type="hidden" name="dictParentId" id="dictParentId"
								   value="${tag.tagType}" />
							<div data-value="选择标签分类"
								 id="tagTypeDiv" class="select-text">无父节点</div>
							<ul class="select-option" id="tagTypeUl">
								<li data-option="">无父节点</li>
							</ul>
						</div>
					</td>
				</tr>
			<tr>
				<td width="28%" class="td-title">字典编码：</td>
				<td class="td-input">
					<input type="text" value="" id="dictCode" name="dictCode" class="input-text w220"/>
				</td>
			</tr>
				<tr>
					<td width="28%" class="td-title">字典名称：</td>
					<td class="td-input">
						<input type="text" value="" id="dictName" name="dictName" class="input-text w220"/>
					</td>
				</tr>

				<tr>
					<td class="td-title" ><span class="red">*</span>字典描述：</td>
					<td class="td-content" id="dictRemarkLable">
						<textarea rows="5"  id="dictRemark" name="dictRemark" onkeydown="checkForm();" style="width:532px"></textarea><span id="textCount">剩下200字</span>
					</td>
				</tr>
			<tr>
				<td class="td-btn" align="center" colspan="2">
					<input class="btn-save" type="button"  value="保存" onclick="javascript:return doSubmit();"/>
					<input class="btn-cancel" type="button" value="取消"/>
				</td>
			</tr>
		</table>
	</div>
</form>
--%>





<%--<form id="dictForm">
	<div class="site">
		<em>您现在所在的位置：</em>字典管理 &gt; 字典新增
	</div>
	<div class="site-title">字典新增</div>
	<div id="main-publish">
		<table class="form-table">
			<tr>
				<td class="td-title" width="120"><span class="red">*</span>父节点：</td>
				<td class="td-select"  id="dictParenetCodeLable">
					<div class="select-box w135">
						<input type="hidden" name="dictParentId" id="dictParentId"
							   value="${tag.tagType}" />
						<div data-value="选择标签分类"
							 id="tagTypeDiv" class="select-text">无父节点</div>
						<ul class="select-option" id="tagTypeUl">
							<li data-option="">无父节点</li>
						</ul>
					</div>
				</td>
			</tr>
			<tr>
				<td class="td-title" width="120"><span class="red">*</span>字典编码：</td>
				<td class="td-input"  id="dictCodeLable"><input type="text" value="" id="dictCode" name="dictCode" class="input-text w510"/></td>
			</tr>
			<tr>
				<td class="td-title" width="120"><span class="red">*</span>字典名称：</td>
				<td class="td-input"  id="dictNameLable"><input type="text" value="" id="dictName" name="dictName" class="input-text w510"/></td>
			</tr>
			<tr>
				<td class="td-title" ><span class="red">*</span>字典描述：</td>
				<td class="td-content" id="dictRemarkLable">
					<textarea rows="5"  id="dictRemark" name="dictRemark" onkeydown="checkForm();" style="width:532px"></textarea><span id="textCount">剩下200字</span>
				</td>
			</tr>
			<tr class="td-btn">
				<td></td>
				<td>
					<!-- <input type="button" value="保存草稿"/> -->
					<input type="button" value="保存" class="btn-save" onclick="doSubmit()"/>
					<input type="button" value="返回" class="btn-publish" onclick="javascript:location.href='${path}/sysdict/dictIndex.do'"/>
				</td>
			</tr>
		</table>
	</div>
</form>--%>
<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
<script type="text/javascript">
	$(function() {
		var tagType = $('#tagType').val();
		$.post(
				"${path}/sysdict/querySysDictByByState.do",null,
				function(data) {
					if (data != '' && data != null) {
						var list = eval(data);
						var ulHtml = '';
						for (var i = 0; i < list.length; i++) {
							var dict = list[i];
							ulHtml += '<li data-option="'+dict.dictId+'">'
							+ dict.dictName + '</li>';
							if (tagType != '' && dict.dictId == tagType) {
								$('#tagTypeDiv').html(dict.dictName);
							}
						}
						$('#tagTypeUl').append(ulHtml);
					}
				}).success(function() {
					selectModel();
				});
	});


	/*$(function(){
	 selectModel();
	 });*/

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
				var dictParentId = $("#dictParentId").val();
				if($.trim($("#dictName").val())==""){
					//dictParentId  如果选择了父节点 则可以不填写编码
					if(dictParentId){

					}else{
						dialogTypeSaveDraft("提示","请输入编码名称!",function(){
						});
						return;
					}
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
				$.post("${path}/sysdict/dictSave.do", $("#dictForm").serialize(), function(
						datas) {
					if (datas == "success") {
						dialogTypeSaveDraft("提示","保存成功",function(){
							parent.location.href="${path}/sysdict/dictIndex.do";
							dialog.close().remove();
						});
					}else if(datas=="toAdd"){
						dialogTypeSaveDraft("提示","不可重复添加字典",function(){
						});
					}
					else {
						dialogTypeSaveDraft("提示", "保存失败!", function () {
						});
					}
					$(".btn-save").removeAttr("disabled");
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

	/* function doSubmit(){
	 var  dictCode=$("#dictCode").val();
	 var  dictName=$("#dictName").val();
	 var  dictRemark=$("#dictRemark").val();
	 if(dictCode==""){
	 removeMsg("dictCodeLable");
	 appendMsg("dictCodeLable","请输入编码!");
	 return;
	 }else{
	 removeMsg("dictCodeLable");
	 }
	 if(dictName==""){
	 removeMsg("dictNameLable");
	 appendMsg("dictNameLable","请输入名称!");
	 return;
	 }else{
	 removeMsg("dictNameLable");
	 }
	 if(dictRemark==""){
	 removeMsg("dictRemarkLable");
	 appendMsg("dictRemarkLable","请输入描述!");
	 return;
	 }else{
	 removeMsg("dictRemarkLable");
	 }
	 $.post("${path}/sysdict/dictSave.do", $("#dictForm").serialize(), function(data) {
	 if (data == "success") {
	 dialogSaveDraft('系统提示', '保存成功',function (){
	 window.location.href="${path}/sysdict/dictIndex.do";
	 });
	 } else if(data==""){
	 window.location.href="${path}/sysdict/preSaveSysDict.do";
	 }
	 else if(data=="toAdd"){
	 dialogSaveDraft("系统提示","不可重复添加字典");
	 }
	 });
	 }*/
</script>
</body>
</html>
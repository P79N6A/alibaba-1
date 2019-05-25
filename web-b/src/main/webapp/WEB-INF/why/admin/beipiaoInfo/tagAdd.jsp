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
<form action="" id="tagForm">
	<div class="main-publish tag-add" style="overflow:visible">
		<table width="100%" class="form-table">
			<tr>
				<td class="td-title" width="28%"> 父标签名称：</td>
				<td class="td-select"  id="tagParenetCodeLable">
					<div class="select-box w140">
						<input type="hidden" name="tagParentId" id="tagParentId"
							   value="${tag.tagType}"/>
						<div data-value="选择标签分类"
							 id="tagTypeDiv" class="select-text">无父节点</div>
						<ul class="select-option" id="tagTypeUl">
							<li data-option="">无父节点</li>
						</ul>
					</div>
				</td>
			</tr>
			<tr>
				<td width="28%" class="td-title">标签名称：</td>
				<td class="td-input">
					<input type="text" value="" id="tagName" name="tagName" class="input-text w220" maxlength="20"/>
				</td>
			</tr>
			<tr>
				<td width="28%" class="td-title">标签编码：</td>
				<td class="td-input">
					<input type="text" value="" id="tagCode" name="tagCode" class="input-text w220" maxlength="30"/>
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
<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
<script type="text/javascript">
	$(function() {
		$.post("${path}/beipiaoInfoTag/queryParentTag.do",
			function(data) {
				if (data != '' && data != null) {
					var list = eval(data);
					var ulHtml = '';
					for (var i = 0; i < list.length; i++) {
						var tag = list[i];
						ulHtml += '<li data-option="'+tag.tagId+'">'
						+ tag.tagName + '</li>';
					}
					$('#tagTypeUl').append(ulHtml);
				}
			}).success(function() {
				selectModel();
		});
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
				var tagName=$("#tagName").val();
				if($.trim($("#tagName").val())==""){
					dialogTypeSaveDraft("提示","请输入标签名称!",function(){});
					return;
				}
				var tagCode=$("#tagCode").val();
				if($.trim($("#tagCode").val())==""){
					dialogTypeSaveDraft("提示","请输入标签编码!",function(){});
					return;
				}
				for(iu=0;iu<=iuu;iu++){
					if($.trim($("#tagName").val()).indexOf(regArray[iu])!=-1) {
						dialogTypeSaveDraft("提示","标签名称中不可以包含特殊字符  "+regArray[iu]+"",function(){
							regArray[iu];
						});
						return false;
					}
				}
				$.post("${path}/beipiaoInfoTag/addAndEditTag.do", $("#tagForm").serialize(), function(
						datas) {
					if (datas == "success") {
						dialogTypeSaveDraft("提示","保存成功",function(){
							parent.location.href="${path}/beipiaoInfoTag/tagList.do";
							dialog.close().remove();
						});
					}else if(datas=="toAdd"){
						dialogTypeSaveDraft("提示","不可重复添加标签",function(){
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
</script>
</body>
</html>
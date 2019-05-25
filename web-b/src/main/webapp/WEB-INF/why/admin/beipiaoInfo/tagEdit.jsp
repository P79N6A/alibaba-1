<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>编辑标签</title>
<%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
</head>
<body>
<form id="tagForm">
	<div class="main-publish tag-add">
		<table width="100%" class="form-table">
			<input type="hidden" name="tagId" id="tagId" value="${bpInfoTag.tagId }"/>
			<tr>
				<td width="28%" class="td-title">标签名称：</td>
				<td class="td-input">
					<input type="text" value="${bpInfoTag.tagName}" id="tagName" name="tagName" class="input-text w220" maxlength="20"/>
				</td>
			</tr>
			<tr>
				<td width="28%" class="td-title">标签编码：</td>
				<td class="td-input">
					<input type="text" value="${bpInfoTag.tagCode}" id="tagCode" name="tagCode" class="input-text w220" maxlength="30"/>
				</td>
			</tr>
			<c:if test="${bpInfoTag.tagParentId ==null }">
				<tr>
				<td width="28%" class="td-title">运营位数量：</td>
				<td class="td-input">
					<input  type="hidden" id = "pId" value="${bpInfoTag.tagParentId ==null }"/>
					<input type="text" value="${bpInfoTag.tagAmount}" id="tagAmount" name="tagAmount" class="input-text w220" maxlength="20"/>
				</td>
			</tr>			
			</c:if>
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
					dialogTypeSaveDraft("提示","请输入编码名称!",function(){});
					return;
				}
				var tagCode=$("#tagCode").val();
				if($.trim($("#tagCode").val())==""){
					dialogTypeSaveDraft("提示","请输入标签编码!",function(){});
					return;
				}
				for(iu=0;iu<=iuu;iu++){
					if($.trim($("#tagName").val()).indexOf(regArray[iu])!=-1) {
						dialogTypeSaveDraft("提示","字典名称中不可以包含特殊字符  "+regArray[iu]+"",function(){
							regArray[iu];
						});
						return false;
					}
				}
				
				if($("#pId").val()!=null){
					var tagAmount=$("#tagAmount").val();
					if($.trim($("#tagAmount").val())==""){
						dialogTypeSaveDraft("提示","请输入运营位数量!",function(){});
						return;
					}
					if(isNaN(tagAmount)){
						dialogTypeSaveDraft("提示","请输入数字!",function(){});
						return;
					}else{
						if(parseInt(tagAmount)>4||parseInt(tagAmount)<1){
							dialogTypeSaveDraft("提示","请输入1~4的数字!",function(){});
							return;
						};
					}
				}
				
				$.post("${path}/beipiaoInfoTag/addAndEditTag.do", $("#tagForm").serialize(), function(data) {
					if (data != null && data == 'success') {
                        dialogAlert("提示","编辑成功！",function(){
                            parent.location.href='${path}/beipiaoInfoTag/tagList.do';
                            dialog.close().remove();
                       });
    			   }else if (data =="nologin"){
    				   dialogConfirm("提示", "请先登录！", function(){
                 		  window.location.href = "${path}/login.do";
 	                   });
    			   }else {
    				   dialogAlert("提示", "编辑失败！")
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
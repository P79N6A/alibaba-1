<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>

<head>
	<title>文化云</title>
	<!-- 导入头部文件 start -->
	<%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
</head>
<body class="rbody">
<input type="hidden" id="userCounty" value="${sessionScope.user.userCounty}" />
<!-- 正中间panel -->
<form action="" id="sys_form">
	<div class="main-publish tag-add">
		<%--<input type="hidden" value="${tag.tagType}" name="tagType" id="tagType"/>--%>
		<table width="100%" class="form-table">
			<tr>
				<td width="28%" class="td-title">外部版本号：</td>
				<td class="td-input">
					<input type="text" value="" id="externalVnumber" name="externalVnumber" class="input-text w220"/>
				</td>
			</tr>
			<tr>
				<td width="28%" class="td-title">内部版本号：</td>
				<td class="td-input">
					<input type="text" value="" id="buildVnumber" name="buildVnumber" class="input-text w220"/>
				</td>
			</tr>
			<tr>
				<td class="td-title">版本APP：</td>
				<td class="td-input-two td-input-four"colspan="3" id="updateUrlLable">
					<input type="hidden" name="uploadType" value="Attach" id="uploadType2"/>
					<input type="hidden" name="updateUrl" id="updateUrl"/>
					<div class="td-upload">
						<input type="file" name="file3" id="file3">
						<div id="fileContainer2"></div>
							<div id="btnContainer2" style="display:none;">
                              <%--  <a href="javascript:uploadQueue2();" class="btn btn-primary"
                                   style="margin-left: 322px;">上传文件</a>
                                <a  href="javascript:clearAppQueue();" class="btn">取消</a>--%>
						</div>

					</div>
				</td>
			</tr>
			<tr>
				<td class="td-title">更新描述：</td>
				<td class="td-content" id="updateDescrLable">
					<textarea id="updateDescr" name="updateDescr" onkeydown="checkForm('updateDescr');" class="text-des"></textarea>
					<span <%--id="textCount"--%>>200字以内</span>
					<%--<textarea rows="5"  id="updateDescr" name="updateDescr" onkeydown="checkForm();" style="width:249px"></textarea>
					<span id="textCount" id="textCount">剩下200字</span>--%>
				</td>
			</tr>



			<tr>
				<td class="td-title">是否强制更新：</td>
				<td>
					<input type="radio" style="vertical-align: middle;" name="versionUpdateStatus" value="N" checked="true" id="no" />
					<label for="no">否</label>
					&nbsp;&nbsp;&nbsp;
					<input type="radio" style="vertical-align: middle;" name="versionUpdateStatus" value="Y"  id="yes" />
					<label for="yes">是</label>
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
<script type="text/javascript" src="${path}/STATIC/js/admin/phoneVersion/UploadAPP.js?version=201511101242"></script>
<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
<script type="text/javascript">
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
				//	var tagType='${tagType}';
				var  externalVnumber=$("#externalVnumber").val();
				//var type = $("#tagType").val();
				if(externalVnumber == "undefined"||externalVnumber==""){
					dialogTypeSaveDraft("提示","请输入外部版本号!",function(){
					});
					return;
				}
				var  buildVnumber=$("#buildVnumber").val();
				if($("#buildVnumber").val()==""){
					dialogTypeSaveDraft("提示","请输入内部部版本号!",function(){
						$("#buildVnumber").focus();
					});
					return;
				}
				var  updateDescr=$("#updateDescr").val();
				if($("#updateDescr").val()==""){
					dialogTypeSaveDraft("提示","请输入描述!",function(){
						$("#updateDescr").focus();
					});
					return;
				} else if($("#updateDescr").val().length>200){
					dialogTypeSaveDraft("提示","描述必须在200字内!",function(){
						$("#updateDescr").focus();
					});
					return;
				}
				var  updateUrl=$("#updateUrl").val();
				if($("#updateUrl").val()==""){
					dialogTypeSaveDraft("提示","请上传手机端APP!",function(){
						$("#updateUrl").focus();
					});
					return;
				}
				$.post("${path}/androidVersion/addAndroidVersion.do", $("#sys_form").serialize(), function(
						datas) {
					if (datas == "success") {
						dialogTypeSaveDraft("提示","保存成功",function(){
							parent.location.href="${path}/androidVersion/androidVersionIndex.do";
							dialog.close().remove();
						});
					} else if(datas == "repeat"){
						dialogTypeSaveDraft("提示", "内部版本号已经存在,不能重复!", function () {
						});
					}else {
						dialogTypeSaveDraft("提示", "保存失败!", function () {
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
<%--<script type="text/javascript" src="${path}/STATIC/js/jquery.uploadify-3.1.min.js"></script>--%>
</body>
</html>
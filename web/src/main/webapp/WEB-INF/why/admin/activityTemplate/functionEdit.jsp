<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
	<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/admin/activityTemplate/UploadFunctionImg.js"></script>
</head>

<body>
	<input type="hidden" id="userCounty" value="${sessionScope.user.userCounty}"/>
	<form id="editFunction" method="post">
		<input type="hidden" name="funId" value="${cmsFunction.funId}"/>
	    <div class="main-publish tag-add">
	        <table width="100%" class="form-table">
	            <tr>
	            	<td width="100" class="td-title"><span class="red">*</span>全称：</td>
					<td class="td-input" id="funNameLabel">
					    <input type="text" id="funName" name="funName" class="input-text w510"  maxlength="20" value="${cmsFunction.funName}"/>
						<input type="hidden" id="hideFunName" value="${cmsFunction.funName}"/>
					</td>
	            </tr>
	
				<tr>
				    <td width="100" class="td-title"><span class="red">*</span>简介：</td>
				    <td class="td-input" id="funDescrLabel">
				        <textarea name="funDescr" id="funDescr" class="input-textarea w510" maxlength="255" style="max-width: 535px;max-height: 185px;"><c:out value="${cmsFunction.funDescr}"></c:out></textarea>
				    </td>
				</tr>
				
				<tr>
				     <td width="100" class="td-title"><span class="red">*</span>示例图：</td>
				     <td class="td-upload" >
				         <table>
				             <tr>
				                 <td>
				                      <input type="hidden"  name="funIconUrl" id="funIconUrl" value="${cmsFunction.funIconUrl}"/>
				                      <input type="hidden" name="uploadType" value="Img" id="uploadType"/>
				
				                      <div class="img-box">
				                          <div  id="imgHeadPrev" class="img"> </div>
				                      </div>
				                      <span id="funIconUrlLabel"></span>
				                      <div class="controls-box" style="margin-left: 0px;">
				                          <div style="height: 46px;margin-top: 20px;">
				                              <div class="controls" style="float:left;">
				                                  <input type="file" name="file" id="file"/>
				                              </div>
				                              <span class="upload-tip">可上传1张图片，建议尺寸750*500像素，格式为jpg,jpeg,png,gif，大小不超过2M</span>
				                          </div>
				                          <div id="fileContainer"></div>
				                          <div id="btnContainer" style="display: none;">
				                              <a style="margin-left:335px;" href="javascript:clearQueue();" class="btn">取消</a>
				                          </div>
				                      </div>
				                  </td>
				             </tr>
				         </table>
				     </td>
				</tr>
				
	            <tr>
	                <td class="td-btn" align="center" colspan="2" style="padding-top: 30px;">
	                    <input class="btn-save" type="button" value="保存"/>
	                    <input class="btn-cancel" type="button" value="取消"/>
	                </td>
	            </tr>
	        </table>
	    </div>
	</form>

	<script type="text/javascript">
		function submitData(){
			$.post("${path}/function/editFunction.do", $("#editFunction").serialize(),function(data){
				if (data!=null&&data=='success') {
					dialogAlert('系统提示', '编辑成功！',function (r){
						parent.window.location.href="${path}/function/functionIndex.do";
					});
				}else{
					dialogAlert('系统提示', '编辑失败！');
				}
			});
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
			/*窗口元素*/
			var dialog = parent.dialog.get(window);

			/*点击确定按钮*/
			$(".btn-save").on("click", function(){
				var funName = $("#funName").val();
				var funDescr = $("#funDescr").val();
				var funIconUrl = $("#funIconUrl").val();

				if(funName==undefined||funName.trim()==""){
					removeMsg("funNameLabel");
					appendMsg("funNameLabel","全称为必填项!");
					$('#funName').focus();
					return;
				}else{
					removeMsg("funNameLabel");
					if(funName.length>20){
						appendMsg("funNameLabel","全称只能输入20字以内!");
						$('#funName').focus();
						return;
					}
				}

				if(funDescr==undefined||funDescr.trim()==""){
					removeMsg("funDescrLabel");
					appendMsg("funDescrLabel","简介为必填项!");
					$('#funDescr').focus();
					return;
				}else{
					removeMsg("funDescrLabel");
					if(funDescr.length>255){
						appendMsg("funDescrLabel","简介只能输入255字以内!");
						$('#funDescr').focus();
						return;
					}
				}

				if(funIconUrl==undefined||funIconUrl==""){
					removeMsg("funIconUrlLabel");
					appendMsg("funIconUrlLabel","示例图为必填项!");
					$('#funIconUrl').focus();
					return;
				}else{
					removeMsg("funIconUrlLabel");
				}

				var hideFunName = $("#hideFunName").val();
				if(hideFunName != funName){
					$.post("${path}/function/checkRepeat.do",{functionName:funName},function(data){
						if(data=="success"){
							submitData();
						}else if(data=="false"){
							removeMsg("funNameLabel");
							appendMsg("funNameLabel","全称不能重名!");
							$('#funName').focus();
						}
					});
				}else{
					submitData();
				}
			});

			/*点击取消按钮，关闭登录框*/
			$(".btn-cancel").on("click", function(){
				dialog.close().remove();
			});
		});
	</script>
</body>
</html>





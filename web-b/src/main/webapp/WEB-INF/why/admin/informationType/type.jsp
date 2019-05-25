<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>活动列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>

</head>

<body style="background: none;">
<form id="typeForm">
	<input type="hidden" name="informationTypeId" value="${informationType.informationTypeId }"/>
    <input type="hidden" id="informationModuleId" name="informationModuleId" value="${informationModuleId}"/>
    <input type="hidden" id="parentTypeListCount" name="parentTypeListCount" value="${fn:length(parentInformationTypeList)}" />
    <div class="main-publish tag-add">
            <table width="100%" class="form-table">
            	<c:if test="${fn:length(parentInformationTypeList) gt 0}">
	            	<tr>
	            		<td class="td-title" width="20%"><span class="red">*</span>父级类型：</td>
	            		<td placeholder="资讯父级类型" class="td-select" >
					  		<select id="typeParentId" name="typeParentId" class="ng-select-box" >
					  			<c:if test="${empty informationType.typeParentId}">
					  				<option value=''>请选择</option>
					  			</c:if>
					  			<c:forEach items="${parentInformationTypeList}" var="type">
					  				<c:choose>
					  					<c:when test="${informationType.typeParentId == type.informationTypeId}">
					  						<option selected value='${type.informationTypeId}'>${type.typeName}</option>
					  					</c:when>
					  					<c:otherwise>
					  						<option value='${type.informationTypeId}'>${type.typeName}</option>
					  					</c:otherwise>
					  				</c:choose>
					  				
					  			</c:forEach>
					  		</select>
					  		<span class="error-msg" id="typeParentIdSpan"></span>
	                	</td> 
	            	</tr>
	            </c:if>
                <tr>
                    <td class="td-title" width="20%"><span class="red">*</span>类型名称：</td>
                    <td class="td-input"><input type="text" class="input-text w210" id="typeName" name="typeName" value="${informationType.typeName }"/><span class="error-msg" id="typeNameSpan"></span></td>
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
            	var parentType = "";
            	if($("#parentTypeListCount").val() > 0){
            		parentType = $("#typeParentId").val();
        			
        			if (!parentType) {
        				$("#typeParentIdSpan").html("请选择父级类型");
                        $('#typeParentId').focus();
                        return;
        			}else{
        				$("#typeParentIdSpan").html("");
        			}
            	}
            	
                var typeName = $("#typeName").val();
                if(typeName==undefined||$.trim(typeName)==""){
                    $("#typeNameSpan").html("请输入类型名称");
                    $('#typeName').focus();
                    return;
                }else{
                    $("#typeNameSpan").html("");
                }
                var informationModuleId = $("#informationModuleId").val();
                $.post("${path}/ccpInformationType/saveInformationType.do", $("#typeForm").serialize(), function(result) {
                    if(result == "repeat"){
                        $("#typeNameSpan").html("类型名称不可重复!");
                        $('#typeName').focus();
                    }else if (result == "success") {
                        dialogTypeSaveDraft("提示", "保存成功", function(){
                            parent.location.href="${path}/ccpInformationType/informationTypeIndex.do?informationModuleId="+informationModuleId;
                            dialog.close().remove();
                        });
                    }else if (result == "login") {
                    	
                      	 dialogAlert('提示', '请先登录！', function () {
                      		parent.location.href = "${path}/login.do";
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
</body>
</html>
<%@ page language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <title>文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <%@include file="/WEB-INF/why/common/limit.jsp" %>
    
        <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    
    <script type="text/javascript">
    var informationModuleId = '${informationModuleId}';
    
    if(!'${sessionScope.user}'){
		window.location.href="${pageContext.request.contextPath}/login.do";
	}
    
    function saveInfo(){
    	
    	var informationModuleName = $("#informationModuleName");
    	
		if (!informationModuleName) {
			dialogAlert("提示", "请填写名称");
			return
		}
			
		$.post("${path}/ccpInformationModule/saveOrUpdateInformationModule.do", $("#infoFrom").serialize(), function(result) {
            if (result == "success") {
                dialogTypeSaveDraft("提示", "保存成功", function(){
                    window.location.href="${path}/ccpInformationModule/informationModuleIndex.do";
                });
            }else{
                dialogTypeSaveDraft("提示", "保存失败");
            }
        });
    }
    
    function dialogTypeSaveDraft(title, content, fn) {
        var d = window.dialog({
            width: 400,
            title: title,
            content: content,
            fixed: true,
            okValue: '确 定',
            ok: function () {
                if (fn)  fn();
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

	</script>
</head>

<body >
<form id="infoFrom" >
    <input type="hidden" id="informationModuleId" name="informationModuleId" value="${info.informationModuleId}"/>
    <div class="site">
        <em>您现在所在的位置：</em>资讯模块配置 &gt; 资讯模块编辑
    </div>
    <div class="site-title">资讯模块编辑</div>
    <div class="main-publish">
        <table width="100%" class="form-table">
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>名称：</td>
                <td placeholder="名称" class="td-input">
                    <input type="text" placeholder="名称最多输入8个字" 
                           class="input-text w510" value="${info.informationModuleName}" maxlength="8" id="informationModuleName" name="informationModuleName"/>
                </td>
            </tr>
	                
            <tr>
                <td width="100" class="td-title"></td>
                <td class="td-btn">
                    <div class="room-order-info info2" style="position: relative;">
                    	<button type="button" class="btn-publish" onclick="javascript:history.go(-1);">取消操作</button>
                        <button type="button"  class="btn-save" onclick="saveInfo()">保存</button>
                    </div>
                </td>
            </tr>
        </table>
    </div>
</form>
</body>
</html>
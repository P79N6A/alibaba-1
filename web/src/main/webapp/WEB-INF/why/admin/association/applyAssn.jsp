<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>

<head>
    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>

	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
	
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    
    <script type="text/javascript">
    
	    $(function () {
	    	//加载社团类别
	        $.post("${path}/tag/getChildTagByType.do",{code:"ASSOCIATION_TYPE"}, function (data) {
	            if (data != '' && data != null) {
	                var list = eval(data);
	                var ulHtml = '';
	                for (var i = 0; i < list.length; i++) {
	                    var dict = list[i];
	                    ulHtml += '<li data-option="' + dict.tagId + '">' + dict.tagName + '</li>';
	                }
	                $('#assnTypeUl').html(ulHtml);
	                selectModel();
	            }
	        },"json");
	    	
	    });
    
	  	//保存信息
	    function applyAssn(){
	        var assnName=$('#assnName').val();
	        var assnLinkman = $("#assnLinkman").val();
	        var assnPhone = $("#assnPhone").val();
	        var assnType = $("#assnType").val();
	        var assnIntroduce = $("#assnIntroduce").val();
	        
	        //社团名称
	        if(assnName==undefined||assnName.trim()==""){
	            removeMsg("assnNameLabel");
	            appendMsg("assnNameLabel","社团名称为必填项!");
	            $('#assnName').focus();
	            return;
	        }else{
	            removeMsg("assnNameLabel");
	            if(assnName.length>20){
	                appendMsg("assnNameLabel","社团名称只能输入20字以内!");
	                $('#assnName').focus();
	                return false;
	            }
	        }
	        
	        //社团联系人
	        if(assnLinkman==undefined||assnLinkman.trim()==""){
	            removeMsg("assnLinkmanLabel");
	            appendMsg("assnLinkmanLabel","社团联系人为必填!");
	            $('#assnLinkman').focus();
	            return;
	        }else{
	            removeMsg("assnLinkmanLabel");
	            if(assnLinkman.length>20){
	                appendMsg("assnLinkmanLabel","社团联系人只能输入20字以内!");
	                $('#assnLinkman').focus();
	                return false;
	            }
	        }
	
	        //联系电话
	        if(assnPhone==undefined||assnPhone==""){
	            removeMsg("assnPhoneLabel");
	            appendMsg("assnPhoneLabel","联系电话为必填项!");
	            $('#assnPhone').focus();
	            return;
	        }else{
	            removeMsg("assnPhoneLabel");
	        }
	        
	      	//社团类型
	        if(assnType==undefined||assnType==""){
	            removeMsg("assnTypeLabel");
	            appendMsg("assnTypeLabel","请选择社团类型!");
	            $('#assnType').focus();
	            return;
	        }else{
	            removeMsg("assnTypeLabel");
	        }
	        
	      	//社团简介
	        if(assnIntroduce==undefined||assnIntroduce.trim()==""){
	            removeMsg("assnIntroduceTipLabel");
	            appendMsg("assnIntroduceTipLabel","社团简介为必填!");
	            $('#assnIntroduce').focus();
	            return;
	        }else{
	            removeMsg("assnIntroduceLabel");
	            if(assnIntroduce.length>500){
	                appendMsg("assnIntroduceTipLabel","社团简介只能输入500字以内!");
	                $('#assnIntroduce').focus();
	                return false;
	            }
	        }
	        
	        //保存申请信息
	        $.post("${path}/association/applyAssociation.do", $("#associationApplyForm").serialize(),function(data) {
                if (data!=null&&data=='success') {
                    dialogAlert('系统提示', "申请完成！",function (r){
                    	$('body', parent.document).find('#DialogBySHFLayer,#DialogBySHF').remove();
                    });

                }else{
                    dialogAlert('系统提示', '申请失败！');
                }
	        },"json");
	    }
        
    </script>
</head>

<body>
	<form action="${path}/association/applyAssociation.do" id="associationApplyForm" method="post">
	    <div class="site">
	        <h2>社团申请</h2>
	    </div>
	    <div class="main-publish" style="padding: 20px;">
	        <table width="100%" class="form-table">
	            <tr>
	                <td class="td-title"><p style="width:80px;display:block;margin:0px"><span class="red">*</span>社团名称：</p></td>
	                <td class="td-input" id="assnNameLabel"><input type="text" id="assnName" name="assnName" class="input-text w340" maxlength="20"/></td>
	            </tr>
	            <tr>
	                <td class="td-title"><span class="red">*</span>联系人：</td>
	                <td class="td-input" id="assnLinkmanLabel"><input type="text" id="assnLinkman" name="assnLinkman" class="input-text w340" maxlength="20"/></td>
	            </tr>
	            <tr>
	                <td class="td-title"><span class="red">*</span>联系电话：</td>
	                <td class="td-input" id="assnPhoneLabel"><input type="text" id="assnPhone" name="assnPhone" class="input-text w340" maxlength="11"/></td>
	            </tr>
	            <tr>
	                <td class="td-title"><span class="red">*</span>社团类型：</td>
	                <td class="td-input search" id="assnTypeLabel">
	                	<div class="select-box w135" style="margin-left: 0;">
				            <input type="hidden" id="assnType" name="assnType"/>
				            <div id="assnTypeDiv" class="select-text" data-value="">-请选择-</div>
				            <ul class="select-option" id="assnTypeUl"></ul>
				        </div>
	                </td>
	            </tr>
	            <tr>
	            	<td class="td-title"><span class="red">*</span>社团简介：</td>
	                <td class="td-input">
	                    <div class="editor-box">
	                        <textarea name="assnIntroduce" rows="4" class="textareaBox" id="assnIntroduce"  maxlength="500" style="resize: none;width:350px"></textarea>
	                        <span class="upload-tip" style="color:#596988" id="assnIntroduceTipLabel">（0~500个字以内）</span>
	                    </div>
	                </td>
	            </tr>
	            <tr>
	            	<td colspan="2">
	            		<div class="form-table form_table_btn" style="width: 100%; padding: 10px 0 30px; background: #ffffff;">
					        <input class="btn-publish" type="button" onclick="applyAssn()" value="申请"/>
						    <input class="btn-save" type="button" onclick="$('body', parent.document).find('#DialogBySHFLayer,#DialogBySHF').remove();" value="取消"/>
					    </div>
	            	</td>
	            </tr>
	        </table>
	    </div>
	</form>
</body>
</html>
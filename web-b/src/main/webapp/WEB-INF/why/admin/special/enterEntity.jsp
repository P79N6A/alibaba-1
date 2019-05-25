<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>活动列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
     <%@include file="/WEB-INF/why/common/aliImageFrame.jsp"%>

<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
<script type="text/javascript">
    $(function(){
    	
    	$.post("../specialProject/searchProjectList.do",function(data) {
    		
    		var projectId = $("#projectId").val();

            if (data != '' && data != null) {
                var list = eval(data);
                var ulHtml = '<li data-option="">请选择</li>';
                for (var i = 0; i <list.length; i++) {
                    var project = list[i];
                    ulHtml += '<li data-option="'+project.projectId+'">'+ project.projectName+ '</li>';
                    
                    if(projectId != '' && projectId == project.projectId){
                        $('#projectIdDiv').html(project.projectName);
                    }
                }
                $('#projectIdUl').html(ulHtml);
            }
        }).success(function() {
            selectModel();
        });
    	
    	aliUploadImg("aliImg",uploadCallBack)
    	
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
                var enterName = $("#enterName").val();
                if(enterName==undefined||$.trim(enterName)==""){
                    $("#enterNameSpan").html("渠道入口名称不能为空");
                    $('#enterName').focus();
                    return;
                }else{
                    $("#enterNameSpan").html("");
                }

                var projectId=$("#projectId").val();
                
                if(projectId==undefined||$.trim(projectId)==""){
                    $("#projectIdSpan").html("选择活动主题为必选");
                    $('#projectId').focus();
                    return;
                }else{
                    $("#projectIdSpan").html("");
                }
                
                var enterParamePath = $("#enterParamePath").val();
                if(enterParamePath==undefined||$.trim(enterParamePath)==""){
                    $("#enterParamePathSpan").html("入口参数路径不能为空");
                    $('#enterParamePath').focus();
                    return;
                }else{
                    $("#enterParamePathSpan").html("");
                }
                
                $.post("${path}/specialEnter/saveEnter.do", $("#form").serialize(), function(result) {
                	
                    if (result == "success") {
                        dialogTypeSaveDraft("提示", "保存成功", function(){
                            parent.location.href="${path}/specialEnter/index.do";
                            dialog.close().remove();
                        });
                    }else if (result == "login") {
                    	
                    	 dialogAlert('提示', '请先登录！', function () {
                 			window.location.href = "${path}/login.do";
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
    
    function uploadCallBack(up, file, info){
    	var aliImgUrl = "${aliImgUrl}" + info 
    	//$(".aliImg").find("img").attr("src",aliImgUrl+"@300w").css({"width":"100px","height":"100px"})
    	$("#enterLogoImageUrl").val(aliImgUrl)
    	
    	$("#"+file.id).append('<input type="hidden" name="enterLogoImageUrl" id="enterLogoImageUrl" value="'+aliImgUrl+'"/>')
    	
	}
</script>
</head>

<body style="background: none;">
<form id="form">
    <div class="main-publish tag-add" style="overflow:visible;">
    	<input type="hidden" name="enterId" id="enterId" value="${entity.enterId }"/>
            <table width="100%" class="form-table">
                <tr>
                    <td class="td-title" width="20%"><span class="red">*</span>渠道入口名称：</td>
                    <td class="td-input"><input type="text" class="input-text w210" id="enterName" name="enterName" value="${entity.enterName }"/>
                    <span class="error-msg" id="enterNameSpan"></span>
                    </td>
                </tr>
                <tr>
                    <td class="td-title" width="20%"><span class="red">*</span>选择活动主题：</td>
                    <td class="td-input search" id="projectIdLabel">

                    <div class="select-box w230" style="margin-left: 0px;">
                        <input type="hidden" value="${entity.projectId }" name="projectId" id="projectId"/>
                        <div class="select-text" data-value="" id="projectIdDiv">请选择</div>
                        <ul class="select-option" style="display: none;max-height:100px"  id="projectIdUl">
                        </ul>
                    </div>
                      <span class="error-msg" id="projectIdSpan"></span>
              	  </td>
                </tr>
                <tr>
                    <td class="td-title" width="20%"><span class="red">*</span>入口参数路径：</td>
                    <td class="td-input"><input type="text" class="input-text w210" id="enterParamePath" name="enterParamePath" value="${entity.enterParamePath }"/><span class="error-msg" id="enterParamePathSpan"></span></td>
                </tr>
               <tr id="aliImg" style="height:210px;">
                    <td class="td-title" width="20%">图片logo：</td>
                    <td class="td-input" style="padding:0;height:210px;vertical-align:top;">
                    <div class="aliImg img-box">
                    <c:choose>
		                 		<c:when test="${empty  entity.enterLogoImageUrl}">
		                 		</c:when>
		                 		<c:otherwise>
		                 			<div name="aliFile" style="position:relative" ><span></span><b></b>
		                 		<img onclick="aliRemoveImg(this)" class="aliRemoveBtn" src="../STATIC/image/removeBtn.png" style="position:absolute;left:80px;top:0;width:20px" />
		                 			<img src="${entity.enterLogoImageUrl}@300w"  style="max-height: 100px;max-width: 100px;"  />
		                 			 <input type="hidden" value="${entity.enterLogoImageUrl }" name="enterLogoImageUrl" id="enterLogoImageUrl"/>
		                 			</div>
		                 		</c:otherwise>
		                 	</c:choose> 
                    
                   
                    </div>
                    <div id="ossfile2">你的浏览器不支持flash,Silverlight或者HTML5！</div>
                    <div id="container2">
                  		<a id="selectfiles2" href="javascript:void(0);" class='btn'>选择文件</a>
						<a id="postfiles2" href="javascript:void(0);" class='btn'>开始上传</a>
                    </div>
                    </td>
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


</body>
</html>
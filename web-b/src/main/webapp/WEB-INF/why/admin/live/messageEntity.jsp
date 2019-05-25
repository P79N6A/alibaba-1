<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>添加修改专属也--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/aliImageFrame.jsp"%>

<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
<script type="text/javascript">
	$.ajaxSettings.async = false; 	//同步执行ajax

    seajs.config({
        alias: {
            "jquery": "jquery-1.10.2.js"
        }
    });

    seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
        window.dialog = dialog;
    });

    window.console = window.console || {log:function () {}}
    
    $(function(){
    	
    });
    
    window.onload = function() { 
		aliUploadImg("whyUploadImgDiv",uploadImgCallBack, 3)
	}
    
    function uploadImgCallBack(up, file, info){
    	var aliImgUrl = "${aliImgUrl}" + info 
    	
    	//$("#"+file.id).find("input[name='"+messageImg+"']").val(aliImgUrl)
    	
    	$("#"+file.id).append('<input type="hidden" name="messageImg" value="'+aliImgUrl+'"/>')
    	
    	
	}
	
    
    seajs.use(['jquery'], function ($) {
        $(function () {
        	var dialog = parent.dialog.get(window);
        	
        	/*点击确定按钮*/
            $(".btn-save").on("click", function(){
                var messageContent = $("#messageContent").val();
                
                if(messageContent==undefined||$.trim(messageContent)==""){
                    $("#messageContentSpan").html("文字内容为必填");
                    $('#messageContent').focus();
                    return;
                }else{
                	$("#messageContentSpan").html("");
                }
              

                $.post("${path}/live/saveMessage.do", $("#form").serialize(), function(result) {
                	
                    if (result == "success") {
                    	dialogTypeSaveDraft("提示", "保存成功", function(){
                            parent.location.href="${path}/live/messageIndex.do";
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
        	
        	/*点击取消按钮，关闭弹出框*/
            $(".btn-cancel").on("click", function(){
                dialog.close().remove();
            });
        })
    })
    

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
</head>

<body style="background: none;">
	<form id="form">
		<input id="messageActivity" name="messageActivity" type="hidden" value="3"/>
	    <div class="main-publish tag-add" style="overflow-y: scroll;height:500px;">
	    	<input type="hidden" name="messageId" id="messageId" value="${entity.messageId}"/>
	        <table width="100%" class="form-table">
	          <tr>
	                <td class="td-title" width="20%"><span class="red">*</span>文字内容：</td>
	                <td class="td-input"><textarea id="messageContent" name="messageContent" rows="4" class="textareaBox" style="width: 380px;resize: none" >${entity.messageContent }</textarea></div>  <span class="error-msg" id="messageContentSpan"></span></td>
	            </tr>
	            <tr>
                    <td class="td-title" width="20%">选择图片：</td>
                    <td class="td-input search" id="projectIdLabel" height="500">
	                 	<div class="whyUploadVedio">
								<!-- <div style="float: left;width: 145px;text-align: right;font-size: 16px;color: #333;">作品封面 </div>
								<div style="float: right;width: 700px;font-size: 14px;color: #999;line-height: 25px;">尺寸为：320*200，节目预览图片上传，格式为：jpg,png,bmp</div> -->
								<div style="clear: both;"></div>
								<div id="whyUploadImgDiv" style="margin-left: 20px;margin-top: 25px;width: 500px;">
									<div  class="whyUploadImgDiv">
									
									<c:choose>
										<c:when test="${!empty entity.messageImg }">
											<c:forEach items="${fn:split(entity.messageImg, ',')}" var="img">
									
										<div name="aliFile" style="position:relative" ><span></span><b></b>
											<img onclick="aliRemoveImg(this)" class="aliRemoveBtn" src="../STATIC/image/removeBtn.png" style="position:absolute;left:80px;top:0;width:20px" />
											<img src="${img}" style="max-height: 100px;max-width: 100px;" />
											<input type="hidden" name="messageImg" value="${img }"/>
											<br />
										</div>
									</c:forEach>
										</c:when>
										<c:otherwise>
										
										</c:otherwise>
									</c:choose>
									<div id="ossfile2">你的浏览器不支持flash,Silverlight或者HTML5！</div>
									</div>
									
									<!--<pre id="console"></pre>-->
									<br/>
									<div id="container2">
										<a id="selectfiles2" href="javascript:void(0);" class='btn'>1.选择文件</a>
										<a id="postfiles2" href="javascript:void(0);" class='btn'>2.点击开始上传</a>
									</div>
								</div>
								<span class="error-msg" id="videoImgUrlSpan"></span>
							</div>
              	    </td>
                </tr>
	            <tr>
	                <td class="td-title"></td>
	                <td class="td-btn" style="padding: 36px 0;">
	                    <input class="btn-save" type="button"  value="保存"/>
	                    <input class="btn-cancel" type="button" value="关闭"/>
	                </td>
	            </tr>
	        </table>
	    </div>
	</form>
</body>
</html>
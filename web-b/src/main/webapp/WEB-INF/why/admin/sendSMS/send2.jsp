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
        	/*点击确定按钮*/
            $(".btn-publish").on("click", function(){
            	
            	
            	var month =$("#month").val();
            	
            	if(!month||$.trim(month)==""){
            		
            		$("#monthSpan").html("月份必选");
            		$('#month').focus();
                    return;
            	}else{
                	$("#monthSpan").html("");
                }
            	
            	var area=$("#area").val();
            	
				if(!area||$.trim(area)==""){
            		
					$("#areaSpan").html("");
            		$("#areaSpan").html("场馆必填");
            		$('#area').focus();
                    return;
            	}else if(area.length>50){
            		
            		$("#areaSpan").html("");
            		$("#areaSpan").html("场馆不超过50");
            		$('#area').focus();
                    return;
            	}else{
                	$("#areaSpan").html("");
                }
            	
				var num=$("#num").val();
				
				if(!num||$.trim(num)==""){
            		
					$("#numSpan").html("");
            		$("#numSpan").html("数量必选");
            		$('#num').focus();
                    return;
				}else
					$("#numSpan").html("");
				
				var areaRank=$("#areaRank").val();
				
				if(!areaRank||$.trim(areaRank)==""){
            		
					$("#areaRankSpan").html("");
            		$("#areaRankSpan").html("区排名必选");
            		$('#areaRank').focus();
                    return;
				}else
					$("#areaRankSpan").html("");
				
				var cityRank=$("#cityRank").val();
				
				if(!cityRank||$.trim(cityRank)==""){
            		
					$("#cityRankSpan").html("");
            		$("#cityRankSpan").html("市排名必选");
            		$('#cityRank').focus();
                    return;
				}else
					$("#cityRankSpan").html("");
				
                var telephoneNumber = $("#telephoneNumber").val();
                
                var isMobile=/^(?:13\d|15\d|18\d)\d{5}(\d{3}|\*{3})$/; //手机号码验证规则
                
                if(telephoneNumber==undefined||$.trim(telephoneNumber)==""){
                	$("#telephoneNumberSpan").html("");
                	$("#telephoneNumberSpan").html("发送电话必填");
                    $('#telephoneNumber').focus();
                    return;
                }else{
                	
                	var result=true;
                	  $.each(telephoneNumber.split(","),function(i,userTelephone){

                		  if(!isMobile.test(userTelephone)){ 
                			$("#telephoneNumberSpan").html("");
                			$("#telephoneNumberSpan").html("手机格式不正确");
                             $('#telephoneNumber').focus();
                             result=false;
                             return false;     
                		  }
                      });
                	  
                	  if(!result)
                		  return;
                	  else
                		$("#telephoneNumberSpan").html("");
                }
              

                $.post("${path}/sendSMS/send.do", $("#form").serialize(), function(result) {
                	
                    if (result.success) {
                    	dialogTypeSaveDraft("提示", "发送成功", function(){
                    		window.location.href="${path}/sendSMS/sendSMSIndex.do";
                        });
                    }else if(result.error){
                    	dialogTypeSaveDraft("提示", result.error);
                    	
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
        var d = window.dialog({
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
 <div class="site">
		    <em>您现在所在的位置：</em>运维管理 &gt;后台发送短信&gt;发送短信
		</div>
	<form id="form">
	    <div class="main-publish tag-add" >
	    	<input type="hidden" name="templateId" id="templateId" value="${templateId}"/>
	        <table width="100%" class="form-table">
	        	 <tr>
	                <td class="td-title" width="20%">模板名称：</td>
	                  <td class="td-input">
	                	${ templateName }</td>
	            </tr>
	      		 <tr>
	                <td class="td-title" width="20%"><span class="red">*</span>月份：</td>
	                <td class="td-input">
	                
	                 <input type="number" class="input-text w220" id="month" name="month" max="12" min="1"/>
	                  <span class="error-msg" id="monthSpan"></span></td>
	            </tr>
	            <tr>
	                <td class="td-title" width="20%"><span class="red">*</span>场馆名称：</td>
	                <td class="td-input">
	                
	                 <input type="text" class="input-text w220" id="area" name="area" />
	                  <span class="error-msg" id="areaSpan"></span></td>
	            </tr>
	             <tr>
	                <td class="td-title" width="20%"><span class="red">*</span>数量：</td>
	                <td class="td-input">
	                 
	                 <input type="number" class="input-text w220" id="num" name="num" min="0"/>
	                  <span class="error-msg" id="numSpan"></span></td>
	            </tr>
	             <tr>
	                <td class="td-title" width="20%"><span class="red">*</span>区排名：</td>
	                <td class="td-input">
	                 
	                 <input type="number" class="input-text w220" id="areaRank" name="areaRank" min="0"/>
	                  <span class="error-msg" id="areaRankSpan"></span></td>
	            </tr>
	             <tr>
	                <td class="td-title" width="20%"><span class="red">*</span>市排名：</td>
	                <td class="td-input">
	                 
	                 <input type="number" class="input-text w220" id="cityRank" name="cityRank" min="0"/>
	                  <span class="error-msg" id="cityRankSpan"></span></td>
	            </tr>
	          <tr>
	                <td class="td-title" width="20%"><span class="red">*</span>发送电话号码：</td>
	                <td class="td-input"><textarea id="telephoneNumber" name="telephoneNumber" rows="4" class="textareaBox" style="width: 380px;resize: none" >${entity.telephoneNumber }</textarea><span class="error-msg" id="telephoneNumberSpan"></span><br />多个手机号以英文逗号,隔开</td>
	            </tr>
	            <tr>
	                <td class="td-title"></td>
	                <td class="td-btn" style="padding: 36px 0;">
	                    <input class="btn-publish" type="button"  value="发送"/>
	                </td>
	            </tr>
	        </table>
	    </div>
	</form>
</body>
</html>
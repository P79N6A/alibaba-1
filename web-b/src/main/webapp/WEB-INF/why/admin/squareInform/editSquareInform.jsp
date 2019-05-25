<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>编辑用户</title>
	<!-- 导入头部文件 start -->
	<%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
	<%@include file="/WEB-INF/why/common/limit.jsp" %>
	 <link rel="stylesheet" type="text/css" href="${path}/STATIC/aliImage/style.css"/>
	   <script type="text/javascript" src="${path}/STATIC/wechat/js/jquery-2.1.4.min.js"></script>
       <script type="text/javascript" src="${path}/STATIC/aliImage/uuid.js"></script>
       <script type="text/javascript" src="${path}/STATIC/aliImage/crypto.js"></script>
       <script type="text/javascript" src="${path}/STATIC/aliImage/hmac.js"></script>
       <script type="text/javascript" src="${path}/STATIC/aliImage/sha1.js"></script>
       <script type="text/javascript" src="${path}/STATIC/aliImage/base64.js"></script>
       <script type="text/javascript" src="${path}/STATIC/aliImage/plupload.full.min.js"></script>
       <script type="text/javascript" src="${path}/STATIC/aliImage/upload-img.js"></script>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
	<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    <script type="text/javascript">
            $(function () {
                $(".btn-publish").on("click", function(){
                	//getImgs();
                	var ext1=$("#ext1").val();
                	var ext0=$('input[name=ext0]').val();
                	var ext3=$("#ext3").val();
                	var ext2=$("#ext2").val();
                	if(ext1 ==undefined||ext1 ==""){
                		alert("请输入标题");
                		return false;
                	}
                	if(ext0 ==undefined||ext0 ==""){
                		alert("请上传图片");
                		return false;
                	}
                	
                	if(ext2 ==undefined||ext2 ==""){
                		alert("请输入内容");
                		return false;
                	}
                     $.post("${path}/squareInform/updateSquareInform.do",$("#squareInformForm").serialize(),function (data) {
                         if (data == 'success') {
                        	 dialogAlert("系统提示", "保存成功", function () {
                                 window.location.href = "${path}/squareInform/squareInformList.do"
                             });
                                dialog.close().remove();
                        }else if(data!=null && data=='login'){
                      		 alert("请先登录")
                     			window.location.href = "${path}/login.do";
                        }else{
                          alert("保存失败")
                         } 
                    }); 
                });
                /*点击取消按钮，关闭登录框*/
                $(".btn-save").on("click", function(){
                	window.location.href = "${path}/squareInform/squareInformList.do"
                    dialog.close().remove();
                });
            });
        
        
   /*      function testalert(up, file, info) {
            var url = "http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info;
        	
        	$("#" + file.id).find("img").not(".aliRemoveBtn").attr("data-src",url);
		}

		window.onload = function() {
			aliUploadImg('webupload5', testalert, 1, true)
		}
		
		 function removeImg(obj){
			 //$(obj).parent().remove();
		 }
		 function getImgs(){
				var imgs="";
				$("#ossfile2").find('img').each(function(index,item){
					if($(item).hasClass("upload-img-identify")){
						imgs+=$(item).attr("data-src");	
					}
				});
				if(imgs ==undefined||imgs ==""){
					$("#container2").find('img').each(function(index,item){
						 if($(item).hasClass("upload-img-identify")){ 
							imgs+=$(item).attr("src");	
						 } 
					});
				}
				$("#ext0").val(imgs);
			}  */
			 $(function () {
				 aliUploadImg('webupload5', getAssnImgUrl, 1, true, 'H5')
		        });
		        
		      	//封面图回调
		        function getAssnImgUrl(up, file, info) {
		        	var filePath = "http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info;
		        	$("#"+file.id).append("<input type='hidden' name='ext0' value='"+filePath+"'/>");
				}
    </script>
    
    <style type="text/css">
    	.upload-img-identify{position:static!important;}
    	.progress{margin:0!important;}
    	.ossfile2{margin-left:20px;}
    	.aliRemoveBtn{position:absolute;left:110px!important;top:0;width:20px}
    </style>
</head>

<body >

<form action="${path}/squareInform/updateSquareInform.do" id="squareInformForm" method="post">
    <div class="site">
        <em>您现在所在的位置：</em>运维管理 &gt;广场通知
    </div>
   <div class="site-title">广场通知</div>
		 <div class="main-publish">
	        <table width="100%" class="form-table">
	         <tr>
                <td width="100" class="td-title"><span class="red">*</span>标题:</td>
                <td class="td-input" id="heritageNameLabel"><input  type="text" class="input-text w510" name="ext1" id="ext1" value="${squareInform.ext1}"/></td>
             </tr>
             <tr>
             	<td width="100" class="td-title"><span class="red">*</span>图片:</td>
             	<td>
             		<div class="whyUploadVedio" id="webupload5">
						<div style="" class="clearfix">
							<div id="container2" style="float: left;overflow: hidden;">
								<%-- <c:set var="ext0" value="${squareInform.ext0}"/>
								<c:set var="img" value="${fn:replace(ext0, 
                                'http://oss-cn-hangzhou.aliyuncs.com/culturecloud', 'http://culturecloud.img-cn-hangzhou.aliyuncs.com')}" /> --%>
                                <div name="aliFile" style="position:relative">
                                <img src="${squareInform.ext0}" class="upload-img-identify" style="max-height: 100px;max-width: 100px;" />
                                </div>
								
								<img onclick="removeImg()"  src="${path}/STATIC/image/addpic.png" id="selectfiles2" style="display: block;width: 100px;height: 100px;" />
							</div>
							<div id="ossfile2" style="width: 470px;float: left;" class="clearfix"></div>
						</div>
					</div>
             	</td>
             </tr>
             <tr>
                <td width="100" class="td-title">链接:</td>
                <td class="td-input" id="heritageNameLabel"><input  type="text" class="input-text w510" name="ext3" id="ext3" value="${squareInform.ext3}"/></td>
             </tr>
             <tr>
                <td width="100" class="td-title"><span class="red">*</span>内容:</td>
                 <td class="td-input">
	                    <div class="editor-box">
	                        <textarea id="ext2" name="ext2" rows="5" class="textareaBox"  maxlength="2000" style="width: 500px;resize: none">${squareInform.ext2}</textarea>
	                        <span class="upload-tip" style="color:#596988" id="ext2Label">（0~200个字以内）</span>
	                    </div>
	             </td>
             </tr>
            </table>
               <!--  <input type="hidden" id="ext0" name="ext0"> -->
                <input type="hidden" id="squareId" name="squareId" value="${squareInform.squareId}">
                <input type="hidden" id="outId" name="outId" value="${squareInform.outId}">
                <input type="hidden" id="contextDec" name="contextDec" value="${squareInform.contextDec}">
                <input type="hidden" id="userName" name="userName" value="${squareInform.userName}">
 		    <div class="select-btn form-table" style="width: 305px;margin:10px auto 0;">
                  <input type="button" class="btn-publish" value="提交"/>
                   <input type="button" class="btn-save" value="返回"/> 
            </div>
</form>
</body>
</html>
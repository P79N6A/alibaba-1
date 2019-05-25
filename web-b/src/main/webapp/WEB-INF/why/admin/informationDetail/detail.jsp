<%@ page language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <%@include file="/WEB-INF/why/common/limit.jsp" %>
    <%@include file="/WEB-INF/why/common/aliImageFrame.jsp" %>
    
     <script type="text/javascript" src="${path}/STATIC/js/ckeditor/sample.js"></script>
    
    <script type="text/javascript">
    
  	//上传图片回调函数
    function uploadImgCallback1(up, file, info) {
    	//$('#'+file.id).append("<input type='hidden' id='jiazhouInfoIconUrl' value='http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info+"'/>");
  	 	var filePath = "http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info;
    	
    	$("#"+file.id).append("<input type='hidden' id='detailImage' name='detailImage' value='"+filePath+"'/>");
  	}

  	
    $(function () { 
    	
    	var informationSort=${informationSort}
            aliUploadImg('webupload2', uploadImgCallback1, 1, true, 'H5');
    	/*alert(informationSort)
    	if(informationSort==2)
    		// 图片
			aliUploadImg('webupload2', uploadImgCallback1, 1, true, 'H5');
    	else
    		aliUploadImg('webupload2', uploadImgCallback1, 9, true, 'H5');*/
    });
    
    function saveInfo(){
    	
    	
			var detailImage=$("#detailImage").val();
			
			if(!detailImage){
				$("#infoFrom").append('<input type="hidden" id="detailImage" name="detailImage" value=""/>')
			}
			
			var informationId=$("#informationId").val();
			
			if(CKEDITOR.instances.detailContent){
				
				 var detailContent = CKEDITOR.instances.detailContent.getData();
				 
				 $("#detailContent").val(detailContent);
			}
			
		
			$.post("${path}/ccpInformationDetail/saveInformationDetail.do", $("#infoFrom").serialize(), function(result) {
               if (result == "success") {
                    dialogTypeSaveDraft("提示", "保存成功", function(){
                        window.location.href="${path}/ccpInformationDetail/ccpInformationDetailIndex.do?informationId="+informationId;
                    });
                }else if (result == "login") {
                	
                  	 dialogAlert('提示', '请先登录！', function () {
                  		window.location.href = "${path}/login.do";
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
	</script>
</head>
<style>
	div[name=aliFile] br,div[name=aliFile] p,div[name=aliFile] span，.progress{display:none!important;}
	#webupload1 div[name=aliFile] img:nth-child(1){position:relative!important;max-width:700px!important;max-height:700px!important;}
	#webupload2 div[name=aliFile] img:nth-child(1){position:relative!important;max-width:200px!important;max-height:300px!important;}
	#webupload1 div[name=aliFile]{width:700px!important;max-width:700px!important;}
	#webupload2 div[name=aliFile]{width:200px!important;max-width:200px!important;float:left;margin-right:20px;}
</style>
<body >
<form id="infoFrom" >
<input type="hidden" id="informationId" name="informationId" value="${info.informationId }"/>
    <input type="hidden" id="informationDetailId" name="informationDetailId" value="${info.informationDetailId }"/>
    <div class="site">
        <em>您现在所在的位置：</em>资讯列表 &gt;资讯详情管理&gt; 详情编辑
    </div>
    <div class="site-title">详情编辑</div>
    <div class="main-publish">
        <table width="100%" class="form-table">
         <tr> 	
         	<td class="td-title">描述：</td>
        <c:choose>
         	<c:when test="${informationSort==2 }">
         		
						 <td class="td-input">
		                    <div class="editor-box">
		                        <textarea rows="5" class="textareaBox"  maxlength="2000" style="width: 500px;resize: none" name="detailContent" id="detailContent" >${info.detailContent }</textarea>
		                    </div>
		                </td>
         	</c:when>
         	<c:otherwise>
         		
         		<td class="td-content">
	                <div class="editor-box">
	                    <textarea name="detailContent" id="detailContent">${info.detailContent }</textarea>
	                </div>
	            </td>
	            <script type="text/javascript">
				 var editor = CKEDITOR.replace('detailContent');
				    window.onload = function () {
				    	
				    }
				</script>
         		
         	</c:otherwise>
        </c:choose>
					</tr>
          
            <tr>
                <td width="100" class="td-title">图片：</td>    
                <td class="td-upload" >
                <table>
                    <tr>
                        <td>
                        	<div class="whyVedioInfoContent" style="margin-top:-10px;">
	                            <div class="whyUploadVedio" id="webupload2">
									<div style="width: 700px;">
										<div id="ossfile2">
										<c:choose>
											<c:when test="${!empty info.detailImage }">
											<c:forEach items="${fn:split(info.detailImage,',') }" var="detailImage">
												<div name="aliFile" style="position:relative" >
													<img src="${detailImage}" style="max-height: 130px;max-width: 130px;position: absolute;left: 0;right: 0;top: 0;bottom: 0;margin: auto;" />
													<img onclick="aliRemoveImg(this)" class="aliRemoveBtn" src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201733161236Bn6gTqiCZBHhgObFvsCkLFNzmIBoh2.png" style="position:absolute;right:0;top:0;width:20px" />
													<input type="hidden" id="detailImage" name="detailImage" value="${detailImage }"/>
												</div>
											</c:forEach>
											
											</c:when>
											<c:otherwise>
											
											</c:otherwise>
										</c:choose>
										</div>
										<div id="container2" style="clear:both;">
											<a id="selectfiles2" href="javascript:void(0);" class='btn'>选择文件</a>
											<pre style="font-size: 14px;color: #999;line-height: 25px;"><c:choose><c:when test="${informationSort==2 }">Tip：可上传1张图片，尺寸不小于750 × 600，格式为jpg、jpeg、png、gif，大小不超过2M</c:when><c:otherwise>Tip：可上传1张图片，格式为jpg、jpeg、png、gif，大小不超过2M</c:otherwise></c:choose></pre>
										</div>
										
									</div>
								</div>
							</div>
                        </td>
                    </tr>
                </table>
              </td>
            </tr>
            
            <c:if test="${informationSort==2 }">
            
                 <tr>
	                <td width="100" class="td-title">图片链接：</td>
	                <td class="td-input">
	                    <input type="text" 
	                           class="input-text w510" value="${info.detailImageLink  }" " id="detailImageLink" name="detailImageLink"/>
	                </td>
	            </tr>
            </c:if>
	        
            <tr>
                <td width="100" class="td-title"></td>
                <td class="td-btn">
                    <div class="room-order-info info2" style="position: relative;">
                    	<button type="button" class="btn-publish" onclick="javascript:history.go(-1);">取消</button>
                        <button type="button"  class="btn-save" onclick="saveInfo()">保存</button>
                    </div>
                </td>
            </tr>
        </table>
    </div>
</form>
</body>
</html>
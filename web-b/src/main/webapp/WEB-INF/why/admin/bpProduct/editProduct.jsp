<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>发布文化商城--文化云</title>

    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <%@ include file="/WEB-INF/why/common/limit.jsp" %>
    <%@include file="/WEB-INF/why/common/aliImageFrame.jsp"%>
    
    <!--文本编辑框 end-->
    <script type="text/javascript" src="${path}/STATIC/layer/layer.js"></script>
    <script type="text/javascript" src="${path}/STATIC/layer/extend/layer.ext.js"></script>
    <!-- dialog start -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    
    <link rel="stylesheet" href="${path}/STATIC/js/ossjs/style.css" type="text/css" />
    <script type="text/javascript" src="${path}/STATIC/js/ossjs/uuid.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/ossjs/crypto.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/ossjs/hmac.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/ossjs/sha1.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/ossjs/base64.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/ossjs/plupload.full.min.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/ossjs/upload-img.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/ossjs/upload-files.js"></script>
    <script type="text/javascript">
        window.onload = function () {
            var editor = CKEDITOR.replace('productRemark');
        }

        seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
            window.dialog = dialog;
        });

        window.console = window.console || {
                    log: function () {
                    }
                }
        $(function (){
        	//商品模块
        	$.post("${path}/sysdict/queryChildSysDictByDictCode.do", {
    			'dictCode' : 'PRODUCT_MODULE'
    		}, function(data) {
    			var list = data;
    			var dictHtml = '';
    			var typeVal = $("#productModule").val();
    			for (var i = 0; i < list.length; i++) {
    				var obj = list[i];
    				var dictId = obj.dictId;
    				var dictName = obj.dictName;
    				var result = false;
    				if (typeVal != '') {
    					if ($.trim(typeVal) == dictId) {
    						result = true;
    					}
    				}
    				var cl = 'class="tagType"';
    				if (result) {
    					cl = 'class="cur tagType"';
    				}
    				dictHtml += '<a id="' + dictId + '" ' + cl
    						+ ' onclick="setSingle(\'' + dictId
    						+ '\',\'productModule\')">' + dictName + '</a>';
    			}
    			$("#productModuleLabel").html(dictHtml);
    			tagSelectSingle("productModuleLabel");
    		}, 'json');
        });
        $(function () {
        	var showtype = $("#productShowtype").val();
        	  //展示形式单选
	          tagSelectSingle("showTypeLabel");            
	          //切换展示形式 
	          $(".showType").click(function(){
	        	  var typeValue;
	        	  if(this.id=="showPic"){
	        		  	typeValue='1';
	  	          		$("#showVideoType").attr("style","display:none");
	  	          		$("#showPicType").removeAttr("style");
	  	          	}
	  	          	if(this.id=="showVideo"){
	  	          		typeValue='2';
	  	          		$("#showPicType").attr("style","display:none");
	  	          		$("#showVideoType").removeAttr("style");
	  	          	}
	  	          setSingle(typeValue,"productShowtype");
	          });
	          if(showtype!=''){
	        	  if(showtype=='1'){
	        		  $("#showPic").click();  
	        	  }else{
	        		  $("#showVideo").click();
	        	  }
	        	  
	          }
	          
        });
        
        $(function () {
        	//上传封面
          	aliUploadImg('productIconUrlWebupload', getProductIconUrl, 1, true, 'BeiPiao');
        	//上传图片集
          	aliUploadImg('productImagesWebupload', getProductImages, 6, true, 'BeiPiao');
         	//上传视频
          	aliUploadFiles('productVideoWebupload', getProductVideo, 1, true, 'BeiPiao');
        });
        
      //封面图片回调    
        function getProductIconUrl(up, file, info) {
        	var filePath = "http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info;
    		$("#"+file.id).append("<input type='hidden' name='productIconUrl' value='"+filePath+"'/>"); 
		}
      //图片集回调    
        function getProductImages(up, file, info) {
        	var filePath = "http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info;
    		$("#"+file.id).append("<input type='hidden' name='productImages' value='"+filePath+"'/>"); 
		}
      //视频回调    
        function getProductVideo(up, file, info) {
        	var filePath = "http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info;
    		$("#"+file.id).append("<video controls style='width:220px;height:220px;' src='http://culturecloud.img-cn-hangzhou.aliyuncs.com/"
    	            + info+"'></video><input type='hidden' name='productVideo' value='"+filePath+"'/>"); 
    		//视频全名
  	      var video = $("[name='productVideo']").val();
  	      //视频后缀名开始的下标
  	      var point = video.lastIndexOf(".");
  	      //视频后缀
  	      var type = video.substr(point);
  	      if(type!=".mp4"){ 
  	        dialogAlert("提示", "请上传mp4格式的视频！");
  	        	$("[name='productVideo']").parent().remove();
  	        } 
		}
      
        /**
         * 单选
         * @param value
         * @param id
         */
        function setSingle(value,id){
            $("#"+id).val(value);
            $('#'+id).find('a').removeClass('cur');
        }
        /**
         * 单选
         * @param id
         */
        function tagSelectSingle(id) {
            /* tag标签选择 */

            $('#'+id).find('a').click(function() {
                $('#'+id).find('a').removeClass('cur');
                $(this).addClass('cur');
            });
        }

        /**
         * 校验
         */
         function checkValidation(){
         	$('#productRemark').val(CKEDITOR.instances.productRemark.getData());
             var productName=$('#productName').val();
             var productIconNum=$("[name='productIconUrl']").length;
             var productModule=$('#productModule').val();
             var productShowtype=$('#productShowtype').val();
             var productImagesNum=$("[name='productImages']").length;
             var productVideoNum=$("[name='productVideo']").length;
             var productInfo=$("#productInfo").val();
             var productRemark=CKEDITOR.instances.productRemark.getData();

             if($.trim(productName)){
             	removeMsg("productNameLabel");
                 if(productName.length>20){
                 	appendMsg("productNameLabel","商品名称只能输入20字以内!");
                     $('#productName').focus();
                     return false;
                 }
             }else{
             	removeMsg("productNameLabel");
             	appendMsg("productNameLabel","商品名称为必填项!");
                 $('#productName').focus();
                 return false;
             }   
             
             if(productIconNum>0){
 				removeMsg("productIconUrlLabel");
 			}else{
 				removeMsg("productIconUrlLabel");
 				appendMsg("productIconUrlLabel","封面必须上传!");
 				alert("封面必须上传!");
 	            return false;
 			}
             if($.trim(productModule)){
 				removeMsg("productModuleLabel");
 			}else{
 				removeMsg("productModuleLabel");
 				appendMsg("productModuleLabel","模块为必选项!");
 				$('#productModuleMessage').focus();
 	            return false;
 			}
             if($.trim(productShowtype)){
             	if($.trim(productShowtype)=='1'){
             		if(productImagesNum>0){
         				removeMsg("productImagesLabel");
                 		$("#showVideoType [name='aliFile']").remove();
         			}else{
         				removeMsg("productImagesLabel");
         				appendMsg("productImagesLabel","图片集必须上传!");
         				alert("图片集必须上传!");
         	            return false;
         			}
             	}else{
             		if(productVideoNum>0){
             			$("#showPicType [name='aliFile']").remove();
         				removeMsg("productVideoLabel");
         			}else{
         				removeMsg("productVideoLabel");
         				appendMsg("productVideoLabel","视频必须上传!");
         				alert("视频必须上传!");
         	            return false;
         			}
             	}
             	
             }
             
             if($.trim(productInfo)){
             	removeMsg("productInfoLabel");
             }else{
             	removeMsg("productInfoLabel");
             	appendMsg("productInfoLabel","简介为必填项!");
                 $('#productInfo').focus();
                 return false;
             }
             if($.trim(productRemark)){
             	removeMsg("productRemarkLabel");
             }else{
             	removeMsg("productRemarkLabel");
             	appendMsg("productRemarkLabel","详细描述为必填项!");
                 $('#productRemark').focus();
                 return false;
             }
             return true;
         }
        //修改按钮对应事件
        $(function () {
            $("#btnPublish").on("click", function () {
               if(checkValidation()){
            	   $.post("${path}/bpProduct/editProduct.do", $("#product_update_form").serialize(),
                           function(data) {
                               if (data!=null && data=='success') {
                                       var html = "<h2>修改成功</h2>";
                                       dialogSaveDraft("提示", html, function(){
                                    	   window.location.href = "${path}/bpProduct/productIndex.do";
                                       });
                                       
                               } else {
                                   var html = "<h2>修改失败,请联系管理员</h2>";
                                   dialogSaveDraft("提示", html, function(){

                                   });
                               }
                           });
               }
           	  
            });
        });
        
        seajs.config({
            alias: {
                "jquery": "jquery-1.10.2.js"
            }
        });

        seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
            window.dialog = dialog;
        });
        

    </script>
    <!-- dialog end -->
    <style>
	div[name=aliFile] br,div[name=aliFile] p,div[name=aliFile] span，.progress{display:none!important;}
	#productIconUrlWebupload div[name=aliFile] img:nth-child(1){position:relative!important;max-width:750px!important;max-height:500px!important;}
	#productIconUrlWebupload div[name=aliFile] img:nth-child(1){max-width:750px;max-height:500px;}
	#productIconUrlWebupload div[name=aliFile]{width:750px!important;max-width:500px!important;}
	#productImagesWebupload div[name=aliFile] img:nth-child(1){position:relative!important;max-width:560px!important;max-height:420px!important;}
	#productImagesWebupload div[name=aliFile] img:nth-child(1){max-width:560px;max-height:420px;}
	#productImagesWebupload div[name=aliFile]{width:560px!important;max-width:420px!important;}
</style>
</head>
<body>
<input type="hidden" id="sessionId" value="${pageContext.session.id}"/>

<div class="site">
    <em>您现在所在的位置：</em>文化商城 &gt; 编辑文化商城
</div>
<div class="site-title">编辑文化商城</div>
<form method="post" id="product_update_form" method="post">

    <%-- 基础路径 --%>
    <div class="main-publish">
        <table width="100%" class="form-table">
         <input type="hidden" id="productId" name="productId" value="${record.productId}"/>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>商品名称：</td>
                <td class="td-input" id="productNameLabel">
                    <input id="productName" name="productName" type="text" class="input-text w510" maxlength="20" value='<c:out value="${record.productName}" escapeXml="true"/>'/>
                    <span class="error-msg"></span>
                </td>
            </tr>
          
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>封面：</td>
                <td id="productIconUrlLabel" class="td-upload">
                <table>
	                    <tr>
	                        <td>
	                        	<div class="whyVedioInfoContent" style="margin-top:-10px;">
									<div class="whyUploadVedio" id="productIconUrlWebupload">
										<div style="width: 700px;">
										<div id="ossfile2">
											<c:choose>
												<c:when test="${!empty record.productIconUrl}">
													<div name="aliFile" style="position: relative; margin-bottom: 5px; margin-right: 15px; max-width: 130px; display: inline-block;" >
														<img src="${record.productIconUrl}" style="max-height: 130px;max-width: 130px;position: absolute;left: 0;right: 0;top: 0;bottom: 0;margin: auto;" />
														<br />
														<img onclick="aliRemoveImg(this)" class=" 	" src="../STATIC/image/removeBtn.png" style="position:absolute;right:0;top:0;width:20px" />
														<input type="hidden" value="${record.productIconUrl}" name="productIconUrl" id="productIconUrl"/>
													</div>
												</c:when>
												<c:otherwise>
												</c:otherwise>
											</c:choose>
										</div>
											<div id="container2" style="clear: both;">
												<a id="selectfiles2" class="selectFiles btn">选择封面</a>
											</div>
											 	
										</div>
										<span class="upload-tip">可上传1张图片,建议尺寸750*500像素，格式为jpg,jpeg,png,gif，建议大小不超过2M</span>
									</div>
								</div>
	                        </td>
	                    </tr>
	                </table>
	                
					</td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>模块：
                    <input id="productModuleMessage" style="position: absolute; left: -9999px;"/>
                </td>
                <td class="td-tag">
                    <dl>
                        <input id="productModule" name="productModule" type="hidden" value="${record.productModule}"/>
                        <dd id="productModuleLabel">
                        </dd>
                    </dl>
                </td>
	        </tr>
            <tr>
                <td width="100" class="td-title">联系人：</td>
                <td class="td-input" id="productContactmanLabel">
                    <input id="productContactman" name="productContactman" type="text" class="input-text w260" maxlength="20" value="${record.productContactman}"/>
                    <span class="error-msg"></span>
                </td>
            </tr>         
            
             <tr>
                <td width="100" class="td-title">联系方式：</td>
                <td class="td-input" id="productContactWayLabel">
                    <input id="productContactway" name="productContactway" type="text" class="input-text w260" maxlength="20" value="${record.productContactway}"/>
                    <span class="error-msg"></span>
                </td>
            </tr> 
            
             <tr>
                <td width="100" class="td-title"><span class="red">*</span>展示形式：</td>
                <td class="td-tag">
                <input id="productShowtype" name="productShowtype" type="hidden" value="${record.productShowtype}" />
                    <dl>
                        <dd id="showTypeLabel">
                        	<a id="showPic" class="showType" style="width: 50px; text-align: center">图片</a>
                        	<a id="showVideo" class="showType" style="width: 50px; text-align: center">视频</a>
                        </dd>
                    </dl>
                </td>
            </tr>
            
            <tr id="showPicType">
                <td width="100" class="td-title"><span class="red">*</span>图片集：</td>
                <td id="productImagesLabel" class="td-upload">
                <div class="whyVedioInfoContent" style="margin-top: -10px;">
						<div class="whyUploadVedio" id="productImagesWebupload">
							<div style="width: 700px;">
							<div id="ossfile2">
								<c:choose>
										<c:when test="${!empty record.productImages}">
										
										<c:set value="${ fn:split(record.productImages,',')}"  var="images"></c:set>
											<c:forEach items="${images}" var="image">
												<div name="aliFile" style="position: relative; margin-bottom: 5px; margin-right: 15px; max-width: 130px; display: inline-block;" >
													<img src="${image}" style="max-height: 130px;max-width: 130px;position: absolute;left: 0;right: 0;top: 0;bottom: 0;margin: auto;" />
													<br />
													<img onclick="aliRemoveImg(this)" class=" 	" src="../STATIC/image/removeBtn.png" style="position:absolute;right:0;top:0;width:20px" />
													<input type="hidden" value="${image}" name="productImages" id="productImages"/>
												</div>
											</c:forEach>
										</c:when>
										<c:otherwise>
										</c:otherwise>
									</c:choose>
							</div>
								<div id="container2" style="clear: both;">
									<a id="selectfiles2" class="selectFiles btn">上传图片</a>
								</div>
								 	
							</div>
							<span class="upload-tip">最多上传6张图片,建议尺寸560*420像素，格式为jpg,jpeg,png,gif，建议大小不超过2M</span>
						</div>
						</div>
					</td>
            </tr>
            
            <tr id="showVideoType" style="display: none">
                <td width="100" class="td-title"><span class="red">*</span>视频：</td>
                <td id="productVideoLabel" class="td-upload">
						<div class="whyUploadVedio" id="productVideoWebupload">
							<div style="width: 240px;">
							<div id="ossfile2">
								<c:choose>
										<c:when test="${!empty record.productVideo}">
												<div name="aliFile" style="position:relative;width:220px;height:130px;" >
													<video src="${record.productVideo}" controls="controls" style="width:200px;height:200px;position: absolute;left: 0;top: 0;bottom: 0;margin: auto;"></video>
													<br />
													<img onclick="aliRemoveFiles(this)" class=" " src="../STATIC/image/removeBtn.png" style="position:absolute;right:0;top:0;width:20px" />		
													<input type="hidden" value="${record.productVideo}" name="productVideo" id="productVideo"/>
												</div>
										</c:when>
										<c:otherwise>
										</c:otherwise>
									</c:choose>
							</div><br/>
								<div id="container2" style="clear: both;">
									<a id="selectfiles2" class="selectFiles btn">上传视频</a>
								</div>
								 
							</div>
							<span class="upload-tip">仅支持MP4格式</span>	
						</div>
					</td>
            </tr>
            
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>简介：</td>
                <td class="td-input" id="productInfoLabel">
                     <textarea name="productInfo" id="productInfo" rows="4" class="textareaBox"  maxlength="300" style="width: 500px;resize: none">${record.productInfo}</textarea>
                </td>
            </tr>
            
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>详情描述：</td>
                <td class="td-content" id="productRemarkLabel">
                    <div class="editor-box">
                        <textarea name="productRemark" id="productRemark">${record.productRemark}</textarea>
                    </div>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"></td>
                <td class="td-btn">
                	<input id="btnPublish" class="btn-publish" type="button" value="修改信息"/>             	
                </td>
                <!-- <td class="td-btn">
                	<input id="test" class="test" type="button" value="测试"/>             	
                </td> -->
            </tr>
        </table>
    </div>
</form>

</body>
</html>
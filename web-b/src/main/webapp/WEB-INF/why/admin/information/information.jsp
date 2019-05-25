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
    
        <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    
    <script type="text/javascript" src="${path}/STATIC/js/admin/information/UploadInformationImg.js"></script>
      
      
    <script type="text/javascript">
    
    window.onload = function () {
    	var editor = CKEDITOR.replace('informationContent');
    }
    
  	//上传图片回调函数
    function uploadImgCallback1(up, file, info) {
    	//$('#'+file.id).append("<input type='hidden' id='jiazhouInfoIconUrl' value='http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info+"'/>");
  	 	var filePath = "http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info;
    	
    	$("#"+file.id).append("<input type='hidden' id='informationIconUrl' name='informationIconUrl' value='"+filePath+"'/>");
  	}
  	
  	function uploadImgCallback2(up, file, info) {
  		var filePath = "http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info;
    	$("#"+file.id).append("<input type='hidden' name='bigImageUrl' value='"+filePath+"'/>");
  	}
  	
	//视频缩略图回调
    function getvideoIconUrl(up, file, info) {
        var filePath = "http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info;
        $("#"+file.id).find("span").html('<img src="'+filePath+'" style="\n' +
            '            width: 120px;\n' +
            '            height: 100px;\n' +
            '            ">')

        $("#"+file.id).append("<input type='hidden' id='videoIconUrl' name='videoIconUrl' value='"+filePath+"'/>");
	}
  
  	//视频地址回调
    function getvideoUrl(up, file, info) {
    	var filePath = "http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info;
    	$("#"+file.id).append("<input type='hidden' id='videoUrl' name='videoUrl' value='"+filePath+"'/>");
    	$("#"+file.id).prepend("<video src='"+filePath+"' style='width:260px;' controls/>");
	}

    $(function () { 
    	
    	var informationSort = '${info.informationSort}'
    	
    	var informationType= '${info.informationType}'

        var informationModuleId= '${informationModuleId}'

        var informationCreateUser= '${info.informationCreateUser}'
    	
    	//加载分类
    	$.post("${path}/ccpInformationType/queryAllInformationType.do",{informationModuleId:informationModuleId,informationCreateUser:informationCreateUser},function(data){
    		
    		$("#informationType").append("<option value=''>请选择</option>")
    		
    		$.each(data,function(i,dom){
    			
    			if(informationType==dom.informationTypeId){
    				$("#informationType").append("<option selected value='"+dom.informationTypeId+"'>"+dom.typeName+"</option>")
    			}
    			else
    			
    				$("#informationType").append("<option value='"+dom.informationTypeId+"'>"+dom.typeName+"</option>")
    		})
    	})
    	
    	$(":radio").click(function(){
    		   
    		   typeChange($(this).val())
    		   
    		 
    	 });
    	
    	if(informationSort){
    		
            var array=["图文版","大图版","视频版","直播或回放","列表跳转"];
            
            var i=parseInt(informationSort);
            
    		 $("#informationSortTD").html(array[i-1]) 
    		
    		typeChange(informationSort);
    	}
    	
    	aliUploadFiles('videoUrWebupload', getvideoUrl, 1, true, 'video');
    	aliUploadFiles('videoIconUrlWebupload', getvideoIconUrl, 1, true, 'H5');
    });
    
    function typeChange(value){
    	
    	$(".informationSortDiv").hide();
    	$(".informationSortDiv[value='"+value+"']").show()
    }
    
    function saveInfo(){
    	
    	var informationTitle =$("#informationTitle").val();
    	
			if (!informationTitle) {
				dialogAlert("提示", "请填写标题");
				return
			}
			
		var informationIconUrl=$("#informationIconUrl").val();
			if (!informationIconUrl) {
				dialogAlert("提示", "请上传资讯封面");
				return
			}
			
		var authorName = $("#authorName").val();
		
			if (!authorName) {
				dialogAlert("提示", "请填写作者");
				return
			}
			
		var publisherName=$("#publisherName").val();
		
			if (!publisherName) {
				dialogAlert("提示", "请填写来源");
				return
			}
			
			var informationType=$("#informationType").val();
			
			if (!informationType) {
				dialogAlert("提示", "请选择资讯类型");
				return
			}
			
			$('#informationContent').val(CKEDITOR.instances.informationContent.getData());
			
			var videoIconUrl=$("#videoIconUrl").val();
			
			if(!videoIconUrl){
				$("#infoFrom").append('<input type="hidden" id="videoIconUrl" name="videoIconUrl" value=""/>')
			}
			
			var videoUrl=$("#videoUrl").val();
			
			if(!videoUrl){
				$("#infoFrom").append('<input type="hidden" id="videoUrl" name="videoUrl" value=""/>')
			}
            var informationModuleId = $("#informationModuleId").val();
			$.post("${path}/ccpInformation/saveInformation.do", $("#infoFrom").serialize(), function(result) {
               if (result == "success") {
                    dialogTypeSaveDraft("提示", "保存成功", function(){
                        window.location.href="${path}/ccpInformation/informationIndex.do?informationModuleId="+informationModuleId;
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
<style>
	div[name=aliFile] br,div[name=aliFile] p,div[name=aliFile] span，.progress{display:none!important;}
	#webupload1 div[name=aliFile] img:nth-child(1){position:relative!important;max-width:700px!important;max-height:700px!important;}
	#webupload2 div[name=aliFile] img:nth-child(1){position:relative!important;max-width:200px!important;max-height:300px!important;}
	#webupload1 div[name=aliFile]{width:700px!important;max-width:700px!important;}
	#webupload2 div[name=aliFile]{width:200px!important;max-width:200px!important;float:left;margin-right:20px;}
	#videoIconUrlWebupload div[name=aliFile] {width:130px;}
	#videoIconUrlWebupload div[name=aliFile] img:nth-child(1){position:relative!important;}
</style>
<body >
 <input type="hidden" id="userCounty" value="${sessionScope.user.userCounty}" />
<form id="infoFrom" >
    <input type="hidden" id="informationModuleId" name="informationModuleId" value="${informationModuleId}"/>
    <input type="hidden" id="informationId" name="informationId" value="${info.informationId }"/>
    <input type="hidden" id="isCutImg" value="N"/>
    <div class="site">
        <em>您现在所在的位置：</em>${infoModule.informationModuleName}列表 &gt; ${infoModule.informationModuleName}<c:choose><c:when test="${not empty info.informationId}">编辑</c:when><c:otherwise>新增</c:otherwise></c:choose>
    </div>
    <div class="site-title">${infoModule.informationModuleName}<c:choose><c:when test="${not empty info.informationId}">编辑</c:when><c:otherwise>新增</c:otherwise></c:choose></div>
    <div class="main-publish">
        <table width="100%" class="form-table">
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>标题：</td>
                <td placeholder="标题" class="td-input">
                    <input type="text" placeholder="标题最多输入24个字" 
                           class="input-text w510" value="${info.informationTitle }" maxlength="24" id="informationTitle" name="informationTitle"/>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>资讯封面：</td>    
                <td class="td-upload" >
                <table>
                    <tr>
                        <td>
                        	<div class="whyVedioInfoContent" style="margin-top:-10px;">
                        	 
	                            <input type="hidden" name="uploadType" value="Img" id="uploadType"/>
                        	  <input type="hidden"  name="informationIconUrl" id="informationIconUrl" value="${info.informationIconUrl }">
                        		 <div class="img-box">
                                <div  id="imgHeadPrev" class="img"> </div>
                            </div>
                            <div class="controls-box">
                                <div style="height: 46px;">
                                    <div class="controls" style="float:left;">
                                        <input type="file" name="file" id="file">
                                    </div>
                                    <%--<input type="button" class="upload-cut-btn" id="" value="裁剪图片"/>--%>
                                    <span class="upload-tip">可上传1张图片，建议尺寸730*375像素，格式为jpg,jpeg,png,gif，大小不超过2M</span>
                                </div>
                                <div id="fileContainer"></div>
                                <div id="btnContainer" style="display: none;">
                                    <a style="margin-left:335px;" href="javascript:clearQueue();" class="btn">取消</a>
                                </div>
                            </div>
							</div>
                        </td>
                    </tr>
                </table>
              </td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>作者：</td>
                <td placeholder="作者" class="td-input">
                    <input type="text" placeholder="作者最多输入32个字" id="authorName" name="authorName" value="${info.authorName }" class="input-text w510"
                           maxlength="32"/>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>来源：</td>
                <td placeholder="来源" class="td-input">
                    <input type="text" placeholder="来源最多输入32个字" id="publisherName" name="publisherName"
                    
                    value="${info.publisherName }"
                           class="input-text w510" maxlength="32"/>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>简介：</td>
                <td placeholder="简介" class="td-input">
                    <input type="text" placeholder="简介最多输入200个字" id="brief" name="brief"

                           value="${info.brief }"
                           class="input-text w510" maxlength="200"/>
                </td>
            </tr>
            <tr>
               <td width="100" class="td-title"><span class="red">*</span>资讯类型：</td>
                <td placeholder="资讯类型" class="td-select" >
				  <select id="informationType" name="informationType" class="ng-select-box" >
				  
				  </select>
                </td> 
            </tr>  
              <tr>
               <td width="100" class="td-title">标签：</td>
                <td placeholder="标签" class="td-input">
                    <input name="informationTags"  type="text" value="${fn:split(info.informationTags, ",")[0]}" class="input-text w110"/>
                    <input name="informationTags" type="text" value="${fn:split(info.informationTags, ",")[1]}"  class="input-text w110"/>
                    <input name="informationTags" type="text" value="${fn:split(info.informationTags, ",")[2]}"  class="input-text w110"/>
                </td>
            </tr>      
            
             <tr>
	             <td width="100" class="td-title"><span class="red">*</span>分类：</td>
	                <td class="td-input td-fees" id="informationSortTD">
	                    <label><input type="radio"  name="informationSort" checked="checked" value="1"/><em>图文版</em></label>
	                    <label><input type="radio"  name="informationSort" value="2"/><em>大图版</em></label>
	                    <label><input type="radio"  name="informationSort" value="3"/><em>视频版</em></label>
                        <label><input type="radio"  name="informationSort" value="4"/><em>直播或回放</em></label>
                        <label><input type="radio"  name="informationSort" value="5"/><em>列表跳转</em></label>
	             </td>
	        </tr>
            <tr class="informationSortDiv" value="5" style="display: none;">
                <td width="100" class="td-title">跳转地址：</td>
                <td class="td-input" id="toOtherUrl"><input type="text" name="toOtherUrl" value="${info.toOtherUrl }" class="input-text w510" maxlength="200"/></td>
            </tr>
	        <tr class="informationSortDiv" value="3" style="display: none;">
	          <td width="100" class="td-title">上传视频：</td>    
                <td class="td-upload" >
	        	  <table width="100%" class="form-table assnResVideos">
			        <tr>
		                <td width="100" class="td-title">视频名称：</td>
		                <td class="td-input" id="videoTitleLabel"><input type="text" name="videoTitle" value="${info.videoTitle }" class="input-text w510" maxlength="30"/></td>
		            </tr>
			        <tr>
						<td class="td-title">视频缩略图：</td>
						<td>
							<div class="whyUploadVedio videoIconUrlDiv" id="videoIconUrlWebupload">
								<div class="clearfix">
									<div id="container2" style="float: left;overflow: hidden;margin: 10px 10px 10px 0;">
										<a id="selectfiles2" class="selectFiles btn">选择文件</a>
									</div>
									
									<div id="ossfile2" style="width: 200px;float: left;" class="clearfix"><c:if test="${!empty info.videoIconUrl }">
										<div name="aliFile" style="position:relative" >
											<img style="max-height: 130px;max-width: 130px;position: absolute;left: 0;right: 0;top: 0;bottom: 0;margin: auto;" src="${info.videoIconUrl }">
											<br>
											<img class="aliRemoveBtn" onclick="aliRemoveImg(this)"  src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201733161236Bn6gTqiCZBHhgObFvsCkLFNzmIBoh2.png" style="position:absolute;right:0;top:0;width:20px">
												<input type="hidden" id="videoIconUrl" name="videoIconUrl" value="${ info.videoIconUrl }">
										</div>
									</c:if>你的浏览器不支持flash,Silverlight或者HTML5！</div>
								</div>
							</div>
						</td>
					</tr>
					<tr>
						<td class="td-title">上传视频：</td>
						<td>
							<div class="whyUploadVedio videoUrlDiv" id="videoUrWebupload">
								<div class="clearfix">
									<div id="container2" style="float: left;overflow: hidden;margin: 10px 10px 10px 0;">
										<a id="selectfiles2" class="selectFiles btn">选择文件</a>
									</div>
									<div id="ossfile2" style="width: 300px;float: left;" class="clearfix">
									<c:if test="${!empty info.videoUrl }">
									<div name="aliFile" style="position:relative" id=""><video src="${ info.videoUrl }" style="width:260px;" controls=""></video><img class="aliRemoveBtn" onclick="aliRemoveImg(this)"  src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201733161236Bn6gTqiCZBHhgObFvsCkLFNzmIBoh2.png" style="position:absolute;right:0px;top:0;width:20px"><input type="hidden" name="videoUrl" value="${ info.videoUrl }"></div>
									</c:if>
									你的浏览器不支持flash,Silverlight或者HTML5！</div>
								</div>
							</div>
						</td>
					</tr>
					<tr>
						<td class="td-title">视频描述：</td>
						 <td class="td-content">
		                    <div class="editor-box">
		                        <textarea name="informationContent" id="informationContent" >${info.informationContent }</textarea>
		                    </div>
		                </td>
					</tr>
		        </table>
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
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>

<head>
    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/aliImageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>

    <script type="text/javascript">
    	$.ajaxSettings.async = false; 	//同步执行ajax
    	var videosNum = 0;
    	
		var userId = '${sessionScope.user.userId}';
		
		if (userId == null || userId == '') {
			location.href = '${path}/admin.do';
		}
    
        $(function () {
          	aliUploadImg('assnImgUrlWebupload', getAssnImgUrl, 1, true, 'H5');
          	aliUploadImg('assnIconUrlWebupload', getAssnIconUrl, 1, true, 'H5');
          	aliUploadImg('assnResImgUrlsWebupload', getAssnResImgUrls, 100, true, 'H5');
        
        });
        
      	//封面图回调
        function getAssnImgUrl(up, file, info) {
        	var filePath = "http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info;
        	$("#"+file.id).append("<input type='hidden' name='assnImgUrl' value='"+filePath+"'/>");
		}
      	
      	//头像图回调
        function getAssnIconUrl(up, file, info) {
        	var filePath = "http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info;
        	$("#"+file.id).append("<input type='hidden' name='assnIconUrl' value='"+filePath+"'/>");
		}
      	
      	//社团相册回调
        function getAssnResImgUrls(up, file, info) {
        	var filePath = "http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info;
        	$("#"+file.id).append("<input type='hidden' name='assnResImgUrls' value='"+filePath+"'/>");
		}
      	
      	//视频缩略图回调
        function getAssnResVideoCovers(up, file, info) {
        	var filePath = "http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info;
        	$("#"+file.id).append("<input type='hidden' name='assnResVideoCovers' value='"+filePath+"'/>");
		}
      
      	//视频地址回调
        function getAssnResVideoUrls(up, file, info) {
        	var filePath = "http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info;
        	$("#"+file.id).append("<input type='hidden' name='assnResVideoUrls' value='"+filePath+"'/>");
        	$("#"+file.id).prepend("<video src='"+filePath+"' style='width:260px;' controls/>");
		}
      	
        //添加视频
        function addVideos(){
        	videosNum += 1;
        	$("#assnResVideos").append("<table width='100%' class='form-table assnResVideos'>" +
								        	"<tr><td class='assnResVideosTitle'><img src='${path}/STATIC/image/remove.png' width='30' height='30' onclick='removeVideos($(this));'>视频"+videosNum+"：</td><td><div class='assnVideo' onclick='setMainVideo($(this))'>设为主视频</div></td></tr>" +
									        "<tr>" +
								                "<td width='100' class='td-title'>视频名称：</td>" +
								                "<td class='td-input' id='assnResVideoNamesLabel'><input type='text' name='assnResVideoNames' class='input-text w510' maxlength='30'/></td>" +
								            "</tr>" +
									        "<tr>" +
												"<td class='td-title'>视频缩略图<span style='color:red'>(360*230)</span>：</td>" +
												"<td>" +
													"<div class='whyUploadVedio assnResVideoCoversDiv' id='assnResVideoCover"+videosNum+"Webupload'>" +
														"<div class='clearfix'>" +
															"<div id='container2' style='float: left;overflow: hidden;margin: 10px 10px 10px 0;'>" +
																"<a id='selectfiles2' class='selectFiles btn'>选择文件</a>" +
															"</div>" +
															"<div id='ossfile2' style='width: 200px;float: left;' class='clearfix'>你的浏览器不支持flash,Silverlight或者HTML5！</div>" +
														"</div>" +
													"</div>" +
												"</td>" +
											"</tr>" +
									        "<tr>" +
												"<td class='td-title'>上传视频：</td>" +
												"<td>" +
													"<div class='whyUploadVedio assnResVideoUrlsDiv' id='assnResVideoUrl"+videosNum+"Webupload'>" +
														"<div class='clearfix'>" +
															"<div id='container2' style='float: left;overflow: hidden;margin: 10px 10px 10px 0;'>" +
																"<a id='selectfiles2' class='selectFiles btn'>选择文件</a>" +
															"</div>" +
															"<div id='ossfile2' style='width: 300px;float: left;' class='clearfix'>你的浏览器不支持flash,Silverlight或者HTML5！</div>" +
														"</div>" +
													"</div>" +
												"</td>" +
											"</tr>" +
								        "</table>");
        	
        	aliUploadImg('assnResVideoCover'+videosNum+'Webupload', getAssnResVideoCovers, 1, true, 'H5');
        	aliUploadFiles('assnResVideoUrl'+videosNum+'Webupload', getAssnResVideoUrls, 1, true, 'H5');
        	
        }
        
        //删除视频
        function removeVideos($this){
        	if(videosNum > 0){
        		videosNum -= 1;
        		$this.parents("table").remove();
        	}
        }
    	
    	function saveAssn(){
    		if (userId == null || userId == '') {
    			dialogAlert('系统提示', '登录超时',function(){
    				location.href = '${path}/user/sysUserLoginOut.do'
    			});
                return;
            }
    		
    		$("#saveBut").attr("onclick","");
    		var assnName=$('#assnName').val();
            var assnTag=$('#assnTag1').val()+$('#assnTag2').val()+$('#assnTag3').val();
    		var assnIntroduce=$('#assnIntroduce').val();
    		var assnContent=$('#assnContent').val();
    		var assnImgUrl=$('input[name=assnImgUrl]').val();
    		var assnIconUrl=$('input[name=assnIconUrl]').val();
    		var assnMember=$('#assnMember').val();
    		var assnFansInit=$('#assnFansInit').val();
    		var assnFlowerInit=$('#assnFlowerInit').val();
    		var shareTitle=$('#shareTitle').val();
    		var shareDesc=$('#shareDesc').val();
    		
    		if(!checkInfo(assnName,"assnName","社团名称为必填项！")) return;
    		if(!checkInfo(assnTag,"assnTag","社团标签为必填项！")) return;
    		if(!checkInfo(assnIntroduce,"assnIntroduce","社团简介为必填项！")) return;
    		if(!checkInfo(assnContent,"assnContent","详细介绍为必填项！")) return;
    		if(!checkInfo(assnImgUrl,"assnImgUrl","封面图为必填项！")) return;
    		if(!checkInfo(assnIconUrl,"assnIconUrl","头像为必填项！")) return;
    		if(!checkInfo(assnMember,"assnMember","成员数为必填项！")) return;
    		if(!checkInfo(assnFansInit,"assnFansInit","初始粉丝数为必填项！")) return;
    		if(!checkInfo(assnFlowerInit,"assnFlowerInit","初始浇花数为必填项！")) return;
    		if(!checkInfo(shareTitle,"shareTitle","分享标题为必填项！")) return;
    		if(!checkInfo(shareDesc,"shareDesc","分享描述为必填项！")) return;
    		
    		//设为主视频
    		if($(".assnVideoBlue")){
    			$("#assnVideoUrl").val($(".assnVideoBlue").parents(".assnResVideos").find("input[name=assnResVideoUrls]").val());
        		$("#assnVideoName").val($(".assnVideoBlue").parents(".assnResVideos").find("input[name=assnResVideoNames]").val());
    		}else{
    			$("#assnVideoUrl").val('');
        		$("#assnVideoName").val('');
    		}
    		
    		//防止视频信息没填，补足input
    		$(".assnResVideoCoversDiv").each(function(){
    			if($(this).find("#ossfile2").html() == ""){
    				$(this).find("#ossfile2").html("<input class='lsInput' type='hidden' name='assnResVideoCovers' />")
    			}else{
    				$(this).find("#ossfile2 .lsInput").remove();
    			}
    		})
    		$(".assnResVideoUrlsDiv").each(function(){
    			if($(this).find("#ossfile2").html() == ""){
    				$(this).find("#ossfile2").html("<input class='lsInput' type='hidden' name='assnResVideoUrls' />")
    			}else{
    				$(this).find("#ossfile2 .lsInput").remove();
    			}
    		})
    		
    	  	//保存活动信息
    	    $.post("${path}/association/saveOrUpdateAssn.do", $("#assnForm").serialize(),function(data) {
   	            if(data == "200") {
   	                dialogAlert('系统提示', "保存成功!",function (r){
   	                	window.location.href="${path}/association/assnIndex.do";
   	                });
   	            }else{
   	                dialogAlert('系统提示', '保存失败');
   	                $("#saveBut").attr("onclick","saveAssn();");
   	            }
   	     	},"json");
    	}

    	//信息必填验证
        function checkInfo(param,paramName,warn){
        	if(!param){
    	        removeMsg(paramName+"Label");
    	        $("#saveBut").attr("onclick","saveAssn();");
    	        appendMsg(paramName+"Label",warn);
    	        $('#'+paramName).focus();
    	        return false;
    	    }else{
    	        removeMsg(paramName+"Label");
    	        return true;
    	    }
        }
    	
    	function setMainVideo($this){
    		if($this.hasClass("assnVideoBlue")) {
				$(".assnVideo").removeClass("assnVideoBlue")
			} else {
				$(".assnVideo").removeClass("assnVideoBlue")
				$this.addClass("assnVideoBlue")
			}
    	}
    	
    	//删除图片
    	function removeImg($this){
    		$this.parent("div[name=aliFile]").remove();
    	}
    </script>
    
    <style type="text/css">
		li {
			margin-top: 20px;
			width: 100px;
			height: 100px;
			float: left;
			margin-right: 20px;
			position: relative;
		}
		li .ct-img-img {
			width: 155px;
			height: 100px;
		}
		li .ct-img-remove {
			cursor: pointer;
			position: absolute;
			right: 0px;
			top: 0px;
			width: 30px;
			height: 30px;
		}
		li:nth-last-child(2) {
			margin-right: 0;
		}
		.assnTitle{
			font-weight: bolder;
			font-size: 18px;
			line-height: 30px;
			background-color: #d9d9d9;
			padding-left: 10px;
		}
		.assnResVideosTitle{
			font-weight: bold;
			font-size: 14px;
			line-height: 30px;
		}
		.assnResVideosTitle>img{
			margin-right: 10px;
		}
		div[name = aliFile] img:nth-child(1){
			position: relative!important;
		}
		.assnVideo {
			background: #f3f3f3;
			display: inline-block;
			outline: none;
			cursor: pointer;
			text-align: center;
			text-decoration: none;
			font: 16px/100% 'Microsoft yahei', Arial, Helvetica, sans-serif;
			padding: .5em 2em .55em;
			text-shadow: 0 1px 1px rgba(0, 0, 0, .3);
			-webkit-border-radius: .5em;
			-moz-border-radius: .5em;
			border-radius: .5em;
			-webkit-box-shadow: 0 1px 2px rgba(0, 0, 0, .2);
			-moz-box-shadow: 0 1px 2px rgba(0, 0, 0, .2);
			box-shadow: 0 1px 2px rgba(0, 0, 0, .2);
		}
		.assnVideoBlue {
			background: #337ab7!important;
			color: #fff!important;
		}
	</style>
</head>

<body>
	<form id="assnForm" method="post">
		<input type="hidden" name="assnId" value="${assn.assnId}"/>
		<input type="hidden" id="assnVideoUrl" name="assnVideoUrl" value="${assn.assnVideoUrl}"/>
		<input type="hidden" id="assnVideoName" name="assnVideoName" value="${assn.assnVideoName}"/>
	    <div class="site">
	        <em>您现在所在的位置：</em>社团管理 &gt;社团编辑
	    </div>
	    <div class="site-title">编辑社团</div>
	    <div class="main-publish">
	    	<div class="assnTitle">社团信息：</div>
	        <table width="100%" class="form-table">
		        <tr>
	                <td width="100" class="td-title"><span class="red">*</span>社团名称：</td>
	                <td class="td-input" id="assnNameLabel"><input type="text" id="assnName" name="assnName" class="input-text w510" maxlength="15" value="${assn.assnName}"/></td>
	            </tr>
				<tr>
					<td width="100" class="td-title"><span class="red">*</span>社团标签：</td>
					<td class="td-input" id="assnTagLabel">
						<input type="text" id="assnTag1" name="assnTag" class="input-text w120" maxlength="4" value="${assn.assnTag.split(',')[0]}"/>
						<input type="text" id="assnTag2" name="assnTag" class="input-text w120" maxlength="4" value="${assn.assnTag.split(',')[1]}"/>
						<input type="text" id="assnTag3" name="assnTag" class="input-text w120" maxlength="4" value="${assn.assnTag.split(',')[2]}"/>
						<span style="color:#596988">（最多3个，每个不超过4个字）</span></td>
				</tr>
	            <tr>
	                <td width="100" class="td-title"><span class="red">*</span>社团简介：</td>
	                <td class="td-input" id="assnIntroduceLabel"><input type="text" id="assnIntroduce" name="assnIntroduce" class="input-text w510" maxlength="50" value="${assn.assnIntroduce}"/></td>
	            </tr>
	            <tr>
		        	<td width="100" class="td-title"><span class="red">*</span>详细介绍：</td>
					<td class="td-input">
	                    <div class="editor-box">
	                        <textarea id="assnContent" name="assnContent" rows="5" class="textareaBox"  maxlength="1000" style="width: 500px;resize: none">${assn.assnContent}</textarea>
	                        <span style="color:#596988" id="assnContentLabel">（0~1000个字以内）</span>
	                    </div>
	                </td>
				</tr>
		        <tr>
					<td class="td-title"><span class="red">*</span>上传封面图<span style="color:red">(750*420)</span>：</td>
					<td id="assnImgUrlLabel">
						<div class="whyUploadVedio" id="assnImgUrlWebupload">
							<div class="clearfix">
								<div id="container2" style="float: left;overflow: hidden;margin: 10px 10px 10px 0;">
									<a id="selectfiles2" class="selectFiles btn">选择文件</a>
								</div>
								<div id="ossfile2" style="width: 200px;float: left;" class="clearfix">
									<div name="aliFile" style="position: relative;">
										<img class="aliFileImg" src="${assn.assnImgUrl}" style="max-height: 130px;max-width: 130px;position: absolute;left: 0;right: 0;top: 0;bottom: 0;margin: auto;">
										<input type="hidden" name="assnImgUrl" value="${assn.assnImgUrl}">
										<img class="aliRemoveBtn" src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201733161236Bn6gTqiCZBHhgObFvsCkLFNzmIBoh2.png" style="position:absolute;right:0;top:0;width:20px" onclick="removeImg($(this));"/>
									</div>
								</div>
							</div>
						</div>
					</td>
				</tr>
				<tr>
					<td class="td-title"><span class="red">*</span>上传头像<span style='color:red'>(180*180)</span>：</td>
					<td id="assnIconUrlLabel">
						<div class="whyUploadVedio" id="assnIconUrlWebupload">
							<div class="clearfix">
								<div id="container2" style="float: left;overflow: hidden;margin: 10px 10px 10px 0;">
									<a id="selectfiles2" class="selectFiles btn">选择文件</a>
								</div>
								<div id="ossfile2" style="width: 200px;float: left;" class="clearfix">
									<div name="aliFile" style="position: relative;">
										<img class="aliFileImg" src="${assn.assnIconUrl}" style="max-height: 130px;max-width: 130px;position: absolute;left: 0;right: 0;top: 0;bottom: 0;margin: auto;">
										<input type="hidden" name="assnIconUrl" value="${assn.assnIconUrl}">
										<img class="aliRemoveBtn" src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201733161236Bn6gTqiCZBHhgObFvsCkLFNzmIBoh2.png" style="position:absolute;right:0;top:0;width:20px" onclick="removeImg($(this));"/>
									</div>
								</div>
							</div>
						</div>
					</td>
				</tr>
			</table>	
			
			<div class="assnTitle">社团相册：</div>
			<table width="100%" class="form-table">
				<tr>
					<td width="100" class="td-title"><span style='color:red'>(750*420)</span></td>
					<td>
						<div class="whyUploadVedio" id="assnResImgUrlsWebupload">
							<div class="clearfix">
								<div id="container2" style="float: left;overflow: hidden;margin: 10px 10px 10px 0;">
									<a id="selectfiles2" class="selectFiles btn">选择文件</a>
								</div>
								<div id="ossfile2" style="width: 200px;float: left;" class="clearfix">
									<c:forEach items="${resList}" var="dom" varStatus="i">
										<c:if test="${dom.resType == 1}">
											<div name="aliFile" style="position: relative;margin: 10px;">
												<img class="aliFileImg" src="${dom.assnResUrl}" style="max-height: 130px;max-width: 130px;position: absolute;left: 0;right: 0;top: 0;bottom: 0;margin: auto;">
												<input type="hidden" name="assnResImgUrls" value="${dom.assnResUrl}">
												<img class="aliRemoveBtn" src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201733161236Bn6gTqiCZBHhgObFvsCkLFNzmIBoh2.png" style="position:absolute;right:0;top:0;width:20px" onclick="removeImg($(this));"/>
											</div>
										</c:if>
									</c:forEach>
								</div>
							</div>
						</div>
					</td>
				</tr>
	        </table>
	        
	        <div class="assnTitle">社团视频：</div>
	        <div id="assnResVideos">
	        	<c:set var="videosNum" value="1"/>
	        	<c:forEach items="${resList}" var="dom" varStatus="i">
	        		<c:if test="${dom.resType == 2}">
				        <table width="100%" class="form-table assnResVideos">
				        	<tr>
				        		<td class="assnResVideosTitle"><img src="${path}/STATIC/image/remove.png"  width="30" height="30" onclick="removeVideos($(this));">视频${videosNum}：</td>
				        		<td><div class="assnVideo <c:if test='${assn.assnVideoUrl == dom.assnResUrl}'>assnVideoBlue</c:if>"  onclick="setMainVideo($(this))">设为主视频</div></td>
				        	</tr>
					        <tr>
				                <td width="100" class="td-title">视频名称：</td>
				                <td class="td-input" id="assnResVideoNamesLabel"><input type="text" name="assnResVideoNames" class="input-text w510" maxlength="30" value="${dom.assnResName}"/></td>
				            </tr>
					        <tr>
								<td class="td-title">视频缩略图<span style='color:red'>(360*230)</span>：</td>
								<td>
									<div class="whyUploadVedio assnResVideoCoversDiv" id="assnResVideoCover${videosNum}Webupload">
										<div class="clearfix">
											<div id="container2" style="float: left;overflow: hidden;margin: 10px 10px 10px 0;">
												<a id="selectfiles2" class="selectFiles btn">选择文件</a>
											</div>
											<div id="ossfile2" style="width: 200px;float: left;" class="clearfix">
												<c:if test="${not empty dom.assnResCover}">
													<div name="aliFile" style="position: relative;margin: 10px;">
														<img class="aliFileImg" src="${dom.assnResCover}" style="max-height: 130px;max-width: 130px;position: absolute;left: 0;right: 0;top: 0;bottom: 0;margin: auto;">
														<input type="hidden" name="assnResVideoCovers" value="${dom.assnResCover}">
														<img class="aliRemoveBtn" src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201733161236Bn6gTqiCZBHhgObFvsCkLFNzmIBoh2.png" style="position:absolute;right:0;top:0;width:20px" onclick="removeImg($(this));"/>
													</div>
												</c:if>
											</div>
										</div>
									</div>
								</td>
							</tr>
							<tr>
								<td class="td-title">上传视频：</td>
								<td>
									<div class="whyUploadVedio assnResVideoUrlsDiv" id="assnResVideoUrl${videosNum}Webupload">
										<div class="clearfix">
											<div id="container2" style="float: left;overflow: hidden;margin: 10px 10px 10px 0;">
												<a id="selectfiles2" class="selectFiles btn">选择文件</a>
											</div>
											<div id="ossfile2" style="width: 300px;float: left;" class="clearfix">
												<div name="aliFile" style="position: relative;margin: 10px;">
													<video src="${dom.assnResUrl}" style='width:260px;' controls/>
													<input type="hidden" name="assnResVideoUrls" value="${dom.assnResUrl}">
													<img class="aliRemoveBtn" src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201733161236Bn6gTqiCZBHhgObFvsCkLFNzmIBoh2.png" style="position:absolute;right:0;top:0;width:20px" onclick="removeImg($(this));"/>
												</div>
											</div>
										</div>
									</div>
								</td>
							</tr>
				        </table>
				        <c:set var="videosNum" value="${videosNum+1}"/>
				        <script>
				         	videosNum += 1;
				         	aliUploadImg('assnResVideoCover'+videosNum+'Webupload', getAssnResVideoCovers, 1, true, 'H5');
				        	aliUploadFiles('assnResVideoUrl'+videosNum+'Webupload', getAssnResVideoUrls, 1, true, 'H5');
				        </script>
					</c:if>
				</c:forEach>
		    </div>
		    
	        <div style="padding:20px 0px;">
	        	<img src="${path}/STATIC/image/add.png" width="30" height="30" onclick="addVideos();">
	        </div>
	        
	        <div class="assnTitle">社团初始参数：</div>
	        <table width="100%" class="form-table">
		        <tr>
	                <td width="100" class="td-title"><span class="red">*</span>成员数：</td>
	                <td class="td-input" id="assnMemberLabel"><input type="number" id="assnMember" name="assnMember" class="input-text w310" maxlength="10" value="${assn.assnMember}"/></td>
	            </tr>
		        <tr>
	                <td width="100" class="td-title"><span class="red">*</span>初始粉丝数：</td>
	                <td class="td-input" id="assnFansInitLabel"><input type="number" id="assnFansInit" name="assnFansInit" class="input-text w310" maxlength="10" value="${assn.assnFansInit}"/></td>
	            </tr>
		        <tr>
	                <td width="100" class="td-title"><span class="red">*</span>初始浇花数：</td>
	                <td class="td-input" id="assnFlowerInitLabel"><input type="number" id="assnFlowerInit" name="assnFlowerInit" class="input-text w310" maxlength="10" value="${assn.assnFlowerInit}"/></td>
	            </tr>
	        </table>
	        
	        <div class="assnTitle">社团分享：</div>
	        <table width="100%" class="form-table">
		        <tr>
	                <td width="100" class="td-title"><span class="red">*</span>分享标题：</td>
	                <td class="td-input" id="shareTitleLabel"><input type="text" id="shareTitle" name="shareTitle" class="input-text w510" maxlength="30" value="${assn.shareTitle}"/></td>
	            </tr>
		        <tr>
	                <td width="100" class="td-title"><span class="red">*</span>分享简介：</td>
	                <td class="td-input" id="shareDescLabel"><input type="text" id="shareDesc" name="shareDesc" class="input-text w510" maxlength="50" value="${assn.shareDesc}"/></td>
	            </tr>
	        </table>
	        
		    <table width="100%" class="form-table">  
	            <tr>
	                <td width="100" class="td-title"></td>
	                <td class="td-btn">
	                    <div class="room-order-info info2" style="position: relative;">
	                        <input id="saveBut" class="btn-publish" type="button" onclick="saveAssn()" value="保存"/>
	                    </div>
	                </td>
	            </tr>
	        </table>
	    </div>
	</form>
</body>
</html>
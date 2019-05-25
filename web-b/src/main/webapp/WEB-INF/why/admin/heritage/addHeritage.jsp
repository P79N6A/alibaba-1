<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>

<head>
    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>

	<script type="text/javascript" src="${path}/STATIC/js/admin/heritage/UploadHeritageFile.js"></script>
	
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/webuploader.css"/>
	<script type="text/javascript" src="${path}/STATIC/wechat/js/webuploader/webuploader.min.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/admin/heritage/upload-heritage.js"></script>
	
	<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>

    <script type="text/javascript">
    	$.ajaxSettings.async = false; 	//同步执行ajax
    	
    	var userId = '${user.userId}';
    
        seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
            window.dialog = dialog;
        });

        window.console = window.console || {log:function () {}}
        
        $(function () {
        	//非遗类别
            $.post("${path}/sysdict/queryChildSysDictByDictCode.do",{'dictCode' : 'CULTURETYPE'},function(data) {
            	if (data.length>0) {
    	            var ulHtml = '';
    	            $.each(data,function(i,dom){
    	            	ulHtml += '<li data-option="'+dom.dictId+'">'+dom.dictName+'</li>';
    	            })
    	            $('#heritageTypeUl').html(ulHtml);
    	        }
    		},"json");
        	
          	//非遗等级
            $.post("${path}/sysdict/queryChildSysDictByDictCode.do",{'dictCode' : 'CULTURESYSTEM'},function(data) {
            	if (data.length>0) {
    	            var ulHtml = '';
    	            $.each(data,function(i,dom){
    	            	ulHtml += '<li data-option="'+dom.dictId+'">'+dom.dictName+'</li>';
    	            })
    	            $('#heritageLevelUl').html(ulHtml);
    	        }
    		},"json");
          	
          	//非遗区域
            loadArea();
            
            if('${basePath}'.indexOf('http://xcct.bj.wenhuayun.cn')<0){	//北京西城不显示朝代
	            //非遗朝代
	            $.post("${path}/sysdict/queryChildSysDictByDictCode.do",{'dictCode' : 'CULTUREYEAR'},function(data) {
	    	        if (data.length>0) {
	    	            var ulHtml = '';
	    	            $.each(data,function(i,dom){
	    	            	ulHtml += '<li data-option="'+dom.dictId+'">'+dom.dictName+'</li>';
	    	            })
	    	            $('#heritageDynastyUl').html(ulHtml);
	    	        }
	    		},"json");
            }
            
            selectModel();
            
        });
    	
    	function loadArea(){
    		var userProvince = '${user.userProvince}';
       	 	var userCity = '${user.userCity}';
			var loc = new Location();
			var area = loc.find('0,' + userProvince.split(",")[0]);
            var ulHtml = '';
            $.each(area , function(k , v) {
                if(k == userCity.split(",")[0]){
                	ulHtml += '<li data-option="'+k+','+v+'">'+v+'</li>';
                }
   			});
            area = loc.find('0,' + userProvince.split(",")[0] + ',' + userCity.split(",")[0]);
   			$.each(area , function(k , v) {
                ulHtml += '<li data-option="'+k+','+v+'">'+v+'</li>';
   			});
            $('#heritageAreaUl').html(ulHtml);
    	}
    	
    	function saveHeritage(){
    		if (userId == null || userId == '') {
    			dialogAlert('系统提示', '登录超时');
                return;
            }
    		
    		$("#saveBut").attr("onclick","");
    		var heritageName=$('#heritageName').val();
    		var heritageCoverImg=$('#heritageCoverImg').val();
    		var heritageType=$('#heritageType').val();
    		var heritageLevel=$('#heritageLevel').val();
    		var heritageArea=$('#heritageArea').val();
    		var heritageDynasty=$('#heritageDynasty').val();
    		var heritageIntroduce=$('#heritageIntroduce').val();
    		
    		//非遗名称
    	    if(heritageName==undefined||heritageName.trim()==""){
    	        removeMsg("heritageNameLabel");
    	        $("#saveBut").attr("onclick","saveHeritage();");
    	        appendMsg("heritageNameLabel","非遗名称为必填项!");
    	        $('#heritageName').focus();
    	        return;
    	    }else{
    	        removeMsg("heritageNameLabel");
    	        if(heritageName.length>20){
    	        	$("#saveBut").attr("onclick","saveHeritage();");
    	            appendMsg("heritageNameLabel","非遗名称只能输入20字以内!");
    	            $('#heritageName').focus();
    	            return false;
    	        }
    	    }
    		
    		//非遗封面
    	    if(heritageCoverImg==undefined||heritageCoverImg.trim()==""){
    	        removeMsg("heritageCoverImgLabel");
    	        $("#saveBut").attr("onclick","saveHeritage();");
    	        appendMsg("heritageCoverImgLabel","非遗封面为必填项!");
    	        $('#heritageCoverImg').focus();
    	        return;
    	    }else{
    	        removeMsg("heritageCoverImgLabel");
    	    }
    	  
    	    if("N"==isCutImg) {
    	    	$("#saveBut").attr("onclick","saveHeritage();");
    	        dialogAlert("提示","请先裁剪系统要求尺寸(750*400)的图片，再提交！");
    	        return;
    	    }
    	    
    	  	//非遗类别
    	    if(heritageType==undefined||heritageType.trim()==""){
    	        removeMsg("heritageTypeLabel");
    	        $("#saveBut").attr("onclick","saveHeritage();");
    	        appendMsg("heritageTypeLabel","非遗类别为必填项!");
    	        $('#heritageType').focus();
    	        return;
    	    }else{
    	        removeMsg("heritageTypeLabel");
    	    }
    	  	
    	  	//非遗等级
    	    if(heritageLevel==undefined||heritageLevel.trim()==""){
    	        removeMsg("heritageLevelLabel");
    	        $("#saveBut").attr("onclick","saveHeritage();");
    	        appendMsg("heritageLevelLabel","非遗等级为必填项!");
    	        $('#heritageLevel').focus();
    	        return;
    	    }else{
    	        removeMsg("heritageLevelLabel");
    	    }
    	  	
    	  	//非遗区域
    	    if(heritageArea==undefined||heritageArea.trim()==""){
    	        removeMsg("heritageAreaLabel");
    	        $("#saveBut").attr("onclick","saveHeritage();");
    	        appendMsg("heritageAreaLabel","非遗区域为必填项!");
    	        $('#heritageArea').focus();
    	        return;
    	    }else{
    	        removeMsg("heritageAreaLabel");
    	    }
    	  	
    	    if('${basePath}'.indexOf('http://xcct.bj.wenhuayun.cn')<0){	//北京西城不填写朝代
	    	  	//非遗朝代
	    	    if(heritageDynasty==undefined||heritageDynasty.trim()==""){
	    	        removeMsg("heritageDynastyLabel");
	    	        $("#saveBut").attr("onclick","saveHeritage();");
	    	        appendMsg("heritageDynastyLabel","非遗朝代为必填项!");
	    	        $('#heritageDynasty').focus();
	    	        return;
	    	    }else{
	    	        removeMsg("heritageDynastyLabel");
	    	    }
    	    }
    	  	
    	  	if($("#heritageImgUl li").length==1){
    	  		$("#saveBut").attr("onclick","saveHeritage();");
    	  		dialogAlert("提示","请上传非遗图片！");
    	        return;
    	  	}
    	  	
    	  	//非遗简介
    	    if(heritageIntroduce==undefined||heritageIntroduce.trim()==""){
    	        removeMsg("heritageIntroduceLabel");
    	        $("#saveBut").attr("onclick","saveHeritage();");
    	        appendMsg("heritageIntroduceLabel","非遗简介为必填项!");
    	        $('#heritageIntroduce').focus();
    	        return;
    	    }else{
    	        removeMsg("heritageIntroduceLabel");
    	        if(heritageName.length>2000){
    	        	$("#saveBut").attr("onclick","saveHeritage();");
    	            appendMsg("heritageIntroduceLabel","非遗简介只能输入2000字以内!");
    	            $('#heritageIntroduce').focus();
    	            return false;
    	        }
    	    }
    	  	
    	  	//保存活动信息
    	    $.post("${path}/heritage/addHeritage.do", $("#heritageForm").serialize(),function(data) {
   	            if(data.status==1) {
   	                dialogAlert('系统提示', "保存成功!",function (r){
   	                	window.location.href="../heritage/heritageIndex.do";
   	                });
   	            }else{
   	                dialogAlert('系统提示', '保存失败');
   	                $("#saveBut").attr("onclick","saveHeritage();");
   	            }
   	     	},"json");
    	}

    </script>
    
    <style type="text/css">
		li {
			margin-top: 20px;
			width: 155px;
			height: 100px;
			float: left;
			margin-right: 20px;
			position: relative;
		}
		
		li .feiyi-img {
			width: 155px;
			height: 100px;
		}
		
		li .feiyi-remove {
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
	</style>
</head>

<body>
	<form id="heritageForm" method="post">
	    <input type="hidden" id="userCounty" name="userCounty" value="${sessionScope.user.userCounty}"/>
	    <input type="hidden" id="sessionId" value="${pageContext.session.id}"/>
	    <input type="hidden" name="createUser" value="${user.userId}"/>
	    <input type="hidden" name="updateUser" value="${user.userId}"/>
	    <input type="hidden" id="isCutImg" value="N"/>
	    
	    <div class="site">
	        <em>您现在所在的位置：</em>运维管理  &gt; 非遗管理  &gt; 新增非遗
	    </div>
	    <div class="site-title">新增非遗</div>
	    <div class="main-publish">
	        <table width="100%" class="form-table">
	            <tr>
	                <td width="100" class="td-title"><span class="red">*</span>非遗名称：</td>
	                <td class="td-input" id="heritageNameLabel"><input type="text" id="heritageName" name="heritageName" class="input-text w510" maxlength="20"/></td>
	            </tr>
	            <tr>
	                <td class="td-title"><span class="red">*</span>上传封面：</td>
	                <td class="td-upload" id="heritageCoverImgLabel">
	                    <table>
	                        <tr>
	                            <td>
	                                <input type="hidden" name="heritageCoverImg" id="heritageCoverImg" value="">
	                                <input type="hidden" name="uploadType" value="Img" id="uploadType"/>
	
	                                <div class="img-box">
	                                    <div  id="imgHeadPrev" class="img"> </div>
	                                </div>
	                                <div class="controls-box">
	                                    <div style="height: 46px;">
	                                        <div class="controls" style="float:left;">
	                                            <input type="file" name="file" id="file">
	                                        </div>
	                                        <%--<input type="button" class="upload-cut-btn" id="" value="裁剪图片"/>--%>
	                                        <span class="upload-tip">可上传1张图片，建议尺寸750*400像素，格式为jpg,jpeg,png,gif，大小不超过2M</span>
	                                    </div>
	                                    <div id="fileContainer"></div>
	                                    <div id="btnContainer" style="display: none;">
	                                        <a style="margin-left:335px;" href="javascript:clearQueue();" class="btn">取消</a>
	                                    </div>
	                                </div>
	                            </td>
	                        </tr>
	                    </table>
	                </td>
	            </tr>
	            <tr>
		            <td class="td-title"><span class="red">*</span>非遗类别：</td>
		            <td class="td-input search" id="heritageTypeLabel">
		                <div class="select-box w135" style="margin-left: 0;">
		                    <input type="hidden" name="heritageType" id="heritageType"/>
		                    <div id="heritageTypeDiv" class="select-text" data-value="">-请选择-</div>
		                    <ul class="select-option" id="heritageTypeUl"></ul>
		                </div>
		            </td>
		        </tr>
		        <tr>
		            <td class="td-title"><span class="red">*</span>非遗等级：</td>
		            <td class="td-input search" id="heritageLevelLabel">
		                <div class="select-box w135" style="margin-left: 0;">
		                    <input type="hidden" name="heritageLevel" id="heritageLevel"/>
		                    <div id="heritageLevelDiv" class="select-text" data-value="">-请选择-</div>
		                    <ul class="select-option" id="heritageLevelUl"></ul>
		                </div>
		            </td>
		        </tr>
		        <tr>
		            <td class="td-title"><span class="red">*</span>非遗区域：</td>
		            <td class="td-input search" id="heritageAreaLabel">
		                <div class="select-box w135" style="margin-left: 0;">
		                    <input type="hidden" name="heritageArea" id="heritageArea"/>
		                    <div id="heritageAreaDiv" class="select-text" data-value="">-请选择-</div>
		                    <ul class="select-option" id="heritageAreaUl"></ul>
		                </div>
		            </td>
		        </tr>
		        <!-- 北京西城不显示朝代 -->
			    <c:if test="${!fn:contains(basePath,'http://xcct.bj.wenhuayun.cn')}">
			        <tr>
			            <td class="td-title"><span class="red">*</span>非遗朝代：</td>
			            <td class="td-input search" id="heritageDynastyLabel">
			                <div class="select-box w135" style="margin-left: 0;">
			                    <input type="hidden" name="heritageDynasty" id="heritageDynasty"/>
			                    <div id="heritageDynastyDiv" class="select-text" data-value="">-请选择-</div>
			                    <ul class="select-option" id="heritageDynastyUl"></ul>
			                </div>
			            </td>
			        </tr>
			    </c:if>
	            <tr>
					<td class="td-title"><span class="red">*</span>上传图片：</td>
					<td>
						<ul id="heritageImgUl">
							<li class="uploadClass">
								<img src="${path}/STATIC/image/uploadImg.png" width="155" height="100"/>
							</li>
							<div style="clear: both;"></div>
						</ul>
					</td>
				</tr>
                <td width="100" class="td-title">简介：</td>
	                <td class="td-input">
	                    <div class="editor-box">
	                        <textarea id="heritageIntroduce" name="heritageIntroduce" rows="5" class="textareaBox"  maxlength="2000" style="width: 500px;resize: none"></textarea>
	                        <span class="upload-tip" style="color:#596988" id="heritageIntroduceLabel">（0~2000个字以内）</span>
	                    </div>
	                </td>
	            </tr>
	            <tr>
	                <td width="100" class="td-title"></td>
	                <td class="td-btn">
	                    <div class="room-order-info info2" style="position: relative;">
	                        <input id="saveBut" class="btn-publish" type="button" onclick="saveHeritage()" value="保存"/>
	                    </div>
	                </td>
	            </tr>
	        </table>
	    </div>
	</form>
</body>
</html>
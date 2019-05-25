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
    	
		var userId = '${sessionScope.user.userId}';
		
		if (userId == null || userId == '') {
			location.href = '${path}/admin.do';
		}
    
        $(function () {
          	aliUploadImg('lectorHeadImgWebupload', getLectorHeadImg, 1, true, 'H5');
        
        });
        
      	//头像回调
        function getLectorHeadImg(up, file, info) {
        	var filePath = "http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info;
        	$("#"+file.id).append("<input type='hidden' name='lectorHeadImg' value='"+filePath+"'/>");
		}
    	
    	function savePoemLector(){
    		if (userId == null || userId == '') {
    			dialogAlert('系统提示', '登录超时',function(){
    				location.href = '${path}/user/sysUserLoginOut.do'
    			});
                return;
            }
    		
    		$("#saveBut").attr("onclick","");
    		var lectorName=$('#lectorName').val();
    		var lectorHeadImg=$('input[name=lectorHeadImg]').val();
    		var lectorJob=$('#lectorJob').val();
    		var lectorIntro=$('#lectorIntro').val();
    		
    		if(!checkInfo(lectorName,"lectorName","讲师名称为必填项！")) return;
    		if(!checkInfo(lectorHeadImg,"lectorHeadImg","请上传头像！")) return;
    		if(!checkInfo(lectorJob,"lectorJob","讲师职位为必填项！")) return;
    		if(!checkInfo(lectorIntro,"lectorIntro","个人简介为必填项！")) return;
    		
    	  	//保存信息
    	    $.post("${path}/poem/saveOrUpdatePoemLector.do", $("#poemLectorForm").serialize(),function(data) {
   	            if(data == "200") {
   	                dialogAlert('系统提示', "保存成功!",function (r){
   	                	window.location.href="${path}/poem/poemLectorIndex.do";
   	                });
   	            }else{
   	                dialogAlert('系统提示', '保存失败');
   	                $("#saveBut").attr("onclick","savePoemLector();");
   	            }
   	     	},"json");
    	}

    	//信息必填验证
        function checkInfo(param,paramName,warn){
        	if(!param){
    	        removeMsg(paramName+"Label");
    	        $("#saveBut").attr("onclick","savePoemLector();");
    	        appendMsg(paramName+"Label",warn);
    	        $('#'+paramName).focus();
    	        return false;
    	    }else{
    	        removeMsg(paramName+"Label");
    	        return true;
    	    }
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
		div[name = aliFile] img:nth-child(1){
			position: relative!important;
		}
	</style>
</head>

<body>
	<form id="poemLectorForm" method="post">
	    <div class="site">
	        <em>您现在所在的位置：</em>运维管理 &gt; 每日一诗管理  &gt;讲师新增
	    </div>
	    <div class="site-title">新增讲师</div>
	    <div class="main-publish">
	        <table width="100%" class="form-table">
		        <tr>
	                <td width="100" class="td-title"><span class="red">*</span>讲师名称：</td>
	                <td class="td-input" id="lectorNameLabel"><input type="text" id="lectorName" name="lectorName" class="input-text w510" maxlength="20"/></td>
	            </tr>
	            <tr>
					<td class="td-title"><span class="red">*</span>上传头像：</td>
					<td id="lectorHeadImgLabel">
						<div class="whyUploadVedio" id="lectorHeadImgWebupload">
							<div class="clearfix">
								<div id="container2" style="float: left;overflow: hidden;margin: 10px 10px 10px 0;">
									<a id="selectfiles2" class="selectFiles btn">选择文件</a>
								</div>
								<div id="ossfile2" style="width: 200px;float: left;" class="clearfix">你的浏览器不支持flash,Silverlight或者HTML5！</div>
							</div>
						</div>
					</td>
				</tr>
	            <tr>
	                <td width="100" class="td-title"><span class="red">*</span>讲师职位：</td>
	                <td class="td-input" id="lectorJobLabel"><input type="text" id="lectorJob" name="lectorJob" class="input-text w510" maxlength="50"/></td>
	            </tr>
	            <tr>
		        	<td width="100" class="td-title"><span class="red">*</span>个人简介：</td>
					<td class="td-input">
	                    <div class="editor-box">
	                        <textarea id="lectorIntro" name="lectorIntro" rows="5" class="textareaBox"  maxlength="500" style="width: 500px;resize: none"></textarea>
	                        <span style="color:#596988" id="lectorIntroLabel">（500字以内）</span>
	                    </div>
	                </td>
				</tr>
			</table>	
			
		    <table width="100%" class="form-table">  
	            <tr>
	                <td width="100" class="td-title"></td>
	                <td class="td-btn">
	                    <div class="room-order-info info2" style="position: relative;">
	                        <input id="saveBut" class="btn-publish" type="button" onclick="savePoemLector()" value="保存"/>
	                    </div>
	                </td>
	            </tr>
	        </table>
	    </div>
	</form>
</body>
</html>
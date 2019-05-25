<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<title</title>
  		<%@include file="../../common/pageFrame.jsp"%>
  		<%@include file="/WEB-INF/why/common/aliImageFrame.jsp"%>
	  	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
	    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
	    <link rel="Stylesheet" type="text/css" href="${path}/STATIC/css/DialogBySHF.css" />
	    <script type="text/javascript" src="${path}/STATIC/js/DialogBySHF.js"></script>
    
		<style>
			.uploader-list {
				min-height: 242px;
				/*width: 960px;*/
			}
			
			.uploader-list>.file-item {
				float: left;
				margin-right: 40px;
			}
			
			.w30 {
				width: 30px;
			}
			
			.margin-left10 {
				margin-left: 10px;
			}
			
			#addleave {
				cursor: pointer;
			}
			
			.removeleave {
				cursor: pointer;
			}
			
			.upload-img-identify{
				position:relative!important
				;
			}
		</style>
		<script type="text/javascript">
		  seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
	            window.dialog = dialog;
	        });
		  
		  	var num=0;
		  
			$("document").ready(function() {
				
				aliUploadImg("uploadlogo",uploadlogoCallBack)
				
			})
			
			function uploadlogoCallBack(up, file, info){
				
				var aliImgUrl = "${aliImgUrl}" + info 
		    	
				//$("#logo").val(aliImgUrl)
				
				$("#"+file.id).append('<input type="hidden" id="logo" name="logo" value="'+aliImgUrl+'"/>')
			}

			
			function check(){
				
				var result= true;
				
				
				return result;
			}
			
			$(function() {
				// 保存
				$(".btn-publish").click(function(){
					
					var c=check();
					
		        	if(c)
		        	{
		        		$.post("${path}/applicationContestConfig/saveParamConfig.do",$("#configForm").serializeArray(),function(result) {
		        			   
		        			if(result=='user')
		        			{
		        				alert("请先登录！")
		        				window.location.href = "${path}/login.do";
		        			}
		        			else if(result=='success')
		        			{
		        				alert("保存成功！")
		        				window.location.href = "${path}/applicationContestConfig/index.do";
		        			}
		        			else
		        				alert("保存失败，系统错误！")
		        		});
		        	}
				});

			})
		</script>

	</head>

	<body>
		<div class="site">
			<em>您现在所在的位置：</em>文化云应用大赛  &gt; 应用大赛配置管理
		</div>
		<div class="site-title">应用大赛配置管理</div>
		<form method="post" id="configForm">
			<div class="main-publish">
				<table width="100%" class="form-table">
					
					<tr id="logoLabel">
						<td width="150" class="td-title">上传LOGO：</td>
						<td class="td-input" >
							<div id="uploadlogo" >

								<div class="td-input">
									 <div class="aliImg img-box">
									 <c:choose>
										<c:when test="${!empty configMap['logo']  }">
											<div name="aliFile" style="position:relative" ><span></span><b></b>
												<img onclick="aliRemoveImg(this)" class="aliRemoveBtn" src="../STATIC/image/removeBtn.png" style="position:absolute;left:80px;top:0;width:20px" />
												<img src="${configMap['logo']}@150w" style="max-height: 150px;max-width: 100px;" />
												<br />
												<input type="hidden" value="${configMap['logo'] }" name="logo" id="logo"/>
											</div>
										</c:when>
										<c:otherwise>
										</c:otherwise>
									</c:choose>
			                    </div>
			                    <div id="ossfile2">你的浏览器不支持flash,Silverlight或者HTML5！</div>
			                    <div id="container2">
			                  		<a id="selectfiles2" href="javascript:void(0);" class='btn'>选择上传封面</a>
									<a id="postfiles2" href="javascript:void(0);" class='btn'>开始上传</a>
									 请上传大于750x250图片
			                    </div>
								</div>
							</div>
						<span class="error-msg"></span>
						</td>
					</tr>
				
					
					<tr>
						<td width="150" class="td-title"></td>
						<td class="td-btn">
							<input class="btn-publish" type="button" value="保存" />
						</td>
					</tr>
				</table>
			</div>
		</form>

	</body>


</html>
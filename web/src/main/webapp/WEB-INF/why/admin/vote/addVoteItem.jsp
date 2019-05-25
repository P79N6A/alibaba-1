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
		</style>
		<script type="text/javascript">
		  seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
	            window.dialog = dialog;
	        });
		  
		  	var num=0;
		  
			$("document").ready(function() {
				
				num=$(".voteRuleClass").length+1;
				
				$(".removeleave").on("click", function() {
					$(this).parent().parent().remove()
				})
				
				aliUploadImg("uploaditemImgUrl",uploaditemImgUrlCallBack)
				
				
				aliUploadImg("uploadauthorHeadImgUrl",uploadauthorHeadImgUrlCallBack)
				
			})
			
			function uploadauthorHeadImgUrlCallBack(up, file, info){
				
				var aliImgUrl = "${aliImgUrl}" + info 
		    	
		    	//$("#authorHeadImgUrl").val(aliImgUrl)
		    	
		    	$("#"+file.id).append('<input type="hidden" id="authorHeadImgUrl" name="authorHeadImgUrl" value="'+aliImgUrl+'"/>')
		    	
			}
			
			function uploaditemImgUrlCallBack(up, file, info){
				
				var aliImgUrl = "${aliImgUrl}" + info 
		    	
				//$("#itemImgUrl").val(aliImgUrl)
				
				$("#"+file.id).append('<input type="hidden" id="itemImgUrl" name="itemImgUrl" value="'+aliImgUrl+'"/>')
			}

			
			function check(){
				
				var itemName = $("#itemName").val();
				
				if(itemName == undefined || $.trim(itemName) == ""){
					removeMsg("itemNameLabel");
					appendMsg("itemNameLabel","请输入投票选项名称!");
					$("#itemName").focus();
					return false;
				}else if(itemName.length > 8){
					removeMsg("itemNameLabel");
					appendMsg("itemNameLabel","最多不超过8个汉字!");
					$("#itemName").focus();
				}
				else 
					removeMsg("itemNameLabel");
				
				var itemImgUrl=$("#itemImgUrl").val();
				
				if(!itemImgUrl){
					
					removeMsg("itemImgUrlLabel");
					appendMsg("itemImgUrlLabel","请上传投票选项图片!");
					$("#itemImgUrl").focus();
					return false;
				}
				else
					removeMsg("itemImgUrlLabel");
				
				var result=true;
				
				var isAuthorInfo=$("#isAuthorInfo").val();
				
				if(isAuthorInfo=="2"){
					
					var authorName = $("#authorName").val();
					
					if(authorName == undefined || $.trim(authorName) == ""){
						removeMsg("authorNameLabel");
						appendMsg("authorNameLabel","请输入作者名称!");
						$("#authorName").focus();
						return false;
					}else if(authorName.length > 7){
						removeMsg("authorNameLabel");
						appendMsg("authorNameLabel","最多不超过7个汉字!");
						$("#authorName").focus();
						return false;
					}
					else 
						removeMsg("authorNameLabel");	
					
					var authorHeadImgUrl= $("#authorHeadImgUrl").val();
					
					if(!authorHeadImgUrl){
						removeMsg("authorHeadImgUrlLabel");
						appendMsg("authorHeadImgUrlLabel","请上传作者头像!");
						$("#authorHeadImgUrl").focus();
						return false;
					}
					else
						removeMsg("authorHeadImgUrlLabel");						
				}
				
				
				return result;
			}
			
			$(function() {
				$("#addleave").click(function() {
					addleaveList()
				})
				
				// 保存
				$(".btn-publish").click(function(){
					
					var c=check();
					
		        	if(c)
		        	{
		        		$.post("${path}/voteItem/saveVoteItem.do",$("#voteItemForm").serializeArray(),function(result) {
		        			   
		        			if(result=='user')
		        			{
		        				alert("请先登录！")
		        				window.location.href = "${path}/login.do";
		        			}
		        			else if(result=='success')
		        			{
		        				alert("添加成功！")
		        				var voteId=$("#voteId").val();
		        				window.location.href = "${path}/voteItem/managerVoteItem.do?voteId="+voteId;
		        			}
		        			else
		        				alert("添加失败，系统错误！")
		        		});
		        	}
				});

			})
		</script>

	</head>

	<body>
		<div class="site">
			<c:choose>
				<c:when test="${empty voteItem.voteItemId }">
					<em>您现在所在的位置：</em>运维管理  &gt;线上投票&gt;投票选项列表&gt;添加投票项目
				</c:when>
				<c:otherwise>
					<em>您现在所在的位置：</em>运维管理  &gt;线上投票&gt;投票选项列表&gt;编辑投票项目
				</c:otherwise>
			</c:choose>
		</div>
		<div class="site-title">新建投票项目页</div>
		<form method="post" id="voteItemForm">
		 <input type="hidden" id="voteItemId" name="voteItemId" value="${voteItem.voteItemId }"/>
		 <input type="hidden" id="voteId" name="voteId" value="${vote.voteId }"/>
			<div class="main-publish">
				<table width="100%" class="form-table">
					<tr>
						<td width="150" class="td-title"><span class="red">*</span>投票选项名称：</td>
						<td class="td-input" id="itemNameLabel">
							<input id="itemName" name="itemName" type="text" class="input-text w510" value='${voteItem.itemName }' maxlength="8" />
							8个汉字以内
							<span class="error-msg"></span>
						</td>
					</tr>
					
					<tr >
						<td width="150" class="td-title"><span class="red">*</span>上传投票图片：</td>
						<td class="td-input" id="itemImgUrlLabel">
							<div id="uploaditemImgUrl" >

								<div class="td-input">
									 <div class="aliImg img-box">
									 <c:choose>
										<c:when test="${!empty voteItem.itemImgUrl  }">
											<div name="aliFile" style="position:relative" ><span></span><b></b>
												<img onclick="aliRemoveImg(this)" class="aliRemoveBtn" src="../STATIC/image/removeBtn.png" style="position:absolute;left:80px;top:0;width:20px" />
												<img src="${voteItem.itemImgUrl}@300w" style="max-height: 150px;max-width: 100px;" />
												<br />
												<input type="hidden" value="${voteItem.itemImgUrl }" name="itemImgUrl" id="itemImgUrl"/>
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
									 请上传大于750x500图片
			                    </div>
								</div>
							</div>
						<span class="error-msg"></span>
						</td>
					</tr>
					<input type="hidden" id="isAuthorInfo" value="${vote.isAuthorInfo}"/>
					<c:if test="${vote.isAuthorInfo==2 }">
					<tr>
						<td width="150" class="td-title"><span class="red">*</span>作者名称：</td>
						<td class="td-input" id="authorNameLabel">
							<input id="authorName" name="authorName" type="text" class="input-text w510" value='${voteItem.authorName }' />
							7个汉字以内
							<span class="error-msg"></span>
						</td>
					</tr>
					<tr >
						<td width="150" class="td-title"><span class="red">*</span>作者头像：</td>
						<td class="td-input" id="authorHeadImgUrlLabel">
								<div id="uploadauthorHeadImgUrl">

								<c:choose>
										<c:when test="${!empty voteItem.authorHeadImgUrl  }">
											<div name="aliFile" style="position:relative" ><span></span><b></b>
												<img onclick="aliRemoveImg(this)" class="aliRemoveBtn" src="../STATIC/image/removeBtn.png" style="position:absolute;left:80px;top:0;width:20px" />
												<img src="${voteItem.authorHeadImgUrl}@300w" style="max-height: 100px;max-width: 100px;" />
												<br />
												 <input type="hidden" value="${voteItem.authorHeadImgUrl }" name="authorHeadImgUrl" id="authorHeadImgUrl"/>
											</div>
										</c:when>
										<c:otherwise>
										</c:otherwise>
									</c:choose>
			                   
			                    <div id="ossfile2">你的浏览器不支持flash,Silverlight或者HTML5！</div>
			                    <div id="container2">
			                  		<a id="selectfiles2" href="javascript:void(0);" class='btn'>选择图片</a>
									<a id="postfiles2" href="javascript:void(0);" class='btn'>开始上传</a>
									请上传300*300图片
			                    </div>
								</div>

							</div>
						</td>
					</tr>
						</c:if>
						
						<tr>
						<td width="150" class="td-title">链接地址：</td>
						<td class="td-input" id="itemLinkLabel">
							<input id="itemLink" name="itemLink" type="text" class="input-text w510" value='${voteItem.itemLink }' />
							
							<span class="error-msg"></span>
						</td>
					</tr>
					<tr>
						<td width="150" class="td-title"></td>
						<td class="td-btn">
							<input class="btn-save" type="button" onclick="javascript:window.history.go(-1);" value="返回" />

							<input class="btn-publish" type="button" value="保存" />
						</td>
					</tr>
				</table>
			</div>
		</form>

	</body>


</html>
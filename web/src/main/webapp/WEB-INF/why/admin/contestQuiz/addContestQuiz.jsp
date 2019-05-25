<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="com.sun3d.why.enumeration.contest.CcpContestTopicIsLevelEnum"%>

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
			$("document").ready(function() {
				
				$(".isDraw").click(function() {
					if($("#isDrawYes").get(0).checked) {
						$(".leaveList").show()
					} else {
						$(".leaveList").hide()
					}
				})
				
				$(".selectTemplate").click(function() {
					
					var selectTemplate2=$("#selectTemplate2").prop("checked");
					
					if(selectTemplate2) 
					{
						$(".templateUpload").show();
						$("#selectBtn").prop("disabled",true);
					}
					else{
						
						$(".templateUpload").hide();
						$("#selectBtn").prop("disabled",false);
					}
						
				});
				
				$("#selectBtn").click(function() {
					
					   dialog({
			                url: '${path}/contestTemplate/selectTemplate.do?templateId='+$("#templateId").val(),
			                title: '选择模板',
			                width: 600,
			                height: 400,
			                fixed: true,
			                onclose: function () {
		                        if(this.returnValue){
		                            $('#templateId').val(this.returnValue.templateId);
		                            $("#templateName").html(this.returnValue.templateName);
		                           
		                        }
		                        //dialog.focus();
		                    }

			            }).showModal();
				});
				
				aliUploadImg("uploadCoverImgUrl",uploadCoverImgUrlCallBack)
				
				aliUploadImg("uploadBackgroundImgUrl",uploadBackgroundImgUrlCallBack)
				
				aliUploadImg("uploadShareLogoImg",uploadShareLogoImgCallBack)
				
				aliUploadImg("uploadlogo",uploadlogoCallBack)
				
			})
			
			function uploadlogoCallBack(up, file, info){
				
				var aliImgUrl = "${aliImgUrl}" + info 
		    	
				//$("#logo").val(aliImgUrl)
				
				$("#"+file.id).append('<input type="hidden" id="indexLogo" name="indexLogo" value="'+aliImgUrl+'"/>')
			}
			
			function uploadShareLogoImgCallBack(up, file, info){
				
				var aliImgUrl = "${aliImgUrl}" + info 
		    	
		    	$("#"+file.id).append('<input type="hidden" id="shareLogoImg" name="shareLogoImg" value="'+aliImgUrl+'"/>')
		    	
			}
			
			function uploadCoverImgUrlCallBack(up, file, info){
				
				var aliImgUrl = "${aliImgUrl}" + info 
		    	
				$("#"+file.id).append('<input type="hidden" id="coverImgUrl" name="coverImgUrl" value="'+aliImgUrl+'"/>')
			}
			
			function uploadBackgroundImgUrlCallBack(up, file, info){
				
				var aliImgUrl = "${aliImgUrl}" + info 
		    	
				$("#"+file.id).append('<input type="hidden" id="backgroundImgUrl" name="backgroundImgUrl" value="'+aliImgUrl+'"/>')
			}

			function addleaveList() {
				//				$(".td-input").eq(leaveListnum).find("#addleave").hide()
				$(".leaveList").append(
					"<div class=\"td-input\">" +
					"<span>第</span>" +
					"<input type=\"text\" class=\"input-text w30 margin-left10\" name=\"passNumber\"/>" +
					"<span> 关后,称号:</span>" +
					"<input type=\"text\" class=\"input-text margin-left10\" name=\"passName\"/>" +
					"<div class='removeleave' style=\"display: inline-block;width: 50px;height: 50px;vertical-align: middle;text-align: center;font-size: 40px;\">-</div>" +
					"</div>"
				)
				$(".removeleave").on("click", function() {
					$(this).parent().remove()
				})
			}
			
			function check(){
				
				
				var topicName = $("#topicName").val();
				
				if(topicName == undefined || $.trim(topicName) == ""){
					removeMsg("topicNameLabel");
					appendMsg("topicNameLabel","请输入问答标题!");
					$("#topicName").focus();
					return false;
				}else if(topicName.length > 11){
					removeMsg("topicNameLabel");
					appendMsg("topicNameLabel","最多不超过10个汉字!");
					$("#topicName").focus();
				}
				else 
					removeMsg("topicNameLabel");
				
				var topicTitle = $("#topicTitle").val();
				
				if(topicTitle == undefined || $.trim(topicTitle) == ""){
					removeMsg("topicTitleLabel");
					appendMsg("topicTitleLabel","请输入封面标题!");
					$("#topicTitle").focus();
					return false;
				}else if(topicTitle > 30){
					removeMsg("topicTitleLabel");
					appendMsg("topicTitleLabel","最多不超过30个汉字!");
					$("#topicTitle").focus();
					return false;
				}
				else 
					removeMsg("topicTitleLabel");
				
				if($("#selectTemplate1").prop("checked")) {
					
					var templateId=$("#templateId").val();
					
					if(!templateId){
						removeMsg("templateIdLabel");
		        		appendMsg("templateIdLabel","请选择模板！");
		        		$("#selectTemplate1").focus();
		        		return false;
					}
					else
					{
		        		removeMsg("templateIdLabel");
					}
				}
				else if($("#selectTemplate2").prop("checked")){
					
					var coverImgUrl=$("#coverImgUrl").val();
					
					if(!coverImgUrl){
						removeMsg("templateIdLabel");
		        		appendMsg("templateIdLabel","请上传封面！");
		        		$("#selectTemplate2").focus();
		        		return false;
					}
					else
					{
		        		removeMsg("templateIdLabel");
					}
					
					var backgroundImgUrl=$("#backgroundImgUrl").val();
					
					if(!backgroundImgUrl){
						removeMsg("templateIdLabel");
		        		appendMsg("templateIdLabel","请上传内页底图！");
		        		$("#selectTemplate2").focus();
		        		return false;
					}
					else
					{
		        		removeMsg("templateIdLabel");
					}
				}
					
				if($("#isDrawYes").get(0).checked){
					
					var drawRule=$("#drawRule").val().replace(/\ +/g,"").replace(/[ ]/g,"").replace(/[\r\n]/g,"");
					
					if(drawRule.length > 70){
						removeMsg("drawRuleLabel");
						appendMsg("drawRuleLabel","最多不超过70个汉字!");
						$("#drawRule").focus();
						return false;
					}
					else
						removeMsg("drawRuleLabel");
				}
				
				var reg=/^[1-9]([0-9]*)$/;
			
					var answerRightText = $("#answerRightText").val();
					
					if(answerRightText == undefined || $.trim(answerRightText) == ""){
						removeMsg("answerRightTextLabel");
						appendMsg("answerRightTextLabel","请输入答对文字!");
						$("#answerRightText").focus();
						return false;
					}else if(answerRightText.length > 11){
						removeMsg("answerRightTextLabel");
						appendMsg("answerRightTextLabel","最多不超过10个汉字!");
						$("#answerRightText").focus();
						return false;
					}
					else 
						removeMsg("answerRightTextLabel");
					
					var answerWrongText = $("#answerWrongText").val();
					
					if(answerWrongText == undefined || $.trim(answerWrongText) == ""){
						removeMsg("answerWrongTextLabel");
						appendMsg("answerWrongTextLabel","请输入答错文字!");
						$("#answerWrongText").focus();
						return false;
					}else if(answerWrongText.length > 11){
						removeMsg("answerWrongTextLabel");
						appendMsg("answerWrongTextLabel","最多不超过10个汉字!");
						$("#answerWrongText").focus();
						return false;
					}
					else 
						removeMsg("answerWrongTextLabel");
					
					var passText = $("#passText").val();
					
					if(passText == undefined || $.trim(passText) == ""){
						removeMsg("passTextLabel");
						appendMsg("passTextLabel","请输入通过文案!");
						$("#passText").focus();
						return false;
					}
					else if(passText.length > 60){
						removeMsg("passTextLabel");
						appendMsg("passTextLabel","最多不超过60个汉字!");
						$("#passText").focus();
						return false;
					}
					else 
						removeMsg("passTextLabel");
				
				
				return true;
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
		        		$.post("${path}/contestTopic/addContestQuiz.do",$("#topicForm").serializeArray(),function(result) {
		        			   
		        			if(result=='user')
		        			{
		        				alert("请先登录！")
		        				window.location.href = "${path}/login.do";
		        			}
		        			else if(result=='success')
		        			{
		        				alert("添加成功！")
		        				window.location.href = "${path}/contestTopic/contestQuizIndex.do";
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
			<em>您现在所在的位置：</em>运维管理  &gt; 知识问答&gt; 添加问答
		</div>
		<div class="site-title">新建问答页</div>
		<form method="post" id="topicForm">
		 <input type="hidden" id="userCounty" name="userCounty" value="${sessionScope.user.userCounty}"/>
		 <input type="hidden" id="topicId" name="topicId" value="${contestTopic.topicId }"/>
		 <input type="hidden" id="topicStatus" name="topicStatus" value="3"/>
			<div class="main-publish">
				<table width="100%" class="form-table">
					<tr>
						<td width="100" class="td-title"><span class="red">*</span>问答标题：</td>
						<td class="td-input" id="topicNameLabel">
							<input id="topicName" name="topicName" type="text" class="input-text w510" value='${contestTopic.topicName }' maxlength="10" />
							<span class="error-msg"></span>
						</td>
					</tr>
					<tr>
						<td width="100" class="td-title"><span class="red">*</span>封面标题：</td>
						<td class="td-input" id="topicTitleLabel">
							<input id="topicTitle" name="topicTitle" type="text" class="input-text w510" value='${contestTopic.topicTitle }' maxlength="30" />
							多个标题以英文逗号,隔开
							<span class="error-msg"></span>
							
						</td>
					</tr>
					<tr>
						<td width="100" class="td-title"><span class="red">*</span>选择模板：</td>
						<td class="td-input td-fees" id="templateIdLabel">
							<c:choose>
								<c:when test="${template.templateIsSystem==1 }">
								<label><input type="radio" id="selectTemplate1" name="selectTemplate" value="1" class="radio selectTemplate" checked="checked"><em>
									<span id="templateName">${template.templateName}</span>
									<input class="" type="button" id="selectBtn" value="点击选择模板"/></em></label>
									<label><input type="radio" id="selectTemplate2" name="selectTemplate" value="2" class="radio selectTemplate" ><em>自定义</em></label>
								</c:when>
								<c:when test="${template.templateIsSystem==2 }">
								<label><input type="radio" id="selectTemplate1" name="selectTemplate" value="1" class="radio selectTemplate"><em>
									<span id="templateName"></span>
									<input class="" type="button" id="selectBtn" value="点击选择模板"/></em></label>
									<label><input type="radio" id="selectTemplate2" name="selectTemplate" value="2" class="radio selectTemplate"  checked="checked"><em>自定义</em></label>
								
									<script type="text/javascript">
										$(function(){
											$("#selectTemplate2").click();
										});
									</script>
								</c:when>
								<c:otherwise>
									<label><input type="radio" id="selectTemplate1" name="selectTemplate" value="1" class="radio selectTemplate" checked="checked"><em>
									<span id="templateName"></span>
									<input class="" type="button" id="selectBtn" value="点击选择模板"/></em></label>
									<label><input type="radio" id="selectTemplate2" name="selectTemplate" value="2" class="radio selectTemplate" ><em>自定义</em></label>
								</c:otherwise>
							</c:choose>
							<input type="hidden" id="templateId" name="templateId" value="${contestTopic.templateId }"/>	
							<span class="error-msg"></span>
						</td>
					</tr>
					<tr class="templateUpload" style="display: none;">
						<td></td>
						<td class="td-input" id="passLabel">
							<div id="uploadCoverImgUrl" >

								<div class="td-input">
									 <div class="aliImg img-box">
									 <c:choose>
										<c:when test="${template.templateIsSystem==2 && !empty template.coverImgUrl  }">
											<div name="aliFile" style="position:relative" ><span></span><b></b>
												<img onclick="aliRemoveImg(this)" class="aliRemoveBtn" src="../STATIC/image/removeBtn.png" style="position:absolute;left:80px;top:0;width:20px" />
												<img src="${template.coverImgUrl}" style="max-height: 100px;max-width: 100px;" />
												<br />
												<input type="hidden" value="${template.coverImgUrl }" name="coverImgUrl" id="coverImgUrl"/>
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
									 请上传750*1200图片
			                    </div>
								</div>

							</div>
							
							<div id="uploadBackgroundImgUrl">

								<div class="td-input">
									 <div class="aliImg img-box">
		                 			 <c:choose>
										<c:when test="${template.templateIsSystem==2 && !empty template.backgroundImgUrl  }">
											<div name="aliFile" style="position:relative" ><span></span><b></b>
												<img onclick="aliRemoveImg(this)" class="aliRemoveBtn" src="../STATIC/image/removeBtn.png" style="position:absolute;left:80px;top:0;width:20px" />
												<img src="${template.backgroundImgUrl }" style="max-height: 100px;max-width: 100px;" />
												<br />
												  <input type="hidden" value="${template.backgroundImgUrl }" name="backgroundImgUrl" id="backgroundImgUrl"/>
											</div>
										</c:when>
										<c:otherwise>
										</c:otherwise>
									</c:choose>
			                  
			                    </div>
			                    <div id="ossfile2">你的浏览器不支持flash,Silverlight或者HTML5！</div>
			                    <div id="container2">
			                  		<a id="selectfiles2" href="javascript:void(0);" class='btn'>选择上传内页底图</a>
									<a id="postfiles2" href="javascript:void(0);" class='btn'>开始上传</a>
			                  		 请上传750*1200图片
			                    </div>
								</div>

							</div>
						</td>
					</tr>
					
					<tr>
						<td width="100" class="td-title"><span class="red">*</span>是否抽奖：</td>
						<td class="td-input td-fees">
							<c:choose>
								<c:when test="${ contestTopic.isDraw ==2}">
									<label><input id="isDrawNo" type="radio" name="isDraw" value="1" class="isDraw" ><em>否</em></label>
									<label><input id="isDrawYes" type="radio" name="isDraw" value="2" class="isDraw" checked="checked"><em>是</em></label>
								</c:when>
								<c:otherwise>
								<label><input id="isDrawNo" type="radio" name="isDraw" value="1" class="isDraw" checked="checked"><em>否</em></label>
								<label><input id="isDrawYes" type="radio" name="isDraw" value="2" class="isDraw" ><em>是</em></label>
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
					
					<c:choose>
						<c:when test="${ contestTopic.isDraw ==2}">
					<tr class="leaveList">
						<td width="100" class="td-title">抽奖规则：</td>
						<td class="td-input" id="drawRuleLabel">
							<div class="editor-box">
			                    <textarea id="drawRule" name="drawRule" rows="4" class="textareaBox" style="width: 510px;resize: none">${ contestTopic.drawRule}</textarea>
			                </div>  
							<span class="error-msg"></span>
						</td>
					</tr>
						</c:when>
						<c:otherwise>
							<tr class="leaveList" style="display: none;">
						<td width="100" class="td-title">抽奖规则：</td>
						<td class="td-input" id="drawRuleLabel">
							<div class="editor-box">
			                    <textarea id="drawRule" name="drawRule" rows="4" class="textareaBox" style="width: 510px;resize: none"></textarea>
			                </div>
							<span class="error-msg"></span>
						</td>
					</tr>
						</c:otherwise>
					</c:choose>
					<tr>
						<td width="100" class="td-title"><span class="red">*</span>答对文字提示：</td>
						<td class="td-input" id="answerRightTextLabel">
							<input id="answerRightText" name="answerRightText" type="text" class="input-text w510" value='${ contestTopic.answerRightText}' />
							<span class="error-msg"></span>
						</td>
					</tr>
					<tr>
						<td width="100" class="td-title"><span class="red">*</span>答错文字提示：</td>
						<td class="td-input" id="answerWrongTextLabel">
							<input id="answerWrongText" name="answerWrongText" type="text" class="input-text w510" value='${ contestTopic.answerWrongText}' />
							<span class="error-msg"></span>
						</td>
					</tr>
					<tr>
						<td width="100" class="td-title"><span class="red">*</span>通关文案：</td>
						<td class="td-input" id="passTextLabel">
							<div class="editor-box">
			                    <textarea id="passText" name="passText" rows="4" class="textareaBox" style="width: 510px;resize: none">${ contestTopic.passText}</textarea>
			                </div>
							<span class="error-msg"></span>
						</td>
					</tr>
					
					<tr>
						<td width="100" class="td-title">分享封面图：</td>
						<td class="td-input" id="">
								<div id="uploadShareLogoImg">

								<c:choose>
										<c:when test="${!empty contestTopic.shareLogoImg  }">
											<div name="aliFile" style="position:relative" ><span></span><b></b>
												<img onclick="aliRemoveImg(this)" class="aliRemoveBtn" src="../STATIC/image/removeBtn.png" style="position:absolute;left:80px;top:0;width:20px" />
												<img src="${contestTopic.shareLogoImg}@300w" style="max-height: 100px;max-width: 100px;" />
												<br />
												 <input type="hidden" value="${contestTopic.shareLogoImg }" name="shareLogoImg" id="shareLogoImg"/>
											</div>
										</c:when>
										<c:otherwise>
										</c:otherwise>
									</c:choose>
			                   
			                    <div id="ossfile2">你的浏览器不支持flash,Silverlight或者HTML5！</div>
			                    <div id="container2">
			                  		<a id="selectfiles2" href="javascript:void(0);" class='btn'>选择图片</a>
									<a id="postfiles2" href="javascript:void(0);" class='btn'>开始上传</a>
									请上传150*150图片
			                    </div>
								</div>

							</div>
						</td>
					</tr>
					<tr>
						<td width="100" class="td-title">分享标题：</td>
						<td class="td-input" id="shareTitleLabel">
							<input id="shareTitle" name="shareTitle" type="text" class="input-text w510" value='${contestTopic.shareTitle }' />
							<span class="error-msg"></span>
						</td>
					</tr>
					<tr>
						<td width="100" class="td-title">分享描述：</td>
						<td class="td-input" id="shareDescribeLabel">
							<div class="editor-box">
			                    <textarea name="shareDescribe" rows="4" class="textareaBox" style="width: 510px;resize: none">${contestTopic.shareDescribe }</textarea>
			                </div>
							<span class="error-msg"></span>
						</td>
					</tr>
					<tr id="logoLabel">
						<td width="100" class="td-title">首页显示LOGO：</td>
						<td class="td-input" >
							<div id="uploadlogo" >

								<div class="td-input">
									 <div class="aliImg img-box">
									 <c:choose>
										<c:when test="${!empty contestTopic.indexLogo   }">
											<div name="aliFile" style="position:relative" ><span></span><b></b>
												<img onclick="aliRemoveImg(this)" class="aliRemoveBtn" src="../STATIC/image/removeBtn.png" style="position:absolute;left:80px;top:0;width:20px" />
												<img src="${contestTopic.indexLogo }@80w" style="max-height: 150px;max-width: 100px;" />
												<br />
												<input type="hidden" value="${contestTopic.indexLogo }" name="logo" id="logo"/>
											</div>
										</c:when>
										<c:otherwise>
										</c:otherwise>
									</c:choose>
			                    </div>
			                    <div id="ossfile2">你的浏览器不支持flash,Silverlight或者HTML5！</div>
			                    <div id="container2">
			                  		<a id="selectfiles2" href="javascript:void(0);" class='btn'>选择上传LOGO</a>
									<a id="postfiles2" href="javascript:void(0);" class='btn'>开始上传</a>
									 请上传大于80X70图片
			                    </div>
								</div>
							</div>
						<span class="error-msg"></span>
						</td>
					</tr>
					<tr>
						<td width="100" class="td-title"></td>
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
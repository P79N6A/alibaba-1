<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<title></title>
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
			
				$(".main-publish").on("click",".removeleave", function() {
					$(this).parent().parent().parent().remove()
				})
				
				aliUploadImg("uploadCoverImgUrl",uploadCoverImgUrlCallBack)
				
				
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
		    	
		    	//$("#shareLogoImg").val(aliImgUrl)
		    	
		    	$("#"+file.id).append('<input type="hidden" id="shareLogoImg" name="shareLogoImg" value="'+aliImgUrl+'"/>')
			}
			
			function uploadCoverImgUrlCallBack(up, file, info){
				
				var aliImgUrl = "${aliImgUrl}" + info 
		    	
				//$("#coverImgUrl").val(aliImgUrl)
				
				$("#"+file.id).append('<input type="hidden" id="coverImgUrl" name="coverImgUrl" value="'+aliImgUrl+'"/>')
			}

			function addleaveList() {	
				//				$(".td-input").eq(leaveListnum).find("#addleave").hide()
				$(".voteRuleClass:last").after(
						'<tr id="voteRule'+num+'" class="voteRuleClass">'+
						'<td width="100" class="td-title">活动规则'+num+':</td>'+
						'<td class="td-input leaveList" id="voteRuleLabel'+num+'">'+
							'<div class="editor-box">'+
			                    '<textarea id="voteRule'+num+'" name="voteRule" rows="4" class="textareaBox" style="width: 510px;resize: none"></textarea>'+
			                    "<div class='removeleave' style=\"display: inline-block;width: 50px;height: 50px;vertical-align: top;text-align: center;font-size: 40px;\">-</div>"+
			                '</div>'+
							'<span class="error-msg"></span>'+
						'</td>'+
					'</tr>'
				) 
				
				num++;
				
			}
			
			function check(){
				
				
				var voteName = $("#voteName").val();
				
				if(voteName == undefined || $.trim(voteName) == ""){
					removeMsg("voteNameLabel");
					appendMsg("voteNameLabel","请输入投票项目名称!");
					$("#voteName").focus();
					return false;
				}else if(voteName.length > 10){
					removeMsg("voteNameLabel");
					appendMsg("voteNameLabel","最多不超过10个汉字!");
					$("#voteName").focus();
				}
				else 
					removeMsg("voteNameLabel");
				
				var voteTitle = $("#voteTitle").val();
				
				if(voteTitle == undefined || $.trim(voteTitle) == ""){
					removeMsg("voteTitleLabel");
					appendMsg("voteTitleLabel","请输入封面主标题!");
					$("#voteTitle").focus();
					return false;
				}else if(voteTitle.length > 14){
					removeMsg("voteTitleLabel");
					appendMsg("voteTitleLabel","最多不超过14个汉字!");
					$("#voteTitle").focus();
					return false;
				}
				else 
					removeMsg("voteTitleLabel");
				
				var voteSecondTitle = $("#voteSecondTitle").val();
				
				if(voteSecondTitle == undefined || $.trim(voteSecondTitle) == ""){
					removeMsg("voteSecondTitleLabel");
					appendMsg("voteSecondTitleLabel","请输入封面副标题!");
					$("#voteSecondTitle").focus();
					return false;
				}else if(voteSecondTitle > 20){
					removeMsg("voteSecondTitleLabel");
					appendMsg("voteSecondTitleLabel","最多不超过20个汉字!");
					$("#voteSecondTitle").focus();
					return false;
				}
				else 
					removeMsg("voteSecondTitleLabel");	
				
				var coverImgUrl=$("#coverImgUrl").val();
				
				var voteIntroduction = $("#voteIntroduction").val();
				
				if(voteIntroduction.length > 300){
					removeMsg("voteIntroductionLabel");
					appendMsg("voteIntroductionLabel","最多不超过300个汉字!");
					$("#voteIntroduction").focus();
					return false;
				}
				else 
					removeMsg("voteIntroductionLabel");	
				
				var voteRuleArray= $("textarea[name='voteRule']");
				
				var result=true;
				
				$.each(voteRuleArray,function(i,dom){
					
					var voteRule=dom.value;
					
					if(voteRule.length>300){
						
						var id=$(this).parent().parent().attr("id");
						
						removeMsg(id);
						appendMsg(id,"最多不超过300个汉字!");
						$(this).focus();
						result=false;
						return false;
					}
					else
						removeMsg(id);	
					
				})
				
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
		        		$.post("${path}/vote/saveVote.do",$("#voteForm").serializeArray(),function(result) {
		        			   
		        			if(result=='user')
		        			{
		        				alert("请先登录！")
		        				window.location.href = "${path}/login.do";
		        			}
		        			else if(result=='success')
		        			{
		        				alert("添加成功！")
		        				window.location.href = "${path}/vote/voteIndex.do";
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
				<c:when test="${empty vote.voteId }">
					<em>您现在所在的位置：</em>运维管理  &gt; 线上投票&gt; 添加投票项目
				</c:when>
				<c:otherwise>
					<em>您现在所在的位置：</em>运维管理  &gt; 线上投票&gt; 编辑投票项目
				</c:otherwise>
			</c:choose>
		</div>
		<div class="site-title">新建投票项目页</div>
		<form method="post" id="voteForm">
		 <input type="hidden" id="voteId" name="voteId" value="${vote.voteId }"/>
			<div class="main-publish">
				<table width="100%" class="form-table">
					<tr>
						<td width="150" class="td-title"><span class="red">*</span>投票项目名称：</td>
						<td class="td-input" id="voteNameLabel">
							<input id="voteName" name="voteName" type="text" class="input-text w510" value='${vote.voteName }' maxlength="10" />
							10个汉字以内
							<span class="error-msg"></span>
						</td>
					</tr>
					<tr>
						<td width="150" class="td-title"><span class="red">*</span>封面主标题：</td>
						<td class="td-input" id="voteTitleLabel">
							<input id="voteTitle" name="voteTitle" type="text" class="input-text w510" value='${vote.voteTitle }' maxlength="15" />
							14个汉字以内
							<span class="error-msg"></span>
							
						</td>
					</tr>
					<tr>
						<td width="150" class="td-title"><span class="red">*</span>封面副标题：</td>
						<td class="td-input" id="voteSecondTitleLabel">
							<input id="voteSecondTitle" name="voteSecondTitle" type="text" class="input-text w510" value='${vote.voteSecondTitle }' maxlength="20" />
							20个汉字以内
							<span class="error-msg"></span>
							
						</td>
					</tr>
					<tr id="coverImgUrlLabel">
						<td width="150" class="td-title">上传封面图：</td>
						<td class="td-input" >
							<div id="uploadCoverImgUrl" >

								<div class="td-input">
									 <div class="aliImg img-box">
									 <c:choose>
										<c:when test="${!empty vote.coverImgUrl  }">
											<div name="aliFile" style="position:relative" ><span></span><b></b>
												<img onclick="aliRemoveImg(this)" class="aliRemoveBtn" src="../STATIC/image/removeBtn.png" style="position:absolute;left:80px;top:0;width:20px" />
												<img src="${vote.coverImgUrl}@150w" style="max-height: 150px;max-width: 100px;" />
												<br />
												<input type="hidden" value="${vote.coverImgUrl }" name="coverImgUrl" id="coverImgUrl"/>
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
						<td width="150" class="td-title">活动介绍：</td>
						<td class="td-input" id="voteIntroductionLabel">
							<div class="editor-box">
			                    <textarea id="voteIntroduction" name="voteIntroduction" rows="4" class="textareaBox" style="width: 510px;resize: none">${ vote.voteIntroduction}</textarea>
			                </div>
							<span class="error-msg"></span>
						</td>
					</tr>
					<tr id="voteRule1" class="voteRuleClass">
						<td width="100" class="td-title">活动规则1:</td>
						<td class="td-input leaveList" id="voteRuleLabel1">
							<div class="editor-box">
			                    <textarea id="voteRule" name="voteRule" rows="4" class="textareaBox" style="width: 510px;resize: none"><c:if test="${!empty vote.voteRule }">${fn:split(vote.voteRule, ",")[0]}</c:if></textarea>
			               		<div id="addleave" style="display: inline-block;width: 50px;height: 50px;vertical-align: top;text-align: center;font-size: 40px;">+</div>
			                </div>
							<span class="error-msg"></span>
						</td>
					</tr>
					<c:forEach items="${fn:split(vote.voteRule, ',')}" var="voteRule" varStatus="var" begin="1">
						<tr id="voteRule${var.index+1 }" class="voteRuleClass">
						<td width="100" class="td-title">活动规则${var.index+1 }:</td>
						<td class="td-input leaveList" id="voteRuleLabel${var.index+1 }">
							<div class="editor-box">
			                    <textarea id="voteRule" name="voteRule" rows="4" class="textareaBox" style="width: 510px;resize: none">${fn:split(vote.voteRule, ",")[var.index]}</textarea>
			                	 <div class='removeleave' style="display: inline-block;width: 50px;height: 50px;vertical-align: top;text-align: center;font-size: 40px;">-</div>
			                </div>
			               
							<span class="error-msg"></span>
						</td>
					</tr>
					</c:forEach>
					<tr></tr>
						<tr>
						<td width="150" class="td-title"><span class="red">*</span>投票设置：</td>
						<td class="td-input td-fees">
							<c:choose>
								<c:when test="${ vote.voteType ==2}">
									<label><input id="voteType1" type="radio" name="voteType" value="1"><em>每天只能投票一次</em></label>
									<label><input id="voteType2" type="radio" name="voteType" value="2" checked="checked"><em>该活动只能投票一次</em></label>
									<label><input id="voteType3" type="radio" name="voteType" value="3"><em>每个投票选项每天只能投一次</em></label>
								</c:when>
								<c:when test="${ vote.voteType ==3}">
									<label><input id="voteType1" type="radio" name="voteType" value="1"><em>每天只能投票一次</em></label>
									<label><input id="voteType2" type="radio" name="voteType" value="2"><em>该活动只能投票一次</em></label>
									<label><input id="voteType3" type="radio" name="voteType" value="3" checked="checked"><em>每个投票选项每天只能投一次</em></label>
								</c:when>
								<c:otherwise>
									<label><input id="voteType1" type="radio" name="voteType" value="1" checked="checked"><em>每天只能投票一次</em></label>
									<label><input id="voteType2" type="radio" name="voteType" value="2"><em>该活动只能投票一次</em></label>
									<label><input id="voteType3" type="radio" name="voteType" value="3"><em>每个投票选项每天只能投一次</em></label>
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
					
					<tr>
						<td width="150" class="td-title"><span class="red">*</span>是否需要填写个人信息：</td>
						<td class="td-input td-fees">
							<c:choose>
								<c:when test="${ vote.isUserInfo ==2}">
									<label><input id="isUserInfoNo" type="radio" name="isUserInfo" value="1" class="isUserInfo" ><em>否</em></label>
									<label><input id="isUserInfoYes" type="radio" name="isUserInfo" value="2" class="isUserInfo" checked="checked"><em>是</em></label>
								</c:when>
								<c:otherwise>
								<label><input id="isUserInfoNo" type="radio" name="isUserInfo" value="1" class="isUserInfo" checked="checked"><em>否</em></label>
								<label><input id="isUserInfoYes" type="radio" name="isUserInfo" value="2" class="isUserInfo" ><em>是</em></label>
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
					<tr>
						<td width="150" class="td-title"><span class="red">*</span>是否显示作者个人信息：</td>
						<td class="td-input td-fees">
							<c:choose>
								<c:when test="${ vote.isAuthorInfo ==2}">
									<label><input id="isAuthorInfoNo" type="radio" name="isAuthorInfo" value="1" class="isAuthorInfo" ><em>否</em></label>
									<label><input id="isAuthorInfoYes" type="radio" name="isAuthorInfo" value="2" class="isAuthorInfo" checked="checked"><em>是</em></label>
								</c:when>
								<c:otherwise>
								<label><input id="isAuthorInfoNo" type="radio" name="isAuthorInfo" value="1" class="isAuthorInfo" checked="checked"><em>否</em></label>
								<label><input id="isAuthorInfoYes" type="radio" name="isAuthorInfo" value="2" class="isAuthorInfo" ><em>是</em></label>
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
					
					<tr>
						<td width="150" class="td-title">分享封面图：</td>
						<td class="td-input" id="">
								<div id="uploadShareLogoImg">

								<c:choose>
										<c:when test="${!empty vote.shareLogoImg  }">
											<div name="aliFile" style="position:relative" ><span></span><b></b>
												<img onclick="aliRemoveImg(this)" class="aliRemoveBtn" src="../STATIC/image/removeBtn.png" style="position:absolute;left:80px;top:0;width:20px" />
												<img src="${vote.shareLogoImg}@300w" style="max-height: 100px;max-width: 100px;" />
												<br />
												 <input type="hidden" value="${vote.shareLogoImg }" name="shareLogoImg" id="shareLogoImg"/>
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
					<tr>
						<td width="150" class="td-title">分享标题：</td>
						<td class="td-input" id="shareTitleLabel">
							<input id="shareTitle" name="shareTitle" type="text" class="input-text w510" value='${vote.shareTitle }' />
							<span class="error-msg"></span>
						</td>
					</tr>
					<tr>
						<td width="150" class="td-title">分享描述：</td>
						<td class="td-input" id="shareDescribeLabel">
							<div class="editor-box">
			                    <textarea name="shareDescribe" rows="4" class="textareaBox" style="width: 510px;resize: none">${vote.shareDescribe }</textarea>
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
										<c:when test="${!empty vote.indexLogo   }">
											<div name="aliFile" style="position:relative" ><span></span><b></b>
												<img onclick="aliRemoveImg(this)" class="aliRemoveBtn" src="../STATIC/image/removeBtn.png" style="position:absolute;left:80px;top:0;width:20px" />
												<img src="${vote.indexLogo }@80w" style="max-height: 150px;max-width: 100px;" />
												<br />
												<input type="hidden" value="${vote.indexLogo }" name="logo" id="logo"/>
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
									 请上传大于50X40图片
			                    </div>
								</div>
							</div>
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
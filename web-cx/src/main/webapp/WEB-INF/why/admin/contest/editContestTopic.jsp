<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ page import="com.sun3d.why.enumeration.contest.CcpContestTopicIsLevelEnum"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

	<head>
		<title</title>
  		<%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
  		   <%@include file="/WEB-INF/why/common/limit.jsp"%>
	 <script type="text/javascript" src="${path}/STATIC/js/admin/contest/uploadLogo.js"></script>
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
			$("document").ready(function() {
				$(".radio").click(function() {
					if($("#yes").get(0).checked) {
						$(".leaveList").show()
					} else {
						$(".leaveList").hide()
					}
				})
			})

			function addleaveList() {
				//				$(".td-input").eq(leaveListnum).find("#addleave").hide()
				$(".leaveList").append(
					"<div class=\"td-input\">"+
					"<span>第</span><input type=\"text\" class=\"input-text w30 margin-left10\" name=\"passNumber\"/>" +
					"<span> 关后,称号:</span><input type=\"text\" class=\"input-text margin-left10\" name=\"passName\"/><div class='removeleave' style=\"display: inline-block;width: 50px;height: 50px;vertical-align: middle;text-align: center;font-size: 40px;\">-</div>" +
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
					appendMsg("topicNameLabel","请输入主题名称!");
					$("#topicName").focus();
					return false;
				}else if(topicName.length > 3){
					removeMsg("topicNameLabel");
					appendMsg("topicNameLabel","最多不超过3个字!");
					$("#topicName").focus();
				}
				else 
					removeMsg("topicNameLabel");
				
				
				var topicTitle = $("#topicTitle").val();
				
				if(topicTitle == undefined || $.trim(topicTitle) == ""){
					removeMsg("topicTitleLabel");
					appendMsg("topicTitleLabel","请输入副标题!");
					$("#topicTitle").focus();
					return false;
				}else if(topicTitle > 5){
					removeMsg("topicTitleLabel");
					appendMsg("topicTitleLabel","最多不超过5个字!");
					$("#topicTitle").focus();
					return false;
				}
				else 
					removeMsg("topicTitleLabel");
				
				var topicIcon=$("#topicIcon").val();
				
				if(topicIcon)
	        	{
	        		removeMsg("topicIconLabel");
	        	}
	        	else
	        	{
	        		appendMsg("topicIconLabel","请上传图片LOGO!");
	        		return false;
	        	}
				
				var reg=/^[1-9]([0-9]*)$/;
				
				var passNameArray=$("input[name='passName']");
				
				var result=true;
				
				if($("#yes").get(0).checked) 
				$("input[name='passNumber']").each(function (index,element) {
					
					var passName=passNameArray[index].value;
					var passNumber=element.value;
					
					if(passNumber == undefined || $.trim(passNumber) == ""){
						removeMsg("passLabel");
						appendMsg("passLabel","请填写关卡号!");
						$("#passLabel").focus();
						result=false;
						return false;
					}
					else if(passName || passNumber)
					{
						if(!reg.test(passNumber)){
							
							removeMsg("passLabel");
							appendMsg("passLabel","关卡必须为数字!");
							$("#passLabel").focus();
							result=false;
							return false;
						} 
						if(!passName)
						{
							removeMsg("passLabel");
							appendMsg("passLabel","请输入过关称号!");
							$("#passLabel").focus();
							result=false;
							return false;
						}else if(passName.length > 6){
							removeMsg("passLabel");
							appendMsg("passLabel","过关称号最多不超过6个字!");
							$("#passLabel").focus();
							result=false;
							return false;
						}
					}
				});
				if(result)
				{
					removeMsg("passLabel");
					
					var passNameTopic = $("#passNameTopic").val();
					
					if(passNameTopic == undefined || $.trim(passNameTopic) == ""){
						removeMsg("passNameLabel");
						appendMsg("passNameLabel","请输入通过称号!");
						$("#passName").focus();
						return false;
					}else if(passNameTopic.length > 4){
						removeMsg("passNameLabel");
						appendMsg("passNameLabel","最多不超过4个字!");
						$("#passNameTopic").focus();
						return false;
					}
					else 
						removeMsg("passNameLabel");
					
					var passText = $("#passText").val();
					
					if(passText == undefined || $.trim(passText) == ""){
						removeMsg("passTextLabel");
						appendMsg("passTextLabel","请输入通过文案!");
						$("#passText").focus();
						return false;
					}
					else 
						removeMsg("passTextLabel");
				}
				else
					return result;
				
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
		        		$.post("${path}/contestTopic/addContestTopic.do",$("#topicForm").serializeArray(),function(result) {
		        			   
		        			if(result=='user')
		        			{
		        				alert("请先登录！")
		        				window.location.href = "${path}/login.do";
		        			}
		        			else if(result=='success')
		        			{
		        				alert("修改成功！")
		        				window.location.href = "${path}/contestTopic/contestTopicIndex.do";
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
	<c:set var="isLevelupYes" value="<%=CcpContestTopicIsLevelEnum.IS_LEVELUP_YES.getValue()%>" scope="request"> </c:set>
		<div class="site">
			<em>您现在所在的位置：</em>运维管理  &gt; 文化竞赛&gt; 修改主题
		</div>
		<div class="site-title">新建主题页</div>
			
		<form method="post" id="topicForm">
		<input type="hidden" id="topicId" name="topicId" value="${contestTopic.topicId }"/>
		 <input type="hidden" id="userCounty" name="userCounty" value="${sessionScope.user.userCounty}">
			<div class="main-publish">
				<table width="100%" class="form-table">
					<tr>
						<td width="100" class="td-title"><span class="red">*</span>主题名称：</td>
						<td class="td-input" id="topicNameLabel">
							<input id="topicName" name="topicName" type="text" class="input-text w510" value='${contestTopic.topicName }' maxlength="3" />
							<span class="error-msg"></span>
						</td>
					</tr>
					<tr>
						<td width="100" class="td-title"><span class="red">*</span>副标题：</td>
						<td class="td-input" id="topicTitleLabel">
							<input id="topicTitle" name="topicTitle" type="text" class="input-text w510" maxlength="7" value='${contestTopic.topicTitle }' maxlength="5" />
							<span class="error-msg"></span>
						</td>
					</tr>
					<tr>
						<td width="100" class="td-title"><span class="red">*</span>上传LOGO：</td>
						<td class="td-upload" id="pictureLabel">
							<table>
								<tr>
									<td>
										<input type="hidden" name="topicIcon" id="topicIcon" value="${contestTopic.topicIcon }">
										<input type="hidden" name="uploadType" value="Img" id="uploadType" />
										<div class="img-box">
											<div id="imgHeadPrev" class="img"> </div>
										</div>
										<div class="controls-box">
											<div style="height: 46px;">
												<div class="controls" style="float:left;">
													<input type="file" name="file" id="file">
												</div>

												<span class="upload-tip">可上传1张图片，格式为jpg,jpeg,png,gif，大小不超过2M</span>
											</div>
											<div id="fileContainer"></div>
											<div id="btnContainer" style="display: none;">
												<a style="margin-left:335px;" href="javascript:clearQueue();" class="btn">取消</a>
											</div>
										</div>
									</td>
									<td class="td-input" id="topicIconLabel"></td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td width="100" class="td-title"><span class="red">*</span>升级设置：</td>
						<td class="td-input td-fees">
						
						<c:choose>
							<c:when test="${contestTopic.isLevelup==isLevelupYes }">
								<label><input type="radio" id="yes" name="isLevelup" value="<%=CcpContestTopicIsLevelEnum.IS_LEVELUP_YES.getValue() %>" class="radio"  checked="checked"><em>是</em></label>
								<label><input type="radio" id="no" name="isLevelup" value="<%=CcpContestTopicIsLevelEnum.IS_LEVELUP_NO.getValue() %>" class="radio"><em>否</em></label>
							</c:when>
							<c:otherwise>
								<label><input type="radio" id="yes" name="isLevelup" value="<%=CcpContestTopicIsLevelEnum.IS_LEVELUP_YES.getValue() %>" class="radio" ><em>是</em></label>
								<label><input type="radio" id="no" name="isLevelup" value="<%=CcpContestTopicIsLevelEnum.IS_LEVELUP_NO.getValue() %>" class="radio"  checked="checked"><em>否</em></label>
							</c:otherwise>
						</c:choose>
							
						</td>
					</tr>
					<tr>
						<td></td>
						<td class="td-input" id="passLabel">
							<c:choose>
							<c:when test="${contestTopic.isLevelup==isLevelupYes }">
							<div class="leaveList">
							<c:choose>
								<c:when test="${empty passList }">
								<div class="td-input">
									<span>第</span><input type="text" name="passNumber" class="input-text w30 margin-left10" />
									<span>关后,称号:</span><input type="text" name="passName" class="input-text margin-left10" /><div id="addleave" style="display: inline-block;width: 50px;height: 50px;vertical-align: middle;text-align: center;font-size: 40px;">+</div>
								</div>
								</c:when>
								<c:otherwise>
								<c:forEach items="${ passList}" var="pass" varStatus="varSta">
									<c:choose>
										<c:when test="${varSta.index==0 }">
										<div class="td-input">
											<span>第</span><input type="text" value="${ pass.passNumber}" name="passNumber" class="input-text w30 margin-left10" />
											<span>关后,称号:</span><input type="text" value="${ pass.passName}"  name="passName" class="input-text margin-left10" /><div id="addleave" style="display: inline-block;width: 50px;height: 50px;vertical-align: middle;text-align: center;font-size: 40px;">+</div>
										</div>
										</c:when>
										<c:otherwise>
										<div class="td-input">
										<span>第</span><input type="text" class="input-text w30 margin-left10" value="${ pass.passNumber}" name="passNumber"/>
										<span>关后,称号:</span><input type="text" class="input-text margin-left10" value="${ pass.passName}" name="passName"/><div class='removeleave' style="display: inline-block;width: 50px;height: 50px;vertical-align: middle;text-align: center;font-size: 40px;">-</div>
										</div>
										</c:otherwise>
									</c:choose>
								
								</c:forEach>
								
								</c:otherwise>
							</c:choose>
		
							</div>
							</c:when>
							<c:otherwise>
							<div class="leaveList" style="display: none;">

								<div class="td-input">
									<span>第</span><input type="text" name="passNumber" class="input-text w30 margin-left10" />
									<span>关后,称号:</span><input type="text" name="passName" class="input-text margin-left10" /><div id="addleave" style="display: inline-block;width: 50px;height: 50px;vertical-align: middle;text-align: center;font-size: 40px;">+</div>
								</div>

							</div>
							</c:otherwise>
							</c:choose>
						</td>
					</tr>
					<tr>
						<td width="100" class="td-title"><span class="red">*</span>通关称号：</td>
						<td class="td-input" id="passNameLabel">
							<input id="passNameTopic" name="passNameTopic"  type="text" class="input-text w510" value='${contestTopic.passName }' maxlength="15" />
							<span class="error-msg"></span>
						</td>
					</tr>
					<tr>
						<td width="100" class="td-title"><span class="red">*</span>通关文案：</td>
						<td class="td-input" id="passTextLabel">
							<input id="passText" name="passText" type="text" class="input-text w510" value='${contestTopic.passText }' />
							<span class="error-msg"></span>
						</td>
					</tr>
					<!--用来存放item-->
					<!--<tr>
						<td width="100" class="td-title"><span class="red">*</span>上传封面：</td>
						<td>
							<div id="uploader-demo">

								<div id="fileList" class="uploader-list">
									<div style="clear: both;"></div>
								</div>
								<div id="filePicker">选择图片</div>
							</div>
						</td>
					</tr>-->
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
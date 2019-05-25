<%@ page language="java" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%-- <%@ page import="com.sun3d.why.enumeration.contest.CcpexhibitionIsLevelEnum"%> --%>
<%@ page import="com.sun3d.why.enumeration.contest.CcpContestTopicIsLevelEnum"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
 <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<title</title> <%@include file="../../common/pageFrame.jsp"%>
	<%@include file="/WEB-INF/why/common/aliImageFrame.jsp"%>
	<link rel="stylesheet" type="text/css"
		href="${path}/STATIC/css/dialog-back.css" />
	<script type="text/javascript"
		src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
	<link rel="Stylesheet" type="text/css"
		href="${path}/STATIC/css/DialogBySHF.css" />
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
		  
		  function check(){
			  
				  
				
				/* 内页标题的校验 */
				var pageTitle = $("#pageTitle").val();
				
				if(pageTitle == undefined || $.trim(pageTitle) == ""){
					removeMsg("pageTitleLabel");
					appendMsg("pageTitleLabel","请输入页面抬头!");
					$("#pageTitle").focus();
					return false;
				}else if(pageTitle.length >=17){
					removeMsg("pageTitleLabel");
					appendMsg("pageTitleLabel","最多不超过16个汉字!");
					$("#pageTitle").focus();
					return false;
				}
				else 
					removeMsg("pageTitleLabel");
				   
				/* 主标题的校验 */
	               
				var result=true;
				$(".pageContent").each(function(i,n){
					var pageContent = n.value;
					
					if(pageContent == undefined || $.trim(pageContent) == ""){
						removeMsg("pageContentLabel"+(i+1));
						appendMsg("pageContentLabel"+(i+1),"请输入描述!");
						$("#pageContent").focus();
						result=false;
						return result;
					}else if(pageContent.length > 15){
						removeMsg("pageContentLabel"+(i+1));
						appendMsg("pageContentLabel"+(i+1),"最多不超过15个汉字!");
						$("#pageContent").focus();
						result=false;
						return result;
					}
					else 
						removeMsg("pageContentLabel"+(i+1));
					  
				  });
				    return result;
			}
			
		  $(function() {
				// 保存
              $(".btn-publish").click(function(){
					var c=check();
					
		        	if(c)
		        	{
		        		$.post("${path}/InsidePages/addCcpExhibitionPage.do",$("#exhibitionPageForm").serializeArray(),function(result) {
		        			   
		        			if(result=='user')
		        			{
		        				alert("请先登录！")
		        				window.location.href = "${path}/login.do";
		        			}
		        			else if(result=='success')
		        			{
		        				alert("保存成功！")
		        				window.location.href = "${path}/InsidePages/managerExhibitionPage.do?exhibitionId=${exhibitionId}";
		        			}
		        			else
		        				alert("添加失败，系统错误！")
		        		});
		        	}
			});
		});
	  
		
		
	</script>
</head>

<body>
	 
	<div class="site-title">版式</div>
	<form method="post" id="exhibitionPageForm">
		<div class="main-publish">
			<table width="100%" class="form-table">
				<tr>
					<td width="100" class="td-title"></span>标题:</td>
					<td class="td-input" id="pageTitleLabel"><input
						id="pageTitle" name="pageTitle" type="text"
						class="input-text w510" value='${exhibitionPage.pageTitle }'
						maxlength="25" /> <span>16个汉字以内</span></td>
				</tr>
				 <tr>
				 	<input type="hidden" value="${exhibitionPage.pageId }" name="pageId" id="pageId"/>
				        <input type="hidden" value="${exhibitionId }" name="exhibitionId" id="exhibitionId"/>
				        <input type="hidden" value="${pageType }" name="pageType" id="pageType"/> 
						<td width="100" class="td-title">上传图片：</td>
						<td class="td-input" id="">
						
						       <c:forEach  begin="1" end="${pageType }" varStatus="sta">
								<div id="uploadpageImg${sta.index }">
								<c:choose>
										<c:when test="${!empty exhibitionPage.pageImg &&  !empty fn:split(exhibitionPage.pageImg, ',')[sta.index-1]}">
											<div name="aliFile" style="position:relative" ><span></span><b></b>
												<img onclick="aliRemoveImg(this)" class="aliRemoveBtn" src="../STATIC/image/removeBtn.png" style="position:absolute;left:80px;top:0;width:20px" />
												<img src="${fn:split(exhibitionPage.pageImg, ',')[sta.index-1]}@300w" style="max-height: 100px;max-width: 100px;" />
												<input type="hidden" value="${exhibitionPage.pageImg }" name="pageImg" id="pageImg"/>
												<input type="hidden" value="${fn:split(exhibitionPage.pageImg, ',')[sta.index-1]}" name="pageImg" id="pageImg"/>
												<br />
											</div>
										</c:when>
										<c:otherwise>
											<img  src="">
										</c:otherwise>
									</c:choose>
			                    
			                    <div id="ossfile2">你的浏览器不支持flash,Silverlight或者HTML5！</div>
			                    <div id="container2">
			                  		<a id="selectfiles2" href="javascript:void(0);" class='btn'>选择图片</a>
									<a id="postfiles2" href="javascript:void(0);" class='btn'>开始上传</a>
									<c:if test="${pageType==1}">
									请上传500*600图片
									</c:if>
									<c:if test="${pageType==2}">
									 请上传500*300图片
									</c:if>
									<c:if test="${pageType==4}">
									请上传240*280图片
									</c:if>
										<div width="100"></span>描述信息:</div>
										<div class="td-input" id="pageContentLabel${sta.index }">
										<input id="pageContent" name="pageContent" type="text"
										class="input-text w510 pageContent" value='${fn:split(exhibitionPage.pageContent, ',')[sta.index-1]}'
										maxlength="20" /> <span>15个汉字以内</span></div>
			                    </div>
								</div>
							<script>
								  aliUploadImg("uploadpageImg${sta.index }",uploadpageImgCallBack) 
								  function uploadpageImgCallBack(up, file, info){
										
										var ImgUrl = "${ImgUrl}" + info 
								    	
										$("#"+file.id).append('<input type="hidden" id="pageImg" name="pageImg" value="'+ImgUrl+'"/>')
									}
							</script>
							</c:forEach>
						</td>
					</tr>
					
				<tr>
					<td width="100" class="td-title"></td>
					<td class="td-btn"><input class="btn-save" type="button"
						onclick="javascript:window.history.go(-1);" value="返回" /> <input
						class="btn-publish" type="button" value="保存修改" /></td>
				</tr>
		</table>
		</div>
	</form> 

</body>


</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>标签管理</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    
    <script type="text/javascript" src="${path}/STATIC/js/admin/terminalUser/UploadTerminalUserIdPicFile.js"></script>
    <script type="text/javascript"
	src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
	<script type="text/javascript">
		seajs.use([ '${path}/STATIC/js/dialogBack/src/dialog-plus' ], function(
				dialog) {
			window.dialog = dialog;
		});
	</script>
    
    <script type="text/javascript">
   
      
        function savePerson(){
        	
        	var data= $("#form").serializeArray();
        	
        	var c=checkPerson();
        	
        	if(c)
        	{
        		sub(data);
        	}
        }
   
        
		function saveCompany(){
        	
        	var data= $("#form").serializeArray();
        	
        	var c=checkCompany();
        	
        	if(c)
        	{
        		sub(data);
        	}
        }
	 
		
		function saveTeam(){
			
			var data= $("#form").serializeArray();
        	
        	var c=checkTeam();
        	
        	if(c)
        	{
        		sub(data);
        	}
		}
        

        
        function sub(data){
        	
        	var tuserIsActiviey=$("#tuserIsActiviey").val();
        	
        	var userId=$("#userId").val();
        	
        	 $.post('${path}/teamUser/authDo.do',data,function(result){
        		 
        		 if(result>=0)
        		{
        			 if(userId)
        				 window.location.href = '${path}/teamUser/teamUserIndex.do?tuserIsActiviey='+tuserIsActiviey+'&userId='+userId;
        			else 
        				 window.location.href = '${path}/teamUser/teamUserIndex.do?tuserIsActiviey='+tuserIsActiviey;
        		}
        		 else
        			 alert("操作失败！系统错误")
        		 
        	 });
        }
        
        function checkPerson(){
        	
        	
        	return true
        }
        
        function checkCompany(){
        	
        	return true
        }
        
        function checkTeam(){
        	
        	return true;
        }

        // 团体类别
        function getTeamUserType(){
            $.post("${path}/sysdict/queryCode.do",{'dictCode' : 'TEAM_TYPE'},function(data) {
                if (data != '' && data != null) {
                    var list = eval(data);
                    var ulHtml = '';
                    var tuserTeamType= $('#tuserTeamType').val();
                    for (var i = 0; i < list.length; i++) {
                        var dict = list[i];
                        ulHtml += '<li data-option="'+dict.dictId+'">'
                        + dict.dictName + '</li>';
                        if (tuserTeamType != '' &&  tuserTeamType == dict.dictId) {
                            $('#tagTypeDiv').html(dict.dictName);
                        }
                    }
                    $('#tagTypeUl').html(ulHtml);
                }
            }).success(function(){

            });
            selectModel();
        }
        
    	 // 公司类别
        function getCompanyTeamUserType(){
            $.post("${path}/sysdict/queryCode.do",{'dictCode' : 'COMPANY_TYPE'},function(data) {
                if (data != '' && data != null) {
                    var list = eval(data);
                    var ulHtml = '';
                    var tuserTeamType= $('#tuserTeamType').val();
                    for (var i = 0; i < list.length; i++) {
                        var dict = list[i];
                        ulHtml += '<li data-option="'+dict.dictId+'">'
                        + dict.dictName + '</li>';
                        if (tuserTeamType != '' &&  tuserTeamType == dict.dictId) {
                            $('#tagTypeDiv').html(dict.dictName);
                        }
                    }
                    $('#tagTypeUl').html(ulHtml);
                }
            }).success(function(){

            });
            selectModel();
        }

        $(function(){
        	 $("body").on("click",".bigCheck",function(){
         		var img_src = $(this).attr('src');
         		imgCheck(img_src);
         	})	
        });
    </script>
</head>

<body class="rbody">
<form action="" id="form">
<div class="site">
    <em>您现在所在的位置：</em> 使用者列表
</div> 

	<div class="site-title">使用者编辑</div>
	
<input type="hidden" id="userId" name="userId" value="${userId }">
<input type="hidden" id="tuserIsActiviey" name="tuserIsActiviey" value="${teamUser.tuserIsActiviey }">
<input type="hidden" id="tuserId" name="tuserId" value="${teamUser.tuserId }">
<input type="hidden" id="roomOrderId" name="roomOrderId" value="${roomOrderId }">
<input type="hidden" id="sessionId" value="${pageContext.session.id}"/>
<input type="hidden" id="userCounty" value="${sessionScope.user.userCounty}" />
  <input type="hidden" id="applyId" name="applyId" value="${teamUser.applyId}">
	<input type="hidden" id="isCutImg" value="N"/>
	<c:choose>
		<c:when test="${teamUser.tuserUserType==0 }">
		
			<!-- 社团 -->
<div id="content">
    <div class="content">
        <div class="con-box-blp">
            <form id="tag_form" action="" method="post">
                <div class="con-box-tlp">
                    <div class="form-box">
                        <table class="form-table">
                            <tbody>
                          <tr>
				                <td width="100" class="td-title">社团名称：</td>
				                <td class="td-input" id="tuserNameLabel"><input type="text" id="tuserName" value="${teamUser.tuserName}" name="tuserName" class="input-text w510" maxlength="50"/></td>
				            </tr>
				             <tr>
				                <td class="td-title">成立年限：</td>
				                <td class="td-input" id="tuserYearLabel">
				                    <input type="text" value="${teamUser.tuserYear}" name="tuserYear" id="tuserYear" class="input-text w210" maxlength="11" onkeyup="this.value=this.value.replace(/\D/g,'')"/>
				                </td>
				            </tr>
							 <tr>
				                <td class="td-title">社团上限：</td>
				                <td class="td-input" id="tuserLimitLabel">
				                    <input type="text" value="${teamUser.tuserLimit}" name="tuserLimit" id="tuserLimit" class="input-text w210" maxlength="11" onkeyup="this.value=this.value.replace(/\D/g,'')"/>
				                </td>
				            </tr>
							  <tr>
					                <td class="td-title">团体类别：<input type="text" id="tuserTeamTypeLimit" style="position: absolute; left: -9999px;" /></td>
					                <td class="td-select" id="tuserTeamTypeLabel">
					                    <div class="select-box w140">
					                        <input type="hidden" name="tuserTeamType" id="tuserTeamType" value="${teamUser.tuserTeamType}"/>
					                        <div class="select-text" data-value="" id="tagTypeDiv">所有类别</div>
					                        <ul class="select-option" id="tagTypeUl">
					                        </ul>
					                    </div>
					                </td>
					            </tr>
					         <c:if test="${!empty teamUserDetailPics }">
					<tr>
						<td class="td-title">图片资料展示：</td>
					       <td class="td-upload">
					       <c:forEach items="${ teamUserDetailPics}" var="teamUserDetailPic" varStatus="index">
					       <table>
						<tr>
							<td>
								<input type="hidden"  name="teamUserDetailPics" id="teamUserDetailPicImgUrl${index.index }" value="${teamUserDetailPic.url }">
								<input type="hidden" name="uploadType" value="Img" id="uploadType"/>

								<div class="img-box">
									<div  id="imgteamUserDetailPicImgPrev${index.index }" class="img"> </div>
								</div>
							</td>
							<td class="td-input" id="teamUserDetailPicImgUrl${index.index }Label"></td>
							
							<script type="text/javascript">
					
							$(function(){
								//初始化获取图片
								var imgUrl=$("#teamUserDetailPicImgUrl${index.index }").val();
								
								if(imgUrl){
									if(imgUrl.indexOf("http")!=-1){
										$("#imgteamUserDetailPicImgPrev${index.index }").html("<img style='width:300px; height:200px;' class='bigCheck' src='"+imgUrl+"'>");
									}else{
										imgUrl = getImgUrl(imgUrl);
										imgUrl = getIndexImgUrl(imgUrl,"_300_300");
										$("#imgteamUserDetailPicImgPrev${index.index }").html("<img style='width:300px; height:200px;' class='bigCheck' src='"+imgUrl+"'>");
									}
								}else{
									$("#imgteamUserDetailPicImgPrev${index.index }").html("<img src='../STATIC/image/defaultImg.png' id='userHeadImg'>");
								}
							});
							//-->
							</script>
						</tr>
					</table>
					       </c:forEach>
					       </td>
					 </tr>
					 
				 </c:if>   
				  <tr>
        	<td width="150px" class="td-title">操作日志：</td>
								  <td class="td-input">
									 <div class="editor-box">
										<c:if test="${!empty logList }">
											<table>
												<thead>
													<th>日期</th>
													<th>操作人</th>
													<th>操作人角色</th>
													<th>说明</th>
												</thead>
												
												<c:forEach items="${logList }" var="log">
													<tr>
														<td><fmt:formatDate value="${log.createTime }"
														pattern="yyyy/MM/dd HH:mm:ss" /></td>
														<td>${log.operatorUserName }</td>
														<td>
														<c:choose>
															<c:when test="${log.userType==1 }">
															管理员
															</c:when>
															<c:when test="${log.userType==2 }">
															普通用户
															</c:when>
														</c:choose>
														</td>
														<th>${log.remark }</th>
													</tr>
												</c:forEach>	
										
											</table>
										</c:if>                 
									 </div>
								 </td>	               
					        </tr>	
							<tr>
				                <td width="150px" class="td-title">团体描述：</td>
				                <td class="td-input">
				                    <div class="editor-box">
				                        <textarea name="tuserTeamRemark" id="tuserTeamRemark"  rows="4" class="textareaBox" style="width: 500px;resize: none;text-align:left!important;">${teamUser.tuserTeamRemark}</textarea>
				                    </div>
				                </td>
				            </tr>
											
                            <tr class="td-btn" style="margin-top:15px;">
                                <td colspan="2">
                                
		                    	   <input type="button" value="保存" onclick="saveTeam()" class="btn-save"
                                                       style="margin-left: 155px;margin-top: 20px;"/>
                              
                            </tr>
                            </tbody>
                        </table>
                        
                        <script type="text/javascript">
				        $(function(){
				        	getTeamUserType();
				        });
				        </script>
			        </div>
                </div>
            </form>
        </div>
    </div>
</div>
		</c:when>
		<c:when test="${teamUser.tuserUserType==1}">
			<!-- 个人 -->
			
			<div id="content">
    <div class="content">
        <div class="con-box-blp">
            <form id="tag_form" action="" method="post">
                <div class="con-box-tlp">
                    <div class="form-box">
                        <table class="form-table">
                            <tbody>
                          <tr>
				                <td width="100" class="td-title">个人姓名：</td>
				                <td class="td-input" id="tuserNameLabel"><input type="text" id="tuserName" value="${teamUser.tuserName}" name="tuserName" class="input-text w510" maxlength="50"/></td>
				            </tr>
				             <tr>
				                <td class="td-title">头衔/职位：</td>
				                <td class="td-input" id="tuserTagLabel">
				                    <input type="text" value="${teamUser.tuserTag}" name="tuserTag" id="tuserTag" class="input-text w210" maxlength="11" onkeyup="this.value=this.value.replace(/\D/g,'')"/>
				                </td>
				            </tr>
				             <tr>
				                <td class="td-title">从业年限：</td>
				                <td class="td-input" id="tuserYearLabel">
				                    <input type="text" value="${teamUser.tuserYear}" name="tuserYear" id="tuserYear" class="input-text w210" maxlength="11" onkeyup="this.value=this.value.replace(/\D/g,'')"/>
				                </td>
				            </tr>
					            <c:if test="${!empty teamUserDetailPics }">
					<tr>
						<td class="td-title">图片资料展示：</td>
					       <td class="td-upload">
					       <c:forEach items="${ teamUserDetailPics}" var="teamUserDetailPic" varStatus="index">
					       <table>
						<tr>
							<td>
								<input type="hidden"  name="teamUserDetailPics" id="teamUserDetailPicImgUrl${index.index }" value="${teamUserDetailPic.url }">
								<input type="hidden" name="uploadType" value="Img" id="uploadType"/>

								<div class="img-box">
									<div  id="imgteamUserDetailPicImgPrev${index.index }" class="img"> </div>
								</div>
							</td>
							<td class="td-input" id="teamUserDetailPicImgUrl${index.index }Label"></td>
							
							<script type="text/javascript">
					
							$(function(){
								//初始化获取图片
								var imgUrl=$("#teamUserDetailPicImgUrl${index.index }").val();
								
								if(imgUrl){
									if(imgUrl.indexOf("http")!=-1){
										$("#imgteamUserDetailPicImgPrev${index.index }").html("<img style='width:300px; height:200px;' class='bigCheck' src='"+imgUrl+"'>");
									}else{
										imgUrl = getImgUrl(imgUrl);
										imgUrl = getIndexImgUrl(imgUrl,"_300_300");
										$("#imgteamUserDetailPicImgPrev${index.index }").html("<img style='width:300px; height:200px;' class='bigCheck' src='"+imgUrl+"'>");
									}
								}else{
									$("#imgteamUserDetailPicImgPrev${index.index }").html("<img src='../STATIC/image/defaultImg.png' id='userHeadImg'>");
								}
							});
							//-->
							</script>
						</tr>
					</table>
					       </c:forEach>
					       </td>
					 </tr>
					 
				 </c:if>
							<tr>
				                <td width="150px" class="td-title">个人简介：</td>
				                <td class="td-input">
				                    <div class="editor-box">
				                        <textarea name="tuserTeamRemark" id="tuserTeamRemark"  rows="4" class="textareaBox" style="width: 500px;resize: none">${teamUser.tuserTeamRemark}</textarea>
				                    </div>
				                </td>
				            </tr>
				            
				             <tr>
        	<td width="150px" class="td-title">操作日志：</td>
								  <td class="td-input">
									 <div class="editor-box">
										<c:if test="${!empty logList }">
											<table>
												<thead>
													<th>日期</th>
													<th>操作人</th>
													<th>操作人角色</th>
													<th>说明</th>
												</thead>
												
												<c:forEach items="${logList }" var="log">
													<tr>
														<td><fmt:formatDate value="${log.createTime }"
														pattern="yyyy/MM/dd HH:mm:ss" /></td>
														<td>${log.operatorUserName }</td>
														<td>
														<c:choose>
															<c:when test="${log.userType==1 }">
															管理员
															</c:when>
															<c:when test="${log.userType==2 }">
															普通用户
															</c:when>
														</c:choose>
														</td>
														<th>${log.remark }</th>
													</tr>
												</c:forEach>	
										
											</table>
										</c:if>                 
									 </div>
								 </td>	               
					        </tr>	
											
                            <tr class="td-btn" style="margin-top:15px;">
                                <td colspan="2">
		                    	   <input type="button" value="保存" onclick="savePerson()" class="btn-save"
                                                       style="margin-left: 155px;margin-top: 20px;"/>
                            </tr>
                            </tbody>
                        </table>
                        
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>
		</c:when>
		<c:when test="${teamUser.tuserUserType==2}">
			<!-- 公司 -->
					<div id="content">
    <div class="content">
        <div class="con-box-blp">
            <form id="tag_form" action="" method="post">
                <div class="con-box-tlp">
                    <div class="form-box">
                        <table class="form-table">
                            <tbody>
                          <tr>
				                <td width="100" class="td-title">公司名称：</td>
				                <td class="td-input" id="tuserNameLabel"><input type="text" id="tuserName" value="${teamUser.tuserName}" name="tuserName" class="input-text w510" maxlength="50"/></td>
				            </tr>
				             <tr>
				                <td class="td-title">主营业务：</td>
				                <td class="td-input" id="tuserTagLabel">
				                    <input type="text" value="${teamUser.tuserTag}" name="tuserTag" id="tuserTag" class="input-text w210" maxlength="11" onkeyup="this.value=this.value.replace(/\D/g,'')"/>
				                </td>
				            </tr>
				             <tr>
					                <td class="td-title">公司类别：<input type="text" id="tuserTeamTypeLimit" style="position: absolute; left: -9999px;" /></td>
					                <td class="td-select" id="tuserTeamTypeLabel">
					                    <div class="select-box w140">
					                        <input type="hidden" name="tuserTeamType" id="tuserTeamType" value="${teamUser.tuserTeamType}"/>
					                        <div class="select-text" data-value="" id="tagTypeDiv">所有类别</div>
					                        <ul class="select-option" id="tagTypeUl">
					                        </ul>
					                    </div>
					                </td>
					            </tr>
					            	<tr>
								<td class="td-title">公司营业执照：</td>
					            	<td class="td-upload">
					<table>
						<tr>
							<td>
								<input type="hidden"  name="tuserPicture" id="tuserPictureImgUrl" value="${teamUserDetailPic.url}">
								<input type="hidden" name="uploadType" value="Img" id="uploadType"/>

								<div class="img-box">
									<div  id="imgTuserPicturePrev" class="img"> </div>
								</div>
							</td>
							<td class="td-input" id="tuserPictureImgUrlLabel"></td>
							
							<script type="text/javascript">
					
							$(function(){
								//初始化获取图片
								var imgUrl=$("#tuserPictureImgUrl").val();
								
								if(imgUrl){
									if(imgUrl.indexOf("http")!=-1){
										$("#imgTuserPicturePrev").html("<img style='width:300px; height:200px;' class='bigCheck' src='"+imgUrl+"'>");
									}else{
										imgUrl = getImgUrl(imgUrl);
										imgUrl = getIndexImgUrl(imgUrl,"_300_300");
										$("#imgTuserPicturePrev").html("<img style='width:300px; height:200px;' class='bigCheck' src='"+imgUrl+"'>");
									}
								}else{
									$("#imgTuserPicturePrev").html("<img src='../STATIC/image/defaultImg.png' id='userHeadImg'>");
								}
							});
							//-->
							</script>
						</tr>
					</table>
				</td></tr>
				
				<c:if test="${!empty teamUserDetailPics }">
					<tr>
						<td class="td-title">图片资料展示：</td>
					       <td class="td-upload">
					       <c:forEach items="${ teamUserDetailPics}" var="teamUserDetailPic" varStatus="index">
					       <table>
						<tr>
							<td>
								<input type="hidden"  name="teamUserDetailPics" id="teamUserDetailPicImgUrl${index.index }" value="${teamUser.tuserPicture }">
								<input type="hidden" name="uploadType" value="Img" id="uploadType"/>

								<div class="img-box">
									<div  id="imgteamUserDetailPicImgPrev${index.index }" class="img"> </div>
								</div>
							</td>
							<td class="td-input" id="teamUserDetailPicImgUrl${index.index }Label"></td>
							
							<script type="text/javascript">
					
							$(function(){
								//初始化获取图片
								var imgUrl=$("#teamUserDetailPicImgUrl${index.index }").val();
								
								if(imgUrl){
									if(imgUrl.indexOf("http")!=-1){
										$("#imgteamUserDetailPicImgPrev${index.index }").html("<img style='width:300px; height:200px;' class='bigCheck' src='"+imgUrl+"'>");
									}else{
										imgUrl = getImgUrl(imgUrl);
										imgUrl = getIndexImgUrl(imgUrl,"_300_300");
										$("#imgteamUserDetailPicImgPrev${index.index }").html("<img style='width:300px; height:200px;' class='bigCheck' src='"+imgUrl+"'>");
									}
								}else{
									$("#imgteamUserDetailPicImgPrev${index.index }").html("<img src='../STATIC/image/defaultImg.png' id='userHeadImg'>");
								}
							});
							//-->
							</script>
						</tr>
					</table>
					       </c:forEach>
					       </td>
					 </tr>
					 
				 </c:if>
							<tr>
				                <td width="150px" class="td-title">公司简介：</td>
				                <td class="td-input">
				                    <div class="editor-box">
				                        <textarea name="tuserTeamRemark" id="tuserTeamRemark"  rows="4" class="textareaBox" style="width: 500px;resize: none">${teamUser.tuserTeamRemark}</textarea>
				                    </div>
				                </td>
				            </tr>
							
							 <tr>
        	<td width="150px" class="td-title">操作日志：</td>
								  <td class="td-input">
									 <div class="editor-box">
										<c:if test="${!empty logList }">
											<table>
												<thead>
													<th>日期</th>
													<th>操作人</th>
													<th>操作人角色</th>
													<th>说明</th>
												</thead>
												
												<c:forEach items="${logList }" var="log">
													<tr>
														<td><fmt:formatDate value="${log.createTime }"
														pattern="yyyy/MM/dd HH:mm:ss" /></td>
														<td>${log.operatorUserName }</td>
														<td>
														<c:choose>
															<c:when test="${log.userType==1 }">
															管理员
															</c:when>
															<c:when test="${log.userType==2 }">
															普通用户
															</c:when>
														</c:choose>
														</td>
														<th>${log.remark }</th>
													</tr>
												</c:forEach>	
										
											</table>
										</c:if>                 
									 </div>
								 </td>	               
					        </tr>					
											
                            <tr class="td-btn" style="margin-top:15px;">
                                <td colspan="2">
                                
                              
		                    	   <input type="button" value="保存" onclick="saveCompany()" class="btn-save"
                                                       style="margin-left: 155px;margin-top: 20px;"/>
		                      	
                              
                            </tr>
                            </tbody>
                        </table>
                          <script type="text/javascript">
				        $(function(){
				        	getCompanyTeamUserType();
				        });
				        </script>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>
		</c:when>
	</c:choose>

</form>
</body>
</html>
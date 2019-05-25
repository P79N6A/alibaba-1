<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:setLocale value="zh_CN"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/html">
<head>
    <title>查看使用者</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <script type="text/javascript" src="${path}/STATIC/js/admin/teamUser/UploadTeamUserImg.js"></script>

    <script type="text/javascript">
        $(function(){
            /*getTuserCrowdTag();*/
            getTuserPropertyTag();
            /*getTuserSiteTag();*/
            getTuserLocationDict();
        });

        /*// 人群标签
        function getTuserCrowdTag(){
            $.post("${path}/tag/getChildTagByType.do?code=TEAMUSER_CROWD", function(data) {
                var list = eval(data);
                var tagHtml = '';
                var tagIds = '${record.tuserCrowdTag}';
                var ids = '';
                if (tagIds.length > 0) {
                    ids = tagIds.substring(0, tagIds.length - 1).split(",");
                }
                for (var i = 0; i < list.length; i++) {
                    var obj = list[i];
                    var tagId = obj.tagId;
                    var tagName = obj.tagName;
                    var result = false;
                    if (ids != '') {
                        for (var j = 0; j <ids.length; j++) {
                            if (tagId == ids[j]) {
                                result = true;
                                break;
                            }
                        }
                    }
                    var cl = '';
                    if (result) {
                        cl = 'class="cur"';
                    }
                    tagHtml += '<a ' + cl +' style="cursor:text">' + tagName
                    + '</a>';
                }
                $("#teamUserCrowdLabel").html(tagHtml);
            });
        }*/

        // 属性标签
        function getTuserPropertyTag(){
            $.post("${path}/tag/getChildTagByType.do?code=TEAMUSER_PROPERTY", function(data) {
                var list = eval(data);
                var tagHtml = '';
                var tagIds = '${record.tuserPropertyTag}';
                var ids = '';
                if (tagIds.length > 0) {
                    ids = tagIds.substring(0, tagIds.length - 1).split(",");
                }
                for (var i = 0; i < list.length; i++) {
                    var obj = list[i];
                    var tagId = obj.tagId;
                    var tagName = obj.tagName;
                    var result = false;
                    if (ids != '') {
                        for (var j = 0; j <ids.length; j++) {
                            if (tagId == ids[j]) {
                                result = true;
                                break;
                            }
                        }
                    }
                    var cl = '';
                    if (result) {
                        cl = 'class="cur"';
                    }
                    tagHtml += '<a '+cl+' style="cursor:text">' + tagName
                    + '</a>';
                }
                $("#teamUserPropertyLabel").html(tagHtml);
            });
        }

        // 地点标签
        /*function getTuserSiteTag(){
            $.post("${path}/tag/getChildTagByType.do?code=TEAMUSER_SITE", function(data) {
                var list = eval(data);
                var tagHtml = '';
                var tagIds = '${record.tuserSiteTag}';
                var ids = '';
                if (tagIds.length > 0) {
                    ids = tagIds.substring(0, tagIds.length - 1).split(",");
                }
                for (var i = 0; i < list.length; i++) {
                    var obj = list[i];
                    var tagId = obj.tagId;
                    var tagName = obj.tagName;
                    var result = false;
                    if (ids != '') {
                        for (var j = 0; j <ids.length; j++) {
                            if (tagId == ids[j]) {
                                result = true;
                                break;
                            }
                        }
                    }
                    var cl = '';
                    if (result) {
                        cl = 'class="cur"';
                    }
                    tagHtml += '<a '+cl+' style="cursor:text">' + tagName
                    + '</a>';
                }
                $("#teamUserSiteLabel").html(tagHtml);
            });
        }*/

        // 商圈位置
        function getTuserLocationDict(){
            $.post("${path}/sysdict/queryChildSysDictByDictCode.do",{dictCode:'${fn:substringBefore(record.tuserCounty,',')}'}, function(data) {
                var list = eval(data);
                var dictHtml = '';
                var other = "";
                for (var i = 0; i < list.length; i++) {
                    var obj = list[i];
                    var dictId = obj.dictId;
                    var dictName = obj.dictName;
                    var cl = '';
                    if (dictId == '${record.tuserLocationDict}') {
                        cl = 'class="cur"';
                    }

                    if(dictName == "其他"){
                        other =  '<a '+cl+'style="cursor:text">' + dictName
                        + '</a>';
                    }else{
                        dictHtml += '<a '+cl+' style="cursor:text">' + dictName
                        + '</a>';
                    }
                }
                dictHtml += other;
                $("#teamUserLocationLabel").html(dictHtml);
            });
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
    </script>
</head>
<body>
<div class="site">
    <em>您现在所在的位置：</em>使用者列表 &gt; 查看
</div>
<div class="site-title">查看使用者</div>
<!-- 正中间panel -->
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
				                <td class="td-input" id="tuserNameLabel">${teamUser.tuserName}</td>
				            </tr>
				             <tr>
				                <td class="td-title">成立年限：</td>
				                <td class="td-input" id="tuserYearLabel">
				                   ${teamUser.tuserYear}
				                </td>
				            </tr>
							 <tr>
				                <td class="td-title">社团上限：</td>
				                <td class="td-input" id="tuserLimitLabel">
				                   ${teamUser.tuserLimit}
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
										$("#imgteamUserDetailPicImgPrev${index.index }").html("<img style='width:300px; height:200px;' src='"+imgUrl+"'>");
									}else{
										imgUrl = getImgUrl(imgUrl);
										imgUrl = getIndexImgUrl(imgUrl,"_300_300");
										$("#imgteamUserDetailPicImgPrev${index.index }").html("<img style='width:300px; height:200px;' src='"+imgUrl+"'>");
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
				                <td width="150px" class="td-title">团体描述：</td>
				                <td class="td-input">
				                    <div class="editor-box">
				                       
				                            ${teamUser.tuserTeamRemark}
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
                                
		                    	<input type="button" value="返回"  style="margin-left: 155px;margin-top: 20px;" class="btn-publish btn-cancel" onclick="javascript:history.back(-1)" />
                              
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
				                <td class="td-input" id="tuserNameLabel">${teamUser.tuserName}</td>
				            </tr>
				             <tr>
				                <td class="td-title">头衔/职位：</td>
				                <td class="td-input" id="tuserTagLabel">
				                    ${teamUser.tuserTag}
				                </td>
				            </tr>
				             <tr>
				                <td class="td-title">从业年限：</td>
				                <td class="td-input" id="tuserYearLabel">
				                    ${teamUser.tuserYear} 
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
										$("#imgteamUserDetailPicImgPrev${index.index }").html("<img style='width:300px; height:200px;' src='"+imgUrl+"'>");
									}else{
										imgUrl = getImgUrl(imgUrl);
										imgUrl = getIndexImgUrl(imgUrl,"_300_300");
										$("#imgteamUserDetailPicImgPrev${index.index }").html("<img style='width:300px; height:200px;' src='"+imgUrl+"'>");
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
				                            ${teamUser.tuserTeamRemark}
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
                           
                           <input type="button" value="返回" class="btn-publish btn-cancel"  style="margin-left: 155px;margin-top: 20px;" onclick="javascript:history.back(-1)" />
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
				                <td class="td-input" id="tuserNameLabel">${teamUser.tuserName}</td>
				            </tr>
				             <tr>
				                <td class="td-title">主营业务：</td>
				                <td class="td-input" id="tuserTagLabel">
				                    ${teamUser.tuserTag}
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
								<input type="hidden"  name="tuserPicture" id="tuserPictureImgUrl" value="${teamUser.tuserPicture }">
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
										$("#imgTuserPicturePrev").html("<img style='width:300px; height:200px;' src='"+imgUrl+"'>");
									}else{
										imgUrl = getImgUrl(imgUrl);
										imgUrl = getIndexImgUrl(imgUrl,"_300_300");
										$("#imgTuserPicturePrev").html("<img style='width:300px; height:200px;' src='"+imgUrl+"'>");
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
										$("#imgteamUserDetailPicImgPrev${index.index }").html("<img style='width:300px; height:200px;' src='"+imgUrl+"'>");
									}else{
										imgUrl = getImgUrl(imgUrl);
										imgUrl = getIndexImgUrl(imgUrl,"_300_300");
										$("#imgteamUserDetailPicImgPrev${index.index }").html("<img style='width:300px; height:200px;' src='"+imgUrl+"'>");
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
				                    <div class="editor-box">${teamUser.tuserTeamRemark}</div>
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
                                
                              
		                    	 <input type="button" value="返回"  style="margin-left: 155px;margin-top: 20px;" class="btn-publish btn-cancel" onclick="javascript:history.back(-1)" />
		                      	
                              
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

</body>
</html>

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
   
        function pass(){
        	
        	var c=check();
        	
        	var data= $("#form").serializeArray();
        	
        	if(c)
        	{
        		data.push({'name':'userType','value':2});
        		
        		sub(data);
        	}
        	
        }
        
        function save(){
        	
        	var data= $("#form").serializeArray();
        	
        	var c=check();
        	
        	if(c)
        	{
        		sub(data);
        	}
        }

        function refuse(){
        	
        	var userId=$("#userId").val();
        	
        	var roomOrderId=$("#roomOrderId").val();
        	
        	dialog(
    				{
    					url : '${path}/terminalUser/authRefuse.do?userId='+userId+'&roomOrderId='+roomOrderId,
    					title : '填写拒绝理由',
    					width : 520,
    					height : 240,
    					fixed : true

    				}).showModal();
    		return false;
        	
        	
        }
        
        function sub(data){
        	
        	var roomOrderId=$("#roomOrderId").val();
        	
        	var userIsDisable=$("#userIsDisable").val();
        	
        	var userId=$("#userId").val();
        	
        	 $.post('${path}/terminalUser/authDo.do',data,function(result){
        		 
        		 if(result>=0)
        		{
        		 	if(roomOrderId)
        				window.location.href = '${path}/cmsRoomOrder/roomOrderDetail.do?roomOrderId='+roomOrderId;
        			else if(userIsDisable)
        				window.location.href = '${path}/terminalUser/terminalUserIndex.do?userIsDisable='+userIsDisable;
        			else 
        			 	window.location.href = '${path}/cmsRoomOrder/roomOrderCheckIndex.do';
        			 
        		}
        		 
        	 });
        }
        
        function check(){
        	
        	var userNickName = $("#userNickName").val();
        	
        	var userTelephone=$("#userTelephone").val();
        	
        	var userEmail = $("#userEmail").val();
        	
        	var userCardNo = $("#userCardNo").val();
        	
        	var headImgUrl=$("#headImgUrl").val();
        	
        	
        	if(userNickName == undefined || $.trim(userNickName) == ""){
				removeMsg("userNickNameLabel");
				appendMsg("userNickNameLabel","请输入真实姓名!");
				$("#userNickName").focus();
				return false;
			}else{
				removeMsg("userNickNameLabel");
				
				if(userCardNo == undefined || $.trim(userCardNo) == ""){
					removeMsg("userCardNoLabel");
					appendMsg("userCardNoLabel","请输入身份证号!");
					$("#userCardNo").focus();
					return false;
				}else{
					var reg = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/;
					if(reg.test(userCardNo) == false){
						removeMsg("userCardNoLabel");
						appendMsg("userCardNoLabel","身份证输入不合法!");
						$("#userCardNo").focus();
						return  false;
					}else{
						removeMsg("userCardNoLabel");
					}
				}
				
				var isMobile=/^(?:13\d|15\d|18\d|17\d)\d{5}(\d{3}|\*{3})$/; //手机号码验证规则

              if(userTelephone != '' && !isMobile.test(userTelephone)){ 
                  removeMsg("userTelephoneLable");
                  appendMsg("userTelephoneLable","手机格式不正确");
                  $("#userTelephone").focus();
                 return false;       //返回一个错误，不向下执行
             }else{
					removeMsg("userTelephoneLable");
				}
				
				// 电子邮箱
				if($.trim(userEmail).length > 0){
					if(!is_email(userEmail)){
						removeMsg("userEmailLabel");
						appendMsg("userEmailLabel","电子邮箱格式不正确!");
						$("#userEmail").focus();
						return false;
					}else{
						removeMsg("userEmailLabel");
					}
				}else{
					removeMsg("userEmailLabel");
				}
       		 }
        	
        	if(headImgUrl)
        	{
        		removeMsg("headImgUrlLabel");
        	}
        	else
        	{
        		appendMsg("headImgUrlLabel","请上传身份证照片!");
        		return false;
        	}
        	
        	return true
        }

    </script>
</head>

<body class="rbody">
<form action="" id="form">
<div class="site">
    <em>您现在所在的位置：</em> 活动室订单管理 &gt; 待审核
</div> 
<div class="site-title">实名认证</div>
<input type="hidden" id="userId" name="userId" value="${user.userId}"/>
<input type="hidden" id="roomOrderId" name="roomOrderId" value="${roomOrderId }">
<input type="hidden" id="sessionId" value="${pageContext.session.id}"/>
<input type="hidden" id="userCounty" value="${sessionScope.user.userCounty}" />
<input type="hidden" id="userIsDisable" value="${userIsDisable }"/>
  	<input type="hidden" id="isCutImg" value="N"/>
<!-- 正中间panel -->
<div id="content">
    <div class="content">
        <div class="con-box-blp">
            <form id="tag_form" action="" method="post">
                <div class="con-box-tlp">
                    <div class="form-box">
                        <table class="form-table">
                            <tbody>
                         <tr>
							<td width="100" class="td-title">用户名：</td>
							<td class="td-input" id="userNameLabel">
								${user.userName}
							</td>
						</tr>
							<tr>
								<td class="td-title"><span id="userNickNameSpan"></span>姓名：</td>
								<td class="td-input" id="userNickNameLabel"><input type="text" value="${user.userNickName }" id="userNickName" name="userNickName" class="input-text w210" maxlength="25"/></td>
							</tr>
							<tr>
								<td class="td-title">手机号码：</td>
								<td class="td-input" id="userTelephoneLable"><input type="text" value="${user.userTelephone}" name="userTelephone" id="userTelephone" class="input-text w210" maxlength="100"/> </td>
							</tr>	
							<tr>
								<td class="td-title">邮箱：</td>
								<td class="td-input" id="userEmailLabel"><input type="text" value="${user.userEmail }" name="userEmail" id="userEmail" class="input-text w210" maxlength="100"/></td>
							</tr>
							<tr>
								<td class="td-title">身份证号：</td>
								<td class="td-input" id="userCardNoLabel"><input type="text" value="${user.userCardNo }" name="userCardNo" id="userCardNo" class="input-text w210" maxlength="18"/></td>
							</tr>
							<tr>
								<td class="td-title">身份证照片：</td>
				<td class="td-upload">
					<table>
						<tr>
							<td>
								<input type="hidden"  name="idCardPhotoUrl" id="headImgUrl" value="${user.idCardPhotoUrl }">
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
										<span class="upload-tip">可上传1张图片，建议尺寸750*500像素，格式为jpg,jpeg,png,gif，大小不超过2M</span>
									</div>
									<div id="fileContainer"></div>
									<div id="btnContainer" style="display: none;">
										<a style="margin-left:335px;" href="javascript:clearQueue();" class="btn">取消</a>
									</div>
								</div>
							</td>
							<td class="td-input" id="headImgUrlLabel"></td>
						</tr>
					</table>
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
                                
                               <c:choose>
								<c:when test="${user.userType==1||user.userType==2||user.userType==4 }">
		                    	
		                    	   <input type="button" value="保存" onclick="save()" class="btn-save"
                                                       style="margin-left: 155px;margin-top: 20px;"/>
		                      	</c:when>
								<c:when test="${user.userType==3 }">
		                    	 
		                    	   <input type="button" value="通过" onclick="pass()" class="btn-save"
                                                       style="margin-left: 155px;margin-top: 20px;"/>
                                                       
                                 <input type="button" value="拒绝" onclick="refuse()" class="btn-publish btn-cancel"/></td>
		                      </c:when>
									
								</c:choose>
                                
                              
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>
</form>
</body>
</html>
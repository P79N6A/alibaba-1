<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:setLocale value="zh_CN"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/html">
<head>
    <title>查看订单</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
     <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
     
    <script type="text/javascript">
    
    seajs.use([ '${path}/STATIC/js/dialogBack/src/dialog-plus' ], function(
			dialog) {
		window.dialog = dialog;
	});
    
    	function userAuth(){
    		
    		var userId=$("#userId").val();
    		
    		var roomOrderId=$("#roomOrderId").val();
    		
    		 window.location.href="${path}/terminalUser/authInfo.do?userId="+userId+"&roomOrderId="+roomOrderId;
    	
    	}
    	
    	function teamUserAuth(){
    		
    		
    		var tuserId=$("#tuserId").val();
    		
    		var roomOrderId=$("#roomOrderId").val();
    		
    		window.location.href="${path}/teamUser/authTeamUserInfo.do?tuserId="+tuserId+"&roomOrderId="+roomOrderId;
    	}
    	
    	  function refuse(){
          	
          	var roomOrderId=$("#roomOrderId").val();
          	
          	dialog(
      				{
      					url : '${path}/cmsRoomOrder/refuse.do?roomOrderId='+roomOrderId,
      					title : '填写拒绝理由',
      					width : 520,
      					height : 240,
      					fixed : true

      				}).showModal();
      		return false;
          	
          }
          
    	 function pass(){
    		 
    		 var html = "您确定审核通过该订单吗？";
	         dialogConfirm("提示", html, function(){
    		 
    			var roomOrderId=$("#roomOrderId");
    			
    			var data= $("#form").serializeArray();
            	
            	 $.post('${path}/cmsRoomOrder/checkPass.do',data,function(result){
            		 
            		 if(result>=0)
            		{
            			 window.location.href = '${path}/cmsRoomOrder/roomOrderCheckIndex.do';
            		}
            		else if(result==-1)
            		{
            			alert("审核失败，场次已被预定！")
            		}
            		 else 
            			alert("审核失败，系统错误！")
            		 
            	 });
	         });
    	 }
    	 
    	 function save(){
    		 
    		var data= $("#form").serializeArray();
    		
    		var userName=$("#userName").val();
    		
    		var userTel=$("#userTel").val();
    		
    		if(userName == undefined || $.trim(userName) == ""){
				removeMsg("userNameLabel");
				appendMsg("userNameLabel","请输入联系人姓名!");
				$("#userName").focus();
				return false;
			}
    		
    		var re =(/^1[34578]\d{9}$/);
			// 手机号码
			if(userTel == undefined || $.trim(userTel) == ""){
				removeMsg("userTelLabel");
				appendMsg("userTelLabel","请输入联系人手机号码!");
				$("#userTel").focus();
				return false;
			}else if(!re.test(userTel)){
				removeMsg("userTelLabel");
				appendMsg("userTelLabel","请正确填写联系人手机号码!");
				$("#userTel").focus();
				return false;
			}else{
				removeMsg("userTelLabel");
			}
			
 			$.post('${path}/cmsRoomOrder/editRoomOrder.do',data,function(result){
        		 
        		 if(result>=0)
        		{
        			 window.location.href = '${path}/cmsRoomOrder/roomOrderIndex.do';
        		}
        		 
        	 });
    	 }
    	
    </script>
</head>
<body>
<form id="form">
<div class="site">
    <em>您现在所在的位置：</em> 活动室订单管理 &gt; 待审核
</div>
<div class="site-title">订单详情</div>
<!-- 正中间panel -->
<div class="main-publish">
<input type="hidden" value="${cmsRoomOrder.roomOrderId }" id="roomOrderId" name="roomOrderId"/>
<input type="hidden" value="${user.userId }" id="userId" name="userId"/>
<input type="hidden" value="${ cmsRoomOrder.tuserId }" id="tuserId" name="tuserId"/>
            <table class="form-table" width="100%">
                <tbody>
                	 		<tr>
                                <td width="150px" class="td-title">场馆名称：</td>
                                <td class="td-input" >
                                  <span >
                                     ${cmsVenue.venueName }
                                  </span>
                                </td>
                            </tr>
                            <tr>
                                <td width="150px" class="td-title">活动室名称：</td>
                                <td class="td-input" >
                                   <span > ${cmsActivityRoom.roomName} </span>
                                </td>
                            </tr>
                            <tr>
                                <td width="150px" class="td-title"><span class="td-prompt"></span>日期：</td>
                                <td  >
                                    <span > ${date}</span>
                                </td>
                            </tr>
                           <tr>
                                <td width="150px" class="td-title">场次：</td>
                                <td class="td-input" >
                                   <span > ${cmsRoomBook.openPeriod} </span>
                                </td>
                            </tr>
                            <tr>
                                <td width="150px" class="td-title">价格：</td>
                                <td class="td-input" >
                                 <span >
                                <c:choose>
                                	<c:when test="${cmsActivityRoom.getRoomIsFree()==1 }">
                                		免费
                                	</c:when>
                                	<c:otherwise>
                                		${cmsActivityRoom.roomFee }
                                	</c:otherwise>
                                </c:choose>
                           
                                  </span>
                                </td>
                            </tr>
                            <tr>
                                <td width="150px" class="td-title">场次：</td>
                                <td class="td-input" >
                                   <span > ${cmsRoomBook.openPeriod} </span>
                                </td>
                            </tr>
                            <tr>
                              <td width="150px" class="td-title">预订人：</td>
                                <td class="td-input" >
                                   <span > ${user.userNickName} </span>
                                   <c:choose>
									<c:when test="${user.userType==1 }">
									 <span style="padding-left: 100px;color: red;">
			                    		未提交
			                    	 </span>
			                      </c:when>
									<c:when test="${user.userType==2 }">
			                    	
			                    	 <span style="padding-left: 100px;color: red;">
			                    	 	 <a onclick="userAuth()" style="color: red;">已认证</a>
			                    	  </span>
			                    	 
			                      </c:when>
									<c:when test="${user.userType==3 }">
			                    	   
			                    	   <span style="padding-left: 100px;color: red;">
			                    		<a  onclick="userAuth()" style="color: red;"> 认证中</a>
			                    	  </span>
			                    	   
			                      </c:when>
									<c:when test="${user.userType==4 }">
									
			                    	   <span style="padding-left: 100px;">
			                    		<a onclick="userAuth()"  style="color: red;">认证不通过 </a>
			                    	  </span>
			                    	
			                      </c:when>
								</c:choose>
                                   
                                </td>
                            </tr>
                           <tr>
                              <td width="150px" class="td-title">预订人手机号：</td>
                                <td class="td-input" >
                                   <span>${user.userMobileNo}</span>
                                </td>
                            </tr>
                              
                            <tr>
								<td class="td-title">联系人：</td>
								<td class="td-input" id="userNameLabel"><input type="text" value="${cmsRoomOrder.userName }" name="userName" id="userName"class="input-text w210" maxlength="25"/></td>
							</tr>
                           <tr>
                              <td width="150px" class="td-title">联系人手机号：</td>
                                <td class="td-input" id="userTelLabel" >
                                   <span > 
                                   <input class="input-text w210"  type="text" name="userTel" id="userTel" value="${cmsRoomOrder.userTel}"/>
                                  
                                   </span>
                                </td>
                            </tr>
                            <tr>
                              <td width="150px" class="td-title">使用者：</td>
                                <td class="td-input" >
                                   <span > ${cmsRoomOrder.tuserName} </span>
                                   
                                   <c:choose>
									<c:when test="${empty cmsRoomOrder.tuserId }">
									<span style="padding-left: 100px;">
									
										<span style="color: red;">未认证</span>
									</span>
                    		
                    		</c:when>
									<c:when test="${teamUser.tuserIsDisplay==0}">
                    		  		<span style="padding-left: 100px;">
			                    		<a  onclick="teamUserAuth()"  style="color: red;"> 认证中</a>
			                    	  </span>
                    		</c:when>
									<c:when test="${teamUser.tuserIsDisplay==1}">
                    		 		<span style="padding-left: 100px;">
			                    	 	 <a onclick="teamUserAuth()"  style="color: red;">已认证</a>
			                    	  </span>
                    		</c:when>
									<c:when test="${teamUser.tuserIsDisplay==3}">
                    		 <span style="padding-left: 100px;">
			                    		<a onclick="teamUserAuth()"  style="color: red;">认证不通过 </a>
			                    	  </span>
                    		</c:when>
								</c:choose>
                                </td>
                            </tr>
                             <tr>
					            <td width="150px" class="td-title">备注：</td>
					            <td class="td-input">
					                <div class="editor-box">
					                    <textarea name="purpose" rows="4" class="textareaBox" style="width: 500px;resize: none" >${cmsRoomOrder.purpose }</textarea></div>
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
        <tr>
            <td width="100" class="td-title"></td>
            <td class="td-btn">
              <c:choose>
	              <c:when test="${cmsRoomOrder.bookStatus==0 }">
	              
	              <c:if test="${teamUser.tuserIsDisplay==1&&user.userType==2}">
	              
	                <input class="btn-save" onclick="pass()" type="button" value="通过"/>
	              
	              </c:if>
		            
	                <input class="btn-publish" onclick="refuse()" type="button" value="拒绝"/>
	                
	                </c:when>
	                <c:otherwise>
	                	
	                	<input type="button" value="保存" onclick="save()" class="btn-save"
                                                       style="margin-left: 155px;margin-top: 20px;"/>
	                </c:otherwise>
                </c:choose>
            </td>
        </tr>
                </tbody>
                        </table>
    </div>
</form>

</body>
</form>
</html>

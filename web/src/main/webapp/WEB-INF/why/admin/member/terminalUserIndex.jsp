<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>

	<title>文化云</title>
	<%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
	<%@include file="/WEB-INF/why/common/limit.jsp"%>
	 <script type="text/javascript"
	src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
	<script type="text/javascript">
		seajs.use([ '${path}/STATIC/js/dialogBack/src/dialog-plus' ], function(
				dialog) {
			window.dialog = dialog;
		});
	</script>

	<script type="text/javascript">
		$(function(){
			kkpager.generPageHtml({
				pno : '${page.page}',
				total : '${page.countPage}',
				totalRecords :  '${page.total}',
				mode : 'click',//默认值是link，可选link或者click
				click : function(n){
					this.selectPage(n);
					$("#page").val(n);
					doSearchUser('#terminalUserForm');
					return false;
				}
			});

			// 冻结
			freeTerminalUser();
			// 激活
			activeTerminalUser();
			// 禁止评论
			disableTerminalUser();
			//取消禁止评论
			cancelTerminalUser();
			// 所有区县
			
			
			$(".userId").click(function(){
				
				var result=false;
				
				 $("#list-table :checkbox").each(function () {
					  
					 var checked= $(this).prop("checked");
					 
					if(checked)
					{
						 result=true;
						 return false;
					}
				 }); 
				 
				 if(result){
					 $("#cloudBtn").prop("disabled", false);
				}
				 else{
					 $("#cloudBtn").prop("disabled", true);
				 }
			});
			
			selectModel();

		});

		function freeTerminalUser(){
			$(".active").on("click", function(){
				var userId = $(this).attr("userId");
				var name = $(this).parent().siblings(".title").find("a").text();
				var html = "您确定要冻结" + name + "吗？";
				dialogConfirm("提示", html, function(){
					$.post("${path}/terminalUser/freezeTerminalUser.do",{userId:userId},function(data) {
						if (data == 'success') {
							window.location.href="${path}/terminalUser/terminalUserIndex.do?userIsDisable="+$("#userIsDisable").val();
						}
					});
				})
			});
		}

		function activeTerminalUser(){
			$(".delete").on("click", function(){
				var userId = $(this).attr("userId");
				var name = $(this).parent().siblings(".title").find("a").text();
				var html = "您确定要激活" + name + "吗？";
				dialogConfirm("提示", html, function(){
					$.post("${path}/terminalUser/activeTerminalUser.do",{userId:userId},function(data) {
						if (data == 'success') {
							window.location.href="${path}/terminalUser/terminalUserIndex.do?userIsDisable="+$("#userIsDisable").val();
						}
					});
				})
			});
		}

		function disableTerminalUser(){
			$(".disable").on("click", function(){
				var userId = $(this).attr("userId");
				var name = $(this).parent().siblings(".title").find("a").text();
				var html = "您确定要禁止" + name + "评论吗？";
				dialogConfirm("提示", html, function(){
					$.post("${path}/terminalUser/disableTerminalUserComment.do",{userId:userId},function(data) {
						if (data == 'success') {
							window.location.href="${path}/terminalUser/terminalUserIndex.do?userIsDisable="+$("#userIsDisable").val();
						}
					});
				})
			});
		}

		function cancelTerminalUser(){
			$(".cancel").on("click", function(){
				var userId = $(this).attr("userId");
				var name = $(this).parent().siblings(".title").find("a").text();
				var html = "您确定要取消禁止" + name + "的评论吗？";
				dialogConfirm("提示", html, function(){
					$.post("${path}/terminalUser/cancelTerminalUserComment.do",{userId:userId},function(data) {
						if (data == 'success') {
							window.location.href="${path}/terminalUser/terminalUserIndex.do?userIsDisable="+$("#userIsDisable").val();
						}
					});
				})
			});
		}

		function doSearchUser(formName){
			if($("#userMobileNo").val() == "输入手机号码关键字"){
				$("#userMobileNo").val("");
			}
			$(formName).submit();
		}

		// 参数
		function getSearchParameter(){
			

			//禁止评论状态
			var commentStatus = $("#commentStatus").val();
			var commentStatusStr = '禁止评论状态';
			if(commentStatus == 1){
				commentStatusStr = '未禁止';
			}else if(commentStatus == 2){
				commentStatusStr = '已禁止';
			}
			$("#commentStatusDiv").html(commentStatusStr);

			$.post("${path}/terminalUser/queryExistTerminalUserArea.do",null,function(data){
				if(data != '' && data != null){
					var userArea = $('#userArea').val();
					var list = eval(data);
					var ulHtml = '<li data-option="">所有区县</li>';
					for(var i = 0;i<list.length;i++){
						var area = list[i];
						var areaId = area.substring(0,area.indexOf(","));
						var areaName = area.substring(area.indexOf(",")+1,area.length);
						ulHtml +='<li data-option="'+areaId+'">'+areaName+'</li>';
						if(userArea != '' && areaId == userArea){
							$('#userAreaDiv').html(areaName);
						}
					}
					$('#userAreaUl').html(ulHtml);
				}
			}).success(function(){
				selectModel();
			});
		}
		
		 //全选或全不选
        function selectActivityIds() {
			 
        	var checked=$("#checkAll").prop("checked");
        	
            $("#list-table :checkbox").each(function () {
            	
               if (checked) {
                    $(this).prop("checked", true);
                } else {
                    $(this).prop("checked", false);
               }
            });
            
            if(!checked){
            	$("#cloudBtn").prop("disabled", true);
            }
            else{
            	$("#cloudBtn").prop("disabled", false);
            }
        }
		 
		function cloudInt(){
			
			var ids="";
			
			$("#list-table :checkbox").each(function () {
				  
				var checked=$(this).prop("checked");
				
				if(checked)
					ids+=$(this).val()+",";
			  });
			
			if(ids.length>0)
			{
				ids = ids.substring(0, ids.length-1);
				
				dialog(
	    				{
	    					url : '${path}/userIntegral/cloudIntegral.do?userId='+ids,
	    					title : '云叔积分',
	    					width : 520,
	    					height : 360,
	    					fixed : true

	    				}).showModal();
	    		return false;
			}
		}
			
	</script>
</head>
<body>

<div class="site">
	<em>您现在所在的位置：</em>会员管理 &gt;用户管理 &gt; <c:choose><c:when test="${user.userIsDisable == 1}">用户列表</c:when><c:otherwise>待激活</c:otherwise></c:choose>
</div>
<form action="${path}/terminalUser/terminalUserIndex.do" id="terminalUserForm" method="post">
	<input type="hidden" value="${user.userIsDisable}" name="userIsDisable" id="userIsDisable"/>
	<div class="search">
		<div class="search-box">
			<i></i><input class="input-text" data-val="输入手机号码关键字" name="userMobileNo" value="<c:if test="${not empty user.userMobileNo}">${user.userMobileNo}</c:if><c:if test="${empty user.userMobileNo}">输入手机号码关键字</c:if>" type="text" id="userMobileNo"/>
		</div>
		<div class="select-box w135">
				<input type="hidden" id="userType" name="userType"
					value="${user.userType}" />
				<div id="userTypeDiv" class="select-text" data-value="">
					<c:choose>
						<c:when test="${user.userType==1 }">
	              	未提交
	            </c:when>
						<c:when test="${user.userType==2 }">
	               	已认证
	            </c:when>
						<c:when test="${user.userType==3 }">
	                                                认证中
	            </c:when>
						<c:when test="${user.userType==4 }">
	               	  认证不通过
	            </c:when>
						<c:otherwise>
           		   实名认证状态
				</c:otherwise>
					</c:choose>
				</div>
				<ul class="select-option">
					<li data-option="">实名认证状态</li>
					<li data-option="1">未提交</li>
					<li data-option="2">已认证</li>
					<li data-option="3">认证中</li>
					<li data-option="4">认证不通过</li>
				</ul>
			</div>

		<div class="select-box w135">
			<input type="hidden" id="commentStatus" name="commentStatus" value="${user.commentStatus}"/>
			<div class="select-text" id="commentStatusDiv" data-value="">禁止评论状态</div>
			<ul class="select-option">
				<li data-option="">禁止评论状态</li>
				<li data-option="2">已禁止</li>
				<li data-option="1">未禁止</li>
			</ul>
		</div>
		<div class="select-box w135" style="display: none">
			<input type="hidden" id="userArea" name="userArea" value="${user.userArea}"/>
			<div class="select-text" data-value="" id="userAreaDiv">所有区县</div>
			<ul class="select-option" id="userAreaUl">
			</ul>
		</div>
		<div class="select-btn">
			<input type="button" value="搜索" onclick="$('#page').val(1);doSearchUser('#terminalUserForm')"/>
		</div>
		<div style="clear: both"></div>
		
		<%--<div class="form-table" style="float: left;width:480px">
			<p style="float: left; line-height: 42px">批量操作：</p>
		<div class="select-btn">
					<input type="button"
					onclick="cloudInt();" id="cloudBtn" disabled="true" value="云叔积分" />
					</div>			
		</div>--%>
	</div>
	<div class="main-content">
		<table width="100%">
			<thead>
			<tr>
				<th ><input type="checkbox" name="checkAll" id="checkAll" onclick="selectActivityIds()" />全选 </th>
				<th class="title">用户名</th>
				<%--<th>所属站点</th>--%>
				<th>姓名</th>
				<th>手机号码</th>
				<th>邮箱</th>
				<th>积分</th>
				<c:if test="${user.userIsDisable == 1}">
				<th>禁止评论状态</th>
				</c:if>
				<th>实名认证状态</th>
				<th>操作</th>
			</tr>
			</thead>
			<tbody id="list-table">
			<%int i=0;%>
			<c:if test="${null != userList}">
				<c:forEach items="${userList}" var="dataList" varStatus="status">
					<%i++;%>
					<tr>
						
						<td><input type="checkbox" class="userId" name="userId"  value="${dataList.userId}" /></td>
						<c:choose>
							<c:when test="${not empty dataList.userName}">
								<td class="title"><a href="${path}/terminalUser/viewTerminalUser.do?userId=${dataList.userId}" target="main">${dataList.userName}</a></td>
							</c:when>
							<c:otherwise>
								<td class="title"><a href="javascript:;"></a></td>
							</c:otherwise>
						</c:choose>
						<td>${dataList.userNickName}</td>
						<%--<c:choose>--%>
							<%--<c:when test="${not empty dataList.userArea}">--%>
								<%--<td>${fn:substringAfter(dataList.userArea, ',')}</td>--%>
							<%--</c:when>--%>
							<%--<c:otherwise>--%>
								<%--<td></td>--%>
							<%--</c:otherwise>--%>
						<%--</c:choose>--%>
						<td>
							${ dataList.userMobileNo}
						</td>
						<td>${dataList.userEmail}</td>	
						<td><a href="${path}/userIntegral/userIntegralIndex.do?userId=${dataList.userId}" target="main">${dataList.integralNow}</a></td>
					<c:if test="${user.userIsDisable == 1}">
							<td>
								<c:choose>
									<c:when test="${dataList.commentStatus == 1}">
										未禁止
									</c:when>
									<c:when test="${dataList.commentStatus == 2}">
										已禁止
									</c:when>
								</c:choose>
							</td>
						</c:if>
					
					
						<c:choose>	
							<c:when test="${not empty dataList.userType}">
								<td>
									<c:if test="${dataList.userType == 1}">未提交</c:if>
									<c:if test="${dataList.userType == 2}">
										<a href="${path}/terminalUser/authInfo.do?userId=${dataList.userId}&userIsDisable=${user.userIsDisable }" style="color: red;">已认证</a>
									</c:if>
									<c:if test="${dataList.userType == 3}">认证中</c:if>
									<c:if test="${dataList.userType == 4}">未通过</c:if>
								</td>
							</c:when>
							<c:otherwise>
								<td></td>
							</c:otherwise>
						</c:choose>
						
						
						<td>
							<c:if test="${user.userIsDisable == 1}">
								<%if(terminalEditButton){%>
								
								<c:choose>
									<c:when test="${dataList.userType == 3}">
									<a href="${path}/terminalUser/authInfo.do?userId=${dataList.userId}&userIsDisable=${user.userIsDisable }" target="main">认证</a> |
									</c:when>
									<c:otherwise>
									<a href="${path}/terminalUser/preEditTerminalUser.do?userId=${dataList.userId}" target="main">编辑</a> |
									</c:otherwise>
								</c:choose>
									
								<%}%>
								<%if(terminalViewButton){%>
								<a href="${path}/terminalUser/viewTerminalUser.do?userId=${dataList.userId}" target="main">查看</a>|
								<%}%>
							</c:if>
							<c:if test="${user.userIsDisable != 1}">
								<%if(terminalEditWaiteActiveButton){%>
									<a href="${path}/terminalUser/preEditTerminalUser.do?userId=${dataList.userId}" target="main">编辑</a> |
								<%}%>
								<%if(terminalViewWaitButton){%>
								<a href="${path}/terminalUser/viewTerminalUser.do?userId=${dataList.userId}" target="main">查看</a> |
								<%}%>
							</c:if>
								
								<c:if test="${user.userIsDisable == 1}">
									<c:if test="${dataList.commentStatus==2}">
										<%if(terminalDisableCommentButton){%>
											<a class="cancel" userId="${dataList.userId}">取消禁止</a> |
										<%}%>
									</c:if>

									<c:if test="${dataList.commentStatus==1}">
										<%if(terminalDisableCommentButton){%>
											<a class="disable" userId="${dataList.userId}">禁止评论</a> |
										<%}%>
									</c:if>
								</c:if>
								<c:if test="${dataList.userIsDisable != 1}">
									<%if(terminalActiveButton){%>
										<a class="delete" userId="${dataList.userId}">激活</a> |
									<%}%>
								</c:if>

								<c:if test="${dataList.userIsDisable == 1}">
									<%if(terminalFreezeButton){%>
										<a class="active" userId="${dataList.userId}">冻结</a> |
									<%}%>
								</c:if>
							<a href="${path}/teamUser/teamUserIndex.do?tuserIsActiviey=1&userId=${dataList.userId}" target="main">使用者认证查询</a> |
							
							<a href="${path}/order/queryAllTerminalUserOrderIndex.do?userId=${dataList.userId}" target="main">所有订单</a> |
							
							<a href="${path}/userIntegral/userIntegralIndex.do?userId=${dataList.userId}" target="main">积分管理</a>
								
						</td>
					</tr>
				</c:forEach>
			</c:if>
			<c:if test="${empty userList}">
				<tr>
					<c:choose>
						<c:when test="${user.userIsDisable == 1}">
							<td colspan="10"> <h4 style="color:#DC590C">暂无数据!</h4></td>
						</c:when>
						<c:otherwise>
							<td colspan="9"> <h4 style="color:#DC590C">暂无数据!</h4></td>
						</c:otherwise>
					</c:choose>
				</tr>
			</c:if>
			</tbody>
		</table>
		<c:if test="${not empty userList}">
			<input type="hidden" id="page" name="page" value="${page.page}" />
			<div id="kkpager"></div>
		</c:if>
	</div>
</form>
</body>
</html>
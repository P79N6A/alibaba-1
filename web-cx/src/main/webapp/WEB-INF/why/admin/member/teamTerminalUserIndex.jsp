<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>

	<title>文化云</title>
	<%@include file="/WEB-INF/why/common/pageFrame.jsp"%>

	<script type="text/javascript">
		$(function(){
			getPage();
			deleteTeamTerminalUser();
		});

		// 分页
		function getPage(){
			kkpager.generPageHtml({
				pno : '${page.page}',
				total : '${page.countPage}',
				totalRecords :  '${page.total}',
				mode : 'click',//默认值是link，可选link或者click
				click : function(n){
					this.selectPage(n);
					$("#page").val(n);
					formSub('#terminalUserForm');
					return false;
				}
			});
		}

		// 搜索
		function formSub(formName){
			if($("#userName").val() == "输入关键词"){
				$("#userName").val("");
			}
			$(formName).submit();
		}

		function deleteTeamTerminalUser(){
			$(".delete").on("click", function(){
				var applyId = $(this).attr("applyId");
				var name = $(this).parent().siblings(".title").find("a").text();
				var html = "您确定要删除" + name + "吗？";
				dialogConfirm("提示", html, function(){
					$.post("${path}/applyJoinTeam/deleteTeamTerminalUser.do",{applyId:applyId},function(data) {
						if (data == 'success') {
							window.location.href="${path}/terminalUser/teamTerminalUserIndex.do?tuserId=${applyJoinTeam.tuserId}";
						}
					});
				})
			});
		}
	</script>
</head>
<body>
<%--<%
	boolean teamTerminalUserViewButton=false;
	boolean teamTerminalUserDeleteButton=false;
%>--%>

<%
	boolean teamTerminalUserViewButton=true;
	boolean teamTerminalUserDeleteButton=true;
%>

<%--<%if(session.getAttribute("user") != null)
{
%>
<c:forEach items="${sessionScope.user.sysModuleList}" var="module">
	<c:if test="${module.moduleUrl == '${path}/terminalUser/viewTeamTerminalUser.do'}">
		<% teamTerminalUserViewButton=true;%>
	</c:if>

	<c:if test="${module.moduleUrl == '${path}/applyJoinTeam/deleteTeamTerminalUser.do'}">
		<% teamTerminalUserDeleteButton=true;%>
	</c:if>
</c:forEach>
<%
	}
%>--%>

<div class="site">
	<em>您现在所在的位置：</em>团体管理 &gt; 成员列表
</div>
<form action="${path}/terminalUser/teamTerminalUserIndex.do" id="terminalUserForm" method="post">
	<div class="search">
		<input type="hidden" name="tuserId" value="${applyJoinTeam.tuserId}"/>
		<div class="search-box">
			<i></i><input class="input-text" data-val="输入关键词" name="userName" value="<c:choose><c:when test="${not empty userName}">${userName}</c:when><c:otherwise>输入关键词</c:otherwise></c:choose>" type="text" id="userName"/>
		</div>
		<div class="select-btn">
			<input type="button" value="搜索" onclick="$('#page').val(1);formSub('#terminalUserForm')"/>
		</div>
	</div>
	<div class="main-content">
		<table width="100%">
			<thead>
			<tr>
				<th>ID</th>
				<th class="title">成员用户名</th>
				<th>成员性别</th>
				<th>出生日期</th>
				<th>联系方式</th>
				<th>成员简介</th>
				<th>管理</th>
			</tr>
			</thead>
			<tbody>
			<c:forEach items="${terminalUserList}" var="terminalUser" varStatus="status">
				<tr>
					<td>${status.index +1}</td>
					<td class="title">
						<a href="javascript:;">${terminalUser.userName}
							<c:if test="${terminalUser.applyIsState == 1}">
								<span style="color: red">(管理员)</span>
							</c:if>
						</a>
					</td>
					<td>
						<c:if test="${terminalUser.userSex == 1}">男</c:if>
						<c:if test="${terminalUser.userSex == 2}">女</c:if>
						<c:if test="${terminalUser.userSex == 3}">保密</c:if>
					</td>
					<td><fmt:formatDate value="${terminalUser.userBirth}"  pattern="yyyy-MM-dd" /></td>
					<td>${terminalUser.userMobileNo}</td>
					<td>
						<c:choose>
							<c:when test="${fn:length(terminalUser.applyReason) > 10}">
								${fn:substring(terminalUser.applyReason, 0 , 10)}.....
							</c:when>
							<c:otherwise>
								${terminalUser.applyReason}
							</c:otherwise>
						</c:choose>
					</td>
					<td>
						<%
							if(teamTerminalUserViewButton){
						%>
							<a href="${path}/terminalUser/viewTeamTerminalUser.do?applyId=${terminalUser.applyId}">查看</a>
						<%
							}
						%>
						<%
							if(teamTerminalUserDeleteButton){
						%>
							<c:if test="${terminalUser.applyIsState == 2}">
								| <a class="delete" applyId="${terminalUser.applyId}">删除</a>
							</c:if>
						<%
							}
						%>
					</td>
				</tr>
			</c:forEach>
			</tbody>
			<c:if test="${empty terminalUserList}">
				<tr>
					<td colspan="7"> <h4 style="color:#DC590C">暂无数据!</h4></td>
				</tr>
			</c:if>
		</table>
		<c:if test="${not empty terminalUserList}">
			<input type="hidden" id="page" name="page" value="${page.page}" />
			<div id="kkpager"></div>
		</c:if>
	</div>
</form>
</body>
</html>
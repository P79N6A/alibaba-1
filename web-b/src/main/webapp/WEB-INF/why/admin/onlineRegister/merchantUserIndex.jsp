<%@ page language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>线上报名列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <%@include file="/WEB-INF/why/common/limit.jsp" %>

    <script type="text/javascript">

        $(function () {
            kkpager.generPageHtml({
                pno: '${page.page}',
                total: '${page.countPage}',
                totalRecords: '${page.total}',
                mode: 'click',//默认值是link，可选link或者click
                click: function (n) {
                    this.selectPage(n);
                    $("#page").val(n);
                    formSub('#merchantUserForm');
                    return false;
                }
            });
        });
        
      	//提交表单
        function formSub(formName) {
            $(formName).submit();
        }

        //激活用户
        function saveSysUser(merchantUserId) {
            dialogConfirm("提示", "确定激活该用户？", function(){
            	$.post("${path}/onlineRegister/saveSysUser.do", {merchantUserId: merchantUserId}, function (data) {
                    if (data == "200") {
                    	dialogConfirm("提示", "激活成功！", function(){
                    		location.reload();
                    	})
                    } else {
                        dialogAlert('提示', "激活失败！");
                    }
                });
            });
        }
        
      	//授权用户
        function setUserRole(sysUserId) {
            dialogConfirm("提示", "确定授权该用户？", function(){
            	$.post("${path}/userRole/saveUserRole.do", {userId:sysUserId,roleId:"e2b73a277f324305969b792d66da44cc"}, function (data) {
            		if(data == "success"){
            			dialogConfirm("提示", "授权成功！", function(){
                    		location.reload();
                    	})
                    }else{
                    	dialogAlert("提示", "授权失败！");
                    }
                });
            });
        }
        
    </script>
</head>
<body>
<form id="merchantUserForm" action="" method="post">
    <div class="site">
        <em>您现在所在的位置：</em>运维管理 &gt; 线上报名
    </div>
    <div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th width="50">ID</th>
                <th class="title">单位</th>
                <th width="170">姓名</th>
                <th width="170">登录名</th>
                <th width="170">手机号</th>
                <th width="170">邮箱</th>
                <th width="170">地址</th>
                <th width="170">申请时间</th>
                <th width="340">管理</th>
            </tr>
            </thead>
            <tbody>
            <%int i = 0;%>
            <c:forEach items="${list}" var="dom">
                <%i++;%>
                <tr>
                    <td><%=i%></td>
                    <td class="title">${dom.userCompany}</td>
                    <td>${dom.userName}</td>
                    <td>${dom.userAccount}</td>
                    <td>${dom.userMobileNo}</td>
                    <td>${dom.userEmail}</td>
                    <td>${dom.userAddress}</td>
                    <td><fmt:formatDate value="${dom.createTime}" pattern="yyyy-MM-dd"/></td>
                    <td>
                    	<c:if test="${empty dom.sysUserId}">
                    		<a target="main" href="javascript:saveSysUser('${dom.merchantUserId}');" style="color: red;font-weight: bold;">激活</a>
                    	</c:if>
                    	<c:if test="${not empty dom.sysUserId}">
                    		<c:if test="${empty dom.roleId}">
                    			<a target="main" href="javascript:setUserRole('${dom.sysUserId}');" style="color: red;font-weight: bold;">授权</a>
                    		</c:if>
                    		<c:if test="${not empty dom.roleId}">
                    			<a target="main" href="javascript:;">已授权</a>
                    		</c:if>
                    	</c:if>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty list}">
                <tr>
                    <td colspan="8"><h4 style="color:#DC590C">暂无数据!</h4></td>
                </tr>
            </c:if>
            </tbody>
        </table>
        <c:if test="${not empty list}">
            <input type="hidden" id="page" name="page" value="${page.page}"/>
            <div id="kkpager"></div>
        </c:if>
    </div>
</form>
</body>
</html>

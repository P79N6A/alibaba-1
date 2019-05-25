<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

    <title>管理员列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>

    <%--<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/reset.css"/>--%>
    <%--<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/main.css"/>--%>
    <%--<!--[if lte IE 8]>--%>
    <%--<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/main-ie.css"/>--%>
    <%--<![endif]-->--%>
    <%--<script type="text/javascript" src="${path}/STATIC/js/jquery.min.js"></script>--%>
    <%--<script type="text/javascript" src="${path}/STATIC/js/base.js"></script>--%>
    <script type="text/javascript">
        function actUser(id){
            dialogConfirm("激活用户", "您确定要激活此用户吗？", removeParent);
            function removeParent() {
                location.href='${path}/user/deleteSysUser.do?userId=' + id +'&'+ $('#indexForm').serialize();
            }
        }
        function deletUser(id){
            dialogConfirm("冻结用户", "您确定要冻结此用户吗？", removeParent);
            function removeParent() {
                location.href='${path}/user/deleteSysUser.do?userId=' + id +'&'+ $('#indexForm').serialize();
            }
        }
        $(function(){
        	//区县搜索
            var defaultAreaId = $("#areaData").val();
            $.post("${path}/user/getLocArea.do",function(areaData) {
                var ulHtml = "<li data-option=''>全部区县</li>";
                var divText = "全部区县";
                if (areaData != '' && areaData != null) {
                    for(var i=0; i<areaData.length; i++){
                        var area = areaData[i];
                        var areaId = area.id;
                        var areaText = area.text;
                        if(areaId == "44"){
                            continue;
                        }
                        ulHtml += '<li data-option="'+areaId+'">'
                        + areaText
                        + '</li>';
                        if(defaultAreaId == areaId){
                            divText = areaText;
                        }
                    }
                    $("#areaDiv").html(divText);
                    $("#areaUl").html(ulHtml);
                }
            }).success(function() {
                selectModel();
            });
        	
            $("input").focus();
            kkpager.generPageHtml({
                pno : '${page.page}',
                total : '${page.countPage}',
                totalRecords :  '${page.total}',
                mode : 'click',//默认值是link，可选link或者click
                click : function(n){
                    this.selectPage(n);
                    $("#page").val(n);
                    if ($("#userAccount").val() != undefined && $("#userAccount").val() =='输入用户帐号') {
                        $("#userAccount").val("");
                    }
                    $("#userForm").submit();
                    return false;
                }
            });
        });

        var pageSize = ${page.countPage};
        function pageSubmit(page){
            if(page <= pageSize){
                $("#page").val(page);
                if ($("#userAccount").val() != undefined && $("#userAccount").val() =='输入用户帐号') {
                    $("#userAccount").val("");
                }
                $("#userForm").submit();
            }else{
                //alert("跳转页数不能超过总页数");
            }
        }
    </script>
</head>
<body>
<form id="userForm" action="${path}/user/sysUserIndex.do" method="post">
<div class="site">
    <em>您现在所在的位置：</em>用户管理 &gt;管理员列表
</div>
<div class="search">
    <div class="search-box">
        <i></i><input value="${userAccount}" id="userAccount" name ="userAccount"class="input-text" data-val="输入用户帐号"  type="text"/>
    </div>
    <div class="select-box w135">
	     <input type="hidden" name="areaData" id="areaData" value="${areaData}"/>
	     <div id="areaDiv" class="select-text" data-value="">全部区县</div>
	     <ul id="areaUl" class="select-option">
	     </ul>
    </div>
    <div class="select-btn">
        <input type="button" value="搜索" onclick="pageSubmit(0)" style="border: none; "/>
    </div>

</div>
<div class="main-content">
    <table width="100%">
        <thead>
        <tr>
            <th>ID</th>
            <th class="title">用户帐号</th>
            <th class="venue">用户级别</th>
            <th>部门</th>
            <th>性别</th>
            <th >操作人</th>
            <th >操作时间</th>
            <th >状态</th>
            <th >权限标签</th>
            <th >管理</th>
        </tr>
        </thead>
        <tbody>
        <%int i=0;%>
        <c:forEach items="${userList}" var="user">
                <% i++;%>
        <tr>
            <td> <%= i%></td>
            <td class="title"><a href="${path}/user/viewSysUser.do?userId=${user.userId}">${user.userAccount} </a></td>
            <td class="venue"><a href="#">
                <c:if test="${user.userIsManger == 1}">省级人员 </c:if>
                <c:if test="${user.userIsManger == 2}">市级人员</c:if>
                <c:if test="${user.userIsManger == 3}"> 区级人员</c:if>
                <c:if test="${user.userIsManger == 4}"> 场馆人员 </c:if></a>
            </td>
            <td>${user.userDeptId}</td>
            <td>
                <c:choose>
                    <c:when test="${user.userSex==2}">
                        女
                    </c:when>
                    <c:otherwise>
                        男
                    </c:otherwise>
                </c:choose>
            </td>
            <td>${user.userUpdateUser}</td>
            <td> <fmt:formatDate value="${user.userUpdateTime}"  pattern="yyyy-MM-dd" /></td></td>
            <td width="80">
                <c:choose>
                    <c:when test="${user.userState==1}">
                        激活
                    </c:when>
                    <c:otherwise>
                        冻结
                    </c:otherwise>
                </c:choose>
            </td>
            <td width="160">
                <c:if test="${user.userLabel1==1}">文广体系</c:if>
                <c:if test="${user.userLabel2==2&&user.userLabel1==1}">，独立商家</c:if>
                <c:if test="${user.userLabel2==2&&user.userLabel1!=1}">独立商家</c:if>
                <c:if test="${user.userLabel3==3&&(user.userLabel1==1||user.userLabel2==2)}">，其他</c:if>
                <c:if test="${user.userLabel3==3&&!(user.userLabel1==1||user.userLabel2==2)}">其他</c:if>
            </td>
            <td>
                <c:if test="${sessionScope.user.userId != user.userId}" >
                    <c:choose>
                        <c:when test="${user.userState==1}">
                        <%
		                   if(sysUserDeleteButton) {
		                %>
                            <a href="javascript:deletUser('${user.userId}');" >冻结</a>|
		                <%
		                    }
		                %>
                       
                        </c:when>
                        <c:otherwise>
                        <%
		                   if(sysUserDeleteButton) {
		                %>
                             <a href="javascript:actUser('${user.userId}');" >激活</a>|
		                <%
		                    }
		                %>
                        </c:otherwise>
                    </c:choose>
                    
                 </c:if>
			<%--
                <c:forEach items="${sessionScope.user.sysModuleList}" var="module">
                    <c:if test="${module.moduleUrl == '${path}/user/preEditSysUser.do'}">
                        <a href="${path}/user/preEditSysUser.do?userId=${user.userId}">编辑</a>|
                    </c:if>
                </c:forEach>
                <c:forEach items="${sessionScope.user.sysModuleList}" var="module">
                    <c:if test="${module.moduleUrl == '${path}/user/viewSysUser.do'}">
                        <a href="${path}/user/viewSysUser.do?userId=${user.userId}">查看</a>|
                    </c:if>
                </c:forEach>
                    <c:forEach items="${sessionScope.user.sysModuleList}" var="module">
                        <c:if test="${module.moduleUrl == '${path}/role/allRole.do'}">
                <a href="${path}/role/allRole.do?userId=${user.userId}">角色分配</a>
                    <</c:if>
                </c:forEach>--%>
                
                <%
                   if(sysUserEditButton) {
                %>
                	<a href="${path}/user/preEditSysUser.do?userId=${user.userId}">编辑</a> |
                <%
                    }
                %>
                <%
                   if(sysUserViewButton) {
                %>
                	<a href="${path}/user/viewSysUser.do?userId=${user.userId}">查看</a> |
                <%
                    }
                %>
                <%
                   if(sysUserAllRoleButton) {
                %>
                	<a href="${path}/role/allRole.do?userId=${user.userId}">角色分配</a> |
                <%
                    }
                %>
                <a href="${path}/sysUserAddress/addressIndex.do?userId=${user.userId}">地址管理</a>
            </td>
        </tr>
        </c:forEach>
        <c:if test="${empty userList}">
            <tr>
                <td colspan="9"> 暂无数据!</td>
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
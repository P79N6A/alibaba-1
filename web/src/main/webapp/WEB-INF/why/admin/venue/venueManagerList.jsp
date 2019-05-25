<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>场馆管理员列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
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
                    formSub('#venueIndexForm');
                    return false;
                }
            });
        });

        //提交表单
        function formSub(formName){
            var venueName = $("#userAccount").val();
            if(venueName == "输入管理员名称"){
                $("#userAccount").val("");
            }
            $(formName).submit();
        }
    </script>
</head>
<body>
<form id="venueManagerForm" action="${path}/user/sysUserIndex.do" method="post">
    <div class="site">
        <em>您现在所在的位置：</em>场馆管理 &gt;场馆列表 &gt;场馆管理员 &gt;
    </div>
    <div class="search">
        <div class="search-box">
            <i></i><input value="${userAccount}" id="userAccount" name ="userAccount"class="input-text" data-val="输入管理员名称"  type="text"/>
        </div>
        <div class="select-btn">
            <input type="button" value="搜索" onclick="$('#page').val(1);formSub('venueManagerForm')" style="border: none; "/>
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
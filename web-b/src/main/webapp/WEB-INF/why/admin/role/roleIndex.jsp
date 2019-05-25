<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>

    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
</head>
<body>
<%--<%
    boolean roleAddButton=false;
    boolean roleDeleteButton=false;
    boolean rolePreEditButton=false;
    boolean roleViewButton=false;
    boolean moduleIndexButton=false;
%>--%>

<%--<%if(session.getAttribute("user") != null)
{
%>
<c:forEach items="${sessionScope.user.sysModuleList}" var="module">
    <c:if test="${module.moduleUrl == '${path}/role/preAddRole.do'}">
        <% roleAddButton=true;%>
    </c:if>

    <c:if test="${module.moduleUrl == '${path}/role/deleteRole.do'}">
        <% roleDeleteButton=true;%>
    </c:if>

    <c:if test="${module.moduleUrl == '${path}/role/preEditRole.do'}">
        <% rolePreEditButton=true;%>
    </c:if>

    <c:if test="${module.moduleUrl == '${path}/role/viewRole.do'}">
        <% roleViewButton=true;%>
    </c:if>

    <c:if test="${module.moduleUrl == '${path}/module/moduleIndex.do'}">
        <% moduleIndexButton=true;%>
    </c:if>
</c:forEach>
<%
}
%>--%>
<div class="site">
    <em>您现在所在的位置：</em>角色管理 &gt; 角色列表
</div>
<form action="${path}/role/roleIndex.do" id="roleForm" method="post">
    <div class="search">
        <div class="search-box">
            <i></i><input class="input-text" name="roleName" data-val="输入关键词" value="<c:choose><c:when test="${not empty role.roleName}">${role.roleName}</c:when><c:otherwise>输入关键词</c:otherwise></c:choose>" type="text" id="roleName"/>
        </div>
        <div class="select-btn">
            <input type="button" value="搜索" onclick="$('#page').val(1);formSub('#roleForm');"/>
        </div>
        <%
            if(roleAddButton){
        %>
            <div class="search menage">
                <div class="menage-box">
                    <a class="btn-add">新增角色</a>
                </div>
            </div>
        <%
            }
        %>

    </div>
    <div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th>ID</th>
                <th class="title">角色名称</th>
                <th>备注</th>
                <th>状态</th>
                <th>操作人</th>
                <th>操作时间</th>
                <th>管理</th>
            </tr>
            </thead>
            <tbody>
            <c:if test="${fn:length(roleList) gt 0}">
                <tbody>
                <%int i=0;%>
                <c:forEach items="${roleList}" var="role">
                    <%i++;%>
                    <tr>
                        <td><%=i%></td>
                        <td class="title">
                            <a href="javascript:;"><c:if test="${not empty role.roleName}">
                                ${role.roleName}
                            </c:if></a>
                        </td>
                        <td>
                            <c:if test="${not empty role.roleRemark}">
                                ${role.roleRemark}
                            </c:if>
                        </td>

                        <td>
                            <c:if test="${not empty role.roleState && role.roleState == 1}">
                                正常
                            </c:if>
                        </td>
                        <td>
                            <c:if test="${not empty role.roleUpdateUser}">
                                ${role.roleUpdateUser}
                            </c:if>
                        </td>
                        <td>
                            <c:if test="${not empty role.roleUpdateTime}">
                                <fmt:formatDate value="${role.roleUpdateTime}"  pattern="yyyy-MM-dd" />
                            </c:if>
                        </td>
                        <td>
                            <%
                                if(roleDeleteButton){
                            %>
                                <a class="delete" roleId="${role.roleId}">删除</a> |
                            <%
                                }
                            %>
                            <%
                                if(rolePreEditButton){
                            %>
                                <a roleId="${role.roleId}" class="role-edit">编辑</a> |
                            <%
                                }
                            %>
                            <%
                                if(roleViewButton){
                            %>
                                <a roleId="${role.roleId}" class="role-view">查看</a> |
                            <%
                                }
                            %>
                            <%
                                if(moduleIndexButton){
                            %>
                                <a href="${path}/module/moduleIndex.do?roleId=${role.roleId}">分配权限</a>
                            <%
                                }
                            %>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </c:if>
            <c:if test="${empty roleList}">
                <tr>
                    <td colspan="7"> <h4 style="color:#DC590C">暂无数据!</h4></td>
                </tr>
            </c:if>
            </tbody>
        </table>
        <c:if test="${not empty roleList}">
            <input type="hidden" id="page" name="page" value="${page.page}" />
            <div id="kkpager"></div>
        </c:if>
    </div>
</form>
<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
<script type="text/javascript">
    seajs.config({
        alias: {
            "jquery": "jquery-1.10.2.js"
        }
    });

    seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
        window.dialog = dialog;
    });

    window.console = window.console || {log:function () {}}

    seajs.use(['jquery'], function ($) {
        // 新增角色
        $('.btn-add').on('click', function () {
            dialog({
                url: '${path}/role/preAddRole.do',
                title: '新增角色',
                width: 500,
                fixed: true
            }).showModal();
            return false;
        });

        //编辑角色
        $('.role-edit').on('click', function () {
            var roleId = $(this).attr("roleId");
            dialog({
                url: '${path}/role/preEditRole.do?roleId='+roleId,
                title: '编辑角色',
                width: 500,
                fixed: true
            }).showModal();
            return false;
        });

        // 查看角色
        $('.role-view').on('click', function () {
            var roleId = $(this).attr("roleId");
            dialog({
                url: '${path}/role/viewRole.do?roleId='+roleId,
                title: '角色详情',
                width: 500,
                fixed: true
            }).showModal();
            return false;
        });
    });

    $(function(){
        kkpager.generPageHtml({
            pno : '${page.page}',
            total : '${page.countPage}',
            totalRecords :  '${page.total}',
            mode : 'click',//默认值是link，可选link或者click
            click : function(n){
                this.selectPage(n);
                $("#page").val(n);
                formSub('#roleForm');
                return false;
            }
        });

        // 删除角色
        deleteRole();
    });

    function formSub(formName){
        if($("#roleName").val() == "输入关键词"){
            $("#roleName").val("");
        }
        $(formName).submit();
    }

    function deleteRole(){
        $(".delete").on("click", function(){
            var roleId = $(this).attr("roleId");
            var name = $(this).parent().siblings(".title").find("a").text();
            var html = "您确定要删除" + name + "吗？";
            dialogConfirm("提示", html, function(){
                $.post("${path}/role/deleteRole.do",{roleId:roleId},function(data) {
                    if (data == 'success') {
                        window.location.href="${path}/role/roleIndex.do";
                    }
                });
            })
        });
    }
</script>
</body>
</html>
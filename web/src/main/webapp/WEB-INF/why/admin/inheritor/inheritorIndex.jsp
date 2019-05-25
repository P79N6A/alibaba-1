<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>

    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
</head>
<body>
<%--<%
    boolean inheritorEditButton=false;
    boolean inheritorViewButton=false;
    boolean inheritorDeleteButton=false;
%>--%>
<%
    boolean inheritorEditButton=true;
    boolean inheritorViewButton=true;
    boolean inheritorDeleteButton=true;
%>
<%--<%if(session.getAttribute("user") != null)
{
%>
<c:forEach items="${sessionScope.user.sysModuleList}" var="module">
    <c:if test="${module.moduleUrl == '${path}/inheritor/preEditInheritor.do'}">
        <% inheritorEditButton=true;%>
    </c:if>

    <c:if test="${module.moduleUrl == '${path}/inheritor/viewInheritor.do'}">
        <% inheritorEditButton=true;%>
    </c:if>

    <c:if test="${module.moduleUrl == '${path}/inheritor/deleteInheritor.do'}">
        <% inheritorDeleteButton=true;%>
    </c:if>
</c:forEach>
<%
    }
%>--%>

<div class="site">
    <em>您现在所在的位置：</em>非遗管理 &gt; 传承人列表
</div>
<form action="${path}/inheritor/inheritorIndex.do" id="inheritorForm" method="post">
    <input type="hidden" name="cultureId" value="${inheritor.cultureId}"/>
    <div class="search">
        <div class="search menage">
            <h2>非遗名称：${inheritor.cultureName}</h2>
            <div class="menage-box">
                <a class="btn-add">新增传承人</a>
            </div>
        </div>
    </div>

    <div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th>ID</th>
                <th class="title">传承人姓名</th>
                <th>性别</th>
                <th>年龄</th>
                <th>个人简介</th>
                <th>操作人</th>
                <th>操作时间</th>
                <th>管理</th>
            </tr>
            </thead>
            <tbody>
            <c:if test="${fn:length(inheritorList) gt 0}">
                <tbody>
                <%int i=0;%>
                <c:forEach items="${inheritorList}" var="inheritor">
                    <%i++;%>
                    <tr>
                        <td><%=i%></td>
                        <td class="title">
                            <a href="javascript:;"><c:if test="${not empty inheritor.inheritorName}">${inheritor.inheritorName}</c:if></a>
                        </td>
                        <td>
                            <c:if test="${not empty inheritor.inheritorSex}">
                                <c:if test="${inheritor.inheritorSex eq 1}">男</c:if>
                                <c:if test="${inheritor.inheritorSex eq 2}">女</c:if>
                            </c:if>
                        </td>
                        <td>
                            <c:if test="${not empty inheritor.inheritorAge}">
                                ${inheritor.inheritorAge}
                            </c:if>
                        </td>
                        <td title="${inheritor.inheritorRemark}">
                            <c:if test="${not empty inheritor.inheritorRemark}">
                                <c:choose>
                                    <c:when test="${fn:length(inheritor.inheritorRemark) > 20}">
                                        <c:out escapeXml="true" value="${fn:substring(inheritor.inheritorRemark, 0 , 20)}"/>.....
                                    </c:when>
                                    <c:otherwise>
                                        <c:out escapeXml="true" value="${inheritor.inheritorRemark}"/>
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                        </td>
                        <td>
                            <c:if test="${not empty inheritor.inheritorUpdateUser}">
                                ${inheritor.inheritorUpdateUser}
                            </c:if>
                        </td>
                        <td>
                            <c:if test="${not empty inheritor.inheritorUpdateTime}">
                                <fmt:formatDate value="${inheritor.inheritorUpdateTime}"  pattern="yyyy-MM-dd HH:mm" />
                            </c:if>
                        </td>
                        <td>
                            <%
                                if(inheritorEditButton){
                            %>
                                <a inheritorId="${inheritor.inheritorId}" class="inheritor-edit">编辑</a> |
                            <%
                                }
                            %>
                            <%
                                if(inheritorViewButton){
                            %>
                                <a inheritorId="${inheritor.inheritorId}" class="inheritor-view">查看</a> |
                            <%
                                }
                            %>
                            <%
                                if(inheritorDeleteButton){
                            %>
                                <a inheritorId="${inheritor.inheritorId}" class="inheritor-delete">删除</a>
                            <%
                                }
                            %>
                        </td>
                    </tr>
                </c:forEach>


                </tbody>
            </c:if>
            <c:if test="${empty inheritorList}">
                <tr>
                    <td colspan="8"> <h4 style="color:#DC590C">暂无数据!</h4></td>
                </tr>
            </c:if>
            </tbody>
        </table>
        <c:if test="${not empty inheritorList}">
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
        // 新增非遗传承人
        $('.btn-add').on('click', function () {
            dialog({
                url: '${path}/inheritor/preAddInheritor.do?cultureId=${inheritor.cultureId}&cultureName=${inheritor.cultureName}',
                title: '新增传承人',
                width: 900,
                height: 800,
                fixed: true
            }).showModal();
            return false;
        });

        //编辑角色
        $('.inheritor-edit').on('click', function () {
            var inheritorId = $(this).attr("inheritorId");
            dialog({
                url: '${path}/inheritor/preEditInheritor.do?inheritorId='+inheritorId,
                title: '编辑传承人',
                width: 900,
                height: 800,
                fixed: true
            }).showModal();
            return false;
        });

        $(".inheritor-delete").on("click", function(){
            var inheritorId = $(this).attr("inheritorId");
            var name = $(this).parent().siblings(".title").find("a").text();
            var html = "您确定要删除" + name + "吗？";
            dialogConfirm("提示", html, function(){
                $.post("${path}/inheritor/deleteInheritor.do",{inheritorId:inheritorId},function(data) {
                    if (data == 'success') {
                        window.location.href="${path}/inheritor/inheritorIndex.do?cultureId=${inheritor.cultureId}&cultureName=${inheritor.cultureName}";
                    }
                });
            })
        });

        // 查看角色
        $('.inheritor-view').on('click', function () {
            var inheritorId = $(this).attr("inheritorId");
            dialog({
                url: '${path}/inheritor/viewInheritor.do?inheritorId='+inheritorId,
                title: '传承人详情',
                width: 700,
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
                formSub('#inheritorForm');
                return false;
            }
        });
    });

    function formSub(formName){
        $(formName).submit();
    }
</script>
</body>
</html>
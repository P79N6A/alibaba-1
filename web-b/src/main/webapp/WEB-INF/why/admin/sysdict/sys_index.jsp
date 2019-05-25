<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>活动列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@ include file="/WEB-INF/why/common/limit.jsp"%>
</head>
<body>
<form id="dictForm" method="post" action="${path}/sysdict/dictIndex.do">
<div class="site">
    <em>您现在所在的位置：</em>字典管理 &gt; 字典列表
</div>
<div class="search">
    <div class="search-box">
        <i></i><input value="<c:choose><c:when test="${not empty sysDict.dictCode}">${sysDict.dictCode}</c:when><c:otherwise>请输入编码</c:otherwise></c:choose>" name="dictCode" id="dictCode" class="input-text" data-val="请输入编码" type="text"/>
    </div>
    <div class="search-box">
        <i></i><input type="text" data-val="请输入名称" value="<c:choose><c:when test="${not empty sysDict.dictName}">${sysDict.dictName}</c:when><c:otherwise>请输入名称</c:otherwise></c:choose>" class="input-text" name="dictName" id="dictName"/>
    </div>
    <div class="select-btn">

        <input type="button" value="搜索" onclick="searchDict()"/>

    </div>
    <div class="search menage">
        <div class="menage-box">
            <%
                if(preSaveSysDictButton){
            %>
            <a class="btn-add" href="javascript:void(0);">添加字典</a>
            <%
                }
            %>
        </div>
    </div>
</div>
<div class="main-content">
    <table width="100%">
        <thead>
        <tr>
            <th>ID</th>
            <th class="title">字典编码</th>
            <th class="venue">字典名称</th>
            <th >描述</th>
            <th>操作人</th>
            <th>操作时间</th>
            <th >管理</th>
        </tr>
        </thead>
        <tbody>
        <%int i=0;%>
        <c:if test="${null != list}">
            <c:forEach items="${list}" var="dataList" varStatus="status">
                <%i++;%>
                <tr>
                    <td width="65"><%=i%></td>

                    <c:choose>
                        <c:when test="${not empty dataList.dictCode}">
                            <td class="title">${dataList.dictCode}</td>
                        </c:when>
                        <c:otherwise>
                            <td class="title"></td>
                        </c:otherwise>
                    </c:choose>

                    <c:choose>
                        <c:when test="${not empty dataList.dictName}">
                            <td class="venue">${dataList.dictName}</td>
                        </c:when>
                        <c:otherwise>
                            <td class="venue"></td>
                        </c:otherwise>
                    </c:choose>

                    <c:choose>
                        <c:when test="${not empty dataList.dictRemark}">
                            <td width="130">${dataList.dictRemark}</td>
                        </c:when>
                        <c:otherwise>
                            <td width="130"></td>
                        </c:otherwise>
                    </c:choose>

                    <c:choose>
                        <c:when test="${not empty dataList.userAccount}">
                            <td width="70">${dataList.userAccount}</td>
                        </c:when>
                        <c:otherwise>
                            <td width="70"></td>
                        </c:otherwise>
                    </c:choose>

                    <c:choose>
                        <c:when test="${not empty dataList.dictUpdateTime}">
                            <td width="70">
                                <fmt:formatDate value="${dataList.dictUpdateTime}" pattern="yyyy-MM-dd HH:mm"/>
                            </td>
                        </c:when>
                        <c:otherwise>
                            <td width="70"></td>
                        </c:otherwise>
                    </c:choose>

                    <td width="120" class="td-editing">
                        <%--<c:forEach items="${sessionScope.user.sysModuleList}" var="module">
                            <c:if test="${module.moduleUrl == '${path}/sysdict/dictDel.do'}">
                                <a class="delete" dictId="${dataList.dictId}">删除</a> |
                            </c:if>
                          <c:if test="${module.moduleUrl == '${path}/sysdict/updateEdit.do'}">
                            <a id="${dataList.dictId}" class="btn-edit">编辑</a>
                            </c:if>

                        </c:forEach>--%>

                        <%
                            if(deleteDictButton){
                        %>
                            <a class="delete" dictId="${dataList.dictId}">删除</a> |

                            <%
                                }
                            %>

                            <%
                                if(editDictButton){
                            %>
                            <a id="${dataList.dictId}" class="btn-edit">编辑</a>

                            <%
                                }
                            %>

                    </td>
                </tr>
            </c:forEach>
        </c:if>
        <c:if test="${empty list}">
            <tr>
                <td colspan="9"><h4 style="color:#DC590C">暂无数据!</h4></td>
            </tr>
        </c:if>
        </tbody>
    </table>
    <c:if test="${not empty list}">
        <input type="hidden" id="page" name="page" value="${page.page}" />
        <div id="kkpager"></div>
    </c:if>
</form>
<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
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
                searchDict();
                return false;
            }
        });

        deleteRole();
    });

    function deleteRole(){
        $(".delete").on("click", function(){
            var dictId = $(this).attr("dictId");
            var name = $(this).parent().siblings(".title").find("a").text();
            var html = "您确定要删除" + name + "吗？";
            dialogConfirm("提示", html, function(){
                $.post("${path}/sysdict/dictDel.do",{dictId:dictId},function(data) {
                    if (data == 'success') {
                        window.location.href="${path}/sysdict/dictIndex.do";
                    }
                });
            })
        });
    }

    function searchDict(){
        var dictCode = $("#dictCode").val();
        var dictName = $("#dictName").val();
        if(dictCode == "请输入编码"){
            $("#dictCode").val("");
        }
        if(dictName == "请输入名称"){
            $("#dictName").val("");
        }
        $("#dictForm").submit();
    }

    seajs.config({
        alias: {
            "jquery": "jquery-1.10.2.js"
        }
    });
    seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
        window.dialog = dialog;
    });
    window.console = window.console || {log:function () {}}
    //添加标签
    seajs.use(['jquery'], function ($) {
        $('.btn-add').on('click', function () {
            dialog({
                url: '${path}/sysdict/preSaveSysDict.do',
                title: '字典新增',
                width: 500,
                fixed: true
            }).showModal();
            return false;
        });

        $('.btn-edit').on('click', function () {
            var dictId = $(this).attr("id");
            dialog({
                url: '${path}/sysdict/updateEdit.do?dictId='+dictId,
                title: '字典编辑',
                width: 500,
                fixed: true
            }).showModal();
            return false;
        });
    });

</script>
</body>
</html>
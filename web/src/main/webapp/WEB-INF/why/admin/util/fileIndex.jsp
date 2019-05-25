<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>模板列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@ include file="/WEB-INF/why/common/limit.jsp"%>
</head>
<body>
<form id="dictForm" method="post" action="${path}/sysdict/dictIndex.do">
<div class="site">
    <em>您现在所在的位置：</em>模板管理 &gt; 模版管理
</div>
<div class="search">
<%--    <div class="search-box">
        <i></i><input value="<c:choose><c:when test="${not empty sysDict.dictCode}">${sysDict.dictCode}</c:when><c:otherwise>请输入编码</c:otherwise></c:choose>" name="dictCode" id="dictCode" class="input-text" data-val="请输入编码" type="text"/>
    </div>
    <div class="search-box">
        <i></i><input type="text" data-val="请输入名称" value="<c:choose><c:when test="${not empty sysDict.dictName}">${sysDict.dictName}</c:when><c:otherwise>请输入名称</c:otherwise></c:choose>" class="input-text" name="dictName" id="dictName"/>
    </div>
    <div class="select-btn">

        <input type="button" value="搜索" onclick="searchDict()"/>

    </div>--%>
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
            <th class="title">模版名称</th>
            <th class="venue">最新修改时间</th>
<%--            <th >描述</th>
            <th>操作人</th>
            <th>操作时间</th>--%>
            <th >管理</th>
        </tr>
        </thead>
        <tbody>
        <%int i=0;%>
        <c:if test="${null != fileList}">
            <c:forEach items="${fileList}" var="dataList" varStatus="status">
                <%i++;%>
                <tr>
                    <td width="65"><%=i%></td>
                    <td class="title">
                        <c:if test="${dataList.file}">
                            <a href="${path}/test/getFile.do?filePath=${dataList.path}">${dataList.name}</a>
                        </c:if>
                        <c:if test="${dataList.directory}">
                            <a href="${path}/test/fileList.do?name=${dataList.path}">${dataList.name}</a>
                        </c:if>
                    </td>
                    <td class="title"> ${dataList.path}</td>
                    <td width="120" class="td-editing">
                        <c:if test="${dataList.file}">
                             <a  class="btn-edit" href="${path}/test/preEditFile.do?filePath=${dataList.path}">编辑</a>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
        </c:if>
        <c:if test="${empty fileList}">
            <tr>
                <td colspan="9"><h4 style="color:#DC590C">暂无数据!</h4></td>
            </tr>
        </c:if>
        </tbody>
    </table>
</form>
</body>
</html>
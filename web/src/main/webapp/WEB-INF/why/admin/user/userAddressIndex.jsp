<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

    <title>管理员列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>

    <script type="text/javascript">
        seajs.config({
            alias: {
                "jquery": "jquery-1.10.2.js"
            }
        });
        seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
            window.dialog = dialog;
        });

        window.console = window.console || {
                    log:function () {

                    }
                }
        seajs.use(['jquery'], function ($) {
            $('.btn-add-tag').on('click', function () {
                dialog({
                    url: '${path}/sysUserAddress/addAdd.do?userId='+userId,
                    title: '添加地址',
                    width: 700,
                    height:700,
                    fixed: true
                }).showModal();
                return false;
            });
        });

    </script>
</head>
<body>
<input type="hidden" name="userId" id="userId" value="${userId}"/>
<form id="userForm" action="${path}/sysUserAddress/addressIndex.do" method="post">
<div class="site search">
    <em>您现在所在的位置：</em>用户管理 &gt;管理员地址列表
        <div class="search-total">
            <div class="select-btn">
                <input class="btn-add-tag" type="button" value="添加" style="background:#ED3838; "/>
            </div>
        </div>
</div>

<div class="main-content">
    <table width="100%">
        <thead>
        <tr>
            <th>ID</th>
            <th>地址</th>
            <th>地点</th>
            <th>管理</th>
        </tr>
        </thead>
        <tbody>
        <%int i=0;%>
        <c:forEach items="${userAddresses}" var="address">
                <% i++;%>
        <tr>
            <td> <%= i%></td>
            <td >${address.activityAddress}</td>
            <td >${address.activitySite}</td>
            <td>
                <a href="${path}/sysUserAddress/addressIndex.do">地址编辑</a>
            </td>
        </tr>
        </c:forEach>
        <c:if test="${empty userAddresses}">
            <tr>
                <td colspan="9"> 暂无数据!</td>
            </tr>
        </c:if>
        </tbody>
    </table>
</div>
</form>
</body>
</html>
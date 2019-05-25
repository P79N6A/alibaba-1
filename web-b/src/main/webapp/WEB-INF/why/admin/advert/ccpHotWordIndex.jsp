<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

    <title>热门词汇列表--文化云</title>
    <%@include file="../../common/pageFrame.jsp" %>
    <%@include file="/WEB-INF/why/common/limit.jsp" %>
</head>
<body>
<link rel="Stylesheet" type="text/css" href="${path}/STATIC/css/DialogBySHF.css"/>
<script type="text/javascript" src="${path}/STATIC/js/DialogBySHF.js"></script>
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
                log: function () {

                }
            }
    seajs.use(['jquery'], function ($) {

    });
    function advEdit(ID,SD) {
        dialog({
            url: '${path}/ccpAdvert/addHotWordIndex.do?advertId=' + ID +'&advertTitle='+SD,
            title: '修改'+SD+'热门词汇',
            width: 800,
            height: 400,
            fixed: true
        }).showModal();
        return false;
    }
</script>
<div class="site">
    <em>您现在所在的位置：</em>推荐管理 &gt;Web端推荐&gt;热门词汇管理
</div>
<form id=""  method="post">
    <div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th>ID</th>
                <th>热门搜索词</th>
                <th>类别</th>
                <th>操作人</th>
                <th>操作时间</th>
                <th>管理</th>
            </tr>
            </thead>
            <tbody id="advertImg">
                    <tr>
                        <td class="sortNum">1</td>
                        <td><c:if test="${not empty listA}">${listA[0].advertUrl}</c:if></td>
                        <td>活动</td>
                        <td><c:if test="${not empty listA}">${listA[0].updateBy}</c:if></td>
                        <td><c:if test="${not empty listA}"><fmt:formatDate
                                value="${listA[0].updateTime}" pattern="yyyy-MM-dd"/></c:if></td>
                        <td>
                            <%
                                if (advertAddButton) {
                            %>
                            <a href="javascript:;" onclick="advEdit('4_A_1','活动')">编辑</a>
                            <%
                                }
                            %>
                        </td>
                    </tr>
                    <tr>
                        <td class="sortNum">2</td>
                        <td><c:if test="${not empty listB}">${listB[0].advertUrl}</c:if></td>
                        <td>场馆</td>
                        <td><c:if test="${not empty listB}">${listB[0].updateBy}</c:if></td>
                        <td><c:if test="${not empty listB}"><fmt:formatDate
                                value="${listB[0].updateTime}" pattern="yyyy-MM-dd"/></c:if></td>
                        <td>
                            <%
                                if (advertAddButton) {
                            %>
                            <a href="javascript:;" onclick="advEdit('4_B_1','场馆')">编辑</a>
                            <%
                                }
                            %>
                        </td>
                    </tr>
            </tbody>
        </table>
    </div>
</form>


</body>
</html>
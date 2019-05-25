<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

    <title>轮播图列表--文化云</title>
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

        $('.btn-add-tag').on('click', function () {
            var sortNum = $(this).parent().siblings(".sortNum").text();
            dialog({
                url: '${path}/ccpAdvert/addAdvertIndex.do?advertSort=' + sortNum,
                title: '添加首页轮播图',
                width: 1000,
                height: 800,
                fixed: true
            }).showModal();
            return false;
        });

    });
    function advEdit(ID) {
        dialog({
            url: '${path}/ccpAdvert/addAdvertIndex.do?advertId=' + ID,
            title: '添加首页轮播图',
            width: 1000,
            height: 800,
            fixed: true
        }).showModal();
        return false;
    }
    function editAdvert(ID,advertState) {
        $.post("../ccpAdvert/editAdvert.do", {advertState:advertState,advertId:ID},
                function (data) {
                    switch (data) {
                        case("success"):
                            dialogAlert("系统提示", "操作成功", function () {
                                window.location.href = "../ccpAdvert/advertIndex.do";
                                dialog.close().remove();
                            });
                            break;
                        case("noLogin"):
                            dialogAlert("系统提示", "请登陆后再进行操作", function () {
                                window.location.href = "../admin.do";
                                dialog.close().remove();
                            });
                            break;
                        case("failure"):
                            dialogAlert("系统提示", "服务器异常", function () {
                                window.location.href = "../ccpAdvert/advertIndex.do"
                                dialog.close().remove();
                            });
                            break;
                        default:
                            dialogAlert("系统提示", "保存发生错误，请查看数据是否完整", function () {
                                window.location.href = "../ccpAdvert/advertIndex.do"
                                dialog.close().remove();
                            });
                            break
                    }
                });
    }

</script>
<div class="site">
    <em>您现在所在的位置：</em>推荐管理 &gt;Web端推荐&gt;轮播图管理
</div>
<form id="advertIndexForm" action="${path}/advert/advertIndex.do" method="post">
    <div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th>ID</th>
                <th>标题</th>
                <th>上架时间</th>
                <th>操作人</th>
                <th>更新时间</th>
                <th>排序</th>
                <th>管理</th>
            </tr>
            </thead>
            <tbody id="advertImg">
            <c:if test="${empty list}">
                <c:forEach var="i" begin="1" end="6">
                    <tr>
                        <td class="sortNum">${i}</td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td>
                            <%
                                if (advertAddButton) {
                            %>
                            <a class="btn-add-tag">添加</a>
                            <%
                                }
                            %>
                        </td>
                    </tr>
                </c:forEach>
            </c:if>
            <c:if test="${not empty list}">
                <c:forEach var="i" begin="1" end="6">
                    <%boolean flag = false;%>
                    <c:forEach items="${list}" var="advert">
                        <c:if test="${advert.advertSort eq i}">
                            <tr>
                                <td class="sortNum">${i}</td>
                                <td>${advert.advertTitle}</td>
                                <td>
                                    <c:if test="${not empty advert.createTime}"><fmt:formatDate
                                            value="${advert.createTime}" pattern="yyyy-MM-dd"/></c:if>
                                </td>
                                <td>${advert.updateBy}</td>
                                <td><c:if test="${not empty advert.updateTime}"><fmt:formatDate
                                        value="${advert.updateTime}" pattern="yyyy-MM-dd HH:mm:ss"/></c:if></td>
                                <td>${i}</td>

                                <td>
                                    <%
                                        if (advertEditButton) {
                                    %>
                                    <a href="javascript:;" onclick="advEdit('${advert.advertId}')">编辑</a> |
                                    <%
                                        }
                                    %>

                                    <%
                                        if (recoveryAdvertButton) {
                                    %>
                                    <c:if test="${advert.advertState eq 3}"><a onclick="editAdvert('${advert.advertId}',1)"
                                                                              href="#">上线</a></c:if>
                                    <c:if test="${advert.advertState eq 1}"><a onclick="editAdvert('${advert.advertId}',3)"
                                                                              href="#">下线</a></c:if>

                                    <%
                                        }
                                    %>
                                </td>
                            </tr>
                            <%flag = true;%>
                        </c:if>
                    </c:forEach>
                    <%if (!flag) {%>
                    <tr>
                        <td class="sortNum">${i}</td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td>
                            <%
                                if (advertAddButton) {
                            %>
                            <a class="btn-add-tag">添加</a>
                            <%
                                }
                            %>
                        </td>
                    </tr>
                    <%}%>
                </c:forEach>
            </c:if>
            </tbody>
        </table>

        <input type="hidden" id="page" name="page" value="${page.page}"/>
        <c:if test="${not empty list}">
            <div id="kkpager"></div>
        </c:if>

    </div>
</form>


</body>
</html>
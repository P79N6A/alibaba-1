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
    <script type="text/javascript">
        var tagIds = "${tagIds}";

    </script>

</head>
<body>

<div class="site">
    <em>您现在所在的位置：</em>推荐管理 &gt; App端推荐 &gt;日历广告位

</div>
<form id="advertIndexForm" action="${path}/advertCalendar/appAdvertCalendarIndex.do" method="post">
    <div class="search">
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
                <th>日期</th>
                <th>创建人</th>
                <th>创建时间</th>
                <th>修改人</th>
                <th>修改时间</th>
                <th>管理</th>
            </tr>
            </thead>

            <c:if test="${empty list}">
                <tr>
                    <td colspan="8"><h4 style="color:#DC590C">暂无数据!</h4></td>
                </tr>
            </c:if>

            <tbody id="advertImg">

            <c:forEach items="${list}" var="c" varStatus="s">
                <tr id="data-div">
                    <td>${s.index+1}</td>
                    <td>${fn:substring(c.advertDate,0,10)}</td>
                    <td>${c.createBy}</td>
                    <td><fmt:formatDate value="${c.createTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                    <td>${c.updateBy}</td>
                    <td><fmt:formatDate value="${c.updateTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                    <td>
                        <a target="main"
                           href="${path}/advertCalendar/addAdvertCalendar.do?advertId=${c.advertId}">编辑</a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>

        <input type="hidden" id="page" name="page" value="${page.page}"/>
        <c:if test="${not empty list}">
            <div id="kkpager"></div>
        </c:if>

    </div>
</form>

<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
<script type="text/javascript">
    $(function () {
        getPage();//分页

        $('.btn-add-tag').on('click', function () {
            window.location.href = "${path}/advertCalendar/addAdvertCalendar.do";

        });
    });

    // 分页
    function getPage() {
        kkpager.generPageHtml({
            pno: '${page.page}',
            total: '${page.countPage}',
            totalRecords: '${page.total}',
            mode: 'click',//默认值是link，可选link或者click
            click: function (n) {
                this.selectPage(n);
                $("#page").val(n);
                $("#advertIndexForm").submit();
                return false;
            }
        });
    }

    function advertEdit(advertId) {
        window.location.href = '${path}/advertRecommend/editAdvertRecommendIndex.do?advertId=' + advertId;

    }
    function advertDelete(advertId) {
        dialogConfirm("提示", "是否删除该广告位?", function () {
            $.post("${path}/advertRecommend/delete.do", {
                advertId: advertId
            }, function (data) {
                if (data != null && data == 'success') {
                    dialogAlert("提示", "操作成功", function () {
                        window.location.href = "${path}/advertRecommend/appAdvertRecommendIndex.do";
                    });
                } else {
                    dialogAlert("提示", "操作失败！", function () {
                    });
                }
            });
        })
    }
</script>


</body>
</html>
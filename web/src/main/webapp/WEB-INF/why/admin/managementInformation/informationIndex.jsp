<%@ page language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
    <title>活动列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <%@include file="/WEB-INF/why/common/limit.jsp" %>

    <script type="text/javascript">

        $(function () {

            new Clipboard('.copyButton');
            $("input").focus();
            kkpager.generPageHtml({
                pno: '${page.page}',
                total: '${page.countPage}',
                totalRecords: '${page.total}',
                mode: 'click',//默认值是link，可选link或者click
                click: function (n) {
                    this.selectPage(n);
                    $("#page").val(n);
                    formSub('#informationForm');
                    return false;
                }
            });

        });
        function copyUrl(id) {
            dialogAlert("提示", "复制完成：" + id);
        }
        //提交表单
        function formSub(formName) {
            var informationTitle = $('#informationTitle').val();
            if (informationTitle != undefined && informationTitle == '输入资讯名称') {
                $('#informationTitle').val("");
            }


            //场馆
            $(formName).submit();
        }
    </script>
</head>
<body  >
<form id="informationForm" action="" method="post">
    <div class="site">
        <em>您现在所在的位置：</em>咨询管理&gt; 咨询列表
    </div>
    <div class="search">
        <div class="search-box">
            <i></i><input type="text" id="informationTitle" name="informationTitle" value="${information.informationTitle}"
                          data-val="输入资讯名称" class="input-text"/>
        </div>
        <div class="select-btn">
            <input type="button" onclick="$('#page').val(1);formSub('#informationForm');" value="搜索"/>

        </div>

    </div>

    <div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th>ID</th>
                <th class="title">标题</th>
                <th>作者</th>
                <th>发布者</th>
                <th>最新操作时间</th>
                <th>管理</th>
            </tr>
            </thead>

            <tbody>
            <%int i = 0;%>
            <c:forEach items="${informationList}" var="info">
                <%i++;%>
                <tr>
                    <td><%=i%></td>
                    <td class="title">${info.informationTitle}</td>
                    <td>${info.authorName}</td>
                    <td>${info.publisherName}</td>
                    <td><c:if test="${not empty info.informationUpdateTime}">
                        <fmt:formatDate value="${info.informationUpdateTime}" pattern="yyyy-MM-dd HH:mm"/>
                    </c:if></td>
                    <td><a target="main"
                           href="${path}/information/preAddInformation.do?informationId=${info.informationId}">编辑</a> |
                        <a class="copyButton" data-clipboard-text='http://www.wenhuayun.cn/information/preInfo.do?informationId=${info.informationId}'
                           href="javascript:copyUrl('http://www.wenhuayun.cn/information/preInfo.do?informationId=${info.informationId}');">复制URL</a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty informationList}">
                <tr>
                    <td colspan="8"><h4 style="color:#DC590C">暂无数据!</h4></td>
                </tr>
            </c:if>
            </tbody>
        </table>
        <c:if test="${not empty informationList}">
            <input type="hidden" id="page" name="page" value="${page.page}"/>
            <div id="kkpager"></div>
        </c:if>
    </div>

</form>
</body>
</html>
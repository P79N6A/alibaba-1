<%@ page language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>

    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <%@include file="/WEB-INF/why/common/limit.jsp" %>

    <script type="text/javascript">
        $(function () {
            getPage();
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
                    formSub('#contactForm');
                    return false;
                }
            });
        }
        function formSub(formName){
            $(formName).submit();
        }
    </script>
</head>
<body>
<form action="${path}/contact/contactPage.do" id="contactForm" method="post">
    <div class="site">
        <em>您现在所在的位置：</em>运维管理 &gt; 联系我们列表
    </div>
    <div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th width="50">ID</th>
                <th width="200">称呼</th>
                <th width="400">公司</th>
                <th width="150">电话</th>
                <th width="110">评论时间</th>
            </tr>
            </thead>
            <c:if test="${fn:length(contactusList) gt 0}">
                <tbody>
                <%int i = 0;%>
                <c:forEach items="${contactusList}" var="List">
                    <%i++;%>
                    <tr style="height:80px" >
                        <td><%=i%>
                        </td>
                        <td>
                                ${List.contactName}
                        </td>
                        <td>
                                ${List.corporation}
                        </td>
                        <td>
                                ${List.contact}
                        </td>
                        <td>
                            <fmt:formatDate value="${List.contactTime}" pattern="yyyy-MM-dd HH:mm"/>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </c:if>
            <c:if test="${empty contactusList}">
                <tr>
                    <td colspan="7"><h4 style="color:#DC590C">暂无数据!</h4></td>
                </tr>
            </c:if>
        </table>
        <c:if test="${not empty contactusList}">
            <input type="hidden" id="page" name="page" value="${page.page}"/>
            <div id="kkpager"></div>
        </c:if>
    </div>
</form>
</body>
</html>
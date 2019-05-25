<%@ page language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>每日一诗用户列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <%@include file="/WEB-INF/why/common/limit.jsp" %>

    <script type="text/javascript">

        $(function () {
        	
            kkpager.generPageHtml({
                pno: '${page.page}',
                total: '${page.countPage}',
                totalRecords: '${page.total}',
                mode: 'click',//默认值是link，可选link或者click
                click: function (n) {
                    this.selectPage(n);
                    $("#page").val(n);
                    formSub('#poemUserForm');
                    return false;
                }
            });
        	 
        });
        
      	//提交表单
        function formSub(formName) {
        	var userName = $('#userName').val();
            if (userName != undefined && userName == '输入用户名') {
                $('#userName').val("");
            }
        	var poemCompleteCount = $('#poemCompleteCount').val();
            if (poemCompleteCount != undefined && poemCompleteCount == '输入答题数') {
                $('#poemCompleteCount').val("");
            }
            $(formName).submit();
        }

    </script>
    
</head>

<body>
	<form id="poemUserForm" action="" method="post">
	    <div class="site">
	        <em>您现在所在的位置：</em>运维管理 &gt; 每日一诗管理 &gt; 参与用户列表
	    </div>
	    <div class="search">
		    <div class="search-box">
		        <input type="text" id="userName" name="userName" value="${entity.userName}" data-val="输入用户名" class="input-text"/>
		    </div>
		    <div class="search-box">
		        <input type="text" id="poemCompleteCount" name="poemCompleteCount" value="${entity.poemCompleteCount}" data-val="输入答题数" class="input-text"/>
		    </div>
		    <div class="select-btn" style="margin:0px 15px;">
		        <input type="button"  onclick="$('#page').val(1);formSub('#poemUserForm');" value="搜索"/>
		    </div>
		</div>
	    <div class="main-content">
	        <table width="100%">
	            <thead>
	            <tr>
	                <th width="30">ID</th>
	                <th width="100">UUID</th>
	                <th width="150">用户名</th>
	                <th width="150">手机号</th>
	                <th width="100">答对题数</th>
	                <th width="150">参与时间（首次答对）</th>
	            </tr>
	            </thead>
	            <tbody>
	            <%int i = 0;%>
	            <c:forEach items="${list}" var="dom">
	                <%i++;%>
	                <tr>
	                    <td><%=i%></td>
	                    <td>${dom.userId}</td>
	                    <td>${dom.userName}</td>
	                    <td>${dom.userMobile}</td>
	                    <td>${dom.poemCompleteCount}</td>
	                    <td><fmt:formatDate value="${dom.firstCompleteTime}" pattern="yyyy-MM-dd"/></td>
	                </tr>
	            </c:forEach>
	            <c:if test="${empty list}">
	                <tr>
	                    <td colspan="6"><h4 style="color:#DC590C">暂无数据!</h4></td>
	                </tr>
	            </c:if>
	            </tbody>
	        </table>
	        <c:if test="${not empty list}">
	            <input type="hidden" id="page" name="page" value="${page.page}"/>
	            <div id="kkpager"></div>
	        </c:if>
	    </div>
	</form>
</body>
</html>

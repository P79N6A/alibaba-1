<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>

    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>

    <script type="text/javascript">
        function testMysql(){
            var num = $("#num").val();
            if(num == undefined || $.trim(num) == ""){
                $("#num").focus();
                return;
            }
            $("#roleForm").submit();
        }
    </script>
</head>
<body>

<form action="${path}/test/testMysql.do" id="roleForm" method="post">
    <div class="search">
        <div class="search-box">
            <i></i><input class="input-text" name="num" type="text" id="num"/>
        </div>
        <div class="select-btn">
            <input type="button" value="测试" onclick="testMysql()"/>
        </div>
    </div>
</form>
</body>
</html>
<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>模板详情--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@ include file="/WEB-INF/why/common/limit.jsp"%>
</head>
<body>
<form id="dictForm" method="post" action="${path}/sysdict/dictIndex.do">
<div class="site">
    <em>您现在所在的位置：</em>模板管理 &gt; 模版管理
</div>
    ${fileContent}
</form>

</body>
</html>
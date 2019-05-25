<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>分配管理员--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
</head>
<body>
<div class="site">
    <em>您现在所在的位置：</em>场馆管理 &gt; 查看管理员
</div>
<div class="site-title">查看管理员</div>
<div class="main-content">
    <form id="assignForm">
        <table width="100%">
            <tr>
                <td>
                    <span>${sysUser.userNickName}</span>
                </td>
            </tr>
            <tr>
                <td class="td-btn">
                    <input type="button" value="返回" onclick="javascript:history.back(-1)"/>
                </td>
            </tr>
        </table>
    </form>
</div>

</body>
</html>
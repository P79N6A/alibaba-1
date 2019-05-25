<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:setLocale value="zh_CN"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/html">
<head>
    <title>文化云-社团会员详情</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <style>
    	
    </style>
</head>
<body>
<div class="site">
    <em>您现在所在的位置：</em>社团管理 &gt;社团招募列表 &gt; 查看社团会员详情
</div>
<div class="site-title"> 查看社团会员详情</div>
<!-- 正中间panel -->
<div class="main-publish">
    <table class="form-table" width="100%">
        <tbody>
        <tr>
            <td class="td-title" width = "130">申请社团：</td>
            <td class="td-input" >
                <span>${apply.assnName}</span>
            </td>
        </tr>
        <tr>
            <td class="td-title">申请时间：</td>
            <td class="td-input" >
                <span><fmt:formatDate value="${apply.applyTime}" pattern="yyyy-MM-dd HH:mm"/></span>
            </td>
        </tr>
        <tr>
            <td class="td-title">用户名：</td>
            <td class="td-input" >
                <span>${apply.userName}</span>
            </td>
        </tr>
        <tr>
            <td class="td-title">姓名：</td>
            <td class="td-input" >
                <span>${apply.applyName}</span>
            </td>
        </tr>
        <tr>
            <td class="td-title">身份证号：</td>
            <td class="td-input" >
                <span>${apply.applyCard}</span>
            </td>
        </tr>
        <tr>
            <td class="td-title">联系方式：</td>
            <td class="td-input" >
                <span>${apply.moblie}</span>
            </td>
        </tr>
        <tr>
            <td class="td-title">个人简介:</td>
            <td class="td-input">
            <span>${apply.personProfile}</span>
            </td>
        </tr>
        <tr>
            <td class="td-title"></td>
            <td class="td-input">
            <%-- <span>${apply.pic}</span> --%>
	            <c:set value="${fn:split(apply.pic, ',')}" var="names" />
				<c:forEach items="${names}" var="name">
					<img src="${name}" width="150px" height="120px"/>
				</c:forEach>
            </td>
        </tr>
        
        <tr class="submit-btn">
            <td></td>
            <td class="td-btn">
                <input type="button" class="btn-publish" value="返回" onclick="javascript :history.back(-1);"/>
            </td>
        </tr>
        </tbody>
    </table>
</div>
<script>
function addImgClickEvent(){       
	var objs = document.getElementsByTagName("img");       
	for(var i=0;i<objs.length;i++) {         
		objs[i].onclick=function(){
			window.open(this.src);
		}         
		objs[i].style.cursor = "pointer"; 
	}    
}     
addImgClickEvent(); 
</script>
</body>
</html>

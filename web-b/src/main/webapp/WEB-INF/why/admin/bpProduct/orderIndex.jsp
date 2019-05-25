<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>预约信息列表--文化云</title>
    <%@include file="../../common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    <script type="text/javascript">
    $(function(){
        kkpager.generPageHtml({
            pno : '${page.page}',
            total : '${page.countPage}',
            totalRecords :  '${page.total}',
            mode : 'click',//默认值是link，可选link或者click
            click : function(n){
                this.selectPage(n);
                $("#page").val(n);
                $("#orderIndexForm").submit();
                return false;
            }
        });
    });
    function showInfo(info){
    	dialogSaveDraft("备注", info, function(){
            
        });
    }; 
    </script>
</head>
<body>
	<form id="orderIndexForm" action="${path}/bpProduct/orderIndex.do" method="post">
	<input type="hidden" name="productId" value="${productId }">
	    <div class="site">
	        <em>您现在所在的位置：</em>文化商城&gt; 文化商城列表&gt; 预约信息列表
	    </div>
	<div class="main-content pt10">
	    <table width="100%">
	        <thead>
	        <tr>
	            <th>ID</th>
	            <th class="title">姓名</th>
	            <th>联系方式</th>
	            <th>备注</th>
	            <th>预约时间</th>
	        </tr>
	
	        </thead>
	        <c:if test="${empty orderList}">
	            <tr>
	                <td colspan="5"> <h4 style="color:#DC590C">暂无数据!</h4></td>
	            </tr>
	        </c:if>
	
	        <tbody>
	
	        <c:forEach items="${orderList}" var="c" varStatus="s">
	            <tr>
	                <td>${s.index+1}</td>
	                <td class="title">${c.userName}</td>
	             	<td>${c.userTel}</td>
	             	<td>
	             		<c:choose >
	             			<c:when test="${fn:length(c.orderRemark)>20 }"><a href="javascript:showInfo('${c.orderRemark}')">${fn:substring(c.orderRemark, 0, 20)}...</a> </c:when>
	             			<c:otherwise><a href="javascript:showInfo('${c.orderRemark}')">${c.orderRemark}</a></c:otherwise>  
	             		</c:choose>
	             	</td> 
	             	<td><fmt:formatDate value="${c.orderTime}" pattern="yyyy-MM-dd HH:mm" /></td>
	            </tr>
	        </c:forEach>
	        </tbody>
	    </table>
	</div>
	    <c:if test="${not empty orderList}">
	        <input type="hidden" id="page" name="page" value="${page.page}" />
	        <div id="kkpager"></div>
	    </c:if>
	</form>
</body>
</html>
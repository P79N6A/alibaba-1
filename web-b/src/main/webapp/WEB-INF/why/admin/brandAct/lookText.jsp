<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>查看</title>
    <style type="">
   		table { table-layout: fixed;word-wrap:break-word;}
   		div { word-wrap:break-word;}
	</style>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
	
</head>
<%   request.setAttribute("vEnter", "\r\n");   %>
<body style="background: none;);">
<form id="roleForm">
    <div class="main-publish tag-add">
            <table width="100%" class="form-table" >
                <tr>
                    <td class="td-title" style="text-align:left;" width="20%">
	                    <c:if test="${flag==0 }">
	                    	${fn:replace(cmsActivityBrand.actText, vEnter, "<br/>")}
	                    </c:if>
	                    <c:if test="${flag==1 }">
	                    	${cmsActivityBrand.imgSrc}
	                    </c:if>
	                    <c:if test="${flag==2 }">
	                    	${cmsActivityBrand.actUrl}
	                    </c:if>
                    </td>
                </tr>
            </table>
    </div>
</form>
</body>
</html>
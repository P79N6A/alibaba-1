<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style type="">
   .housel {width: 30%;height: 30px;border: none;color: #444444;font-family: \5FAE\8F6F\96C5\9ED1;margin-left: 0%;margin-top: 1px;border: solid 1px #ACB4C3;}
</style>
 </head>
 <%   request.setAttribute("vEnter", "\r\n");   %>
<body>
	<form action="" id="batchForm" method="post">
	    <div class="site">
	        <em>您现在所在的位置：</em>
	        
	   <c:choose>
            <c:when test="${flag==1}">
        		音乐征文管理 
            </c:when>
            <c:otherwise>
                                      电影征文管理
           </c:otherwise>
       </c:choose>     
	   &gt; 查看信息
	    </div>
	    <div class="site-title">查看信息</div>
	    <div class="main-publish">
	        <table width="100%" class="form-table">
	            <tr>
	                <td width="100" class="td-title">姓名：</td>
	                <td width="300">
	                   ${EntityArticle.userRealName}
	                </td>
	            </tr>
	            <tr>
	                <td width="100" class="td-title">手机号：</td>
	                <td width="300">${EntityArticle.userMoblieNo}</td>
	            </tr>
	            <tr>
	                <td width="100" class="td-title">文章标题：</td>
	                <td width="300">
	                    ${EntityArticle.articleTitle }
	                </td>
                </tr>
                <tr>
	                <td width="100" class="td-title">文章内容：</td>
	                <td width="300">
	                	${fn:replace(EntityArticle.articleText, vEnter, "<br/>")}
	                </td>
                </tr>
                <tr>
	                <td width="100" class="td-title">审核状态：</td>
	                <td width="300">
	                    <c:if test="${EntityArticle.articleIsDel==0 }">
	                      审核通过
	                    </c:if>
	                    <c:if test="${EntityArticle.articleIsDel==1 }">
	                      审核不通过
	                    </c:if>
	                </td>
                </tr>
                <tr>
	                <td width="100" class="td-title">票数：</td>
	                <td width="300">
	                     ${EntityArticle.articleLike }
	                </td>
                </tr>
                <tr>
	                <td width="100" class="td-title">文章创建时间：</td>
	                <td width="300">
	                    <fmt:formatDate value="${EntityArticle.articleCreateTime }"  pattern="yyyy-MM-dd HH:mm:ss" type="both"/>
	                </td>
                </tr>
		        <tr>
	                <td width="100" class="td-title"></td>
	                <td class="td-btn">
	                    <div class="room-order-info info2" style="position: relative;">
	                        <input type="button"   class="btn-publish" onclick="javascript:history.go(-1);" value="返回"/>
	                    </div>
	                </td>
	            </tr>
	        </table>
	    </div>
</form>
</body>
</html>
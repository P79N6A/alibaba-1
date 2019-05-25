<%@ page language="java"  pageEncoding="UTF-8"%>

<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>互动管理列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    <script type="text/javascript">
        $(function(){
        	//分页
            kkpager.generPageHtml({
                pno : '${page.page}',
                total : '${page.countPage}',
                totalRecords :  '${page.total}',
                mode : 'click',//默认值是link，可选link或者click
                click : function(n){
                    this.selectPage(n);
                    $("#page").val(n);
                    searchContestTopic();
                    return false;
                }
            });
        });
        function searchContestTopic(){
            var userName = $('#userName').val();
            if (userName == '请输入用户名称或手机号') {
                $('#userName').val("");
            }
            
            $("#backForm").submit();
        }
        
    </script>
</head>
<body>

 
<form id="backForm" method="post" action="">
<div class="site">
    <em>您现在所在的位置：</em>运维管理 &gt; 知识问答&gt;用户信息
</div>
<div class="search">
    
	<div class="search-box">
        <i></i><input value="<c:choose><c:when test="${not empty cmsUserAnswer.userName}">${cmsUserAnswer.userName}</c:when><c:otherwise>请输入用户名称或手机号</c:otherwise></c:choose>" name="userName" id="userName" class="input-text" data-val="请输入用户名称或手机号" type="text"/>
    </div>
    <div class="select-btn">
        <input type="button" value="搜索" onclick="searchContestTopic()"/>
    </div>
</div>
<div class="main-content">
   <table width="100%">
        <thead>
        <tr>
            <th>序号</th>
            <th class="title">用户名称</th>
            <th >答对题数</th>
            <th>手机号码</th>
            <th>答题时间</th>
        </tr>
        </thead>
        <tbody id="questionAnwser">
        <%int i=0;%>
        <c:if test="${!empty userAnswersList}">
            <c:forEach items="${userAnswersList}" var="userMessage" varStatus="status">
            <%i++; %>
                <tr>
                  <td width="170"><%=i %></td>
                  <td width="10">${userMessage.userName }</td>
 				  <td width="170">${userMessage.userScore}</td>
				  <td width="170">${userMessage.userMobile}</td>
				  <td width="170">
				  <fmt:formatDate value="${userMessage.createTime}" pattern="yyyy-MM-dd HH:mm"/>
				  </td>
                </tr>
            </c:forEach>
        </c:if>
        <c:if test="${empty userAnswersList}">
            <tr>
                <td colspan="8"><h4 style="color:#DC590C">暂无数据!</h4></td>
            </tr>
        </c:if>
        </tbody>
    </table>
    </div>
    <c:if test="${not empty userAnswersList}">
        <input type="hidden" id="page" name="page" value="${page.page}" />
        <div id="kkpager"></div>
    </c:if>
</form>
</body>
</html>
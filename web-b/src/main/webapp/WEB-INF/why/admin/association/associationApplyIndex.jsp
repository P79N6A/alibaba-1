<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>社团申请列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
    
    <script type="text/javascript">

        //搜索
        function formSub(formName){
            var  assnName=$('#assnName').val();
            if(assnName!=undefined&&assnName=='输入社团名称'){
                $('#assnName').val("");
            }
            $(formName).submit();
        }
        
        $(document).ready(function(){
            //分页
            kkpager.generPageHtml({
                pno : '${page.page}',
                total : '${page.countPage}',
                totalRecords :  '${page.total}',
                mode : 'click',//默认值是link，可选link或者click
                click : function(n){
                    this.selectPage(n);
                    $("#page").val(n);
                    formSub('#associationForm');
                    return false;
                }
            });
        });
        
    </script>
    <style type="text/css">
        .ui-dialog-title,.ui-dialog-content textarea{ font-family: Microsoft YaHei;}
        .ui-dialog-header{ border-color: #9b9b9b;}
        .ui-dialog-close{ display: none;}
        .ui-dialog-title{ color: #F23330; font-size: 20px; text-align: center;}
        .ui-dialog-content{}
        .ui-dialog-body{}
    </style>
</head>
<body>
	<form id="associationForm" action="${path}/association/associationApplyIndex.do" method="post">
	    <input type="hidden" name="assnId" value="${association.assnId}"/>
	    <div class="site">
		    <em>您现在所在的位置：</em>社团管理 &gt;社团列表
		</div>
		<div class="search">
		    <div class="search-box">
		        <i></i><input type="text" id="assnName" name="assnName" value="${association.assnName}" data-val="输入社团名称" class="input-text"/>
		    </div>
		
		    <div class="select-btn">
		        <input type="button" onclick="$('#page').val(1);formSub('#associationForm');" value="搜索"/>
		    </div>
		</div>
		<div class="main-content">
		    <table width="100%">
		        <thead>
			        <tr>
			            <th width="30">ID</th>
			            <th width="120">类型</th>
			            <th class="title">社团名称</th>
			            <th width="120">联系人</th>
			            <th width="120">联系电话</th>
			            <th width="120">创建人</th>
			            <th width="120">创建时间</th>
			            <th width="200">创建单位</th>
			            <th>简介</th>
			        </tr>
		        </thead>
		        <tbody>
		        <%int i=0;%>
		        <c:forEach items="${assnApplyList}" var="assnApply">
		            <%i++;%>
		            <tr>
		                <td ><%=i%></td>
		                <td>${assnApply.assnType}</td>
	                    <td class="title">${assnApply.assnName}</td>
		                <td>${assnApply.assnLinkman}</td>
		                <td>${assnApply.assnPhone}</td>
		                <td>
		                	<c:choose>
		                		<c:when test="${not empty assnApply.createSuser}">${assnApply.createSuser}</c:when>
		                		<c:otherwise>${assnApply.createTuser}</c:otherwise>
                            </c:choose>
                        </td>
	                    <td> <fmt:formatDate value="${assnApply.createTime}"  pattern="yyyy-MM-dd" /></td></td>
	                    <td>${assnApply.deptName}</td>
	                    <td>${assnApply.assnIntroduce}</td>
		            </tr>
		        </c:forEach>
		
		        <c:if test="${empty assnApplyList}">
		            <tr>
		                <td colspan="8"><h4 style="color:#DC590C">暂无数据!</h4></td>
		            </tr>
		        </c:if>
		        </tbody>
		    </table>
		
		    <input type="hidden" id="page" name="page" value="${page.page}" />
		    <div id="kkpager"></div>
		</div>
	</form>
</body>
</html>
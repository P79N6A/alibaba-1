<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>文化志愿者管理--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
    
    <script type="text/javascript">

        //搜索
       function formSub(formName){
         
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
                    formSub('#form');
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
	<form id="form" action="" method="post">
	    <div class="site">
		    <em>您现在所在的位置：</em>文化志愿者管理 &gt;志愿者申请列表
		</div>
		<!-- <div class="search">
		    <div class="search-box">
		        <i></i><input type="text" id="noteTitle" name="noteTitle" value="${ccpMicronote.noteTitle}" data-val="输入微笔记标题" class="input-text"/>
		    </div>
		
		    <div class="select-btn">
		        <input type="button" onclick="$('#page').val(1);formSub('#form');" value="搜索"/>
		    </div>
		</div> -->
		<div class="main-content">
		    <table width="100%">
		        <thead>
			        <tr>
			            <th width="30">ID</th>
			            <th width="150">申请人账号</th>
			            <th width="150">招募活动</th>
			            <th width="150">姓名</th>
			            <th width="120">手机</th>
			            <th width="80">年龄</th>
			            <th width="80">性别</th>
			            <th width="120">学历</th>
			            <th width="120">申请时间</th>
			           <!-- <th width="50">申请状态</th>
			             <th width="200">管理</th> -->
			        </tr>
		        </thead>
		        <tbody>
		        <%int i=0;%>
		        <c:forEach items="${list}" var="volunteerApply">
		            <%i++;%>
		            <tr>
		                <td ><%=i%></td>
		                <td>${volunteerApply.userName}</td>
		                <c:choose>
		                	<c:when test="${!empty volunteerApply.recruitName}">
		                		<td>${volunteerApply.recruitName}</td>
		                	</c:when>
		                	<c:otherwise>
		                		<td>不限</td>
		                	</c:otherwise>
		                </c:choose>
		                
		                <td>${volunteerApply.volunteerRealName}</td>
		                <td>${volunteerApply.volunteerMobile}</td>
	                    <td>${volunteerApply.volunteerAge}</td>
	                    <td>
	                    <c:choose>
	                    	<c:when test="${volunteerApply.volunteerSex==0}">
	                    		男
	                    	</c:when>
	                    	<c:when test="${volunteerApply.volunteerSex==1}">
	                    		女
	                    	</c:when>
	                    </c:choose>
	                    </td>
		                <td>${volunteerApply.dictName}</td>
		                <td><fmt:formatDate value="${volunteerApply.applyDateTime}"  pattern="yyyy-MM-dd HH:mm" type="both"/></td>
		                <!--   <td>
		                <c:choose>
		                	<c:when test="${volunteerApply.applyStatus==0}">
		                	 待审核
		                	</c:when>
		                	<c:when test="${volunteerApply.applyStatus==1}">
		                	审核通过
		                	</c:when>
		                		<c:when test="${volunteerApply.applyStatus==2}">
		                	审核不通过
		                	</c:when>
		                </c:choose>
						</td>
	                  <td>
                        	<a target="main" href="javascript:;" onclick="deleteNote('${note.noteId}')">删除</a>
                        </td> -->
		            </tr>
		        </c:forEach>
		
		        <c:if test="${empty list}">
		            <tr>
		                <td colspan="8"><h4 style="color:#DC590C">暂无数据!</h4></td>
		            </tr>
		        </c:if>
		        </tbody>
		    </table>
		
			<c:if test="${not empty list}">
	            <input type="hidden" id="page" name="page" value="${page.page}" />
		    	<div id="kkpager"></div>
	        </c:if>
		</div>
	</form>
</body>
</html>
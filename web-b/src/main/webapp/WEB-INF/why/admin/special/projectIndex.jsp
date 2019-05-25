<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
    
	<link rel="stylesheet" type=+"text/css" href="${path}/STATIC/css/dialog-back.css"/>
	<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    
    <script type="text/javascript">

        //搜索
       function formSub(formName){
         
            $(formName).submit();
        }
        
       seajs.config({
           alias: {
               "jquery": "jquery-1.10.2.js"
           }
       });

       seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
           window.dialog = dialog;
       });

       window.console = window.console || {log:function () {}}

       seajs.use(['jquery'], function ($) {
           $('.btn-add').click(function () {
               dialog({
                   url: '${path}/specialProject/preSaveProject.do',
                   title: '新增活动主题',
                   width: 500,
                   fixed: true
               }).showModal();
               return false;
           });

           $('.btn-edit').click(function () {
               var projectId = $(this).attr("projectId");
               dialog({
                   url: '${path}/specialProject/preSaveProject.do?projectId='+projectId,
                   title: '编辑活动主题',
                   width: 500,
                   fixed: true
               }).showModal();
               return false;
           });
           
           $(".delete").click(function () {
               var projectId = $(this).attr("projectId");
               var name = $(this).parent().siblings(".title").text();
               var html = "您确定要删除" + name + "吗？";
               dialogConfirm("提示", html, function(){
                   $.post("${path}/specialProject/saveProject.do",{projectId:projectId,projectIsDel:2},function(data) {
                       if (data == 'success') {
                    	   formSub('#form');
                       }
                   });
               })
           });
          
       });

        
        
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
		    <em>您现在所在的位置：</em>渠道管理 &gt;活动主题列表
		</div>
       
            <div class="search menage">
                <div class="menage-box">
                    <a class="btn-add">新增活动主题</a>
                </div>
            </div>
     
		</div>
		<div class="main-content">
		    <table width="100%">
		        <thead>
			        <tr>
			            <th width="30">ID</th>
			            <th class="title" width="150">活动主题名称</th>
			            <th width="150">活动主题首页url</th>
			            <th width="150">创建时间</th>
			            <th width="200">管理</th>
			        </tr>
		        </thead>
		        <tbody>
		        <%int i=0;%>
		        <c:forEach items="${list}" var="entity">
		            <%i++;%>
		            <tr>
		                <td ><%=i%></td>
		                <td class="title">${entity.projectName}</td>
		               
		                <td>${entity.projectIndexUrl}</td>
	                 
		                <td><fmt:formatDate value="${entity.projectCreateTime}"  pattern="yyyy-MM-dd HH:mm" type="both"/></td>
		                 <td>
                               <a class="delete" projectId="${entity.projectId}">删除</a> |
                           
                      			<a projectId="${entity.projectId}" class="btn-edit">编辑</a>
                        </td>
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
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
                   url: '${path}/specialEnter/preSaveEnter.do',
                   title: '新增渠道入口',
                   width: 500,
                   fixed: true
               }).showModal();
               return false;
           });

           $('.btn-edit').click(function () {
               var enterId = $(this).attr("enterId");
               dialog({
                   url: '${path}/specialEnter/preSaveEnter.do?enterId='+enterId,
                   title: '编辑渠道入口',
                   width: 500,
                   fixed: true
               }).showModal();
               return false;
           });
           
           $(".delete").click(function () {
               var enterId = $(this).attr("enterId");
               var name = $(this).parent().siblings(".title").text();
               var html = "您确定要删除" + name + "吗？";
               dialogConfirm("提示", html, function(){
                   $.post("${path}/specialEnter/saveEnter.do",{enterId:enterId,enterIsDel:2},function(data) {
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
		    <em>您现在所在的位置：</em>渠道管理 &gt;渠道入口列表
		</div>
       
            <div class="search menage">
                <div class="menage-box">
                    <a class="btn-add">新增渠道入口</a>
                </div>
            </div>
     
		</div>
		<div class="main-content">
		    <table width="100%">
		        <thead>
			        <tr>
			            <th width="30">ID</th>
			            <th class="title" width="150">渠道入口名称</th>
			             <th width="150">活动主题</th>
			             <th width="150">图片logo</th>
			            <th width="150">入口参数路径</th>
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
		                <td class="title">${entity.enterName}</td>
		                
		                <td>${entity.projectName}</td>
		                
		                 <td>
		                 	<c:choose>
		                 		<c:when test="${empty  entity.enterLogoImageUrl}">
		                 			无
		                 		</c:when>
		                 		<c:otherwise>
		                 			<img src="${entity.enterLogoImageUrl}@300w" style="height: 50px;width: 50px;" />
		                 		</c:otherwise>
		                 	</c:choose> 
		                 
		                 </td>
		               
		                <td>${entity.enterParamePath}</td>
	                 
		                <td><fmt:formatDate value="${entity.enterCreateTime}"  pattern="yyyy-MM-dd HH:mm" type="both"/></td>
		                 <td>
                               <a class="delete" enterId="${entity.enterId}">删除</a> |
                           
                      			<a enterId="${entity.enterId}" class="btn-edit">编辑</a>
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
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
                   url: '${path}/specialCustomer/preSaveCustomer.do',
                   title: '新增渠道客户',
                   width: 500,
                   fixed: true
               }).showModal();
               return false;
           });

           $('.btn-edit').click(function () {
               var customerId = $(this).attr("customerId");
               dialog({
                   url: '${path}/specialCustomer/preSaveCustomer.do?customerId='+customerId,
                   title: '编辑渠道客户',
                   width: 500,
                   fixed: true
               }).showModal();
               return false;
           });
           
           $(".delete").click(function () {
               var customerId = $(this).attr("customerId");
               var name = $(this).parent().siblings(".title").text();
               var html = "您确定要删除" + name + "吗？";
               dialogConfirm("提示", html, function(){
                   $.post("${path}/specialCustomer/saveCustomer.do",{customerId:customerId,customerIsDel:2},function(data) {
                       if (data == 'success') {
                    	   formSub('#form');
                       }
                   });
               })
           });
           
           $(".code").click(function () {
        	   var customerId = $(this).attr("customerId");
               dialog({
                   url: '${path}/specialCustomer/preSaveYCode.do?customerId='+customerId,
                   title: '生成Y码',
                   width: 500,
                   fixed: true
               }).showModal();
               return false;
           });
           
           $(".codeManager").click(function () {
        	   var customerId = $(this).attr("customerId");
        	   
        	   window.location.href = '../specialYcode/index.do?customerId='+customerId;
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
		    <em>您现在所在的位置：</em>渠道管理 &gt;渠道客户列表
		</div>
       
            <div class="search menage">
                <div class="menage-box">
                    <a class="btn-add">新增渠道客户</a>
                </div>
            </div>
     
		</div>
		<div class="main-content">
		    <table width="100%">
		        <thead>
			        <tr>
			            <th width="30">ID</th>
			            <th  width="100">渠道客户名称</th>
			             <th width="80">客户类型</th>
			             <th width="100">活动主题</th>
			             <th width="100">活动专属页</th>
			             <th width="100">渠道入口</th>
			             <th width="150">图片logo</th>
			             <th width="150">Y码兑换开始日期</th>
			            <th width="150">Y码兑换结束日期</th>
			            <th width="150">创建日期</th>
			            <th width="">管理</th>
			        </tr>
		        </thead>
		        <tbody>
		        <%int i=0;%>
		        <c:forEach items="${list}" var="entity">
		            <%i++;%>
		            <tr>
		                <td ><%=i%></td>
		              
		                 <td>${entity.customerName}</td>
		                 
		                  <td>${entity.customerType}</td>
		                 
		                <td>${entity.projectName}</td>
		                
		                  <td>${entity.pageName}</td>
		                
		                  <td>${entity.enterName}</td>
		                  
		                    
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
		                  
		                  <td>
		                  <fmt:formatDate value="${entity.ycodeStartTime}"  pattern="yyyy-MM-dd HH:mm" type="both"/>
		                  </td>
		                  
		                  <td>
		                  <fmt:formatDate value="${entity.ycodeEndTime}"  pattern="yyyy-MM-dd HH:mm" type="both"/>
		                  </td>
	                 
		                <td><fmt:formatDate value="${entity.customerCreateTime}"  pattern="yyyy-MM-dd HH:mm" type="both"/></td>
		                 <td>
                               <a class="delete" customerId="${entity.customerId}">删除</a> |
                           
                      			<a customerId="${entity.customerId}" class="btn-edit">编辑</a> |
                      			
                      			 <a class="code" customerId="${entity.customerId}">生成Y码</a> |
                      			 
                      			  <a class="codeManager" customerId="${entity.customerId}">管理Y码</a>
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
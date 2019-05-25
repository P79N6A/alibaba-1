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

        //搜索@300w
       function formSub(formName){
         
            $(formName).submit();
        }
        

       //全选或全不选
       function selectActivityIds(){
    	   
    	   var checked=$("#checkAll").prop("checked");
    	   
           $("#list-table :checkbox").each(function () {
        	   
               if (checked) {
                   $(this).prop("checked", true);
               } else {
                   $(this).prop("checked", false);
               }
           });
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
           $('#addCode').click(function () {
        	   var customerId=$("#customerId").val();
               dialog({
                   url: '${path}/specialCustomer/preSaveYCode.do?customerId='+customerId,
                   title: '生成Y码',
                   width: 500,
                   fixed: true
               }).showModal();
               return false;
           });
           
           $('#sendCode').click(function () {
        	   var customerId=$("#customerId").val();
        	   
        	   var ids=new Array();
        	   
        	   $("#list-table input[name='codeId']:checked").each(function(){
        		   ids.push($(this).val());
        	   }); 
        	   
        	   if(ids.length>0)
	        	{
        		   var html = "您确定要发送选中的Y码吗？";
                   dialogConfirm("提示", html, function(){
                       $.post("${path}/specialYcode/sendCode.do",{codeIds:ids.join(",")},function(data) {
                           if (data == 'success') {
                        	   formSub('#form');
                           }
                           else
                        	   dialogAlert("提示", "发送失败，系统错误！");
                       });
                   })   
	        	}
        	   else
        		{
        		   dialogAlert("提示", "请先勾选要发送的Y码！");
        		}
            });
           
           $('#exportCode').click(function () {
           
        	   var customerId=$("#customerId").val();
        	   
        	   location.href = "${path}/specialYcode/exportCode.do?customerId="+customerId;
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
	<form id="form" action="${path}/specialYcode/index.do" method="post">
	<input type="hidden" name="customerId" id="customerId" value="${entity.customerId }"/>
	    <div class="site">
		    <em>您现在所在的位置：</em>渠道管理 &gt;渠道客户列表 &gt;Y码列表
		</div>
       
            <div class="search menage">
            	 <div class="menage-box">
                    <a id="addCode" class="btn-add">生成Y码</a>
                </div>
            	<div class="menage-box">
                    <a id="sendCode" class="btn-add">发送Y码</a>
                </div>
               <div class="menage-box">
                    <a id="exportCode" class="btn-add">导出Y码</a>
                </div>
            </div>
     
		</div>
		<div class="main-content">
		    <table width="100%">
		        <thead>
			        <tr>
			        	<th width="30">全选<input type="checkbox" name="checkAll" id="checkAll" onclick="selectActivityIds()" /> </th>
			            <th width="30">ID</th>
			            <th width="150">兑换Y码</th>
			            <th width="100">Y码状态</th>
			            <th width="150">创建时间</th>
			        </tr>
		        </thead>
		        <tbody id="list-table">
		        <%int i=0;%>
		        <c:forEach items="${list}" var="entity">
		            <%i++;%>
		            <tr>
		            <td><input type="checkbox"  name="codeId"  value="${entity.codeId}" /></td>
		                <td ><%=i%></td>
		                <td >${entity.ycode}</td>
		               
	                 	<td>
	                 		<c:choose>
	                 			<c:when test="${entity.codeStatus ==0}">
	                 			未使用
	                 			</c:when>
	                 			<c:when test="${entity.codeStatus ==1}">
	                 			已发送
	                 			</c:when>
	                 			<c:when test="${entity.codeStatus ==2}">
	                 			已使用
	                 			</c:when>
	                 		</c:choose>
	                 	</td>
		                <td><fmt:formatDate value="${entity.ycodeCreateTime}"  pattern="yyyy-MM-dd HH:mm" type="both"/></td>
		               
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
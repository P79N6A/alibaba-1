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
        	
    	   if($("#dramaCommentRemark").val() == "输入评论"){
               $("#dramaCommentRemark").val("");
           }
         
            $(formName).submit();
        }
        
       function dialogTypeSaveDraft(title, content, fn){
           var d = window.dialog({
               width:400,
               title:title,
               content:content,
               fixed: true,
               okValue: '确 定',
               ok: function () {
                   if(fn)  fn();
               }
           });
           d.showModal();
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
    	   
    	   $(function () {
    	   
         
           $(".delete").click(function () {
               var dramaCommentId = $(this).attr("dramaCommentId");
               var html = "您确定要删除吗？";
               dialogConfirm("提示", html, function(){
                   $.post("${path}/drama/updateDramaComment.do",{dramaCommentId:dramaCommentId,dramaStatus:1},function(data) {
                       if (data == 'success') {
                    	   formSub('#form');
                       }
                   });
               })
           });
           
           
           $(".top").click(function () {
               var dramaCommentId = $(this).attr("dramaCommentId");
               var html = "您确定要置顶吗？";
               dialogConfirm("提示", html, function(){
                   $.post("${path}/drama/updateDramaComment.do",{dramaCommentId:dramaCommentId,dramaStatus:2},function(result) {
                	   if (result == "success") {
                       	dialogTypeSaveDraft("提示", "操作成功", function(){
                       		formSub('#form');
                           });
                       }else if (result == "login") {
                       	
                      	 dialogAlert('提示', '请先登录！', function () {
                   			window.location.href = "${path}/login.do";
   	                    	 });
                      }else{
                       	dialogTypeSaveDraft("提示", "操作失败");
                       }
                   });
               })
           });
           
           $(".untop").click(function () {
               var dramaCommentId = $(this).attr("dramaCommentId");
               var html = "您确定要取消置顶吗？";
               
               dialogConfirm("提示", html, function(){
                   $.post("${path}/drama/updateDramaComment.do",{dramaCommentId:dramaCommentId,dramaStatus:0},function(result) {
                	   if (result == "success") {
                       	dialogTypeSaveDraft("提示", "操作成功", function(){
                       		formSub('#form');
                           });
                       }else if (result == "login") {
                       	
                      	 dialogAlert('提示', '请先登录！', function () {
                   			window.location.href = "${path}/login.do";
   	                    	 });
                      }else{
                       	dialogTypeSaveDraft("提示", "操作失败");
                       }
                   });
               })
           });
           
           
           $(function () {
               var dramaId = $('#dramaId').val();
               $.post("../drama/dramaSelectList.do", function (data) {
                   if (data != '' && data != null) {
                       var list = eval(data);
                       var ulHtml = '<li data-option="">全部类型</li>';
                       for (var i = 0; i < list.length; i++) {
                           var drama = list[i];
                           ulHtml += '<li data-option="' + drama.dramaId + '">' + drama.dramaName + '</li>';
                           if (dramaId != '' && drama.dramaId == dramaId) {
                               $('#dramaIdDiv').html(drama.dramaName);
                           }
                       }
                       $('#dramaIdUl').html(ulHtml);
                   }
               }).success(function () {
                   selectModel();
               });
               
           });
           
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
		    <em>您现在所在的位置：</em>运维管理 &gt;戏剧评论管理
		</div>
		
		<div class="search">
		
		<div class="select-box w135">
            <input type="hidden" id="dramaId" name="dramaId" value="${entity.dramaId}"/>
            <div id="dramaIdDiv" class="select-text" data-value="">戏剧名</div>
            <ul class="select-option" id="dramaIdUl">
            </ul>
        </div>
        <div class="search-box">
            <i></i><input class="input-text" name="dramaCommentRemark" data-val="输入评论" value="<c:choose><c:when test="${not empty entity.dramaCommentRemark}">${entity.dramaCommentRemark}</c:when><c:otherwise>输入评论</c:otherwise></c:choose>" type="text" id="dramaCommentRemark"/>
        </div>
        <div class="select-btn">
            <input type="button" value="搜索" onclick="$('#page').val(1);formSub('#form');"/>
        </div>

    </div>
       
         <!--    <div class="search menage">
                <div class="menage-box">
                    <a class="btn-add">新增直播内容</a>
                </div>
            </div> -->
     
		<div class="main-content">
		    <table width="100%">
		        <thead>
			        <tr>
			            <th width="30">编号</th>
			            <th width="100">戏剧名</th>
			            <th width="100">发布人</th>
			            <th width="300">评论内容</th>
			            <th width="150">发布时间</th>
			           
			           	 <th width="">操作</th>
			        </tr>
		        </thead>
		        <tbody>
		        <%int i=0;%>
		        <c:forEach items="${list}" var="entity">
		            <%i++;%>
		            <tr>
		                <td ><%=i%></td>
		                
		                <td>${entity.dramaName}</td>
		                
		                  <td>${entity.userName}</td>
		                  
		                    <td>${entity.dramaCommentRemark}</td>
		                
		                  <td><fmt:formatDate value="${entity.createTime}"  pattern="yyyy-MM-dd HH:mm" type="both"/></td>
		                 
		                
		                 <td>
                               <a class="delete" dramaCommentId="${entity.dramaCommentId}">删除</a> |
                           
                      			 <c:choose>
                      			 	<c:when test="${entity.dramaStatus==0}">
                      			 		 
                      			 	 <a class="top" dramaCommentId="${entity.dramaCommentId}">置顶</a>
                      			 	</c:when>
                      			 	
                      			 	<c:when test="${entity.dramaStatus==2}">
                      			 	<a class="untop" dramaCommentId="${entity.dramaCommentId}">取消置顶</a>
                      			 	</c:when>
                      			 </c:choose>
                      			
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
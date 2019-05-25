<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%
	if(request.getSession().getAttribute("user")==null){
%>
<script>
	window.location.href="${pageContext.request.contextPath}/login.do";
</script>
<%
	}
%>

    <title>文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
    
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
	<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    
    <script type="text/javascript">

        //搜索
       function formSub(formName){
        	
    	   var liveActvityName = $('#liveActvityName').val();
           if (liveActvityName != undefined && liveActvityName == '输入直播活动标题') {
               $('#liveActvityName').val("");
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
           $('.btn-add').click(function () {
               dialog({
                   url: '${path}/live/preSaveMessage.do',
                   title: '新增直播',
                   width: 650,
                   fixed: true
               }).showModal();
               return false;
           });

           $('.btn-edit').click(function () {
               var messageId = $(this).attr("messageId");
               dialog({
                   url: '${path}/live/preSaveMessage.do?messageId='+messageId,
                   title: '编辑直播内容',
                   width: 650,
                   fixed: true
               }).showModal();
               return false;
           });
           
           $(".delete").click(function () {
               var messageId = $(this).attr("messageId");
               var html = "您确定要删除吗？";
               dialogConfirm("提示", html, function(){
                   $.post("${path}/live/saveMessage.do",{messageId:messageId,messageIsDel:2},function(data) {
                       if (data == 'success') {
                    	   formSub('#form');
                       }
                   });
               })
           });
           
           $(".recommend").click(function () {
               var messageId = $(this).attr("messageId");
               var html = "您确定要推荐互动消息吗？";
               dialogConfirm("提示", html, function(){
                   $.post("${path}/live/saveMessage.do",{messageId:messageId,messageIsRecommend:1},function(data) {
                       if (data == 'success') {
                    	   formSub('#form');
                       }
                   });
               })
           });
           
           
           
           
           $(".top").click(function () {
               var messageId = $(this).attr("messageId");
               var html = "您确定要置顶吗？";
               var messageActivity=$("#messageActivity").val();
               dialogConfirm("提示", html, function(){
                   $.post("${path}/live/setMessageTop.do",{messageId:messageId,messageActivity:messageActivity},function(result) {
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
               var messageId = $(this).attr("messageId");
               var html = "您确定要取消置顶吗？";
               var messageActivity=$("#messageActivity").val();
               dialogConfirm("提示", html, function(){
                   $.post("${path}/live/setMessageTop.do",{messageId:messageId,messageActivity:messageActivity},function(result) {
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
        .ui-dialog-title{ color: #F23330; font-size: 20px; text-align: center;}
        .ui-dialog-content{}
        .ui-dialog-body{}
    </style>
</head>
<body>
	<form id="form" action="" method="post">
	    <div class="site">
		    <em>您现在所在的位置：</em>直播管理 &gt;直播评论管理
		</div>
		<div class="search">
		
		  <div class="search-box">
            <i></i><input type="text" id="liveActvityName" name="liveActvityName" value="${liveActvityName}"
                          data-val="输入直播活动标题" class="input-text"/>
        </div>
	        <div class="select-btn">
	            <input type="button" onclick="$('#page').val(1);formSub('#form');" value="搜索"/>
	        </div>
	   	
		</div>
		
		</div>
		<div class="main-content">
		    <table width="100%">
		        <thead>
			        <tr>
			            <th width="30">编号</th>
			            <th width="150">直播活动标题</th>
			            <th  width="150">发布时间</th>
			             <th width="300">文字内容</th>
			             <th width="200">图片</th>
			             <th width="100">发布人</th>
			             <th width="100">发布人id</th>
			             <th width="50">是否推荐互动消息</th>
			             <th width="150">推荐时间</th>
			           	 <th width="">操作</th>
			        </tr>
		        </thead>
		        <tbody>
		        <%int i=0;%>
		        <c:forEach items="${list}" var="entity">
		            <%i++;%>
		            <tr>
		                <td ><%=i%></td>
		                
		                <td>${entity.liveActivityName}</td>
		                
		                  <td><fmt:formatDate value="${entity.messageCreateTime}"  pattern="yyyy-MM-dd HH:mm" type="both"/></td>
		              
		                 <td>${entity.messageContent}</td>
		                 
		                  <td>
		                 	<c:choose>
		                 		<c:when test="${empty  entity.messageImg}">
		                 			无
		                 		</c:when>
		                 		<c:otherwise>
									<c:forEach items="${fn:split(entity.messageImg, ',')}" var="img">
										<img class="bigCheck" src="${img}@300w" style="height: 50px;width: 50px;" />
									</c:forEach>
		                 		</c:otherwise>
		                 	</c:choose> 
		                 
		                 </td>
		                 
		                <td>${entity.messageCreateUserName}</td>
		                
		                <td>${entity.messageCreateUser}</td>
		                  
		                 <td>
		                 	<c:choose>
		                 		<c:when test="${ entity.messageIsRecommend==0}">
		                 			否
		                 		</c:when>
		                 		<c:when test="${ entity.messageIsRecommend==1}">
		                 			是
		                 		</c:when>	
		                 		<c:otherwise>
		                 			-
		                 		</c:otherwise>
		                 	</c:choose>
		                 </td>
		                 
		                  <td><fmt:formatDate value="${entity.messageRecommendTime}"  pattern="yyyy-MM-dd HH:mm" type="both"/></td>
		                 <td>
                               <a class="delete" messageId="${entity.messageId}">删除</a> 
                               
                               <c:if test="${ entity.messageIsRecommend==0}">
		                 			| <a class="recommend" messageId="${entity.messageId}">推荐</a> 
		                 		</c:if>
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
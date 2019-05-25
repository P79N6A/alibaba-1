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
    <%
		if(request.getSession().getAttribute("user")==null){
	%>
	<script>
		window.location.href="${pageContext.request.contextPath}/login.do";
	</script>
	<%
		}
	%>
    <script type="text/javascript">

        //搜索
       function formSub(formName){
         
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
    		   
    	            selectModel();
    	   
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
               var liveActivityId = $(this).attr("liveActivityId");
               dialog({
                   url: '${path}/live/preSaveMessage.do?liveActivityId='+liveActivityId,
                   title: '编辑直播内容',
                   width: 650,
                   fixed: true
               }).showModal();
               return false;
           });
           
           $(".delete").click(function () {
               var liveActivityId = $(this).attr("liveActivityId");
               var html = "您确定要删除吗？";
               dialogConfirm("提示", html, function(){
                   $.post("${path}/live/saveLiveActivity.do",{liveActivityId:liveActivityId,liveIsDel:2},function(result) {
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
           
           
           $(".push").click(function () {
               var liveActivityId = $(this).attr("liveActivityId");
               var html = "您确定要发布直播活动吗？";
               dialogConfirm("提示", html, function(){
                   $.post("${path}/live/saveLiveActivity.do",{liveActivityId:liveActivityId,liveStatus:1},function(result) {
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
           
           $(".end").click(function () {
               var liveActivityId = $(this).attr("liveActivityId");
               var html = "您确定要结束直播活动吗？";
               var messageActivity=$("#messageActivity").val();
               dialogConfirm("提示", html, function(){
                   $.post("${path}/live/saveLiveActivity.do",{liveActivityId:liveActivityId,liveStatus:2},function(result) {
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
           
           $(".check").click(function () {
               var liveActivityId = $(this).attr("liveActivityId");
               var html = "您确定要审核通过吗？";
               var messageActivity=$("#messageActivity").val();
               dialogConfirm("提示", html, function(){
                   $.post("${path}/live/saveLiveActivity.do",{liveActivityId:liveActivityId,liveCheck:2},function(result) {
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
           
           $(".addMessage").click(function () {
        	   var liveActivityId = $(this).attr("liveActivityId");
        	   
        	   
        	   window.location.href = "${path}/live/preSaveLiveActivityMessage.do?liveActivityId="+liveActivityId;
        	   
           });
           
           
           $(".addManyMessage").click(function () {
        	   var liveActivityId = $(this).attr("liveActivityId");
        	   
        	   dialog({
                   url: '${path}/live/preAddManyMessage.do?liveActivityId='+liveActivityId,
                   title: '批量添加内容',
                   width: 650,
                   fixed: true
               }).showModal();
               return false;
           });
           
          
           
    	   });
       });

       function copy(liveActivityId){
          	var clipBoardContent='m.wenhuayun.cn/wechatLive/liveActivity.do?liveActivityId=';
        	clipBoardContent=clipBoardContent+liveActivityId;
            
              	  dialogAlert('复制成功', clipBoardContent);
            
          }
        
        $(document).ready(function(){
        	
        	new Clipboard('.copyButton');
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
		<input id="messageActivity" name="messageActivity" type="hidden" value="3"/>
	    <div class="site">
		    <em>您现在所在的位置：</em>直播管理 &gt;直播活动管理
		</div>
        <div class="search">
          <div class="select-box w135">
            <input type="hidden" value="${liveActivityTimeStatus}" name="liveActivityTimeStatus"
                   id="liveActivityTimeStatus"/>
            <div class="select-text" data-value="">
                <c:choose>
                    <c:when test="${liveActivityTimeStatus == 1}">
                       正在直播
                    </c:when>
                         	
            <c:when test="${liveActivityTimeStatus == 2}">
                      尚未开始
                    </c:when>
                     <c:when test="${liveActivityTimeStatus == 3}">
                     已结束
                    </c:when>
                    <c:otherwise>
                    直播状态
                    </c:otherwise>
                </c:choose>
            </div>
            <ul class="select-option">
            	<li data-option="">直播状态</li>
                <li data-option="1"> 正在直播</li>
                <li data-option="2">尚未开始</li>
                <li data-option="3">已结束</li>
            </ul>
        </div>
        
        <div class="select-box w135">
            <input type="hidden" value="${liveStatus}" name="liveStatus"
                   id="liveStatus"/>
            <div class="select-text" data-value="">
                <c:choose>
                    <c:when test="${liveStatus == 0}">
                      未发布
                    </c:when>
                         	
            <c:when test="${liveStatus == 1}">
                      已发布
                    </c:when>
                    <c:when test="${ liveStatus==2}">
		                 			已结束
		                 		</c:when>
                    <c:otherwise>
                    </c:otherwise>
                </c:choose>
            </div>
            <ul class="select-option">
            	<li data-option="">发布状态</li>
                <li data-option="0">未发布</li>
                <li data-option="1">已发布</li>
                <li data-option="2">已结束</li>
            </ul>
        </div>
        
        <div class="select-box w135">
        <input type="hidden" value="${liveCheck}" name="liveCheck"
                   id="liveCheck"/>
            <div class="select-text" data-value="">
                <c:choose>
                    <c:when test="${liveCheck == 1}">
                      未审核
                    </c:when>
                         	
            <c:when test="${liveCheck == 2}">
                      审核通过
                    </c:when>
                    <c:when test="${ liveCheck==3}">
		                 			审核不通过
		                 		</c:when>
                    <c:otherwise>
                    </c:otherwise>
                </c:choose>
            </div>
            <ul class="select-option">
            	<li data-option="">审核状态</li>
                <li data-option="1">未审核</li>
                <li data-option="2">审核通过</li>
                <li data-option="3">审核不通过</li>
            </ul>
        </div>
        
        <div class="select-btn">
            <input type="button" onclick="$('#page').val(1);formSub('#form');" value="搜索"/>
        </div>
   <!--          <div class="search menage">
                <div class="menage-box">
                    <a class="btn-add">新增直播内容</a>
                </div>
            </div> -->
     
		</div>
		<div class="main-content">
		    <table width="100%">
		        <thead>
			        <tr>
			            <th width="30">编号</th>
			            <th  width="150">直播标题</th>
			            <!--    <th width="300">公告</th> -->
			            <th width="200">封面图片</th>
			             <th width="100">创建人</th>
			             <th width="150">创建时间</th>
			             <th width="50">发布状态</th>
			             <th width="50">直播状态</th>
			             <th width="150">直播开始时间</th>
			             <th width="150">直播结束时间</th>
			             <th width="50">审核状态</th>
			             <th width="150">审核通过时间</th>
			           	 <th width="">操作</th>
			        </tr>
		        </thead>
		        <tbody>
		        <%int i=0;%>
		        <c:forEach items="${list}" var="entity">
		            <%i++;%>
		            <tr>
		                <td ><%=i%></td>
		                
		                 <td>${entity.liveTitle}</td>
		                 
		                <!--  <td>${entity.liveTopText }</td> -->
		                
		              
		                  <td>
		                 	<c:choose>
		                 		<c:when test="${empty  entity.liveCoverImg}">
		                 			无
		                 		</c:when>
		                 		<c:otherwise>
									<c:forEach items="${fn:split(entity.liveCoverImg, ',')}" var="img">
										<img src="${img}@300w" style="height: 50px;width: 50px;" />
									</c:forEach>
		                 		</c:otherwise>
		                 	</c:choose> 
		                 </td>
		                 
		                  <td>${entity.userName}</td>
		                
		                  <td><fmt:formatDate value="${entity.liveCreateTime}"  pattern="yyyy-MM-dd HH:mm" type="both"/></td>
		                 
		                 <td>
		                 	   <c:choose>
		                 		<c:when test="${ entity.liveStatus==0}">
		                 			未发布
		                 		</c:when>
		                 		<c:when test="${ entity.liveStatus==1}">
		                 			已发布
		                 		</c:when>
		                 		<c:when test="${ entity.liveStatus==2}">
		                 			已结束
		                 		</c:when>
		                 		<c:otherwise>
									
		                 		</c:otherwise>
		                 	</c:choose> 
		                 </td>
		                 
		                 <td>
		                 	   <c:choose>
		                 		<c:when test="${ entity.liveActivityTimeStatus==1}">
		                 			正在直播
		                 		</c:when>
		                 		<c:when test="${ entity.liveActivityTimeStatus==2}">
		                 			尚未开始 
		                 		</c:when>
		                 		<c:when test="${ entity.liveActivityTimeStatus==3}">
		                 			已结束
		                 		</c:when>
		                 		<c:otherwise>
									
		                 		</c:otherwise>
		                 	</c:choose> 
		                 </td>
		                 <td><fmt:formatDate value="${entity.liveStartTime}"  pattern="yyyy-MM-dd HH:mm" type="both"/></td>
		                  <td><fmt:formatDate value="${entity.liveEndTime}"  pattern="yyyy-MM-dd HH:mm" type="both"/></td>
		                <td>
		                <c:choose>
		                 		<c:when test="${ entity.liveCheck==1}">
		                 			未审核 
		                 		</c:when>
		                 		<c:when test="${ entity.liveCheck==2}">
		                 			审核通过
		                 		</c:when>
		                 		<c:when test="${ entity.liveCheck==3}">
		                 			审核不通过
		                 		</c:when>
		                 		<c:otherwise>
									
		                 		</c:otherwise>
		                 		</c:choose>
		                </td>
		                <td>
		                <fmt:formatDate value="${entity.liveCheckTime}"  pattern="yyyy-MM-dd HH:mm" type="both"/>
		                </td>
		                 <td>
                            <a class="delete" liveActivityId="${entity.liveActivityId}">删除</a> 
                      			
                      		|  <a data-clipboard-text='m.wenhuayun.cn/wechatLive/liveActivity.do?liveActivityId=${entity.liveActivityId}' class="copyButton" onclick="copy('${entity.liveActivityId}')">复制链接</a>
                      			
                      		<c:if test="${ entity.liveStatus==0}">
                      		|  <a class="push" liveActivityId="${entity.liveActivityId}">发布直播</a>
                      		</c:if>
                      		
                      		<c:if test="${ entity.liveActivityTimeStatus==1}">
                      			|  <a class="end" liveActivityId="${entity.liveActivityId}">结束直播</a>
                      		</c:if>
                      		
                      		<c:if test="${ entity.liveCheck==1}">
		                 			|  <a class="check" liveActivityId="${entity.liveActivityId}">审核通过</a>
		                 		</c:if>
		                 		
		                 			|  <a class="addMessage" liveActivityId="${entity.liveActivityId}">添加评论</a>
		                 			
		                 			|  <a class="addManyMessage" liveActivityId="${entity.liveActivityId}">效果</a>
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
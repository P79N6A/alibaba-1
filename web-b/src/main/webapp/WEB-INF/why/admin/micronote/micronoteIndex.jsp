<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>微笔记列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
    
    <script type="text/javascript">

        //搜索
        function formSub(formName){
            var  noteTitle=$('#noteTitle').val();
            if(noteTitle!=undefined&&noteTitle=='输入微笔记标题'){
                $('#noteTitle').val("");
            }
            $(formName).submit();
        }
        
        //删除
        function deleteNote(noteId){
        	dialogConfirm("提示", "您确定要删除该笔记吗？", function(){
        		$.post("${path}/micronote/deleteMicronote.do", {noteId: noteId}, function (data) {
        			if(data.status==1) {
       	                dialogAlert('系统提示', "删除成功!");
       	             	formSub('#noteForm');
       	            }else{
       	                dialogAlert('系统提示', '删除失败!');
       	            }
        		},"json");
        	});
        }
        
        $(document).ready(function(){
            //分页
            kkpager.generPageHtml({
                pno : '${micronoteRes.resultIndex}',
                total : '${micronoteRes.countPage}',
                totalRecords :  '${micronoteRes.sum}',
                mode : 'click',//默认值是link，可选link或者click
                click : function(n){
                    this.selectPage(n);
                    $("#page").val(n);
                    formSub('#noteForm');
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
	<form id="noteForm" action="${path}/micronote/micronoteIndex.do" method="post">
		<input type="hidden" name="noteId" value="${ccpMicronote.noteId}"/>
	    <div class="site">
		    <em>您现在所在的位置：</em>微笔记管理 &gt;微笔记列表
		</div>
		<div class="search">
		    <div class="search-box">
		        <i></i><input type="text" id="noteTitle" name="noteTitle" value="${ccpMicronote.noteTitle}" data-val="输入微笔记标题" class="input-text"/>
		    </div>
		
		    <div class="select-btn">
		        <input type="button" onclick="$('#page').val(1);formSub('#noteForm');" value="搜索"/>
		    </div>
		</div>
		<div class="main-content">
		    <table width="100%">
		        <thead>
			        <tr>
			            <th width="30">ID</th>
			            <th width="50">编号</th>
			            <th width="120">标题</th>
			            <th class="title">笔记内容</th>
			            <th width="120">发布人</th>
			            <th width="120">手机</th>
			            <th width="120">年龄</th>
			            <th width="120">创建人</th>
			            <th width="120">创建时间</th>
			            <th width="200">管理</th>
			        </tr>
		        </thead>
		        <tbody>
		        <%int i=0;%>
		        <c:forEach items="${micronoteRes.list}" var="note">
		            <%i++;%>
		            <tr>
		                <td ><%=i%></td>
		                <td>${note.noteNum}</td>
		                <td>${note.noteTitle}</td>
	                    <td class="title">${note.noteContent}</td>
		                <td>${note.notePublisherName}</td>
		                <td>${note.notePublisherMobile}</td>
		                <td>${note.notePublisherAge}</td>
		                <td>${note.createUser}</td>
	                    <td> 
	                    	<jsp:useBean id="createTime" class="java.util.Date"/> 
							<c:set target="${createTime}" property="time" value="${note.createTime}"/> 
	                    	<fmt:formatDate value="${createTime}"  pattern="yyyy-MM-dd" type="both"/>
	                    </td>
	                    <td>
                        	<a target="main" href="javascript:;" onclick="deleteNote('${note.noteId}')">删除</a>
                        </td>
		            </tr>
		        </c:forEach>
		
		        <c:if test="${empty micronoteRes.list}">
		            <tr>
		                <td colspan="8"><h4 style="color:#DC590C">暂无数据!</h4></td>
		            </tr>
		        </c:if>
		        </tbody>
		    </table>
		
			<c:if test="${not empty micronoteRes.list}">
	            <input type="hidden" id="page" name="resultIndex" value="${micronoteRes.resultIndex}" />
		    	<div id="kkpager"></div>
	        </c:if>
		</div>
	</form>
</body>
</html>
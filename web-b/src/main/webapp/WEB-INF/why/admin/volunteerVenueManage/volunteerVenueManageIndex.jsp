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
        	
   	      var recruitName = $('#recruitName').val();
          if (recruitName != undefined && recruitName == '按名称搜索') {
              $('#recruitName').val("");
          }
           
            $(formName).submit();
        }
        
       //删除方法 
       function deleteVolunteer(ID){
    	   dialogConfirm("提示","您确定要删除吗？",function(){
    		   $.post("${path}/volunteerVenueManage/deleteVolunteer.do",{"recruitId":ID},function(data){
	   	       		if(data == "success"){
	   	       		   dialogConfirm("提示","删除成功！",function(){
	   	       			  formSub('#form'); 
	   	       		   })
	   	       		}else{
	   	       			dialogConfirm("提示","删除失败！");
	   	       		}
	   	       		
	   	       	})		
    	   })
       } 
       
        $(function(){
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
            
            //跳转至添加志愿者页面
            $('.btn-add-tag').on('click', function () {
                window.location.href = "${path}/volunteerVenueManage/add.do";

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
		    <em>您现在所在的位置：</em>志愿者管理列表 
		</div>
		<div class="search">
		    <div class="search-box">
		        <i></i><input type="text" id="recruitName" name="recruitName" value="${volunteerRecruit.recruitName}" data-val="按名称搜索" class="input-text"/>
		    </div>
		
		    <div class="select-btn">
		        <input type="button" onclick="$('#page').val(1);formSub('#form');" value="搜索"/>
		    </div>
		    
		    <div class="search-total">
	            <div class="select-btn">
	                <input class="btn-add-tag" type="button" value="添加志愿者" style="background:#ED3838; "/>
	            </div>
            </div>
		</div>
		<div class="main-content">
		    <table width="100%">
		        <thead>
			        <tr>
			            <th width="30">ID</th>
			            <th width="150">名称</th>
			            <th width="150">年龄要求</th>
			            <th width="150">学历要求</th>
			            <th width="120">最近操作时间</th>
			            <th width="80">操作</th>
			        </tr>
		        </thead>
		        <tbody>
		        <%int i=0;%>
		        <c:forEach items="${list}" var="volunteerRecruit">
		            <%i++;%>
		            <tr>
		                <td ><%=i%></td>
		                <td>${volunteerRecruit.recruitName}</td>
		                <td>${volunteerRecruit.ageRequirement}</td>
		                <td>${volunteerRecruit.educationRequirement}</td>
		                <td><fmt:formatDate value="${volunteerRecruit.recruitUpdateTime}"  pattern="yyyy-MM-dd HH:mm" type="both"/></td>
		                <td>
		                   <a target="main" href="${path}/volunteerVenueManage/editVolunteer.do?recruitId=${volunteerRecruit.recruitId}">编辑</a>
		                   <a target="main" href="javascript:;" onclick="deleteVolunteer('${volunteerRecruit.recruitId}')">删除</a>
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
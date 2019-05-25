<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>最美城市用户信息列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
    
    <script type="text/javascript">

        //搜索
        function formSub(formName){
            var  userName=$('#userName').val();
            if(userName!=undefined&&userName=='输入姓名'){
                $('#userName').val("");
            }
            var  userMobile=$('#userMobile').val();
            if(userMobile!=undefined&&userMobile=='输入手机号'){
                $('#userMobile').val("");
            }
            $(formName).submit();
        }
        
        $(document).ready(function(){
            //分页
            kkpager.generPageHtml({
                pno : '${beautycityRes.resultIndex}',
                total : '${beautycityRes.countPage}',
                totalRecords :  '${beautycityRes.sum}',
                mode : 'click',//默认值是link，可选link或者click
                click : function(n){
                    this.selectPage(n);
                    $("#page").val(n);
                    formSub('#beautycityForm');
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
	<form id="beautycityForm" action="${path}/beautycity/beautycityIndex.do" method="post">
	    <div class="site">
		    <em>您现在所在的位置：</em>最美城市管理 &gt;用户信息列表
		</div>
		<div class="search">
		    <div class="search-box">
		        <i></i><input type="text" id="userName" name="userName" value="${ccpBeautycity.userName}" data-val="输入姓名" class="input-text"/>
		    </div>
			<div class="search-box">
		        <i></i><input type="text" id="userMobile" name="userMobile" value="${ccpBeautycity.userMobile}" data-val="输入手机号" class="input-text"/>
		    </div>
		    <div class="select-btn">
		        <input type="button" onclick="$('#page').val(1);formSub('#beautycityForm');" value="搜索"/>
		    </div>
		</div>
		<div class="main-content">
		    <table width="100%">
		        <thead>
			        <tr>
			            <th width="30">ID</th>
			            <th width="220">姓名</th>
			            <th width="220">手机号</th>
			            <th width="120">已参与空间</th>
			            <th width="120">已发布照片</th>
			            <th width="120">发布人</th>
			            <th width="220">创建时间</th>
			        </tr>
		        </thead>
		        <tbody>
		        <%int i=0;%>
		        <c:forEach items="${beautycityRes.list}" var="dom">
		            <%i++;%>
		            <tr>
		                <td ><%=i%></td>
		                <td>${dom.userName}</td>
		                <td>${dom.userMobile}</td>
	                    <td>${dom.venueCount}</td>
	                    <td>${dom.imgCount}</td>
	                    <td>${dom.createUserName}</td>
	                    <td> 
	                    	<jsp:useBean id="createTime" class="java.util.Date"/> 
							<c:set target="${createTime}" property="time" value="${dom.createTime}"/> 
	                    	<fmt:formatDate value="${createTime}"  pattern="yyyy-MM-dd" type="both"/>
	                    </td>
		            </tr>
		        </c:forEach>
		
		        <c:if test="${empty beautycityRes.list}">
		            <tr>
		                <td colspan="8"><h4 style="color:#DC590C">暂无数据!</h4></td>
		            </tr>
		        </c:if>
		        </tbody>
		    </table>
		
			<c:if test="${not empty beautycityRes.list}">
	            <input type="hidden" id="page" name="resultIndex" value="${beautycityRes.resultIndex}" />
		    	<div id="kkpager"></div>
	        </c:if>
		</div>
	</form>
</body>
</html>
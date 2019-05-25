<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>最美城市照片列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
    
    <script type="text/javascript">

        $(document).ready(function(){
            //分页
            kkpager.generPageHtml({
                pno : '${beautycityImgRes.resultIndex}',
                total : '${beautycityImgRes.countPage}',
                totalRecords :  '${beautycityImgRes.sum}',
                mode : 'click',//默认值是link，可选link或者click
                click : function(n){
                    this.selectPage(n);
                    $("#page").val(n);
                    formSub('#beautycityImgForm');
                    return false;
                }
            });
        });
        
      	//搜索
        function formSub(formName){
            $(formName).submit();
        }
        
      	//删除
        function deleteBeautycityImg(beautycityImgId){
        	dialogConfirm("提示", "您确定要删除该照片吗？", function(){
        		$.post("${path}/beautycity/deleteBeautycityImg.do", {beautycityImgId: beautycityImgId}, function (data) {
        			if(data.status==1) {
       	                dialogAlert('系统提示', "删除成功!");
       	             	formSub('#beautycityImgForm');
       	            }else{
       	                dialogAlert('系统提示', '删除失败!');
       	            }
        		},"json");
        	});
        }
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
	<form id="beautycityImgForm" action="${path}/beautycity/beautycityImgIndex.do" method="post">
	    <div class="site">
		    <em>您现在所在的位置：</em>最美城市管理 &gt;上传照片列表
		</div>
		<div class="main-content">
		    <table width="100%">
		        <thead>
			        <tr>
			            <th width="30">ID</th>
			            <th width="220">照片</th>
			            <th width="320">上传人</th>
			            <th width="220">所属空间</th>
			            <th width="220">创建时间</th>
			            <th width="200">管理</th>
			        </tr>
		        </thead>
		        <tbody>
		        <%int i=0;%>
		        <c:forEach items="${beautycityImgRes.list}" var="dom">
		            <%i++;%>
		            <tr>
		                <td ><%=i%></td>
		                <td>
		                	<a href="${dom.beautycityImgUrl}" target="_blank"><img src="${dom.beautycityImgUrl}@150w" width="150" height="150"/></a>
                        </td>
		                <td>${dom.userName}</td>
	                    <td>${dom.venueName}</td>
	                    <td> 
	                    	<jsp:useBean id="createTime" class="java.util.Date"/> 
							<c:set target="${createTime}" property="time" value="${dom.createTime}"/> 
	                    	<fmt:formatDate value="${createTime}"  pattern="yyyy-MM-dd" type="both"/>
	                    </td>
	                    <td>
                        	<a target="main" href="javascript:;" onclick="deleteBeautycityImg('${dom.beautycityImgId}')">删除</a>
                        </td>
		            </tr>
		        </c:forEach>
		
		        <c:if test="${empty beautycityImgRes.list}">
		            <tr>
		                <td colspan="8"><h4 style="color:#DC590C">暂无数据!</h4></td>
		            </tr>
		        </c:if>
		        </tbody>
		    </table>
		
			<c:if test="${not empty beautycityImgRes.list}">
	            <input type="hidden" id="page" name="resultIndex" value="${beautycityImgRes.resultIndex}" />
		    	<div id="kkpager"></div>
	        </c:if>
		</div>
	</form>
</body>
</html>
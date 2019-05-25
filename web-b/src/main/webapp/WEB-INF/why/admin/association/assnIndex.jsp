<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>社团列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
    
    <script type="text/javascript">
	    var userId = '${sessionScope.user.userId}';
		if (userId == null || userId == '') {
	        window.location.href = '${path}/admin.do';
	    }
    
        //搜索
        function formSub(formName){
            var  assnName=$('#assnName').val();
            if(assnName!=undefined&&assnName=='输入社团名称'){
                $('#assnName').val("");
            }
            $(formName).submit();
        }
        
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
                    formSub('#associationForm');
                    return false;
                }
            });
        });
        
      	//删除
		function deleteAssn(assnId){
			dialogConfirm("提示", "您确定要删除此团体吗？", function(){
                $.post("${path}/association/deleteAssn.do",{"assnId":assnId}, function(data) {
                    if (data == '200') {
                    	dialogConfirm("提示", "删除成功！", function(){
                    		location.reload();
                    	})
                    }else{
		                dialogAlert('提示', '删除失败！');
		            }
                });
            }) 
		}
        
    </script>
</head>
<body>
	<form id="associationForm" action="${path}/association/assnIndex.do" method="post">
		<div class="site">
		    <em>您现在所在的位置：</em>社团管理 &gt;社团列表
		</div>
	    <div class="subject-content" style="padding-bottom: 62px;">
			<div class="search">
			    <div class="search-box">
			        <i></i><input type="text" id="assnName" name="assnName" value="${association.assnName}" data-val="输入社团名称" class="input-text"/>
			    </div>
			
			    <div class="select-btn">
			        <input type="button" onclick="$('#page').val(1);formSub('#associationForm');" value="搜索"/>
			    </div>
			</div>
			<div class="search menage">
			    <h2>社团一览</h2>
			    <div class="menage-box">
			        <a class="btn-add" href="${path}/association/preAddAssn.do">新增社团</a>
			    </div>
			</div>
			<div class="main-content">
			    <table width="100%">
			        <thead>
				        <tr>
				            <th width="30">ID</th>
				            <th class="title">社团名称</th>
				            <th class="150">社团头像</th>
				            <th width="200">社团标签</th>
				            <th width="320">社团简介</th>
				            <th width="80">图片数</th>
				            <th width="80">视频数</th>
				            <th width="160">创建时间</th>
	                		<th width="200">管理</th>
				        </tr>
			        </thead>
			        <tbody>
			        <%int i=0;%>
			        <c:forEach items="${associationList}" var="assn">
			            <%i++;%>
			            <tr>
			                <td ><%=i%></td>
		                    <td class="title">${assn.assnName}</td>
		                    <td><img src="${assn.assnIconUrl}" style="height: 150px;width: 150px;"/></td>
		                    <td>${assn.assnTag}</td>
			                <td>${assn.assnIntroduce}</td>
			                <td>${assn.resImgCount}</td>
			                <td>${assn.resVideoCount}</td>
			                <td><fmt:formatDate value="${assn.createTime}" pattern="yyyy-MM-dd"/></td>
		                    <td>
		                    	<a target="main" href="${path}/association/preEditAssn.do?assnId=${assn.assnId}">编辑</a>
	                    	 | <a target="main" href="javascript:deleteAssn('${assn.assnId}')" style="color: red;font-weight: bold;">删除</a>
		                    </td>
			            </tr>
			        </c:forEach>
			
			        <c:if test="${empty associationList}">
			            <tr>
			                <td colspan="8"><h4 style="color:#DC590C">暂无数据!</h4></td>
			            </tr>
			        </c:if>
			        </tbody>
			    </table>
				<c:if test="${not empty associationList}">
		            <input type="hidden" id="page" name="page" value="${page.page}"/>
		            <div id="kkpager"></div>
		        </c:if>
			</div>
		</div>
	</form>
</body>
</html>
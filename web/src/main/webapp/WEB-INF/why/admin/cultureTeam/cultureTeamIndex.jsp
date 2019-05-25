<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>团队列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
    
    <script type="text/javascript">
	    var userId = '${sessionScope.user.userId}';
		
		if (userId == null || userId == '') {
			location.href = '${path}/admin.do';
		}
    
	    $(function () {
	        kkpager.generPageHtml({
	            pno: '${page.page}',
	            total: '${page.countPage}',
	            totalRecords: '${page.total}',
	            mode: 'click',//默认值是link，可选link或者click
	            click: function (n) {
	                this.selectPage(n);
	                $("#page").val(n);
	                formSub('#cultureTeamForm');
	                return false;
	            }
	        });
	        
	        selectModel();
	    });
    
	  	//删除
		function deleteCultureTeam(cultureTeamId){
			dialogConfirm("提示", "您确定要删除此团体吗？", function(){
                $.post("${path}/cultureTeam/deleteCultureTeam.do",{"cultureTeamId":cultureTeamId}, function(data) {
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
	    
        //搜索
        function formSub(formName){
            var  cultureTeamName=$('#cultureTeamName').val();
            if(cultureTeamName!=undefined&&cultureTeamName=='输入团队名称'){
                $('#cultureTeamName').val("");
            }
            $(formName).submit();
        }
        
    </script>
    
</head>
<body>
	<form id="cultureTeamForm" action="${path}/cultureTeam/cultureTeamIndex.do" method="post">
	    <div class="site">
		    <em>您现在所在的位置：</em>浦东文化社团评选 &gt; 团队列表
		</div>
		<div class="search">
		    <div class="search-box">
		        <i></i><input type="text" id="cultureTeamName" name="cultureTeamName" value="${cultureTeam.cultureTeamName}" data-val="输入团队名称" class="input-text"/>
		    </div>
		    <div class="select-box w135">
        		<input type="hidden" id="cultureTeamType" name="cultureTeamType" value="${cultureTeam.cultureTeamType}"/>
	            <div id="videoTypeDiv" class="select-text" data-value="">全部门类</div>
	            <ul class="select-option">
	            	<li data-option="1">舞蹈</li>
	            	<li data-option="2">音乐</li>
	            	<li data-option="3">戏剧</li>
	            	<li data-option="6">曲艺</li>
	            	<li data-option="4">美书影</li>
	            	<li data-option="5">综合</li>
	            </ul>
	        </div>
		    <div class="select-btn">
		        <input type="button" onclick="$('#page').val(1);formSub('#cultureTeamForm');" value="搜索"/>
		    </div>
		    <div class="menage-box">
		        <a class="btn-add" href="${path}/cultureTeam/preAddCultureTeam.do">新建社团</a>
		    </div>
		</div>
		<div class="main-content">
	        <table width="100%">
	            <thead>
	            <tr>
	                <th width="50">ID</th>
	                <th class="title">社团名称</th>
	                <th width="250">所属街镇</th>
	                <th width="170">所属门类</th>
	                <th width="170">创建时间</th>
	                <th width="170">创建人</th>
	                <th width="340">管理</th>
	            </tr>
	            </thead>
	            <tbody>
	            <%int i = 0;%>
	            <c:forEach items="${list}" var="dom">
	                <%i++;%>
	                <tr>
	                    <td><%=i%></td>
	                    <td>${dom.cultureTeamName}</td>
	                    <td>${dom.cultureTeamTown}</td>
	                    <td>
	                    	<c:if test="${dom.cultureTeamType == 1}">舞蹈</c:if>
	                    	<c:if test="${dom.cultureTeamType == 2}">音乐</c:if>
	                    	<c:if test="${dom.cultureTeamType == 3}">戏剧</c:if>
	                    	<c:if test="${dom.cultureTeamType == 6}">曲艺</c:if>
	                    	<c:if test="${dom.cultureTeamType == 4}">美书影</c:if>
	                    	<c:if test="${dom.cultureTeamType == 5}">综合</c:if>
	                    </td>
	                    <td><fmt:formatDate value="${dom.createTime}" pattern="yyyy-MM-dd"/></td>
	                    <td>${dom.createUser}</td>
	                    <td>
	                    	<a target="main" href="${path}/cultureTeam/preEditCultureTeam.do?cultureTeamId=${dom.cultureTeamId}">编辑</a>
	                    	 | <a target="main" href="javascript:deleteCultureTeam('${dom.cultureTeamId}')" style="color: red;font-weight: bold;">删除</a>
	                    </td>
	                </tr>
	            </c:forEach>
	            <c:if test="${empty list}">
	                <tr>
	                    <td colspan="7"><h4 style="color:#DC590C">暂无数据!</h4></td>
	                </tr>
	            </c:if>
	            </tbody>
	        </table>
	        <c:if test="${not empty list}">
	            <input type="hidden" id="page" name="page" value="${page.page}"/>
	            <div id="kkpager"></div>
	        </c:if>
	    </div>
	</form>
</body>
</html>
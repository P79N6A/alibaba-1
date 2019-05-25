<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <title>活动模板管理--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>

    <script type="text/javascript">
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
	                searchActivityTemplate();
	                return false;
	            }
	        });
	        
	    });
	    
	    //删除
		function activityTemplateDelete(id){
			$.post("${path}/activityTemplate/hasActivity.do",{"templId":id}, function(data) {
                if (data!=null && data==1) {
	                dialogAlert('系统提示', '该模板已被使用，不能删除！');
	            }else{
	            	dialogConfirm("提示", "您确定要删除该模板吗？", function(){
	                    $.post("${path}/activityTemplate/deleteActivityTemplate.do",{"templId":id}, function(data) {
	                        if (data!=null && data=='success') {
	                            window.location.href="${path}/activityTemplate/activityTemplateIndex.do";
	                        }else{
	    		                dialogAlert('系统提示', '删除失败！');
	    		            }
	                    });
	                })
	            }
            });
		}
	    
	    function searchActivityTemplate(){
            $("#activityTemplateForm").submit();
        }
    </script>
</head>

<body>
	<form id="activityTemplateForm" action="" method="post">
		<div class="site">
		    <em>您现在所在的位置：</em>活动管理 &gt; 活动模板管理
		</div>
		
		<div class="search">
			<div class="menage-box">
		        <a class="btn-add" href="${path}/activityTemplate/preActivityTemplateAdd.do">添加活动模板</a>
		    </div>
		</div>
		
		<div class="main-content">
		    <table width="100%">
		        <thead>
			        <tr>
			            <th width="65">ID</th>
			            <th class="title">模板名称</th>
			            <th>功能</th>
			            <th>创建日期</th>
			            <th>创建人</th>
			            <th>操作</th>
			        </tr>
		        </thead>
		
		        <tbody>
			        <%int i=0;%>
			        <c:if test="${not empty list}">
				        <c:forEach items="${list}" var="dataList">
				            <%i++;%>
				            <tr>
				                <td><%=i%></td>
				                
				                <c:choose>
				                    <c:when test="${not empty dataList.templName}">
				                        <td class="title">${dataList.templName}</td>
				                    </c:when>
				                    <c:otherwise>
				                        <td class="title"></td>
				                    </c:otherwise>
				                </c:choose>
				                
				                <c:choose>
				                    <c:when test="${not empty dataList.functions}">
				                        <td width="500">${dataList.functions}</td>
				                    </c:when>
				                    <c:otherwise>
				                        <td width="500"></td>
				                    </c:otherwise>
				                </c:choose>

								<c:choose>
									<c:when test="${not empty dataList.createTime}">
										<td width="170"><fmt:formatDate value="${dataList.createTime}" pattern="yyyy-MM-dd" /></td>
									</c:when>
									<c:otherwise>
										<td width="170"></td>
									</c:otherwise>
								</c:choose>
				
				                <c:choose>
				                    <c:when test="${not empty dataList.createUser}">
				                        <td width="170">${dataList.createUser}</td>
				                    </c:when>
				                    <c:otherwise>
				                        <td width="170"></td>
				                    </c:otherwise>
				                </c:choose>
				                
				                <td width="170">
	                                <a href="${path}/activityTemplate/preActivityTemplateEdit.do?templId=${dataList.templId}">编辑</a> | 
	                                <a href="javascript:activityTemplateDelete('${dataList.templId}');" style="color: red;">删除</a>
		                        </td>
				            </tr>
				        </c:forEach>
			        </c:if>
			        <c:if test="${empty list}">
			            <tr>
			                <td colspan="8"><h4 style="color:#DC590C">暂无数据!</h4></td>
			            </tr>
			        </c:if>
		        </tbody>
		    </table>
		    <c:if test="${not empty list}">
			    <input type="hidden" id="page" name="page" value="${page.page}" />
			    <div id="kkpager" ></div>
		    </c:if>
		</div>
	</form>
</body>
</html>
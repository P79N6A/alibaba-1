<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>信息共享列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
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
                    return false;
                }
            });
            
        });

     	//取消
		function shareDeptCancel(id){
			dialogConfirm("提示", "您确定要取消向该单位共享信息吗？", function(){
                $.post("${path}/shareDept/cancelShareDept.do",{"shareId":id}, function(data) {
                    if (data!=null && data==1) {
                        window.location.href="${path}/shareDept/shareDeptIndex.do";
                    }else{
		                dialogAlert('系统提示', '取消失败！');
		            }
                });
            })
		}
        
    </script>
</head>
<body>
<form id="backForm" method="post" action="">
<div class="site">
    <em>您现在所在的位置：</em>站点管理 &gt; 信息共享
</div>
<div class="search">
    <%if(shareDeptPreAddButton) {%>
	    <div class="menage-box">
	        <a class="btn-add" href="${path}/shareDept/preAddShareDept.do">添加</a>
	    </div>
	<%}%>
</div>
<div class="main-content">
   <table width="100%">
        <thead>
        <tr>
            <th>ID</th>
            <th class="title">单位名称</th>
            <th >操作人</th>
            <th >时间</th>
            <th >管理</th>
        </tr>
        </thead>
        <tbody id="shareDept">
        <%int i=0;%>
        <c:if test="${null != list}">
            <c:forEach items="${list}" var="dataList" varStatus="status">
                <%i++;%>
                <tr>
                    <td width="65"><%=i%></td>

                    <c:choose>
                        <c:when test="${not empty dataList.targetDeptname}">
                            <td class="title">${dataList.targetDeptname}</td>
                        </c:when>
                        <c:otherwise>
                            <td class="title"></td>
                        </c:otherwise>
                    </c:choose>

                    <c:choose>
                        <c:when test="${not empty dataList.updateUserName}">
                            <td width="220">${dataList.updateUserName}</td>
                        </c:when>
                        <c:otherwise>
                            <td width="220"></td>
                        </c:otherwise>
                    </c:choose>
					
                    <c:choose>
                        <c:when test="${not empty dataList.updateTime}">
                            <td width="220"><fmt:formatDate value="${dataList.updateTime}" pattern="yyyy-MM-dd HH:mm" /></td>
                        </c:when>
                        <c:otherwise>
                            <td width="220"></td>
                        </c:otherwise>
                    </c:choose>
                    
                    <td width="220">
                    	<%if(shareDeptCancelButton) {%>
                    		<a onclick="shareDeptCancel('${dataList.shareId}')" href="#">取消共享</a>
                    	<%}%>
                	</td>
                </tr>
            </c:forEach>
        </c:if>
        <c:if test="${empty list}">
            <tr>
                <td colspan="5"><h4 style="color:#DC590C">暂无数据!</h4></td>
            </tr>
        </c:if>
        </tbody>
    </table>
    </div>
    <c:if test="${not empty list}">
        <input type="hidden" id="page" name="page" value="${page.page}" />
        <div id="kkpager"></div>
    </c:if>
</form>
</body>
</html>
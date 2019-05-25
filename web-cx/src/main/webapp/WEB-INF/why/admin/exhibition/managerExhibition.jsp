<%@ page language="java"  pageEncoding="UTF-8"%>

<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>互动管理列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    <script type="text/javascript">
        $(function(){
        	//图片显示
        	$("#questionAnwser Img").each(function(index,item){
                $(this).attr("src",getImgUrl($(this).attr("data-url")));
            });
        	
        	//分页
            kkpager.generPageHtml({
                pno : '${page.page}',
                total : '${page.countPage}',
                totalRecords :  '${page.total}',
                mode : 'click',//默认值是link，可选link或者click
                click : function(n){
                    this.selectPage(n);
                    $("#page").val(n);
                    $("#backForm").submit();
                    return false;
                }
            });
            
        });
        
      //删除
		function questionAnwserDelete(id){
			dialogConfirm("提示", "您确定要进行此操作吗？", function(){
                $.post("${path}/InsidePages/deleteInsidePages.do",{"pageId":id}, function(data) {
                    if (data!=null) {
                    	searchContestTopic();
                    }else{
		                dialogAlert('系统提示', '删除失败！');
		            }
                });
            }) 
		}

           // 
        
    </script>
</head>
<body>

 
<form id="backForm" method="post" action="">
<div class="site">
    <em>您现在所在的位置：</em>运维管理 &gt; 线上展览&gt;内页列表
</div>
<div class="search">
    
	    <div class="menage-box">
	        <a class="btn-add" href="${path}/InsidePages/addInsidePages.do?exhibitionId=${exhibitionId}">添加内页</a>
	    </div>
</div>
<div class="main-content">
   <table width="100%">
        <thead>
        <tr>
           <th>图片编号</th>
            <th class="title">名称</th>
            <th >操作</th>
            <th>移动</th>
        </tr>
        </thead>
        <tbody id="questionAnwser">
        <c:if test="${!empty InsidePagesList}">
            <c:forEach items="${InsidePagesList}" var="InsidePages" varStatus="status">
                <tr>
                  <td width="170">${InsidePages.exhibitionId }</td>
 					<td width="300" class="title">${InsidePages.pageTitle }</td>
 					<td>
 					<a target="main" href="${path}/InsidePages/EditInsidePages.do?exhibitionId=${exhibition.exhibitionId}">编辑</a>
                    <a style="color:red;" onclick="questionAnwserDelete('${exhibition.exhibitionId}')" href="#">删除</a>
 					</td>
				
                </tr>
            </c:forEach>
        </c:if>
        <c:if test="${empty InsidePagesList}">
            <tr>
                <td colspan="8"><h4 style="color:#DC590C">暂无数据!</h4></td>
            </tr>
        </c:if>
        </tbody>
    </table>
    </div>
    <c:if test="${not empty InsidePagesList}">
        <input type="hidden" id="page" name="page" value="${page.page}" />
        <div id="kkpager"></div>
    </c:if>
</form>
</body>
</html>
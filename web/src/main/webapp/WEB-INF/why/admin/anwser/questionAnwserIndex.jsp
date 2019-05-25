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
                    searchQuestionAnwser();
                    return false;
                }
            });
            
        });

     	//删除
		function questionAnwserDelete(id){
			dialogConfirm("提示", "您确定要删除该条互动吗？", function(){
                $.post("${path}/questionAnwser/deleteQuestionAnwser.do",{"anwserId":id}, function(data) {
                    if (data!=null && data=='success') {
                        window.location.href="${path}/questionAnwser/questionAnwserIndex.do";
                    }else{
		                dialogAlert('系统提示', '删除失败！');
		            }
                });
            })
		}
        
        function searchQuestionAnwser(){
            var searchKey = $("#searchKey").val();
            if(searchKey == "请输入关键词") {
                $("#searchKey").val("");
            }
            $("#backForm").submit();
        }
        
    </script>
</head>
<body>
<form id="backForm" method="post" action="">
<div class="site">
    <em>您现在所在的位置：</em>运维管理 &gt; 互动管理
</div>
<div class="search">
    <div class="search-box">
        <i></i><input value="<c:choose><c:when test="${not empty searchKey}">${searchKey}</c:when><c:otherwise>请输入关键词</c:otherwise></c:choose>" name="searchKey" id="searchKey" class="input-text" data-val="请输入关键词" type="text"/>
    </div>
    <div class="select-btn">
        <input type="button" value="搜索" onclick="searchQuestionAnwser()"/>
    </div>
    <%if(questionAnwserPreAddButton) {%>
	    <div class="menage-box">
	        <a class="btn-add" href="${path}/questionAnwser/preAddQuestionAnwser.do">添加</a>
	    </div>
	<%}%>
</div>
<div class="main-content">
   <table width="100%">
        <thead>
        <tr>
            <th>ID</th>
            <th class="title">问题</th>
            <th >选项</th>
            <th >图片</th>
            <th >答案</th>
            <th >操作人</th>
            <th >时间</th>
            <th >管理</th>
        </tr>
        </thead>
        <tbody id="questionAnwser">
        <%int i=0;%>
        <c:if test="${null != list}">
            <c:forEach items="${list}" var="dataList" varStatus="status">
                <%i++;%>
                <tr>
                    <td width="65"><%=i%></td>

                    <c:choose>
                        <c:when test="${not empty dataList.anwserQuestion}">
                            <td class="title">${dataList.anwserQuestion}</td>
                        </c:when>
                        <c:otherwise>
                            <td class="title"></td>
                        </c:otherwise>
                    </c:choose>

                    <c:choose>
                        <c:when test="${not empty dataList.anwserAllCode}">
                            <td width="170">${fn:replace(dataList.anwserAllCode,"*/*","；")}</td>
                        </c:when>
                        <c:otherwise>
                            <td width="170"></td>
                        </c:otherwise>
                    </c:choose>
					
					<td data-id="${dataList.anwserImgUrl}">
	                    <img src="" data-url="${dataList.anwserImgUrl}"  width="60" height="40"/>
	                </td>
					
                    <c:choose>
                        <c:when test="${not empty dataList.anwserCode}">
                            <td width="170">${dataList.anwserCode}</td>
                        </c:when>
                        <c:otherwise>
                            <td width="170"></td>
                        </c:otherwise>
                    </c:choose>
                    
                    <c:choose>
                        <c:when test="${not empty dataList.anwserUpdateUser}">
                            <td width="170">${dataList.anwserUpdateUser}</td>
                        </c:when>
                        <c:otherwise>
                            <td width="170"></td>
                        </c:otherwise>
                    </c:choose>
                    
                    <c:choose>
                        <c:when test="${not empty dataList.anwserUpdateTime}">
                            <td width="170"><fmt:formatDate value="${dataList.anwserUpdateTime}" pattern="yyyy-MM-dd HH:mm" /></td>
                        </c:when>
                        <c:otherwise>
                            <td width="170"></td>
                        </c:otherwise>
                    </c:choose>
                    
                    <td>
                    	<%if(questionAnwserPreEditButton) {%>
                    		<a target="main" href="${path}/questionAnwser/preEditQuestionAnwser.do?anwserId=${dataList.anwserId}">编辑</a>
                    	<%}%>
                    	<%if(questionAnwserPreEditButton&&questionAnwserDeleteButton) {%> | <%}%>
                    	<%if(questionAnwserDeleteButton) {%>
                    		<a style="color:red;" onclick="questionAnwserDelete('${dataList.anwserId}')" href="#">删除</a>
                    	<%}%>
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
    </div>
    <c:if test="${not empty list}">
        <input type="hidden" id="page" name="page" value="${page.page}" />
        <div id="kkpager"></div>
    </c:if>
</form>
</body>
</html>
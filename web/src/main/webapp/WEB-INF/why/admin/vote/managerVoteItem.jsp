<%@ page language="java"  pageEncoding="UTF-8"%>

<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>投票项目管理--文化云</title>
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
                    //searchvoteItem();
                     $("#backForm").submit();
                    return false;
                }
            });
        });

        function deleteVoteItem(voteItemId){
        	dialogConfirm("提示", "您确定要进行此操作吗？", function(){
                $.post("${path}/voteItem/saveVoteItem.do",{"voteItemId":voteItemId,"itemIsDel":2}, function(data) {
                    if (data!=null && data=='success') {
                    	 $("#backForm").submit();
                    }else{
		                dialogAlert('系统提示', '删除失败！');
		            }
                });
            }) 
        }
        
    </script>
</head>
<body>

 
<form id="backForm" method="post" action="${path}/voteItem/managerVoteItem.do">
<div class="site">
    <em>您现在所在的位置：</em>运维管理 &gt;线上投票 &gt; 投票选项列表
</div>
<div class="search">
    
	    <div class="menage-box">
	        <a class="btn-add" href="${path}/voteItem/preAddVoteItem.do?voteId=${voteId}">添加投票选项</a>
	    </div>
</div>
<div class="main-content">
	<input type="hidden" id="voteId" name="voteId" value="${voteId}" />
   <table width="100%">
        <thead>
        <tr>
            <th>投票选项名称</th>
            <th>投票图片</th>
            <th>创建时间</th>
            <th>投票选项链接</th>
            <th >管理</th>
        </tr>
        </thead>
        <tbody id="questionAnwser">
        <c:if test="${!empty voteItemList}">
            <c:forEach items="${voteItemList}" var="voteItem" varStatus="status">
                <tr>
                 	<td>${voteItem.itemName }</td>
					<c:choose>
					<c:when test="${empty voteItem.itemImgUrl}">
						<td>无</td>
					</c:when>
					<c:otherwise> 
					<td data-id="${voteItem.itemImgUrl}">
	                    <img src="${voteItem.itemImgUrl}@60w" data-url=""  width="60" height="30"/>
	                </td>
	                </c:otherwise>
	                </c:choose>
					
                      <td >
                    	<fmt:formatDate value="${voteItem.itemCreateTime}" pattern="yyyy-MM-dd HH:mm"/>
                      </td>
                    <td>${voteItem.itemLink }</td>
                    <td>
                    		<a target="main" href="${path}/voteItem/preEditVoteItem.do?voteItemId=${voteItem.voteItemId}">编辑</a> |
                    		<a style="color:red;" onclick="deleteVoteItem('${voteItem.voteItemId}')" href="#">
                    			删除
                    		</a>
                    		
                	</td>
                </tr>
            </c:forEach> 
        </c:if>
        <c:if test="${empty voteItemList}">
            <tr>
                <td colspan="8"><h4 style="color:#DC590C">暂无数据!</h4></td>
            </tr>
        </c:if>
        </tbody>
    </table>
    </div>
    <c:if test="${not empty voteItemList}">
        <input type="hidden" id="page" name="page" value="${page.page}" />
        <div id="kkpager"></div>
    </c:if>
</form>
</body>
</html>
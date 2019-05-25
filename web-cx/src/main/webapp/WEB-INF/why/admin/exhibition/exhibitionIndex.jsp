<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ page import="com.sun3d.why.enumeration.contest.CcpContestTopicStatusEnum"%>

<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>文化展览--文化云</title>
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
                    searchContestTopic();
                    return false;
                }
            });
        	

            new Clipboard('.copyButton');
            
        });

     	//删除
		function questionAnwserDelete(id){
			dialogConfirm("提示", "您确定要进行此操作吗？", function(){
                $.post("${path}/exhibition/deleteExhibition.do",{"exhibitionId":id}, function(data) {
                    if (data="success") {
                    	searchContestTopic();
                    }else{
		                dialogAlert('系统提示', '删除失败！');
		            }
                });
            }) 
		}
        
        function searchContestTopic(){
            var exhibitionHead = $("#exhibitionHead").val();
            if(exhibitionHead == "请输入展览名称") {
                $("#exhibitionHead").val("");
            }
            $("#backForm").submit();
        }
        
        function copy(exhibitionId){
        	var clipBoardContent='hs.hb.wenhuayun.cn/wechatFunction/exhibition.do?exhibitionId=';
        	clipBoardContent=clipBoardContent+exhibitionId;
        	
        	//if(window.clipboardData && window.clipboardData.setData){  
        		  
           //     window.clipboardData.setData("Text",clipBoardContent);
                
            //    dialogAlert('提示', '复制成功');
          
           // }else{  
          
            	  dialogAlert('复制成功', clipBoardContent);
          
          //  }  
        }
        
    </script>
</head>
<body>

 
<form id="backForm" method="post" action="">
<div class="site">
    <em>您现在所在的位置：</em>运维管理 &gt; 线上展览
</div>
<div class="search">
    <div class="search-box">
        <i></i><input value="<c:choose><c:when test="${not empty exhibition.exhibitionHead}">${exhibition.exhibitionHead}</c:when><c:otherwise>请输入展览名称</c:otherwise></c:choose>" name="exhibitionHead" id="exhibitionHead" class="input-text" data-val="请输入展览名称" type="text"/>
    </div>
    <div class="select-btn">
        <input type="button" value="搜索" onclick="searchContestTopic()"/>
    </div>
	    <div class="menage-box">
	        <a class="btn-add" href="${path}/exhibition/addExhibition.do">新增展览</a>
	        <a class="btn-add" href="#" onclick="javascript:window.open('/why/STATIC/html/help3.html');">帮助说明</a>
	    </div>
</div>
<div class="main-content">
   <table width="100%">
        <thead>
        <tr>
            <th class="title">编号</th>
            <th >名称</th>
            <th >操作</th>
        </tr>
        </thead>
        <tbody id="questionAnwser">
        <%int i = 0;%>
        <c:if test="${!empty exhibitionList}">
            <c:forEach items="${exhibitionList}" var="exhibition" varStatus="status">
            <%i++;%>
                <tr>
                 	<td class="title"><%=i %></td>
 					<td width="170">${exhibition.exhibitionHead }</td>
                    <td>
                    		<a target="main" href="${path}/exhibition/EditExhibition.do?exhibitionId=${exhibition.exhibitionId}">编辑</a>
                    		<a style="color:red;" onclick="questionAnwserDelete('${exhibition.exhibitionId}')" href="#">删除</a>
                    		<a target="main" data-clipboard-text='hs.hb.wenhuayun.cn/wechatFunction/exhibition.do?exhibitionId=${exhibition.exhibitionId}' class="copyButton" onclick="copy('${exhibition.exhibitionId}')">复制链接</a> |
                    		<a target="main" href="${path}/InsidePages/managerExhibitionPage.do?exhibitionId=${exhibition.exhibitionId}">管理内页</a> 
                    		<%-- <a target="main" href="${path}/exhibition/downloadQRCode.do">下载二维码</a> --%>
                	</td>
                </tr>
            </c:forEach>
        </c:if>
        <c:if test="${empty exhibitionList}">
            <tr>
                <td colspan="8"><h4 style="color:#DC590C">暂无数据!</h4></td>
            </tr>
        </c:if>
        </tbody>
    </table>
    </div>
    <c:if test="${not empty exhibitionList}">
        <input type="hidden" id="page" name="page" value="${page.page}" />
        <div id="kkpager"></div>
    </c:if>
</form>
</body>
</html>
<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ page import="com.sun3d.why.enumeration.contest.CcpContestTopicStatusEnum"%>

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
                    searchContestTopic();
                    return false;
                }
            });
            
        });

     	//删除
		function questionAnwserDelete(id){
			dialogConfirm("提示", "您确定要进行此操作吗？", function(){
                $.post("${path}/contestTopic/topicStatusChange.do",{"topicId":id}, function(data) {
                    if (data!=null && data=='success') {
                    	searchContestTopic();
                    }else{
		                dialogAlert('系统提示', '删除失败！');
		            }
                });
            }) 
		}
        
        function searchContestTopic(){
            var topicName = $("#topicName").val();
            if(topicName == "请输入主题名称") {
                $("#topicName").val("");
            }
            $("#backForm").submit();
        }
        
    </script>
</head>
<body>

 <c:set var="topicStatusUP" value="<%=CcpContestTopicStatusEnum.TOPIC_STATUS_UP.getValue()%>" scope="request"> </c:set>
 <c:set var="topicStatusDown" value="<%=CcpContestTopicStatusEnum.TOPIC_STATUS_DOWN.getValue()%>" scope="request"> </c:set>
 
<form id="backForm" method="post" action="">
<div class="site">
    <em>您现在所在的位置：</em>运维管理 &gt; 文化竞赛
</div>
<div class="search">
    <div class="search-box">
        <i></i><input value="<c:choose><c:when test="${not empty topic.topicName}">${topic.topicName}</c:when><c:otherwise>请输入主题名称</c:otherwise></c:choose>" name="topicName" id="topicName" class="input-text" data-val="请输入主题名称" type="text"/>
    </div>
    <div class="select-btn">
        <input type="button" value="搜索" onclick="searchContestTopic()"/>
    </div>
    <%if(contestTopicIndex) {%>
	    <div class="menage-box">
	        <a class="btn-add" href="${path}/contestTopic/preAddContestTopic.do">添加主题</a>
	    </div>
	<%}%>
</div>
<div class="main-content">
   <table width="100%">
        <thead>
        <tr>
            <th class="title">主题名称</th>
            <th >副标题</th>
            <th >图片logo</th>
            <th >通关称号</th>
            <th >通关文案</th>
            <th >更新时间</th>
            <th >状态</th>
            <th >管理</th>
        </tr>
        </thead>
        <tbody id="questionAnwser">
        <c:if test="${!empty contestTopicList}">
            <c:forEach items="${contestTopicList}" var="contestTopic" varStatus="status">
                <tr>
                  <td class="title">${contestTopic.topicName }</td>
 					<td width="170">${contestTopic.topicTitle }</td>
					<c:choose>
					<c:when test="${empty contestTopic.topicIcon}">
						<td>无</td>
					</c:when>
					<c:otherwise>
					<td data-id="${contestTopic.topicIcon}">
	                    <img src="" data-url="${contestTopic.topicIcon}"  width="60" height="40"/>
	                </td>
	                </c:otherwise>
	                </c:choose>
					
                    <td width="170">${contestTopic.passName }</td>
                    
                     <td width="170">${contestTopic.passText }</td>
                     
                      <td >
                      <c:choose>
                      	<c:when test="${empty contestTopic.updateTime}">
                      	  <fmt:formatDate value="${contestTopic.createTime}" pattern="yyyy-MM-dd HH:mm"/>
                      	</c:when>
                      	<c:otherwise>
                      		<fmt:formatDate value="${contestTopic.updateTime}" pattern="yyyy-MM-dd HH:mm"/>
                      	</c:otherwise>
                      </c:choose>
                      
                      </td>
                       <td>
                        <c:set var="topicStatus" value="${contestTopic.topicStatus }" scope="request"> </c:set>
                       <%=CcpContestTopicStatusEnum.getStatusText(Integer.valueOf(request.getAttribute("topicStatus").toString())) %>
                      </td>
                    <td>
                    	<%if(contestTopicIndex) {%>
                    		<a target="main" href="${path}/contestTopic/preEditContestTopic.do?topicId=${contestTopic.topicId}">编辑</a> |
                    		<a target="main" href="${path}/contestTopicQuestion/managerTopicQuestion.do?topicId=${contestTopic.topicId}">管理试题</a>
                    	<%}%>
                    	<%if(contestTopicIndex&&contestTopicIndex) {%> | <%}%>
                    	<%if(contestTopicIndex) {%>
                    		<a style="color:red;" onclick="questionAnwserDelete('${contestTopic.topicId}','${ topicStatus}')" href="#">
                    		<c:choose>
                    			<c:when test="${topicStatusUP==topicStatus }">
                    			下架
                    			</c:when>
                    			<c:when test="${topicStatusDown==topicStatus }">
                    			上架 
                    			</c:when>
                    			<c:otherwise>
                    			删除
                    			</c:otherwise >
                    		</c:choose>
                    		</a>
                    		
                    		
                    	<%}%>
                    	
                	</td>
                </tr>
            </c:forEach>
        </c:if>
        <c:if test="${empty contestTopicList}">
            <tr>
                <td colspan="8"><h4 style="color:#DC590C">暂无数据!</h4></td>
            </tr>
        </c:if>
        </tbody>
    </table>
    </div>
    <c:if test="${not empty contestTopicList}">
        <input type="hidden" id="page" name="page" value="${page.page}" />
        <div id="kkpager"></div>
    </c:if>
</form>
</body>
</html>
<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>用户反馈列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    <script type="text/javascript">
        $(function(){
        	selectModel();
        	
            kkpager.generPageHtml({
                pno : '${page.page}',
                total : '${page.countPage}',
                totalRecords :  '${page.total}',
                mode : 'click',//默认值是link，可选link或者click
                click : function(n){
                    this.selectPage(n);
                    $("#page").val(n);
                    searchReport();
                    return false;
                }
            });
        });


        function searchReport(){
            var content = $("#content").val();
            if(content == "请输入关键词") {
                $("#content").val("");
            }
            var listType = $("#listType").val();
            if(listType==1){
            	$("#backForm").attr("action","${path}/reportInformation/reportIndex.do");
            }else if(listType==0){
            	$("#backForm").attr("action","${path}/feedInformation/feedIndex.do");
            }
            $("#backForm").submit();
        }
        
    </script>
</head>
<body>
<form id="backForm" method="post" action="">
<div class="site">
    <em>您现在所在的位置：</em>站点管理 &gt; 用户举报
</div>
<div class="search">
    <div class="search-box">
        <i></i><input value="<c:choose><c:when test="${not empty content}">${content}</c:when><c:otherwise>请输入关键词</c:otherwise></c:choose>" name="content" id="content" class="input-text" data-val="请输入关键词" type="text"/>
    </div>
    <div class="select-box w135">
    	<input type="hidden" value="${listType}" name="listType" id="listType"/>
        <div class="select-text" data-value="">
                                 举报列表
        </div>
        <ul class="select-option">
            <li data-option="0">用户反馈列表</li>
            <li data-option="1">举报列表</li>
        </ul>
    </div>
    <div class="select-btn">
        <input type="button" value="搜索" onclick="searchReport()"/>
    </div>
</div>
<div class="main-content">
    <table width="100%">
        <thead>
        <tr>
            <th>ID</th>
            <th class="title">举报类型</th>
            <th class="title">活动名称</th>
            <th >用户名</th>
            <th >联系电话</th>
            <th >举报时间</th>
        </tr>
        </thead>
        <tbody>
        <%int i=0;%>
        <c:if test="${null != reportList}">
            <c:forEach items="${reportList}" var="dataList" varStatus="status">
                <%i++;%>
                <tr>
                    <td width="65"><%=i%></td>
                    
                    <c:choose>
                        <c:when test="${not empty dataList.reportTypeName}">
                            <td width="title" style="text-align:left;">${dataList.reportTypeName}</td>
                        </c:when>
                        <c:otherwise>
                            <td width="title" style="text-align:left;"></td>
                        </c:otherwise>
                    </c:choose>

                    <c:choose>
                        <c:when test="${not empty dataList.activityName}">
                            <td class="340">${dataList.activityName}</td>
                        </c:when>
                        <c:otherwise>
                            <td class="340"></td>
                        </c:otherwise>
                    </c:choose>

                    <c:choose>
                        <c:when test="${not empty dataList.userName}">
                            <td width="170">${dataList.userName}</td>
                        </c:when>
                        <c:otherwise>
                            <td width="170"></td>
                        </c:otherwise>
                    </c:choose>

                    <c:choose>
                        <c:when test="${not empty dataList.userMobileNo}">
                            <td width="170">${dataList.userMobileNo}</td>
                        </c:when>
                        <c:otherwise>
                            <td width="170"></td>
                        </c:otherwise>
                    </c:choose>
                    
                    <c:choose>
                        <c:when test="${not empty dataList.reportTime}">
                            <td width="170"><fmt:formatDate value="${dataList.reportTime}" pattern="yyyy-MM-dd HH:mm" /></td>
                        </c:when>
                        <c:otherwise>
                            <td width="170"></td>
                        </c:otherwise>
                    </c:choose>
                </tr>
            </c:forEach>
        </c:if>
        <c:if test="${empty reportList}">
            <tr>
                <td colspan="6"><h4 style="color:#DC590C">暂无数据!</h4></td>
            </tr>
        </c:if>
        </tbody>
    </table>
    </div>
    <c:if test="${not empty reportList}">
        <input type="hidden" id="page" name="page" value="${page.page}" />
        <div id="kkpager"></div>
    </c:if>
</form>
</body>
</html>
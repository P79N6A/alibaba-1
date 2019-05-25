<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>非遗列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
    
    <script type="text/javascript">

        //搜索
        function formSub(formName){
            var  heritageName=$('#heritageName').val();
            if(heritageName!=undefined&&heritageName=='输入非遗名称'){
                $('#heritageName').val("");
            }
            $(formName).submit();
        }
        
    </script>
    <style type="text/css">
        .ui-dialog-title,.ui-dialog-content textarea{ font-family: Microsoft YaHei;}
        .ui-dialog-header{ border-color: #9b9b9b;}
        .ui-dialog-close{ display: none;}
        .ui-dialog-title{ color: #F23330; font-size: 20px; text-align: center;}
        .ui-dialog-content{}
        .ui-dialog-body{}
    </style>
</head>
<body>
	<form id="heritageForm" action="${path}/heritage/heritageIndex.do" method="post">
	    <input type="hidden" name="heritageId" value="${ccpHeritage.heritageId}"/>
	    <div class="site">
		    <em>您现在所在的位置：</em>非遗管理 &gt;非遗列表
		</div>
		<div class="search">
		    <div class="search-box">
		        <i></i><input type="text" id="heritageName" name="heritageName" value="${ccpHeritage.heritageName}" data-val="输入非遗名称" class="input-text"/>
		    </div>
		    <div class="select-btn">
		        <input type="button" onclick="formSub('#heritageForm');" value="搜索"/>
		    </div>
		    <div class="menage-box">
		        <a class="btn-add" href="${path}/heritage/preAddHeritage.do">新建非遗</a>
		    </div>
		</div>
		<div class="main-content">
		    <table width="100%">
		        <thead>
			        <tr>
			            <th width="30">ID</th>
			            <th class="title">非遗名称</th>
			            <th width="150">类别</th>
			            <th width="150">非遗等级</th>
			            <th width="150">非遗区域</th>
			            <!-- 北京西城不显示朝代 -->
			            <c:if test="${!fn:contains(basePath,'http://xcct.bj.wenhuayun.cn')}">
			            	<th width="150">非遗朝代</th>
			            </c:if>
			            <th width="150">创建人</th>
			            <th width="150">创建时间</th>
			            <th width="260">管理</th>
			        </tr>
		        </thead>
		        <tbody>
			        <%int i=0;%>
			        <c:forEach items="${heritageList}" var="heritage">
			            <%i++;%>
			            <tr>
			                <td ><%=i%></td>
		                    <td class="title">${heritage.heritageName}</td>
		                    <td>${heritage.heritageType}</td>
			                <td>${heritage.heritageLevel}</td>
			                <td>${fn:split(heritage.heritageArea, ",")[1]}</td>
			                <!-- 北京西城不显示朝代 -->
			                <c:if test="${!fn:contains(basePath,'http://xcct.bj.wenhuayun.cn')}">
			                	<td>${heritage.heritageDynasty}</td>
			                </c:if>
			                <td>${heritage.createUser}</td>
		                    <td> <fmt:formatDate value="${heritage.createTime}" pattern="yyyy-MM-dd"/></td>
		                    <td>
                            	<a target="main" href="${path}/heritage/preEditHeritage.do?heritageId=${heritage.heritageId}">编辑</a>
                            </td>
			            </tr>
			        </c:forEach>
			
			        <c:if test="${empty heritageList}">
			            <tr>
			                <td colspan="7"><h4 style="color:#DC590C">暂无数据!</h4></td>
			            </tr>
			        </c:if>
		        </tbody>
		    </table>
		</div>
	</form>
</body>
</html>
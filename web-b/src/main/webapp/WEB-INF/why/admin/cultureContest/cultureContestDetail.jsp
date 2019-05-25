<%@ page language="java" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>文化云</title>
<%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
<%@include file="/WEB-INF/why/common/limit.jsp"%>
<script type="text/javascript">
	$(function() {
		$('#hr').css({'margin-bottom':'20px','height':'3px','background-color':'grey'});
		$('.main-publish').css({'padding-bottom':'20px'});
	});
</script>
</head>
<body>
	<div class="main-publish">
	        <table width="100%" class="form-table">
	            <tr>
	            	<td class="td-title" ><h1>用户名：</h1></td>
		            <td class="td-input" >
		                <h1>${userName}</h1>   
		            </td>
		            <td class="td-title" ><h1>真实姓名：</h1></td>
		            <td class="td-input" >
		                <h1>${userInfo.userRealName }</h1>
		            </td>
		            <td class="td-title" ><h1>手机号：</h1></td>
		            <td class="td-input" >
		                <h1>${userInfo.userTelephone }</h1>
		            </td>
		            <td class="td-title" ><h1>生日：</h1></td>
		            <td class="td-input" >
		                <h1><fmt:formatDate value="${userInfo.userBirthday }" type="date"/></h1>
		            </td>
		            <td class="td-title" ><h1>所属组别：</h1></td>
		            <td class="td-input" >
		                <h1>
		               <c:if test="${userInfo.userGroupType == 1}">
			                	少年组
			            </c:if>
		               <c:if test="${userInfo.userGroupType == 2}">
			                	中青年组
			            </c:if>
			            <c:if test="${userInfo.userGroupType == 3}">
			                	老年组
			            </c:if>
		                </h1>
		            </td>
				</tr>
				
				<tr >
		            <td class="td-title" style="vertical-align:inherit;"><h1>所属区域：</h1></td>
		            <td class="td-input" colspan="3"><h1>${userInfo.userArea}</h1></td>
		            <td></td>
		            <td></td>
		            <td></td>
		            <td></td>
		            
		            <td class="td-btn" colspan="2">
		                <input type="button" class="btn-publish" value="返回" onclick="javascript :history.back(-1);"/>
		            </td>
		        </tr>
				
			</table>
	     </div>
	<hr id="hr"></hr>
	<h1>答题记录</h1>
	<div class="main-content">
		<table width="100%">
			<thead>
				<tr>
					<th width="100">第一阶段</th>
					<th width="170">答题时间</th>
					<th width="100">所花时间</th>
					<th width="100">答题数</th>
					<th width="100">答对数</th>
					<th width="100">得分</th>
				</tr>
			</thead>
			<tbody>
			<c:forEach items="${detailInfo}" var="avct" varStatus="statu"  begin="0" end="2">
				<tr>
					<td>
						 <c:if test="${avct.rowno ==1}">
			                	第一次
			            </c:if>
			            <c:if test="${avct.rowno ==2}">
			                	第二次
			            </c:if>
			            <c:if test="${avct.rowno ==3}">
			                	第三次
			            </c:if>
					</td>
		            <td>
		            	<fmt:formatDate value="${avct.answerUseTime }" type="both"/>  
		            </td>
		             <td>${avct.answerTime }s</td>
		            <td>${avct.answerNumber }</td>
		            <td>${avct.answerRightNumber}</td>
		            <td>${avct.answerRightNumber}</td>
				</tr>
			</c:forEach>
			<tr>
				<td></td>
	            <td></td>
	            <td>排名</td>
	            <td>
	            	<fmt:parseNumber integerOnly="true" value="${sortInfo.key2[0].rowNo}" /> 
	            </td>
	            <td>最高分</td>
	            <td>${sortInfo.key2[0].max}</td>
			</tr>
			</tbody>
		</table>
	</div>
	<div class="main-content">
		<table width="100%">
			<thead>
				<tr>
					<th width="100">第二阶段</th>
					<th width="170">答题时间</th>
					<th width="100">所花时间</th>
					<th width="100">答题数</th>
					<th width="100">答对数</th>
					<th width="100">得分</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${detailInfo}" var="avct" varStatus="statu"  begin="3" end="5">
				<tr>
					<td>
						<c:if test="${avct.rowno ==4}">
			                	第一次
			            </c:if>
			            <c:if test="${avct.rowno ==5}">
			                	第二次
			            </c:if>
			            <c:if test="${avct.rowno ==6}">
			                	第三次
			            </c:if>
		            <td>
		            	<fmt:formatDate value="${avct.answerUseTime }" type="both"/>  
		            </td>
		            <td>${avct.answerTime }s</td>
		            <td>${avct.answerNumber }</td>
		            <td>${avct.answerRightNumber}</td>
		            <td>${avct.answerRightNumber}</td>
				</tr>
				</c:forEach>
				<tr>
				<td></td>
	            <td></td>
	            <td>排名</td>
	            <td>
	            	<fmt:parseNumber integerOnly="true" value="${sortInfo.key5[0].rowNo}" /> 
	            </td>
	            <td>最高分</td>
	            <td>${sortInfo.key5[0].max}</td>
			</tr>
			</tbody>
		</table>
	</div>
	<div class="main-content">
		<table width="100%">
			<thead>
				<tr>
					<th width="100">第三阶段</th>
					<th width="170">答题时间</th>
					<th width="100">所花时间</th>
					<th width="100">答题数</th>
					<th width="100">答对数</th>
					<th width="100">得分</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${detailInfo}" var="avct" varStatus="statu"  begin="6" end="8">
				<tr>
					<td>
						<c:if test="${avct.rowno ==7}">
			                	第一次
			            </c:if>
			            <c:if test="${avct.rowno ==8}">
			                	第二次
			            </c:if>
			            <c:if test="${avct.rowno ==9}">
			                	第三次
			            </c:if>
					</td>
		            <td>
		            <fmt:formatDate value="${avct.answerUseTime }" type="both"/>  
		            </td>
		            <td>${avct.answerTime }s</td>
		            <td>${avct.answerNumber }</td>
		            <td>${avct.answerRightNumber}</td>
		            <td>${avct.answerRightNumber}</td>
				</tr>
				</c:forEach>
				<tr>
					<td></td>
		            <td></td>
		            <td>排名</td>
		            <td>
		            	<fmt:parseNumber integerOnly="true" value="${sortInfo.key8[0].rowNo}" /> 
		            </td>
		            <td>最高分</td>
		            <td>${sortInfo.key8[0].max}</td>
				</tr>
				<tr>
					<td></td>
		            <td></td>
		            <td>总排名</td>
		            <td>
		            	<fmt:parseNumber integerOnly="true" value="${sortInfo.key9[0].rowNo}" /> 
		            </td>
		            <td>总得分</td>
		            <td>${sortInfo.key9[0].max}</td>
				</tr>
			</tbody>
		</table>
	</div>
</body>
</html>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	 <style type="text/css">
		.select-btn:last-child{
			margin-left:20px;
		}
	</style>
<head>
<title>文化云</title>
<%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
<%@include file="/WEB-INF/why/common/limit.jsp"%>
</head>
<body>
	<form action="${path}/CultureContestUser/queryUserInfo.do"
		id="cultureContextUsertForm" method="post">
		<div class="site">
			<em>您现在所在的位置：</em>运维管理 &gt; 文化答题-用户管理
			<c:if test="${userGroupType == 1}">
	                &gt; 少年组
	            </c:if>
			<c:if test="${userGroupType == 2}">
	                &gt; 中青年组
	            </c:if>
			<c:if test="${userGroupType == 3}">
	                &gt; 老年组
	            </c:if>
		</div>

		<div class="search">
			<div class="search-box">
				<i></i><input class="input-text" id="name" name="Name" data-val="请输入姓名\手机号" type="text" 
				value="<c:choose><c:when test="${not empty Name}">${Name}</c:when><c:otherwise>请输入姓名\手机号</c:otherwise></c:choose>" />
			</div>
			
			<input type="hidden" name="userGroupType" value="${userGroupType }" id="userGroupType">
			<div class="select-box w135">
			    <input type="hidden" name="userStage" id="userStage" value=${ userStage}>
				<div class="select-text" data-value="" id="userStageValue">所有用户</div>
				<ul class="select-option">
					<li data-option="">所有用户</li>
					<li data-option="1">完成第一阶段用户</li>
					<li data-option="2">完成第二阶段用户</li>
					<li data-option="3">完成第三阶段用户</li>
				</ul>
			</div>
			<div class="select-box w135">
				<input type="hidden" name="orderType" id="orderType" value=${orderType }>
				<div class="select-text" data-value="" id="orderTypeValue">按新增时间排序</div>
				<ul class="select-option">
					<li data-option="1">按新增时间排序</li>
					<li data-option="2">按得分由高到低排序</li>
					<li data-option="3">按得分由低到高排序</li>
				</ul>
			</div>
			<div class="select-btn">
				<input type="button"
					onclick="$('#page').val(1);formSub('#cultureContextUsertForm');" value="搜索" />
			</div>
			<div class="select-btn">
				<input type="button" id="doReset" value="重置" />
			</div>
		</div>
		<div class="main-content">
			<table width="100%">
				<thead>
					<tr>
						<th width="100">编号</th>
						<th width="190">用户名</th>
						<th width="150">姓名</th>
						<th width="170">手机号</th>
						<th width="300">所属区域</th>
						<th width="100">总分</th>
						<th width="100">一阶段得分</th>
						<th width="100">二阶段得分</th>
						<th width="100">三阶段得分</th>
						<th width="170">操作</th>
					</tr>
				</thead>
				<tbody>
		            <c:forEach items="${userList}" var="avct" varStatus="statu">
		                
		                <tr>
		                	<td>${statu.index+1}</td>      	
		                	<td>${avct.userName }</td>
		                	<td>${avct.realName }</td>		   	
		                	<td>${avct.userTelephone }</td>
		                	<td>${avct.userArea }</td>
		                	<td>${avct.sum }</td>
		                	<td>${avct.stage1 }</td>
		                	<td>${avct.stage2 }</td>
		                	<td>${avct.stage3 }</td>
		                	<td>
		                		<a target="main" href="${path}/CultureContestUser/queryUserDetail.do?cultureUserId=${avct.cultureUserId}&userName=${avct.userName}&userGroupType=${userGroupType }">查看详情</a>
		                	</td>
		                </tr>
		            </c:forEach>
				</tbody>
				</table>
				</div>
				<c:if test="${not empty userList}">
		            <input type="hidden" id="page" name="page" value="${page.page}"/>
		            <input type="hidden" id="userGroupType" name="userGroupType" value="${userGroupType}"/>
            		<div id="kkpager"></div>
        		</c:if>
	</form>
</body>
<script type="text/javascript">
	$(function() {
		selectModel();
		$('.search .select-box .select-text').css({'background-position': '180px 19px','width': '195px'});
		$('.search .select-box').css('width','205px');
		$('.search .select-box .select-option').css('width','205px');
	});
	
	
	//提交表单
    function formSub(formName) {
        $(formName).submit();
    }
	
	$('#doReset')[0].addEventListener('click',doReset,false );
	
	
	function doReset(){
		
		
	/* 	$(':input','#cultureContextUsertForm')

	       .not(':button,:submit,:reset,:hidden')   //将myform表单中input元素type为button、submit、reset、hidden排除

	       .val('')  //将input元素的value设为空值

	       .removeAttr('checked')

	       .removeAttr('checked') // 如果任何radio/checkbox/select inputs有checked or selected 属性，将其移除
		 */

		
		
	 	$('#name').val('');
		$('#userStage').val('');
		$('#userStageValue').text('所有用户');
		
		$('#orderType').val('1');
		$('#orderTypeValue').text('按新增时间排序');

	}
	
    $(function () {
        $("input").focus();
        kkpager.generPageHtml({
            pno: '${page.page}',
            total: '${page.countPage}',
            totalRecords: '${page.total}',
            mode: 'click',//默认值是link，可选link或者click
            click: function (n) {
                this.selectPage(n);
                $("#page").val(n);
                formSub('#cultureContextUsertForm');
                return false;
            }
        });
    });
</script>


</html>
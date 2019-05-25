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



</head>
<body>
	<form
		action="${path}/CultureContestQuestion/queryCultureContestQuestion.do"
		id="cultureContextQuestionForm" method="post">
		<div class="site">
			<em>您现在所在的位置：</em>运维管理 &gt; 文化答题-题库管理
			<c:if test="${question.stageNumber == 1}">
	                &gt; 第一阶段-戏曲精粹
	            </c:if>
			<c:if test="${question.stageNumber == 2}">
	                &gt; 第二阶段-诗词经典
	            </c:if>
			<c:if test="${question.stageNumber == 3}">
	                &gt; 第三阶段-人文民俗
	            </c:if>
		</div>

		<div class="search">
			<div class="search-box">
				<i></i><input class="input-text" id="questionContent"
					name="questionContent" data-val="请输入编号或题目名称" type="text"
					value="<c:choose><c:when test="${not empty question.questionContent}">${question.questionContent}</c:when><c:otherwise>请输入编号或题目名称</c:otherwise></c:choose>" />

				<!-- <i></i><input class="input-text" id="inp" /> -->
			</div>
			<div class="select-box w135">
				<input type="hidden" name="questionType" id="questionType"
					value=${ question.questionType}>
				<div class="select-text" data-value="">全部类型</div>
				<ul class="select-option">
					<li data-option="0">全部类型</li>
					<li data-option="1">单选题</li>
					<li data-option="2">多选题</li>
					<li data-option="3">判断题</li>
				</ul>
			</div>
			<input type="hidden" name="stageNumber" id="stageNumber" value="${question.stageNumber}" /> 
		<%-- 	<input type="hidden" name="cultureQuestionId" id="cultureQuestionId" value="${question.cultureQuestionId}" /> --%>
			<div class="select-btn">
				<input type="button"
					onclick="$('#page').val(1);formSub('#cultureContextQuestionForm');"
					value="搜索" />
			</div>
			<div class="search menage">
				<div class="menage-box">
					<a class="btn-add" href="javascript:void(0);">新增题目</a>
				</div>
			</div>
		</div>


		<div class="main-content">
			<table width="100%">
				<thead>
					<tr>
						<th width="100">编号</th>
						<th width="170">题目类型</th>
						<th width="170">题目名称</th>
						<th width="170">操作</th>
					</tr>
				</thead>
				<tbody>
					<%
						int i = 0;
					%>
					<c:forEach items="${userList}" var="avct" varStatus="s">
						<tr>
							<td>${avct.cultureQuestionId}</td>
							<td><c:if test="${avct.questionType == 1}">
							        	单选题	
							    </c:if> <c:if test="${avct.questionType == 2}">
							        	多选题	
							    </c:if> <c:if test="${avct.questionType == 3}">
							        	判断题	
							    </c:if></td>
							<td>${avct.questionContent }</td>
							<td><a target="main" href="" class="btn-edit" id="${avct.cultureQuestionId}">编辑</a> 
								<a target="main" href="" class="btn-del" id="${avct.cultureQuestionId}">删除</a>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>

		<c:if test="${not empty userList}">
			<input type="hidden" id="page" name="page" value="${page.page}" />
			<div id="kkpager"></div>
		</c:if>

	</form>
	<script type="text/javascript"
		src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
	<script type="text/javascript">
		$(function() {
			selectModel();
			$('.search .select-box .select-text').css({
				'background-position' : '180px 19px',
				'width' : '195px'
			});
			$('.search .select-box').css('width', '205px');
			$('.search .select-box .select-option').css('width', '205px');
		});

		
		
		
		
		function formSub(formName) {
			var questionContent = $('#questionContent').val();
			if (questionContent != undefined && questionContent == '请输入编号或题目名称') {
				$('#questionContent').val('');
			}
			$(formName).submit();
		}
		
		
		
		

		$(function() {
			$("input").focus();
			kkpager.generPageHtml({
				pno : '${page.page}',
				total : '${page.countPage}',
				totalRecords : '${page.total}',
				mode : 'click',//默认值是link，可选link或者click
				click : function(n) {
					this.selectPage(n);
					$("#page").val(n);
					formSub('#cultureContextQuestionForm');
					return false;
				}
			});
		});

		seajs.config({
			alias : {
				"jquery" : "jquery-1.10.2.js"
			}
		});
		seajs.use([ '${path}/STATIC/js/dialogBack/src/dialog-plus' ], function(
				dialog) {
			window.dialog = dialog;
		});
		//添加标签
		
		
		seajs.use([ 'jquery' ],function($) {
			$('.btn-add').on('click',function() {
								var stageNumber = $('#stageNumber').val();
								dialog(
										{
											url : '${path}/CultureContestQuestion/addCultureContestQuestion.do?stageNumber='+ stageNumber,
											title : '新增题目',
											width : 800,
											fixed : true
										}).showModal();
								return false;
							});

			$('.btn-edit').on('click',function() {
				var dictId = $(this).attr("id");
				var stageNumber = $('#stageNumber').val();
				dialog({  url : '${path}/CultureContestQuestion/editQuestion.do?stageNumber='+ stageNumber+ "&cultureQuestionId="+ dictId,
						title : '新增题目',
						width : 800,
						fixed : true
						}).showModal();
				return false;
			});

			$('.btn-del').on('click',function() {
					var dictId = $(this).attr("id");
					var stageNumber = $('#stageNumber').val();
					var msg = "您真的确定要删除吗？\n\n请确认！";
					if (confirm(msg) == true) {
							$.post("${path}/CultureContestQuestion/deleteQuestion.do",
							{
								stageNumber : stageNumber,
								cultureQuestionId : dictId
							},
							function(
									datas) {
								if (datas == "success") {
									window.location.href = "${path}/CultureContestQuestion/queryCultureContestQuestion.do?stageNumber="
											+ stageNumber;
								}
							});
					}
			});
		});

		/*    $('#del').click(function(){
			$.post("${path}/CultureContestQuestion/insertCultureContestQuestion.do", $("#dictForm").serialize(), function(datas) {
				
				if (datas == "success") {
					dialogTypeSaveDraft("提示","保存成功",function(){
						var stageNumber = $('#stageNumber').val();
						parent.location.href="${path}/CultureContestQuestion/queryCultureContestQuestion.do?stageNumber="+stageNumber;
						dialog.close().remove();
					});
				}
				$(".btn-save").removeAttr("disabled");
			});
		}) */
	</script>



</body>
</html>
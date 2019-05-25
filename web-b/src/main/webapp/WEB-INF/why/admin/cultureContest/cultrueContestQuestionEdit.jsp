<%@ page language="java" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>文化云</title>
<!-- 导入头部文件 start -->
<%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
</head>
<body class="rbody">
	<form action="" id="dictForm">
		<input type="hidden" value="${stageNumber}" id="stageNumber" name="stageNumber" />
		<div class="main-publish tag-add">
			<table width="100%" class="form-table" height="600px">
				<tr>
					<td class="td-title" style="text-align: center;">请输入题目名称</td>
					<td class="td-content">
						<textarea id="questionContent" name="questionContent" style="width: 480px; height: 150px"
								onkeydown="checkForm('questionContent');" class="text-des" maxlength="500">${question.questionContent }</textarea>
						<span style="color: red">500字内</span>
					</td>
				</tr>
				<tr>
					<td class="td-title" width="15%" style="text-align: center;">
						请选择题目类型
					</td>
					<td class="td-select" id="dictParenetCodeLable">
						<input type="radio" name="questionType" value=3 
						<c:choose>
							<c:when test="${question.questionType == 3}">
				               	checked = true
				            </c:when>
				        	<c:otherwise> 
							    disabled = true
							</c:otherwise>
						</c:choose>
				        />判断题
						<input type="radio" name="questionType" value=1 
						<c:choose>
							<c:when test="${question.questionType == 1}">
				               	checked = true
				            </c:when>
				        	<c:otherwise> 
							    disabled = true
							</c:otherwise>
						</c:choose>/>单选题 
						<input type="radio" name="questionType" value=2 
						<c:choose>
							<c:when test="${question.questionType == 2}">
				               	checked = true
				            </c:when>
				        	<c:otherwise> 
							    disabled = true
							</c:otherwise>
						</c:choose>/>多选题
		            </td>
				</tr>
				<tr id="appDom">
					<td width="28%" class="td-title" style="text-align: center;">请设置答案</td>
					<c:if test="${question.questionType == 3}">
		                	<td class="td-input sel">
								<input type="radio" name="rightAnswer" value=1 <c:if test="${question.rightAnswer == 1}"> checked= true </c:if> >对
								<input type="radio" name="rightAnswer" value=0 <c:if test="${question.rightAnswer == 0}"> checked= true </c:if> >错
					    		<input type="hidden" name="cultureQuestionId"  value=${ question.cultureQuestionId}></input>
					    	</td>
		            </c:if>
		           
		            <c:if test="${question.questionType == 1}">
		                	<td class="td-input rad">
		                		<c:forEach items="${option}" var="avct" varStatus="st">
		                			<input type="radio" name="rightAnswer" value=${avct.optionIndex } <c:if test="${avct.optionIsRight == 1}">checked=true</c:if>/>
										${optionArray[st.index]}
									<input type="text" name="optionContent" style="width: 400px;" value=${ avct.optionContent}></input></br> 
									<input type="hidden" name="cultureOptionId"  value=${ avct.cultureOptionId}></input>
									<input type="hidden" name="cultureQuestionId"  value=${ question.cultureQuestionId}></input>
		                		</c:forEach>
		                	</td>
		            </c:if>
		            <c:if test="${question.questionType == 2}">
		            	<td class="td-input che">
		                		<c:forEach items="${option}" var="avct" varStatus="st">
		                			<input type="checkbox" name="rightAnswer" value=${avct.optionIndex } 
		                				<c:if test="${ avct.optionIsRight == 1}">checked=true</c:if>
			                		/>
										${optionArray[st.index]}
									<input type="text" name="optionContent" style="width: 400px;" value=${ avct.optionContent}></input></br> 
									<input type="hidden" name="cultureOptionId"  value=${ avct.cultureOptionId}></input>
									<input type="hidden" name="cultureQuestionId"  value=${ question.cultureQuestionId}></input>
		                		</c:forEach>
		                	</td>   	
		            </c:if>
				</tr>
				<tr>
					<td class="td-btn" align="center" colspan="2">
						<input class="btn-save" type="button" value="保存" /> 
						<input class="btn-cancel" type="button" value="取消" />
					</td>
				</tr>
			</table>
		</div>
	</form>
	<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
	<script type="text/javascript">
		
		var dialog = parent.dialog.get(window);
		
		var saving = true
		
		$('.btn-save').click(function(){
			
			//当前输入的题目
			var text = $('#questionContent').val().replace(/(^\s*)|(\s*$)/g,'');
			
			if(text==null || text==''){
				dialogTypeSaveDraft("提示", '题目内容不能为空', '');
				return false;
			}
			//获取题目类型
			var questionType = ($('#dictParenetCodeLable :radio:checked').val());
			
			//判断类型
			//单选题
			if(questionType==1){
				var flag = false;
				var $_radInputVal = $('.rad :input[name=optionContent]');
				//遍历每个选项输入框,判断不能为空
				$_radInputVal.each(function(){
					var str = $(this).val().replace(/(^\s*)|(\s*$)/g,'');
				    if(str == null || str ==''){
				    	dialogTypeSaveDraft("提示", '问题内容不能为空', '');
				    	flag=true;
				    	return false;			    	
				    }
				  });	
				if(flag){
					return false;
				}
			}
			
			if(questionType==2){
				var flag = false;
				var $_chekVal = $('.che :checkbox:checked');
				var $_cheInputVal = $('.che :input[name=optionContent]');
				//遍历每个选项输入框,判断不能为空
				$_cheInputVal.each(function(){
					var str = $(this).val().replace(/(^\s*)|(\s*$)/g,'');
				    if(str == null || str ==''){
				    	dialogTypeSaveDraft("提示", '问题选项不能为空', '');
						flag=true;
						return false;
				    }
				  });	
				if(flag){
					return false;
				}
				if($_chekVal.length<2){
					dialogTypeSaveDraft("提示", '答案内容至少两项', '');
					return false;
				}
			}
				
			if(saving){
				saving = false;	
				$.post("${path}/CultureContestQuestion/updateCultureContestQuestion.do", $("#dictForm").serialize(), function(datas) {
					if (datas == "success") {
						dialogTypeSaveDraft("提示","保存成功",function(){
							var stageNumber = $('#stageNumber').val();
							parent.location.href="${path}/CultureContestQuestion/queryCultureContestQuestion.do?stageNumber="+stageNumber;
							dialog.close().remove();
						});
					}else{
						saving = true;
					}
					$(".btn-save").removeAttr("disabled");
				});
			}else{
				return false;
			}
		})
		
		$(".btn-cancel").on("click", function(){
				dialog.close().remove();
		});
		
		function dialogTypeSaveDraft(title, content, fn){
	        var d = parent.dialog({
	            width:400,
	            title:title,
	            content:content,
	            fixed: true,
	            okValue: '确 定',
	            ok: function () {
	                if(fn)  fn();
	            }
	        });
	        d.showModal();
	    }
	</script>
</body>
</html>
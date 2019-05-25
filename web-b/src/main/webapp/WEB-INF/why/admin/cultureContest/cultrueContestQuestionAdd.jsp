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
	<form action=" " id="dictForm">
		<input type="hidden" value="${stageNumber}" id="stageNumber" name="stageNumber"/>
		<div class="main-publish tag-add">
			<table width="100%" class="form-table" height="600px">
				<tr>
					<td class="td-title" style="text-align: center;">请输入题目名称</td>
					<td class="td-content">
						<textarea id="questionContent" name="questionContent" style="width: 480px; height: 150px;"
								class="text-des" maxlength="500"></textarea>
					<span style="color: red">500字内</span>
					</td>
				</tr>
				<tr>
					<td class="td-title" width="15%" style="text-align: center;">
						请选择题目类型</td>
					<td class="td-select" id="dictParenetCodeLable">
					<input type="radio" name="questionType" value=3 checked="checked" />判断题 
					<input type="radio" name="questionType" value=1 />单选题 
					<input type="radio" name="questionType" value=2 />多选题</td>
				</tr>
				<tr>
					<td width="28%" class="td-title" style="text-align: center;">请设置答案</td>
					<td class="td-input sel">
						<input type="radio" name="rightAnswer" value=1 />对 
						<input type="radio" name="rightAnswer" value=0 />错
					</td>

					<td class="td-input rad" style="display: none;">
						<input type="radio" name="rightAnswer" value=1 /> 
							A<input type="text" name="optionContent" style="width: 400px;"></input></br> 
						<input type="radio" name="rightAnswer" value=2 /> 
							B<input type="text" name="optionContent" style="width: 400px;"></input></br> 
						<input type="radio" name="rightAnswer" value=3 /> 
							C<input type="text" name="optionContent" style="width: 400px;"></input></br>
						<input type="radio" name="rightAnswer" value=4 /> 
							D<input type="text" name="optionContent" style="width: 400px;"></input>
					</td>

					<td class="td-input che" style="display: none;">
					   <input type="checkbox" name="rightAnswer" value=1 /> 
							A<input type="text" name="optionContent" style="width: 400px;"></input></br> 
						<input type="checkbox" name="rightAnswer" value=2 /> 
							B<input type="text" name="optionContent" style="width: 400px;"></input></br> 
						<input type="checkbox" name="rightAnswer" value=3 /> 
							C<input type="text" name="optionContent" style="width: 400px;"></input></br> 
						<input type="checkbox" name="rightAnswer" value=4 /> 
							D<input type="text" name="optionContent" style="width: 400px;"></input>
					</td>
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
	<script type="text/javascript"
		src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
	<script type="text/javascript">
		$(function() {
		});

		$("[name='questionType']").on("change", function(e) {
			/* 单选 */
			if ($(e.target).val() == 1) {
				$('.rad').css("display", "block");
				
				$('.sel').css("display", "none");
				$('.che').css("display", "none");
				$('.sel [input]').attr("checked", false);
				$(".che input[name='rightAnswer']").attr("checked", false);
				$(".che input[name='optionContent']").val('');
			} 
			/* 多选 */
			else if ($(e.target).val() == 2) {
				$('.che').css("display", "block");
				$('.rad').css("display", "none");
				$('.sel').css("display", "none");
				$('.sel [input]').attr("checked", false);
				$(".rad input[name='rightAnswer']").attr("checked", false);
				$(".rad input[name='optionContent']").val('');
				
			} 
			/* 判断 */
			else {
				$('.sel').css("display", "block");
				$('.che').css("display", "none");
				$('.rad').css("display", "none");
				
				
				$(".che input[name='rightAnswer']").attr("checked", false);
				$(".che input[name='optionContent']").val('');
				
				$(".rad input[name='rightAnswer']").attr("checked", false);
				$(".rad input[name='optionContent']").val('');
				
				
			}

		});
		
		var dialog = parent.dialog.get(window);
		
		var saving = true;
	
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
			if(questionType==3){
				var $_selkVal = $('.sel :radio:checked');
				if($_selkVal.length==0){
					dialogTypeSaveDraft("提示", '没有设置正确答案', '');
					return false;
				}
			}
			//单选题
			if(questionType==1){
				var flag = false;
				var $_radkVal = $('.rad :radio:checked');
				var $_radInputVal = $('.rad :input[name=optionContent]');
				
			
				
				//遍历每个选项输入框,判断不能为空
				$_radInputVal.each(function(){
					var str = $(this).val().replace(/(^\s*)|(\s*$)/g,'');
				    if(str==null || str==''){
				    	console.log($(this).val());
				    	dialogTypeSaveDraft("提示", '问题内容不能为空', '');
				    	flag=true;
				    	return false;			    	
				    }
				  });	
				if(flag){
					return false;
				}
				//判断有没有设置正确值
				if($_radkVal.length==0){
					dialogTypeSaveDraft("提示", '没有设置正确答案', '');
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
					if(str==null || str==''){
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
				$.post("${path}/CultureContestQuestion/insertCultureContestQuestion.do", $("#dictForm").serialize(), function(datas) {
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
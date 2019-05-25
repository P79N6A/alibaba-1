<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>标签管理</title>
<!-- 导入头部文件 start -->
	<%@include file="/WEB-INF/why/common/pageFrame.jsp"%>

<script type="text/javascript">
	$(function() {
		var tagType = $('#tagType').val();
		$.post(
				"${path}/sysdict/queryCode.do",
				{
					'dictCode' : 'tagType'
				},
				function(data) {
					if (data != '' && data != null) {
						var list = eval(data);
						var ulHtml = '';
						for (var i = 0; i < list.length; i++) {
							var dict = list[i];
							ulHtml += '<li data-option="'+dict.dictId+'">'
									+ dict.dictName + '</li>';
							if (tagType != '' && dict.dictId == tagType) {
								$('#tagTypeDiv').html(dict.dictName);
							}
						}
						$('#tagTypeUl').html(ulHtml);
					}
				}).success(function() {
			selectModel();
		});
	});

	function queryMore() {
		var tagType = $('#tagType').val();
		$.post("${path}/sysdict/queryChildCode.do", {'dictCode' : tagType},
				function(data) {
					if (data != '' && data != null) {
						$("#childLable").show();
						var list = eval(data);
						var ulHtml = '';
						for (var i = 0; i < list.length; i++) {
							var dict = list[i];
							ulHtml += '<li data-option="'+dict.dictId+'">'
							+ dict.dictName + '</li>';
							if (tagType != '' && dict.dictId == tagType) {
								$('#tagTypeDivs').html(dict.dictName);
							}
						}
						$('#tagTypeUlS').html(ulHtml);
					} else {
						//隐藏子标签
						$("#tagChildType").val("");
						$("#childLable").hide();
					}
					selectModel();
				}).success(function() {
					selectModel();
				});
	}


	//保存表单
	function saveTag() {
		var tagType = $('#tagType').val();
		var tagName = $('#tagName').val();

		if (tagType == undefined || tagType == "") {
			removeMsg("tagTypeDivLable");
			appendMsg("tagTypeDivLable", "请选择标签类型!");
			$('#tagTypeDiv').focus();
			return;
		} else {
			removeMsg("tagTypeDivLable");
		}

		if (tagName == undefined || tagName == "") {
			removeMsg("tagNameLable");
			appendMsg("tagNameLable", "请选择标签名称!");
			$('#tagName').focus();
			return;
		} else {
			removeMsg("tagNameLable");
		}
		$.post("${path }/tag/saveTag.do", $("#tag_form").serialize(), function(
				data) {
			if (data == "success") {

				jAlert('保存成功', '系统提示','success',function (r){
					location.href = "${path }/tag/tagIndex.do?type=1";
				});

			} else {
				jAlert('保存失败', '系统提示','',function (r){
				});
			}
		});
	}


</script>
</head>
<body class="rbody">
	<!-- 正中间panel -->
	<div id="content">
		<div class="content">
			<div class="con-box-blp">
				<h3>新建标签</h3>
				<form id="tag_form" action="" method="post">
					<input type="hidden" name="tagId" id="tagId" value="${tag.tagId }" />
					<div class="con-box-tlp">
						<div class="form-box">
							<table class="form-table">
								<tbody>
									<tr>
										<td class="td-title"><span class="td-prompt">*</span>标签分类：</td>
										<td class="td-input-two" id="tagTypeDivLable">
											<div class="select-box-one select-box-three">
												<input type="hidden" name="tagType" id="tagType"
													value="${tag.tagType }" />
												<div class="select-text-one select-text-three" data-value="选择标签分类"
													id="tagTypeDiv">选择标签分类</div>
												<ul class="select-option select-option-three" id="tagTypeUl" onmouseleave="queryMore()">

												</ul>
											</div>
										</td>
									</tr>

									<tr id="childLable" style="display: none">
										<td class="td-title"><span class="td-prompt">*</span>标签：</td>
										<td class="td-input-two" id="tagTypeDivLables">
											<div class="select-box-one select-box-three">
												<input type="hidden" name="tagChildType" id="tagChildType"
													   value="${tag.tagType }" />
												<div class="select-text-one select-text-three" data-value="选择标签分类"
													 id="tagTypeDivs">选择标签分类</div>
												<ul class="select-option select-option-three" id="tagTypeUlS">

												</ul>
											</div>
										</td>
									</tr>

									<tr>
										<td class="td-title"><span class="td-prompt">*</span>标签名称：</td>
										<td class="td-input-one" id="tagNameLable"><input type="text"
											value="${tag.tagName }" id="tagName" name="tagName" /></td>
									</tr>
									<tr>
										<td class="td-title"><span class="td-prompt">*</span>标签首字母：</td>
										<td class="td-input-one" id="tagSearchStrLable"><input type="text"
																						  value="${tag.tagSearchStr }" id="tagSearchStr" name="tagSearchStr" /></td>
									</tr>

									<tr class="submit-btn">
										<td colspan="2"><input type="button" value="保存"
											onclick="saveTag()" />
											<input type="button" value="返回"
												   onclick="javascript:location.href='${path}/tag/tagIndex.do'" /></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>

</body>
</html>
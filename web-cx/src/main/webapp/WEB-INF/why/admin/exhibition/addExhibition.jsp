<%@ page language="java" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%-- <%@ page import="com.sun3d.why.enumeration.contest.CcpexhibitionIsLevelEnum"%>
<%@ page
	import="com.sun3d.why.enumeration.contest.CcpexhibitionIsLevelEnum"%>
 --%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<title</title> <%@include file="../../common/pageFrame.jsp"%>
	<%@include file="/WEB-INF/why/common/aliImageFrame.jsp"%>
	<link rel="stylesheet" type="text/css"
		href="${path}/STATIC/css/dialog-back.css" />
	<script type="text/javascript"
		src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
	<link rel="Stylesheet" type="text/css"
		href="${path}/STATIC/css/DialogBySHF.css" />
	<script type="text/javascript" src="${path}/STATIC/js/DialogBySHF.js"></script>

	<style>
.uploader-list {
	min-height: 242px;
	/*width: 960px;*/
}

.uploader-list>.file-item {
	float: left;
	margin-right: 40px;
}

.w30 {
	width: 30px;
}

.margin-left10 {
	margin-left: 10px;
}

#addleave {
	cursor: pointer;
}

.removeleave {
	cursor: pointer;
}
</style>
	<script type="text/javascript">
		seajs.use([ '${path}/STATIC/js/dialogBack/src/dialog-plus' ], function(
				dialog) {
			window.dialog = dialog;
		});
		$("document").ready(function() {
							$(".isDraw").click(function() {
								if ($("#isDrawYes").get(0).checked) {
									$(".leaveList").show()
								} else {
									$(".leaveList").hide()
								}
							})
							aliUploadImg("uploadexhibitionHeadImg",
									uploadexhibitionHeadImgCallBack)

							aliUploadImg("uploadexhibitionFootImg",
									uploadexhibitionFootImgCallBack)

							aliUploadImg("uploadexhibitionShareImg",
									uploadexhibitionShareImgCallBack)

				aliUploadImg("uploadlogo",uploadlogoCallBack)
									
		})
		
		function uploadlogoCallBack(up, file, info){
			
			var aliImgUrl = "${ImgUrl}" + info 
	    	
			//$("#logo").val(aliImgUrl)
			
			$("#"+file.id).append('<input type="hidden" id="indexLogo" name="indexLogo" value="'+aliImgUrl+'"/>')
		}

		function uploadexhibitionHeadImgCallBack(up, file, info) {

			var ImgUrl = "${ImgUrl}" + info

			$("#" + file.id).append('<input type="hidden" id="exhibitionHeadImg" name="exhibitionHeadImg" value="'+ImgUrl+'"/>')

		}

		function uploadexhibitionFootImgCallBack(up, file, info) {

			var ImgUrl = "${ImgUrl}" + info

			$("#" + file.id)
					.append(
							'<input type="hidden" id="exhibitionFootImg" name="exhibitionFootImg" value="'+ImgUrl+'"/>')
		}

		function uploadexhibitionShareImgCallBack(up, file, info) {

			var ImgUrl = "${ImgUrl}" + info

			$("#" + file.id)
					.append(
							'<input type="hidden" id="exhibitionShareImg" name="exhibitionShareImg" value="'+ImgUrl+'"/>')

		}

		function check() {

			/* 页面抬头的校验 */
			var exhibitionHead = $("#exhibitionHead").val();

			if (exhibitionHead == undefined || $.trim(exhibitionHead) == "") {
				removeMsg("exhibitionHeadLabel");
				appendMsg("exhibitionHeadLabel", "请输入页面抬头!");
				$("#exhibitionHead").focus();
				return false;
			} else if (exhibitionHead.length >= 11) {
				removeMsg("exhibitionHeadLabel");
				appendMsg("exhibitionHeadLabel", "最多不超过10个汉字!");
				$("#exhibitionHead").focus();
			} else
				removeMsg("exhibitionHeadLabel");

			/* 主标题的校验 */
			var exhibitionTitle = $("#exhibitionTitle").val();

			if (exhibitionTitle == undefined || $.trim(exhibitionTitle) == "") {
				removeMsg("exhibitionTitleLabel");
				appendMsg("exhibitionTitleLabel", "请输入主标题!");
				$("#exhibitionTitle").focus();
				return false;
			} else if (exhibitionTitle.length >= 11) {
				removeMsg("exhibitionTitleLabel");
				appendMsg("exhibitionTitleLabel", "最多不超过10个汉字!");
				$("#exhibitionTitle").focus();
			} else
				removeMsg("exhibitionTitleLabel");

			/* 副标题的校验 */
			var exhibitionSubtitle = $("#exhibitionSubtitle").val();

			if (exhibitionSubtitle == undefined
					|| $.trim(exhibitionSubtitle) == "") {
				removeMsg("exhibitionSubtitleLabel");
				appendMsg("exhibitionSubtitleLabel", "请输入副标题!");
				$("#exhibitionSubtitle").focus();
				return false;
			} else if (exhibitionSubtitle.length >= 19) {
				removeMsg("exhibitionSubtitleLabel");
				appendMsg("exhibitionSubtitleLabel", "最多不超过18个汉字!");
				$("#exhibitionSubtitle").focus();
				return false;
			} else
				removeMsg("exhibitionSubtitleLabel");

			/* 封底文字的校验 */
			var exhibitionFootContent = $("#exhibitionFootContent").val();

			if (exhibitionFootContent == undefined
					|| $.trim(exhibitionFootContent) == "") {
				removeMsg("exhibitionFootContentLabel");
				appendMsg("exhibitionFootContentLabel", "请输入封底文字!");
				$("#exhibitionFootContent").focus();
				return false;
			} else if (exhibitionFootContent.length > 11) {
				removeMsg("exhibitionFootContentLabel");
				appendMsg("exhibitionFootContentLabel", "最多不超过9个汉字!");
				$("#exhibitionFootContent").focus();
				return false;
			} else
				removeMsg("exhibitionFootContentLabel");

			/* 分享标题的校验 */
			var exhibitionShareTitle = $("#exhibitionShareTitle").val();

			if (exhibitionShareTitle == undefined
					|| $.trim(exhibitionShareTitle) == "") {
				removeMsg("exhibitionShareTitleLabel");
				appendMsg("exhibitionShareTitleLabel", "请输入分享标题!");
				$("#exhibitionShareTitle").focus();
				return false;
			} else if (exhibitionShareTitle.length > 21) {
				removeMsg("exhibitionShareTitleLabel");
				appendMsg("exhibitionShareTitleLabel", "最多不超过20个汉字!");
				$("#exhibitionShareTitle").focus();
				return false;
			} else
				removeMsg("exhibitionShareTitleLabel");

			/* 分享描述的校验 */
			var exhibitionShareDesc = $("#exhibitionShareDesc").val();

			if (exhibitionShareDesc == undefined
					|| $.trim(exhibitionShareDesc) == "") {
				removeMsg("exhibitionShareDescLabel");
				appendMsg("exhibitionShareDescLabel", "请输入分享描述!");
				$("#exhibitionShareDesc").focus();
				return false;
			} else if (exhibitionShareDesc.length > 51) {
				removeMsg("exhibitionShareDescLabel");
				appendMsg("exhibitionShareDescLabel", "最多不超过50个汉字!");
				$("#exhibitionShareDesc").focus();
				return false;
			} else
				removeMsg("exhibitionShareDescLabel");

			return true;
		}

		$(
				function() {
					// 保存
					$(".btn-publish")
							.click(
									function() {

										var c = check();
										if (c) {
											$
													.post(
															"${path}/exhibition/addCcpExhibition.do",
															$("#exhibitionForm")
																	.serializeArray(),
															function(result) {

																if (result == 'user') {
																	alert("请先登录！");
																	window.location.href = "${path}/login.do";
																} else if (result == 'success') {
																	alert("添加成功！");
																	window.location.href = "${path}/exhibition/exhibitionIndex.do";
																} else
																	alert("添加失败，系统错误！");
															});
										}
									});

				})
	</script>
</head>

<body>
	<div class="site">
		<em>您现在所在的位置：</em>运维管理 &gt; 线上展览&gt; 添加展览
	</div>
	<div class="site-title">添加展览页</div>
	<form method="post" id="exhibitionForm">
		<input type="hidden" id="userCounty" name="userCounty"
			value="${sessionScope.user.userCounty}" /> <input type="hidden"
			<div class="main-publish">
			<table width="100%" class="form-table">
				<tr>
					<td width="100" class="td-title"></span>展览页面抬头</td>
					<td class="td-input" id="exhibitionHeadLabel"><input
						id="exhibitionHead" name="exhibitionHead" type="text"
						class="input-text w510" value='${exhibition.exhibitionHead }'
						maxlength="15" /> <span>10个汉字以内</span></td>
				</tr>
				<tr>
					<td width="100" class="td-title" style="font-weight:bold;">设置封面</td>
				</tr>
				<tr>
					<td width="100" class="td-title">封面主标题:</td>
					<td class="td-input" id="exhibitionTitleLabel"><input
						id="exhibitionTitle" name="exhibitionTitle" type="text"
						class="input-text w510" value='${exhibition.exhibitionTitle }'
						maxlength="15" /> <span>10个汉字以内</span></td>
				</tr>
				<tr>
					<td width="100" class="td-title">封面副标题:</td>
					<td class="td-input" id="exhibitionSubtitleLabel"><input
						id="exhibitionSubtitle" name="exhibitionSubtitle" type="text"
						class="input-text w510" value='${exhibition.exhibitionSubtitle }'
						maxlength="25" /> <span>18个汉字以内</span></td>
				</tr>
				 <tr>
						<td width="100" class="td-title">上传封面图：</td>
						<td class="td-input" id="">
								<div id="uploadexhibitionHeadImg">

								<c:choose>
										<c:when test="${!empty exhibition.exhibitionHeadImg  }">
											<div name="aliFile" style="position:relative" ><span></span><b></b>
												<img onclick="aliRemoveImg(this)" class="aliRemoveBtn" src="../STATIC/image/removeBtn.png" style="position:absolute;left:80px;top:0;width:20px" />
												<img src="${exhibition.exhibitionHeadImg}@300w" style="max-height: 100px;max-width: 100px;" />
												<br />
												<input type="hidden" value="${exhibition.exhibitionHeadImg }" name="exhibitionHeadImg" id="exhibitionHeadImg"/>
											</div></c:when>
			<c:otherwise>
				<img src="">
			</c:otherwise> </c:choose>

			<div id="ossfile2">你的浏览器不支持flash,Silverlight或者HTML5！</div>
			<div id="container2">
				<a id="selectfiles2" href="javascript:void(0);" class='btn'>选择图片</a>
				<a id="postfiles2" href="javascript:void(0);" class='btn'>开始上传</a>
				请上传600*400图片
			</div>
			</div>

			</div>
			</td>
			</tr> <!-- <tr>
					  <td width="100" class="td-title"></td>
					  <td class="td-btn">
					  <input class="btn-publish" type="button" value="查看" id="lookButton"/>
					  </td>
				</tr> -->
			<tr>
				<td width="100" class="td-title" style="font-weight:bold;">设置封底</td>
			</tr>
			<input type="hidden" value="${exhibition.exhibitionId }" name="exhibitionId" id="exhibitionId" />
			<tr>
				<td width="100" class="td-title">上传封底图：</td>
				<td class="td-input" id="">
					<div id="uploadexhibitionFootImg">

						<c:choose>
							<c:when test="${!empty exhibition.exhibitionFootImg  }">
								<div name="aliFile" style="position: relative">
									<span></span><b></b> <img onclick="aliRemoveImg(this)"
										class="aliRemoveBtn" src="../STATIC/image/removeBtn.png"
										style="position: absolute; left: 80px; top: 0; width: 20px" />
									<img src="${exhibition.exhibitionFootImg}@300w"
										style="max-height: 100px; max-width: 100px;" /> <br /> <input
										type="hidden" value="${exhibition.exhibitionFootImg }"
										name="exhibitionFootImg" id="exhibitionFootImg" />
								</div>
							</c:when>
							<c:otherwise>
								<img src=""> 
							</c:otherwise>
						</c:choose>

						<div id="ossfile2">你的浏览器不支持flash,Silverlight或者HTML5！</div>
						<div id="container2">
							<a id="selectfiles2" href="javascript:void(0);" class='btn'>选择图片</a>
							<a id="postfiles2" href="javascript:void(0);" class='btn'>开始上传</a>
							请上传650*600图片
						</div>
					</div>

					</div>
				</td>
			</tr>
			<tr>
				<td width="100" class="td-title">封底文字:</td>
				<td class="td-input" id="exhibitionFootContentLabel"><input
					id="exhibitionFootContent" name="exhibitionFootContent" type="text"
					class="input-text w510"
					value='${exhibition.exhibitionFootContent }' maxlength="15" /> <span>9个汉字以内</span>
				</td>
			</tr>

			<tr>
				<td width="100" class="td-title">上传分享图：</td>
				<td class="td-input" id="">
					<div id="uploadexhibitionShareImg">
						<c:choose>
							<c:when test="${!empty exhibition.exhibitionShareImg  }">
								<div name="aliFile" style="position: relative">
									<span></span><b></b> <img onclick="aliRemoveImg(this)"
										class="aliRemoveBtn" src="../STATIC/image/removeBtn.png"
										style="position: absolute; left: 80px; top: 0; width: 20px" />
									<img src="${exhibition.exhibitionShareImg}@300w"
										style="max-height: 100px; max-width: 100px;" /> <br /> <input
										type="hidden" value="${exhibition.exhibitionShareImg }"
										name="exhibitionShareImg" id="exhibitionShareImg" />
								</div>
							</c:when>
							<c:otherwise>
								<img src=""> 
							</c:otherwise>
						</c:choose>

						<div id="ossfile2">你的浏览器不支持flash,Silverlight或者HTML5！</div>
						<div id="container2">
							<a id="selectfiles2" href="javascript:void(0);" class='btn'>选择图片</a>
							<a id="postfiles2" href="javascript:void(0);" class='btn'>开始上传</a>
							请上传300*300图片
						</div>
					</div>

					</div>
				</td>
			</tr>

			<tr>
				<td width="100" class="td-title"></span>分享标题：</td>
				<td class="td-input" id="exhibitionShareTitleLabel"><input
					id="exhibitionShareTitle" name="exhibitionShareTitle" type="text"
					class="input-text w510" value='${exhibition.exhibitionShareTitle }'
					maxlength="25" /> <span>20个汉字以内</span></td>
			</tr>
			<tr>
				<td width="100" class="td-title"></span>分享描述：</td>
				<td class="td-input" id="exhibitionShareDescLabel"><input
					id="exhibitionShareDesc" name="exhibitionShareDesc" type="text"
					class="input-text w510" value='${exhibition.exhibitionShareDesc }'
					maxlength="60" /> <span>50个汉字以内</span></td>
			</tr>
			<tr id="logoLabel">
						<td width="100" class="td-title">首页显示LOGO：</td>
						<td class="td-input" >
							<div id="uploadlogo" >

								<div class="td-input">
									 <div class="aliImg img-box">
									 <c:choose>
										<c:when test="${!empty exhibition.indexLogo   }">
											<div name="aliFile" style="position:relative" ><span></span><b></b>
												<img onclick="aliRemoveImg(this)" class="aliRemoveBtn" src="../STATIC/image/removeBtn.png" style="position:absolute;left:80px;top:0;width:20px" />
												<img src="${exhibition.indexLogo }@80w" style="max-height: 150px;max-width: 100px;" />
												<br />
												<input type="hidden" value="${exhibition.indexLogo }" name="logo" id="logo"/>
											</div>
										</c:when>
										<c:otherwise>
										</c:otherwise>
									</c:choose>
			                    </div>
			                    <div id="ossfile2">你的浏览器不支持flash,Silverlight或者HTML5！</div>
			                    <div id="container2">
			                  		<a id="selectfiles2" href="javascript:void(0);" class='btn'>选择上传LOGO</a>
									<a id="postfiles2" href="javascript:void(0);" class='btn'>开始上传</a>
									 请上传大于90X80图片
			                    </div>
								</div>
							</div>
						<span class="error-msg"></span>
						</td>
					</tr>
			<tr>
				<td width="100" class="td-title"></td>
				<td class="td-btn"><input class="btn-save" type="button"
					onclick="javascript:window.history.go(-1);" value="返回" /> <input
					class="btn-publish" type="button" value="保存" /></td>
			</tr>
			</table>
			</div>
	</form>

</body>


</html>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>新增用户</title>
	<!-- 导入头部文件 start -->
	<%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
	<script type="text/javascript" src="${path}/STATIC/js/admin/terminalUser/UploadTerminalUserFile.js"></script>
	<%--<script type="text/javascript" src="${path}/STATIC/js/admin/terminalUser/getTerminalUserFile.js"></script>--%>
	<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
	<script type="text/javascript">

		$(function(){
			removeMsg("userNameLabel");
			appendMsg("userNameLabel","支持数字、字母、下划线、汉字!");
			selectUserTypeClass();
			selectModel();
			getArea();
		});

		seajs.config({
			alias: {
				"jquery": "jquery-1.10.2.js"
			}
		});

		seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
		window.dialog = dialog;
		});



		// 省市区
		function getArea(){
			var teamUserProvince='${user.userProvince}';
			var teamUserCity='${user.userCity}';
			var teamUserArea='${user.userCounty}';
			if((teamUserProvince != null && teamUserProvince != "") && (teamUserCity != null && teamUserCity != "") && (teamUserArea != null && teamUserArea != "")){
				//省市区
				showLocation(teamUserProvince.split(",")[0],teamUserCity.split(",")[0],teamUserArea.split(",")[0]);
				$("#loc_province").select2("val", teamUserProvince.split(",")[0]);
				$("#loc_city").select2("val", teamUserCity.split(",")[0]);
				$("#loc_town").select2("val",  teamUserArea.split(",")[0]);

			}else {
				showLocation();
			}

			var userIsManger = '${user.userIsManger}';
			if(userIsManger!=undefined&&userIsManger == 1){ // 省级管理员
				$("#locProvinceDiv").show();
				$("#loc_province").attr("disabled", true);
				$("#locCityDiv").show();
				$("#locCountyDiv").show();
			}else if(userIsManger!=undefined&&userIsManger == 2){ // 市级管理员
				$("#locProvinceDiv").show();
				$("#locCityDiv").show();
				$("#locCountyDiv").show();
				$("#loc_province").attr("disabled", true);
				$("#loc_city").attr("disabled", true);
			}else{ // 区级管理员和场馆级管理员
				$("#locProvinceDiv").show();
				$("#locCityDiv").show();
				$("#locCountyDiv").show();
				$("#loc_province").attr("disabled", true);
				$("#loc_city").attr("disabled", true);
				$("#loc_town").attr("disabled", true);
			}
		}

		//用户类别为团体管理员时，验证真实姓名和身份证
		function selectUserTypeClass(){
			$("#userTypeUl li").mousedown(function(){
				var userType = $(this).attr("data-option");
				if(userType == 2){
					$("#userNickNameSpan").html("*");
					$("#userNickNameSpan").addClass("red");
					$("#userCardNoSpan").html("*");
					$("#userCardNoSpan").addClass("red");
				}else{
					$("#userNickNameSpan").html("");
					$("#userNickNameSpan").removeClass();
					$("#userCardNoSpan").html("");
					$("#userCardNoSpan").removeClass();
				}
			});
		}

		//新增表单
		function doSubmit(userIsDisable) {

			var isCutImg =$("#isCutImg").val();
			if("N"==isCutImg) {
				dialogAlert("提示","请先裁剪系统要求尺寸(750*500)的图片，再提交！",function(){
				});
				return;
			}

			$("#userProvinceText").val($("#loc_province").find("option:selected").val()+","+$("#loc_province").find("option:selected").text());
			$("#userCityText").val($("#loc_city").find("option:selected").val()+","+$("#loc_city").find("option:selected").text());
			$("#userCountyText").val($("#loc_town").find("option:selected").val()+","+$("#loc_town").find("option:selected").text());

			var userName = $("#userName").val();
			var userType = $("#userType").val();
			var userNickName = $("#userNickName").val();
			var userCardNo = $("#userCardNo").val();
			var userMobileNo = $("#userMobileNo").val();
			var userCountyText = $("#userCountyText").val();
			var userEmail = $("#userEmail").val();
			var userBirth = $("#userBirthStr").val();
			var userSex = $('input:radio[name="userSex"]:checked').val();

			// 用户名称
			var pattern = new RegExp("[^a-zA-Z0-9\_\u4e00-\u9fa5]","i");
			var arr = userName.split("_");
			if(userName == undefined || $.trim(userName) == ""){
				removeMsg("userNameLabel");
				appendMsg("userNameLabel","请输入昵称!");
				$("#userName").focus();
				return false;
			}else if(pattern.test(userName)){
				removeMsg("userNameLabel");
				appendMsg("userNameLabel","支持数字、字母、下划线、汉字!");
				$("#userName").focus();
				return false;
			}else if(arr.length > 2){
				removeMsg("userNameLabel");
				appendMsg("userNameLabel","下划线最多一个!");
				$("#userName").focus();
				return false;
			}else{
				removeMsg("userNameLabel");
			}

			// 用户类别
			if(userType == undefined || $.trim(userType) == ""){
				removeMsg("userTypeLabel");
				appendMsg("userTypeLabel","用户类别必选!");
				$("#userTypeLimit").focus();
				return false;
			}else{
				removeMsg("userTypeLabel");
			}

			if(userType == 2){
				// 真实姓名
				if(userNickName == undefined || $.trim(userNickName) == ""){
					removeMsg("userNickNameLabel");
					appendMsg("userNickNameLabel","请输入真实姓名!");
					$("#userNickName").focus();
					return false;
				}else{
					removeMsg("userNickNameLabel");
				}
			}else{
				removeMsg("userNickNameLabel");
			}

			if(userType == 2){
				// 身份证号
				if(userCardNo == undefined || $.trim(userCardNo) == ""){
					removeMsg("userCardNoLabel");
					appendMsg("userCardNoLabel","请输入身份证号!");
					$("#userCardNo").focus();
					return false;
				}else{
					var reg = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/;
					if(reg.test(userCardNo) == false){
						removeMsg("userCardNoLabel");
						appendMsg("userCardNoLabel","身份证输入不合法!");
						$("#userCardNo").focus();
						return  false;
					}else{
						removeMsg("userCardNoLabel");
					}
				}
			}else{
				removeMsg("userCardNoLabel");
			}

			var re =/^1\d{10}$/;
			// 手机号码
			if(userMobileNo == undefined || $.trim(userMobileNo) == ""){
				removeMsg("userMobileNoLabel");
				appendMsg("userMobileNoLabel","请输入手机号码!");
				$("#userMobileNo").focus();
				return false;
			}else if(!re.test(userMobileNo)){
				removeMsg("userMobileNoLabel");
				appendMsg("userMobileNoLabel","请正确填写手机号码!");
				$("#userMobileNo").focus();
				return false;
			}else{
				removeMsg("userMobileNoLabel");
			}

			// 省市区
			if(userCountyText == '' || userCountyText == 'undefined,'  || userCountyText == undefined || $.trim(userCountyText) == ",区"){
				removeMsg("userCountyTextLabel");
				appendMsg("userCountyTextLabel","请选择所属地区!");
				$("#userCountyText").focus();
				return false;
			}else{
				removeMsg("userCountyTextLabel");
			}

			// 电子邮箱
			if($.trim(userEmail).length > 0){
				if(!is_email(userEmail)){
					removeMsg("userEmailLabel");
					appendMsg("userEmailLabel","电子邮箱格式不正确!");
					$("#userEmail").focus();
					return false;
				}else{
					removeMsg("userEmailLabel");
				}
			}else{
				removeMsg("userEmailLabel");
			}

			// 出生日期
			if($.trim(userBirth).length > 0){
				var currentDate = new Date();
				if(Date.parse(userBirth) > currentDate){
					removeMsg("userBirthLabel");
					appendMsg("userBirthLabel","出生日期小于今天!");
					$("#userBirthStr").focus();
					return false;
				}else{
					removeMsg("userBirthLabel");
				}
			}else{
				removeMsg("userBirthLabel");
			}

			// 性别
			if(userSex == undefined || userSex == null){
				removeMsg("userSexLabel");
				appendMsg("userSexLabel","请选择性别!");
				$("#userSex").focus();
				return false;
			}else{
				removeMsg("userSexLabel");
			}

			$("#userIsDisable").val(userIsDisable);
			$.ajax({
				type: "POST",
				url: "${path}/terminalUser/addTerminalUser.do",
				data: $("#terminalUserForm").serialize(),
				async:false,
				success: function(data){
					if (data == "success") {
						dialogSaveDraft("提示", "用户保存成功，密码已发送到手机上", function(){
							window.location.href = "${path}/terminalUser/terminalUserIndex.do?userIsDisable="+$("#userIsDisable").val();
						});
					}else if(data == "repeat"){
						removeMsg("userNameLabel");
						appendMsg("userNameLabel","用户名称已存在!");
						$("#userName").focus();
					}else if(data == "mobileRepeat"){
						removeMsg("userMobileNoLabel");
						appendMsg("userMobileNoLabel","手机号码不可重复!");
						$("#userMobileNo").focus();
					}else if(data == "cardNoRepeat"){
						removeMsg("userCardNoLabel");
						appendMsg("userCardNoLabel","身份证号不可重复!");
						$("#userCardNo").focus();
					} else {
						dialogSaveDraft("提示", "用户保存失败")
					}
				}
			});
		}
	</script>
</head>

<body >
<form action="" id="terminalUserForm" method="post">
	<input type="hidden" id="sessionId" value="${pageContext.session.id}"/>
	<input type="hidden" id="userCounty" value="${sessionScope.user.userCounty}" />
	<input type="hidden" id="isCutImg" value="N"/>
	<div class="site">
		<em>您现在所在的位置：</em>会员管理 &gt; 用户管理 &gt; 用户新增
	</div>
	<div class="site-title">用户新增</div>
	<div class="main-publish">
		<table width="100%" class="form-table">
			<tr>
				<td width="100" class="td-title"><span class="red">*</span>昵称：</td>
				<td class="td-input" id="userNameLabel">
					<input type="text" id="userName" name="userName" class="input-text w210" maxlength="20"/></td>
			</tr>
			<tr>
				<td class="td-title"><span class="red">*</span>用户类别：
					<input type="text" id="userTypeLimit" style="position: absolute; left: -9999px;" />
				</td>
				<td class="td-select" id="userTypeLabel">
					<div class="select-box w140">
						<input type="hidden" id="userType"  name="userType"/>
						<div class="select-text" data-value="" id="userTypeDiv">全部类别</div>
						<ul class="select-option" id="userTypeUl">
							<li data-option="1">普通用户</li>
							<li data-option="2">团体管理员</li>
						</ul>
					</div>
				</td>
			</tr>
			<tr>
				<td class="td-title">用户头像：</td>
				<td class="td-upload">
					<table>
						<tr>
							<td>
								<input type="hidden"  name="userHeadImgUrl" id="headImgUrl" value="">
								<input type="hidden" name="uploadType" value="Img" id="uploadType"/>

								<div class="img-box">
									<div  id="imgHeadPrev" class="img"> </div>
								</div>

								<div class="controls-box">
									<div style="height: 46px;">
										<div class="controls" style="float:left;">
											<input type="file" name="file" id="file">
										</div>
										<%--<input type="button" class="upload-cut-btn" id="" value="裁剪图片"/>--%>
										<span class="upload-tip">可上传1张图片，建议尺寸750*500像素，格式为jpg,jpeg,png,gif，大小不超过2M</span>
									</div>
									<div id="fileContainer"></div>
									<div id="btnContainer" style="display: none;">
										<a style="margin-left:335px;" href="javascript:clearQueue();" class="btn">取消</a>
									</div>
								</div>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td class="td-title"><span id="userNickNameSpan"></span>真实姓名：</td>
				<td class="td-input" id="userNickNameLabel"><input type="text" id="userNickName" name="userNickName" class="input-text w210" maxlength="25"/></td>
			</tr>
			<tr>
				<td class="td-title"><span id="userCardNoSpan"></span>身份证号：</td>
				<td class="td-input" id="userCardNoLabel"><input type="text" id="userCardNo" name="userCardNo" class="input-text w210" maxlength="18"/></td>
			</tr>
			<tr>
				<td class="td-title"><span class="red">*</span>手机号码：</td>
				<td class="td-input" id="userMobileNoLabel"><input type="text" maxlength="11" name="userMobileNo" id="userMobileNo" class="input-text w210" onkeyup="this.value=this.value.replace(/\D/g,'')"/></td>
			</tr>
			<tr>
				<td  class="td-title"><span class="red">*</span>所属地区：</td>
				<td  class="td-select" id="userCountyTextLabel">
					<div id="locProvinceDiv">
						<select id="loc_province"
								style="width: 130px;"></select>
						<input type="hidden" name="userProvince" id="userProvinceText" />
					</div>

					<div id="locCityDiv">
							<select id="loc_city"
									style="width: 130px; margin-left: 10px"></select>
							<input type="hidden" name="userCity" id="userCityText" />
					</div>
					<div id="locCountyDiv">
						<select id="loc_town"
									style="width: 130px; margin-left: 10px"></select>
						<input type="hidden" name="userArea" id="userCountyText" />
					</div>
				</td>
			</tr>
			<tr>
				<td class="td-title">常用邮箱：</td>
				<td class="td-input" id="userEmailLabel"><input type="text" name="userEmail" id="userEmail" class="input-text w210" maxlength="100"/></td>
			</tr>
			<tr>
				<td class="td-title">出生日期：</td>
				<td class="td-input" id="userBirthLabel">
					<input  type="text" name="userBirthStr" onClick="WdatePicker();"	style="width: 200px;" id="userBirthStr" class="input-text w210" />
				</td>
			</tr>
			<tr>
				<td class="td-title"><span class="red">*</span>性别：</td>
				<td class="td-radio" id="userSexLabel">
					<input type="hidden" id="userSex"/>
					<label><input type="radio" value="1" name="userSex" checked/><em>男</em></label>
					<label><input type="radio" value="2" name="userSex"/><em>女</em></label>
					<%--<input type="radio" value="3" name="userSex" checked/>保密--%>
				</td>
			</tr>
			<tr class="td-btn">
				<td></td>
				<td><input type="hidden" name="userIsDisable" id="userIsDisable"/>
					<input type="button" value="保存" class="btn-save" onclick="javascript:return doSubmit(1);"/>
					<input type="button" value="返回" class="btn-publish" onclick="javascript:history.back(-1);"/>
				</td>
			</tr>
		</table>
	</div>
</form>
</body>
</html>
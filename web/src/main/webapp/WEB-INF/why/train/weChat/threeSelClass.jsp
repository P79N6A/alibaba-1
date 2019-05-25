<%@ page language="java" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%
	String path = request.getContextPath();
	request.setAttribute("path", path);
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	request.setAttribute("basePath", basePath);
%>
<!doctype html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title>万人培训-选择课程</title>
<meta name="viewport"
	content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">

<link rel="stylesheet" type="text/css"
	href="${path}/STATIC/train/weChat/css/mobiscroll.custom-2.4.4.min.css">
<link rel="stylesheet" type="text/css"
	href="${path}/STATIC/train/weChat/css/ui-dialog.css" />
<link rel="stylesheet" type="text/css"
	href="${path}/STATIC/train/weChat/css/css.css">
<script type="text/javascript"
	src="${path}/STATIC/train/weChat/js/jquery-min.js"></script>
<script type="text/javascript"
	src="${path}/STATIC/train/weChat/js/common.js"></script>
<script type="text/javascript"
	src="${path}/STATIC/train/weChat/js/mobiscroll.custom-2.17.0.min.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
<!--移动端版本兼容 -->
<script type="text/javascript">
	var phoneWidth = parseInt(window.screen.width);
	var phoneScale = phoneWidth / 750;
	var ua = navigator.userAgent; //浏览器类型
	if (/Android (\d+\.\d+)/.test(ua)) { //判断是否是安卓系统
		var version = parseFloat(RegExp.$1); //安卓系统的版本号
		if (version > 2.3) {
			document
					.write('<meta name="viewport" content="width=750, minimum-scale = '+phoneScale+', maximum-scale = '+phoneScale+', target-densitydpi=device-dpi">');
		} else {
			document
					.write('<meta name="viewport" content="width=750, target-densitydpi=device-dpi">');
		}
	} else {
		document
				.write('<meta name="viewport" content="width=750, user-scalable=no, target-densitydpi=device-dpi">');
	}
</script>
<script>
var isCommitted = false;
	function formSub() {
		if (!isCommitted) {
			isCommitted = true;
		} else {
			dialogAlert("不能重复提交表单");
			return false;
		}
		var i = 0;
		var j = 0;
		var open = $(".submitS1").attr("data-action");
		if (open == 'false')
			return;
		$(".train_radio_even").each(function(index, element) {
			if ($(this).hasClass("on")) {
				i++;
				var v = $(this).find("input").val();
				$("#TI" + v).prop("disabled", false);
				$("#TY" + v).prop("disabled", false);
			}
		});

		$(".train_check_even").each(function(index, element) {
			if ($(this).hasClass("on")) {
				j++;
				var v = $(this).find("input").val();
				$("#TI" + v).prop("disabled", false);
				$("#TY" + v).prop("disabled", false);
			}
		});
		if (i + j == 0) {
			dialogAlert("提示", "请至少选择一个课程!");
			return;
		}
		if (j > 6) {
			dialogAlert("提示", "讲座类最多选择6项!");
			return;
		}

		$.post("${path}/millionPeople/saveCourseOrder.do", $("#vform")
				.serialize(), function(data) {
			var map = eval(data);
			if (map.success == 'Y') {
				location.href = "${path}/millionPeople/toOrderSucess.do?"
						+ $("#vform").serialize();
			} else {
				dialogAlert("提示", map.msg, function() {
					location.href = "${path}/millionPeople/toOrder.do";
				});
			}
		});
	}
	
	function alertForbbiden(){
      dialogAlert("提示", "报名工作将于9月7日上午9:00正式开始。");
    }
</script>
<!--移动端版本兼容 end -->
</head>
<body>
	<div class="header">
		<a href="javascript:history.go(-1);" class="pre"></a> <span>文化云</span>
		<a class="center" href="${path}/millionPeople/queryCourseOrder.do">个人中心</a>
	</div>
	<div class="content contentS2">
		<div class="tilClass">
			<div class="boxT">
				<p>
					
				</p>
			</div>
			<div class="tabBtn borderRadiu5">
			<a href="javascript:void(0);" class="second boxSize on"
					data-option='3'>第三次培训课程</a>
				<a href="javascript:void(0);" class="second boxSize"
					data-option='2'>第二次培训课程</a> <a href="javascript:void(0);"
					class="first boxSize" data-option='1'>第一次培训课程</a>
			</div>
		</div>
		<div id="classOne"></div>
		<form id="vform" action="">
			<input type="hidden" name="userId" value="${user.userId}"
				class="rp_noinput" />
			<div class="selCon">
				<div class="tilText">
					三天短训类 <span>(最多选择一项)</span>
				</div>
				<ul class="trains_select borderRadiu5">
					<c:forEach items="${shortCourses}" var="course" varStatus="i">
						<input id="TI${course.courseId}" type="hidden" disabled="disabled"
							name="courseTitle" value="${course.courseTitle}"
							class="rp_noinput" />
						<input id="TY${course.courseId}" type="hidden" disabled="disabled"
							name="courseType" value="${course.courseType}" class="rp_noinput" />
						<li class="clearfix">
							<div class="selTop clearfix"
								<c:if test="${i.index==0}">width="26"</c:if>>
								
 								<c:if
									test="${(not empty course.orderNum and course.peopleNumber<=course.orderNum) or fn:indexOf(course.courseField, trainUser.engagedField)==-1}">
									<div class="train_radio notselect">
										<input type="radio" id="${course.courseId}" disabled
											value="${course.courseId}" name="courseId" />
									</div>
								</c:if>
								<c:if
									test="${(empty course.orderNum or course.peopleNumber>course.orderNum) and fn:indexOf(course.courseField, trainUser.engagedField)!=-1}">
									<div class="train_radio train_radio_even">
										<input type="radio" id="${course.courseId}"
											value="${course.courseId}" name="courseId" />
									</div>
								</c:if>
 								 
								<label for='${course.courseId}' class="topic">${course.courseTitle
									}</label> <span class="detailS"></span>
							</div>
							<div class="info">
								<div class="infoInner">
									<h2>【培训时间】</h2>
									<p>${course.courseStartTime} 至 ${course.courseEndTime}
										&nbsp;&nbsp;${course.trainTime}</p>
									<c:if test="${not empty course.coursePhoneNum}">
										<h2>【联系方式】</h2>
										<p>${course.coursePhoneNum}</p>
									</c:if>
									<h2>【培训地点】</h2>
									<p>${course.trainAddress}</p>
									<h2>【目标学员】</h2>
									<p>${course.targetAudienc}</p>
									<h2>【师资简介】</h2>
									<p>${course.teacherIntro}</p>
									<h2>【课程简介】</h2>
									<p>${course.courseDescription}</p>
								</div>
							</div>
						</li>
					</c:forEach>
				</ul>
				<div class="tilText">
					讲座类 <span>(最多选择6项)</span>
				</div>
				<ul class="trains_select borderRadiu5">
					<c:forEach items="${lectureCourses}" var="course" varStatus="i">
						<input id="TI${course.courseId}" type="hidden" name="courseTitle"
							disabled="disabled" value="${course.courseTitle}"
							class="rp_noinput" />
						<input id="TY${course.courseId}" type="hidden" name="courseType"
							disabled="disabled" value="${course.courseType}"
							class="rp_noinput" />
						<li class="clearfix">
							<div class="selTop clearfix">
								<c:if
									test="${(not empty course.orderNum and course.peopleNumber<=course.orderNum) or fn:indexOf(course.courseField, trainUser.engagedField)==-1}">
									<div class="train_check notselect">
										<input type="checkbox" id="${course.courseId}" disabled
											value="${course.courseId}" name="courseId" />
									</div>
								</c:if>
								<c:if
									test="${(empty course.orderNum or course.peopleNumber>course.orderNum) and fn:indexOf(course.courseField, trainUser.engagedField)!=-1}">
									<div class="train_check train_check_even">
										<input type="checkbox" id="${course.courseId}"
											value="${course.courseId}" name="courseId" />
									</div>
								</c:if>
								<label for='${course.courseId}' class="topic">${course.courseTitle}</label>
								<span class="detailS"></span>
							</div>
							<div class="info">
								<div class="infoInner">
									<h2>【培训时间】</h2>
									<p>${course.courseStartTime} 至 ${course.courseEndTime}
										&nbsp;&nbsp;${course.trainTime}</p>
									<c:if test="${not empty course.coursePhoneNum}">
										<p>
										<h2>【联系方式】</h2>
										<p>${course.coursePhoneNum}</p>
									</c:if>
									<h2>【培训地点】</h2>
									<p>${course.trainAddress}</p>
									<h2>【目标学员】</h2>
									<p>${course.targetAudienc}</p>
									<h2>【师资简介】</h2>
									<p>${course.teacherIntro}</p>
									<h2>【课程简介】</h2>
									<p>${course.courseDescription}</p>
								</div>
							</div>
						</li>
					</c:forEach>
				</ul>
				<div class="tilText">报名须知</div>
				<div class="signUptip borderRadiu5 clearfix">
					<div class="p">
				各位学员，为有效做好2016-2018年度上海市公共文化从业人员万人培训选课报名的服务工作，请仔细阅读以下内容：</br>
				1.2016年万人培训的第三次报名于9月7日上午9:00正式开始，培训时间为10月-12月。</br>
				2.每名学员的身份证号每年最多可选3天短训班1次和专题讲座6场。</br>
				3.每门课程均有报名限额，报满即止。如本次报名未成功，请在明年继续参加选课。</br>
				4.报名是否成功，请在“我的报名”中查看确认状态。</br>
				5.报名成功后，如因故无法参加，学员须事先自行取消报名。</br>
				6.开课前3日，系统将冻结取消按钮。学员如因故无法参加，请与所在单位调剂其他人员参加课程，不得无故缺席。累计两次报名成功但未参加培训的学员，注册信息将列入系统黑名单。</br>
				7.所有培训院校均不提供停车位，请学员尽量乘坐公共交通前往。</br>
					</div>
				</div>
				<div class="accpectTip">
					<div class="train_check" id="agreetip">
						<input type="checkbox" id="checkboxt" name="radiocc" />
					</div>
					<label for='checkboxt'>我已阅读并接受报名须知</label>
				</div>
				<div class="warmTip">
					<span>【温馨提示】</span>短训类报名次数最多1次/年；讲座类报名次数最多6次/年
				</div>
			</div>
			
			<c:if test="${registerStatus=='open'}">
			<div type="button" class="submitS1 submitNone" data-action="false"
				onclick=" formSub();">
				<span>提交</span>
			</div>
			</c:if>
			<c:if test="${registerStatus=='close'}">
			<div type="button" class="submitS1 submitNone" data-action="false"
				onclick="alertForbbiden();">
				<span>提交</span>
			</div>
			</c:if>
			
		</form>
	</div>
	<script>
		$(".tabBtn").on('click', 'a', function() {
			var dataOption = $(this).attr('data-option');
			$(this).addClass('on').siblings('a').removeClass('on');
			if (dataOption == '3') {//第三次培训课程
				$("#vform").show();
				$("#classOne").html('');
			} else if(dataOption == '2'){//第一次培训课程
				$("#vform").hide();
				var links = '${path}/millionPeople/toOrder.do?type=2';
				changeClass(links)
			}else {//第一次培训课程
				$("#vform").hide();
				var links = '${path}/millionPeople/toOrder.do?type=1';
				changeClass(links)
			}
		})
		function changeClass(link) {
			var iframe = document.createElement("iframe");
			var iframe = '<iframe frameborder="0" id="mainweb" name="mainweb" scrolling="yes" width="750" height="100%"  src=""></iframe>';
			$("#classOne").html(iframe);
			var oIframe = document.getElementById("mainweb");
			oIframe.onload = oIframe.onreadystatechange = function() {
				iFrameHeight();
			}
			oIframe.src = link;

		}
		function iFrameHeight() {
			var ifm = document.getElementById("mainweb");
			var subWeb = document.frames ? document.frames["mainweb"].document
					: ifm.contentDocument;
			if (ifm != null && subWeb != null) {
				ifm.height = subWeb.body.scrollHeight + 380;
			}
		}
	</script>
</body>
</html>































































































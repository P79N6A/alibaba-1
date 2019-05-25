<%@ page language="java" pageEncoding="UTF-8"%>
<html>
<head>
<%@include file="/WEB-INF/why/common/frontPageFrame.jsp"%>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/style_fs.css" />	

	<style>
		.amap-logo,
		.amap-copyright {
			display: none!important;
			z-index: -1;
		}
	</style>
	
	<script type="text/javascript">
		
		function over(){
			 window.parent._SHFClose();
		}
	
	</script>
	
</head>


<body>
		<input type="hidden" id="userId" name="userId" value="${userId }"/>

		<div class="bookactivityroom" style="width: 500px;">
			<div class="submit" style="width: 500px;">
				<div class="submit_top">
					<h3>提交成功。请等待审核！</h3>
					<p>您的活动室预约信息已提交成功，我们将在3个工作日之内予以审核，</p>
					<p>请及时关注短信通知，谢谢！</p>
				</div>
				<div class="submit_bot">
					<h4>${roomName }</h4>
					<p>场&emsp;馆：${venueName }</p>
					<p>日&emsp;期：${date } ${openPeriod }</p>
					<p>使用人：${tuserName }</p>
					<p>联系人：${orderName } ${orderTel }</p>
				</div>
			</div>
			<div class="complete clearfix" style="padding-top: 20px;text-align: center;">
				<a href="javascript:;" style="width: 120px;margin: auto;" class="totalBtn" onclick="over();">确定</a>
			</div>
		</div>

</body>
</html>


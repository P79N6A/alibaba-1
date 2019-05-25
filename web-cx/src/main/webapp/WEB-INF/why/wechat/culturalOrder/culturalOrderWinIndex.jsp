<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

	<head>
		<title>文化点单</title>
		<%@include file="/WEB-INF/why/wechat/commonFrame.jsp" %>
		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css">
		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/fsStyle.css" />
		<script type="text/javascript">
		
		//跳转到详情页
        function toDetail(){
        	if (userId == null || userId == '') {
				 publicLogin('${basePath}wechatCulturalOrder/culturalCyOrderIndex.do');
	                return;
	            }else{
            window.location.href ='${path}/wechatCulturalOrder/culturalOrderDetail.do?culturalOrderId=${culturalOrderId}&culturalOrderLargeType=${culturalOrderLargeType}&userId='+userId;
        	}
		}
		 function toDetailInfo(info){
			 if (userId == null || userId == '') {
				 publicLogin('${basePath}wechatCulturalOrder/culturalCyOrderIndex.do');
	                return;
	            }else{
            window.location.href ='${path}/wechatCulturalOrder/culturalOrderDetail.do?culturalOrderId=${culturalOrderId}&culturalOrderLargeType='+info+'&userId='+userId;
        	}
		}
		 
		 //跳转机构认证
		 function toAuthTeamUser(){
			 if (userId == null || userId == '') {
				 publicLogin('${basePath}wechatCulturalOrder/culturalCyOrderIndex.do');
	                return;
	            }else{
            window.location.href ='${path}/wechatRoom/authTeamUser.do?userId='+userId+'&roomType=2';
        	}
		}
		</script>
	</head>

<body style="background-color: #f3f3f3;">
	<div class="fsMain">
	<c:if test="${culturalOrderLargeType == 1}"><p class="tipStatus">已报名</p><p class="tipsNext">请耐心等待确认！</p></c:if>
	<c:if test="${culturalOrderLargeType == 2}"><p class="tipStatus">已邀请</p><p class="tipsNext">请耐心等待确认！</p></c:if>
	<c:if test="${culturalOrderLargeType == 3}"><p class="tipStatus">该服务仅限机构用户邀请，请前往个人中心<br>完成机构认证后再进行邀请！</p></c:if>
	<c:if test="${culturalOrderLargeType == 4}"><p class="tipStatus">该服务报名名额已满，请前往活动详情<br>重新更换时段后再进行报名！</p></c:if>
		<div class="fsBtnWrap">
			<c:if test="${culturalOrderLargeType == 4}">
				<a href="#" class="fsBtn" onclick="toDetailInfo(1)">返回详情</a>
			</c:if>
			<c:if test="${culturalOrderLargeType == 1}">
				<a href="#" class="fsBtn" onclick="toDetail()">返回详情</a>
				<a href="${path}/wechatCulturalOrder/myCulturalOrderIndex.do" class="fsBtn" style="background-color: #e8a74c;">查看报名记录</a>
			</c:if>
			<c:if test="${culturalOrderLargeType == 2}">
				<a href="#" class="fsBtn" onclick="toDetail()">返回详情</a>
				<a href="${path}/wechatCulturalOrder/myCulturalOrderIndex.do?culturalOrderLargeType=2" class="fsBtn" style="background-color: #e8a74c;">查看邀请记录</a>
			</c:if>
			<c:if test="${culturalOrderLargeType == 3}">
				<a href="#" class="fsBtn" onclick="toDetailInfo(2)">返回详情</a>
				<a onclick="toAuthTeamUser()" class="fsBtn" style="background-color: #e8a74c;">机构认证</a>
			</c:if>
		</div>
	</div>
</body>

</html>
<%@ page language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <%@include file="/WEB-INF/why/common/limit.jsp" %>
	<meta charset="UTF-8">
	<c:if test="${cnwdEntryForm.checkStatus==1}">
	  <title>第三步</title>
	</c:if>
	<c:if test="${cnwdEntryForm.checkStatus==2}">
	  <title>恭喜你！</title>
	</c:if>
	<link rel="stylesheet" type="text/css" href="${path }/STATIC/css/cnwd/reset.css">
	<link rel="stylesheet" type="text/css" href="${path }/STATIC/css/cnwd/dance.css">
</head>
<body>
	<%@include file="/WEB-INF/why/index/cnwd/header.jsp"%>
	<p class="crumbs">我的位置：2017年舞蹈大赛</p>
	<c:if test="${cnwdEntryForm.checkStatus==1}">
		<ul class="steps">
			<li class="cur">填写团队基本信息</li>
			<hr class="hrone cur">
			<li class="cur">上传参赛视频</li>
			<hr class="hrtwo cur">       
			<li class="cur">提交成功</li>
		</ul>
	</c:if>
    <c:if test="${cnwdEntryForm.checkStatus==1}">
       <div class="content_wrap">
			<div class="content clear" style="padding-bottom: 107px;">
				<h1 class="success">提交成功，请耐心等待审核</h1>
				
				<p class="question questions">如有疑问，请致电：400-018-2346</p>
				
				<a href="${path }/cnwdEntry/registerOne.do?entryId=${entryId}&editStatus=1" class="btn btn_bgtwo fl">修改信息</a>
				<a href="javascript:void(0)" class="btn btn_bgone fl" onclick="getUrl();">退出登录</a>
			</div>
	   </div>
    </c:if>
    <c:if test="${cnwdEntryForm.checkStatus==2}">
       <div class="content_wrap">
			<div class="content clear">
				<h1>审核已通过，进入专家评审阶段</h1>
				<p>专家评审将于2017年6月2日至6月16日进行，请耐心等待结果</p>
				<p class="question">如有疑问，请致电：周老师、李老师</p>
				<p class="number">62421443、62421436</p>
				<!-- <a href="javascript:;" class="btn btn_bgtwo fl">修改信息</a> -->
				<a href="javascript:void(0);" class="btn btn_bgone fl" onclick="getUrl();"/>退出登录</a>
			</div>
	    </div>
    </c:if>
    <c:if test="${cnwdEntryForm.checkStatus==3}">
       <div class="content_wrap">
			<div class="content clear">
				<h1>审核未通过</h1>
				 <p>原因：${cnwdEntryForm.refusalReason}</p> 
				<p class="question">如有疑问，请致电：周老师、李老师</p>
				<p class="number">62421443、62421436</p>
				<a href="${path }/cnwdEntry/registerOne.do?entryId=${entryId}&editStatus=1" class="btn btn_bgtwo fl">修改信息</a>
				<a href="javascript:void(0);" class="btn btn_bgone fl" onclick="getUrl();"/>退出登录</a>
			</div>
	    </div>
    </c:if> 
	<%@include file="/WEB-INF/why/index/cnwd/footer.jsp"%>
</body>
</html>
<script>
function getUrl() {
    var url=getChinaServerUrl();
    return window.location.href=url+"cnwdFrontUser/login.do?type=${basePath}cnwdEntry/registerOne.do";
}
</script>
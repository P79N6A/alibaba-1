<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java" pageEncoding="UTF-8" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

	<head>
	<title>视频上传系统</title>
		 <%@include file="/WEB-INF/why/common/frontIndexPageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/aliImageFrame.jsp"%>
    
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture-index.css" />
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture-index-new.css" />
    
     <link rel="stylesheet" type="text/css" href="${path}/STATIC/dc/css/whyupload.css"/>
	</head>

	<body style="background-color: #ffffff;" ms-important="Login">

		<!-- 导入头部文件  无搜索按钮 -->

		<!--top start-->
		
		<!--top end-->
		<!--nav start-->
		<div class="hp_navbg">
			<div class="hp_nav clearfix">
				<div class="logo fl">
					<img alt="文化云" src="${path}/STATIC/image/baiduLogo.png" width="80" height="48" />
				</div>
				<ul class="fl">
					
				</ul>
				 <div class="fr">
					<ul class="fl">
			            <li data-url="frontIndex"><a href="#" onclick="logout();">退出</a></li>
			        </ul>
		   		 </div>
				<!--search start-->
				
				<script type="text/javascript">
				function logout(){
					 $.post("${path}/dcFront/logout.do",function(){
						 
						 window.location.href = '../dcFront/login.do';
					 });
				}
				</script>
			</div>
		</div>

		<!--上传登录-->

		<div class="whyuploadMain">
			<div class="whyUploadDiv">
				<p class="nowPlace">您所在的位置：视频上传成功</p>
				<div class="whyUserLogin">
					<p style="color: #e12c57;font-size: 30px;text-align: center;margin-top: 65px;">提交成功！</p>
					<p style="font-size: 18px;text-align: center;margin-top: 35px;color: #333;">第一轮海选将于<span id="" style="color: #e12c57;">2016年11月01日-11月07日</span>进行，</p>
					<p style="font-size: 18px;text-align: center;margin-top: 25px;color: #333;">您可以扫描二维码关注”文化云微信公众账号“，或者下载”文化云App“，</p>
					<p style="font-size: 18px;text-align: center;margin-top: 25px;color: #333;">于11月8日进入文化云，查看结果并进行拉票！</p>
					<img style="display: block;margin: 40px auto 0;" src="${path}/STATIC/dc/whyQR.jpg" />
					<p style="font-size: 14px;text-align: center;color: #333;">文化云微信公众账号</p>
					<div class="whySuccessBtn" onclick="javascript:window.location.href='../dcFront/dcVideoList.do'">完成</div>
				</div>
			</div>
		</div>

		
	</body>
<!-- 导入头部文件 -->
</html>
<%@ page language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
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
<title>万人培训-等待确认</title>
<meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">

<link rel="stylesheet" type="text/css" href="${path}/STATIC/train/weChat/css/mobiscroll.custom-2.4.4.min.css">
<link rel="stylesheet" type="text/css" href="${path}/STATIC/train/weChat/css/css.css">
<script type="text/javascript" src="${path}/STATIC/train/weChat/js/jquery-min.js"></script>
<script type="text/javascript" src="${path}/STATIC/train/weChat/js/common.js"></script>
<script type="text/javascript" src="${path}/STATIC/train/weChat/js/mobiscroll.custom-2.17.0.min.js"></script>
<!--移动端版本兼容 -->
<script type="text/javascript">
	var phoneWidth =  parseInt(window.screen.width);
	var phoneScale = phoneWidth/750;
	var ua = navigator.userAgent;            //浏览器类型
	if (/Android (\d+\.\d+)/.test(ua)){      //判断是否是安卓系统
		var version = parseFloat(RegExp.$1); //安卓系统的版本号
		if(version>2.3){
			document.write('<meta name="viewport" content="width=750, minimum-scale = '+phoneScale+', maximum-scale = '+phoneScale+', target-densitydpi=device-dpi">');
		}else{
			document.write('<meta name="viewport" content="width=750, target-densitydpi=device-dpi">');
		}
	} else {
		document.write('<meta name="viewport" content="width=750, user-scalable=no, target-densitydpi=device-dpi">');
	}
</script>
<!--移动端版本兼容 end -->
</head>
<body>
  <div class="header">
    <a href="javascript:history.go(-1);" class="pre"></a>
    <span>文化云 </span>
    <a class="center" href="${path}/millionPeople/queryCourseOrder.do">个人中心</a>
  </div>
  <div class="content contentS2">
     <div class="tilClass">
       <div class="boxT"><p><span>等待确认</span></p></div>
     </div>
     <div class="selCon">
       <div class="tilText">您已报名项目</div>
       <ul class="trains_select waitList borderRadiu5">
	 <c:forEach items="${courses}" var="course" varStatus="i">
         <li class="clearfix">
           <p>${course.courseTitle}</p>
         </li>
	</c:forEach>
       </ul>
      </div>
     <div class="waitTXT">等待确认中...</div>
  </div>   
</body>
</html>































































































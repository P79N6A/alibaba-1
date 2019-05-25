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
<title>万人培训-选择课程</title>
<meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">

<link rel="stylesheet" type="text/css" href="${path}/STATIC/train/weChat/css/mobiscroll.custom-2.4.4.min.css">
<link rel="stylesheet" type="text/css" href="${path}/STATIC/train/weChat/css/ui-dialog.css"/>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/train/weChat/css/css.css">
<script type="text/javascript" src="${path}/STATIC/train/weChat/js/jquery-min.js"></script>
<script type="text/javascript" src="${path}/STATIC/train/weChat/js/common.js"></script>
<script type="text/javascript" src="${path}/STATIC/train/weChat/js/mobiscroll.custom-2.17.0.min.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
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
<script>


	function formSub(){
		var i = 0;
		var j = 0;
		var open=$(".submitS1").attr("data-action");
		if(open=='false') return;
		$(".train_radio_even").each(function(index, element) {
	 		if($(this).hasClass("on")){
	 			i++;
	 			var v = $(this).find("input").val();
	 			$("#TI"+v).prop("disabled",false);
	 			$("#TY"+v).prop("disabled",false);
	 		}
		}); 
		
		$(".train_check_even").each(function(index, element) {
			if($(this).hasClass("on")){	
	 			j++;
	 			var v = $(this).find("input").val();
	 			$("#TI"+v).prop("disabled",false);
	 			$("#TY"+v).prop("disabled",false);
	 		}
			});
   			if(i+j==0){
				dialogAlert("提示", "请至少选择一个课程!");
				return;
			}
			if(j>6){
				dialogAlert("提示", "讲座类最多选择6项!");
				return;
			}

			$.post("${path}/millionPeople/saveCourseOrder.do", $("#vform").serialize(), function(data) {
                var map = eval(data);
                if (map.success=='Y') {
                    location.href="${path}/millionPeople/toOrderSucess.do?"+$("#vform").serialize();
                } else {
                    dialogAlert("提示",map.msg,function(){
                    	location.href="${path}/millionPeople/toOrder.do";
                    });
                }
            });
}
</script>
<!--移动端版本兼容 end -->
<style>
 #vform{ width:700px; margin:0 auto;}
</style>
</head>
<body>
  <div>
     <form id="vform" action="">
      <input type="hidden" name="userId" value="${user.userId}" class="rp_noinput"/>
     <div>
       <div class="tilText">三天短训类 <span></span></div>
       <ul class="trains_select borderRadiu5">
        <c:forEach items="${shortCourses}" var="course" varStatus="i">
          <input id="TI${course.courseId}" type="hidden" disabled="disabled" name="courseTitle" value="${course.courseTitle}" class="rp_noinput"/>
          <input id="TY${course.courseId}" type="hidden" disabled="disabled" name="courseType" value="${course.courseType}" class="rp_noinput"/>
         <li class="clearfix">
           <div class="selTop clearfix" <c:if test="${i.index==0}">width="26"</c:if>>
           <c:if test="${(not empty course.orderNum and course.peopleNumber<=course.orderNum) or fn:indexOf(course.courseField, trainUser.engagedField)==-1}">
               <div class="train_radio notselect"></div>
               </c:if>
                <c:if test="${(empty course.orderNum or course.peopleNumber>course.orderNum) and fn:indexOf(course.courseField, trainUser.engagedField)!=-1}">
               <div class="train_radio notselect"></div>
               </c:if>
               <label for='${course.courseId}' class="topic">${course.courseTitle }</label>
               <span class="detailS"></span>
           </div>
           <div class="info">
             <div class="infoInner">
                <h2>【培训时间】</h2>
                <p>${course.courseStartTime} 至  ${course.courseEndTime} &nbsp;&nbsp;${course.trainTime}</p>
                <c:if test="${not empty course.coursePhoneNum}"><h2>【联系方式】</h2><p>${course.coursePhoneNum}</p></c:if>
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
       <div class="tilText">讲座类 <span></span></div>
       <ul class="trains_select borderRadiu5">
       <c:forEach items="${lectureCourses}" var="course" varStatus="i">
        <input id="TI${course.courseId}" type="hidden" name="courseTitle" disabled="disabled" value="${course.courseTitle}" class="rp_noinput"/>
        <input id="TY${course.courseId}" type="hidden" name="courseType"  disabled="disabled" value="${course.courseType}" class="rp_noinput"/>
         <li class="clearfix">
           <div class="selTop clearfix"> 
               <c:if test="${(not empty course.orderNum and course.peopleNumber<=course.orderNum) or fn:indexOf(course.courseField, trainUser.engagedField)==-1}">
              <div class="train_check notselect"></div>
               </c:if>
				<c:if test="${(empty course.orderNum or course.peopleNumber>course.orderNum) and fn:indexOf(course.courseField, trainUser.engagedField)!=-1}">
              <div class="train_check notselect"></div>
                </c:if>
               <label for='${course.courseId}' class="topic">${course.courseTitle}</label>
               <span class="detailS"></span>
            </div>
            <div class="info">
             <div class="infoInner">
                <h2>【培训时间】</h2>
                <p>${course.courseStartTime} 至  ${course.courseEndTime} &nbsp;&nbsp;${course.trainTime}</p>
                 <c:if test="${not empty course.coursePhoneNum}"><p><h2>【联系方式】</h2><p>${course.coursePhoneNum}</p></c:if>
                <h2>【培训地点】</h2>
                <p>${course.trainAddress}</p>
                <h2>【目标学员】</h2>
                <p>${course.targetAudienc}</p> 
                <h2>【师资简介】</h2>
                <p>${course.teacherIntro}</p>
                 <h2>【课程简介】</h2>
                <p> ${course.courseDescription}</p>
              </div>
           </div>
         </li>
         </c:forEach>
       </ul>
     </div>

  </div>  
  <script>
    $(".tabBtn").on('click','a',function(){
    	 var dataOption=$(this).attr('data-option');
    	 $(this).addClass('on').siblings('a').removeClass('on');
    	 if(dataOption=='1'){//第一次培训课程
    		 $("#vform").show();
    	     $("#classOne").html('');
    	 }else{//第二次培训课程
    		 alert(2222);
    		 $("#vform").hide();
    		 var links='${path}/millionPeople/toOrder.do?type';
    		 changeClass(links)
    	 }
    })   
            function changeClass(link){
		    	 var iframe = document.createElement("iframe");
				 var iframe='<iframe frameborder="0" id="mainweb" name="mainweb" scrolling="no" width="700" height="100%"  src=""></iframe>';
				 $("#classOne").html(iframe);
				 var oIframe = document.getElementById("mainweb");
			     oIframe.onload = oIframe.onreadystatechange =function(){ 
			    	iFrameHeight();
					}
			     oIframe.src = link;
   	
             }
   	      function iFrameHeight() {
    	    	 var ifm= document.getElementById("mainweb");
    	    	 var subWeb = document.frames ? document.frames["mainweb"].document : ifm.contentDocument;
    	    	 if(ifm != null && subWeb != null) {
    	    	   ifm.height = subWeb.body.scrollHeight;
    	    	 }
   	    	 }
  </script>
</body>
</html>































































































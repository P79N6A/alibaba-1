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
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title>选择课程</title>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/train/css/reset-index.css"/>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/train/css/culture.css"/>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/train/css/trains.css"/>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/ui-dialog.css"/>
<style>
     .book-notes .book_inner {
	  overflow-y: auto;
	  max-height: 312px;
	}
	
	.register-content  #btn-tip-loading{ float:left;margin-left:30px; background:url('${path}/STATIC/train/image/register-icongray.png') no-repeat center center; border-radius:5px; -webkit-border-radius:5px;-moz-border-radius:5px;}
	#btn-tip-loading h3{ color:#ffffff;}
	#submit_second{ width:680px; height:44px; margin:0 auto;}
	#submit_second input{float:left;}
</style>
<script type="text/javascript" src="${path}/STATIC/train/js/jquery.min.js"></script>
<script type="text/javascript" src="${path}/STATIC/train/js/train_index.js"></script>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/train/js/scroll_mouse/scroll_com.css"/>
<script type="text/javascript" src="${path}/STATIC/train/js/scroll_mouse/scroll_common.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
<script type="text/javascript">
$(function(){
  siteDecribe();
  //标题内容介绍文字
  function siteDecribe(){
   $("body").find(".topic").hover(function(){
      var w=$(this).width();
	  var left=$(this).offset().left+parseInt(w)+21;
	  var top=$(this).offset().top-6;
	  var maxHeight=325;
	  var context=$(this).find(".class_intro"); 
	  if(context){
	      context.css({"left":left,"top":top});
	      if(context.is(":visible")){
				  context.hide();
				     context.find(".content_mid").css("margin-top","0");
					 context.find(".scroll_btn").css("top","0");
				 }else{
					context.show(); 
					if(context.hasClass("scroll_block")){
						var hh=context.find(".content_mid").height();
						var par_h=context.outerHeight();
						if(hh>maxHeight){
							context.css("height",maxHeight+"px");
							ss(context,"v",false); 
						  }
					}
				 }
	  }
   })
  }
   //单选按钮 
    $(".train_radio_even").each(function(index, element) {
		 var parents=$(this).parents(".trains_select");
         $(this).click(function(){
			         parents.find("input").prop("checked",false);
					 parents.find(".train_radio").removeClass("on");
					 $(this).addClass("on");
					 $(this).find("input").prop("checked",true);
			 })
    });   
   //多选按钮
   $(".train_check_even").each(function(index, element) {
		 var parents=$(this).parents(".trains_select");
         $(this).click(function(){
			  if($(this).hasClass("on")){
				    $(this).removeClass("on");
					$(this).find("input").prop("checked",false);
					var v = $(this).find("input").val();
		 			$("#TI"+v).prop("disabled",true);
		 			$("#TY"+v).prop("disabled",true);
				  }else{
					 $(this).addClass("on");
					 $(this).find("input").prop("checked",true);
					  }
			 
			 })
    });  
   
     
})


	
	function acceptItem(){
    if($("#agreement").prop("checked")){
        $("#subOrder").removeAttr("style");
        $("#subOrder").prop('disabled',false);
    }else{
        $("#subOrder").css("background","url('${path}/STATIC/train/image/register-icongray.png') no-repeat center center");
        $("#subOrder").prop('disabled',true);
    }
}
</script>
</head>
<body>
    <!--con start-->
    <div id="register-content">
    <div>
         <div id="classOne"></div>
        <form id="vform" action="">
        <input type="hidden" name="userId" value="${user.userId}" class="rp_noinput"/>
        <div class="room-part1 room-part2">
            <div class="trians_block">
              <div class="trains_title">
                 三天短训类<span>（最多选择1项）</span>
              </div>
              <div class="train_sel_con">
                  <table class="trains_select" width="100%" style="margin-top: 0;">
                    <tbody>
                    <c:forEach items="${shortCourses}" var="course" varStatus="i">
                    <input id="TI${course.courseId}" type="hidden" name="courseTitle" disabled="disabled" value="${course.courseTitle}" class="rp_noinput"/>
                    <input id="TY${course.courseId}" type="hidden" name="courseType"  disabled="disabled" value="${course.courseType}" class="rp_noinput"/>
                     <tr>
                        <td <c:if test="${i.index==0}">width="26"</c:if> >
                        	<c:if test="${(not empty course.orderNum and course.peopleNumber<=course.orderNum) or fn:indexOf(course.courseField, trainUser.engagedField)==-1}">
                        		<div></div>
                        	</c:if>
                           <c:if test="${(empty course.orderNum or course.peopleNumber>course.orderNum) and fn:indexOf(course.courseField, trainUser.engagedField)!=-1}">
                        		<div></div>
                        	</c:if>
                        </td>
                        <td>
                          <label for="${course.courseId}" class="topic">${course.courseTitle }
                          <div class="class_intro scroll_block">
                            <div class="content">
                                 <img src="${path}/STATIC/train/image/triangle.png" class="triangle" />
                                 <div class="class_intro_inner content_mid">
                                 	<p><span>【培训时间】:</span>${course.courseStartTime} 至  ${course.courseEndTime} &nbsp;&nbsp;${course.trainTime}</p>
                                 	<c:if test="${not empty course.coursePhoneNum}"><p><span>【联系方式】:</span>${course.coursePhoneNum}</p></c:if>
                                 	<p><span>【培训地点】:</span>${course.trainAddress}</p>
                                 	<p><span>【目标学员】:</span>${course.targetAudienc}</p>
                                 	<p><span>【师资简介】:</span>${course.teacherIntro}</p>
                                    <p><span>【课程简介】:</span>${course.courseDescription}</p>
                                 </div>
                             </div>
                          </div>
                          </label> 
                        </td>
                    </tr>
                    </c:forEach>
                   </tbody>
                  </table>
                </div>
            </div>
            <div class="trians_block">
              <div class="trains_title">
                 讲座类<span>（最多选择6项）</span>
              </div>
              <div class="train_sel_con">
                  <table class="trains_select" width="100%" style="margin-top: 0;">
                    <tbody>
                    <c:forEach items="${lectureCourses}" var="course" varStatus="i">
                    <input id="TI${course.courseId}" type="hidden" disabled="disabled" name="courseTitle" value="${course.courseTitle}" class="rp_noinput"/>
                    <input id="TY${course.courseId}" type="hidden" disabled="disabled" name="courseType" value="${course.courseType}" class="rp_noinput"/>
                     <tr>
                        <td <c:if test="${i.index==0}">width="26"</c:if> >
                        	<c:if test="${(not empty course.orderNum and course.peopleNumber<=course.orderNum) or fn:indexOf(course.courseField, trainUser.engagedField)==-1}">
                        		<div></div>
                        	</c:if>
                        	<c:if test="${(empty course.orderNum or course.peopleNumber>course.orderNum) and fn:indexOf(course.courseField, trainUser.engagedField)!=-1}">
                        		<div></div>
                        	</c:if>
                        </td>
                        <%-- <div class="train_check notallow"><input type="checkbox" id="checkbox1" disabled   name="courseId" value="${course.courseId}" /></div> --%>
                        <td>
                          <label for="${course.courseId}" class="topic">${course.courseTitle}
                            <div class="class_intro scroll_block">
                              <div class="content">
                                 <img src="${path}/STATIC/train/image/triangle.png" class="triangle" />
                                 <div class="class_intro_inner content_mid">
                                    <p><span>【培训时间】:</span>${course.courseStartTime} 至  ${course.courseEndTime} &nbsp;&nbsp;${course.trainTime}</p>
                                    <c:if test="${not empty course.coursePhoneNum}"><p><span>【联系方式】:</span>${course.coursePhoneNum}</p></c:if>
                                 	<p><span>【培训地点】:</span>${course.trainAddress}</p>
                                 	<p><span>【目标学员】:</span>${course.targetAudienc}</p>
                                 	<p><span>【师资简介】:</span>${course.teacherIntro}</p>
                                    <p><span>【课程简介】:</span>${course.courseDescription}</p>
                                </div>
                            </div>
                          </div>
                          </label> 
                        </td>
                    </tr>
                    </c:forEach>
                   </tbody>
                  </table>
                </div>
            </div>
            <div>
          <div class="book_inner">
          </div>
        </div>
        </div>
        <div class="book-agreement">
        </div>
        <div class="book-control train-control" id="submit_second">
        </div>
        </form>
    </div>
</div>
    <!--con end-->
<%@include file="../index/index_foot.jsp"%>
<script>
//执行下拉列表
selectModel();
</script>
<script>
$(".tabBtn").on('click','a',function(){
	 var dataOption=$(this).attr('data-option');
	 $(this).addClass('on').siblings('a').removeClass('on');
	 if(dataOption=='1'){//第二次培训课程
		 $("#vform").show();
	     $("#classOne").html('');
	 }else{//第一次培训课程
		 $("#vform").hide();
		 var links='${path}/train/toBookTrain.do?type';
		 changeClass(links)
	 }
})   
       function changeClass(link){
	    	 var iframe = document.createElement("iframe");
			 var iframe='<iframe frameborder="0" id="mainweb" name="mainweb" scrolling="no" width="880" height="100%"  src=""></iframe>';
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

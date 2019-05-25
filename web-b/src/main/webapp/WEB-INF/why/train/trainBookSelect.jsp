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

	function formSub(){
		var i = 0;
		var j = 0;
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
			//提交等待 
    		var html = '<div class="btn-submit btn-loading" id="btn-tip-loading"><h3>正在提交，请稍等...</h3><div class="img"></div></div>';
            $(".btn-submit").parent().append(html);
            $("#subOrder").hide();
        /*     setTimeout(function(){
               $("#subOrder").show();
               $("#btn-tip-loading").remove();
            },1000) */
             //
			$.post("${path}/train/saveCourseOrder.do", $("#vform").serialize(), function(data) {
                var map = eval(data);
                if (map.success=='Y') {
                    $("#btn-tip-loading").remove();
                    $("#subOrder").show();
                    location.href="${path}/train/toOrderSucess.do?"+$("#vform").serialize();
                } else {
                    dialogAlert("提示",map.msg,function(){
                    	$("#btn-tip-loading").remove();
                    	$("#subOrder").show();
                    	location.href="${path}/train/toOrder.do";
                    });
                }
            });
            
			
	}
	
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
<%@include file="../index/index_top.jsp"%>
    <!--con start-->
    <div id="register-content">
    <div class="register-content">
        <div class="steps steps-room">
            <ul class="clearfix">
                <li class="step_1 visited_pre">1.填写个人信息<i class="tab_status"></i></li>
                <li class="step_2 active">2.选择课程<i class="tab_status"></i></li>
                <!-- <li class="step_3">3.等待确认<i class="tab_status"></i></li> -->
                <li class="step_4">3.等待确认</li> 
            </ul>
        </div>
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
                        		<div class="train_radio notallow"><input type="radio" id="${course.courseId}"  disabled value="${course.courseId}" name="courseId"/></div>
                        	</c:if>
                           <c:if test="${(empty course.orderNum or course.peopleNumber>course.orderNum) and fn:indexOf(course.courseField, trainUser.engagedField)!=-1}">
                        		<div class="train_radio train_radio_even"><input type="radio" id="${course.courseId}"  value="${course.courseId}" name="courseId"/></div>
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
                        		<div class="train_check notallow"><input type="checkbox" id="${course.courseId}"  disabled name="courseId" value="${course.courseId}" /></div>
                        	</c:if>
                        	<c:if test="${(empty course.orderNum or course.peopleNumber>course.orderNum) and fn:indexOf(course.courseField, trainUser.engagedField)!=-1}">
                        		<div class="train_check train_check_even"><input type="checkbox" id="${course.courseId}" name="courseId" value="${course.courseId}" /></div>
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
            <div class="book-notes">
          <div class="book_inner">
            <div class="notes-content">
              <h3 class="caption">报名须知</h3>
              <!-- <h4 class="notes-title">使用说明：</h4> -->
              <p>各位学员，为有效做好2016-2018年度上海市公共文化从业人员万人培训选课报名的服务工作，请仔细阅读以下内容：</p>
              <p>1.2016年万人培训共分3次报名及培训。首次报名于3月26日上午9:00正式启动，培训时间为4月至6月。第二次和第三次选课定于2016年6月和9月，具体时间请以书面通知为准。</p>
              <p>2.每名学员的身份证号每年最多可选3天短训班1次和专题讲座6场。</p>
              <p>3.每门课程均有报名限额，报满即止。如本次报名未成功，可在第二次和第三次报名期间继续参加选课。</p>
              <p>4.报名是否成功，请以短信确认为准。</p>
              <p>5.报名成功后，如因故无法参加，学员须事先自行取消报名。</p>
              <p>6.开课前3日，系统将冻结取消按钮。学员如因故无法参加，请与所在单位调剂其他人员参加课程，不得无故缺席。累计两次报名成功但未参加培训的学员，注册信息将列入系统黑名单。</p>
              <p>7.所有培训院校均不提供停车位，请学员尽量乘坐公共交通前往。</p>
              <p style="margin-left:585px;font-size:16px;">上海市文化广播影视管理局</p>
            </div>
          </div>
        </div>
        </div>
        <div class="book-agreement">
        <input type="checkbox" id="agreement"  onclick="acceptItem()" />
        <label for="agreement">我已阅读并接受<a>报名须知</a><!-- <a style="text-decoration: underline;">服务条款</a> --></label>
        </div>
        <div class="warm_tip"><span>温馨提示：</span>短训类报名次数最多1次/年；讲座类报名次数最多6次/年</div>
        <div class="book-control train-control" id="submit_second">
            <input type="button"  value="上一步" class="btn-submit book-submit book_return" onclick="location.href='${path}/train/toBookTrain.do'">
            <input id="subOrder" type="button"  value="提交" class="btn-submit book-submit"  disabled onclick="formSub();" style="background:url('${path}/STATIC/train/image/register-icongray.png') no-repeat center center">
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
</body>
</html>

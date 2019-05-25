<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title>文化云--短信提醒</title>
  <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
<style>
  .container_mess{ width:516px; margin:0 auto; font-size:14px; color:#9b9b9b;}
  .add_buttons{text-align:center; width:240px; margin:0 auto; padding:32px 0 60px 0;}
  .sendContext{ width:380px; margin:0 auto; position:relative; }
  .add_buttons button{ display:inline-block; border:none; font-size:16px; color:#ffffff; border-radius:3px; -moz-border-radius:3px; -webkit-border-radius:3px; background:#f03330; width:100px; height:40px; line-height:40px; margin:0 10px; display:inline; float:left; cursor:pointer; }
  .add_buttons button.blue{ background:#117dff;}
  .sendContext span{color: #f58636;display:block; line-height:40px; }
  .sendContext textarea{ width:100%; resize:none; display:block; border:1px solid #adb5c4; line-height:24px; height:140px; padding:10px; color:#9b9b9b; font-size:12px;border-radius:3px; -moz-border-radius:3px; -webkit-border-radius:3px;}
</style>
<script type="text/javascript" src="${path}/STATIC/js/jquery.min.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
</head>

<body>
  <div class="container_mess">
    <div width="100%" class="sendContext">
          <span>短信提醒:</span>
          <textarea  disable>友情提醒，您所报的【${course.courseTitle}】课程，培训时间：${course.courseStartTime}至${course.courseEndTime}${course.trainTime}，培训地点：${course.trainAddress},<c:if test="${not empty course.coursePhoneNum }">联系方式：${course.coursePhoneNum},</c:if>请准时参加。</textarea>
    </div>
    <div class="add_buttons">
      <button class="blue btn-cancel">取消发送</button>
      <button class="btn-save">确认发送</button>
    </div>
  </div>
</body>
   <script type="text/javascript">
	
   function dialogTypeSaveDraft(title, content, fn){
		var d = parent.dialog({
			width:400,
			title:title,
			content:content,
			fixed: true,
			okValue: '确 定',
			ok: function () {
				if(fn)  fn();
			}
		});
		d.showModal();
	}
	
	seajs.config({
		alias: {
			"jquery": "jquery-1.10.2.js"
		}
	});
	seajs.use(['/why/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
		window.dialog = dialog;
	});

	window.console = window.console || {log:function () {}}
	seajs.use(['jquery'], function ($) {
		$(function () {
			var dialog = parent.dialog.get(window);
			/*点击确定按钮*/
			$(".btn-save").on("click", function(){
                 var orderId ="${orderId}";
                 var type ="${type}";
                 var state ="${state}";   
				$.post("${path}/peopleTrain/sendMessage.do",
				{
					orderId:orderId,
					type:type,
					state:state
				}, function(datas) {
					var map = eval(datas);
					if (map.sucess=='Y') {
						dialogTypeSaveDraft("提示","短信群发成功",function(){
							dialog.close().remove();
						});
					}else{
						dialogTypeSaveDraft("提示","短信群发失败",function(){
//							location.href="${path}/peopleTrain/addCourseUser.do?courseId="+map.courseId;
							dialog.close().remove();
						});
						
					}

				});
			});
			/*点击取消按钮，关闭登录框*/
			$(".btn-cancel").on("click", function(){
				dialog.close().remove();
			});
		});
	});
</script>
   </script>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	request.setAttribute("path", path);
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>添加报名人</title>

<style>
  .container_add{ width:516px; margin:0 auto;}
  .add_buttons{text-align:center; width:240px; margin:0 auto; padding:32px 0 60px 0;}
  .add_tables{ width:100%; font-size:12px;}
  .add_tables tr td{ color:#9b9b9b;}
  .add_tables tr td span{ display:block; text-align:right; padding-right:18px; width:133px;}
  .add_tables tr td  input{ border:1px solid #ffffff; line-height:32px; height:32px; margin:9px 0;font-size:12px;  color:#9b9b9b; padding:0 10px; width:246px;}
  .add_buttons button{ display:inline-block; border:none; font-size:16px; color:#ffffff; border-radius:3px; -moz-border-radius:3px; -webkit-border-radius:3px; background:#f03330; width:100px; height:40px; line-height:40px; margin:0 10px; display:inline; float:left; cursor:pointer; }
  .add_buttons button.blue{ background:#117dff;}
  .account_message{ height:42px; padding:36px 0 16px 76px;}
  .account_message input{ float:left;width:234px; height:40px; line-height:40px; border:1px solid #adb5c4; padding:0 13px; color:#9b9b9b; font-size:12px;border-radius:3px; -moz-border-radius:3px; -webkit-border-radius:3px;background: url("${path}/STATIC/image/input-icon1.gif") repeat-x; }
  .account_message .matchButton { width:91px; height:32px; margin-left:10px; margin-top:3px; border:1px solid #adb5c4;border-radius:3px; -moz-border-radius:3px; display:block; -webkit-border-radius:3px;color:#9b9b9b; font-size:12px; cursor:pointer; float:left; display:inline; line-height:32px; text-align:center; background:#f5f5f5 url(images/zaddbg2.jpg) repeat-x 0 0;  } 
</style>
<script type="text/javascript" src="${path}/STATIC/js/jquery.min.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
<script>

	
	$(function(){
	//文本
	$(".input_style").focus(function(){
		var txt_val=$(this).val();
		if(txt_val==this.defaultValue){
			   $(this).val("");
			}
		})
    $(".input_style").blur(function(){
		 var txt_val=$(this).val();
		if(txt_val==""){
			   $(this).val(this.defaultValue);
			}
		})
		$(".matchButton").on("click", function(){
		 var searchKey=$("#searchKey").val();
		 if(searchKey=="手机号/身份证号"){
		 searchKey="";
		 }
		 	$.post("${path}/peopleTrain/userDetails.do",{searchKey:searchKey}, function(data) {
           if(data != null && data!=""){
              if(data.userSex==1){
	                         $("#userSex").val("男");
	                         }else if(data.userSex==2){
	                           $("#userSex").val("女");
	                         }
	                        $("#userMobileNo").val(data.userMobileNo);
	                        $("#idNumber").val(data.idNumber);
	                        $("#userId").val(data.userId);
        }else{
        	dialogTypeSaveDraft("提示","用户不存在",function(){
    
			});
        }
      });
	
			});
		
})

</script>
</head>

<body>
  <div class="container_add">
    <div class="account_message">
       <input type="text" class="input_style"  placeholder="手机号/身份证号" id="searchKey" />
       <span class="matchButton">匹配信息</span>
    </div> 
    <table width="100%" class="add_tables" border="0" cellspacing="0" cellpadding="0">
    <input type="hidden"  value="" id="userId"/>
          <tr>
            <td width="152"><span>课程名称：</span></td>
            <td><input type="text" readonly value="${course.courseTitle}"/></td>
          </tr>
          <tr>
            <td><span>性别 ：</span></td>
            <td><input type="text" readonly value="" id="userSex"/></td>
          </tr>
          <tr>
            <td><span>手机号码：</span></td>
            <td><input type="text" readonly  value="" id="userMobileNo"/></td>
          </tr>
          <tr>
            <td><span>身份证号码：</span></td>
            <td><input type="text" readonly value="" id="idNumber"/></td>
          </tr>
        </table>
        <div class="add_buttons">
          <button class="blue btn-cancel">取消</button>
          <button class="btn-save">保存</button>
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
                 var courseId ="${course.courseId}";
                 var userId =$("#userId").val();
                 if(courseId==""||courseId==null){
                	 dialogTypeSaveDraft("提示","课程不能为空")
                	 return;
                 }else if(userId=="" || userId==null){
                	 dialogTypeSaveDraft("提示","用户不能为空")
                	 return;
                 }
				$.post("${path}/peopleTrain/saveCourseUser.do",
				{
				courseId:courseId,
				userId:userId
				}, function(datas) {
					var map = eval(datas);
					if (map.success=='Y') {
						dialogTypeSaveDraft("提示","保存成功",function(){
							parent.location.href="${path}/peopleTrain/courseView.do?courseId="+map.courseId;
							dialog.close().remove();
						});
					}else{
						dialogTypeSaveDraft("提示",map.msg,function(){
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
</html>

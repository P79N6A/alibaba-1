<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>添加评论</title>
<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
<%@include file="/WEB-INF/why/common/aliImageFrame.jsp"%>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>
<script type="text/javascript" src="${path}/STATIC/js/common.js"></script>

<script type="text/javascript">
</script>
<style type="text/css">
			html,body {height: 100%;}
			.twzbMain {min-height: 100%;background-color: #eee;}
			.whyUploadVedio {padding: 0 20px;}
			div[name = aliFile]{margin-left: 10px;margin-bottom: 15px; float: left;height: 130px;width: 130px;position: relative;}
			div[name = aliFile] span,div[name = aliFile] b,div[name = aliFile] .progress{display: none;}
		</style>

</head>
<body>
		<div class="twzbMain">
		<form id="form" >
			<input type="hidden" id="tab" value="${tab }"/>
			<input type="hidden" id="template" value="${template }"/>
			<input type="hidden" name="messageActivity" id="messageActivity" value="${liveActivityId }"/>
		 <input type="hidden" name="messageCreateUser" value="" id="messageCreateUser"/>
		 <input type="hidden" name="messageIsInteraction" value="1"/>
		 <input type="hidden" name="messageIsRecommend" value="0"/>
			<textarea id="messageContent" name="messageContent" class="pinglunArea" placeholder="请留下您的评论"></textarea>
			<div class="whyUploadVedio" id="webupload1">
				<div style="" class="clearfix">
					<div id="container2" style="float: left;overflow: hidden;">
						<img src="${path}/STATIC/wechat/image/add-comment.png" id="selectfiles2" style="display: block;width: 130px;height: 130px;" />
					</div>
					<div id="ossfile2" style="width: 580px;float: left;" class="clearfix"></div>
				</div>
			</div>
			<div class="commSub">
				<input id="submitBtn" type="button" value="提交">
			</div>
			</form>
		</div>
		
	</body>
	<script type="text/javascript">
		
		$("#submitBtn").click(function(){
			
			var messageActivity=$("#messageActivity").val();
			var tab=$("#tab").val();
			var template=$("#template").val();
			
			if (userId == null || userId == '') {
				//判断登陆
		    	publicLogin('${basePath}wechatLive/addComment.do?liveActivityId='+messageActivity+"&tab="+tab+"&template="+template);
			}
			else{
				$("#messageCreateUser").val(userId)
			}
			
			var messageContent=$("#messageContent").val();
			
			if(!messageContent){
				 dialogAlert('提示', "请填写评论！");
				 
				 return false;
			}
				
			 $.post("${path}/wechatLive/createMessage.do", $("#form").serialize(), function(data) {
                
				 if (data.status == 1) {
					 
					 var integralChange=data.integralChange;
					 
					 window.location.href='${basePath}wechatLive/liveActivity.do?liveActivityId='+messageActivity+"&tab="+tab+"&integralChange="+integralChange+"&template="+template;
				 }
				 else{
					 dialogAlert('提示', "保存失败,系统异常！");
				 }
				 
			 },"json");
		})

		function testalert(up, file, info) {
			var aliImgUrl = "${aliImgUrl}" + info

			$("#" + file.id).append(
				'<input type="hidden" id="messageImg" name="messageImg" value="' + aliImgUrl + '"/>')
		}
		window.onload = function() {
			aliUploadImg('webupload1', testalert, 9, true, 'H5')
		}
	</script>
</html>
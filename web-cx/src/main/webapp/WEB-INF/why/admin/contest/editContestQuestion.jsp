<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@include file="/WEB-INF/why/common/limit.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<title>编辑试题</title>
  		<%@include file="../../common/pageFrame.jsp"%>

		<!--图片上传webupoader-->
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/webuploader.css"/>
	<script type="text/javascript" src="${path}/STATIC/wechat/js/webuploader/webuploader.min.js"></script>

	
		<style>
			.uploader-list {
				min-height: 242px;
				/*width: 960px;*/
			}
			
			.uploader-list>.file-item {
				float: left;
				margin-right: 40px;
				position: relative;
			}
			
			.w30 {
				width: 30px;
			}
			
			.margin-left10 {
				margin-left: 10px;
			}
			
			#addleave {
				cursor: pointer;
			}
			
			.removeleave {
				cursor: pointer;
			}
			
			.img-font {
				display: block;
				height: 20px;
				line-height: 20px;
				padding: 10px;
				margin: 5px auto 0px auto;
				border: solid 1px #ACB4C3;
				color: #596887;
				border-radius: 4px;
				-webkit-border-radius: 4px;
				-moz-border-radius: 4px;
			}
			
			.img-checkbox {
				position: absolute;
				height: 20px;
				width: 15px;
				right: 0px;
				bottom: 10px;
				padding: 10px;
				color: #596887;
				border-radius: 4px;
				-webkit-border-radius: 4px;
				-moz-border-radius: 4px;
			}
			
			.img-remove {
				position: absolute;
				right: 10px;
				top: 10px;
				background: url(../STATIC/image/deletePic.png) no-repeat center center;
				width: 30px;
				height: 30px;
			}
		</style>
		<script>
		
			var uploader ;
			var fileNumLimit=8;
			
			$(function() {
				$("#addleave").click(function() {
					addleaveList()
				})
				
				
				$("img").each(function(i){
					
					var img=$(this).attr("img");
					
					var url=getIndexImgUrl(getImgUrl(img),"_750_500");
					
					this.src=url;
				});
				
				
			})
			
			function save(){
				
				var c=check();
				
	        	if(c)
	        	{
	        		var topicId=$("#topicId").val();
	        		
	        		var data=$("#questionForm").serializeArray();
	        		
	        		var result = [];
	        		
	        		$("input[type='checkbox']").each(function(){
	        		    var num = this.checked ? 1 : 2;
	        		    result.push(num);
	        		});
	        		
	        		var isTrueCheck=result.join();
	        		
	        		data.push({'name':'isTrueCheck','value':isTrueCheck});
	        		
	        		$.post("${path}/contestTopicQuestion/addContestQuestion.do",data,function(result) {
	        			   
	        			if(result=='user')
	        			{
	        				alert("请先登录！")
	        				window.location.href = "${path}/login.do";
	        			}
	        			else if(result=='success')
	        			{ 
	        				alert("编辑成功！")
	        				window.location.href = "${path}/contestTopicQuestion/managerTopicQuestion.do?topicId="+topicId;
	        			}
	        			else
	        				alert("编辑失败，系统错误！")
	        		});
	        	}
			}
			
			
			function check(){

				if (questionTitle == undefined || $.trim(questionTitle) == "") {
					removeMsg("questionTitleLable");
					appendMsg("questionTitleLable", "请输入题目文案!");
					$("#questionTitle").focus();
					return false;
				} else
					removeMsg("questionTitleLable");
				
				var result=true;
				
				$("input[name$='answerText']").each(function(){
					if($(this).val() == undefined || $.trim($(this).val()) == ""){
						removeMsg("questionAnswerLable");
						appendMsg("questionAnswerLable", "请输入选项文字!");
						result=false;
						return false;
					}else
						removeMsg("questionAnswerLable");
				})
				
				if(result)
				{
					var uploaderList = $(".uploader-list img").length
						if($("input[type='checkbox']:checked").length < 1){
							removeMsg("questionAnswerLable");
							appendMsg("questionAnswerLable", "至少有一个正确答案被勾选！");
							return false;
						} else
							removeMsg("questionAnswerLable");
				}else
					return false;
				
				return true;
			}
		</script>

	</head>

	<body>
	<form method="post" id="questionForm">
	<input type="hidden" id="topicId" name="topicId" value="${topicId }"/>
	 <input type="hidden" id="questionId" name="questionId" value="${question.questionId }"/>
		<input type="hidden" id="userCounty" value="${sessionScope.user.userCounty}" />
		<div class="site">
			 <em>您现在所在的位置：</em>运维管理 &gt; 知识问答&gt;试题列表&gt;编辑试题
		</div>
		<div class="site-title">新建主题页</div>
		
			<div class="main-publish">
				<table width="100%" class="form-table">
					<tr>
						<td width="100" class="td-title"><span class="red">*</span>题目文案：</td>
						<td class="td-input" id="roomNameLabel">
							<input id="questionTitle" name="questionTitle" type="text" class="input-text w510" value='${question.questionTitle }' />
							<span class="error-msg"></span>
						</td>
					</tr>
					<!--用来存放item-->
					<tr>
						<td width="100" class="td-title"><span class="red">*</span>上传答案：</td>
						<td id="questionAnswerLable">
							<div >
								<div id="filePicker">选择图片</div>
								<div id="fileList" class="uploader-list">
									<c:forEach items="${answers }" var="answer" varStatus="varSta">
									
									<div id="WU_FILE_${answer.answerId }" class="file-item thumbnail">
									<div id="WU_FILE_${answer.answerId }_remove" class='img-remove'>
									<script >
									 $(function(){
										 
										 fileNumLimit-=1;
										//图片删除
										$("#WU_FILE_${answer.answerId }_remove").on('click', function() {
											
											fileNumLimit+=1
											$(this).parent().remove()
											upload(); 
										})
									 });
									</script>
									</div>
								
									<img src="" img='${answer.answerPicUrl }'  height='200' width='200'> <input value="${answer.answerPicUrl }" type='hidden' name='answerPicUrl' />
					<div class="info">选项文字<input name='answerText' value="${answer.answerText }" class='img-font' id= "test_WU_FILE_${answer.answerId }" type='Text'/></div>
					是否正确答案
					<c:choose>
						<c:when test="${answer.isTrue==1 }">
						<input name='isTrue' id= "ck_WU_FILE_${answer.answerId }" checked="checked" type='checkbox' class='img-checkbox' />
						</c:when>
						<c:otherwise>
						<input name='isTrue' id= "ck_WU_FILE_${answer.answerId }" type='checkbox' class='img-checkbox' />
						</c:otherwise>
					</c:choose>
					
					</div>
									
									</c:forEach>
								</div>

							</div>
						</td>
					</tr>
					<tr>
						<td width="100" class="td-title"></td>
						<td class="td-btn">

							<input class="btn-save" type="button" value="返回"  onclick="javascript:window.history.go(-1);"/>

							<input onclick="save()" class="btn-publish" type="button" value="保存修改" />
						</td>
					</tr>
				</table>
			</div>
		</form>
	</body>
	<script>
	 $(function(){
		upload();
	 });
	function upload(){
		
		if(fileNumLimit==0)
		{
			uploader.destroy();
			return ;
		}
		
		// 初始化Web Uploader
		 uploader = WebUploader.create({

			// 选完文件后，是否自动上传。
			auto: true,

			// swf文件路径
			swf: '../STATIC/wechat/js/webuploader/Uploader.swf',
			
			   formData: {  
				   uploadType:'Img',
				   modelType:9,
				   userCounty:$("#userCounty").val()
				   
			    }  ,

			// 文件接收服务端。
			server: '../upload/webUploader.do',

			// 选择文件的按钮。可选。
			// 内部根据当前运行是创建，可能是input元素，也可能是flash.
			pick: '#filePicker',

			// 只允许选择图片文件。
			accept: {
				title: 'Images',
				extensions: 'gif,jpg,jpeg,bmp,png',
				mimeTypes: 'image/*'
			},

			fileNumLimit: fileNumLimit
		});
		
		// 当有文件添加进来的时候
		uploader.on('fileQueued', function(file) {
			var $list = $("#fileList")
			var $li = $(
					'<div id="' + file.id + '" class="file-item thumbnail">' +
					'<div class=\'img-remove\'></div>' +
					'<img>' +
					'<input type=\'hidden\' name=\'answerPicUrl\' />' +
					'<div class="info">选项文字<input name=\'answerText\' class=\'img-font\' id= \"test_' + file.id + '\" type=\'Text\'/></div>' +
					'是否正确答案<input name=\'isTrue\' id= \"ck_' + file.id + '\" type=\'checkbox\' class=\'img-checkbox\' />' +
					'</div>'
				),
				$img = $li.find('img');

			// $list为容器jQuery实例
			$list.append($li);

			//图片删除
			$(".img-remove").on('click', function() {
				$(this).parent().remove()
				console.info(uploader.getFiles())
				var p_id = $(this).parent().attr('id')
				uploader.removeFile(p_id, true);
			})

			// 创建缩略图
			// 如果为非图片文件，可以不用调用此方法。
			// thumbnailWidth x thumbnailHeight 为 100 x 100
			uploader.makeThumb(file, function(error, src) {
				if(error) {
					$img.replaceWith('<span>不能预览</span>');
					return;
				}

				$img.attr('src', src);
			}, 200, 200);
		});

		// 文件上传过程中创建进度条实时显示。
		uploader.on('uploadProgress', function(file, percentage) {
			var $li = $('#' + file.id),
				$percent = $li.find('.progress span');

			// 避免重复创建
			if(!$percent.length) {
				$percent = $('<p class="progress"><span></span></p>')
					.appendTo($li)
					.find('span');
			}

			$percent.css('width', percentage * 100 + '%');
		});

		// 文件上传成功，给item添加成功class, 用样式标记上传成功。
		uploader.on('uploadSuccess', function(file, response) {
			$('#' + file.id).addClass('upload-state-done');
	
			if(response.code == 0) {
				//$("#" + file.id).attr("imgUrl", response.data);
				$("#" + file.id).find("input[name='answerPicUrl']").val(response.data);
			}
		});

		// 文件上传失败，显示上传出错。
		uploader.on('uploadError', function(file) {
			var $li = $('#' + file.id),
				$error = $li.find('div.error');

			// 避免重复创建
			if(!$error.length) {
				$error = $('<div class="error"></div>').appendTo($li);
			}

			$error.text('上传失败');
		});

		// 完成上传完了，成功或者失败，先删除进度条。
		uploader.on('uploadComplete', function(file) {
			$('#' + file.id).find('.progress').remove();
		});
	}
		
		
	</script>

</html>
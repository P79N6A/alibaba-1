<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
  <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
<html>
<head>
    <title>支持多文件上传</title>
    
  <script type="text/javascript">
    function doSubmit(){
    	
    	$('#file').uploadify('upload','*');
    }
    
    $(function(){
    	
    		var sessionId = $("#sessionId").val();
    		$("#file").uploadify({
    			//'formData':{'uploadType':type,'type' :2 ,userCounty:userCounty},//传静态参数
    			swf:'../STATIC/js/uploadify.swf',
    			uploader:'../nearSynonym/upload.do;jsessionid='+sessionId, //后台处理的请求
    			buttonText:'导入文件',//上传按钮的文字
    			'fileSizeLimit':'2MB',
    			'buttonClass':"upload-btn",//按钮的样式
    			queueSizeLimit:1, //   default 999
    			'method': 'post',//和后台交互的方式：post/get
    			queueID:'fileContainer',
    			fileObjName:'file', //后台接受参数名称
    			fileTypeExts:'*.xls;*.xlsx;', //控制可上传文件的扩展名，启用本项时需同时声明fileDesc
    			'auto':false, //true当选择文件后就直接上传了，为false需要点击上传按钮才上传
    			'multi':false, //是否支持多个附近同时上传
    			height:44,//选择文件按钮的高度
    			width:100,//选择文件按钮的宽度
    			'debug':false,//debug模式开/关，打开后会显示debug时的信息
    			'dataType':'json',
    			removeCompleted:true,//上传成功后的文件，是否在队列中自动删除
    			onUploadSuccess:function (file, data, response) {

    				var json = $.parseJSON(data);

					if(json.status==1)
					{
						if(json.errorList.length>0)
						{
							 html = "";
							$.each(json.errorList,function(i,item){
								html+="<p>"+item+"</p><br>";
							})
							
							dialogSaveDraft("导入失败", html);
						}
						else
						{
							 html = "<h2>上传成功!</h2>";
							 dialogSaveDraft("提示", html, function(){
								 
								 window.location.href = "${path}/nearSynonym/nearSynonymIndex.do";
							 })
						}
					}
					else if(json.status==2){
						
						html+="<p>"+json.errorMessage+"</p><br>";
						
						dialogSaveDraft("导入失败", html, function(){
							
							 window.location.href = "${path}/login.do";
						});
					}
					else if(json.status==0)
					{
						html+="<p>"+json.errorMessage+"</p><br>";
						
						dialogSaveDraft("导入失败", html);
					}
    				
    				//getImg();
    			},
    			onSelect:function () { //插件本身没有单文件上传之后replace的效果
    				//var notLast = $('#fileContainer').find('div.uploadify-queue-item').not(':last');
    				//notLast.remove();
    				//$('#btnContainer').show();
    			},
    			onCancel:function () {
    				//$('#btnContainer').hide();
    			}
    		});
    	});
    	
  </script>
  <style>
  	html,body{
  		width:100%;
  		height:100%;
  		position:relative;
  	}
  </style>
</head>
<body>

<form id="form2"  enctype="multipart/form-data" method="post">
   <input type="hidden" id="sessionId" value="${pageContext.session.id}"/>
<!-- <table class="form-table">
	<tr>
		<td> 选择文件:</td>
		<td class="td-input"> <input type="file" id="file" name="file" class="input-text w510" />
		
		<div id="fileContainer">
		
		</div>
		</td>
		
	</tr>
	
	<tr>
	<td colspan="2"><input type="button" class="btn-save" value="上传" onclick="doSubmit()"/></td>
	 	
	</tr>
</table> -->
<div style="width:500px;height:300px;position:absolute;left:0;right:0;bottom:0;top:0;margin:auto;">
	<table class="form-table">
	<tr style="vertical-align:top">
		<td> 选择文件:</td>
		<td class="td-input"> <input type="file" id="file" name="file" class="input-text w510" />
		
		<div id="fileContainer">
		
		</div>
		</td>
		
	</tr>
	
	<tr>
	<td colspan="2"><input type="button" class="btn-save" value="上传" onclick="doSubmit()"/></td>
	 	
	</tr>
</table>
</div>

 
 
</form>
</body>
</html>

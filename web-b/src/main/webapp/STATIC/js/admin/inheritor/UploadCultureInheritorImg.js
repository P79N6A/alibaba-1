$(function () {
	var type=$("#uploadType").val();
	$("#file").uploadify({
		'formData':{'uploadType':type,type:4},//传静态参数
		swf:'../STATIC/js/uploadify.swf',
		uploader:'../upload/uploadFile.do;jsessionid='+$("#sessionId").val(), //后台处理的请求
		buttonText:'上传头像',//上传按钮的文字
		'fileSizeLimit':'2MB',
		'buttonClass':"upload-btn",//按钮的样式
		queueSizeLimit:1, //   default 999
		'method': 'post',//和后台交互的方式：post/get
		queueID:'fileContainer',
		fileObjName:'file', //后台接受参数名称
		fileTypeExts:'*.gif;*.png;*.jpg;*.jpeg;', //控制可上传文件的扩展名，启用本项时需同时声明fileDesc
		'auto':true, //true当选择文件后就直接上传了，为false需要点击上传按钮才上传
		'multi':false, //是否支持多个附近同时上传
		height:25,//选择文件按钮的高度
		width:100,//选择文件按钮的宽度
		'debug':false,//debug模式开/关，打开后会显示debug时的信息
		'dataType':'json',
		removeCompleted:false,//上传成功后的文件，是否在队列中自动删除
		onUploadSuccess:function (file, data, response) {
			var json = $.parseJSON(data);
			var url=json.data;
			$("#inheritorHeadImgUrl").val(url);
			$("#btnContainer").show();
			getImg();
		},
		onSelect:function () { //插件本身没有单文件上传之后replace的效果
			var notLast = $('#fileContainer').find('div.uploadify-queue-item').not(':last');
			notLast.remove();
			$('#btnContainer').show();
		},
		onCancel:function () {
			$('#btnContainer').hide();
		}
	});
});
function clearQueue() {
	$('#file').uploadify('cancel', '*');
	$('#btnContainer').hide();
	$("#inheritorHeadImgUrl").val('');
	$("#imgHeadPrev").html("<img  src='../STATIC/image/defaultImg.png' id='userHeadImg'>");
}
function uploadQueue() {
	$('#file').uploadify('upload','*');
}

$(function(){
	//初始化获取图片
	getImg();
});

//编辑后获取图片
getImg=function(){
	var imgUrl=$("#inheritorHeadImgUrl").val();
	if(imgUrl == undefined || imgUrl == ""){
		$("#imgHeadPrev").html("<img src='../STATIC/image/defaultImg.png' id='userHeadImg'>");
	}else{
		imgUrl = getImgUrl(imgUrl);
		$("#imgHeadPrev").html("<img style='width:300px; height:200px;' src='"+imgUrl+"'>");
		$("#btnContainer").hide();
	}
};
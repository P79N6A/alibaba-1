$(window).load(function(){
	var type = $("#uploadType2").val();
	$("#file3").uploadify({
		'formData': {
			'uploadType': type,
			'userCounty': $("#userCounty").val()
		},//传静态参数
		swf: '../STATIC/js/uploadify.swf?var=' + (new Date()).getTime(),
		uploader: '../upload/uploadFile.do', //后台处理的请求
		buttonText: '上传手机端APP',//上传按钮的文字
		'fileSizeLimit': '50MB',
		'buttonClass': "upload-btn",//按钮的样式
		queueSizeLimit: 1, //   default 999
		'method': 'post',//和后台交互的方式：post/get
		queueID: 'fileContainer2',
		fileObjName: 'attachFile', //后台接受参数名称
		fileTypeExts: '*.apk;', //控制可上传文件的扩展名，启用本项时需同时声明fileDesc
		'auto': true, //true当选择文件后就直接上传了，为false需要点击上传按钮才上传
		'multi': false, //是否支持多个附近同时上传
		height: 39,//选择文件按钮的高度
		width: 100,//选择文件按钮的宽度
		'debug': false,//debug模式开/关，打开后会显示debug时的信息
		'dataType': 'json',
		removeCompleted: false,//上传成功后的文件，是否在队列中自动删除
		onUploadSuccess: function (file, data, response) {
			var json = $.parseJSON(data);
			var url = json.data;
			$("#updateUrl").val(url);
			$("#btnContainer2").show();
			//clearQueue2();
		},
		onSelect: function () { //插件本身没有单文件上传之后replace的效果
			var notLast = $('#fileContainer2').find('div.uploadify-queue-item').not(':last');
			notLast.remove();
			$('#btnContainer2').show();
		},
		onCancel: function () {
			$('#btnContainer2').hide();
		}
	});
});
function clearAppQueue(){
	$('#file3').uploadify('cancel', '*');
	$('#btnContainer2').hide();
	$("#updateUrl").val('');
}
function uploadQueue2() {
	$('#file3').uploadify('upload','*');
}
jQuery(function() {
	var $ = jQuery,
		// Web Uploader实例
		uploader;

	var uploader = WebUploader.create({
		// 选完文件后，是否自动上传。
		auto: true,
		// swf文件路径
		swf: '../STATIC/wechat/js/webuploader/Uploader.swf',
		// 文件接收服务端。
		server: '../wechat/uploadWcFiles.do?userId='+userId+'&uploadType=1&modelType=3',
		// 选择文件的按钮。可选。
		// 内部根据当前运行是创建，可能是input元素，也可能是flash.
		pick: '.bcUpPhoto',
		// 不压缩image, 默认如果是jpeg，文件上传前会压缩一把再上传！
		resize: false,
		// 只允许选择图片文件。
		accept: {
			title: 'Images',
			extensions: 'gif,jpg,jpeg,bmp,png',
			mimeTypes: 'image/*'
		},
		// 允许重复
		duplicate: true
	});

	// 当有文件添加进来的时候
	uploader.on('fileQueued', function(file) {
		$("#upPhoto").attr("src","../STATIC/wxStatic/image/comedy/loading.gif");
	});

	// 文件上传成功，给item添加成功class, 用样式标记上传成功。
	uploader.on('uploadSuccess', function(file, response) {		
		
	    //回调参数，加载图片
	    if(response.status==0){
	    	var imgUrl = response.data;
	    	var imgUrlAli = "http://culturecloud.img-cn-hangzhou.aliyuncs.com/image"+imgUrl.substr(imgUrl.lastIndexOf("/"));
    		$("#upPhoto").attr("src",imgUrlAli+"@700w");
    		$("#userUploadImg").val(imgUrlAli);
	    }else{
	    	$("#upPhoto").attr("src","../STATIC/wxStatic/image/comedy/pic5.jpg");
	    	dialogAlert('系统提示', '上传失败！');
	    }
	});

	// 文件上传失败，显示上传出错。
	uploader.on('uploadError', function(file) {
		$("#upPhoto").attr("src","../STATIC/wxStatic/image/comedy/pic5.jpg");
		dialogAlert('系统提示', '上传失败！');
	});

	// 完成上传完了，成功或者失败，先删除进度条。
	uploader.on('uploadComplete', function(file) {
		$('#' + file.id).find('.progress').remove();
	});

});
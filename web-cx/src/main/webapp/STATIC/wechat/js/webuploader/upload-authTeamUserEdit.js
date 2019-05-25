function upload1() {
	var $ = jQuery,
    $list = $('#personForm .user-upl');
	
	uploader1 = WebUploader.create({
		// 选完文件后，是否自动上传。
	    auto: true,
	    // swf文件路径
	    swf: '../STATIC/wechat/js/webuploader/Uploader.swf',
	    // 文件接收服务端。
	    server: '../wechat/uploadWcFiles.do?userId='+userId+'&uploadType=1&modelType=3',
	    // 选择文件的按钮。可选。
	    // 内部根据当前运行是创建，可能是input元素，也可能是flash.
	    pick: '.uploadClass1',
	    // 不压缩image, 默认如果是jpeg，文件上传前会压缩一把再上传！
	    resize: false,
	    // 只允许选择图片文件。
	    accept: {
	        title: 'Images',
	        extensions: 'gif,jpg,jpeg,bmp,png',
	        mimeTypes: 'image/*'
	    },
	    // 允许重复
	    duplicate : true
	});
	
	// 当有文件添加进来的时候
	uploader1.on( 'fileQueued', function( file ) {
	    var $li = $(
	            '<li id="' + file.id + '" imgUrl="" class="uploadLi">' +
	                '<img height="150" width="150">' +
	                '<p class="progress"><span></span></p>' +
	                '<img class="user-uplrem" src="../STATIC/wechat/image/mobile_close.png"></img>' +
	            '</li>'
	            ),
	        $img = $li.find('img');

	    // $list为容器jQuery实例
	    $list.prepend( $li );

	    imgButton('personForm');	//判断图片按钮是否显示
	    
	    //删除按钮
		$("#personForm .user-uplrem").on("touchstart", function() {
			$(this).parent('li').remove();
			upload1();
			uploader1.option( 'fileNumLimit',9-$("#personForm .add-pic-list li.uploadLi").length);
			imgButton('personForm');
		})
	});
	
	// 文件上传过程中创建进度条实时显示。
	uploader1.on( 'uploadProgress', function( file, percentage ) {
	    var $li = $( '#'+file.id ),
	        $percent = $li.find('.progress span');
	    
	    // 避免重复创建
	    if ( !$percent.length ) {
	        $percent = $('<p class="progress"><span></span></p>')
	                .appendTo( $li )
	                .find('span');
	    }

	    $percent.css( 'width', percentage * 100 + '%' );
	});

	// 文件上传成功，给item添加成功class, 用样式标记上传成功。
	uploader1.on( 'uploadSuccess', function( file, response ) {
	    $( '#'+file.id ).addClass('upload-state-done');
	    
	    //回调参数，加载图片
	    if(response.status==0){
	    	$("#"+file.id).attr("imgUrl",response.data);
	    	var imgUrl = getIndexImgUrl(response.data,"_150_150");
	    	$("#"+file.id).find('img:eq(0)').attr("src",imgUrl);
	    }
	});

	// 文件上传失败，显示上传出错。
	uploader1.on( 'uploadError', function( file ) {
		dialogAlert('系统提示', '上传失败！');
	});

	// 完成上传完了，成功或者失败，先删除进度条。
	uploader1.on( 'uploadComplete', function( file ) {
	    $( '#'+file.id ).find('.progress').remove();
	});
	
};

function upload2() {
	var $ = jQuery,
    $list = $('#teamForm .user-upl');
	
	var userId=$("#userId").val();

	uploader2 = WebUploader.create({
		// 选完文件后，是否自动上传。
	    auto: true,
	    // swf文件路径
	    swf: '../STATIC/wechat/js/webuploader/Uploader.swf',
	    // 文件接收服务端。
	    server: '../wechat/uploadWcFiles.do?userId='+userId+'&uploadType=1&modelType=3',
	    // 选择文件的按钮。可选。
	    // 内部根据当前运行是创建，可能是input元素，也可能是flash.
	    pick: '.uploadClass2',
	    // 不压缩image, 默认如果是jpeg，文件上传前会压缩一把再上传！
	    resize: false,
	    // 只允许选择图片文件。
	    accept: {
	        title: 'Images',
	        extensions: 'gif,jpg,jpeg,bmp,png',
	        mimeTypes: 'image/*'
	    },
	    // 允许重复
	    duplicate : true
	});
	
	// 当有文件添加进来的时候
	uploader2.on( 'fileQueued', function( file ) {
	    var $li = $(
	            '<li id="' + file.id + '" imgUrl="" class="uploadLi">' +
	                '<img height="150" width="150">' +
	                '<p class="progress"><span></span></p>' +
	                '<img class="user-uplrem" src="../STATIC/wechat/image/mobile_close.png"></img>' +
	            '</li>'
	            ),
	        $img = $li.find('img');

	    // $list为容器jQuery实例
	    $list.prepend( $li );

	    imgButton('teamForm');	//判断图片按钮是否显示
	    
	    //删除按钮
		$("#teamForm .user-uplrem").on("touchstart", function() {
			$(this).parent('li').remove();
			upload2();
			uploader2.option( 'fileNumLimit',9-$("#teamForm .add-pic-list li.uploadLi").length);
			imgButton('teamForm');
		})
	});
	
	// 文件上传过程中创建进度条实时显示。
	uploader2.on( 'uploadProgress', function( file, percentage ) {
	    var $li = $( '#'+file.id ),
	        $percent = $li.find('.progress span');
	    
	    // 避免重复创建
	    if ( !$percent.length ) {
	        $percent = $('<p class="progress"><span></span></p>')
	                .appendTo( $li )
	                .find('span');
	    }

	    $percent.css( 'width', percentage * 100 + '%' );
	});

	// 文件上传成功，给item添加成功class, 用样式标记上传成功。
	uploader2.on( 'uploadSuccess', function( file, response ) {
	    $( '#'+file.id ).addClass('upload-state-done');
	    
	    //回调参数，加载图片
	    if(response.status==0){
	    	$("#"+file.id).attr("imgUrl",response.data);
	    	var imgUrl = getIndexImgUrl(response.data,"_150_150");
	    	$("#"+file.id).find('img:eq(0)').attr("src",imgUrl);
	    }
	});

	// 文件上传失败，显示上传出错。
	uploader2.on( 'uploadError', function( file ) {
		dialogAlert('系统提示', '上传失败！');
	});

	// 完成上传完了，成功或者失败，先删除进度条。
	uploader2.on( 'uploadComplete', function( file ) {
	    $( '#'+file.id ).find('.progress').remove();
	});
	
};

function upload3() {
	var $ = jQuery,
    $list = $('#companyForm .user-upl');
	
	var userId=$("#userId").val();

	uploader3 = WebUploader.create({
		// 选完文件后，是否自动上传。
	    auto: true,
	    // swf文件路径
	    swf: '../STATIC/wechat/js/webuploader/Uploader.swf',
	    // 文件接收服务端。
	    server: '../wechat/uploadWcFiles.do?userId='+userId+'&uploadType=1&modelType=3',
	    // 选择文件的按钮。可选。
	    // 内部根据当前运行是创建，可能是input元素，也可能是flash.
	    pick: '.uploadClass3',
	    // 不压缩image, 默认如果是jpeg，文件上传前会压缩一把再上传！
	    resize: false,
	    // 只允许选择图片文件。
	    accept: {
	        title: 'Images',
	        extensions: 'gif,jpg,jpeg,bmp,png',
	        mimeTypes: 'image/*'
	    },
	    // 允许重复
	    duplicate : true
	});
	
	// 当有文件添加进来的时候
	uploader3.on( 'fileQueued', function( file ) {
	    var $li = $(
	            '<li id="' + file.id + '" imgUrl="" class="uploadLi">' +
	                '<img height="150" width="150">' +
	                '<p class="progress"><span></span></p>' +
	                '<img class="user-uplrem" src="../STATIC/wechat/image/mobile_close.png"></img>' +
	            '</li>'
	            ),
	        $img = $li.find('img');

	    // $list为容器jQuery实例
	    $list.prepend( $li );

	    imgButton('companyForm');	//判断图片按钮是否显示
	    
	    //删除按钮
		$("#companyForm .user-uplrem").on("touchstart", function() {
			$(this).parent('li').remove();
			upload3();
			uploader3.option( 'fileNumLimit',9-$("#companyForm .add-pic-list li.uploadLi").length);
			imgButton('companyForm');
		})
	});
	
	// 文件上传过程中创建进度条实时显示。
	uploader3.on( 'uploadProgress', function( file, percentage ) {
	    var $li = $( '#'+file.id ),
	        $percent = $li.find('.progress span');
	    
	    // 避免重复创建
	    if ( !$percent.length ) {
	        $percent = $('<p class="progress"><span></span></p>')
	                .appendTo( $li )
	                .find('span');
	    }

	    $percent.css( 'width', percentage * 100 + '%' );
	});

	// 文件上传成功，给item添加成功class, 用样式标记上传成功。
	uploader3.on( 'uploadSuccess', function( file, response ) {
	    $( '#'+file.id ).addClass('upload-state-done');
	    
	    //回调参数，加载图片
	    if(response.status==0){
	    	$("#"+file.id).attr("imgUrl",response.data);
	    	var imgUrl = getIndexImgUrl(response.data,"_150_150");
	    	$("#"+file.id).find('img:eq(0)').attr("src",imgUrl);
	    }
	});

	// 文件上传失败，显示上传出错。
	uploader3.on( 'uploadError', function( file ) {
		dialogAlert('系统提示', '上传失败！');
	});

	// 完成上传完了，成功或者失败，先删除进度条。
	uploader3.on( 'uploadComplete', function( file ) {
	    $( '#'+file.id ).find('.progress').remove();
	});
	
};

function upload4() {
	var $ = jQuery,
    $list = $('.tuser-upl');
	
	var userId=$("#userId").val();

	uploader4 = WebUploader.create({
		// 选完文件后，是否自动上传。
	    auto: true,
	    // swf文件路径
	    swf: '../STATIC/wechat/js/webuploader/Uploader.swf',
	    // 文件接收服务端。
	    server: '../wechat/uploadWcFiles.do?userId='+userId+'&uploadType=1&modelType=3',
	    // 选择文件的按钮。可选。
	    // 内部根据当前运行是创建，可能是input元素，也可能是flash.
	    pick: '.uploadClass4',
	    // 不压缩image, 默认如果是jpeg，文件上传前会压缩一把再上传！
	    resize: false,
	    // 只允许选择图片文件。
	    accept: {
	        title: 'Images',
	        extensions: 'gif,jpg,jpeg,bmp,png',
	        mimeTypes: 'image/*'
	    },
	    // 允许重复
	    duplicate : true
	});
	
	// 当有文件添加进来的时候
	uploader4.on( 'fileQueued', function( file ) {
	    var $li = $(
	            '<li id="' + file.id + '" imgUrl="" class="uploadLi">' +
	                '<img height="150" width="150">' +
	                '<p class="progress"><span></span></p>' +
	                '<img class="tuser-uplrem" src="../STATIC/wechat/image/mobile_close.png"></img>' +
	            '</li>'
	            ),
	        $img = $li.find('img');

	    $(".add-tuser-pic-button").hide();
	    
	    // $list为容器jQuery实例
	    $list.prepend( $li );

	    //删除按钮
		$(".tuser-uplrem").on("touchstart", function() {
			$(this).parent('li').remove();
			upload4();
			uploader4.option( 'fileNumLimit',1-$("#companyForm .add-tuser-pic-list li.uploadLi").length);
			$(".add-tuser-pic-button").show();
		})
	});
	
	// 文件上传过程中创建进度条实时显示。
	uploader4.on( 'uploadProgress', function( file, percentage ) {
	    var $li = $( '#'+file.id ),
	        $percent = $li.find('.progress span');
	    
	    // 避免重复创建
	    if ( !$percent.length ) {
	        $percent = $('<p class="progress"><span></span></p>')
	                .appendTo( $li )
	                .find('span');
	    }

	    $percent.css( 'width', percentage * 100 + '%' );
	});

	// 文件上传成功，给item添加成功class, 用样式标记上传成功。
	uploader4.on( 'uploadSuccess', function( file, response ) {
	    $( '#'+file.id ).addClass('upload-state-done');
	    
	    //回调参数，加载图片
	    if(response.status==0){
	    	$("#"+file.id).attr("imgUrl",response.data);
	    	var imgUrl = getIndexImgUrl(response.data,"_150_150");
	    	$("#"+file.id).find('img:eq(0)').attr("src",imgUrl);
	    }
	});

	// 文件上传失败，显示上传出错。
	uploader4.on( 'uploadError', function( file ) {
		dialogAlert('系统提示', '上传失败！');
	});

	// 完成上传完了，成功或者失败，先删除进度条。
	uploader4.on( 'uploadComplete', function( file ) {
	    $( '#'+file.id ).find('.progress').remove();
	});
	
};
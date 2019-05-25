jQuery(function() {
	var $ = jQuery,
    $list = $('.fack_block .upimg ul');
	
	var userId=$("#userId").val();

	uploader = WebUploader.create({
		// 选完文件后，是否自动上传。
	    auto: true,
	    // swf文件路径
	    swf: '../STATIC/wechat/js/webuploader/Uploader.swf',
	    // 文件接收服务端。
	    server: '../wechat/uploadWcFiles.do?userId='+userId+'&uploadType=1&modelType=3',
	    // 选择文件的按钮。可选。
	    // 内部根据当前运行是创建，可能是input元素，也可能是flash.
	    pick: '.uploadClass',
	    // 不压缩image, 默认如果是jpeg，文件上传前会压缩一把再上传！
	    resize: false,
	    // 只允许选择图片文件。
	    accept: {
	        title: 'Images',
	        extensions: 'gif,jpg,jpeg,bmp,png',
	        mimeTypes: 'image/*'
	    },
	    // 允许重复
	    duplicate : true,
	    // 验证文件总数量, 超出则不允许加入队列
	    fileNumLimit : 3
	});
	
	// 当有文件添加进来的时候
	uploader.on( 'fileQueued', function( file ) {
	    var $li = $(
	            '<li id="' + file.id + '" feedImgUrl="">' +
	                '<div class="pict"><img ></div>' +
	                '<p class="progress"><span></span></p>' +
	                '<a class="m_close"><img src="../STATIC/wx/image/mobile_close.png"></a>' +
	            '</li>'
	            ),
	        $img = $li.find('img');

	    // $list为容器jQuery实例
	    $list.append( $li );

	    imgButton();	//判断图片按钮是否显示
	    
	    /**删除图片**/
		$(".fack_block .upimg ul").on('touchstart','li .m_close',function(){
  			  $(this).parent().remove();
  			  imgButton();
  			  chooseCount++;
  			  uploader.removeFile( $(this).parent('li').attr("id"), true );
  		})
	    
	    /*// 创建缩略图
	    // 如果为非图片文件，可以不用调用此方法。
	    // thumbnailWidth x thumbnailHeight 为 100 x 100
	    uploader.makeThumb( file, function( error, src ) {
	        if ( error ) {
	            $img.replaceWith('<span>不能预览</span>');
	            return;
	        }

	        $img.attr( 'src', src );
	    }, thumbnailWidth, thumbnailHeight );*/
	});
	
	// 文件上传过程中创建进度条实时显示。
	uploader.on( 'uploadProgress', function( file, percentage ) {
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
	uploader.on( 'uploadSuccess', function( file, response ) {
	    $( '#'+file.id ).addClass('upload-state-done');
	    
	    //回调参数，加载图片
	    if(response.status==0){
	    	$("#"+file.id).attr("feedImgUrl",response.data);
	    	var imgUrl = getIndexImgUrl(response.data,"_150_150");
	    	$("#"+file.id+" .pict").find('img').attr("src",imgUrl);
	    }
	});

	// 文件上传失败，显示上传出错。
	uploader.on( 'uploadError', function( file ) {
		dialogAlert('系统提示', '上传失败！');
	});

	// 完成上传完了，成功或者失败，先删除进度条。
	uploader.on( 'uploadComplete', function( file ) {
	    $( '#'+file.id ).find('.progress').remove();
	});
	
});

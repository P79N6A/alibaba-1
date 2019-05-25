function aliUpload(obj) {
	/*
	 * uploadDomId 上传ID，默认为webUpload
	 * fileFormat 格式限制，默认不限制，参数为字符串逗号分割
	 * upLoadSrc 上传路径，默认为H5文件夹
	 * fileNum 上传数量限制，默认为false，不限制
	 * callBackFunc 上传回调函数，默认无回调
	 * progressBar 进度条显示，默认为不显示 false
	 * fileSize 文件大小限制，默认不限制
	 * imgPreview 预览图，默认没有
	 * callBackFunc 报错回调
	 * 
	 * */
	
	if(!obj) {
		var obj = new Object();
	}
	obj.uploadDomId = obj.uploadDomId ? obj.uploadDomId : 'webUpload';
	obj.fileFormat = obj.fileFormat ? [{
		title: "fileFormat",
		extensions: obj.fileFormat
	}] : [];
	obj.upLoadSrc = obj.upLoadSrc ? obj.upLoadSrc : 'H5';
	obj.fileNum = obj.fileNum ? obj.fileNum : false;
	obj.callBackFunc = obj.callBackFunc ? obj.callBackFunc : '';
	obj.fileSize = obj.fileSize ? obj.fileSize : null;
	obj.progressBar = obj.progressBar ? obj.progressBar : false;
	obj.imgPreview = obj.imgPreview ? obj.imgPreview : false;
	obj.erroeCallBack = obj.erroeCallBack ? obj.erroeCallBack : '';
	
	

	var policyText = {
		"expiration": "2020-01-01T12:00:00.000Z", //设置该Policy的失效时间，超过这个失效时间之后，就没有办法通过这个policy上传文件了
		"conditions": [
			["content-length-range", 0, 1048576000] // 设置上传文件的大小限制
		]
	};

	accessid = 'g71YwJtSB2zq8EgJ';
	accesskey = '9PJFP214P7vt5SjFWnxBNwPxkoqYJr';
	host = 'http://culturecloud.img-cn-hangzhou.aliyuncs.com';
	var fileName = '';

	var policyBase64 = Base64.encode(JSON.stringify(policyText))
	message = policyBase64
	var bytes = Crypto.HMAC(Crypto.SHA1, message, accesskey, {
		asBytes: true
	});
	var signature = Crypto.util.bytesToBase64(bytes);

	function random_string(len) {
		var d, s;
		d = new Date();
		s = d.getFullYear().toString() //取年份0
		s = s + (d.getMonth() + 1); //取月份
		s += d.getDate(); //取日期
		s += d.getHours(); //取小时
		s += d.getMinutes(); //取分
		s += d.getSeconds();
		var pwd = s + Math.uuid(len);
		return pwd;
	}

	function set_upload_param(up, upFileName, fileLink) {

		var pos = upFileName.lastIndexOf('.')
		var suffix = ''
		if(pos != -1) {
			suffix = upFileName.substring(pos)
		}

		fileName = fileLink + '/' + random_string(30) + suffix

		new_multipart_params = {
			'key': fileName
		};

		up.setOption({
			'multipart_params': new_multipart_params
		});

		//up.start();
	}

	var uploader = new plupload.Uploader({
		runtimes: 'html5,flash,silverlight,html4',
		browse_button: $("#" + obj.uploadDomId + " #selectfiles")[0],
		container: $("#" + obj.uploadDomId + " #container")[0],
		flash_swf_url: 'js/Moxie.swf',
		silverlight_xap_url: 'js/Moxie.xap',
		url: host,
		//multi_selection:false,
		/*resize: {
			crop: false,
			quality: 80,
			preserve_headers: false
		},*/
		filters: {
			mime_types: obj.fileFormat,
			//max_file_size: '400kb', //最大只能上传400kb的文件
			max_file_size: obj.fileSize,
			//prevent_duplicates: true //不允许选取重复文件
		},
		multipart_params: {
			'policy': policyBase64,
			'OSSAccessKeyId': accessid,
			'success_action_status': '200', //让服务端返回200,不然，默认会返回204
			'signature': signature,
		},

		init: {
			PostInit: function() {
				//document.getElementById('ossfile').innerHTML = '';
			},

			FilesAdded: function(up, files) {
				var addFiles = $("#" + obj.uploadDomId).find("div[name='aliFile']");
				var size = obj.fileNum - addFiles.length;
				plupload.each(files, function(file) {
					if(size <= 0 && obj.fileNum != false) {
						// 先删除已添加的图片
						if(addFiles.length > 0) {
							var fileId = $(addFiles[0]).attr("id");
							if(fileId) {
								up.removeFile(fileId);
							}
							addFiles[0].remove();
							addFiles.splice(0, 1);
						}
						// 删除新上传的图片
						else {
							var fileId = up.files[0].id;
							if(fileId != file.id) {
								$("#" + obj.uploadDomId + " #ossfile")[0].removeChild(
									document.getElementById(fileId));

								up.files.splice(0, 1);
							}
						}
					}
					$("#" + obj.uploadDomId + " #ossfile").append('<div name="aliFile" id="' + file.id + '"><span>' + file.name + ' (' + plupload.formatSize(file.size) + ')</span><b></b>' + '</div>');

					//进度条
					if(obj.progressBar) {
						$("#" + file.id).append('<div class="progress"><div class="progress-bar" style="width: 0%"></div></div>')
					}

					//缩略图容器、删除按钮、删除按钮事件绑定
					if(obj.imgPreview) {
						$("#" + file.id).prepend('<div class="imgPack"><img class="aliRemoveBtn" src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201733161236Bn6gTqiCZBHhgObFvsCkLFNzmIBoh2.png"/></div>')
						$("#" + file.id).find(".aliRemoveBtn").click(function() {
							$("#" + file.id).remove();
							up.removeFile(file.id);
						});
					}
					size--;
				});
				up.start();
			},
			BeforeUpload: function(up, file) {
				set_upload_param(up, file.name, obj.upLoadSrc);
			},
			UploadProgress: function(up, file) {
				var d = document.getElementById(file.id);
				d.getElementsByTagName('b')[0].innerHTML = '<span>' + file.percent + "%</span>";

				//进度条
				if(obj.progressBar) {
					var prog = d.getElementsByClassName('progress')[0];
					var progBar = prog.getElementsByTagName('div')[0]
					progBar.style.width = 2 * file.percent + 'px';
					progBar.setAttribute('aria-valuenow', file.percent);
				}
			},

			FileUploaded: function(up, file, info) {
				if(info.status >= 200 || info.status < 200) {
					document.getElementById(file.id).getElementsByTagName('b')[0].innerHTML = '上传成功';

					//图片显示预览
					if(obj.imgPreview) {
						var img = document.createElement("img");
						img.setAttribute("src", host + '/' + fileName);
						$(img).addClass("upload-img-identify");
						$("#" + file.id).find(".imgPack").append(img)
					}
				} else {
					document.getElementById(file.id).getElementsByTagName('b')[0].innerHTML = info.response;
				}
				if(obj.callBackFunc && fileName) {
					obj.callBackFunc(up, file, fileName)
				}
			},

			Error: function(up, err) {
				console.log(err)
				if(obj.callBackFunc) {
					obj.callBackFunc(up, err)
				}
			}
		}
	});

	uploader.init();
}
accessid = 'g71YwJtSB2zq8EgJ';
accesskey = '9PJFP214P7vt5SjFWnxBNwPxkoqYJr';
host = 'http://oss-cn-hangzhou.aliyuncs.com/culturecloud/';

var oldId;

g_dirname = ''
g_object_name = ''
g_object_name_type = 'random_name'//'local_name'
now = timestamp = Date.parse(new Date()) / 1000;

var policyText = {
	"expiration": "2020-01-01T12:00:00.000Z", //设置该Policy的失效时间，超UploadProgress过这个失效时间之后，就没有办法通过这个policy上传文件了
	"conditions": [
		["content-length-range", 0, 10485760000] // 设置上传文件的大小限制
	]
};

var policyBase64 = Base64.encode(JSON.stringify(policyText))
message = policyBase64
var bytes = Crypto.HMAC(Crypto.SHA1, message, accesskey, {
	asBytes: true
});
var signature = Crypto.util.bytesToBase64(bytes);

function aliRemoveImg(rm) {
	rm.parentNode.parentNode.removeChild(rm.parentNode);
}

function get_dirname_img(img_div) {
	var dir = img_div //document.getElementById("dirname").value;
	if(dir != '' && dir.indexOf('/') != dir.length - 1) {
		dir = dir + '/'
	}
	g_dirname = dir
}

function random_string(len) {
	//　　len = len || 32;
	//　　var chars = 'ABCDEFGHJKMNPQRSTWXYZabcdefhijkmnprstwxyz2345678';   
	//　　var maxPos = chars.length;
	//　　var pwd = '';
	//　　for (i = 0; i < len; i++) {
	//  　　pwd += chars.charAt(Math.floor(Math.random() * maxPos));
	//  }
	//  return pwd;
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

function get_suffix_img(filename) {
	pos = filename.lastIndexOf('.')
	suffix = ''
	if(pos != -1) {
		suffix = filename.substring(pos)
	}
	return suffix;
}

//上传文件名字是否随机
function calculate_object_name_img(filename) {
	g_object_name_type = 'random_name'; //规定为随机
	if(g_object_name_type == 'local_name') {
		g_object_name += "${filename}"
	} else if(g_object_name_type == 'random_name') {
		suffix = get_suffix_img(filename)
		g_object_name = g_dirname + random_string(30) + suffix
	}
	return ''
}

function get_uploaded_object_name_img(filename) {
	if(g_object_name_type == 'local_name') {
		tmp_name = g_object_name
		tmp_name = tmp_name.replace("${filename}", filename);
		return tmp_name
	} else if(g_object_name_type == 'random_name') {
		return g_object_name
	}
}

function set_upload_param_img(up, filename, ret) {
	g_object_name = g_dirname;
	if(filename != '') {
		suffix = get_suffix_img(filename)
		calculate_object_name_img(filename)
	}
	new_multipart_params = {
		'key': g_object_name,
		'policy': policyBase64,
		'OSSAccessKeyId': accessid,
		'success_action_status': '200', //让服务端返回200,不然，默认会返回204
		'signature': signature,
	};

	up.setOption({
		'url': host,
		'multipart_params': new_multipart_params
	});

	up.start();
}

function aliUploadImg(uploadDomId, callback, upNum, auto, imgSrc) {
	if(!imgSrc) {
		imgSrc = 'H5'
	}
	var multiSelection = false;

	if(upNum) {
		upNum = upNum;

		if(upNum > 2)
			multiSelection = true;
	} else
		upNum = 1

	var d;
	var uploader_img = new plupload.Uploader({
		runtimes: 'html5,flash,silverlight,html4',
		browse_button: $("#" + uploadDomId + " #selectfiles2")[0],
		multi_selection: multiSelection, //限制单张上传
		container: $("#" + uploadDomId + " #container2")[0],
		flash_swf_url: './Moxie.swf',
		silverlight_xap_url: './Moxie.xap',
		url: 'http://oss.aliyuncs.com',
		fileNumLimit: upNum,
		filters: {
			title: "Image files",
			extensions: "jpg,png,bmp",
			prevent_duplicates: false
		},
		resize: {
			crop:false,
			quality: 70,
			preserve_headers: false
		},
		init: {
			PostInit: function() {
				var $children = $("#" + uploadDomId + " #ossfile2").children();
				$("#" + uploadDomId + " #ossfile2").empty().append($children);
				if(!auto) {
					$("#" + uploadDomId + " #postfiles2")[0].onclick = function() {
						set_upload_param_img(uploader_img, '', false);
						return false;
					};
				}

			},

			FilesAdded: function(up, files) {
				console.log(files)
					//单张上传显示
					//if(upNum == 1) {
					//	if(oldId2 != '') {
					//		var my = document.getElementById(oldId2); //file.id
					//		if(my != null)
					//			my.parentNode.removeChild(my);
					//	}
					//}

				//var size = upNum - document.getElementsByName("aliFile").length;
				// 已经添加的问题
				var addFiles = $("#" + uploadDomId).find("div[name='aliFile']");

				var size = upNum - addFiles.length;

				plupload.each(files, function(file) {
					console.log(files.length)
					if(size <= 0) {

						// 先删除已添加的图片
						if(addFiles.length > 0) {
							
							var fileId=$(addFiles[0]).attr("id");
							
							if(fileId){
								uploader_img.removeFile(fileId);
							}

							addFiles[0].remove();
							addFiles.splice(0, 1);
						}
						// 删除新上传的图片
						else {
							var fileId = uploader_img.files[0].id;

							if(fileId != file.id) {
								$("#" + uploadDomId + " #ossfile2")[0].removeChild(
									document.getElementById(fileId));

								uploader_img.files.splice(0, 1);
							}
						}
					}
					var imgPath= '/STATIC/image/removeBtn.png';
					$("#" + uploadDomId + " #ossfile2").append('<div name="aliFile" style="position:relative" id="' + file.id + '"><span>' + file.name + ' (' + plupload.formatSize(file.size) + ')</span><b></b>' +
						'<div class="progress"><div class="progress-bar" style="width: 0%"></div></div>' +
						'<img class="aliRemoveBtn" src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201733161236Bn6gTqiCZBHhgObFvsCkLFNzmIBoh2.png" style="position:absolute;right:0;top:0;width:20px" />' +
						'</div>');

					$("#" + file.id).find(".aliRemoveBtn").click(function() {

						$("#" + file.id).remove();

						uploader_img.removeFile(file.id);

					});

					size--;
					console.log(size)

				});

				if(auto == true) {
					set_upload_param_img(uploader_img, '', false);
				}

			},

			BeforeUpload: function(up, file) {
				get_dirname_img(imgSrc);
				set_upload_param_img(up, file.name, true);
			},

			UploadProgress: function(up, file) {
				d = document.getElementById(file.id);

				d.getElementsByTagName('b')[0].innerHTML = '<span>' + file.percent + "%</span>";
				var prog = d.getElementsByTagName('div')[0];
				var progBar = prog.getElementsByTagName('div')[0]
				progBar.style.width = 2 * file.percent + 'px';
				progBar.setAttribute('aria-valuenow', file.percent);
			},

			FileUploaded: function(up, file, info) {
				if(info.status == 200) { //回调函数
					var fileName = get_uploaded_object_name_img(file.name);

					document.getElementById(file.id).getElementsByTagName('b')[0].innerHTML = '上传成功'; //file.id
					//document.getElementById('containerImg2').src = "http://oss-cn-hangzhou.aliyuncs.com/culturecloud/" + fileName;

					var img = document.createElement("img");
					img.setAttribute("style", "max-height: 130px;max-width: 130px;position:absolute;left: 0;right: 0;top: 0;bottom: 0;margin: auto;");
					img.setAttribute("src", host + fileName);
					// 增加图片上传标识
					 $(img).addClass("upload-img-identify");
					var br = document.createElement("br");
					document.getElementById(file.id).insertBefore(br, document.getElementById(file.id).childNodes.item(0))
					document.getElementById(file.id).insertBefore(img, document.getElementById(file.id).childNodes.item(0))

					if(callback && fileName){
						callback(up, file, fileName)
					}
				} else {
					document.getElementById(file.id).getElementsByTagName('b')[0].innerHTML = info.response;
				}
			},

			Error: function(up, err) {
				//				document.getElementById('console').appendChild(document.createTextNode("\nError xml:" + err.response));
			}
		}

	});
	failesNum = 1;
	uploader_img.init();
}

function getBasePath() {
	var localObj = window.location;
	var contextPath = localObj.pathname.split("/")[1];
	if (contextPath) {
		return localObj.protocol + "//" + localObj.host + "/" + contextPath;
	}else {
		return localObj.protocol + "//" + localObj.host ;
	}
};
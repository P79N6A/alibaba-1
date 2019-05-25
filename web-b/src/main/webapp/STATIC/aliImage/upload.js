accessid = 'g71YwJtSB2zq8EgJ';
accesskey = '9PJFP214P7vt5SjFWnxBNwPxkoqYJr';
host = 'http://oss-cn-hangzhou.aliyuncs.com/culturecloud';
var oldId;
//var oldId2;
var upNum = 2; //上传限制，1为单张，2为多张

g_dirname = ''
g_object_name = ''
g_object_name_type = ''
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

function check_object_radio() {
	var tt = document.getElementsByName('myradio');
	for(var i = 0; i < tt.length; i++) {
		if(tt[i].checked) {
			g_object_name_type = tt[i].value;
			break;
		}
	}
}

function get_dirname_img() {
	dir = 'H5' //document.getElementById("dirname").value;
	if(dir != '' && dir.indexOf('/') != dir.length - 1) {
		dir = dir + '/'
	}
	g_dirname = dir
}

function get_dirname_video() {
	dir = 'video' //document.getElementById("dirname").value;
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

function get_suffix(filename) {
	pos = filename.lastIndexOf('.')
	suffix = ''
	if(pos != -1) {
		suffix = filename.substring(pos)
	}
	return suffix;
}

//上传文件名字是否随机
function calculate_object_name(filename) {
	g_object_name_type = 'random_name'; //规定为随机
	if(g_object_name_type == 'local_name') {
		g_object_name += "${filename}"
	} else if(g_object_name_type == 'random_name') {
		suffix = get_suffix(filename)
		g_object_name = g_dirname + random_string(30) + suffix
	}
	return ''
}

function get_uploaded_object_name(filename) {
	if(g_object_name_type == 'local_name') {
		tmp_name = g_object_name
		tmp_name = tmp_name.replace("${filename}", filename);
		return tmp_name
	} else if(g_object_name_type == 'random_name') {
		return g_object_name
	}
}

function set_upload_param(up, filename, ret) {
	g_object_name = g_dirname;
	if(filename != '') {
		suffix = get_suffix(filename)
		calculate_object_name(filename)
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

var uploader_video;

function aliUploadVideo(callback, upNum) {

	var multiSelection = false;

	if(upNum) {
		upNum = upNum;

		if(upNum > 0)
			multiSelection = true;
	}

	var d;
	uploader_video = new plupload.Uploader({
		runtimes: 'html5,flash,silverlight,html4',
		browse_button: 'selectfiles',
		multi_selection: multiSelection, //限制单张上传
		container: document.getElementById('container'),
		flash_swf_url: './Moxie.swf',
		silverlight_xap_url: './Moxie.xap',
		url: 'http://oss.aliyuncs.com',
		filters: {
			mime_types: [ //只允许上传图片
				{
					title: "Vedio files",
					extensions: "MP4,rm,mpg,avi"
				},
			],
			prevent_duplicates: true //不允许选取重复文件
		},
		init: {
			PostInit: function() {
				document.getElementById('ossfile').innerHTML = '';
				document.getElementById('postfiles').onclick = function() {
					set_upload_param(uploader_video, '', false);
					return false;
				};
			},

			FilesAdded: function(up, files) {
				//单张上传显示
				if(upNum == 1) {
					if(oldId != '') {
						var my = document.getElementById(oldId); //file.id
						if(my != null)
							my.parentNode.removeChild(my);
					}
				}
				plupload.each(files, function(file) {
					document.getElementById('ossfile').innerHTML += '<div id="' + file.id + '">' + file.name + ' (' + plupload.formatSize(file.size) + ')<b></b>' +
						'<div class="progress"><div class="progress-bar" style="width: 0%"></div></div>' +
						'</div>';
					oldId = file.id;

				});
			},

			BeforeUpload: function(up, file) {
				check_object_radio();
				get_dirname_video();
				set_upload_param(up, file.name, true);
			},

			UploadProgress: function(up, file) {
				d = document.getElementById(oldId);
				d.getElementsByTagName('b')[0].innerHTML = '<span>' + file.percent + "%</span>";
				var prog = d.getElementsByTagName('div')[0];
				var progBar = prog.getElementsByTagName('div')[0]
				progBar.style.width = 2 * file.percent + 'px';
				progBar.setAttribute('aria-valuenow', file.percent);
			},

			FileUploaded: function(up, file, info) {
				if(info.status == 200) { //回调函数

					var fileName = get_uploaded_object_name(file.name);
				//	var pos = fileName.lastIndexOf(".");
				//	fileName = fileName.substr(0, pos) + '.mp4'

					document.getElementById(oldId).getElementsByTagName('b')[0].innerHTML = '上传成功'; //file.id
//					document.getElementById('containerImg1').src = host + fileName;
					if(callback) {
						console.log(fileName)
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
	uploader_video.init();
}

function aliUploadImg(uploadDomId,callback, upNum) {

	var multiSelection = false;

	if(upNum) {
		upNum = upNum;

		if(upNum > 1)
			multiSelection = true;
	}
	else
		upNum=1

	var d;
	var uploader_img = new plupload.Uploader({
		runtimes: 'html5,flash,silverlight,html4',
		browse_button: $("#"+uploadDomId+" #selectfiles2")[0],
		multi_selection: multiSelection, //限制单张上传
		container: $("#"+uploadDomId+" #container2")[0],
		flash_swf_url: './Moxie.swf',
		silverlight_xap_url: './Moxie.xap',
		url: 'http://oss.aliyuncs.com',
		filters: {
			mime_types: [ //只允许上传图片
				{
					title: "Image files",
					extensions: "jpg,png,bmp"
				},
			],
			prevent_duplicates: false //不允许选取重复文件
		},
		init: {
			PostInit: function() {
				$("#"+uploadDomId+" #ossfile2")[0].innerHTML = '';
				$("#"+uploadDomId+" #postfiles2")[0].onclick = function() {
					set_upload_param(uploader_img, '', false);
					return false;
				};
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
				var  addFiles=$("#"+uploadDomId).find("div[name='aliFile']");
				
				var size = upNum -addFiles.length;

				plupload.each(files, function(file) {
					if(size <= 0) {
						
						// 先删除已添加的图片
						if(addFiles.length>0){
							
							addFiles[0].remove();
						}
						// 删除新上传的图片
						else{
							var fileId=uploader_img.files[0].id;
							
							if(fileId!=file.id){
								$("#"+uploadDomId+" #ossfile2")[0].removeChild(
										document.getElementById(fileId));
								
									uploader_img.files.splice(0, 1);
							}
						}
					}
					
					$("#"+uploadDomId+" #ossfile2").append( '<div name="aliFile" style="position:relative" id="' + file.id + '"><span>' + file.name + ' (' + plupload.formatSize(file.size) + ')</span><b></b>' +
						'<div class="progress"><div class="progress-bar" style="width: 0%"></div></div>' +
						'<img class="aliRemoveBtn" src="../STATIC/image/removeBtn.png" style="position:absolute;left:80px;top:0;width:20px" />' +
						'</div>');
					
					$("#"+file.id ).find(".aliRemoveBtn").click(function(){

						$("#"+file.id ).remove();
				
						uploader_img.removeFile(file.id);
						
					});

					size--;
				});
			},

			BeforeUpload: function(up, file) {
				
				check_object_radio();
				get_dirname_img();
				set_upload_param(up, file.name, true);
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

					var fileName = get_uploaded_object_name(file.name);

					document.getElementById(file.id).getElementsByTagName('b')[0].innerHTML = '上传成功'; //file.id
					//document.getElementById('containerImg2').src = "http://oss-cn-hangzhou.aliyuncs.com/culturecloud/" + fileName;

					var img = document.createElement("img");
					img.setAttribute("style", "max-height: 100px;max-width: 100px;");
					img.setAttribute("src", "http://oss-cn-hangzhou.aliyuncs.com/culturecloud/" + fileName);
					var br = document.createElement("br");
					document.getElementById(file.id).insertBefore(br, document.getElementById(file.id).childNodes.item(0))
					document.getElementById(file.id).insertBefore(img, document.getElementById(file.id).childNodes.item(0))

					if(callback) {
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
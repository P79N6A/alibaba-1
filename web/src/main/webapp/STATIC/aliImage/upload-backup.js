accessid = 'g71YwJtSB2zq8EgJ';
accesskey = '9PJFP214P7vt5SjFWnxBNwPxkoqYJr';
host = 'http://oss-cn-hangzhou.aliyuncs.com/culturecloud';
var oldId;
var upNum = 1; //上传限制，1为单张，2为多张

g_dirname = 'H5'
g_object_name = ''
g_object_name_type = ''
now = timestamp = Date.parse(new Date()) / 1000;

var policyText = {
	"expiration": "2020-01-01T12:00:00.000Z", //设置该Policy的失效时间，超过这个失效时间之后，就没有办法通过这个policy上传文件了
	"conditions": [
		["content-length-range", 0, 1048576000] // 设置上传文件的大小限制
	]
};

var policyBase64 = Base64.encode(JSON.stringify(policyText))
message = policyBase64
var bytes = Crypto.HMAC(Crypto.SHA1, message, accesskey, {
	asBytes: true
});
var signature = Crypto.util.bytesToBase64(bytes);

function check_object_radio() {
	var tt = document.getElementsByName('myradio');
	for(var i = 0; i < tt.length; i++) {
		if(tt[i].checked) {
			g_object_name_type = tt[i].value;
			break;
		}
	}
}

function get_dirname() {
	dir = 'H5' //document.getElementById("dirname").value;
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

function uploadtest(callback, upNum) {
	upNum = upNum;
	var d;
	var failesNum = 1;
	var uploader = new plupload.Uploader({
		runtimes: 'html5,flash,silverlight,html4',
		browse_button: 'selectfiles',
		//multi_selection: false,
		container: document.getElementById('container'),
		flash_swf_url: './Moxie.swf',
		silverlight_xap_url: './Moxie.xap',
		url: 'http://oss.aliyuncs.com',

		init: {
			PostInit: function() {
				document.getElementById('ossfile').innerHTML = '';
				document.getElementById('postfiles').onclick = function() {
					set_upload_param(uploader, '', false);
					return false;
				};
			},

			FilesAdded: function(up, files) {
				failesNum = files.length;

				//限制为单张上传
				if(failesNum > 1) {
					failesNum = 2;
					return;
				} else if(failesNum <= 1) {
					failesNum = 1;
				}
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
				get_dirname();
				set_upload_param(up, file.name, true);
			},

			UploadProgress: function(up, file) {
				//限制为单张上传
				if(failesNum > 1) {
					return;
				}

				d = document.getElementById(oldId);

				d.getElementsByTagName('b')[0].innerHTML = '<span>' + file.percent + "%</span>";
				var prog = d.getElementsByTagName('div')[0];
				var progBar = prog.getElementsByTagName('div')[0]
				progBar.style.width = 2 * file.percent + 'px';
				progBar.setAttribute('aria-valuenow', file.percent);
			},

			FileUploaded: function(up, file, info) {
				//限制为单张上传
				if(failesNum > 1) {
					return;
				}
				if(info.status == 200) { //回调函数

					var fileName = get_uploaded_object_name(file.name);

					document.getElementById(oldId).getElementsByTagName('b')[0].innerHTML = 'upload to oss success, object name:' + fileName; //file.id
					if(callback) {
						console.log(fileName)
						callback(up, file, fileName)
					}
				} else {
					document.getElementById(file.id).getElementsByTagName('b')[0].innerHTML = info.response;
				}
			},

			Error: function(up, err) {
				document.getElementById('console').appendChild(document.createTextNode("\nError xml:" + err.response));
			}
		}

	});
	failesNum = 1;
	uploader.init();
}
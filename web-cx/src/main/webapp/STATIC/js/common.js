/**
 * 公共的方法
 */
function checkForm(type) {
    //alert(type);
    var curLength = $("#" + type + "").val().length;
    if (curLength >= 200) {
        var num = $("#" + type + "").val().substr(0, 199);
        $("#" + type + "").val(num);
        //alert("超过字数限制，多出的字将被截断！" );
    }
    else {
        $("#textCount").text("剩余" + (199 - $("#" + type + "").val().length) + "字");
    }
}
function appendMsg(id, msg) {
    var html = '<span id="' + id + 'vPanel" class="error-msg">' + msg + '</span>';
    $('#' + id).append(html);
}
function removeMsg(id) {
    $('#' + id + 'vPanel').remove();
}
//javascript 验证电子邮箱的正确性
function is_email(value) {
    var pattern = /^[a-zA-Z0-9]+([\._\-]*[a-zA-Z0-9])*@([a-zA-Z0-9]+[-a-zA-Z0-9]*[a-zA-Z0-9]+\.){1,63}[a-zA-Z0-9]+$/;
    if (!pattern.test(value)) {
        return false;
    }
    return true;
}
//验证注册密码的正确性
function is_password(value) {
    var pattern = /^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,15}$/;
    if (!pattern.test(value)) {
        return false;
    }
    return true;
}
//验证用户输入手机号码是否符合规范
function is_mobile(phone) {
//	var isMobile=/^(?:13\d|15\d|18\d)\d{5}(\d{3}|\*{3})$/; //手机号码验证规则
    //var pattern =/^([0-9-]+)$/;   //验证手机号码之前所用
    var pattern = /^((\d{11})|^((\d{7,8})|(\d{4}|\d{3})-(\d{7,8})|(\d{4}|\d{3})-(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1})|(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1}))$)$/;
    //   var isPhone=/^((0\d{2,3})-)?(\d{7,8})(-(\d{3,}))?$/;  //座机验证规则
    if (!pattern.test(phone)) {
        return false;
    }
    else {
        return true;
    }
}

function checkTel(value) {
    var isPhone = /^([0-9]{3,4}-)?[0-9]{7,8}$/; //座机验证规则
    var isMob = /^((\+?86)|(\(\+86\)))?(13[012356789][0-9]{8}|15[012356789][0-9]{8}|18[02356789][0-9]{8}|147[0-9]{8}|1349[0-9]{7})$/;

    if (!isMob.test(value) && !isPhone.test(value)) {
        return false;
    }
    else {
        return true;
    }
}
/**
 * 判断场所文字介绍输入框
 */
function checkVenue() {
    var curLength = $("#venueRemark").val().length;
    if (curLength >= 200) {
        var num = $("#venueRemark").val().substr(0, 200);
        $("#venueRemark").val(num);
        //alert("超过字数限制，多出的字将被截断！" );
    }
    else {
        $("#textCount").text("剩余" + (999 - $("#venueRemark").val().length) + "字");
    }
}

function slideBanner() {
    /*鼠标移过，左右按钮显示*/
    jQuery(".in-ban").hover(function () {
        jQuery(this).find(".prev,.next").stop(true, true).fadeTo("show", 1)
    }, function () {
        jQuery(this).find(".prev,.next").fadeOut()
    });
    /*SuperSlide图片切换*/
    jQuery(".in-ban").slide({mainCell: ".in-banImg", effect: "fold", autoPlay: true, delayTime: 600, trigger: "click"});
}
function getAdvertByName(siteName, columnName) {
    $.post("../advert/getAdvertByName.do", {"siteName": siteName, "columnName": columnName}, function (data) {
        if (data != null && data.length > 0) {
            for (var i = 0; i < data.length; i++) {
                var advert = data[i];
                //alert(advert.advertPicUrl);
                var imgurl = advert.advertPicUrl;
                var fileName = new Array();
                fileName = imgurl.split("/");
                var imgc = fileName[fileName.length - 1];
                var filename2 = new Array();
                filename2 = imgc.split(".");
                $.ajax({
                    type: "post",
                    url: "../get/getFile.do?url=" + imgurl + "&width=" + 1200 + "&height=" + 500 + "",
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    cache: false,//缓存不存在此页面
                    async: true,//异步请求
                    success: function (date) {
                        if (date.data.length > 0) {
                            $("#advert").append("<li><a href='javascript:void(0)'><img  src='data:image/" + filename2[1] + ";base64," + date.data + "'style='width:1200px; height:500px;'/></a></li>");
                        }
                        else if (date.status == 63101) {
                            $("#advert").append("<li><img style='width:1200px; height:500px;' src='../STATIC/image/venues-ban1.jpg' id='userHeadImg'></li>");
                        }
                        else if (date.status == 10102) {
                            $("#advert").append("<li><img style='width:1200px; height:500px;' src='../STATIC/image/venues-ban1.jpg' id='userHeadImg'></li>");
                        }
                        slideBanner();
                    }
                });
            }
        }
    });
}


function getUserImgUrl(userHeadImgUrl){
    return getIndexImgUrl(getImgUrl(userHeadImgUrl), "_300_300");
}


function getImgUrl(imgurl) {
    //var staticServerUrl = "http://img1.wenhuayun.cn/";
    // var staticServerUrl = "http://localhost:8079/why/";
    // var staticServerUrl = "http://127.0.0.1:8080/static/";
	var staticServerUrl = "http://120.77.85.181:8000/";
    return staticServerUrl + imgurl;
}

function getJiaDingImgUrl(imgurl) {

    //开发环境
    //var staticServerUrl="http://192.168.41.161/";
    //测试环境
    var staticServerUrl = "http://img.whjd.cn/";
    //正式环境
    //var staticServerUrl="http://192.168.41.161/";
    return staticServerUrl + imgurl;
}

//判断图片是否存在
function CheckImgExists(imgurl) {
    var ImgObj = new Image();
    ImgObj.src = imgurl;
    //没有图片，则返回-1
    if (ImgObj.fileSize > 0 || (ImgObj.width > 0 && ImgObj.height > 0)) {
        return true;
    } else {
        return false;
    }
}


function getIndexImgUrl(imgUrl, size) {
    var pos = imgUrl.lastIndexOf(".");
    var imgUrlIndex = imgUrl.substr(0, pos) + size + imgUrl.substr(pos);
    return imgUrlIndex;
}

function fixImage(img, w, h) {
    var newImg = new Image(); //获得图片的原始尺寸
    newImg.src = img.src;
    var lh;  //用于保存img.height，IE下隐藏的图片读取不到，需currentStyle解决
    if (newImg.width / newImg.height >= w / h) {
        if (newImg.width > w) {
            img.width = w;
            img.height = w * newImg.height / newImg.width;
            lh = window.ActiveXObject ? parseInt(img.currentStyle['height']) : img.height;
            //img.style.marginTop = (h - lh)/2 + 'px';  //顺手垂直居中
        } else {
            img.width = newImg.width;
            img.height = newImg.height;
            lh = window.ActiveXObject ? parseInt(img.currentStyle['height']) : img.height;
            //img.style.marginTop = (h - lh)/2 + 'px';  //顺手垂直居中
        }
    } else {
        if (newImg.height > h) {
            img.height = h;
            img.width = newImg.width * h / newImg.height;
        } else {
            img.width = newImg.width;
            img.height = newImg.height;
        }
    }
}

$(function () {
    if (/msie/.test(navigator.userAgent.toLowerCase())) {
        $('textarea[maxlength]').on('keyup blur', function () {
            // Store the maxlength and value of the field.
            var maxlength = $(this).attr('maxlength');
            var val = $(this).val();

            // Trim the field if it has content over the maxlength.
            if (val.length > maxlength) {
                $(this).val(val.slice(0, maxlength));
            }
        });
    }
});

function getChinaServerUrl() {
    return "http://localhost:8081/why/";
}


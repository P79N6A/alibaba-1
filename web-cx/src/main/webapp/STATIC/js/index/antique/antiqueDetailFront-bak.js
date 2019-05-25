
$(document).ready(function(){
    //loadVoice();
    loadAntiqueImg();
    loadAntiqueListPics();
    //选中当前label
    $('#venueListLabel').addClass('cur').siblings().removeClass('cur');
});

function dynamicMp3(){
    loadVoice();
    setTimeout(function(){
        $(".play-pause .play").click();
    },1000);
}

function loadVoice(){
    var audioSrc = $("#venueVoiceUrl").val();
    if(audioSrc != undefined && audioSrc != ""){
        var voiceUrl = getImgUrl(audioSrc);
        $("#audioPlay").attr("src", voiceUrl);
    }
    audiojs.events.ready(function() {
        audiojs.createAll();
    });
}

/**
* 馆藏详情页
* @param venueId
*/
function antiqueDetail(antiqueId){
    $("#antiqueId").val(antiqueId);
    $("#antiqueDetailForm").submit();
}

//获取列表元素中所包含的图片
function loadAntiqueListPics(){
    //请求页面下方团体所有图片
    $("#antique-list-div li").each(function (index, item) {
        var imgUrl = $(this).attr("data-id");
        imgUrl = getIndexImgUrl(getImgUrl(imgUrl),"_300_300");
        $(item).find("img").attr("src", imgUrl);
    });
}

/**
 * 加载音频文件
 */
/*function loadVoice(){
    var audioSrc = $("#antiqueVoiceUrl").val();
    if(audioSrc != null && audioSrc != ''){
        $.ajax({
            type: "post",
            url: "../get/getAudio.do?url="+audioSrc,
            dataType: "json",
            contentType: "application/json;charset=utf-8",
            cache:false,//缓存不存在此页面
            async: true,//异步请求
            success: function (data) {
                if(data.data.length>0){
                    $("#audioPlay").attr("src", "data:audio/mp3;base64," + data.data);
                }
            }
        });
    }

    audiojs.events.ready(function() {
        audiojs.createAll();
    });
}*/


//获取场馆详情图片
function loadAntiqueImg(){
    var imgUrl = $("#antiqueImg").attr("data-id");
    //imgUrl = getImgUrl(imgUrl);
    imgUrl=getIndexImgUrl(getImgUrl(imgUrl),"_750_500");
    $("#antiqueImg").attr("src", imgUrl);
}

//判断用户是否收藏了该条内容
$(function () {
    var antiqueId = $("#antiqueId").val();
    $.ajax({
        type: 'POST',
        dataType : "json",
        url: "../collect/isHadCollect.do?relateId="+antiqueId+"&type=3",//请求的action路径
        error: function () {//请求失败处理函数
        },
        success:function(data){ //请求成功后处理函数。
            if (data > 0) {
                $("#zanId").attr("class","zan love");
            }
        }
    });

    $.ajax({
        type: 'POST',
        dataType : "json",
        url: "../collect/getHotNum.do?relateId="+antiqueId+"&type=3",//请求的action路径
        error: function () {//请求失败处理函数
        },
        success:function(data){ //请求成功后处理函数。
            $("#likeCount").html(data);
        }
    });
});

//点击收藏
function changeClass() {

  if($("#isLogin").val() == 1){
    var antiqueId = $("#antiqueId").val();
    //判断是收藏还是取消 收藏
            if ($("#zanId").attr("class") == 'zan love') {
                $.ajax({
                    type: 'POST',
                    dataType: "json",
                    url: "../collect/deleteUserCollect.do?relateId=" + antiqueId + "&type=3",//请求的action路径
                    error: function () {//请求失败处理函数
                    },
                    success: function (data) { //请求成功后处理函数。
                        $("#likeCount").html(data);
                    }
                });
                $("#zanId").attr("class", "zan");
            } else {
                $.ajax({
                    type: 'POST',
                    dataType: "json",
                    url: "../cmsTypeUser/antiqueSave.do?antiqueId=" + antiqueId + "&operateType=3",//请求的action路径
                    error: function () {//请求失败处理函数
                    },
                    success: function (data) { //请求成功后处理函数。
                        $("#likeCount").html(data);
                    }
                });
                $("#zanId").attr("class", "zan love");
            }
    }else{
        dialogAlert("提示","登录之后才能收藏");
        return;
    }

}



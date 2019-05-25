
$(document).ready(function(){
    //选中当前label
    $('#venueLabel').addClass('cur').siblings().removeClass('cur');

    loadVoice();
    loadAntiqueImg();
    loadAntiqueList();
});


/**
 * 加载音频文件
 */
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
                    $("#zanId").addClass("love");
                }
            }
        });

        $.ajax({
            type: 'POST',
            dataType : "json",
            url: "../collect/getHotNum.do?relateId="+antiqueId+"&type=3",//请求的action路径
            error: function () {//请求失败处理函数
                $("#likeCount").html("0");
                $("#zanId").html(data);
            },
            success:function(data){ //请求成功后处理函数。
                $("#likeCount").html(data);
                $("#zanId").html(data);
            }
        });
    });

//点击收藏
    function changeClass() {

        if($("#isLogin").val() == 1){
            var antiqueId = $("#antiqueId").val();
            //判断是收藏还是取消 收藏
            if ($("#zanId").hasClass("love")) {
                $.ajax({
                    type: 'POST',
                    dataType: "json",
                    url: "../collect/deleteUserCollect.do?relateId=" + antiqueId + "&type=3",//请求的action路径
                    error: function () {//请求失败处理函数
                    },
                    success: function (data) { //请求成功后处理函数。
                        $("#likeCount").html(data);
                        $("#zanId").html(data);
                    }
                });
                $("#zanId").removeClass("love");
            } else {
                $.ajax({
                    type: 'POST',
                    dataType: "json",
                    url: "../cmsTypeUser/antiqueSave.do?antiqueId=" + antiqueId + "&operateType=3",//请求的action路径
                    error: function () {//请求失败处理函数
                    },
                    success: function (data) { //请求成功后处理函数。
                        $("#likeCount").html(data);
                        $("#zanId").html(data);
                    }
                });
                $("#zanId").addClass("love");
            }
        }else{
            dialogAlert("提示","登录之后才能收藏");
            return;
        }
    }

    /**
     * 加载推荐馆藏列表
     */
    function loadAntiqueList(){
        var antiqueId = $("#antiqueId").val();
        var data = {"antiqueId":antiqueId};
        $.post("../frontAntique/relatedAntiqueList.do",data ,
            function(data) {
                var antiqueHtml = "";
                if(data != null && data != ""){
                    for(var i=0; i<data.length; i++){
                        var antique = data[i];
                        var antiqueImgUrl = antique.antiqueImgUrl;
                        var antiqueName = antique.antiqueName;
                        var antiqueId = antique.antiqueId;

                        antiqueHtml = antiqueHtml + "<li data-id='"+antiqueImgUrl+"'>"+
                        "<a href='javascript:;' class='img' onclick=antiqueDetail('"+antiqueId+"')><img src='../STATIC/image/collection-img2.jpg' alt='' width='135' height='100'/></a>"+
                        "<h4><a href='javascript:;' onclick=antiqueDetail('"+antiqueId+"')>"+antiqueName+"</a></h4>"+
                        "</li>";
                    }
                }
                if(antiqueHtml == ""){
                    $("#antique-list-div").attr("style","display:none;");
                }else{
                    $("#antique-list-div ul").html(antiqueHtml);
                    var venueId = $("#venueId").val();
                    $("#antique-list-div ul").after("<a href='../frontAntique/antiqueList.do?venueId=" + venueId + "' class='load-more'>查看更多></a>");
                }
                loadAntiqueListPics();
            });
    }
$(function(){
    getTerminalUserHeadImg();
    // 活动列表
    // 文本框失去焦点时查询活动
    $("#keyword").blur(function(){
        //getActivityList();
    });
});



// 获取用户头像
function getTerminalUserHeadImg(){
    var imgUrl = $("#userHeadImgUrl").attr("data-user-picture");
    var fileName=new Array();
    fileName=imgUrl.split("/");
    var imgc=fileName[fileName.length-1];
    var filename2=new Array();
    filename2 = imgc.split(".");
    $.ajax({
        type: "post",
        url: "../get/getFile.do?url="+imgUrl+"&width=140&height=140",
        dataType: "json",
        contentType: "application/json;charset=utf-8",
        cache:false,//缓存不存在此页面
        async: true,//异步请求
        success: function (date) {
            if(date.data.length>0){
                $("#userHeadImgUrl").find("img").attr("src", "data:image/"+filename2[1]+";base64,"+date.data);
            }
        }
    });
}

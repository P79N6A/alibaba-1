$(function(){
    //初始化获取图片
    getImg();
});
//编辑后获取图片
getImg=function(){
    var imgUrl=$("#antiqueImgUrl").val();
    imgUrl= getImgUrl(imgUrl);
    $("#imgShow").html("<img  src='"+ imgUrl +"' width='100' height='120'>");
};
/*
$(function(){
    //初始化获取图片
    getImg();
});
//编辑后获取图片
getImg=function(){
    var imgUrl=$("#antiqueImgUrl").val();
    var fileName=new Array();
    fileName=imgUrl.split("/");
    var imgc=fileName[fileName.length-1];
    var filename2=new Array();
    filename2 = imgc.split(".");
    $.ajax({
        type: "post",
        url: "../get/getFile.do?url="+imgUrl+"&width=100&height=100",
        dataType: "json",
        contentType: "application/json;charset=utf-8",
        cache:false,//缓存不存在此页面
        async: true,//异步请求
        success: function (date) {
            if(date.data.length>0){
                $("#imgHeadPrev").html("<img  src='data:image/"+filename2[1]+";base64,"+date.data+"'>");
            }
            else if(date.status==63101){
                $("#imgHeadPrev").html("<img src='../STATIC/image/defaultImg.png' id='userHeadImg'>");
            }

            else if(date.status==10102){
                $("#imgHeadPrev").html("<img  src='../STATIC/image/defaultImg.png' id='userHeadImg'>");
            }
        }
    });
};*/

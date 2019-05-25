$(function(){
    //初始化获取图片
    saveHeadImg();
});
//编辑后获取图片
saveHeadImg=function(){
    var imgUrl=$("#headImgUrl").val();
    imgUrl = getImgUrl(imgUrl);
    $("#imgHeadPrev").html("<img  src='"+imgUrl+"'>");
};
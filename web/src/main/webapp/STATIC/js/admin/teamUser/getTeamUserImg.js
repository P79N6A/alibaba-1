$(function(){
    //初始化获取图片
    getImg();
});
//编辑后获取图片
getImg=function(){
    var imgUrl=$("#tuserPicture").val();
    imgUrl = getImgUrl(imgUrl);
    $("#imgHeadPrev").html("<img  src='"+imgUrl+"'>");
};
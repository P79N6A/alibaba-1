$(function(){
    //初始化获取图片
    getImg();
});
//编辑后获取图片
getImg=function(){
    var imgUrl=$("#activityIconUrl").val();
    imgUrl= getImgUrl(imgUrl);
    $("#imgShow").html("<img  src='"+ imgUrl +"' width='100' height='120'>");
};
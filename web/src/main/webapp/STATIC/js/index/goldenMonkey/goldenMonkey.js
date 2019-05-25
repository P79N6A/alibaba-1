$(function(){
    showIndex();
});


// 获取年俗文化前三条记录
function showIndex(){
    $("#annualCustomDiv").load("../goldenMonkey/annualCustomIndex.do #annualCustomDivChild",null,function(){
        getGoldenMonkeyPicture("#annualCustomDivChild li");
    });

    $("#tuanyanDiv").load("../goldenMonkey/tuanYuanindex.do #tuanyanDivChild", null, function(){
        getTuanYuanPicture();
    });

    $("#paperCutDiv").load("../goldenMonkey/paperCutIndex.do #paperCutDivChild", null, function(){
        getGoldenMonkeyPicture("#paperCutDivChild li");
    });
}


function getGoldenMonkeyPicture(emlmentID){
    $(emlmentID).each(function (index, item) {
        var imgUrl = $(this).attr("data-url");
        if(imgUrl != undefined && imgUrl != "" && imgUrl != null) {
            $(item).find("img").attr("src", getIndexImgUrl(getImgUrl(imgUrl),"_300_300"));
        }else{
            $(item).find("img").attr("src", "../STATIC/image/default.jpg");
        }
    });
}

function getTuanYuanPicture(){

    $("#tuanyanUrl Img").each(function(index,item){
        var imgUrl = getImgUrl($(this).attr("data-url"));
        imgUrl = getIndexImgUrl(imgUrl,"_300_300")
        if(imgUrl != '' || userHeadImgUrl != undefined || userHeadImgUrl != null){
            $(this).attr("src",imgUrl);
        }else{
            $(this).attr("src",'../STATIC/image/default.jpg');
        }
    });

}






/**
 * 加载更多评论
 */
function loadMoreComment(){
    var tuserId = $("#tuserId").val();
    var pageNum = parseInt($("#commentPageNum").val())+1;
    $("#commentPageNum").val(pageNum)
    var activityId = $("#commentRkId").val();
    var rdata = {"tuserId":tuserId,"commentType" : 2,"commentRkId" :activityId, "pageNum" :pageNum};
    $.post("../frontActivity/commentList.do",rdata ,
        function(data) {
            var commentHtml = "";
            if(data != null && data != ""){
                for(var i=0; i<data.length; i++){
                    var comment = data[i];
                    var commentRemark = comment.commentRemark.replace(/</g,'&lt;').replace(/>/g,'&gt;');
                    var commentTime = comment.commentTime.substring(0,16);
                    var commentUserName = comment.commentUserName;
                    var userHeadImgUrl = comment.userHeadImgUrl;
                    var commentImgUrl = comment.commentImgUrl;
                    var userSex = comment.userSex;

                    if(userHeadImgUrl != null && userHeadImgUrl !="") {
                        if(userHeadImgUrl.indexOf("http")==-1){
                            userHeadImgUrl = getUserImgUrl(userHeadImgUrl);
                        }
                    }else{
                        if(userSex == 1){
                            userHeadImgUrl = "../STATIC/image/face_boy.png";
                        }else if(userSex == 2){
                            userHeadImgUrl = "../STATIC/image/face_girl.png";
                        }else{
                            userHeadImgUrl = "../STATIC/image/face_secrecy.png";
                        }
                    }
                    var imgUrl = getCommentImgUrl(commentImgUrl);
                    commentHtml = commentHtml + "<li><a class='img fl'><img src='"+userHeadImgUrl+"' width='50' height='50'/></a>" +
                    "<div class='info fr'><h4><a>"+commentUserName+"</a><em>"+commentTime+"</em></h4>"+""+"<p>"+commentRemark+"</p>"+imgUrl+"</div></li>";
                }
            }else{
                $("#moreComment").removeAttr("onclick");
                $("#moreComment").html("没有更多了!");
                return;
            }
            $("#comment-list-div ul").append(commentHtml);
            //starts(".comment-list .start",18);

            //loadCommentListPics();
        });
}


function getUserImgUrl(userHeadImgUrl){
    return getIndexImgUrl(getImgUrl(userHeadImgUrl), "_300_300");
}



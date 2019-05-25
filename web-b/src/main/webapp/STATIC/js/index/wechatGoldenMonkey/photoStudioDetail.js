$(function(){
    showTwoImg();
    showAllImg();
    loadCommentList();
    showUserHeadImg();
});

// 显示用户头像，未登陆显示默认
function showUserHeadImg(){
    var userHeadImg = $("#userHeadImg").val();
    if(userHeadImg == undefined || userHeadImg == null || userHeadImg == ""){
        $("#userImg").find("img").attr("src", "../STATIC/image/face_secrecy.png");
        return;
    }
    $("#userImg").find("img").attr("src", getUserImgUrl(userHeadImg));
}

// 显示两张图片
function showTwoImg(){
    $("#phoneUl a").each(function(index,item){
        var url = $(item).attr("data-url");
        if(url != undefined && url != null && url != ""){
            $(item).find("img").attr("src", getImgUrl(url));
        }
    });
}

// 显示全部图片
function showAllImg(){
    $("#detailImg a").each(function(index,item){
        var url = $(item).attr("data-url");
        if(url != undefined && url != null && url != ""){
            $(item).find("img").attr("src", getImgUrl(url));
        }
    });
}

//点击收藏
function changeClass(){
    var isLogin = $("#isLogin").val();
    if(isLogin != "Y"){
        dialogAlert("提示","登录之后才能收藏");
        return;
    }

    var loveUserId = $("#userId").val();
    $.ajax({
        type:"post",
        url:"../mcShow/addLove.do",
        data:{userId:loveUserId,showId:$("#showId").val()},
        dataType: "text",
        cache:false,//缓存不存在此页面
        async: false,//异步请求
        success: function (data) {
            if("success" == data){
                dialogAlert("提示","点赞成功");
                $("#zanId").addClass("in-zaned")
            }else if("repeat" == data){
                dialogAlert("提示","已点过赞");
            }else{
                dialogAlert("提示","点赞失败");
            }

        }

    });
}

// 添加评论
function addComment(){
    var isLogin = $("#isLogin").val();
    if(isLogin != "Y") {
        dialogAlert("评论提示", "登录之后才能评论");
        return;
    }

    var status = $("#commentStatus").val();
    if(parseInt(status) == 2){
        dialogAlert("评论提示", "您的账户已被禁止评论，没有评论权限");
        return;
    }

    var commentRemark = $("#commentRemark").val();
    if(commentRemark == undefined || $.trim(commentRemark) == ""){
        dialogAlert("评论提示", "输入评论内容");
        return;
    }

    $.ajax({
        type:"post",
        url:"../mc/addComment.do",
        data:{commentUserId:$("#userId").val(),commentRkId:$("#showId").val(),commentRemark:$("#commentRemark").val(),commentType:10},
        dataType: "json",
        cache:false,//缓存不存在此页面
        async: false,//异步请求
        success: function (result) {
            if(result == "success"){
                $("#commentRemark").val("");
                dialogAlert("提示", "评论成功!");
                loadCommentList();
            }else if(result == "exceedNumber"){
                dialogAlert("提示", "当天评论次数最多一次!");
            }else if(result == "sensitiveWordsExist"){
                dialogAlert("评论提示","评论内容有敏感词，不能评论!");
            }else{
                dialogAlert("提示","评论失败，请重试!");
            }
        }
    });
}

/**
 * 加载推荐评论列表
 */
function loadCommentList(){
    var showId = $("#showId").val();
    $.post("../mc/commentList.do",{"commentType" : 10,"commentRkId" :showId} ,
        function(data) {
            var commentHtml = "";
            if(data != null && data != ""){
                for(var i=0; i<data.length; i++){
                    var comment = data[i];
                    var commentRemark = comment.commentRemark.replace(/</g,'&lt;').replace(/>/g,'&gt;');
                    var commentTime = comment.commentTime.substring(0,16);
                    var commentUserName = comment.commentUserName;
                    var userHeadImgUrl = comment.userHeadImgUrl;
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
                    commentHtml = commentHtml + "<li><a class='img'><img src='"+userHeadImgUrl+"' width='60' height='60'></a>"+
                    "<div class='info'><div class='tit clearfix'><h3>"+commentUserName+"</h3><span>"+commentTime+"</span></div>"+
                    "<p>"+commentRemark+"</p></div></li>";
                }
                //当评论大于10条时，显示 更多... 按钮
                /*if(data.length==10){
                 $("#moreComment").show();
                 };*/
            }else{
                //$("#moreComment").hide();
            }

            $("#commentUl").html(commentHtml);
            //loadCommentListPics();
        });
}

// 得到评论用户图片
function getUserImgUrl(userHeadImgUrl){
    return getIndexImgUrl(getImgUrl(userHeadImgUrl), "_300_300");
}
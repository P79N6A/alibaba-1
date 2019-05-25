
$(function(){
    loadCommentList();
});

/**
 * 加载推荐评论列表
 */
function loadCommentList(){
    $("#comment-list-div ul").html();
    var tuserId = $("#tuserId").val();
    var data = {tuserId:tuserId};
    $.post("../frontTeamUser/commentList.do",data ,
        function(data) {
            var commentHtml = "";
            if(data != null && data != ""){
                $("#moreComment").show();
                for(var i=0; i<data.length; i++){
                    var comment = data[i];
                    var commentRemark = comment.commentRemark.replace(/</g,'&lt;').replace(/>/g,'&gt;');
                    var commentTime = comment.commentTime.substring(0,16);
                    var commentUserName = comment.commentUserName;
                    var userHeadImgUrl = comment.userHeadImgUrl;
                    commentHtml = commentHtml + "<li data-id='"+userHeadImgUrl+"'>"+
                    "<a href='javascript:;' class='img fl'><img width='50' height='50'/></a>"+
                    "<div class='info fr'>"+
                    "<h4><a href='javascript:;'>"+commentUserName+"</a><em>"+commentTime+"</em></h4>"+
                    "<p>"+commentRemark+"</p>"+
                    "</div>"+
                    "</li>";
                }
            }else{
                $("#moreComment").hide();
            }
            $("#comment-list-div ul").html(commentHtml);
            loadCommentListPics();
        });
}

// 评论会员头像
function loadCommentListPics() {
    //请求页面下方团体所有图片
    $("#comment-list-div li").each(function (index, item) {
        var imgUrl = $(this).attr("data-id");
        imgUrl = getImgUrl(imgUrl);
        imgUrl = getIndexImgUrl(imgUrl, "_300_300");
        $(item).find("img").attr("src", imgUrl);
    });
}

/**
 * 加载更多评论
 */
function loadMoreComment(){
    var tuserId = $("#tuserId").val();
    var pageNum = parseInt($("#commentPageNum").val())+1;
    $("#commentPageNum").val(pageNum)
    var data = {"tuserId":tuserId,"pageNum":pageNum};
    $.post("../frontTeamUser/commentList.do",data ,
        function(data) {
            var commentHtml = "";
            if(data != null && data != ""){
                for(var i=0; i<data.length; i++){
                    var comment = data[i];
                    var commentRemark = comment.commentRemark.replace(/</g,'&lt;').replace(/>/g,'&gt;');
                    var commentTime = comment.commentTime.substring(0,16);
                    var commentUserName = comment.commentUserName;
                    var userHeadImgUrl = comment.userHeadImgUrl;

                    commentHtml = commentHtml + "<li data-id='"+userHeadImgUrl+"'>"+
                    "<a href='javascript:;' class='img fl'><img src='../STATIC/image/portrait-img1.jpg' alt='' width='50' height='50'/></a>"+
                    "<div class='info fr'>"+
                    "<h4><a href='javascript:;'>"+commentUserName+"</a><em>"+commentTime+"</em></h4>"+
                    "<p>"+commentRemark+"</p>"+
                    "</div>"+
                    "</li>";
                }
            }else{
                $("#moreComment").removeAttr("onclick");
                $("#moreComment").html("没有更多了!");
            }
            $("#comment-list-div ul").append(commentHtml);
            loadCommentListPics();
        });
}


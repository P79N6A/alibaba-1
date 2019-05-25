
$(function(){
    loadCommentList();
});

/**
 * 加载推荐评论列表
 */
function loadCommentList(){
    $("#comment-list-div ul").html();
    var tuserId = $("#tuserId").val();
    var activityId = $("#commentRkId").val();
    var data = {"tuserId":tuserId,"commentType" : 10,"commentRkId" :activityId};
    $.post("/frontActivity/commentList.do",data ,
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

/*                    var comStar =comment.commentStar;
                    var starStr = "";
                    if(comStar){
                        starStr='<div class="start" tip="'+comStar+'"><p></p></div>';
                    }*/

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
                    commentHtml = commentHtml + "<li><a class='img fl'><img src='"+userHeadImgUrl+"' width='60' height='60'/></a>" +
                    "<div class='info fr'><h4><a>"+commentUserName+"</a><em>"+commentTime+"</em></h4>"+""+"<p>"+commentRemark+"</p>"+imgUrl+"</div></li>";
                }
                //当评论大于10条时，显示 更多... 按钮
                 if(data.length==10){
                    $("#moreComment").show();
                };
            }else{
                $("#moreComment").hide();
            }
            $("#comment-list-div ul").html(commentHtml);
            //loadCommentListPics();
        }).success(function () {
            var localUrl = top.location.href;
            var divActivityComment = document.getElementById("divActivityComment");
            if(localUrl.indexOf("collect_info.jsp") == -1){
                $("#divActivityComment").show();
                //starts(".comment-list .start",18);
            }else{
                $("#divActivityComment").css('display','none');
                $("#divActivityComment").html("");
                $("#divActivityComment").hide();
            }
        });
}

function getUserImgUrl(userHeadImgUrl){
    return getIndexImgUrl(getImgUrl(userHeadImgUrl), "_300_300");
}

function getCommentImgUrl(commentImgUrl){
    if(commentImgUrl == undefined || commentImgUrl == "" || commentImgUrl == null){
        return "";
    }
    var allUrl = commentImgUrl.split(";");
    var imgDiv = "<div class='wk'><div class='pld_img_list'>";
    for(var i=0;i<allUrl.length;i++){
        if(allUrl[i] == undefined || allUrl[i] == "" || allUrl[i] == null){
            continue;
        }
        commentImgUrl = getImgUrl(allUrl[i]);
        commentImgUrl = getIndexImgUrl(commentImgUrl, "_300_300");
        imgDiv = imgDiv + "<div class='pld_img fl'><img src='"+commentImgUrl+"' onload='fixImage(this, 75, 50)'/></div>";
    }
    imgDiv = imgDiv + "</div><div class='after_img'><div class='do'><a href='javascript:void(0)' class='shouqi'>" +
    "<span><img src='../STATIC/image/shouqi.png' width='8' height='11' /></span>收起</a><a href='#' target='_blank' class='yuantu'>" +
    "<span><img src='../STATIC/image/fangda.png' width='11' height='11'/></span>原图</a></div><img src='' class='fd_img'/></div></div>";
    return imgDiv;
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
    $.post("/frontActivity/commentList.do",rdata ,
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

/*                    var comStar =comment.commentStar;
                    var starStr = "";
                    if(comStar){
                        starStr='<div class="start" tip="'+comStar+'"><p></p></div>';
                    }*/
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



//加载视频
$(function () {
    var activityVideoURL = $("#activityVideoURL").val();
    if (activityVideoURL != undefined && activityVideoURL != '') {
        var cultureVediourl = activityVideoURL;
        if(cultureVediourl != undefined && cultureVediourl != ""){
            if(cultureVediourl.indexOf(".swf") == -1){
                var flashvars={
                    f:cultureVediourl,
                    b:1
                };
                var params={bgcolor:'#FFF',allowFullScreen:true,allowScriptAccess:'always',wmode:'transparent'};
                var video=[cultureVediourl + '->video/mp4'];
                CKobject.embed('/STATIC/js/ckplayer/ckplayer.swf','vedioDiv','ckplayer_a1','320','220',false,flashvars,video,params);
            }else{
                var htmlStr = '<embed src="'+ cultureVediourl +'" quality="high" width="320" height="220 align="middle" allowScriptAccess="always" allowFullScreen="true" wmode="transparent" type="application/x-shockwave-flash"></embed>';
                $("#vedioDiv").html(htmlStr);
            }
        }
    }
    /* var flashvars={
     f:activityVideoURL,
     b:1
     };
     var params={bgcolor:'#FFF',allowFullScreen:true,allowScriptAccess:'always',wmode:'transparent'};
     var video=[activityVideoURL + '->video/mp4'];
     CKobject.embed('../STATIC/js/ckplayer/ckplayer.swf','videoURL','ckplayer_a1','400','400',false,flashvars,video,params);
     }*/
});



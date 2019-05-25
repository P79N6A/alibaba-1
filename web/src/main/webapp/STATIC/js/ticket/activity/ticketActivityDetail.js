/**
 * Created by yujinbing on 2015/12/24.
 */



var userId = $("#userId").val();


    //得到喜欢的人数
$(function () {
    var activityId = $("#activityId").val();
    $.ajax({
        type: 'POST',
        dataType : "json",
        url: "../collect/isHadCollect.do?relateId="+activityId+"&type=2",//请求的action路径
        error: function () {//请求失败处理函数
        },
        success:function(data){ //请求成功后处理函数。
            if (data > 0) {
                $("#zan-btn").addClass("love");
            }
        }
    });

    $.ajax({
        type: 'POST',
        dataType : "json",
        url: "../collect/getHotNum.do?relateId="+ activityId+"&type=2",//请求的action路径
        error: function () {//请求失败处理函数
            $("#likeCount").html("0");
            $("#zan-btn").html(data);
        },
        success:function(data){ //请求成功后处理函数。
            $("#likeCount").html(data);
            $("#zan-btn").html(data);
        }
    });
});

//点击收藏
function changeClass(){
    if($("#isLogin").val() == 1){
        var activityId = $("#activityId").val();
        //判断是收藏还是取消 收藏
        if($("#zan-btn").hasClass("love")) {
            alert("delete");
            $.ajax({
                type: 'POST',
                dataType : "json",
                url: "../collect/deleteUserCollect.do?relateId="+activityId+"&type=2",//请求的action路径
                error: function () {//请求失败处理函数
                },
                success:function(data){ //请求成功后处理函数。
                    $("#likeCount").html(data);
                    $("#zan-btn").html(data);
                }
            });
            $("#zan-btn").removeClass("love");
        }else {
            alert("save");
            $.ajax({
                type: 'POST',
                dataType : "json",
                url: "../cmsTypeUser/activitySave.do?activityId="+activityId+"&operateType=3",//请求的action路径
                error: function () {//请求失败处理函数
                },
                success:function(data){ //请求成功后处理函数。
                    $("#likeCount").html(data);
                    $("#zan-btn").html(data);
                }
            });
            /*$("#zan-btn").addClass("love");*/
            $("#zan-btn").addClass("love");
        }
    }else{
        dialogAlert("提示","登录之后才能收藏");
        return;
    }
}

//用户头像
function getHeadImg(url){
    var imgUrl = getImgUrl(url);
    imgUrl=getIndexImgUrl(imgUrl,"_300_300");
    $("#imgHeadPrev").append("<div class='sc_img fl' data-url='"+url+"'><img onload='fixImage(this, 100, 100)' src='"+imgUrl+"'><a href='javascript:;'></a></div>");
    $("#btnContainer").hide();
    $("#fileContainer").hide();
}


function loadWantGo(){
    var page = $("#page").val();	//分页数
    var activityId = $("#activityId").val();
    //我想去列表加载
    $("#go_head").load("../frontActivity/frontWantGoListLoad.do?page="+page+"&activityId=" + activityId+ "&userId=" + userId,function(){
        //分页
        kkpager.generPageHtml({
            pno :$("#pages").val() ,
            //总页码
            total :$("#countpage").val(),
            //总数据条数
            totalRecords :$("#total").val(),
            mode : 'click',
            isShowFirstPageBtn : false,
            isShowLastPageBtn : false,
            isShowTotalPage : false,
            click : function(n){
                this.selectPage(n);
                $("#page").val(n);
                loadWantGo();
                return false;
            }
        });
    });
}


//统计数据
$(function () {
    var activityId = $("#activityId").val();
    //默认选中当前label
    $('#activityLabel').addClass('cur').siblings().removeClass('cur');
    $.ajax({
        type: 'POST',
        dataType : "json",
        url: "../cmsTypeUser/activitySave.do?activityId=" + activityId +"&operateType=1",//请求的action路径
        error: function () {//请求失败处理函数
        },
        success:function(data){ //请求成功后处理函数。
        }
    });
});


//异步加载图片
$(function () {
    $("#allInfo li").each(function (index, item) {
        var imgUrl = $(this).attr("activity-icon-url");
        if(imgUrl==undefined||imgUrl==""){
            $(item).find("img").attr("src", "../STATIC/image/default.jpg");
        }else{
            imgUrl=getIndexImgUrl(getImgUrl(imgUrl),"_300_300");
            $(item).find("img").attr("src", imgUrl);
        }
    });

    //异步加载附件
    var attachmentUrl = $(".download_fj").attr("activityAttachment");
    if(attachmentUrl!=null&&attachmentUrl!=""){
        var attachments = attachmentUrl.split(",");
        for(var i=0;i<attachments.length;i++){
            attachmentUrl=getImgUrl(attachments[i]);
            $(".download_fj").append("<a href='"+attachmentUrl+"'>下载附件"+(i+1)+"</a><br/>");
        }
    }

    //选中当前label
    $('#activityListLabel').addClass('cur').siblings().removeClass('cur');
});


//标签
$(function() {
    var activityId = $("#activityId").val();
    $.post("../frontActivity/queryActivityLabelById.do?activityId=" + activityId, function(data) {
        var list = eval(data);
        var tagHtml = '';
        var otherHtml = '';
        var tagIds = $("#tagIds").val();
        var ids = '';
        if (tagIds.length > 0) {
            ids = tagIds.substring(0, tagIds.length - 1).split(",");
        }

        for (var i = 0; i < list.length; i++) {
            var result = false;
            if (ids != '') {

                for (var j = 0; j <ids.length; j++) {
                    if (list[i].tagId == ids[j]) {
                        result = true;
                        break;
                    }
                }
            }
            var cl = '';
            if (result) {
                cl = 'class="cur"';
            }

            if(list[i].tagName == '其他'){
                otherHtml = '<a' + cl + ' onclick="setTag(\''
                + list[i].tagId + '\')">' + list[i].tagName
                + '</a>';
                continue;
            }
            tagHtml += '<a' + cl + ' onclick="setTag(\''
            + list[i].tagId + '\')">' + list[i].tagName
            + '</a>';
        }
        $("#tag").html(tagHtml+otherHtml);
    });
});


//预定
function bookActivity(activityId) {
    var activityId = $("#activityId").val();
    var userId = $("#userId").val();
    if( userId == null || userId == ""){
        dialogAlert("提示","登录之后才能预订");
        return;
    }
    location.href= "../ticketActivity/ticketActivityBook.do?activityId=" + activityId;
}
//关闭遮罩层
function closeOverDiv(){
    $(".overDiv").hide();
}
//扫码预定
function bookActivityPic(bashPath, activityId) {
    debugger
    var needPath = bashPath+'ticketActivity/ticketActivityBookPic.do?needPath='+bashPath+'/wechatActivity/preActivityDetail.do?activityId=';
    $("#pic").attr("src",needPath+activityId);
    //显示遮罩层
    $(".overDiv").css({"height":window.screen.availHeight});
    $(".overDiv").show();
    /*ajax进行请求 */
    /*$.ajax({
        /!*请求方式 *!/
        type:'POST',
        async: false,
        /!*请求的地址 *!/
        url:'http://localhost:8080/ticketActivity/ticketActivityBookPic.do',
        /!* 请求的参数和内容*!/
        data:{needPath:"http://www.hao123.com/"},
        /!* 请求成功后，返回结果result，写一个函数进行处理*!/
        success:function(result){
            debugger
            console.info(11111);
            console.info(result);
            //清空之前的内容，避免数据都叠加在一起
            // $("#dpic").empty();
            /!* 给指定区域写内容，也就是要显示的地方*!/
            $("#dpic").prepend(result);
            /!*为标签写属性，这里我使用的是java的数据流方式传递图片到页面，类似于验证码原理 *!/
            $("#pic").attr("src","http://localhost:8080/ticketActivity/ticketActivityBookPic.do?needPath=http://www.hao123.com/");
        },
        error: function (data) {
            debugger
            console.info(data);
        }
        });*/
}

function wantGo(activityId,userId) {
    $(this).attr("disabled", false);
    if(userId == null || userId == ""){
        dialogAlert("提示","登录之后才能点击！");
        return;
    }
    $.post("../frontActivity/addActivityUserWantgo.do?activityId="+activityId+"&userId="+userId, function(data) {
        if(data=="success"){
            loadWantGo();
        }else{
            dialogAlert("提示","操作失败！");
        }
    });
}


/**
 * 加载推荐评论列表
 */
function loadCommentList(){
    $("#comment-list-div ul").html();
    var tuserId = $("#tuserId").val();
    var  commentRkId =$("#commentRkId").val();
    var data = {"tuserId":tuserId,"commentType" : 2,"commentRkId" :commentRkId};
    $.post("../frontActivity/commentList.do",data ,
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
                    commentHtml = commentHtml + "<li><a class='img fl'><img src='"+userHeadImgUrl+"' width='60' height='60'/></a>" +
                    "<div class='info fr'><h4><a>"+commentUserName+"</a><em>"+commentTime+"</em></h4><p>"+commentRemark+"</p>"+imgUrl+"</div></li>";
                }
            }else{
                //$("#moreComment").removeAttr("onclick");
                //$("#moreComment").html("没有更多了!");
                $("#moreComment").hide();
            }
            $("#comment-list-div ul").html(commentHtml);
            //loadCommentListPics();
        }).success(function () {
            var localUrl = top.location.href;
            var divActivityComment = document.getElementById("divActivityComment");
            if(localUrl.indexOf("collect_info.jsp") == -1){
                $("#divActivityComment").show();
            }else{
                $("#divActivityComment").css('display','none');
                $("#divActivityComment").html("");
                $("#divActivityComment").hide();
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
                    "<div class='info fr'><h4><a>"+commentUserName+"</a><em>"+commentTime+"</em></h4><p>"+commentRemark+"</p>"+imgUrl+"</div></li>";
                }
            }else{
                $("#moreComment").removeAttr("onclick");
                $("#moreComment").html("没有更多了!");
            }
            $("#comment-list-div ul").append(commentHtml);
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
                CKobject.embed('../STATIC/js/ckplayer/ckplayer.swf','vedioDiv','ckplayer_a1','320','220',false,flashvars,video,params);
            }else{
                var htmlStr = '<embed src="'+ cultureVediourl +'" quality="high" width="320" height="220 align="middle" allowScriptAccess="always" allowFullScreen="true" wmode="transparent" type="application/x-shockwave-flash"></embed>';
                $("#vedioDiv").html(htmlStr);
            }
        }
    }});


$(function(){
    loadCommentList();
    loadWantGo();
});

function getUserImgUrl(userHeadImgUrl){
    return getIndexImgUrl(getImgUrl(userHeadImgUrl), "_300_300");
}

function getCommentImgUrl(commentImgUrl){
    if(commentImgUrl == undefined || commentImgUrl == "" || commentImgUrl == null){
        return "";
    }
    var allUrl = commentImgUrl.split(";");
    var imgDiv = "<div class='wk'>";
    for(var i=0;i<allUrl.length;i++){
        if(allUrl[i] == undefined || allUrl[i] == "" || allUrl[i] == null){
            continue;
        }
        commentImgUrl = getImgUrl(allUrl[i]);
        commentImgUrl = getIndexImgUrl(commentImgUrl, "_300_300");
        imgDiv = imgDiv + "<div class='pld_img fl'><img src='"+commentImgUrl+"' onload='fixImage(this, 75, 50)'/></div>";
    }
    imgDiv = imgDiv + "<div class='clear'></div><div class='after_img'><div class='do'><a href='javascript:void(0)' class='shouqi'>" +
    "<span><img src='../STATIC/image/shouqi.png' width='8' height='11' /></span>收起</a><a href='#' target='_blank' class='yuantu'>" +
    "<span><img src='../STATIC/image/fangda.png' width='11' height='11'/></span>原图</a></div><img src='' class='fd_img'/></div></div>";
    return imgDiv;
}
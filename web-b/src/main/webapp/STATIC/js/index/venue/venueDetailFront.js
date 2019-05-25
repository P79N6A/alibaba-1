//推荐活动室每页个数
var relatedRoomCount = 4;

$(document).ready(function(){

    //选中当前label
    $('#venueLabel').addClass('cur').siblings().removeClass('cur');

    loadVoice();
    loadVenueIcon();
    loadAntiqueList();
    loadRoomList();
    loadVenueList();
    loadCommentList();
    loadArea();
});

$(function () {
    var Img=$("#uploadType").val();
    $("#file").uploadify({
        'formData':{
            'uploadType':Img,
            'type':10,
            'userMobileNo':$("#userMobileNo").val()
        },//传静态参数
        swf:'/STATIC/js/uploadify.swf',
        uploader:'/upload/frontUploadFile.do;jsessionid='+$("#sessionId").val(),
        buttonText:'<a class="shangchuan"><h4><font>添加图片</font></h4></a>',
        'buttonClass':"upload-btn",
        /*queueSizeLimit:3,*/
        fileSizeLimit:"2MB",
        'method': 'post',
        queueID:'fileContainer',
        fileObjName:'file',
        'fileTypeDesc' : '支持jpg、png、gif格式的图片',
        'fileTypeExts' : '*.gif; *.jpg; *.png',
        'auto':true,
        'multi':true, //是否支持多个附近同时上传
        height:21,
        width:85,
        'debug':false,
        'dataType':'json',
        'removeCompleted':true,
        onUploadSuccess:function (file, data, response) {
            var json = $.parseJSON(data);
            var url=json.data;

            $("#headImgUrl").val($("#headImgUrl").val()+url+";");
            getHeadImg(url);

            if($("#headImgUrl").val().split(";").length > 3){
                $("#file").hide();
                $(".comment_message").show();
            }
        },
        onSelect:function () {

        },
        onCancel:function () {

        },
        onQueueComplete:function(queueData){
            if('${sessionScope.terminalUser}' ==null || '${sessionScope.terminalUser}' == '') {
                dialogAlert("评论提示", "登录之后才能评论");
            }
        }
    });
});

/*场馆评论图片删除*/
$(function(){
    $(".wimg").on("click", ".sc_img a", function(){
        var url = $(this).parent().attr("data-url");
        var allUrl = $("#headImgUrl").val();
        var newUrl = allUrl.replace(url+";", "");
        $("#headImgUrl").val(newUrl);
        $(this).parent().remove();
        if($("#headImgUrl").val().split(";").length <= 3){
            $("#file").show();
            $(".comment_message").hide();
        }
    });
    $(".wimg").on({
        mouseover: function(){
            $(this).find("a").show();
        },
        mouseout: function(){
            $(this).find("a").hide();
        }
    }, ".sc_img");
});

function getHeadImg(url){
    var imgUrl = getImgUrl(url);
    imgUrl=getIndexImgUrl(imgUrl,"_300_300");
    $("#imgHeadPrev").append("<div class='sc_img fl' data-url='"+url+"'><img onload='fixImage(this, 100, 80)' src='"+imgUrl+"'><a href='javascript:;'></a></div>");
    $("#btnContainer").hide();
    $("#fileContainer").hide();
}

$(function(){
    $('#keyword').keydown(function(event){
        if(event.keyCode == "13")
        {
            searchVenueList()
            event.preventDefault();
        }
    });
});

function searchVenueList(){
    var venueName =  $("#keyword").val() == "请输入关键词" ? "" : $("#keyword").val();
    window.location.href = "/frontVenue/venueList.do?keyword="+encodeURI(venueName);
}

/**
 * 加载页面中场馆所在区域
 */
function loadArea(){

    var venueCity = $("#venueCity").val();
    var venueArea = $("#venueArea").val();
    var venueAddress = $("#venueAddress").val();

    var spanCity = truncateStr(',',venueCity);
    var spanArea = truncateStr(',',venueArea);
    var spanAddress = truncateStr(',',venueAddress);
    spanAddress = spanAddress.replace(/</g,'&lt;').replace(/>/g,'&gt;');

    $("#areaSpan").html(spanCity + " " + spanArea + " " +spanAddress);
}

/**
 * 加载音频文件
 */
function loadVoice(){
    var audioSrc = $("#venueVoiceUrl").val();

    if(audioSrc != undefined && audioSrc != ""){
        var voiceUrl = getImgUrl(audioSrc);
        $("#audioPlay").attr("src", voiceUrl);
    }

    audiojs.events.ready(function() {
        audiojs.createAll();
    });
}

/**
 * 场馆详情页
 * @param venueId
 */
function venueDetail(venueId){
    $("#detailVenueId").val(venueId);
    $("#venueDetailForm").submit();
}

/**
 * 馆藏详情页
 * @param venueId
 */
function antiqueDetail(antiqueId){
    $("#antiqueId").val(antiqueId);
    $("#antiqueDetailForm").submit();
}

/**
 * 活动室详情页
 * @param venueId
 */
function roomDetail(roomId){
    $("#roomId").val(roomId);
    $("#roomDetailForm").submit();
}

/**
 *
 * @param roomId
 */
function roomBook(roomId){
    if($("#isLogin").val() == 1){
        if($("#teamUserType").val() == 1){
            dialogAlert("提示", "活动室预订只对团体用户开放!");
        }else {
            if ($("#teamUserSize").val() > 0) {
                $("#roomId2").val(roomId);
                $("#roomBookForm").submit();
            } else {
                //dialogAlert("提示", "您还没有管理的团队哦!");
                dialogAlert("提示", "您的团体身份已被冻结，请联系管理员为你激活!");
            }
        }
    }else{
        dialogAlert("提示", "请登录后再进行预订!");
    }
}

/**
 * 加载推荐馆藏列表
 */
function loadAntiqueList(){
    var venueId = $("#venueId").val();
    var data = {"venueId":venueId};
    $.post("/frontVenue/antiqueList.do",data ,
        function(data) {
            var antiqueHtml = "";
            if(data != null && data != ""){
                for(var i=0; i<data.length; i++){
                    var antique = data[i];
                    var antiqueImgUrl = antique.antiqueImgUrl;
                    var antiqueName = antique.antiqueName;
                    var antiqueId = antique.antiqueId;

                    antiqueHtml = antiqueHtml + "<li data-id='"+antiqueImgUrl+"'>"+
                    "<a class='img' onclick=antiqueDetail('"+antiqueId+"')><img src='../STATIC/image/collection-img2.jpg' alt='' width='135' height='100'/></a>"+
                    "<h4><a onclick=antiqueDetail('"+antiqueId+"')>"+antiqueName+"</a></h4>"+
                    "</li>";
                }
            }
            if(antiqueHtml == ""){
                $("#antique-list-div").attr("style","display:none;");
            }else{
                $("#antique-list-div ul").html(antiqueHtml);
            }
            loadAntiqueListPics();
        });
}

//获取列表元素中所包含的图片
function loadAntiqueListPics(){
    //请求页面下方团体所有图片
    $("#antique-list-div li").each(function (index, item) {
        var imgUrl = $(this).attr("data-id");
        if(imgUrl == undefined || imgUrl == null || imgUrl == ""){
            $(item).find("img").attr("src", "../STATIC/image/default.jpg");
        }else{
            imgUrl = getImgUrl(imgUrl);
            imgUrl = getIndexImgUrl(imgUrl,"_300_300")
            $(item).find("img").attr("src", imgUrl);
        }
    });
}

/**
 * 加载推荐活动室列表
 */
function loadRoomList(){
    var venueId = $("#venueId").val();
    var data = {"venueId":venueId};
    $.post("/frontVenue/roomList.do",data ,
        function(data) {
            var roomHtml = "";
            if(data != null && data != ""){
                //当活动室数量大于6个时才显示查看更多
                var roomCount = data.roomCount;
                if(roomCount>relatedRoomCount){
                    $("#roomViewMore").css("display","");
                }
                var roomList = data.roomList;
                //显示活动室信息
                for(var i=0; i<roomList.length; i++){
                    var room = roomList[i];
                    var roomPicUrl = room.roomPicUrl;
                    var roomName = room.roomName;
                    var roomId = room.roomId;
                    var sysNo = room.sysNo;
                    var roomCapacity = room.roomCapacity;
                    var roomArea = room.roomArea;
                    var availableCount = room.availableCount;

                    roomHtml = roomHtml + "<li   data-id='"+roomPicUrl+"'>"+
                    "<a href='javascript:;' class='room_pic fl' onclick=roomDetail('"+roomId+"')><img src='../STATIC/image/room-img1.jpg' alt='' width='135' height='100'/></a>"+
                    "<div class='room_txt fl'> " +
                    "<h4><a href='javascript:;' onclick=roomDetail('"+roomId+"')>"+roomName+"</a></h4>"+
                    "<p>面积："+roomArea+"平方米</p>"+
                    "<p>可容纳人数："+roomCapacity+"人</p>";
                    if(sysNo == 0 || sysNo == undefined || sysNo.trim()==""){
                        if(availableCount > 0){
                            roomHtml = roomHtml + "<a href='javascript:;' class='book-room' onclick=roomBook('"+roomId+"')>预订</a>";
                        }
                    }
                    roomHtml = roomHtml + "</div></li>";
                }
            }
            if(roomHtml == ""){
                $("#room-list-div").css("display","none");
            }else{
                $("#room-list-div ul").html(roomHtml);
            }
            loadRoomListPics();
        });
}

/**
 * 加载推荐场馆列表
 */
function loadVenueList(){
    var venueId = $("#venueId").val();
    var data = {"venueId":venueId};
    $.post("/frontVenue/relatedVenueList.do",data ,
        function(data) {
            var venueHtml = "";
            if(data != null && data != ""){
                for(var i=0; i<data.length; i++){
                    var venue = data[i];
                    var venueIconUrl = venue.venueIconUrl;
                    var rVenueId = venue.venueId;
                    var venueName = venue.venueName;
                    var venueAddress = venue.venueAddress;
                    var venueTel = venue.venueMobile;

                    if(venueId != rVenueId){
                        venueHtml = venueHtml + "<li data-id='"+venueIconUrl+"'>"+
                        "<a href='javascript:;' class='room_pic fl' onclick=venueDetail('"+rVenueId+"')><img src='../STATIC/image/venues-img2.png' alt='' width='135' height='100'/></a>"+
                        "<div class='room_txt2 fl'>"+
                        "<h4><a href='javascript:;' onclick=venueDetail('"+rVenueId+"')>"+venueName+"</a></h4>"+
                        "<p>地址："+venueAddress+"</p>"+
                        "<p>电话："+venueTel+"</p>"+
                        "</div>"+
                        "</li>";
                    }
                }
            }
            if(venueHtml == ""){
                $("#venue-list-div").attr("style","display:none;");
            }else{
                $("#venue-list-div ul").html(venueHtml);
            }
            loadVenueListPics();
        });
}

/**
 * 加载推荐评论列表
 */
function loadCommentList(){
    $("#comment-list-div ul").html();
    var venueId = $("#venueId").val();
    var data = {"rkId":venueId,"typeId":1};
    $.post("/frontVenue/commentList.do",data ,
        function(data) {
            var commentHtml = "";
            if(data != null && data != ""){
                for(var i=0; i<data.length; i++){
                    var comment = data[i];
                    var commentRemark = comment.commentRemark.replace(/</g,'&lt;').replace(/>/g,'&gt;');
                    var commentTime = comment.commentTime;
                    var commentUserName = comment.commentUserName;
                    var userHeadImgUrl = comment.userHeadImgUrl;
                    var commentImgUrl = comment.commentImgUrl;
                    var userSex = comment.userSex;

                    var comStar =comment.commentStar;
                    var starStr = "";
                    if(comStar){
                        starStr='<div class="start" tip="'+comStar+'"><p></p></div>';
                    }else{
                        starStr='<div class="start" tip="'+5+'"><p></p></div>';
                    }

               /* <div class="start" tip="2.5"><p></p></div>*/

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
                    "<div class='info fr'><h4><a>"+commentUserName+"</a><em>"+commentTime+"</em></h4>"+starStr+"<p>"+commentRemark+"</p>"+imgUrl+"</div></li>";
                }
            }else{
                $("#viewMore").hide();
                //$("#comment-list-div").attr("style","display:none;");
            }
            $("#comment-list-div ul").html(commentHtml);
        }).success(function () {
            var localUrl = top.location.href;
            var divActivityComment = document.getElementById("divActivityComment");
            if(localUrl.indexOf("collect_info.jsp") == -1){
                $("#divActivityComment").show();
                starts(".comment-list .start",18);
            }else{
                $("#divActivityComment").css('display','none');
                $("#divActivityComment").html("");
                $("#divActivityComment").hide();
            }
        });;
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

//获取列表元素中所包含的图片
function loadRoomListPics(){
    //请求页面下方团体所有图片
    $("#room-list-div li").each(function (index, item) {
        var imgUrl = $(this).attr("data-id");
        if(imgUrl == undefined || imgUrl == null || imgUrl == ""){
            $(item).find("img").attr("src", "../STATIC/image/default.jpg");
        }else{
            imgUrl = getImgUrl(imgUrl);
            imgUrl = getIndexImgUrl(imgUrl,"_300_300")
            $(item).find("img").attr("src", imgUrl);
        }
    });
}

//获取列表元素中所包含的图片
function loadVenueListPics(){
    //请求页面下方团体所有图片
    $("#venue-list-div li").each(function (index, item) {
        var imgUrl = $(this).attr("data-id");
        if(imgUrl == undefined || imgUrl == null || imgUrl == ""){
            $(item).find("img").attr("src", "../STATIC/image/default.jpg");
        }else{
            imgUrl = getImgUrl(imgUrl);
            imgUrl = getIndexImgUrl(imgUrl,"_300_300")
            $(item).find("img").attr("src",imgUrl);
        }
    });
}

//获取列表元素中所包含的图片
function loadCommentListPics(){
    //请求页面下方团体所有图片
    $("#comment-list-div li").each(function (index, item) {
        var imgUrl = $(this).attr("data-id");
        if(imgUrl == undefined || imgUrl == null || imgUrl == ""){
            $(item).find("img").attr("src", "../STATIC/image/default.jpg");
        }else{
            imgUrl = getImgUrl(imgUrl);
            imgUrl = getIndexImgUrl(imgUrl,"_300_300")
            $(item).find("img").attr("src", imgUrl);
        }
    });
}

/**
 * 加载更多评论
 */
function loadMoreComment(){
    var venueId = $("#venueId").val();
    var pageNum = parseInt($("#commentPageNum").val())+1;
    $("#commentPageNum").val(pageNum)
    var data = {"rkId":venueId,"pageNum":pageNum};
    $.post("/frontVenue/commentList.do",data ,
        function(data) {
            var commentHtml = "";
            if(data != null && data != ""){
                for(var i=0; i<data.length; i++){
                    var comment = data[i];
                    var commentRemark = comment.commentRemark.replace(/</g,'&lt;').replace(/>/g,'&gt;');
                    var commentTime = comment.commentTime;
                    var commentUserName = comment.commentUserName;
                    var userHeadImgUrl = comment.userHeadImgUrl;
                    var commentImgUrl = comment.commentImgUrl;
                    var userSex = comment.userSex;

                    var comStar =comment.commentStar;
                    var starStr = "";
                    if(comStar){
                        starStr='<div class="start" tip="'+comStar+'"><p></p></div>';
                    }

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
                    "<div class='info fr'><h4><a>"+commentUserName+"</a><em>"+commentTime+"</em></h4>"+starStr+"<p>"+commentRemark+"</p>"+imgUrl+"</div></li>";
                }
            }else{
                $("#viewMore").removeAttr("onclick");
                $("#viewMore").html("没有更多了!");
                return;
            }
            $("#comment-list-div ul").append(commentHtml);
            starts(".comment-list .start",18);
            //loadCommentListPics();
        });
}

/**
 * 加载更多活动室
 */
function loadMoreRoom(){

    var venueId = $("#venueId").val();
    var tmpRoomId = $("#roomId").val();
    var pageNum = parseInt($("#roomPageNum").val())+1;
    $("#roomPageNum").val(pageNum)
    var data = {"venueId":venueId,"pageNum":pageNum};
    $.post("/frontVenue/roomList.do",data ,
        function(data) {
            if(data != null && data != ""){
                var roomHtml = "";
                var roomCount = data.roomCount;
                var roomList = data.roomList;
                for(var i=0; i<roomList.length; i++){
                    var room = roomList[i];
                    var roomPicUrl = room.roomPicUrl;
                    var roomName = room.roomName;
                    var roomId = room.roomId;
                    var sysNo = room.sysNo;
                    var roomCapacity = room.roomCapacity;
                    var roomArea = room.roomArea;
                    var availableCount = room.availableCount;
                    roomHtml = roomHtml + "<li   data-id='"+roomPicUrl+"'>"+
                    "<a href='javascript:;' class='room_pic fl' onclick=roomDetail('"+roomId+"')><img src='../STATIC/image/room-img1.jpg' alt='' width='135' height='100'/></a>"+
                    "<div class='room_txt fl'> " +
                    "<h4><a href='javascript:;' onclick=roomDetail('"+roomId+"')>"+roomName+"</a></h4>"+
                    "<p>面积："+roomArea+"平方米</p>"+
                    "<p>可容纳人数："+roomCapacity+"人</p>";
                    if(sysNo == 0 || sysNo == undefined || sysNo.trim()==""){
                        if(availableCount > 0) {
                            roomHtml = roomHtml + "<a href='javascript:;' class='book-room' onclick=roomBook('" + roomId + "')>预订</a>";
                        }
                    }
                    roomHtml = roomHtml + "</div></li>";
                }
            }

            $("#room-list-div ul").append(roomHtml);
            if(roomCount <= pageNum*relatedRoomCount){
                $("#roomViewMore").css("display","none");
            }
            loadRoomListPics();
        });
}

/**
 * 活动室添加评论
 */
function addComment(){

    if($("#isLogin").val() != 1){
        dialogAlert("提示", "请登录后再发表评论哦!");
        return;
    }else{
        var accountStatus = $("#accountStatus").val();
        if(parseInt(accountStatus) == 2){
            dialogAlert("评论提示", "您的账户已被禁止评论，没有评论权限");
            return;
        }
    }

    var star = $("#activityScore").val();
    if(star==0){
        dialogAlert("评论提示", "请为场馆评分");
        return;
    }

    var commentRemark = $("#commentRemark").val();
    if(commentRemark == undefined || $.trim(commentRemark) == ""){
        dialogAlert("评论提示", "输入评论内容");
        return;
    }

    var headImgUrl = $("#headImgUrl").val();
    if(headImgUrl != ""){
        if(headImgUrl.lastIndexOf(";") == headImgUrl.length - 1){
            var url = headImgUrl.substring(0,headImgUrl.lastIndexOf(";"));
            $("#headImgUrl").val(url);
        }
    }

    if($("#commentRemark").val().trim() != ""){
        /*$.post("../frontVenue/addComment.do",$("#commentForm").serialize(),function(result){
            if(result == "success"){
                $("#commentRemark").val("");
                $("#headImgUrl").val("");
                $(".sc_img").remove();
                $(".shangchuan").show();
                dialogAlert("提示", "评论成功!");
                loadCommentList();
            }else if(result == "exceedNumber"){
                dialogAlert("提示", "当天评论次数最多五次!");
            }else if(result == "sensitiveWords"){
                dialogAlert("评论提示","评论内容有敏感词，不能评论!");
            }else{
                dialogAlert("提示","评论失败，请重试!");
            }
        });*/
        $.ajax({
            type:"post",
            url:"/frontVenue/addComment.do",
            data:$("#commentForm").serialize(),
            dataType: "json",
            cache:false,//缓存不存在此页面
            async: false,//异步请求
            success: function (result) {
                if(result == "success"){
                    $("#commentRemark").val("");
                    $("#headImgUrl").val("");
                    $(".sc_img").remove();
                    $("#file").show();
                    dialogAlert("提示", "评论成功!");
                    $(".comment_message").hide();

                    //恢复默认
                    $("#star-score a").each(function(){
                        $(this).removeClass("cur");
                    });
                    $("#activityScore").val(0);
                    $("#score-num").html(0);

                    loadCommentList();
                    $.ajax({
                        type:"post",
                        url:"/comment/queryCommentCount.do",
                        data:{commentRkId:$("#tmpVenueId").val(),commentType:1},
                        dataType: "json",
                        cache:false,//缓存不存在此页面
                        async: false,//异步请求
                        success: function (result) {
                            $("#commentCount").html(result+"条评论");
                        }
                    });
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
}


//判断用户是否收藏了该条内容
$(function () {
    var venueId = $("#tmpVenueId").val();
    $.ajax({
        type: 'POST',
        dataType : "json",
        url: "/collect/isHadCollect.do?relateId="+venueId+"&type=1",//请求的action路径
        error: function () {//请求失败处理函数
        },
        success:function(data){ //请求成功后处理函数。
            if (data > 0) {
                $("#zanId").addClass("love");
            }
        }
    });

    $.ajax({
        type: 'POST',
        dataType : "json",
        url: "/collect/getHotNum.do?relateId="+venueId+"&type=1",//请求的action路径
        error: function (data) {//请求失败处理函数
            $("#likeCount").html("0");
            $("#zanId").html(data);
        },
        success:function(data){ //请求成功后处理函数。
            $("#likeCount").html(data);
            $("#zanId").html(data);
        }
    });

});

//点击收藏
function changeClass(){

    if($("#isLogin").val() == 1){
        var venueId = $("#venueId").val();
        //判断是收藏还是取消 收藏
        if($("#zanId").hasClass("love")) {
            $.ajax({
                type: 'POST',
                dataType : "json",
                url: "/collect/deleteUserCollect.do?relateId="+venueId+"&type=1",//请求的action路径
                error: function () {//请求失败处理函数
                },
                success:function(data){ //请求成功后处理函数。
                    $("#likeCount").html(data);
                    $("#zanId").html(data);
                }
            });
            $("#zanId").removeClass("love");
        }else {
            $.ajax({
                type: 'POST',
                dataType : "json",
                url: "/cmsTypeUser/venueSave.do?venueId="+venueId+"&operateType=3",//请求的action路径
                error: function () {//请求失败处理函数
                },
                success:function(data){ //请求成功后处理函数。
                    $("#likeCount").html(data);
                    $("#zanId").html(data);
                }
            });
            $("#zanId").addClass("love");
        }
    }else{
        dialogAlert("提示","登录之后才能收藏");
        return;
    }
}


//统计数据
$(function () {
    var venueId = $("#venueId").val();
    $.ajax({
        type: 'POST',
        dataType : "json",
        url: "/cmsTypeUser/venueSave.do?venueId="+venueId+"&operateType=1",//请求的action路径
        error: function () {//请求失败处理函数
        },
        success:function(data){ //请求成功后处理函数。
        }
    });
});

//获取场馆详情图片
function loadVenueIcon(){

    var imgUrl = $("#venueIcon").attr("data-id");
    if(imgUrl == undefined || imgUrl == "" || imgUrl == null){
        $("#venueIcon").attr("src", "../STATIC/image/default.jpg");
        $("#venueIcon").css("width", "750");
        $("#venueIcon").css("height", "500");
    }else{
        imgUrl = getImgUrl(imgUrl);
        imgUrl = getIndexImgUrl(imgUrl,"_750_500");
        $("#venueIcon").attr("src", imgUrl);
    }
}

/**
 * 根据分隔符截取字符串
 * @param splitChar
 * @param truncateStr
 * @returns {*}
 */
function truncateStr(splitChar,truncateStr){
    var indexOfSplitChar = null;
    var result = "";
    if(isLegal(splitChar) && isLegal(truncateStr)){
        indexOfSplitChar = truncateStr.indexOf(splitChar);

        var len = truncateStr.length;
        if(indexOfSplitChar != null){
            result = truncateStr.substring(indexOfSplitChar+1,len);
        }
    }
    return result;
}

/**
 * 判断一个字符串是否合理
 * @param str
 * @returns {boolean}
 */
function isLegal(str){
    var result = true;
    if(str == undefined || str == null || str == ""){
        result = false;
    }
    return result;
}

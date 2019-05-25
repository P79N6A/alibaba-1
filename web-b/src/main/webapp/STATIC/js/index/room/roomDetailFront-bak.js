
$(document).ready(function(){

    loadRoomPic();
    loadArea();
    loadRoomList();
    loadVenueList();
    loadCommentList();
    //选中当前label
    $('#venueListLabel').addClass('cur').siblings().removeClass('cur');
});

$(function () {
    var Img=$("#uploadType").val();
    $("#file").uploadify({
        'formData':{
            'uploadType':Img,
            'type':10,
            'userMobileNo':$("#userMobileNo").val()
        },//传静态参数
        swf:'../STATIC/js/uploadify.swf',
        uploader:'../upload/frontUploadFile.do;jsessionid='+$("#sessionId").val(),
        //buttonText:'<input type="button" value="上传头像">',
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

/*活动室评论图片删除*/
$(function(){
    $(".pl_img").on("click", ".sc_img a", function(){
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
    $(".pl_img").on({
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
    $("#imgHeadPrev").append("<div class='sc_img fl' data-url='"+url+"'><img onload='fixImage(this, 50, 50)' src='"+imgUrl+"'><a href='javascript:;'></a></div>");
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
    window.location.href = "../frontVenue/venueList.do?keyword="+venueName;
}


//获取活动室详情图片
function loadRoomPic(){

    var imgUrl = $("#roomPic").attr("data-id");
    imgUrl = getImgUrl(imgUrl);
    imgUrl = getIndexImgUrl(imgUrl,"_750_500")
    $("#roomPic").attr("src", imgUrl);
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

    $("#areaSpan").html("地址："+spanCity + " " + spanArea + " " +spanAddress);
}

/**
 *
 * @param roomId
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
    var invalidData = $("#invalidData").val();
    if(invalidData == "true"){
        dialogAlert("提示", "该场馆或活动室已被删除，请预定其它场馆内活动室！");
    }else{
        if($("#isLogin").val() == 1){
            if($("#teamUserType").val() == 1){
                dialogAlert("提示", "活动室预订只对团体用户开放!");
            }else {
                if ($("#teamUserSize").val() > 0) {
                    $("#roomId2").val(roomId);
                    $("#roomBookForm").submit();
                } else {
                    dialogAlert("提示", "您还没有管理的团队哦!");
                }
            }
        }else{
            dialogAlert("提示", "请登录后再进行预订!");
        }
    }
}

/**
 *
 * @param roomId
 */
function singleRoomBook(roomId,bookId){
    var invalidData = $("#invalidData").val();
    if(invalidData == "true"){
        dialogAlert("提示", "该场馆或活动室已被删除，请预定其它场馆内活动室！");
    }else{
        if($("#isLogin").val() == 1){
            if($("#teamUserType").val() == 1){
                dialogAlert("提示", "活动室预订只对团体用户开放!");
            }else{
                if($("#teamUserSize").val() > 0){
                    $("#roomId2").val(roomId);
                    $("#bookId").val(bookId);
                    $("#roomBookForm").submit();
                }else{
                    dialogAlert("提示", "您还没有管理的团队哦!");
                }
            }
        }else{
            dialogAlert("提示", "请登录后再进行预订!");
        }
    }
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
 * 加载推荐活动室列表
 */
function loadRoomList(){
    var venueId = $("#tmpVenueId").val();
    var tmpRoomId = $("#roomId").val();
    var data = {"venueId":venueId};
    $.post("../frontRoom/roomList.do",data ,
        function(data) {
            var roomHtml = "";
            if(data != null && data != ""){
                //当活动室数量大于6个时才显示查看更多
                var roomCount = data.roomCount;
                if(roomCount>6){
                    $("#roomViewMore").css("display","");
                }
                var roomList = data.roomList;
                //显示活动室信息
                for(var i=0; i<roomList.length; i++){
                    var room = roomList[i];
                    var roomPicUrl = room.roomPicUrl;
                    var roomName = room.roomName;
                    var roomIsFree = room.roomIsFree;
                    var roomFee = room.roomFee;
                    var roomConsultTel = room.roomConsultTel;
                    var roomId = room.roomId;
                    var sysNo = room.sysNo;

                    var feeContent = "";
                    if(roomIsFree == 1){
                        feeContent = " 免费";
                    }else{
                        feeContent = roomFee;
                    }

                    if(tmpRoomId != roomId){
                        roomHtml = roomHtml + "<li data-id='"+roomPicUrl+"'>"+
                        "<a href='javascript:;' class='img' onclick=roomDetail('"+roomId+"')><img src='../STATIC/image/room-img1.jpg' alt='' width='155' height='128'/></a>"+
                        "<h4><a href='javascript:;' onclick=roomDetail('"+roomId+"')>"+roomName+"</a></h4>"+
                        "<p>费用："+feeContent+"</p>"+
                        "<p>咨询："+roomConsultTel+"</p>";
                        if($("#isLogin").val() == 1){
                        	if(sysNo == 0 || sysNo == undefined || sysNo.trim()==""){
                        		roomHtml = roomHtml + "<a href='javascript:;' class='book-room' onclick=roomBook('" + roomId + "')>预订</a>";
                        	}
                        }
                        roomHtml = roomHtml + "</li>";
                    }
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

//获取列表元素中所包含的图片
function loadRoomListPics(){
    //请求页面下方团体所有图片
    $("#room-list-div li").each(function (index, item) {
        var imgUrl = $(this).attr("data-id");
        imgUrl = getImgUrl(imgUrl);
        imgUrl = getIndexImgUrl(imgUrl,"_300_300")
        $(item).find("img").attr("src", imgUrl);
    });
}

/**
 * 加载推荐场馆列表
 */
function loadVenueList(){
    var venueId = $("#tmpVenueId").val();
    var data = {"venueId":venueId};
    $.post("../frontVenue/relatedVenueList.do",data ,
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

                    venueHtml = venueHtml + "<li data-id='"+venueIconUrl+"'>"+
                    "<a href='javascript:;' class='img fl' onclick=venueDetail('"+rVenueId+"')><img src='../STATIC/image/venues-img2.png' alt='' width='72' height='72'/></a>"+
                    "<div class='info fr'>"+
                    "<h4><a href='javascript:;' onclick=venueDetail('"+rVenueId+"')>"+venueName+"</a></h4>"+
                    "<p>地址："+venueAddress+"</p>"+
                    "<p>电话："+venueTel+"</p>"+
                    "</div>"+
                    "</li>";
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

//获取列表元素中所包含的图片
function loadVenueListPics(){
    //请求页面下方团体所有图片
    $("#venue-list-div li").each(function (index, item) {
        var imgUrl = $(this).attr("data-id");
        imgUrl = getImgUrl(imgUrl);
        imgUrl = getIndexImgUrl(imgUrl,"_300_300")
        $(item).find("img").attr("src", imgUrl);
    });
}

/**
 * 加载推荐评论列表
 */
function loadCommentList(){
    $("#comment-list-div ul").html();
    var roomId = $("#roomId").val();
    var data = {"rkId":roomId,"typeId":7};
    $.post("../frontVenue/commentList.do",data ,
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
                $("#viewMore").hide();
                //$("#comment-list-div").attr("style","display:none;");
            }
            $("#comment-list-div ul").html(commentHtml);
        });
}


/**
 * 加载更多评论
 */
function loadMoreComment(){

    var roomId = $("#roomId").val();
    var pageNum = parseInt($("#commentPageNum").val())+1;
    $("#commentPageNum").val(pageNum)
    var data = {"rkId":roomId,"pageNum":pageNum};
    $.post("../frontVenue/commentList.do",data ,
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
                $("#viewMore").removeAttr("onclick");
                $("#viewMore").html("没有更多了!");
            }
            $("#comment-list-div ul").append(commentHtml);
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

/**
 * 加载更多活动室
 */
function loadMoreRoom(){

    var venueId = $("#tmpVenueId").val();
    var tmpRoomId = $("#roomId").val();
    var pageNum = parseInt($("#roomPageNum").val())+1;
    $("#roomPageNum").val(pageNum)
    var data = {"venueId":venueId,"pageNum":pageNum};
    $.post("../frontRoom/roomList.do",data ,
        function(data) {
            if(data != null && data != ""){
                var roomHtml = "";
                var roomCount = data.roomCount;
                var roomList = data.roomList;
                for(var i=0; i<roomList.length; i++){
                    var room = roomList[i];
                    var roomPicUrl = room.roomPicUrl;
                    var roomName = room.roomName;
                    var roomIsFree = room.roomIsFree;
                    var roomFee = room.roomFee;
                    var roomConsultTel = room.roomConsultTel;
                    var roomId = room.roomId;
                    var sysNo = room.sysNo;

                    var feeContent = "";
                    if(roomIsFree == 1){
                        feeContent = " 免费";
                    }else{
                        feeContent = roomFee;
                    }

                    if(tmpRoomId != roomId){
                        roomHtml = roomHtml + "<li data-id='"+roomPicUrl+"'>"+
                        "<a href='javascript:;' class='img' onclick=roomDetail('"+roomId+"')><img src='../STATIC/image/room-img1.jpg' alt='' width='155' height='128'/></a>"+
                        "<h4><a href='javascript:;' onclick=roomDetail('"+roomId+"')>"+roomName+"</a></h4>"+
                        "<p>费用："+feeContent+"</p>"+
                        "<p>咨询："+roomConsultTel+"</p>";
                        if($("#isLogin").val() == 1){
                        	if(sysNo == 0 || sysNo == undefined || sysNo.trim()==""){
                        		roomHtml = roomHtml + "<a href='javascript:;' class='book-room' onclick=roomBook('"+roomId+"')>预订</a>";
                        	}
                        }	
                        roomHtml = roomHtml + "</li>";
                    }
                }
                $("#room-list-div ul").append(roomHtml);
                if(roomCount <= pageNum*6){
                    $("#roomViewMore").css("display","none");
                }
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
        var accountStatus = $("#accountStatus").val()
        if(parseInt(accountStatus) == 2){
            dialogAlert("评论提示", "您的账户已被禁止评论，没有评论权限");
            return;
        }
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
        /*$.post("../frontRoom/addComment.do",$("#commentForm").serialize(),function(result){
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
            url:"../frontRoom/addComment.do",
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
                    loadCommentList();
                    $.ajax({
                        type:"post",
                        url:"../comment/queryCommentCount.do",
                        data:{commentRkId:$("#tmpRoomId").val(),commentType:7},
                        dataType: "json",
                        cache:false,//缓存不存在此页面
                        async: false,//异步请求
                        success: function (result) {
                            $("#commentCount").html(result+"条评论");
                        }
                    });
                }else if(result == "exceedNumber"){
                    dialogAlert("提示", "当天评论次数最多五次!");
                }else if(result == "sensitiveWords"){
                    dialogAlert("评论提示","评论内容有敏感词，不能评论!");
                }else{
                    dialogAlert("提示","评论失败，请重试!");
                }
            }
        });
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
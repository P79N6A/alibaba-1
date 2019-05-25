<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!--移动端版本兼容 -->
<script type="text/javascript">
    var phoneWidth = parseInt(window.screen.width);
    var phoneScale = phoneWidth / 1200;
    var ua = navigator.userAgent;            //浏览器类型
    if (/Android (\d+\.\d+)/.test(ua)) {      //判断是否是安卓系统
        var version = parseFloat(RegExp.$1); //安卓系统的版本号
        if (version > 2.3) {
            document.write('<meta name="viewport" content="width=1200, minimum-scale = ' + phoneScale + ', maximum-scale = ' + (phoneScale) + ', target-densitydpi=device-dpi">');
        } else {
            document.write('<meta name="viewport" content="width=1200, target-densitydpi=device-dpi">');
        }
    } else {
        document.write('<meta name="viewport" content="width=1200, user-scalable=yes, target-densitydpi=device-dpi">');
    }

    $(function(){
        var _module = '${module.informationModuleId}' ;
        if(_module != '' && _module == 'YSJS') {
            $("#ysjs").addClass('cur').siblings().removeClass('cur');
        } else {
            $("#chuanzhouIndex").addClass('cur').siblings().removeClass('cur');
        }
        //页面加载完成后首次加载评论
        loadComment(20);

        //点赞
        var userIsWant ='${info.userIsWant}';
        if(userIsWant > 0){
            $(".zan_lm").addClass("cur");
        }

        //图片上传
        var Img = $("#uploadType").val();
        $("#file").uploadify({
            'formData':{
                'uploadType':Img,
                'type':20,
                'userMobileNo':$("#userMobileNo").val()
            },//传静态参数
            swf:'${path}/STATIC/js/uploadify.swf',
            uploader:'${path}/upload/frontUploadFile.do;jsessionid='+$("#sessionId").val(),
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
            height:26,
            width:90,
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
    })

    //图片回显
    function getHeadImg(url){
        var imgUrl = getImgUrl(url);
        imgUrl=getIndexImgUrl(imgUrl,"_300_300");
        $("#imgHeadPrev").append("<div class='sc_img fl' data-url='"+url+"'><img onload='fixImage(this, 100, 80)' src='"+imgUrl+"'><a href='javascript:;'></a></div>");
        $("#btnContainer").hide();
        $("#fileContainer").hide();
    }

    //图片删除
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

    //加载评论列表
    var commentIndex = 1;
    function loadComment(type) {
        $("#comment-list-div ul").html();
        var infoId = $("#infoId").val();
        var data = {"rkId":infoId,"typeId":20,"pageNum":commentIndex};
        $.post("${path}/beipiaoInfo/commentList.do",data ,
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
                                userHeadImgUrl = "${path}/STATIC/image/face_boy.png";
                            }else if(userSex == 2){
                                userHeadImgUrl = "${path}/STATIC/image/face_girl.png";
                            }else{
                                userHeadImgUrl = "${path}/STATIC/image/face_secrecy.png";
                            }
                        }
                        var imgUrl = getCommentImgUrl(commentImgUrl);
                        commentHtml = commentHtml + "<li><a class='img fl'><img src='"+userHeadImgUrl+"' width='60' height='60'/></a>" +
                            "<div class='info fr'><h4><a>"+commentUserName+"</a><em>"+commentTime+"</em></h4><p>"+commentRemark+"</p>"+imgUrl+"</div></li>";
                    }
                    if(data.length != 5){
                        $("#viewMore").hide();
                    }
                }else{
                    $("#viewMore").hide();
                    //$("#comment-list-div").attr("style","display:none;");
                }
                $("#comment-list-div ul").append(commentHtml);
            });
    }

    //评论图片样式
    function getCommentImgUrl(commentImgUrl){
        if(commentImgUrl == undefined || commentImgUrl == "" || commentImgUrl == null){
            return "";
        }
        var allUrl = commentImgUrl.split(";");
        var imgDiv = '<div class="wk"><div class="pld_img_list">';
        for(var i=0;i<allUrl.length;i++){
            if(allUrl[i] == undefined || allUrl[i] == "" || allUrl[i] == null){
                continue;
            }
            commentImgUrl = getImgUrl(allUrl[i]);
            commentImgUrl = getIndexImgUrl(commentImgUrl, "_300_300");
            imgDiv = imgDiv + "<div class='pld_img fl'><img src='"+commentImgUrl+"' onload='fixImage(this, 75, 50)'/></div>";
        }
        imgDiv = imgDiv + "</div><div class='after_img'><div class='do'><a href='javascript:void(0)' class='shouqi'>" +
            "<span><img src='${path}/STATIC/image/shouqi.png' width='8' height='11' /></span>收起</a><a href='#' target='_blank' class='yuantu'>" +
            "<span><img src='${path}/STATIC/image/fangda.png' width='11' height='11'/></span>原图</a></div><img src='' class='fd_img'/></div></div>";
        return imgDiv;
    }

    //加载更多评论
    function moreComment(type){
        commentIndex += 1;
        loadComment(type);
    }

    //添加评论
    function addComment(type){
        var userId = $("#userId").val();
        if (userId == null || userId == "") {
            dialogAlert("提示", '登录之后才能评论', function () {
                //location.href = "${path}/frontTerminalUser/userLogin.do";
            });
            return;
        }
        var commentRemark = $("#commentRemark").val();
        if(commentRemark.trim()==""){
            dialogAlert("提示", '评论内容不能为空！', function () {
            });
            return;
        }
        if(commentRemark.length<4){
            dialogAlert("提示", '评论内容不能少于4个字！', function () {
            });
            return;
        }

        var headImgUrl = $("#headImgUrl").val();
        if(headImgUrl != ""){
            if(headImgUrl.lastIndexOf(";") == headImgUrl.length - 1){
                var url = headImgUrl.substring(0,headImgUrl.lastIndexOf(";"));
                $("#headImgUrl").val(url);
            }
        }

        var data = {
            commentUserId:userId,
            commentRemark:commentRemark,
            commentType:type,
            commentRkId:$("#infoId").val(),
            commentImgUrl:$("#headImgUrl").val()
        }
        $.post("${path}/comment/addComment.do",data, function(data) {
            if(data=='success'){
                dialogAlert("提示", '评论成功!', function () {
                    window.location.href = "${path}/beipiaoInfo/bpInfoDetail.do?infoId=" + $("#infoId").val();
                });
                return;
            }else if(data == "exceedNumber"){
                dialogAlert("提示", "当天评论次数最多一次!");
            }else if(data == "failure"){
                dialogAlert("评论提示","评论内容有敏感词，不能评论!");
            }else{
                dialogAlert("提示","评论失败，请重试!");
            }
        },"json");
    }

    //点赞（我想去）
    function addWantGo(relateId,wantgoType,$this) {
        var userId = $("#userId").val();
        if (userId == null || userId == '') {
            dialogAlert("提示", '登录之后才能点赞', function () {
                //location.href = "${path}/frontTerminalUser/userLogin.do";
            });
            return;
        }
        $.post("${path}/beipiaoInfo/addUserWantgo.do", {
            relateId: relateId,
            userId: userId,
            type: wantgoType
        }, function (data) {
            if (data.status == 0) {
                $(".zan_lm").addClass("cur");
                $(".zan_lm").html(parseInt($(".zan_lm").html())+1);
            } else if (data.status == 14111) {
                $.post("${path}/beipiaoInfo/deleteUserWantgo.do", {
                    relateId: relateId,
                    userId: userId
                }, function (data) {
                    if (data.status == 0) {
                        $(".zan_lm").removeClass("cur");
                        $(".zan_lm").html(parseInt($(".zan_lm").html())-1);
                    }
                }, "json");
            }
        }, "json");
    }

    //举报
    seajs.config({
        alias: {
            "jquery": "${path}/STATIC/js/dialog/lib/jquery-1.10.2.js"
        }
    });
    seajs.use(['${path}/STATIC/js/dialog/src/dialog-plus'], function (dialog) {
        window.dialog = dialog;
    });

    window.console = window.console || {
        log: function () {
        }
    };
    seajs.use(['jquery'], function ($) {
        $('.worn_lm').on('click', function () {
            if ('${sessionScope.terminalUser}' == null || '${sessionScope.terminalUser}' == "") {
                dialogAlert("提示", "登录之后才能举报");
                return;
            }
            top.dialog({
                url: '${path}/beipiaoInfo/chuanzhouReport.do?bpInfoId=${bpInfo.beipiaoinfoId }',
                title: '举报原因',
                width: 420,
                height: 340,
                fixed: true,
                data: $(this).attr("data-name") // 给 iframe 的数据
            }).showModal();
            return false;
        });
    });

    //多视频显示
    <%--$(function(){--%>
    <%--    //加载视频--%>
    <%--    var cultureVediourl = '${info.detailList}';--%>
    <%--    cultureVediourl = 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/video/2019429181646jTFTSycZBjSq0K1TrxxkU0AQybSjyI.mp4';--%>
    <%--    for(var i = 0;i<4;i++){--%>
    <%--        var divName = "vedioDiv"+i;--%>
    <%--        var div = '<div id="'+divName+'" style="text-indent: 0; margin: 20px auto;"></div>';--%>
    <%--        $("#detailDiv").append(div);--%>
    <%--        createVedio(cultureVediourl,divName);--%>
    <%--    }--%>
    <%--});--%>

    //单视频显示
    $(function(){
        //加载视频
        var videoUrl = '${info.videoUrl}';
            var divName = "vedioDiv";
            var div = '<div id="'+divName+'" style="text-indent: 0; margin: 20px auto;"></div>';
            $("#detailDiv").append(div);
            createVedio(videoUrl,divName);
    });

    function createVedio(cultureVediourl,divName){
        if(cultureVediourl != undefined && cultureVediourl != ""){
            if(cultureVediourl.indexOf(".swf") == -1){
                var flashvars={
                    f:cultureVediourl,
                    b:1
                };
                var params={bgcolor:'#FFF',allowFullScreen:true,allowScriptAccess:'always',wmode:'transparent'};
                var video=[cultureVediourl + '->video/mp4'];
                CKobject.embed('${path}/STATIC/js/ckplayer/ckplayer.swf',divName,'ckplayer_a1','710','470',false,flashvars,video,params);
            }else{
                var htmlStr = '<embed src="'+ cultureVediourl +'" quality="high" width="710" height="470" align="middle" allowScriptAccess="always" allowFullScreen="true" mode="transparent" type="application/x-shockwave-flash"></embed>';
                $("#"+divName).html(htmlStr);
            }
        }
    }
</script>
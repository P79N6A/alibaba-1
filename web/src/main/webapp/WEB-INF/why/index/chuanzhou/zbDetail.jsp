<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@page import="com.sun3d.why.model.CmsTerminalUser"%>
<%@ page language="java" pageEncoding="UTF-8" %>
<%
    String path = request.getContextPath();
    request.setAttribute("path", path);
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
    request.setAttribute("basePath", basePath);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>文化直播</title>
    <link rel="stylesheet" href="${path}/STATIC/css/owl.carousel.min.css">
    <link rel="stylesheet" href="${path}/STATIC/css/owl.theme.default.min.css">
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/bpNormalize.css">
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/hsCulture.css">
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture-user.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/ui-dialog.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/frontBp/jquery.min.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/frontBp/jquery.SuperSlide.2.1.1.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/frontBp/owl.carousel.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/frontBp/culture.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/frontBp/qiehuan.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/base.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/common.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/jquery.alerts.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/jquery.uploadify-3.1.min.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/ckplayer/ckplayer.js" charset="utf-8"></script>
    <!-- 评论 
    <script type="text/javascript" src="${path}/STATIC/js/comment.js"></script>-->
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    <!-- 举报弹窗 -->
    <script type="text/javascript" src="${path}/STATIC/js/dialog/lib/sea.js"></script>
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
            var _module = '${module}' ;
            if(_module != '' && _module == 'YSJS') {
                $("#ysjs").addClass('cur').siblings().removeClass('cur');
            } else {
                $("#whzb").addClass('cur').siblings().removeClass('cur');
            }
            //页面加载完成后首次加载评论
            loadComment(20);

            //点赞
            var userIsWant ='${userIsWant}';
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

            //加载视频
            <%--var cultureVediourl = '${info.detailList[0].detailContent}';--%>
            //var cultureVediourl = 'http://movie.ks.js.cn/flv/other/2014/06/20-2.flv';
            //var cultureVediourl = 'http://player.youku.com/player.php/Type/Folder/Fid/25900235/Ob/1/sid/XMTMzMDg2MDk0NA==/v.swf';

            <%--if(cultureVediourl != undefined && cultureVediourl != ""){--%>
                <%--if(cultureVediourl.indexOf(".swf") == -1){--%>
                    <%--var flashvars={--%>
                        <%--f:cultureVediourl,--%>
                        <%--b:1--%>
                    <%--};--%>
                    <%--var params={bgcolor:'#FFF',allowFullScreen:true,allowScriptAccess:'always',wmode:'transparent'};--%>
                    <%--var video=[cultureVediourl + '->video/mp4'];--%>
                    <%--CKobject.embed('${path}/STATIC/js/ckplayer/ckplayer.swf','vedioDiv','ckplayer_a1','710','470',false,flashvars,video,params);--%>
                <%--}else{--%>
                    <%--var htmlStr = '<embed src="'+ cultureVediourl +'" quality="high" width="710" height="470" align="middle" allowScriptAccess="always" allowFullScreen="true" mode="transparent" type="application/x-shockwave-flash"></embed>';--%>
                    <%--$("#vedioDiv").html(htmlStr);--%>
                <%--}--%>
            <%--}--%>
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
            /* var data = {
                moldId: $("#infoId").attr("value"),
                type: type,
                pageIndex: commentIndex,
                pageNum: 5
            };
            $.post("${path}/wechat/weChatComment.do", data, function (data) {
				if (data.status == 0) {
					if(data.data.length<=0){
						$("#moreComment").hide();
				        return;
					}
		            if(data.data.length<5){
						$("#moreComment").hide();
		            }
					$("#commentSize").html(data.pageTotal);
		            var str = '';
		            $.each(data.data, function (i, dom) {
		                str += '<li><a class="img fl">';
		                var userHeadImgUrl = '';
		                if (dom.userHeadImgUrl.indexOf("http://") == -1) {
		                    userHeadImgUrl = '${path}/STATIC/wx/image/sh_user_header_icon.png';
		                } else if (dom.userHeadImgUrl.indexOf("/front/") != -1) {
		                    userHeadImgUrl = getIndexImgUrl(dom.userHeadImgUrl, "_300_300");
		                } else {
		                    userHeadImgUrl = dom.userHeadImgUrl;
		                }
		                var imgUrl = getCommentImgUrl(dom.commentImgUrl);
		                str += '<img src="'+userHeadImgUrl+'" width="60" height="60">';
		                str += '</a>';
		                str += '<div class="info fr">';
		                str += '<h4><a>'+dom.commentUserNickName+'</a>';
		                str += '<em>'+dom.commentTime+'</em></h4>';
		                str += '<p>'+dom.commentRemark+'</p>';
		                str += imgUrl;
		                str += '</div></li>';
					});
		            $("#commentUl").append(str);
				}
			}, "json");  */
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
    </script>
    <style type="">
        .bdshare-button-style0-16{
            padding-left:0 !important;}
        .bdshare-button-style0-16 a, .bdshare-button-style0-16 .bds_more {
            float: none !important;
            margin:  0 !important;
        }
    </style>
    <!--移动端版本兼容 end -->
</head>
<body>
<div class="header">
    <%@include file="../header.jsp" %>
</div>
<input id ="userId" value="${sessionScope.terminalUser.userId }" type="hidden"/>
<input id ="infoId" value="${bpInfo.beipiaoinfoId }" type="hidden"/>
<div class="lm_main clearfix">
    <p class="lm-breadcrumbs" style="margin-left: 40px;">您所在的位置：
        <a href="${path}/zxInformation/zxfrontindex.do?module=80f65566172843a5b450c0d6eaea5bda"><span>文化直播</span></a>
        <%--<a href="${path}/beipiaoInfo/chuanzhouList.do?infoTagCode=${bpInfo.beipiaoinfoTag }"><span>${bpTagInfo.parentTagInfo }</span></a> &gt;--%>
        <%--<span>${info.informationTags }</span>--%>
    </p>
    <!-- 详情 -->
    <div class="left">
        <p class="name">${info.informationTitle }</p>
        <div class="time clearfix">
            <fmt:formatDate value="${info.informationUpdateTime}" pattern="yyyy-MM-dd HH:mm"/>
            <div class="state">
                <span class="zan_lm" onclick="addWantGo('${info.informationId }',20,'$(this)')">${info.shareCount }</span>
                <span class="bdsharebuttonbox" >
					 <a class="share_lm" data-cmd="more">分享</a>
				 </span>
                <!--分享代码 start-->
                <script>
                    window._bd_share_config = {
                        "common": {
                            "bdSnsKey": {},
                            "bdText": "",
                            "bdMini": "2",
                            "bdMiniList": false,
                            "bdPic": "",
                            "bdStyle": "0",
                            "bdSize": "16"
                        },
                        "share": {}
                    };
                    with(document) 0[(getElementsByTagName('head')[0] || body).appendChild(createElement('script')).src = 'http://bdimg.share.baidu.com/static/api/js/share.js?v=89860593.js?cdnversion=' + ~(-new Date() / 36e5)];
                </script>
                <!--分享代码 end-->

            </div>
        </div>
        <%--<div id="vedioDiv" style="text-indent: 0; margin: 20px auto;"></div>--%>
        <c:forEach items="${info.detailList }" var="detail">
            <div class="char clearfix">${detail.detailTitle }</div>
            <div class="videoAllShip">
                <iframe width="640" height="360" frameborder="0" allowfullscreen src="${detail.detailContent }"></iframe>
                    <%--<iframe width="320" height="240" frameborder="0" allowfullscreen src="http://mudu.tv/show/videolink/534031/origin"></iframe>--%>
            </div>
        </c:forEach>

    </div>
    <!--  评论 -->
    <div class="left zbPl">
        <div class="comment mt20 clearfix" id="divActivityComment" style="display: block;">
            <a name="comment"></a>
            <div class="comment-tit">
                <h3>我要评论</h3><span id="commentCount">${info.commentCount }条评论</span>
            </div>
            <form id="commentForm">
                <input type="hidden" value="${pageContext.session.id}" id="sessionId"/>
                <%
                    String userMobileNo = "";
                    if(session.getAttribute("terminalUser") != null){
                        CmsTerminalUser terminalUser = (CmsTerminalUser)session.getAttribute("terminalUser");
                        if(StringUtils.isNotBlank(terminalUser.getUserMobileNo())){
                            userMobileNo = terminalUser.getUserMobileNo();
                        }else{
                            userMobileNo = "0000000";
                        }
                    }
                %>
                <input type="hidden" id="userMobileNo" value="<%=userMobileNo%>"/>
                <textarea class="text" name="commentRemark" id="commentRemark" maxLength="200"></textarea>
                <div class="tips">
                    <div class="fl wimg">
                        <input type="hidden" name="commentImgUrl" id="headImgUrl" value=""/>
                        <input type="hidden" name="uploadType" value="Img" id="uploadType"/>
                        <div id="imgHeadPrev" style="position: relative; overflow: hidden;  float: left;">
                        </div>
                        <div style="float: left; margin-top: 0px;">
                            <div>
                                <input type="file" name="file" id="file"/>
                            </div>
                            <div class="comment_message" style="display: none">(最多三张图片)</div>
                            <div id="fileContainer" style="display: none;"></div>
                            <div id="btnContainer" style="display: none;"></div>
                        </div>
                    </div>
                    <div class="fr r_p">
                        <p style="color:#999999;">文明上网理性发言，请遵守新闻评论服务协议</p>
                        <input type="button" class="btn" value="发表评论" id="commentButton" onclick="addComment(20)"/>
                    </div>
                    <div class="clear"></div>
                </div>
            </form>
            <div class="comment-list" id="comment-list-div">
                <ul id="commentUl">

                </ul>
                <c:if test="${info.commentCount >= 5}">
                    <a href="javascript:;" class="load-more" onclick="moreComment(20)" id="viewMore">查看更多...</a>
                    <input type="hidden" id="commentPageNum" value="1"/>
                </c:if>
            </div>
        </div>
    </div>
</div>
<%@include file="/WEB-INF/why/index/footer.jsp" %>
</body>
</html>
<script type="text/javascript">
    /* start 详情大小图轮播 */
    $('.qiehuan').qiehuan({
        way:'slide',//slide:滑动，fade:渐隐渐现
        num:4,//默认小图显示个数
        btns:true,//左右按钮是否需要
        dt:false,//dt是否需要
        auto:5000,//自动切换时间
        animation:500//切换一个需要的时间
    });
    /* end 详情大小图轮播 */
</script>
<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
    String path = request.getContextPath();
    request.setAttribute("path", path);
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <%--<%@include file="/WEB-INF/why/common/pageFrame.jsp"%>--%>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <meta http-equiv="pragma" content="no-cache">
        <meta http-equiv="cache-control" content="no-cache">
        <meta http-equiv="expires" content="0">
        <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/reset.css"/>
        <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/main.css"/>
        <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/jquery.alerts.css">
        <!--[if lte IE 8]>
        <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/main-ie.css"/>
        <![endif]-->
        <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/page.css"/>
        <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/select2.css"/>
        <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
        <script type="text/javascript" src="${path}/STATIC/js/jquery.min.js"></script>
        <script type="text/javascript" src="${path}/STATIC/js/base.js"></script>
        <script type="text/javascript" src="${path}/STATIC/js/DatePicker/WdatePicker.js"></script>
        <script type="text/javascript" src="${path}/STATIC/js/common.js"></script>
        <script type="text/javascript" src="${path}/STATIC/js/jquery.alerts.js"></script>
        <script type="text/javascript" src="${path}/STATIC/js/location.js"></script>
        <script type="text/javascript" src="${path}/STATIC/js/page.min.js"></script>
        <script type="text/javascript" src="${path}/STATIC/js/jquery.uploadify-3.1.min.js"></script>
        <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>

    <link rel="Stylesheet" type="text/css" href="${path}/STATIC/css/DialogBySHF.css" />
    <script type="text/javascript" src="${path}/STATIC/js/DialogBySHF.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    <script type="text/javascript">

        seajs.config({
            alias: {
                "jquery": "jquery-1.10.2.js"
            }
        });

        seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
            window.dialog = dialog;
        });


        function uploadFun(type,userCounty,sessionId, num){
            var num = num ? num : "";
            var queueIDStr = num ? ('fileContainer'+num) : 'fileContainer';
            $("#file"+num).uploadify({
                'formData':{'uploadType':type,'type' :2 ,userCounty:userCounty},//传静态参数
                swf:'../STATIC/js/uploadify.swf',
                uploader:'../upload/uploadFile.do;jsessionid='+sessionId, //后台处理的请求
                buttonText:'选择图片',//上传按钮的文字
                'fileSizeLimit':'2MB',
                'buttonClass':"upload-btn",//按钮的样式
                queueSizeLimit:1, //   default 999
                'method': 'post',//和后台交互的方式：post/get
                queueID: queueIDStr,
                fileObjName:'file', //后台接受参数名称
                fileTypeExts:'*.gif;*.png;*.jpg;*.jpeg;', //控制可上传文件的扩展名，启用本项时需同时声明fileDesc
                'auto':true, //true当选择文件后就直接上传了，为false需要点击上传按钮才上传
                'multi':false, //是否支持多个附近同时上传
                height:44,//选择文件按钮的高度
                width:100,//选择文件按钮的宽度
                'debug':false,//debug模式开/关，打开后会显示debug时的信息
                'dataType':'json',
                removeCompleted:false,//上传成功后的文件，是否在队列中自动删除
                onUploadSuccess:function (file, data, response) {
                    var json = $.parseJSON(data);
                    var url=json.data;
                    var hiddenImgUrl = url ;
                    $("#voteCoverImgUrl"+num).val(url);
                    $("#btnContainer"+num).show();
                    if(num == ''){
                        //$("#imgHeadPrev"+num).html(getImgHtml(getImgUrl(url),300,200));
                        var initWidth = parseInt(json.initWidth);
                        var initHeigth = parseInt(json.initHeigth);
                        if(initWidth<750 || initHeigth<500){
                            dialogAlert("提示","请上传尺寸不小于750*500(px)的图片",function(){
                                $('#fileContainer'+num).html("");
                                $("#btnContainer"+num).hide();
                            });
                            $("#isCutImg").val("N");
                            return;
                        }

                        var cutImageWidth=750;
                        var cutImageHeigth=500;
                        var url =getImgUrl(url);
                        dialog({
                            url: "../att/toCutImgJsp.do",
                            data: {
                                imageUrl: url,
                                initWidth:initWidth,
                                initHeigth:initHeigth,
                                cutImageWidth:cutImageWidth,
                                cutImageHeigth:cutImageHeigth
                            },
                            title: '图片裁剪',
                            fixed: false,
                            onclose: function () {
                                if(this.returnValue){
                                    var imgUrl = this.returnValue.imageUrl;
                                    var isCutImg = this.returnValue.isCutImg;
                                    setTimeout(function(){
                                        $("#imgHeadPrev"+num).html(getImgHtml(imgUrl,300,200));
                                    },0);
                                    $("#isCutImg").val(isCutImg);
                                    $("#voteCoverImgUrl"+num).val(hiddenImgUrl);
                                    $("#imgHeadPrev"+num).val(getImgHtml(hiddenImgUrl,300,200));
                                }
                            }
                        }).showModal();

                        }else{
                        $("#imgHeadPrev"+num).html(getImgHtml(getImgUrl(url),100,100));
                    }
                    return false;
                },
                onSelect:function () { //插件本身没有单文件上传之后replace的效果
                    var notLast = $('#fileContainer'+num).find('div.uploadify-queue-item').not(':last');
                    notLast.remove();
                    $('#btnContainer'+num).show();
                },
                onCancel:function () {
                    $('#btnContainer'+num).hide();
                }
            });
        }

        $(function () {
            var type=$("#uploadType").val();
            var sessionId = $("#sessionId").val();
            var userCounty = $("#userCounty").val();
            uploadFun(type,userCounty,sessionId);
        });

        function clearQueue() {
            $('#file').uploadify('cancel', '*');
            $('#btnContainer').hide();
            $("#voteImgUrl").val('');
            $("#imgHeadPrev").html("<img   src='../STATIC/image/defaultImg.png' id='userHeadImg'>");
        }


        $(function(){
            //初始化获取图片
            getImg();
        });
        //编辑后获取图片
        getImg=function(){
            var imgUrl=$("#voteCoverImgUrl").val();
            if(imgUrl == undefined || imgUrl == ""){
                $("#imgHeadPrev").html("<img  src='../STATIC/image/defaultImg.png' id='userHeadImg'>");
            }else{
                imgUrl = getImgUrl(imgUrl);
                $("#imgHeadPrev").html("<img style='width:300px; height:200px;' src='"+imgUrl+"'>");
            }
        };

        function getImgHtml(imgUrl,width,height){
            if(imgUrl==""){
                return '<img src="../STATIC/image/defaultImg.png" />';
            }
            return '<img style="width:'+width+'px; height:'+height+'px;"  src="'+imgUrl+'" />';
        }

        $(function () {
            $(".btn-save").on("click", function(){

                 if (!getVoteRelevanceInfo()) {
                     return;
                 }

                var voteTitel = $("#voteTitel").val().trim();
                var activityName = $("#activityName").val();
                var voteDescribe = $("#voteDescribe").val();
                var voteCoverImgUrl = $("#voteCoverImgUrl").val();
                var voteContents = $("#voteContents").val();
                var voteImgUrls = $("#voteImgUrls").val();
                var flag = $("#flag").val();
                var flag1 = $("#flag1").val();
                if(voteTitel==undefined||voteTitel==""){
                    removeMsg("voteTitelLabel");
                    appendMsg("voteTitelLabel","请输入投票标题!");
                    $('#voteTitel').focus();
                    return;
                }else{
                    removeMsg("voteTitelLabel");
                }

                if(voteDescribe==undefined||voteDescribe==""){
                    removeMsg("voteDescribeLabel");
                    appendMsg("voteDescribeLabel","请输入投票说明!");
                    $('#voteDescribe').focus();
                    return;
                }else{
                    removeMsg("voteDescribeLabel");
                }

                if(activityName==undefined||activityName==""){
                    removeMsg("activityIdLabel");
                    appendMsg("activityIdLabel","请选择活动名称!");
                    $('#activityName').focus();
                    return;
                }else{
                    removeMsg("activityIdLabel");
                }

                if(voteCoverImgUrl==undefined||voteCoverImgUrl==""){
                    removeMsg("voteCoverImgUrlLabel");
                    appendMsg("voteCoverImgUrlLabel","请上传封面图片!");
                    $('#voteCoverImgUrl').focus();
                    return;
                }else{
                    removeMsg("voteCoverImgUrlLabel");
                }

                if(flag == "false" || flag1 == "false"){
                    return ;
                }
                $.post("${path}/vote/addActivityVote.do", $("#voteForm").serialize(),

                        function(data) {
                            if(data == "success"){
                                dialogSaveDraft("提示", "添加成功！", function(){
                                    window.location.href = "${path}/vote/activityVoteIndex.do";
                                })
                            }else if( data == "repeat"){
                                dialogSaveDraft("提示", "投票标题重复！", function(){
                                })
                            } else{
                                dialogSaveDraft("提示", "添加失败！", function(){
                                    // window.location.href = "${path}/vote/activityVoteIndex.do";
                                })
                            }
                        });

            });
        });

        function selectActivityList() {
            var winW = parseInt($(window).width()*0.8);
            var winH = parseInt($(window).height()*0.95);
            $.DialogBySHF.Dialog({
                Width: winW,
                Height: winH,
                URL: '${path}/activity/subjectActivityIndex.do?activityState=6'
            });
        }

        function getVoteRelevanceInfo() {

            var voteContent = new Array();
            var voteImgUrl = new Array();
            var flag = true;
            $("input[name='voteContent']").each(function(i,o) {

                if($(o).val() == "" || $(o).val() == undefined){
                        removeMsg("voteContentLabel"+(i+1));
                        appendMsg("voteContentLabel"+(i+1),"请将投票内容填写完整!");
                        $("#flag").val(false);
                         flag = false;
                        return false;
                }else{
                    removeMsg("voteContentLabel"+(i+1));
                    $("#flag").val(true);
                }
                voteContent.push($(o).val());
            }) ;
            if (!flag) {
                return false;
            }

            $("input[name='voteImgUrl']").each(function(i,o) {

                if($(o).val() == "" || $(o).val() == undefined){
                        removeMsg("voteContentLabel"+(i+1));
                        appendMsg("voteContentLabel"+(i+1),"请将投票内容填写完整!");
                        $("#flag1").val(false);
                         flag = false;
                        return false;
                }else{
                    removeMsg("voteContentLabel"+(i+1));
                    $("#flag1").val(true);
                }
                voteImgUrl.push($(o).val());
            }) ;

            if (!flag) {
                return false;
            }

            if(voteContent.length<=1 ||voteImgUrl.length<=1){
                removeMsg("voteContentLabel1");
                appendMsg("voteContentLabel1","请输入至少两个投票内容选项!");
                $("#flag").val(false);
                flag = false;
                return false;
            }
            $("#voteContents").val(voteContent.join(","));
            $("#voteImgUrls").val(voteImgUrl.join(","));
            return flag;
        }


    </script>

</head>
<body>

<div class="site">
    <em>您现在所在的位置：</em>投票管理 &gt;  新增投票
</div>
<div class="site-title">新增投票</div>
<input type="hidden" id="userCounty" value="${sessionScope.user.userCounty}" />
<form id="voteForm" method="post">
    <input type="hidden" id="referId" name="activityId" value=""/>
    <input type="hidden" id="voteContents" name="voteContents"/>
    <input type="hidden" id="voteImgUrls" name="voteImgUrls"/>
    <input type="hidden" id="flag" value=""/>
    <input type="hidden" id="flag1" value=""/>
    <div class="main-publish">
        <table  width="100%" class="form-table">
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>标题：</td>
                <td class="td-input" id="voteTitelLabel">
                    <input type="text" id="voteTitel" name="voteTitel" class="input-text w220" maxlength="100"/>
                </td>
            </tr>

            <tr>
                <td width="100" class="td-title"><span class="red" >*</span>投票说明：</td>
                <td class="td-input" id="voteDescribeLabel">
                    <textarea rows="8" cols="85" name="voteDescribe" id="voteDescribe" class="vote-des"></textarea>
                </td>
            </tr>

            <tr>
                <td width="100" class="td-title"><span class="red">*</span>活动名称：</td>
                <td class="td-input" id="activityIdLabel" style="position:relative;">
                    <input type="text" class="input-text w510" id="activityName" value="" readonly>
                    <a style="position:absolute; left:424px;top: 20px; background:#2079E0;display:inline-block; width: 100px; height: 28px; line-height: 28px;text-align: center; border-radius: 3px;-webkit-border-radius: 3px;-moz-border-radius: 3px; color: #ffffff; font-size: 12px;"  onclick="selectActivityList()">选择活动</a>
                </td>
            </tr>

            <tr>
                <td width="100" class="td-title"><span class="red">*</span>上传封面：</td>
                <td class="td-upload" id="voteCoverImgUrlLabel">
                    <input type="hidden"  name="voteCoverImgUrl" id="voteCoverImgUrl" value="${voteCoverImgUrl}">
                    <input type="hidden" name="uploadType" value="Img" id="uploadType"/>
                    <div class="img-box">
                        <div  id="imgHeadPrev" class="img"></div>
                    </div>
                    <div class="controls-box">
                        <div style="height: 46px;">
                            <div class="controls" style="float:left;">
                                <input type="file" name="file" id="file"/>
                            </div>
                            <span class="upload-tip">可上传1张图片，建议尺寸750*500像素，格式为jpg,jpeg,png,gif，大小不超过2M</span>
                        </div>
                        <div id="fileContainer"></div>
                        <div id="btnContainer" style="display: none;">
                            <a style="margin-left:335px;" href="javascript:clearQueue();" class="btn">取消</a>
                        </div>
                    </div>
                </td>
            </tr>

            <tr>
                <td width="100" class="td-title" ><span class="red">*</span>投票内容：</td>
                <td class="td-input td-upload td-vote" id="vote-list" >

                </td>

            </tr>

            <script type="text/javascript">
                function setHtml(num){
                    var html = '<div class="item" id="voteContentLabel'+num+'">' +
                            '<em>'+ num +'</em><input type="text" class="input-text w180" id="voteContent" name="voteContent" value=""/>' +
                            '<input type="hidden"  name="voteImgUrl" id="voteCoverImgUrl'+num+'" value=""><span class="img-box" id="imgHeadPrev'+ num +'"><img src="../STATIC/image/defaultImg.png" alt="" style="width: 52px; height: 46px; margin-top: 27px;"/></span>' +
                            '<div class="controls-box"><div style="height: 42px;"><div class="controls" style="float:left;"><input type="file" name="file" id="file'+ num +'"></div>' +
                            '<div id="fileContainer'+ num +'"></div>' +
                            '<div id="btnContainer'+ num +'" style="display: none;"><a style="margin-left:335px;" href="javascript:clearQueue();" class="btn">取消</a>' +
                            '</div></div></div>';
                    return html;
                }
                //投票内容 加  减
                $(function () {
                    var curIndex = 1;
                    var type=$("#uploadType").val();
                    var sessionId = $("#sessionId").val();
                    var userCounty = $("#userCounty").val();
                    var $voteList = $("#vote-list");
                    var html = "";
                    if(curIndex == 1){
                        html = setHtml(curIndex) + '<a class="icon-vote btn-add"></a></div>';
                        $voteList.append(html);
                        uploadFun(type,userCounty,sessionId, curIndex);
                    }
                    $("#vote-list").on("click", ".icon-vote", function(){
                        var $voteItem = $voteList.find(".item");
                        var $this = $(this);
                        if($this.hasClass("btn-add")) {
                            curIndex++;
                            html = "";
                            html = setHtml(curIndex) + '<a class="icon-vote btn-del"></a></div>';
                            $voteList.append(html);
                            uploadFun(type,userCounty,sessionId, curIndex);

                        }else if($this.hasClass("btn-del")){
                            curIndex--;
                            $voteItem.eq($voteItem.length - 1).detach();
                        }
                    });
                });
            </script>

            <tr>
                <td width="100" class="td-title">
                <td class="td-btn">
                    <input class="btn-save" type="button"  style="background-color:#f00000; margin: 0; width: 120px;" value="发布投票"/>
                </td>
            </tr>
        </table>
    </div>
</form>
</body>
</html>






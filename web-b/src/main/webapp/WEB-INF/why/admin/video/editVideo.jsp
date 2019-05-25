<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    <%--<script type="text/javascript" src="${path}/STATIC/js/jquery.uploadify-3.1.min.js"></script>--%>
    <script type="text/javascript">
        //绑定事件
        $(function(){
            $("#areaDiv li").mousedown(function(){
                if($(this).attr("data-option")==0){
                    $("#sbuject").show();
                }else{
                    $("#sbuject").hide();
                }
            });
            //日期控件
            $(".start-btn").on("click", function(){
                WdatePicker({el:'videoCreateTimeHidden',dateFmt:'yyyy-MM-dd',doubleCalendar:true,minDate:'', oncleared:function() {
                    $("#videoCreateTime").val("");
                },position:{left:-224,top:8},isShowClear:true,isShowOK:true,isShowToday:false,onpicked:pickedStartFunc})
            })
        });
        function pickedStartFunc(){
            $dp.$('videoCreateTime').value=$dp.cal.getDateStr('yyyy-MM-dd');
        }


        $(function(){
            $("#imgHeadPrev").html(getImgHtml(""));
            selectModel(function(){
                if($("#displayPosition").val() == 2){
                    $("#city-select").hide();
                    $("#advertPos").val("45");
                }else{
                    $("#city-select").show();
                }
            });
        });

        seajs.config({
            alias: {
                "jquery": "jquery-1.10.2.js"
            }
        });

        seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
            window.dialog = dialog;
        });

        window.console = window.console || {log:function () {}}
        seajs.use(['jquery'], function ($) {
            $(function () {
                var dialog = parent.dialog.get(window);


                /*点击确定按钮*/
                $(".btn-save").on("click", function(){
                    var videoTitle = $("#videoTitle").val();
                    var videoLink = $("#videoLink").val();
                    var videoImgUrl = $("#videoImgUrl").val();
                    var videoCreateTime = $("#videoCreateTime").val();
                    var videoCreateUser = $("#videoCreateUser").val();
                    var isCutImg =$("#isCutImg").val();

                    if("N"==isCutImg) {
                        dialogAlert("提示","请上传系统要求尺寸(800*600px)的图片",function(){
                        });
                        return;
                    }
                    if(videoTitle == ""){
                        dialogAlert("提示","请填写视频标题",function(){
                        });
                        return;
                    }
                    if(videoLink==""){
                        dialogAlert("提示","请填写视频链接",function(){
                        });
                        return;
                    }
                    if(videoImgUrl==""){
                        dialogAlert("提示","上传封面",function(){
                        });
                        return;
                    }
                    if(videoCreateTime==""){
                        dialogAlert("提示","请填写发布时间",function(){
                        });
                        return;
                    }
                    if(videoCreateUser==""){
                        dialogAlert("提示","请填写发布人",function(){
                        });
                        return;
                    }
                    $.post("${path}/video/editVideo.do", $("#editVideo").serialize(),
                            function(result) {
                                if(result != null && result == 'success'){
                                    parent.location.href="${path}/video/videoIndex.do?referId=" + $("#referId").val()+'&videoType=' + $("#videoType").val();
                                }else {
                                    dialogAlert("提示","操作失败！",function(){

                                    });
                                }
                            });
                     });
                /*点击取消按钮，关闭登录框*/
                $(".btn-cancel").on("click", function(){
                    dialog.close().remove();
                });
            });
        });
        $(function () {
            var type=$("#uploadType").val();
            var sessionId = $("#sessionId").val();
            var userCounty = $("#userCounty").val();
            $("#file").uploadify({
                'formData':{'uploadType':type,'type' :2 ,userCounty:userCounty},//传静态参数
                swf:'../STATIC/js/uploadify.swf',
                uploader:'../upload/uploadFile.do;jsessionid='+sessionId, //后台处理的请求
                buttonText:'上传封面',//上传按钮的文字
                'fileSizeLimit':'2MB',
                'buttonClass':"upload-btn",//按钮的样式
                queueSizeLimit:1, //   default 999
                'method': 'post',//和后台交互的方式：post/get
                queueID:'fileContainer',
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
                    var hiddenImgUrl = url;//数据库里面保存的路径
                    var initWidth = parseInt(json.initWidth);
                    var initHeigth = parseInt(json.initHeigth);
                    if(initWidth<800 || initHeigth<600){
                        dialogAlert("提示","请上传尺寸不小于800*600(px)的图片",function(){
                        });
                        $("#isCutImg").val("N");
                        return;
                    }

                    var cutImageWidth=800;
                    var cutImageHeigth=600;
                    var url =getImgUrl(url);
                    parent.dialog({
                        url: '${path}/att/toCutImgJsp.do',
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
                                    $("#imgHeadPrev").html(getImgHtml(imgUrl));
                                },0);
                                $("#isCutImg").val(isCutImg);
                                $("#videoImgUrl").val(hiddenImgUrl);
                            }
                        }
                    }).showModal();
                    return false;
                },
                onSelect:function () { //插件本身没有单文件上传之后replace的效果
                    var notLast = $('#fileContainer').find('div.uploadify-queue-item').not(':last');
                    notLast.remove();
                    $('#btnContainer').show();
                },
                onCancel:function () {
                    $('#btnContainer').hide();
                }
            });
        });



        function getImgHtml(imgUrl){
            if(imgUrl==""){
                return '<img src="../STATIC/image/defaultImg.png" />';
            }
            return '<img style="width:300px; height:200px;"  src="'+imgUrl+'" />';
        }
        function clearQueue() {
            $('#file').uploadify('cancel', '*');
            $('#btnContainer').hide();
            $("#videoImgUrl").val('');
            $("#imgHeadPrev").html("<img   src='../STATIC/image/defaultImg.png' id='userHeadImg'>");
        }
        function uploadQueue() {
            $('#file').uploadify('upload','*');
        }

        $(function(){
            //初始化获取图片
            getImg();
        });

        //编辑后获取图片
        getImg=function(){
            var imgUrl=$("#videoImgUrl").val();
            if(imgUrl == undefined || imgUrl == ""){
                $("#imgHeadPrev").html("<img src='../STATIC/image/defaultImg.png' id='userHeadImg'>");
            }else{
                imgUrl = getImgUrl(imgUrl);
                imgUrl = getIndexImgUrl(imgUrl,"_300_300")
                $("#imgHeadPrev").html("<img style='width:300px; height:200px;' src='"+imgUrl+"'>");
            }
        };
    </script>
</head>
<body style="background: none;">
<%--360下无法取得session--%>
<input type="hidden" id="userCounty" value="${sessionScope.user.userCounty}" />
<form id="editVideo" method="post">
    <input type="hidden" name="referId" id="referId" value="${referId}"/>
    <input type="hidden" name="videoType" id="videoType" value="${videoType}"/>
    <input type="hidden" name="videoId" id="videoId" value="${videoId}"/>
    <input type="hidden" id="isCutImg" value="Y"/>
<div class="main-publish tag-add">
    <table width="100%" class="form-table">
        <tr>
            <td width="28%" class="td-title"><span class="red">*</span>视频标题：</td>
            <td class="td-input">
                <input type="text" id="videoTitle" name="videoTitle"
                       value="${list[0].videoTitle}" class="input-text w220"/>
            </td>
        </tr>
        <tr>
            <td width="28%" class="td-title">发布人：</td>
            <td class="td-input">
                <input type="text" id="videoCreateUser" name="videoCreateUser"
                       value="${list[0].videoCreateUser}" class="input-text w220"/>
            </td>
        </tr>
        <tr>
            <td width="100" class="td-title">发布时间：</td>
            <td class="td-time"  id="videoCreateTimeLabel">
                <div class="start w240">
                    <input type="hidden" id="videoCreateTimeHidden"/>
                    <input type="text" id="videoCreateTime" name="videoCreateTime" value="<fmt:formatDate value="${list[0].videoCreateTime}" pattern="yyyy-MM-dd"/>" readonly/>
                    <i class=" start-btn"></i>
                </div>
            </td>
        </tr>
        <tr>
            <td width="28%" class="td-title"><span class="red">*</span>视频链接：</td>
            <td class="td-input" >
                <input type="text" id="videoLink" name="videoLink"
                       value="${list[0].videoLink}" class="input-text w220"/>
            </td>
        </tr>
        <tr>
            <td width="100" class="td-title"><span class="red">*</span>上传封面：</td>
            <td class="td-upload" id="videoImgUrlLabel">
                <table>
                    <tr>
                        <td>
                            <input type="hidden"  name="videoImgUrl" id="videoImgUrl" value="${list[0].videoImgUrl}">
                            <input type="hidden" name="uploadType" value="Img" id="uploadType"/>
                            <div class="img-box">
                                <div  id="imgHeadPrev" class="img"> </div>
                            </div>
                            <div class="controls-box" style="margin: 10px 0 0;">
                                <div style="height: 46px;">
                                    <div class="controls" style="float:left;">
                                        <input type="file" name="file" id="file">
                                    </div>
                                </div>
                                <div id="fileContainer"></div>
                                <div id="btnContainer" style="display: none;">
                                    <a style="margin-left:335px;" href="javascript:clearQueue();" class="btn">取消</a>
                                </div>
                            </div>
                        </td>
                    </tr>
                </table>
            </td>
        <tr>
            <td class="td-btn" align="center" colspan="1000">
                <a style="color: red" id="PromptMessger"></a>
            </td>
        </tr>
        </tr>
        <tr>
            <td class="td-btn" align="center" colspan="2">
                <input class="btn-save" type="button" value="保存"/>
                <input class="btn-cancel" type="button" value="取消"/>
            </td>
        </tr>
    </table>
</div>
</form>
</body>
</html>





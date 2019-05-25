<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <%@include file="/WEB-INF/why/common/limit.jsp" %>

    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <link rel="stylesheet" href="${path}/STATIC/js/ossjs/style.css" type="text/css"/>
    <!--文本编辑框 end-->
    <script type="text/javascript" src="${path}/STATIC/layer/layer.js"></script>
    <script type="text/javascript" src="${path}/STATIC/layer/extend/layer.ext.js"></script>
    <!-- dialog start -->
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    <%-- add   version   避免上传js浏览器缓存 --%>
    <link rel="stylesheet" href="${path}/STATIC/js/ossjs/style.css" type="text/css"/>
    <script type="text/javascript" src="${path}/STATIC/js/ossjs/uuid.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/ossjs/crypto.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/ossjs/hmac.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/ossjs/sha1.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/ossjs/base64.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/ossjs/plupload.full.min.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/ossjs/upload-img.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/ossjs/upload-files.js"></script>
    <script type="text/javascript" src="http://api.map.baidu.com/api?v=1.3"></script>
    <script type="text/javascript">

        /**
         * Created by cj on 2015/7/2.
         */
        seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
            window.dialog = dialog;
        });

        $(function () {

            //页面初始化时加载富文本编辑器
            var editor = CKEDITOR.replace('springEnrolment');
            var editor = CKEDITOR.replace('autumnEnrolment');

        });

        function addEnrolment(){
            var id = $("#id").val();
/*            var springEnrolment = CKEDITOR.instances.springEnrolment.getData();
            $("#springEnrolment").val(springEnrolment);
            var autumnEnrolment = CKEDITOR.instances.autumnEnrolment.getData();
            $("#autumnEnrolment").val(autumnEnrolment);
            var springImg = $("#springImg").val();
            var autumnImg = $("#autumnImg").val();
            if(springImg == null){
                dialogAlert("提示","请上传春季简章图片");
                return;
            }
            if(springEnrolment == null || springEnrolment == ''){
                dialogAlert("提示","请填写春季简章");
                return;
            }
            if(autumnImg == null){
                dialogAlert("提示","请上传秋季简章图片");
                return;
            }
            if(autumnEnrolment == null || autumnEnrolment == ''){
                dialogAlert("提示","请填写秋季简章");
                return;
            }*/
            var newSpringCount = $("#newSpringCount").val();
            var springCount = $("#springCount").val();
            var summerCount = $("#summerCount").val();
            var autumnCount = $("#autumnCount").val();
            if(newSpringCount == null || newSpringCount == ''){
                dialogAlert("提示","请填写新春班报名次数上限");
                return;
            }
            if(springCount == null || springCount == ''){
                dialogAlert("提示","请填写春季班报名次数上限");
                return;
            }
            if(summerCount == null || summerCount == ''){
                dialogAlert("提示","请填写暑期班报名次数上限");
                return;
            }
            if(autumnCount == null || autumnCount == ''){
                dialogAlert("提示","请填写秋季班报名次数上限");
                return;
            }
            //{"id":id,"springEnrolment":springEnrolment,"autumnEnrolment":autumnEnrolment,"springImg":springImg,"autumnImg":autumnImg}
            dialogConfirm("提示","确定要保存报名次数上限吗？",function () {
                $.post("${path}/train/saveEnrolment.do",$("#infoForm").serialize(), function (data) {
                    data = JSON.parse(data);
                    if ('200' == data.status) {
                        dialogAlert('提示', '保存成功', function () {
                            window.location.href="${path}/train/trainEnrolment.do"
                        });
                    } else {
                        dialogAlert('提示',"保存失败", function () {
                            window.location.href="${path}/train/trainEnrolment.do"
                        });
                    }
                });
            });
        }

        //上传封面回调函数
        function uploadImgCallbackHomepage(up, file, info) {
            $('#' + file.id).append("<input type='hidden' id='springImg' name='springImg' value='http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info + "'/>");
            //alert($("#beipiaoinfoHomepage").val());
        }

        //上传封面回调函数
        function uploadImgCallbackHomepage2(up, file, info) {
            $('#' + file.id).append("<input type='hidden' id='autumnImg' name='autumnImg' value='http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info + "'/>");
            //alert($("#beipiaoinfoHomepage").val());
        }

    </script>
</head>
<style>
    div[name=aliFile] br, div[name=aliFile] p, div[name=aliFile] span，.progress {
        display: none !important;
    }

    #webuploadhomepage  #webuploadhomepage2 div[name=aliFile] img:nth-child(1) {
        position: relative !important;
        max-width: 490px !important;
        max-height: 500px !important;
    }

    #webuploadhomepage  #webuploadhomepage2  div[name=aliFile] img:nth-child(1) {
        max-width: 750px;
        max-height: 500px;
    }

    #webuploadhomepage  #webuploadhomepage2  div[name=aliFile] {
        width: 750px !important;
        max-width: 500px !important;
    }

    #webuploadimages  #webuploadhomepage2  div[name=aliFile] img:nth-child(1) {
        position: relative !important;
        max-width: 560px !important;
        max-height: 420px !important;
    }

    #webuploadimages  #webuploadhomepage2  div[name=aliFile] img:nth-child(1) {
        max-width: 560px;
        max-height: 420px;
    }

    #webuploadimages  #webuploadhomepage2  div[name=aliFile] {
        width: 560px !important;
        max-width: 420px !important;
    }
</style>
<body>
<div class="site">
    <em>您现在所在的位置：</em>培训管理 &gt; 报名次数上限
</div>
<div class="site-title">报名次数上限管理</div>
<div class="main-publish">
    <form id="infoForm" method="post">
        <table width="100%" class="form-table">
         <input type="hidden" name="id" id="id" value="${enrolment.id}"/>
            <tr>
                <td width="130" class="td-title"><span class="red">*</span>新春班报名次数上限：</td>
                <td class="td-input" id="publisherNameLabel">
                    <input id="newSpringCount" name="newSpringCount" type="text" class="input-text w125" maxlength="10"
                           onkeyup="value=value.replace(/[^\d]/g,'')" VALUE="${enrolment.newSpringCount}"/>&nbsp;&nbsp;人
                </td>
            </tr>
            <tr>
                <td width="130" class="td-title"><span class="red">*</span>春季班报名次数上限：</td>
                <td class="td-input" id="publisherNameLabel2">
                    <input id="springCount" name="springCount" type="text" class="input-text w125" maxlength="10"
                           onkeyup="value=value.replace(/[^\d]/g,'')" VALUE="${enrolment.springCount}"/>&nbsp;&nbsp;人
                </td>
            </tr>
            <tr>
                <td width="130" class="td-title"><span class="red">*</span>暑期班报名次数上限：</td>
                <td class="td-input" id="publisherNameLabel3">
                    <input id="summerCount" name="summerCount" type="text" class="input-text w125" maxlength="10"
                           onkeyup="value=value.replace(/[^\d]/g,'')" VALUE="${enrolment.summerCount}"/>&nbsp;&nbsp;人
                </td>
            </tr>
            <tr>
                <td width="130" class="td-title"><span class="red">*</span>秋季班报名次数上限：</td>
                <td class="td-input" id="publisherNameLabel4">
                    <input id="autumnCount" name="autumnCount" type="text" class="input-text w125" maxlength="10"
                           onkeyup="value=value.replace(/[^\d]/g,'')" VALUE="${enrolment.autumnCount}"/>&nbsp;&nbsp;人
                </td>
            </tr>
            <%--<tr>
                <td width="100" class="td-title"><span class="red">*</span>春季简章封面：
                </td>
                <td class="td-upload" id="homepageLabel">
                    <table>
                        <tr>
                            <td>
                                <div class="whyVedioInfoContent" style="margin-top:-10px;">
                                    <div class="whyUploadVedio" id="webuploadhomepage">
                                        <div style="width: 700px;">
                                            <div id="ossfile2">
                                                <c:if test="${not empty enrolment.springImg}">
                                                    <div name="aliFile"
                                                         style="position:relative;margin-bottom:5px;margin-right:15px;max-width:130px;display:inline-block;">
                                                        <img style="max-height: 130px;max-width: 130px;left: 0;right: 0;top: 0;bottom: 0;margin: auto;"
                                                             src="${enrolment.springImg }"><br>
                                                        <img onclick="this.parentNode.remove();" id="aliRemoveBtn"
                                                             src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201733161236Bn6gTqiCZBHhgObFvsCkLFNzmIBoh2.png"
                                                             style="right:0;top:0;width:20px">
                                                        <input id="springImg" name="springImg"
                                                               value="${enrolment.springImg }" type="hidden">
                                                    </div>
                                                </c:if>
                                            </div>
                                            <div id="container2" style="clear:both;">
                                                <a id="selectfiles2" href="javascript:void(0);" class='btn'
                                                   style="width: 120px;background-color: #1882FC;">选择封面</a>
                                                <pre style="font-size: 14px;color: #999;line-height: 25px;">Tip：可上传1张图片，建议尺寸<span
                                                        style="color:red">750*500像素</span>，格式为jpg、jpeg、png、gif，大小不超过<span
                                                        style="color:red">2M</span></pre>
                                            </div>
                                            <script type="text/javascript">
                                                // 图片
                                                aliUploadImg('webuploadhomepage', uploadImgCallbackHomepage, 1, true, 'beipiao');
                                            </script>
                                        </div>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>春季简章：</td>
                <td class="td-content">
                    <div class="editor-box">
                        <textarea id="springEnrolment" name="springEnrolment" rows="8"
                                  class="textareaBox"
                                  style="width: 500px;resize: none">${enrolment.springEnrolment}</textarea>
                    </div>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>秋季简章封面：
                </td>
                <td class="td-upload" id="homepageLabel2">
                    <table>
                        <tr>
                            <td>
                                <div class="whyVedioInfoContent" style="margin-top:-10px;">
                                    <div class="whyUploadVedio" id="webuploadhomepage2">
                                        <div style="width: 700px;">
                                            <div id="ossfile2">
                                                <c:if test="${not empty enrolment.autumnImg}">
                                                    <div name="aliFile"
                                                         style="position:relative;margin-bottom:5px;margin-right:15px;max-width:130px;display:inline-block;">
                                                        <img style="max-height: 130px;max-width: 130px;left: 0;right: 0;top: 0;bottom: 0;margin: auto;"
                                                             src="${enrolment.autumnImg }"><br>
                                                        <img onclick="this.parentNode.remove();" id="aliRemoveBtn"
                                                             src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201733161236Bn6gTqiCZBHhgObFvsCkLFNzmIBoh2.png"
                                                             style="right:0;top:0;width:20px">
                                                        <input id="autumnImg" name="autumnImg"
                                                               value="${enrolment.autumnImg }" type="hidden">
                                                    </div>
                                                </c:if>
                                            </div>
                                            <div id="container2" style="clear:both;">
                                                <a id="selectfiles2" href="javascript:void(0);" class='btn'
                                                   style="width: 120px;background-color: #1882FC;">选择封面</a>
                                                <pre style="font-size: 14px;color: #999;line-height: 25px;">Tip：可上传1张图片，建议尺寸<span
                                                        style="color:red">750*500像素</span>，格式为jpg、jpeg、png、gif，大小不超过<span
                                                        style="color:red">2M</span></pre>
                                            </div>
                                            <script type="text/javascript">
                                                // 图片
                                                aliUploadImg('webuploadhomepage2', uploadImgCallbackHomepage2, 1, true, 'beipiao');
                                            </script>
                                        </div>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>秋季简章：</td>
                <td class="td-content">
                    <div class="editor-box">
                        <textarea id="autumnEnrolment" name="autumnEnrolment" rows="8" class="textareaBox"
                                  style="width: 500px;resize: none">${enrolment.autumnEnrolment}</textarea>
                    </div>
                </td>
            </tr>--%>

            <tr>
                <td width="100" class="td-title"></td>
                <td class="td-btn">
                    <input style="background-color: #999" type="button" value="取消" class="btn-publish"
                           onclick="javascript:history.back(-1)">
                    <input id="btnPublish" class="btn-publish" type="button" onclick="addEnrolment()" value="保存"/>
                </td>
            </tr>
        </table>
    </form>

</div>
</body>
</html>
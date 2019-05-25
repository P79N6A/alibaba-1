<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <%@include file="/WEB-INF/why/common/limit.jsp" %>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <link rel="stylesheet" href="${path}/STATIC/js/ossjs/style.css" type="text/css"/>
    <link rel="stylesheet" href="${path}/STATIC/css/whyupload.css" type="text/css"/>
    <!--文本编辑框 end-->
    <script type="text/javascript" src="${path}/STATIC/layer/layer.js"></script>
    <script type="text/javascript" src="${path}/STATIC/layer/extend/layer.ext.js"></script>
    <!-- dialog start -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/admin/venue/addVenue.js?version=20151120"></script>
    <%-- add   version   避免上传js浏览器缓存 --%>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/admin/jiazhouInfo/addjiazhouInfo.js"></script>
    <link rel="stylesheet" href="${path}/STATIC/js/ossjs/style.css" type="text/css"/>
    <script type="text/javascript" src="${path}/STATIC/js/ossjs/uuid.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/ossjs/crypto.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/ossjs/hmac.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/ossjs/sha1.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/ossjs/base64.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/ossjs/plupload.full.min.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/ossjs/upload-img.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/ossjs/upload-files.js"></script>
    <script type="text/javascript">
        function reload() {
            window.location.href = "${path}/beipiaoCarousel/carouselList.do?carouselType=${param.carouselType}";
        }

        //上传图片回调函数
        function uploadImgCallbackHomepage(up, file, info) {
            $('#' + file.id).append("<input type='hidden' id='carouselImage' name='carouselImage' value='http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info + "'/>");
            //alert($("#beipiaoinfoHomepage").val());
        }

        //前端校验数据
        function addCarousel() {

            var carouselTitle = $("#carouselTitle").val();
            var carouselImage = $("#carouselImage").val();
            var pccarouselUrl = $("#pccarouselUrl").val();
            var h5carouselUrl = $("#h5carouselUrl").val();

            if (carouselTitle == undefined || carouselTitle == "") {
                removeMsg("titleLabel");
                appendMsg("titleLabel", "标题不能为空!");
                $("#titleLabel").focus();
                window.location.hash = "#titleLabel";
                return;
            } else {
                removeMsg("titleLabel");
            }

            if (pccarouselUrl == undefined || pccarouselUrl == "") {
                removeMsg("pcurlLabel");
                appendMsg("pcurlLabel", "PC链接不能为空!");
                $("#urlLabel").focus();
                window.location.hash = "#urlLabel";
                return;
            } else {
                removeMsg("pcurlLabel");
            }

            if (h5carouselUrl == undefined || h5carouselUrl == "") {
                removeMsg("h5urlLabel");
                appendMsg("h5urlLabel", "H5链接不能为空!");
                $("#urlLabel").focus();
                window.location.hash = "#urlLabel";
                return;
            } else {
                removeMsg("h5urlLabel");
            }

            if (carouselImage == undefined || carouselImage == "") {
                removeMsg("homepageLabel");
                appendMsg("homepageLabel", "图片不能为空!");
                $('#homepageLabel').focus();
                window.location.hash = "#homepageLabel";
                return;
            } else {
                removeMsg("homepageLabel");
            }

            $.post("${path}/beipiaoCarousel/addCarousel.do", $('#infoForm').serialize(), function (data) {
                if (data != null && data == 'success') {
                    dialogAlert("提示", "添加成功！", function () {
                        window.location.href = "${path}/beipiaoCarousel/carouselList.do?carouselType=${param.carouselType}";
                    });
                } else if (data == "nologin") {
                    dialogConfirm("提示", "请先登录！", function () {
                        window.location.href = "${path}/login.do";
                    });
                } else {
                    dialogConfirm("提示", "添加失败！")
                }
            });
        }

    </script>
</head>
<style>
    div[name=aliFile] br, div[name=aliFile] p, div[name=aliFile] span，.progress {
        display: none !important;
    }

    #webuploadhomepage div[name=aliFile] img:nth-child(1) {
        position: relative !important;
        max-width: 750px !important;
        max-height: 400px !important;
    }

    #webuploadhomepage div[name=aliFile] img:nth-child(1) {
        max-width: 750px;
        max-height: 400px;
    }

    #webuploadhomepage div[name=aliFile] {
        width: 750px !important;
        max-width: 400px !important;
    }
</style>
<body>
<div class="site">
    <em>您现在所在的位置：</em>动态资讯 &gt; 添加首页轮播图
</div>
<div class="site-title">添加首页轮播图</div>
<div class="main-publish">
    <form id="infoForm" method="post"/>
    <table width="100%" class="form-table">
        <tr>
            <td width="100" class="td-title"><span class="red">*</span>标题：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
            <td class="td-input" id="titleLabel">
                <input id="carouselTitle" name="carouselTitle" type="text" class="input-text w510"/>
                <input id="carouselType" name="carouselType" type="hidden" value="${param.carouselType}"/>
                <span class="error-msg"></span>
            </td>
        </tr>

        <tr>
            <td width="100" class="td-title"><span class="red">*</span>PC链接：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
            <td class="td-input" id="pcurlLabel">
                <input id="pccarouselUrl" name="carouselUrl" type="text" class="input-text w510"/>
                <span class="error-msg"></span>
            </td>
        </tr>

        <tr>
            <td width="100" class="td-title"><span class="red">*</span>H5链接：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
            <td class="td-input" id="h5urlLabel">
                <input id="h5carouselUrl" name="carouselUrl" type="text" class="input-text w510"/>
                <span class="error-msg"></span>
            </td>
        </tr>

        <tr>
            <td width="100" class="td-title"><span class="red">*</span>图片：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
            <td class="td-upload" id="homepageLabel">
                <table>
                    <tr>
                        <td>
                            <div class="whyVedioInfoContent" style="margin-top:-10px;">
                                <div class="whyUploadVedio" id="webuploadhomepage">
                                    <div style="width: 700px;">
                                        <div id="ossfile2"></div>
                                        <div id="container2" style="clear:both;">
                                            <a id="selectfiles2" href="javascript:void(0);" class='btn'
                                               style="width: 120px">选择封面</a>
                                            <pre style="font-size: 14px;color: #999;line-height: 25px;">Tip：可上传1张图片，建议尺寸<span
                                                    style="color:red">1200*400像素，大小必须小于2M</span></pre>
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
            <td width="100" class="td-title"></td>
            <td class="td-btn">
                <input id="btnPublish" class="btn-save" style="width: 120px" type="button" onclick="addCarousel()"
                       value="保存"/>
                <input class="btn-publish" type="button" style="background-color:#C0C0C0 " onclick="reload();"
                       value="返回"/>
            </td>
        </tr>
    </table>
    </form>
</div>
</body>
</html>
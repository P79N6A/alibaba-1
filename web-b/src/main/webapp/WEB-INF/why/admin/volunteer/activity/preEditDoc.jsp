<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>修改活动纪实--文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <script type="text/javascript" src="${path}/STATIC/js/admin/terminalUser/UploadTerminalUserFile.js?version=20151127"></script>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    <link rel="stylesheet" href="${path}/STATIC/js/ossjs/style.css" type="text/css" />
    <script type="text/javascript" src="${path}/STATIC/js/ossjs/uuid.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/ossjs/crypto.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/ossjs/hmac.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/ossjs/sha1.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/ossjs/base64.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/ossjs/plupload.full.min.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/ossjs/upload-img.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/ossjs/upload-files.js"></script>
    <script type="text/javascript">
        $(function(){
            // getArea();
            var uuid = $('#uuid').val();
            if(uuid){
                $('#title').html('修改活动纪实');
                $('title').val('修改活动纪实--文化云');
            }else {
                $('#title').html('新增活动纪实');
                $('title').val('新增活动纪实--文化云');
            }
            selectModel();
            selectResourceType();
        });


        seajs.config({
            alias: {
                "jquery": "jquery-1.10.2.js"
            }
        });

        seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
            window.dialog = dialog;
        });


        // 初始化时资源类型选中
        function selectResourceType(){
            var resourceType = $('#hidResourceType').val();
            if(resourceType == 1){
                $("#resourceTypeDiv").html("图片");
            }
            else if(resourceType == 2){
                $("#resourceTypeDiv").html("视频");
            }
            else if(resourceType == 2){
                $("#resourceTypeDiv").html("音频");
            }
        }

        //上传附件回调函数
        function uploadImgCallbackResourceSite(up, file, info){

            var html = "<a href='http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info+"' target=\"_blank\">查看附件</a>"
                +"<input type='hidden' id='resourceSite' name='resourceSite' value='http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info+"'/>";
            $('#'+file.id).append(html)
        }

        //编辑表单
        function handleEdit() {

            var resourceName = $("#resourceName").val();
            var resourceType = $("#resourceType").val();
            var resourceSite = $("#resourceSite").val();

            // 名称
            if(resourceName == undefined || $.trim(resourceName) == ""){
                removeMsg("resourceNameLabel");
                appendMsg("resourceNameLabel","请输入资源名称!");
                $("#resourceName").focus();
                return false;
            }else{
                removeMsg("resourceNameLabel");
            }

            // 资源类型
            if(resourceType == undefined || $.trim(resourceType) == ""){
                removeMsg("resourceTypeLabel");
                appendMsg("resourceTypeLabel","资源类型必选!");
                $("#resourceType").focus();
                return false;
            }else{
                removeMsg("resourceTypeLabel");
            }



            var post = {
                uuid: $('#uuid').val(),
                ownerId: $('#activityId').val(),
                resourceName: resourceName,
                resourceType: resourceType,
                resourceSite: resourceSite
            }
            var title = post.uuid ? '修改' : '新增';
            var url = post.uuid ? '${path}/VolunteerActivityDemeanorDocumentary/editVolunteerActivityDemeanorDocumentary.do' : '${path}/VolunteerActivityDemeanorDocumentary/addVolunteerActivityDemeanorDocumentary.do';
            $.ajax({
                type: 'post',
                url: url,
                data: post,
                dataType: 'json',
                success: function (res) {
                    if (res && res == 'success') {
                        dialogSaveDraft("提示", title + "成功", function(){
                            var param = post.uuid ? '?activityId=' + post.uuid : '';
                            window.location.href = "${path}/VolunteerActivityDemeanorDocumentary/documentaryList.do" + param;
                        });
                    }else {
                        dialogSaveDraft("提示", title + "失败")
                    }
                }
            });
        }
    </script>
    <style>
        div[name=aliFile] br,div[name=aliFile] p,div[name=aliFile] span，.progress{display:none!important;}
        #webuploadhomepage div[name=aliFile] img:nth-child(1){position:relative!important;max-width:750px!important;max-height:500px!important;}
        #webuploadhomepage div[name=aliFile] img:nth-child(1){max-width:750px;max-height:500px;}
        #webuploadhomepage div[name=aliFile]{width:750px!important;max-width:500px!important;}
        #webuploadimages div[name=aliFile] img:nth-child(1){position:relative!important;max-width:560px!important;max-height:420px!important;}
        #webuploadimages div[name=aliFile] img:nth-child(1){max-width:560px;max-height:420px;}
        #webuploadimages div[name=aliFile]{width:560px!important;max-width:420px!important;}
    </style>
</head>
<body>
<form action="" id="activityForm" method="post">
    <input type="hidden" id="activityId" name="activityId" value="${activityId}">
    <input type="hidden" id="uuid" name="uuid" value="${volunteerActivity.uuid}">
    <input type="hidden" id="hidResourceType" value="${volunteerActivity.resourceType}">

<div class="site">
    <em>您现在所在的位置：</em>文化志愿者 &gt; 活动纪实管理
</div>
<div class="site-title" id="title">修改活动纪实</div>

<div class="main-publish">
    <table width="100%" class="form-table">
        <tr>
            <td width="100" class="td-title"><span class="red">*</span>资源名称：</td>
            <td class="td-input" id="resourceNameLabel">
                <input type="text" value="${documentary.resourceName}" id="resourceName" name="resourceName" class="input-text w210" maxlength="20"/>
            </td>
        </tr>
        <tr>
            <td class="td-title"><span class="red">*</span>资源类型：
                <input type="text" id="resourceTypeLimit" style="position: absolute; left: -9999px;" />
            </td>
            <td class="td-select" id="resourceTypeLabel">
                <div class="select-box w140">
                    <input type="hidden" id="resourceType" value="${documentary.resourceType}" name="resourceType"/>
                    <div class="select-text" data-value="" id="resourceTypeDiv">全部类别</div>
                    <ul class="select-option" id="resourceTypeUl">
                        <li data-option="1">图片</li>
                        <li data-option="2">视频</li>
                        <li data-option="3">音频</li>
                    </ul>
                </div>
            </td>
        </tr>
        <tr>
            <td width="100" class="td-title">上传资源：</td>
            <td class="td-upload" id="videoLabel">
                <table>
                    <tr>
                        <td>
                            <div class="whyVedioInfoContent" style="margin-top:-10px;">
                                <div class="whyUploadVedio" id="webuploadatresourceSite">
                                    <div style="width: 700px;">
                                        <div id="ossfile2">
                                            <c:if test="${documentary.resourceSite!=null && documentary.resourceSite != '' }">
                                                <div name="aliFile" style="position:relative;margin-bottom:5px;margin-right:15px;max-width:130px;display:inline-block;" >
                                                    <img onclick="remove(this);" id="aliRemoveBtn" src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201733161236Bn6gTqiCZBHhgObFvsCkLFNzmIBoh2.png" style="position:absolute;right:0;top:0;width:20px;z-index:10;">
                                                    <a href='${documentary.resourceSite }' target="_blank">查看资源</a>
                                                    <input id="resourceSite" name="resourceSite" value="${documentary.resourceSite }" type="hidden">
                                                </div>
                                            </c:if>
                                        </div>
                                        <div id="container2" style="clear:both;">
                                            <a id="selectfiles2" href="javascript:void(0);" class='btn' style="width: 120px;background-color: #1882FC">上传附件</a>
                                            <%--<pre style="font-size: 14px;color: #999;line-height: 25px;">Tip：<span style="color:red">仅支持MP4</span></pre>--%>
                                        </div>
                                        <script type="text/javascript">
                                            // 视频
                                            aliUploadFiles('webuploadatresourceSite', uploadImgCallbackResourceSite, 1, true, 'beipiao');
                                        </script>
                                    </div>
                                </div>
                            </div>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr class="td-btn">
            <td></td>
            <td>
                <input type="button" value="保存" class="btn-save" onclick="javascript:return handleEdit();"/>
                <input type="button" value="返回" class="btn-publish" onclick="javascript:history.back(-1);"/>
            </td>
        </tr>
    </table>
</div>
</form>
</body>
</html>
<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:setLocale value="zh_CN"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/html">
<head>
    <title>修改馆藏</title>
    <%@include file="../../common/pageFrame.jsp"%>
    <script type="text/javascript" src="${path}/STATIC/js/admin/antique/UploadAntiqueImg.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/admin/antique/UploadAntiqueAudio.js"></script>
   <%-- <script type="text/javascript" src="${path}/STATIC/js/admin/antique/getAntiqueImg.js"></script>--%>
    <%--    <script type="text/javascript" src="${path}/STATIC/js/area-venues-admin.js"></script>--%>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/area-venues-admin.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    <style type="text/css">
        /*.ui-dialog-close{ display: none;}*/
    </style>

    <script type="text/javascript">
        //富文本编辑器
        window.onload = function(){
            var editor = CKEDITOR.replace('antiqueRemark');
        }
        //下拉框选中 查询子数据
        $(function() {
            var venueId= $("#hiddenVenueId").val();
            var tagType = $('#antiqueVenueId').val();
            var tagDynasty=$("#antiqueYears").val();
            $.post(
                    "${path}/antiqueType/getTypeList.do",
                    {
                        'venueId' : venueId
                    },
                    function(data) {
                        if (data != '' && data != null) {
                            var list = eval(data);
                            //var ulHtml = '<li data-option="">所有分类</li>';
                            var ulHtml='';
                            for (var i in data) {
                                var dict = list[i];
                                ulHtml += '<li data-option="'+dict.antiqueTypeId+'">'
                                + dict.antiqueTypeName + '</li>';
                                if (tagType != '' && dict.antiqueTypeId == tagType) {
                                    $('#tagTypeDiv').html(dict.antiqueTypeName);
                                }
                            }
                            $('#tagTypeUl').html(ulHtml);
                        }
                    }).success(function() {
                        $.post(
                                "${path}/sysdict/queryChildSysDictByDictCode.do",
                                {
                                    'dictCode' : 'DYNASTY'
                                },
                                function(data) {
                                    if (data != '' && data != null) {
                                        var list = eval(data);
                                        //var ulHtml = '<li data-option="">所有朝代</li>';
                                        var ulHtml='';
                                        for (var i in data) {
                                            var dict = list[i];
                                            ulHtml += '<li data-option="'+dict.dictId+'">'
                                            + dict.dictName + '</li>';
                                            if (tagDynasty != '' && dict.dictId == tagDynasty) {
                                                $('#tagDynastyDiv').html(dict.dictName);
                                            }
                                        }
                                        $('#tagDynasty').html(ulHtml);
                                    }
                                }).success(function() {
                                    selectModel();
                                });
                    });

        });

        //选中所属博物馆
 /*       $(function(){
            var venueArea = '${cmsVenue.venueArea}';
            venueArea = venueArea.substring(0,venueArea.indexOf(","));
            showVenueData(venueArea,'${cmsVenue.venueType}','${cmsVenue.venueId}');
        });*/

        function addErrMsg(id,content){
            $("#"+id).html(content);
        }
        function rmErrMsg(id){
            $("#"+id).html("");
        }

        function valMethod(focusId,strVal,errId,strErr){
            if($.trim(strVal)){
                rmErrMsg(errId);
                return true;
            }else{
                addErrMsg(errId,strErr);
                $("#"+focusId).focus();
                return false;
            }
            return false;
        }

        function checkValidation(){
            $('#antiqueRemark').val(CKEDITOR.instances.antiqueRemark.getData());

            var antiqueName=$('#antiqueName').val();
            //var venueVal = $("#loc_venue").val();
            var antiqueVenueId = $("#antiqueVenueId").val();
            //var antiqueImgUrl = $("#antiqueImgUrl").val();
            var antiqueYears =$("#antiqueYears").val();
            var antiqueGalleryAddress =$("#antiqueGalleryAddress").val();
            var antiqueRemark = $('#antiqueRemark').val();
           /* if(venueVal==undefined||venueVal==""){
                addErrMsg("venueIdLabelErr","所属场馆为必填项!");
                $('#loc_area').focus();
                return false;
            }else{
                rmErrMsg("venueIdLabelErr");
            }*/
            if(!valMethod("antiqueName",antiqueName,"antiqueNameLabelErr","馆藏名称为必填项!")){
                return  false;
            }
            
            if($.trim(antiqueName)){
                rmErrMsg("antiqueNameLabelErr");
                if(antiqueName.length>20){
                	addErrMsg("antiqueNameLabelErr","馆藏名称只能输入20字以内!");
                    $('#antiqueName').focus();
                    return false;
                }
            }

            if(! valMethod("antiqueVenueId",antiqueVenueId,"antiqueVenueIdLabelErr","馆藏分类为必填项!")){
                return  false;
            }

            if(!valMethod("antiqueYears",antiqueYears,"antiqueYearsErr","馆藏年代为必填项!")){
                return  false;
            }

            if($.trim(antiqueRemark)){
                rmErrMsg("antiqueRemarkErr");
            }else{
                addErrMsg("antiqueRemarkErr","馆藏简介为必填项!");
                $('#antiqueRemark').focus();
                return false;
            }

/*            if(!valMethod("antiqueGalleryAddress",antiqueGalleryAddress,"antiqueGalleryAddressErr","馆藏区域为必填")){
                return  false;
            }*/

            return true;

        }
           /* if(antiqueImgUrl==undefined||antiqueImgUrl==""){
                addErrMsg("antiqueImgUrlLabelErr","馆藏图片为必填项!");
                $('#antiqueImgUrl').focus();
                return false;
            }else{
                rmErrMsg("antiqueImgUrlLabelErr");
            }*/
        /*    if($.trim(antiqueVenueId)){
                rmErrMsg("antiqueVenueIdLabelErr");
            }else{
                addErrMsg("antiqueVenueIdLabelErr","馆藏分类为必填项!");
                $('#antiqueVenueId').focus();
                return false;
            }*/
  /*          if($.trim(antiqueYears)){
                rmErrMsg("antiqueYearsErr");
            }else{
                addErrMsg("antiqueYearsErr","馆藏年代为必填项!");
                $('#antiqueYears').focus();
                return false;
            }*/

/*
            if($.trim(antiqueGalleryAddress)){
                rmErrMsg("antiqueGalleryAddressErr");
            }else{
                addErrMsg("antiqueGalleryAddressErr","馆藏区域为必填");
                $("#antiqueGalleryAddress").focus();
                return false;
            }
*/


            //return true;

        //提交表单
        function updateAntique(state){



            var isCutImg =$("#isCutImg").val();
            if("N"==isCutImg) {
                dialogAlert("提示","请先裁剪系统要求尺寸(750*500)的图片，再提交！",function(){
                });
                return;
            }
            //cke_144_fileInput
            var validateResult = checkValidation();
            //富文本编辑器

            if(!validateResult){
                return;
            }

            $("#antiqueState").val(state);
            var venueId= $("#hiddenVenueId").val();
            $.post("${path}/antique/editAntique.do", $("#antique_update_form").serialize(),
                    function(data) {
                        if (data!=null && data=='success') {
                            var html = "<h2>修改成功</h2>";
                            dialogSaveDraft("提示", html, function(){
                                if(""!=venueId){
                                    window.location.href = "${path}/antique/antiqueIndex.do?antiqueState="+state+"&venueId="+venueId;
                                }else{
                                    window.location.href = "${path}/antique/antiqueIndex.do?antiqueState="+state+"&asm="+new Date().getTime();
                                }
                            });
                        } else {
                            var html = "<h2>修改失败,请联系管理员</h2>";
                            dialogSaveDraft("提示", html, function(){

                            });
                        }
                    });
            }


        seajs.config({
            alias: {
                "jquery": "jquery-1.10.2.js"
            }
        });

        seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
            window.dialog = dialog;
        });
        seajs.use(['jquery'], function ($) {


            $('.upload-cut-btn').on('click', function () {
                var cutImageSize;
                var width;
                var height;
                cutImageSize="750*500";

                var urlStr = $("#antiqueImgUrl").val();

                var url =getImgUrl(urlStr);
                dialog({
                    url: '${path}/att/toCutImgJsp.do?imageURL='+url+'&cutImageSize='+cutImageSize,
                    title: '图片裁剪',
                    fixed: false,
                    onclose: function () {
                        if(this.returnValue){
                            //alert("返回值：" + this.returnValue.imageUrl);
                            $("#imgHeadPrev").html(getImgHtml(this.returnValue.imageUrl));
                            $("#antiqueImgUrl").val(this.returnValue.imageUrl);
                        }
                    }
                }).showModal();
                return false;
            });
        });


    </script>
</head>
<body>
<input id="sessionId"  type="hidden" value="${pageContext.session.id}" />
<input type="hidden" id="userCounty" value="${sessionScope.user.userCounty}" />
<input type="hidden" id="isCutImg" value="Y"/>

<form id="antique_update_form"  method="post">
    <!-- 正中间panel -->
    <input type="hidden" value="${cmsVenue.venueId}" name="venueId" id="hiddenVenueId"/>
    <div class="site">
        <em>您现在所在的位置：</em>场馆管理 &gt; 场馆信息管理&gt; 藏品管理 &gt; 编辑藏品
    </div>
    <div class="site-title">编辑藏品</div>
    <div class="main-publish">
        <table width="100%" class="form-table">
            <%--Id 状态 是否删除--%>
            <input type="hidden" id="antiqueId" name="antiqueId" value="${record.antiqueId}"/>
            <input id="antiqueIsDel2" type="hidden" name="antiqueIsDel2" value="${antiqueIsDel}"/>
            <input id="antiqueState2" type="hidden" name="antiqueState2" value="${antiqueState}"/>

            <tr>
                <td width="100" class="td-title">所属场馆：</td>
                <td class="td-input">${cmsVenue.venueName}</td>
<%--                <td class="td-input" id="venueIdLabel" colspan="3">
                    <div>
                        <select id="loc_area" name="" style="width:110px; margin-left: 10px"></select>
                        <select id="loc_category" name="" style="width:110px; margin-left: 10px"></select>
                        <select id="loc_venue"  name="venueId" style="width:200px;margin-left: 10px"></select>
                    </div>
                    <span class="error-msg" id="venueIdLabelErr"></span>
                </td>--%>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>藏品名称：</td>
                <td class="td-input">
                    <input type="text" id="antiqueName" name="antiqueName" value='<c:out value="${record.antiqueName}" escapeXml="true"/>' class="input-text w510" maxlength="20"/>
                    <span class="error-msg" id="antiqueNameLabelErr"></span>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>上传封面：</td>

                <td class="td-upload" id="activityIconUrlLabel">
                    <table>
                        <tr>
                            <td>

                                <input type="hidden"  name="antiqueImgUrl" id="antiqueImgUrl" value="${record.antiqueImgUrl}">
                                <input type="hidden" name="uploadType" value="Img" id="uploadType"/>

                                <div class="img-box">
                                    <div id="imgHeadPrev" class="img"></div>
                                </div>

                                <div class="controls-box">
                                    <div style="height: 46px;">
                                        <div class="controls" style="float:left;">
                                            <input type="file" name="file" id="file">
                                        </div>
                                        <%--<input type="button" class="upload-cut-btn" id="" value="裁剪图片"/>--%>
                                        <span class="upload-tip">可上传1张图片，建议尺寸750*500像素，格式为jpg,jpeg,png,gif，大小不超过2M</span>


                                    </div>
                                    <div id="fileContainer"></div>
                                    <div id="btnContainer" style="display: none;">
                                        <a style="margin-left:335px;" href="javascript:clearQueue();" class="btn">取消</a>
                                    </div>
                                </div>

                            </td>
                        </tr>
                    </table>

<%--                    <table>
                        <tr>
                            <td width="80"><span id="imgShow"></span></td>
                            <td>
                                <input type="hidden" name="antiqueImgUrl" id="antiqueImgUrl"  value="${record.antiqueImgUrl}" >
                                <input type="hidden" name="uploadType" value="Img" id="uploadType"/>
                                <div style="float: left; margin-left: 20px;">
                                    <div style="height: 30px;">
                                        <div class="controls" style="float:left;">
                                            <input type="file" name="file" id="file">
                                        </div>
                                        <span class="td-prompt-one" style="margin-left: 30px;">图片标准为800 x 600为标准</span>
                                    </div>
                                    <div id="fileContainer"></div>
                                    <div id="btnContainer" style="display: none;">
                                        <a style="margin-left:335px;" href="javascript:clearQueue();" class="btn">取消</a>
                                    </div>
                                </div>
                                <span class="error-msg" id="antiqueImgUrlLabelErr"></span>
                            </td>
                        </tr>
                    </table>--%>

                </td>
            </tr>

            <tr>
                <td width="100" class="td-title"><span class="red">*</span>藏品类别：</td>
                <td class="td-select">
                    <div class="select-box w140">
                        <input type="text" name="antiqueVenueId" id="antiqueVenueId" value="${record.antiqueVenueId}" style="position: absolute; left: -9999px;" />
                        <div class="select-text" data-value="" id="tagTypeDiv">藏品类别</div>
                        <ul class="select-option" id="tagTypeUl">
                            <%--                        <li data-option="1">青铜器</li>
                                                    <li data-option="2">瓷器</li>
                                                    <li data-option="3">陶瓷器</li>--%>
                        </ul>
                    </div>
                    <span class="error-msg" id="antiqueVenueIdLabelErr"></span>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>藏品朝代：</td>
                <td class="td-select">
                    <div class="select-box w140">
                        <input type="text" name="antiqueYears" id="antiqueYears" value="${record.antiqueYears}" style="position: absolute; left: -9999px;" />
                        <div class="select-text" data-value=""  id="tagDynastyDiv">藏品朝代</div>
                        <ul class="select-option" id="tagDynasty">
                            <%--                        <li data-option="1">新石器</li>
                                                    <li data-option="2">商周</li>
                                                    <li data-option="3">唐代</li>--%>
                        </ul>
                    </div>
                    <span class="error-msg" id="antiqueYearsErr"></span>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title">藏品区域：</td>
                <td class="td-input">
                    <input type="text"  name="antiqueGalleryAddress"  id="antiqueGalleryAddress" value='<c:out value="${record.antiqueGalleryAddress}" escapeXml="true"/>' class="input-text w400" />
                    <span class="error-msg" id="antiqueGalleryAddressErr"></span>
                </td>

            </tr>
            <tr>
                <td width="100" class="td-title">藏品3D展示：</td>
                <td class="td-input">
                    <input name="antique3dUrl" type="text" class="input-text w400" value='<c:out value="${record.antique3dUrl}" escapeXml="true"/>'/>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title">音频文件：</td>
                <td class="td-input td-upload">


                    <%--                <input type="text" class="input-text w400"/>
                                    <input type="button" class="upload-btn" value="上传音频"/>--%>

                    <input type="hidden" name="uploadType" value="Audio" id="uploadType2"/>
                    <input type="hidden" name="antiqueVoiceUrl" id="antiqueVoiceUrl" value="${record.antiqueVoiceUrl}"/>

                    <div class="controls">
                        <input type="file" name="voiceFile" id="file2">
                        <div id="fileContainer2"></div>
                        <div id="btnContainer2" style="display: none;">
                            <a style="margin-left:335px;" href="javascript:clearQueue2();" class="btn">取消</a>
                        </div>
                    </div>

                    <%--<span class="td-prompt-one">具体请见使用文档</span>--%>
                </td>
            </tr>

            <tr>
                <td width="100" class="td-title"><span class="red">*</span>馆藏简介：</td>
                <td class="td-content">
                    <table>
                        <tr>
                            <td>
                                <div class="editor-box">
                                    <textarea name="antiqueRemark" id="antiqueRemark">${record.antiqueRemark}</textarea>
                                    <input type="hidden" value="" id="txtImgUrl" name="txtImgUrl"/>
                                </div>
                            </td>
                            <td>
                                <span class="error-msg" id="antiqueRemarkErr"></span>
                            </td>
                        </tr>
                    </table>

                </td>
            </tr>
            <input type="hidden" name="antiqueState" id="antiqueState" value="${record.antiqueState}" />
            <tr>
                <td width="100" class="td-title"></td>
                <td class="td-btn">

                    <c:if test="${record.antiqueState != 6}">
                        <input type="button" value="保存草稿" class="btn-save" onclick="updateAntique(1)"/>
                    </c:if>
                    <c:choose>
                        <c:when test="${record.antiqueState == 6}">
                            <input  class="btn-publish" type="button" value="保存修改"  onclick="updateAntique(6)"/>
                            <input  class="btn-save"    type="button" value="返回" onclick="history.back(-1)"/>
                        </c:when>
                        <c:otherwise>
                            <input  class="btn-publish"  type="button" value="发布" onclick="updateAntique(6)"/>
                        </c:otherwise>
                    </c:choose>
                   <%-- <input class="btn-save" type="button" onclick="update(1)"  value="保存草稿" />
                    <input class="btn-publish" type="button" onclick="update(6)" value="发布信息" />--%>
                </td>
            </tr>
        </table>
    </div>
</form>




<script type="text/javascript">
    //提交表单
    function formSub(formName,state){
        $("#antiqueState").val(state);
        $(formName).submit();
    }
</script>
<!-- 正中间panel -->

</body>
</html>
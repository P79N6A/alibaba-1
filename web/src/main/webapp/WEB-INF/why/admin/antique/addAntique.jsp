<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:setLocale value="zh_CN"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/html">
<head>
    <title>新建馆藏</title>
    <%@include file="../../common/pageFrame.jsp"%>
    <script type="text/javascript" src="${path}/STATIC/js/admin/antique/UploadAntiqueImg.js"></script>
<%--    <script type="text/javascript" src="${path}/STATIC/js/getAntiqueImg.js"></script>--%>
    <script type="text/javascript" src="${path}/STATIC/js/admin/antique/UploadAntiqueAudio.js"></script>
    <!-- dialog end -->
   <style type="text/css">
        /*.ui-dialog-close{ display: none;}*/
    </style>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
   <%-- <script type="text/javascript" src="${path}/STATIC/js/area-venues-admin.js"></script>--%>
    <script type="text/javascript">
        //富文本编辑器
        window.onload = function(){
            var editor = CKEDITOR.replace('antiqueRemark');
        }
        //加载分类 加载年代   selectModel();只能执行一次
        $(function() {

            var venueId='${cmsVenue.venueId}';
            //var tagType = $('#tagType').val();
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
                                                    }
                                                    $('#tagDynasty').html(ulHtml);
                                                }
                                            }).success(function() {
                                                selectModel();
                                });
                    });
         });

/*
        $(function(){
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

        function checkValidation(){
            $('#antiqueRemark').val(CKEDITOR.instances.antiqueRemark.getData());
            var antiqueName=$('#antiqueName').val();
            var antiqueVenueId = $("#antiqueVenueId").val();
            //var antiqueImgUrl = $("#antiqueImgUrl").val();
/*            var venueVal = $("#loc_venue").val();
            var antiqueVenueId = $("#antiqueVenueId").val();
           */
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


            if($.trim(antiqueName)){
                rmErrMsg("antiqueNameLabelErr");
                if(antiqueName.length>20){
                	addErrMsg("antiqueNameLabelErr","馆藏名称只能输入20字以内!");
                    $('#antiqueName').focus();
                    return false;
                }
            }else{
                addErrMsg("antiqueNameLabelErr","馆藏名称为必填项!");
                $('#antiqueName').focus();
                return false;
            }

/*            if($.trim(antiqueImgUrl)){
                rmErrMsg("antiqueImgUrlLabelErr");
            }else{
                addErrMsg("antiqueImgUrlLabelErr","馆藏图片为必填项!");
                $('#antiqueImgUrl').focus();
                return false;
            }*/

            if($.trim(antiqueVenueId)){
                rmErrMsg("antiqueVenueIdLabelErr");
            }else{
                addErrMsg("antiqueVenueIdLabelErr","馆藏分类为必填项!");
                $('#antiqueVenueId').focus();
                return false;
            }

            if($.trim(antiqueYears)){
                rmErrMsg("antiqueYearsErr");
            }else{
                addErrMsg("antiqueYearsErr","馆藏年代为必填项!");
                $('#antiqueYears').focus();
                return false;
            }

            if($.trim(antiqueRemark)){
                rmErrMsg("antiqueRemarkErr");
            }else{
                addErrMsg("antiqueRemarkErr","馆藏简介为必填项!");
                $('#antiqueRemark').focus();
                return false;
            }

/*
            if($.trim(antiqueGalleryAddress)){
                rmErrMsg("antiqueGalleryAddressErr");
            }else{
                addErrMsg("antiqueGalleryAddressErr","馆藏区域为必填");
                $("#antiqueGalleryAddress").focus();
                return false;
            }
*/




            return true;
        }
        //提交表单
        function addAntique(state){


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
            var venueId='${cmsVenue.venueId}';
            $.post("${path}/antique/addAntique.do", $("#antique_add_form").serialize(),
                    function(data) {
                        if (data!=null && data=='success') {
                                var html = "<h2>保存成功</h2>";
                                var asm = new Date().getTime();
                                dialogSaveDraft("提示", html, function(){
                                    window.location.href = "${path}/antique/antiqueIndex.do?antiqueState="+state+"&venueId="+venueId;
                                });
                        } else {
                            var html = "<h2>保存失败,请联系管理员</h2>";
                            dialogSaveDraft("提示", html, function(){

                            });
                        }
                    });
            }





        /**        $(function() {
            var tagType = $('#tagType').val();
            $.post(
                "${path}/sysdict/queryCode.do",
                {
                    'dictCode' : 'ANTIQUE'
                },
                function(data) {
                    if (data != '' && data != null) {
                        var list = eval(data);
                        var ulHtml = '<li data-option="">所有分类</li>';
                        for (var i = 0; i < list.length; i++) {
                            var dict = list[i];
                            ulHtml += '<li data-option="'+dict.dictId+'">'
                            + dict.dictName + '</li>';
                            if (tagType != '' && dict.dictId == tagType) {
                                $('#tagTypeDiv').html(dict.dictName);
                            }
                        }
                        $('#tagTypeUl').html(ulHtml);
                    }
                }).success(function() {
                    selectModel();
                });
        });



        function checkValidation(){
            var antiqueName=$('#antiqueName').val();
            var venueVal = $("#loc_venue").val();
            var antiqueVenueId = $("#antiqueVenueId").val();
            var antiqueImgUrl = $("#antiqueImgUrl").val();

            if(antiqueName==undefined||antiqueName==""){
                removeMsg("antiqueNameLabel");
                appendMsg("antiqueNameLabel","馆藏名称为必填项!");
                $('#antiqueName').focus();
                return false;
            }else{
                removeMsg("antiqueNameLabel");
            }

            if(venueVal==undefined||venueVal==""){
                removeMsg("venueIdLabel");
                appendMsg("venueIdLabel","所属场馆为必填项!");
                $('#loc_area').focus();
                return false;
            }else{
                removeMsg("venueIdLabel");
            }

            if(antiqueVenueId==undefined||antiqueVenueId==""){
                removeMsg("antiqueVenueIdLabel");
                appendMsg("antiqueVenueIdLabel","馆藏分类为必填项!");
                $('#antiqueVenueId').focus();
                return false;
            }else{
                removeMsg("antiqueVenueIdLabel");
            }

            if(antiqueImgUrl==undefined||antiqueImgUrl==""){
                removeMsg("antiqueImgUrlLabel");
                appendMsg("antiqueImgUrlLabel","馆藏图片为必填项!");
                $('#antiqueImgUrl').focus();
                return false;
            }else{
                removeMsg("antiqueImgUrlLabel");
            }
            return true;
        }
        //提交表单
        function addAntique(state){
            //cke_144_fileInput
            var validateResult = checkValidation();
            //富文本编辑器
            $('#antiqueRemark').val(CKEDITOR.instances.antiqueRemark.getData());

            if(!validateResult){
                return;
            }
            $("#antiqueState").val(state);
            //保存团体信息
            $.post("${path}/antique/addAntique.do", $("#antique_add_form").serialize(),
                function(data) {
                    if (data!=null && data=='success') {
                        jAlert('保存成功', '系统提示','success',function (r){
                            window.location.href="${path}/antique/antiqueIndex.do";
                        });
                    } else {
                        jAlert('保存失败', '系统提示','failure');
                    }
                });
        }
 **/

        seajs.config({
            alias: {
                "jquery": "jquery-1.10.2.js"
            }
        });

        seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
            window.dialog = dialog;
        });


    </script>
</head>
<body>
<input id="sessionId"  type="hidden" value="${pageContext.session.id}" />
<input type="hidden"   id="userCounty" value="${sessionScope.user.userCounty}" />
<form id="antique_add_form"  method="post">
<!-- 正中间panel -->

<input type="hidden" value="${cmsVenue.venueId}" name="venueId"/>
    <input type="hidden" id="isCutImg" value="N"/>
<div class="site">
    <em>您现在所在的位置：</em>场馆管理 &gt; 场馆信息管理&gt; 藏品管理 &gt; 添加藏品
</div>
<div class="site-title">添加藏品</div>
<div class="main-publish">
    <table width="100%" class="form-table">
        <tr>
            <td width="100" class="td-title">所属场馆：</td>
            <td class="td-input">${cmsVenue.venueName}</td>
<%--            <td class="td-select" id="venueIdLabel" colspan="3">
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
                <input type="text" id="antiqueName" name="antiqueName" class="input-text w510" maxlength="20"/>
                <span class="error-msg" id="antiqueNameLabelErr"></span>
            </td>
        </tr>
        <tr>
            <td width="100" class="td-title"><span class="red">*</span>上传封面：</td>

           <%-- <td class="" id="antiqueImgUrlLabel">--%>

            <td class="td-upload" id="activityIconUrlLabel">
                <table>
                    <tr>
                        <td>

                            <input type="hidden"  name="antiqueImgUrl" id="antiqueImgUrl" value="">
                            <input type="hidden" name="uploadType" value="Img" id="uploadType"/>

                            <div class="img-box">
                                <div id="imgHeadPrev" class="img">
                                </div>
                            </div>

                            <div class="controls-box">
                                <div style="height: 46px;">
                                    <div class="controls" style="float:left;">
                                        <input type="file" name="file" id="file">
                                    </div>
                                    <%--<input type="button" class="upload-cut-btn" id="" value="裁剪图片"/>--%>
                                    <span class="upload-tip">可上传1张图片，建议尺寸750*520像素，格式为jpg,jpeg,png,gif，大小不超过2M</span>
                                </div>
                                <div id="fileContainer"></div>
                                <div id="btnContainer" style="display: none;">
                                    <a style="margin-left:335px;" href="javascript:clearQueue();" class="btn">取消</a>
                                </div>
                            </div>

                        </td>
                    </tr>
                </table>



            <%--                <table>
                    <tr>
                        <td width="80"><span id="imgShow"></span></td>
                        <td>
                            <input type="hidden"  name="antiqueImgUrl" id="antiqueImgUrl" >
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
            <td class="td-select" id="antiquetd">
                <div class="select-box w140">
                    <input type="text" name="antiqueVenueId" id="antiqueVenueId" style="position: absolute; left: -9999px;"/>
                    <div class="select-text" data-value="">藏品类别</div>
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
                    <input type="text" name="antiqueYears" id="antiqueYears" style="position: absolute; left: -9999px;"/>
                    <div class="select-text" data-value="">藏品朝代</div>
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
                <input type="text"  name="antiqueGalleryAddress"   id="antiqueGalleryAddress"  class="input-text w400"  maxlength="50" />
                <span class="error-msg" id="antiqueGalleryAddressErr"></span>
            </td>

        </tr>
        <tr>
            <td width="100" class="td-title">藏品3D展示：</td>
            <td class="td-input">
                <input name="antique3dUrl" type="text" class="input-text w400"/>
            </td>
        </tr>
        <tr>
            <td width="100" class="td-title">音频文件：</td>
            <td class="td-input td-upload">


<%--                <input type="text" class="input-text w400"/>
                <input type="button" class="upload-btn" value="上传音频"/>--%>

                <input type="hidden" name="uploadType" value="Audio" id="uploadType2"/>
                <input type="hidden" name="antiqueVoiceUrl" id="antiqueVoiceUrl"/>

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
                        <td><div class="editor-box">
                                <textarea name="antiqueRemark" id="antiqueRemark"></textarea>
                                <input type="hidden" value="" id="txtImgUrl" name="txtImgUrl"/>
                            </div>
                        </td>
                        <td><span class="error-msg" id="antiqueRemarkErr"></span></td>
                    </tr>
                </table>
            </td>
        </tr>
        <input type="hidden" name="antiqueState" id="antiqueState"/>
        <tr>
            <td width="100" class="td-title"></td>
            <td class="td-btn">
                <input class="btn-save" type="button" onclick="addAntique(1)"  value="保存草稿" />
                <input class="btn-publish" type="button" onclick="addAntique(6)" value="发布信息" />
            </td>
        </tr>
    </table>
</div>
</form>



<%--<form id="antique_add_form"  method="post">
    <!-- 正中间panel -->
    <div id="content">
        <div class="content">
            <div class="con-box-blp">
                <h3>新建馆藏</h3>
                <div class="con-box-tlp">
                    <div class="form-box">
                        <table class="form-table">
                            <tbody>
                            <tr>
                                <td class="td-title"><span class="td-prompt">*</span>馆藏名称：</td>
                                <td class="td-input-one" colspan="3" id="antiqueNameLabel">
                                    <input type="text" id="antiqueName" name="antiqueName"/>
                                </td>
                            </tr>
                            <tr>
                                <td class="td-title" width="120"><span class="td-prompt">*</span>所属场馆：</td>
                                <td class="td-input-two" colspan="3" id="venueIdLabel">
                                    <div class="main">
                                        <select id="loc_area" name="" style="width:110px; margin-left: 10px"></select>
                                        <select id="loc_category" name="" style="width:110px; margin-left: 10px"></select>
                                        <select id="loc_venue"  name="venueId" style="width:200px;margin-left: 10px"></select>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td class="td-title"><span class="td-prompt">*</span>馆藏分类：</td>
                                <td class="td-input-two">
                                    <div class="select-box-one select-box-three">
                                        <input type="hidden" name="antiqueVenueId" id="antiqueVenueId"/>
                                        <div class="select-text-one select-text-three" data-value="所有分类" id="tagTypeDiv">所有分类</div>
                                        <ul class="select-option select-option-three" id="tagTypeUl">

                                        </ul>
                                    </div>
                                </td>
                                <td class="td-title" width="120" align="right">馆藏所在区域：</td>
                                <td class="td-input-two" id="antiqueVenueIdLabel">
                                    <input type="text" name="antiqueGalleryAddress"  class="inpTxt" id="antiqueGalleryAddress"/>
                                </td>
                            </tr>
                            <tr>
                                <td class="td-title" >藏品时间：</td>
                                <td class="td-input-one td-input-two" colspan="3">
                                        <input type="text" name="antiqueYears" value="" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})"/>
                                </td>
                            </tr>
                            <tr>
                                <td class="td-title"><span class="td-prompt">*</span>馆藏图片：</td>
                                <td class="td-input-two td-input-four" colspan="3" id="antiqueImgUrlLabel">
                                    <input type="hidden"  name="antiqueImgUrl" id="antiqueImgUrl" >
                                    <input type="hidden" name="uploadType" value="Img" id="uploadType"/>
                                    <div id="imgHeadPrev" style="width:100px; height:100px;position: relative; overflow: hidden;  float: left;">

                                    </div>
                                    <div style="float: left; margin-left: 20px;">
                                        <div style="height: 30px;">
                                            <div class="controls" style="float:left;">
                                                <input type="file" name="file" id="file">
                                            </div>
                                            <span class="td-prompt-one" style="margin-left: 30px;">图片标准为800 x 600为标准，具体请见使用文档</span>
                                        </div>
                                        <div id="fileContainer"></div>
                                        <div id="btnContainer" style="display: none;">
                                          &lt;%&ndash;  <a href="javascript:uploadQueue();" class="btn btn-primary"
                                               style="margin-left: 290px;">上传文件</a>&ndash;%&gt;
                                            <a style="margin-left:335px;" href="javascript:clearQueue();" class="btn">取消</a>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td class="td-title">音频介绍：</td>
                                <td class="td-input-two td-input-four"colspan="3">
                                    <input type="hidden" name="uploadType" value="Audio" id="uploadType2"/>
                                    <input type="hidden" name="antiqueVoiceUrl" id="antiqueVoiceUrl"/>

                                    <div class="controls">
                                        <input type="file" name="voiceFile" id="file2">
                                        <div id="fileContainer2"></div>
                                        <div id="btnContainer2" style="display:none;">
                                            &lt;%&ndash;<a href="javascript:uploadQueue2();" class="btn btn-primary"
                                               style="margin-left: 322px;">上传文件</a>&ndash;%&gt;
                                            <a style="margin-left:335px;"  href="javascript:clearQueue2();" class="btn">取消</a>
                                        </div>
                                    </div>
                                    <span class="td-prompt-one">具体请见使用文档</span>
                                </td>
                            </tr>
                            <tr>
                                <td class="td-title">视频介绍：</td>
                                <td class="td-input-two td-input-four"colspan="3">
                                    <input type="text" name="antiqueVideoUrl" data-val="" class="inpTxt"/>
                                    <span class="td-prompt-one">具体请见使用文档</span>
                                </td>
                            </tr>
                            <tr>
                                <td class="td-title">三维展示：</td>
                                <td class="td-input-two td-input-four"colspan="3">
                                    <input type="text"  name="antique3dUrl" value="" data-val="" class="inpTxt"/>
                                    <span class="td-prompt-one">具体请见使用文档</span>
                                </td>
                            </tr>
                            <tr>
                                <td class="td-title-one">文字介绍：</td>
                                <td class="td-input-two td-input-five"colspan="3">
                                    <div style="width:760px;margin-bottom: 10px;">
                                        <textarea name="antiqueRemark" id="antiqueRemark"></textarea>
                                    </div>
                                    <span class="td-prompt-one">1000字内</span>
                                    <input type="hidden" value="" id="txtImgUrl" name="txtImgUrl"/>
                                </td>
                            </tr>
                            <tr class="submit-btn">
                                <input type="hidden" name="antiqueState" id="antiqueState"/>
                                <td colspan="2">
                                    &lt;%&ndash;<c:forEach items="${sessionScope.user.sysModuleList}" var="module">
                                        <c:if test="${module.moduleUrl == '${path}/antique/addAntique.do'}">&ndash;%&gt;
                                   <input type="button" value="保存草稿" onclick="addAntique(1)"/>
                                   <input type="button" value="发布" onclick="addAntique(6)"/>
                                       &lt;%&ndash; </c:if>
                                    </c:forEach>&ndash;%&gt;
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</form>--%>


</body>
</html>

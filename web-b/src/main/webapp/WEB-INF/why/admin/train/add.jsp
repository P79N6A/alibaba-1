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

    <script type="text/javascript" src="${path}/STATIC/js/train/train.save.js"></script>
    <script type="text/javascript">

        /**
         * Created by cj on 2015/7/2.
         */
        seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
            window.dialog = dialog;
        });

        var trainArea = '${train.trainArea}';
        var venueType = '${train.venueType}';
        var venueId = '${train.venueId}';
        var trainLocation = '${train.trainLocation}'
        var trainType = '${train.trainType}';
        var trainTag = '${train.trainTag}';
        $(function () {

            //页面初始化时加载富文本编辑器
            var editor = CKEDITOR.replace('registrationRequirements');
            var editor = CKEDITOR.replace('courseIntroduction');
            var editor = CKEDITOR.replace('teachersIntroduction');

          /*  //初始化父标签
            $.post("${path}/beipiaoInfoTag/queryParentTag.do", function (data) {
                var list = eval(data);
                var tagHtml = '';
                for (var i = 0; i < list.length; i++) {
                    var obj = list[i];
                    var tagId = obj.tagId;
                    var tagName = obj.tagName;
                    var cl = '';
                    cl = 'class="cur"';
                    tagHtml += '<a id="' + tagId + '" class="tagType" >' + tagName
                        + '</a>';
                }
                $("#TypeLabel").html(tagHtml);
                setTrainType("TypeLabel");
            });*/

            //获取经纬度
            $('#getMapAddressPoint').on('click', function () {
                var address = $('#trainAddress').val();
                dialog({
                    url: '${path}/activity/queryMapAddressPoint.do?address=' + encodeURI(encodeURI(address)),
                    title: '获取经纬度',
                    width: 700,
                    fixed: true,
                    onclose: function () {
                        if (this.returnValue) {

                            $('#lon').val(this.returnValue.xPoint);
                            $("#lat").val(this.returnValue.yPoint);

                        }
                        //dialog.focus();
                    }
                }).showModal();
                return false;
            });
        });


        //标签选择时更改样式
        function tagSelect(id) {
            /* tag标签选择 */
            $('#' + id).find('a').click(function () {
                if ($(this).hasClass('cur')) {
                    $(this).removeClass('cur');
                } else {
                    $(this).addClass('cur');
                }
            });
        }


        //父标签的点击事件
        function setParentId(id) {
            $("#childTagTr").removeAttr("style");
            $.post("${path}/tag/getTagSubByTagId.do", {"tagId": id},
                function (data) {
                    var list = eval(data);
                    var tagHtml = '';
                    for (var i = 0; i < list.length; i++) {
                        var obj = list[i];
                        var tagId = obj.tagSubId;
                        var tagName = obj.tagName;
                        var cl = '';
                        cl = 'class="cur"';
                        tagHtml += '<a data-v="'+obj.tagName+'" id="' + tagName + '" class="tagType">' + tagName
                            + '</a>';
                    }
                    $("#childTagLabel").html(tagHtml);
                    setTrainTag();
                    $("#childTag").val("");
                    if('${train.trainTag}'){
                        var tags = '${train.trainTag}'.split(',');
                        for(var i=0;i<tags.length;i++){
                            $("#"+tags[i]).addClass('cur');
                        }
                    }
                });
        }

        //子标签的点击事件
        function setChildId(id) {
            $("#childTag").val(id);
            $("#beipiaoinfoTag").val(id);
        }


        //上传封面回调函数
        function uploadImgCallbackHomepage(up, file, info) {
            $('#' + file.id).append("<input type='hidden' id='trainImgUrl' name='trainImgUrl' value='http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info + "'/>");
            //alert($("#beipiaoinfoHomepage").val());
        }

    </script>
</head>
<style>
    div[name=aliFile] br, div[name=aliFile] p, div[name=aliFile] span，.progress {
        display: none !important;
    }

    #webuploadhomepage div[name=aliFile] img:nth-child(1) {
        position: relative !important;
        max-width: 490px !important;
        max-height: 500px !important;
    }

    #webuploadhomepage div[name=aliFile] img:nth-child(1) {
        max-width: 750px;
        max-height: 500px;
    }

    #webuploadhomepage div[name=aliFile] {
        width: 750px !important;
        max-width: 500px !important;
    }

    #webuploadimages div[name=aliFile] img:nth-child(1) {
        position: relative !important;
        max-width: 560px !important;
        max-height: 420px !important;
    }

    #webuploadimages div[name=aliFile] img:nth-child(1) {
        max-width: 560px;
        max-height: 420px;
    }

    #webuploadimages div[name=aliFile] {
        width: 560px !important;
        max-width: 420px !important;
    }
</style>
<body>
<div class="site">
    <em>您现在所在的位置：</em>培训管理 &gt; 发布培训
</div>
<div class="site-title">添加课程</div>
<div class="main-publish">
    <form id="infoForm" method="post">
        <table width="100%" class="form-table">
            <tr>
                <td width="150" class="td-title"><span class="red">*</span>课程标题：
                </td>
                <td class="td-input" id="titleLabel">
                    <input type="hidden" id="id" name="id" value="${train.id}"/>
                    <input id="trainTitle" name="trainTitle" type="text" class="input-text w510"
                           maxlength="30" value="${train.trainTitle}"/>
                    <span class="error-msg"></span>
                </td>
            </tr>

            <tr>
                <td width="100" class="td-title"><span class="red">*</span>上传封面：
                </td>
                <td class="td-upload" id="homepageLabel">
                    <table>
                        <tr>
                            <td>
                                <div class="whyVedioInfoContent" style="margin-top:-10px;">
                                    <div class="whyUploadVedio" id="webuploadhomepage">
                                        <div style="width: 700px;">
                                            <div id="ossfile2">
                                                <c:if test="${not empty train.trainImgUrl}">
                                                    <div name="aliFile"
                                                         style="position:relative;margin-bottom:5px;margin-right:15px;max-width:130px;display:inline-block;">
                                                        <img style="max-height: 130px;max-width: 130px;position: absolute;left: 0;right: 0;top: 0;bottom: 0;margin: auto;"
                                                             src="${train.trainImgUrl }"><br>
                                                        <img onclick="this.parentNode.remove();" id="aliRemoveBtn"
                                                             src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201733161236Bn6gTqiCZBHhgObFvsCkLFNzmIBoh2.png"
                                                             style="position:absolute;right:0;top:0;width:20px">
                                                        <input id="trainImgUrl" name="trainImgUrl"
                                                               value="${train.trainImgUrl }" type="hidden">
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
                <td width="100" class="td-title"><span class="red">*</span>区域：</td>
                <input type="hidden" id="userDeptId" value="${sysUser.userDeptId}"/>
                <input type="hidden" id="userCounty" value="${sysUser.userCounty}"/>
                <input type="hidden" id="userIsManger" value="${sysUser.userIsManger}"/>
                <%--<input type="hidden" id="userTown" value="${sysUser.userTown}"/>--%>
                <td class="td-select">
                    <select class="ng-select-box" name="trainProvince">
                        <option value="804,陕西省" class="ng-binding ng-scope" selected>陕西省</option>
                    </select>
                    <select class="ng-select-box" name="trainCity">
                        <option value="900,安康市" selected>安康市</option>
                    </select>
                    <select class="ng-select-box" id="trainArea" name="trainArea">
                    </select>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>位置：</td>
                <input id="trainLocation" name="trainLocation" type="hidden" value="<c:if test="${not empty train.trainLocation}">${train.trainLocation}</c:if>"/>
                <td class="td-tag" id="activityLocationLabel">
                    <dd><a id="2" onclick="setActivityLocation('be4cb27979a845c1b42153adc442b117')" class="ng-binding ng-scope">安康市</a></dd>
                </td>
            </tr>

            <tr>
                <td width="100" class="td-title"><span class="red">*</span>培训地址：
                </td>
                <td class="td-input">
                    <input id="trainAddress" name="trainAddress" type="text" class="input-text w510"
                           maxlength="50" placeholder="请输入详细地址" value="${train.trainAddress}"/>
                    <span class="error-msg"></span>
                </td>
            </tr>

            <tr>
                <td width="100" class="td-title"><span class="red">*</span>地图坐标：</td>
                <td class="td-input td-coordinate" id="venueMapLabel">
                    <span class="txt">X</span>
                    <input value="${train.lon}" id="lon" name="lon" type="text" class="input-text w120" maxlength="15"
                           readonly="">
                    <span class="txt">Y</span>
                    <input value="${train.lat}" id="lat" name="lat" type="text" class="input-text w120" maxlength="15"
                           readonly="">
                    <input type="button" class="upload-btn" id="getMapAddressPoint" value="查询坐标">
                    <span class="error-msg"></span>
                </td>
            </tr>

            <tr>
                <td width="100" class="td-title"><span class="red">*</span>类型(单选)：</td>
                <td class="td-tag" id="parentLabel">
                    <input type="hidden" id="trainType" name="trainType" value="${train.trainType}"/>
                    <dl>
                        <dd id="TypeLabel">
                        </dd>
                    </dl>
                </td>
            </tr>

            <tr id="childTagTr">
                <td width="100" class="td-title"><span class="red">*</span>标签(多选)：</td>
                <td class="td-tag" id="childLabel">
                    <input type="hidden" id="trainTag" name="trainTag" value="${train.trainTag}"/>
                    <dl>
                        <dd id="">
                            <span id="commonTagLabel"></span>
                            <span id="childTagLabel"></span>
                        </dd>
                    </dl>
                </td>
            </tr>

            <tr>
                <td width="100" class="td-title"><span class="red">*</span>录取方式：</td>
                <td class="td-tag">
                    <input type="hidden" id="admissionType" name="admissionType" value="${train.admissionType}"/>
                    <dl>
                        <dd id="showAdmissionLabel">
                            <a class="admissionType ${train.admissionType==1?'cur':''}" onclick="setAdmissionType(1)"
                               style="width: 56px; text-align: center">先到先得</a>
                            <a class="admissionType ${train.admissionType==2?'cur':''}" onclick="setAdmissionType(2)"
                               style="width: 56px; text-align: center">人工录取</a>
                            <a class="admissionType ${train.admissionType==3?'cur':''}" onclick="setAdmissionType(3)"
                               style="width: 56px; text-align: center">随机录取</a>
                            <a class="admissionType ${train.admissionType==4?'cur':''}" onclick="setAdmissionType(4)"
                               style="width: 70px; text-align: center">面试后录取</a>
                        </dd>
                    </dl>
                </td>
            </tr>
<%--
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>培训课程类型：</td>
                <td class="td-tag">
                    <input type="hidden" id="courseType" name="courseType" value="${train.courseType}"/>
                    <dl>
                        <dd id="showCourseTypeLabel">
                            <a class="courseType ${train.courseType==1?'cur':''}" onclick="setCourseType(1)"
                               style="width: 56px; text-align: center">新春班</a>
                            <a class="courseType ${train.courseType==2?'cur':''}" onclick="setCourseType(2)"
                               style="width: 56px; text-align: center">春季班</a>
                            <a class="courseType ${train.courseType==3?'cur':''}" onclick="setCourseType(3)"
                               style="width: 56px; text-align: center">暑期班</a>
                            <a class="courseType ${train.courseType==4?'cur':''}" onclick="setCourseType(4)"
                               style="width: 70px; text-align: center">秋季班</a>
                        </dd>
                    </dl>
                </td>
            </tr>--%>
            <tr>
                <td width="130" class="td-title"><span class="red">*</span>男性年龄限制：</td>
                <td class="td-input" id="maleAgeLabel">
                    <input id="maleMinAge" name="maleMinAge" type="number" class="input-text w125" maxlength="10"
                           onkeyup="value=value.replace(/[^\d]/g,'')" VALUE="${train.maleMinAge}"/>&nbsp;&nbsp;岁至
                    <input id="maleMaxAge" name="maleMaxAge" type="number" class="input-text w125" maxlength="10"
                           onkeyup="value=value.replace(/[^\d]/g,'')" VALUE="${train.maleMaxAge}"/>&nbsp;&nbsp;岁
                </td>
            </tr>
            <tr>
                <td width="130" class="td-title"><span class="red">*</span>女性年龄限制：</td>
                <td class="td-input" id="femaleAgeLabel">
                    <input id="femaleMinAge" name="femaleMinAge" type="number" class="input-text w125" maxlength="10"
                           onkeyup="value=value.replace(/[^\d]/g,'')" VALUE="${train.femaleMinAge}"/>&nbsp;&nbsp;岁至
                    <input id="femaleMaxAge" name="femaleMaxAge" type="number" class="input-text w125" maxlength="10"
                           onkeyup="value=value.replace(/[^\d]/g,'')" VALUE="${train.femaleMaxAge}"/>&nbsp;&nbsp;岁
                </td>
            </tr>
<%--
            <tr>
                <td width="130" class="td-title"><span class="red">*</span>可报名次数：</td>
                <td class="td-input" id="registrationCountLabel">
                    <input id="registrationCount" name="registrationCount" type="text" class="input-text w125" maxlength="10"
                           onkeyup="value=value.replace(/[^\d]/g,'')" VALUE="${empty train.registrationCount?1:train.registrationCount}"/>&nbsp;&nbsp;次
                </td>
            </tr>
--%>

            <tr id="interviewTimeTR"  <c:if test="${train==null || train.admissionType!=4}">style="display: none;"</c:if> >
                <td width="100" class="td-title">面试时间：
                </td>
                <td class="td-input">
                    <input id="interviewTime" name="interviewTime" type="text" class="input-text w510"
                           maxlength="50" placeholder="请输入面试时间" value="${train.interviewTime}"/>
                    <span class="error-msg"></span>
                </td>
            </tr>

            <tr id="interviewAddressTR"  <c:if test="${train==null || train.admissionType!=4}">style="display: none;"</c:if>>
                <td width="100" class="td-title">面试地点：
                </td>
                <td class="td-input">
                    <input id="interviewAddress" name="interviewAddress" type="text" class="input-text w510"
                           maxlength="50" placeholder="请输入详细地址" value="${train.interviewAddress}"/>
                    <span class="error-msg"></span>
                </td>
            </tr>

            <tr>
                <td width="100" class="td-title"><span class="red">*</span>录取人数上限：</td>
                <td class="td-input td-fees ">
                    <label><input type="radio" value="1"
                                  name="maxPeopleClick" ${empty train.maxPeople ? "checked" : ""} checked><em>无</em></label>
                    <label><input type="radio" value="2"
                                  name="maxPeopleClick" ${not empty train.maxPeople  ? "checked" : ""}><em>有</em></label>
                </td>
            </tr>
            <tr id="maxPeople_tr" style="<c:if test="${empty train.maxPeople}">display:none;</c:if>">
                <td width="130" class="td-title"><span class="red">*</span>录取人数上限：</td>
                <td class="td-input" id="publisherNameLabel">
                    <input id="maxPeople" name="maxPeople" type="text" class="input-text w125" maxlength="10"
                           onkeyup="value=value.replace(/[^\d]/g,'')" VALUE="${train.maxPeople}"/>&nbsp;&nbsp;人
                </td>
            </tr>

            <tr>
                <td width="100" class="td-title"><span class="red">*</span>培训场次：</td>
                <td class="td-input td-fees ">
                    <label><input type="radio" value="1"
                                  name="trainField" ${train.trainField==1 or empty tyain.trainField?'checked':''}><em>单场</em></label>
                    <label><input type="radio" value="2"
                                  name="trainField" ${train.trainField==2?'checked':''}><em>多场</em></label>

                </td>
            </tr>

            <tr>
                <td width="100" class="td-title"><span class="red">*</span>报名时间：</td>
                <input type="hidden">
                <td class="td-time">
                    <div class="start w340" style="width:249px;">
                        <span class="text">开始日期</span>
                        <input type="text" style="width:130px;" value="${train.registrationStartTime}" name="registrationStartTime"
                               id="registrationStartTime" readonly="">
                        <i date-picker="" class="registrationStartTime"></i>
                    </div>
                    <span class="txt">至</span>
                    <div class="end w340" style="width:249px;">
                        <span class="text">结束日期</span>
                        <input type="text" style="width:130px;" name="registrationEndTime" id="registrationEndTime"
                               value="${train.registrationEndTime}" readonly="">
                        <i date-picker="" class="registrationEndTime"></i>
                    </div>
            </tr>

            <tr id="courseType_tr">
                <td width="130" class="td-title"><span class="red">*</span>同批次报名次数上限：</td>
                <td class="td-input" id="courseTypeLabel">
                    <input id="courseType" name="courseType" type="number" class="input-text w125" maxlength="10"
                          placeholder="请填写大于0的整数" onkeyup="value=value.replace(/[^\d]/g,'')" VALUE="${train.courseType}"/>&nbsp;&nbsp;<span style="color: red">注:相同报名时间的培训活动视为同一批次</span>
                </td>
            </tr>

            <tr>
                <td width="100" class="td-title"><span class="red">*</span>培训周期：</td>
                <td class="td-time">
                    <div class="start w340" style="width:249px;">
                        <span class="text">开始日期</span>
                        <input type="text" style="width:130px;"  name="trainStartTime" id="trainStartTime" value="${train.trainStartTime}"
                               readonly="">
                        <i date-picker="" class="trainStartTime"></i>
                    </div>
                    <span class="txt">至</span>
                    <div class="end w340" style="width:249px;">
                        <span class="text">结束日期</span>
                        <input type="text" style="width:130px;" name="trainEndTime" id="trainEndTime" value="${train.trainEndTime}"
                               readonly="">
                        <i date-picker="" class="trainEndTime"></i>
                    </div>
            </tr>
            <tr id="more_field_tr"
                <c:if test="${empty train or train.trainField==1}">style="display: none"</c:if>
            >
                <td width="100" class="td-title"><span class="red">*</span>培训时间：</td>
                <td class="td-time more_field">
                    <c:if test="${empty fields}">
                        <div class="fieldTimeDiv">
                            <div class="start w340">
                                <span class="text">培训时间</span>
                                <input type="text" value="" name="fieldTime" id="fieldTime0" readonly="">
                                <i date-picker="" class="fieldTime0"></i>
                            </div>
                            <div class="end w64" style="width: 100px;">
                                <input type="text" style="width: 70px;" name="fieldStartTime" id="fieldStartTime0" value=""
                                       readonly="">
                                <i date-picker="" class="fieldStartTime0"></i>
                            </div>
                            <span class="txt">至</span>
                            <div class="end w64" style="width: 100px;">
                                <input type="text" style="width: 70px;" name="fieldEndTime" id="fieldEndTime0" value=""
                                       readonly="">
                                <i date-picker="" class="fieldEndTime0"></i>
                            </div>
                            <div style="clear: both;"></div>
                        </div>
                    </c:if>
                    <c:if test="${not empty fields}">
                        <div class="fieldTimeDiv">
                            <div class="start w340">
                                <span class="text">培训时间</span>
                                <input type="text" value="${fn:substring(fields[0].fieldTimeStr,0,10)}" name="fieldTime" id="fieldTime0" readonly="">
                                <i date-picker="" class="fieldTime0"></i>
                            </div>
                            <div class="end w64" style="width: 100px;">
                                <input type="text" style="width: 70px;" name="fieldStartTime" id="fieldStartTime0"
                                       value="${fn:substring(fields[0].fieldTimeStr,11,16)}"
                                       readonly="">
                                <i date-picker="" class="fieldStartTime0"></i>
                            </div>
                            <span class="txt">至</span>
                            <div class="end w64" style="width: 100px;">
                                <input type="text" style="width: 70px;" name="fieldEndTime" id="fieldEndTime0"
                                       value="${fn:substring(fields[0].fieldTimeStr,17,24)}"
                                       readonly="">
                                <i date-picker="" class="fieldEndTime0"></i>
                            </div>
                            <div style="clear: both;"></div>
                        </div>
                    </c:if>
                    <input type="hidden" id="fieldsLength" value="${fn:length(fields)}"/>
                    <c:forEach items="${fields}" begin="1" end="${fn:length(fields)}" var="f" varStatus="i">
                        <div class="fieldTimeDiv" style="margin-top: 20px;">
                            <div class="start w340">
                                <span class="text">培训时间</span>
                                <input type="text" name="fieldTime" id="fieldTime${i.index}"
                                       value="${fn:substring(f.fieldTimeStr,0,10)}" readonly="">
                                <i date-picker="" class="fieldTime${i.index}"></i>
                            </div>
                            <div class="end w64" style="width: 100px;">
                                <input type="text" style="width: 70px;" name="fieldStartTime" id="fieldStartTime${i.index}"
                                       value="${fn:substring(f.fieldTimeStr,11,16) }" readonly="">
                                <i date-picker="" class="fieldStartTime${i.index}"></i>
                            </div>
                            <span class="txt">至</span>
                            <div class="end w64" style="width: 100px;">
                                <input type="text" style="width: 70px;" name="fieldEndTime" id="fieldEndTime${i.index}"
                                       value="${fn:substring(f.fieldTimeStr,17,24)}" readonly="">
                                <i date-picker="" class="fieldEndTime${i.index}"></i>
                            </div>

                            <a onclick="deleteCourseTime(this)" class="timeico jianhao" style="background: url(/STATIC/image/remove.png) no-repeat center center;width: 25px;height: 42px;display: block;float: left"></a>
                            <div style="clear: both;"></div>
                        </div>

                    </c:forEach>
                        <script type="text/javascript">
                            //setFieldTime(i)
                            window.onload=function (ev) {
                                var len = $("#fieldsLength").val();
                                for (var i = 1; i < len; i++) {
                                    setFieldTime(i);
                                    setFieldStartTime(i);
                                    setFieldEndTime(i);
                                }
                            }

                        </script>


                    <a onclick="addCourseTime(this)" class="timeico tianjia"
                       style="background: url(/STATIC/image/addTrainField.png) no-repeat center center;width: 25px;height: 42px;display: block;"></a>
                </td>

            </tr>


            <tr>
                <td width="100" class="td-title"><span class="red">*</span>咨询电话：
                </td>
                <td class="td-input">
                    <input id="consultingPhone" name="consultingPhone" type="text" class="input-text w510"
                           maxlength="50" value="${train.consultingPhone}"/>
                    <span class="error-msg"></span>
                </td>
            </tr>

            <tr>
                <td width="100" class="td-title">联系方式：
                </td>
                <td class="td-input">
                    <input id="contactInformation" name="contactInformation" type="text" class="input-text w510"
                           maxlength="50" value="${train.contactInformation}"/>
                    <span class="error-msg"></span>
                </td>
            </tr>

            <tr>
                <td width="100" class="td-title">温馨提示：
                </td>
                <td class="td-input">
                    <input id="reminder" name="reminder" type="text" class="input-text w510"
                           maxlength="50" value="${train.reminder}"/>
                    <span class="error-msg"></span>
                </td>
            </tr>

            <tr>
                <td width="100" class="td-title"><span class="red">*</span>报名要求：</td>
                <td class="td-content">
                    <div class="editor-box">
                        <textarea id="registrationRequirements" name="registrationRequirements" rows="8"
                                  class="textareaBox"
                                  style="width: 500px;resize: none">${train.registrationRequirements}</textarea>
                    </div>
                </td>
            </tr>

            <tr>
                <td width="100" class="td-title"><span class="red">*</span>课程简介：</td>
                <td class="td-content">
                    <div class="editor-box">
                        <textarea id="courseIntroduction" name="courseIntroduction" rows="8" class="textareaBox"
                                  style="width: 500px;resize: none">${train.courseIntroduction}</textarea>
                    </div>
                </td>
            </tr>

            <tr>
                <td width="100" class="td-title"><span class="red">*</span>师资介绍：</td>
                <td class="td-content">
                    <div class="editor-box">
                        <textarea id="teachersIntroduction"
                                  name="teachersIntroduction">${train.teachersIntroduction}</textarea>
                    </div>
                </td>
            </tr>


            <%--  <tr>
                  <td width="100" class="td-title"><span class="red" id="spanred">*</span>详细描述：</td>
                  <td class="td-content" id="beipiaoinfoDetailsLabel">
                      <div class="editor-box">
                          <textarea name="beipiaoinfoDetails" id="beipiaoinfoDetails"></textarea>
                      </div>
                  </td>
              </tr>--%>

            <tr>
                <td width="100" class="td-title"></td>
                <td class="td-btn">
                    <input type="hidden" id="fieldStr" name="fieldStr"/>
                    <input type="hidden" id="trainStatus" name="trainStatus"/>
                    <input style="background-color: #999" type="button" value="取消" class="btn-publish"
                           onclick="javascript:history.back(-1)">
                    <input class="btn-save" type="button" onclick="addInfo(2)" value="保存草稿" style="margin-left:0;"/>
                    <input id="btnPublish" class="btn-publish" type="button" onclick="addInfo(1)" value="发布培训"/>
                </td>
            </tr>
        </table>
    </form>

</div>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>修改志愿者活动--文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
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
            var uuid = $('#uuid').val();
            if(uuid){
                $('#title').html('修改志愿者活动');
                $('title').val('修改志愿者活动--文化云');
            }else {
                $('#title').html('新增志愿者活动');
                $('title').val('新增志愿者活动--文化云');
            }
            selectModel();
            getArea();
            selectRecruitmentStatus();
            selectRecruitObjectType();
            //页面初始化时加载富文本编辑器
            var editor = CKEDITOR.replace('description');
        });


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


                var urlStr = $("#picUrl").val();

                var url =getImgUrl(urlStr);
                dialog({
                    url: '${path}/att/toCutImgJsp.do?imageURL='+url+'&cutImageSize='+cutImageSize,
                    title: '图片裁剪',
                    fixed: false,
                    onclose: function () {
                        if(this.returnValue){
                            //alert("返回值：" + this.returnValue.imageUrl);
                            $("#imgHeadPrev").html(getImgHtml(this.returnValue.imageUrl));
                            $("#picUrl").val(this.returnValue.imageUrl);
                        }
                    }
                }).showModal();
                return false;
            });
        });


        // 初始化时启动招募选中
        function selectRecruitmentStatus(){
            var status = $('#hidStatus').val();
            if(status == 1){
                $("#recruitmentStatusDiv").html("是");
            }
            else if(status == 2){
                $("#recruitmentStatusDiv").html("否");
            }
        }


        // 初始化时招募对象类型选中
        function selectRecruitObjectType(){
            var type = $('#hidType').val();
            if(type == '1'){
                $("#recruitObjectTypeDiv").html("个人");
            }
            else if(type == '2'){
                $("#recruitObjectTypeDiv").html("团体");
            }
            else if(type == '1，2'){
                $("#recruitObjectTypeDiv").html("个人、团体");
            }
        }



        // 省市区
        function getArea(){
            var respectiveRegion = $('#respectiveRegion').val();
            var areaCode = '';
            if(respectiveRegion){
                var region = respectiveRegion.split(',');
                if(region && region.length === 3){
                    areaCode= region[2];
                }
            }

            var teamUserProvince='${terminalUser.userProvince}';
            var teamUserCity='${terminalUser.userCity}';
            var teamUserArea='${terminalUser.userArea}';
            if((teamUserProvince != null && teamUserProvince != "") && (teamUserCity != null && teamUserCity != "") && (teamUserArea != null && teamUserArea != "")){
                //省市区
                showLocation(teamUserProvince.split(",")[0],teamUserCity.split(",")[0],teamUserArea.split(",")[0]);
                $("#loc_province").select2("val", teamUserProvince.split(",")[0]);
                $("#loc_city").select2("val", teamUserCity.split(",")[0]);
                $("#loc_town").select2("val",  teamUserArea.split(",")[0]);
                if(areaCode){
                    $("#loc_town").select2("val",  areaCode);
                }

            }else {
                var province='${user.userProvince}';
                var city='${user.userCity}';
                var area='${user.userCounty}';
                showLocation(province.split(",")[0],city.split(",")[0],area.split(",")[0]);
                $("#loc_province").select2("val", province.split(",")[0]);
                $("#loc_city").select2("val", city.split(",")[0]);
                $("#loc_town").select2("val",  area.split(",")[0]);
                if(areaCode){
                    $("#loc_town").select2("val",  areaCode);
                }
            }

            var userIsManger = '${user.userIsManger}';
            if(userIsManger!=undefined&&userIsManger == 1){ // 省级管理员
                $("#locProvinceDiv").show();
                $("#loc_province").attr("disabled", true);
                $("#locCityDiv").show();
                $("#locCountyDiv").show();
            }else if(userIsManger!=undefined&&userIsManger == 2){ // 市级管理员
                $("#locProvinceDiv").show();
                $("#locCityDiv").show();
                $("#locCountyDiv").show();
                $("#loc_province").attr("disabled", true);
                $("#loc_city").attr("disabled", true);
            }else{ // 区级管理员和场馆级管理员
                $("#locProvinceDiv").show();
                $("#locCityDiv").show();
                $("#locCountyDiv").show();
                $("#loc_province").attr("disabled", true);
                $("#loc_city").attr("disabled", true);
                $("#loc_town").attr("disabled", true);
            }
        }

        //删除图片
        function remove(data){
            data.parentNode.remove();
        }

        //上传封面回调函数
        function uploadImgCallbackHomepage(up, file, info) {
            $('#'+file.id).append("<input type='hidden' id='picUrl' name='picUrl' value='http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info+"'/>");
        }
        //上传附件回调函数
        function uploadImgCallbackAttachment(up, file, info){

            var html = "<a href='http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info+"' target=\"_blank\">查看附件</a>"
            +"<input type='hidden' id='attachment' name='attachment' value='http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info+"'/>";
            $('#'+file.id).append(html)
        }

        //编辑表单
        function handleEdit() {

            var name = $("#name").val();
            var picUrl = $("#picUrl").val();
            picUrl = picUrl ? picUrl : ' ';
            var recruitmentStatus = $("#recruitmentStatus").val();
            var recruitObjectType = $("#recruitObjectType").val();
            var provinceCode = $("#loc_province").find("option:selected").val();
            var cityCode = $("#loc_city").find("option:selected").val();
            var areaCode = $("#loc_town").find("option:selected").val();
            var respectiveRegion = provinceCode + ',' + cityCode + ',' + areaCode;
            var address = $("#address").val();
            var phone = $("#phone").val();
            var limitNum = $("#limitNum").val();
            var startTime = $("#startTime").val();
            var endTime = $("#endTime").val();
            var serviceTime = $("#serviceTime").val();
            var description = CKEDITOR.instances.description.getData();
            var attachment = $("#attachment").val();
            // 活动名称
            if(name == undefined || $.trim(name) == ""){
                removeMsg("nameLabel");
                appendMsg("nameLabel","请输入活动名称!");
                $("#name").focus();
                return false;
            }else{
                removeMsg("nameLabel");
            }

            // 是否启动招募
            if(recruitmentStatus == undefined || $.trim(recruitmentStatus) == ""){
                removeMsg("recruitmentStatusLabel");
                appendMsg("recruitmentStatusLabel","启动招募必选!");
                $("#recruitmentStatus").focus();
                return false;
            }else{
                removeMsg("recruitmentStatusLabel");
            }

            // 招募对象类型
            if(recruitObjectType == undefined || $.trim(recruitObjectType) == ""){
                removeMsg("recruitObjectTypeLabel");
                appendMsg("recruitObjectTypeLabel","招募对象类型必选!");
                $("#recruitObjectType").focus();
                return false;
            }else{
                removeMsg("recruitObjectTypeLabel");
            }

            // 省市区
            if($.trim(areaCode) == ''){
                removeMsg("userCountyTextLabel");
                appendMsg("userCountyTextLabel","请选择所属地区!");
                $("#loc_town").focus();
                $("#userCountyText").focus();
                return false;
            }else{
                removeMsg("userCountyTextLabel");
            }

            //详细地址
            if($.trim(address) == ''){
                removeMsg("addressLabel");
                appendMsg("addressLabel","请输入详细地址!");
                $("#address").focus();
                return false;
            }else{
                removeMsg("addressLabel");
            }

            // 允许报名人数
            if(limitNum == undefined || $.trim(limitNum) == ""){
                removeMsg("limitNumLabel");
                appendMsg("limitNumLabel","请输入允许报名人数!");
                $("#limitNum").focus();
                return false;
            }else{
                removeMsg("limitNumLabel");
            }

            // 活动开始日期
            if($.trim(startTime).length <= 0){
                appendMsg("timeLabel","开始时间必选!");
                $("#startTime").focus();
                return false;
            }

            // 活动开始日期
            if($.trim(endTime).length <= 0){
                appendMsg("timeLabel","结束时间必选!");
                $("#endTime").focus();
                return false;
            }

            // 服务时长
            if(serviceTime == undefined || $.trim(serviceTime) == ""){
                removeMsg("timeLabel");
                appendMsg("timeLabel","请输入服务时长!");
                $("#serviceTime").focus();
                return false;
            }else{
                removeMsg("serviceTimeLabel");
            }


            var post = {
                uuid: $('#uuid').val(),
                name: name,
                picUrl: picUrl,
                recruitmentStatus: recruitmentStatus,
                recruitObjectType: recruitObjectType,
                respectiveRegion: respectiveRegion,
                address: address,
                phone: phone,
                limitNum: limitNum,
                startTime: startTime,
                endTime: endTime,
                serviceTime: serviceTime,
                description: description,
                attachment: attachment
            }
            post.status = post.uuid ? undefined : 3;//状态默认为正常
            post.publish = post.uuid ? undefined : 2;//默认为下架
            var title = post.uuid ? '修改' : '新增';
            var url = post.uuid ? '${path}/newVolunteerActivity/updateNewVolunteerActivityJson.do' : '${path}/newVolunteerActivity/addNewVolunteerActivityJson.do';
            $.ajax({
                type: 'post',
                url: url,
                data: post,
                dataType: 'json',
                success: function (res) {
                    if (res && res.status == 200) {
                        dialogSaveDraft("提示", title + "成功", function(){
                            window.location.href = "${path}/newVolunteerActivity/queryNewVolunteerActivityList.do";
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
    <input type="hidden" id="respectiveRegion" name="respectiveRegion" value="${volunteerActivity.respectiveRegion}">
    <input type="hidden" id="uuid" name="uuid" value="${volunteerActivity.uuid}">
    <input type="hidden" id="hidStatus" value="${volunteerActivity.recruitmentStatus}">
    <input type="hidden" id="hidType" value="${volunteerActivity.recruitObjectType}">

<div class="site">
    <em>您现在所在的位置：</em>文化志愿者 &gt; 志愿者活动管理
</div>
<div class="site-title" id="title">修改志愿者活动</div>

<div class="main-publish">
    <table width="100%" class="form-table">
        <tr>
            <td width="100" class="td-title"><span class="red">*</span>活动名称：</td>
            <td class="td-input" id="nameLabel">
                <input type="text" value="${volunteerActivity.name}" id="name" name="name" class="input-text w210" maxlength="20"/>
            </td>
        </tr>
        <tr>
            <td width="100" class="td-title"><span class="red">*</span>封面图片：</td>
            <td class="td-upload" id="homepageLabel">
                <table>
                    <tr>
                        <td>
                            <div class="whyVedioInfoContent" style="margin-top:-10px;">
                                <div class="whyUploadVedio" id="webuploadhomepage">
                                    <div style="width: 700px;">
                                        <div id="ossfile2">
                                            <div name="aliFile" style="position:relative;margin-bottom:5px;margin-right:15px;max-width:130px;display:inline-block;" >
                                                <img style="max-height: 130px!important;max-width: 130px!important;position: absolute;left: 0;right: 0;top: 0;bottom: 0;margin: auto;" src="${volunteerActivity.picUrl }"><br>
                                                <img onclick="remove(this);" id="aliRemoveBtn" src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201733161236Bn6gTqiCZBHhgObFvsCkLFNzmIBoh2.png" style="position:absolute;right:0;top:0;width:20px">
                                                <input id="picUrl" name="picUrl" value="${volunteerActivity.picUrl }" type="hidden">
                                            </div>
                                        </div>
                                        <div id="container2" style="clear:both;">
                                            <a id="selectfiles2" href="javascript:void(0);" class='btn' style="width: 120px;background-color: #1882FC;">选择封面</a>
                                            <pre style="font-size: 14px;color: #999;line-height: 25px;">Tip：可上传1张图片，建议尺寸<span style="color:red">750*500像素</span>，格式为jpg、jpeg、png、gif，大小不超过<span style="color:red">2M</span></pre>
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
            <td class="td-title"><span class="red">*</span>启动招募：
                <input type="text" id="recruitmentStatusLimit" style="position: absolute; left: -9999px;" />
            </td>
            <td class="td-select" id="recruitmentStatusLabel">
                <div class="select-box w140">
                    <input type="hidden" id="recruitmentStatus" value="${volunteerActivity.recruitmentStatus}" name="recruitmentStatus"/>
                    <div class="select-text" data-value="" id="recruitmentStatusDiv">全部类别</div>
                    <ul class="select-option" id="recruitmentStatusUl">
                        <li data-option="1">是</li>
                        <li data-option="2">否</li>
                    </ul>
                </div>
            </td>
        </tr>
        <tr>
            <td class="td-title"><span class="red">*</span>招募对象类型：
                <input type="text" id="recruitObjectTypeLimit" style="position: absolute; left: -9999px;" />
            </td>
            <td class="td-select" id="recruitObjectTypeLabel">
                <div class="select-box w140">
                    <input type="hidden" id="recruitObjectType" value="${volunteerActivity.recruitObjectType}" name="recruitObjectType"/>
                    <div class="select-text" data-value="" id="recruitObjectTypeDiv">全部类别</div>
                    <ul class="select-option" id="recruitObjectTypeUl">
                        <li data-option="1">个人</li>
                        <li data-option="2">团队</li>
                        <%--<li data-option="1,2">个人、团队</li>--%>
                    </ul>
                </div>
            </td>
        </tr>
        <tr>
            <td  class="td-title"><span class="red">*</span>所属区域：</td>
            <td  class="td-input" id="userCountyTextLabel">
                <div class="main">
                    <div id="locProvinceDiv">
                        <select id="loc_province"
                                style="width: 130px;" value="">
                        </select>
                        <input type="hidden" name="userProvince" id="userProvinceText" />
                    </div>

                    <div id="locCityDiv">
                        <select id="loc_city" style="width: 130px; margin-left: 10px" value="">
                        </select>
                        <input type="hidden" name="userCity" id="userCityText" />
                    </div>

                    <div id="locCountyDiv">
                        <select id="loc_town" style="width: 130px; margin-left: 10px" value="">
                        </select>
                        <input type="hidden" name="userArea" id="userCountyText" />
                    </div>

                </div>
            </td>
        </tr>
        <tr>
            <td class="td-title"><span class="red">*</span>详细地址：</td>
            <td class="td-input" id="addressLabel"><input type="text" value="${volunteerActivity.address }" id="address" name="address" class="input-text w210" maxlength="200"/></td>
        </tr>
        <tr>
            <td class="td-title"><span id="phoneSpan"></span>联系电话：</td>
            <td class="td-input" id="phoneLabel"><input type="text" value="${volunteerActivity.phone }" id="phone" name="phone" class="input-text w210" maxlength="25"/></td>
        </tr>
        <tr>
            <td class="td-title"><span class="red">*</span>允许报名人数：</td>
            <td class="td-input" id="limitNumLabel"><input type="text" value="${volunteerActivity.limitNum}" maxlength="11" name="limitNum" id="limitNum" class="input-text w210" onkeyup="this.value=this.value.replace(/\D/g,'')"/></td>
        </tr>
        <tr>
            <td class="td-title"><span class="red">*</span>活动时间：</td>
            <td class="td-input" id="timeLabel">
            <input  type="text"  value="<fmt:formatDate value="${volunteerActivity.startTime}" pattern="yyyy-MM-dd HH:mm:ss"/>" name="startTime" id="startTime" onClick="WdatePicker({dateFmt: 'yyyy-MM-dd HH:mm:ss'});" class="input-text w120" />
            至
            <input  type="text"  value="<fmt:formatDate value="${volunteerActivity.endTime}" pattern="yyyy-MM-dd HH:mm:ss"/>" name="endTime" id="endTime" onClick="WdatePicker({dateFmt: 'yyyy-MM-dd HH:mm:ss'});" class="input-text w120" />

            </td>
        </tr>
        <tr>
            <td class="td-title"><span class="red">*</span>服务时长：</td>
            <td class="td-input" id="serviceTimeLabel"><input type="text" value="${volunteerActivity.serviceTime}" maxlength="5" name="serviceTime" id="serviceTime" class="input-text w210" onkeyup="this.value=this.value.replace(/\D/g,'')"/>小时</td>
        </tr>

        <tr>
            <td width="100" class="td-title">详细描述：</td>
            <td class="td-content" id="descriptionLabel">
                <div class="editor-box">
                    <textarea name="description" id="description">${volunteerActivity.description }</textarea>
                </div>
            </td>
        </tr>
        <tr>
            <td width="100" class="td-title">附件：</td>
            <td class="td-upload" id="videoLabel">
                <table>
                    <tr>
                        <td>
                            <div class="whyVedioInfoContent" style="margin-top:-10px;">
                                <div class="whyUploadVedio" id="webuploadattachment">
                                    <div style="width: 700px;">
                                        <div id="ossfile2">
                                            <c:if test="${volunteerActivity.attachment!=null && volunteerActivity.attachment != '' }">
                                                <div name="aliFile" style="position:relative;margin-bottom:5px;margin-right:15px;max-width:130px;display:inline-block;" >
                                                    <img onclick="remove(this);" id="aliRemoveBtn" src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201733161236Bn6gTqiCZBHhgObFvsCkLFNzmIBoh2.png" style="position:absolute;right:0;top:0;width:20px;z-index:10;">
                                                    <a href='${volunteerActivity.attachment }' target="_blank">查看附件</a>
                                                    <input id="attachment" name="attachment" value="${volunteerActivity.attachment }" type="hidden">
                                                </div>
                                            </c:if>
                                        </div>
                                        <div id="container2" style="clear:both;">
                                            <a id="selectfiles2" href="javascript:void(0);" class='btn' style="width: 120px;background-color: #1882FC">上传附件</a>
                                            <%--<pre style="font-size: 14px;color: #999;line-height: 25px;">Tip：<span style="color:red">仅支持MP4</span></pre>--%>
                                        </div>
                                        <script type="text/javascript">
                                            // 视频
                                            aliUploadFiles('webuploadattachment', uploadImgCallbackAttachment, 1, true, 'beipiao');
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
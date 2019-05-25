<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:setLocale value="zh_CN"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/html">
<head>
    <title>编辑<c:if test="${teamUser.tuserIsDisplay == 0}">团体草稿</c:if><c:if test="${teamUser.tuserIsDisplay == 1}">团体</c:if><c:if test="${teamUser.tuserIsDisplay == 2}">冻结团体</c:if></title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
  <script type="text/javascript" src="${path}/STATIC/js/admin/teamUser/UploadTeamUserImg.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
   <%-- <script type="text/javascript" src="${path}/STATIC/js/admin/teamUser/getTeamUserImg.js"></script>--%>
    <%--<script type="text/javascript" src="${path}/STATIC/js/admin/teamUser/teamUserEdit.js"></script>--%>

    <script type="text/javascript">
        $(function(){
            var editor = CKEDITOR.replace('tuserTeamRemark');

            getArea();
            getTerminalUser($("#userId").val());
            getTags();
            getAllStationManager('${teamUser.tuserProvince}','${teamUser.tuserCity}','${teamUser.tuserCounty}');
            getTeamUserType();
        });

        // 得到所有站点下的管理员
        function getAllStationManager(userProvince,userCity,userArea){
            showSelectData("memberName", "../terminalUser/getTerminalUserByArea.do?userProvince="+userProvince.split(',')[0]+"&userCity="+userCity.split(',')[0]+"&userArea="+userArea.split(',')[0], "请选择管理员",$("#userId").val());


            selectStationManager();
        }

        function selectStationManager(){
            $("#memberName").change(function() {
                $("#userId").val(($("#memberName").find("option:selected").val()));
                if($("#userId").val() == ""){
                    $("#userBirth").html("");
                    $("#userSex").html("");
                    $("#userMobileNo").html("");
                    return;
                }
                getTerminalUser($("#userId").val());
            });
        }

        function getTerminalUser(userId){
            $.post("${path}/terminalUser/getTerminalUserByUserId.do",{userId:userId},function(data){
                removeMsg("userIdLabel");
                if(data != null && data != ""){
                    if(data.userBirth != "" && data.userBirth != null){
                        $("#userBirth").html("出生日期："+data.userBirth.substring(0,10));
                    }else{
                        $("#userBirth").html("");
                    }

                    if(data.userSex != "" && data.userSex != null){
                        if(data.userSex == 1){
                            $("#userSex").html("性别：男");
                        }else if(data.userSex == 2){
                            $("#userSex").html("性别：女");
                        }else{
                            $("#userSex").html("");
                        }
                    }else{
                        $("#userSex").html("");
                    }

                    if(data.userMobileNo != null && data.userMobileNo != ""){
                        $("#userMobileNo").html("手机号码："+data.userMobileNo);
                    }else{
                        $("#userMobileNo").html("");
                    }
                }
            });
        }

        // 省市区
        function getArea(){
            var teamUserProvince='${teamUser.tuserProvince}';
            var teamUserCity='${teamUser.tuserCity}';
            var teamUserArea='${teamUser.tuserCounty}';
            if(teamUserProvince!=undefined&&teamUserCity!=undefined&&teamUserArea!=undefined){
                //省市区
                showTeamUserLocation(teamUserProvince.split(",")[0],teamUserCity.split(",")[0],teamUserArea.split(",")[0]);
                $("#loc_province").select2("val", teamUserProvince.split(",")[0]);
                $("#loc_city").select2("val", teamUserCity.split(",")[0]);
                $("#loc_town").select2("val",  teamUserArea.split(",")[0]);

            }else {
                showTeamUserLocation();
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

        function showTeamUserLocation(province , city , town) {
            var loc	= new Location();
            var title	= ['省' , '市' , '区'];
            $.each(title , function(k , v) {
                title[k]	= '<option value="">'+v+'</option>';
            });

            $('#loc_province').append(title[0]);
            $('#loc_city').append(title[1]);
            $('#loc_town').append(title[2]);

            $("#loc_province,#loc_city,#loc_town").select2()
            $('#loc_province').change(function() {
                $('#loc_city').empty();
                $('#loc_city').append(title[1]);
                loc.fillOption('loc_city' , '0,'+$('#loc_province').val());
                $('#loc_city').change()
                //$('input[@name=location_id]').val($(this).val());
            });

            $('#loc_city').change(function() {
                $('#loc_town').empty();
                $('#loc_town').append(title[2]);
                loc.fillOption('loc_town' , '0,' + $('#loc_province').val() + ',' + $('#loc_city').val());
                //$('input[@name=location_id]').val($(this).val());
            });

            $('#loc_town').change(function() {
                $("#userId").val("");
               /* $('input[name=location_id]').val($(this).val());*/
                var userProvince = $("#loc_province").find("option:selected").val() +","+$("#loc_province").find("option:selected").text();
                var userCity = $("#loc_city").find("option:selected").val() +","+$("#loc_city").find("option:selected").text();
                var userArea = $("#loc_town").find("option:selected").val() +","+$("#loc_town").find("option:selected").text();
                getAllStationManager(userProvince, userCity, userArea);
                $("#userSex").html("");
                $("#userBirth").html("");
                $("#userMobileNo").html("");

                // 位置字典根据区域变更
                //dictLocation($("#loc_town").find("option:selected").val());
                $.post("${path}/sysdict/queryChildSysDictByDictCode.do",{dictCode:$("#loc_town").find("option:selected").val()}, function(data) {
                    var list = eval(data);
                    var dictHtml = '';
                    var other = "";
                    for (var i = 0; i < list.length; i++) {
                        var obj = list[i];
                        var dictId = obj.dictId;
                        var dictName = obj.dictName;

                        if(dictName == "其他"){
                            other =  '<a class="cur" onclick="setTeamUserDict(\''
                            + dictId + '\',\'teamUserLocation\')">' + dictName
                            + '</a>';
                            $("#teamUserLocation").val(dictId);
                        }else{
                            dictHtml += '<a onclick="setTeamUserDict(\''
                            + dictId + '\',\'teamUserLocation\')">' + dictName
                            + '</a>';
                        }
                    }
                    /*if(dictHtml != ""){
                     if(tid == "" || tid == null){
                     dictHtml += '<a class="cur" onclick="setTeamUserDict(\'\',\'teamUserLocation\')">全部</a>';
                     }else{
                     dictHtml += '<a  onclick="setTeamUserDict(\'\',\'teamUserLocation\')">全部</a>';
                     }
                     }*/
                    dictHtml += other;
                    $("#teamUserLocationLabel").html(dictHtml);
                    tagSelectDict("teamUserLocationLabel");
                });
            });

            if (province) {
                loc.fillOption('loc_province' , '0' , province);

                if (city) {
                    loc.fillOption('loc_city' , '0,'+province , city);

                    if (town) {
                        loc.fillOption('loc_town' , '0,'+province+','+city , town);
                    }
                }

            } else {
                loc.fillOption('loc_province' , '0');
            }
        }

        // 团体类别
        function getTeamUserType(){
            $("#userSex").html("");
            $.post("${path}/sysdict/queryCode.do",{'dictCode' : 'TEAM_TYPE'},function(data) {
                if (data != '' && data != null) {
                    var list = eval(data);
                    var ulHtml = '';
                    var tuserTeamType= $('#tuserTeamType').val();
                    for (var i = 0; i < list.length; i++) {
                        var dict = list[i];
                        ulHtml += '<li data-option="'+dict.dictId+'">'
                        + dict.dictName + '</li>';
                        if (tuserTeamType != '' &&  tuserTeamType == dict.dictId) {
                            $('#tagTypeDiv').html(dict.dictName);
                        }
                    }
                    $('#tagTypeUl').html(ulHtml);
                }
            }).success(function(){

            });
            selectModel();
        }

        //提交表单
        function updateTeamUser(tuserIsDisplay){

            var isCutImg =$("#isCutImg").val();
            if("N"==isCutImg) {
                dialogAlert("提示","请先裁剪系统要求尺寸(750*500)的图片，再提交！",function(){
                });
                return;
            }


            $("#tuserIsDisplay").val(tuserIsDisplay);
            //省市区
            $('#tuserProvinceText').val($('#loc_province').val()+","+$('#loc_province').select2('data').text);
            $('#tuserCityText').val($('#loc_city').val()+","+$('#loc_city').select2('data').text);
            $('#tuserCountyText').val($('#loc_town').val()+","+$('#loc_town').select2('data').text);

            var tuserName = $("#tuserName").val();
            var tuserCountyText = $("#tuserCountyText").val();
            var userId = $("#userId").val();
            //var teamUserCrowd = $("#teamUserCrowd").val();
            var teamUserProperty = $("#teamUserProperty").val();
           // var teamUserSite = $("#teamUserSite").val();
            var tuserPicture = $("#tuserPicture").val();
            var tuserTeamType = $("#tuserTeamType").val();
            var tuserLimit = $("#tuserLimit").val();

            //团体名称
            if(tuserName==undefined|| $.trim(tuserName)==""){
                removeMsg("tuserNameLabel");
                appendMsg("tuserNameLabel","团体名称为必填项!");
                $('#tuserName').focus();
                return;
            }else{
                removeMsg("tuserNameLabel");
            }

            //所属站点
            if(tuserCountyText== ",区"){
                removeMsg("tuserCountyLabel");
                appendMsg("tuserCountyLabel","所属站点为必选项!");
                $('#tuserCounty').focus();
                return;
            }else{
                removeMsg("tuserCountyLabel");
            }

            //管理员姓名
            if(userId ==undefined|| $.trim(userId)==""){
                removeMsg("userIdLabel");
                appendMsg("userIdLabel","管理员姓名为必选项!");
                $('#managerUser').focus();
                return;
            }else{
                removeMsg("userIdLabel");
            }

            //团体标签必选
            if($.trim(teamUserProperty)==""){
                removeMsg("teamUserPropertyLabel");
                appendMsg("teamUserPropertyLabel","团体标签必选一个!");
                $('#teamTag').focus();
                return;
            }else{
                removeMsg("teamUserPropertyLabel");
            }

            //团体图像
            if(tuserPicture ==undefined|| $.trim(tuserPicture)==""){
                removeMsg("tuserPictureLabel");
                appendMsg("tuserPictureLabel","必须上传团体图像!");
                $('#tuserPicture').focus();
                return;
            }else{
                removeMsg("tuserPictureLabel");
            }

            //团体类别
            if(tuserTeamType==undefined|| $.trim(tuserTeamType)==""){
                removeMsg("tuserTeamTypeLabel");
                appendMsg("tuserTeamTypeLabel","团体类别为必选项!");
                $('#tuserTeamTypeLimit').focus();
                return;
            }else{
                removeMsg("tuserTeamTypeLabel");
            }

            //成员上限
            if(tuserLimit==undefined|| $.trim(tuserLimit)==""){
                removeMsg("tuserLimitLabel");
                appendMsg("tuserLimitLabel","成员上限为必填项!");
                $('#tuserLimit').focus();
                return;
            }else{
                var count = '${count}';
                if(parseInt(tuserLimit) < parseInt(count)){
                    removeMsg("tuserLimitLabel");
                    appendMsg("tuserLimitLabel","成员上限不能低于该团体当前成员数量"+count);
                    $('#tuserLimit').focus();
                    return;
                }else{
                    removeMsg("tuserLimitLabel");
                }
            }

            //富文本编辑器
            $('#tuserTeamRemark').val(CKEDITOR.instances.tuserTeamRemark.getData());

            //修改团体信息
            $.post("${path}/teamUser/editTeamUser.do", $("#teamUserForm").serialize(),function(data) {
                if (data!=null && data=='success') {
                    var html = "";
                    if(tuserIsDisplay == 0){
                        html = "团体草稿修改成功";
                    }else if(tuserIsDisplay == 1){
                        html = "团体修改成功";
                    }else{
                        html = "冻结团体修改成功";
                    }
                    dialogSaveDraft("提示", html, function(){
                        if($("#tuserIsDisplay").val() == 1){
                            window.location.href = "${path}/teamUser/teamUserIndex.do?tuserIsDisplay="+$("#tuserIsDisplay").val();
                        }else{
                            window.location.href = "${path}/teamUser/teamUserIndex.do";
                        }
                    });
                } else {
                    var html = "";
                    if(tuserIsDisplay == 0){
                        html = "团体草稿修改失败";
                    }else if(tuserIsDisplay == 1){
                        html = "团体修改失败";
                    }else{
                        html = "冻结团体修改失败";
                    }
                    dialogSaveDraft("提示", html)
                }
             });
        }

        // 标签
        function getTags(){
            //人群标签
            /*$.post("${path}/tag/getChildTagByType.do?code=TEAMUSER_CROWD", function(data) {
                var list = eval(data);
                var tagHtml = '';
                var tagIds = $("#teamUserCrowd").val();
                var ids = '';
                if (tagIds.length > 0) {
                    ids = tagIds.substring(0, tagIds.length - 1).split(",");
                }
                for (var i = 0; i < list.length; i++) {
                    var obj = list[i];
                    var tagId = obj.tagId;
                    var tagName = obj.tagName;
                    var result = false;
                    if (ids != '') {
                        for (var j = 0; j <ids.length; j++) {
                            if (tagId == ids[j]) {
                                result = true;
                                break;
                            }
                        }
                    }
                    var cl = '';
                    if (result) {
                        cl = 'class="cur"';
                    }
                    tagHtml += '<a ' + cl +' onclick="setTeamUserTag(\''
                    + tagId + '\',\'teamUserCrowd\')">' + tagName
                    + '</a>';
                }
                $("#teamUserCrowdLabel").html(tagHtml);
                tagSelect("teamUserCrowdLabel");
            });*/

            // 属性标签
            $.post("${path}/tag/getChildTagByType.do?code=TEAMUSER_PROPERTY", function(data) {
                var list = eval(data);
                var tagHtml = '';
                var tagIds = $("#teamUserProperty").val();
                var ids = '';
                if (tagIds.length > 0) {
                    ids = tagIds.substring(0, tagIds.length - 1).split(",");
                }
                for (var i = 0; i < list.length; i++) {
                    var obj = list[i];
                    var tagId = obj.tagId;
                    var tagName = obj.tagName;
                    var result = false;
                    if (ids != '') {
                        for (var j = 0; j <ids.length; j++) {
                            if (tagId == ids[j]) {
                                result = true;
                                break;
                            }
                        }
                    }
                    var cl = '';
                    if (result) {
                        cl = 'class="cur"';
                    }
                    tagHtml += '<a '+cl+' onclick="setTeamUserTag(\''
                    + tagId + '\',\'teamUserProperty\')">' + tagName
                    + '</a>';
                }
                $("#teamUserPropertyLabel").html(tagHtml);
                tagSelect("teamUserPropertyLabel");
            });

            // 地点标签
            /*$.post("${path}/tag/getChildTagByType.do?code=TEAMUSER_SITE", function(data) {
                var list = eval(data);
                var tagHtml = '';
                var tagIds = $("#teamUserSite").val();
                var ids = '';
                if (tagIds.length > 0) {
                    ids = tagIds.substring(0, tagIds.length - 1).split(",");
                }
                for (var i = 0; i < list.length; i++) {
                    var obj = list[i];
                    var tagId = obj.tagId;
                    var tagName = obj.tagName;
                    var result = false;
                    if (ids != '') {
                        for (var j = 0; j <ids.length; j++) {
                            if (tagId == ids[j]) {
                                result = true;
                                break;
                            }
                        }
                    }
                    var cl = '';
                    if (result) {
                        cl = 'class="cur"';
                    }
                    tagHtml += '<a '+cl+' onclick="setTeamUserTag(\''
                    + tagId + '\',\'teamUserSite\')">' + tagName
                    + '</a>';
                }
                $("#teamUserSiteLabel").html(tagHtml);
                tagSelect("teamUserSiteLabel");
            });*/

            dictLocation('${fn:substringBefore(teamUser.tuserCounty,",")}');
        }

        function dictLocation(code){
            // 位置字典
            $.post("${path}/sysdict/queryChildSysDictByDictCode.do",{dictCode:code}, function(data) {
                var list = eval(data);
                var dictHtml = '';
                var tid = $("#teamUserLocation").val();
                var other = "";
                for (var i = 0; i < list.length; i++) {
                    var obj = list[i];
                    var dictId = obj.dictId;
                    var dictName = obj.dictName;

                    var result = false;
                    if (tid == dictId) {
                        result = true;
                    }
                    var cl = '';
                    if (result) {
                        cl = 'class="cur"';
                    }
                    if(dictName == "其他"){
                        other =  '<a '+cl+' onclick="setTeamUserDict(\''
                        + dictId + '\',\'teamUserLocation\')">' + dictName
                        + '</a>';
                    }else{
                        dictHtml += '<a '+cl+' onclick="setTeamUserDict(\''
                        + dictId + '\',\'teamUserLocation\')">' + dictName
                        + '</a>';
                    }
                }
                /*if(dictHtml != ""){
                    if(tid == "" || tid == null){
                        dictHtml += '<a class="cur" onclick="setTeamUserDict(\'\',\'teamUserLocation\')">全部</a>';
                    }else{
                        dictHtml += '<a  onclick="setTeamUserDict(\'\',\'teamUserLocation\')">全部</a>';
                    }
                }*/
                dictHtml += other;
                $("#teamUserLocationLabel").html(dictHtml);
                tagSelectDict("teamUserLocationLabel");
            });
        }

        function setTeamUserDict(value,id){
            $("#"+id).val(value);
            //$('#'+id).find('a').removeClass('cur');
        }

        function tagSelectDict(id) {
            /* tag标签选择 */

            $('#'+id).find('a').click(function() {
                $('#'+id).find('a').removeClass('cur');
                $(this).addClass('cur');
            });
        }

        //选择关键字标签时，赋值
        function setTeamUserTag(value,id) {
            var tagIds = $("#"+id).val();
            if (tagIds != '') {
                var ids = tagIds.substring(0, tagIds.length - 1).split(",");
                var data = '', r = true;
                for (var i = 0; i < ids.length; i++) {
                    if (ids[i] == value) {
                        r = false;
                    } else {
                        data = data + ids[i] + ',';
                    }
                }
                if (r) {
                    data += value + ',';
                }
                $("#"+id).val(data);
            } else {
                $("#"+id).val(value + ",");
                removeMsg("teamUserPropertyLabel");
            }
        }

        function tagSelect(id) {
            /* tag标签选择 */
            $('#'+id).find('a').click(function() {
                if ($(this).hasClass('cur')) {
                    $(this).removeClass('cur');
                } else {
                    $(this).addClass('cur');
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

                var urlStr = $("#tuserPicture").val();

                var url =getImgUrl(urlStr);
                dialog({
                    url: '${path}/att/toCutImgJsp.do?imageURL='+url+'&cutImageSize='+cutImageSize,
                    title: '图片裁剪',
                    fixed: false,
                    onclose: function () {
                        if(this.returnValue){
                            //alert("返回值：" + this.returnValue.imageUrl);
                            $("#imgHeadPrev").html(getImgHtml(this.returnValue.imageUrl));
                            $("#tuserPicture").val(this.returnValue.imageUrl);
                        }
                    }
                }).showModal();
                return false;
            });
        });

    </script>
</head>

<body >
<form id="teamUserForm" method="post">
    <input type="hidden" id="sessionId" value="${pageContext.session.id}"/>
    <input type="hidden" id="userCounty" value="${sessionScope.user.userCounty}" />
    <input type="hidden" id="tuserId" name="tuserId" value="${teamUser.tuserId}">
    <input type="hidden" id="applyId" name="applyId" value="${teamUser.applyId}">
    <input type="hidden" id="isCutImg" value="Y"/>
    <div class="site">
        <em>您现在所在的位置：</em>团体管理 &gt; 编辑<c:if test="${teamUser.tuserIsDisplay == 0}">团体草稿</c:if><c:if test="${teamUser.tuserIsDisplay == 1}">团体</c:if><c:if test="${teamUser.tuserIsDisplay == 2}">冻结团体</c:if>
    </div>
    <div class="site-title">编辑团体</div>
    <div class="main-publish">
        <table width="100%" class="form-table">
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>团体名称：</td>
                <td class="td-input" id="tuserNameLabel"><input type="text" value="${teamUser.tuserName}" id="tuserName" name="tuserName" class="input-text w510" maxlength="50"/></td>
            </tr>
            <tr>
                <td  class="td-title"><span class="red">*</span>所属站点：<input type="text" id="tuserCounty" style="position: absolute; left: -9999px;" /></td>
                <td  class="td-input-one" id="tuserCountyLabel">
                    <div class="main">
                        <div id="locProvinceDiv">
                            <select id="loc_province" style="width: 130px;" <c:if test="${not empty teamUser.tuserProvince}"> value="${fn:substringBefore(teamUser.tuserProvince,',')}" </c:if>>
                                <c:if test="${not empty teamUser.tuserProvince}">
                                    ${fn:substringAfter(teamUser.tuserProvince,',')}
                                </c:if>
                            </select>
                            <input type="hidden" name="tuserProvince" id="tuserProvinceText" />
                        </div>

                        <div id="locCityDiv">
                            <select id="loc_city" style="width: 130px; margin-left: 10px" <c:if test="${not empty teamUser.tuserCity}">value="${fn:substringBefore(teamUser.tuserCity,',')}" </c:if>>
                                <c:if test="${not empty teamUser.tuserCity}">
                                    ${fn:substringAfter(teamUser.tuserCity,',')}
                                </c:if>
                            </select>
                            <input type="hidden" name="tuserCity" id="tuserCityText" />
                        </div>

                        <div id="locCountyDiv">
                            <select id="loc_town" style="width: 130px; margin-left: 10px" <c:if test="${not empty teamUser.tuserCounty}">value="${fn:substringBefore(teamUser.tuserCounty,',')}"</c:if>>
                                <c:if test="${not empty teamUser.tuserCounty}">
                                    ${fn:substringAfter(teamUser.tuserCounty,',')}
                                </c:if>
                            </select>
                            <input type="hidden" name="tuserCounty" id="tuserCountyText" />
                        </div>

                    </div>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>管理员姓名：<input type="text" id="managerUser" style="position: absolute; left: -9999px;" /></td>
                <td class="td-select" id="userIdLabel">
                    <input type="hidden" name="userId"  id="userId" value="${teamUser.userId}"/>
                    <select id="memberName" style="width:142px; margin-right: 8px"></select>
                    <span id="userSex"></span>&nbsp;&nbsp;&nbsp;
                    <span id="userBirth"></span>&nbsp;&nbsp;&nbsp;
                    <span id="userMobileNo"></span>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>团体标签：<input type="text" id="teamTag" style="position: absolute; left: -9999px;" /></td>
                <td class="td-tag">
                    <%--<dl>
                        <dt>人群</dt>
                        <input id="teamUserCrowd" name="tuserCrowdTag" style="position: absolute; left: -9999px;" type="hidden" value="${teamUser.tuserCrowdTag}"/>
                        <dd id="teamUserCrowdLabel">
                        </dd>
                    </dl>--%>
                    <dl>
                        <dt>属性</dt>
                        <input id="teamUserProperty" name="tuserPropertyTag" style="position: absolute; left: -9999px;" type="hidden" value="${teamUser.tuserPropertyTag}"/>
                        <dd id="teamUserPropertyLabel">
                        </dd>
                    </dl>
                    <%--<dl>
                        <dt>地点</dt>
                        <input id="teamUserSite" name="tuserSiteTag" style="position: absolute; left: -9999px;" type="hidden" value="${teamUser.tuserSiteTag}"/>
                        <dd id="teamUserSiteLabel">
                        </dd>
                    </dl>--%>
                    <dl>
                        <dt>位置</dt>
                        <input id="teamUserLocation" name="tuserLocationDict" style="position: absolute; left: -9999px;" type="hidden" value="${teamUser.tuserLocationDict}"/>
                        <dd id="teamUserLocationLabel">
                        </dd>
                    </dl>
                </td>
            </tr>
            <tr>
                <td class="td-title"><span class="red">*</span>团体图像：</td>
                <td class="td-upload">
                    <table>
                        <tr>
                            <td id="tuserPictureLabel">
                                <input type="hidden"  name="tuserPicture" id="tuserPicture" value="${teamUser.tuserPicture}">
                                <input type="hidden" name="uploadType" value="Img" id="uploadType"/>

                                <div class="img-box">
                                    <div  id="imgHeadPrev" class="img"> </div>
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
                </td>
            </tr>
            <tr>
                <td class="td-title"><span class="red">*</span>团体类别：<input type="text" id="tuserTeamTypeLimit" style="position: absolute; left: -9999px;" /></td>
                <td class="td-select" id="tuserTeamTypeLabel">
                    <div class="select-box w140">
                        <input type="hidden" name="tuserTeamType" id="tuserTeamType" value="${teamUser.tuserTeamType}"/>
                        <div class="select-text" data-value="" id="tagTypeDiv">所有类别</div>
                        <ul class="select-option" id="tagTypeUl">
                        </ul>
                    </div>
                </td>
            </tr>
            <tr>
                <td class="td-title"><span class="red">*</span>成员上限：</td>
                <td class="td-input" id="tuserLimitLabel">
                    <input type="text" value="${teamUser.tuserLimit}" name="tuserLimit" id="tuserLimit" class="input-text w210" maxlength="11" onkeyup="this.value=this.value.replace(/\D/g,'')"/>
                </td>
            </tr>
            <tr class="td-line">
                <td class="td-title">团体描述：</td>
                <td class="td-content">
                    <div class="editor-box">
                        <textarea name="tuserTeamRemark" id="tuserTeamRemark">
                            ${teamUser.tuserTeamRemark}
                        </textarea>
                    </div>
                </td>
            </tr>
            <tr class="td-btn">
                <td></td>
                <td><input type="hidden" name="tuserIsDisplay" id="tuserIsDisplay" value="${teamUser.tuserIsDisplay}"/>
                    <input type="button" value="修改" class="btn-save" onclick="updateTeamUser('${teamUser.tuserIsDisplay}');"/>
                    <input type="button" value="返回" class="btn-publish" onclick="javascript:history.back(-1);"/>
                </td>
            </tr>
        </table>
    </div>
</form>
</body>
</html>
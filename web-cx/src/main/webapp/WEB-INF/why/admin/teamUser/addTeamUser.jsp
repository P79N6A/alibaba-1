<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:setLocale value="zh_CN"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/html">
<head>
    <title>新增团体</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <script type="text/javascript" src="${path}/STATIC/js/admin/teamUser/UploadTeamUserImg.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    <%--<script type="text/javascript" src="${path}/STATIC/js/admin/teamUser/getTeamUserImg.js"></script>--%>
    <%--<script type="text/javascript" src="${path}/STATIC/js/admin/teamUser/teamUserEdit.js"></script>--%>

    <script type="text/javascript">
        $(function(){
            var editor = CKEDITOR.replace('tuserTeamRemark');

            getArea();
            getTags();
            getAllStationManager('${user.userProvince}','${user.userCity}','${user.userCounty}');
            getTeamUserType();
        });

        // 得到所有站点下的管理员
        function getAllStationManager(userProvince,userCity,userArea){
            showSelectData("memberName", "../terminalUser/getTerminalUserByArea.do?userProvince="+userProvince.split(',')[0]+"&userCity="+userCity.split(',')[0]+"&userArea="+userArea.split(',')[0], "请选择管理员");
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
                $.post("${path}/terminalUser/getTerminalUserByUserId.do",{userId:$("#userId").val()},function(data){
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
            });
        }

        // 省市区
        function getArea(){
            var activityProvince='${user.userProvince}';
            var activityCity='${user.userCity}';
            var activityArea='${user.userCounty}';
            if(activityProvince!=undefined&&activityCity!=undefined&&activityArea!=undefined){
                //省市区
                showTeamUserLocation(activityProvince.split(",")[0],activityCity.split(",")[0],activityArea.split(",")[0]);
                $("#loc_province").select2("val", activityProvince.split(",")[0]);
                $("#loc_city").select2("val", activityCity.split(",")[0]);
                $("#loc_town").select2("val",  activityArea.split(",")[0]);

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
                /*$('input[name=location_id]').val($(this).val());*/
                var userProvince = $("#loc_province").find("option:selected").val() +","+$("#loc_province").find("option:selected").text();
                var userCity = $("#loc_city").find("option:selected").val() +","+$("#loc_city").find("option:selected").text();
                var userArea = $("#loc_town").find("option:selected").val() +","+$("#loc_town").find("option:selected").text();
                getAllStationManager(userProvince, userCity, userArea);
                $("#userSex").html("");
                $("#userBirth").html("");
                $("#userMobileNo").html("");

                // 位置字典根据区域变更
                dictLocation($("#loc_town").find("option:selected").val());
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
                        ulHtml += '<li  data-option="'+dict.dictId+'">'
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
        function addTeamUser(tuserIsDisplay){

            var isCutImg =$("#isCutImg").val();
            if("N"==isCutImg) {
                dialogAlert("提示","请先裁剪系统要求尺寸(750*500)的图片，再提交！",function(){
                });
                return;
            }


            //省市区
            $('#tuserProvinceText').val($('#loc_province').val()+","+$('#loc_province').select2('data').text);
            $('#tuserCityText').val($('#loc_city').val()+","+$('#loc_city').select2('data').text);
            $('#tuserCountyText').val($('#loc_town').val()+","+$('#loc_town').select2('data').text);

            var tuserName = $("#tuserName").val();
            var tuserCountyText = $("#tuserCountyText").val();
            var userId = $("#userId").val();
            //var teamUserCrowd = $("#teamUserCrowd").val();
            var teamUserProperty = $("#teamUserProperty").val();
            //var teamUserSite = $("#teamUserSite").val();
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
                if(tuserLimit > 0){
                    removeMsg("tuserLimitLabel");
                }else{
                    removeMsg("tuserLimitLabel");
                    appendMsg("tuserLimitLabel","成员上限不低于1人!");
                    $('#tuserLimit').focus();
                    return;
                }
            }

            $("#tuserIsDisplay").val(tuserIsDisplay);
            //富文本编辑器
            $('#tuserTeamRemark').val(CKEDITOR.instances.tuserTeamRemark.getData());

            //保存团体信息
            $.post("${path}/teamUser/addTeamUser.do", $("#teamUserForm").serialize(),function(data) {
                if (data!=null && data=='success') {
                    var html = "";
                    if(tuserIsDisplay == 0){
                        html = "草稿保存成功";
                    }else if(tuserIsDisplay == 1){
                        html = "团体发布成功";
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
                        html = "草稿保存失败";
                    }else if(tuserIsDisplay == 1){
                        html = "团体发布失败";
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
                for (var i = 0; i < list.length; i++) {
                    var obj = list[i];
                    var tagId = obj.tagId;
                    var tagName = obj.tagName;
                    var cl = '';
                    cl = 'class="cur"';
                    tagHtml += '<a class="" onclick="setTeamUserTag(\''
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
                for (var i = 0; i < list.length; i++) {
                    var obj = list[i];
                    var tagId = obj.tagId;
                    var tagName = obj.tagName;
                    var cl = '';
                    cl = 'class="cur"';
                    tagHtml += '<a class="" onclick="setTeamUserTag(\''
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
                for (var i = 0; i < list.length; i++) {
                    var obj = list[i];
                    var tagId = obj.tagId;
                    var tagName = obj.tagName;
                    var cl = '';
                    cl = 'class="cur"';
                    tagHtml += '<a class="" onclick="setTeamUserTag(\''
                    + tagId + '\',\'teamUserSite\')">' + tagName
                    + '</a>';
                }
                $("#teamUserSiteLabel").html(tagHtml);
                tagSelect("teamUserSiteLabel");
            });*/

            dictLocation('${fn:substringBefore(user.userCounty,",")}');
        }

        function dictLocation(code){
            // 位置字典
            $.post("${path}/sysdict/queryChildSysDictByDictCode.do",{dictCode:code}, function(data) {
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
                    }else{
                        dictHtml += '<a onclick="setTeamUserDict(\''
                        + dictId + '\',\'teamUserLocation\')">' + dictName
                        + '</a>';
                    }
                }
                /*if(dictHtml != ""){
                    dictHtml += '<a onclick="setTeamUserDict(\'\',\'teamUserLocation\')" class="cur">全部</a>';
                }*/
                dictHtml += other;
                $("#teamUserLocationLabel").html(dictHtml);
                tagSelectDict("teamUserLocationLabel");
            });
        }

        function setTeamUserDict(value,id){
            $("#"+id).val(value);
           // $('#'+id).find('a').removeClass('cur');
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



    </script>
</head>

<body >
<form id="teamUserForm" method="post">
    <input type="hidden" id="sessionId" value="${pageContext.session.id}"/>
    <input type="hidden" id="userCounty" value="${sessionScope.user.userCounty}" />
    <input type="hidden" id="tuserId" name="tuserId" value="${teamUser.tuserId}">
    <input type="hidden" id="applyId" name="applyId" value="${teamUser.applyId}">
    <input type="hidden" id="isCutImg" value="N"/>
    <div class="site">
        <em>您现在所在的位置：</em>团体管理 &gt; 新增团体
    </div>
    <div class="site-title">新增团体</div>
    <div class="main-publish">
        <table width="100%" class="form-table">
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>团体名称：</td>
                <td class="td-input" id="tuserNameLabel"><input type="text" id="tuserName" name="tuserName" class="input-text w510" maxlength="50"/></td>
            </tr>
            <tr>
                <td  class="td-title"><span class="red">*</span>所属站点：<input type="text" id="tuserCounty" style="position: absolute; left: -9999px;" /></td>
                <td  class="td-input-one" id="tuserCountyLabel">
                    <div class="main">
                        <div id="locProvinceDiv">
                            <select id="loc_province" style="width: 130px;" name=""></select>
                            <input type="hidden" name="tuserProvince" id="tuserProvinceText"/>
                        </div>

                        <div id="locCityDiv">
                            <select id="loc_city" style="width: 130px; margin-left: 10px"></select>
                            <input type="hidden" name="tuserCity" id="tuserCityText"/>
                        </div>

                        <div id="locCountyDiv">
                            <select id="loc_town" style="width: 130px; margin-left: 10px"></select>
                            <input type="hidden" name="tuserCounty" id="tuserCountyText"/>
                        </div>

                    </div>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>管理员姓名：<input type="text" id="managerUser" style="position: absolute; left: -9999px;" /></td>
                <td class="td-select" id="userIdLabel">
                    <input type="hidden" name="userId"  id="userId"/>
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
                        <input id="teamUserCrowd" name="tuserCrowdTag" style="position: absolute; left: -9999px;" type="hidden"/>
                        <dd id="teamUserCrowdLabel">
                        </dd>
                    </dl>--%>
                    <dl>
                        <dt>属性</dt>
                        <input id="teamUserProperty" name="tuserPropertyTag" style="position: absolute; left: -9999px;" type="hidden"/>
                        <dd id="teamUserPropertyLabel">
                        </dd>
                    </dl>
                   <%-- <dl>
                        <dt>地点</dt>
                        <input id="teamUserSite" name="tuserSiteTag" style="position: absolute; left: -9999px;" type="hidden"/>
                        <dd id="teamUserSiteLabel">
                        </dd>
                    </dl>--%>
                    <dl>
                        <dt>位置</dt>
                        <input id="teamUserLocation" name="tuserLocationDict" style="position: absolute; left: -9999px;" type="hidden"/>
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
                                <input type="hidden"  name="tuserPicture" id="tuserPicture" value="">
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
                        <input type="hidden" name="tuserTeamType" id="tuserTeamType"/>
                        <div class="select-text" data-value="" id="tagTypeDiv">所有类别</div>
                        <ul class="select-option" id="tagTypeUl">
                        </ul>
                    </div>
                </td>
            </tr>
            <tr>
                <td class="td-title"><span class="red">*</span>成员上限：</td>
                <td class="td-input" id="tuserLimitLabel">
                    <input type="text"  name="tuserLimit" id="tuserLimit" class="input-text w210" maxlength="11" onkeyup="this.value=this.value.replace(/\D/g,'')"/>
                </td>
            </tr>
            <tr class="td-line">
                <td class="td-title">团体描述：</td>
                <td class="td-content">
                    <div class="editor-box">
                        <textarea name="tuserTeamRemark" id="tuserTeamRemark"></textarea>
                    </div>
                </td>
            </tr>
            <tr class="td-btn">
                <td></td>
                <td><input type="hidden" name="tuserIsDisplay" id="tuserIsDisplay"/>
                    <%--<input type="button" value="保存草稿" class="btn-save" onclick="addTeamUser(0)"/>--%>
                    <input type="button" value="新建团体" class="btn-publish" onclick="addTeamUser(1)"/>
                </td>
            </tr>
        </table>
    </div>
</form>
</body>
</html>
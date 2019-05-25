<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>安康文化云·志愿服务详情</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="shortcut icon" href="/favicon.ico">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <style>
        .bar-tab {
            z-index: 20;
        }
        .bar-tab .tab-item.enroll-btn {
            color: #fff;
            background-color: #0894ec;
        }
        #description p img{
            max-width:100% !important;
            width:auto !important;
            height:auto !important;
        }
    </style>
</head>

<body>
    <input type="hidden" value="${ activityId }" name="activityId" id="activityId"/>
    <input type="hidden" id="userId" name="userId" value="${sessionScope.terminalUser.userId}"/>
    <div class="content" style="padding-bottom: 2.5rem;">

        <!--活动标题、招募人数、收藏-->
        <div class="card demo-card-header-pic">
            <div valign="bottom" class="card-header color-white no-border no-padding">
                <img class="card-cover" src="" alt="" id="picUrl">
            </div>
            <div class="card-content">
                <div class="card-content-inner">
                    <p id="name"></p>
                    <p class="color-gray" id="limitNum"></p>
                    <p class="color-gray" id="time"></p>
                    <p class="color-gray" id="type"></p>
                    <p class="color-gray" id="address"></p>
                    <p class="color-gray" id="phone"></p>
                </div>
            </div>
        </div>

        <!--活动详情、活动纪实-->
        <div class="card">
            <div class="card-content">
                <div class="buttons-tab">
                    <a href="#tab1" class="tab-link active button">活动详情</a>
                    <a href="#tab2" class="tab-link button">活动纪实</a>
                </div>
                <div class="content-block">
                    <div class="tabs">
                        <div id="tab1" class="tab active">
                            <div class="content-block">
                                <p id="description"></p>
                            </div>
                        </div>
                        <div id="tab2" class="tab">
                            <div class="content-block">
                                <p id="containerDocumentaryList"></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!--评论列表-->
        <!--暂时不做-->
        <!--
        <div class="card">
            <div class="card-header">评论列表</div>
            <div class="card-content">
            </div>
        </div>
        -->
    </div>
    <nav class="bar bar-tab" id="bar-tab">
    </nav>

    <%@include file="/WEB-INF/why/wechat/static/volunteer/menu.jsp" %>
<script type='text/javascript' src='//g.alicdn.com/sj/lib/zepto/zepto.min.js' charset='utf-8'></script>
<script type='text/javascript' src='//g.alicdn.com/msui/sm/0.6.2/js/sm.min.js' charset='utf-8'></script>
<script type='text/javascript' src='//g.alicdn.com/msui/sm/0.6.2/js/sm-extend.min.js' charset='utf-8'></script>

<script>
    $(document).ready(function(){
        getDetail();
    });

    //获取详情数据
    function getDetail(){
        var activityId = $('#activityId').val()
        var strList = ''
        $.ajax({
            type: 'get',
            url: '/newVolunteerActivity/queryNewVolunteerActivityByIdJson.do',
            contentType: 'application/json; charset=utf-8',
            data: {uuid: activityId},
            dataType: 'json',
            before: function(){
                $.showPreloader();
            },
            success: function (res) {
                if(res && res.status === 200){
                    var detail = res.volunteerActivity;
                    if(detail){
                        setDetail(detail);
                    }
                }

            },
            error: function (err) {
                strList = '获取失败';
            },
            complete: function(){
                $('#container').html(strList);
                $.hidePreloader();
            }
        });
    }

    //获取志愿者信息(返回个人志愿者及团队志愿者)
    var arrVolunteer = function () {
        var userId = $('#userId').val();
        if(!userId) return;
        var list = null;
        $.ajax({
            type: 'get',
            url: '/newVolunteer/queryNewVolunteerListByUserId.do?userId=' + userId,
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            async: false,
            success: function (res) {
                list = res;
            }
        });
        return list;
    }

    //获取志愿者加入活动的信息（用于判断当前志愿者是否加入当前活动）
    var volofActivity = function (activityId, volunteerId) {
        if(!activityId) return;
        if(!volunteerId) return;
        var list = null
        $.ajax({
            type: 'get',
            url: '/newVolunteerActivity/queryVolunteerRelationDetailJson.do',
            contentType: 'application/json; charset=utf-8',
            data: {volunteerActivityId: activityId, volunteerId: volunteerId},
            dataType: 'json',
            async: false,
            success: function (res) {
                if(res && res.status === 200){
                    list = res.data ;
                }
            }
        });
        return list;
    }

    //设置详情数据
    function setDetail(detail){
        detail.limitNum = detail.limitNum ? detail.limitNum : 0;
        if(detail.recruitmentStatus == 1) {
            detail.limitNum = '招募' + detail.limitNum + '人';
        } else if(detail.recruitmentStatus == 2) {
            detail.limitNum = '停止招募';
        }
        var time = detail.startTime.substr(0, 16) + ' 至 ' + detail.endTime.substr(0, 16)
        var typeObj = {key: undefined, value:''};//用于保存活动（个人/团队）类型
        if(detail.recruitObjectType){
            if(detail.recruitObjectType === '1,2'){//1个人，2团队
                typeObj = {key: 3, value: '个人，团队'};
            }else if(detail.recruitObjectType == '1'){//1个人
                typeObj = {key: 1, value: '个人'};
            }else if(detail.recruitObjectType == '2'){//2团队
                typeObj = {key: 2, value: '团队'};
            }
        }
        detail.address = detail.address ? detail.address : '';
        $('#picUrl').attr('src', detail.picUrl);
        $('#name').html(detail.name);
        $('#limitNum').html(detail.limitNum);
        $('#time').html('时间：'+time);
        $('#type').html('招募类型：'+typeObj.value);
        $('#address').html('地点：'+detail.address);
        $('#phone').html('联系电话：'+detail.phone);
        detail.description = detail.description ? detail.description : '暂无活动详情';
        $('#description').html(detail.description);
        if(detail.status === 3){//状态：1:草稿 2:未审核 3:正常 4:驳回 9:删除
            var strHtml = '';
            var volunteerList = arrVolunteer();
            var volunteetType = 0; //用户的志愿者类型，0不是志愿者，1个人志愿者，2团队志愿者，3个人+团队志愿者
            var isPersonalJoin = false; //个人是否已加入
            var isTeamJoin = false; //团队是否已加入
            if(volunteerList){
                var volPersonal = null; //个人志愿者信息
                var volTeam = null; //团队志愿者信息
                if(volunteerList.length === 2){
                    volunteetType = 3;
                    volPersonal = volunteerList[0];
                    volTeam = volunteerList[1];
                }else if(volunteerList.length === 1){
                    var vol = volunteerList[0];
                    volunteetType = vol.type;// type：1个人志愿者，2团队志愿者
                    if(vol.type === 1){
                        volPersonal = vol;
                    }else if(vol.type === 2){
                        volTeam = vol;
                    }
                }
                if(volPersonal){
                    isPersonalJoin = volofActivity(detail.uuid, volPersonal.uuid).length > 0;
                }
                if(volTeam){
                    isTeamJoin = volofActivity(detail.uuid, volTeam.uuid).length > 0;
                }
            }
            if(typeObj.key){//活动类型，1个人，2团队，3个人+团队
                if(typeObj.key === 3) {//个人，团队
                    if(volunteetType === 0){//不是个人志愿者也不是团队志愿者
                        strHtml += '<a class="tab-item external" href="#">不是个人志愿者</a>';
                        strHtml += '<a class="tab-item external" href="#">不是团队志愿者</a>';
                    }
                    else if(volunteetType === 1){//是个人志愿者不是团队志愿者
                        if(isPersonalJoin){
                            strHtml += '<a class="tab-item external" href="#">个人已报名</a>';
                        }else {
                            strHtml += '<a class="tab-item external enroll-btn" href="#" onclick="handleEnroll(1)">个人报名</a>';
                        }
                        strHtml += '<a class="tab-item external href="#">不是团队志愿者</a>';
                    }
                    else if(volunteetType === 2){//不是个人志愿者但是团队志愿者
                        strHtml += '<a class="tab-item external" href="#">不是个人志愿者</a>';
                        if(isTeamJoin){
                            strHtml += '<a class="tab-item external" href="#">团队已报名</a>';
                        }else {
                            strHtml += '<a class="tab-item external enroll-btn" href="#" onclick="handleEnroll(2)">团队报名</a>';
                        }
                    }
                    else if(volunteetType === 3){//既是个人志愿者也是团队志愿者
                        if(isPersonalJoin){
                            strHtml += '<a class="tab-item external" href="#">个人已报名</a>';
                        }else {
                            strHtml += '<a class="tab-item external enroll-btn" href="#" onclick="handleEnroll(1)">个人报名</a>';
                        }
                        if(isTeamJoin){
                            strHtml += '<a class="tab-item external" href="#">团队已报名</a>';
                        }else {
                            strHtml += '<a class="tab-item external enroll-btn" href="#" onclick="handleEnroll(2)">团队报名</a>';
                        }
                    }
                }else if(typeObj.key === 1){//个人
                    if(volunteetType === 1 || volunteetType === 3) {
                        if(isPersonalJoin){
                            strHtml += '<a class="tab-item external" href="#">个人已报名</a>';
                        }else {
                            strHtml += '<a class="tab-item external enroll-btn" href="#" onclick="handleEnroll(1)">个人报名</a>';
                        }
                    }else{
                        strHtml = '<a class="tab-item external" href="#">不是个人志愿者</a>';
                    }
                }else if(typeObj.key === 2){//团队
                    if(volunteetType === 2 || volunteetType === 3) {
                        if(isTeamJoin){
                            strHtml += '<a class="tab-item external" href="#">团队已报名</a>';
                        }else {
                            strHtml += '<a class="tab-item external enroll-btn" href="#" onclick="handleEnroll(2)">团队报名</a>';
                        }
                    }else{
                        strHtml = '<a class="tab-item external" href="#">不是团队志愿者</a>';
                    }
                }
            }else{
                strHtml += '<a class="tab-item external" href="#">不是个人志愿者</a>';
                strHtml += '<a class="tab-item external" href="#">不是团队志愿者</a>';
            }
            $('#bar-tab').html(strHtml);
        }else{
            $('#bar-tab').html('<a class="tab-item external" href="#">停止招募</a>');
        }

        //获取风采纪实
        getDocumentarylist();
    }

    //获取风采纪实
    function getDocumentarylist(){
        var activityId = $('#activityId').val()
        var strList = ''
        $.ajax({
            type: 'get',
            url: '/VolunteerActivityDemeanorDocumentary/documentaryList.do',
            contentType: 'application/json; charset=utf-8',
            data: {ownerId: activityId},
            dataType: 'json',
            before: function(){
                $.showPreloader();
            },
            success: function (data) {
                if(data && data.length >0){
                    $.each(data, function(index, item){

                    if(item.resource_type == 1){
                        strList += '<img src="'+ item.resource_site +'" >';
                    }
                    else if(item.resource_type == 2){

                        strList += '<video controls><source src="'+ item.resource_site +'"></video>';
                    }
                    else if(item.resource_type == 1){
                        strList += '<audio src="'+ item.resource_site + '" controls></audio>';
                    }
                    })
                }
            },
            error: function (err) {
                strList = '获取失败';
            },
            complete: function(){
                strList = strList ? '暂无活动纪实':
                $('#containerDocumentaryList').html(strList);
                $.hidePreloader();
            }
        });
    }

    //执行报名
    function handleEnroll(type){//type：1个人报名，2团队报名
        var activityId = $('#activityId').val();
        if(!userId){
            $.toast('请先登录');
            setTimeout(function(){
                location.href = '/muser/login.do?type=/wechatStatic/volunteerDetail.do?id=' + activityId;
            }, 2000);
            return;
        }
        var volunteer = arrVolunteer();
        var volunteerId = '';
        if(volunteer && volunteer.length > 0){
            if(volunteer.length === 1){//当前登录用户是个人志愿者或团队志愿者
                if(type === volunteer[0].type){
                    volunteerId = volunteer[0].uuid;
                }
            }if(volunteer.length === 2){//当前登录用户既是个人志愿者也是团队志愿者
                if(type === 1){
                    volunteerId = volunteer[0].uuid;
                }else{
                    volunteerId = volunteer[1].uuid;
                }
            }
        }
        if(!volunteerId){
            $.toast('请先注册成为志愿者');
            setTimeout(function(){
                location.href = '/wechatStatic/volunteerRegister.do';
            }, 2000);
            return;
        }
        var post = {
            volunteerActivityId: activityId,
            volunteerId: volunteerId,
            status: 2  //--状态：1:草稿 2:未审核 3:正常 4:驳回 9:删除

        }

        //提交报名
        $.ajax({
            type: 'get',
            url: '/newVolunteerActivity/inNewVolunteerActivityJson.do',
            contentType: 'application/json; charset=utf-8',
            data: post,
            dataType: 'json',
            before: function () {
                $.showPreloader();
            },
            success: function (res) {
                if (res && res.status === 200) {
                    $.toast('报名成功');
                    getDetail();
                    return;
                }
                $.toast('报名失败');
            },
            error: function (err) {
                $.toast('报名失败');
            },
            complete: function () {
                $.hidePreloader();
            }
        });
    }
</script>
</body>

</html>
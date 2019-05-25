<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>安康文化云·志愿服务</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <style>
        .volun-header {
            position: relative;
            height: 128px;
            height: 8rem;
            background: #fff url(${path}/STATIC/wechat/image/volunteer.jpg) no-repeat center;
            background-size: cover;
            padding-top: 34.133px;
            padding-top: 2.13333rem;
            text-align: center;
        }
         .volun-header .overlayer {
             position: absolute;
             top: 0;
             right: 0;
             bottom: 0;
             left: 0;
             background: rgba(0, 0, 0, .5);
             z-index: 0;
         }
        .overlayer {
            z-index: 50;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            opacity: 1;
            -webkit-backface-visibility: hidden;
            backface-visibility: hidden;
            background: rgba(0, 0, 0, .7);
            -webkit-backdrop-filter: blur(10px);
            backdrop-filter: blur(10px);
        }
        .btn {
            display: inline-block;
            text-align: center;
            white-space: nowrap;
            vertical-align: middle;
            -webkit-user-select: none;
            -moz-user-select: none;
            -ms-user-select: none;
            user-select: none;
            outline: none;
            cursor: pointer;
            color: #fff;
            background-color: #0894ec;
            border: 1px solid #0894ec;
            padding: 6.826px 8.533px;
            padding: 0.42667rem 0.53333rem;
            font-size: 9.557px;
            font-size: 0.59733rem;
            line-height: 9.557px;
            line-height: 0.59733rem;
            border-radius: 0;
        }
        .volun-header > .btn{
            position: relative;
            margin-top: 5.12px;
            margin-top: 0.32rem;
        }
        .bar-tab {
            z-index: 20;
        }
        .bar-tab .tab-item.enroll-btn {
            color: #fff;
            background-color: #0894ec;
        }
    </style>
</head>

<body>
<div class="content" style="padding-bottom: 2.5rem;">
    <div class="volun-header">
        <div class="overlayer" ></div>
        <span class="btn" onclick="handleRegister()">成为志愿者</span>
    </div>
    <div id="container"></div>
</div>
<nav class="bar bar-tab" id="bar-tab">
    <a class="tab-item external enroll-btn" href="/wechatStatic/volunteerList.do">查看更多  →</a>
</nav>

<%@include file="/WEB-INF/why/wechat/static/volunteer/menu.jsp" %>
<script type='text/javascript' src='//g.alicdn.com/sj/lib/zepto/zepto.min.js' charset='utf-8'></script>
<script type='text/javascript' src='//g.alicdn.com/msui/sm/0.6.2/js/sm.min.js' charset='utf-8'></script>
<script type='text/javascript' src='//g.alicdn.com/msui/sm/0.6.2/js/sm-extend.min.js' charset='utf-8'></script>

<script>
    $(document).ready(function(){
        var strList = ''
        $.ajax({
            type: 'get',
            url: '/newVolunteerActivity/queryNewVolunteerActivityListJson.do',
            contentType: 'application/json; charset=utf-8',
            data: {page: 1, rows: 3},
            dataType: 'json',
            before: function(){
                $.showPreloader();
            },
            success: function (res) {
                if(res && res.status === 200){
                    var list = res.volunteerActivityList;
                    $.each(list, function(index, obj){
                        obj.limitNum = obj.limitNum ? obj.limitNum : 0
                        var time = obj.startTime.substr(0, 16) + '至' + obj.endTime.substr(0, 16)
                        var address = obj.address ? obj.address : '';
                        strList += '<div class="card demo-card-header-pic" onclick="goDetail(\''+ obj.uuid +'\')">';
                        strList += '<div valign="bottom" class="card-header color-white no-border no-padding">';
                        strList += '   <img class="card-cover" src="'+ obj.picUrl +'" alt="'+ obj.name +'">';
                        strList += '</div>';
                        strList += '<div class="card-content">';
                        strList += '    <div class="card-content-inner">';
                        strList += '        <p>'+ obj.name +'</p>';
                        if(obj.recruitmentStatus == 1){
                            strList += '    <p class="color-gray">招募'+ obj.limitNum +'人</p>';
                        }else if(obj.recruitmentStatus == 2){
                            strList += '    <p class="color-gray">停止招募</p>';
                        }
                        if(obj.recruitObjectType == '1'){
                            strList += '    <p class="color-gray">招募类型：个人</p>';
                        }else if(obj.recruitObjectType == '2'){
                            strList += '    <p class="color-gray">招募类型：团队</p>';
                        }else if(obj.recruitObjectType == '1,2'){
                            strList += '    <p class="color-gray">招募类型：个人、团队</p>';
                        }
                        strList += '        <p class="color-gray">时间：'+ time +'</p>';
                        strList += '        <p class="color-gray">地址：'+ address +'</p>';
                        strList += '    </div>';
                        strList += '</div>';
                        strList += '</div>';
                    })
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
    });

    function handleRegister(){
        location.href='/wechatStatic/volunteerRegister.do'
    }

    function goDetail(uuid){
        location.href='/wechatStatic/volunteerDetail.do?id=' + uuid
    }
</script>
</body>

</html>
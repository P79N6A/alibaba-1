<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>安康文化云·志愿者注册</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
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
    </style>
</head>

<body>
<form id="form">
    <input type="hidden" id="userId" name="user_id" value="${sessionScope.terminalUser.userId}"/>
    <div class="content" style="padding-bottom: 2.5rem;">
        <div class="buttons-tab">
            <a href="#tab1" class="tab-link active button" data-type="1">个人志愿者</a>
            <a href="#tab1" class="tab-link button" data-type="2">团队志愿者</a>
        </div>
        <div class="tabs">
            <div id="tab1" class="tab active">
                <%--<div class="card">--%>
                    <%--<div class="card-header">志愿者服务方向</div>--%>
                    <%--<div class="card-content">--%>
                        <%--<div class="card-content-inner">--%>
                            <%--<p class="color-gray" style="font-size: .6rem;">注：志愿者招募活动将优先录用服务方向相同的志愿者</p>--%>
                        <%--</div>--%>
                    <%--</div>--%>
                <%--</div>--%>

                <div class="card">
                    <div class="card-header">确认并填写志愿者身份信息</div>
                    <div class="card-content">
                        <div class="list-block">
                            <ul>
                                <li>
                                    <div class="item-content">
                                        <div class="item-inner">
                                            <div class="item-title label" id="labelName">姓名</div>
                                            <div class="item-input">
                                                <input type="text" id="name" name="name" placeholder="请输入姓名">
                                            </div>
                                        </div>
                                    </div>
                                </li>
                                <li>
                                    <div class="item-content">
                                        <div class="item-inner">
                                            <div class="item-title label">手机</div>
                                            <div class="item-input">
                                                <input type="text" id="phone" name="phone" placeholder="请输入手机">
                                            </div>
                                        </div>
                                    </div>
                                </li>
                                <li>
                                    <div class="item-content">
                                        <div class="item-inner">
                                            <div class="item-title label">证件号</div>
                                            <div class="item-input">
                                                <input type="text" id="cardId" name="cardId" placeholder="请输入证件号">
                                            </div>
                                        </div>
                                    </div>
                                </li>
                                <li id="liGroupNum">
                                    <div class="item-content">
                                        <div class="item-inner">
                                            <div class="item-title label">团队人数</div>
                                            <div class="item-input">
                                                <input type="number" id="groupNum" placeholder="请输入团队人数">
                                            </div>
                                        </div>
                                    </div>
                                </li>
                                <%--<li>--%>
                                    <%--<div class="item-content">--%>
                                        <%--<div class="item-inner">--%>
                                            <%--<div class="item-title label">所在区域</div>--%>
                                            <%--<div class="item-input">--%>
                                                <%--<input type="text" id="region" placeholder="请选择区域">--%>
                                            <%--</div>--%>
                                        <%--</div>--%>
                                    <%--</div>--%>
                                <%--</li>--%>
                                <li>
                                    <div class="item-content">
                                        <div class="item-inner">
                                            <div class="item-title label">详细地址</div>
                                            <div class="item-input">
                                                <textarea id="address" name="address" placeholder="请输入详细地址"></textarea>
                                            </div>
                                        </div>
                                    </div>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-content">
                        <div class="list-block">
                            <ul>
                                <li>
                                    <div class="item-content">
                                        <div class="item-inner">
                                            <div class="item-title label">邮箱</div>
                                            <div class="item-input">
                                                <input type="email" id="email" name="email" placeholder="请输入邮箱">
                                            </div>
                                        </div>
                                    </div>
                                </li>
                                <%--<li>--%>
                                    <%--<div class="item-content">--%>
                                        <%--<div class="item-inner">--%>
                                            <%--<div class="item-title label">职业</div>--%>
                                            <%--<div class="item-input">--%>
                                                <%--<input type="text" id="occupation" placeholder="请选择职业">--%>
                                            <%--</div>--%>
                                        <%--</div>--%>
                                    <%--</div>--%>
                                <%--</li>--%>
                                <li>
                                    <div class="item-content">
                                        <div class="item-inner">
                                            <div class="item-title label">最高学历</div>
                                            <div class="item-input">
                                                <input type="text" id="education" placeholder="请选择最高学历">
                                            </div>
                                        </div>
                                    </div>
                                </li>
                                <li>
                                    <div class="item-content">
                                        <div class="item-inner">
                                            <div class="item-title label">政治面貌</div>
                                            <div class="item-input">
                                                <input type="text" id="political" placeholder="请选择政治面貌">
                                            </div>
                                        </div>
                                    </div>
                                </li>
                                <li>
                                    <div class="item-content">
                                        <div class="item-inner">
                                            <div class="item-title label">个人简介</div>
                                            <div class="item-input">
                                                <textarea id="brief" name="brief" placeholder="请输入个人简历"></textarea>
                                            </div>
                                        </div>
                                    </div>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <nav class="bar bar-tab" id="bar-tab">
        <a class="tab-item external enroll-btn" href="#" onclick="handleSubmit()">提交</a>
    </nav>
</form>

<%@include file="/WEB-INF/why/wechat/static/volunteer/menu.jsp" %>

<script>

    $(document).ready(function(){
        var userId = $('#userId').val();
        if(!userId){
            location.href = '/muser/login.do?type= /wechatStatic/volunteerRegister.do';
            return;
        }
        $('#liGroupNum').hide();
        $('.buttons-tab>.tab-link').click(function(e){
            $.showPreloader();
            $('.buttons-tab>.tab-link').removeClass('active');
            $(this).addClass('active');
            if($(this).index() === 1){
                $('#liGroupNum').show();
                $('#labelName').html('团队名称')
            }else{
                $('#liGroupNum').hide();
                $('#labelName').html('姓名')
            }
            $.hidePreloader();
        })
        initDropDownList()
    });

    function initDropDownList(){
        //所属区域
        $("#region").picker({
            toolbarTemplate: '<header class="bar bar-nav">' +
            '<button class="button button-link pull-right close-picker">确定</button>'+
            '<h1 class="title">请选择所属区域</h1>'+
            '</header>',
            cols: [
                {
                    textAlign: 'center',
                    values: ['iPhone 4', 'iPhone 4S', 'iPhone 5', 'iPhone 5S', 'iPhone 6', 'iPhone 6 Plus', 'iPad 2', 'iPad Retina', 'iPad Air', 'iPad mini', 'iPad mini 2', 'iPad mini 3']
                }
            ]
        });
        //职业
//        $("#occupation").picker({
//            toolbarTemplate: '<header class="bar bar-nav">' +
//            '<button class="button button-link pull-right close-picker">确定</button>'+
//            '<h1 class="title">请选择职业</h1>'+
//            '</header>',
//            cols: [
//                {
//                    textAlign: 'center',
//                    values: ['iPhone 4', 'iPhone 4S', 'iPhone 5', 'iPhone 5S', 'iPhone 6', 'iPhone 6 Plus', 'iPad 2', 'iPad Retina', 'iPad Air', 'iPad mini', 'iPad mini 2', 'iPad mini 3']
//                }
//            ]
//        });
        //最高学历
        $("#education").picker({
            toolbarTemplate: '<header class="bar bar-nav">' +
            '<button class="button button-link pull-right close-picker">确定</button>'+
            '<h1 class="title">请选择最高学历</h1>'+
            '</header>',
            cols: [
                {
                    textAlign: 'center',
                    values: ['高中', '大专', '本科', '硕士及以上']
                }
            ]
        });
        //政治面貌
        $("#political").picker({
            toolbarTemplate: '<header class="bar bar-nav">' +
            '<button class="button button-link pull-right close-picker">确定</button>'+
            '<h1 class="title">请选择政治面貌</h1>'+
            '</header>',
            cols: [
                {
                    textAlign: 'center',
                    values: ['党员', '团员']
                }
            ]
        });

    }

    function handleSubmit(){
        var userId = $('#userId').val();
        if(!userId){
            location.href = '/muser/login.do?type=/wechatStatic/volunteerRegister.do';
            return;
        }
        //----志愿者类型 1，个人 2.团队
        var type = $('.buttons-tab>.tab-link.active').attr('data-type');
        $('#hidType').val(type);
        var educationName = $("#education").val();
        var education = '';
        switch (educationName){
            case '高中':
                education = 1;
                break;
            case '大专':
                education = 2;
                break;
            case '本科':
                education = 3;
                break;
            case '硕士及以上':
                education = 4;
                break;
        }
        var politicalName = $("#political").val();
        var political = '';
        switch (politicalName){
            case '党员':
                political = 1;
                break;
            case '团员':
                political = 2;
                break;
        }
        var post = {
            "userId": userId,
            "name":$('#name').val(),
            "type": type,
            "status": 1, //1 未审核，2正常，3.驳回，9删除
            "cardId": $('#cardId').val(),//----身份证，必填
            "phone": $('#phone').val(), //----必填
            "email": $('#email').val(),
//            region: undefined,  //---必填，省市区等id拼接以，隔开
            "address": $('#address').val(),
//            occupation: undefined,
            "brief": $('#brief').val(),
            "education": education,  //----学历  高中:1,大专:2,本科:3,博士及以上:4
            "political": political //政治面貌 1.党员 2.团员
        }
        if($.trim(post.name).length <= 0){
            if(post.type == 1){
                $.toast('请输入姓名');
            }else if(post.type == 2){
                $.toast('团队名称');
            }
            return;
        }
        if($.trim(post.phone).length <= 0){
            $.toast('请输入手机');
            return;
        }
        if($.trim(post.cardId).length <= 0){
            $.toast('请输入证件号');
            return;
        }
        $.ajax({
            contentType:"application/json",
            type: "post",
            url: "${path}/newVolunteer/addNewVolunteer.do",
            data: JSON.stringify(post),
            async: false,
            dataType:"json",
            beforeSend: function(){
                $.showPreloader();
            },
            success: function (res) {
                if(res && res === 'success'){
                    $.toast('提交成功');
//                    setTimeout(function(){
//                        location.href = '/wechatStatic/volunteer.do';
//                    }, 2000);
                } else if(res === 'volunteer Already exists' || res === 'exist'){
                    var typeName = post.type == 1 ? '个人志愿者' : '团队志愿者';
                    $.toast('您已经是' + typeName + '请勿重复注册');
                }else{
                    $.toast('提交失败');
                }
            },
            error: function (err) {
                $.toast('提交失败');
            },
            complete: function(){
                $.hidePreloader();
            }
        });
    }
</script>
</body>

</html>
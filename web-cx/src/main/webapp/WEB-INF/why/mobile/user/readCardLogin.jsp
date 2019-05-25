<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head lang="en">
    <title>登录</title>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp" %>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css">
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/normalize.css">
    <script type="text/javascript" src="${path}/STATIC/js/avalon.js"></script>
    <script type="text/javascript">
        var mobileNo = "";	//动态登录手机号

        var useAddress ="";
        var userCardNo ="";
        var userName ="";
        var userPwd ="";
        var userBirth ="";
        var readerCard ="";


        if (userId != null && userId != '') {
            if ('${type}') {
                if ('${type}'.indexOf("?") != -1) {
                    window.location.href = "${type}&userId=" + userId;
                } else {
                    window.location.href = "${type}?userId=" + userId;
                }
            } else {
                window.location.href = '${path}/wechat/index.do';
            }
        }


        function userLogin() {
            console.log("login");
            $.ajax({
                type: "POST",
                url: '${path}/frontTerminalUser/terminalLogin.do?' + new Date().getTime(),
                data: {
                    userName:mobileNo,
                    userPwd:userPwd
                },
                dataType: "json",
                success: function (data) {
                    var c = eval(data);
                    console.log(c.status);
                    if (c.status == "success") {
                        var type = '${type}';
                        if (type) {
                            if (type.indexOf("?") != -1) {
                                window.location.href = type + "&userId=" + c.user.userId;
                            } else {
                                window.location.href = type + "?userId=" + c.user.userId;
                            }
                        }
                        else {
                            window.location.href = '${path}/wechat/index.do';
                        }
                    } else {
                        if (c.status == "noActive") {
                            $("#userName").focus();
                            $("#loginTips").html("账号未完成注册，请重新注册")
                        } else {
                            if (c.status == "isFreeze") {
                                $("#loginTips").html("账号已冻结");
                            } else if (c.status == "LoginLimit") {
                                $("#loginTips").html("密码输错次数过多,请明天再试");
                            } else {
                                $("#loginTips").html("账号和密码不匹配，请重新输入");
                            }
                        }
                    }
                },
                error: function () {
                }
            });
        }

        function toRegister() {
            if ('${type}') {
                window.location.href = '${path}/muser/register.do?type=${type}';
            } else {
                window.location.href = '${path}/muser/register.do';
            }
        }

        function toForget() {
            if ('${type}') {
                window.location.href = '${path}/muser/forget.do?type=${type}';
            } else {
                window.location.href = '${path}/muser/forget.do';
            }
        }

        $(function () {
            $('.logintitUl li').bind('click', function () {
                $('.logintitUl li').removeClass('current');
                $(this).addClass('current');
                $('.login-account-hide .login-account-wc').hide();
                $('.login-account-hide .login-account-wc').eq($(this).index()).show();
            });
        });

        //发送验证码
        function sendSms() {
            $("#loginTips").html("")
            $("#smsCodeBut").attr("onclick", "");
            mobileNo = $("#mobileNo").val();
            var telReg = (/^1[34578]\d{9}$/);
            if (mobileNo == "") {
                $("#loginTips").html("请输入手机号！");
                $("#smsCodeBut").attr("onclick", "sendSms();");
                return false;
            } else if (!mobileNo.match(telReg)) {
                $("#loginTips").html("请正确填写手机号！");
                $("#smsCodeBut").attr("onclick", "sendSms();");
                return false;
            }
            $.post("${path}/muser/loginSendCode.do", {mobileNo: mobileNo}, function (data) {
                if (data.status == 1) {
                    var s = 60;
                    $("#smsCodeBut").html(s + "秒后重新获取");
                    var ss = setInterval(function () {
                        s -= 1;
                        $("#smsCodeBut").html(s + "秒后重新获取");
                        if (s == 0) {
                            clearInterval(ss);
                            $("#smsCodeBut").attr("onclick", "sendSms();");
                            $("#smsCodeBut").html("获取验证码");
                        }
                    }, 1000);
                } else {
                    $("#smsCodeBut").attr("onclick", "sendSms();");
                }
            }, "json");
        }

        //验证码登录
        function userCodeLogin() {
            $("#codeLoginBtn").attr("onclick", "");
            if (mobileNo != $("#mobileNo").val()) {
                dataForm.mobileNoErr = "手机号错误，请重新发送验证码！";
                $("#codeLoginBtn").attr("onclick", "userCodeLogin();");
                return false;
            } else {
                dataForm.mobileNoErr = "";
            }
            var code = $("#loginCode").val();
            if (!code) {
                dataForm.codeErr = "请输入验证码";
                $("#codeLoginBtn").attr("onclick", "userCodeLogin();");
                return false;
            } else if (code.length != 6) {
                dataForm.codeErr = "验证码长度有误";
                $("#codeLoginBtn").attr("onclick", "userCodeLogin();");
                return false;
            } else {
                dataForm.codeErr = "";
            }
            $.post("${path}/muser/codeLogin.do", {
                mobileNo: mobileNo,
                code: code,
                callback: '${type}'
            }, function (data) {
                if (data.status == 1) {
                    if (data.data.status == "success") {
                        var type = '${type}';
                        if (type) {
                            if (type.indexOf("?") != -1) {
                                window.location.href = type + "&userId=" + data.data.userId;
                            } else {
                                window.location.href = type + "?userId=" + data.data.userId;
                            }
                        } else {
                            window.location.href = '${path}/wechat/index.do';
                        }
                    } else {
                        $("#codeLoginBtn").attr("onclick", "userCodeLogin();");
                        dataForm.codeErr = data.data.errorMsg;
                    }
                } else {
                    $("#codeLoginBtn").attr("onclick", "userCodeLogin();");
                    dataForm.codeErr = "响应失败！";
                }
            }, "json");
        }


        function login(){
            var identifier = $("input[name='identifier']").val();
            var password = $("input[name='password']").val();
            if(!identifier){
                $("#loginTips").html("请输入读者证号！");
                return;
            }
            if(!password){
                $("#loginTips").html("请输入密码！");
                return;
            }
            $("#loginTips").html('');
            $.post("${path}/muser/checkReadCardLogin.do", {identifier: identifier,password:password},
                function (data) {
                    data = JSON.parse(data);
                    if (data.status == 10001) {
                        $("#loginTips").html("账号或密码输入有误！");
                    } else {
                        useAddress =data.data.useAddress;
                        userCardNo =data.data.userCardNo;
                        userName =data.data.userName;
                        userPwd =data.data.userPwd;
                        userBirth =data.data.userBirth;
                        readerCard =data.data.readerCard;
                        if(data.status==200){
                            mobileNo = data.data.userMobileNo;
                            userLogin();
                        }else{
                            $(".btn").attr("onclick","register()");
                            $("#mobileNo").val(data.data.userMobileNo);
                            $("#firstLogin").show();
                        }
                    }
                }, "json");
        }
        
        function register() {
            $("#codeLoginBtn").attr("onclick", "");
            if (mobileNo != $("#mobileNo").val()) {
                $("#loginTips").html("请获取验证码！");
                $("#codeLoginBtn").attr("onclick", "register();");
                return false;
            }
            var code = $("#loginCode").val();
            if (!code) {
                $("#loginTips").html("请输入验证码");
                $("#codeLoginBtn").attr("onclick", "register();");
                return false;
            } else if (code.length != 6) {
                $("#loginTips").html("验证码长度有误");
                $("#codeLoginBtn").attr("onclick", "register();");
                return false;
            }
            $.post("${path}/muser/readerCardRegister.do", {
                userMobileNo: mobileNo,
                useAddress: useAddress,
                userCardNo: userCardNo,
                userName: userName,
                userBirthStr: userBirth,
                readerCard: readerCard,
                userPwd: userPwd,
                code: code,
                callback: '${type}'
            }, function (data) {
                if(data == "success"){
                    $("#loginTips").html("")
                    userLogin();
                }else{
                    $("#codeLoginBtn").attr("onclick", "register()");
                    if (data == "codeOvertime") {
                        $("#loginTips").html("验证码已过期，请重新索取！")
                    } else if(data == "codeError"){
                        $("#loginTips").html("验证码不正确！")
                    }else if(data == "mobileRepeat"){
                        $("#loginTips").html("手机号已存在！")
                    }else if(data == "cardNoRepeat"){
                        $("#loginTips").html("身份证号已存在！")
                    }else{
                        $("#loginTips").html("响应失败！")
                    }
                }
            }, "json");
        }
    </script>


    <style>
        html,
        body {
            height: 100%;
            width: 100%;
        }

        .inputDiv {
            border-bottom: 1px solid #e2e2e2;
            margin: 0 35px;
            height: 110px;
        }

        .inputDiv label {
            font-size: 28px;
            color: #333333;
            line-height: 110px;
        }

        .inputDiv input {
            width: 500px;
            font-size: 28px;
            height: 40px;
            line-height: 40px;
            border: none;
            margin-left: 30px;
            color: #333333;
        }

        .btn {
            margin: 100px auto 0;
            width: 610px;
            height: 88px;
            border-radius: 5px;
            background-color: #734631;
            color: #fff;
            font-size: 30px;
            line-height: 88px;
            text-align: center;
        }

        .code {
            margin-top: 22px;
            float: right;
            height: 66px;
            width: 254px;
            background-color: #eaeaea;
            color: #000000;
            font-size: 32px;
            line-height: 66px;
            text-align: center;
            border-radius: 5px;
        }
    </style>

<body>
<div class="logo" style="padding-top: 130px;">
    <img src="${path}/STATIC/image/tushuguan_logo.png" style="display: block;margin: auto;"/>
</div>
<div style="margin-top: 100px;">

    <!--读者证-->
    <div>
        <div class="inputDiv">
            <label>读者证</label>
            <input type="tel" maxlength="18" placeholder="请输入读者证号" name="identifier" value=""/>
        </div>
        <div class="inputDiv">
            <label>密&emsp;码</label>
            <input type="password" placeholder="6-20位字母、数字和符号" maxlength="20" name="password" value=""/>
        </div>
    </div>
    <!--手机验证-->
    <div id="firstLogin" style="display: none;">
        <p style="color: #734631;font-size: 32px;text-align: center;margin-bottom: 50px;" id="tps">读者证用户首次登录需进行手机号验证</p>
        <div class="inputDiv">
            <label>手机号</label>
            <input type="tel" maxlength="11" placeholder="请输入手机号" id="mobileNo"/>
        </div>
        <div class="inputDiv clearfix">
            <label>验证码</label>
            <input type="text" id="loginCode" placeholder="请输入验证码" style="width: 290px;"/>
            <div class="code" id="smsCodeBut" onclick="sendSms();">获取验证码</div>
        </div>
    </div>
</div>
<p style="color: #734631;font-size: 32px;text-align: center;" id="loginTips"></p>
<div class="btn" id="codeLoginBtn" onclick="login()">确认登录</div>
</body>
</html>
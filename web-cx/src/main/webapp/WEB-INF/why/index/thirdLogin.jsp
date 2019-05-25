<%@ page import="com.sun3d.why.model.CmsTerminalUser" %>
<%@ page language="java"  pageEncoding="UTF-8"%>
<html xmlns:wb="http://open.weibo.com/wb">
<c:if test="${empty sessionScope.terminalUser}">
    <script type="text/javascript" src="http://qzonestyle.gtimg.cn/qzone/openapi/qc_loader.js" data-appid="101229091" data-callback="true" charset="utf-8"></script>
    <script src="http://tjs.sjs.sinajs.cn/open/api/js/wb.js?appkey=3103565176" type="text/javascript" charset="utf-8"></script>
</c:if>
<script type="text/javascript">

    function myQQLogin(){
        $("#qqLoginBtn a").click();
    }
    function myWBLogin(){
        $("#wb_connect_btn").click();
    }


if(""=='${sessionScope.terminalUser}'||"null"=='${sessionScope.terminalUser}'){
        QC.Login({
            btnId:"qqLoginBtn"
        }, function(reqData, opts){
            //登录成功
            /*           var dom = document.getElementById(opts['btnId']),
             _logoutTemplate=[

             '<span><img src="{figureurl}" class="{size_key}"/></span>',

             '<span>{nickname}</span>',

             '<span><a href="javascript:QC.Login.signOut();">退出</a></span>'
             ].join("");
             dom && (dom.innerHTML = QC.String.format(_logoutTemplate, {
             nickname : QC.String.escHTML(reqData.nickname), //做xss过滤
             figureurl : reqData.figureurl
             })
             );
             */
            $("#otherUserImg").val(reqData.figureurl);
            //登陆成功 获取用户opendId
            if(QC.Login.check()) {
                QC.Login.getMe(function (openId, accessToken) {
                    //是否存在该用户
                    $.ajax({
                        type: "POST",
                        url: "${path}/frontTerminalUser/getOpenUser.do",
                        data: {
                            openId: openId
                        },
                        dataType: "json",
                        success: function (data) {
                            if(data.code==404){
                                var userBirthStr = "";
                                var userSex = "";
                                var  paras={};
                                QC.api("get_info",paras)
                                        .success(function(s){//成功回调
                                            userBirthStr= s.data.data.birth_year+"-"+s.data.data.birth_month+"-"+s.data.data.birth_day;
                                            userSex=s.data.data.sex;
                                        })
                                        .error(function(f){
                                            return;
                                        })
                                        .complete(function(c){//完成请求回调 正确获取信息后
                                            $.ajax({
                                                type: "POST",
                                                url: "${path}/frontTerminalUser/saveThirdUser.do",
                                                data:{
                                                    type:2,
                                                    userHeadImgUrl:reqData.figureurl_qq_1,
                                                    userNickName:QC.String.escHTML(reqData.nickname),
                                                    operId: openId,
                                                    accessToken:accessToken,
                                                    headImgUrl:reqData.figureurl,
                                                    userSex:userSex,
                                                    userBirthStr:userBirthStr
                                                },
                                                dataType: "json",
                                                success: function (saveData) {
                                                    if(saveData.code==200){
                                                        location.href="${path}/frontTerminalUser/completeInfo.do?userId="+saveData.userId;
                                                    }
                                                }
                                            });
                                        });
                            }else if(data.code==200){
                                $.ajax({
                                    type: "POST",
                                    url: "${path}/frontTerminalUser/setUserSession.do",
                                    data: {
                                        openId:openId
                                    },
                                    dataType: "json",
                                    success: function (datas) {
                                        window.location.reload(true);
                                    }
                                });
                            }else if(data.code==500){
                                //openId查询异常 避免重复注册 不做任何操作
                            }

                        }
                    });
                })
            }
        }, function(opts){
        });

        WB2.anyWhere(function (W) {
                    W.widget.connectButton({
                        id: "wb_connect_btn",
                        type: '2,2',
                        callback: {
                            login: function (o) {
                                if(WB2.checkLogin()){
                                    if(o.id!=""){
                                        $.ajax({
                                            type: "POST",
                                            url: "${path}/frontTerminalUser/getOpenUser.do",
                                            data: {
                                                openId: o.id
                                            },
                                            dataType: "json",
                                            success: function (data) {
                                                if (data.code==404) {
                                                    var userSex = 1;
                                                    if(o.gender=="m"){
                                                        userSex=1;
                                                    }else if(o.gender=="f"){
                                                        userSex=2;
                                                    }
                                                    $.ajax({
                                                        type: "POST",
                                                        url: "${path}/frontTerminalUser/saveThirdUser.do",
                                                        data:{
                                                            type:3,
                                                            userHeadImgUrl: o.avatar_hd,
                                                            userNickName:o.screen_name,
                                                            operId: o.id,
                                                            userSex:userSex
                                                        },
                                                        dataType: "json",
                                                        success: function (saveData) {
                                                            if(saveData.code==200){
                                                                location.href="${path}/frontTerminalUser/completeInfo.do?userId="+saveData.userId;
                                                            }else if(saveData.code==502){
                                                                dialogAlert("同Ip操作频繁！");
                                                            }
                                                        }
                                                    });
                                                }else if(data.code==200){
                                                    //已注册
                                                    $.ajax({
                                                        type: "POST",
                                                        url: "${path}/frontTerminalUser/setUserSession.do",
                                                        data: {
                                                            openId: o.id
                                                        },
                                                        dataType: "json",
                                                        success: function (datas) {
                                                            window.location.reload(true);
                                                        }
                                                    });
                                                }else if(data.code==500){
                                                    //openId查询异常 避免重复注册 不做任何操作
                                                }

                                            }
                                        });
                                    }
                                }
                                //回调结束
                            },
                            logout: function () {

                            }
                        }
                    });

                });

    }

function myLogOut (){

    $.getScript("http://tjs.sjs.sinajs.cn/open/api/js/wb.js?appkey=3103565176",function(){

        if(QC.Login.check()){
            QC.Login.signOut();
        }

        if(WB2.checkLogin()){
            WB2.logout(function(){
                window.location.reload(true);
            });
        }else{
            window.location.reload(true);
        }
    });


    }
$(function(){
        $("#logout").click(function(){
            myLogOut();
        });
});
function outLogin(){
        var user = '${sessionScope.terminalUser}';
        if(""!=user){
            $.post("${path}/frontTerminalUser/outLogin.do",function(result){
                if(result=="success"){
                    $.getScript("http://qzonestyle.gtimg.cn/qzone/openapi/qc_loader.js",function(){
/*                        if(QC.Login.check()){
                            QC.Login.signOut();
                        }*/
                    });
                    $("#logout").click();
                }else{
                    $.getScript("http://qzonestyle.gtimg.cn/qzone/openapi/qc_loader.js",function(){
/*                        if(QC.Login.check()){
                            QC.Login.signOut();
                        }*/
                    });
                    $("#logout").click();
                }

            });
        }
    }
</script>
</html>

<%@ page import="com.sun3d.why.model.CmsTerminalUser" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>个人中心-账号设置--佛山文化云</title>
    <%@include file="/WEB-INF/why/common/frontPageFrame.jsp"%>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture-user.css" />
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/hsCulture.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/birthday.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/jquery.uploadify-3.1.min.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/index/userCenter/userInfo.js"></script>
    <script type="text/javascript">
        $(function(){
            $(".editInfo").on("blur input propertychange",'.input-text', function(){
                if($(this).val() == ''){
                    $(this).parent().addClass("showPlaceholder");
                }else{
                    $(this).parent().removeClass("showPlaceholder");
                }
            });
            $(".placeholder").on({
                click:function(){ $(this).parent().find(".input-text").focus();},
                dblclick:function(){ $(this).parent().find(".input-text").focus();}
            });
            /*IE8 IE7 IE6*/
            var userAgent=window.navigator.userAgent.toLowerCase();
            var msie = /msie/.test(userAgent);
            var msie8 = /msie 8\.0/i.test(userAgent);
            var msie7 = /msie 7\.0/i.test(userAgent);
            var msie6 = /msie 6\.0/i.test(userAgent);
            if(msie && (msie8 || msie7 || msie6)){
                $(".editInfo").on("focus",'.input-text', function(){
                    $(this).parent().removeClass("showPlaceholder");
                })
            }
            //修改资料显示头像
            $('#userInfo').addClass('cur').siblings().removeClass('cur');
            var imgUrl= '${user.userHeadImgUrl}';
            var sourceCode = '${user.sourceCode}';
            if(imgUrl!="" && imgUrl.indexOf("http")==-1){
                $("#imgHeadPrev").html("<img width='120'  src='"+getIndexImgUrl(getImgUrl(imgUrl),"_300_300")+"'>");
            }else if(imgUrl.indexOf("http")!=-1){
                $("#imgHeadPrev").html("<img  src='"+imgUrl+"'>");
            }else{
                var this_sex = '${sessionScope.terminalUser.userSex}';
                if(this_sex==1){
                    $("#imgHeadPrev").html("<img  src='../STATIC/image/face_boy.png'>");
                }else if(this_sex==2){
                    $("#imgHeadPrev").html("<img  src='../STATIC/image/face_girl.png'>");
                }else{
                    $("#imgHeadPrev").html("<img  src='../STATIC/image/face_boy.png'>");
                }
            }
            $("#modMobile").on("click", function(){
                $("#mobileDiv").toggle();
                if($("#mobileDiv").is(':visible')){
                    $("#userMobileNo").focus();
                }
                //$("#userMobileNo").focus();
            });
            $("#modEmail").on("click", function(){
                $("#emailDiv").toggle();
                if($("#emailDiv").is(':visible')){
                    $("#userEmail").focus();
                }
                //$("#userEmail").focus();
            });

        });

        var timeOut = 60;
        function smsTimer () {
            if (timeOut <= 0) {
                $("#codeErr").removeClass("error-msg").html("");
                $("#sendCode").prop("disabled",false);
                $("#sendCode").val("获取验证码");
                timeOut = 60;
            } else {
                $("#sendCode").val(timeOut+"秒后重新获取");
                timeOut--;
                setTimeout(function () {
                    smsTimer();
                }, 1000);
            }
        }

        //发送验证
        function sendSmsCode(){
            if(!valUserInfo()){
                 return;
            }
            //是否该变了号码
            var userMobileNo = $("#userMobileNo").val();
            var oldMobile = $("#valMobile").val();

/*            if(oldMobile.substring(3,8)==userMobileNo.substring(3,8)){
                $("#mobileDiv").show();
                addErrMsg("userMobileNoErr","手机号码未更换,无需发送验证码");
                return;
            }*/

            if(oldMobile==userMobileNo) {
                $("#mobileDiv").show();
                addErrMsg("userMobileNoErr", "手机号码未更换,无需发送验证码");
                return;
            }
            setBtnDis("sendCode",true);
            var userMobileNo = $("#userMobileNo").val();

            $.ajax({
                type: "POST",
                data:{
                    userMobileNo:userMobileNo
                },
                url: "${path}/frontTerminalUser/updateSendCode.do?"+new Date().getTime(),
                dataType: "json",
                success: function (data) {
                    if(data == "success") {
                        smsTimer();
                    }else if(data == "mobileRepeat"){
                        addErrMsg("userMobileNoErr","该手机号码已经注册过!");
                        $("#userMobileNo").focus();
                    }else if(data=="third"){
                        addErrMsg("codeErr","已发送三次,请明天再试!");
                    }else if(data==="timeOut"){
                        dialogAlert("提示","登录超时");
                        setTimeout(function(){
                            window.location.href="${path}/frontTerminalUser/userLogin.do";
                        },1500);
                        //$("#codeErr").addClass("error-msg").html("短信验证码发送失败,请重试!");
                        //addErrMsg("codeErr","短信验证码发送失败,请重试!");
                        //setBtnDis("sendCode",false);
                    }
               },
               error:function(){
                   //addErrMsg("codeErr","短信验证码发送失败,请重试!");
                   //setBtnDis("sendCode",false);
               }

            });
        }
        //修改
        function modifyUserInfo(){
            var noVal=$("#noVal").val();
            if(noVal){
                var uYear= $("#uYear").val();
                var uMonth=$("#uMonth").val();
                var uDay =$("#uDay").val();
                if(uMonth!="1900" && uMonth!="1900" && uDay!="1900"){
                    $("#userBirth").val(uYear+"-"+uMonth+"-"+uDay);
                }

                $.post("${path}/frontTerminalUser/editTerminalUser.do?asm="+new Date().getTime(), $("#userForm").serialize(), function(
                        datas) {
                    if (datas == "success") {
                        dialogAlert("提示","保存成功!");
                        setTimeout(function(){
                            window.location.reload(true);
                        },1000);
                    }else if(datas == "SmsCodeErr"){
                        addErrMsg("codeErr","短信验证码错误,请重新输入");
                        setBtnDis("btnUpdate",false);
                        $("#code").focus();
                    } else if(datas == "mobileRepeat"){
                        addErrMsg("userMobileNoErr","手机号码已存在!");
                        setBtnDis("btnUpdate",false);
                        $("#userMobileNo").focus();
                    } else {
                        dialogAlert("提示","保存失败!");
                    }
                });
                return;
            }


            if(!valUserInfo()){
                return;
            }
           var oldMobile = $("#valMobile").val();
           var userMobileNo = $("#userMobileNo").val();


           if(oldMobile!=userMobileNo){
               var code=$("#code").val();
               if($.trim(code)==""){
                   addErrMsg("codeErr","请输入短信验证码!");
                   $("#code").focus();
                   return;
               }else{
                   rmErrMsg("codeErr");
               }
           }
           setBtnDis("btnUpdate",true);
           /* $.ajax({
                type: "POST",
                data:{
                    userName:'${user.userName}',
                    userPwd:oldPass
                },
                url: "${path}/frontTerminalUser/terminalLogin.do",
                dataType: "text",
                success: function (data) {
                    if(data == "success") {
           */

           $.post("${path}/frontTerminalUser/editTerminalUser.do?asm="+new Date().getTime(), $("#userForm").serialize(), function(
                                datas) {
                            if (datas == "success") {
                                dialogAlert("提示","保存成功!");
                                setTimeout(function(){
                                    window.location.reload(true);
                                },1000);
                            }else if(datas == "SmsCodeErr"){
                                addErrMsg("codeErr","短信验证码错误,请重新输入");
                                setBtnDis("btnUpdate",false);
                                $("#code").focus();
                            } else if(datas == "mobileRepeat"){
                                addErrMsg("userMobileNoErr","手机号码已存在!");
                                setBtnDis("btnUpdate",false);
                                $("#userMobileNo").focus();
                            }else if(datas=="timeOut"){
                                dialogAlert("提示","登录超时");
                                setTimeout(function(){
                                    window.location.href="${path}/frontTerminalUser/userLogin.do";
                                },1500);
                            } else {
                                dialogAlert("提示","保存失败!");
                            }
            });

            //$("#btnUpdate").prop("disabled",false);
        }

    </script>
</head>
<body>
<div class="header">
	<%@include file="../header.jsp" %>
</div>

<div id="register-content">
<div class="crumb">您所在的位置： <a href="#">个人主页</a> &gt;<a href="#">账号设置</a></div>
<div class="activity-content user-content clearfix">
<%@include file="user_center_left.jsp"%>

    <div class="user-right fr">
        <div class="setting-content">
            <h1>账号设置</h1>
            <form action="" id="userForm">
                <dl class="photo">
                    <dt>头像</dt>
                    <dd>
                    <input type="hidden"  name="userHeadImgUrl" id="headImgUrl" value="${user.userHeadImgUrl}">
                    <input type="hidden" name="uploadType" value="Img" id="uploadType"/>
                    <div id="imgHeadPrev" style="width:120px; height:120px;position: relative; overflow: hidden;  float: left;"></div>
                    <div class="upload-box fl">
                    <%--<div  class="upload-photo">--%>
                        <input type="file" name="file" id="file">
                        <div id="fileContainer" style="display: none;"></div>
                        <div id="btnContainer" style="display: none;"></div>
                    <%--</div>--%>
                    </div>
                    </dd>
                    <div class="clear"></div>
                </dl>
                <dl class="userName">
                    <dt>昵称</dt>
                    <dd><input id="userName" type="text" class="input-text" name="userName"
                                value="${user.userName}" />
                        <span id="userNameErr"></span></dd>
                </dl>
                <dl class="userSex">
                    <dt>性别</dt>
                    <dd>
                        <label><input type="radio" name="userSex" value="1" <c:if test="${user.userSex==1}">checked="checked" </c:if> />男</label>
                        <label><input type="radio" name="userSex" value="2" <c:if test="${user.userSex==2}">checked="checked" </c:if>/>女</label>
                    </dd>
                </dl>
                <dl class="userBirthday">
                    <dt>生日</dt>
                    <dd>
                 <c:choose>
                  <c:when test="${not empty user.userBirthStr}" >
                        <select class="sel_year" id="uYear" rel="${fn:substring(user.userBirthStr,0,4)}"></select>年
                        <select class="sel_month" id="uMonth" rel="${fn:substring(user.userBirthStr,5,7)}"></select>月
                        <select class="sel_day" id="uDay" rel="${fn:substring(user.userBirthStr,8,10)}"></select>日
                    </c:when>
                     <c:otherwise>
                         <select class="sel_year" id="uYear" ></select>年
                         <select class="sel_month" id="uMonth"></select>月
                         <select class="sel_day" id="uDay"></select>日
                     </c:otherwise>
                 </c:choose>
                    </dd>
                </dl>

                <c:choose>
                    <c:when test="${not empty user.userMobileNo}">
                        <input type="hidden" value="${user.userMobileNo}" id="valMobile" />
                        <dl class="userMobile editInfo">
                            <dt>绑定手机</dt>
                            <dd>
                                <div class="phone-num">
                            <span>
                                <c:choose>
                                    <c:when test="${not empty user.userMobileNo}">${user.userMobileNo}</c:when>
                                    <c:otherwise>${user.userTelephone}</c:otherwise>
                                </c:choose>
                            </span>
                                    <a href="javascript:;" class="edit-phone" id="modMobile">
                                        <c:choose>
                                            <c:when test="${empty user.userMobileNo}">绑定手机</c:when>
                                            <c:otherwise>修改手机</c:otherwise>
                                        </c:choose>
                                    </a>
                                </div>

                                <div class="edit-box"  style="display: none;" id="mobileDiv">
                                    <div class="mt20">
                                        <input type="text" class="input-text" id="userMobileNo" name="userMobileNo"
                                                <c:choose>
                                                    <c:when test="${not empty user.userMobileNo}">value="${user.userMobileNo}"</c:when>
                                                    <c:otherwise>value="${user.userTelephone}"</c:otherwise>
                                                </c:choose>
                                               maxlength="11"
                                               onkeyup="if(this.value!=this.value.replace(/\D/g,'')) this.value=this.value.replace(/\D/g,'')"
                                               onafterpaste="this.value=this.value.replace(/\D/g,'')"
                                               onblur="this.value=this.value.replace(/\D/g,'')" />
                                        <label class="placeholder">输入新手机号码</label>
                                        <span id="userMobileNoErr"></span>
                                    </div>
                                    <div class="code showPlaceholder">
                                        <input type="text" class="input-text code-text" name="registerCode" id="code" maxlength="6"
                                               onkeyup="if(this.value!=this.value.replace(/\D/g,'')) this.value=this.value.replace(/\D/g,'')"
                                               onafterpaste="this.value=this.value.replace(/\D/g,'')"
                                               onblur="this.value=this.value.replace(/\D/g,'')" />
                                        <label class="placeholder">输入验证码</label>
                                        <input type="button" class="send-code" id="sendCode"  onclick="sendSmsCode()"  value="获取验证码"/>

                                        <span id="codeErr"></span>
                                    </div>
                                </div>
                            </dd>
                        </dl>
                    </c:when>

                    <c:when test="${not empty user.operId && not empty user.userTelephone}">
                        <input type="hidden" value="${user.userTelephone}" id="valMobile" />
                        <dl class="userMobile editInfo">
                            <dt>绑定手机</dt>
                            <dd>
                                <div class="phone-num">
                            <span>${user.userTelephone}</span>
<%--                                    <a href="javascript:;" class="edit-phone" id="modMobile">
                                        <c:choose>
                                            <c:when test="${empty user.userMobileNo}">绑定手机</c:when>
                                            <c:otherwise>修改手机</c:otherwise>
                                        </c:choose>
                                    </a>--%>
                                </div>
                            <input type="hidden"  id="userMobileNo"  name="userMobileNo"  value="${user.userTelephone}" />
<%--                                <div class="edit-box"  style="display: none;" id="mobileDiv">
                                    <div class="mt20">
                                        <input type="text" class="input-text" id="userMobileNo" name="userMobileNo"
                                                <c:choose>
                                                    <c:when test="${not empty user.userMobileNo}">value="${user.userMobileNo}"</c:when>
                                                    <c:otherwise>value="${user.userTelephone}"</c:otherwise>
                                                </c:choose>
                                               maxlength="11"
                                               onkeyup="if(this.value!=this.value.replace(/\D/g,'')) this.value=this.value.replace(/\D/g,'')"
                                               onafterpaste="this.value=this.value.replace(/\D/g,'')"
                                               onblur="this.value=this.value.replace(/\D/g,'')" />
                                        <label class="placeholder">输入新手机号码</label>
                                        <span id="userMobileNoErr"></span>
                                    </div>
                                    <div class="code showPlaceholder">
                                        <input type="text" class="input-text code-text" name="registerCode" id="code" maxlength="6"
                                               onkeyup="if(this.value!=this.value.replace(/\D/g,'')) this.value=this.value.replace(/\D/g,'')"
                                               onafterpaste="this.value=this.value.replace(/\D/g,'')"
                                               onblur="this.value=this.value.replace(/\D/g,'')" />
                                        <label class="placeholder">输入验证码</label>
                                        <input type="button" class="send-code" id="sendCode"  onclick="sendSmsCode()"  value="获取验证码"/>

                                        <span id="codeErr"></span>
                                    </div>
                                </div>--%>
                            </dd>
                        </dl>
                    </c:when>

                    <c:otherwise>
                        <input type="hidden" value="1" id="noVal" />
                    </c:otherwise>
                </c:choose>




                <dl class="userEmail editInfo">
                    <dt>绑定邮箱</dt>
                    <dd>

                        <div class="phone-num">
                            <span>${user.userEmail}</span>
                            <a href="javascript:;" class="edit-phone" id="modEmail">
                                <c:choose>
                                    <c:when test="${empty user.userEmail}">绑定邮箱</c:when>
                                    <c:otherwise>修改邮箱</c:otherwise>
                                </c:choose>
                                <label class="placeholder">输入邮箱地址</label>
                            </a>
                        </div>

                        <div style="display: none;" id="emailDiv">

                            <div class="showPlaceholder">
                                <div class="mt20 showPlaceholder">
                                    <input type="text" class="input-text"  id="userEmail" name="userEmail" value="${user.userEmail}" maxlength="20" />
                                    <span id="userEmailErr"></span>
                                </div>
                            </div>

                        </div>

                    </dd>
                </dl>
                <input type="hidden" id="userBirth" name="userBirthStr" value="${user.userBirthStr}"  >
                <input type="button" class="save-edit" value="保存修改" onclick="modifyUserInfo()" id="btnUpdate" />
            </form>
        </div>
    </div>
    </div>
    </div>

<script type="text/javascript">
    //图片上传
    $(function () {
        var Img=$("#uploadType").val();
        var userMobileNo="${sessionScope.terminalUser.userMobileNo}";
        if(!userMobileNo){
            userMobileNo="${sessionScope.terminalUser.userTelephone}";
            if(!userMobileNo){
                userMobileNo="15000000000";
            }
        }
        $("#file").uploadify({
            'formData':{
                'uploadType':Img,
                'type':10,
                'userMobileNo':userMobileNo
            },//传静态参数
            swf:'../STATIC/js/uploadify.swf',
            uploader:'../upload/frontUploadFile.do;jsessionid=${pageContext.session.id}',
            //buttonText:'<input type="button" value="上传头像">',
            buttonText:'上传头像',
            'buttonClass':"upload-photo",
            queueSizeLimit:1,
            fileSizeLimit:'2MB',
            'method': 'post',
            queueID:'fileContainer',
            fileObjName:'file',
            'fileTypeDesc' : '支持jpg、png、gif格式的图片',
            'fileTypeExts' : '*.gif; *.jpg; *.png',
            'auto':true,
            height:44,
            width:160,
            'debug':false,
            'dataType':'json',
            removeCompleted:false,
            onUploadSuccess:function (file, data, response) {
                var json = $.parseJSON(data);
                var url=json.data;
                $("#headImgUrl").val(url);
                getHeadImg(url);
            },
            onSelect:function () {

            },
            onCancel:function () {
                cancelUpload();
            }
        });
    });
    function clearQueue() {
        cancelUpload();
    }

    function uploadQueue() {
        $('#file').uploadify('upload','*');
    }

    //取消上传时
    function cancelUpload(){
        $("#headImgUrl").val("");
        $('#file').uploadify('cancel', '*');
        $('#btnContainer').hide();
        $("#imgHeadPrev").html("<img  src='../STATIC/image/defaultImg.png' id='userHeadImg'>");
        //顶部
        $("#userImage").find("img").attr("src", '../STATIC/image/defaultImg.png');
        //左侧
        $("#userHeadImgUrl").find("img").attr("src", '../STATIC/image/defaultImg.png');
    }

</script>

	<%@include file="/WEB-INF/why/index/footer.jsp" %>
</body>
</html>
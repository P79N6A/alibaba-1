function addErrMsg(id,content){
    $("#"+id).addClass("error-msg").html(content);
}
function rmErrMsg(id){
    $("#"+id).removeClass("error-msg").html("");
}

function setBtnDis(id,tf){
    $("#"+id).prop("disabled",tf);
}

/*var smsTimer;
var count=180;
function setStatus(){
    count = count - 1;
    $("#sendCode").val(count+"秒后重新发送");
    if(count <= 0){
        $("#codeErr").removeClass("error-msg").html("");
        $("#sendCode").removeAttr("disabled");
        $("#sendCode").val("发送验证码");
        clearInterval(smsTimer);
        count = 120;
    }
}*/






$(function(){
    /*出生年月日*/
    $.ms_DatePicker({
        YearSelector: ".sel_year",
        MonthSelector: ".sel_month",
        DaySelector: ".sel_day",
        FirstValue:1900
    });
    $.ms_DatePicker();

});


function valUserInfo() {
    //var  userName=$("#userName").val();
    var  userPwd=$("#newPass").val();
    var  confirmPassword=$("#newPass2").val();
    var  userMobileNo=$("#userMobileNo").val();
    var  oldPass=$("#oldPass").val();
    var uYear= $("#uYear").val();
    var uMonth=$("#uMonth").val();
    var uDay =$("#uDay").val();
    if(uMonth!="1900" && uMonth!="1900" && uDay!="1900"){
        $("#userBirth").val(uYear+"-"+uMonth+"-"+uDay);
    }
    var regPassWord = new RegExp("^[A-Za-z0-9]+$");
    // 会员昵称
/*    if($.trim(userName)==""){
        addErrMsg("userNameErr","请输入姓名");
        $("#userName").focus();
        return false;
    }else{
        rmErrMsg("userNameErr");
    }*/
/*    if($.trim(oldPass) ==""){
        addErrMsg("oldPassErr","请输入原密码!");
        $("#oldPass").focus();
        return false;
    }else if(oldPass.length<6){
        addErrMsg("oldPassErr","密码至少6位!!");
        $("#oldPass").focus();
        return false;
    }else{
        rmErrMsg("oldPassErr");
    }*/

 /*   if($.trim(userPwd) ==""){
        addErrMsg("newPassErr","请输入新密码!");
        $("#newPass").focus();
        return false;
    }else if(userPwd.length<6){
        addErrMsg("newPassErr","密码至少6位!");
        $("#newPass").focus();
        return false;
    }else if(!regPassWord.test(userPwd)){
        addErrMsg("newPassErr","密码格式不正确!");
        $("#newPass").focus();
        return false;
    }else{
        rmErrMsg("newPassErr");
    }*/
    // 确认密码
/*    if($.trim(confirmPassword) ==""){
        addErrMsg("newPass2Err","请输入确认密码!");
        $("#newPass2").focus();
        return false;
    }else if(confirmPassword.length<6){
        addErrMsg("newPass2Err","密码至少6位!!");
        $("#newPass2").focus();
        return false;
    }else{
        rmErrMsg("newPass2Err");
    }*/

    // 电子邮箱 不在验证邮箱
 /*   if(userEmail == ""){
        addErrMsg("userEmailErr","请输入电子邮箱!");
        $("#emailDiv").show();
        $("#userEmail").focus();
        return false;
    }else{
        if(!is_email(userEmail)){
            addErrMsg("userEmailErr","电子邮箱格式不正确!");
            $("#emailDiv").show();
            $("#userEmail").focus();
            return false;
        }else{
            rmErrMsg("userEmailErr");
        }
    }*/

    // 联系电话
    if(userMobileNo ==""){
        addErrMsg("userMobileNoErr","请输入联系电话");
        $("#mobileDiv").show();
        $("#userMobileNo").focus();
        return false;
    }else if(!valMobile()){
        $("#mobileDiv").show();
        addErrMsg("userMobileNoErr","请正确填写手机号码");
        $("#userMobileNo").focus();
        return false;
    }else{
        rmErrMsg("userMobileNoErr")
    }

    var  userEmail=$("#userEmail").val();
    if(userEmail != "") {
        if(!is_email(userEmail)){
            addErrMsg("userEmailErr","电子邮箱格式不正确!");
            $("#emailDiv").show();
            $("#userEmail").focus();
            return false;
        }else{
            rmErrMsg("userEmailErr");
        }
    }

    return true;
}

function valMobile(){
    var userMobileNo = $("#userMobileNo").val();
    var telReg = (/^1[34578]\d{9}$/);
    if(!userMobileNo.match(telReg)){
        return false;
    }
    return true;
}

/**
 * 编辑后获取图片
 * @param url
 */
function getHeadImg(url){
    var imgUrl = getImgUrl(url);
    imgUrl=getIndexImgUrl(imgUrl,"_300_300");
    $("#imgHeadPrev").html("<img  src='"+imgUrl+"'>");
    $("#btnContainer").hide();
    $("#fileContainer").hide();
    //顶部
    $("#headImg").attr("src", imgUrl);
    //左侧
    $("#userHeadImgUrl").find("img").attr("src", imgUrl);
}





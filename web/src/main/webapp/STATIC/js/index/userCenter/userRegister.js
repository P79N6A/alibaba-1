function checkPass(pass){
    var ls = 1;
    if(pass.match(/([0-9])+/)){ls+=1;}
    if(pass.match(/([a-z])+/) || pass.match(/([A-Z])+/)){ls+=1;}
    /*var reg = /^[0-9a-zA-Z]+$/;
    if(reg.test(pass)){
    	ls = 3;
    }*/
    return ls;
}
function valUserName(){
    var  userName=$("#userName").val();
    var  regUserName = new RegExp("^[\u4E00-\u9FA5A-Za-z0-9_]+$");
    if(userName!=""){
        var userArr =  userName.split("_");
    }
    if($.trim(userName)==""){
        $("#userNameErr").addClass("error-msg").html("请输入昵称！");
        return false;
    }else if(userName.length>20) {
        $("#userNameErr").addClass("error-msg").html("昵称不能超过20位！");
        return false;
    }else if(!regUserName.test(userName)) {
        $("#userNameErr").addClass("error-msg").html("昵称格式不正确,支持数字、字母、下划线、汉字！");
        return false;
    }else if(userArr.length>2){
        $("#userNameErr").addClass("error-msg").html("昵称格式不正确,只能包含一个下划线！");
        return false;
    }else{
        $("#userNameErr").removeClass("error-msg").html("");
    }
    return true;
}
function valNewPass(){
    var  userPwd=$("#newPass").val();
    if(userPwd==""){
        $("#userPwdErr").addClass("error-msg").html("请输入密码！");
        return false;
    }else if(userPwd.length<6){
        $("#userPwdErr").addClass("error-msg").html("密码至少6位！");
        return false;
    }else if(userPwd.length>20){
        $("#userPwdErr").addClass("error-msg").html("密码不能超过20位！");
        return false;
    }
    //格式
    if(checkPass(userPwd)<3){
        $("#userPwdErr").addClass("error-msg").html("密码格式不正确,必须是字母数字组合！");
        return false;
    }else{
        $("#userPwdErr").removeClass("error-msg").html("");
    }
    return true;
}
function valNewPass2(){
    var  userPwd=$("#newPass").val();
    var  confirmPassword=$("#newPass2").val();
    if(confirmPassword==""){
        $("#confirmPasswordErr").addClass("error-msg").html("请输入确认密码！");
        return false;
    }else if(confirmPassword.length<6){
        $("#confirmPasswordErr").addClass("error-msg").html("确认密码至少6位！");
        return false;
    }else if(confirmPassword.length>20){
        $("#confirmPasswordErr").addClass("error-msg").html("确认密码不能超过20位！");
        return false;
    }else if(confirmPassword!=userPwd){
        $("#confirmPasswordErr").addClass("error-msg").html("两次输入密码不一致！");
        return false;
    }
    if(checkPass(confirmPassword)<3){
        $("#confirmPasswordErr").addClass("error-msg").html("密码格式不正确,必须是字母数字组合！");
        return false;
    }else{
        $("#confirmPasswordErr").removeClass("error-msg").html("");
    }
    return true;
}
function valUserMobile(){
    var  userMobileNo=$("#userMobileNo").val();
    var telReg = (/^1[34578]\d{9}$/);
    if(userMobileNo ==""){
        $("#userMobileNoErr").addClass("error-msg").html("请输入手机号码！");
        return false;
    }else if(!userMobileNo.match(telReg)){
        $("#userMobileNoErr").addClass("error-msg").html("请正确填写手机号码！");
        return false;
    }else{
        $("#userMobileNoErr").removeClass("error-msg").html("");
    }
    return true;
}
function valRegForm(){
    if(!valUserMobile()){
        $("#userMobileNo").focus();
        return false;
    }
    if(!valUserName() ){
        $("#userName").focus();
        return false;
    }
    if(!valNewPass()){
        $("#newPass").focus();
        return false;
    }
    if(!valNewPass2()){
        $("#newPass2").focus();
        return false;
    }
    return true;
}

function setDisBtn(id,tf){
    $("#"+id).prop("disabled",tf);
}


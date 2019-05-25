<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>注册页--文化云</title>
  <%@include file="/WEB-INF/why/common/frontPageFrame.jsp"%>
</head>
<body style="background-color: khaki">

<br><br><br><br><br>
<div style="width: 500px;margin:50px auto">
用户名：<input type = "text"   id="userName"  style="width: 300px;height: 30px;" /> <br><br><br><br>
密码&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<input type="password"  id="userPwd" style="width: 300px;height: 30px;" /> <br><br><br><br>
手机号: <input type="text"  id="userMobileNo" style="width: 300px;height: 30px;" maxlength="11"/> <br><br><br><br>

&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
  <input type="button" value="注册" onclick="saveUser()" style="width: 100px;height: 30px;"  />
</div>
<script type="text/javascript">

  function saveUser(){

    var userName=$("#userName").val();
    var userPwd = $("#userPwd").val();
    var userMobileNo=$("#userMobileNo").val();

    if(userName){

    }else{
      alert("用户名不完整!");
      return;
    }

    if(userPwd){
    }else{
      alert("密码不完整!");
      return;
    }

    if(userMobileNo){
    }else{
      alert("手机号码不完整!");
      return;
    }


    //用户名验证
    $.ajax({
      type: "POST",
      data:{
        userName:userName,
        userPwd:userPwd,
        userMobileNo:userMobileNo
      },
      url: "${path}/frontTerminalUser/testReg.do",
      dataType: "json",
      success: function (data) {
        if(data=="success"){
          alert("注册成功！");
          history.go(0);
        }else if(data=="repeat") {
        alert("用户名重复！");
       }else{
        alert("注册失败！")
       }
  }
  });
  }


</script>
</body>
</html>
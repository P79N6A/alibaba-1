<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head>
    <title>文化云后台管理系统</title>
      <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
      <!-- dialog end -->
      <style type="text/css">
          .ui-dialog-close{ display: none;}
      </style>
   </head>
  <body>
  <div class="site">
      <em>您现在所在的位置：</em>管理员 &gt; 修改密码
  </div>
  <div class="site-title">修改密码</div>
  <div class="main-publish">
      <table width="100%" class="form-table">
          <tr>
              <td width="100" class="td-title">原始密码：</td>
              <td class="td-input">
                  <input type="password" id="oldPass" name="oldPass" class="input-text w210" maxlength="20"/>
                  <span id="oldPassErr"></span>
              </td>

          </tr>
          <tr>
              <td width="100" class="td-title">新密码：</td>
              <td class="td-input">
                  <input type="password" id="userPassword" name="userPassword" class="input-text w210" maxlength="20"/>
                  <span id="userPasswordErr"></span>
              </td>

          </tr>
          <tr>
              <td width="100" class="td-title">确认新密码：</td>
              <td class="td-input">
                  <input type="password" id="userPassword2" class="input-text w210" maxlength="20"/>
                  <span id="userPasswordErr2"></span>
              </td>
          </tr>
          <tr>
              <td width="100" class="td-title"></td>
              <td class="td-btn">
                  <input class="btn-publish" type="button" value="保存修改"/>
              </td>
          </tr>
      </table>
  </div>

  <script type="text/javascript">

      function addTips(id,content){
          $("#"+id).addClass("error-msg").html(content);
      }

      function rmTips(id,content){
          $("#"+id).removeClass("error-msg").html(content);
      }

      function setDisBtn(tf){
          $(".btn-publish").prop("disabled",tf);
      }
      $(function() {
          $(".btn-publish").on("click", function(){
                      setDisBtn(true);
                      var userId='${user.userId}';
                      var oldPass= $("#oldPass").val();
                      var userPassword=$("#userPassword").val();
                      var userPassword2=$("#userPassword2").val();
                      if(oldPass==""|| $.trim(oldPass)==""){
                          //dialogAlert("提示", "<h2>旧密码不能为空!</h2>", function(){
                             addTips("oldPassErr","旧密码不能为空!");
                             setDisBtn(false);
                          //});
                          return;
                      }
                      rmTips("oldPassErr","");
                      if(userPassword==""|| $.trim(userPassword)==""){
                         // dialogAlert("提示", "<h2>新密码不能为空!</h2>", function(){
                              addTips("userPasswordErr","新密码不能为空!");
                              setDisBtn(false);
                         // });
                          return;
                      }
                      rmTips("userPasswordErr","");
                      if(userPassword2==""|| $.trim(userPassword2)==""){
                          //dialogAlert("提示", "<h2>确认密码不能为空!</h2>", function(){
                              setDisBtn(false);
                              addTips("userPasswordErr2","确认密码不能为空!");
                          //});
                          return;
                      }
                      if(userPassword!=userPassword2){
                          //dialogAlert("提示", "<h2>两次密码输入不一致!</h2>", function(){
                              setDisBtn(false);
                              addTips("userPasswordErr2","两次密码输入不一致!");

                         // });
                          return;
                      }
                      rmTips("userPasswordErr2","");
                      if(userPassword==oldPass){
                          //dialogAlert("提示", "<h2>新密码和旧密码相同,无须修改!</h2>", function(){
                              setDisBtn(false);
                              addTips("userPasswordErr2","新密码和旧密码相同,无须修改!");
                          //});
                          return;
                      }
                     rmTips("userPasswordErr2","");
                      $.ajax({
                          type: "POST",
                          url: "${path}/user/modUserInfo.do",
                          data: {
                              userId:userId,
                              oldPass:oldPass,
                              userPassword:userPassword
                          },
                          dataType: "json",
                          success: function (data) {
                              if(data.result=="success"){
                                  var html = "<h2>修改成功,请重新登录!</h2>";
                                  dialogAlert("提示", html, function(){
                                      window.location.href = "${path}/login.do";
                                  });
                              }else if(data.result=="oldPassError"){
                                  var html = "<h2>原密码错误!</h2>";
                                  dialogAlert("提示", html, function(){
                                      setDisBtn(false);
                                  });

                              }else if(data.result=="timeOut"){
                                  var html = "<h2>登陆超时,请重新登录!</h2>";
                                  dialogAlert("提示", html, function(){
                                      window.location.href = "${path}/login.do";
                                  });
                              }else{
                                  var html = "<h2>更新失败,请稍后重试!</h2>";
                                  dialogAlert("提示", html, function(){
                                      setDisBtn(false);
                                  });
                              }
                          }
                      });

                 });

             });
  </script>
  </body>
</html>
<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>团体详情--文化云</title>
  <!-- 导入头部文件 start -->
  <%@include file="/WEB-INF/why/common/frontPageFrame.jsp"%>

</head>
<body style="background: none;">
<div class="join-box">
  <form id="groupJoinForm">
    <dl class="groupName">
      <dt>申请加入<input type="hidden" name="tuserId" value="${tuserId}"/><input type="hidden" name="userId" value="${terminalUser.userId}"/></dt>
      <dd id="groupTit"></dd>
    </dl>
    <dl>
      <dt><span style="color:red;">*</span>姓名</dt>
      <dd><input type="text" class="input-text" name="userNickName" id="userNickName" value="${terminalUser.userNickName}" maxlength="25"/></dd>
    </dl>
    <dl class="groupSex">
      <dt>性别<input type="hidden" name="userSex" id="userSex"/></dt>
      <dd><label><input name="sex" type="radio" id="sex1" <c:if test="${empty terminalUser.userSex || terminalUser.userSex == 1}">checked="checked" </c:if>/>男</label><label><input name="sex" id="sex2" type="radio" <c:if test="${terminalUser.userSex == 2}">checked="checked" </c:if>/>女</label></dd>
    </dl>
    <dl>
      <dt>年龄</dt>
      <dd><input type="text" class="input-text" name="userAge" value="${terminalUser.userAge}" maxlength="11" onkeyup="this.value=this.value.replace(/\D/g,'')"/></dd>
    </dl>
    <dl>
      <dt><span style="color:red;">*</span>手机号码</dt>
      <dd><input type="text" class="input-text" name="userMobileNo" id="userMobileNo" value="${terminalUser.userMobileNo}" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')"  maxlength="11"/></dd>
    </dl>
    <dl>
      <dt><span style="color:red;">*</span>申请理由</dt>
      <dd><textarea class="introduce" name="applyReason" id="applyReason" maxlength="200"></textarea></dd>
    </dl>
    <div class="join-btn">
      <input class="btn-confirm" type="button" value="确定"/>
      <input class="btn-reset" type="reset" value="取消"/>
    </div>
  </form>
</div>

<script type="text/javascript" src="${path}/STATIC/js/dialog/lib/sea.js"></script>
<script type="text/javascript">
  seajs.config({
    alias: {
      "jquery": "${path}/STATIC/js/dialog/lib/jquery-1.10.2.js"
    }
  });

  seajs.use(['${path}/STATIC/js/dialog/src/dialog-plus'], function (dialog) {
    window.dialog = dialog;
  });

  window.console = window.console || {log:function () {}}
  seajs.use(['jquery'], function ($) {

    var dialog = top.dialog.get(window);
    var data = dialog.data; // 获取对话框传递过来的数据
    $('#groupTit').text(data);
    /*点击确定，关闭登录框*/
    $(".btn-confirm").on("click", function(){
      if($("#sex1").is(":checked")){
        $("#userSex").val(1);
      }else if($("#sex2").is(":checked")){
        $("#userSex").val(2);
      }

      // 验证姓名不为空
      var userNickName = $("#userNickName").val();
      if(userNickName == null || userNickName == ""){
        dialogAlert("提示", "请填写真实姓名");
        return;
      }

      // 验证手机号
      var userMobileNo = $("#userMobileNo").val();
      if(userMobileNo == null || userMobileNo == ""){
        dialogAlert("提示", "请填写手机号码");
        return;
      }else if(!is_mobile(userMobileNo)){
        dialogAlert("提示", "请正确填写手机号码");
        return;
      }

      //验证申请理由不为空
      var applyReason = $("#applyReason").val();
      if(applyReason == null || applyReason == ""){
        dialogAlert("提示", "请填写申请理由");
        return;
      }

      $.post("${path}/frontApplyJoinTeam/addGroupJoin.do",$("#groupJoinForm").serialize(),function(result){
        if(result == "success"){
          dialogAlert("提示", "申请成功，正在审核中.....", function(){
            dialog.close(result).remove();
          });
        }
      });
    });
    $(".btn-reset").on("click", function(){
      dialog.close().remove();
    });
  });
</script>
</body>
</html>
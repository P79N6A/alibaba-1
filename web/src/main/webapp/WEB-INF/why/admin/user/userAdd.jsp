<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="s" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>文化云后台管理系统</title>
<%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
<script type="text/javascript" src="${path}/STATIC/layer/layer.js"></script>
<script type="text/javascript" src="${path}/STATIC/layer/extend/layer.ext.js"></script>

      <script type="text/javascript" >

          $(document).ready(function(){
              selectModel();
          });
          
          $(function() {
//              removeMsg("userAccountLable");
//              appendMsg("userAccountLable","支持数字、字母、下划线、汉字!");
              showLocation();
              $('input:text').focus()
              $("#userAccount").focus();
              
              //权限标签选择
              $("#userLabelCheck input[type='checkbox']").click(function(){
            	  if($(this).is(':checked')){
            		  $(this).val($(this).attr("labelNo"));
            	  }else{
            		  $(this).val(0);
            	  }
              });
          });

          function showErrorMsg(id,msgInfo) {
              var bean =$('#' + id).val();
              if(bean ==undefined||bean ==""){
                  removeMsg(id + "Lable");
                  appendMsg(id + "Lable",msgInfo);
                  $('#' + id ).focus();
                  return false;
              }else{
                  removeMsg(id + "Lable");
                  return true;
              }
          }
              
          function doSubmit(){
              var pattern = new RegExp("[^a-zA-Z0-9\_\u4e00-\u9fa5]","i");
               if (!showErrorMsg("userAccount","帐号不能为空")) {
                   return false
               }
              if($("#userAccount").val() != null && pattern.test($("#userAccount").val())){
                   removeMsg("userAccountLable");
                   appendMsg("userAccountLable","支持数字、字母、下划线、汉字!");
                   $("#userAccount").focus();
                   return false;
               }

              if (!showErrorMsg("userPassword","用户密码不能为空")) {
                  return false
              }

              if (!showErrorMsg("confirmUserPassword","用户确认密码不能为空")) {
                  return false
              }

              if ($("#confirmUserPassword").val() != ($("#userPassword").val())){
                  removeMsg("confirmUserPasswordLable");
                  appendMsg("confirmUserPasswordLable","两次密码不一样");
                  return false;
              }
              /*if (!showErrorMsg("userIsManger","用户类别不能为空")) {
                  return false
              }*/


/*              if (!showErrorMsg("userIsManger","用户级别不能为空")) {
                  return false
              }*/
              if (!showErrorMsg("userDeptId","用户部门不能为空")) {
                  return false;
              }
              if (!showErrorMsg("userDeptName","用户部门不能为空")) {
                  return false
              }
              if (!showErrorMsg("userNickName","用户昵称不能为空")) {
                  return false;
              }
              if (!showErrorMsg("userMobilePhone","电话号码不能为空")) {
                  return false;
              }
              if (!showErrorMsg("loc_province","所属省份不能为空")) {
                  return false;
              }


//              var isMobile = /^[\d]{11}$/;
//              //var isMobile=/^(?:13\d|15\d|18\d)\d{5}(\d{3}|\*{3})$/; //手机号码验证规则
//              var isPhone=/^[0-9]*$/;   //座机验证规则
//              var userMobilePhone = $("#userMobilePhone").val();//获得用户填写的号码值 赋值给变量dianhua
//              var userTelephone =  $("#userTelephone").val();
//              if(userMobilePhone != '' && !isMobile.test(userMobilePhone)){ //如果用户输入的值不同时满足手机号和座机号的正则
//                  removeMsg("userMobilePhoneLable");
//                  appendMsg("userMobilePhoneLable","手机格式不正确");
//                  //showErrorMsg("userMobilePhone","手机格式不正确");
//                  return false;       //返回一个错误，不向下执行
//              } removeMsg("userMobilePhoneLable");
//              if(userTelephone != '' && !isPhone.test(userTelephone)){ //如果用户输入的值不同时满足手机号和座机号的正则
//                  removeMsg("userTelephoneLable");
//                  appendMsg("userTelephoneLable","座机号码格式不正确");
//  //                showErrorMsg("userTelephone","座机号码格式不正确");
//                  return false;       //返回一个错误，不向下执行
//              }

//              var isQQ= /^\+?[1-9][0-9]*$/;
//              var userQq = $("#userQq").val();
//              if (userQq != '' && !isQQ.test(userQq)) {
//                  removeMsg("userQqLable");
//                  appendMsg("userQqLable","qq格式不正确");
//                  //showErrorMsg("userQq","qq格式不正确");
//                  return false;
//              }

              var userIdCardNo = $("#userIdCardNo").val();
              var isCardNo = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/;
              var userIdCardNo = $("#userIdCardNo").val();
              var isUserEmail = /^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+(.[a-zA-Z0-9_-])+/;
              var userEmail = $("#userEmail").val();
              if (userEmail !='' && !isUserEmail.test(userEmail)) {
                  removeMsg("userEmailLable");
                  appendMsg("userEmailLable","邮箱格式不正确");
                  //showErrorMsg("userEmail","邮箱格式不正确");
                  return false;
              }

              if (userIdCardNo != '' && !isCardNo.test(userIdCardNo)) {
                  removeMsg("userIdCardNoLable");
                  appendMsg("userIdCardNoLable","身份证号码格式不正确");
                  //showErrorMsg("userIdCardNo","身份证号码格式不正确");
                  return false;
              }

              removeMsg("userMobilePhoneLable");
//              removeMsg("userTelephoneLable");
//              removeMsg("confirmUserPasswordLable");
              removeMsg("userEmailLable");
              removeMsg("userIdCardNoLable");
//              removeMsg("userQqLable");
              $("#userProvinceText").val($("#loc_province").find("option:selected").text()) ;
              $("#userCityText").val($("#loc_city").find("option:selected").text()) ;
              $("#userCountyText").val($("#loc_town").find("option:selected").text()) ;
              
              var userLabel1 = $("input[name='userLabel1']").val();
        	  var userLabel2 = $("input[name='userLabel2']").val();
        	  var userLabel3 = $("input[name='userLabel3']").val();
        	  if(userLabel1==0&&userLabel2==0&&userLabel3==0){
        		  appendMsg("userLabelCheck","权限标签不能为空");
        		  return;
        	  }else{
        		  removeMsg("userLabelCheck");
        	  }
	
              $.post("${path}/user/saveSysUser.do", $("#userInfoForm").serialize(), function(data) {
                  if (data == "success") {
                      dialogAlert("系统提示", "添加成功",function (r){
                          location.href='${path}/user/sysUserIndex.do';
                      });
                  }
                  else {
                      dialogAlert("系统提示", '添加失败:' + data);
                  }
              });
          }
      </script>

     <script type="text/javascript">
          var setting = {
              check: {
                  enable: true,
                  chkStyle: "radio",
                  radioType: "all"
              },
              data: {
                  simpleData: {
                      enable: true,
                      idKey: "deptId",
                      pIdKey: "deptParentId",
                      rootPId: "0"
                  },
                  key: {
                      name: "deptName"
                  }
              },
              callback: {
                  beforeCheck: zTreeBeforeCheck,
                  onCheck: zTreeOnCheck
              }
          };

          function zTreeBeforeCheck(treeId, treeNode){
              return true;
          }
          function zTreeOnCheck(event, treeId, treeNode){
              $("#userDeptId").val(treeNode.deptId);
          }
          var zNodes;

          var code;
          function showCode(str) {
              if (!code) code = $("#code");
              code.empty();
              code.append("<li>"+str+"</li>");
          }

          function doChangeAddress () {
              var type = $("#userIsManger").val();
              if(type == '1') {
                  $("#loc_cityId").css("display", 'none');
                  $("#loc_townId").css("display", "none");
                  $("#loc_city").val("");
                  $("#loc_town").val("");
              } else if(type =='2') {
                  $("#loc_cityId").css("display", 'block');
                  $("#loc_townId").css("display", "none");
                  $("#loc_town").val("");
              } else if(type =='3'){
                  $("#loc_cityId").css("display", 'block');
                  $("#loc_townId").css("display", "block");
              } else {
                  $("#loc_cityId").css("display", 'block');
                  $("#loc_townId").css("display", "block");
              }
          }
      </script>

  </head>
  <body>
  <form action="" id="userInfoForm" method="post">
      <div class="site">
          <em>您现在所在的位置：</em>用户管理 &gt; 用户新增
      </div>
      <div class="site-title">用户新增</div>
      <div class="main-publish">
          <table width="100%" class="form-table">
              <tr>
                  <td width="100" class="td-title"><span class="red">*</span>用户帐号：</td>
                  <td class="td-input" id="userAccountLable">
                      <input type="text" id="userAccount" name="userAccount" class="input-text w410"  maxlength="20" /></td>
              </tr>
              <tr>
                  <td  class="td-title" ><span class="red">*</span>密码</td>
                  <td class="td-input" id="userPasswordLable">
                      <input type="password" class="input-text w410" style="" name="userPassword" id="userPassword"/>
                  </td>
              </tr>
              <tr>
                  <td class="td-title" ><span class="red">*</span>确认密码</td>
                  <td  class="td-input" id="confirmUserPasswordLable">
                      <input type="password" class="input-text w410"  name="confirmUserPassword" id="confirmUserPassword"/>
                  </td>
              </tr>
<%--              <tr>
                  <td class="td-title"><span class="red">*</span>用户类别：</td>
                  <td class="td-select" id="userIsMangerLable">
                      <div class="select-box w140" style="z-index: 5;">
                          <input type="hidden" id="userIsManger" name="userIsManger">
                          <div class="select-text" data-value="" id="userTypeDiv">请选择级别</div>
                          <ul class="select-option" style="display: none;" onmouseleave="doChangeAddress()">
                              <li data-option="">请选择级别</li>
                              <c:if test="${sessionScope.user.userIsManger <= 1}"><li data-option="1">省级人员</li> </c:if>
                              <c:if test="${sessionScope.user.userIsManger <= 2}"> <li data-option="2">市级人员</li></c:if>
                              <c:if test="${sessionScope.user.userIsManger <= 3}"> <li data-option="3">区级人员</li></c:if>
                              <c:if test="${sessionScope.user.userIsManger <= 4}"> <li data-option="4">场馆人员</li> </c:if>
                          </ul>
                      </div>
                  </td>
              </tr>--%>
              <tr>
                  <td class="td-title">
                      <span class="red">*</span> 部门
                  </td>
                  <td class="td-input" id="userDeptIdLable">
                      <script type="text/javascript">
                          //iframe层-父子操作
                          function selectDept() {
                              layer.open({
                                  type: 2,
                                  title: '请选择部门',
                                  area: ['450px', '440px'],
                                  fix: false, //固定
                                  maxmin: true,
                                  content: '${path}/user/selectDept.do'
                              });
                          }

                      </script>
                      <input type="hidden" name="userDeptId" id="userDeptId" value=""/>
                      <input data-val="输入用户部门"  class="input-text" type="text" name="userDeptName" id="userDeptName" value=""  readonly />
                      <input type="button"  value="点击选择部门" id="parentIframe" class="upload-btn" onclick="selectDept()"/>
                  </td>
              </tr>
              <tr>
                  <td class="td-title"><span class="red">*</span>用户昵称：</td>
                  <td class="td-input" id="userNickNameLable"><input type="text" id="userNickName" name="userNickName" class="input-text w410"/></td>
              </tr>
              <tr>
                  <td class="td-title"><span class="red">*</span>手机号码：</td>
                  <td class="td-input" id="userMobilePhoneLable">
                      <input type="text" maxlength="11" name="userMobilePhone" id="userMobilePhone"
                             class="input-text w410" onkeyup="this.value=this.value.replace(/\D/g,'')"/>
                  </td>
              </tr>
              <tr>
                  <td  class="td-title"><span class="red">*</span>所属省份：</td>
                  <td  class="td-select" id="loc_provinceLable">
                      <select id="loc_province"
                              style="width: 130px;" name="userProvince"></select>
                      <input type="hidden" name="userProvinceText" id="userProvinceText" />

                      <div id="loc_cityId">
                          <select id="loc_city" name="userCity"
                                  style="width: 130px; margin-left: 10px"></select>
                          <input type="hidden" name="userCityText" id="userCityText" />
                      </div>
                      
                      <div id="loc_townId">
                          <select id="loc_town" name="userCounty"
                                  style="width: 130px; margin-left: 10px"></select>
                          <input type="hidden" name="userCountyText" id="userCountyText" />
                      </div>
                  </td>
              </tr>
              <tr>
                  <td class="td-title">常用邮箱：</td>
                  <td class="td-input" id="userEmailLable"><input type="text" name="userEmail" id="userEmail" class="input-text w510"/></td>
              </tr>
              <tr>
                  <td  class="td-title">身份证号码</td>
                  <td  class="td-input"  id="userIdCardNoLable">
                      <input type="text" data-val=""  class="input-text w510" name="userIdCardNo" id="userIdCardNo" value="" />
                  </td>
              </tr>
              <tr>
                  <td class="td-title">出生日期：</td>
                  <td class="td-input">
                      <input  type="text" name="birthday" id="birthday" onClick="WdatePicker();"	style="width: 200px;" class="input-text w510" />
                  </td>
              </tr>
              <tr>
                  <td class="td-title">性别：</td>
                  <td class="td-radio">
                      <label><input type="radio" value="1" checked name="userSex"/><em>男</em></label>
                      <label><input type="radio" value="2" name="userSex"/><em>女</em></label>
                  </td>
              </tr>
              <tr>
                  <td class="td-title"><span class="red">*</span>权限标签：</td>
                  <td class="td-fees" id="userLabelCheck">
                      <label><input type="checkbox" value="1" checked name="userLabel1" labelNo="1"/><em>文广体系</em></label>
                      <label><input type="checkbox" value="0" name="userLabel2" labelNo="2"/><em>独立商家</em></label>
                      <label><input type="checkbox" value="0" name="userLabel3" labelNo="3"/><em>其他</em></label>
                      <label class="red">（此处可多选）</label>
                  </td>
              </tr>
              <tr class="td-btn">
                  <td></td>
                  <td>
                      <input type="button" value="保存" class="btn-save" onclick="javascript:return doSubmit();"/>
                      <input type="button" value="返回" class="btn-publish" onclick="javascript:history.back(-1)"/>
                  </td>
              </tr>
          </table>
      </div>
  </form>
  </body>
</html>

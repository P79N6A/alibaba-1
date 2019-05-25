<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>意见反馈--文化云</title>
  <%@include file="/WEB-INF/why/common/frontIndexPageFrame.jsp"%>
  <script type="text/javascript" src="${path}/STATIC/js/jquery.uploadify-3.1.min.js"></script>
</head>
<body>
<%
  String userMobileNo = "";
  if(session.getAttribute("terminalUser") != null){
    CmsTerminalUser terminalUser = (CmsTerminalUser)session.getAttribute("terminalUser");
    if(StringUtils.isNotBlank(terminalUser.getUserMobileNo())){
      userMobileNo = terminalUser.getUserMobileNo();
    }else{
      userMobileNo = "0000000";
    }
  }
%>
<input type="hidden" id="userMobileNo" value="<%=userMobileNo%>"/>
<script type="text/javascript">
  $(function() {
    <c:if test="${ empty sessionScope.terminalUser}">
    window.location="${path}/frontTerminalUser/userLogin.do";
    </c:if>
    // 根据标签查询反馈选项
    $.post("${path}/sysdict/queryChildSysDictByDictCode.do?dictCode=FEEDBACKTYPE", function(data) {
      var list = eval(data);
      for (var i = 0; i < list.length; i++) {
        var obj = list[i];
        var dictId = obj.dictId;
        var dictName = obj.dictName;
        $("#feed_Type").append('<label><input checked="checked" name="feedType" type="radio" value="'+dictId+'"/><span>'+dictName+'</span></label>');
      }
    });
  });
    // 保存反馈
  function saveFeedBack(){
    if($("input[name=userMobileNo]").val() == undefined || $("input[name=userMobileNo]").val() == ""){
//      dialogAlert("反馈提示", "请输入反馈联系方式");
      $("#userMobileNoError").addClass("error-msg").html("请输入联系方式！");
      $("#userMobileNo").focus();
      return;
    }
    if($("#feedContent").val()== undefined || $("#feedContent").val() == ""){
      $("#feedContentError").addClass("error-msg").html("请输入意见内容!");
      $("#feedContent").focus();
      return;
    }

    $.ajax({
      type: "POST" ,
      data:{
        feedImgUrl:$("input[name=headImgUrl]").val(),
        feedType:$("input[name=feedType]").val(),
        feedContent:$("#feedContent").val(),
        userMobileNo:$("input[name=userMobileNo]").val(),
        userId:$("#userId").val()
      },
      url: "${path}/frontFeedBack/webFeedBack.do",
//      dataType: "json",
      success: function (data) {
        if(data == "success") {
          dialogAlert("提示","反馈成功！",function(){
            window.location="${path}/frontIndex/index.do";
          });
        }else{
          dialogAlert("提示","反馈失败！请稍后再试！");
        }
      }
    });
  }
</script>
<%@include file="/WEB-INF/why/index/index_top.jsp"%>
<c:if test="${not empty sessionScope.terminalUser}">
<div id="register-content" name="CmsFeedback" >
  <div class="register-content">
    <div class="feedback-box">
      <h2>意见反馈</h2>
      <form action="">
        <div class="feedback-form"  >
          <input type="hidden" id="userId" name="userId" value="${terminalUser.userId}"/>
            <dl>
              <dt>类型</dt>
              <dd>
                <div id="feed_Type" class="input-radio">
                </div>
              </dd>
            </dl>
          </dl>
          <dl>
            <dt>内容</dt>
            <dd>
              <textarea maxlength="200" class="content-txt" id="feedContent" name="feedContent" placeholder="请输入意见内容" value=""></textarea>
              <span id="feedContentError" style="color: #CC0000"> </span>
            </dd>

          </dl>
          <dl>
            <dt>上传图片</dt>
            <dd style="min-height:50px;">
              <div class="fl wimg" style="width: auto;">

                <input type="hidden"  name="headImgUrl" id="headImgUrl" value=""/>
                <input type="hidden" name="uploadType" value="Img" id="uploadType"/>
                <div id="imgHeadPrev" style="position: relative; overflow: hidden;  float: left;">
                </div>

                <div style="float: left; margin-top:7px;">
                    <div>
                      <input type="file" name="file" id="file"/>
                    </div>
                  <div class="comment_message" style="display: none">(最多三张图片)</div>
                  <div id="fileContainer" style="display: none;"></div>
                  <div id="btnContainer" style="display: none;"></div>
                </div>

              </div>
            </dd>
          </dl>
          <dl>
            <dt>联系方式</dt>
            <dd>
              <input maxlength="30" type="text" class="input-phone" id="userMobileNo" name="userMobileNo" placeholder="请输入联系方式"  value=""/>
              <span id="userMobileNoError" style="color: #CC0000"></span>
            </dd>
          </dl>
          <input type="button" value="提 交" onclick="saveFeedBack()" class="btn-submit btn-feedback"/>
        </div>

      </form>
    </div>
  </div>
</div>
  </c:if>
<%@include file="../index_foot.jsp"%>
</body>

<script type="text/javascript" >

  $(function () {
    var Img=$("#uploadType").val();
    $("#file").uploadify({
      'formData':{
        'uploadType':Img,
        'type':10,
        'userMobileNo':$("#userMobileNo").val()
      },//传静态参数
      swf:'${path}/STATIC/js/uploadify.swf',
      uploader:'${path}/upload/frontUploadFile.do;jsessionid=${pageContext.session.id}',
      buttonText:'<a class="shangchuan" style="margin:0;"><h4><font>添加图片</font></h4></a>',
      'buttonClass':"upload-btn",
      /*queueSizeLimit:3,*/
      fileSizeLimit:"2MB",
      'method': 'post',
      queueID:'fileContainer',
      fileObjName:'file',
      'fileTypeDesc' : '支持jpg、png、gif格式的图片',
      'fileTypeExts' : '*.gif; *.jpg; *.png',
      'auto':true,
      'multi':true, //是否支持多个附近同时上传
      height:26,
      width:90,
      'debug':false,
      'dataType':'json',
      'removeCompleted':true,
      onUploadSuccess:function (file, data, response) {
        var json = $.parseJSON(data);
        var url=json.data;

        $("#headImgUrl").val($("#headImgUrl").val()+url+";");
        getHeadImg(url);

        if($("#headImgUrl").val().split(";").length > 3){
          $("#file").hide();
          $(".comment_message").show();
        }
      },
      onSelect:function (file) {

      },
      onDialogOpen:function () {

      }
    });


  });

  function getHeadImg(url){
    var imgUrl = getImgUrl(url);
    imgUrl=getIndexImgUrl(imgUrl,"_300_300");
    $("#imgHeadPrev").append("<div class='sc_img fl' data-url='"+url+"'><img onload='fixImage(this, 100, 100)' src='"+imgUrl+"'><a href='javascript:;'></a></div>");
    $("#btnContainer").hide();
    $("#fileContainer").hide();
  }

  /*活动评论图片删除*/
  $(function(){
    $(".wimg").on("click", ".sc_img a", function(){
      var url = $(this).parent().attr("data-url");
      var allUrl = $("#headImgUrl").val();
      var newUrl = allUrl.replace(url+";", "");
      $("#headImgUrl").val(newUrl);

      $(this).parent().remove();
      if($("#headImgUrl").val().split(";").length <= 3){
        $("#file").show();
        $(".comment_message").hide();
      }
    });
    $(".wimg").on({
      mouseover: function(){
        $(this).find("a").show();
      },
      mouseout: function(){
        $(this).find("a").hide();
      }
    }, ".sc_img");
  });



  $(function(){
    $('#keyword').blur(function(){
      toList();
    });
  });


</script>


</html>

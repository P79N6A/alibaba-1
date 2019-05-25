<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<%
  String path = request.getContextPath();
  request.setAttribute("path", path);
  String basePath = request.getScheme() + "://"
          + request.getServerName() + ":" + request.getServerPort()
          + path + "/";
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
  <script language="javascript" type="text/javascript" src="${path}/STATIC/js/DragZoom.js"></script>
  <title>js+php上传头像图片缩放裁剪</title>
  <style type="text/css">
    body {
      -moz-user-select: none; /*火狐*/
      -webkit-user-select: none; /*webkit浏览器*/
      -ms-user-select: none; /*IE10*/
      -khtml-user-select: none; /*早期浏览器*/
      user-select: none;
    }
    #drag_zoom_box{ margin: 10px auto;}
    #cut_div{ border:2px solid #888888; overflow: hidden; position:relative; top:0px; left:0px; cursor:pointer;}
    .menu_box{ height: 23px; margin-top: 10px;}
    .menu_box a{ display: inline-block; width: 19px; height: 19px; cursor: pointer;}
    .menu_box .zoom_reduce{ background: url("${path}/STATIC/image/_h.gif") no-repeat;}
    .menu_box .zoom_reduce:hover{ background: url("${path}/STATIC/image/_c.gif") no-repeat;}
    .menu_box .zoom_enlarge{ background: url("${path}/STATIC/image/+h.gif") no-repeat;}
    .menu_box .zoom_enlarge:hover{ background: url("${path}/STATIC/image/+c.gif") no-repeat;}
    #img_grip{position:absolute; z-index:100; left:-1000px; top:-1000px; cursor:pointer;}
    .btn_box{ padding-top: 20px;}
  </style>
</head>
<body>

<form id="submitCutIamge" action="${path}/att/sliceImg.do" method="post"  >
  <div id="drag_zoom_box">
    <div id="cut_div">
      <table style="border-collapse: collapse; z-index: 10; filter: alpha(opacity=75); position: relative; left: 0px; top: 0px; opacity: 0.75;" cellspacing="0" cellpadding="0" border="0" unselectable="on">
        <tr>
          <td style="background: #cccccc; height: 50px;" colspan="3"></td>
        </tr>
        <tr>
          <td style="background: #cccccc; width: 50px;"></td>
          <td style="border: 1px solid #ffffff;" id="cut_box"></td>
          <td style="background: #cccccc; width: 50px;"></td>
        </tr>
        <tr>
          <td style="background: #cccccc; height: 50px;" colspan="3"></td>
        </tr>
      </table>
      <%--<img id="cut_img" style="position:relative;" src="http://192.168.42.11/admin/45/201512/Img/Img8584e3f3c1434eaea862306f549863e0.png" />--%>
      <img id="cut_img" style="position:relative;" src="${data.imageUrl}" />
    </div>
    <%--${path}--%>
    <div class="menu_box">
      <%--<div class="menu_box" style="display: none;">--%>
      <a class="zoom_reduce" onclick="DragZoom.imageResize(false)"></a>
      <img class="zoom_bar" id="img_track" style="width: 250px; height: 18px;" src="${path}/STATIC/image/track.gif" />
      <a class="zoom_enlarge" onclick="DragZoom.imageResize(true)"></a>
    </div>
    <%--<img id="img_grip" src="${path}/STATIC/image/grip.gif" style="display: none;" />--%>
    <img id="img_grip" src="${path}/STATIC/image/grip.gif" />
    <div class="btn_box">
      <input type="hidden" name="imageUrl" id="imageUrl" value="${imageURL}"/>
      <input type="hidden" name="cut_pos" id="cut_pos" value="" />
      <input type="hidden" name="cutWidth" id="cutImageWidht" value=""/>
      <input type="hidden" name="cutHeight" id="cutImageHeigth" value=""/>
      <%--<input type="button" class="button" name="submit"  id="submit" value=" 确认裁剪并提交 " onclick="DragZoom.getCutPos()"/>&nbsp;--%>
      <%--<input type="button" class="button" name="submit"  id="submit" value=" 确认裁剪" onclick="submitForm()"/>&nbsp;--%>
      <input type="button" class="btn-save button" name="submit"  id="submit" value=" 确认裁剪"/>&nbsp;
      <%--<input type="button" class="btn-save button" name="submit"   value=" 应用页面" />&nbsp;--%>
      <input type="button" class="button" name="cancel"  id="cancel" value=" 取消裁剪 " onclick="cancleDialog();"/>
    </div>
  </div>
</form>
<script type="text/javascript" src="${path}/STATIC/js/jquery.min.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
<script language="javascript" type="text/javascript">
  //页面载入初始化
  var mdialog;
  function avatarInit(){
    var dialog = parent.dialog.get(window);
    mdialog = dialog;
    var data = dialog.data; // 获取对话框传递过来的数据

    var url = data.imageUrl;
    $("#cut_img").attr({"src": url, "width": data.initWidth, "height": data.initHeigth});
    var w = data.cutImageWidth;
    var h = data.cutImageHeigth;

    $("#imageUrl").val(url);
    $("#cutImageWidht").val(w);
    $("#cutImageHeigth").val(h);
    DragZoom.imageConfig({
      cutx: w,  //裁减宽度
      cuty: h,  //裁减高度
      imgdefw: data.initWidth,  //图片默认宽度
      imgdefh: data.initHeigth  //图片默认高度
    });
  }

  if (document.all){
    window.attachEvent('onload',avatarInit);
  }else{
    window.addEventListener('load',avatarInit,false);
  }
  document.onselectstart = new Function("return false");

  seajs.config({
    alias: {
      "jquery": "${path}/STATIC/js/dialog/lib/jquery-1.10.2.js"
    }
  });

  seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
    window.dialog = dialog;
  });



  window.console = window.console || {log:function () {}}
  seajs.use(['jquery'], function ($) {
    $(function () {
      var dialog = parent.dialog.get(window);
      mdialog = dialog;
      var data = dialog.data; // 获取对话框传递过来的数据

      $(".btn-save").on("click", function(){
      DragZoom.getCutPos()
      $.post("${path}/att/sliceImg.do", $("#submitCutIamge").serialize(),
              function(data){
                var json = $.parseJSON(data);
                var url=json.url;
                // var imgUrl = getImgUrl(url);
                $("#imageUrl").val(url);

                $("#cut_img").attr("src",url);

                var imageUrl = $("#imageUrl").val();
                var returnData = {"imageUrl": imageUrl,"isCutImg":'Y'};
                //  }
                dialog.close(returnData).remove();

              });

      });


//      /*点击确定按钮*/
//      $(".btn-save").on("click", function(){
//        var imageUrl = $("#imageUrl").val();
//        var returnData = {"imageUrl": imageUrl};
//        //  }
//        dialog.close(returnData).remove();
//      })
  });
});


  function cancleDialog(){

    mdialog.close().remove();
  }

  function submitForm(){
    DragZoom.getCutPos();
    $.post("${path}/att/sliceImg.do", $("#submitCutIamge").serialize(),
            function(data){
              var json = $.parseJSON(data);
              var url=json.url;
             // var imgUrl = getImgUrl(url);
              $("#imageUrl").val(url);

              $("#cut_img").attr("src",url);

            });


  }
</script>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="s" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <title>添加场馆--文化云</title>

  <%@include file="../../common/pageFrame.jsp"%>
  <!--文本编辑框 end-->
  <!-- dialog start -->
  <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
  <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
  <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>

  <script type="text/javascript" src="${path}/STATIC/js/admin/culture/addCulture.js"></script>
<%--  <script type="text/javascript" src="${path}/STATIC/js/admin/venue/UploadVenueAudio.js"></script>--%>
 <%--  <script type="text/javascript" src="${path}/STATIC/js/admin/venue/addVenue.js"></script>--%>
  <script type="text/javascript">

    window.onload = function(){
      var editor = CKEDITOR.replace( 'venueMemo' );
    }

    seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
      window.dialog = dialog;
    });

    window.console = window.console || {log:function () {}}

    // 省市区
    function getArea(){
      var venueProvince='${user.userProvince}';
      var venueCity='${user.userCity}';
      var venueArea='${user.userCounty}';
      if(venueProvince!=undefined && venueCity!=undefined && venueArea!=undefined){
        //省市区
        showVenueLocation(venueProvince.split(",")[0],venueCity.split(",")[0],venueArea.split(",")[0]);
        $("#loc_province").select2("val", venueProvince.split(",")[0]);
        $("#loc_city").select2("val", venueCity.split(",")[0]);
        $("#loc_town").select2("val",  venueArea.split(",")[0]);
      }else {
        showVenueLocation();
      }

      var userIsManger = '${user.userIsManger}';
      if(userIsManger!=undefined&&userIsManger == 1){ // 省级管理员
        $("#locProvinceDiv").show();
        $("#loc_province").attr("disabled", true);
        $("#locCityDiv").show();
        $("#locTownDiv").show();
      }else if(userIsManger!=undefined&&userIsManger == 2){ // 市级管理员
        $("#locProvinceDiv").show();
        $("#locCityDiv").show();
        $("#locTownDiv").show();
        $("#loc_province").attr("disabled", true);
        $("#loc_city").attr("disabled", true);
      }else{ // 区级管理员和场馆级管理员
        $("#locProvinceDiv").show();
        $("#locCityDiv").show();
        $("#locTownDiv").show();
        $("#loc_province").attr("disabled", true);
        $("#loc_city").attr("disabled", true);
        $("#loc_town").attr("disabled", true);
      }
    }

    function showVenueLocation(province , city , town) {
      var loc	= new Location();
      var title	= ['省' , '市' , '区'];
      $.each(title , function(k , v) {
        title[k]	= '<option value="">'+v+'</option>';
      });

      $('#loc_province').append(title[0]);
      $('#loc_city').append(title[1]);
      $('#loc_town').append(title[2]);

      $("#loc_province,#loc_city,#loc_town").select2();
      $('#loc_province').change(function() {
        $('#loc_city').empty();
        $('#loc_city').append(title[1]);
        loc.fillOption('loc_city' , '0,'+$('#loc_province').val());
        $('#loc_city').change()
      });

      $('#loc_city').change(function() {
        $('#loc_town').empty();
        $('#loc_town').append(title[2]);
        loc.fillOption('loc_town' , '0,' + $('#loc_province').val() + ',' + $('#loc_city').val());
      });

      $('#loc_town').change(function() {
        //$("#userId").val("");
        var userProvince = $("#loc_province").find("option:selected").val() +","+$("#loc_province").find("option:selected").text();
        var userCity = $("#loc_city").find("option:selected").val() +","+$("#loc_city").find("option:selected").text();
        var userArea = $("#loc_town").find("option:selected").val() +","+$("#loc_town").find("option:selected").text();
        // 位置字典根据区域变更
        //dictLocation($("#loc_town").find("option:selected").val());
      });

      if (province) {
        loc.fillOption('loc_province' , '0' , province);
        if (city) {
          loc.fillOption('loc_city' , '0,'+province , city);
          if (town) {
            loc.fillOption('loc_town' , '0,'+province+','+city , town);
          }
        }
      } else {
        loc.fillOption('loc_province' , '0');
      }
    }

    $(function() {
      //显示省市区信息
      getArea();

      //类型标签
  /*    $.post("${path}/tag/getChildTagByType.do?code=VENUE_TYPE", function(data) {
        var list = eval(data);
        var tagHtml = '';
        for (var i = 0; i < list.length; i++) {
          var obj = list[i];
          var tagId = obj.tagId;
          var tagName = obj.tagName;
          var cl = '';
          cl = 'class="cur"';
          tagHtml += '<a class="" onclick="setVenueSingle(\''
          + tagId + '\',\'venueType\')">' + tagName
          + '</a>';
        }
        $("#venueTypeLabel").html(tagHtml);
        tagSelectSingle("venueTypeLabel");
      });*/


      $.post(
              "${path}/sysdict/queryChildSysDictByDictCode.do",
              {
                'dictCode' : 'CULTURESYSTEM'
              },
              function(data) {
                if (data != '' && data != null) {
                  var list = eval(data);
                  var ulHtml='';
                  for (var i in data) {
                    var dict = list[i];
                    ulHtml += '<a class="" onclick="setVenueSingle(\''
                    + dict.dictId + '\',\'venueMood\')">' + dict.dictName
                    +'</a>';
                  }

                  $("#venueMoodLabel").html(ulHtml);
                  tagSelectSingle("venueMoodLabel");
                }
              }).success(function() {
                //selectModel();
              });

      $.post(
              "${path}/sysdict/queryChildSysDictByDictCode.do",
              {
                'dictCode' : 'CULTUREYEAR'
              },
              function(data) {
                if (data != '' && data != null) {
                  var list = eval(data);
                  var ulHtml='';
                  for (var i in data) {
                    var dict = list[i];
                    ulHtml += '<a class="" onclick="setVenueSingle(\''
                    + dict.dictId + '\',\'venueCrowd\')">' + dict.dictName
                    +'</a>';
                  }
                  $('#venueCrowdLabel').html(ulHtml);
                  tagSelectSingle("venueCrowdLabel");
                }
              }).success(function() {
                //selectModel();
              });

      $.post(
              "${path}/sysdict/queryChildSysDictByDictCode.do",
              {
                'dictCode' : 'CULTURETYPE'
              },
              function(data) {
                if (data != '' && data != null) {
                  var list = eval(data);
                  var ulHtml='';
                  for (var i in data) {
                    var dict = list[i];
                    ulHtml += '<a class="" onclick="setVenueSingle(\''
                    + dict.dictId + '\',\'venueType\')">' + dict.dictName
                    +'</a>';
                  }
                  $('#venueTypeLabel').html(ulHtml);
                  tagSelectSingle("venueTypeLabel");
                }
              }).success(function() {
                //selectModel();
              });

    });



    function setVenueDict(value,id){
      $("#"+id).val(value);
      $('#'+id).find('a').removeClass('cur');
    }

    function tagSelectDict(id) {
      /* tag标签选择 */

      $('#'+id).find('a').click(function() {
        $('#'+id).find('a').removeClass('cur');
        $(this).addClass('cur');
      });
    }


    //提交与发布草稿按钮对应事件
    $(function() {
      $(".btn-save").on("click", function(){
        var checkResult = checkSave();
        if(checkResult){
          $("#cultureState").val(2);
          $(".btn-save").unbind("click");
          $(".btn-publish").unbind("click");

          $("#venueProvince").val($("#loc_province").find("option:selected").val()+","+$("#loc_province").find("option:selected").text());
          $("#venueCity").val($("#loc_city").find("option:selected").val()+","+$("#loc_city").find("option:selected").text());
          $("#venueArea").val($("#loc_town").find("option:selected").val()+","+$("#loc_town").find("option:selected").text());
          //富文本编辑器
          $('#venueMemo').val(CKEDITOR.instances.venueMemo.getData());
          var html = "";
          $.post("${path}/culture/addCulture.do", $("#addVenueForm").serialize(),
                  function(data) {
                    if (data != "failure") {
                      html = "<h2>保存成功!</h2>";
                      dialogSaveDraft("提示", html, function(){
                        window.location.href = "${path}/culture/getList.do?cultureState=2";
                      })
                    }else if(data == "failure") {
                      html = "<h2>保存失败!</h2>";
                      dialogSaveDraft("提示", html, function(){
                        window.location.href = "${path}/culture/getList.do?cultureState=2";
                      })
                    }
                  });
        }
      });

      $(".btn-publish").on("click", function(){
        //检查字段是否满足格式
        var checkResult = checkSave();

        if(checkResult){
          $(".btn-save").unbind("click");
          $(".btn-publish").unbind("click");
          $("#cultureState").val(1);

          $("#venueProvince").val($("#loc_province").find("option:selected").val()+","+$("#loc_province").find("option:selected").text());
          $("#venueCity").val($("#loc_city").find("option:selected").val()+","+$("#loc_city").find("option:selected").text());
          $("#venueArea").val($("#loc_town").find("option:selected").val()+","+$("#loc_town").find("option:selected").text());
          //富文本编辑器
          $('#venueMemo').val(CKEDITOR.instances.venueMemo.getData());
          var html = "";
          $.post("${path}/culture/addCulture.do", $("#addVenueForm").serialize(),
                  function(data) {
                    if (data == "success") {
                      html = "<h2>发布成功!</h2>";
                      dialogSaveDraft("提示", html, function(){
                        window.location.href = "${path}/culture/getList.do?cultureState=1";
                      });

                    }else if(data == "failure") {
                      html = "<h2>发布失败!</h2>";
                      dialogSaveDraft("提示", html, function(){
                        window.location.href = "${path}/culture/getList.do?cultureState=1";
                      });
                    }
                  });
        }
      });


    });

  </script>
  <!-- dialog end -->
</head>
<body>
<div class="site">
  <em>您现在所在的位置：</em>非遗管理 &gt; 新建非遗
</div>
<div class="site-title">添加非遗</div>
<form method="post" id="addVenueForm">
  <%-- 基础路径 --%>
  <div class="main-publish">
    <table width="100%" class="form-table">
      <tr>
        <td width="100" class="td-title"><span class="red">*</span>非遗名称：</td>
        <td class="td-input" id="venueNameLabel">
          <input id="venueName" name="cultureName" type="text" class="input-text w510" maxlength="30"  />
          <span class="error-msg"></span>
        </td>
      </tr>

      <tr>
        <td width="100" class="td-title"><span class="red">*</span>上传封面：</td>
        <td class="td-upload" id="venueIconUrlLabel">
          <table>
            <tr>
              <td>
                <input type="hidden"  name="cultureImgurl" id="venueIconUrl" value="">
                <input type="hidden" name="uploadType" value="Img" id="uploadType"/>
                <div class="img-box">
                  <div  id="imgHeadPrev" class="img"> </div>
                </div>
                <div style="margin-left: 20px; display: inline-block; vertical-align: bottom;">
                  <div style="height: 46px;">
                    <div class="controls" style="float:left;">
                      <input type="file" name="file" id="file">
                    </div>

                    <span class="upload-tip">可上传1张图片，建议尺寸750*500像素，格式为jpg,jpeg,png,gif，大小不超过2M</span>

                  </div>
                  <div id="fileContainer"></div>
                  <div id="btnContainer" style="display: none;">
                    <a style="margin-left:335px;" href="javascript:clearQueue();" class="btn">取消</a>
                  </div>
                </div>
              </td>
            </tr>
          </table>
        </td>
      </tr>


      <tr>
        <td width="100" class="td-title"><span class="red">*</span>非遗标签：</td>
        <td class="td-tag" id="venueTagLabel">
          <dl>
            <dt>体系</dt>
            <input id="venueMood" name="cultureSystem" style="position: absolute; left: -9999px;" type="hidden"/>
            <dd id="venueMoodLabel">
            </dd>
          </dl>

          <dl>
            <dt>年代</dt>
            <input id="venueCrowd" name="cultureYears" style="position: absolute; left: -9999px;" type="hidden" value=""/>
            <dd id="venueCrowdLabel">
            </dd>
          </dl>

          <dl>
            <dt>类别</dt>
            <input id="venueType" name="cultureType" style="position: absolute; left: -9999px;" type="hidden" value=""/>
            <dd id="venueTypeLabel">
            </dd>
          </dl>


        </td>
      </tr>

      <tr>
        <td  class="td-title"><span class="red">*</span>所属省市区：</td>
        <td  class="td-select" id="venueLocLabel">
          <div id="locProvinceDiv">
            <select id="loc_province" style="width: 130px;"></select>
            <input type="hidden" name="cultureProvince" id="venueProvince" />
          </div>
          <div id="locCityDiv">
            <select id="loc_city"style="width: 130px; margin-left: 10px"></select>
            <input type="hidden" name="cultureCity" id="venueCity" />
          </div>
          <div id="locTownDiv">
            <select id="loc_town"style="width: 130px; margin-left: 10px"></select>
            <input type="hidden" name="cultureArea" id="venueArea" />
          </div>
        </td>
      </tr>


<%--      <tr>
        <td  class="td-title"><span class="red">*</span>所属省市区：</td>
        <td  class="td-select" id="venueLocLabel">
          <div id="locProvinceDiv">
            <select id="loc_province" style="width: 130px;"></select>
            <input type="hidden" name="cultureProvince" id="venueProvince" />
          </div>
          <div id="locCityDiv">
            <select id="loc_city"style="width: 130px; margin-left: 10px"></select>
            <input type="hidden" name="cultureCity" id="venueCity" />
          </div>
          <div id="locTownDiv">
            <select id="loc_town"style="width: 130px; margin-left: 10px"></select>
            <input type="hidden" name="cultureArea" id="venueArea" />
          </div>
        </td>
      </tr>--%>

      <tr>
        <td width="100" class="td-title">视频地址：</td>
        <td class="td-input">
          <input  name="cultureVediourl" type="text" class="input-text w510" maxlength="200"/>
          <span class="error-msg"></span>
        </td>
      </tr>

      <tr>
        <td width="100" class="td-title"></td>
        <td class="td-btn">
          <input class="btn-save" type="button" value="保存草稿"/>
          <input class="btn-publish" type="button" value="发布信息"/>
        </td>
      </tr>


    </table>
  </div>
<input type="hidden" name="cultureState" id="cultureState"/>
</form>

</body>
</html>

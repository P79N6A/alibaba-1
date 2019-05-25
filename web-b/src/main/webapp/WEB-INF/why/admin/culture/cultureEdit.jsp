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
  <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
  <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
  <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
  <script type="text/javascript" src="${path}/STATIC/js/admin/culture/addCulture.js"></script>
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
      var venueProvince='${c.cultureProvince}';
      var venueCity='${c.cultureCity}';
      var venueArea='${c.cultureArea}';
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
      $.post(
              "${path}/sysdict/queryChildSysDictByDictCode.do",
              {
                'dictCode' : 'CULTURESYSTEM'
              },
              function(data) {
                if (data != '' && data != null) {
                  var list = eval(data);
                  var ulHtml='';
                  var cl="";
                  var venueSys = '${c.cultureSystem}';
                  for (var i in data) {
                    var dict = list[i];
                    if(venueSys==dict.dictId){
                      cl="cur"
                    }else{
                      cl="";
                    }
                    ulHtml += '<a class="'+cl+'" onclick="setVenueSingle(\''
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
                  var cl="";
                  var venueYear = '${c.cultureYears}';
                  for (var i in data) {
                    var dict = list[i];
                    if(venueYear==dict.dictId){
                      cl="cur"
                    }else{
                      cl="";
                    }

                    ulHtml += '<a class="'+cl+'" onclick="setVenueSingle(\''
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
                  var cl="";
                  var venueType = '${c.cultureType}';
                  for (var i in data) {
                    var dict = list[i];
                    if(venueType==dict.dictId){
                      cl="cur"
                    }else{
                      cl="";
                    }
                    ulHtml += '<a class="'+cl+'" onclick="setVenueSingle(\''
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
        //检查字段是否满足格式
        var checkResult = checkSave();
        if(checkResult){
          //点击后使按钮失效
          $(".btn-save").unbind("click");
          $(".btn-publish").unbind("click");


          $("#venueProvince").val($("#loc_province").find("option:selected").val()+","+$("#loc_province").find("option:selected").text());
          $("#venueCity").val($("#loc_city").find("option:selected").val()+","+$("#loc_city").find("option:selected").text());
          $("#venueArea").val($("#loc_town").find("option:selected").val()+","+$("#loc_town").find("option:selected").text());

          //富文本编辑器
          $('#venueMemo').val(CKEDITOR.instances.venueMemo.getData());
          var html = "";
          $.post("${path}/culture/editCulture.do", $("#addVenueForm").serialize(),
                  function(data) {
                    if (data == "success") {
                      html="<h2>修改成功</h2>";
                      dialogSaveDraft("提示", html, function(){
                        window.location.href = "${path}/culture/getList.do?cultureState=${c.cultureState}";
                      })
                    }else if(data == "failure") {
                      html = "<h2>修改失败!</h2>";
                      dialogSaveDraft("提示", html, function(){
                        window.location.href = "${path}/culture/getList.do?cultureState=${c.cultureState}";
                      })
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
          <input id="venueName" name="cultureName" value="${c.cultureName}" type="text" class="input-text w510" maxlength="30"/>
          <span class="error-msg"></span>
        </td>
      </tr>

      <tr>
        <td width="100" class="td-title"><span class="red">*</span>上传封面：</td>
        <td class="td-upload" id="venueIconUrlLabel">
          <table>
            <tr>
              <td>
                <input type="hidden"  name="cultureImgurl" id="venueIconUrl" value="${c.cultureImgurl}">
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
            <input id="venueMood" name="cultureSystem" style="position: absolute; left: -9999px;" type="text" value="${c.cultureSystem}"/>
            <dd id="venueMoodLabel">
            </dd>
          </dl>

          <dl>
            <dt>年代</dt>
            <input id="venueCrowd" name="cultureYears" style="position: absolute; left: -9999px;" type="text" value="${c.cultureYears}"/>
            <dd id="venueCrowdLabel">
            </dd>
          </dl>

          <dl>
            <dt>类别</dt>
            <input id="venueType" name="cultureType" style="position: absolute; left: -9999px;" type="text" value="${c.cultureType}"/>
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
            <input type="hidden" name="cultureProvince" id="venueProvince" value="${c.cultureProvince}" />
          </div>
          <div id="locCityDiv">
            <select id="loc_city"style="width: 130px; margin-left: 10px"></select>
            <input type="hidden" name="cultureCity" id="venueCity"  value="${c.cultureCity}" />
          </div>
          <div id="locTownDiv">
            <select id="loc_town"style="width: 130px; margin-left: 10px"></select>
            <input type="hidden" name="cultureArea" id="venueArea" value="${c.cultureArea}" />
          </div>
        </td>
      </tr>


      <tr>
        <td width="100" class="td-title">视频地址：</td>
        <td class="td-input">
          <input  name="cultureVediourl" type="text" class="input-text w510" maxlength="200" value="${c.cultureVediourl}"/>
          <span class="error-msg"></span>
        </td>
      </tr>


      <tr>
        <td width="100" class="td-title"><span class="red">*</span>非遗描述：</td>
        <td class="td-content" id="venueMemoLabel">
          <div class="editor-box">
            <textarea name="cultureDes" id="venueMemo">${c.cultureDes}</textarea>
          </div>
        </td>
      </tr>
      <tr>
        <td width="100" class="td-title"></td>
        <td class="td-btn">
          <input class="btn-save" type="button" value="保存"/>
          <input class="btn-publish" type="button" value="返回" onclick="window.history.go(-1)" />
        </td>
      </tr>
    </table>
  </div>
    <input type="hidden" name="cultureId" value="${c.cultureId}"  />
    <input type="hidden" name="cultureState" id="cultureState" value="${c.cultureState}" />
</form>

</body>
</html>

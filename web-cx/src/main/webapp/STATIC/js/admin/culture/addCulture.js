$(function () {
  var type=$("#uploadType").val();
  $("#file").uploadify({
    'formData':{'uploadType':type,'type':3},//传静态参数
    swf:'../STATIC/js/uploadify.swf',
    uploader:'../upload/uploadFile.do', //后台处理的请求
    buttonText:'上传封面',//上传按钮的文字
    'fileSizeLimit':'2MB',
    'buttonClass':"upload-btn",//按钮的样式
    queueSizeLimit:1, //   default 999
    'method': 'post',//和后台交互的方式：post/get
    queueID:'fileContainer',
    fileObjName:'file', //后台接受参数名称
    fileTypeExts:'*.gif;*.png;*.jpg;*.jpeg;', //控制可上传文件的扩展名，启用本项时需同时声明fileDesc
    'auto':true, //true当选择文件后就直接上传了，为false需要点击上传按钮才上传
    'multi':false, //是否支持多个附近同时上传
    height:44,//选择文件按钮的高度
    width:100,//选择文件按钮的宽度
    'debug':false,//debug模式开/关，打开后会显示debug时的信息
    'dataType':'json',
    removeCompleted:false,//上传成功后的文件，是否在队列中自动删除
    onUploadSuccess:function (file, data, response) {
      var json = $.parseJSON(data);
      var url=json.data;
      $("#venueIconUrl").val(url);
      $("#btnContainer").show();
      getImg();
    },
    onSelect:function () { //插件本身没有单文件上传之后replace的效果
      var notLast = $('#fileContainer').find('div.uploadify-queue-item').not(':last');
      notLast.remove();
      $('#btnContainer').show();
    },
    onCancel:function () {
      $('#btnContainer').hide();
    }
  });
});
function clearQueue() {
  $('#file').uploadify('cancel', '*');
  $('#btnContainer').hide();
  $("#venueIconUrl").val('');
  $("#imgHeadPrev").html("<img src='../STATIC/image/defaultImg.png' id='userHeadImg'>");
}
function uploadQueue() {
  $('#file').uploadify('upload','*');
}

$(function(){
  //初始化获取图片
  getImg();
});

//编辑后获取图片
getImg=function(){
  var imgUrl=$("#venueIconUrl").val();
  if(imgUrl == undefined || imgUrl == ""){
    $("#imgHeadPrev").html("<img src='../STATIC/image/defaultImg.png' id='userHeadImg'>");
  }else{
    imgUrl = getImgUrl(imgUrl);
    imgUrl = getIndexImgUrl(imgUrl,"_300_300")
    $("#imgHeadPrev").html("<img style='width:300px; height:200px;' src='"+imgUrl+"'>");
  }
};





$(function(){
  // 全选
/*  $("#selectAll").bind("click", function () {
    if($(this).attr("checked")){
      $(".td-checkbox input[type='checkbox']").each(function(){
        $(this).attr("checked",true);
      });
    }else{
      $(".td-checkbox input[type='checkbox']").each(function(){
        $(this).attr("checked",false);
      });
    }
  });*/

  //控制全选、反选
/*  $(".td-checkbox input[type='checkbox']").bind("click",function(){

   var result = false;
   $(".td-checkbox input[type='checkbox']").each(function(){
   var value = $(this).val();
   if(value == 1 && !$(this).attr("checked")){
   result = true;
   }
   });
   if(result){
   $("#selectAll").attr("checked",false);
   }else{
   $("#selectAll").attr("checked",true);
   }
   });*/
});



//选择关键字标签时，赋值
function setVenueTag(value,id) {

  var tagIds = $("#"+id).val();
  if (tagIds != '') {
    var ids = tagIds.substring(0, tagIds.length - 1).split(",");
    var data = '', r = true;
    for (var i = 0; i < ids.length; i++) {
      if (ids[i] == value) {
        r = false;
      } else {
        data = data + ids[i] + ',';
      }
    }
    if (r) {
      data += value + ',';
    }
    $("#"+id).val(data);
  } else {
    $("#"+id).val(value + ",");
  }
}

//标签选择时更改样式
function tagSelect(id) {
  /* tag标签选择 */
  $('#'+id).find('a').click(function() {
    if ($(this).hasClass('cur')) {
      $(this).removeClass('cur');
    } else {
      $(this).addClass('cur');
    }
  });
}

/**
 * 单选
 * @param value
 * @param id
 */
function setVenueSingle(value,id){
  $("#"+id).val(value);
  $('#'+id).find('a').removeClass('cur');
}

/**
 * 单选
 * @param id
 */
function tagSelectSingle(id) {
  /* tag标签选择 */

  $('#'+id).find('a').click(function() {
    $('#'+id).find('a').removeClass('cur');
    $(this).addClass('cur');
  });
}

//添加非遗数据时进行数据校验
function checkSave(){
  var result = true;
  var venueName = $("#venueName").val();
  var venueIconUrl = $("#venueIconUrl").val();


  var venueType = $("#venueType").val();
  var venueCrowd = $("#venueCrowd").val();
  var venueMood = $("#venueMood").val();

  var venueArea = $("#loc_town").find("option:selected").val()+","+$("#loc_town").find("option:selected").text();

  if(venueName.trim() == ""){
    removeMsg("venueNameLabel");
    appendMsg("venueNameLabel", "请填写非遗名称!");
    $('#venueName').focus();
    return false;
  }else{
    removeMsg("venueNameLabel");
  }

  if(venueIconUrl.trim() == ""){
    removeMsg("venueIconUrlLabel");
    appendMsg("venueIconUrlLabel", "请上传非遗封面!");
    $('#venueIconUrl').focus();
    return false;
  }else{
    removeMsg("venueIconUrlLabel");
  }

  if(venueMood.trim() == ""){
    removeMsg("venueMoodLabel");
    appendMsg("venueMoodLabel", "请选择非遗体系!");
    $('#venueMood').focus();
    return false;
  }else{
    removeMsg("venueMoodLabel");
  }

  if(venueCrowd.trim() == ""){
    removeMsg("venueCrowdLabel");
    appendMsg("venueCrowdLabel", "请选择非遗人年代!");
    $('#venueCrowd').focus();
    return false;
  }else{
    removeMsg("venueTagLabel");
  }


  if(venueType.trim() == ""){
    removeMsg("venueTypeLabel");
    appendMsg("venueTypeLabel", "请选择非遗类型!");
    $('#venueType').focus();
    return false;
  }else{
    removeMsg("venueTagLabel");
  }



  if(venueArea.trim() == ",区"){
    removeMsg("venueLocLabel");
    appendMsg("venueLocLabel", "请填写非遗省市区!");
    $('#venueArea').focus();
    return false;
  }else{
    removeMsg("venueLocLabel");
  }


  var venueMemo = CKEDITOR.instances.venueMemo.getData();
  if(venueMemo.trim() == ""){
    removeMsg("venueMemoLabel");
    appendMsg("venueMemoLabel", "请填写非遗描述!");
    $('#venueMemo').focus();
    return false;
  }else{
    removeMsg("venueMemoLabel");
  }

  return result;
}








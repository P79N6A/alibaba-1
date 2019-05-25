<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>个人中心-我的团体--文化云</title>
  <!-- 导入头部文件 start -->
  <%@include file="/WEB-INF/why/common/frontPageFrame.jsp"%>
  <!--富文本编辑器 start-->
  <script type="text/javascript" src="${path}/STATIC/js/ckeditor/ckeditor.js"></script>
  <script type="text/javascript" src="${path}/STATIC/js/ckeditor/sample.js"></script>

  <!--富文本编辑器 end-->

  <script type="text/javascript">
    //富文本编辑器
    window.onload = function(){
      var editor = CKEDITOR.replace('tuserTeamRemark');
    }

    $(function(){
      $('#group').addClass('cur').siblings().removeClass('cur');

      getTags();
    });

    function getSelectTag(){

    }

    //选择关键字标签时，赋值
    function setTag(id) {
      var tagIds = $("#tagIds").val();
      if (tagIds != '') {
        var ids = tagIds.substring(0, tagIds.length).split(",");
        var data = '', r = true;
        for (var i = 0; i < ids.length; i++) {
          if (ids[i] == id) {
            r = false;
          } else {
            data = data + ids[i] + ',';
          }
        }
        if (r) {
          data += id + ',';
        }
        $("#tagIds").val(data);
      } else {
        $("#tagIds").val(id + ",");
      }
    }

    // 保存修改
    function saveTeamUser(){
      //富文本编辑器
      $('#tuserTeamRemark').val(CKEDITOR.instances.tuserTeamRemark.getData());
      var tuserCrowdTag = $("#teamUserCrowd").val();
      var tuserPropertyTag = $("#teamUserProperty").val();
      var tuserSiteTag = $("#teamUserSite").val();
      //var tuserTeamRemark = $("#tuserTeamRemark").val();

      // 团体个数失去焦点时判断数量小于等于最大上限
      if($("#num").val() < ${count}){
        dialogAlert("提示","成员上限不能小于当前团体的会员数量!");
        return;
      }

      if($("#tagIds").val() == ""){
        dialogAlert("提示","团体个性必须选择！");
        return;
      }

      if($.trim(tuserCrowdTag) == "" && $.trim(tuserPropertyTag) == "" && $.trim(tuserSiteTag) == ""){
        dialogAlert("提示","团体个性必选一个!");
        return;
      }

      /*if(CKEDITOR.instances.tuserTeamRemark.document.getBody().getText().length > 200){
        dialogAlert("提示","最多200个字!");
        return;
      }*/
      $("#userGroupEditForm").submit();
    }

    function getTags(){
      //人群标签
      $.post("${path}/tag/getChildTagByType.do?code=TEAMUSER_CROWD", function(data) {
        var list = eval(data);
        var tagHtml = '';
        var tagIds = $("#teamUserCrowd").val();
        var ids = '';
        if (tagIds.length > 0) {
          ids = tagIds.substring(0, tagIds.length - 1).split(",");
        }
        for (var i = 0; i < list.length; i++) {
          var obj = list[i];
          var tagId = obj.tagId;
          var tagName = obj.tagName;
          var result = false;
          if (ids != '') {
            for (var j = 0; j <ids.length; j++) {
              if (tagId == ids[j]) {
                result = true;
                break;
              }
            }
          }
          var cl = '';
          if (result) {
            cl = 'class="r_on"';
          }else{
            cl = 'class="r_off"';
          }
          tagHtml += '<label '+cl+'><input type="checkbox" onclick="setTeamUserTag(\''+ tagId + '\',\'teamUserCrowd\')"/>'+tagName+'</label>';
        }
        $("#teamUserCrowdLabel").html(tagHtml);
      });

      //属性标签
      $.post("${path}/tag/getChildTagByType.do?code=TEAMUSER_PROPERTY", function(data) {
        var list = eval(data);
        var tagHtml = '';
        var tagIds = $("#teamUserProperty").val();
        var ids = '';
        if (tagIds.length > 0) {
          ids = tagIds.substring(0, tagIds.length - 1).split(",");
        }
        for (var i = 0; i < list.length; i++) {
          var obj = list[i];
          var tagId = obj.tagId;
          var tagName = obj.tagName;
          var result = false;
          if (ids != '') {
            for (var j = 0; j <ids.length; j++) {
              if (tagId == ids[j]) {
                result = true;
                break;
              }
            }
          }
          var cl = '';
          if (result) {
            cl = 'class="r_on"';
          }else{
            cl = 'class="r_off"';
          }
          tagHtml += '<label '+cl+'><input type="checkbox" onclick="setTeamUserTag(\''+ tagId + '\',\'teamUserProperty\')"/>'+tagName+'</label>';
        }
        $("#teamUserPropertyLabel").html(tagHtml);
      });

      //地点标签
      $.post("${path}/tag/getChildTagByType.do?code=TEAMUSER_SITE", function(data) {
        var list = eval(data);
        var tagHtml = '';
        var tagIds = $("#teamUserSite").val();
        var ids = '';
        if (tagIds.length > 0) {
          ids = tagIds.substring(0, tagIds.length - 1).split(",");
        }
        for (var i = 0; i < list.length; i++) {
          var obj = list[i];
          var tagId = obj.tagId;
          var tagName = obj.tagName;
          var result = false;
          if (ids != '') {
            for (var j = 0; j <ids.length; j++) {
              if (tagId == ids[j]) {
                result = true;
                break;
              }
            }
          }
          var cl = '';
          if (result) {
            cl = 'class="r_on"';
          }else{
            cl = 'class="r_off"';
          }
          tagHtml += '<label '+cl+'><input type="checkbox" onclick="setTeamUserTag(\''+ tagId + '\',\'teamUserSite\')"/>'+tagName+'</label>';
        }
        $("#teamUserSiteLabel").html(tagHtml);
      });

      // 位置字典
      $.post("${path}/sysdict/queryChildSysDictByDictCode.do",{dictCode:'${fn:substringBefore(teamUser.tuserCounty,",")}'}, function(data) {
        var list = eval(data);
        var dictHtml = '';
        var other = '';
        var tid = $("#teamUserLocation").val();
        for (var i = 0; i < list.length; i++) {
          var obj = list[i];
          var dictId = obj.dictId;
          var dictName = obj.dictName;
          var result = false;
          if (tid == dictId) {
            result = true;
          }
          var cl = '';
          if (result) {
            cl = 'class="r_on"';
          }else{
            cl = 'class="r_off"';
          }

          if(dictName == '其他'){
            other = '<label '+cl+'><input type="checkbox" onclick="setTeamUserDict(\'' + dictId + '\',\'teamUserLocation\')"/>'+dictName+'</label>';
          }else{
            dictHtml += '<label '+cl+'><input type="checkbox" onclick="setTeamUserDict(\'' + dictId + '\',\'teamUserLocation\')"/>'+dictName+'</label>';
          }
        }
       /* if(dictHtml != ""){
          if(tid == "" || tid == null){
            dictHtml += '<label class="r_on"><input type="checkbox" onclick="setTeamUserDict(\'\',\'teamUserLocation\')"/>全部</label>';
          }else{
            dictHtml += '<label class="r_off"><input type="checkbox" onclick="setTeamUserDict(\'\',\'teamUserLocation\')"/>全部</label>';
          }
        }*/
        dictHtml += other;
        $("#teamUserLocationLabel").html(dictHtml);
        tagSelectDict("teamUserLocationLabel");
      });
    }

    function setTeamUserDict(value,id){
      $("#"+id).val(value);
    }

    function tagSelectDict(id) {
      /* tag标签选择 */
      $('#'+id).find('input').click(function() {
        $('#'+id).find('label').removeClass('r_on');
      });
    }
    //选择关键字标签时，赋值
    function setTeamUserTag(value,id) {
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
  </script>
</head>
<body>

<%--引入个人中心头文件--%>
<%@include file="/WEB-INF/why/index/index_top.jsp"%>

<div class="crumbs"><i></i>您所在的位置： <a href="#">个人主页</a> &gt; 我的团体</div>
<div class="activity-content user-content clearfix">

  <%--引入个人中心左边菜单--%>
  <%@include file="user_center_left.jsp"%>

  <div class="user-right fr">
    <div class="user-tab">
      <c:if test="${sessionScope.terminalUser.userType == 2}">
        <a href="${path}/frontTeamUser/userGroupIndex.do" class="cur">我管理的团体</a>
      </c:if>
      <a href="${path}/frontTeamUser/userGroupJoin.do">我加入的团体</a>
      <a href="${path}/frontTeamUser/userGroupHistory.do">历史记录</a>
    </div>
    <div class="user-part">
      <div class="member-manage auditing-manage">
        <h2>编辑团体信息</h2>
        <div class="edit-group">
          <div class="tit">
            <span>团体名称：${teamUser.tuserName}</span>
            <em>创建时间： <fmt:formatDate value="${teamUser.tCreateTime}" pattern="yyyy-MM-dd HH:mm" /></em>
          </div>
          <div class="edit-info clearfix">
            <form action="${path}/frontTeamUser/saveUserGroupEdit.do" id="userGroupEditForm">
              <input type="hidden" name="tuserId" value="${teamUser.tuserId}"/>
              <div class="box1 clearfix">
                <div class="img fl">
                  <input type="hidden"  name="tuserPicture" id="tuserPicture" value="${teamUser.tuserPicture}">
                  <input type="hidden"  name="uploadType" value="Img" id="uploadType"/>
                    <span>
                        <img id="imgHeadPrev"  width="80" height="80">
                        <span id="fileContainer"></span>
                        <input type="file" name="file" id="file">
                     </span>
                </div>
                <div class="info-r fr">
                  <dl>
                    <dt>成员上限：</dt>
                    <dd><input class="num" type="text" value="${teamUser.tuserLimit}" name="tuserLimit" id="num" onkeyup="this.value=this.value.replace(/\D/g,'')"/>人</dd>
                  </dl>
                  <dl>
                    <dt>团体标签：</dt>
                    <dd class="type checkBtn">
                      <table style="width: auto">
                        <tr>
                          <td width="50">人群<input id="teamUserCrowd" name="tuserCrowdTag" type="hidden" value="${teamUser.tuserCrowdTag}"/></td>
                          <td id="teamUserCrowdLabel" style="width: auto;"></td>
                        </tr>
                        <tr>
                          <td width="50">属性<input id="teamUserProperty" name="tuserPropertyTag" type="hidden" value="${teamUser.tuserPropertyTag}"/></td>
                          <td id="teamUserPropertyLabel"></td>
                        </tr>
                        <tr>
                          <td width="50">地点<input id="teamUserSite" name="tuserSiteTag" type="hidden" value="${teamUser.tuserSiteTag}"/></td>
                          <td id="teamUserSiteLabel"></td>
                        </tr>
                        <tr>
                          <td width="50">位置<input id="teamUserLocation" name="tuserLocationDict" type="hidden" value="${teamUser.tuserLocationDict}"/></td>
                          <td id="teamUserLocationLabel"></td>
                        </tr>
                      </table>
                    </dd>
                  </dl>
                  <dl>
                    <dt>团体简介：</dt>
                    <dd class="des">
                      <div style="width:600px;margin-bottom: 10px;">
                        <textarea name="tuserTeamRemark" id="tuserTeamRemark">${teamUser.tuserTeamRemark}</textarea>
                      </div><%--<span class="lightred">200字内</span>--%>
                    </dd>
                  </dl>
                </div>
              </div>
              <div class="box2">
                <input type="button" value="保存修改" class="btn-saveEdit" onclick="saveTeamUser()"/>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<%@include file="../index_foot.jsp"%>
<script type="text/javascript" src="${path}/STATIC/js/jquery.uploadify-3.1.min.js"></script>
<script type="text/javascript">
  $(document).ready(function(){
    getPicture();
    uploadImage();
  });
  function uploadImage(){


    var Img=$("#uploadType").val();
    $("#file").uploadify({
      'formData':{'uploadType':Img},//传静态参数
      swf:'${path}/STATIC/js/uploadify.swf',
      uploader:'${path}/upload/frontUploadFile.do;jsessionid=${pageContext.session.id}', //后台处理的请求
      buttonText:'修改形象',//上传按钮的文字
      'buttonClass':"upload-btn",//按钮的样式
      queueSizeLimit:1, //   default 999
      'method': 'post',//和后台交互的方式：post/get
      queueID:'fileContainer',
      fileObjName:'file', //后台接受参数名称
      fileTypeExts:'*.*', //控制可上传文件的扩展名，启用本项时需同时声明fileDesc
      'auto':true, //true当选择文件后就直接上传了，为false需要点击上传按钮才上传
      //'multi':true, //是否支持多个附近同时上传
      height:25,//选择文件按钮的高度
      width:70,//选择文件按钮的宽度
      'debug':false,//debug模式开/关，打开后会显示debug时的信息
      'dataType':'json',
      removeCompleted:false,//上传成功后的文件，是否在队列中自动删除
      onUploadSuccess:function (file, data, response) {
        var json = $.parseJSON(data);
        var url=json.data;
        var imgUrl = getImgUrl(url);
        $("#tuserPicture").val(url);
        $("#imgHeadPrev").attr("src",imgUrl);
        //隐藏该区域
        $(".uploadify-queue-item").hide();
        //$("#fileContainer").hide();
      },
      onSelect:function () {
      },
      onCancel:function () {
        //$('#btnContainer').hide();
      }
    });
  }

  function getPicture(){
    var imgUrl = $("#tuserPicture").val();
    if(imgUrl!=""){
      imgUrl = getImgUrl(imgUrl);
      imgUrl = getIndexImgUrl(imgUrl,"_300_300");
      $("#imgHeadPrev").attr("src",imgUrl);
    }
  }
</script>


</body>
</html>
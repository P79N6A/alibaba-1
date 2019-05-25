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
      <link rel="stylesheet" href="${path}/STATIC/zTree_v3/css/zTreeStyle/zTreeStyle.css"/>
      <style type="text/css">
          .demo{width:80%; margin:20px auto}
          .demo h3{height:32px; line-height:32px}
          .demo p{line-height:24px}
          pre{margin-top:10px; padding:6px; background:#f7f7f7}
      </style>
      <%--<script type="text/javascript" src="${path}/STATIC/js/jquery.min.js"></script>--%>

      <script type="text/javascript" src="${path}/STATIC/zTree_v3/js/jquery.ztree.core-3.5.js"></script>
      <script type="text/javascript" src="${path}/STATIC/zTree_v3/js/jquery.ztree.excheck-3.5.js"></script>
      <script type="text/javascript" src="${path}/STATIC/zTree_v3/js/jquery.ztree.exedit-3.5.js"></script>
      <script type="text/javascript" src="${path}/STATIC/js/layer.js"></script>

  <%--<script type="text/javascript" src="${path}/STATIC/js/layer.ext.js"></script>--%>
      <!-- end -->


      <SCRIPT type="text/javascript">
          var index = parent.layer.getFrameIndex(window.name)
          $(document).ready(function(){
              //给父页面传值
              $('#transmit').on('click', function(){
                  parent.$('#venueParentDeptName').val($("#venueParentDeptName").val());
                  parent.$('#venueParentDeptId').val($("#venueParentDeptId").val());
                  parent.layer.close(index);
              });

              //关闭iframe
              $('#closeIframe').click(function(){
                  parent.layer.close(index);
              });

          });

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
              $("#venueParentDeptId").val(treeNode.deptId);
              $("#venueParentDeptName").val(treeNode.deptName);
          }
          var zNodes;

          var code;
          function setCheck() {

              var type = $("#level").attr("checked")? "level":"all";
              setting.check.radioType = type;
              showCode('setting.check.radioType = "' + type + '";');
              var type = '${type}';
              $.ajax({
                  type: 'POST',
                  dataType : "json",
                  data:{type:type}, //此处添加data参数也是方便新建场馆选择部门
                  url: "${path}/user/getDeptList.do",//请求的action路径
                  error: function () {//请求失败处理函数
                      alert('请求失败');
                  },
                  success:function(data){ //请求成功后处理函数。
                      var t = $("#treeDemo");
                      zNodes = eval(data);
                      $.fn.zTree.init($("#treeDemo"), setting, zNodes);

                  }
              });

          }
          function showCode(str) {
              if (!code) code = $("#code");
              code.empty();
              code.append("<li>"+str+"</li>");
          }

          $(document).ready(function(){
              setCheck();
              $("#level").bind("change", setCheck);
              $("#all").bind("change", setCheck);
          });
          //-->
      </SCRIPT>
    <style type="text/css">
        body{ min-width: 450px;}
        #transmit,#closeIframe{ padding: 6px 12px; margin: 0 4px;}
    </style>
  </head>
  <body>

  <table width="100%">
      <form> <input type="hidden" name="venueParentDeptId" id="venueParentDeptId"/>
          <input type="hidden" name="venueParentDeptName" id="venueParentDeptName"/>

      <tr><td>
              <div class="content_wrap">
                  <div class="zTreeDemoBackground left">
                      <ul id="treeDemo" class="ztree"></ul>
                  </div>
              </div>
      </td></tr>
      <tr>
          <td align="center">
          <div style="align-content: center">
              <ul style="margin: 0 auto;">
                  <button id="transmit">确定</button>
                  <button id="closeIframe" onclick="javascript:windows.colse()">关闭</button>
              </ul>
          </div>
         </td>
      </tr>

      </form>
  </table>
  </body>
</html>

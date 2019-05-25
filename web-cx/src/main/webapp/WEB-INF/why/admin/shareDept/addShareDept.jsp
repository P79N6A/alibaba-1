<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="s" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>

<title>添加信息共享--文化云</title>
<%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
<link rel="stylesheet" href="${path}/STATIC/zTree_v3/css/demo.css" type="text/css">
<link rel="stylesheet" href="${path}/STATIC/zTree_v3/css/zTreeStyle/zTreeStyle.css"/>
<script type="text/javascript" src="${path}/STATIC/zTree_v3/js/jquery.ztree.core-3.5.js"></script>
<script type="text/javascript" src="${path}/STATIC/zTree_v3/js/jquery.ztree.excheck-3.5.js"></script>
<script type="text/javascript" >

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
              onCheck: zTreeOnCheck
          }
      };
      
      function zTreeOnCheck(event, treeId, treeNode){
          $("#targetDeptid").val(treeNode.deptId);
      }

      var code;
      function setCheck() {
          $.ajax({
              type: 'POST',
              dataType : "json",
              url: "${path}/dept/getBroDeptList.do",//请求的action路径
              error: function () {//请求失败处理函数
                  alert('请求失败');
              },
              success:function(data){ //请求成功后处理函数。
            	  var t = $("#treeDemo");
                  treeNodes = eval(data);
                  t = $.fn.zTree.init(t, setting, treeNodes);
              }
          });

      }

      $(document).ready(function(){
    	  setCheck();
      });

      function doSubmit(){
    	  var targetDeptid = $("#targetDeptid").val();
    	  if(targetDeptid==null||targetDeptid==""){
    		  dialogAlert("评论提示", "请选择共享部门");
    		  return;
    	  }
		  $.post("${path}/shareDept/addShareDept.do", $("#shareDeptForm").serialize(),
		        function(data) {
		            $(this).attr("disabled", false);
		            if (data!=null&&data==1) {
		            	dialogAlert('系统提示', '添加成功！',function (r){
		            		window.location.href="${path}/shareDept/shareDeptIndex.do";
		            	});
		            }else{
		                dialogAlert('系统提示', '添加失败！');
		            }
		   });
      }
</script>

</head>
<body>
  <form action="" id="shareDeptForm" method="post">
  	<input type="hidden" name="targetDeptid" id="targetDeptid"/>
      <div class="site">
          <em>您现在所在的位置：</em>站点管理 &gt; 添加信息共享
      </div>
      <div class="">
	      <div class="">
	          <ul id="treeDemo" class="ztree"></ul>
	      </div>
	  </div>
	  <div class="form-table" style="margin-left: 100px;">
		  <div class="td-btn">
		  	  <input type="button" value="保存" class="btn-save" onclick="javascript:return doSubmit();"/>
	          <input type="button" value="返回" class="btn-publish" onclick="javascript:history.back(-1)"/>
		  </div>
	  </div>
  </form>
</body>
</html>

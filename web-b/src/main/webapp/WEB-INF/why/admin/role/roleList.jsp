<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>

   <script type="text/javascript">
          function roleSubmit(obj){
              $(obj).attr("disabled","disabled");
              $.ajax({
                  type:"post",
                  url:"${path}/userRole/saveUserRole.do",
                  async:true,
                  data:$("#roleForm").serialize(),
                  success :function(result){
                      if(result == "success"){
                          dialogSaveDraft("提示", "角色分配成功,退出重新登录后生效");
                      }else{
                          dialogSaveDraft("提示", "保存失败");
                      }
                      $(obj).removeAttr("disabled");
                  }
              });
       }
   </script>

  </head>

  <body>
  <div class="site">
      <em>您现在所在的位置：</em>用户管理 &gt; 角色分配
  </div>
  <!-- 正中间panel -->
  <div id="main-content">
      <form id="roleForm">
          <input type="hidden" value="${userId}" name="userId"/>
          <table class="form-table" width="100%">
              <tr>
                  <td width="100"></td>
                  <td class="td-checkbox">
                      <c:forEach items="${sysRoles}" var="sysRole">
                          <div style="text-align: left;width: 300px;float: left">
                              <label><input type="checkbox" value="${sysRole.roleId}" name="roleId"
                                      <c:forEach items="${myRoles}" var="role">
                                          <c:if test="${role.roleId == sysRole.roleId}"> checked </c:if>
                                      </c:forEach>/>${sysRole.roleName}</label>
                          </div>
                      </c:forEach>
                  </td>
              </tr>
              <tr>
                  <td></td>
                  <td class="td-btn">
                      <input type="button" class="btn-save" value="保存" onclick="roleSubmit(this)"/>
                      <input type="button" class="btn-publish" value="返回" onclick="javascript:history.back(-1)"/>
                  </td>
              </tr>
          </table>
      </form>
  </div>


  </body>
</html>

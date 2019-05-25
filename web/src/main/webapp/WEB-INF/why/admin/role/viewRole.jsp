<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head>
    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>


  </head>

  <body>
  <input type="hidden" value="${role.roleId}" name="roleId"/>
  <div class="main-publish tag-add">
      <table width="100%" class="form-table">
          <tr>
              <td class="td-title" width="100"><span class="red">*</span>角色名称：</td>
              <td class="td-input"><input type="text" class="input-text w210" id="roleName" name="roleName" value="${role.roleName}" readonly/><span class="error-msg" id="roleNameSpan"></span></td>
          </tr>
          <tr class="td-line">
              <td class="td-title">描述：</td>
              <td class="td-input">
                  <textarea rows="4" name="roleRemark" class="textareaBox" style="width: 340px;resize: none;" readonly>${role.roleRemark}</textarea><span style="color:red">200字内</span>
              </td>
          </tr>
          <tr>
              <td class="td-title"></td>
              <td class="td-btn">
                  <input class="btn-cancel" type="button" value="关闭"/>
              </td>
          </tr>
      </table>
  </div>

  <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
  <script type="text/javascript">
      seajs.config({
          alias: {
              "jquery": "jquery-1.10.2.js"
          }
      });
      seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
          window.dialog = dialog;
      });

      window.console = window.console || {log:function () {}}
      seajs.use(['jquery'], function ($) {
          $(function () {
              var dialog = parent.dialog.get(window);
              /*点击取消按钮，关闭登录框*/
              $(".btn-cancel").on("click", function(){
                  dialog.close().remove();
              });
          });
      });
  </script>
  </body>
</html>

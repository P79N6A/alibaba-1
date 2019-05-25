<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head>
    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>


  </head>

  <body>
      <div class="site">
          <em>您现在所在的位置：</em>团体管理 &gt; 查看团体成员
      </div>
      <div class="site-title">查看团体成员</div>
      <div class="main-publish">
          <table width="100%" class="form-table">
              <tr>
                  <td class="td-title" width="100">成员用户名：</td>
                  <td class="td-input">${terminalUser.userName}
                      <c:if test="${terminalUser.applyIsState == 1}">
                          <span style="color: red">(管理员)</span>
                      </c:if>
                  </td>
              </tr>
              <tr>
                  <td class="td-title">成员性别：</td>
                  <td class="td-input">
                      <c:if test="${terminalUser.userSex == 1}">男</c:if>
                      <c:if test="${terminalUser.userSex == 2}">女</c:if>
                      <c:if test="${terminalUser.userSex == 3}">保密</c:if>
                  </td>
              </tr>
              <tr>
                  <td class="td-title">出生日期：</td>
                  <td class="td-input"><fmt:formatDate value="${terminalUser.userBirth}"  pattern="yyyy-MM-dd" /></td>
              </tr>
              <tr>
                  <td class="td-title">联系方式：</td>
                  <td class="td-input">${terminalUser.userMobileNo}</td>
              </tr>
              <tr>
                  <td class="td-title">成员简介：</td>
                  <td class="td-input">${terminalUser.applyReason}</td>
              </tr>
              <tr>
                  <td></td>
                  <td class="td-btn">
                      <input type="button" class="btn-publish" value="返回" onclick="javascript :history.back(-1);"/>
                  </td>
              </tr>
          </table>
      </div>
  </body>
</html>

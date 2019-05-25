<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head>
    <title>文化云后台管理系统</title>
      <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
  </head>

  <body class="rbody">
  <form method="post" action="" name="postForm">
  <!-- 正中间panel -->
  <div id="content">
      <div class="content">
          <div class="con-box-blp">
              <div class="site">
                  <em>您现在所在的位置：</em>用户管理
              </div>
              <div class="site-title">用户管理</div>
            <c:if test="${not empty update && update =='success'}">
              <div class="con-box-tlp">
                  <div class="top-search">
                      <font color="red"> 更新成功</font>
                  </div>

              </div>
            </c:if>
                  <div class="main-content">
                      <table width="100%"   class="form-table">
                          <tr>
                              <td width="75">用户帐号</td>
                              <td   class="td-input-two" width="65">
                                  ${user.userAccount}
                              </td>
                              <td width="75" >邮箱</td>
                              <td width="90">${user.userEmail}</td>
                          </tr>

                          <tr>
                              <td width="75">用户昵称</td>
                              <td width="65">
                                  ${user.userNickName}
                              </td>
                              <td width="75">部门</td>
                              <td width="90">
                                  ${user.userDeptId}
                              </td>
                          </tr>

                          <tr>
                              <td width="75">性别</td>
                              <td width="65">
                                  <c:choose>
                                      <c:when test="${user.userSex eq 1}">男</c:when>
                                      <c:when test="${user.userSex eq 2}">女</c:when>
                                      <c:otherwise>保密</c:otherwise>
                                  </c:choose>
                              </td>
                              <td width="75">状态</td>
                              <td width="90">

                                  <c:if test="${user.userState ==1}"> 正常 </c:if>
                                  <c:if test="${user.userState ==2}"> 删除 </c:if>
                              </td>
                          </tr>

                          <tr>
                              <td width="75">所属省份</td>
                              <td width="65">
                                  ${fn:split(user.userProvince,',')[1]}
                              </td>
                              <td width="75">所属市</td>
                              <td width="90">${fn:split(user.userCity,',')[1]}</td>
                          </tr>

                          <tr>
                              <td width="75">所属区县</td>
                              <td width="65">
                                      ${fn:split(user.userCounty,',')[1]}
                              </td>
                              <td width="75">录入时间</td>
                              <td width="90">
                                  <fmt:formatDate value="${user.userCreateTime}"  pattern="yyyy-MM-dd" />
                              </td>
                          </tr>

                          <tr>
                              <td width="75">手机号码</td>
                              <td width="65">
                                 ${user.userMobilePhone}
                              </td>
                              <td width="75">生日</td>
                              <td width="90">
                                  <fmt:formatDate value="${user.userBirthday}"  pattern="yyyy-MM-dd" />
                              </td>
<%--                              <td width="75">座机号码</td>
                              <td width="90">${user.userTelephone}</td>--%>
                          </tr>

<%--                          <tr>
                           <td width="75">qq号码</td>
                              <td width="65">
                                 ${user.userQq}
                              </td>
                              <td width="75">生日</td>
                              <td width="90">
                                  <fmt:formatDate value="${user.userBirthday}"  pattern="yyyy-MM-dd" />
                              </td>
                          </tr>--%>

                          <tr>
                              <td width="95">身份证号码</td>
                              <td width="90">
                                 ${user.userIdCardNo}
                              </td>
                              <td width="75">是否启用</td>
                              <td width="65">
                                      <c:if test="${user.userIsdisplay ==1}"> 已启用 </c:if>
                                      <c:if test="${user.userIsdisplay ==2}"> 未启用 </c:if>
                              </td>
                          </tr>

                          <tr>


                          </tr>
                          <tr class="td-btn">
                              <td colspan="4">
                                  <input type="button" class="btn-save" value="更改" onclick = "javascript:location.href='${path}/user/preEditSysUser.do?userId=${user.userId}'"/>
                                  <input type="button" class="btn-publish" value="返回" onclick="javascript:history.go(-1)"/>
                              </td>
                          </tr>
                      </table>
                  </div>
              </div>
          </div>
      </div>

  </form>
  </body>
</html>

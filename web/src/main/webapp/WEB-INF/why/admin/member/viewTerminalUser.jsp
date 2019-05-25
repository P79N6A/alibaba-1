<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:setLocale value="zh_CN"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/html">
<head>
    <title>查看用户</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
</head>
<body>
<div class="site">
    <em>您现在所在的位置：</em>会员管理 &gt;用户管理 &gt; 查看用户
</div>
<div class="site-title">查看用户</div>
<!-- 正中间panel -->
<div class="main-publish">
    <table class="form-table" width="100%">
        <tbody>
        <tr>
            <td class="td-title" width = "130">用户昵称：</td>
            <td class="td-input" >
                <span>${terminalUser.userName}</span>
            </td>
        </tr>
        <tr>
            <td class="td-title">真实姓名：</td>
            <td class="td-input" >
                <span>${terminalUser.userNickName}</span>
            </td>
        </tr>
        <tr>
            <td class="td-title">用户等级：</td>
            <td class="td-input" >
                <span>
                    <c:if test="${terminalUser.userType == 1}">普通用户</c:if>
                    <c:if test="${terminalUser.userType == 2}">团体管理员</c:if>
                </span>
            </td>
        </tr>
        <tr>
            <td class="td-title">状态：</td>
            <td class="td-input" >
                <span>
                    <c:if test="${terminalUser.userIsDisable == 0}">待激活</c:if>
                    <c:if test="${terminalUser.userIsDisable == 1}">已激活</c:if>
                    <c:if test="${terminalUser.userIsDisable == 2}">冻结</c:if>
                </span>
            </td>
        </tr>
        <tr>
            <td class="td-title">所属地区：</td>
            <td class="td-input" >
                <span>${fn:substringAfter(terminalUser.userProvince,',')}&nbsp;${fn:substringAfter(terminalUser.userCity,',')}&nbsp;${fn:substringAfter(terminalUser.userArea,',')}</span>
            </td>
        </tr>
        <tr>
            <td class="td-title">电子邮箱：</td>
            <td class="td-input" >
                <span <c:if test="${empty terminalUser.userEmail}">style="color:red" </c:if>>
                    <c:if test="${empty terminalUser.userEmail}">未绑定</c:if>
                    <c:if test="${not empty terminalUser.userEmail}">${terminalUser.userEmail}</c:if>
                </span>
            </td>
        </tr>
        <tr>
            <td class="td-title">性别：</td>
            <td class="td-input">
                                    <span>
                                        <c:choose>
                                            <c:when test="${terminalUser.userSex==1}">
                                                男
                                            </c:when>
                                            <c:when test="${terminalUser.userSex==2}">
                                                女
                                            </c:when>
                                            <c:when test="${terminalUser.userSex==3}">
                                                保密
                                            </c:when>
                                        </c:choose>
                                    </span>
            </td>
        </tr>
        <tr>
            <td class="td-title">联系电话：</td>
            <td class="td-input" >
                <span>${terminalUser.userMobileNo}</span>
            </td>
        </tr>
        <tr>
            <td class="td-title">注册时间：</td>
            <td class="td-input" >
                <span> <fmt:formatDate value="${terminalUser.createTime}" pattern="yyyy-MM-dd hh:mm:ss" /></span>
            </td>
        </tr>
        <tr class="submit-btn">
            <td></td>
            <td class="td-btn">
                <input type="button" class="btn-publish" value="返回" onclick="javascript :history.back(-1);"/>
            </td>
        </tr>
        </tbody>
    </table>
</div>
</body>
</html>

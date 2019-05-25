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
    <em>您现在所在的位置：</em>培训管理 &gt;用户列表 &gt; 查看用户
</div>
<div class="site-title">查看用户</div>
<!-- 正中间panel -->
<div class="main-publish">
    <table class="form-table" width="100%">
        <tbody>
        <tr>
            <td class="td-title" width = "130">真实姓名：</td>
            <td class="td-input" >
                <span>${trainUser.realName}</span>
            </td>
        </tr>
        <tr>
            <td class="td-title">手机号：</td>
            <td class="td-input" >
                <span>${trainUser.userMobileNo}</span>
            </td>
        </tr>
        <tr>
            <td class="td-title">电子邮件：</td>
            <td class="td-input" >
                <span>
					${trainUser.userEmail}
                </span>
            </td>
        </tr>
        <tr>
            <td class="td-title">身份证号：</td>
            <td class="td-input" >
                <span>${trainUser.idNumber}
                </span>
            </td>
        </tr>
        <tr>
            <td class="td-title">所在区县：</td>
            <td class="td-input" >
                <span>
                	<c:choose>
			        	<c:when test="${trainUser.unitArea==46}">
                            黄浦区
			        	</c:when>
			        	<c:when test="${trainUser.unitArea==48}">
			        		徐汇区
			        	</c:when>
			        	<c:when test="${trainUser.unitArea==49}">
			        		长宁区
			        	</c:when>
			        	<c:when test="${trainUser.unitArea==50}">
			        		静安区
			        	</c:when>
			        	<c:when test="${trainUser.unitArea==51}">
			        		普陀区
			        	</c:when>
			        	<c:when test="${trainUser.unitArea==53}">
			        		虹口区
			        	</c:when>
			        	<c:when test="${trainUser.unitArea==54}">
			        		杨浦区
			        	</c:when>
			        	<c:when test="${trainUser.unitArea==55}">
			        		闵行区
			        	</c:when>
			        	<c:when test="${trainUser.unitArea==56}">
			        		宝山区
			        	</c:when>
			        	<c:when test="${trainUser.unitArea==57}">
			        		嘉定区
			        	</c:when>
			        	<c:when test="${trainUser.unitArea==58}">
			        		浦东新区
			        	</c:when>
			        	<c:when test="${trainUser.unitArea==59}">
			        		金山区
			        	</c:when>
			        	<c:when test="${trainUser.unitArea==60}">
			        		松江区
			        	</c:when>
			        	<c:when test="${trainUser.unitArea==61}">
			        		青浦区
			        	</c:when>
			        	<c:when test="${trainUser.unitArea==63}">
			        		奉贤区
			        	</c:when>
			        	<c:when test="${trainUser.unitArea==64}">
			        		崇明县
			        	</c:when>
			        	<c:otherwise>
			        		上海市
			        	</c:otherwise>
					</c:choose>
				</span>
            </td>
        </tr>
        <tr>
            <td class="td-title">所在单位名称：</td>
            <td class="td-input" >
                <span>${trainUser.unitName}</span>
            </td>
        </tr>
        <tr>
            <td class="td-title">职务：</td>
            <td class="td-input" >
                <span>
                ${trainUser.jobName}
                </span>
            </td>
        </tr>
        <tr>
            <td class="td-title">职称：</td>
            <td class="td-input" >
                <span>${trainUser.titleName}</span>
            </td>
        </tr>
        <tr>
            <td class="td-title">性别：</td>
            <td class="td-input">
                                    <span>
                                        <c:choose>
                                            <c:when test="${trainUser.userSex==1}">
                                                男
                                            </c:when>
                                            <c:when test="${trainUser.userSex==2}">
                                                女
                                            </c:when>
                                            <c:otherwise>
			        							保密
			        						</c:otherwise>
                                        </c:choose>
                                    </span>
            </td>
        </tr>
        <tr>
            <td class="td-title">从事领域：</td>
            <td class="td-input" >
                <span>${trainUser.fieldName}</span>
            </td>
        </tr>
        <tr>
            <td class="td-title">验证码：</td>
            <td class="td-input" >
                <span>${trainUser.verificationCode}</span>
            </td>
        </tr>
        <tr>
            <td class="td-title">注册时间：</td>
            <td class="td-input" >
                <span> <fmt:formatDate value="${trainUser.createTime}" pattern="yyyy-MM-dd HH:mm:ss" /></span>
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

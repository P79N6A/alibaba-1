<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:setLocale value="zh_CN"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/html">
<head>
    <title>查看广告</title>
    <%@include file="../../common/pageFrame.jsp"%>
    <script type="text/javascript" src="${path}/STATIC/js/getAdvertImg.js"></script>
</head>
<body class="rbody">
<!-- 正中间panel -->
<div id="content">
    <div class="content">
        <div class="con-box-blp">
            <h3>添加广告</h3>
            <div class="con-box-tlp">
                <div class="form-box">
                    <table class="form-table">
                        <tbody>
                        <tr>
                            <td class="td-title"><span class="td-prompt"></span>广告标题：</td>
                            <td class="td-input-one" colspan="3">
                                <span class="td-prompt-one">${record.advertTitle}</span>
                            </td>
                        </tr>
                        <tr>
                            <td class="td-title"><span class="td-prompt"></span>类型：</td>
                            <td class="yd_numlist yd_numlist_bg" colspan="3">
                                <span class="td-prompt-one">
                                <c:choose>
                                <c:when test="${record.advertType==1}">
                                    图片
                                </c:when>
                                <c:when test="${record.advertType==2}">
                                   FLASH
                                </c:when>
                                <c:when test="${record.advertType==3}">
                                    代码
                                </c:when>
                                </c:choose>
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <td class="td-title"><span class="td-prompt"></span>所属站点：</td>
                            <td class="td-input-two">
                                <span class="td-prompt-one">
                                <c:forEach items="${siteList}" var="c" varStatus="s">
                                    <c:if test="${c.dictId == record.advertSite}"> ${c.dictName}</c:if>
                                </c:forEach>
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <td class="td-title"><span class="td-prompt"></span>所属栏目：</td>
                            <td class="td-input-two" colspan="3">
                                <span class="td-prompt-one">
                                <c:forEach items="${columnList}" var="c" varStatus="s">
                                    <c:if test="${c.dictId == record.advertColumn}"> ${c.dictName}</c:if>
                                </c:forEach>
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <td class="td-title"><span class="td-prompt"></span>版位：</td>
                            <td class="td-input-two" colspan="3">
                                <span class="td-prompt-one">
                                <c:forEach items="${posList}" var="c" varStatus="s">
                                    <c:if test="${c.dictId == record.advertPos}"> ${c.dictName}</c:if>
                                </c:forEach>
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <td class="td-title"><span class="td-prompt"></span>顺序：</td>
                            <td class="td-input-one td-input-four" colspan="3">
                                <span class="td-prompt-one">${record.advertPosSort}</span>
                            </td>
                        </tr>
                        <tr>
                            <td class="td-title"><span class="td-prompt"></span>图片：</td>
                            <td class="td-input-two td-input-four"colspan="3">
                                <div id="imgHeadPrev" style="width:100px; height:100px;position: relative; overflow: hidden;  float: left;">
                                    <input type="hidden"  name="advertPicUrl" id="advertPicUrl" value="${record.advertPicUrl}">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="td-title"><span class="td-prompt"></span>连接目标：</td>
                            <td class="yd_numlist yd_numlist_bg" colspan="3">
                                <span class="td-prompt-one">
                                <c:choose>
                                    <c:when test="${record.advertConnectTarget==1}">
                                        新窗口
                                    </c:when>
                                    <c:when test="${record.advertConnectTarget==2}">
                                        原窗口
                                    </c:when>
                                </c:choose>
                                </span>
                            </td>
                        </tr>
                        <tr class="submit-btn">
                            <td colspan="4">
                                <input type="button" value="返回" onclick="history.back(-1)"/>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>

<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:setLocale value="zh_CN"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/html">
<head>
    <title>查看志愿者--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
</head>
<body>
<div class="site">
    <em>您现在所在的位置：</em>文化志愿者 &gt;志愿者管理 &gt; 查看志愿者
</div>
<div class="site-title">查看志愿者</div>
<!-- 正中间panel -->
<div class="main-publish">
    <table class="form-table" width="100%">
        <tbody>
        <tr>
            <td class="td-title" width = "10%">志愿者名称：</td>
            <td class="td-input" width = "40%">
                <span>${model.name}</span>
            </td>
            <td class="td-title" width = "10%">性别：</td>
            <td class="td-input" width = "40%">
                <span>
                    <c:if test="${model.sex == 1}">男</c:if>
                    <c:if test="${model.sex == 2}">女</c:if>
                </span>
            </td>
        </tr>
        <tr>
            <td class="td-title">志愿者类型：</td>
            <td class="td-input" >
                <span>
                    <c:if test="${model.type == 1}">个人</c:if>
                    <c:if test="${model.type == 2}">团队</c:if>
                </span>
            </td>
            <td class="td-title">证件信息：</td>
            <td class="td-input" >
                <span>${model.cardId}</span>
            </td>
        </tr>
        <tr>
            <td class="td-title">手机号码：</td>
            <td class="td-input" >
                <span>${model.phone}</span>
            </td>
            <td class="td-title">邮箱：</td>
            <td class="td-input" >
                <span>${model.email}</span>
            </td>
        </tr>
        <tr>
            <td class="td-title">区域：</td>
            <td class="td-input" >
                <span id="lblRegion"></span>
            </td>
            <td class="td-title">地址：</td>
            <td class="td-input" >
                <span>${model.address}</span>
            </td>
        </tr>
        <tr>
            <%--<td class="td-title">职业：</td>--%>
            <%--<td class="td-input" >--%>
            <%--<span>${model.occupation}</span>--%>
            <%--</td>--%>
            <%--<td class="td-title">团队人数：</td>--%>
            <%--<td class="td-input" >--%>
                <%--<span>${model.region}</span>--%>
            <%--</td>--%>
        </tr>
        <tr>
            <td class="td-title">最高学历：</td>
            <td class="td-input" >
                <span>
                    <c:if test="${model.education == 1}">高中</c:if>
                    <c:if test="${model.education == 2}">专科</c:if>
                    <c:if test="${model.education == 3}">本科</c:if>
                    <c:if test="${model.education == 4}">硕士及以上</c:if>
                </span>
            </td>
                <td class="td-title">政治面貌：</td>
                <td class="td-input" >
                <span>
                    <c:if test="${model.political == 1}">党员</c:if>
                    <c:if test="${model.political == 2}">团员</c:if>
                </span>
                </td>
        </tr>
        <tr>
            <td class="td-title">个人简介：</td>
            <td class="td-input" colspan="3">
                <span>${model.brief}</span>
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
<script type="text/javascript" >
    var loc	= new Location();
    var region = '${model.region}';
    if(region && region.split(',').length === 3){

        var areaList = loc.find('0,' + region.split(',')[0] + ',' + region.split(',')[1])
        var areaCode = '';
        if(region){
            var region = region.split(',');
            if(region && region.length === 3){
                areaCode= region[2];
            }
        }
        var regionText ='';
        $.each(areaList, function(code, name){
            if(areaCode == code){
                regionText =  name;
            }
        })
        $('#lblRegion').html('陕西省安康市' + regionText);
    }
</script>
</body>
</html>

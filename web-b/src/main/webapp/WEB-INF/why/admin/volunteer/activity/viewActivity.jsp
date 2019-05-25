<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:setLocale value="zh_CN"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/html">
<head>
    <title>查看活动--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
</head>
<body>
<div class="site">
    <em>您现在所在的位置：</em>文化志愿者 &gt;志愿者活动 &gt; 查看活动
</div>
<div class="site-title">查看活动</div>
<!-- 正中间panel -->
<div class="main-publish">
    <table class="form-table" width="100%">
        <tbody>
        <tr>
            <td class="td-title" width = "10%">活动名称：</td>
            <td class="td-input"  width = "40%">
                <span>${volunteerActivity.name}</span>
            </td>
            <td class="td-title" width = "10%">活动时间：</td>
            <td class="td-input"  width = "40%">
                <span><fmt:formatDate value="${volunteerActivity.startTime}" pattern="yyyy-MM-dd HH:mm"/> 至 <fmt:formatDate value="${volunteerActivity.endTime}" pattern="yyyy-MM-dd HH:mm"/></span>
            </td>
        </tr>
        <tr>
            <td class="td-title">所属区域：</td>
            <td class="td-input" style="vertical-align: top;">
                <span id="lblRegion"></span>
            </td>
            <td class="td-title">封面图片：</td>
            <td class="td-input" >
                <img style="max-height: 130px!important;max-width: 130px!important;" src="${volunteerActivity.picUrl }">
            </td>
        </tr>
        <tr>
            <td class="td-title">活动地址：</td>
            <td class="td-input" >
                <span>${volunteerActivity.address}</span>
            </td>
            <td class="td-title">联系电话：</td>
            <td class="td-input" >
                <span>${volunteerActivity.phone}</span>
            </td>
        </tr>
        <tr>
            <%--<td class="td-title">服务类型：</td>--%>
            <%--<td class="td-input" >--%>
                <%--<span>${volunteerActivity.serviceType}</span>--%>
            <%--</td>--%>
            <td class="td-title">招募对象类型：</td>
            <td class="td-input" >
                <span>
                    <c:if test="${volunteerActivity.recruitObjectType == 1}">个人</c:if>
                    <c:if test="${volunteerActivity.recruitObjectType == 2}">团队</c:if>
                </span>
            </td>
            <td class="td-title">是否上架：</td>
            <td class="td-input" >
                <span>
                    <c:if test="${volunteerActivity.publish == 1}">已上架</c:if>
                    <c:if test="${volunteerActivity.publish == 2}">未上架</c:if>
                </span>
            </td>
        </tr>
        <tr>
            <td class="td-title">招募状态：</td>
            <td class="td-input" >
                <span>
                    <c:if test="${volunteerActivity.recruitmentStatus == 1}">招募中</c:if>
                    <c:if test="${volunteerActivity.recruitmentStatus == 2}">停止招募</c:if>
                </span>
            </td>
            <td class="td-title">状态：</td>
            <td class="td-input" >
                <span>
                    <c:if test="${volunteerActivity.status == 1}">草稿</c:if>
                    <c:if test="${volunteerActivity.status == 2}">未审核</c:if>
                    <c:if test="${volunteerActivity.status == 3}">正常</c:if>
                    <c:if test="${volunteerActivity.status == 4}">驳回</c:if>
                    <c:if test="${volunteerActivity.status == 9}">删除</c:if>
                </span>
            </td>
        </tr>
        <tr>
            <td class="td-title">服务时长：</td>
            <td class="td-input" >
                <span>${volunteerActivity.serviceTime} 小时</span>
            </td>
            <td class="td-title">允许报名人数：</td>
            <td class="td-input" >
                <span>${volunteerActivity.limitNum}</span>
            </td>
        </tr>
        <tr>
            <td class="td-title">活动描述：</td>
            <td class="td-input" colspan="3">
                <span>${volunteerActivity.description}</span>
            </td>
        </tr>
        <tr>
            <td class="td-title">附件信息：</td>
            <td class="td-input" >
                <c:if test="${volunteerActivity.attachment}">
                    <a href="${volunteerActivity.attachment}" target="_blank">下载附件</a>
                </c:if>

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
    var respectiveRegion = '${volunteerActivity.respectiveRegion}';
    if(respectiveRegion && respectiveRegion.split(',').length === 3){

        var areaList = loc.find('0,' + respectiveRegion.split(',')[0] + ',' + respectiveRegion.split(',')[1])
        var areaCode = '';
        if(respectiveRegion){
            var region = respectiveRegion.split(',');
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

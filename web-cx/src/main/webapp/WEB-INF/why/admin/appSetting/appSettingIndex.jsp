<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>活动列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
<script type="text/javascript" >

    seajs.config({
        alias: {
            "jquery": "jquery-1.10.2.js"
        }
    });
    seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
        window.dialog = dialog;
    });

    function toEditKeyword(key) {
        dialog({
        url: '${path}/appSetting/editAppSetting.do?saveId='+key,
        title: '修改App热搜关键词',
        width:600,
        height:350,
        fixed: true,
        data: {
        title: $(this).parent().siblings().text(),
        type: $(this).parents("tr").find(".title").text(),
        imgUrl: $(this).siblings().attr("src")
        }
        }).showModal();
        return false;

    }
    function editAppSelectSetting(key) {
        dialog({
            url: '${path}/appSetting/editAppSelectSetting.do?saveId='+key,
            title: '修改App热搜关键词',
            width:600,
            height:350,
            fixed: true,
            data: {
                title: $(this).parent().siblings().text(),
                type: $(this).parents("tr").find(".title").text(),
                imgUrl: $(this).siblings().attr("src")
            }
        }).showModal();
        return false;

    }
    function editActivityAreaSetting(key) {
        dialog({
            url: '${path}/appSetting/editActivityAreaSetting.do?saveId='+key,
            title: '修改App热搜关键词',
            width:600,
            height:350,
            fixed: true,
            data: {
                title: $(this).parent().siblings().text(),
                type: $(this).parents("tr").find(".title").text(),
                imgUrl: $(this).siblings().attr("src")
            }
        }).showModal();
        return false;

    }
    function venueTagKeywordsName(key) {
        dialog({
            url: '${path}/appSetting/venueTagKeywordsName.do?saveId='+key,
            title: '修改App热搜关键词',
            width:600,
            height:350,
            fixed: true,
            data: {
                title: $(this).parent().siblings().text(),
                type: $(this).parents("tr").find(".title").text(),
                imgUrl: $(this).siblings().attr("src")
            }
        }).showModal();
        return false;

    }
    </script>

</head>
<body>
<form action="${path }/tag/tagIndex.do" id="tag_form" method="post" name="tag_form">
<div class="site">
    <em>您现在所在的位置：</em>运维管理 &gt; App设置
</div>

<div class="main-content">
    <table width="100%">
        <thead>
        <tr>
            <th width="100">序号</th>
            <th width="200">类别</th>
            <th width="200">热门</th>
            <th>内容</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>

            <tr>
                <td>1</td>
                <td>App新时间</td>
                <td>（单位：小时）</td>
                <td><c:forEach items="${hotDays}" var="c">${c}</c:forEach></td>
                <td >
                   <a href="#" onclick="toEditKeyword('hotDays')">编辑</a>
                </td>
            </tr>
            <tr>
                <td>2</td>
                <td>活动搜索</td>
                <td>热门搜索</td>
                <td><c:forEach items="${activityHotKeywords}" var="c">${c},</c:forEach></td>
                <td >
                    <a href="#" onclick="toEditKeyword('activityHotKeywords')">编辑</a>
                </td>
            </tr>
            <tr>
                <td>3</td>
                <td>活动搜索</td>
                <td>热门分类</td>
                <td><c:forEach items="${activityTagKeywords}" var="c">${c},</c:forEach></td>
                <td >
                    <a href="#" onclick="editAppSelectSetting('activityTagKeywordsName')">编辑</a>
                </td>
            </tr>
            <tr>
                <td>4</td>
                <td>活动搜索</td>
                <td>热门区域</td>
                <td><c:forEach items="${activityAreaKeywords}" var="c">${c.split(":")[1]},</c:forEach></td>
                <td >
                    <a href="#" onclick="editActivityAreaSetting('activityAreaKeywords')">编辑</a>
                </td>
            </tr>
            <tr>
                <td>5</td>
                <td>场馆搜索</td>
                <td>热门搜索</td>
                <td><c:forEach items="${venueHotKeywords}" var="c">${c},</c:forEach></td>
                <td >
                    <a href="#" onclick="toEditKeyword('venueHotKeywords')">编辑</a>
                </td>
            </tr>
            <tr>
                <td>6</td>
                <td>场馆搜索</td>
                <td>热门分类</td>
                <td><c:forEach items="${venueTagKeywordsName}" var="c">${c},</c:forEach></td>
                <td >
                    <a href="#" onclick="venueTagKeywordsName('venueTagKeywordsName')">编辑</a>
                </td>
            </tr>
            <tr>
                <td>7</td>
                <td>场馆搜索</td>
                <td>热门区域</td>
                <td><c:forEach items="${venueAreaKeywords}" var="c">${c.split(":")[1]},</c:forEach></td>
                <td >
                    <a href="#" onclick="editActivityAreaSetting('venueAreaKeywords')">编辑</a>
                </td>
            </tr>
        </tbody>
    </table>
</div>
</form>
</body>
</html>
<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

    <title>轮播图列表--文化云</title>
    <%@include file="../../common/pageFrame.jsp" %>
    <%@include file="/WEB-INF/why/common/limit.jsp" %>
</head>
<body>
<link rel="Stylesheet" type="text/css" href="${path}/STATIC/css/DialogBySHF.css"/>
<script type="text/javascript" src="${path}/STATIC/js/DialogBySHF.js"></script>
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

    window.console = window.console || {
                log: function () {

                }
            }
    seajs.use(['jquery'], function ($) {

        $('.btn-add-tag').on('click', function () {
            var sortNum = $(this).parent().siblings(".sortNum").text();
            dialog({
                url: '${path}/ccpAdvert/addAdvertIndex.do?advertSort=' + sortNum,
                title: '添加首页栏目推荐',
                width: 1000,
                height: 800,
                fixed: true
            }).showModal();
            return false;
        });

    });
    function advEdit(ID,Name) {
        dialog({
            url: '${path}/ccpAdvert/addFrontAdvertIndex.do?advertType=' + ID,
            title: '添加'+Name,
            width: 1000,
            height: 800,
            fixed: true
        }).showModal();
        return false;
    }
</script>
<div class="site">
    <em>您现在所在的位置：</em>推荐管理 &gt;Web端推荐&gt; 首页栏目推荐
</div>
<form id="advertIndexForm" action="${path}/advert/advertIndex.do" method="post">
    <div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th>ID</th>
                <th>栏目名称</th>
                <th>编辑</th>
            </tr>
            </thead>
            <tbody id="advertImg">
            <tr>
                <td>1</td>
                <td>热门场馆</td>
                <td><a onclick="advEdit('D','热门场馆')">编辑</a></td>
            </tr>
            <tr>
                <td>2</td>
                <td>动态资讯</td>
                <td><a onclick="advEdit('K','动态资讯')">编辑</a></td>
            </tr>
            <tr>
                <td>3</td>
                <td>特色活动</td>
                <td><a onclick="advEdit('L','特色活动')">编辑</a></td>
            </tr>
            <tr>
                <td>4</td>
                <td>热门培训</td>
                <td><a onclick="advEdit('M','热门培训')">编辑</a></td>
            </tr>
            <!-- <tr>
                <td>1</td>
                <td>最新推荐</td>
                <td><a onclick="advEdit('B','最新推荐')">编辑</a></td>
            </tr>
            <tr>
                <td>2</td>
                <td>精彩回顾</td>
                <td><a onclick="advEdit('C','精彩回顾')">编辑</a></td>
            </tr> -->
            
           <%-- <tr>
                <td>4</td>
                <td>热门推荐位</td>
                <td><a onclick="advEdit('E','热门推荐位')">编辑</a></td>
            </tr>--%>
            <!-- <tr>
                <td>5</td>
                <td>今日佛山</td>
                <td><a onclick="advEdit('F','今日佛山')">编辑</a></td>
            </tr>
            <tr>
                <td>6</td>
                <td>历史文化</td>
                <td><a onclick="advEdit('G','历史文化')">编辑</a></td>
            </tr>
            <tr>
                <td>7</td>
                <td>文化旅游</td>
                <td><a onclick="advEdit('H','文化旅游')">编辑</a></td>
            </tr>
            <tr>
                <td>8</td>
                <td>佛山美食</td>
                <td><a onclick="advEdit('I','佛山美食')">编辑</a></td>
            </tr>
            <tr>
                <td>9</td>
                <td>文化遗产</td>
                <td><a onclick="advEdit('J','文化遗产')">编辑</a></td>
            </tr> -->
            </tbody>
        </table>
    </div>
</form>


</body>
</html>
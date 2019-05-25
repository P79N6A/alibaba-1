<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

    <title>场馆评论列表--文化云</title>
    <%@include file="../../common/pageFrame.jsp"%>

    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
</head>
<body>

<div class="site">
    <em>您现在所在的位置：</em>场馆管理 &gt; 场馆信息管理&gt; 场馆评论列表
</div>
<form id="venueCommentIndexForm" method="post" action="${path}/venue/venueCommentIndex.do">
<div class="search">
    <div class="search-box">
        <i></i><input id="venueName" name="venueName" class="input-text" data-val="输入场馆名称关键词" type="text"
             value="<c:choose><c:when test="${not empty venue.venueName}">${venue.venueName}</c:when><c:otherwise>输入场馆名称关键词</c:otherwise></c:choose>"/>
    </div>
    <%-- <div class="select-box w135">
        <input type="hidden" name="venueArea" value="${venue.venueArea}" id="venueArea"/>
        <div class="select-text" data-value="" id="areaDiv">所属区县</div>
        <ul class="select-option" id="areaUl">
        </ul>
    </div> --%>
    <div class="select-btn">
        <input type="button" value="搜索" onclick="$('#page').val(1);formSub('#venueCommentIndexForm')"/>
    </div>
</div>
<div class="main-content">
    <table width="100%">
        <thead>
        <tr>
            <th>ID</th>
            <th class="title">场馆名称</th>
            <th>所属区县</th>
            <th>场馆类型</th>
            <th>操作人</th>
            <th>操作时间</th>
            <th>评论数量</th>
            <th width="210">管理</th>
        </tr>
        </thead>
        <c:if test="${empty list}">
            <tr>
                <td colspan="8"> <h4 style="color:#DC590C">暂无数据!</h4></td>
            </tr>
        </c:if>
        <tbody>

        <c:forEach items="${list}" var="c" varStatus="s">
            <tr>
                <td>${s.index+1}</td>
                <td class="title"><a href="${path}/frontVenue/venueDetail.do?venueId=${c.venueId}" target="_blank">${c.venueName }</a></td>
                <td>${fn:substringAfter(c.venueArea, ',')}</td>
                <td>${c.venueType}</td>
                <td>${c.venueUpdateUser }</td>
                <td><fmt:formatDate value="${c.venueUpdateTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                <td>${c.commentCount}</td>
                <td>
                    <a href="${path}/comment/commentVenueIndex.do?commentRkId=${c.venueId}">所有评论</a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    <c:if test="${not empty list}">
    <input type="hidden" id="page" name="page" value="${page.page}" />
    <div id="kkpager"></div>
    </c:if>
    <script type="text/javascript">
        $(function(){
            $.post("${path}/venue/getVenueCommentExistArea.do",{},function(data){
                if(data != '' && data != null){
                    var venueArea = $('#venueArea').val();
                    var list = eval(data);
                    var ulHtml = '<li data-option="">所属区县</li>';
                    for(var i = 0;i<list.length;i++){
                        var area = list[i];
                        var areaId = area.substring(0,area.indexOf(","));
                        var areaName = area.substring(area.indexOf(",")+1,area.length);
                        ulHtml +='<li data-option="'+areaId+'">'+areaName+'</li>';
                        if(venueArea != '' && areaId == venueArea){
                            $('#areaDiv').html(areaName);
                        }
                    }
                    $('#areaUl').html(ulHtml);
                }
            }).success(function(){
                selectModel();
            });


            kkpager.generPageHtml({
                pno : '${page.page}',
                total : '${page.countPage}',
                totalRecords :  '${page.total}',
                mode : 'click',//默认值是link，可选link或者click
                click : function(n){
                    this.selectPage(n);
                    $("#page").val(n);
                    formSub('#venueCommentIndexForm');
                    return false;
                }
            });
        });

        //提交表单
        function formSub(formName){
            var venueName = $("#venueName").val();
            if(venueName == "输入场馆名称关键词"){
                $("#venueName").val("");
            }
            $(formName).submit();
        }
    </script>
</div>
</form>

</body>
</html>
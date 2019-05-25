<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

    <title>场馆座位模板列表--文化云</title>
    <%@include file="../../common/pageFrame.jsp"%>

    <!-- dialog start -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    <script type="text/javascript">
        $(function() {
            $(".delete").on("click", function(){
                var templateId = $(this).attr("id");
                var name = $(this).parent().siblings(".title").find("a").text();
                var html = "您确定要删除" + name + "吗？";
                dialogConfirm("提示", html, function(){
                    $.post("${path}/venueSeatTemplate/deleteVenueSeatTemplate.do",{"templateId":templateId}, function(data) {
                        if (data!=null && data=='success') {
                            window.location.href="${path}/venueSeatTemplate/venueSeatTemplateIndex.do?venueId=${cmsVenue.venueId}";
                        }
                    });
                })
            });
        });
    </script>
    <!-- dialog end -->
</head>
<body>

<div class="site">
    <em>您现在所在的位置：</em>场馆管理 &gt; 场馆信息管理&gt; 场馆列表 &gt; ${cmsVenue.venueName} &gt; 座位模板列表
</div>
<form id="venueSeatTemplateIndexForm" action="${path}/venueSeatTemplate/venueSeatTemplateIndex.do" method="post">
<input type="hidden" id="venueId" name="venueId" value="${cmsVenue.venueId}"/>
<div class="search">
    <div class="search-box">
        <i></i><input id="templateName" name="templateName" class="input-text" type="text" data-val="输入模板名称关键词"
                      value="<c:choose><c:when test="${not empty record.templateName}">${ record.templateName}</c:when><c:otherwise>输入模板名称关键词</c:otherwise></c:choose>" />
    </div>
    <div class="select-btn">
        <input type="button" value="搜索" onclick="$('#page').val(1);formSub('#venueSeatTemplateIndexForm')"/>
    </div>
</div>
<div class="search menage">
    <h2>${cmsVenue.venueName}座位模板一览</h2>
    <div class="menage-box">
        <a class="btn-add" href="${path}/venue/preBuildVenueSeat.do?venueId=${cmsVenue.venueId}">添加座位模板</a>
    </div>
</div>

<div class="main-content">
    <table width="100%">
        <thead>
        <tr>
            <th>ID</th>
            <th class="title">模板名称</th>
            <th>操作人</th>
            <th width="120">操作时间</th>
            <th width="80">管理</th>
        </tr>
        </thead>

        <c:if test="${empty list}">
            <tr>
                <td colspan="5"> <h4 style="color:#DC590C">暂无数据!</h4></td>
            </tr>
        </c:if>

        <tbody>

        <c:forEach items="${list}" var="c" varStatus="s">
            <tr>
                <td>${s.index+1}</td>
                <td class="title">${c.templateName}</td>
                <td>${c.templateUpdateUser}</td>
                <td width="120"><fmt:formatDate value="${c.templateUpdateTime}" pattern="yyyy-MM-dd  HH:mm" /></td>
                <td class="operate">
                    <a href="${path}/venueSeatTemplate/preEditVenueSeatTemplate.do?templateId=${c.templateId}">编辑</a> |
                    <a class="delete" id="${c.templateId}">删除</a>
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
            kkpager.generPageHtml({
                pno : '${page.page}',
                total : '${page.countPage}',
                totalRecords :  '${page.total}',
                mode : 'click',//默认值是link，可选link或者click
                click : function(n){
                    this.selectPage(n);
                    $("#page").val(n);
                    formSub('#venueSeatTemplateIndexForm');
                    return false;
                }
            });
        });

        //提交表单
        function formSub(formName){
            var templateName = $("#templateName").val();
            if(templateName == "输入模板名称关键词"){
                $("#templateName").val("");
            }
            $(formName).submit();
        }
    </script>
</div>
</form>
</body>
</html>
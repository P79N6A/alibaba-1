<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>手机版本列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
</head>
<body>
<form action="${path}/androidVersion/androidVersionIndex.do" method="post" id="indexForm" name="indexForm">
    <div class="site">
        <em>您现在所在的位置：</em>手机版本管理 &gt; 手机版本列表

    </div>
    <div class="search">
        <div class="search-box">
            <i></i><input type="text" value="${record.externalVnumber}" name ="externalVnumber"class="input-text" data-val="输入关键词"/>
        </div>
        <div class="select-btn">
            <input type="button" value="搜索" onclick="pageSubmit(0)" style="border: none; "/>
        </div>
    </div>
    <%if(androidVersionAddButton){%>   	
    <div class="search menage">
        <div class="menage-box">
            <a class="btn-add" href="javascript:void(0);">添加手机版本</a>
        </div>
    </div>
    <%}%>   
    <div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th >ID</th>
                <th class="title">外部版本号</th>
                <th class="venue">内部版本号</th>
                <th>更新描述</th>
                <th >更新地址</th>
                <th>强制更新</th>
                <th>操作人</th>
                <th>操作时间</th>
                <th>管理</th>
            </tr>
            </thead>
            <tbody>
            <%int i=0;%>
            <c:forEach items="${list}" var="cmsAndroidVersion">
                <% i++;%>
                <tr>
                    <td > <%= i%></td>
                    <td class="title">
                            ${cmsAndroidVersion.externalVnumber}
                    </td>
                    <td class="venue">
                            ${cmsAndroidVersion.buildVnumber}
                    </td>
                    <td >
                            ${cmsAndroidVersion.updateDescr}
                    </td>
                    <td >
                            ${cmsAndroidVersion.updateUrl}
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${cmsAndroidVersion.versionUpdateStatus eq 'Y'}">是</c:when>
                            <c:otherwise>否</c:otherwise>
                        </c:choose>
                    </td>
                    <td >
                            ${cmsAndroidVersion.userAccount}
                    </td>
                    <td >
                        <fmt:formatDate value="${cmsAndroidVersion.versionUpdateTime}"  pattern="yyyy-MM-dd" />
                    </td>
                    <td width="85" class="td-editing">
                            <%--<c:forEach items="${sessionScope.user.sysModuleList}" var="module">--%>
                            <%--<c:if test="${module.moduleUrl == '${path}/androidVersion/deleteAndroidVersion.do'}">--%>
                            <%--<a href="javascript:confirmDialog('确认提示框','确定要删除该版本吗？','${path}/androidVersion/deleteAndroidVersion.do?vId=${cmsAndroidVersion.vId}'+'&'+ $('#indexForm').serialize())" >--%>
                            <%--删除--%>
                            <%--</a>--%>
                            <%--</c:if>--%>
                            <%--</c:forEach>--%>

                            <%--<c:forEach items="${sessionScope.user.sysModuleList}" var="module">--%>
                            <%--<c:if test="${module.moduleUrl == '${path}/androidVersion/preEditAndroidVersion.do'}">--%>
                 <%--               <a class="btn-edit" href="javascript:void(0);"><input type="hidden" name="androidVersionId" id="androidVersionId" value="${cmsAndroidVersion.vId}"/>编辑</a>--%>
                             <%if(androidVersionEditButton){%>   	
                                <a id="${cmsAndroidVersion.vId}" class="btn-edit">编辑</a>
                             <%}%>   
                            <%--</c:if>--%>
                            <%--</c:forEach>--%>
                            <%--<c:forEach items="${sessionScope.user.sysModuleList}" var="module">--%>
                            <%--<c:if test="${module.moduleUrl == '${path}/androidVersion/viewSysUser.do'}">--%>
                            <%--<a href="${path}/androidVersion/viewSysUser.do?userId=${user.userId}">查看</a>|--%>
                            <%--</c:if>--%>
                            <%--</c:forEach>--%>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty list}">
                <tr>
                    <td colspan="8"> <h4 style="color:#DC590C">暂无数据!</h4></td>
                </tr>
            </c:if>
            </tbody>
        </table>
        <c:if test="${not empty list}">
            <input type="hidden" id="page" name="page" value="${page.page}" />
            <div id="kkpager"></div>
        </c:if>
    </div>
</form>
<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
<script type="text/javascript">

    function chk_dl()
    {
        if(!confirmDialog('确认提示框','确定要删除这条数据吗?')){
            return  false;
        } else {
            return  true;
        }
    }
    $(function(){
        kkpager.generPageHtml({
            pno : '${page.page}',
            total : '${page.countPage}',
            totalRecords :  '${page.total}',
            mode : 'click',//默认值是link，可选link或者click
            click : function(n){
                this.selectPage(n);
                $("#page").val(n);
                $("#indexForm").submit();
                return false;
            }
        });
    });

    var pageSize = ${page.countPage};
    function pageSubmit(page){
        if(page <= pageSize){
            $("#page").val(page);
            $("#indexForm").submit();
        }else{
            //alert("跳转页数不能超过总页数");
        }
    }

    seajs.config({
        alias: {
            "jquery": "jquery-1.10.2.js"
        }
    });
    seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
        window.dialog = dialog;
    });
    window.console = window.console || {log:function () {}}
    //添加标签
    seajs.use(['jquery'], function ($) {
        $('.btn-add').on('click', function () {
            dialog({
                url: '${path}/androidVersion/preAddAndroidVersion.do',
                title: '添加手机版本',
                width: 460,
                height:450,
                fixed: true
            }).showModal();
            return false;
        });

        $('.btn-edit').on('click', function () {
            var vId = $(this).attr("id");
            dialog({
                url: '${path}/androidVersion/preEditAndroidVersion.do?vId='+vId,
                title: '更新手机版本',
                width: 460,
                height:450,
                fixed: true
            }).showModal();
            return false;
        });
    });
</script>
</body>
</html>
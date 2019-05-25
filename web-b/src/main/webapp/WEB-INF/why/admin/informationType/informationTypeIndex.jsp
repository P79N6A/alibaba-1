<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>

    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
</head>
<body>
<div class="site">
    <em>您现在所在的位置：</em>${infoModule.informationModuleName}管理 &gt; ${infoModule.informationModuleName}类型管理
</div>
<form action="${path}/ccpInformationType/informationTypeIndex.do" id="informationTypeForm" method="post">
    <input type="hidden" id="informationModuleId" name="informationModuleId" value="${InformationType.informationModuleId}"/>
    <div class="search">
            <div class="search menage">
                <div class="menage-box">
                    <a class="btn-add">新增类型</a>
                </div>
            </div>
    </div>
    <div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th>ID</th>
                <th class="title">类型名称</th>
                <th>创建时间</th>
                <th>管理</th>
            </tr>
            </thead>
            <tbody>
            <c:if test="${fn:length(informationTypeList) gt 0}">
                <tbody>
                <%int i=0;%>
                <c:forEach items="${informationTypeList}" var="informationType">
                    <%i++;%>
                    <tr>
                        <td><%=i%></td>
                        <td class="title">
                            <a href="javascript:;"><c:if test="${not empty informationType.typeName}">
                                ${informationType.typeName}
                            </c:if></a>
                        </td>
                          <td>
                            <fmt:formatDate value="${informationType.typeCreateTime}"  pattern="yyyy-MM-dd HH:mm" />
                        </td>
                        <td>
                           <a class="delete" informationTypeId="${informationType.informationTypeId}">删除</a> |
                           
                           <a informationTypeId="${informationType.informationTypeId}" class="informationType-edit">编辑</a> 
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </c:if>
            <c:if test="${empty informationTypeList}">
                <tr>
                    <td colspan="7"> <h4 style="color:#DC590C">暂无数据!</h4></td>
                </tr>
            </c:if>
            </tbody>
        </table>
        <c:if test="${not empty informationTypeList}">
            <input type="hidden" id="page" name="page" value="${page.page}" />
            <div id="kkpager"></div>
        </c:if>
    </div>
</form>
<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
<script type="text/javascript">
    seajs.config({
        alias: {
            "jquery": "jquery-1.10.2.js"
        }
    });

    seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
        window.dialog = dialog;
    });

    window.console = window.console || {log:function () {}}

    seajs.use(['jquery'], function ($) {
        // 新增类型
        $('.btn-add').on('click', function () {
            var informationModuleId = $("#informationModuleId").val();
            dialog({
                url: '${path}/ccpInformationType/preAddInformationType.do?informationModuleId='+informationModuleId,
                title: '新增类型',
                width: 500,
                fixed: true
            }).showModal();
            return false;
        });

        //编辑类型
        $('.informationType-edit').on('click', function () {
            var informationTypeId = $(this).attr("informationTypeId");
            var informationModuleId = $("#informationModuleId").val();
            dialog({
                url: '${path}/ccpInformationType/preEditInformationType.do?informationTypeId='+informationTypeId+'&informationModuleId='+informationModuleId,
                title: '编辑类型',
                width: 500,
                fixed: true
            }).showModal();
            return false;
        });

    });

    $(function(){
        kkpager.generPageHtml({
            pno : '${page.page}',
            total : '${page.countPage}',
            totalRecords :  '${page.total}',
            mode : 'click',//默认值是link，可选link或者click
            click : function(n){
                this.selectPage(n);
                $("#page").val(n);
                formSub('#informationTypeForm');
                return false;
            }
        });

        // 删除类型
        deleteinformationType();
    });

    function formSub(formName){
       
        $(formName).submit();
    }

    function deleteinformationType(){
        $(".delete").on("click", function(){
            var informationTypeId = $(this).attr("informationTypeId");
            var informationModuleId = $("#informationModuleId").val();
            var name = $(this).parent().siblings(".title").find("a").text();
            var html = "您确定要删除" + name + "吗？";
            dialogConfirm("提示", html, function(){
                $.post("${path}/ccpInformationType/deleteInformationType.do",{informationTypeId:informationTypeId},function(data) {
                    if (data == 'success') {
                        window.location.href="${path}/ccpInformationType/informationTypeIndex.do?informationModuleId="+informationModuleId;
                    }else if (data=='used'){
                    	dialogAlert('提示', '类型已使用，不能删除！')
                    }else if (data == "login") {
                    	
                     	 dialogAlert('提示', '请先登录！', function () {
                     		window.location.href = "${path}/login.do";
   	                    	 });
                     }else{
                       dialogTypeSaveDraft("提示", "删除失败");
                   }
                });
            })
        });
    }
</script>
</body>
</html>
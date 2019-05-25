<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>
    <title>文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
</head>
<body>

<div class="site">
    <em>您现在所在的位置：</em>站点管理 &gt; 资讯模块配置
</div>
<form id="informationModuleForm" action="${path}/ccpInformationModule/informationModuleIndex.do" method="post">
    <div class="search">
        <div class="search-box">
            <i></i><input class="input-text" name="informationModuleName" data-val="输入关键词" value="<c:choose><c:when test="${not empty informationModule.informationModuleName}">${informationModule.informationModuleName}</c:when><c:otherwise>输入关键词</c:otherwise></c:choose>" type="text" id="informationModuleName"/>
        </div>
        <div class="select-btn">
            <input type="button" value="搜索" onclick="$('#page').val(1);formSub('#informationModuleForm');"/>
        </div>
        <div class="search menage">
            <div class="menage-box">
                <a class="btn-add">新增资讯模块</a>
            </div>
        </div>
    </div>
    <div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th>ID</th>
                <th class="title">名称</th>
                <th>发布者</th>
                <th>发布时间</th>
                <th>最新操作人</th>
                <th>最新操作时间</th>
                <th>管理</th>
            </tr>
            </thead>
            <tbody>
            <c:if test="${fn:length(informationModuleList) gt 0}">
                <tbody>
                <%int i=0;%>
                <c:forEach items="${informationModuleList}" var="info">
                    <%i++;%>
                    <tr>
                       <td><%=i%></td>
                       <td class="title">${info.informationModuleName}</td>
                       <td>${info.createUser}</td>
                       <td><fmt:formatDate value="${info.createTime}"  pattern="yyyy-MM-dd HH:mm" type="both"/></td>
                       <td>${info.updateUser}</td>
                       <td><fmt:formatDate value="${info.updateTime}"  pattern="yyyy-MM-dd HH:mm" type="both"/></td>
                       <td>
	                       <%-- <a target="main" class="delete" informationModuleId="${info.informationModuleId}"><font color="red">删除</font></a> | --%>
	                       <a target="main" class="informationModule-edit"  informationModuleId="${info.informationModuleId}">编辑</a>
                       </td>
                    </tr>
                </c:forEach>
                </tbody>
            </c:if>
            <c:if test="${empty informationModuleList}">
                <tr>
                    <td colspan="7"> <h4 style="color:#DC590C">暂无数据!</h4></td>
                </tr>
            </c:if>
            </tbody>
        </table>
        <c:if test="${not empty informationModuleList}">
            <input type="hidden" id="page" name="page" value="${page.page}" />
            <div id="kkpager"></div>
        </c:if>
    </div>
</form>
<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
<script type="text/javascript">
	if(!'${sessionScope.user}'){
		window.location.href="${pageContext.request.contextPath}/login.do";
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

    $(function(){
        kkpager.generPageHtml({
            pno : '${page.page}',
            total : '${page.countPage}',
            totalRecords :  '${page.total}',
            mode : 'click',//默认值是link，可选link或者click
            click : function(n){
                this.selectPage(n);
                $("#page").val(n);
                formSub('#informationModuleForm');
                return false;
            }
        });

        $(function () {
            
         	// 新增资讯
            $('.btn-add').on('click', function () {
                   window.location.href = "${path}/ccpInformationModule/preInformationModule.do";
            });

            //编辑资讯
            $('.informationModule-edit').on('click', function () {
                var informationModuleId = $(this).attr("informationModuleId");
                window.location.href = "${path}/ccpInformationModule/preInformationModule.do?informationModuleId="+informationModuleId;
            });
            
            $(".delete").on("click", function(){
                var informationModuleId = $(this).attr("informationModuleId");
                var name = $(this).parent().siblings(".title").text();
                var html = "您确定要删除" + name + "吗？";
                dialogConfirm("提示", html, function(){
                    $.post("${path}/ccpInformationModule/deleteInformationModule.do",{informationModuleId:informationModuleId},function(result) {
                        if (result == "success") {
                            dialogTypeSaveDraft("提示", "删除成功", function(){
                                window.location.href="${path}/ccpInformationModule/informationModuleIndex.do";
                            });
                        }else{
                            dialogTypeSaveDraft("提示", "删除失败");
                        }
                    });
                })
            });
       
        });                  
    });

    function dialogTypeSaveDraft(title, content, fn) {
        var d = window.dialog({
            width: 400,
            title: title,
            content: content,
            fixed: true,
            okValue: '确 定',
            ok: function () {
                if (fn)  fn();
            }
        });
        d.showModal();
    }
    
    function formSub(formName){
        if($("#informationModuleName").val() == "输入关键词"){
            $("#informationModuleName").val("");
        }
        $(formName).submit();
    }
    
</script>
</body>
</html>
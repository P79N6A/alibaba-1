<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>文化云</title>
<%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
<%@ include file="/WEB-INF/why/common/limit.jsp"%>
</head>
<body>
<form id="tagForm" method="post" action="${path}/beipiaoInfoTag/tagList.do">
<div class="site">
    <em>您现在所在的位置：</em>标签管理 &gt; 标签列表
</div>
<div class="search">
    <div class="search-box">
        <i></i><input type="text" data-val="请输入名称" value="<c:choose><c:when test="${not empty bpInfoTag.tagName}">${bpInfoTag.tagName}</c:when><c:otherwise>请输入名称</c:otherwise></c:choose>" class="input-text" name="tagName" id="tagName"/>
    </div>
    <div class="select-btn">

        <input type="button" value="搜索" onclick="searchtag()"/>

    </div>
    <div class="search menage">
        <div class="menage-box">
            <a class="btn-add" href="javascript:void(0);">添加标签</a>
        </div>
    </div>
</div>
<div class="main-content">
    <table width="100%">
        <thead>
        <tr>
            <th>ID</th>
            <th>标签名称</th>
            <th>标签编码</th>
            <th>操作人</th>
            <th>操作时间</th>
            <th>运营位数量</th>
            <th>管理</th>
        </tr>
        </thead>
        <tbody>
        <%int i=0;%>
        <c:if test="${null != list}">
            <c:forEach items="${list}" var="data" varStatus="status">
                <%i++;%>
                <tr>
                    <td width="65"><%=i%></td>

                    <c:choose>
                        <c:when test="${not empty data.tagName}">
                            <td class="name"  width="140">${data.tagName}</td>
                        </c:when>
                        <c:otherwise>
                            <td></td>
                        </c:otherwise>
                    </c:choose>
                    
                    <c:choose>
                        <c:when test="${not empty data.tagCode}">
                            <td width="140">${data.tagCode}</td>
                        </c:when>
                        <c:otherwise>
                            <td></td>
                        </c:otherwise>
                    </c:choose>

                    <c:choose>
                        <c:when test="${not empty data.userAccount}">
                            <td width="70">${data.userAccount}</td>
                        </c:when>
                        <c:otherwise>
                            <td width="70"></td>
                        </c:otherwise>
                    </c:choose>

                    <c:choose>
                        <c:when test="${not empty data.tagUpdateTime}">
                            <td width="140">
                                <fmt:formatDate value="${data.tagUpdateTime}" pattern="yyyy-MM-dd HH:mm"/>
                            </td>
                        </c:when>
                        <c:otherwise>
                            <td width="70"></td>
                        </c:otherwise>
                    </c:choose>
                    
                     <c:choose>
                        <c:when test="${not empty data.tagAmount}">
                            <td width="70">${data.tagAmount }</td>
                        </c:when>
                        <c:otherwise>
                            <td width="70"></td>
                        </c:otherwise>
                    </c:choose>

                    <td width="120" class="td-editing">
                    	<a class="delete" data-id="${data.tagId }">删除</a> |
                        <a class="btn-edit"  data-id="${data.tagId }">编辑</a>
                    </td>
                </tr>
            </c:forEach>
        </c:if>
        <c:if test="${empty list}">
            <tr>
                <td colspan="9"><h4 style="color:#DC590C">暂无数据!</h4></td>
            </tr>
        </c:if>
        </tbody>
    </table>
    <c:if test="${not empty list}">
        <input type="hidden" id="page" name="page" value="${page.page}" />
        <div id="kkpager"></div>
    </c:if>
</form>
<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
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
                searchtag();
                return false;
            }
        });

        deleteRole();
    });

    function deleteRole(){
        $(".delete").on("click", function(){
            var tagId = $(this).attr("data-id");
            var name = $(this).parent().parent().find(".name").html();
            var html = "您确定要删除" + name + "吗？";
            dialogConfirm("提示", html, function(){
                $.post("${path}/beipiaoInfoTag/delTag.do",{"tagId":tagId},function(data) {
                	if (data != null && data == 'success') {
                        dialogAlert("提示","删除成功！",function(){
                      	  window.location.href = "${path}/beipiaoInfoTag/tagList.do";
                        });
                    }else if (data == "noLogin") {                      	
                  	  dialogConfirm("提示", "请先登录！", function(){
                  		  window.location.href = "${path}/login.do";
  	                    	 });
                    } else {
                        dialogConfirm("提示", "删除失败！")
                    }
                });
            })
        });
    }

    function searchtag(){
        var tagCode = $("#tagCode").val();
        var tagName = $("#tagName").val();
        if(tagCode == "请输入编码"){
            $("#tagCode").val("");
        }
        if(tagName == "请输入名称"){
            $("#tagName").val("");
        }
        $("#tagForm").submit();
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
                url: '${path}/beipiaoInfoTag/tagAddPage.do',
                title: '标签新增',
                width: 500,
                height:350,
                fixed: true
            }).showModal();
            return false;
        });

        $('.btn-edit').on('click', function () {
            var tagId = $(this).attr("data-id");
            dialog({
                url: '${path}/beipiaoInfoTag/preEditTag.do?tagId='+tagId,
                title: '标签编辑',
                width: 500,
                height:250,
                fixed: true
            }).showModal();
            return false;
        });
    });

</script>
</body>
</html>
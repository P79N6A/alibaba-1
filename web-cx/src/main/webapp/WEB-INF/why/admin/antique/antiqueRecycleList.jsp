<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>藏品回收站-文化云</title>
    <%@include file="../../common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    <script type="text/javascript">
        /*$(function() {
            var venueId = '${cmsVenue.venueId}';
            $.post(
                    "${path}/antiqueType/getTypeList.do",
                    {
                        'venueId' : venueId
                    },
                    function(data) {
                        if (data != '' && data != null) {
                            var st ='${record.antiqueVenueId}';
                            var list = eval(data);
                            var ulHtml = '<li data-option="">所有分类</li>';
                            for (var i in data) {
                                var dict = list[i];
                                ulHtml += '<li data-option="'+dict.antiqueTypeId+'">'
                                + dict.antiqueTypeName + '</li>';
                                if(st!="" && st==dict.antiqueTypeId){
                                    $('#tagTypeDiv').html(dict.antiqueTypeName);
                                }
                            }
                            $('#tagType').html(ulHtml);
                        }

                    }).success(function() {
                        $.post(
                                "${path}/sysdict/queryChildSysDictByDictCode.do",
                                {
                                    'dictCode' : 'DYNASTY'
                                },
                                function(data) {
                                    if (data != '' && data != null) {
                                        var sty ='${record.antiqueYears}';
                                        //alert(sty);
                                        var list = eval(data);
                                        var ulHtml = '<li data-option="">所有朝代</li>';
                                        for (var i = 0; i < list.length; i++) {
                                            var dict = list[i];
                                            ulHtml += '<li data-option="'+dict.dictId+'">'
                                            + dict.dictName + '</li>';
                                            if(sty!=""&&sty==dict.dictId){
                                                $('#tagDynastyDiv').html(dict.dictName);
                                            }
                                        }
                                        $('#tagDynasty').html(ulHtml);
                                    }
                                }).success(function() {
                                    selectModel();
                                });
                    });
        });*/

        //回收站物理删除
        function deleteAntique(antiqueId,name){
            var html = "您确定要彻底删除" + name + "吗？";
            dialogConfirm("提示", html, function(){
                $.post("${path}/antique/physicalDelete.do",{"antiqueId":antiqueId}, function(data) {
                    if (data!=null && data=='success') {
                        dialogSaveDraft("提示", "<h2>删除成功</h2>", function(){
                            window.location.href="${path}/antique/antiqueIndex.do?antiqueState=5&asm"+new Date().getTime();
                        });
                            //var antiqueIsDel = $("#antiqueIsDel").val();
                            //var antiqueState = $("#antiqueState").val();
                    } else {
                        dialogSaveDraft("提示", "<h2>删除失败,请联系管理员</h2>", function(){
                        });

                    }
                });
            });
        }

        function recoverAntique(antiqueId,name){
            var html = "您确定要还原" + name + "吗？";
            dialogConfirm("提示", html, function(){
                    $.post("${path}/antique/recoverAntique.do",{"antiqueId":antiqueId}, function(data) {
                        if (data!=null && data=='success') {
                                //var antiqueIsDel = $("#antiqueIsDel").val();
                                //var antiqueState = $("#antiqueState").val();
                            dialogSaveDraft("提示", "<h2>还原成功</h2>", function(){
                                var asm  = new Date().getTime();
                                window.location.href="${path}/antique/antiqueIndex.do?antiqueState=5&asm="+asm;
                            });

                        } else {
                            dialogSaveDraft("提示", "<h2>还原失败,请联系管理员</h2>", function(){
                            });
                        }
                    });
            });
        }

        //提交表单
        function formSub(formName){
        	var searchKey = $("#searchKey").val();
            if(searchKey == "请输入藏品名称\\发布人\\操作人"){		//"\\"代表一个反斜线字符\
                $("#searchKey").val("");
            }
            $(formName).submit();
        }
     </script>
</head>
<body>

<div class="site">
    <em>您现在所在的位置：</em>藏品管理&gt;藏品回收站
</div>
<%--条件检索--%>
<form id="antiqueForm" action="${path}/antique/antiqueIndex.do" method="post">
    <%--<input id="antiqueIsDel" type="hidden" name="antiqueIsDel" value="${record.antiqueIsDel}"/>--%>
        <input type="hidden" name="antiqueState" value="${record.antiqueState}" />
        <div class="search">

            <div class="search-box">
	            <i></i><input id="searchKey" name="searchKey" class="input-text" data-val="请输入藏品名称\发布人\操作人" type="text"
	                          value="<c:choose><c:when test="${not empty searchKey}">${searchKey}</c:when><c:otherwise>请输入藏品名称\发布人\操作人</c:otherwise></c:choose>"/>
	        </div>

<%--            <div class="select-box w135">
                <input type="hidden"/>
                <div class="select-text" data-value="" id="tagTypeDiv" >全部类型</div>
                <input type="hidden" name="antiqueVenueId" value="${record.antiqueVenueId}" id="antiqueVenueId" />
                <ul class="select-option" id="tagType">

                </ul>
            </div>

            <div class="select-box w135">
                <input type="hidden" name="antiqueYears" value="${record.antiqueYears}" />
                <div class="select-text" data-value=""  id="tagDynastyDiv" >全部朝代</div>
                <ul class="select-option" id="tagDynasty"  id="antiqueYears" >

                </ul>
            </div>--%>

            <div class="select-btn">
                <input type="button" value="搜索" onclick="$('#page').val(1);formSub('#antiqueForm')"/>
            </div>

        </div>


<%--内容--%>
    <div class="main-content pt10">
        <table width="100%">
            <thead>
            <tr>
                <th>ID</th>
                <th class="title">藏品名称</th>
                <th class="venue">所属场馆</th>
                <th>藏品位置</th>
	            <th>发布者</th>
	            <th>发布时间</th>
	            <th>最新操作人</th>
	            <th>最新操作时间</th>
                <%--<th>状态</th>--%>
                <th>管理</th>
            </tr>
            </thead>

            <c:if test="${empty list}">
                <tr>
                    <td colspan="7"> <h4 style="color:#DC590C">暂无数据!</h4></td>
                </tr>
            </c:if>

            <tbody>

            <c:forEach items="${list}" var="c" varStatus="s">
                <tr>
                    <td>${s.index+1}</td>
                    <td class="title"><a href="javascript:;">${c.antiqueName}</a></td>
                    <td class="venue"><a href="javascript:;">${c.antiqueVideoUrl}</a></td>
                    <td>${c.antiqueGalleryAddress}</td>
	                <td>${c.antiqueCreateUser}</td>
	                <td><fmt:formatDate value="${c.antiqueCreateTime}" pattern="yyyy-MM-dd HH:mm" /></td>
	                <td>${c.antiqueUpdateUser}</td>
	                <td><fmt:formatDate value="${c.antiqueUpdateTime}" pattern="yyyy-MM-dd HH:mm" /></td>
 <%--                   <td>
                        <c:choose>
                            <c:when test="${c.antiqueState==1}">
                                草稿
                            </c:when>
                            <c:when test="${c.antiqueState==2}">
                                已审核
                            </c:when>
                            <c:when test="${c.antiqueState==3}">
                                审核中
                            </c:when>
                            <c:when test="${c.antiqueState==4}">
                                退回
                            </c:when>
                            <c:when test="${c.antiqueState==5}">
                                回收站
                            </c:when>
                            <c:when test="${c.antiqueState==6}">
                                已发布
                            </c:when>
                        </c:choose>
                    </td>--%>

                    <td>
                       <%-- <a href="${path}/antique/preEditAntique.do?antiqueId=${c.antiqueId}&antiqueState=${c.antiqueState}&antiqueIsDel=${c.antiqueIsDel}">编辑</a> |
                        <a href="${path}/frontAntique/antiqueDetail.do?antiqueId=${c.antiqueId}" target="_blank">查看</a>--%>

<%--                           <c:forEach items="${sessionScope.user.sysModuleList}" var="module">
                               <c:if test="${module.moduleUrl == '${path}/antique/preEditAntique.do'}">--%>
                                   <%-- <a href="${path}/antique/preEditAntique.do?antiqueId=${c.antiqueId}&antiqueState=${c.antiqueState}&antiqueIsDel=${c.antiqueIsDel}">编辑</a>| --%>
<%--                               </c:if>
                           </c:forEach>--%>

<%--                           <c:forEach items="${sessionScope.user.sysModuleList}" var="module">
                               <c:if test="${module.moduleUrl == '${path}/antique/deleteAntique.do'}">--%>
                               		<%
			                            if(antiquePhysicalDeleteButton) {
			                        %>
                                       <a class="delete" href="javascript:deleteAntique('${c.antiqueId}','${c.antiqueName}')">删除</a>|
                                    <%
			                            }
			                        %>
<%--                               </c:if>
                           </c:forEach>--%>


<%--                          <c:forEach items="${sessionScope.user.sysModuleList}" var="module">
                               <c:if test="${module.moduleUrl == '${path}/antique/recoverAntique.do'}">--%>
                               		<%
			                            if(antiqueRecoverButton) {
			                        %>
                                       <a href="javascript:recoverAntique('${c.antiqueId}','${c.antiqueName}')">还原</a>
                                    <%
			                            }
			                        %>
<%--                               </c:if>
                           </c:forEach>--%>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>



        <c:if test="${not empty list}">
            <input type="hidden" id="page" name="page" value="${page.page}" />
            <div id="kkpager"></div>
        </c:if>
</form>
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
                        formSub('#antiqueForm');
                        return false;
                    }
                });
            });
        </script>
    </div>


</body>
</html>
<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>活动列表--文化云</title>
    <%@include file="../../common/pageFrame.jsp"%>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    <script type="text/javascript">
        $(function() {
            $.post(
                    "${path}/sysdict/queryChildSysDictByDictCode.do",
                    {
                        'dictCode' : 'ANTIQUE'
                    },
                    function(data) {
                        if (data != '' && data != null) {
                            var st ='${record.antiqueVenueId}';
                            var list = eval(data);
                            var ulHtml = '<li data-option="">所有分类</li>';
                            for (var i = 0; i < list.length; i++) {
                                var dict = list[i];
                                ulHtml += '<li data-option="'+dict.dictId+'">'
                                + dict.dictName + '</li>';
                                if(st!="" && st==dict.dictId){
                                    $('#tagTypeDiv').html(dict.dictName);
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
        });

        //回收站物理删除
        function deleteAntique(antiqueId,name){
            var html = "您确定要删除" + name + "吗？";
            dialogConfirm("提示", html, function(){
                $.post("${path}/antique/physicalDelete.do",{"antiqueId":antiqueId}, function(data) {
                    if (data!=null && data=='success') {
                            //var antiqueIsDel = $("#antiqueIsDel").val();
                            //var antiqueState = $("#antiqueState").val();
                            window.location.href="${path}/antique/antiqueIndex.do?antiqueState=5&asm"+new Date().getTime();
                    } else {
                        alert("删除失败,请联系管理员!");
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
                                var asm  = new Date().getTime();
                                window.location.href="${path}/antique/antiqueIndex.do?antiqueState=5&asm="+asm;
                        } else {
                            alert("还原失败,请联系管理员!");
                        }
                    });
            });
        }
     </script>
</head>
<body>

<div class="site">
    <em>您现在所在的位置：</em>藏品管理&gt;藏品回收站
</div>
<%--条件检索--%>
<form id="antique_form" action="${path}/antique/antiqueIndex.do" method="post">
    <%--<input id="antiqueIsDel" type="hidden" name="antiqueIsDel" value="${record.antiqueIsDel}"/>--%>
        <input type="hidden" name="antiqueState" value="${record.antiqueState}" />
        <div class="search">

            <div class="search-box">
                <i></i><input type="text" class="input-text" name="antiqueName" value="${record.antiqueName}" />
            </div>

            <div class="select-box w135">
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
            </div>

            <div class="select-btn">
                <input type="submit" value="搜索"/>
            </div>

        </div>

</form>
<%--内容--%>
    <div class="main-content pt10">
        <table width="100%">
            <thead>
            <tr>
                <th>ID</th>
                <th class="title">馆藏名称</th>
                <th class="venue">所属场馆</th>
                <th>操作人</th>
                <th>操作时间</th>
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
                    <td class="venue"><a href="javascript:;">${c.antiqueVoiceUrl}</a></td>
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

                           <c:forEach items="${sessionScope.user.sysModuleList}" var="module">
                               <c:if test="${module.moduleUrl == '${path}/antique/preEditAntique.do'}">
                                   <a href="${path}/antique/preEditAntique.do?antiqueId=${c.antiqueId}&antiqueState=${c.antiqueState}&antiqueIsDel=${c.antiqueIsDel}">编辑</a>|
                               </c:if>
                           </c:forEach>

                           <c:forEach items="${sessionScope.user.sysModuleList}" var="module">
                               <c:if test="${module.moduleUrl == '${path}/antique/deleteAntique.do'}">
                                       <a class="delete" href="javascript:deleteAntique('${c.antiqueId}','${c.antiqueName}')">删除</a>|
                               </c:if>
                           </c:forEach>


                          <c:forEach items="${sessionScope.user.sysModuleList}" var="module">
                               <c:if test="${module.moduleUrl == '${path}/antique/recoverAntique.do'}">
                                       <a href="javascript:recoverAntique('${c.antiqueId}','${c.antiqueName}')">还原</a>
                               </c:if>
                           </c:forEach>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>

        <input type="hidden" id="page" name="page" value="${page.page}" />

        <c:if test="${not empty list}">
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
                        formSub('#antiqueIndexForm');
                        return false;
                    }
                });
            });
            //提交表单
            function formSub(formName){
                $(formName).submit();
            }
        </script>
    </div>
</form>

</body>
</html>
<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>活动列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
<script type="text/javascript" >
    $(function(){
        kkpager.generPageHtml({
            pno : '${page.page}',
            total : '${page.countPage}',
            totalRecords :  '${page.total}',
            mode : 'click',//默认值是link，可选link或者click
            click : function(n){
                this.selectPage(n);
                $("#page").val(n);
                $('#tag_form').submit();
                return false;
            }
        });
    });
    $(function() {
        var tagType = $("#tagType").val();
        $.post("${path}/sysdict/queryCode.do",{'dictCode':'tagType'},function(data){
            if(data != '' && data != null){
                var list = eval(data);
                var ulHtml = '<li data-option="">所有类型</li>';
                for(var i = 0;i<list.length;i++){
                    var dict = list[i];
                    ulHtml +='<li data-option="'+dict.dictId+'">'+dict.dictName+'</li>';
                    if(tagType != '' && dict.dictId == tagType){
                      $('#tagTypeDiv').html(dict.dictName);
                    }
                }
                 $('#tagTypeUl').html(ulHtml);
            }
            }).success(function(){
            });
        });

    //选择一行编辑标签
    function toEdit(tagId) {
        location.href = "${path}/tag/preEditTag.do?tagId=" + tagId;
    }
    //进入标签添加页
    function toAdd() {
        location.href = "${path}/tag/preEditTag.do";
    }

    //删除标签信息，支持批量删除
    function toDelete(tagId) {
        jConfirm('确定要删除这条数据吗?','确认提示框',function (r) {
        if (r) {
            $.post("${path}/tag/delTag.do", {'tagId' : tagId}, function(data) {
            if (data == "success") {
                jAlert('删除成功', '系统提示', 'success',function (r){
                location.reload();
            });
            } else {
                 jAlert('添加失败:' + data, '系统提示','',function (r){
            });
         }
     });}
    });
    }
    </script>

</head>
<body>
<form action="${path }/tag/tagIndex.do" id="tag_form" method="post" name="tag_form">
<div class="site">
    <em>您现在所在的位置：</em>字典管理 &gt; 待审核
</div>
<div class="search">
    <div class="search-box">
        <input type="text" value="${tag.tagName}" id="tagName" name="tagName" data-val="输入标签名称"  class="input-text" />
    </div>
    <div class="select-box w110">
        <input type="hidden" value="${tag.tagType}" name="tagType" id="tagType"/>
        <div class="select-text" data-value=""  id="tagTypeDiv">
            所有分类
        </div>
        <ul class="select-option" id="tagTypeUl"></ul>
    </div>
    <div class="select-box w135">
        <input type="hidden" value="${activity.activitySalesOnline}" name="activitySalesOnline" id="activitySalesOnline"/>
        <div class="select-text" data-value="">
            <c:choose>
                <c:when test="${activity.activitySalesOnline == 'Y'}">
                    在线选座
                </c:when>
                <c:when test="${activity.activitySalesOnline == 'N'}">
                    自由入座
                </c:when>
                <c:otherwise>
                    所有
                </c:otherwise>
            </c:choose>
        </div>
        <ul class="select-option">
            <li data-option="">所有</li>
            <li data-option="Y"  >在线选座</li>
            <li data-option="N"  >自由入座</li>
        </ul>
    </div>
    <div class="select-btn">
        <input type="submit" value="搜索"/>
    </div>

</div>
<div class="main-content">
    <table width="100%">
        <thead>
        <tr>
            <th >序号</th>
            <th class="title">标签名称</th>
            <th class="venue">标签分类</th>
            <th>操作人</th>
            <th >操作时间</th>
            <th >管理</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${list}" var="tag" varStatus="tags">
            <tr>
                <td>${tags.index+1 }</td>
                <td class="title">${tag.TAG_NAME }</td>
                <td class="venue">${tag.DICT_NAME }</td>
                <td >${tag.USER_ACCOUNT }</td>
                <td>
                    <fmt:formatDate value="${tag.TAG_CREATE_TIME}"  pattern="yyyy-MM-dd HH:mm" /></td>
                </td>
                <td >
                    <c:forEach items="${sessionScope.user.sysModuleList}" var="module">
                        <c:if test="${module.moduleUrl == '${path}/tag/delTag.do'}">
                            <a href="#" onclick="toDelete('${tag.TAG_ID}')">删除</a>|
                        </c:if>
                    </c:forEach>
                    <c:forEach items="${sessionScope.user.sysModuleList}" var="module">
                        <c:if test="${module.moduleUrl == '${path}/tag/preEditTag.do'}">
                            <a href="#" onclick="toEdit('${tag.TAG_ID}')">编辑</a>|
                        </c:if>
                    </c:forEach>
                        <%--<a href="#">查看</a>--%>
                </td>
            </tr>
        </c:forEach>


        </tbody>
    </table>
    <input type="hidden" id="page" name="page" value="${page.page}" />
    <div id="kkpager" style="width:800px;margin:20 auto;"></div>
</div>
</form>
</body>
</html>
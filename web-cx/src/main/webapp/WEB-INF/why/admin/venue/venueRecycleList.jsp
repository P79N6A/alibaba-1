<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

    <title>场馆回收站列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@ include file="/WEB-INF/why/common/limit.jsp"%>

    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    <script type="text/javascript">
        $(function() {
        	//区县搜索
            var defaultAreaId = $("#areaData").val();
            $.post("${path}/venue/getLocArea.do",function(areaData) {
                var ulHtml = "<li data-option=''>全部区县</li>";
                var divText = "全部区县";
                if (areaData != '' && areaData != null) {
                    for(var i=0; i<areaData.length; i++){
                        var area = areaData[i];
                        var areaId = area.id;
                        var areaText = area.text;
                        ulHtml += '<li data-option="'+areaId+'">'
                        + areaText
                        + '</li>';
                        if(defaultAreaId == areaId){
                            divText = areaText;
                        }
                    }
                    $("#areaDiv").html(divText);
                    $("#areaUl").html(ulHtml);
                }
            }).success(function() {
            	//类型搜索
                var defaultTypeId = $("#venueType").val();
                $.post("${path}/tag/getChildTagByType.do?code=VENUE_TYPE",function(venueType) {
                    var ulHtml = "<li data-option=''>全部类别</li>";
                    var divText = "全部类别";
                    if (venueType != '' && venueType != null) {
                        for(var i=0; i<venueType.length; i++){
                            var type = venueType[i];
                            var typeId = type.tagId;
                            var typeText = type.tagName;
                            ulHtml += '<li data-option="'+typeId+'">'
                            + typeText
                            + '</li>';
                            if(defaultTypeId == typeId){
                                divText = typeText;
                            }
                        }
                        $("#venueTypeDiv").html(divText);
                        $("#venueTypeUl").html(ulHtml);
                    }
                }).success(function() {
                    selectModel();
                });
            });

            $(".delete").on("click", function(){
                var venueId = $(this).attr("id");
                var name = $(this).parent().siblings(".title").find("a").text();
                var html = "您确定要彻底删除  " + name + "  吗？";
                dialogConfirm("提示", html, function(){
                    $.post("${path}/venue/totalDeleteVenue.do",{"venueId":venueId}, function(data) {
                        if (data!=null && data=='success') {
                            window.location.href="${path}/venue/venueRecycleList.do";
                        }
                    });
                })
            });
        });

        /**
         * 还原场馆
         */
        function backVenue(venueId){
            var html = "您确定要还原吗？";
            dialogConfirm("提示", html, function(){
                $.post("${path}/venue/backVenue.do",{"venueId":venueId}, function(data) {
                    if (data!=null && data=='success') {
                        window.location.href="${path}/venue/venueRecycleList.do";
                    }
                });
            })
        }
    </script>
</head>
<body>

<div class="site">
    <em>您现在所在的位置：</em>场馆管理 &gt; 场馆信息管理&gt; 场馆回收站
</div>
<form id="venueIndexForm" method="post" action="${path}/venue/venueRecycleList.do">
<div class="search">
    <div class="search-box">
        <i></i><input id="searchKey" name="searchKey" class="input-text" data-val="请输入场馆名称\发布人\操作人" type="text"
                      value="<c:choose><c:when test="${not empty searchKey}">${searchKey}</c:when><c:otherwise>请输入场馆名称\发布人\操作人</c:otherwise></c:choose>"/>
    </div>
    <div class="select-box w135">
     <input type="hidden" name="areaData" id="areaData" value="${areaData}"/>
     <div id="areaDiv" class="select-text" data-value="">全部区县</div>
     <ul id="areaUl" class="select-option">
     </ul>
    </div>
    <div class="select-box w135">
    	<input type="hidden" name="venueType" id="venueType" value="${venueType}"/>
        <div id="venueTypeDiv" class="select-text" data-value="" >全部类型</div>
        <ul id="venueTypeUl" class="select-option">
        </ul>
    </div>
    <div class="select-btn">
        <input type="button" value="搜索" onclick="$('#page').val(1);formSub('#venueIndexForm')"/>
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
            <th>发布者</th>
            <th>发布时间</th>
            <th>最新操作人</th>
            <th>最新操作时间</th>
            <th width="80">状态</th>
            <th width="120">管理</th>
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
                <td class="title"><c:out escapeXml="true" value="${c.venueName}"/></td>
                <td>${fn:substringAfter(c.venueArea, ',')}</td>
                <td>${c.venueType}</td>
                <td>${c.venueCreateUser }</td>
                <td><fmt:formatDate value="${c.venueCreateTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                <td>${c.venueUpdateUser }</td>
                <td><fmt:formatDate value="${c.venueUpdateTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                <td>
                    <c:if test="${c.venueState ==1}">
                        草稿
                    </c:if> <c:if test="${c.venueState ==2}">
                        已审核
                    </c:if> <c:if test="${c.venueState ==3}">
                        审核中
                    </c:if> <c:if test="${c.venueState ==4}">
                        退回
                    </c:if>
                    <c:if test="${c.venueState ==5}">
                        回收站
                    </c:if>
                    <c:if test="${c.venueState==6}">
                        已发布
                    </c:if>
                </td>
                <td class="operate">
                    <%
                        if(deleteRecycleButton){
                    %>
                    <a class="delete" id="${c.venueId}">删除</a> |

                    <%
                        }
                    %>

                    <%
                        if(backVenueButton){
                    %>
                        <a href="javascript:;"  onclick="backVenue('${c.venueId}')">还原</a>
                    <%
                        }
                    %>

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
                    formSub('#venueIndexForm');
                    return false;
                }
            });
        });

        //提交表单
        function formSub(formName){
        	var searchKey = $("#searchKey").val();
            if(searchKey == "请输入场馆名称\\发布人\\操作人"){		//"\\"代表一个反斜线字符\
                $("#searchKey").val("");
            }
            $(formName).submit();
        }
    </script>
</div>
</form>

</body>
</html>
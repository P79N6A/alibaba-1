<%@ page language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>社团列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <%@include file="/WEB-INF/why/common/limit.jsp" %>

    <link rel="Stylesheet" type="text/css" href="${path}/STATIC/css/DialogBySHF.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/DialogBySHF.js"></script>
    <script type="text/javascript">

        //搜索
        function formSub(formName) {
            $(formName).submit();
        }

        $(document).ready(function () {

            /*点击确定按钮，关闭登录框*/
            $(".btn-publish").on("click", function(){
                $("body",parent.document).find('#DialogBySHFLayer,#DialogBySHF').remove();
            });
            //区县搜索
            var defaultAreaId = $("#areaData").val();
            $.post("${path}/venue/getLocArea.do", function (areaData) {
                var ulHtml = "<li data-option=''>全部区县</li>";
                var divText = "全部区县";
                if (areaData != '' && areaData != null) {
                    for (var i = 0; i < areaData.length; i++) {
                        var area = areaData[i];
                        var areaId = area.id;
                        var areaText = area.text;
                        ulHtml += '<li data-option="' + areaId + '">'
                            + areaText
                            + '</li>';
                        if (defaultAreaId == areaId) {
                            divText = areaText;
                        }
                    }
                    $("#areaDiv").html(divText);
                    $("#areaUl").html(ulHtml);
                }
            }).success(function () {
                //类型搜索
                var defaultTypeId = $("#venueType").val();
                $.post("${path}/tag/getChildTagByType.do?code=VENUE_TYPE", function (venueType) {
                    var ulHtml = "<li data-option=''>全部类别</li>";
                    var divText = "全部类别";
                    if (venueType != '' && venueType != null) {
                        for (var i = 0; i < venueType.length; i++) {
                            var type = venueType[i];
                            var typeId = type.tagId;
                            var typeText = type.tagName;
                            ulHtml += '<li data-option="' + typeId + '">'
                                + typeText
                                + '</li>';
                            if (defaultTypeId == typeId) {
                                divText = typeText;
                            }
                        }
                        $("#venueTypeDiv").html(divText);
                        $("#venueTypeUl").html(ulHtml);
                    }
                }).success(function () {
                    selectModel();
                });
            });

            kkpager.generPageHtml({
                pno: '${page.page}',
                total: '${page.countPage}',
                totalRecords: '${page.total}',
                mode: 'click',//默认值是link，可选link或者click
                click: function (n) {
                    this.selectPage(n);
                    $("#page").val(n);
                    formSub('#venueIndexForm');
                    return false;
                }
            });
        });

        //全选或全不选
        function checkAll() {
            $("#list-table :checkbox").each(function () {
                if ($('#all').prop('checked')) {
                    $(this).prop("checked", true);
                } else {
                    $(this).prop("checked", false);
                }
            });
        }

        function relationAllVenue(){
            var arr = new Array();
            $("#list-table :checkbox").each(function () {
                var checked=$(this).prop("checked");
                if(checked)   arr.push($(this).val());
            });
            if(arr.length==0) {
                dialogAlert("提示", "请选择需要关联的数据！");
                return;
            }
            dialogConfirm("提示", "您确定要关联所选场馆吗？", function () {
                $.post("${path}/member/relationVenue.do", {venueIds: arr.toString(),memberId:'${memberId}',state:1}, function (data) {
                    data = JSON.parse(data);
                    if ('200' == data.status) {
                        dialogAlert('提示', '操作成功', function () {
                            formSub('#venueIndexForm');
                        });
                    } else {
                        dialogAlert('提示', data.data, function () {
                            formSub('#venueIndexForm');
                        });
                    }
                });
            });
        }

        function relationVenue(venueId,state) {
            $.post("${path}/member/relationVenue.do", {venueIds: venueId,memberId:'${memberId}',state:state}, function (data) {
                data = JSON.parse(data);
                if ('200' == data.status) {
                    dialogAlert('提示', '操作成功', function () {
                        formSub('#venueIndexForm');
                    });
                } else {
                    dialogAlert('提示', data.data);
                }
            });
        }

    </script>
    <style type="text/css">
        .ui-dialog-title, .ui-dialog-content textarea {
            font-family: Microsoft YaHei;
        }

        .ui-dialog-header {
            border-color: #9b9b9b;
        }

        .ui-dialog-close {
            display: none;
        }

        .ui-dialog-title {
            color: #F23330;
            font-size: 20px;
            text-align: center;
        }

        .ui-dialog-content {
        }

        .ui-dialog-body {
        }
    </style>
</head>
<body>
<form id="venueIndexForm" method="post" action="${path}/venue/relationVenueIndex.do">
    <div class="search" style="height: 30px;">
        <input type="hidden" name="memberId" value="${param.memberId}"/>
        <div class="search-box">
            <i></i><input id="venueName" name="venueName" class="input-text" placeholder="场馆名称" type="text"
                          value="${venue.venueName}"/>
        </div>
        <div class="select-box w135">
            <input type="hidden" name="venueArea" id="venueArea" value="${venue.venueArea}"/>
            <div id="areaDiv" class="select-text" data-value="">全部区县</div>
            <ul id="areaUl" class="select-option">
            </ul>
        </div>
        <div class="select-box w135">
            <input type="hidden" name="venueType" id="venueType" value="${venue.venueType}"/>
            <div id="venueTypeDiv" class="select-text" data-value="">全部类型</div>
            <ul id="venueTypeUl" class="select-option">
            </ul>
        </div>

        <div class="select-box w135">
            <input type="hidden" name="relationType" id="relationType" value="${venue.relationType}"/>
            <div id="relationTypeDiv" class="select-text" data-value="">关联状态</div>
            <ul id="relationTypeUl" class="select-option">
                <li data-option="" class="">关联状态</li>
                <li data-option="1">已关联</li>
                <li data-option="0">未关联</li>
            </ul>
        </div>

        <div class="select-btn">
            <input type="button" value="搜索" onclick="$('#page').val(1);formSub('#venueIndexForm')"/>
        </div>
        <div class="select-btn" style="margin-left: 20px;">
            <input type="button" value="批量关联" onclick="relationAllVenue()"/>
        </div>
    </div>
    <div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th><input type="checkbox" id="all" onclick="checkAll()" /></th>
                <th class="title">场馆名称</th>
                <th>所属区县</th>
                <th>场馆类型</th>
                <th>发布者</th>
                <th>发布时间</th>
                <th>最新操作人</th>
                <th>最新操作时间</th>
                <th>状态</th>
                <th>操作</th>
            </tr>
            </thead>
            <c:if test="${empty venueList}">
                <tr>
                    <td colspan="8"><h4 style="color:#DC590C">暂无数据!</h4></td>
                </tr>
            </c:if>
            <tbody  id="list-table">

            <c:forEach items="${venueList}" var="c" varStatus="s">
                <tr>
                    <td>
                        <input type="checkbox" name="venueId" value="${c.venueId}"/>
                    </td>
                    <td class="title"><c:out escapeXml="true" value="${c.venueName }"/></td>
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
                            <c:choose>
                                <c:when test="${c.venueIsRecommend==2}">已推荐</c:when>
                                <c:otherwise>已发布</c:otherwise>
                            </c:choose>

                        </c:if>

                        <c:if test="${c.venueDeptLable ==1}">
                            (文广体系)
                        </c:if>
                        <c:if test="${c.venueDeptLable ==2}">
                            (独立商家)
                        </c:if>
                        <c:if test="${c.venueDeptLable ==3}">
                            (其他)
                        </c:if>
                    </td>
                    <td>
                        <c:if test="${c.relationType==0}">
                            <a target="main" href="javascript:relationVenue('${c.venueId}',1)">关联</a>
                        </c:if>
                        <c:if test="${c.relationType==1}">
                            <a target="main" href="javascript:relationVenue('${c.venueId}',0)">取消关联</a>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        <c:if test="${not empty venueList}">
            <input type="hidden" id="page" name="page" value="${page.page}"/>
            <div id="kkpager" style="padding-top: 14px;"></div>
        </c:if>
    </div>
    <div class="form-table form_table_btn" style="position: fixed; bottom: 0; width: 100%; padding: 10px 0 30px;">
        <input class="btn-publish" type="button" value="关闭"/>
    </div>
    </div>
</form>
</body>
</html>
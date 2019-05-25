<%@ page language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>活动列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <%@include file="/WEB-INF/why/common/limit.jsp" %>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>

    <script type="text/javascript">
        seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
            window.dialog = dialog;
        });
        //** 日期控件
        $(function () {

            new Clipboard('.copyButton');

            $(".start-btn").on("click", function () {
                WdatePicker({
                    el: 'startDateHidden',
                    dateFmt: 'yyyy-MM-dd',
                    doubleCalendar: true,
                    minDate: '',
                    maxDate: '#F{$dp.$D(\'endDateHidden\')}',
                    position: {left: -224, top: 8},
                    isShowClear: false,
                    isShowOK: true,
                    isShowToday: false,
                    onpicked: pickedStartFunc
                })
            })
            $(".end-btn").on("click", function () {
                WdatePicker({
                    el: 'endDateHidden',
                    dateFmt: 'yyyy-MM-dd',
                    doubleCalendar: true,
                    minDate: '#F{$dp.$D(\'startDateHidden\')}',
                    position: {left: -224, top: 8},
                    isShowClear: false,
                    isShowOK: true,
                    isShowToday: false,
                    onpicked: pickedendFunc
                })
            })
        });
        function pickedStartFunc() {
            $dp.$('activityCreateTime').value = $dp.cal.getDateStr('yyyy-MM-dd');
        }
        function pickedendFunc() {
            $dp.$('activityUpdateTime').value = $dp.cal.getDateStr('yyyy-MM-dd');
        }

        $(function () {
            $("input").focus();
            kkpager.generPageHtml({
                pno: '${page.page}',
                total: '${page.countPage}',
                totalRecords: '${page.total}',
                mode: 'click',//默认值是link，可选link或者click
                click: function (n) {
                    this.selectPage(n);
                    $("#page").val(n);
                    formSub('#activityForm');
                    return false;
                }
            });
        });


        //删除
        function delActivity(id) {
            var showText = "您确定要删除该活动吗？";
            dialogConfirm("提示", showText, removeParent);
            function removeParent() {
                $.post("${path}/activityEditorial/deleteActivity.do", {"id": id}, function (data) {
                    if ('200' == data.status) {
                        dialogAlert('提示', data.msg, function () {
                            location.href = "${path}/activityEditorial/activityEditorialIndex.do?activityState=${activity.activityState}&activityIsDel=${activity.activityIsDel}";
                        });
                    } else {
                        dialogAlert('提示', data.msg, function () {
                            location.href = "${path}/activityEditorial/activityEditorialIndex.do?activityState=${activity.activityState}&activityIsDel=${activity.activityIsDel}";
                        });
                    }
                });
            }
        }



        //还原
        function returnBack(id) {
            dialogConfirm("还原活动", "您确定要还原该活动吗？", removeParent);
            function removeParent() {
                $.post("${path}/activityEditorial/returnActivity.do", {"id": id}, function (rsData) {
                    if (rsData == 'success') {
                        location.href = "${path}/activityEditorial/activityEditorialIndex.do?activityState=${activity.activityState}&activityIsDel=${activity.activityIsDel}";
                    } else {
                        dialogAlert("提示", "操作失败：" + rsData);
                    }
                });
            }
        }
        //复制Url
        function copyUrl(id) {
            dialogAlert("提示", "复制完成：" + id);
        }


        function changeLeftMenu() {
            $("#left", parent.document.body).attr("src", "${path}/activityLeft.do")
        }

        //提交表单
        function formSub(formName) {
            $(formName).submit();
        }

        //全选或全不选
        function selectActivityIds() {
            $("#list-table :checkbox").each(function () {
                if ($("#checkAll").attr("checked")) {
                    $(this).attr("checked", true);
                } else {
                    $(this).attr("checked", false);
                }
            });
        }

        $(function () {
            selectModel();
        });

        /**
         * 发布活动
         */
        function publishActivity(activityId) {
            var html = "您确定要发布该活动吗？";
            dialogConfirm("提示", html, function () {
                $.post("${path}/activityEditorial/publishActivity.do", {"activityId": activityId}, function (data) {
                    if (data != null && data == 'success') {
                        location.href = "${path}/activityEditorial/activityEditorialIndex.do?activityState=${activity.activityState}&activityIsDel=${activity.activityIsDel}";
                    }
                });
            })
        }


        //查询活动中存在的活动类型
        $(function () {
            var activityType = $('#activityType').val();
            $.post("../tag/getChildTagByType.do?code=ACTIVITY_TYPE", function (data) {
                if (data != '' && data != null) {
                    var list = eval(data);
                    var ulHtml = '<li data-option="">全部类型</li>';
                    for (var i = 0; i < list.length; i++) {
                        var dict = list[i];
                        ulHtml += '<li data-option="' + dict.tagId + '">' + dict.tagName + '</li>';
                        if (activityType != '' && dict.tagId == activityType) {
                            $('#activityTypeDiv').html(dict.tagName);
                        }
                    }
                    $('#activityUl').html(ulHtml);
                }
            }).success(function () {
            });
        });
        function toEditRatingsInfo(id) {
            dialog({
                url: '${path}/activity/toEditRatingsInfo.do?type=editorial&activityId='+id,
                title: '评级',
                width:520,
                height:240,
                fixed: true
            }).showModal();
            return false;
        }
    </script>
</head>
<body>
<form id="activityForm" action="" method="post">
    <input type="hidden" name="activityIsDel" id="activityIsDel" value="${activity.activityIsDel}"/>
    <input type="hidden" name="activityState" id="activityState" value="${activity.activityState}"/>
    <div class="site">
        <em>您现在所在的位置：</em>运维管理 &gt; 采编活动管理
        <c:if test="${not empty activity}">
            <c:if test="${activity.activityState == 5}">
                &gt; 回收站
            </c:if>
            <c:if test="${activity.activityState == 6}">
                &gt; 采编列表
            </c:if>
            <c:if test="${activity.activityState == 1}">
                &gt; 草稿箱
            </c:if>
        </c:if>
    </div>
    <div class="search">
        <div class="select-box w135">
            <input type="hidden" id="activityType" name="activityType" value="${activity.activityType}"/>
            <div id="activityTypeDiv" class="select-text" data-value="">全部类型</div>
            <ul class="select-option" id="activityUl">

            </ul>
        </div>
        <div class="select-box w135">
            <input type="hidden" value="${activity.activityIsFree}" name="activityIsFree"
                   id="activityIsFree"/>
            <div class="select-text" data-value="">
                <c:choose>
                    <c:when test="${activity.activityIsFree == '2'}">
                        收费
                    </c:when>
                    <c:when test="${activity.activityIsFree == '1'}">
                        免费
                    </c:when>
                    <c:otherwise>
                        全部方式
                    </c:otherwise>
                </c:choose>
            </div>
            <ul class="select-option">
                <li data-option="">全部方式</li>
                <li data-option="2">收费</li>
                <li data-option="1">免费</li>
            </ul>
        </div>
        <div class="select-box w135">
            <input type="hidden" value="${activity.ratingsInfo}" name="ratingsInfo"
                   id="ratingsInfo"/>
            <div class="select-text" data-value="">
                <c:choose>
                    <c:when test="${activity.ratingsInfo == '17d86c347ddf4dae8ffe05782fc6bd1a'}">
                        A
                    </c:when>
                    <c:when test="${activity.ratingsInfo == 'c780370dca4843769ca4b6431d71da46'}">
                        B
                    </c:when>
                    <c:when test="${activity.ratingsInfo == '728d77ac8e9441acb89c04dd55d88bbc'}">
                        C
                    </c:when>
                    <c:when test="${activity.ratingsInfo == '9e678e3cec9a492fb12374cb3acc5bf8'}">
                        D
                    </c:when>
                    <c:otherwise>
                        全部评级
                    </c:otherwise>
                </c:choose>
            </div>
            <ul class="select-option">
                <li data-option="">全部评级</li>
                <li data-option="17d86c347ddf4dae8ffe05782fc6bd1a">A</li>
                <li data-option="c780370dca4843769ca4b6431d71da46">B</li>
                <li data-option="728d77ac8e9441acb89c04dd55d88bbc">C</li>
                <li data-option="9e678e3cec9a492fb12374cb3acc5bf8">D</li>
            </ul>
        </div>
        <div class="form-table" style="float: left;">
            <div class="td-time" style="margin-top: 0px;">
                <div class="start w240" style="margin-left: 8px;">
                    <span class="text">开始日期</span>
                    <input type="hidden" id="startDateHidden"/>
                    <input type="text" id="activityCreateTime" name="activityCreateTime"
                           value='<fmt:formatDate value="${activity.activityCreateTime}" pattern="yyyy-MM-dd"/>'
                            readonly/>
                    <i class="data-btn start-btn"></i>
                </div>
                <span class="txt" style="line-height: 42px;">至</span>
                <div class="end w240">
                    <span class="text">结束日期</span>
                    <input type="hidden" id="endDateHidden"/>
                    <input type="text" id="activityUpdateTime" name="activityUpdateTime"
                           value='<fmt:formatDate value="${activity.activityUpdateTime}" pattern="yyyy-MM-dd"/>'
                           readonly/>
                    <i class="data-btn end-btn"></i>
                </div>
            </div>
        </div>
        <div class="select-btn">
            <input type="button" onclick="$('#page').val(1);formSub('#activityForm');" value="搜索"/>
        </div>
    </div>
    <div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th width="24">ID</th>
                <th class="title">活动名称</th>
                <th width="170">票价</th>
                <th width="170">发布者</th>
                <th width="170">发布时间</th>
                <th width="170">最新操作时间</th>
                <th width="170">评级信息</th>
                <th width="340">管理</th>
            </tr>
            </thead>
            <tbody>
            <%int i = 0;%>
            <c:forEach items="${activityList}" var="avct">
                <%i++;%>
                <tr>
                    <td><%=i%>
                    </td>
                    <td class="title">
                        <c:if test="${not empty avct.activityName}">
                            <c:if test="${avct.activityState ==6}">
                                <a target="_blank" title="${avct.activityName}" >
                            </c:if>
                            <c:set var="activityName" value="${avct.activityName}"/>
                            <c:out value="${fn:substring(activityName,0,19)}"/>
                            <c:if test="${fn:length(activityName) > 19}">...</c:if>
                            <c:if test="${avct.activityState ==6}">
                                </a>
                            </c:if>
                        </c:if>
                    </td>
                    <td>
                        <c:if test="${avct.activityIsFree==2}">
                            收费
                        </c:if>
                        <c:if test="${avct.activityIsFree==1}">
                            免费
                        </c:if>
                    </td>
                    <td>
                        <c:if test="${not empty avct.userAccount}">
                            ${avct.userAccount}
                        </c:if>
                        <c:if test="${ empty avct.userAccount}">
                            未知操作人
                        </c:if>
                    </td>
                    <td>
                        <c:if test="${not empty avct.activityCreateTime}">
                            <fmt:formatDate value="${avct.activityCreateTime}" pattern="yyyy-MM-dd HH:mm"/>
                        </c:if>

                    </td>
                    <td>
                        <c:if test="${not empty avct.activityUpdateTime}">
                            <fmt:formatDate value="${avct.activityUpdateTime}" pattern="yyyy-MM-dd HH:mm"/>
                        </c:if>

                    </td>
                    <td>
                        <c:if test="${not empty avct.ratingsInfo}">
                            ${avct.dictName}
                        </c:if>
                        <c:if test="${ empty avct.ratingsInfo}">
                            暂无评级
                        </c:if>

                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty activityList}">
                <tr>
                    <td colspan="8"><h4 style="color:#DC590C">暂无数据!</h4></td>
                </tr>
            </c:if>
            </tbody>
        </table>
        <c:if test="${not empty activityList}">
            <input type="hidden" id="page" name="page" value="${page.page}"/>
            <div id="kkpager"></div>
        </c:if>
    </div>
</form>
</body>
</html>

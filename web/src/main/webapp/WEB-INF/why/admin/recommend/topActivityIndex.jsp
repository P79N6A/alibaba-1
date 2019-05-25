<%@ page language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>置顶列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <%@include file="/WEB-INF/why/common/limit.jsp" %>

    <script type="text/javascript">

        //** 日期控件
        $(function () {
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
            $dp.$('activityStartTime').value = $dp.cal.getDateStr('yyyy-MM-dd');
        }
        function pickedendFunc() {
            $dp.$('activityEndTime').value = $dp.cal.getDateStr('yyyy-MM-dd');
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




        //提交表单
        function formSub(formName) {
            var activityName = $('#activityName').val();
            if (activityName != undefined && activityName == '输入活动名称') {
                $('#activityName').val("");
            }


            //场馆
            $('#venueId').val($('#loc_venue').val());
            $('#venueType').val($('#loc_category').val());
            $('#venueArea').val($('#loc_area').val());
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




        //查询活动中存在的活动类型
        $(function () {
            var activityType = $('#activityType').val();
            $.post("../tag/getChildTagByType.do?code=ACTIVITY_TYPE", function (data) {
                if (data != '' && data != null) {
                    var list = eval(data);
                    var ulHtml = '';
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
        /**
         * 置顶活动
         */
        function topActivity(activityId) {
            var html = "该活动将在此标签下被置顶，您确定要置顶该活动吗？";
            dialogConfirm("提示", html, function () {
                var activityTypeData = $("#activityType").val();
                $.post("${path}/recommendRelate/topActivity.do", {"activityId": activityId,"activityType": '${activityType}'}, function (data) {
                    if (data != null && data == 'success') {
                        window.location.href = "${path}/recommendRelate/activityIndex.do?activityState=${activity.activityState}&activityIsDel=${activity.activityIsDel}&activityType="+activityTypeData;
                    }else {
                        dialogConfirm("提示", "活动已被置顶", function () {
                            window.location.href = "${path}/recommendRelate/activityIndex.do?activityState=${activity.activityState}&activityIsDel=${activity.activityIsDel}&activityType="+activityTypeData;
                        })
                    }
                });
            })
        }
        /**
         * 取消置顶活动
         */
        function cancelTopActivity(recommendId) {
            var html = "该活动将在此标签下被取消置顶，您确定要取消置顶该活动吗？";
            dialogConfirm("提示", html, function () {
                $.post("${path}/recommendRelate/cancelRecommendActivity.do", {"recommendId": recommendId}, function (data) {
                    var activityTypeData = $("#activityType").val();
                    if (data != null && data == 'success') {
                        window.location.href = "${path}/recommendRelate/activityIndex.do?activityState=${activity.activityState}&activityIsDel=${activity.activityIsDel}&activityType="+activityTypeData;
                    }else {
                        dialogConfirm("提示", "活动信息异常", function () {
                            window.location.href = "${path}/recommendRelate/activityIndex.do?activityState=${activity.activityState}&activityIsDel=${activity.activityIsDel}&activityType="+activityTypeData;
                        })
                    }
                });
            })
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
<form id="activityForm" action="${path}/recommendRelate/activityIndex.do" method="post">
    <input type="hidden" name="activityIsDel" id="activityIsDel" value="1"/>
    <input type="hidden" name="activityState" id="activityState" value="6"/>
    <div class="site">
        <em>您现在所在的位置：</em>活动置顶管理
    </div>
    <div class="search">
        <div class="search-box">
            <i></i><input type="text" id="activityName" name="activityName" value="${activity.activityName}"
                          data-val="输入活动名称" class="input-text"/>
        </div>
        <div class="select-box w135">
            <input type="hidden" id="activityType" name="activityType" value="${activityType}"/>
            <div id="activityTypeDiv" class="select-text" data-value="">活动标签</div>
            <ul class="select-option" id="activityUl">
            </ul>
        </div>
        <div class="select-box w135">
            <input type="hidden" value="${activity.activitySalesOnline}" name="activitySalesOnline"
                   id="activitySalesOnline"/>
            <div class="select-text" data-value="">
                <c:choose>
                    <c:when test="${activity.activitySalesOnline == 'Y'}">
                        在线选座
                    </c:when>
                    <c:when test="${activity.activitySalesOnline == 'N'}">
                        自由入座
                    </c:when>
                    <c:when test="${activity.activitySalesOnline == 'Z'}">
                        不可预订
                    </c:when>
                    <c:otherwise>
                        全部方式
                    </c:otherwise>
                </c:choose>
            </div>
            <ul class="select-option">
                <li data-option="">全部方式</li>
                <li data-option="Z">不可预订</li>
                <li data-option="Y">在线选座</li>
                <li data-option="N">自由入座</li>
            </ul>
        </div>
        <div class="form-table" style="float: left;">
            <div class="td-time" style="margin-top: 0px;">
                <div class="start w240" style="margin-left: 8px;">
                    <span class="text">开始日期</span>
                    <input type="hidden" id="startDateHidden"/>
                    <input type="text" id="activityStartTime" name="activityStartTime"
                           value="${activity.activityStartTime}" readonly/>
                    <i class="data-btn start-btn"></i>
                </div>
                <span class="txt" style="line-height: 42px;">至</span>
                <div class="end w240">
                    <span class="text">结束日期</span>
                    <input type="hidden" id="endDateHidden"/>
                    <input type="text" id="activityEndTime" name="activityEndTime" value="${activity.activityEndTime}"
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
                <th>ID</th>
                <th class="title">活动名称</th>
                <th class="venue">所属场馆</th>
                <th>所属区县</th>
                <th>选座方式</th>
                <th>发布者</th>
                <th>发布时间</th>
                <th>最新操作人</th>
                <th>最新操作时间</th>
                <th>管理</th>
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
                        <c:if test="${avct.activityPersonal == 1}">
                            <img src="${path}/STATIC/image/personal-icon.png"/>
                        </c:if>
                        <c:if test="${not empty avct.activityName}">
                            <c:if test="${avct.activityState ==6}">
                                <a target="_blank" title="${avct.activityName}" href="${path}/frontActivity/frontActivityDetail.do?activityId=${avct.activityId}">
                            </c:if>
                            <c:set var="activityName" value="${avct.activityName}"/>
                            <c:out value="${fn:substring(activityName,0,19)}"/>
                            <c:if test="${fn:length(activityName) > 19}">...</c:if>
                            <c:if test="${avct.activityState ==6}">
                                </a>
                            </c:if>
                        </c:if>
                    </td>

                    <td class="venue">
                        <c:choose>
                            <c:when test="${avct.createActivityCode == 1}">市级自建</c:when>
                            <c:when test="${avct.createActivityCode == 2}">区级自建</c:when>
                            <c:otherwise>
                                <c:if test="${not empty avct.venueName}">
                                    <c:out escapeXml="true" value="${avct.venueName}"/>
                                </c:if>
                                <c:if test="${ empty avct.venueName}">
                                    未知场馆
                                </c:if>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${avct.createActivityCode == 1}">${fn:split(avct.activityProvince, ",")[1]}</c:when>
                            <c:when test="${avct.createActivityCode == 2}">
                                <c:if test="${not empty avct.activityArea}">
                                    ${fn:split(avct.activityArea, ",")[1]}
                                </c:if>
                                <c:if test="${empty avct.activityArea}">
                                    未知区县
                                </c:if>
                            </c:when>
                            <c:otherwise>
                                <c:if test="${not empty avct.activityArea}">
                                    ${fn:split(avct.activityArea, ",")[1]}
                                </c:if>
                                <c:if test="${empty avct.activityArea}">
                                    未知区县
                                </c:if>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${avct.activitySalesOnline =='Y'}">
                                在线选座
                            </c:when>
                            <c:otherwise>
                                <c:if test="${avct.activityIsReservation == 2}">
                                    自由入座
                                </c:if>
                                <c:if test="${avct.activityIsReservation == 1}">
                                    不可预订
                                </c:if>

                            </c:otherwise>
                        </c:choose>
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
                        <c:if test="${not empty avct.userAccount2}">
                            ${avct.userAccount2}
                        </c:if>
                        <c:if test="${ empty avct.userAccount2}">
                            未知操作人
                        </c:if>
                    </td>
                    <td>
                        <c:if test="${not empty avct.activityUpdateTime}">
                            <fmt:formatDate value="${avct.activityUpdateTime}" pattern="yyyy-MM-dd HH:mm"/>
                        </c:if>

                    </td>
                    <td>
                        <%if (apprecommendRelateTopButton) {%>
                        <c:if test="${not empty avct.venueId}">
                            <a onclick="cancelTopActivity('${avct.venueId}')">取消置顶</a>
                        </c:if>
                        <c:if test="${ empty avct.venueId}">
                            <a onclick="topActivity('${avct.activityId}')">置顶</a>
                        </c:if>
                        <%}%>
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
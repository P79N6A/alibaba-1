<%@ page language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<html>
<head>
    <title>交互统计</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <%@include file="/WEB-INF/why/common/limit.jsp" %>
    <script type="text/javascript" src="${path}/STATIC/js/area-venues-admin.js?version=20151125"></script>

</head>
<body ng-controller="alteCon" ng-app="alteSta" ng-init="type='venue'">
<div class="site">
    <em>您现在所在的位置：</em>活动室交互统计
</div>
<script type="text/javascript">

</script>
<table width="100%" class=" main-publish form-table">
    <tr>
        <td width="100" class="td-title">区域：</td>
        <td class="td-select">
            <select ng-model="area.province" ng-options="x for (x,y) in province"
                    style="width:142px; margin-right: 8px">
            </select>
            <select ng-model="area.city" ng-options="x for (x,y) in city" style="width:142px; margin-right: 8px">
            </select>
            <select ng-model="area.district" ng-options="x for (x,y) in district"
                    style="width:142px; margin-right: 8px">
                <option value="" ng-if="!area.district">请选择</option>
            </select>
            <select ng-model="area.venue" ng-options="x for (x,y) in venue" style="width:142px; margin-right: 8px">
                <option value="" ng-if="!area.venue">请选择</option>
            </select>
        </td>
    <tr>
        <td width="100" class="td-title">类别：</td>
        <td class="td-tag">
            <dd>
                <a style="margin: 0 8px 0 0;padding: 2px 33px" class="cur">全部</a>
            </dd>
        </td>
    </tr>
    <tr>
        <td width="100" class="td-title">交互方式：</td>
        <td class="td-tag" id="tag">
            <dd>
                <a style="margin: 0 8px 0 0;padding: 2px 33px" class="cur" id="tagAll" ng-click="addLevel()">全部</a>
                <a style="margin: 0 8px 0 0;padding: 2px 30px" id="pc"
                   ng-click="addLevel('pc')">pc</a>
                <a style="margin: 0 8px 0 0;padding: 2px 30px" id="iphone"
                   ng-click="addLevel('iphone')">app</a>
                <a style="margin: 0 8px 0 0;padding: 2px 30px" id="wap"
                   ng-click="addLevel('wap')">微网站</a>
            </dd>
        </td>
    </tr>

</table>
<div class="site-title">上海市<%--{{area}}{{dateType}}{{level}}{{type}}--%></div>
<table width="100%" class=" main-publish form-table" ng-switch="selMod">
    <tr>
        <td width="10" style="margin-left: 8px;" class="td-title"></td>
        <td class="td-tag" id="selTim" ng-switch-when="false" style="margin-left: 8px;">
            <dd>
                <a class="cur" style="margin: 0 8px 0 0;padding: 2px 40px;float: left;" id="day"
                   ng-click="selTim('day')">日</a>
                <a style="margin: 0 8px 0 0;padding: 2px 40px;float: left;" id="week" ng-click="selTim('week')">周</a>
                <a style="margin: 0 8px 0 0;padding: 2px 40px;float: left;" id="month" ng-click="selTim('month')">月</a>
            </dd>
        </td>
        <td ng-switch-when="true" class="search">
            <div class="form-table" style="float: left;">
                <div class="td-time" style="margin-top: 0px;">
                    <div class="start w240" style="margin-left: 70px;">
                        <span class="text">开始日期</span>
                        <input type="hidden" id="startDateHidden"/>
                        <input type="text" id="startTime" name="startTime"
                               value="" readonly/>
                        <i class="data-btn start-btn"></i>
                    </div>
                    <span class="txt" style="line-height: 42px;">至</span>
                    <div class="end w240">
                        <span class="text">结束日期</span>
                        <input type="hidden" id="endDateHidden"/>
                        <input type="text" id="endTime" name="endTime" value=""
                               readonly/>
                        <i class="data-btn end-btn"></i>
                    </div>
                    <div class="select-btn">
                        <input type="button" style="text-align: center;color: white" ng-click="selTim('time')"
                               value="搜索"/>
                    </div>
                </div>
            </div>
        </td>
    </tr>
</table>
<div class="data-content table-cont">
    <div class="table-cont">
        <table width="100%" class="tab-data" id="Area_Info" ng-switch="selMod">
            <thead class="tab-data" ng-switch-when="true">
            <tr>
                <td>名称</td>
                <td>pv</td>
                <td>uv</td>
                <td>ip</td>
                <td>点赞量</td>
                <td>收藏量</td>
                <td>评论量</td>
                <td>预定量</td>
                <td>入场量</td>
            </tr>
            <tr ng-repeat="x in resData">
                <td ng-switch="area.district">
                    <a ng-switch-when="0"  ng-bind="x.carea"></a>
                    <a ng-switch-default ng-bind="x.vname"></a>
                </td>
                <td ng-bind="x.pv"></td>
                <td ng-bind="x.uv"></td>
                <td ng-bind="x.ip"></td>
                <td ng-bind="x.favorc"></td>
                <td ng-bind="x.collect"></td>
                <td ng-bind="x.commentc"></td>
                <td ng-bind="x.bookc"></td>
                <td ng-bind="x.enterc"></td>
            </tr>
            </thead>
            <thead class="tab-data" ng-switch-when="false">
            <tr>
                <td>日期</td>
                <td>pv</td>
                <td>uv</td>
                <td>ip</td>
                <td>点赞量</td>
                <td>收藏量</td>
                <td>评论量</td>
                <td>预定量</td>
                <td>入场量</td>
            </tr>
            <tr ng-repeat="x in resData">
                <td ng-bind="x.cdate"></td>
                <td ng-bind="x.pv"></td>
                <td ng-bind="x.uv"></td>
                <td ng-bind="x.ip"></td>
                <td ng-bind="x.favorc"></td>
                <td ng-bind="x.collect"></td>
                <td ng-bind="x.commentc"></td>
                <td ng-bind="x.bookc"></td>
                <td ng-bind="x.enterc"></td>
            </tr>
            </thead>
        </table>
    </div>
</div>
</body>
<script type="text/javascript"
        src="${path}/STATIC/js/admin/statistics/alterStatistics.js?version=111"></script>

</html>

<%@ page language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>区县数据统计</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <%@include file="/WEB-INF/why/common/limit.jsp" %>
    <script type="text/javascript" src="${path}/STATIC/js/area-venues-admin.js?version=20151125"></script>

</head>
<body ng-controller="alteCon" ng-app="alteSta" ng-init="type='activity';seachName='搜索';resStatus=''">
<div class="site">
    <em>您现在所在的位置： </em>区县数据统计
</div>
<script type="text/javascript">

</script>

<div class="site-title">区县数据统计</div>
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
        <td ng-switch-when="true" class="search"><span style="float: left;margin-left: 10px">活动发布日期:</span>
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
                        <input type="button" style="text-align: center;color: white" class="w240" ng-click="selTim('time')"
                             ng-model="seachName" value="{{seachName}}"/>
                    </div>
                </div>
            </div> 
        </td>
    </tr>
</table>
<div class="data-content table-cont">
    <div class="table-cont">
        <table width="100%" class="tab-data" id="Area_Info" ng-switch="selMod">
            <thead class="tab-data" >
            <tr>
                <td>帐号</td>
                <td>所属场馆</td>
                <td>活动发布量</td>
                <td>可预订活动发布数</td>
                
            </tr>
            <tr  ng-model="resStatus" ng-show="resStatus=='ok'"   ng-repeat="x in resData">
                <td ng-bind="x.userAccount"></td>
                <td ng-bind="x.deptName"></td>
                <td ng-bind="x.publishActivity"></td>
                <td ng-bind="x.activityCanBook"></td>
            </tr>
            </thead>
        </table>
        <div ng-model="resStatus" ng-show="resStatus=='error'" style="font-size:30px;text-align: center;"><span >{{resMsg}}</span></div>
    </div>
</div>
</body>
<script type="text/javascript"
        src="${path}/STATIC/js/admin/statistics/countyStatistics.js"></script>

</html>

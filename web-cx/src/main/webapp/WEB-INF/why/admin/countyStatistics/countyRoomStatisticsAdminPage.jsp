<%@ page language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<html>
<head>
    <title>区县活动室数据统计</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <%@include file="/WEB-INF/why/common/limit.jsp" %>
    <script type="text/javascript" src="${path}/STATIC/js/area-venues-admin.js?version=20151125"></script>

</head>
<body ng-controller="alteCon" ng-app="alteSta" ng-init="type='venue';seachName='搜索';resStatus=''">
<div class="site">
    <em>您现在所在的位置：</em>区县活动室数据统计
</div>
<script type="text/javascript">

</script>
<table width="70%" class=" main-publish form-table">
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
        </td>
        <td class="search" >  <div class="form-table" style="float:left;margin-left: 10px;">
                <div class="td-time" style="margin-top: 0px;">
                    <div class="select-btn">
                        <input type="button" style="text-align: center;color: white" class="w240"  ng-click="selTim('time')" 
                            ng-model="seachName"    value="{{seachName}}"/>
                    </div>
                </div>
            </div></td>
</table>
<div class="site-title">区县活动室数据统计</div>

<div class="data-content table-cont">
    <div class="table-cont">
        <table width="100%" class="tab-data" id="Area_Info" ng-switch="selMod">
            <thead class="tab-data" ng-switch-when="true">
            <tr>
                <td>所属场馆</td>
                <td>活动室总量</td>
                <td>可预订活动室总量</td>
            </tr>
            <tr ng-model="resStatus" ng-show="resStatus=='ok'"   ng-repeat="x in resData">
                <td ng-bind="x.deptName"></td>
                <td ng-bind="x.roomPublish"></td>
                <td ng-bind="x.roomCanBook"></td>
            </tr>
            </thead>
        </table>
         <div ng-model="resStatus" ng-show="resStatus=='error'" style="font-size:30px;text-align: center;"><span >{{resMsg}}</span></div>
    </div>
</div>
</body>
<script type="text/javascript"
        src="${path}/STATIC/js/admin/statistics/countyRoomStatisticsAdmin.js?version=111"></script>

</html>

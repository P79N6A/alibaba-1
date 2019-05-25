<%@ page language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>区县活动室数据统计</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <%@include file="/WEB-INF/why/common/limit.jsp" %>
    <script type="text/javascript" src="${path}/STATIC/js/area-venues-admin.js?version=20151125"></script>

</head>
<body ng-controller="alteCon" ng-app="alteSta" ng-init="type='activity';seachName='搜索';resStatus='loading'">
<div class="site">
    <em>您现在所在的位置： </em>区县活动室数据统计
</div>
<script type="text/javascript">

</script>

<div class="site-title">区县活动室数据统计</div>
<div class="data-content table-cont">
    <div class="table-cont">
        <table width="100%" class="tab-data" id="Area_Info" ng-switch="selMod">
            <thead class="tab-data" >
            <tr>
                <td>所属场馆</td>
                <td>活动室总量</td>
                <td>可预订活动室总量</td>
                
            </tr>
            <tr  ng-model="resStatus" ng-show="resStatus=='ok'"   ng-repeat="x in resData">
                <td ng-bind="x.deptName"></td>
                <td ng-bind="x.roomPublish"></td>
                <td ng-bind="x.roomCanBook"></td>
            </tr>
            </thead>
        </table>
        <div ng-model="resStatus" ng-show="resStatus=='error'" style="font-size:30px;text-align: center;"><span >{{resMsg}}</span></div>
        <div ng-model="resStatus" ng-show="resStatus=='loading'" style="font-size:30px;text-align: center;"><i>{{resMsg}}</i></div>
    </div>
</div>
</body>
<script type="text/javascript"
        src="${path}/STATIC/js/admin/statistics/countyRoomStatistics.js"></script>

</html>

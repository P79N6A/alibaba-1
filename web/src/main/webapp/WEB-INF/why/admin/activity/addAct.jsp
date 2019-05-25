<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html ng-controller="ActCon" ng-app="addAct">

<head>
    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <%@include file="/WEB-INF/why/common/limit.jsp" %>
    <script type="text/javascript"
            src="${path}/STATIC/js/admin/activity/UploadActivityFile.js?version=20151230"></script>
    <script type="text/javascript" src="${path}/STATIC/js/area.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/area-venues-admin.js?version=20151125"></script>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    <!--文本编辑框 end-->
    <!-- dialog start -->
    <link rel="Stylesheet" type="text/css" href="${path}/STATIC/css/DialogBySHF.css" />
    <script type="text/javascript" src="${path}/STATIC/js/DialogBySHF.js"></script>

    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/ckeditor/sample.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/admin/activity/addAct.js?version=20170509"></script>
    <script type="text/javascript" src="${path}/STATIC/js/admin/uploadify.js?version=20160302"></script>
    <script type="text/javascript" src="${path}/STATIC/js/admin/datePicker.js?version=20160302"></script>
    <script type="text/javascript" src="${path}/STATIC/js/admin/datePickerHour.js?version=20160302"></script>
    <script type="text/javascript" src="${path}/STATIC/js/admin/ckeditor.js?version=20160302"></script>
</head>
<body ng-init="activity.activityId='${activityId}';event.order='${isPayStatus}';area.userIsManger='${sessionScope.user.userIsManger}'">
<div class="site">
    <em>您现在所在的位置：</em>活动管理 &gt; 发布活动
</div>
<div class="site-title">活动发布</div>
<input type="hidden" value="${sessionScope.user.userIsManger}" id="userIsManager"/>
<input type="hidden" id="assnId" name="assnId" value="" ng-model="area.assnId"/>
<input type="hidden" id="referId" name="addressId" value="" ng-model="area.addressId"/>
<input type="hidden" id="userCounty" value="${sessionScope.user.userCounty}"/>
<input type="hidden" id="userProvince" value="${sessionScope.user.userProvince}"/>
<div class="main-publish">
    <table width="100%" class="form-table">
        <tr>
            <td width="100" class="td-title"><span class="red">*</span>活动名称：</td>
            <td class="td-input"><input type="text" placeholder="标题最多输入20个字" ng-model="activity.activityName" class="input-text w510" maxlength="20" /></td>
        </tr>
        <tr>
            <td width="100" class="td-title"><span class="red">*</span>上传封面：</td>
            <td class="td-upload" id="activityIconUrlLabel">
                <table>
                    <tr>
                        <td>
                            <div class="img-box" style="width: 300px;height:200px ">
                                <div id="activityIconUrlShow" class="img" style="width: 300px;height:200px ">
                                    <img ng-src="{{activity.activityIconUrlShow}}" style="width: 52px;height:46px ">
                                </div>
                            </div>
                            <div class="controls-box" style="height: 46px;">
                                <div id="activityIconUrlShow_750_500_300_200" class="controls" ng-model="activity.activityIconUrl" snail-uploadify="{auto:false,buttonText:'图片上传'}">
                                </div>
                                <span class="upload-tip">可上传1张图片，建议尺寸750*500像素，格式为jpg,jpeg,png,gif，大小不超过2M</span>
                            </div>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td width="100" class="td-title"><span class="red">*</span>区域：</td>
            <td class="td-select">
                <select class="ng-select-box" ng-model="activity.createActivityCode"  ng-disabled ="code.userIsMangerDisable">
                    <option ng-repeat="option in area.activityCode" value="{{option.id}}">{{option.name}}</option>
                </select>
                <select class="ng-select-box" ng-show="area.activityAreashow" ng-model="activity.activityArea"  ng-disabled ="code.userIsMangerDisable">
                    <option ng-repeat="option in area.activityArea" value="{{option.id}}">{{option.name}}</option>
                </select>
                <select class="ng-select-box" ng-show="area.venueTypeshow" ng-model="activity.venueType"  ng-disabled ="code.userIsMangerDisable">
                    <option ng-repeat="option in area.venueType" value="{{option.id}}">{{option.name}}</option>
                </select>
                <select class="ng-select-box" ng-show="area.venueIdshow" ng-model="activity.venueId" ng-disabled ="code.userIsMangerDisable">
                    <option ng-repeat="option in area.venueId" value="{{option.id}}">{{option.name}}</option>
                </select>
            </td>
        </tr>
        <tr ng-show="area.activityAreashow">
            <td width="100" class="td-title"><span class="red">*</span>位置：</td>
            <td class="td-tag" id="activityLocationLabel">
                <dd>
                    <a ng-repeat="(x, y) in area.activityLocation" id="{{x}}" ng-click="setActivityLocation(x)">{{y}}</a>
                </dd>
            </td>
        </tr>
        <tr>
            <td width="100" class="td-title"><span class="red">*</span>类型(单选)：</td>
            <td class="td-tag">
                <dd id="activityTypeLabel">
                    <a ng-repeat="(a, b) in area.activityType" id="{{a}}" ng-click="setActivityType(a)">{{b}}</a>
                </dd>
            </td>
        </tr>
        <tr>
            <td width="100" class="td-title"><span class="red">*</span>标签(多选)：</td>
            <td class="td-tag">
                <dd id="activityTagLabel">
                    <a ng-repeat="(q, w) in area.activityComTag" id="{{q}}" ng-click="setActivityTag(q)">{{w}}</a>
                    <a ng-repeat="(m, n) in area.activityTag" id="{{m}}" ng-click="setActivityTag(m)">{{n}}</a>
                </dd>
            </td>
        </tr>

        <tr>
            <td width="100" class="td-littleTitle titleBg">活动单位：</td>
            <td>
                <div class="bt-line" style="height: 11px;"></div>
            </td>
        </tr>
        <tr>
            <td width="100" class="td-title"><span class="red">*</span>主办单位：</td>
            <td class="td-input">
                <input type="text" ng-model="activity.activityHost" class="input-text w510" />
            </td>
        </tr>
        <tr>
            <td width="100" class="td-title">承办单位：</td>
            <td class="td-input ">
                <input type="text" ng-model="activity.activityOrganizer" class="input-text w510" />
            </td>
        </tr>
        <tr>
            <td width="100" class="td-title">协办单位：</td>
            <td class="td-input ">
                <input type="text" ng-model="activity.activityCoorganizer" class="input-text w510" />
            </td>
        </tr>
        <tr>
            <td width="100" class="td-title">演出单位：</td>
            <td class="td-input ">
                <input type="text" id="assnName" ng-model="activity.activityPerformed" class="input-text w510 ng-pristine ng-valid ng-empty ng-touched">
                <input type="button" class="upload-btn" ng-click="changePerformed()" value="选择已有社团" />
            </td>
        </tr>
        <tr>
            <td width="100" class="td-title">主讲人：</td>
            <td class="td-input ">
                <input type="text" ng-model="activity.activitySpeaker" class="input-text w510" />
            </td>
        </tr>
        <tr>
            <td width="100" class="td-title"><span class="red">*</span>联系电话：</td>
            <td class="td-input">
                <input type="text" ng-model="activity.activityTel" class="input-text w510" />
            </td>
        </tr>
        <tr>
            <td width="100" class="td-littleTitle titleBg">活动地址：</td>
            <td>
                <div class="bt-line" style="height: 11px;"></div>
            </td>
        </tr>
        <tr class="actAddress">
            <td width="100" class="td-title"><span class="red">*</span>活动地址：</td>
            <td class="td-input">
                <input readonly="readonly" ng-keypress="$event.preventDefault()" type="text" ng-model="activity.activityAddress" id="activityAddress" class="actPlace input-text w510 ng-pristine ng-untouched ng-valid ng-not-empty " placeholder="街道+门牌号，如：“广中西路777弄10号F楼”">
            </td>

        </tr>
        <tr>
            <td width="100" class="td-title">备注：</td>
            <td class="td-input">
                <input type="text" ng-model="activity.activitySite" class="input-text w510" placeholder="例如：302室/多功能厅/三楼剧场" />
            </td>
        </tr>
        <%--<tr >--%>
        <%--<td width="100" class="td-title">备注：</td>--%>
        <%--<td class="td-input bt-line ">--%>
        <%--<input type="text" ng-model="activity.activitySite" class="input-text w510" />--%>
        <%--</td>--%>
        <%--</tr>--%>
        <tr>
            <td></td>
            <td class="td-input">
                <input type="button" class="upload-btn" ng-click="changeAddress()" value="地址设置">
            </td>
        </tr>
        <tr ng-show="code.ticketShow">
            <td width="100" class="td-littleTitle titleBg">活动票价：</td>
            <td>
                <div class="bt-line" style="height: 11px;"></div>
            </td>
        </tr>
        <tr ng-show="code.ticketShow">
            <td width="100" class="td-title"></td>
            <td class="td-input td-fees ">
                <label><input type="radio" ng-model="activity.activityIsFree" value="1"/><em>免费</em></label>
                <label><input type="radio" ng-model="activity.activityIsFree" value="2"/><em>收费</em></label>
                <div class="" ng-show="code.payShow">
                    <input type="text" ng-model="activity.activityPrice" maxlength="10" class="input-text w60" />
                    <select ng-model="activity.priceType">
                        <option value=1>元/人</option>
                        <option value=0>元起</option>
                    </select>
                    <em></em> 收费说明：
                    <input type="text" ng-model="activity.priceDescribe" maxlength="100" class="input-text " style="width:140px;" />
                </div>
            </td>
        </tr>
        <tr ng-show="code.ticketShow">
            <td width="100" class="td-littleTitle titleBg">入场设置：</td>
            <td>
                <div class="bt-line" style="height: 11px;"></div>
            </td>
        </tr>
        <tr>
            <td width="100" class="td-title"><span class="red">*</span>活动日期：</td>
            <input type="hidden" id="datePicker" />
            <td class="td-time" id="activityStartTimeLabel">
                <div class="start w340">
                    <span class="text">开始日期</span>
                    <input type="text" ng-model="activity.activityStartTime" value="" readonly/>
                    <i date-picker ng-model="activity.activityStartTime"></i>
                </div>
                <span class="txt">至</span>
                <div class="end w340">
                    <span class="text">结束日期</span>
                    <input type="text" ng-model="activity.activityEndTime" value="" readonly/>
                    <i date-picker ng-model="activity.activityEndTime"></i>
                </div>
                <input ng-model="area.startHour" required ng-required min="0" type="number" class="input-text w64" maxlength="2" ng-disabled="code.typeDisable" />：
                <input ng-model="area.startMinute" required ng-required min="0" type="number" class="input-text w64" maxlength="2" ng-disabled="code.typeDisable" />至
                <input ng-model="area.endHour" required ng-required min="0" type="number" class="input-text w64" maxlength="2" ng-disabled="code.typeDisable" />：
                <input ng-model="area.endMinute" required ng-required min="0" type="number" class="input-text w64" maxlength="2" ng-disabled="code.typeDisable" />
                <span ng-hide="code.noTicketShow" class="txt des">具体描述:</span>
                <input type="text" maxlength="100" class="input-text w210" value="" ng-model="activity.activityTimeDes" placeholder="具体描述 例如：每周三上午8:00-11:30" /></td>

        </tr>
        <tr ng-show="code.ticketShow">
            <td width="100" class="td-title"></td>
            <td class="td-input td-fees">
                <label><input type="radio" ng-model="activity.activityIsReservation" value="1"/><em>不可预订</em></label>
                <label><input type="radio" ng-model="activity.activityIsReservation" value="3"/><em>自由入座</em></label>
                <label><input type="radio" ng-model="activity.activityIsReservation" value="2"/><em>在线选座</em></label>
                <label><input type="radio" ng-model="activity.activityIsReservation" value="4"/><em>直接前往</em></label>
                <label><input type="radio" ng-model="activity.activityIsReservation" value="5"/><em>电话预约</em></label>
            </td>
        </tr>
        <tr ng-show="code.singleEventShow" style="padding: 0px;" ng-show="code.ticketShow">
            <td style="padding: 0px;"></td>
            <td style="padding: 0px;">

                <div ng-show="code.triangle2" style="margin-left: 230px;width: 0;height: 0;border-bottom: 10px solid #e2e2e2;border-left: 10px solid transparent;border-right: 10px solid transparent;float: left;"></div>
                <div ng-show="code.triangle3" style="margin-left: 130px;width: 0;height: 0;border-bottom: 10px solid #e2e2e2;border-left: 10px solid transparent;border-right: 10px solid transparent;float: left;"></div>
                <div style="clear: both;"></div>
            </td>
        </tr>
        <tr ng-show="code.singleEventShow" class="bge2e2e2" ng-show="code.ticketShow">
            <td width="100" class="td-title"></td>
            <td class="td-input td-fees">
                <label><input type="radio" ng-model="activity.singleEvent" value="1"/><em>单场次</em></label>
                <label><input type="radio" ng-model="activity.singleEvent" value="0"/><em>多场次</em></label>
            </td>
        </tr>
        <%if(activityTicketSpick){%>
        <tr ng-show="code.spikeTypeShow" class="bgf9f9f9" ng-show="code.ticketShow">
            <td width="100" class="td-title"></td>
            <td class="td-input">
                <input type="checkbox" ng-true-value='1' ng-false-value='0' ng-model="activity.spikeType" /> 需要秒杀
            </td>
        </tr>
        <%}%>
        <tr ng-switch on="activity.singleEvent" ng-show="code.singleOrderShow" class="bgf9f9f9" ng-show="code.ticketShow">
            <td ng-switch-when=1 width="100" class="td-title"><span class="red">*</span>场次设置：</td>
            <td ng-switch-when=1 class="td-time td-input  td-online">
                <div class="starts w340">
                    <span class="text">开始日期</span>
                    <input class="bgf9f9f9" type="text" ng-model="event.singleStartTime" value="" readonly/>
                    <i date-picker ng-model="event.singleStartTime"></i>
                </div>
                <span class="txt">至</span>
                <div class="ends w340">
                    <span class="text">结束日期</span>
                    <input class="bgf9f9f9" type="text" ng-model="event.singleEndTime" value="" readonly/>
                    <i date-picker ng-model="event.singleEndTime"></i>
                </div>
                <input ng-model="area.startHour" required ng-required min="0" type="number" class="input-text w64" maxlength="2" ng-disabled="code.typeDisable" />：
                <input ng-model="area.startMinute" required ng-required min="0" type="number" class="input-text w64" maxlength="2" ng-disabled="code.typeDisable" />至
                <input ng-model="area.endHour" required ng-required min="0" type="number" class="input-text w64" maxlength="2" ng-disabled="code.typeDisable" />：
                <input ng-model="area.endMinute" required ng-required min="0" type="number" class="input-text w64" maxlength="2" ng-disabled="code.typeDisable" />
                <em>票数：</em><input ng-show="!code.seatShow" ng-model="event.totalSeat" required ng-required type="number" min="0" class="input-text w64" />
                <input ng-keypress="$event.preventDefault()" ng-show="code.seatShow" ng-model="event.totalSeat" required ng-required min="0" class="input-text w64" />
                <input type="button" class="set-ticket" ng-show="code.seatShow" ng-click="loadSeat(x.num)" value="设置座位" />
            </td>
        </tr>
        <tr ng-switch on="activity.singleEvent" ng-show="code.singleOrderShow" class="bgf9f9f9" ng-show="code.ticketShow">
            <td ng-switch-when=0 width="100" class="td-title"><span class="red">*</span>场次设置：</td>
            <td ng-switch-when=0 class="td-time td-input">
                <div class="starts w340">
                    <span class="text">开始日期</span>
                    <input class="bgf9f9f9" type="text" ng-model="event.startTime" value="" readonly/>
                    <i date-picker ng-model="event.startTime"></i>
                </div>
                <span class="txt">至</span>
                <div class="ends w340">
                    <span class="text">结束日期</span>
                    <input class="bgf9f9f9" type="text" ng-model="event.endTime" value="" readonly/>
                    <i date-picker ng-model="event.endTime"></i>
                </div>
                <input type="button" class="upload-btn" ng-click="getEvents()" value="生成场次" />
            </td>
        </tr>
        <tr ng-switch on="activity.singleEvent" ng-show="code.singleOrderShow" class="bgf9f9f9" ng-show="code.ticketShow">
            <td ng-switch-when=0 width="100" class="td-title"></td>
            <td ng-switch-when="0" class="td-input ng-scope">
                <div id="free-time-set">
                    <div id="put-ticket-list" style="width: 800px;">
                        <!-- ngRepeat: x in event.eventTimes track by $index -->
                        <div class="ticket-item ng-scope" ng-repeat="x in event.eventTimes track by $index">
                            <input ng-model="x.startHour"  ng-required=""  type="number" class="input-text w64 ng-pristine ng-untouched ng-valid ng-not-empty ng-valid-max ng-valid-required ng-valid-maxlength" maxlength="2"><em>：</em>
                            <input ng-model="x.startMinute"  ng-required=""  type="number" class="input-text w64 ng-pristine ng-untouched ng-valid ng-not-empty ng-valid-max ng-valid-required ng-valid-maxlength" maxlength="2"><span class="zhi">至</span>
                            <input ng-model="x.endHour"  ng-required="" type="number" class="input-text w64 ng-pristine ng-untouched ng-valid ng-not-empty ng-valid-max ng-valid-required ng-valid-maxlength" maxlength="2"><em>：</em>
                            <input ng-model="x.endMinute"  ng-required=""  type="number" class="input-text w64 ng-pristine ng-untouched ng-valid ng-not-empty ng-valid-max ng-valid-required ng-valid-maxlength" maxlength="2">
                            <a ng-click="deleteEventTime(x.number)" class="timeico jianhao" style="background: url(${path}/STATIC/image/remove.png) no-repeat center center;width: 25px;"></a>
                        </div>
                        <!-- end ngRepeat: x in event.eventTimes track by $index -->
                        <a ng-click="addEventTime()" class="timeico tianjia" style="background: url(${path}/STATIC/image/add.png) no-repeat center center;width: 25px;"></a>
                    </div>
                </div>
            </td>
        </tr>
        <tr ng-repeat="x in event.eventList track by $index" ng-show="code.singleOrderShow" class="bgf9f9f9" ng-show="code.ticketShow">
            <td width="100" class="td-title"><span class="red"></span>场次{{x.num}}：</td>
            <td class="td-time  td-online">
                <div class="start w340" ng-show="code.spickShow">
                    <span class="text">秒杀时间</span>
                    <input class="bgf9f9f9" type="text" style="width: 125px" ng-model="x.spikeTime" value="" readonly/>
                    <i date-picker-hour ng-model="x.spikeTime"></i>
                </div>
                <div class="starts w340">
                    <span class="text">场次日期</span>
                    <input class="bgf9f9f9" type="text" ng-model="x.eventDate" value="" readonly/>
                    <i date-picker ng-model="x.eventDate"></i>
                </div>

                <input ng-model="x.startHour" required ng-required min="0" type="number" class="input-text w64" maxlength="2" ng-disabled="code.typeDisable" />：<em ng-show="code.noTicketShow"></em>
                <input ng-model="x.startMinute" required ng-required min="0" type="number" class="input-text w64" maxlength="2" ng-disabled="code.typeDisable" />至<em ng-show="code.noTicketShow"></em>
                <input ng-model="x.endHour" required ng-required min="0" type="number" class="input-text w64" maxlength="2" ng-disabled="code.typeDisable" />：<em ng-show="code.noTicketShow"></em>
                <input ng-model="x.endMinute" required ng-required min="0" type="number" class="input-text w64" maxlength="2" ng-disabled="code.typeDisable" />
                <em>票数：</em><input ng-show="!code.seatShow" ng-model="x.availableCount" required ng-required type="number" min="0" class="input-text w64" />
                <input ng-keypress="$event.preventDefault()" ng-show="code.seatShow" ng-model="x.availableCount" required ng-required min="0" class="input-text w64" />
                <em ng-show="code.payShow">票价：</em><input ng-show="code.payShow" ng-model="x.orderPrice" required ng-required type="number" min="0" class="input-text w64" />
                <input type="button" class="set-ticket" ng-show="code.seatShow" ng-click="loadSeat(x.num)" value="设置座位" />
                <a ng-click="deleteEventList(x.num)" class="timeico jianhao" style="background: url(${path}/STATIC/image/remove.png) no-repeat center center;height:25px;width: 25px;display: inline-block;"></a>
            </td>
        </tr>
        <tr ng-show="code.addEventListBtn" class="bgf9f9f9" ng-show="code.ticketShow">
            <td></td>
            <td>
                <a ng-click="addEventList(x.num)" class="timeico tianjia" style="background: url(${path}/STATIC/image/add.png) no-repeat center center;width: 25px;height: 25px;display: inline-block;"></a>
            </td>
        </tr>
        <tr ng-repeat="x in event.spickList track by $index" ng-show="code.spickShow" ng-show="code.singleOrderShow" ng-show="code.ticketShow">
            <td width="100" class="td-title"><span class="red"></span>秒杀{{x.num}}：</td>
            <td class="td-time td-input">
                <div class="start w340">
                    <span class="text">秒杀时间</span>
                    <input type="text" style="width: 125px" ng-model="x.spikeTime" value="" readonly/>
                    <i date-picker-hour ng-model="x.spikeTime"></i>
                </div>
                <em>票数：</em><input ng-model="x.availableCount" required ng-required type="number" min="0" class="input-text w64" />
                <em ng-show="code.payShow">票价：</em><input ng-show="code.payShow" ng-model="x.orderPrice" required ng-required type="number" min="0" class="input-text w64" />
                <a ng-click="deleteSpickTime(x.num)" class="timeico jianhao"></a>
            </td>
        </tr>

        <tr ng-switch on="activity.singleEvent" ng-show="code.spickShow" ng-show="code.ticketShow">
            <td ng-show="code.ticketShow" ng-switch-when=1 width="100" class="td-title"> 添加秒杀</td>
            <td ng-show="code.ticketShow" class="td-input" ng-switch-when=1>
                <a ng-click="addSpickTime()" class="timeico tianjia"></a>
            </td>
        </tr>

        <tr ng-show="code.DIYShow">
            <td width="100" class="td-title">单个ID购票限制：</td>
            <td class="td-input">
                <label><input type="radio" ng-model="code.DIY" value="0"/><em>默认（单个ID每场最多订5张票）</em></label>
                <label><input type="radio" ng-model="code.DIY" value="1"/><em>自定义</em></label>
            </td>
        </tr>
        <tr ng-show="code.DIYDetail" ng-show="code.DIYShow">
            <td width="100" class="td-title"></td>
            <td class="td-input td-fees">
                <div style="width: 400px;padding: 10px 0px;" class="bgf9f9f9">
                    <label><em>限制</em><input ng-model="activity.ticketNumber" required
                                             ng-required min="0" type="number"
                                             class="input-text w64"
                                             maxlength="2"/>次</label>
                    <label><em>单次最多预订</em><input ng-model="activity.ticketCount" required
                                                 ng-required min="0" type="number"
                                                 class="input-text w64"
                                                 maxlength="2"/>张</label>
                    <div style="clear: both;"></div>
                </div>
            </td>
        </tr>
        <tr ng-show="code.creShow">
            <td width="100" class="td-title">购票积分设置：
            </td>
            <td class="td-input">
                <label><input type="radio" ng-model="code.cre" value="0"/><em>默认</em></label>
                <label><input type="radio" ng-model="code.cre" value="1"/><em>自定义</em></label>
            </td>
        </tr>
        <tr ng-show="code.cre">
            <td width="100" class="td-title"></td>
            <td class="td-input td-fees bgf9f9f9">

                <label><em>用户积分需达</em><input
                        ng-model="activity.lowestCredit" required ng-required min="0" type="number"
                        class="input-text w64" maxlength="5"/>积分方可预订</label>
                <label><em>本场活动每张票需消耗</em><input
                        ng-model="activity.costCredit" required ng-required min="0" type="number" class="input-text w64"
                        maxlength="5"/>积分抵扣 </label>
                <label><em>本场活动不核销将扣除</em><input
                        ng-model="activity.deductionCredit" required ng-required min="0" type="number"
                        class="input-text w64" maxlength="5"/>积分</label>

            </td>
        </tr>

        <tr ng-show="code.creShow">
            <td width="100" class="td-title"></td>
            <td class="td-input">
                <input type="checkbox" ng-true-value='1' ng-false-value='0' ng-model="activity.identityCard" /> 需要填写身份证号
            </td>
        </tr>
        <tr ng-show="code.smsTypeShow" ng-show="code.ticketShow">
            <td width="100" class="td-littleTitle titleBg">短信模板：</td>
            <td>
                <div class="bt-line" style="height: 11px;"></div>
            </td>
        </tr>
        <tr ng-show="code.smsTypeShow" ng-show="code.ticketShow">
            <td width="100" class="td-title"></td>
            <td class="td-input td-fees ">
                <label><input type="radio" ng-model="activity.activitySmsType" value="0"/><em>取票码入场</em></label>
                <label><input type="radio" ng-model="activity.activitySmsType" value="1"/><em>取票机取票入场</em></label>
                <label><input type="radio" ng-model="activity.activitySmsType" value="2"/><em>换实体票入场</em></label>
            </td>
        </tr>
        <tr>
            <td width="100" class="td-littleTitle titleBg">活动描述：</td>
            <td>
                <div class="bt-line" style="height: 11px;"></div>
            </td>
        </tr>
        <tr>
            <td width="100" class="td-title">购票须知：</td>
            <td class="td-input">
                <div class="editor-box">
                    <textarea ng-model="activity.activityNotice" rows="4" class="textareaBox" maxlength="300" style="width: 500px;resize: none"></textarea>
                </div>
            </td>
        </tr>
        <tr class="">
            <td width="100" class="td-title"></td>
            <td class="td-content">
                <div class="editor-box">
                    <textareab ng-model="activity.activityMemo" name="activityMemo" id="activityMemo"></textareab>
                </div>
            </td>
        </tr>
        <tr>
            <td width="100" class="td-title">
            </td>
            <td class="td-btn">
                <div class="room-order-info info2" style="position: relative;">
                    <input ng-show="code.saveShow" class="btn-save" type="button" ng-click="saveInfo(1)" value="保存草稿"/>
                    <input ng-show="code.saveShow" class="btn-publish" type="button" ng-click="saveInfo(6)" value="发布信息"/>
                    <span ng-show="code.btnpublishDisable"><img src="${path}/STATIC/image/loading.gif" />正在保存中.....</span>
                    <input ng-show="!code.saveShow"class="btn-publish" type="button" ng-click="saveInfo(6)" value="保存"/>
                    <input class="btn-publish" type="button" ng-click="preview(6)" value="预览"/>
                </div>
            </td>
        </tr>
    </table>
</div>
</body>
</html>
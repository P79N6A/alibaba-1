<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<head>
    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>

    <script type="text/javascript" src="${path}/STATIC/js/admin/activity/UploadActivityFile.js"></script>
    <%--<script type="text/javascript" src="${path}/STATIC/js/admin/activity/getActivityFile.js"></script>--%>
    <script type="text/javascript" src="${path}/STATIC/js/area.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/area-venues.js?version=20151219"></script>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    <!-- dialog start -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/ckeditor/sample.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/admin/activity/editpublicActivity.js?version=20151221"></script>
    <script type="text/javascript">



        // 日期控件
        $(function(){
            if ('${isPayStatus}' != '1') {
                $(".start-btn").on("click", function(){
                    WdatePicker({el:'startDateHidden',dateFmt:'yyyy-MM-dd',doubleCalendar:true,minDate:'%y-%M-{%d+1}', maxDate:'#F{$dp.$D(\'endDateHidden\')}',position:{left:-224,top:8},isShowClear:false,isShowOK:true,isShowToday:false,onpicked:pickedStartFunc})
                })
                $(".end-btn").on("click", function(){
                    WdatePicker({el:'endDateHidden',dateFmt:'yyyy-MM-dd',doubleCalendar:true,minDate:'#F{$dp.$D(\'startDateHidden\')}',position:{left:-224,top:8},isShowClear:false,isShowOK:true,isShowToday:false,onpicked:pickedendFunc})
                })
            }
            var weekDay = ["星期天", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"];
            var dateStr = $("#activityStartTime").val();
            var dateStr2 = $("#activityEndTime").val();
            var myDate = new Date(Date.parse(dateStr.replace(/-/g, "/")));
            var myDate2 = new Date(Date.parse(dateStr2.replace(/-/g, "/")));
            $("#startWeek").html(weekDay[myDate.getDay()]);
            $("#endWeek").html(weekDay[myDate2.getDay()]);

        });
        seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
            window.dialog = dialog;
        });

        window.console = window.console || {log:function () {}}



    </script>
    <script type="text/javascript">
        $(function() {
            scrollTo(0,0);
            $('#loc_area').change(function() {
                // 位置字典根据区域变更
                dictLocation($("#loc_area").find("option:selected").val());
				$("#activityLocation").val("0");
            });

            var venueArea ='${activity.activityArea}';
            var venueType ='${activity.venueType}';
            if($("#createActivityCode").val()==2){	//区自建
            	venueType = "1";
        	}
            //场馆
            showVenueData(venueArea.split(",")[0],venueType,'${activity.venueId}');
            //获取活动主题
//            var venueType = $('#activityType').val();
            //获取位置
            dictLocation('${fn:substringBefore(activity.activityArea,",")}');
        });


        $(function(){
            seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
                window.dialog = dialog;
            });
        });



        window.console = window.console || {log:function () {}}
        function refuseUserActivity(activityId) {
            var dialogWidth = ($(window).width() < 800) ? ($(window).width() * 0.6) : 800;
            dialog({
                url: '${path}/activity/preRefuseUserActivity.do?activityId=' + activityId,
                title: '拒绝用户活动',
                width: 500,
                /*  height:dialogHeight,*/
                fixed: false,
                data: {
                    'rsData':1
                }, // 给 iframe 的数据
                onclose: function () {
                    if(this.returnValue){
                        //console.log(this.returnValue);
                        window.location.href="${path}/activity/activityPersonalIndex.do?activityState=3&activityPersonal=1";
                    }
                }
            }).showModal();
            return false;
        }


        /**
         * 发布活动
         */
        function publishActivity(activityId,activityState){
            var html = "确定通过该活动审核吗?<br>确定通过后您可以在活动列表中查看该活动";
            if (activityState == 7) {
                html = "您确定不通过该活动审核吗?";
                refuseUserActivity(activityId);
            } else {
                dialogConfirm("提示", html, function(){
                    $.post("${path}/activity/publishActivity.do",{"activityId":activityId,"activityState":activityState}, function(data) {
                        if (data!=null && data=='success') {
                            dialogAlert("提示", '操作成功',function () {
                                window.location.href="${path}/activity/activityPersonalIndex.do?activityState=3&activityPersonal=1";
                            });
                        } else {
                            dialogAlert("提示", '操作失败:' +data ,function () {
                            });
                        }
                    });
                })
            }
        }
        function callBackActivityPage(){
            window.location.href="${path}/activity/activityPersonalIndex.do?activityPersonal=1&activityState=" + $("#activityState").val();
        }
    </script>
</head>
<body >
<form action="${path}/activity/editActivity.do" id="activityForm" method="post">
    <input type="hidden" id="userCounty" name="userCounty" value="${sessionScope.user.userCounty}">
    <input type="hidden" id="activityId" name="activityId" value="${activity.activityId}">
    <input type="hidden" id="activityIsDel" name="activityIsDel" value="${activity.activityIsDel}">
    <input type="hidden" id="activityState" name="activityState" value="${activity.activityState}"/>
    <input type="hidden" id="seatIds" name="seatIds" value="${seatIds}"/>
    <input type="hidden" id="seatInfo" name="seatInfo" value="${seatInfo}"/>
    <input type="hidden" id="validCount" name="validCount" value=""/>
    <input type="hidden" id="activityArea" name="activityArea" value=""/>
    <input type="hidden" id="sessionId" value="${pageContext.session.id}"/>
    <input type="hidden" name="eventStartTimes" value="" id="eventStartTimes" />
    <input type="hidden" name="eventEndTimes" value="" id="eventEndTimes" />
    <!--  -->
    <input type="hidden" id="createActivityCode" name="createActivityCode" value="<c:if test="${empty activity.createActivityCode}">0</c:if><c:if test="${not empty activity.createActivityCode}">${activity.createActivityCode}</c:if>"/>
    <div class="site">
        <em>您现在所在的位置：</em>活动管理 &gt; 个人活动审核
    </div>
    <input type="hidden" value="${sessionScope.user.userIsManger}" id="userIsManager"/>
    <div class="site-title">活动发布</div>
    <div class="main-publish">
        <table width="100%" class="form-table">
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>活动名称：</td>

                <td class="td-input" id="activityNameLabel">
                    <%--<input <c:if test="${isPayStatus == 1}" > readonly="readonly" </c:if> type="text" value='--%><c:out value="${activity.activityName}" escapeXml="true"/><%--' id="activityName" name="activityName" class="input-text w510" maxlength="20"/>--%></td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>上传封面：</td>
                <td class="td-upload" id="activityIconUrlLabel">
                    <table>
                        <tr>
                            <td>
                                <input type="hidden"  name="activityIconUrl" id="activityIconUrl" value="${activity.activityIconUrl}">
                                <img id="activityImg" src=""  width="300" height="200"/>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>所属场馆：</td>
                <td class="td-select" id="venueIdLabel">
                    <input type="hidden" style="position: absolute; left: -9999px;" id="venueId" value="${activity.venueId}" name="venueId"/>
                    <script type="text/javascript">

                        /*传入默认值  start*/
                        $(function(){
                            //showLocation(44,45,48);
                            showLocation(${fn:substringBefore(activity.activityProvince,",")},${fn:substringBefore(activity.activityCity,",")},${fn:substringBefore(activity.activityArea,",")});
                            $("#loc_province").select2("val", ${fn:substringBefore(activity.activityProvince,",")});
                            $("#loc_city").select2("val", ${fn:substringBefore(activity.activityCity,",")});
                            $("#loc_town").select2("val", ${fn:substringBefore(activity.activityArea,",")});
                        });
                        /*传入默认值  end*/

                    </script>
	                <div id="loc_s">
	                    <select id="loc_province" disabled style="width:142px; margin-right: 8px"></select>
	                    <select id="loc_city" disabled style="width:142px; margin-right: 8px"></select>
	                    <div id="loc_q">
	                    	<select id="loc_town" disabled style="width:142px; margin-right: 8px"></select>
	                    </div>
	                </div>
                    <script type="text/javascript">
                        if($("#userIsManager").val() == 4){
                            $("#loc_area").prop("disabled", true);
                            $("#loc_category").prop("disabled", true);
                            $("#loc_venue").prop("disabled", true);
                        }
                    </script>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>活动标签：</td>
                <td class="td-tag">
                    <%--<dl>--%>
                        <%--<dt>人群</dt>--%>
                        <%--<input id="activityCrowd" name="activityCrowd" style="position: absolute; left: -9999px;" type="hidden" value="${activity.activityCrowd}"/>--%>
                        <%--<dd id="activityCrowdLabel">--%>
                        <%--</dd>--%>
                    <%--</dl>--%>
                    <%--<dl>--%>
                        <%--<dt>心情</dt>--%>
                        <%--<input id="activityMood" name="activityMood" style="position: absolute; left: -9999px;" type="hidden" value="${activity.activityMood}"/>--%>
                        <%--<dd id="activityMoodLabel" class="labl_class">--%>
                        <%--</dd>--%>
                    <%--</dl>--%>
                    <dl>
                        <dt>类型</dt>
                        <input id="activityType" name="activityType" style="position: absolute; left: -9999px;" type="hidden" value="${activity.activityType}"/>
                        <dd id="activityTypeLabel">
                        </dd>
                    </dl>
<%--                    <dl>
                        <dt>位置</dt>
                        <input id="activityLocation" name="activityLocation" value="${activity.activityLocation}" style="position: absolute; left: -9999px;" type="hidden"/>
                        <dd id="activityLocationLabel">
                        </dd>
                    </dl>--%>
                </td>
            </tr>
            </tr>
            <input id="tagIds" name="tagIds" type="hidden"   style="position: absolute; left: -9999px;" value="${tagIds}"/>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>活动日期：</td>
                <td class="td-time" id="activityStartTimeLabel">
                        <div  class="start w340">
                            <span class="text">开始日期</span>
                            <input type="hidden" id="startDateHidden"/>
                            <c:if test="${isPayStatus != 1}"><input  disabled type="text"  id="activityStartTime" name="activityStartTime" value="${activity.activityStartTime}"/></c:if>
                            <c:if test="${isPayStatus == 1}"><input  type="hidden"  id="activityStartTime" name="activityStartTime" value="${activity.activityStartTime}"/><span class="dateSpan gray">${activity.activityStartTime}</span></c:if>
                            <span class="week <c:if test='${isPayStatus == 1}'>gray</c:if>" id="startWeek">星期五</span>
                           <%-- <i class="data-btn start-btn"></i>--%>
                        </div>
                        <span class="txt">至</span>
                        <div  class="end w340">
                            <span class="text">结束日期</span>
                            <input type="hidden" id="endDateHidden"/>
                            <c:if test="${isPayStatus != 1}"><input type="text" disabled id="activityEndTime" name="activityEndTime"  value="${activity.activityEndTime}" /></c:if>
                            <c:if test="${isPayStatus == 1}"><input type="hidden" id="activityEndTime" name="activityEndTime"  value="${activity.activityEndTime}"/><span class="dateSpan gray">${activity.activityEndTime}</span></c:if>
                            <span class="week <c:if test='${isPayStatus == 1}'>gray</c:if>" id="endWeek">星期六</span>
                          <%--  <i class="data-btn end-btn" ></i>--%>
                        </div>

                       <%-- <span class="txt des">具体描述</span>
                    <input type="text" maxlength="100" name="activityTimeDes" id="activityTimeDes" class="input-text w210" value='<c:out value="${activity.activityTimeDes}" escapeXml="true"/>'/>--%>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>活动时间：</td>
                <td class="td-input">
                    <div id="free-time-set">
                        <div id="put-ticket-list" style="width: 800px;">
                            <c:forEach items="${activityEventTimes}"  var="activityEventTime" varStatus="varStatus">
                                <c:set value="${ fn:split(activityEventTime.eventTime, '-')[0]}" var="startTime" />
                                <c:set value="${ fn:split(activityEventTime.eventTime, '-')[1]}" var="endTime" />
                                    <div class="ticket-item"  id="activityTimeLabel${varStatus.index+1}">
                                        <input disabled onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" type="text"  data-type="hour" id="startHourTime${varStatus.index+1}"  name="eventStartHourTime" maxlength="2"  <c:if test="${isPayStatus == 1}" > readonly="readonly" </c:if> class="input-text w64" value="${fn:split(startTime, ':')[0]}"/><em>：</em>
                                        <input disabled onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" type="text"  data-type="minute" id="startMinuteTime${varStatus.index+1}" name="eventStartMinuteTime" maxlength="2" <c:if test="${isPayStatus == 1}" > readonly="readonly" </c:if>   class="input-text w64" value="${fn:split(startTime, ':')[1]}"/>
                                        <span class="zhi">至</span>
                                        <input disabled onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" type="text"  data-type="hour" id="endHourTime${varStatus.index+1}"  maxlength="2" <c:if test="${isPayStatus == 1}" > readonly="readonly" </c:if>  name="eventEndHourTime" class="input-text w64" value="${fn:split(endTime, ':')[0]}"/><em>：</em>
                                        <input disabled onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" type="text"  data-type="minute" id="endMinuteTime${varStatus.index+1}"  maxlength="2" <c:if test="${isPayStatus == 1}" >  readonly="readonly" </c:if>  name="eventEndMinuteTime" class="input-text w64" value="${fn:split(endTime, ':')[1]}"/>
                                     <%--   <c:if test="${varStatus.index > 0}" ><a class="timeico jianhao"></a></c:if> <c:if test="${varStatus.index == 0}" ><a href="javascript:void(0)" class="timeico tianjia"></a></c:if>--%>
                                    </div>
                            </c:forEach>
                        </div>
                    </div>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>活动地址：</td>
                <td class="td-input" id="activityAddressLabel">
                    <c:out value="${activity.activityAddress}" escapeXml="true"/>
                   <%-- <input type="text" id="activityAddress" value="" name="activityAddress" data-val="输入详细地址" class="input-text w510"/>--%>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>地图坐标：</td>
                <td class="td-input td-coordinate" id="LonLabel">
                    ${activity.activityLon}
                    <%--<input type="text" value="${activity.activityLon}" data-val="" id="activityLon" name="activityLon" class="input-text w120" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" readonly="readonly"/>--%>
                    <span class="txt">X</span>
                    ${activity.activityLat}
                    <%--<input type="text" value="${activity.activityLat}" data-val="" id="activityLat" name="activityLat" class="input-text w120" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" readonly="readonly"/>--%>
                    <span class="txt">Y</span>
                	<%--<input type="button" class="upload-btn" id="getMapAddressPoint" value="查询坐标"/>--%>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>活动电话：</td>
                <td class="td-input" id="activityTelLabel">
                    <c:out value="${activity.activityTel}" escapeXml="true"/>
                    <%--<input type="text" class="input-text w210" id="activityTel" name="activityTel" value="<c:out value="${activity.activityTel}" escapeXml="true"/>" maxlength="50"/>--%>
                </td>
            </tr>
            <c:if test="${activity.activityIsFree ==2}">
                <script>

                    $(function() {
                        $('#isFree').trigger("click");
                        //showSeatTemplate("Y");
                    });
                </script>

            </c:if>
            <tr>
                <td width="100" class="td-title">在线售票：</td>
                <td class="td-input td-fees td-online" id="activityReservationCountLabel">
                    <label>
                        <c:if test="${activity.activityIsReservation == 1}"> <em>不可预订</em> </c:if>
                    </label>
                    <label>
                        <c:if test="${activity.activityIsReservation == 2}"> <em>自由入座</em> </c:if>
                    </label>
                    <c:if test="${activity.activityIsReservation == 2}">
                    <div>
                        <em>每场次售票数</em>
                        ${activity.eventCount}
                           <%-- <span id="notOnlineTicket" style="display:inline-block;">
                                <input type="hidden" name="activityReservationCount" id="activityReservationCount" value="${activity.eventCount}"/>
                                <input <c:if test="${isPayStatus == 1}"> readonly="readonly" </c:if> type="text" disabled id="notOnlineText" class="input-text w120" onkeyup="this.value=this.value.replace(/\D/g,'')"  value="${activity.eventCount}"  <c:if test="${activity.activitySalesOnline =='N' and activity.activityIsReservation == 2}"></c:if> />
                                <input type="hidden" id="onlineText" <c:if test="${activity.activitySalesOnline =='Y'}"> value="${activity.eventCount}" </c:if>/>
                            </span>
                            <span id="onlineTicket" style="display:inline-block;"><c:choose><c:when test="${not empty activity.eventCount}">${activity.eventCount}</c:when><c:otherwise>0</c:otherwise></c:choose></span>
                            <em >张&nbsp;,总售票数:</em><span  id="totalEventCount" style="display:inline-block;"></span><em> 张</em>--%>
                    </div>
                    </c:if>
                </td>
            </tr>
            <c:if test="${activity.activitySalesOnline =='N' and activity.activityIsReservation == 2}">
                <script>
                    $(function() {
                        $('#freeSelect').trigger("click");
                        //showSeatTemplate("Y");
                        $("#setSeat").hide();
                        $("#notOnlineText").show();
                        $("#onlineTicket").hide();
                        $("#onlineTicket").html('${activity.eventCount}');
                        $("#onlineText").val('${activity.eventCount}');
                        $("#freeSelect").parents(".td-fees").find(".extra").css("display", "inline-block");
                    });
                </script>
            </c:if>
            <c:if test="${activitySeat == 'Y'}">
                <script>
                    $(function() {
                        $('#onlineSelect').trigger("click");
                        $("#onlineTicket").show();
                        $("#setSeat").show();
                        $("#notOnlineText").hide();
                        $("#notOnlineText").val(${activity.eventCount});
                        $("#onlineText").val("${activity.eventCount}");
                        $("#onlineText").html('${activity.eventCount}');
                        $("#freeSelect").parents(".td-fees").find(".extra").css("display", "inline-block");
                    });
                </script>
            </c:if>
            </tr>
            <tr class="td-line">
                <td width="100" class="td-title">活动描述：</td>
                <td class="td-content">
                    ${activity.activityMemo}
                    <div class="editor-box" style="display: none;">
                        <textarea name="activityMemo" id="activityMemo">
                            ${activity.activityMemo}
                        </textarea>
                    </div>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"></td>
                <td class="td-btn">
                    <div class="room-order-info info2" style="position: relative;">
                    <c:if test="${not empty activity.activityState&&activity.activityState!=6}">
                        <%if(activityPublishDraftButton){%>
                                <input type="button"  class="btn-publish" onclick="publishActivity('${activity.activityId}',6)" value="通过"/>
                                <c:if test="${not empty activity.activityState&&activity.activityState!=7}">
                                        <input type="button"  class="btn-publish" onclick="publishActivity('${activity.activityId}',7)" value="不通过"/>
                                </c:if>
                               <input type="button"   class="btn-save" onclick="javascript:history.go(-1);" value="返回"/>
                        <%}%>
                    </c:if>
                    </div>
                </td>
            </tr>
        </table>
    </div>
</form>
</body>
</html>
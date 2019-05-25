<%@ page language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>活动审核列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <%@include file="/WEB-INF/why/common/limit.jsp" %>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    
    <link rel="Stylesheet" type="text/css" href="${path}/STATIC/css/DialogBySHF.css" />
    <script type="text/javascript" src="${path}/STATIC/js/DialogBySHF.js"></script>
    
    <script type="text/javascript">
        seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
            window.dialog = dialog;
        });

        $(function () {
            $(".start-btn").on("click", function () {
                WdatePicker({
                    el: 'startDateHidden',
                    dateFmt: 'yyyy-MM-dd',
                    doubleCalendar: true,
                    minDate: '',
                    maxDate: '#F{$dp.$D(\'endDateHidden\')}',
                    position: {left: -150, top: 8},
                    isShowClear: false,
                    isShowOK: true,
                    isShowToday: false,
                    onpicked: pickedStartFunc
                })
            });
            $(".end-btn").on("click", function () {
                WdatePicker({
                    el: 'endDateHidden',
                    dateFmt: 'yyyy-MM-dd',
                    doubleCalendar: true,
                    minDate: '#F{$dp.$D(\'startDateHidden\')}',
                    position: {left: -150, top: 8},
                    isShowClear: false,
                    isShowOK: true,
                    isShowToday: false,
                    onpicked: pickedendFunc
                })
            })
            
            /*
                                         全 部区县
            */
            var venueProvince = '${user.userProvince}';
       	    var venueCity = '${user.userCity}';
            var venueArea = '${user.userCounty}';
            var ulHtml = "<li data-option=''>全部区县</li>";
            var divText = "全部区县";
            var loc = new Location();
            var a = new Array();
            var defaultAreaId = $("#activityArea").val();
            a=loc.find('0,' + venueProvince.split(",")[0]);
            $.each(a , function(k , v) {
                var Id =k;
                if(Id == venueCity.split(",")[0]){
               	 	var Text = v;
                    ulHtml += '<li data-option="' + Id + '">'
                    + Text
                    + '</li>';
	       			if(defaultAreaId==Id){
	       				divText=Text;
	       			}
                }
   			}) 
            a=loc.find('0,' + venueProvince.split(",")[0] + ',' + venueCity.split(",")[0]);
             $.each(a , function(k , v) {
           	  var area = a[k];
                 var areaId =k;
                 var areaText = v;
                 ulHtml += '<li data-option="' + areaId + '">'
                 + areaText
                 + '</li>';
    			if(defaultAreaId==areaId){
    				divText=areaText;
    			}
    		}) 
    		$("#areaDiv").html(divText);
    		$("#areaUl").append(ulHtml);
             
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
            });
            
            selectModel();
        });
        
        function pickedStartFunc() {
            $dp.$('activityStartTime').value = $dp.cal.getDateStr('yyyy-MM-dd');
        }
        function pickedendFunc() {
            $dp.$('activityEndTime').value = $dp.cal.getDateStr('yyyy-MM-dd');
        }
        
        //提交表单
        function formSub(formName) {
            var activityName = $('#activityName').val();
            if (activityName != undefined && activityName == '输入活动名称') {
                $('#activityName').val("");
            }
            var venueName = $('#venueName').val();
            if (venueName != undefined && venueName == '输入场馆名称') {
                $('#venueName').val("");
            }

            //场馆
            $('#venueId').val($('#loc_venue').val());
            $('#venueType').val($('#loc_category').val());
            $('#venueArea').val($('#loc_area').val());
            $(formName).submit();
        }

        //编辑活动
        function editActivity(activityId) {
        	$.post("${path}/activity/queryOrderCountByActivityId.do", {"activityId": activityId}, function (data) {
        		if (data > 0) {
        			dialogConfirm("提示", "该活动已产生订单不得编辑！");
        		}else{
        			location.href = '${path}/activity/preEditActivity.do?id='+activityId;
        		}
        	},"json");
        }
        
      	//审核通过
        function pushActivity(activityId) {
            var html = "您确定要审核通过该活动吗？";
            dialogConfirm("提示", html, function () {
                $.post("${path}/activity/pushActivity.do", {"activityId": activityId}, function (data) {
                    if (data != null && data == 'success') {
                        window.location.href = "${path}/activity/activityExamineIndex.do?activityState=${activity.activityState}&activityIsDel=${activity.activityIsDel}";
                    }
                });
            })
        }
      	
      	//审核不通过
        function delActivity(id) {
            var showText = "您确定要审核不通过该活动吗？";
            dialogConfirm("提示", showText, removeParent);
            function removeParent() {
                $.post("${path}/activity/pullActivity.do", {"id": id}, function (data) {
                    if ('2' == data.status) {
                        dialogAlert('提示', data.msg, function () {
                            location.href = "${path}/activity/activityExamineIndex.do?activityState=${activity.activityState}&activityIsDel=${activity.activityIsDel}";
                        });
                    } else if ('3' == data.status) {
                        //已经产生订单 确定是否撤销
                        var html = "<p style='text-align: left; line-height: 32px; color: #131F3F; font-size: 16px;'>该活动已产生用户预订订单，审核不通过后将取消该活动下所有订单并给订单用户发送活动撤销信息。您确定审核不通过该活动吗？</p>";
                        html += "<p style='text-align: left; line-height: 32px; color: #444444; font-size: 16px; margin-top: 50px;'>确认信息模版</p>";
                        html += "<textarea id='sms' style='padding: 15px 20px; width: 360px; height: 90px; line-height: 28px; color: #13203F; font-size: 14px; border: solid 1px #9B9B9B;'>亲爱的用户，您预订的活动“" + data.activityName + "”因故取消，系统已为您自动取消订单，因此为您带来的不便，请您谅解！</textarea>";
                        dialogConfirm("警告!", html, function () {
                            var smsMsg = document.getElementById('sms').value;
                            $.post("${path}/activity/pullActivity.do", {
                                "id": id,
                                "delOrder": 'Y',
                                "msgSMS": smsMsg
                            }, function (data) {
                                dialogAlert('提示', data.msg, function () {
                                    if ('2' == data.status) {
                                        location.href = "${path}/activity/activityExamineIndex.do?activityState=${activity.activityState}&activityIsDel=${activity.activityIsDel}";
                                    }
                                });
                            });
                        })
                    } else {
                        dialogAlert('提示', data.msg, function () {
                            location.href = "${path}/activity/activityExamineIndex.do?activityState=${activity.activityState}&activityIsDel=${activity.activityIsDel}";
                        });
                    }
                });
            }
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
<form id="activityForm" action="" method="post">
    <input type="hidden" name="activityState" id="activityState" value="${activity.activityState}"/>
    <div class="site">
        <em>您现在所在的位置：</em>活动管理 &gt; 活动审核列表
    </div>
    <div class="search">
        <div class="search-box">
            <i></i><input type="text" id="activityName" name="activityName" value="${activity.activityName}"
                          data-val="输入活动名称" class="input-text"/>
        </div>
        <div class="search-box">
            <i></i><input type="text" id="venueName" name="venueName" value="${activity.venueName}"
                          data-val="输入场馆名称" class="input-text"/>
        </div>
        <div class="select-box w135">
            <input type="hidden" id="activityType" name="activityType" value="${activity.activityType}"/>
            <div id="activityTypeDiv" class="select-text" data-value="">活动类型</div>
            <ul class="select-option" id="activityUl">
            </ul>
        </div>
        <c:if test="${activity.activityState == 6}">
	        <div class="select-box w135">
	            <input type="hidden" value="${activity.activityIsDel}" name="activityIsDel" id="activityIsDel"/>
	            <div class="select-text" data-value="">
	                <c:choose>
	                    <c:when test="${activity.activityIsDel == 0}">待审核</c:when>
	                    <c:when test="${activity.activitySalesOnline == 1}">审核通过</c:when>
	                    <c:when test="${activity.activitySalesOnline == 3}">审核不通过</c:when>
	                </c:choose>
	            </div>
	            <ul class="select-option">
	                <li data-option="">全部状态</li>
	                <li data-option="0">待审核</li>
	                <li data-option="1">审核通过</li>
	                <li data-option="3">审核不通过</li>
	            </ul>
	        </div>
	    </c:if>
	    <c:if test="${activity.activityState != 6}">
	    	<input type="hidden" name="activityIsDel" id="activityIsDel" value="${activity.activityIsDel}"/>
	    </c:if>
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
        <div class="select-box w135">
            <input type="hidden" value="${activity.availableCount}" name="availableCount"
                   id="availableCount"/>
            <div class="select-text" data-value="">
                <c:choose>
                    <c:when test="${activity.availableCount == 0}">
                        没有余票
                    </c:when>
                    <c:when test="${activity.availableCount == 1}">
                        有余票
                    </c:when>
                    <c:otherwise>
                        全部票数
                    </c:otherwise>
                </c:choose>
            </div>
            <ul class="select-option">
                <li data-option="">全部票数</li>
                <li data-option="0">没有余票</li>
                <li data-option="1">有余票</li>
            </ul>
        </div>
        <%if (updateRatingsInfoButton == true || RatingsInfoButton == true) {%>
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
        <%}%>
        <%--<div class="select-box w135">--%>
        <%--<input type="hidden" id="activityArea" name="activityArea" value="${activity.activityArea}"/>--%>
        <%--<div id="areaDiv" class="select-text" data-value="">全部区县</div>--%>
        <%--<ul class="select-option" id="areaUl">--%>
        <%--</ul>--%>
        <%--</div>--%>
        
        <div class="select-box w135">
        <input type="hidden" id="activityArea" name="activityArea" value="${activity.activityArea}"/>
        <div id="areaDiv" class="select-text" data-value="">全部区县</div>
        <ul class="select-option" id="areaUl">
        </ul>
        </div>
        
        <div class="select-box w135">
            <input type="hidden" value="${activity.activityIsDetails}" name="activityIsDetails"
                   id="activityIsDetails"/>
            <div class="select-text" data-value="">
                <c:choose>

                    <c:when test="${activity.activityIsDetails == 1}">
                        发布时间
                    </c:when>
                    <c:when test="${activity.activityIsDetails == 2}">
                        创建时间
                    </c:when>
                    <c:when test="${activity.activityIsDetails == 3}">
                        进行时间
                    </c:when>
                    <c:otherwise>
                        更新时间
                    </c:otherwise>
                </c:choose>
            </div>
            <ul class="select-option">
                <li data-option="">更新时间</li>
                <li data-option="1">发布时间</li>
                <li data-option="2">创建时间</li>
                <li data-option="3">进行时间</li>
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
                <%--<th class="venue">所属场馆</th>--%>
                <%--<th>所属区县</th>--%>
                <th>选座方式</th>
                <%--<th>费用</th>--%>
                <th>剩余票数</th>
                <th>开始时间</th>
                <th>结束时间</th>
                <th>创建人</th>
                <th>创建时间</th>
                <th>最新操作人</th>
                <th>最新操作时间</th>
                <%if (updateRatingsInfoButton == true || RatingsInfoButton == true) {%>
                <th>评级信息</th>
                <%}%>
                <th>状态</th>
                <th>管理</th>
            </tr>
            </thead>

            <tbody>
            <%int i = 0;%>
            <c:forEach items="${activityList}" var="avct">
                <%i++;%>
                <tr>
                        <%--<td><input type="checkbox"  name="activityId"  value="${avct.activityId}" /></td>--%>
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
                                <div>
                                    <c:choose>
                                        <c:when test="${avct.createActivityCode == 1}">上海市</c:when>
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
                                    -
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

                                </div>
                            </c:if>
                        </c:if>
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
                        <c:if test="${not empty avct.activityCount}">
                            ${avct.activityCount}
                        </c:if>
                        <c:if test="${empty avct.activityCount}">
                            -
                        </c:if>

                    </td>
                    <td>
                        <c:if test="${not empty avct.activityStartTime}">
                            ${avct.activityStartTime}
                        </c:if>

                    </td>
                    <td>
                        <c:if test="${not empty avct.activityEndTime}">
                            ${avct.activityEndTime}
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

                    <%if (updateRatingsInfoButton == true || RatingsInfoButton == true) {%>
                    <td>
                        <c:if test="${not empty avct.ratingsInfo}">
                            ${avct.dictName}
                        </c:if>
                        <c:if test="${ empty avct.ratingsInfo}">
                            暂无评级
                        </c:if>

                    </td>
                    <%}%>

					<td>
						<c:if test="${avct.activityIsDel == 0}">待审核</c:if>
						<c:if test="${avct.activityIsDel == 1}">审核通过</c:if>
						<c:if test="${avct.activityIsDel == 3}">审核不通过</c:if>
					</td>

                    <td>
                        <!-- 其他部门共享的数据只具有查看权限 当用户部门路径比活动路径短的时候说明用户权限大 可以看到下级数据也可以编辑  当活动路径比用户路劲短时 说明是上级用户共享给其他部门的数据权限 只具有查看功能(仅限同区用户) -->
                        <!-- 同部门的路劲应是包含关系 -->
                        <c:if test="${(fn:length(avct.activityDept) > fn:length(sessionScope.user.userDeptPath) and fn:contains(avct.activityDept,sessionScope.user.userDeptPath)) or avct.activityDept == sessionScope.user.userDeptPath}">
                            <c:if test="${not empty avct.activityState && avct.activityState==6}">
                                <c:if test="${avct.sysNo=='0'||empty avct.sysNo}">
                                    <%if (activityPreEditButton) {%>
                                    	<a target="main" href="javascript:editActivity('${avct.activityId}');">编辑</a> |
                                    <%}%>
                                </c:if>
                                <%if (activityDeleteButton) {%>
	                                <c:if test="${avct.activityState== 6}">
	                                    <c:if test="${avct.activityIsDel== 0}">
	                                    	<a href="javascript:;" onclick="pushActivity('${avct.activityId}')">审核通过</a> | 
	                                        <a target="main" href="javascript:delActivity('${avct.activityId}');">审核不通过</a>
	                                    </c:if>
	                                    <c:if test="${avct.activityIsDel== 1}">
	                                        <a target="main" href="javascript:delActivity('${avct.activityId}');">审核不通过</a>
	                                    </c:if>
	                                    <c:if test="${avct.activityIsDel == 3}">
	                                        <a href="javascript:;" onclick="pushActivity('${avct.activityId}')">审核通过</a>
	                                    </c:if>
	                                </c:if>
                                <%}%>
                            </c:if>
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
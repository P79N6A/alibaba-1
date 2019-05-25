<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>活动列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>

    <script type="text/javascript">

        function exportExcel() {
            var activityName=$('#activityName').val();
            if(activityName!=undefined&&activityName=='输入活动名称'){
                $('#activityName').val("");
            }

            /*            $.post("${path}/activity/exportActivityExcel.do",$("#activityForm").serialize(), function(rsData) {
             });*/
            location.href = "${path}/activity/exportActivityExcel.do?" + $("#activityForm").serialize();
        }
        //** 日期控件
        $(function(){
            $(".start-btn").on("click", function(){
                WdatePicker({el:'startDateHidden',dateFmt:'yyyy-MM-dd',doubleCalendar:true,minDate:'',maxDate:'#F{$dp.$D(\'endDateHidden\')}',position:{left:-224,top:8},isShowClear:false,isShowOK:true,isShowToday:false,onpicked:pickedStartFunc})
            })
            $(".end-btn").on("click", function(){
                WdatePicker({el:'endDateHidden',dateFmt:'yyyy-MM-dd',doubleCalendar:true,minDate:'#F{$dp.$D(\'startDateHidden\')}',position:{left:-224,top:8},isShowClear:false,isShowOK:true,isShowToday:false,onpicked:pickedendFunc})
            })
        });
        function pickedStartFunc(){
            $dp.$('activityStartTime').value=$dp.cal.getDateStr('yyyy-MM-dd');
        }
        function pickedendFunc(){
            $dp.$('activityEndTime').value=$dp.cal.getDateStr('yyyy-MM-dd');
        }



        $(function(){
            $("input").focus();
            kkpager.generPageHtml({
                pno : '${page.page}',
                total : '${page.countPage}',
                totalRecords :  '${page.total}',
                mode : 'click',//默认值是link，可选link或者click
                click : function(n){
                    this.selectPage(n);
                    $("#page").val(n);
                    formSub('#activityForm');
                    return false;
                }
            });
        });

        // 置顶
        function recommendActivity(activityId){
            $.post("${path}/recommend/homeNavigationRecommendActivity.do",{activityId:activityId,activityTheme:$("#activityTheme").val(),activityArea:$("#activityArea").val()}, function(rsData) {
                if (rsData == 'success') {
                    dialogAlert("提示", "置顶成功!",function () {
                        location.href= "${path}/recommend/activityHomeRecommendIndex.do?activityTheme="+$("#activityTheme").val()+"&activityArea="+$("#activityArea").val();
                    });
                } else {
                    dialogAlert("提示", "置顶失败!");
                }
            });
        }

        // 取消置顶
        function cancelRecommendActivity(activityId){
            $.post("${path}/recommend/cancelHomeNavigationRecommendActivity.do",{activityId:activityId}, function(rsData) {
                if (rsData == 'success') {
                    dialogAlert("提示", "取消置顶成功!",function () {
                        location.href= "${path}/recommend/activityHomeRecommendIndex.do?activityTheme="+$("#activityTheme").val()+"&activityArea="+$("#activityArea").val();
                    });
                } else {
                    dialogAlert("提示", "取消置顶失败!");
                }
            });
        }


        function changeLeftMenu(){
            $("#left",parent.document.body).attr("src","${path}/activityLeft.do")
        }

        //提交表单
        function formSub(formName){
            var  activityName=$('#activityName').val();
            if(activityName!=undefined&&activityName=='输入关键词'){
                $('#activityName').val("");
            }
            //场馆
            $('#venueType').val($('#loc_category').val());
            $(formName).submit();
        }

        $(function () {
            selectModel();
        });



        //查询活动中存在的区域
        $(function () {
            var defaultAreaId = $("#activityArea").val();
            $.get("${path}/activity/queryExistArea.do",{'activityState' : $("#activityState").val()},
                    function(areaData) {
                var ulHtml = "<li data-option=''>全部区县</li>";
                var divText = "全部区县";
                if (areaData != '' && areaData != null) {
                    for(var i=0; i<areaData.length; i++){
                        var area = areaData[i].activityArea;
                        var array = area.split(",");
                        var areaId = array[0];
                        var areaText = array[1];
                        ulHtml += '<li data-option="'+areaId+'">'
                        + areaText
                        + '</li>';
                        if(defaultAreaId == areaId){
                            divText = areaText;
                        }
                    }
                    $("#areaDiv").html(divText);
                    $("#areaUl").html(ulHtml);
                }
            }).success(function() {

            });
        });


        //查询活动中存在的活动类型
        $(function() {
            //获取活动主题
            var activityTheme = $('#activityTheme').val();
            var ulHtml = '';
            $.post("../tag/getChildTagByType.do?code=ACTIVITY_THEME",function(data) {
                if (data != '' && data != null) {
                    var list = eval(data);
                    for (var i = 0; i <list.length; i++) {
                        var dict = list[i];
                        ulHtml += '<li data-option="'+dict.tagId+'">'+ dict.tagName+ '</li>';
                        if (activityTheme != '' && dict.tagId == activityTheme) {
                            $('#activityThemeDiv').html(dict.tagName);
                        }
                    }
                    $('#activityUl').html(ulHtml);
                }
            }).success(function() {
//                $.post("../tag/getChildTagByType.do?code=ACTIVITY_TYPE", function (data) {
//                    if (data != '' && data != null) {
//                        var list = eval(data);
//
//                        for (var i = 0; i < list.length; i++) {
//                            var dict = list[i];
//                            ulHtml += '<li data-option="' + dict.tagId + '">' + dict.tagName + '</li>';
//                            if (activityTheme != '' && dict.tagId == activityTheme) {
//                                $('#activityThemeDiv').html(dict.tagName);
//                            }
//                        }
//                        $('#activityUl').html(ulHtml);
//                    }
//                });
            });
        });




    </script>
</head>
<body>
<form id="activityForm" action="${path}/recommend/activityHomeRecommendIndex.do" method="post">
    <input type="hidden" id="tagName" name="tagName"/>
<input type="hidden" name="activityIsDel" value="${activity.activityIsDel}"/>
    <input type="hidden" name="activityState" value="${activity.activityState}"/>
<div class="site">
    <em>您现在所在的位置：</em>推荐管理 &gt; web端推荐&gt;首页栏目推荐

</div>

<div class="search">
    <div class="search-box">
        <i></i><input type="text" id="activityName" name="activityName" value="${activity.activityName}" data-val="输入关键词" class="input-text"/>
    </div>

    <div class="select-box w135">
        <input type="hidden" id="activityTheme" name="activityTheme" value="${activity.activityTheme}"/>
        <div id="activityThemeDiv" class="select-text" data-value="">免费看演出</div>
        <ul class="select-option" id="activityUl">
        </ul>
    </div>

    <div class="select-box w135">
        <input type="hidden" id="activityArea" name="activityArea" value="${activity.activityArea}"/>
        <div id="areaDiv" class="select-text" data-value="">全部区县</div>
        <ul class="select-option" id="areaUl">
        </ul>
    </div>

    <div class="select-btn">
        <input type="button" onclick="$('#page').val(1);formSub('#activityForm');" value="搜索"/>
    </div>

</div>
<div class="main-content">
    <table width="100%">
        <thead>
            <tr>
                <th >ID</th>
                <th class="title">活动名称</th>
                <th class="venue">所属场馆</th>
                <th>所属区县</th>
                <th>选座方式</th>
                <th>操作人</th>
                <th>管理</th>
            </tr>
        </thead>

        <tbody>
        <%int i=0;%>
        <c:forEach items="${activityList}" var="avct" varStatus="status">
            <%i++;%>
            <tr>
                <td ><%=i%></td>
                <td class="title">
                    <c:if test="${empty activity.activityName && status.index < 3 && page.page == 1}">
                        <i class="recommend-icon"></i>
                    </c:if>
                    <a target="_blank" title="${avct.activityName}" href="${path}/frontActivity/frontActivityDetail.do?activityId=${avct.activityId}">${avct.activityName}</a>
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
                                <c:if test="${avct.activityIsReservation == 2}" >
                                    自由入座
                                </c:if>
                                <c:if test="${avct.activityIsReservation == 1}" >
                                    不可预订
                                </c:if>

                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td >
                        <c:if test="${not empty avct.userAccount}">
                            ${avct.userAccount}

                        </c:if>
                        <c:if test="${ empty avct.userAccount}">
                            未知操作人
                        </c:if>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${empty activity.activityName && status.index < 3 && page.page == 1}">
                                <c:if test="${not empty avct.activityRecommendTime}">
                                    <% if(webCancleRecommendActivityButton){
                                      %>
                                    <a target="main" onclick="cancelRecommendActivity('${avct.activityId}')">取消置顶</a>
                                    <%
                                        }
                                    %>
                                </c:if>
                                <c:if test="${empty avct.activityRecommendTime}">
                                    <% if(webHomeNavigationRecommendActivityButton){
                                    %>
                                    <a target="main" onclick="recommendActivity('${avct.activityId}')">置顶</a>
                                    <%
                                        }
                                    %>
                                </c:if>
                            </c:when>
                            <c:otherwise>
                                <% if(webHomeNavigationRecommendActivityButton){
                                %>
                                <a target="main" onclick="recommendActivity('${avct.activityId}')">置顶</a>
                                <%
                                    }
                                %>
                            </c:otherwise>
                        </c:choose>
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
    <input type="hidden" id="page" name="page" value="${page.page}" />
    <div id="kkpager" ></div>
    </c:if>
</div>
</form>
</body>
</html>
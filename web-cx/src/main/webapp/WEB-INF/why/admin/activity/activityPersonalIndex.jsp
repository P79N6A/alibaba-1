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
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    <!--文本编辑框 end-->
    <!-- dialog start -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    <script type="text/javascript">
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


        $(function(){
            seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
                window.dialog = dialog;
            });
            $("input").focus();

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
                    /*  seatInfo: $("#seatInfo").val()*/
                }, // 给 iframe 的数据
                onclose: function () {
                    if(this.returnValue){
                        //console.log(this.returnValue);
                       location.reload();
                    } location.reload();
                    //dialog.focus();
                }
            }).showModal();
            return false;
        }


        function changeLeftMenu(){
            $("#left",parent.document.body).attr("src","${path}/activityLeft.do")
        }

        //提交表单
        function formSub(formName){
            var  activityName=$('#activityName').val();
            if(activityName!=undefined&&activityName=='输入活动名称'){
                $('#activityName').val("");
            }

            //场馆
            $('#venueId').val($('#loc_venue').val());
            $('#venueType').val($('#loc_category').val());
            $('#venueArea').val($('#loc_area').val());
            $(formName).submit();
        }

        //全选或全不选
        function selectActivityIds(){
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
        function publishActivity(activityId,activityState){
            var html = "确定通过该活动审核吗?<br>确定通过后您可以在活动列表中查看该活动";
            if (activityState == 7) {
                refuseUserActivity(activityId);
            } else{
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
    </script>
</head>
<body>
<form id="activityForm" action="${path}/activity/activityPersonalIndex.do" method="post">
    <input type="hidden" name="activityIsDel" value="${activity.activityIsDel}"/>
<div class="site">
    <em>您现在所在的位置：</em>活动管理

          &gt; 个人活动审核

    <c:if test="${not empty activity}">

            <c:if test="${activity.activityState == 3}">
                &gt; 待审核
            </c:if>
            <c:if test="${activity.activityState == 1}">
                &gt;  草稿箱
            </c:if>
            <c:if test="${activity.activityState == 5}">
                &gt;  回收站
            </c:if>

    </c:if>
</div>
<div class="search">
    <div class="search-box">
        <i></i><input type="text" id="activityName" name="activityName" value="${activity.activityName}" data-val="输入活动名称" class="input-text"/>
    </div>
    <%--<div class="select-box w135">--%>
        <%--<input type="hidden" id="activityArea" name="activityArea" value="${activity.activityArea}"/>--%>
        <%--<div id="areaDiv" class="select-text" data-value="">全部区县</div>--%>
        <%--<ul class="select-option" id="areaUl">--%>
        <%--</ul>--%>
    <%--</div>--%>
    <input type="hidden" value="${activity.activityPersonal}" name="activityPersonal" id="activityPersonal"/>
    <div class="select-box w135">
        <input type="hidden" value="${activity.activityState}" name="activityState" id="activityState"/>

        <div class="select-text" data-value="">
            <c:choose>
                <c:when test="${activity.activityState == 3}">
                    待审核
                </c:when>
                <c:when test="${activity.activityState == 7}">
                    未通过
                </c:when>
            </c:choose>
        </div>
        <ul class="select-option">
            <li data-option="3">待审核</li>
            <li data-option="7">未通过</li>
        </ul>
    </div>
  <%--  <div class="select-box w110">
        <input type="hidden" value="${activity.activityIsFree}" name="activityIsFree" id="activityIsFree" />
        <div class="select-text"  data-value="">
            <c:choose>
                <c:when test="${activity.activityIsFree == 1}">
                    免费
                </c:when>
                <c:when test="${activity.activityIsFree == 2}">
                    收费
                </c:when>
                <c:otherwise>
                    全部
                </c:otherwise>
            </c:choose>
        </div>
        <ul class="select-option">
            <li data-option="">全部</li>
            <li data-option="1">免费</li>
            <li data-option="2" >收费</li>
        </ul>
    </div>--%>
    <div class="select-btn">
        <input type="button" onclick="$('#page').val(1);formSub('#activityForm');" value="搜索"/>
    </div>
    <div class="search-total">
        <%--待审核活动<span class="red">20</span>条--%>
    </div>
</div>
<div class="main-content">
    <table width="100%">
        <thead>
        <tr>
            <%--<th >全选<input type="checkbox" name="checkAll" id="checkAll" onclick="selectActivityIds()" /> </th>--%>
            <th >ID</th>
            <th class="title">活动名称</th>
           <%-- <th class="venue">所属场馆</th>--%>
            <th>所属区县</th>
            <th>选座方式</th>
            <%--<th>费用</th>--%>
            <th >发布者昵称</th>
                <th>提交时间</th>
                <c:if test="${activity.activityState == 7}">
                    <th >最新操作人</th>
                    <th>操作时间</th>
                </c:if>

            <%--<th >状态</th>--%>
            <th>管理</th>
        </tr>
        </thead>

        <tbody>
        <%int i=0;%>
        <c:forEach items="${activityList}" var="avct">
            <%i++;%>
            <tr>
                <%--<td><input type="checkbox"  name="activityId"  value="${avct.activityId}" /></td>--%>
                <td ><%=i%></td>
                <td class="title">
                    <c:if test="${avct.activityRecommend == 'Y'}">
                        <i class="recommend-icon"></i>
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

<%--                <td class="venue">
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
                </td>--%>
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
                    <%--<td>
                        <c:choose>
                            <c:when test="${avct.activityIsFree ==1}">
                                免费
                            </c:when>
                            <c:otherwise>
                                收费
                            </c:otherwise>
                        </c:choose>
                    </td>--%>
                <td >
                    <c:if test="${not empty avct.userAccount}">
                        ${avct.userAccount}

                    </c:if>
                    <c:if test="${ empty avct.userAccount}">
                        未知申请人
                    </c:if>
                </td>
                    <td>
                        <c:if test="${not empty avct.activityCreateTime}">
                            <fmt:formatDate value="${avct.activityCreateTime}" pattern="yyyy-MM-dd HH:mm" />
                        </c:if>
                    </td>
                    <c:if test="${activity.activityState == 7}">
                        <td >
                            <c:if test="${not empty avct.activityUpdateUser}">
                                ${avct.activityUpdateUser}

                            </c:if>
                            <c:if test="${ empty avct.activityUpdateUser}">

                            </c:if>
                        </td>
                        <td >
                            <c:if test="${not empty avct.activityUpdateTime}">
                                <fmt:formatDate value="${avct.activityUpdateTime}" pattern="yyyy-MM-dd HH:mm" />
                            </c:if>

                        </td>
                    </c:if>
                <%--<td >--%>
                    <%--<c:if test="${not empty avct.activityState}">--%>
                        <%--<c:if test="${avct.activityState==1}">--%>
                            <%--草稿--%>
                        <%--</c:if>--%>
                        <%--<c:if test="${avct.activityState==2}">--%>
                            <%--已审核--%>
                        <%--</c:if>--%>
                        <%--<c:if test="${avct.activityState==3}">--%>
                            <%--审核中--%>
                        <%--</c:if>--%>
                        <%--<c:if test="${avct.activityState==4}">--%>
                            <%--退回--%>
                        <%--</c:if>--%>
                        <%--<c:if test="${avct.activityState==5}">--%>
                            <%--回收站--%>
                        <%--</c:if>--%>
                        <%--<c:if test="${avct.activityState==6}">--%>
                            <%--已发布--%>
                        <%--</c:if>--%>
                    <%--</c:if>--%>

                <%--</td>--%>
                    <td  >
                    <c:if test="${not empty avct.activityState && avct.activityState!=5 && avct.activityState!=6}">
						<c:if test="${avct.sysNo=='0'||empty avct.sysNo}">
	                        <%if(activityPreEditDraftButton){%>
	                            <%if(activityDraftButton){%>  <%}%><a  target="main" href="${path}/activity/preEditActivityPersonal.do?id=${avct.activityId}">查看</a>
	                        <%}%>
						</c:if>
                        <%if(activityPublishDraftButton){%>
                        <c:if test="${avct.activityState == 3 || avct.activityState == 7}" >   <%if(activityPreEditDraftButton){%> | <%}%> <a href="javascript:;" onclick="publishActivity('${avct.activityId}',6)">通过</a> </c:if>
                        <%}%>
                        <%if(activityPublishDraftButton){%>
                        <c:if test="${avct.activityState == 3}" > <%if(activityPreEditDraftButton){%> | <%}%><a href="javascript:;" onclick="publishActivity('${avct.activityId}',7)">不通过</a></c:if>
                        <%}%>
                    </c:if>
                    </td>
            </tr>
        </c:forEach>
        <c:if test="${empty activityList}">
            <tr>
                <c:if test="${activity.activityState == 7}">
                    <td colspan="9"><h4 style="color:#DC590C">暂无数据!</h4></td>
                </c:if>
                <c:if test="${activity.activityState == 3}">
                    <td colspan="7"><h4 style="color:#DC590C">暂无数据!</h4></td>
                </c:if>
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
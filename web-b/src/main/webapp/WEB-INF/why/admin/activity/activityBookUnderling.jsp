<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>活动列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <script type="text/javascript">
        $(function(){
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

        //提交表单
        function formSub(formName){
            var  activityName=$('#activityName').val();
            if(activityName!=undefined&&activityName=='输入活动名称关键词'){
                $('#activityName').val("");
            }

            $(formName).submit();
        }

    </script>
</head>
<body>
<form id="activityForm" action="${path}/activity/activityBookUnderling.do" method="post">
<input type="hidden" name="activityIsDel" value="${activity.activityIsDel}"/>
    <input type="hidden" name="activityState" value="${activity.activityState}"/>
<div class="site">
    <em>您现在所在的位置：</em>活动管理&gt; 活动列表&gt; 下属活动
</div>
<div class="search">
    <div class="search-box">
        <input type="text" id="activityName" name="activityName" value="<c:choose><c:when test="${empty activity.activityName}">输入活动名称关键词</c:when><c:otherwise>${activity.activityName}</c:otherwise></c:choose>" data-val="输入活动名称关键词" class="input-text"/>
    </div>
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
            <th class="venue">所属场馆</th>
            <th>所属区县</th>
            <th>选座方式</th>
            <th>费用</th>
            <th >操作人</th>
            <th>操作时间</th>
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
                      <a target="_blank" title="${avct.activityName}" href="${path}/frontActivity/frontActivityDetail.do?activityId=${avct.activityId}">
                          <c:set var="activityName" value="${avct.activityName}"/>
                          <c:out value="${fn:substring(activityName,0,19)}"/>
                          <c:if test="${fn:length(activityName) > 19}">...</c:if>
                      </a>
                    </c:if>
                </td>

                <td class="venue">
                    <c:if test="${not empty avct.venueName}">
                    	<a href="${path}/frontVenue/venueDetail.do?venueId=${avct.venueId}" target="_blank">${avct.venueName}</a>
                    </c:if>
                    <c:if test="${ empty avct.venueName}">
                        未知场馆
                    </c:if>
                </td>
                    <td>${fn:split(avct.activityArea, ",")[1]}</td>
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
                                    不可预定
                                </c:if>

                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${avct.activityIsFree ==1}">
                                免费
                            </c:when>
                            <c:otherwise>
                                收费
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
                <td >
                    <c:if test="${not empty avct.activityUpdateTime}">
                        <fmt:formatDate value="${avct.activityUpdateTime}" pattern="yyyy-MM-dd HH:mm" />
                    </c:if>

                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty activityList}">
            <tr>
                <td colspan="9"><h4 style="color:#DC590C">暂无数据!</h4></td>
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
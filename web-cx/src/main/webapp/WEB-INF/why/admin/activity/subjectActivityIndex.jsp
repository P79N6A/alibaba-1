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

        //提交表单
        function formSub(formName){
            var  activityName=$('#activityName').val();
            if(activityName!=undefined&&activityName=='输入活动名称'){
                $('#activityName').val("");
            }
            $(formName).submit();
        }
        //保存活动信息
        function checkSubjectActivityData(type){
            var activityId = $('input[type="checkbox"]:checked').val();
            var activityName = $('input[type="checkbox"]:checked').next().val();
            if(type==1){
                $("#activityName", parent.document).val(activityName);
                $("#referId", parent.document).val(activityId);
            }
                $("body",parent.document).find('#DialogBySHFLayer,#DialogBySHF').remove();
        }
        //复选框只能单选
        $(document).ready(function(){
            $('.main-content').find('input[type=checkbox]').bind('click', function(){
                $('.main-content').find('input[type=checkbox]').not(this).attr("checked", false);
            });
            //分页
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
    </script>
    <style type="text/css">
        .ui-dialog-title,.ui-dialog-content textarea{ font-family: Microsoft YaHei;}
        .ui-dialog-header{ border-color: #9b9b9b;}
        .ui-dialog-close{ display: none;}
        .ui-dialog-title{ color: #F23330; font-size: 20px; text-align: center;}
        .ui-dialog-content{}
        .ui-dialog-body{}
    </style>
</head>
<body>
<form id="activityForm" action="${path}/activity/subjectActivityIndex.do?activityState=6" method="post">
    <div class="subject-content" style="padding-bottom: 62px;">
    <input type="hidden" name="referId" value="${referId}"/>
<div class="search">
    <div class="search-box">
        <i></i><input type="text" id="activityName" name="activityName" value="${activity.activityName}" data-val="输入活动名称" class="input-text"/>
    </div>

    <div class="select-btn">
        <input type="button" onclick="$('#page').val(1);formSub('#activityForm');" value="搜索"/>
    </div>
    <%--<div class="search-total">--%>
        <%--<div class="select-btn">--%>
            <%--<input type="button" onclick="exportExcel();" value="导出"/>--%>
        <%--</div>--%>
        <%--&lt;%&ndash;待审核活动<span class="red">20</span>条&ndash;%&gt;--%>
    <%--</div>--%>
</div>
<div class="main-content">
    <table width="100%">
        <thead>
        <tr>
            <th >单选</th>
            <th >ID</th>
            <th class="title">活动名称</th>
            <th>所属区县</th>
            <th>发布者</th>
            <th>发布时间</th>
            <th>最新操作人</th>
            <th>最新操作时间</th>
        </tr>
        </thead>

        <tbody>
        <%int i=0;%>
        <c:forEach items="${activityList}" var="avct">
            <%i++;%>
            <tr>
                <td>
                    <input type="checkbox" <c:if test="${avct.activityId eq referId}">checked="checked" </c:if>  value="${avct.activityId}"/>
                    <input type="hidden"  value="${avct.activityName}" />
                </td>
                <td ><%=i%></td>
                <td class="title">
                    <c:if test="${avct.activityPersonal == 1}">
                        <img src="${path}/STATIC/image/personal-icon.png" />
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
                <td >
                    <c:if test="${not empty avct.userAccount}">
                        ${avct.userAccount}
                    </c:if>
                    <c:if test="${ empty avct.userAccount}">
                        	未知操作人
                    </c:if>
                </td>
                <td >
                    <c:if test="${not empty avct.activityCreateTime}">
                        <fmt:formatDate value="${avct.activityCreateTime}" pattern="yyyy-MM-dd HH:mm" />
                    </c:if>

                </td>
                <td >
                    <c:if test="${not empty avct.userAccount2}">
                        ${avct.userAccount2}
                    </c:if>
                    <c:if test="${ empty avct.userAccount2}">
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
                <td colspan="8"><h4 style="color:#DC590C">暂无数据!</h4></td>
            </tr>
        </c:if>
        </tbody>
    </table>

    <input type="hidden" id="page" name="page" value="${page.page}" />
    <div id="kkpager"></div>
</div>
</div>
    <div class="form-table form_table_btn" style="position: fixed; bottom: 0; width: 100%; padding: 10px 0; background: #ffffff;">
        <input class="btn-publish" type="button" onclick="checkSubjectActivityData(1)" value="确定"/>
        <input class="btn-save" type="button" onclick="checkSubjectActivityData(2)" value="取消"/>
    </div>
</form>
</body>
</html>
<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:setLocale value="zh_CN"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/html">
<head>
    <title>查看活动室</title>
    <%@include file="../../common/pageFrame.jsp"%>
    <script type="text/javascript" src="${path}/STATIC/js/getActivityRoomImg.js"></script>
</head>
<body class="rbody">
<!-- 正中间panel -->
<div id="content">
    <div class="content">
        <div class="con-box-blp">
            <h3>查看活动室</h3>
            <div class="con-box-tlp">
                <div class="form-box list-table_hds">
                    <table class="form-table">
                        <tbody>
                        <tr>
                            <td class="td-title "><span class="td-prompt"></span>活动室名称：</td>
                            <td class="td-input-one td-input-four">
                                <span class="td-prompt-one">${record.roomName}</span>
                            </td>
                        </tr>
                        <tr>
                            <td class="td-title"><span class="td-prompt"></span>所属场所：</td>
                            <td class="td-input-one" >
                                <span class="td-prompt-one">${cmsVenue.venueName}</span>
                            </td>
                        </tr>
                        <tr>
                            <td class="td-title">活动室图片：</td>
                            <td class="td-input-two td-input-four">
                                <div id="imgHeadPrev" style="width:100px; height:100px;position: relative; overflow: hidden;  float: left;">
                                <input type="hidden"  name="roomPicUrl" id="roomPicUrl" value="${record.roomPicUrl}">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="td-title"><span class="td-prompt"></span>容纳人数：</td>
                            <td class="td-input-one td-input-two" >
                                <span class="td-prompt-one">${record.roomCapacity}</span>
                            </td>
                        </tr>
                        <tr>
                            <td class="td-title-one">开放时间：</td>
                            <td class="yd_numlist" colspan="3">
                                <c:choose>
                                    <c:when test="${record.roomOpenPeriod1 == 1}">
                                        <label class="r_on">10:00-12:00</label>
                                    </c:when>
                                </c:choose>
                                <c:choose>
                                    <c:when test="${record.roomOpenPeriod2 == 1}">
                                        <label class="r_on">14:00-16:00</label>
                                    </c:when>
                                </c:choose>
                                <c:choose>
                                    <c:when test="${record.roomOpenPeriod3 == 1}">
                                        <label class="r_on">16:00-18:00</label>
                                    </c:when>
                                </c:choose>
                                <c:choose>
                                    <c:when test="${record.roomOpenPeriod4 == 1}">
                                        <label class="r_on">19:00-21:00</label>
                                    </c:when>
                                </c:choose>
                            </td>
                        </tr>
                        <tr>
                            <td class="td-title-one"></td>
                            <td class="yd_numlist" colspan="3">
                                <c:choose>
                                    <c:when test="${record.roomDayMonday == 1}">
                                        <label class="r_on">周一</label>
                                    </c:when>
                                </c:choose>
                                <c:choose>
                                    <c:when test="${record.roomDayTuesday == 1}">
                                        <label class="r_on">周二</label>
                                    </c:when>
                                </c:choose>
                                <c:choose>
                                    <c:when test="${record.roomDayWednesday == 1}">
                                        <label class="r_on">周三</label>
                                    </c:when>
                                </c:choose>
                                <c:choose>
                                    <c:when test="${record.roomDayThursday == 1}">
                                        <label class="r_on">周四</label>
                                    </c:when>
                                </c:choose>
                                <c:choose>
                                    <c:when test="${record.roomDayFriday == 1}">
                                        <label class="r_on">周五</label>
                                    </c:when>
                                </c:choose>
                                <c:choose>
                                    <c:when test="${record.roomDaySaturday == 1}">
                                        <label class="r_on">周六</label>
                                    </c:when>
                                </c:choose>
                                <c:choose>
                                    <c:when test="${record.roomDaySunday == 1}">
                                        <label class="r_on">周日</label>
                                    </c:when>
                                </c:choose>
                            </td>
                        </tr>
                        <tr>
                            <td class="td-title">收费标准：</td>
                            <td class="td-input-one td-input-two">
                                <span class="td-prompt-one">${record.roomFee}</span>
                            </td>
                        </tr>
                        <tr>
                            <td class="td-title-one">文字介绍：</td>
                            <td class="td-input-two td-input-five">
                                <span class="td-prompt-one">${record.roomRemark}</span>
                            </td>
                        </tr>
                        <tr class="submit-btn">
                            <td colspan="2">
                                <input type="button" value="返回" onclick="history.back(-1)"/>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>

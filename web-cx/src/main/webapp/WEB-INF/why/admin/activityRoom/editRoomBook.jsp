<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:setLocale value="zh_CN"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>编辑活动室预订--文化嘉定云</title>

    <%@include file="../../common/pageFrame.jsp"%>
    <script type="text/javascript">
        $(function() {
            selectModel();

            $(".btn-save").on("click", function(){
                history.back(-1);
            });
            $(".btn-publish").on("click", function(){
            	var venueId=$("#venueId").val();
                var checkResult = true;
                if($("#openPeriod").val() != undefined){
                    checkResult = checkOpenPeriod();
                }
                if(checkResult){
                    $.post("${path}/cmsRoomBook/editRoomBook.do", $("#editRoomBookForm").serialize(),function(data) {
                        if (data == "success") {
                            window.location.href = "${path}/cmsRoomBook/queryRoomBookList.do?roomId=${cmsRoomBook.roomId}&venueId="+venueId;
                        }else {
                            var html = "<h2>修改失败!</h2>";
                            dialogSaveDraft("提示", html, function(){
                                window.location.href = "${path}/cmsRoomBook/queryRoomBookList.do?roomId=${cmsRoomBook.roomId}&venueId="+venueId;
                            })
                        }
                    });
                }
            });

            $("#openPeriod").on("blur",function(){

                checkOpenPeriod();
            });
        });

        /**
         * 检查活动室开放时间
         * @returns true|false
         */
        function checkOpenPeriod(){
            var checkResult = true;
            var $this = $("#openPeriod");
            var timePeriod = $this.val();
            var timePeriodReg = /^\d{2}:\d{2}-\d{2}:\d{2}$/;
            if(timePeriod != ""){
                if(!timePeriodReg.test($.trim(timePeriod))){
                    $this.focus();
                    checkResult = false;
                }else {
                    var validResult = validateTime(timePeriod);
                    if(!validResult){
                        $this.focus();
                        checkResult = false;
                    }
                }
            }
            return checkResult;
        }

        function validateTime(value){
            var valArr = value.split("-");
            var startArr = valArr[0].split(":");
            var endArr = valArr[1].split(":");
            var startStr = valArr[0].replace(":", "");
            var endStr = valArr[1].replace(":", "");
            if(startArr[0] <= 23 && endArr[0] <=23 && startArr[1] <=59 && endArr[1] <= 59 && startStr < endStr){
                return true;
            }else{
                return false;
            }
        }
    </script>
</head>
<body>
<div class="site">
    <c:choose>
	<c:when test="${empty venueId }">
	 <em>您现在所在的位置：活动室管理 &gt;场次管理&gt;修改预订
	</c:when>
	<c:otherwise>
	 <em>您现在所在的位置：</em>场馆管理 &gt; 场馆信息管理&gt; 活动室管理 &gt;场次管理&gt;修改预订
	</c:otherwise>
</c:choose>
</div>
<div class="site-title">活动室发布</div>
<form method="post" id="editRoomBookForm">
<input name="venueId" id="venueId" type="hidden" value="${venueId}"/>
<input name="bookId" type="hidden" value="${cmsRoomBook.bookId}"/>
<div class="main-publish">
    <table width="100%" class="form-table">
        <tr>
            <td width="100" class="td-title">开放日期：</td>
            <td class="td-input">
                <fmt:formatDate value="${cmsRoomBook.curDate}" pattern="yyyy-MM-dd"></fmt:formatDate>
            </td>
        </tr>
        <tr>
            <td width="100" class="td-title">开放时间：</td>
            <td class="td-input">
                <input id="openPeriod" name="openPeriod" type="text" class="input-text w210" value="<c:choose><c:when test="${cmsRoomBook.openPeriod == 'OFF'}"></c:when><c:otherwise>${cmsRoomBook.openPeriod}</c:otherwise></c:choose>"/>
            </td>
        </tr>
        <tr>
            <td width="100" class="td-title">星期：</td>
            <td class="td-input">
                <c:choose>
                    <c:when test="${cmsRoomBook.dayOfWeek == 1}">星期一</c:when>
                    <c:when test="${cmsRoomBook.dayOfWeek == 2}">星期二</c:when>
                    <c:when test="${cmsRoomBook.dayOfWeek == 3}">星期三</c:when>
                    <c:when test="${cmsRoomBook.dayOfWeek == 4}">星期四</c:when>
                    <c:when test="${cmsRoomBook.dayOfWeek == 5}">星期五</c:when>
                    <c:when test="${cmsRoomBook.dayOfWeek == 6}">星期六</c:when>
                    <c:when test="${cmsRoomBook.dayOfWeek == 7}">星期日</c:when>
                    <c:otherwise>
                        无效星期
                    </c:otherwise>
                </c:choose>
            </td>
        </tr>
        <tr>
            <td width="100" class="td-title">状态：</td>
            <td class="td-input">
                <c:choose>
                    <c:when test="${cmsRoomBook.bookStatus == 1}"><span style="color: blue;">开放</span></c:when>
                    <c:when test="${cmsRoomBook.bookStatus == 2}"><span style="color: grey;">已预订</span></c:when>
                    <c:when test="${cmsRoomBook.bookStatus == 3}"><span style="color: red;">不开放</span></c:when>
                    <c:otherwise>
                        无效状态
                    </c:otherwise>
                </c:choose>
            </td>
        </tr>

        <tr>
            <td width="100" class="td-title">状态变更：</td>
            <td class="td-select td-select-time">
                <div class="select-box w140">
                    <input type="hidden" id="changedStatus" name="changedStatus" value="${cmsRoomBook.bookStatus}"/>
                    <div class="select-text" data-value="">
                        <c:choose>
                            <c:when test="${cmsRoomBook.bookStatus == 1}">开放</c:when>
                            <c:when test="${cmsRoomBook.bookStatus == 2}">已预订</c:when>
                            <c:when test="${cmsRoomBook.bookStatus == 3}">不开放</c:when>
                            <c:otherwise>
                                请选择状态
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <ul class="select-option" id="bookStatusUl">
                        <li data-option="1">开放</li>
                        <li data-option="3">不开放</li>
                    </ul>
                </div>
            </td>
        </tr>

        <c:if test="${not empty cmsRoomOrder and cmsRoomOrder.bookStatus ==1}">
            <tr>
                <td width="100" class="td-title">预订团体：</td>
                <td class="td-input">
                        ${cmsRoomOrder.tuserTeamName}
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title">预订号码：</td>
                <td class="td-input">
                    ${cmsRoomOrder.userTel}
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title">订单号：</td>
                <td class="td-input">
                    ${cmsRoomOrder.orderNo}
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title">下单时间：</td>
                <td class="td-input">
                    <fmt:formatDate value="${cmsRoomOrder.orderCreateTime}" pattern="yyyy-MM-dd HH:mm"></fmt:formatDate>
                </td>
            </tr>
        </c:if>

        <tr>
            <td width="100" class="td-title"></td>
            <td class="td-btn">
                <input class="btn-save" type="button" value="返回"/>
                <input class="btn-publish" type="button" value="保存修改"/>
            </td>
        </tr>
    </table>
</div>
</form>

</body>
</html>
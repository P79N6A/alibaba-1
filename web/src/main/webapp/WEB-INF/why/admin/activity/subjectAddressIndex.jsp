<%@ page language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>活动列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <%@include file="/WEB-INF/why/common/limit.jsp" %>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>

    <script type="text/javascript">
        seajs.config({
            alias: {
                "jquery": "jquery-1.10.2.js"
            }
        });
        seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
            window.dialog = dialog;
        });

        window.console = window.console || {
                    log: function () {

                    }
                }
        function addAddress() {
            dialog({
                url: '${path}/sysUserAddress/addAdd.do',
                title: '添加地址',
                width: 700,
                height: 700,
                fixed: true
            }).showModal();
            return false;
        }

        //保存活动信息
        function checkSubjectActivityData(type) {
            var addressId = $('input[type="checkbox"]:checked').val();
            var activityAddress = $('input[type="checkbox"]:checked').next().val();
            var activitySite = $('input[type="checkbox"]:checked').next().next().val();
            if (type == 1) {
                $("#referId", parent.document).val(addressId);
                $("#activityAddress", parent.document).val(activityAddress);
                $("#activitySite", parent.document).val(activitySite);

            }
            $("body", parent.document).find('#DialogBySHFLayer,#DialogBySHF').remove();
        }
        function defaultAddress(addressId) {
            $.post("${path}/sysUserAddress/editUserDefaultAddress.do", {addressId: addressId}, function (data) {
                if (data=="success") {
                    window.location.href = "${path}/activity/subjectAddressIndex.do";
                }
            }, "json");
        }
        function deleteUserDefaultAddress(addressId) {
            $.post("${path}/sysUserAddress/deleteUserDefaultAddress.do", {addressId: addressId}, function (data) {
                if (data=="success") {
                    window.location.href = "${path}/activity/subjectAddressIndex.do";
                }
            }, "json");
        }
        function editAddress(addressId) {
            dialog({
                url: '${path}/sysUserAddress/editAdd.do?addressId='+addressId,
                title: '添加地址',
                width: 700,
                height: 700,
                fixed: true
            }).showModal();
            return false;
        }
        //复选框只能单选
        $(document).ready(function () {
            $('.main-content').find('input[type=checkbox]').bind('click', function () {
                $('.main-content').find('input[type=checkbox]').not(this).attr("checked", false);
            });
        });
    </script>
</head>
<body>
<div class="subject-content" style="padding-bottom: 62px;">
    <input type="hidden" name="addressId" value="${addressId}"/>
    <div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th>单选</th>
                <th>ID</th>
                <th>地址</th>
                <%--<th>地点</th>--%>
                <th>管理</th>
            </tr>
            </thead>

            <tbody>
            <%int i = 0;%>
            <c:forEach items="${userAddresses}" var="address">
                <%i++;%>
                <tr>
                    <td>
                        <input type="checkbox"
                               <c:if test="${address.addressId eq addressId}">checked="checked" </c:if>
                               value="${address.addressId}"/>
                        <input type="hidden" value="${address.activityAddress}"/>
                        <input type="hidden" value="${address.activitySite}"/>

                    </td>
                    <td><%=i%>
                    </td>
                    <td>${address.activityAddress}<c:if test="${address.defaultAddress==1}"><a style="color: red">(默认)</a></c:if></td>
                    <%--<td>${address.activitySite}</td>--%>
                    <td>
                        <a onclick="editAddress('${address.addressId}')">地址编辑</a>|
                        <a onclick="defaultAddress('${address.addressId}')">设为默认地址</a>|
                        <a onclick="deleteUserDefaultAddress('${address.addressId}')">删除地址</a>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty userAddresses}">
                <tr>
                    <td colspan="8"><h4 style="color:#DC590C">暂无数据!</h4></td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>
<div class="form-table form_table_btn"
     style="position: fixed; bottom: 0; width: 100%; padding: 10px 0; background: #ffffff;">

    <input class="btn-publish" type="button" onclick="checkSubjectActivityData(1)" value="确定"/>
    <input class="btn-save" type="button" onclick="checkSubjectActivityData(2)" value="取消"/>
    <input class="btn-add-tag btn-publish" style="background-color: orangered;margin-left:120px" type="button" onclick="addAddress()" value="新增"/>
</div>
</body>
</html>
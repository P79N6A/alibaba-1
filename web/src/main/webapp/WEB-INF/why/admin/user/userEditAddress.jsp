<%@ page language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="s" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    <title>文化云后台管理系统</title>
    <script type="text/javascript">
        seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
            window.dialog = dialog;
        });

        window.console = window.console || {
                    log: function () {
                    }
                };
        //弹出座位编辑框
        seajs.config({
            alias: {
                "jquery": "jquery-1.10.2.js"
            }
        });


        seajs.use(['jquery'], function ($) {
            $(function () {
                //获取经纬度
                $('#getMapAddressPoint').on('click', function () {
                    var address = $('#activityAddress').val();
                    dialog({
                        url: '${path}/activity/queryMapAddressPoint.do?address=' + encodeURI(encodeURI(address)),
                        title: '获取经纬度',
                        width: 550,
                        fixed: true,
                        onclose: function () {
                            if (this.returnValue) {

                                $('#activityLon').val(this.returnValue.xPoint);
                                $("#activityLat").val(this.returnValue.yPoint);

                            }
                            //dialog.focus();
                        }
                    }).showModal();
                    return false;
                });

                /*点击确定按钮*/
                $(".btn-save").on("click", function () {

                    var address = $("#activityAddress").val();

                    if (address == "") {
                        dialogTypeSaveDraft("提示", "请填写活动地址", function () {
                        });
                        return;
                    }


//                    var site = $("#activitySite").val();
//                    if (!site) {
//                        dialogTypeSaveDraft("提示", "请填写活动地点", function () {
//                        });
//                        return;
//                    }
                    var lon = $("#activityLon").val();
                    if (lon=="X"||lon=="") {
                        dialogTypeSaveDraft("提示", "请选取坐标", function () {
                        });
                        return;
                    }

                    $.post("${path}/sysUserAddress/editAddress.do", $("#addAddress").serialize(),
                            function (data) {
                                if (data != null && data == 'success') {
                                    dialogTypeSaveDraft("提示", function () {
                                        parent.location.href = "${path}/activity/subjectAddressIndex.do";
                                    });
                                }

                            });
                });

                /*点击取消按钮，关闭登录框*/
                $(".btn-cancel").on("click", function () {
                    mdialog.close().remove();
                });

            });
        });
        function dialogTypeSaveDraft(title, content, fn) {
            var d = parent.dialog({
                width: 400,
                title: title,
                content: content,
                fixed: true,
                okValue: '确 定',
                ok: function () {
                    if (fn)  fn();
                }
            });
            d.showModal();
        }
    </script>
</head>
<body style="background: none;">
<form method="post" id="addAddress" >
    <div class="main-publish tag-adds">
        <input type="hidden" name="addressId" value="${address.addressId}"/>
        <table width="100%" class="form-table">
            <%--<tr>--%>
                <%--<td width="28%" class="td-title"><span class="red">*</span>活动地点：</td>--%>
                <%--<td class="td-input">--%>
                    <%--<input type="text" value="${address.activitySite}" id="activitySite" name="activitySite" placeholder="活动举办的场所名称，如：“中华艺术宫”"--%>
                           <%--class="input-text w510"/>--%>
                <%--</td>--%>
            <%--</tr>--%>
            <tr>
                <td width="28%" class="td-title"><span class="red">*</span>活动地址：</td>
                <td class="td-input">
                    <input type="text" value="${address.activityAddress}" id="activityAddress" name="activityAddress" placeholder="街道+门牌号，如：“广中西路777弄10号楼”"
                           class="input-text w510"/>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>地图坐标：</td>
                <td class="td-input td-coordinate" id="LonLabel">
                    <input type="text" value="${address.activityLon}" data-val="X" id="activityLon" name="activityLon" class="input-text w120"
                           onkeyup="if(isNaN(value))execCommand('undo')"
                           onafterpaste="if(isNaN(value))execCommand('undo')" readonly="readonly"/>
                    <span class="txt">X</span>
                    <input type="text" value="${address.activityLat}" data-val="Y" id="activityLat" name="activityLat" class="input-text w120"
                           onkeyup="if(isNaN(value))execCommand('undo')"
                           onafterpaste="if(isNaN(value))execCommand('undo')" readonly="readonly"/>
                    <span class="txt">Y</span>
                </td>
            </tr>
            <tr>
                <td width="28%" class="td-title"></td>
                <td class="td-input">
                    <input type="button" class="upload-btn" id="getMapAddressPoint" value="查询坐标"/>
                </td>
            </tr>
            <tr>
                <td class="td-btn" align="center" colspan="2">
                    <input class="btn-save" type="button" value="保存"/>
                    <input class="btn-cancel" type="button" value="取消"/>
                </td>
            </tr>
        </table>
    </div>
</form>
</body>
</html>

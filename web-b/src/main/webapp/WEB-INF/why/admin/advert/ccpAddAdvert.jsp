<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" ng-controller="advCon" ng-app="addAdv">
<head>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
</head>
<body style="background: none;" ng-init="advert.advertSort='${advert.advertSort}';advert.advertId='${advert.advertId}';advert.advertTitle='${advert.advertTitle}';advert.advertUrl='${advert.advertUrl}';advert.advertImgUrl='${advert.advertImgUrl}'">
<%--360下无法取得session--%>
<form id="addAdvert" method="post">
    <div class="main-publish tag-add">
    <input type="hidden" id="userCounty" value="${sessionScope.user.userCounty}"/>
        <table width="100%" class="form-table">
            <tr>
                <td width="28%" class="td-title">标题：</td>
                <td class="td-input">
                    <input type="text" ng-model="advert.advertTitle" placeholder="标题最多输入20个字" class="input-text w400"/>
                </td>
            </tr>
            <tr>
                <td width="28%" class="td-title">链接：</td>
                <td class="td-input">
                    <input type="text" ng-model="advert.advertUrl" placeholder="请输入跳转链接" class="input-text w400"/>
                </td>
            </tr>
            <tr>
                <td width="28%" class="td-title">上传图片：</td>
                <td class="td-upload">
                    <div class="img-adv">
                        <div id="advertImgShow" class="img" style="width: 600px;height:320px ">
                            <img ng-src="{{advertImgShow}}" style="width: 600px;height:320px ">
                        </div>

                    </div>
                    <div id="advertImgShow_1920_500_600_320" class="controls"
                         ng-model="advert.advertImgUrl"
                         snail-uploadify="{auto:false,buttonText:'图片上传'}">
                    </div>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"></td>
                <td class="td-upload">
                    <span>建议尺寸1920px*500px</span>
                </td>
            </tr>
            <tr>
                <td class="td-btn" align="center" colspan="2">
                    <input class="btn-save" type="button" ng-click="saveInfo()" value="保存"/>
                    <input class="btn-cancel" type="button" value="取消"/>
                </td>
            </tr>
        </table>
    </div>
    <input type="hidden" value="" id="siteId" name="siteId"/>
</form>
<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
<script type="text/javascript">
    var app = angular.module("addAdv", []);
    app.controller("advCon", function ($scope, $http) {
        $scope.advert = {
            "advertTitle": "",
            "advertUrl": "",
            "advertImgUrl": "${advert.advertImgUrl}",
            "advertSort": 0,
            "advertLink": 1,
            "advertPostion": 1,
            "advertType": "A",
            "advertState": 1
        };
        $scope.advertImgShow = "";
        if ($scope.advert.advertImgUrl) {
            $scope.advertImgShow = getIndexImgUrl(getImgUrl($scope.advert.advertImgUrl), "_1920_500");
        }
        /* if ('${advert.advertImgUrl}'!='') {
            $scope.advertImgShow = getIndexImgUrl(getImgUrl('${advert.advertImgUrl}'), "_1200_400");
        } */
        $scope.$watch("advert.advertImgUrl", function (value) {
           /* if (value) {
                $scope.advertImgShow = getIndexImgUrl(getImgUrl(value), "_1200_400");
            } */
        }, true);
        $scope.saveInfo = function () {
            if (!$scope.advert.advertTitle) {
                dialogAlert("提示", "请填写标题");
                return
            }
            if (!$scope.advert.advertImgUrl) {
                dialogAlert("提示", "请上传图片");
                return
            }
            $http({
                method: "POST",
                url: "../ccpAdvert/addAdvert.do",
                data: $.param($scope.advert),
                headers: {"Content-Type": "application/x-www-form-urlencoded"}
            }).success(function (data) {
                switch (data) {
                    case("success"):
                        dialogAlert("系统提示", "保存成功", function () {
                            parent.location.href = "../ccpAdvert/advertIndex.do";
                            dialog.close().remove();
                        });
                        break;
                    case("noLogin"):
                        dialogAlert("系统提示", "请登陆后再进行操作", function () {
                            parent.location.href = "../admin.do";
                            dialog.close().remove();
                        });
                        break;
                    case("failure"):
                        dialogAlert("系统提示", "服务器异常", function () {
                            parent.location.href = "../ccpAdvert/advertIndex.do"
                            dialog.close().remove();
                        });
                        break;
                    default:
                        dialogAlert("系统提示", "保存发生错误，请查看数据是否完整", function () {
                            parent.location.href = "../ccpAdvert/advertIndex.do"
                            dialog.close().remove();
                        });
                        break
                }
            })
        };
    });


    seajs.config({
        alias: {
            "jquery": "jquery-1.10.2.js"
        }
    });

    seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
        window.dialog = dialog;
    });


    seajs.use(['jquery'], function ($) {
        $(function () {

            var dialog = parent.dialog.get(window);
            mdialog = dialog;

            var tips = "添加成功";
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
<script type="text/javascript" src="${path}/STATIC/js/admin/uploadify.js?version=20160302"></script>

</body>
</html>




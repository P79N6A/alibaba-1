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
<body style="background: none;" ng-init="advert.advertSort='${advert.advertSort}';
advert.advertId='${advert.advertId}';
advert.advertTitle='${advert.advertTitle}';
advert.advertLink='${advert.advertLink}';
advert.advertLinkType='${advert.advertLinkType}';
advert.advertUrl='${advert.advertUrl}';
advert.advertImgUrl='${advert.advertImgUrl}';
advert.advertPostion='${advert.advertPostion}';
advert.advertType='${advert.advertType}'">
<form id="addAdvert" method="post">
    <div class="main-publish tag-add">
    <input type="hidden" id="userCounty" value="${sessionScope.user.userCounty}"/>
        <table width="100%" class="form-table">
            <tr>
                <td width="28%" class="td-title">热门词汇：</td>
                <td class="td-input">
                    <div class="editor-box">
                        <textarea type="text" rows="8" ng-model="advert.advertUrl" placeholder=""
                                  class="textareaBox"/></textarea>
                    </div>
                    <span class="upload-tip">（英文逗号","分隔，每个热门词汇最多五个字）</span>
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
            "advertImgUrl": "",
            "advertSort": 0,
            "advertLink": 1,
            "advertLinkType": "1",
            "advertPostion": 1,
            "advertType": "A",
            "advertState": 1
        };
        $scope.saveInfo = function () {
            if (!$scope.advert.advertUrl) {
                dialogAlert("提示", "请填写热门词汇");
                return
            } else {
                var word = $scope.advert.advertUrl.split(",");
                for (var i = 0; i < word.length; i++) {
                    if (word[i].length>5) {
                        dialogAlert("提示", "热门词汇不要超过5个字，“"+word[i]+"“——已超标");
                        return
                    }
                }
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
                            parent.location.href = "../ccpAdvert/appHotWordIndex.do";
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
                            parent.location.href = "../ccpAdvert/appHotWordIndex.do";
                            dialog.close().remove();
                        });
                        break;
                    default:
                        dialogAlert("系统提示", "保存发生错误，请查看数据是否完整", function () {
                            parent.location.href = "../ccpAdvert/appHotWordIndex.do";
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




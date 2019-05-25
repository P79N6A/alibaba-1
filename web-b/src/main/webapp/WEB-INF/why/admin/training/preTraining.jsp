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
<body style="background: none;"
      ng-init="training.trainingId='${training.trainingId}';
      training.trainingTitle='${training.trainingTitle}';
      training.trainingSubtitle='${training.trainingSubtitle}';
      training.trainingImgUrl='${training.trainingImgUrl}';
      training.trainingIntroduce='${training.trainingIntroduce}';
      training.speakerName='${training.speakerName}';
      training.speakerImgUrl='${training.speakerImgUrl}';
      training.speakerSubtitle='${training.speakerSubtitle}';
      training.speakerIntroduce='${training.speakerIntroduce}';
      training.trainingVideoUrl='${training.trainingVideoUrl}'">
<%--360下无法取得session--%>
<form id="addTraining" method="post">
    <div class="main-publish tag-add">
    <input type="hidden" id="userCounty" value="${sessionScope.user.userCounty}"/>
        <table width="100%" class="form-table">
            <tr>
                <td width="28%" class="td-title">标题：</td>
                <td class="td-input">
                    <input type="text" ng-model="training.trainingTitle" class="input-text w400"/>
                </td>
            </tr>
            <tr>
                <td width="28%" class="td-title">副标题：</td>
                <td class="td-input">
                    <input type="text" ng-model="training.trainingSubtitle" class="input-text w400"/>
                </td>
            </tr>
            <tr>
                <td width="28%" class="td-title">视频链接：</td>
                <td class="td-input">
                    <input type="text" ng-model="training.trainingVideoUrl" placeholder="请输入视频链接"
                           class="input-text w400"/>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title">培训简介：</td>
                <td class="td-input">
                    <div class="editor-box">
                        <textarea ng-model="training.trainingIntroduce" rows="4" class="textareaBox" maxlength="500"
                                  style="width: 500px;resize: none"></textarea>
                    </div>
                </td>
            </tr>
            <tr>
                <td width="28%" class="td-title">上传视频封面图片：</td>
                <td class="td-upload">
                    <div class="img-adv" style="width: 150px;height:100px ">
                        <div id="trainingImgUrlShow" class="img" style="width: 150px;height:100px ">
                            <img ng-src="{{trainingImgUrlShow}}" style="width: 150px;height:100px ">
                        </div>
                    </div>
                    <div id="advertImgShow_750_500_150_100" class="controls"
                         ng-model="training.trainingImgUrl"
                         snail-uploadify="{auto:false,buttonText:'图片上传'}">
                    </div>
                </td>
            </tr>
            <tr>
                <td width="28%" class="td-title">主讲人姓名：</td>
                <td class="td-input">
                    <input type="text" ng-model="training.speakerName" class="input-text w400"/>
                </td>
            </tr>
            <tr>
                <td width="28%" class="td-title">主讲人头衔：</td>
                <td class="td-input">
                    <input type="text" ng-model="training.speakerSubtitle" class="input-text w400"/>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title">主讲人简介：</td>
                <td class="td-input">
                    <div class="editor-box">
                        <textarea ng-model="training.speakerIntroduce" rows="3" class="textareaBox" maxlength="500"
                                  style="width: 500px;resize: none"></textarea>
                    </div>
                </td>
            </tr>
            <tr>
                <td width="28%" class="td-title">上传主讲人头像：</td>
                <td class="td-upload">
                    <div class="img-adv" style="width: 60px;height:60px ">
                        <div id="speakerImgUrlShow" class="img" style="width: 60px;height:60px ">
                            <img ng-src="{{speakerImgUrlShow}}" style="width: 60px;height:60px ">
                        </div>
                    </div>
                    <div id="speakerImgUrlShow_190_190_60_60" class="controls"
                         ng-model="training.speakerImgUrl"
                         snail-uploadify="{auto:false,buttonText:'图片上传'}">
                    </div>
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
        $scope.training = {
            "trainingId": null,
            "trainingTitle": null,
            "trainingSubtitle": null,
            "trainingImgUrl": null,
            "trainingVideoUrl": null,
            "trainingIntroduce": null,
            "speakerName": null,
            "speakerIntroduce": null,
            "speakerImgUrl": null,
            "speakerSubtitle": null
        };
        $scope.trainingImgUrlShow = "";
        $scope.speakerImgUrlShow = "";

        $scope.$watch("training.trainingImgUrl", function (value) {
            if (value) {
                $scope.trainingImgUrlShow = getIndexImgUrl(getImgUrl(value), "_750_500");
            }
        }, true);
        $scope.$watch("training.speakerImgUrl", function (value) {
            if (value) {
                $scope.speakerImgUrlShow = getIndexImgUrl(getImgUrl(value), "_190_190");
            }
        }, true);
        $scope.saveInfo = function () {
            if (!$scope.training.trainingTitle) {
                dialogAlert("提示", "请填写标题");
                return
            }
            $http({
                method: "POST",
                url: "../training/changeTraining.do",
                data: $.param($scope.training),
                headers: {"Content-Type": "application/x-www-form-urlencoded"}
            }).success(function (data) {
                switch (data.data) {
                    case("success"):
                        dialogAlert("系统提示", "保存成功", function () {
                            parent.location.href = "../training/trainingIndex.do";
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
                            parent.location.href = "../training/trainingIndex.do";
                            dialog.close().remove();
                        });
                        break;
                    default:
                        dialogAlert("系统提示", "保存发生错误，请查看数据是否完整", function () {
                            parent.location.href = "../training/trainingIndex.do";
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




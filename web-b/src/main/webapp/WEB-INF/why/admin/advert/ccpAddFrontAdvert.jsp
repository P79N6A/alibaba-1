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
      ng-init="advert.advertType='${advert.advertType}';adverts[0]='${list[0].advertUrl}';adverts[1]='${list[1].advertUrl}';adverts[2]='${list[2].advertUrl}';adverts[3]='${list[3].advertUrl}';adverts[4]='${list[4].advertUrl}';adverts[5]='${list[5].advertUrl}'">
<form id="addAdvert" method="post">
    <div class="main-publish tag-add">
    <input type="hidden" id="userCounty" value="${sessionScope.user.userCounty}"/>
        <table width="100%" class="form-table">
            <tr>
                <td width="28%" class="td-title">位置1：</td>
                <td class="td-input">
                    <input type="text" ng-model="adverts[0]" placeholder="请输入ID" class="input-text w400"/>
                </td>
            </tr>
            <tr>
                <td width="28%" class="td-title">位置2：</td>
                <td class="td-input">
                    <input type="text" ng-model="adverts[1]" placeholder="请输入ID" class="input-text w400"/>
                </td>
            </tr>
            <tr>
                <td width="28%" class="td-title">位置3：</td>
                <td class="td-input">
                    <input type="text" ng-model="adverts[2]" placeholder="请输入ID" class="input-text w400"/>
                </td>
            </tr>
            <tr>
                <td width="28%" class="td-title">位置4：</td>
                <td class="td-input">
                    <input type="text" ng-model="adverts[3]" placeholder="请输入ID" class="input-text w400"/>
                </td>
            </tr>
            <tr ng-show="sixShow1">
                <td width="28%" class="td-title">位置5：</td>
                <td class="td-input">
                    <input type="text" ng-model="adverts[4]" placeholder="请输入ID" class="input-text w400"/>
                </td>
            </tr>
            <tr ng-show="sixShow2">
                <td width="28%" class="td-title">位置6：</td>
                <td class="td-input">
                    <input type="text" ng-model="adverts[5]" placeholder="请输入ID" class="input-text w400"/>
                </td>
            </tr>
            <tr >
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
        $scope.advertType="";
        $scope.sixShow1=false;
        $scope.sixShow2=false;
        $scope.advert = {
            "advertTitle": "",
            "advertUrl": "",
            "advertImgUrl": "",
            "advertSort": "",
            "advertLink": 1,
            "advertPostion": 1,
            "advertType": "",
            "advertState": 1
        };
        $scope.adverts = [];
        $scope.$watch("advert.advertType", function (value) {
            if (value=="D" || value=="M") {
                $scope.sixShow1=true;
            }
            if (value=="K") {
                $scope.sixShow1=true;
                $scope.sixShow2=true;
            }
        }, true);
        $scope.saveInfo = function () {
            var len=$scope.adverts.length;
            /* if(len<4){
                dialogAlert("系统提示", "请完整填写位置", function () {
                });
                return
            } */
            
            $scope.advert.advertUrl="";
            for(var i=0;i<len;i++){
                if($scope.adverts[i].length!=32&&$scope.adverts[i].length!=0){
                    i++;
                    dialogAlert("系统提示", "请正确填写位置"+i, function () {
                    });
                    return
                }
				if($scope.adverts[i]!=""){
					$scope.advert.advertUrl+=$scope.adverts[i]+","
				}
            }
            $http({
                method: "POST",
                url: "../ccpAdvert/addAdvertList.do",
                data:$.param($scope.advert),
                headers: {"Content-Type": "application/x-www-form-urlencoded"}
            }).success(function (data) {
                switch (data) {
                    case("success"):
                        dialogAlert("系统提示", "保存成功", function () {
                            parent.location.href = "../ccpAdvert/frontAdvertIndex.do";
                            parent.dialog.get(window).close().remove();
                        });
                        break;
                    case("noLogin"):
                        dialogAlert("系统提示", "请登陆后再进行操作", function () {
                            parent.location.href = "../admin.do";
                            parent.dialog.get(window).close().remove();
                        });
                        break;
                    case("failure"):
                        dialogAlert("系统提示", "服务器异常", function () {
                            parent.location.href = "../ccpAdvert/frontAdvertIndex.do";
                            parent.dialog.get(window).close().remove();
                        });
                        break;
                    default:
                        dialogAlert("系统提示", "保存发生错误，请查看数据是否完整", function () {
                            parent.location.href = "../ccpAdvert/frontAdvertIndex.do";
                            parent.dialog.get(window).close().remove();
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




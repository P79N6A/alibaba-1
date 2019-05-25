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
                <td width="28%" class="td-title">标题：</td>
                <td class="td-input">
                    <input type="text" ng-model="advert.advertTitle" placeholder="标题最多输入20个字" class="input-text w400"/>
                </td>
            </tr>
            <tr ng-hide="advImgShow">
                <td width="28%" class="td-title">上传图片：</td>
                <td class="td-upload">
                    <div class="img-adv" style="width: ${width}px;height:${height}px ">
                        <div id="advertImgShow" class="img" style="width: ${width}px;height:${height}px ">
                            <img ng-src="{{advertImgShow}}" style="width: ${width}px;height:${height}px ">
                        </div>

                    </div>
                    <div id="advertImgShow${imgSize}${imgSize}" class="controls"
                         ng-model="advert.advertImgUrl"
                         snail-uploadify="{auto:false,buttonText:'图片上传'}">
                    </div>
                </td>
            </tr>
            <tr ng-hide="typeB">
                <td width="100" class="td-title"><span class="red">*</span></td>
                <td placeholder="发布者" class="td-input">
                    <label><input type="radio" ng-model="advert.advertLink" value="1"/><em>外链</em></label>
                    <label><input type="radio" ng-model="advert.advertLink" value="0"/><em>内链</em></label>
                    <select ng-model="advert.advertLinkType" ng-show="advLinkShow">
                        <option value=0>活动列表</option>
                        <option value=1>活动详情</option>
                        <option value=2>场馆列表</option>
                        <option value=3>场馆详情</option>
                        <option ng-hide="typeThree" value=4>日历广告位</option>
                        <option ng-hide="typeThree" value=5>活动标签</option>
                    </select>
                </td>
            </tr>
            <tr ng-show="typeB">
                <td width="100" class="td-title"><span class="red">*</span></td>
                <td placeholder="发布者" class="td-input">
                    <label><input type="radio" ng-model="advert.advertLink" value="1"/><em>外链</em></label>
                    <label><input type="radio" ng-model="advert.advertLink" value="0"/><em>内链</em></label>
                    <select ng-model="venueType" ng-show="advLinkShow" id="advertLinkType">
                        <option ng-repeat="(q, w) in venueTypes" value="{{q}}">{{w}}</option>
                    </select>
                    <select ng-model="venueTag" ng-show="advLinkShow">
                        <option ng-repeat="(q, w) in venueTags" value="{{q}}">{{w}}</option>
                    </select>
                    <label ng-show="advLinkShow"><input type="radio" ng-model="advertLink"
                                                        value="1"/><em>类型</em></label>
                    <label ng-show="advLinkShow"><input type="radio" ng-model="advertLink"
                                                        value="0"/><em>标签</em></label>
                </td>
            </tr>
            <tr ng-show="advertUrlShow">
                <td width="28%" class="td-title">链接：</td>
                <td class="td-input">
                    <input type="text" ng-model="advert.advertUrl" placeholder="请输入相应类型的链接" class="input-text w400"/>
                </td>
            </tr>
            <tr ng-show="advertTagShow">
                <td width="28%" class="td-title">标签类型：</td>
                <td class="td-input">
                    <select ng-model="activityType">
                        <option ng-repeat="(q, w) in activityTypes" value="{{q}}">{{w}}</option>
                    </select>
                    <select ng-model="activityTag">
                        <option ng-repeat="(q, w) in activityTags" value="{{q}}">{{w}}</option>
                    </select>
                    <label><input type="radio" ng-model="advertLink" value="1"/><em>类型</em></label>
                    <label><input type="radio" ng-model="advertLink" value="0"/><em>标签</em></label>
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
            "advertId": '${advert.advertId}',
            "advertTitle": '${advert.advertTitle}',
            "advertUrl": '${advert.advertUrl}',
            "advertImgUrl": '${advert.advertImgUrl}',
            "advertSort": '${advert.advertSort}',
            "advertLink": '${advert.advertLink}',
            "advertLinkType": '${advert.advertLinkType}',
            "advertPostion": '${advert.advertPostion}',
            "advertType": '${advert.advertType}',
            "advertState": 1
        };
        $scope.advertImgShow = "";
        if( $scope.advert.advertImgUrl){
        	$scope.advertImgShow =getIndexImgUrl(getImgUrl($scope.advert.advertImgUrl), "${imgSize}");
        }
        $scope.advLinkShow = false;
        $scope.width = ${width};
        $scope.advImgShow = false;
        $scope.jumpUrl = "";
        $scope.typeB = false;
        $scope.typeThree = false;
        $scope.advertUrlShow = true;
        $scope.advertTagShow = false;
        $scope.advertLink = 1;
        $scope.venueType = "";
        $scope.venueTag = "";
        $scope.venueTypes = {};
        $scope.venueTags = {};
        $scope.activityType = "";
        $scope.activityTag = "";
        $scope.activityTypes = {};
        $scope.activityTags = {};
        $scope.$watch("advert.advertImgUrl", function (value) {
         //   if (value) {
          //      $scope.advertImgShow = getIndexImgUrl(getImgUrl(value), "${imgSize}");
         //   }
        }, true);
        $scope.$watch("advert.advertLink", function (value) {
            if (value == 0) {
                $scope.advLinkShow = true;
                $scope.advertUrlShow = true;
            } else {
                $scope.advLinkShow = false;
                $scope.advertTagShow = false;
                $scope.advert.advertLinkType = '';
            }
        }, true);
        $scope.venueTagSelected = function () {
            $http({
                method: "POST",
                url: "../tag/getChildTagByType.do?code=VENUE_TYPE",
                headers: {"Content-Type": "application/x-www-form-urlencoded"}
            }).success(function (data) {
                var list = eval(data);
                for (var i = 0; i < list.length; i++) {
                    var obj = list[i];
                    $scope.venueTypes [obj.tagId] = obj.tagName;
                }
            })
        };
        $scope.$watch("venueType", function (Id) {
            $scope.activityTags = {};
            $.post("../tag/getCommonTag.do?type=1", function (data) {
                var list = eval(data);
                for (var i = 0; i < list.length; i++) {
                    var obj = list[i];
                    $scope.venueTags [obj.tagSubId] = obj.tagName;
                    if (obj.tagSubId == $scope.advert.advertUrl) {
                        $scope.venueTag = $scope.advert.advertUrl;
                        $scope.advertLink = 0;
                    }
                }
            });
            $.post("../tag/getTagSubByTagId.do?tagId=" + Id, function (data) {
                var list = eval(data);
                for (var i = 0; i < list.length; i++) {
                    var obj = list[i];
                    $scope.venueTags [obj.tagSubId] = obj.tagName;
                    if (obj.tagSubId == $scope.advert.advertUrl) {
                        $scope.venueTag = $scope.advert.advertUrl;
                        $scope.advertLink = 0;
                    }
                }
                $scope.$apply()
            });
        }, true);
        $scope.activityTagSelected = function () {
            $.post("../tag/getChildTagByType.do?code=ACTIVITY_TYPE", function (data) {
                var list = eval(data);
                $scope.activityTypes = {};
                for (var i = 0; i < list.length; i++) {
                    var obj = list[i];
                    $scope.activityTypes [obj.tagId] = obj.tagName;
                    if (obj.tagId == $scope.advert.advertUrl) {
                        $scope.activityType = $scope.advert.advertUrl;
                    }
                }
                $scope.$apply()
            });
        };
        $scope.$watch("activityType", function (Id) {
            $scope.activityTags = {};
            $.post("../tag/getCommonTag.do?type=2", function (data) {
                var list = eval(data);
                for (var i = 0; i < list.length; i++) {
                    var obj = list[i];
                    $scope.activityTags [obj.tagSubId] = obj.tagName;
                    if (obj.tagSubId == $scope.advert.advertUrl) {
                        $scope.activityTag = $scope.advert.advertUrl;
                        $scope.advertLink = 0;
                    }
                }
            });
            $.post("../tag/getTagSubByTagId.do?tagId=" + Id, function (data) {
                var list = eval(data);
                for (var i = 0; i < list.length; i++) {
                    var obj = list[i];
                    $scope.activityTags [obj.tagSubId] = obj.tagName;
                    if (obj.tagSubId == $scope.advert.advertUrl) {
                        $scope.activityTag = $scope.advert.advertUrl;
                        $scope.advertLink = 0;
                    }
                }
                $scope.$apply()
            });
        }, true);
        $scope.$watch("width", function (value) {
            if (value == 0 || !value) {
                $scope.advImgShow = true;
            } else {
                $scope.advImgShow = false;
            }
        }, true);
        $scope.$watch("advert.advertLinkType", function (value) {
            if ($scope.typeB) {
                $scope.advert.advertUrl = value;
            }
            switch (value) {
                case ('0'):
                    $scope.advertTagShow = false;
                    $scope.advertUrlShow = true;
                    break;
                case ('1'):
                    $scope.advertTagShow = false;
                    $scope.advertUrlShow = true;
                    break;
                case ('2'):
                    $scope.advertTagShow = false;
                    $scope.advertUrlShow = true;
                    break;
                case ('3'):
                    $scope.advertTagShow = false;
                    $scope.advertUrlShow = true;
                    break;
                case ('4'):
                    $scope.advertTagShow = false;
                    $scope.advertUrlShow = false;
                    break;
                case ('5'):
                    $scope.advertTagShow = true;
                    $scope.advertUrlShow = false;
                    $scope.activityTagSelected();
                    break;
                default:
                    $scope.advertUrlShow = true;
            }
        }, true);
        $scope.$watch("advert.advertPostion", function (value) {
            switch (value) {
                case("2"):
                    $scope.jumpUrl = "../ccpAdvert/appFrontAdvertIndex.do";
                    break;
                case("3"):
                    $scope.typeThree = true;
                    $scope.jumpUrl = "../ccpAdvert/appSpaceAdvertIndex.do";
                    if ($scope.advert.advertType == "B") {
                        $scope.typeB = true;
                        $scope.venueTagSelected();
                    }
                    break;
                default:
                    break
            }
        }, true);
        $scope.saveInfo = function () {
            if ($scope.advert.advertLinkType == 5) {
                if ($scope.advertLink == 1) {
                    $scope.advert.advertUrl = $scope.activityType;
                }
                else {
                    $scope.advert.advertUrl = $scope.activityTag;
                }
            }

            if (!$scope.advert.advertTitle) {
                dialogAlert("提示", "请填写标题");
                return
            }
            if (!$scope.advert.advertUrl && $scope.advert.advertLinkType != 4) {
                dialogAlert("提示", "请填写链接");
                return
            }
            if (!$scope.advert.advertImgUrl && !$scope.advImgShow) {
                dialogAlert("提示", "请上传图片");
                return
            }
            if (!$scope.advert.advertLink) {
                dialogAlert("提示", "请选择链接方式");
                return
            } else if (!$scope.advert.advertLinkType && $scope.advert.advertLink == 0 && !$scope.typeB) {
                dialogAlert("提示", "请选择内链方式");
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
                            parent.location.href = $scope.jumpUrl;
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
                            parent.location.href = $scope.jumpUrl;
                            dialog.close().remove();
                        });
                        break;
                    default:
                        dialogAlert("系统提示", "保存发生错误，请查看数据是否完整", function () {
                            parent.location.href = $scope.jumpUrl;
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




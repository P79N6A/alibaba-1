var app = angular.module("addAdv", []);
app.controller("advCon", function ($scope, $http) {
    $scope.advFrom = {
        advertId: "",
        advertName: "",
        advertDate: "",
        advLink: "1",
        advLinkShow: true,
        advLinkType: "1",
        advUrl: "",
        advImgUrl: "",
        advImgUrlShow: "",
    };
    $scope.saveInfo = function () {
        if (!$scope.advFrom.advImgUrl) {
            dialogAlert("提示", "请上传封面图片");
            return
        }
        if (!$scope.advFrom.advertDate) {
            dialogAlert("提示", "请选择日期");
            return
        }
        if (!$scope.advFrom.advLink) {
            dialogAlert("提示", "请选择链接");
            return
        }
        if (!$scope.advFrom.advLinkType && $scope.advFrom.advLink == "0") {
            dialogAlert("提示", "请选择链接");
            return
        }
        if (!$scope.advFrom.advUrl) {
            dialogAlert("提示", "请填写URL/ID/关键字");
            return
        }
        $http({
            method: "POST",
            url: "../advertCalendar/addAdvert.do",
            data: $.param($scope.advFrom),
            headers: {"Content-Type": "application/x-www-form-urlencoded"}
        }).success(function (data) {
            switch (data) {
                case ("success"):
                    dialogAlert("系统提示", "保存成功", function () {
                        window.location.href = "../advertCalendar/appAdvertCalendarIndex.do"
                    });
                    break;
                case ("noLogin"):
                    dialogAlert("系统提示", "请登陆后再进行操作", function () {
                        window.location.href = "../admin.do"
                    });
                    break;
                case ("failure"):
                    dialogAlert("系统提示", "服务器异常", function () {
                    });
                    break;
                case ("repeat"):
                    dialogAlert("系统提示", "此日期已存在", function () {
                    });
                    break;
                default:
                    dialogAlert("系统提示", "保存发生错误，请查看数据是否完整", function () {
                    });
                    break
            }
        })
    };
    $scope.$watch('advFrom.advertId', function (value) {
        if (value) {
            $http({
                method: "POST",
                url: "../advertCalendar/getAdvert.do",
                data: $.param({advertId: value}),
                headers: {"Content-Type": "application/x-www-form-urlencoded"}
            }).success(function (data) {
                $scope.advFrom.advertName = data.advertName.toString();
                $scope.advFrom.advertDate = data.advertDate.toString();
                $scope.advFrom.advImgUrl = data.advImgUrl.toString();
                $scope.advFrom.advUrl = data.advUrl.toString();
                $scope.advFrom.advLink = data.advLink.toString();
                $scope.advFrom.advLinkType = data.advLinkType.toString();
                console.log(data);
            })
        }
    });
    $scope.$watch('advFrom.advLinkType', function (data) {
    });
    $scope.$watch('advFrom.advLink', function (data) {
        if (data=="0") {
            $scope.advFrom.advLinkShow=true;
        } else {
            $scope.advFrom.advLinkShow=false;
        }
    });
    $scope.$watch('advFrom.advImgUrl', function (value) {
        if (value) {
            $scope.advFrom.advImgUrlShow = getIndexImgUrl(getImgUrl(value), "_750_380");
        }
    });

});

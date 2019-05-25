var app = angular.module('alteSta', []);
app.controller('alteCon', function ($scope, $http) {
    $scope.activityName = "";
    $scope.startTime = "";
    $scope.endTime = "";
    $scope.resData = "";
    $scope.type = "";
    $scope.$watch('activityName', function (data) {
        $scope.getData();
    });
    $scope.selTim = function (selTim) {
        $('#selTim').find('a').removeClass('cur');
        $('#' + selTim).addClass('cur');
        $scope.startTime = "";
        $scope.endTime = "";
        switch (selTim) {
            case "day":
                $scope.dateType = 1;
                break;
            case "week":
                $scope.dateType = 2;
                break;
            case "month":
                $scope.dateType = 3;
                break;
            case "time":
                $scope.startTime = $('#startTime').val();
                $scope.endTime = $('#endTime').val();
                break;
            default:
                $scope.dateType = 1;
                break;
        }
        $scope.getData();
    };

    $scope.getData = function () {
        if ($scope.activityName) {
            $http.get('../activityStatistics/selectStatReactByAdmin.do', {
                    params: {
                        cname: $scope.activityName,
                        cType: $scope.type,
                        startTime: $scope.startTime,
                        endTime: $scope.endTime
                    }
                })
                .success(function (data) {
                    $scope.resData = data;
                    $(".start-btn").on("click", function () {
                        WdatePicker({
                            el: 'startDateHidden',
                            dateFmt: 'yyyy-MM-dd',
                            doubleCalendar: true,
                            minDate: '',
                            maxDate: '#F{$dp.$D(\'endDateHidden\')}',
                            position: {left: -224, top: 8},
                            isShowClear: false,
                            isShowOK: true,
                            isShowToday: false,
                            onpicked: pickedStartFunc
                        })
                    })
                    $(".end-btn").on("click", function () {
                        WdatePicker({
                            el: 'endDateHidden',
                            dateFmt: 'yyyy-MM-dd',
                            doubleCalendar: true,
                            minDate: '#F{$dp.$D(\'startDateHidden\')}',
                            position: {left: -224, top: 8},
                            isShowClear: false,
                            isShowOK: true,
                            isShowToday: false,
                            onpicked: pickedendFunc
                        })
                    })
                })
        } else {
        }
    };
});

var appElement = document.querySelector('[ng-controller=alteCon]');
var $scope = angular.element(appElement).scope();
function pickedStartFunc() {
    $dp.$('startTime').value = $dp.cal.getDateStr('yyyy-MM-dd');
}
function pickedendFunc() {
    $dp.$('endTime').value = $dp.cal.getDateStr('yyyy-MM-dd');
}

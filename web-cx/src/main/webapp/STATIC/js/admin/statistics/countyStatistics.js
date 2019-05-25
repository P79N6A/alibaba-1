var app = angular.module('alteSta', []);
app.controller('alteCon', function ($scope, $http) {
  
    $scope.endTime = "";
    $scope.selMod = true;
    $scope.resData = "";
    $scope.resStatus = "";
    $scope.resMsg = "";
    $scope.$watch('area.venue', function (data) {
    	console.log("area.venue  has been watched .....");
        $scope.getData();
    });

    $scope.dateType = 1;
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
        
        $scope.seachName='正在查询 ...';
        $scope.getData();
    };

    $scope.getData = function () {
             $http.get('../countyStatistics/countyStatisticsDetail.do', {
                    params: {
                        dateType: $scope.dateType,
                        startTime: $scope.startTime,
                        endTime: $scope.endTime
                    }
                })
                .success(function (data) {
                	$scope.resStatus=data.status;
                    if(data && data.status=='ok'){
                    	$scope.resData = data.data;
                    	$scope.resMsg='';
                    }else{
                    	$scope.resMsg = data.msg;
                    }
                    $scope.seachName='搜索';
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

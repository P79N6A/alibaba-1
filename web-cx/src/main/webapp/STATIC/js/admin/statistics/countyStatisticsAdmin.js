var app = angular.module('alteSta', []);
app.controller('alteCon', function ($scope, $http) {
    $scope.area = {
        province: 45,
        city: 45,
        district: '0'
    };
    $scope.province = {
        上海: 45,
    };
    $scope.city = {
        上海: 45,
    }
    $scope.district = {
        请选择区县: '0',
        黄浦区: '黄浦区',
        徐汇区: '徐汇区',
        长宁区: '长宁区',
        静安区: '静安区',
        普陀区: '普陀区',
        闸北区: '闸北区',
        虹口区: '虹口区',
        杨浦区: '杨浦区',
        闵行区: '闵行区',
        宝山区: '宝山区',
        嘉定区: '嘉定区',
        浦东新区:'浦东新区',
        金山区: '金山区',
        松江区: '松江区',
        青浦区: '青浦区',
        奉贤区: '奉贤区',
        崇明县: '崇明区'
    };
    $scope.type = "";
    $scope.startTime = "";
    $scope.endTime = "";
    $scope.selMod = true;
    $scope.resData = "";
    $scope.resStatus = "";
    $scope.resMsg = "";
    $scope.timmerFlg = "";
    $scope.$watch('area.district', function (data) {
        $scope.selMod = true;
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
        if ($scope.area.district) {
            $http.get('../countyStatistics/countyStatisticsDetailByAdmin.do', {
                    params: {
                        carea: encodeURI($scope.area.district),
                       /* dateType: $scope.dateType,
                        clevel: $scope.level,
                        cType: $scope.type,
                        vname: $scope.area.venue,*/
                        startTime: $scope.startTime,
                        endTime: $scope.endTime
                    }
                })
                .success(function (data) {
                     $scope.seachName='搜索';
                	$scope.resStatus=data.status;
                    if(data && data.status=='ok'){
                    	$scope.resData = data.data;
                    	$scope.resMsg='';
                    }else{
                    	$scope.resMsg = data.msg;
                    }
                  
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
 $(function () {
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
	 
	 
	 
 });
var appElement = document.querySelector('[ng-controller=alteCon]');
var $scope = angular.element(appElement).scope();
function pickedStartFunc() {
    $dp.$('startTime').value = $dp.cal.getDateStr('yyyy-MM-dd');
}
function pickedendFunc() {
    $dp.$('endTime').value = $dp.cal.getDateStr('yyyy-MM-dd');
}

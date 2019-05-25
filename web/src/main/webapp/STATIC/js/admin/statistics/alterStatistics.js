var app = angular.module('alteSta', []);
app.controller('alteCon', function ($scope, $http) {
    $scope.area = {
        province: 45,
        city: 45,
        district: '0',
        venue: '',
    };
    $scope.province = {
        上海: 45,
    };
    $scope.city = {
        上海: 45,
    }
    $scope.district = {
        全部区县: '0',
        黄浦区: '46,黄浦区',
        徐汇区: '48,徐汇区',
        长宁区: '49,长宁区',
        静安区: '50,静安区',
        普陀区: '51,普陀区',
        闸北区: '52,闸北区',
        虹口区: '53,虹口区',
        杨浦区: '54,杨浦区',
        闵行区: '55,闵行区',
        宝山区: '56,宝山区',
        嘉定区: '57,嘉定区',
        浦东新区: '58,浦东新区',
        金山区: '59,金山区',
        松江区: '60,松江区',
        青浦区: '61,青浦区',
        奉贤区: '63,奉贤区',
        崇明县: '64,崇明县',
    };
    $scope.venue = {};
    $scope.type = "";
    $scope.startTime = "";
    $scope.endTime = "";
    $scope.selMod = true;
    $scope.resData = "";
    $scope.$watch('area.venue', function (data) {
        if (data == '0' || data == '') {
            $scope.selMod = true;
            $scope.dateType = '';
            $scope.venue = {};
        } else {
            $scope.dateType = 1;
            $scope.selMod = false;
        }
        $scope.getData();

    });
    $scope.$watch('area.district', function (data) {
        $scope.selMod = true;
        if (data == '0') {
            $scope.dateType = '';
            $scope.area.venue = '';
        } else {
            if ($scope.area.venue=='0') {
                $scope.getData();
            } else {
                $scope.area.venue = '0'
            }
            $scope.area.venue = '0';
            $scope.selVen(data);
        }
    });

    $scope.selVen = function (data) {
        $scope.venue = {};
        $http.get('../venue/getVenueName.do', {params: {areaId: data}})
            .success(function (data) {
                var json = eval(data);
                var res = json.data;
                len = res.length;
                len++
                var name = " 全部场馆";
                $scope.venue[name] = '0';
                for (var i = 1; i < len; i++) {
                    $scope.venue[res[i - 1].text] = res[i - 1].text;
                }
            })
    };
    $scope.level = "";
    $scope.addLevel = function (levelId) {
        $scope.level = levelId;
        $('#tag').find('a').removeClass('cur');
        if (levelId) {
            $('#' + levelId).addClass('cur');
        } else {
            $('#tagAll').addClass('cur');
        }
        $scope.getData();
    };


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
        $scope.getData();
    };

    $scope.getData = function () {
        if ($scope.area.district) {
            $http.get('../activityStatistics/selectStatReactByAdmin.do', {
                    params: {
                        carea: $scope.area.district,
                        dateType: $scope.dateType,
                        clevel: $scope.level,
                        cType: $scope.type,
                        vname: $scope.area.venue,
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
//$(function () {
//    $(".start-btn").on("click", function () {
//        WdatePicker({
//            el: 'startDateHidden',
//            dateFmt: 'yyyy-MM-dd',
//            doubleCalendar: true,
//            minDate: '',
//            maxDate: '#F{$dp.$D(\'endDateHidden\')}',
//            position: {left: -224, top: 8},
//            isShowClear: false,
//            isShowOK: true,
//            isShowToday: false,
//            onpicked: pickedStartFunc
//        })
//    })
//    $(".end-btn").on("click", function () {
//        WdatePicker({
//            el: 'endDateHidden',
//            dateFmt: 'yyyy-MM-dd',
//            doubleCalendar: true,
//            minDate: '#F{$dp.$D(\'startDateHidden\')}',
//            position: {left: -224, top: 8},
//            isShowClear: false,
//            isShowOK: true,
//            isShowToday: false,
//            onpicked: pickedendFunc
//        })
//    })
//});
var appElement = document.querySelector('[ng-controller=alteCon]');
var $scope = angular.element(appElement).scope();
function pickedStartFunc() {
    $dp.$('startTime').value = $dp.cal.getDateStr('yyyy-MM-dd');
}
function pickedendFunc() {
    $dp.$('endTime').value = $dp.cal.getDateStr('yyyy-MM-dd');
}

var app = angular.module('alteSta', []);
app.controller('alteCon', function ($scope, $http) {
  
    $scope.endTime = "";
    $scope.selMod = true;
    $scope.resData = "";
    $scope.resStatus = "";
    $scope.resMsg = "";
    $scope.$watch('area.venue', function (data) {
    	console.log("area.venue  has been watched .....");
    	
    	$scope.resStatus='loading';
    	$scope.resMsg='正在加载......';
        $scope.getData();
    });

    

    $scope.getData = function () {
             $http.get('../countyStatistics/countyRoomStatisticsDetail.do', {
                    params: {
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

app.directive("mapAddress", function () {
    return {
        require: "?ngModel", link: function (scope, element, attrs, ngModel) {
            if (!ngModel) {
                return
            }
            element.val(ngModel.$viewValue);
            element.bind('click', function () {
                dialog({
                    url: '${path}/activity/queryMapAddressPoint.do?address='+encodeURI(encodeURI(address)),
                    title: '获取经纬度',
                    width: 700,
                    fixed: true,
                    onclose: function () {
                        if(this.returnValue){
                            $('#activityLon').val(this.returnValue.xPoint);
                            $("#activityLat").val(this.returnValue.yPoint);
                        }
                    }
                }).showModal();
            });
        }
    }
});
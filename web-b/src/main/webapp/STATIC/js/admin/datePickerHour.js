app.directive("datePickerHour", function () {
    return {
        restrict: 'A',
        require: '?ngModel',
        scope: {
        },
        link: function (scope, element, attr, ngModel) {

            element.val(ngModel.$viewValue);

            function onpicking(dp) {
                var date = dp.cal.getNewDateStr();
                scope.$apply(function () {
                    ngModel.$setViewValue(date);
                });
            }
            element.bind('click', function () {
                WdatePicker({
                    el: 'datePicker',
                    dateFmt: 'yyyy-MM-dd HH:mm:ss',
                    doubleCalendar: true,
                    position: {left: -224, top: 8},
                    isShowClear: false,
                    isShowOK: true,
                    isShowToday: false,
                    onpicking: onpicking
                })
            });
        }
    };
});
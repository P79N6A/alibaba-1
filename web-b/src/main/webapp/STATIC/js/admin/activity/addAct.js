var app = angular.module("addAct", []);
app.controller("ActCon", function ($scope, $http, $timeout) {
    $scope.activity = {
        "eventIds": "",
        "activityTime": "",
        "activityState": "",
        "activityId": "",
        "activityNotice": "",
        "activityName": "",
        "activityIconUrl": "",
        "activityIconUrlShow": "../STATIC/image/defaultImg.png",
        "venueId": "1",
        "createActivityCode": "0",
        "activityProvince":$("#userProvince").val(),
        "activityCity": "",
        "venueType": "1",
        "activityArea": "1",
        "activityType": "",
        "tagIds": "",
        "comTagIds": "",
        "activityHost": "",
        "activityOrganizer": "",
        "activityCoorganizer": "",
        "activityPerformed": "",
        "activitySpeaker": "",
        "activityTel": "",
        "activityStartTime": "",
        "activityEndTime": "",
        "activityTimeDes": "",
        "activitySite": "",
        "activityAddress": "",
        "addressId": "",
        "activityIsFree": "1",
        "activitySmsType": "0",
        "activityPrice": "",
        "priceDescribe": "",
        "priceType": "1",
        "activityPayPrice":"",
        "activityIsReservation": "1",
        "activityMemo": "",
        "ticketSettings": "",
        "number": "",
        "ticketNumber": "",
        "ticketCount": "",
        "count": "",
        "identityCard": "",
        "lowestCredit": "",
        "costCredit": "",
        "deductionCredit": "",
        "lowestCre": "",
        "costCre": "",
        "deductionCre": "",
        "spikeType": "",
        "singleEvent": "",
        "eventDate": "",
        "eventTime": "",
        "spikeTimes": "",
        "avaliableCount": "",
        "orderPrice": "",
        "seatIds": "2016-,2016",
        "assnId": "",
        "activityContent": "",
        "activityCustomInfo":"",
        "cancelEndTime":""
    };
    $scope.area = {
    	"priceType":"0",
    	"activityProvince":[{id: $("#userProvince").val(), name: $("#userProvince").val().split(",")[1]}],
        "activityCode": [{id: '1', name: '市级自建活动'}, {id: '0', name: $("#userCity").val().split(",")[1]}],
        "activityArea": [{id: '1', name: '所有区县'}],
        "venueType": [{id: '1', name: '场馆类型'}, {id: '2', name: '区级自建'}],
        "venueId": [{id: '1', name: '所有场馆'}],
        "activityLocation": {},
        "activityType": "",
        "activityTag": "",
        "activityIconUrlShow": "",
        "activityTypes": [],
        "activityAreashow": true,
        "venueTypeshow ": true,
        "venueIdshow": true,
        "startHour": 0,
        "startMinute": 0,
        "endHour": 0,
        "endMinute": 0,
        "addressId": "",
        "userIsManger":""
    };
    $scope.event = {
        "order": 0,
        "startTime": "",
        "endTime": "",
        "singleStartTime": "",
        "singleEndTime": "",
        "seatIds": "",
        "totalSeat": "",
        "startHour": 0, "startMinute": 0, "endHour": 0, "endMinute": 0,
        "eventTimes": [{startHour: 0, startMinute: 0, endHour: 0, endMinute: 0, number: 0}],
        "times": 1,
        "eventList": [],
        "spickList": [{
            availableCount: 0,
            spikeTime: '',
            orderPrice: '',
            num: 1
        }],
        "event": {
            eventDate: '',
            eventEndDate: '',
            eventTime: '',
            availableCount: 0,
            eventDateTime: '',
            spikeTime: '',
            orderPrice: '',
            seatIds: ''
        }
    };
    $scope.code = {
    	"activityPayPriceShow":false,
    	"payPriceShow": false,
        "spickShow": false,
        "spikeTypeShow": false,
        "singleEventShow": false,
        "smsTypeShow": false,
        "singleOrderShow": false,
        "DIYShow": false,
        "creShow": false,
        "payShow": false,
        "seatShow": false,
        "ticketShow": true,
        "saveShow": true,
        "addressShow": true,
        "addressSetShow": false,
        "noTicketShow": true,
        "cre": false,
        "userIsMangerDisable": false,
        "typeDisable": false,
        "btnpublishDisable": false,
        "triangle2":false,
        "triangle3":false,
        "cancelTime":false
    };
    $scope.$watch("activity.activityAddress", function (code) {
        if (code == ""&&$scope.activity.activityId=="") {
            $http({
                method: "GET",
                url: "../sysUserAddress/getAddress.do",
                headers: {"Content-Type": "application/x-www-form-urlencoded"}
            }).success(function (data) {
                $scope.code.addressShow = true;
                $scope.activity.activityAddress = data.activityAddress;
                $scope.activity.addressId = data.addressId;
                $("#referId").val(data.addressId);
            });
            if ($scope.activity.activitySite == "") {
                $scope.code.addressSetShow = true;//修改过，可以在前台显示备注的信息
            }
        }
    }, true);
    $scope.$watch("activity.createActivityCode", function (code) {
        switch (code) {
            case ('0'):
                $scope.area.activityAreashow = true;
                $scope.area.venueTypeshow = true;
                $scope.area.venueIdshow = true;
                $scope.loadAreaData(0, "../venue/getActivityArea.do");
                break;
            case ('1'):
                $scope.area.activityAreashow = false;
                $scope.area.venueTypeshow = false;
                $scope.area.venueIdshow = false;
                break;
            case ('2'):
                $scope.area.activityAreashow = true;
                $scope.area.venueTypeshow = true;
                $scope.area.venueIdshow = false;
                break;
            default:
        }
    }, true);
    $scope.$watch("activity.venueType", function (code) {
        if (code) {
            switch (code) {
                case ('2'):
                    $scope.area.activityAreashow = true;
                    $scope.area.venueTypeshow = true;
                    $scope.area.venueIdshow = false;
                    //$scope.loadAreaData(0, "../venue/getActivityArea.do");
                    break;
                default:
                    $scope.area.venueIdshow = true;
            }
        }

    }, true);
	$scope.$watch("activity.priceType", function (code) {
        $scope.area.priceType = code;
    }, true);
    $scope.$watch("activity.activityStartTime", function (code) {
        $scope.event.singleStartTime = code;
        $scope.event.startTime = code;
    }, true);
    $scope.$watch("activity.activityEndTime", function (code) {
        $scope.event.singleEndTime = code;
        $scope.event.endTime = code;
    }, true);
    $scope.$watch("event.singleStartTime", function (code) {
        if (code <= $scope.activity.activityStartTime) {
            $scope.event.singleStartTime = $scope.activity.activityStartTime;
        }
    }, true);
    $scope.$watch("event.singleEndTime", function (code) {
        if (code >= $scope.activity.activityEndTime) {
            $scope.event.singleEndTime = $scope.activity.activityEndTime;
        }
    }, true);
    $scope.$watch("event.startTime", function (code) {
        if (code <= $scope.activity.activityStartTime) {
            $scope.event.startTime = $scope.activity.activityStartTime;
        }
    }, true);
    $scope.$watch("event.endTime", function (code) {
        if (code >= $scope.activity.activityEndTime) {
            $scope.event.endTime = $scope.activity.activityEndTime;
        }
    }, true);
    $scope.$watch("activity.activityStartTime", function (code) {
        if ($scope.activity.activityEndTime != '') {
            if (code > $scope.activity.activityEndTime) {
                $scope.activity.activityStartTime = $scope.activity.activityEndTime;
                dialogAlert("系统提示", "您选择的开始日期大于结束日期", function () {
                });
            }
        }
    }, true);
    $scope.$watch("activity.activityEndTime", function (code) {
        if ($scope.activity.activityStartTime != '') {
            if (code < $scope.activity.activityStartTime) {
                $scope.activity.activityEndTime = $scope.activity.activityStartTime;
                dialogAlert("系统提示", "您选择的结束日期小于开始日期", function () {
                });
            }
        }
    }, true);
    $scope.$watch("activity.activityIsFree", function (code) {
        switch (code) {
            case ('1'):
                $scope.code.payShow = false;
            	$scope.code.payPriceShow = false;
                break;
            case ('2'):
            	$scope.code.payPriceShow = false;
                $scope.code.payShow = true;
                $scope.code.activityPayPriceShow = false;
                $scope.code.describeShow=true;//修改过，显示收费说明中的东西
                break;
            case ('3'):
            	$scope.code.describeShow=false;
            	$scope.code.payPriceShow = true;
            	$scope.code.payShow = true;
            	/*$scope.code.describeShow = false;
            	$scope.code.payShow = false;
            	$scope.code.payPriceShow = true;*/
                $scope.code.activityPayPriceShow=true;//修改过，显示收费说明中的东西
                
                break;
            default:
        }
    }, true);
    $scope.$watch("activity.activityIsReservation", function (code) {
        if($scope.code.ticketShow){
            switch (code) {
                case ('2'):
                    $scope.code.spikeTypeShow = false;
                    $scope.code.singleEventShow = true;
                    $scope.code.smsTypeShow = true;
                    $scope.code.singleOrderShow = true;
                    $scope.code.DIYShow = true;
                    $scope.code.creShow = true;
                    $scope.code.triangle2 = true;
                    $scope.code.triangle3 = false;
                    break;
                case ('3'):
                    $scope.code.spikeTypeShow = false;
                    $scope.code.singleEventShow = true;
                    $scope.code.smsTypeShow = true;
                    $scope.code.singleOrderShow = true;
                    $scope.code.DIYShow = true;
                    $scope.code.creShow = true;
                    $scope.code.triangle2 = false;
                    $scope.code.triangle3 = true;
                    break;
                default:
                	 $scope.code.spikeTypeShow = false;
	                $scope.code.singleEventShow = false;
	                $scope.code.smsTypeShow = false;
	                $scope.code.singleOrderShow = false;
	                $scope.code.spickShow = false;
	                $scope.code.DIYShow = false;
	                $scope.code.creShow = false;
	                $scope.code.triangle2 = false;
	                $scope.code.triangle3 = false;
	                break;
            }
        }

    }, true);
    $scope.$watch("code.DIY", function (code) {
        if (code == 1) {
            $scope.code.DIYDetail = true;
            $scope.activity.ticketSettings = "N"
        } else {
            $scope.code.DIYDetail = false;
            $scope.activity.ticketSettings = "Y"
        }
    }, true);
    $scope.$watch("code.cre", function (code) {
        switch (code) {
            case('0'):
                $scope.code.cre = false;
                $scope.activity.lowestCredit = 0;
                $scope.activity.costCredit = 0;
                $scope.activity.deductionCredit = 0;
                break;
            case('1'):
                $scope.code.cre = true;
                break;
            default:
        }
    }, true);
    
    $scope.$watch("code.cancelTime", function (code) {
        switch (code) {
            case('0'):
            	$scope.activity.cancelEndTime = "";
            	$scope.code.cancelTime = false;
                break;
            case('1'):
            	$scope.code.cancelTime = true;
                break;
            default:
        }
    }, true);
    $scope.$watch("activity.ticketSettings", function (code) {
        switch (code) {
            case('Y'):
                $scope.code.DIY = '0';
                break;
            case('N'):
                $scope.code.DIY = '1';
                break;
            default:
        }
    }, true);
    $scope.$watch("activity.activityId", function (activityId) {
    	
    	 var editor = CKEDITOR.replace('activityMemo');
    	
        $.post("../tag/getChildTagByType.do?code=ACTIVITY_TYPE", function (data) {
            var list = eval(data);
            $scope.area.activityType = {};
            for (var i = 0; i < list.length; i++) {
                var obj = list[i];
                $scope.area.activityType [obj.tagId] = obj.tagName;
            }
            $scope.$apply()
        });
        if (activityId) {
            $http({
                method: "POST",
                url: "../activity/getActivity.do",
                data: $.param({id: activityId}),
                headers: {"Content-Type": "application/x-www-form-urlencoded"}
            }).success(function (data) {
            	$scope.activity.priceType = data.priceType + '';
                $scope.activity.activityAddress = data.activityAddress;
                $scope.activity.activityArea = data.activityArea;
                $scope.activity.activityCity = data.activityCity;
                $scope.activity.activityDept = data.activityDept;
                $scope.activity.activityHost = data.activityHost;
                $scope.activity.activityIconUrl = data.activityIconUrl;
                $scope.activity.activityIsFree = data.activityIsFree.toString();
                $scope.activity.activitySmsType = data.activitySmsType!=null?data.activitySmsType.toString():"0";
                $scope.activity.activityIsReservation = data.activityIsReservation.toString();
                $scope.activity.activityLat = data.activityLat;
                $scope.activity.activityLon = data.activityLon;
                $scope.activity.activityLocation = data.activityLocation;
                $scope.activity.activityMemo = data.activityMemo;
                $scope.activity.activityName = data.activityName;
                $scope.activity.activityProvince = data.activityProvince;
                $scope.activity.activityPrice = data.activityPrice;
                $scope.activity.activityReservationCount = data.activityReservationCount;
                $scope.activity.activitySite = data.activitySite;
                $scope.activity.activityStartTime = data.activityStartTime;
                $scope.activity.activityEndTime = data.activityEndTime;
                $scope.activity.activityTel = data.activityTel;
                $scope.activity.activityType = data.activityType;
                $scope.activity.avaliableCount = data.avaliableCount;
                $scope.activity.ticketSettings = data.ticketSettings;
                $scope.activity.venueId = data.venueId;
                $scope.activity.venueType = data.venueType;
                $scope.activity.venueArea = data.venueArea;
                $scope.activity.activityId = data.activityId;
                $scope.activity.activityCoorganizer = data.activityCoorganizer;
                $scope.activity.activityPerformed = data.activityPerformed;
                $scope.activity.activitySpeaker = data.activitySpeaker;
                $scope.activity.activityOrganizer = data.activityOrganizer;
                $scope.activity.singleEvent = data.singleEvent;
                $scope.activity.lowestCredit = data.lowestCredit;
                $scope.activity.costCredit = data.costCredit;
                $scope.activity.deductionCredit = data.deductionCredit;
                $scope.activity.activityNotice = data.activityNotice;
                $scope.activity.identityCard = data.identityCard;
                $scope.activity.spikeType = data.spikeType;
                $scope.activity.tagIds = data.tagIds;
                $scope.activity.assnId = data.assnId;
                $scope.activity.priceDescribe = data.priceDescribe;
                $scope.activity.activityPayPrice= data.activityPayPrice;
                $scope.activity.activityTimeDes = data.activityTimeDes;
                $scope.activity.cancelEndTime = data.cancelEndTime;
                $("#assnId").val(data.assnId);
                CKEDITOR.instances.activityMemo.setData(data.activityMemo);
                
                if(data.activityIsReservation==1){
                	 var activitySupplementType=data.activitySupplementType;
                
                	 if(activitySupplementType==2){
                		 
                		 $scope.activity.activityIsReservation=4;
                	 }
                	 else if(activitySupplementType==3){
                		 $scope.activity.activityIsReservation=5;
                	 }
                }
                if(data.cancelEndTime ){
                	$scope.code.cancelTime = true;
                }
                
                if($scope.activity.lowestCredit!=null||$scope.activity.costCredit!=null||$scope.activity.deductionCredit!=null){
                    if($scope.activity.lowestCredit!=0||$scope.activity.costCredit!=0||$scope.activity.deductionCredit!=0){
                        $scope.code.cre='1';
                    }
                }
                if (data.spikeType == 1) {
                    $scope.code.spickShow = true;
                } else {
                    $scope.code.spickShow = false;
                }
                if (data.ticketNumber > 0) {
                    $scope.activity.ticketNumber = data.ticketNumber;
                }
                $scope.activity.ticketCount = data.ticketCount;
                $scope.code.addressShow = false;
                $scope.activity.createActivityCode = data.createActivityCode.toString();
                switch ($scope.activity.createActivityCode) {
                    case ('0'):
                        $scope.area.activityAreashow = true;
                        $scope.area.venueTypeshow = true;
                        $scope.area.venueIdshow = true;
                        //$scope.loadAreaData(0, "../venue/getActivityArea.do");
                        break;
                    case ('1'):
                        $scope.area.activityAreashow = false;
                        $scope.area.venueTypeshow = false;
                        $scope.area.venueIdshow = false;
                        break;
                    case ('2'):
                        $scope.area.activityAreashow = true;
                        $scope.area.venueTypeshow = true;
                        $scope.area.venueIdshow = false;
                        $scope.activity.createActivityCode = '0';
                        $scope.activity.venueType = '2';
                        break;
                    default:
                }
                if (data.venueType) {
                    $scope.activity.venueType = data.venueType.substring(0, 32);
                }
                $("#activityIconUrlShow").html(getImgHtml(getImgUrl(getIndexImgUrl(data.activityIconUrl, "_750_500")), 300, 200));
                function getImgHtml(imgUrl, width, height) {
                    if (imgUrl == "") {
                        return '<img src="../STATIC/image/defaultImg.png" />';
                    }
                    return '<img style="width:' + width + 'px; height:' + height + 'px;"  src="' + imgUrl + '" />';
                }

                if (data.activitySalesOnline == "N" && $scope.activity.activityIsReservation == '2') {
                    $scope.activity.activityIsReservation = '3';
                }
                if (data.activityState == 6) {
                    $scope.code.saveShow = false;
                }
                if ($scope.event.order == "1") {
                    $scope.code.ticketShow = false;
                    $scope.code.typeDisable = true;
                    $http({
                        method: "POST",
                        url: "../activity/getActivityEvent.do",
                        data: $.param({activityId: activityId}),
                        headers: {"Content-Type": "application/x-www-form-urlencoded"}
                    }).success(function (data) {
                        if (data.length > 0) {
                            $scope.area.startHour = parseInt(data[0].eventTime.substring(0, 2));
                            $scope.area.startMinute = parseInt(data[0].eventTime.substring(3, 5));
                            $scope.area.endHour = parseInt(data[0].eventTime.substring(6, 8));
                            $scope.area.endMinute = parseInt(data[0].eventTime.substring(9,11));
                        }
                    })
                } else {
                    if (data.activitySalesOnline == "Y") {
                        $scope.activity.activityIsReservation = '2';
                        $scope.code.seatShow = true;
                    }
                    if ($scope.activity.activityIsReservation == '1' ) {
                        $scope.code.spikeTypeShow = true;
                        $scope.code.singleEventShow = false;
                        $scope.code.smsTypeShow = false;
                        $scope.code.singleOrderShow = false;
                        $scope.code.DIYShow = false;
                        $scope.code.creShow = false;
                    } else {
                        $scope.code.noTicketShow = false;
                        $scope.code.spikeTypeShow = false;
                        $scope.code.singleEventShow = true;
                        $scope.code.smsTypeShow = true;
                        $scope.code.singleOrderShow = true;
                        $scope.code.DIYShow = true;
                        $scope.code.creShow = true;
                    }

                    $http({
                        method: "POST",
                        url: "../activity/getActivityEvent.do",
                        data: $.param({activityId: activityId}),
                        headers: {"Content-Type": "application/x-www-form-urlencoded"}
                    }).success(function (data) {
                        if ($scope.activity.singleEvent == "1") {
                            if (data.length > 0) {
                                $scope.loadSingleEvent(data);
                            }
                        } else {
                        	$scope.code.spikeTypeShow = false;
                            if (data.length > 0) {
                                $scope.loadEvent(data);
                            }
                        }
                        if (data.length > 0) {
                            $scope.area.startHour = parseInt(data[0].eventTime.substring(0, 2));
                            $scope.area.startMinute = parseInt(data[0].eventTime.substring(3, 5));
                            $scope.area.endHour = parseInt(data[0].eventTime.substring(6, 8));
                            $scope.area.endMinute = parseInt(data[0].eventTime.substring(9,11));
                        }
                    })
                }
                $timeout(function () {
                    CKEDITOR.instances.activityMemo.setData(data.activityMemo);
                    $scope.setActivityLocation($scope.activity.activityLocation);
                    $scope.setActType();
                    $scope.setActTag();
                }, 300, true);
                
                //自定义信息
                var customInfo = data.activityCustomInfo;
                if (customInfo != ""){
                	 customInfo = eval("("+customInfo+")");
                     for (var i=0;i<customInfo.length;i++){
                     	if (i==0){
                     		$('.customInfoTr').find("#title").val(customInfo[i].title);
                     		$('.customInfoTr').find("#type").val(customInfo[i].type);
                     		$('.customInfoTr').find("#desc").val(customInfo[i].desc);
                     	} else {
                     		addCustomInfoList();
                     		$('.customInfoTr:last').find("#title").val(customInfo[i].title);
                     		$('.customInfoTr:last').find("#type").val(customInfo[i].type);
                     		$('.customInfoTr:last').find("#desc").val(customInfo[i].desc);
                     	}
                     }
                }
            });
        }

    }, true);
    $scope.loadSingleEvent = function (event) {
        $scope.event.singleStartTime = event[0].eventDate;
        $scope.event.singleEndTime = event[0].eventDate;
        $scope.event.startHour = parseInt(event[0].eventTime.substring(0, 2));
        $scope.event.startMinute = parseInt(event[0].eventTime.substring(3, 5));
        $scope.event.endHour = parseInt(event[0].eventTime.substring(6, 8));
        $scope.event.endMinute = parseInt(event[0].eventTime.substring(9,11));
        $scope.event.totalSeat = parseInt(event[0].availableCount);
        var times = event.length;

        for (var i = 0; i < times; i++) {
            if (event[i].spikeTime) {
                var spick = {
                    availableCount: parseInt(event[i].availableCount),
                    spikeTime: event[i].spikeTime,
                    orderPrice: parseInt(event[i].orderPrice),
                    num: i + 1
                };
                $scope.activity.eventIds += event[i].eventId + ',';
                $scope.event.spickList.push(spick);
            } else {
                $scope.activity.eventIds += event[i].eventId + ',';
            }
        }

    };
    $scope.loadEvent = function (event) {
        $scope.event.singleStartTime = event[0].eventDate;
        $scope.event.singleEndTime = event[0].eventDate;
        $scope.event.startHour = parseInt(event[0].eventTime.substring(0, 2));
        $scope.event.startMinute = parseInt(event[0].eventTime.substring(3, 5));
        $scope.event.endHour = parseInt(event[0].eventTime.substring(6, 8));
        $scope.event.endMinute = parseInt(event[0].eventTime.substring(9,11));
        var times = event.length;
        for (var i = 0; i < times; i++) {
            var events = {
                eventDate: event[i].eventDate,
                eventEndDate: event[i].eventDate,
                eventTime: event[i].eventTime,
                availableCount: parseInt(event[i].availableCount),
                eventDateTime: event[i].eventDateTime,
                spikeTime: event[i].spikeTime,
                orderPrice: parseInt(event[i].orderPrice),
                seatIds: '',
                startHour: parseInt(event[i].eventTime.substring(0, 2)),
                startMinute: parseInt(event[i].eventTime.substring(3, 5)),
                endHour: parseInt(event[i].eventTime.substring(6, 8)),
                endMinute: parseInt(event[i].eventTime.substring(9,11)),
                num: i + 1
            };
            $scope.activity.eventIds += event[i].eventId + ',';
            $scope.event.eventList.push(events);
        }
    };
    $scope.$watch("activity.venueType", function (code) {
        $scope.loadAreaData(2, '../venue/getVenueName.do?areaId=' + $scope.activity.activityArea.split(',')[0] + "&venueType=" + code);
    }, true);
    $scope.$watch("activity.activityIsReservation", function (code) {
        switch (code) {
            case ('2'):
                $scope.code.seatShow = true;
                break;
            default:
                $scope.code.seatShow = false;
        }
    }, true);
    $scope.$watch("activity.spikeType", function (code) {
        if (code == '1') {
            $scope.code.spickShow = true;
        } else {
            $scope.code.spickShow = false;
        }
    }, true);

    $scope.$watch("event.eventTimes", function (code) {
        var len = code.length;
        for(var i = 0; i < len; i ++){
            if($scope.event.eventTimes[i].startHour > 23){
                $scope.event.eventTimes[i].startHour = 23
            }
            if($scope.event.eventTimes[i].startMinute > 59){
                $scope.event.eventTimes[i].startMinute = 59
            }
            if($scope.event.eventTimes[i].endHour > 23){
                $scope.event.eventTimes[i].endHour = 23
            }
            if($scope.event.eventTimes[i].endMinute > 59){
                $scope.event.eventTimes[i].endMinute = 59
            }
        }
    }, true);

    $scope.$watch("area.startHour", function (startHour) {
        if (startHour >= 0) {
            if (startHour > 23) {
                $scope.area.startHour = 23;
            }
            $scope.event.startHour = $scope.area.startHour;
        }
    }, true);
    $scope.$watch("area.endHour", function (endHour) {
        if (endHour >= 0) {
            if (endHour > 23) {
                $scope.area.endHour = 23;
            }
            $scope.event.endHour = $scope.area.endHour;
        }
    }, true);
    $scope.$watch("area.startMinute", function (startMinute) {
        if (startMinute >= 0) {
            if (startMinute > 59) {
                $scope.area.startMinute = 59;
            }
            $scope.event.startMinute = $scope.area.startMinute;
        }
    }, true);
    $scope.$watch("area.endMinute", function (endMinute) {
        if (endMinute >= 0) {
            if (endMinute > 59) {
                $scope.area.endMinute = 59;
            }
            $scope.event.endMinute = $scope.area.endMinute;
        }
    }, true);
    $scope.$watch("activity.singleEvent", function (code) {
        if (code == '1') {
            if ($scope.event.eventList) {
                $scope.event.eventList = [];
            }
            console.log($scope.code.singleEventShow)
            if($scope.code.singleEventShow && $scope.activity.singleEvent == "1"){
            	$scope.code.spikeTypeShow = true;
            }           
        } else {
            if ($scope.event.spickList) {
                $scope.event.spickList = [];
            }
            $scope.code.spikeTypeShow = false;
        }
    }, true);
    $scope.loadAreaData = function (type, url) {
        $.ajax({
            type: "get",
            url: url,
            dataType: "json",
            cache: false,//缓存不存在此页面
            async: true,//异步请求
            success: function (result) {
                var json = eval(result);
                var data = json.data;
                if ($scope.activity.activityId == "") {
                    switch (type) {
                        case (0):
                            $scope.area.activityArea = [{id: '1', name: '所有区县'}];
                            if ($scope.activity.activityArea != "2") {
                                $scope.activity.activityArea = "1";
                            }
                            $scope.activity.venueType = "1";
                            $scope.activity.venueId = "1";
                            break;
                        case (1):
                            $scope.area.venueType = [{id: '1', name: '场馆类型'}, {id: '2', name: '区级自建'}];
                            $scope.activity.venueType = "1";
                            $scope.activity.venueId = "1";
                            break;
                        case (2):
                            $scope.area.venueId = [{id: '1', name: '所有场馆'}];
                            $scope.activity.venueId = "1";
                            break;
                        default:
                    }
                }
                console.log(data);
                if (data != null) {
                    switch (type) {
                        case (0):
                            $scope.area.activityArea = [{id: '1', name: '所有区县'}];
                            break;
                        case (1):
                            $scope.area.venueType = [{id: '1', name: '场馆类型'}, {id: '2', name: '区级自建'}];
                            break;
                        case (2):
                            $scope.area.venueId = [{id: '1', name: '所有场馆'}];
                            break;
                        default:
                    }

                    /*if ($scope.area.userIsManger == "4") {
                        $scope.code.userIsMangerDisable = true;
                        var obj = data[0];
                        switch (type) {
                            case (0):
                                var area = {id: obj.id + "," + obj.text, name: obj.text};
                                $scope.area.activityArea.push(area);
                                $scope.activity.activityArea = obj.id + "," + obj.text;
                                break;
                            case (1):
                                var venueType = {id: obj.id, name: obj.text};
                                $scope.area.venueType.push(venueType);
                                $scope.activity.venueType = obj.id;
                                break;
                            case (2):
                                var venueId = {id: obj.id, name: obj.text};
                                $scope.area.venueId.push(venueId);
                                $scope.activity.venueId = obj.id;
                                break;
                            default:
                        }
                    } else {*/
                        for (var i = 0; i < data.length; i++) {
                            var obj = data[i];
                            switch (type) {
                                case (0):
                                   /* var area = {id: obj.id + "," + obj.text, name: obj.text};
                                    $scope.area.activityArea.push(area);
                                    break;*/
                                    var area = {id: obj.id + "," + obj.text, name: obj.text};

                                    $scope.area.activityArea.push(area);
                                    $scope.activity.activityArea = obj.id + "," + obj.text;
                                    break;

                                case (1):
                                    var venueType = {id: obj.id, name: obj.text};
                                    $scope.area.venueType.push(venueType);
                                    break;
                                case (2):
                                    var venueId = {id: obj.id, name: obj.text};
                                    $scope.area.venueId.push(venueId);
                                    break;
                                default:
                            }

                        }
                    //}
                }
                $scope.$apply()
            }
        });
    };
    $scope.loadSeat = function (event) {
        if ($scope.activity.venueId == null || $scope.activity.venueId == '1') {
            dialogAlert('系统提示', '请先选择场馆');
            return;
        }
        dialog({
            url: '../activity/queryVenueSeatTemplateList.do?venueId=' + $scope.activity.venueId,
            title: '设置座位模板',
            width: dialogWidth,
            fixed: false,
            data: {
                seatInfo: $("#seatInfo").val()
            }, // 给 iframe 的数据
            onclose: function () {
                if (this.returnValue) {
                    var list = eval(this.returnValue);
                    if ($scope.activity.singleEvent == "0") {
                        $scope.event.eventList[event - 1].seatIds = list.dataStr;
                        $scope.event.eventList[event - 1].availableCount = list.validCount;
                    } else {
                        $scope.event.seatIds = list.dataStr;
                        $scope.event.totalSeat = list.validCount;
                    }
                }
                $scope.$apply()
            }
        }).showModal();
        return false;
    };
    $scope.changeAddress = function () {
        $scope.code.addressShow = false;
        var addressId = $("#referId").val();
        var winW = parseInt($(window).width() * 0.8);
        var winH = parseInt($(window).height() * 0.95);
        $.DialogBySHF.Dialog({
            Width: winW,
            Height: winH,
            URL: '../activity/subjectAddressIndex.do?addressId=' + addressId
        });
    };
    $scope.changePerformed = function () {
        var assnId = $("#assnId").val();
        var winW = parseInt($(window).width() * 0.8);
        var winH = parseInt($(window).height() * 0.95);
        $.DialogBySHF.Dialog({
            Width: winW,
            Height: winH,
            URL: '../association/associationIndex.do?assnId=' + assnId
        });
    };
    $scope.addSpickTime = function () {
        var addSpick = {
            availableCount: 0,
            spikeTime: '',
            orderPrice: '',
            num: 1
        };
        var len = $scope.event.spickList.length;
        addSpick.num = ++len;
        $scope.event.spickList.push(addSpick);
    };
    $scope.deleteSpickTime = function (nums) {
        var len = $scope.event.spickList.length;
        var spickList = [];
        var x = 1;
        for (var i = 0; i < len; i++) {
            if (nums != i + 1) {
                var addSpick = $scope.event.spickList[i];
                addSpick.num = x++;
                spickList.push(addSpick);
            }
        }
        $scope.event.spickList = spickList;
    };
    $scope.addEventTime = function () {
        var addTime = {startHour: 0, startMinute: 0, endHour: 0, endMinute: 0, number: 1};
        addTime.number = $scope.event.times++;
        $scope.event.eventTimes.push(addTime);
    };
    $scope.deleteEventTime = function (nums) {
        var len = $scope.event.eventTimes.length, eventTimes = $scope.event.eventTimes, x;
        for (var i = 0; i < len; i++) {
            if (eventTimes[i].number == nums) {
                x = i;
            }
        }
        $scope.event.eventTimes.splice(x, 1);
    };
    $scope.deleteEventList = function (nums) {
        var len = $scope.event.eventList.length,
            eventList = $scope.event.eventList,
            x;
        for (var i = 0; i < len; i++) {
            if (eventList[i].num == nums) {
                x = i;
            }
        }
        $scope.event.eventList.splice(x, 1);
    };
    $scope.getEvents = function () {
        var sta = $scope.event.startTime, end = $scope.event.endTime;
        if (sta <= end) {
            var aDate, oDate1, oDate2, iDays, date;
            var mul = 1;
            $scope.event.eventList = [];
            date = new Date(sta);
            aDate = end.split("-");
            oDate1 = new Date(aDate[1] + '-' + aDate[2] + '-' + aDate[0]);   //转换为12-13-2008格式
            aDate = sta.split("-");
            oDate2 = new Date(aDate[1] + '-' + aDate[2] + '-' + aDate[0]);
            iDays = parseInt(Math.abs(oDate1 - oDate2) / 1000 / 60 / 60 / 24) + 1;   //把相差的毫秒数转换为天数
            for (var i = 0; i < iDays; i++) {
                date = new Date(date);
                var num = $scope.event.eventTimes.length;
                var events = $scope.event.eventTimes;
                for (var s = 0; s < num; s++) {
                    var event = {
                        eventDate: '',
                        eventEndDate: '',
                        eventTime: '',
                        availableCount: 0,
                        eventDateTime: '',
                        spikeTime: '',
                        orderPrice: 0,
                        seatIds: '',
                        startHour: 0,
                        startMinute: 0,
                        endHour: 0,
                        endMinute: 0,
                        num: 0
                    };
                    event.eventDate = date.getFullYear() + "-" + $scope.addZero(date.getMonth() + 1) + "-" + $scope.addZero(date.getDate());
                    event.startHour = events[s].startHour;
                    event.startMinute = events[s].startMinute;
                    event.endHour = events[s].endHour;
                    event.endMinute = events[s].endMinute;
                    event.num = mul++;
                    $scope.event.eventList.push(event);
                }
                date = +date + 1000 * 60 * 60 * 24;
            }
        }
    };
    $scope.$watch("activity.activityArea", function (dictCode) {
        var code = dictCode.split(',')[0];
        $scope.loadAreaData(1, "../venue/getVenueType.do?areaId=" + code);
        $.post("../sysdict/queryChildSysDictByDictCode.do", {dictCode: code}, function (data) {
            var list = eval(data);
            $scope.area.activityLocation = {};
            for (var i = 0; i < list.length; i++) {
                var obj = list[i];
                $scope.area.activityLocation[obj.dictId] = obj.dictName;
            }
            $scope.$apply()
        });
    }, true);
    $scope.setActivityLocation = function (value) {
        $scope.activity.activityLocation = value;
        $('#activityLocationLabel').find('a').removeClass('cur');
        $('#' + value).addClass('cur');
    };
    $scope.$watch("activity.activityType", function (Id) {
        $.post("../tag/getCommonTag.do?type=2", function (data) {
            var list = eval(data);
            $scope.area.tages = '';
            $scope.area.activityComTag = {};
            for (var i = 0; i < list.length; i++) {
                var obj = list[i];
                $scope.area.activityComTag [obj.tagSubId] = obj.tagName;
                $scope.area.tages += obj.tagSubId + ',';
            }
            $scope.$apply()
        });
        $.post("../tag/getTagSubByTagId.do?tagId=" + Id, function (data) {
            var list = eval(data);
            $scope.area.activityTag = {};
            for (var i = 0; i < list.length; i++) {
                var obj = list[i];
                $scope.area.activityTag [obj.tagSubId] = obj.tagName;
            }
            $scope.$apply()
        });
    }, true);
    $scope.setActType = function (value) {
        var tagIds = $scope.activity.activityType;
        var ids = tagIds.substring(0, tagIds.length).split(",");
        var len = ids.length;
        for (var i = 0; i < len; i++) {
            $('#' + ids[i]).addClass('cur');
        }
    };
    $scope.setActTag = function (value) {
        var tagIds = $scope.activity.tagIds;
        var ids = tagIds.substring(0, tagIds.length - 1).split(",");
        var len = ids.length;
        if (value == 1) {
            $scope.activity.tagIds = '';
        }
        for (var i = 0; i < len; i++) {
            $('#' + ids[i]).addClass('cur');
            if (value == 1 && $scope.area.tages.indexOf(ids[i]) > 0) {
                $scope.activity.tagIds += ids[i] + ',';
            }
        }
    };
    $scope.setActivityType = function (value) {
        var tagIds = $scope.activity.activityType;
        if (tagIds.indexOf(value) >= 0) {
            $("#" + value).removeClass("cur");
            $scope.activity.activityType = "";
        } else {
            $('#activityTypeLabel').find('a').removeClass('cur');
            $('#' + value).addClass('cur');
            $scope.activity.activityType = value;
            $scope.activity.activityTagName = $scope.area.activityType[value];
        }
        $scope.setActTag(1);
    };
    $scope.setActivityTag = function (value) {
        var tagIds = $scope.activity.tagIds;
        var ids = tagIds.substring(0, tagIds.length - 1).split(",");
        var len = ids.length;
        var data = '', r = true;
        if (tagIds.indexOf(value) >= 0) {
            $("#" + value).removeClass("cur");
        } else {
            $('#' + value).addClass('cur');
        }
        for (var i = 0; i < len; i++) {
            if (ids[i] == value) {
                r = false;
            } else {
                if (ids[i] != "") {
                    data = data + ids[i] + ',';
                }
            }
        }
        $scope.activity.activityLabName = [];
        for (var i = 0; i < len; i++) {
            if ($scope.area.activityComTag[ids[i]]) {
                $scope.activity.activityLabName.push($scope.area.activityComTag[ids[i]]);
            } else {
                $scope.activity.activityLabName.push($scope.area.activityTag[ids[i]]);

            }
        }
        if (r) {
            data += value + ',';
        }
        $scope.activity.tagIds = data;
    };
    $scope.addZero = function (value) {
        var time = "";
        if (value.toString().length < 2) {
            time = "0" + value.toString()
        } else {
            time = value.toString()
        }
        return time;
    };
    $scope.preview = function (value) {
        $scope.activity.activityMemo = CKEDITOR.instances.activityMemo.getData();
        $scope.activity.activityAddress = $("#activityAddress").val();
        if($scope.event.eventList.length>0&&$scope.event.eventList[0].availableCount!=null){
            $scope.activity.activityAbleCount=$scope.event.eventList[0].availableCount;
        }else if($scope.event.spickList.length>0&&$scope.spickList[0].availableCount!=null){
            $scope.activity.activityAbleCount=$scope.spickList[0].availableCount;
        }
        window.localStorage.setItem("activity", JSON.stringify($scope.activity));
        window.open("../activity/previewActivityDetail.do");
    };
    $scope.saveInfo = function (state) {
        $scope.code.btnpublishDisable = true;
        $scope.activity.activityState = state;
        $scope.activity.activityMemo = CKEDITOR.instances.activityMemo.getData();
        $scope.activity.activityAddress = $("#activityAddress").val();
        $scope.activity.addressId = $("#referId").val();
        $scope.activity.assnId = $("#assnId").val();
        $scope.activity.activityPerformed = $("#assnName").val();
        if ($scope.activity.venueType == "2" || $scope.activity.createActivityCode == "1") {
            if ($scope.activity.createActivityCode == "1") {
                $scope.activity.activityArea = "市级自建";
                $scope.activity.activityLocation="";
            } else {
                $scope.activity.createActivityCode = "2";
                if ($scope.activity.activityLocation == "" || $scope.activity.activityLocation == null) {
                    dialogAlert("系统提示", "请选择活动位置", function () {
                    });
                    $scope.code.btnpublishDisable = false;
                    return;
                }
            }
            $scope.activity.venueId = "";
        } else {
            if ($scope.activity.venueId == "1" || $scope.activity.venueId == null) {

                dialogAlert("系统提示", "请选择活动场馆", function () {
                });
                $scope.code.btnpublishDisable = false;
                return;
            }
            if ($scope.activity.activityLocation == "" || $scope.activity.activityLocation == null) {
                dialogAlert("系统提示", "请选择活动位置", function () {
                });
                $scope.code.btnpublishDisable = false;
                return;
            }
        }
        if(state==6){
            if ($scope.activity.activityName == "" || $scope.activity.activityName == null) {
                dialogAlert("系统提示", "请填写活动名称", function () {
                });
                $scope.code.btnpublishDisable = false;
                return;
            }
            if ($scope.activity.activityIconUrl == "" || $scope.activity.activityIconUrl == null) {
                dialogAlert("系统提示", "请上传活动封面", function () {
                });
                $scope.code.btnpublishDisable = false;
                return;
            }

            if ($scope.activity.activityType == "" || $scope.activity.activityType == null) {
                dialogAlert("系统提示", "请选择活动类型", function () {
                });
                $scope.code.btnpublishDisable = false;
                return;
            }
//            if ($scope.activity.activityHost == "" || $scope.activity.activityHost == null) {
////            	这里修改过
//                $scope.code.btnpublishDisable = true;
//                return;
//            }
            if ($scope.activity.activityTel == "" || $scope.activity.activityTel == null) {
                dialogAlert("系统提示", "请填写活动联系电话", function () {
                });
                $scope.code.btnpublishDisable = false;
                return;
            }
            if ($scope.activity.activityStartTime == "" || $scope.activity.activityStartTime == null || $scope.activity.activityEndTime == "" || $scope.activity.activityEndTime == null) {
                dialogAlert("系统提示", "请填写活动举办时间", function () {
                });
                $scope.code.btnpublishDisable = false;
                return;
            }

            if ($scope.activity.singleEvent == null) {
                if ($scope.activity.activityIsReservation != "1" && $scope.activity.activityIsReservation != "4" && $scope.activity.activityIsReservation != "5") {
                    dialogAlert("系统提示", "请进行场次设置", function () {
                    });
                    $scope.code.btnpublishDisable = false;
                    return;
                }
            }
            if ($scope.activity.activityAddress == "" || $scope.activity.activityAddress == null) {
                dialogAlert("系统提示", "请填写地址信息", function () {
                });
                $scope.code.btnpublishDisable = false;
                return;
            }
            if ($scope.activity.activityMemo == "" || $scope.activity.activityMemo == null) {
                dialogAlert("系统提示", "请填写活动描述", function () {
                });
                $scope.code.btnpublishDisable = false;
                return;
            }

        }
        var eventDate = '', eventTime = '', spikeTme = '', avaliableCount = '', orderPrice = '', seatIds = '', spikeTimes = '';
        if ($scope.activity.singleEvent == "0") {
            var num = $scope.event.eventList.length;
            for (var s = 0; s < num; s++) {
                if ($scope.event.eventList[s].eventDate == "" || $scope.event.eventList[s].eventDate == null) {
                    dialogAlert("系统提示", "请填写第" + $scope.event.eventList[s].num + "场次的日期", function () {
                    });
                    $scope.code.btnpublishDisable = false;
                    return;
                } else {
                    eventDate += $scope.event.eventList[s].eventDate + ',';
                }
                eventTime += $scope.addZero($scope.event.eventList[s].startHour) + ':' + $scope.addZero($scope.event.eventList[s].startMinute) + '-' + $scope.addZero($scope.event.eventList[s].endHour) + ':' + $scope.addZero($scope.event.eventList[s].endMinute) + ',';
                if (($scope.event.eventList[s].spikeTime == "" || $scope.event.eventList[s].spikeTime == null ) && $scope.activity.spikeType == "1") {
                    dialogAlert("系统提示", "请填写第" + $scope.event.eventList[s].num + "场次的秒杀时间", function () {
                    });
                    $scope.code.btnpublishDisable = false;
                    return;
                } else {
                    if ($scope.event.eventList[s].spikeTime) {
                        spikeTimes += $scope.event.eventList[s].spikeTime + ',';
                    }
                }
                if ($scope.event.eventList[s].availableCount == "" || $scope.event.eventList[s].availableCount == null) {
                    dialogAlert("系统提示", "请填写第" + $scope.event.eventList[s].num + "场次的票数", function () {
                    });
                    $scope.code.btnpublishDisable = false;
                    return;
                } else {
                    avaliableCount += $scope.event.eventList[s].availableCount + ',';
                }
                orderPrice += $scope.event.eventList[s].orderPrice + ',';
                if ($scope.event.eventList[s].seatIds) {
                    seatIds += $scope.event.eventList[s].seatIds + ';';
                }
            }
        } else {
            var num = $scope.event.spickList.length;

            if (num > 0) {
                for (var s = 0; s < num; s++) {
                    if ($scope.event.singleStartTime == "" || $scope.event.singleStartTime == null) {
                        dialogAlert("系统提示", "请填写开始日期", function () {
                        });
                        $scope.code.btnpublishDisable = false;
                        return;
                    } else {
                        eventDate += $scope.event.singleStartTime + ',';
                    }
                    eventTime += $scope.addZero($scope.event.startHour) + ':' + $scope.addZero($scope.event.startMinute) + '-' + $scope.addZero($scope.event.endHour) + ':' + $scope.addZero($scope.event.endMinute) + ',';

                    if ($scope.event.spickList[s].spikeTime == "" || $scope.event.spickList[s].spikeTime == null) {
                        dialogAlert("系统提示", "请填写第" + $scope.spickList[s].num + "场秒杀时间", function () {
                        });
                        $scope.code.btnpublishDisable = false;
                        return;
                    } else {
                        if ($scope.event.spickList[s].spikeTime) {
                            spikeTimes += $scope.event.spickList[s].spikeTime + ',';
                        }
                    }
                    if ($scope.event.spickList[s].availableCount == "" || $scope.event.spickList[s].availableCount == null) {
                        dialogAlert("系统提示", "请填写第" + $scope.spickList[s].num + "场秒杀的票数", function () {
                        });
                        $scope.code.btnpublishDisable = false;
                        return;
                    } else {
                        avaliableCount += $scope.event.spickList[s].availableCount + ',';
                    }
                    orderPrice += $scope.event.spickList[s].orderPrice + ',';
                }
            } else {
                if ($scope.activity.activityIsReservation != "1" && $scope.activity.activityIsReservation != "4" && $scope.activity.activityIsReservation != "5" ) {
                    if ($scope.event.singleStartTime == "" || $scope.event.singleStartTime == null) {
                        dialogAlert("系统提示", "请填写开始日期", function () {
                        });
                        $scope.code.btnpublishDisable = false;
                        return;
                    } else {
                        eventDate += $scope.event.singleStartTime + ',';
                    }
                    eventTime += $scope.addZero($scope.event.startHour) + ':' + $scope.addZero($scope.event.startMinute) + '-' + $scope.addZero($scope.event.endHour) + ':' + $scope.addZero($scope.event.endMinute) + ',';
                    if ($scope.event.totalSeat == "" || $scope.event.totalSeat == null) {
                        if ($scope.activity.activityId == "") {
                            dialogAlert("系统提示", "请填写票数", function () {
                            });
                            $scope.code.btnpublishDisable = false;
                            return;
                        }
                    } else {
                        avaliableCount = $scope.event.totalSeat;
                    }
                }
            }
            seatIds = $scope.event.seatIds;
        }
        if ($scope.activity.activityIsReservation != "1" && $scope.activity.activityIsReservation != "4" && $scope.activity.activityIsReservation != "5") {
            if ($scope.activity.singleEvent == null) {
                dialogAlert("系统提示", "请进行场次设置", function () {
                });
                $scope.code.btnpublishDisable = false;
                return;
            }
            if (eventDate == "" || eventDate == null) {
                if ($scope.event.order == "1") {
                    dialogAlert("系统提示", "请填写票务时间", function () {
                    });
                    $scope.code.btnpublishDisable = false;
                    return;
                }
            }
        }
        
        if ($scope.activity.activityIsFree == "3") {
        	
        	  if ($scope.activity.activityPayPrice == "" || $scope.activity.activityPayPrice == null) {
                  dialogAlert("系统提示", "请填写支付金额", function () {
                  });
                  $scope.code.btnpublishDisable = false;
                  return;
              }
        	  
        	  var regex = /^-?\d+\.?\d{0,2}$/;
        	  
        	  if(!regex.test($scope.activity.activityPayPrice)){
        		   dialogAlert("系统提示", "请填写正确金额,小数最多保留两位", function () {
                   });
                   $scope.code.btnpublishDisable = false;
                   return; 
              }
        }

        $scope.activity.activityTime = $scope.addZero($scope.area.startHour) + ':' + $scope.addZero($scope.area.startMinute) + '-' + $scope.addZero($scope.area.endHour) + ':' + $scope.addZero($scope.area.endMinute);
        $scope.activity.eventDate = eventDate;
        $scope.activity.eventTime = eventTime;
        $scope.activity.spikeTme = spikeTme;
        $scope.activity.avaliableCount = avaliableCount;
        $scope.activity.orderPrice = orderPrice;
        $scope.activity.seatIds = seatIds;
        $scope.activity.spikeTimes = spikeTimes;
        
        //自定义信息增加
        var customInfoFlag = true;
        var customInfoArr = new Array();
        $('.customInfoTr').each(function(){
        	var title = $(this).find("#title").val();
        	var desc = $(this).find("#desc").val();
        	var type = $(this).find("#type").val();
        	if ((title == "" && desc != "") || (title != "" && desc == "")){
        		customInfoFlag = false;
        		return false;
        	} else if (title != "" && desc != ""){
        		var customInfo = {
        			title:title,
        			type:type,
        			desc:desc
        		};
        		customInfoArr.push(customInfo);
        	}
        });
        if (!customInfoFlag){
        	dialogAlert("系统提示", "请填写完整自定义信息！", function () {
            });
        	$scope.code.btnpublishDisable = false;
        	return;
        } else {
        	if (customInfoArr.length > 0){
	        	var activityCustomInfo = JSON.stringify(customInfoArr);
	        	$scope.activity.activityCustomInfo = activityCustomInfo;
        	}
        }
        debugger;
        $http({
            method: "POST",
            url: "../activity/addActivity.do",
            data: $.param($scope.activity),
            contentType: "application/json",
            headers: {"Content-Type": "application/x-www-form-urlencoded"}
        }).then(function (data) {
        	var backPath = $("#backPath").val();
        	var data =data.data ;
            switch (data) {
                case("success"):
                    dialogAlert("系统提示", "保存成功", function () {
                    	if(backPath){
                    		window.location.href = backPath + "activity/activityIndex.do?activityState=6";
                    	}else{
                    		window.location.href = "../activity/activityIndex.do?activityState=6"
                    	}
                    });
                    break;
                case("noActive"):
                    dialogAlert("系统提示", "请登陆后再进行操作", function () {
                    	if(backPath){
                    		window.location.href = backPath + "admin.do";
                    	}else{
                    		window.location.href = "../admin.do"
                    	}
                    });
                    break;
                default:
                    dialogAlert("系统提示", "保存发生错误，请查看数据是否完整", function () {
                    });
                    break
            }
        }).catch(function (data) {
            dialogAlert("系统提示", "保存发生错误，请查看数据是否完整", function () {
            });
        });
    };

});


seajs.use(['/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
    window.dialog = dialog;
});

window.console = window.console || {
        log: function () {
        }
    };
var dialogWidth = ($(window).width() * 0.8);
//富文本编辑器
window.onload = function () {
   
};


//自定义信息增加
function addCustomInfoList(){
	var customInfoNum = $('.customInfoTr').length;
	if (customInfoNum >= 10){
		dialogAlert("系统提示", "自定义信息最多可以添加10个！", function () {
        });
		return;
	}
	var customInfoTr = $('tr.customInfoTr').eq(0).clone(true);
	$(customInfoTr).find('#title').val("");
	$(customInfoTr).find('#desc').val("");
	$(customInfoTr).find('#addIcon').hide();
	$(customInfoTr).find('#delIcon').css("display","inline-block");
	$(customInfoTr).insertAfter('tr.customInfoTr:last');
}
function deleteCustomInfoList(obj){
	$(obj).parent().parent().remove();
}

var app = angular.module("addInfo", []);
           app.controller(
				"infoCon",
				function($scope, $http) {					
					$scope.infoFrom = {
						"jiazhouInfoId" : "",
						"jiazhouInfoTitle" : "",
						"jiazhouInfoSort" : "",
						"jiazhouInfoTag" : [],
						"jiazhouInfoTags" : "",
						"authorName" : "",
						"publisherName" : "",
						"shareTitle" : "",
						"shareSummary" : "",
						"shareCount" : 0,
						"browseCount" : 0,
						"jiazhouInfoIconUrl" : "",
						"shareIconUrl" : "",
						"activityType": "",
						"jiazhouInfoContent" : ""
					};			       					
					$scope.leftTitle = function() {
						return 24 - $scope.infoFrom.jiazhouInfoTitle.length
					};
					$scope.leftAuthorName = function() {
						return 32 - $scope.infoFrom.authorName.length
					};
					$scope.leftPublisherName = function() {
						return 32 - $scope.infoFrom.publisherName.length
					};
					$scope.leftShareTitle = function() {
						return 64 - $scope.infoFrom.shareTitle.length
					};
					$scope.leftShareSummary = function() {
						return 256 - $scope.infoFrom.shareSummary.length
					};
					$scope.setActivityType = function (value) {				   
				            $('#activityTypeLabel').find('a').removeClass('cur');
				            $('#' + value).addClass('cur');
				            $scope.infoFrom.jiazhouInfoSort = value;
				    };
					$scope.saveInfo = function() {
						if (!$scope.infoFrom.jiazhouInfoTitle) {
							dialogAlert("提示", "请填写标题");
							return
						}
						$scope.infoFrom.jiazhouInfoIconUrl = $("#jiazhouInfoIconUrl").attr("value"); 						
						if ($scope.infoFrom.jiazhouInfoIconUrl == "" || $scope.infoFrom.jiazhouInfoIconUrl == null) {
							dialogAlert("提示", "请上传封面图片");
							return
						}
						if (!$scope.infoFrom.authorName) {
							dialogAlert("提示", "请填写作者");
							return
						}
						if (!$scope.infoFrom.publisherName) {
							dialogAlert("提示", "请填写来源");
							return
						}
						if (!$scope.infoFrom.jiazhouInfoSort) {
							dialogAlert("提示", "请填写分类");
							return
						}
						if (!$scope.infoFrom.jiazhouInfoContent) {
							dialogAlert("提示", "请填写活动描述");
							return
						}
						if (!$scope.infoFrom.shareTitle) {
							dialogAlert("提示", "请填写分享标题");
							return
						}
						if (!$scope.infoFrom.shareSummary) {
							dialogAlert("提示", "请填写分享简介");
							return
						}					
						$scope.infoFrom.shareIconUrl = $("#shareIconUrl").attr("value");
						if ($scope.infoFrom.shareIconUrl == "" || $scope.infoFrom.shareIconUrl == null) {
							dialogAlert("提示", "请上传分享图片");
							return
						}						
						
					    $http({ method : "POST",
								   url : "../jiazhouInfo/addJiazhouInfo.do",
								  data : $.param($scope.infoFrom),
							   headers : {
										"Content-Type" : "application/x-www-form-urlencoded"
									}
								}).success(
										function(data) {
											switch (data) {
											case ("success"):
												dialogAlert(
														"系统提示",
														"保存成功",
														function() {
															window.location.href = "../jiazhouInfo/jiazhouInfoList.do"
														});
												break;
											case ("noLogin"):
												dialogAlert(
														"系统提示",
														"请登陆后再进行操作",
														function() {
															window.location.href = "../admin.do"
														});
												break;
											case ("failure"):
												dialogAlert(
														"系统提示",
														"服务器异常",
														function() {
															window.location.href = "../jiazhouInfo/jiazhouInfoList.do"
														});
												break;
											default:
												dialogAlert(
														"系统提示",
														"保存发生错误，请查看数据是否完整",
														function() {
															window.location.href = "../jiazhouInfo/jiazhouInfoList.do"
														});
												break
											}
										})
					};				  				    
					$scope.$watch("infoFrom.jiazhouInfoId",function(value) {
						$.post("../jiazhouInfo/getJiazhouInfoSortList.do?dictCode=JIAZHOUINFO_TYPE", function (data) {
							  var list = eval(data.data);
					            $scope.infoFrom.activityType = {};
					            for (var i = 0; i < list.length; i++) {
					                var obj = list[i];
					                $scope.infoFrom.activityType [obj.dictId] = obj.dictName;
					            }
					            $scope.$apply();
				             });
							if (value) {
									 $http({method : "POST",
											   url : "../jiazhouInfo/getJiazhouInfo.do",
											data : $.param({jiazhouInfoId : value}),
														headers : {
															"Content-Type" : "application/x-www-form-urlencoded"
														}
													}).success(
															function(data) {
																$scope.infoFrom.jiazhouInfoId = data.jiazhouInfoId;
																$scope.infoFrom.jiazhouInfoTitle = data.jiazhouInfoTitle;	
																$scope.setActivityType(data.jiazhouInfoSort);
																$scope.infoFrom.jiazhouInfoTags = data.jiazhouInfoTags;
																$scope.infoFrom.authorName = data.authorName;
																$scope.infoFrom.publisherName = data.publisherName;
																$scope.infoFrom.shareTitle = data.shareTitle;
																$scope.infoFrom.shareSummary = data.shareSummary;
																$scope.infoFrom.shareCount = data.shareCount;
																
																$("#webupload1 #ossfile2").append('<div name="aliFile" style="position:relative;margin-bottom:5px;max-width:130px;" id="div_'+ data.jiazhouInfoId +'">'+
												                		'<img style="max-height: 700px;max-width: 700px;margin: auto;" src="' + data.jiazhouInfoIconUrl+'"><br/>'+																		
																		'<img class="aliRemoveBtn" onclick="aliRemoveImg(this)" src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201733161236Bn6gTqiCZBHhgObFvsCkLFNzmIBoh2.png" style="position:absolute;right:0;top:0;width:20px" />'+
																		'<input type="hidden" id="jiazhouInfoIconUrl" value="' + data.jiazhouInfoIconUrl+'"/></div>');
																
																$scope.infoFrom.jiazhouInfoContent = data.jiazhouInfoContent;
																																
																$("#webupload2 #ossfile2").append('<div name="aliFile" style="position:relative;margin-bottom:5px;max-width:130px;" id="div_'+ data.jiazhouInfoId +'">'+
												                		'<img style="max-height: 300px;max-width: 300px;margin: auto;" src="' + data.shareIconUrl+'"><br/>'+																		
																		'<img class="aliRemoveBtn" onclick="aliRemoveImg(this)" src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201733161236Bn6gTqiCZBHhgObFvsCkLFNzmIBoh2.png" style="position:absolute;right:0;top:0;width:20px" />'+
																		'<input type="hidden" id="shareIconUrl" value="' + data.shareIconUrl+'"/></div>');
																if (data.browseCount) {
																	$scope.infoFrom.browseCount = data.browseCount
																}
															})
										}
									}, true);										
					
					$scope.$watch("infoFrom.jiazhouInfoTag",
									function(value) {	
										if (value) {					
											var str = "";
											  for (var i = 0; i < value.length; i++) {
									                var obj = value[i];
									                if (obj) {
									                	str += obj +",";
									                } 
									            }
				    $scope.infoFrom.jiazhouInfoTags=str.substring(0,str.length-1)
										}
									}, true);
					
					$scope.$watch("infoFrom.jiazhouInfoTags",
									function(value) {
										if (value) {
											$scope.infoFrom.jiazhouInfoTag = $scope.infoFrom.jiazhouInfoTags
													.split(",")
										}
									}, true)
				});   
                                   
app.directive("ckeditor", function() {
	return {
		require : "?ngModel",
		link : function(scope, element, attrs, ngModel) {
			var ckeditor = CKEDITOR.replace(element[0], {});
			if (!ngModel) {
				return
			}
			ckeditor.on("instanceReady", function() {
				ckeditor.setData(ngModel.$viewValue)
			});
			ckeditor.on("pasteState", function() {
				scope.$apply(function() {
					ngModel.$setViewValue(ckeditor.getData())
				})
			});
			ngModel.$render = function(value) {
				ckeditor.setData(ngModel.$viewValue)
			}
		}
	}
});

//上传图片回调函数
function uploadImgCallback1(up, file, info) {
	$('#'+file.id).append("<input type='hidden' id='jiazhouInfoIconUrl' value='http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info+"'/>");
}

function uploadImgCallback2(up, file, info) {
	$('#'+file.id).append("<input type='hidden' id='shareIconUrl' value='http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info+"'/>");
}


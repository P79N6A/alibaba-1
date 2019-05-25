var app = angular.module("addInfo", []);
app
		.controller(
				"infoCon",
				function($scope, $http) {
					$scope.infoFrom = {
						"informationId" : "",
						"informationTitle" : "",
						"informationTag" : [],
						"informationTags" : "",
						"authorName" : "",
						"publisherName" : "",
						"shareTitle" : "",
						"shareSummary" : "",
						"shareCount" : 0,
						"browseCount" : 0,
						"informationIconUrl" : "",
						"shareIconUrl" : "",
						"informationIconUrlShow" : "",
						"shareIconUrlShow" : "",
						// "informationFooter" : "1",
						"informationContent" : ""
					};
					$scope.leftTitle = function() {
						return 24 - $scope.infoFrom.informationTitle.length
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
					$scope.showImg = function(imgaeInitUrl) {
						var url = getImgUrl(imgaeInitUrl);
						var html = '<img src="' + url + '" target="_blank"/>';
						dialogInitImgConfirm("原图", html, function() {
						})
					};
					$scope.saveInfo = function() {
						if (!$scope.infoFrom.informationTitle) {
							dialogAlert("提示", "请填写标题");
							return
						}
						if (!$scope.infoFrom.authorName) {
							dialogAlert("提示", "请填写作者");
							return
						}
						if (!$scope.infoFrom.publisherName) {
							dialogAlert("提示", "请填写发布者");
							return
						}
						if (!$scope.infoFrom.informationTags) {
							dialogAlert("提示", "请填写标签");
							return
						}
						if (!$scope.infoFrom.informationContent) {
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
						if (!$scope.infoFrom.informationIconUrl
								|| !$scope.infoFrom.shareIconUrl) {
							dialogAlert("提示", "请上传图片");
							return
						}
						$http(
								{
									method : "POST",
									url : "../information/addInformation.do",
									data : $.param($scope.infoFrom),
									headers : {
										"Content-Type" : "application/x-www-form-urlencoded"
									}
								})
								.success(
										function(data) {
											switch (data) {
											case ("success"):
												dialogAlert(
														"系统提示",
														"保存成功",
														function() {
															window.location.href = "../information/informationIndex.do"
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
															window.location.href = "../information/informationIndex.do"
														});
												break;
											default:
												dialogAlert(
														"系统提示",
														"保存发生错误，请查看数据是否完整",
														function() {
															window.location.href = "../information/informationIndex.do"
														});
												break
											}
										})
					};
					$scope
							.$watch(
									"infoFrom.informationId",
									function(value) {
										if (value) {
											$http(
													{
														method : "POST",
														url : "../information/getInformation.do",
														data : $
																.param({
																	informationId : value
																}),
														headers : {
															"Content-Type" : "application/x-www-form-urlencoded"
														}
													})
													.success(
															function(data) {
																$scope.infoFrom.informationId = data.informationId;
																$scope.infoFrom.informationTitle = data.informationTitle;
																$scope.infoFrom.informationTags = data.informationTags;
																$scope.infoFrom.authorName = data.authorName;
																$scope.infoFrom.publisherName = data.publisherName;
																$scope.infoFrom.shareTitle = data.shareTitle;
																$scope.infoFrom.shareSummary = data.shareSummary;
																$scope.infoFrom.shareCount = data.shareCount;
																$scope.infoFrom.informationIconUrl = data.informationIconUrl;
																$scope.infoFrom.informationContent = data.informationContent;
																$scope.infoFrom.shareIconUrl = data.shareIconUrl;
																$scope.infoFrom.informationIconUrlShow = getIndexImgUrl(
																		getImgUrl(data.informationIconUrl),
																		"_900_500");
																$scope.infoFrom.shareIconUrlShow = getIndexImgUrl(
																		getImgUrl(data.shareIconUrl),
																		"_500_500");
																if (data.browseCount) {
																	$scope.infoFrom.browseCount = data.browseCount
																}
																/*if (data.informationFooter == 0) {
																	$scope.infoFrom.informationFooter = "0"
																}*/
															})
										}
									}, true);
					$scope
							.$watch(
									"infoFrom.informationTag",
									function(value) {
										if (value) {
											$scope.infoFrom.informationTags = $scope.infoFrom.informationTag
													.join(",")
										}
									}, true);
					$scope
							.$watch(
									"infoFrom.informationTags",
									function(value) {
										if (value) {
											$scope.infoFrom.informationTag = $scope.infoFrom.informationTags
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
app.directive("snailUploadify", function() {
	return {
		require : "?ngModel",
		restrict : "A",
		link : function($scope, element, attrs, ngModel) {
			element.uploadify({
				"formData" : {
					"uploadType" : "Img",
					"type" : 2,
                    userCounty :$("#userCounty").val().split(",")[0]
				},
				swf : "../STATIC/js/uploadify.swf",
				uploader : "../upload/uploadFile.do",
				buttonText : "上传封面",
				"fileSizeLimit" : "2MB",
				"buttonClass" : "upload-btn",
				queueSizeLimit : 1,
				"method" : "post",
				queueID : "fileContainer",
				fileObjName : "file",
				fileTypeExts : "*.gif;*.png;*.jpg;*.jpeg;",
				"auto" : true,
				"multi" : false,
				height : 44,
				width : 100,
				"debug" : false,
				"dataType" : "json",
				removeCompleted : false,
				"onUploadSuccess" : function(file, data, response) {
					var json = $.parseJSON(data);
					$scope.$apply(function() {
						ngModel.$setViewValue(json.data)
					});
					if (element.context.id == "informationIconUrl") {
						var cutImageWidth = 900
					} else {
						var cutImageWidth = 500
					}
					var cutImageHeigth = 500;
					var initWidth = parseInt(json.initWidth);
					var initHeigth = parseInt(json.initHeigth);
					if (initWidth < cutImageWidth
							|| initHeigth < cutImageHeigth) {
						dialogAlert("提示", "请上传尺寸不小于" + cutImageWidth + "*"
								+ cutImageHeigth + "(px)的图片", function() {
						});
						return
					}
					var url = getImgUrl(json.data);
					dialog({
						url : "../att/toCutImgJsp.do",
						data : {
							imageUrl : url,
							initWidth : initWidth,
							initHeigth : initHeigth,
							cutImageWidth : cutImageWidth,
							cutImageHeigth : cutImageHeigth
						},
						title : "图片裁剪",
						fixed : false,
						onclose : function() {
							var imgUrl = this.returnValue.imageUrl;
							var isCutImg = this.returnValue.isCutImg;
							if (element.context.id == "informationIconUrl") {
								$scope.infoFrom.informationIconUrlShow = imgUrl
                                $("#informationIconUrlPrev").find("img").attr("src",imgUrl);
							} else {
								$scope.infoFrom.shareIconUrlShow = imgUrl
                                $("#shareIconUrlPrev").find("img").attr("src",imgUrl);
							}
						}
					}).showModal();
					return false
				}
			})
		}
	}
});
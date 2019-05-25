app.directive("snailUploadify", function () {
    return {
        require: "?ngModel", restrict: "A", link: function ($scope, element, attrs, ngModel) {
            element.uploadify({
                "formData": {"uploadType": "Img", "type": 2, userCounty: $("#userCounty").val().split(",")[0]},
                swf: "../STATIC/js/uploadify.swf",
                uploader: "../upload/uploadFile.do",
                buttonText: "上传封面",
                "fileSizeLimit": "3MB",
                "buttonClass": "upload-btn",
                queueSizeLimit: 1,
                "method": "post",
                queueID: "fileContainer",
                fileObjName: "file",
                fileTypeExts: "*.gif;*.png;*.jpg;*.jpeg;",
                "auto": true,
                "multi": false,
                height: 44,
                width: 100,
                "debug": false,
                "dataType": "json",
                removeCompleted: false,
                "onUploadSuccess": function (file, data, response) {
                    var json = $.parseJSON(data);
                    $scope.$apply(function () {
                        ngModel.$setViewValue(json.data)
                    });
                    var imgSize = element.context.id.split("_");
                    var cutImageWidth = parseInt(imgSize[1]);
                    var cutImageHeigth = parseInt(imgSize[2]);
                    var initWidth = parseInt(json.initWidth);
                    var initHeigth = parseInt(json.initHeigth);
                    if (initWidth < cutImageWidth || initHeigth < cutImageHeigth) {
                        dialogAlert("提示", "请上传尺寸不小于" + cutImageWidth + "*" + cutImageHeigth + "(px)的图片", function () {
                        });
                        return
                    }
                    var url = getImgUrl(json.data);

                    dialog({
                        url: "../att/toCutImgJsp.do",
                        data: {
                            imageUrl: url,
                            initWidth: initWidth,
                            initHeigth: initHeigth,
                            cutImageWidth: cutImageWidth,
                            cutImageHeigth: cutImageHeigth
                        },
                        title: "图片裁剪",
                        fixed: false,
                        onclose: function () {
                            var imgUrl = this.returnValue.imageUrl;
                            var isCutImg = this.returnValue.isCutImg;
                            
                            var image=getImgHtml(imgUrl,imgSize[3],imgSize[4]);
                            setTimeout(function(){
                            	$("#"+imgSize[0]).html(image);
    						},1000);
                            
                            function getImgHtml(imgUrl,width,height){
                                if(imgUrl==""){
                                    return '<img src="../STATIC/image/defaultImg.png" />';
                                }
                                return '<img style="width:'+width+'px; height:'+height+'px;"  src="'+imgUrl+'" />';
                            }
                        }
                    }).showModal();
                    return false
                }
            })
        }
    }
});